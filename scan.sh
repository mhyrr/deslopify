#!/usr/bin/env bash
# deslopify scanner — locates candidates. It does not judge them.
# Usage: bash scan.sh FILE [FILE...]
#
# Every line of output is a CANDIDATE, not a finding. Read each hit in context
# and apply the earned-use test before touching it. A clean scan does not mean
# the prose is fine; a noisy scan does not mean it is slop.
#
# Line numbers are file line numbers: stripped regions (front matter, code,
# tables) are replaced with blank lines, not removed.

set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TICS="$DIR/references/tics.tsv"
WORDS="$DIR/references/lift-words.tsv"
MID_TRIGGER=15   # 30–49 band: hits per 1,000 words above which the verb-first pass runs

[ $# -eq 0 ] && { echo "usage: bash scan.sh FILE [FILE...]" >&2; exit 2; }

for f in "$@"; do
  [ -f "$f" ] || { echo "skip (not a file): $f" >&2; continue; }

  # Blank out YAML front matter, fenced and indented code, and table rows;
  # strip inline code spans, URLs and link targets. Line count is preserved.
  prose=$(awk '
    NR == 1 && /^---[ \t]*$/ { fm = 1; print ""; next }
    fm { if (/^---[ \t]*$/) fm = 0; print ""; next }
    /^[ \t]*```/ { fence = !fence; print ""; next }
    fence { print ""; next }
    /^    [^ ]/ { print ""; next }     # indented code
    /^[ \t]*\|/ { print ""; next }     # markdown table rows
    { gsub(/`[^`]*`/, " ")            # inline code
      gsub(/https?:\/\/[^ )>]*/, " ")
      gsub(/\]\([^)]*\)/, "] ")       # markdown link targets
      print }
  ' "$f")

  wc_words=$(printf '%s' "$prose" | wc -w | tr -d ' ')
  [ "$wc_words" -eq 0 ] && { echo "== $f — no prose after stripping code"; continue; }

  band=$(awk -v n="$wc_words" 'BEGIN{
    if (n<150) print "Micro"; else if (n<800) print "Short";
    else if (n<2500) print "Medium"; else if (n<8000) print "Long"; else print "Extended"}')

  echo "== $f"
  echo "   $wc_words words · $band band"

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

  # -- regex tics; remember which lines they hit for the vocabulary pass --
  ticlines=$(mktemp); : > "$ticlines"
  while IFS=$'\t' read -r name re; do
    [ -z "${name:-}" ] && continue
    err=$(printf '%s\n' "$prose" | grep -n -i -E -- "$re" 2>&1 >/dev/null)
    [ -n "$err" ] && { printf '   !! %-25s detector failed: %s\n' "$name" "$(printf '%s' "$err" | head -1)"; continue; }
    out=$(printf '%s\n' "$prose" | grep -n -i -E -- "$re")
    [ -z "$out" ] && continue
    cnt=$(printf '%s\n' "$out" | wc -l | tr -d ' ')
    printf '   %-28s (%s)\n' "$name" "$cnt"
    printf '%s\n' "$out" | head -6 | sed 's/^/       /' | cut -c1-110
    printf '%s\n' "$out" | cut -d: -f1 | sed "s/$/	$name/" >> "$ticlines"
  done < "$TICS"

  # -- salience-ranked vocabulary (lift x rarity; see lexical.md 13) --
  # Summary line, then every instance worth ruling (salience 50+, or 30–49 on a
  # line a tic detector also hit), with a context snippet and two marks:
  #   ⨯ tic-id   the word sits inside a detected construction; repair that
  #   "quoted"   the word is inside double quotes: a mention, not a use
  # Then the 30–49 band by word. Words under 30 are counted, never listed.
  printf '%s' "$prose" | awk -v W="$WORDS" -v T="$ticlines" -v N="$wc_words" -v TRIG="$MID_TRIGGER" '
    BEGIN { FS = "\t"
      while ((getline line < W) > 0) {
        if (line ~ /^#/ || line == "") continue
        split(line, f, "\t")
        rank[tolower(f[2])] = f[1]; sal[tolower(f[2])] = f[5]
      }
      while ((getline line < T) > 0) {
        split(line, f, "\t"); tic[f[1]] = (f[1] in tic) ? tic[f[1]] " " f[2] : f[2]
      } }
    function snippet(s, pos,   a, b, out) {
      a = pos - 38; if (a < 1) a = 1
      b = pos + 42; if (b > length(s)) b = length(s)
      out = substr(s, a, b - a + 1); gsub(/[ \t]+/, " ", out); gsub(/\*\*/, "", out)
      return (a > 1 ? "…" : "") out (b < length(s) ? "…" : "")
    }
    /^[ \t]*$/ { qp = 0 }              # paragraph break resets quote parity
    { raw = $0; line = tolower(raw); gsub(/[^a-z0-9'"'"'-]+/, " ", line)
      n = split(line, a, " ")
      for (i = 1; i <= n; i++) {
        w = a[i]; if (!(w in rank)) continue
        c[w]++
        lines[w] = (w in lines) ? lines[w] " L" FNR : "L" FNR
        if (sal[w] + 0 >= 30) {
          # locate the instance in the raw line for context and quote check
          pos = match(tolower(raw), "(^|[^a-z0-9'"'"'-])" w "([^a-z0-9'"'"'-]|$)")
          if (pos) { if (substr(raw, pos, 1) !~ /[a-z0-9]/) pos++ } else pos = 1
          before = substr(raw, 1, pos); q = gsub(/["“”]/, "", before)
          quoted = ((qp + q) % 2 == 1)
          if (sal[w] + 0 >= 50 || (FNR in tic)) {
            k++; I_w[k] = w; I_ln[k] = FNR; I_sal[k] = sal[w] + 0
            I_mark[k] = ((FNR in tic) ? "⨯ " tic[FNR] : "") (quoted ? ((FNR in tic) ? "  " : "") "\"quoted\"" : "")
            I_ctx[k] = snippet(raw, pos)
          }
        } }
      allq = raw; qp = (qp + gsub(/["“”]/, "", allq)) % 2
    }
    END {
      for (w in c) { tot += c[w]
        if (sal[w] + 0 >= 50) strong += c[w]
        else if (sal[w] + 0 >= 30) mid += c[w]
        else low += c[w] }
      if (!tot) { print "   salient words: none"; exit }
      midrate = mid * 1000 / N
      printf "   salient words: %d hit%s (%.1f/1k); %d at salience 50+; %d at 30-49 (%.1f/1k, trigger %d/1k); %d under 30\n", \
        tot, (tot==1?"":"s"), tot*1000/N, strong+0, mid+0, midrate, TRIG, low+0
      if (k) {
        print "     instances to rule (50+, or 30-49 on a tic line):"
        for (i = 1; i <= k; i++)
          printf "       L%-5d %-20s sal %-5.1f %s\n             %s\n", I_ln[i], I_w[i], I_sal[i], I_mark[i], I_ctx[i]
      }
      if (mid) {
        printf "     30-49 by word%s\n", (midrate >= TRIG ? sprintf("   <- above trigger (%.1f >= %d/1k): run the verb-first pass", midrate, TRIG) : "   (below trigger: act only on marked instances)")
        cmd = "sort -t# -k2 -n | head -25"
        for (w in c) if (sal[w] + 0 >= 30 && sal[w] + 0 < 50)
          printf "       #%-4d %-20s x%-3d sal %-5s %s\n", rank[w], w, c[w], sal[w], lines[w] | cmd
        close(cmd)
      }
    }'
  rm -f "$ticlines"

  # -- em-dash rate, measured over body prose (headings excluded) --
  body=$(printf '%s\n' "$prose" | grep -v '^[ \t]*#')
  body_words=$(printf '%s' "$body" | wc -w | tr -d ' ')
  emd=$(printf '%s' "$body" | grep -o '—' | wc -l | tr -d ' ')
  emh=$(printf '%s\n' "$prose" | grep '^[ \t]*#' | grep -o '—' | wc -l | tr -d ' ')
  emrate=$(awk -v e="$emd" -v n="$body_words" 'BEGIN{printf "%.1f", (n?e*1000/n:0)}')
  note=""; [ "$emh" -gt 0 ] && note="; $emh more in headings, not counted"
  echo "   em dash $emd = $emrate/1k over $body_words body words (human baseline 3.2$note)"
  echo
done
