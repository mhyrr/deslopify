# Rhetorical tics — the essay-voice catalog

38 patterns. The 27 in §2 are the **essay tics**: constructions a model reaches for
when it is trying to sound like a good writer. The 11 in §3 are the **Wikipedia
signs**: the SEO-flavored tells of generic assistant prose.

The split matters. The Wikipedia set is what people mean by "AI slop" and is mostly
already handled in the sibling catalogs. The essay set is newer, less documented,
and is what makes a well-written, specific, information-carrying piece still read as
machine-made. If a document survives `lexical.md` and still sounds wrong, the answer
is almost always in §2.

**Provenance.** §2 and §3 are transcribed from the LLM cliché highlighter's pattern
list; §3 tracks Wikipedia's *Signs of AI writing*. Grade **[C]** throughout — curated
by editors, evidence of *perception*, not of measured frequency. Treat any single hit
as a hypothesis. Cross-references point at the fuller entries in the sibling catalogs;
where an entry says "→ file §x", read that instead of duplicating the ruling here.

**Detection.** Machine-readable patterns live in `tics.tsv` (id + ERE, tab-separated),
run by `../scan.sh`. Three patterns have no regex and are computed in the script:
echoing sentence runs, repeated sentence openers, stacked rhetorical questions.

---

## 1. The one thing to understand before using this file

**Nine of the 27 essay tics are the same move.** They announce that something matters
instead of making it matter — "that's the whole point," "this is the entire business
model," "that's not nothing," "worth naming." SKILL.md's governing test already covers
them: ask what the sentence is carrying. These carry the *report* of significance and
nothing else.

That is why the repair is nearly always **deletion of the announcing clause**, keeping
the thing announced. The sentence underneath is usually fine and occasionally very good.
It was wearing a sign.

**A hit is not a finding.** Every one of these constructions is available to human
writers and several are load-bearing in argument. The scanner locates; you rule. On a
2,000-word essay expect 5–15 hits and 2–5 real edits.

---

## 2. Essay tics

### 2.1 Announced significance (9)

The largest family and the one most likely to survive a lexical pass.

**`thats-the-whole`** — "That's the whole point." "This is the whole game."
*Earned:* after a genuinely counterintuitive demonstration the reader might not have
connected. Roughly once per piece, never twice.
*Repair:* cut the sentence. The preceding paragraph either made the point or did not.
→ also `lexical.md` §*the whole game / that's the whole ballgame*

**`is-the-entire`** / **`the-entire-is`** — "Speed is the entire business model."
"The entire point of the rewrite is throughput." Same move, subject and predicate
flipped, and the flip is why a single-shape grep misses half of them.
*Earned:* when *entire* is doing exclusionary work — there really is one input and
naming it corrects a reader who assumes several.
*Repair:* drop "entire," or state the exclusion as a fact: "Nothing else in the
pricing model moves."

**`is-the-whole-x`** — "Here's the whole trick:" "That is the whole pitch."
The generalization of `thats-the-whole` to any subject.
*Earned:* as a genuine summary marker at the head of a short list the reader will
verify immediately. Slop when it introduces a paragraph.
*Repair:* delete the frame, keep the list.

**`thats-not-nothing`** — "That's not nothing." "Which is not nothing."
Litotes used to claim importance while appearing to undersell it. The rhetorical cost
is that it grades the reader's reaction for them.
*Earned:* rarely; it is a real English idiom, but a model reaches for it as a
paragraph-closer. If it sits at the end of a paragraph, it is decorative.
*Repair:* give the magnitude. "That's not nothing" → "That's four hours a week."

**`worth-naming`** — "That loss is real and it's worth naming." "Worth naming:"
Therapist-voiced significance. Notably absent from human technical prose.
*Earned:* almost never. Skip `naming names`.
*Repair:* name it. The sentence announcing that a thing deserves a name is the
sentence that should have contained the name.

**`thats-why-x-mattered`** — "That's why being able to open the environment mattered."
Retroactive significance assignment, usually bolted to the end of a section to make
the section feel concluded.
*Earned:* in Long/Extended documents where the payoff genuinely lands 2,000 words after
the setup and the reader needs the callback.
*Repair:* cut. In Short/Medium prose the reader has not forgotten.

**`thats-the-part`** — "That's the part a counter can't reach." "The part that makes me
trust the rest." "My favourite part of…"
Gesturing at a favoured detail rather than stating it.
*Earned:* when the following clause actually specifies the part and adds information.
*Repair:* promote the detail out of the frame.

**`the-only-x-i-trust`** — "The only metric I trust is p99." "The only thing it needs."
"The only X that matters."
The narrowing superlative. It reads as hard-won judgment and costs nothing to assert.
*Earned:* when the exclusion is defended somewhere in the piece. If nothing supports
"only," it is a rhetorical shrug.
*Repair:* keep the claim, drop the superlative, or defend it.

**`is-real-and-not`** — "The risk is real, and not hypothetical." "This is the real
constraint and it…"
*Earned:* when a named party actually disputes that the thing is real.
*Repair:* cut "is real, and" and assert the thing. Skips `real estate`, `real time`,
`real number` — check the hit before editing.

### 2.2 The staged reveal (6)

Prose organized as a small drama. Each of these buys a beat of suspense the reader did
not ask for.

**`turns-out`** — "Turns out the index was stale." "It turns out that…"
The casual-revelation opener, almost always bolted to a tidy conclusion.
*Earned:* when something genuinely surprised the writer and the surprise is the point
of the paragraph. Once per piece.
*Repair:* state the finding. "The index was stale."

**`heres-the-twist`** — "Here's the twist:" "Here's the thing." "Here's the catch /
kicker / rub." "Here's the first example:"
*Earned:* never for "here's the thing," which is pure throat-clearing. The others are
earned only when what follows actually reverses what preceded.
*Repair:* delete the frame. → `lexical.md` §*here's where it gets interesting*

**`the-punchline-is`** — "The punchline is that nobody ran the tests."
*Earned:* when the piece has been structured as a joke and this is the joke.
*Repair:* lead with the punchline; it is the sentence.

**`x-is-dead`** — "Peer code review is dead." "BOTD is dead; long live BOTD."
The obituary headline and its sequel.
*Earned:* as a real thesis you then argue. Slop as a section header or an aside.
*Repair:* state what changed and who stopped doing what.

**`sit-with-that`** — "Sit with that for a moment." "Sit with the discomfort."
*Earned:* never in technical or marketing prose. It instructs the reader's interior
state.
*Repair:* delete. Nothing is lost.

**`you-already-know`** — "You already know the answer." "You already know what to do."
Flattery wearing the costume of concision, and it frequently precedes the thing the
reader did *not* know.
*Earned:* never as a standalone sentence.
*Repair:* delete, and say the thing.

### 2.3 Manufactured contrast (5)

Rhythm built from opposition. Related to negative parallelism (SKILL.md worked set #2),
which is the same instinct at sentence scale.

**`no-x-no-y`** — "No fluff, no filler, no jargon." Two or more `no …` items in a row.
*Earned:* in a genuine spec list where each item is a real excluded feature.
*Repair:* say what it *is*. A list of absences describes nothing. This is the swap test
in construction form — every product is "no bloat."

**`did-not-chains`** — "It didn't ship, it didn't build, and it didn't matter."
Two or more negated verbs in series.
*Earned:* when enumerating actual failed checks.
*Repair:* one negation, then the positive statement of what did happen.

**`dont-verb-it`** — "Don't call it a cache. Call it a ledger." Negated verb + *it*,
then the same verb + *it*.
*Earned:* when the reader genuinely holds the wrong name and the renaming carries a
distinction you then use.
*Repair:* assert the second half. "It's a ledger, not a cache" is already shorter, and
usually just "It's a ledger" is enough.

**`stranded-auxiliary`** — "The tool died; the data didn't." "Reading mostly passed.
Writing didn't." "Maybe it wouldn't have."
A clause landing on a bare negated auxiliary for the reversal. The rhythm is
unmistakable and it is *very* hard to see in your own draft.
*Earned:* occasionally — it is a real English construction and can be crisp. The tell
is **density**: two in a page is a voice, three is a tic.
*Repair:* complete the verb. "Writing didn't" → "Writing failed on every retry."

**Negative parallelism** — "Not just X, but Y." Listed here for adjacency; the ruling
lives at SKILL.md worked set #2 and `syntactic.md`. Detected as `not-just-x-but-y`.

### 2.4 Repetition as rhythm (4)

Structural. Three of the four are invisible line by line, which is why `scan.sh`
computes them rather than grepping.

**Echoing sentence runs** *(no regex — read for it)* — consecutive sentences built on
the same skeleton. "A shopping cart is an object in the system. A chat room is an object
in the system."
*Earned:* deliberate anaphora, once, at a moment that deserves the weight.
*Repair:* collapse the run into one sentence with a list, or vary the frames.
*Detection:* read the passage aloud. This is the one pattern where the ear beats grep.

**`repeated-sentence-openers`** *(script)* — three or more consecutive sentences opening
on the same word. "Maybe nobody needed it. Maybe it introduced… Maybe a small
convenience…" Articles and pronouns are ignored, since "The … The … The …" is normal.
*Earned:* same as above — once, deliberately.
*Repair:* keep the strongest, recast the rest.

**`stacked-rhetorical-questions`** *(script)* — two or more questions in a row, usually
fragments after the first. "Do I know how it works? Where it breaks? Which corners it
cut?"
*Earned:* on an FAQ mirroring real search queries; as a single question opening a
section. Never as a triple.
*Repair:* answer them. A stacked question set is an outline that did not get written.

**`colon-into-triple`** — a colon opening onto three or more comma-separated items:
"separate ports, processes, and local state."
The most common shape LLM prose uses to sound concrete, and the highest-noise pattern
in this file.
*Earned:* **usually** in documentation and reference prose, where a colon onto a list is
correct and expected. Suppress this check on instructional and reference venues.
*Repair:* only when the triple is padded to reach three — cardinality uniformity
(SKILL.md, document-scope checks) is the real signal. Count the honest items and match
the number.

### 2.5 Performed sincerity (2)

**`performative-honesty`** — "I'll be honest." "Let's be honest." "To be clear." "I won't
pretend." Sentence-initial "Honestly," and "Look,".
Sincerity announced rather than demonstrated. Compounds badly with the register: a page
that says "let's be honest" twice reads less honest, not more.
*Earned:* "to be clear" when disambiguating an actual misreading you expect.
*Repair:* delete the frame. → `lexical.md` §*honest / honestly*, §*narrated candor*

**`dont-take-my-word`** — "You don't have to take my word for it." "Don't take my word
for any of this."
The stock invitation to verify, which in practice is never followed by a way to verify.
*Earned:* when immediately followed by the benchmark, the repo, the data, or the
citation. Then the sentence is doing work.
*Repair:* delete it and link the thing. If there is nothing to link, the sentence was
covering for that.

### 2.6 Genre boilerplate (1)

**`fits-in-your-head`** — "Small enough to hold in your head." "Batteries included."
"It just works." "Zero config." "Sane defaults."
Dev-blog boilerplate for simplicity. Fails the swap test cleanly: every framework claims
all five.
*Earned:* when accompanied by the number. "Fits in your head" → "Four public functions."
*Repair:* the number, the line count, or the API surface. Otherwise cut.

---

## 3. Wikipedia signs of AI writing (11)

Mostly already catalogued. Entries here give the detector and the one-line ruling; the
full treatment is in the sibling file named.

**`ai-vocabulary`** — delve, tapestry, meticulous, pivotal, intricate, interplay,
underscore, garner, bolster, vibrant, bustling, multifaceted, seamless, ever-evolving.
*One hit is coincidence; three is a tell.* Count before editing.
→ `lexical.md` families A–D, which carry the tier and register-gating for each word.

**`not-just-x-but-y`** — "not just X, but (also) Y," "not only … but …," "it's not X —
it's Y." ~3× the human rate. → SKILL.md worked set #2, `syntactic.md`

**`important-to-note`** — "it is important to note that," "it's worth noting," "it should
be noted," plus the *worth pausing / considering / asking* family. Didactic hedging.
*Repair:* delete the frame and keep the note; if the note does not survive alone, it was
not worth noting. → `lexical.md` §*it's worth noting that*, §*the entire "worth ___" family*

**`stands-as-a-testament`** — "stands / serves as a testament (or reminder)," "is a
testament to." Inflating significance instead of saying what happened.
*Repair:* say what happened. → `lexical.md` §*testament*

**`plays-a-crucial-role`** — "plays a crucial / pivotal / vital / key / significant role
in." Animacy inflation with a hedge attached: the subject does something, but the
sentence declines to say what.
*Repair:* name the mechanism. → SKILL.md worked set #3, `syntactic.md` animacy tiers

**`ever-evolving-landscape`** — "the ever-evolving / changing / shifting landscape," "in
today's fast-paced world." Scene-setting boilerplate, nearly always in a first paragraph.
*Repair:* head-and-tail deletion usually removes it for free. → `lexical.md` §*landscape*

**`experts-argue`** — "experts argue," "some critics have noted," "observers suggest,"
"industry reports indicate," "studies show." Vague attribution to unnamed authorities.
*Repair:* name the source or cut the claim. This is the one family where the repair is
sometimes deletion of a factual-sounding claim — flag it, per SKILL.md's scope limit.
→ `lexical.md` §*studies show / research suggests*

**`despite-these-challenges`** — "despite these challenges," "faces several challenges,"
"challenges remain," "remains to be seen," "time will tell." The challenges-and-outlook
formula, always in a closing paragraph.
*Repair:* head-and-tail deletion. → `discourse.md`, bookend conclusions

**`participle-tails`** — "…, highlighting / underscoring / showcasing / reflecting the…"
Superficial analysis bolted onto a sentence end.
*Ruling:* tails that narrate are fine; tails that evaluate get cut.
→ SKILL.md worked set #8

**`promotional-boilerplate`** — "nestled in," "in the heart of," "rich tapestry /
heritage," "hidden gem," "boasts a," "breathtaking," "stunning views." Travel-brochure
tone. → `marketing.md`, `lexical.md` §*boasts*

**`chatbot-leftovers`** — "as an AI language model," "as of my last update," "knowledge
cutoff," plus markup debris: `oaicite`, `contentReference`, `turn0search`, and
`utm_source=` tracking parameters.
*Ruling:* the only entry in this file that is not a judgment call. Delete on sight, and
check whether anything else was pasted in with it.

---

## 4. Using the detectors

```
bash scan.sh path/to/file.md
```

Reads `tics.tsv` and `lift-words.tsv`, strips code fences, inline code, indented blocks,
table rows and URLs, then reports: word count and length band, em-dash rate against the
3.2/1k human baseline, sentence-length distribution, the three computed structural tics,
every regex hit with line numbers, and salience-ranked vocabulary.

Calibration on real documents — four human-written technical READMEs (abseil, apache-arrow,
aws-c-common, ada-url) scored 1.6–10.9 salient words per 1,000 with nothing above salience
50; a file seeded with all 38 scored 58.6/1k with nothing above 50, and agent-written
engineering prose 294/1k with eight above 50. The gap is wide, which is what makes a middling score worth
reading rather than acting on.

**Order of operations.** Scan *after* Pass 1, not before. Head-and-tail deletion removes
a large share of §3 hits at no cost, and scanning first spends attention on lines you are
about to delete anyway.

**Editing patterns from a list is how this skill fails.** The scan output is a map of
where to look. Every ruling still needs the line read in context, and the earned-use test
applied. If the report ends up containing every scanner hit, the pass was mechanical and
should be thrown away.
