#!/usr/bin/env bash
# deslopify audit — scans the EDIT, not the document.
#
#   bash audit.sh FILE             compare the HEAD version with the working tree
#   bash audit.sh SOURCE OUTPUT    compare any two files
#
# Reports what the edit did: tics and salient words present in the output but
# not the source (the editor's own slop), numbers new in the output (nothing
# should be), and source facts missing from the output (flag each in the
# report or confirm the cut). Exit 1 when there is a hard finding, else 0.
# Every line is a candidate; the ruling is still yours.

set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TICS="$DIR/references/tics.tsv"
WORDS="$DIR/references/lift-words.tsv"
STRIP="$DIR/tools/strip.awk"

case $# in
  1) f=$1; d=$(dirname "$f"); b=$(basename "$f")
     src=$(mktemp)
     if ! (cd "$d" && git show "HEAD:./$b") > "$src" 2>/dev/null; then
       echo "audit: no HEAD version of $f (untracked, or not in a git repo). Pass SOURCE OUTPUT." >&2
       rm -f "$src"; exit 2
     fi
     out=$f; label="HEAD → working tree"; cleanup=$src ;;
  2) src=$1; out=$2; label="$1 →"; cleanup="" ;;
  *) echo "usage: bash audit.sh FILE | bash audit.sh SOURCE OUTPUT" >&2; exit 2 ;;
esac
for x in "$src" "$out"; do [ -f "$x" ] || { echo "audit: not a file: $x" >&2; exit 2; }; done

# -- hit collection: kind<TAB>id<TAB>match<TAB>line ------------------------------------
hits() {  # $1 = prose text
  local prose=$1
  while IFS=$'\t' read -r name re; do
    [ -z "${name:-}" ] && continue
    printf '%s\n' "$prose" | grep -n -o -i -E -- "$re" 2>/dev/null \
      | awk -v id="$name" '{ i = index($0, ":"); ln = substr($0, 1, i-1); m = tolower(substr($0, i+1))
                             gsub(/[ \t]+/, " ", m); printf "tic\t%s\t%s\t%s\n", id, m, ln }'
  done < "$TICS"
  printf '%s\n' "$prose" | awk -v W="$WORDS" '
    BEGIN { FS = "\t"; while ((getline l < W) > 0) { if (l ~ /^#/ || l == "") continue
              split(l, f, "\t"); sal[tolower(f[2])] = f[5] } }
    { line = tolower($0); gsub(/[^a-z0-9'"'"'-]+/, " ", line); n = split(line, a, " ")
      for (i = 1; i <= n; i++) if ((a[i] in sal) && sal[a[i]] + 0 >= 30)
        printf "word\t%s\t%s\t%d\n", a[i], sal[a[i]], FNR }'
}

# -- fact inventory on the light strip: kind<TAB>item ----------------------------------
facts() {  # $1 = light text
  local t=$1
  printf '%s\n' "$t" | sed -E 's/^[ \t]*[0-9]+\.[ \t]+//' \
    | grep -o -E '[0-9]+([.,][0-9]+)*(%|×|x|k|kb|mb|ms)?' | tr 'A-Z' 'a-z' | sed 's/^/num\t/'   # list markers are not numbers
  printf '%s\n' "$t" | grep -o -E '`[^`]+`' | sed 's/^/code\t/'
  printf '%s\n' "$t" | grep -o -E 'https?://[^ )>]+' | sed 's/^/url\t/'
  printf '%s\n' "$t" | awk '
    { line = $0; gsub(/\*\*|__|[|]/, " ", line); gsub(/[*_]/, "", line)
      sub(/^[ \t]*([#>-]+|[0-9]+\.)[ \t]*/, "", line)
      n = split(line, s, /[.!?]["”)]*[ \t]+|[.!?]["”)]*$/)
      for (i = 1; i <= n; i++) { m = split(s[i], w, /[ \t]+/)
        for (j = 2; j <= m; j++) { t = w[j]; gsub(/^[("“'"'"'‘\[]+|[)"”'"'"'’,;:.\]]+$/, "", t)
          if (t ~ /^[A-Z][A-Za-z0-9'"'"'’-]+$/ && t != "I") print "name\t" t } } }'
}

# -- shape metrics on the prose strip: words em semi colon mean sd -------------------
shape() {  # $1 = prose text
  printf '%s\n' "$1" | awk '
    /^[ \t]*#/ { next }
    { body = body " " $0; nw += NF
      em += gsub(/—/, "—"); semi += gsub(/;/, ";"); col += gsub(/:/, ":") }
    END {
      t = body; gsub(/[^A-Za-z0-9.!?;:,'"'"' -]/, " ", t)
      n = split(t, s, /[.!?]+[ ]+|[.!?]+$/)
      for (i = 1; i <= n; i++) { c = split(s[i], w, /[ \t]+/); len = 0
        for (j = 1; j <= c; j++) if (w[j] != "") len++
        if (len < 4) continue; k++; L[k] = len; sum += len }
      m = k ? sum / k : 0; for (i = 1; i <= k; i++) v += (L[i]-m)^2; sd = k ? sqrt(v/k) : 0
      r = nw ? 1000 / nw : 0
      printf "%d %.1f %.1f %.1f %.1f %.1f\n", nw, em*r, semi*r, col*r, m, sd }'
}

S=$(awk -f "$STRIP" "$src");  O=$(awk -f "$STRIP" "$out")
SL=$(awk -v light=1 -f "$STRIP" "$src"); OL=$(awk -v light=1 -f "$STRIP" "$out")
sh=$(mktemp); oh=$(mktemp); sf=$(mktemp); of=$(mktemp)
hits "$S" > "$sh"; hits "$O" > "$oh"; facts "$SL" > "$sf"; facts "$OL" > "$of"
read -r s_w s_em s_semi s_col s_mean s_sd <<< "$(shape "$S")"
read -r o_w o_em o_semi o_col o_mean o_sd <<< "$(shape "$O")"

pct=$(awk -v a="$s_w" -v b="$o_w" 'BEGIN{ printf "%+.0f%%", a ? (b-a)*100/a : 0 }')
echo "== $label $out        $s_w → $o_w words ($pct)"
hard=0

# introduced / removed: multiset diff on kind+id+match, ignoring position
echo
echo "introduced  (in the output, not the source: the editor's own slop)"
intro=$(mktemp)
awk -F'\t' 'NR == FNR { k = $1 "\t" $2 "\t" $3; sc[k]++; next }
     { k = $1 "\t" $2 "\t" $3; oc[k]++; if (!(k in ln)) ln[k] = $4 }
     END { for (k in oc) { d = oc[k] - (k in sc ? sc[k] : 0); if (d <= 0) continue
             split(k, p, "\t")
             if (p[1] == "tic")  printf "  tic   %-24s x%-2d \"%s\"  L%s\n", p[2], d, p[3], ln[k]
             else if (p[3] + 0 >= 50) printf "  word  %-24s x%-2d sal %s  L%s\n", p[2], d, p[3], ln[k]
             else printf "  ~word %-24s x%-2d sal %s  L%s   (30-49: density only)\n", p[2], d, p[3], ln[k] } }' \
     "$sh" "$oh" | sort > "$intro"
awk -F'\t' 'NR == FNR { if ($1 == "num") sc[$2]++; next } $1 == "num" { oc[$2]++ }
     END { for (k in oc) { d = oc[k] - (k in sc ? sc[k] : 0); if (d > 0) printf "  number  %-20s x%d   not in the source: cite it or cut it\n", k, d } }' "$sf" "$of" | sort >> "$intro"
if [ -s "$intro" ]; then cat "$intro"; hard=$(grep -c -v '^  ~word' "$intro"); else echo "  (none)"; fi
rm -f "$intro"

echo
echo "removed  (in the source, not the output)"
awk -F'\t' 'NR == FNR { k = $1 "\t" $2 "\t" $3; sc[k]++; next } { k = $1 "\t" $2 "\t" $3; oc[k]++ }
     END { for (k in sc) { d = sc[k] - (k in oc ? oc[k] : 0); if (d <= 0) continue; split(k, p, "\t")
             if (p[1] == "tic") printf "  tic   %-24s x%-2d \"%s\"\n", p[2], d, p[3]
             else if (p[3] + 0 >= 50) printf "  word  %-24s x%-2d sal %s\n", p[2], d, p[3] } }' "$sh" "$oh" | sort > "$sf.rm"
[ -s "$sf.rm" ] && cat "$sf.rm" || echo "  (none)"

echo
echo "conservation  (source items absent from the output: flag each in the report, or confirm the cut)"
awk -F'\t' 'NR == FNR { sc[$1 "\t" $2]++; next } { oc[$1 "\t" $2]++ }
     END { for (k in sc) { d = sc[k] - (k in oc ? oc[k] : 0); if (d <= 0) continue; split(k, p, "\t"); miss[p[1]] = miss[p[1]] " " p[2] (d > 1 ? "(x" d ")" : "") }
           split("num code url name", order, " "); lab["num"] = "numbers"; lab["code"] = "code spans"; lab["url"] = "urls"; lab["name"] = "names (soft: capitalization heuristic)"
           for (i = 1; i <= 4; i++) { o = order[i]; printf "  %-40s missing:%s\n", lab[o], (o in miss ? miss[o] : " none") } }' "$sf" "$of"

echo
printf "shape                    %8s  %8s\n" "source" "output"
printf "  em dash /1k            %8s  %8s\n" "$s_em" "$o_em"
printf "  semicolon /1k          %8s  %8s%s\n" "$s_semi" "$o_semi" "$(awk -v a="$s_semi" -v b="$o_semi" 'BEGIN{ if (b > a * 1.5 && b - a > 1) print "   <- rose: the second-order tell" }')"
printf "  colon /1k              %8s  %8s%s\n" "$s_col" "$o_col" "$(awk -v a="$s_col" -v b="$o_col" 'BEGIN{ if (b > a * 1.5 && b - a > 1) print "   <- rose: check colon-into-triple" }')"
printf "  sentence mean / sd     %8s  %8s%s\n" "$s_mean/$s_sd" "$o_mean/$o_sd" "$(awk -v a="$s_sd" -v b="$o_sd" 'BEGIN{ if (a > 0 && b < a * 0.75) print "   <- narrowed: staccato guard" }')"

rm -f "$sh" "$oh" "$sf" "$of" "$sf.rm" ${cleanup:+"$cleanup"}
echo
if [ "$hard" -gt 0 ]; then echo "exit 1: $hard hard finding(s)"; exit 1; else echo "exit 0: no hard findings"; exit 0; fi
