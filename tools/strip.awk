# deslopify: blank out the regions the scanners must not read. Line count is
# preserved, so every reported line number is a file line number.
#   awk -f tools/strip.awk FILE            prose only: no code, tables, URLs, link targets
#   awk -v light=1 -f tools/strip.awk FILE keeps table rows and inline code, for the
#                                          conservation inventory (numbers, code spans, URLs)
NR == 1 && /^---[ \t]*$/ { fm = 1; print ""; next }
fm { if (/^---[ \t]*$/) fm = 0; print ""; next }
/^[ \t]*```/ { fence = !fence; print ""; next }
fence { print ""; next }
/^    [^ ]/ { print ""; next }                 # indented code
!light && /^[ \t]*\|/ { print ""; next }       # markdown table rows
{ if (!light) {
    gsub(/`[^`]*`/, " ")                       # inline code
    gsub(/https?:\/\/[^ )>]*/, " ")
    gsub(/\]\([^)]*\)/, "] ")                  # markdown link targets
  }
  print }
