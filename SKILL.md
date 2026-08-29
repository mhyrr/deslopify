---
name: deslopify
description: "Use when prose sounds machine-written and needs the accent removed — the user says 'deslopify', 'this sounds like AI', 'sounds like Claude wrote it', 'remove the AI voice', 'make this sound human', 'de-slop this', 'AI slop', or points at copy that reads generic and templated. Targets landing pages, marketing copy, README intros, docs, announcements, and any prose written for a human reader. For writing copy from scratch see copywriting; for sharpening persuasion and conversion see copy-editing — this skill only removes the machine accent and can run before or after either."
metadata:
  version: 1.2.0
---

# Deslopify

Remove the machine accent from prose without flattening it.

Copy can be clear, correct, and persuasive and still announce that a model wrote
it. That signal is the target.

**Not this skill's job:** persuasion quality (`copy-editing`), drafting
(`copywriting`), grammar, or fact-checking.

**Target.** Edit what the user named. If they named nothing, take the prose in
the files changed in the working tree (`git status`): prose only, skipping code,
tests, and lockfiles. With no changed files and no target, ask what to edit
rather than guessing.

**Explicit non-goal: evading AI detectors.** Detectors key on the same surface
features this skill removes, so scores may fall as a side effect. Never optimize
for that. Optimizing for a detector produces prose that is strange rather than
good. The "humanizer" product category is the cautionary example: it works by
inserting errors.

---

## Stop before you start

**The single largest failure mode is editing copy that did not need it.** An
invocation is not a mandate to produce a diff. A model handed good prose and a
rulebook will sand it down to prove it worked.

Before the first edit, decide whether there is slop. If the prose is specific,
voiced, and carries real information, **return it unchanged and say so.** "This
reads as human-written; three candidates below, none worth changing" is a
complete and successful run.

**Two full sweeps maximum**, where a sweep is one run through passes 0–4 below.
If the second sweep turns up only marginal calls, the piece is done.

### Protected content — never edit

- Direct quotes and attributed text
- **Numbers, dates, prices, metrics, benchmarks: flag-only.** Never edited,
  never replaced, never rounded, never "made more credible." This holds even for
  precision theater ("save 4.7 hours a week"): the repair is a source and a
  denominator, which you do not have. Flag it and leave the digits alone.
- Proper nouns, product names, feature names
- Code, identifiers, commands, URLs, file paths
- Legal, compliance, and safety language
- Terms of art, even ugly ones, where the field uses them

### The scope limit

Deslopify changes **how** something is said. Never **what** it claims.

If a repair would alter a factual claim, a promise, a capability, or a number,
stop and flag it. "No credit card required" is information sitting inside a
slop-shaped sentence. Leave it.

**Relocation is in scope.** Moving a claim the document already makes — promoting
the one real sentence out of a deleted closing paragraph, folding a buried
mechanism into the subhead — is permitted and often required, because head-and-tail
deletion frequently lands on the only paragraph carrying a fact. Say so in the
report. Inventing, strengthening, or hedging a claim is not permitted.

---

## The governing test

**Ask what the thing is carrying.**

Every candidate, whether a word, a sentence shape, or a whole section, does one
of two jobs. It carries something the reader needs, or it carries rhythm,
emphasis, and the feeling of significance. Cut the second kind. Keep the first.

When the answer is "it sounds good there," that *is* the answer.

**The most common way prose fails this test is by announcing significance instead of
carrying it.** "That's the whole point." "Speed is the entire business model." "That's
not nothing." "It's worth naming." "That's why it mattered." Nine separate constructions,
one move: the sentence reports that something matters and contains nothing else. The
repair is almost always to delete the announcing clause and keep the thing announced,
which is usually fine and occasionally very good. It was wearing a sign.
`references/tics.md` §2.1 has all nine with their earned-use tests.

This is why a blacklist alone makes prose worse. Swap "delve" for "explore";
the sentence reads the same. **The word was rarely the problem.** A large share
of the best repairs are deletions, not substitutions. Reach for the cut and the
recast before the synonym.

**Every *substitution* needs a destination.** When you replace a word or phrase,
prohibition alone leaves a gap the model fills with the next-nearest cliché.
Replace with a number, a named subject, a concrete verb, a dated claim, or an
opinion someone owns. This does not apply to structural deletion. A cut
paragraph needs no destination; that is the point of cutting it.

---

## Pass 0 — Classify the document

Do this once for the document, and again at any section that changes venue.
Nearly every "is this earned?" ruling reduces to a lookup against two axes, so
fixing them up front makes the rest mechanical.

**Length band:** Micro (<150 words) · Short (150–800) · Medium (800–2,500) ·
Long (2,500–8,000) · Extended (8,000+)

**Venue:** linear prose · non-linear reference · scan-first web · instructional ·
decision doc

**Mixed venues.** A document can change venue at a section boundary: a marketing
intro over a reference body, a README whose top is a pitch and whose bottom is
instructions. When it does, classify the **dominant** venue for document-scope
checks (density, cardinality, distribution width) and the **local** venue for
line-level rulings. Note the split in the report. Do not force one classification
onto a file that has two; the rulings diverge sharply between rows and
you will apply the wrong half to one section.

**Declare the register too.** On a landing page, persuasion is the *correct*
register. The target is hollow persuasion, not persuasion. Most published deslop
prompts carry a Wikipedia-neutral bias that, applied to marketing copy, deletes
the page.

**What the classification decides.** Keep it in view; these rulings have no
context-free answer and you will hit most of them:

| Ruling | Decided by |
|---|---|
| Is signposting a tax or a requirement? | length + venue (tax under ~800 words; required in a reference the reader enters mid-document) |
| Are bullets and bold earned? | venue (yes on scan-first web, lazy in linear prose) |
| Does the summary go top or bottom, or at all? | venue (decision doc → top; Short → neither) |
| Are question headings a tic? | venue only, never length (right on an FAQ that mirrors real search queries, wrong in a spec) |
| Is uniform paragraph length a finding? | venue (suppress for reference and instructional — uniformity is correct there) |
| Does the restatement ratio apply? | length (Short/Medium; below ~0.6 means padded) |
| What em-dash count is expected? | length (rate × word count; under ~300 words, often zero) |

Use the thresholds in that table directly. Open `references/discourse.md` only
when a document sits within ~20% of a stated boundary (700–900 words for the
signposting line, ratio 0.5–0.7 for restatement), or when the venue is not in the
table.

---

## Three diagnostics, before any pattern matching

These find slop that has no signature phrase.

**The swap test.** Substitute a competitor's name, or any other product. If the
sentence stays true, it carries no information. "Built for modern teams" survives
every substitution.

**The negation test.** State the opposite. If no sane person would claim it, the
original said nothing. Nobody ships "built for teams stuck in the past."

**The mechanism test.** Ask *how*. If the prose never says what the thing does —
only what it delivers, unlocks, or empowers — it is benefit without mechanism.

---

## Four passes, descending altitude

Structural fixes delete whole sentences, so fixing words inside a paragraph you
are about to cut is wasted work.

> **Loading policy.** The worked set below is the default and is usually enough.
> The catalogs total ~270KB. Reading them to edit a short page costs more than
> the edit is worth. When a candidate is not in the worked set, **grep the
> reference for its headers** and read the matching entry. Do not read a
> reference end to end. The arrows below say where a pattern lives, not that you
> should open the file.
>
> **`bash scan.sh FILE`** runs the mechanical half of passes 2–3 in one command:
> length band, sentence-length spread, the named tic patterns, salience-ranked
> vocabulary, and the em-dash rate over body prose, all with file line numbers.
> Each vocabulary instance worth ruling comes with its context, a `⨯ tic-id` mark
> when it sits on a line a tic detector also hit, and a `"quoted"` mark when it is
> a mention rather than a use. Run it **after Pass 1**, because head-and-tail
> deletion removes a large share of the hits for free. Its output is a map of
> where to look, never a list of edits to make.

### Pass 1 — Structure · `references/discourse.md`

Start with **head-and-tail deletion**: remove the first paragraph and the last,
then read. In a large share of AI drafts nothing breaks. It catches the
throat-clearing open and the bookend conclusion together.

Then: restatement ratio (below ~0.6 in Short/Medium prose the piece is padded),
paragraph-length variance, formatting used as a substitute for thinking.

### Pass 2 — Sentence shape · `references/syntactic.md`, `references/tics.md`

**The highest-value pass.** Prose containing zero blacklisted words is still
unmistakable when every sentence has the same three shapes.

`tics.md` carries 40 named constructions with regex detectors in `tics.tsv`. Its §2
(29 essay tics) is what to reach for when a document is specific, voiced, carrying real
information, and *still* reads as machine-made. That is the case `lexical.md` cannot
solve.

### Pass 3 — Word and phrase · `references/lexical.md`

Lowest value, most visible, easiest to overdo. **Go verb-first.** Measured excess
vocabulary is 66% verbs and only 14% adjectives, and everyone's instinct is to
hunt adjectives.

`references/lift-words.tsv` ranks 1,000 words by **salience**: measured
overrepresentation across 461k documents, multiplied by how rare the word is in
general English. Raw overrepresentation alone puts `nothing` at #25 and `never`
at #127, words no editor can act on, because deleting them is not a repair.
Salience drops them to #401 and #820 while `load-bearing`, `byte-identical`, and
`re-derived` hold the top three. **Band on the score, not the presence.** 50+ is
distinctive: rule each instance. 30–49 is a density band, and density has a
number: above 15 hits per 1,000 words in this band, run the verb-first pass over
it; below that, act only on marked instances. Under 30 corroborates and never
triggers.

**Rule an instance from its sentence, not from the list.** Three questions, in
order:

1. Mention or use? A word inside quotes or an example is the document talking
   about slop, not committing it. Skip it.
2. Does it sit inside a tic hit? Then the word is the construction's symptom:
   repair the construction and the word goes with it. That intersection makes a
   30–49 word actionable on its own.
3. Is it the document's term of art, defined once and repeated on purpose? Then
   it is vocabulary, not accent. Leave it, and do not cycle synonyms.

Read `lexical.md` §13 before using the list, and note the corpus is GitHub pull
requests, sharp on agent-written engineering prose and weak on marketing copy.

### Pass 4 — Audit your own output

Before the first edit, copy the file aside (`cp FILE /tmp/deslop-before.md`),
because `HEAD` is not the starting point when the file already had uncommitted
changes. After editing, run `bash audit.sh /tmp/deslop-before.md FILE`, or
`bash audit.sh FILE` when the file was clean. It reports the edit, not the
document: tics and salient words present in the output but not the source,
numbers new in the output, and source facts missing from the output. An
introduced tic is a hard finding: the editor made slop. It exits 1 on any hard
finding.

Then do the rhythm read the audit cannot: "Over-correction" below. Non-optional.

**Landing pages and marketing copy:** also grep `references/marketing.md` for the
formula headers your candidates match, under the same loading policy. It is the
largest catalog and the one most tempting to read whole. Genre formulas are
section-shaped and cannot be fixed line by line.

---

## The worked set

Five to eight patterns handled properly beats forty checked. These are ranked by
frequency times cost. The reference catalogs hold ~200 more; consult them for
anything this set does not cover, and do not try to apply all of them.

For essay, blog, and announcement venues, add the announced-significance family from
the governing-test section above. In that register it outranks most of what follows.

**1. Head-and-tail scaffolding.** The opening paragraph that restates the question
and the closing one that restates the piece. *Earned:* Long/Extended documents,
and decision docs where the summary belongs at the **top**.

**2. Negative parallelism.** "It's not X, it's Y." "X isn't just A — it's B."
Roughly 3× the human rate. *Earned:* when the reader genuinely holds the wrong
belief X and needs it corrected. Not as a rhythm device.

**3. Animacy inflation.** An inanimate subject given a verb that requires a mind.
Four tiers. Inanimate-subject actives are native to technical prose and
outnumber passives there, so the tier decides the ruling.

- *Protected:* mechanism metonymy. "The parser rejects malformed input." Test:
  could it be true or false in a bug report? Then it is a fact, not a flourish.
- *Cut — evaluative agency:* "the design earns its place." The verb needs a
  judge. **Name the judge.** If it means "I think X," write that. The cue is
  grammatical, not lexical: an inanimate subject that earns, keeps, holds, or is
  worth *its* something ("the sentence keeps its shape," "the file is not worth
  its cost"), or a negated verb split by a fit adverb ("does not cleanly name,"
  "doesn't quite land"). Detectors: `earns-its-place`, `not-quite-verb`.
- *Cut — the terminal beat:* "The terminal expires." "The water bottle
  demonstrates." The real defect is **complement deletion**: demonstrates
  *what*? The object was dropped, which is why the verb landed last. Detector:
  short sentence + abstract subject + normally-transitive verb + full stop.
  Genuine intransitives ("the deploy failed") pass clean. Repair test: *verb what?*
- *Cut — animacy stacking:* four or more consecutive non-human subjects. No
  person appears in the paragraph.

**4. Restatement.** The subhead that repeats the headline in longer words; the
sentence that re-says its predecessor. A subhead must add **who it's for**, **how
it works**, or **proof**, never a synonym.

**5. Value-prop abstraction.** Caught by the swap test. *Earned:* never, but the
repair is specificity, not deletion. Find the real claim.

**6. Em-dash density.** Bring the *rate* toward human baseline (~3.2 per 1,000
words). The rule is about rate, not presence. Under ~300 words the baseline
predicts less than one, so zero is correct and not an over-correction. The rule
forbids a blanket search-and-replace at any length. This is a *model* tell, not
an AI tell: Gemini sits at human baseline, Llama at zero, and Mark Twain
measured above Claude. Cutting em dashes raises semicolon density into a new
tell.

**7. Bolded lead-ins on every bullet.** *Earned* when the bolded terms are a
real closed set the reader looks things up in, such as flags, parameters, or
error codes. *Slop* when they are abstractions invented so that something could
be bolded.

**8. Participial evaluative tails.** "..., making it easier to maintain." Clean
rule: **tails that narrate are fine, tails that evaluate get cut.**

---

## Document-scope checks

Some tics are invisible line by line and only appear across the whole piece.

- **Density.** Three or more patterns per 200 words reads as machine-written even
  when each instance individually passes its earned-use test.
- **Cardinality uniformity.** Any single rule-of-three may be honest. Three
  triads in a row is the tell. Count real items, then match the number.
- **Distribution width.** LLM prose clusters narrowly on sentence length,
  paragraph length, and clause depth, with thin tails. If nothing in the piece is
  very short or very long, that is the finding.

---

## Anti-fabrication

**Vague but honest beats specific but invented.**

The repair for an empty claim is a real fact, and you usually do not have one.
Never manufacture a metric, a customer, a benchmark, or a quote to fill a hole
this pass opened.

When a line needs specificity you cannot supply, raise
`[NEEDS FACT: what number goes here]` **in the report, never in the file.** A
bracketed editor's note written into a landing page ships to production if nobody
catches it. Either cut the unsupportable claim and flag the cut, or leave the
line and flag it. The file stays publishable at every moment.

Precision-theater numbers ("save 4.7 hours a week") are the one category where
the editor's failure mode is fabrication rather than blandness. A number in the
output that is not in the source was invented; `audit.sh` lists them.

---

## The conservation check

The stopping condition guards *whether* to edit. This guards *how much*, which
is the harder question and the one every run faces. On a sloppy page every
candidate fails its test, cutting compounds, and half the document can disappear
without any single edit being wrong.

Run this before reporting, every time:

1. Inventory every claim, fact, number, and concrete noun in the **source**.
2. Inventory the same in the **output**.
3. Every item in the delta must be either **deliberately cut as a duplicate** or
   **flagged in the report**.

`audit.sh` does the inventory for numbers, code spans, URLs, and capitalized
names. Names are a heuristic; the rest are exact. It cannot tell a deliberate cut
from a loss, which is what the report is for.

**Word count is not the measure.** Slop is mostly padding, so large drops are
routine: 40–50% on marketing copy, more when the source is thin. Do not treat
that range as a ceiling to stay under or a target to reach. The correct output
length is however long the surviving information needs, and if that number is
embarrassingly small, **that is the finding**. Say so in the report rather than
padding back toward the original.

Losing an unflagged claim is the only failure this check tests for.

**Its blind spot.** Conservation is fully satisfied by a bare inventory: every
fact present, nothing readable. It has no term for transitions, rhythm, or the
connective tissue that makes prose rather than a list. Pass 4's rhythm read is
the counterweight, so run both. Passing conservation is necessary, not
sufficient.

## Over-correction is the second tell

Prose that has visibly been de-AI'd has its own signature.

**Flattening is the main event.** A pass that strips every figure, coinage, and
odd turn of phrase scores *worse* on rhythm than the draft it fixed. This is the
most common way this skill fails, and it fails invisibly, because each
individual cut looks defensible. A vivid phrase is not slop because it is
unusual. If the writer coined it and it carries an image, it stays; that is
exactly the kind of thing a model does not produce on its own.

Then audit for these:

- **Staccato.** Every em dash became a period and the paragraph reads as a ransom
  note.
- **Synonym cycling.** Avoiding a repeated word by rotating through variants is
  itself documented as a tell. Repeat the word.
- **Forced casualness.** Contractions and "look," inserted to perform humanity.
- **Hedge-stripping** that changes how certain a claim is.
- **Deliberate roughness.** Typos and fragments added as camouflage. Never.

The target is prose a good writer would have written, not prose that is visibly
avoiding something.

Ask three questions at the end: *What still reads as generated? Did I invent
anything? Was the amount of cutting proportional to the actual slop?*

---

## Voice

If `~/.hive/personas/dry.md` exists, read it. It carries the user's register and
its own tic list. If the project has a voice or style document, read that.

If the user supplies writing samples and they conflict with these rules, **the
samples win.** Do not fall back on a default professional register. That default
*is* the slop.

Absent all of the above, match the strongest surrounding prose in the file.

---

## Method

**The scanner locates; you rule.** `bash scan.sh FILE` reports candidates with line
numbers and decides nothing. Calibration: four human-written technical READMEs scored
1.6–10.9 salient hits per 1,000 words with nothing above salience 50; a paragraph of
agent-written engineering prose scored 294/1k with 8 above 50 (`lexical.md` §13,
checked by `tests/check.sh`). A middling score is worth reading, not acting on. If the
final report contains every scanner hit, the pass was mechanical and should be
thrown away.

**grep is a flashlight, not a surgeon.** Use search to locate candidates fast,
then read the line in context and decide. Never apply a substitution across a
file without reading each site. A regex pass over prose produces exactly the
mechanical texture this skill exists to remove.

Read the whole document before the first edit. You cannot tell what a sentence is
carrying until you know the argument it sits inside.

---

## Report

Edit, then report grouped by pattern family rather than line order. Family
grouping shows the pattern; line order shows a list.

No rubric, no score. Named pattern, quoted line, concrete fix: evidence the
reader can check.

```
✎ 14 edits across 3 families

Animacy inflation — terminal beat (4)
  L31  "The architecture earns its place."
     → "We chose this architecture because it survives a schema change."

Em-dash density (6)   9.1 → 3.4 per 1k words
  L12  "fast — and finally yours"
     → "fast, and finally yours"

Restatement (4)
  L45  subhead repeated the headline → now names who it's for

⚠ 2 flagged, not edited
  L58  claim risk: "10x faster" is a metric, not a superlative
  L61  [NEEDS FACT: what does the onboarding actually take?]
```

Close with one sentence on how the piece reads now. No summary paragraph.

---

## References

| File | Contents |
|---|---|
| `references/syntactic.md` | ~30 sentence shapes. Animacy inflation tiers, negative parallelism, clefts, participial tails. Highest-value catalog. |
| `references/discourse.md` | 38 structural patterns across 7 families, with the length × venue calibration tables. |
| `references/lexical.md` | 123 word-level entries in 13 families, each graded `[V]` verified corpus study, `[C]` curated banlist, or `[A]` asserted. |
| `references/marketing.md` | 22 landing-page formulas, plus the positive canon — Ogilvy, Schwartz, Wiebe, Basecamp, Linear, Stripe. |
| `references/tics.md` | 40 named constructions — 29 essay tics, 11 Wikipedia signs of AI writing. The catalog for prose that is specific and still reads as generated. |
| `references/tics.tsv` | The regex detectors for those, as `id<TAB>regex`. Machine-readable; edit here to tune a detector. |
| `references/lift-words.tsv` | 1,000 words ranked by salience (lift × rarity in general English), with the `tf` and `idf` terms so any row's score can be audited. What `scan.sh` reads. Explained at `lexical.md` §13. |
| `references/lift-words.txt` | The source list in raw lift order. Input to `tools/rescore.py`; not read at edit time. |
| `tools/rescore.py` | Regenerates the `.tsv`. Carries the three scoring assumptions and why each one is there. |
| `tests/check.sh` | Asserts the numbers this file quotes: every regex and both structural detectors fire, clean prose stays silent, line numbers hold through front matter, code and tables, the 30–49 trigger separates the fixtures, the score reproduces. Run it after touching a detector. |
| `scan.sh` | Runs all of the above against a file. Candidates with line numbers, never findings. |
| `audit.sh` | Scans the edit: working tree against `HEAD`, or any two files. Introduced tics and words, new numbers, missing facts, shape deltas. Exit 1 on a hard finding. |
| `tools/strip.awk` | The one strip both scripts use: front matter, code, tables out; line count preserved. |
| `PRIOR-ART.md` | Design rationale. Why this skill is shaped as it is, and how other deslop prompts fail. Not loaded during an edit pass. |

**Word tells decay; constructions do not.** The lexical catalog has roughly a
one-year half-life and carries evidence grades for that reason. Weight the
structural catalogs higher.
