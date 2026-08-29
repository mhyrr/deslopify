#!/usr/bin/env bash
# deslopify scanner — locates candidates. It does not judge them.
# Usage: bash scan.sh FILE [FILE...]
#
# Every line of output is a CANDIDATE, not a finding. Read each hit in context
# and apply the earned-use test before touching it. A clean scan does not mean
# the prose is fine; a noisy scan does not mean it is slop.

set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TICS="$DIR/references/tics.tsv"
WORDS="$DIR/references/lift-words.tsv"

[ $# -eq 0 ] && { echo "usage: bash scan.sh FILE [FILE...]" >&2; exit 2; }

for f in "$@"; do
  [ -f "$f" ] || { echo "skip (not a file): $f" >&2; continue; }

  # Strip fenced code blocks, indented code, and inline code spans.
  prose=$(awk '
    /^[ \t]*```/ { fence = !fence; next }
    fence { next }
    /^    [^ ]/ { next }          # indented code
    /^[ \t]*\|/ { next }          # markdown table rows
    { gsub(/`[^`]*`/, " ")        # inline code
      gsub(/https?:\/\/[^ )>]*/, " ")
      gsub(/\]\([^)]*\)/, "] ")   # markdown link targets
      print }
  ' "$f")

  wc_words=$(printf '%s' "$prose" | wc -w | tr -d ' ')
  [ "$wc_words" -eq 0 ] && { echo "== $f — no prose after stripping code"; continue; }

  band=$(awk -v n="$wc_words" 'BEGIN{
    if (n<150) print "Micro"; else if (n<800) print "Short";
    else if (n<2500) print "Medium"; else if (n<8000) print "Long"; else print "Extended"}')

  emd=$(printf '%s' "$prose" | grep -o '—' | wc -l | tr -d ' ')
  emrate=$(awk -v e="$emd" -v n="$wc_words" 'BEGIN{printf "%.1f", (n?e*1000/n:0)}')

  echo "== $f"
  echo "   $wc_words words · $band band · em dash $emrate/1k (human baseline 3.2)"

  # -- sentence-length distribution (the "distribution width" check) --
  printf '%s' "$prose" | awk '
    { gsub(/[^A-Za-z0-9.!?;:,'"'"' -]/, " "); buf = buf " " $0 }
    END {
      n = split(buf, s, /[.!?]+[ ]+|[.!?]+$/)
      for (i = 1; i <= n; i++) {
        c = split(s[i], w, /[ \t]+/); len = 0
        for (j = 1; j <= c; j++) if (w[j] != "") len++
        if (len < 4) continue
        k++; L[k] = len; sum += len
        if (!mn || len < mn) mn = len; if (len > mx) mx = len
      }
      if (k < 3) exit
      m = sum / k
      for (i = 1; i <= k; i++) v += (L[i]-m)^2
      sd = sqrt(v/k)
      printf "   sentences %d · mean %.1f · sd %.1f · range %d-%d", k, m, sd, mn, mx
      if (sd < 6) printf "   <- narrow: no very short or very long sentences"
      printf "\n"
    }'

  # -- structural tics that no regex catches --
  printf '%s' "$prose" | awk -v OFS='' '
    # split the whole file into sentences, keep source line numbers
    { text[NR] = $0 }
    END {
      for (r = 1; r <= NR; r++) {
        buf = text[r]
        n = split(buf, s, /[.!?]+["'"'"')]*[ ]*/)
        for (i = 1; i <= n; i++) {
          t = s[i]; gsub(/^[ \t*#>_-]+/, "", t)
          if (split(t, ww, /[ \t]+/) < 4) continue
          k++; S[k] = t; LN[k] = r
        }
      }
      # repeated sentence openers: 3+ in a row on the same word
      for (i = 1; i <= k; i++) {
        split(tolower(S[i]), w, /[^a-z0-9'"'"'-]+/)
        o = w[1]
        if (o ~ /^(the|a|an|it|he|she|they|we|i|you|this|that|these|those)$/) o = ""
        if (o != "" && o == prev) { run++ } else { if (run >= 3) printf "   repeated-sentence-openers  L%d  \"%s\" x%d\n", LNs, prevraw, run; run = 1; LNs = LN[i]; prevraw = o }
        prev = o
      }
      if (run >= 3) printf "   repeated-sentence-openers  L%d  \"%s\" x%d\n", LNs, prevraw, run
    }'

  # stacked rhetorical questions: 2+ question marks inside one paragraph
  printf '%s' "$prose" | awk -v RS='' '
    { c = gsub(/\?/, "?"); if (c >= 2) printf "   stacked-rhetorical-questions  %d questions in one paragraph\n", c }'

  # -- regex tics --
  hits=0
  while IFS=$'\t' read -r name re; do
    [ -z "${name:-}" ] && continue
    err=$(printf '%s\n' "$prose" | grep -n -i -E -- "$re" 2>&1 >/dev/null)
    [ -n "$err" ] && { printf '   !! %-25s detector failed: %s\n' "$name" "$(printf '%s' "$err" | head -1)"; continue; }
    out=$(printf '%s\n' "$prose" | grep -n -i -E -- "$re" | head -6)
    [ -z "$out" ] && continue
    cnt=$(printf '%s\n' "$prose" | grep -c -i -E -- "$re")
    hits=$((hits + cnt))
    printf '   %-28s (%s)\n' "$name" "$cnt"
    printf '%s\n' "$out" | sed 's/^/       /' | cut -c1-110
  done < "$TICS"

  # -- salience-ranked vocabulary (lift x rarity; see lexical.md 13) --
  printf '%s' "$prose" | awk -v W="$WORDS" -v N="$wc_words" '
    BEGIN { FS = "\t"
      while ((getline line < W) > 0) {
        if (line ~ /^#/ || line == "") continue
        split(line, f, "\t")
        rank[tolower(f[2])] = f[1]; sal[tolower(f[2])] = f[5]
      } }
    { line = tolower($0); gsub(/[^a-z0-9'"'"'-]+/, " ", line)
      n = split(line, a, " ")
      for (i = 1; i <= n; i++) if (a[i] in rank) { c[a[i]]++; if (!(a[i] in ln)) ln[a[i]] = FNR } }
    END {
      for (w in c) { tot += c[w]; if (sal[w] + 0 >= 50) strong += c[w] }
      if (!tot) { print "   salient words: none"; exit }
      printf "   salient words: %d hit%s (%.1f/1k); %d at salience 50+\n", tot, (tot==1?"":"s"), tot*1000/N, strong+0
      cmd = "sort -t# -k2 -n | head -25"
      for (w in c) printf "       #%-4d %-22s x%-3d sal %-5s L%d\n", rank[w], w, c[w], sal[w], ln[w] | cmd
      close(cmd)
    }'
  echo
done
