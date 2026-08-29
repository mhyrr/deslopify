#!/usr/bin/env python3
"""Re-rank the lift list by salience = lift x rarity-in-general-English.

    uv run --with wordfreq --python 3.12 tools/rescore.py

Reads  references/lift-words.txt  (source order: descending measured lift)
Writes references/lift-words.tsv  (salience order, with both component terms so
                                   any row's score can be audited from the file)

WHY. Raw lift asks "does an LLM say this more than a human does?" It ranks
`never` at #127 and `four` at #428 -- words no editor can act on, because
deleting them is not a repair. Salience asks the operational question instead:
"how much does one occurrence of this word deserve my attention?" A word earns
attention only when it is BOTH overrepresented and unusual in English at all.

The combination is a product, not a sum, and that is the whole design. A sum
lets either term rescue a word, which promotes engineering jargon that is rare
in general English but ordinary in the source corpus: greps, diffed, retargets,
grepped all landed in the top 32 under a sum despite lift ranks of 244-392. A
product requires both, so weakness on either axis is fatal. Measured effect:
greps #308 -> #173 under the product vs #26 under the sum.

ASSUMPTIONS, all three arguable and all three one constant away from changing:

1. LIFT IS MODELLED FROM RANK. The source publishes rank order; the only lift
   values reported are 39.47 for `load-bearing` at rank 1 and roughly 5.0 at
   rank 1000. Those two anchors fit lift(r) = 39.47 * r**-0.299. Because the
   curve is monotone in rank it cannot reorder anything -- the anchors set how
   steeply attention decays with rank, not which word beats which.

2. HYPHEN PENALTY (1.5 zipf, ~30x rarer). wordfreq splits `byte-identical` into
   byte + identical and returns a compositional estimate of 3.11, scoring a
   minted compound as MORE common than the dictionary word `chokepoint` (1.46).
   It answers "how plausible is this compound" when we need "how often does this
   exact string occur", which for a coined compound is ~never. Minting the
   compound is itself the tell, so every hyphenated form takes the penalty.
   Relative order among compounds is preserved.

3. UNKNOWN-WORD FLOOR (0.8 zipf). Six entries are absent from wordfreq entirely
   (unparseable, adversarially, diffed, greps, retargets, grepped). Zero is a
   sentinel for "not in corpus", not a measurement, so treating it as infinite
   rarity would be reading precision into an absence.
"""
import math, pathlib
from wordfreq import zipf_frequency

HYPHEN_PENALTY = 1.5   # zipf units subtracted from any hyphenated compound
UNKNOWN_FLOOR  = 0.8   # zipf assigned to words wordfreq does not know
LIFT_AT_RANK_1 = 39.47 # reported: load-bearing
LIFT_EXPONENT  = 0.299 # fitted so lift(1000) ~= 5.0, the reported tail

ROOT  = pathlib.Path(__file__).resolve().parent.parent
SRC   = ROOT / "references" / "lift-words.txt"
OUT   = ROOT / "references" / "lift-words.tsv"


def effective_zipf(word: str) -> float:
    """General-English commonness, corrected for what wordfreq cannot see."""
    z = zipf_frequency(word, "en")
    if z == 0.0:
        z = UNKNOWN_FLOOR
    if "-" in word.strip("-"):
        z = max(UNKNOWN_FLOOR, z - HYPHEN_PENALTY)
    return z


def main() -> None:
    words = [w.strip() for w in SRC.read_text().splitlines() if w.strip()]
    rows = []
    for rank, word in enumerate(words, 1):
        log_lift = math.log10(LIFT_AT_RANK_1 * rank ** -LIFT_EXPONENT)
        rows.append({"word": word, "lift_rank": rank,
                     "zipf": zipf_frequency(word, "en"),
                     "zeff": effective_zipf(word), "log_lift": log_lift})

    # Normalise both axes to [0,1] across this list, then take their geometric
    # mean. Geometric mean, not arithmetic: a word must earn both terms.
    lo, hi = min(r["log_lift"] for r in rows), max(r["log_lift"] for r in rows)
    r_lo = min(8 - r["zeff"] for r in rows)
    r_hi = max(8 - r["zeff"] for r in rows)
    for r in rows:
        r["tf"]  = (r["log_lift"] - lo) / (hi - lo)
        r["idf"] = ((8 - r["zeff"]) - r_lo) / (r_hi - r_lo)
        r["salience"] = round(100 * math.sqrt(r["tf"] * r["idf"]), 1)

    rows.sort(key=lambda r: (-r["salience"], r["lift_rank"]))
    lines = [
        "# salience_rank\tword\tlift_rank\tzipf\tsalience\tlift\ttf\tidf\tz_eff",
        f"# salience = 100 * sqrt(tf * idf); tf = norm(log10 modelled lift),"
        f" idf = norm(8 - z_eff)",
        f"# z_eff = zipf, minus {HYPHEN_PENALTY} if hyphenated, floored at"
        f" {UNKNOWN_FLOOR} when wordfreq does not know the word",
        "# scan.sh reads columns 1, 2 and 5; the rest show the working",
        "# regenerate: uv run --with wordfreq --python 3.12 tools/rescore.py",
    ]
    for i, r in enumerate(rows, 1):
        lift = LIFT_AT_RANK_1 * r["lift_rank"] ** -LIFT_EXPONENT
        lines.append(
            f"{i}\t{r['word']}\t{r['lift_rank']}\t{r['zipf']:.2f}\t{r['salience']}"
            f"\t{lift:.1f}\t{r['tf']:.3f}\t{r['idf']:.3f}\t{r['zeff']:.2f}")
    OUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUT} ({len(rows)} words)")

    moved = sorted(rows, key=lambda r: r["lift_rank"] - rows.index(r))
    print("\nbiggest demotions (common English, now suppressed):")
    for r in moved[:8]:
        print(f"   {r['word']:16s} lift#{r['lift_rank']:<4d} -> #{rows.index(r)+1:<4d} zipf {r['zipf']:.2f}")


if __name__ == "__main__":
    main()
