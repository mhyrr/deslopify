#!/usr/bin/env bash
# Regression check for the deslopify detectors.
#
#   bash tests/check.sh
#
# Guards the numbers quoted in SKILL.md, references/tics.md and lexical.md 13.
# Those claims -- "every detector fires", "nothing above salience 50 on clean prose" --
# rot silently as patterns are tuned, so they are asserted here instead.
#
# Fixtures:
#   all-tics.md     seeded with every pattern in tics.tsv; the detector floor.
#   agent-prose.md  agent-written engineering prose; the salience ceiling.
#   clean-prose.md  specific, information-carrying prose that must stay quiet.
#                   Note it is MODEL-written: it is a false-positive guard, not
#                   the human baseline. The human baseline is real READMEs,
#                   which measured 1.6-10.9 salient words per 1,000, none above 50.
#   line-numbers.md front matter, a fence and a table ahead of one tic on line 15.
#   audit/          source.md plus a bad edit (introduces a tic, invents a number,
#                   drops one) and a good edit, for audit.sh.

set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
F="$DIR/tests/fixtures"
pass=0; fail=0
ok()  { printf '  PASS  %s\n' "$1"; pass=$((pass+1)); }
no()  { printf '  FAIL  %s\n' "$1"; fail=$((fail+1)); }

echo "deslopify detector check"

# 1. every regex in tics.tsv compiles under this grep
bad=0; n=0
while IFS=$'\t' read -r name re; do
  [ -z "${name:-}" ] && continue
  n=$((n+1))
  err=$(echo "probe" | grep -i -E -- "$re" 2>&1 >/dev/null)
  [ -n "$err" ] && { no "regex compiles: $name -- $err"; bad=1; }
done < "$DIR/references/tics.tsv"
[ $bad -eq 0 ] && ok "all $n regexes compile"

# 2. the seeded fixture trips every pattern, with no detector errors.
#    Count only detector lines: "   <id>  (<n>)" for regexes, plus the two
#    structural detectors. Header lines (sentences, salient words) do not count.
nre=$(grep -vc '^$' "$DIR/references/tics.tsv")
hits=$(bash "$DIR/scan.sh" "$F/all-tics.md" | grep -c '^   [a-z-]*  *([0-9]')
[ "$hits" -eq "$nre" ] && ok "all $nre regex patterns fire on all-tics.md" \
                       || no "expected $nre regex patterns on all-tics.md, got $hits"
sre=$(bash "$DIR/scan.sh" "$F/all-tics.md" | grep -c '^   \(repeated-sentence-openers\|stacked-rhetorical-questions\)')
[ "$sre" -eq 2 ] && ok "both structural detectors fire on all-tics.md" \
                 || no "expected 2 structural detectors on all-tics.md, got $sre"
errs=$(bash "$DIR/scan.sh" "$F/all-tics.md" | grep -c '!!')
[ "$errs" -eq 0 ] && ok "no detector failures" || no "$errs detector(s) failed"

# 3. agent prose lights up the salience ceiling
strong=$(bash "$DIR/scan.sh" "$F/agent-prose.md" | sed -n 's/.*; \([0-9]*\) at salience 50+.*/\1/p')
[ "${strong:-0}" -ge 8 ] && ok "agent-prose.md: $strong words at salience 50+ (>=8)" \
                         || no "agent-prose.md: only ${strong:-0} words at salience 50+"

# 4. clean prose stays quiet -- the false-positive guard
ctics=$(bash "$DIR/scan.sh" "$F/clean-prose.md" | grep -c '^   [a-z-]*  *([0-9]')
cstrong=$(bash "$DIR/scan.sh" "$F/clean-prose.md" | sed -n 's/.*; \([0-9]*\) at salience 50+.*/\1/p')
[ "$ctics" -eq 0 ] && ok "clean-prose.md trips no tic" || no "clean-prose.md tripped $ctics tic(s)"
[ "${cstrong:-0}" -eq 0 ] && ok "clean-prose.md has nothing above salience 50" \
                          || no "clean-prose.md had ${cstrong} word(s) above salience 50"

# 5. reported line numbers are file line numbers, after front matter, code, tables
ln=$(bash "$DIR/scan.sh" "$F/line-numbers.md" | sed -n 's/^       \([0-9]*\):.*index mattered.*/\1/p')
[ "${ln:-0}" -eq 15 ] && ok "line numbers survive stripped regions (L15)" \
                      || no "line numbers drift: thats-why-x-mattered reported at L${ln:-?}, file line is 15"
fenced=$(bash "$DIR/scan.sh" "$F/line-numbers.md" | grep -c 'sit-with-that')
[ "$fenced" -eq 0 ] && ok "fenced code is not scanned" || no "sit-with-that fired inside a code fence"

# 6. vocabulary: tic intersection is marked, and the 30-49 band trigger separates the fixtures
mark=$(bash "$DIR/scan.sh" "$F/all-tics.md" | grep -c 'mattered .*⨯ thats-why-x-mattered')
[ "$mark" -ge 1 ] && ok "salient word on a tic line is marked with the tic id" \
                  || no "expected 'mattered' marked ⨯ thats-why-x-mattered on all-tics.md"
midrate() { bash "$DIR/scan.sh" "$1" | sed -n 's/.*at 30-49 (\([0-9.]*\)\/1k.*/\1/p'; }
cm=$(midrate "$F/clean-prose.md"); am=$(midrate "$F/agent-prose.md")
awk -v c="${cm:-0}" -v a="${am:-0}" 'BEGIN{exit !(c < 15 && a >= 15)}' \
  && ok "30-49 band trigger (15/1k) separates clean (${cm:-0}) from agent prose (${am:-0})" \
  || no "30-49 band trigger does not separate fixtures: clean=${cm:-0} agent=${am:-0}"

# 7. the scored list is intact and ordered
rows=$(grep -vc '^#' "$DIR/references/lift-words.tsv")
[ "$rows" -eq 999 ] && ok "lift-words.tsv has 999 rows" || no "lift-words.tsv has $rows rows, expected 999"
if awk -F'\t' '!/^#/{if(p!="" && $5>p+0.05) exit 1; p=$5}' "$DIR/references/lift-words.tsv"; then
  ok "lift-words.tsv is sorted by descending salience"
else
  no "lift-words.tsv is not sorted by salience"
fi

# 8. audit.sh: an edit that introduces a tic, invents a number, or drops one is caught
A="$F/audit"
bad=$(bash "$DIR/audit.sh" "$A/source.md" "$A/bad-edit.md" 2>&1); brc=$?
[ "$brc" -eq 1 ] && ok "audit: bad edit exits 1" || no "audit: bad edit exited $brc, expected 1"
printf '%s\n' "$bad" | grep -q 'tic   earns-its-place' && ok "audit: introduced tic is reported" \
                                                       || no "audit: introduced earns-its-place not reported"
printf '%s\n' "$bad" | grep -q 'number  2x' && ok "audit: invented number is reported" \
                                              || no "audit: new number 2x not reported"
printf '%s\n' "$bad" | grep -E -q 'numbers +missing: 3( |$)' && ok "audit: dropped number is reported" \
                                                              || no "audit: missing number 3 not reported"
good=$(bash "$DIR/audit.sh" "$A/source.md" "$A/good-edit.md" 2>&1); grc=$?
[ "$grc" -eq 0 ] && ok "audit: good edit exits 0" || no "audit: good edit exited $grc, expected 0"
printf '%s\n' "$good" | grep -E -q 'numbers +missing: none' && ok "audit: good edit keeps every number" \
                                                              || no "audit: good edit lost a number"

# 9. rescore.py reproduces the file it ships (needs uv + wordfreq)
if command -v uv >/dev/null 2>&1; then
  cp "$DIR/references/lift-words.tsv" "/tmp/lw-check-$$.tsv"
  if timeout 300 uv run --quiet --with wordfreq --python 3.12 "$DIR/tools/rescore.py" >/dev/null 2>&1; then
    diff -q "/tmp/lw-check-$$.tsv" "$DIR/references/lift-words.tsv" >/dev/null \
      && ok "rescore.py reproduces lift-words.tsv" \
      || { no "rescore.py output drifted from the committed lift-words.tsv"; \
           cp "/tmp/lw-check-$$.tsv" "$DIR/references/lift-words.tsv"; }
  else
    printf '  SKIP  rescore.py (uv could not build the env)\n'
  fi
  rm -f "/tmp/lw-check-$$.tsv"
else
  printf '  SKIP  rescore.py (uv not installed)\n'
fi

echo
echo "$pass passed, $fail failed"
[ $fail -eq 0 ]
