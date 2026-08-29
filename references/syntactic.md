# The Syntactic Layer of LLM Writing Tics

A catalog of sentence *shapes* — clause architecture, rhythm devices, attachment habits — that mark prose as machine-written independent of word choice. A sentence containing zero blacklisted vocabulary can still be unmistakably AI because of its shape. This file is the shape catalog.

Companion layers (handled elsewhere): lexical (word choice) and document-structural (headings, bullets, section symmetry).

---

## 0. How to use this catalog

### 0.1 The core principle: every pattern here is a real rhetorical device

Antithesis is Cicero. Fragments are Didion. Clefts are how English marks focus. Tricolon is *veni, vidi, vici*. **Nothing in this catalog should be banned.** The tic is never the device; the tic is the *unearned, reflexive, high-density* deployment of the device. An editor that deletes all fragments produces worse prose than it found.

Therefore every entry carries a required **Earned use** field: a test, answerable from the text alone, for when to keep the instance. Apply the test before touching anything.

### 0.2 Density, not instance

The single most important operational fact: **readers do not detect these patterns individually — they detect co-occurrence.** One negative-parallelism sentence in a 1,200-word essay is invisible. Four is a signature. Edit to a budget, not to zero.

Suggested per-1,000-word budgets for edited prose:

| Pattern | Budget / 1,000 words |
|---|---|
| Negative parallelism (any variant) | 1 |
| Fragment as punchline | 1–2 |
| Tricolon | 2 |
| Cleft / inverted emphasis | 1–2 |
| Em-dash apposition | 2–3 |
| Colon-then-restatement | 1 |
| Rhetorical question + answer | 1 |
| Participial tail | 3 (and none of them evaluative) |
| Terminal Beat (§1.5) | 1 |
| Explicit restatement move ("in other words") | 1 |

These are starting numbers, not measurements. Tune per author.

### 0.3 Order of operations for an editing pass

1. **Measure first** (§8) — sentence-length series, subject-animacy series, opener series. Numbers before judgments.
2. **Kill the stacks** — three of the same shape in a row is always wrong, even when each instance passes its own earned-use test. Repair by deletion, not rewriting: keep the best one.
3. **Then run per-pattern tests** on survivors.
4. **Re-measure.** Deslopifying often *flattens* rhythm — the editor removes the fragments and clefts and leaves a uniform slab of 18-word declaratives, which is a different tic (§8.1). Variance must go up, not down.
5. **Preserve at least one deliberate instance of something.** Prose with no rhetorical figures at all reads as machine-scrubbed, which is its own tell.

### 0.4 A note on regexes

Most of these patterns are not regular. Where a regex is given it is a **candidate finder**, tuned to under-fire rather than over-fire — it produces a shortlist for human/model judgment, never an auto-fix. Patterns marked *(needs POS)* require part-of-speech tagging to detect reliably; a purely lexical regex for those will destroy correct prose.

---

# PART I — THE ANIMACY INFLATION FAMILY

*The user's primary ask. Treated at length because a naive rule here breaks correct technical writing.*

## 1.0 Framing the family

English permits inanimate nouns as grammatical subjects of active, agent-shaped verbs. This is not a defect and not a borrowing — Peter Master's corpus study of ~3,000 subject–verb pairs in scientific prose found inanimate-subject active constructions *more common than passives*. English does this in ways Japanese, Chinese, and Thai largely do not. The construction is native.

Linguistics calls the general phenomenon **grammatical metaphor** (Halliday) or a violation of the **animacy hierarchy**: an entity low on the animacy scale (abstract noun) is assigned the grammatical role (agent-subject of a transitive verb) normally reserved for entities high on it (humans).

So the family name should not imply that inanimate subjects are wrong. I propose:

> ## **ANIMACY INFLATION**
> Promoting a noun higher up the animacy hierarchy than its referent can support — specifically, pairing an abstract or artifactual subject with a verb whose meaning requires intention, judgment, desire, or experience.

The tic is **not** "inanimate subject." The tic is **the mismatch between the subject's animacy and the verb's animacy requirement**, plus two aggravating factors: a **deleted complement**, and **sentence-final verb position used as a rhythm beat**.

### 1.0.1 The three-part diagnostic

A sentence in this family is a tic if **two or more** of the following hold:

1. **Verb-animacy mismatch.** The verb requires a mind — it encodes judgment (`earns`, `deserves`, `justifies`, `vindicates`), volition (`wants`, `insists`, `refuses`, `chooses`, `tries`), cognition (`knows`, `understands`, `remembers`, `assumes`), or self-disclosure (`reveals itself`, `admits`, `confesses`, `announces`). The subject is an abstraction, a document, a design, or a concept.
2. **Deleted complement.** The verb is ordinarily transitive but has no object; or ordinarily requires a complement clause and has none. *"The water bottle demonstrates."* — demonstrates **what**? This is the user's "verb at the end" perception: the object was deleted, which is *why* the verb ended up final. **Complement deletion is the sharpest single detector in this family.**
3. **Hidden judge.** The verb's meaning smuggles in an evaluation, and the evaluator has been erased. "The design earns its place" = "I think the design is worth it," restated as an observed event. The abstraction is doing the writer's arguing for them.

Add a fourth, paragraph-level factor:

4. **Animacy stacking.** Three or more consecutive sentences whose subjects are all inanimate abstractions, so that no person appears anywhere in the passage. Individually licensed sentences become a tic in aggregate — the prose describes a world in which systems act and nobody built them.

### 1.0.2 The tier ladder (leave the low tiers alone)

| Tier | Name | Status | Example |
|---|---|---|---|
| 0 | **Mechanism metonymy** | **Correct. Never touch.** | "The parser rejects malformed input." |
| 1 | **Frozen convention** | Fine; watch density only. | "The study found…", "The contract requires…" |
| 2 | **Evaluative agency** | **Tic.** Hidden judge. | "The abstraction earns its place." |
| 3 | **Terminal Beat** | **Tic.** Truncated, prosodic. | "The training landed." |
| 4 | **Animacy stack** | **Tic** at the paragraph level. | (see §1.6) |

---

### Tier 0 — Mechanism Metonymy *(NOT a tic — protect this)*
- **Shape:** `[system / component / artifact] + [verb naming an operation the referent actually performs]`
- **Why it is fine:** The referent genuinely executes the action; the sentence is a checkable claim about behavior, and rewriting it to name a human agent would be *less* accurate, not more.
- **Specimens (all correct, leave them alone):**
  - "The parser rejects malformed input."
  - "The retry loop backs off exponentially."
  - "The linter flags unused imports."
  - "The cache evicts the least-recently-used entry."
  - "This function returns null when the key is absent."
- **Repairs:** None. Rewriting these ("The engineers wrote a parser that rejects…") adds words and subtracts precision. An editor that touches these is broken.
- **Detection cue — the protection test:** *Could this sentence appear in a bug report, spec, or test name and be true or false?* If yes, it is Tier 0. Corollary tests: (a) Is there a mechanism — could you point at the code/hardware that performs it? (b) Is the verb's meaning exhausted by observable behavior, with no residue of opinion? (c) Is there a complement, and is it concrete?
- **Earned use:** Always earned. The only intervention permitted is at the stack level (§1.6): if six consecutive Tier-0 sentences run without a human, vary the subjects — but never on grounds that any individual sentence is wrong.

---

### Tier 1 — Frozen Convention *(usually fine)*
- **Shape:** `[institution / document / evidence] + [conventionalized reporting verb]`
- **Why it rarely reads as AI:** These are dead metaphors with centuries of use; readers process them as idioms, not as personification. "The data suggest" does not evoke data wearing a hat.
- **Specimens:** "The study found no effect." / "Section 4 requires two signatures." / "The evidence points to a race condition." / "The spec says nothing about ordering."
- **Repairs:** Usually none. Repair only when the frozen verb is doing argumentative work the writer should own: "The evidence points to a race condition" → "I think this is a race condition, and here's why:" — but only if the writer is in fact asserting, not reporting.
- **Detection cue:** Is the verb one of the small closed set of reporting/requiring verbs (`show`, `suggest`, `indicate`, `find`, `require`, `state`, `say`, `note`, `imply`, `point to`)? Then Tier 1. Frequency check only.
- **Earned use:** Earned whenever the source really is the source of the claim. Becomes a tic only in stacks, or when the "evidence" is actually the writer's inference wearing evidence's clothes.

---

### Tier 2 — Evaluative Agency *(the core tic)*
- **Shape:** `[abstract noun] + [verb of judgment / volition / cognition / self-disclosure] (+ optional reflexive or possessive object)`
  - Sub-shapes: `X earns its keep` · `X wants Y` · `X knows Y` · `X reveals itself` · `X does the work` · `X argues for Y` · `X deserves Y` · `X refuses to Y` · `X keeps its shape` · `X is not worth its cost` · `X does not cleanly Y`
  - Detectors: `earns-its-place` (judgment verb + *its/itself*) and `not-quite-verb` (negated auxiliary split by a fit adverb) in `tics.tsv`. The possessive and the split are the regex hooks; the vocabulary inside them varies.
- **Why it reads as AI:** The verb requires a mind the subject does not have, so the sentence quietly converts the writer's opinion into a reported event — it sounds like insight while asserting nothing checkable.
- **Specimens:**
  1. "The abstraction reveals itself once you trace a single request end to end."
  2. "The architecture wants a queue here."
  3. "The naming convention does the work; the comments are redundant."
  4. "This constraint earns its place in the design."
- **Repairs:**
  1. → "Trace a single request end to end and the abstraction is obvious." *(Or, better, name what you saw: "Trace one request and you'll see every handler re-deriving the same tenant ID.")*
  2. → "I'd put a queue here." / "Writes arrive in bursts, so this needs a queue." *(Restores the judge, or replaces the judgment with its reason.)*
  3. → "The names say enough; delete the comments."
  4. → "This constraint is worth the cost: it makes the invalid state unrepresentable." *(States the payoff instead of asserting worth.)*
- **Detection cue:** Scan for an abstract/artifactual subject followed by a verb from the **mind-requiring set**. The closed-ish list worth encoding:
  `wants, needs (as desire), knows, understands, remembers, forgets, assumes, believes, decides, chooses, refuses, insists, tries, means to, cares, earns, deserves, justifies, vindicates, rewards, punishes, admits, confesses, announces, reveals (itself), declares, argues, insists, promises, threatens, invites, resists, embraces, respects, honors, does the work, carries the weight, pays for itself, buys you, gets you, does the heavy lifting`

  Regex (candidate finder, deliberately narrow):
  ```regex
  \b(?:the|this|that|these|those|its|our|their)\s+[a-z][a-z-]*(?:\s+[a-z][a-z-]*)?\s+(?:earns?|deserves?|wants?|knows?|understands?|refuses?|insists?|admits?|announces?|reveals?|argues?|promises?|rewards?|punishes?|respects?|honou?rs?|embraces?|resists?)\b
  ```
  Plus a separate idiom finder:
  ```regex
  \b(?:does the (?:work|heavy lifting)|carries the (?:weight|load)|earns? (?:its|their) (?:keep|place)|pays? for itself|buys? you|gets? you)\b
  ```
  *(Both need a check that the subject is not human — `\b(?:the|this)\s+(?:team|author|engineer|user|reviewer|developer)\b` should be excluded.)*
- **Earned use:** **The stakes test.** Keep it only when (a) the metaphor is live and specific — it makes the reader see something they would not have seen from a literal statement — and (b) you would defend the personification if challenged. "The type system won't let you" is earned: it is a live constraint with real force, and it is arguably Tier 0. "The architecture wants a queue" is not: you want the queue. Secondary test: **can you name the judge?** If the sentence means "I think X," and you're willing to say "I think X," say it. If you're not willing to say it, the sentence is hiding.

---

### Tier 3 — THE TERMINAL BEAT *(the user's specific phenomenon; the highest-value entry in this file)*
- **Shape:** `The/This + [1–2-word abstract or concrete noun] + [finite verb, no object] .` — a short declarative, typically 3–6 words, verb in final position, standing alone as a paragraph-closing or paragraph-opening rhythm beat.
- **Why it reads as AI:** A transitive verb's object has been deleted so the sentence lands on the verb, producing a drum-hit of cadence with no propositional content — the shape supplies the feeling of a conclusion without stating one.
- **Specimens:**
  1. "The terminal expires."
  2. "The water bottle demonstrates."
  3. "The training landed."
  4. "The constraint reveals."
  5. "The standard holds." *(closing a paragraph, meaning nothing beyond "I like the standard")*
- **Repairs:**
  1. → "The session times out after fifteen minutes." *(Restore the missing adverbial; now it's a fact.)*
  2. → "The water bottle shows what the tolerance actually is: 0.4 mm of wobble at the seam." *(Restore the deleted object, then the specifics.)*
  3. → "Three of the four reviewers changed how they write PR descriptions." *(Replace the beat with the evidence it was gesturing at.)*
  4. → "Because you can't allocate here, the whole retry design has to change." *(Say the thing the beat was standing in for.)*
  5. → Delete. Nothing is lost.
- **Detection cue:** Scan for **short sentences that end on a verb**. In ordinary English prose, a declarative sentence ending in a finite verb with no object, complement, or adverbial is rare — genuine intransitives ("The server crashed." "The deploy failed." "Prices fell.") are the main legitimate case, and those are mostly change-of-state verbs with concrete subjects. The reliable cue is the pairing: **abstract subject + normally-transitive verb + full stop.**

  Heuristic (needs POS): flag any sentence where `token_count <= 7` AND the final token before terminal punctuation is a finite verb (`VBZ|VBD|VBP`) AND the subject head noun is abstract or non-agentive.

  Lexical approximation (candidate finder only):
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:The|This|That|Its|Their)\s+[a-z][a-z-]*(?:\s+[a-z][a-z-]*)?\s+(?:reveals?|demonstrates?|proves?|shows?|expires?|lands?|holds?|works?|matters?|wins?|delivers?|scales?|compounds?|persists?|endures?|survives?|sticks?|lands?|clicks?)\.
  ```
  **Warning:** this regex will hit correct intransitives ("The connection drops." "The build breaks."). It is a shortlist generator. The disqualifying check is: *is the verb intransitive in this sense, and is the subject a thing that literally does this?* If yes, keep.
- **Earned use:** **The deleted-object test.** Ask "*verb what?*" If there is an answer the writer intends but omitted, the sentence is a tic — restore the object or cut. If the verb is genuinely intransitive in this sense (`expire`, `fail`, `crash`, `drop`, `compile`, `hang`) and the subject genuinely does it, the sentence is Tier 0 and fine. Second test: **the removal test** — delete the sentence. If the paragraph loses only its cadence and no information, it was a beat, and beats should be rationed to roughly one per piece. Third: a genuine short punch sentence usually carries a *new noun*, not a recycled one. "The terminal expires" after three sentences about terminals is pure percussion.

---

### 1.5 The idiom sub-family: "does the work"
- **Shape:** `[abstraction] + [effort/value idiom]` — *does the work · does the heavy lifting · carries the weight · earns its keep · pays for itself · buys you X · gets you most of the way there · is where the value lives*
- **Why it reads as AI:** These are pre-packaged evaluation, lexicalized so thoroughly that they can be dropped in without the writer ever specifying what the work *was*.
- **Specimens:** "The type system does the heavy lifting here." / "The naming convention earns its keep." / "The cache buys you about 40% of the latency."
- **Repairs:** "The type system catches the ordering bug at compile time." / "The convention means you can find any handler by its filename." / "The cache cuts p99 from 800 ms to 480 ms." *(Note the third specimen was already fine — it had a number. The idiom is only a tic when it replaces the number.)*
- **Detection cue:** the idiom regex in Tier 2. Then ask whether a quantity or mechanism follows within one sentence.
- **Earned use:** Earned when the specifics are *adjacent* — the idiom is a summary of something you then show, or just showed. Unearned when it is the whole claim.

---

### 1.6 Animacy stacking *(paragraph-level)*
- **Shape:** Three or more consecutive sentences with inanimate abstract subjects and no human agent anywhere in the passage.
- **Why it reads as AI:** Systems appear to have built themselves; every choice looks discovered rather than made, which is exactly the epistemic stance of a model that did not make any of them.
- **Specimen:** "The architecture separates reads from writes. The separation lets the read path scale independently. That independence reduces the blast radius of a bad deploy. The design earns its complexity."
- **Repair:** "We split reads from writes so the read path could scale on its own — a bad deploy now takes down one side, not both. It cost us a sync step in the write path; worth it." *(One human subject, one concrete cost, and the Tier-2 closer deleted.)*
- **Detection cue:** Compute the **subject-animacy series** for each paragraph: for each sentence, is the subject-head human/organizational (`we`, `I`, `the team`, `users`, `reviewers`, a person's name) or not? Flag runs of ≥ 4 non-human subjects. Also flag any passage of ≥ 150 words with zero human subjects.
- **Earned use:** Earned in reference documentation, API docs, spec text, and RFC-style prose, where the human agent is genuinely irrelevant and naming one would be noise. Unearned in essays, postmortems, design rationale, and anything arguing for a decision — those are about choices, and choices have choosers.

---

# PART II — CORRECTION AND CONTRAST SHAPES

### Negative Parallelism (the "It's not X, it's Y" family)
- **Shape:** `It's not X — it's Y.` · `X isn't just A; it's B.` · `The question isn't P. The question is Q.` · `Not because X. Because Y.` · `Less about A than about B.`
- **Why it reads as AI:** It performs the *motion* of a correction without a mistaken belief to correct, manufacturing the sensation of nuance from a swap of near-synonyms.
- **Specimens:**
  1. "This isn't a caching problem — it's an invalidation problem."
  2. "Good tooling isn't just about speed; it's about confidence."
  3. "The question isn't whether to refactor. The question is when."
- **Repairs:**
  1. → Keep, *if* the reader plausibly thought it was a caching problem. Otherwise: "The bug is in invalidation, not in the cache itself." *(Same content, no hinge.)*
  2. → "Fast tools make people willing to run things they'd otherwise skip." *(States the actual claim; the abstract pair vanishes.)*
  3. → "We're refactoring. The open question is when." *(The correction becomes a decision plus a residue.)*
- **Detection cue:** Highest-yield regex in the whole catalog, because the surface form is unusually stable:
  ```regex
  \b(?:is|are|was|were|it'?s|that'?s)\s*n[o']?t\s+(?:just|only|merely|simply|about)?[^.;—–\n]{2,60}[—–,;:]\s*(?:it'?s|they'?re|that'?s|but)\b
  ```
  Plus the two-sentence variant:
  ```regex
  \b(?:The|This)\s+(?:question|problem|issue|point|answer|real \w+)\s+is\s*n[o']?t\b[^.]{0,80}\.\s+(?:The|This)\s+\w+\s+is\b
  ```
  And the bare negation-first fragment: `^Not (?:a|an|the|because|just)\b[^.]{0,40}\.` at sentence start.
  Reported frequency: variants of "not just X, but Y" appeared in roughly 6% of messages in one large deployment corpus; negative parallelism runs ~3× human base rate.
- **Earned use:** **The mistaken-reader test.** Name the person who believes X. If you can point to a real, widely-held, *specific* wrong belief that the sentence corrects, keep it — that is what the device is for, and it is why Didion uses it. If X is a straw position invented in the same breath so Y can defeat it, cut. Second filter: **X and Y must be genuinely different categories.** "Not a caching problem but an invalidation problem" passes (different subsystems). "Not about speed but about velocity" fails (same thing, longer word). Budget: **one per piece.**

### "Not X. Not Y. Just Z." (serial negation)
- **Shape:** Two or more standalone negating fragments, then the reveal.
- **Why it reads as AI:** Each negation asks the reader to build and discard a mental model; three build-and-discard cycles is a large tax for one payload.
- **Specimens:** "Not a bug. Not a feature. A design flaw." / "Not ten. Not fifty. Five hundred and twenty-three lint violations."
- **Repairs:** "It's not a bug — the code does exactly what it was written to do. The design is wrong." / "There were 523 lint violations."
- **Detection cue:** two or more consecutive sentences starting `Not ` with no finite verb.
  ```regex
  (?m)^\s*Not\s+[^.!?\n]{1,40}[.!?]\s*(?:Not\s+[^.!?\n]{1,40}[.!?])
  ```
- **Earned use:** Earned when each negation is a belief a reader actually holds *and* the sequence is a genuine narrowing (a real spectrum being walked in). The number-escalation variant ("Not ten. Not fifty. 523.") is earned only if the reader's prior really was ten — that is, if you have set up the expectation earlier. Otherwise it is theater. Budget: **one per piece, at most.**

### The Concessive Pivot
- **Shape:** `While X is true, Y.` · `Yes, X. But Y.` · `To be fair, X. Still, Y.` · `That's not wrong. It's incomplete.`
- **Why it reads as AI:** It is the model's default politeness gesture — a pre-emptive nod to an objection nobody raised — and it appears at a rate no human argumentative style sustains.
- **Specimens:**
  1. "While microservices offer genuine scaling benefits, they introduce operational complexity."
  2. "Yes, the tests are slow. But they catch real regressions."
  3. "That's not wrong. It's just incomplete."
- **Repairs:**
  1. → "Microservices scale well and are miserable to operate." *(The concession becomes a conjunction; 12 words become 8.)*
  2. → "The tests are slow, and they catch real regressions — I'd keep them." *(Or just take the position.)*
  3. → Say what's missing: "You've got the read path. The write path has the same problem and no cache."
- **Detection cue:**
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:While|Although|Though|Granted|Admittedly|To be fair|Yes,|Sure,|True,)\b[^.!?\n]{10,120}[,.]\s*(?:but|yet|still|however|the|it)
  ```
  Also count sentence-initial `While|Although|Though` per 1,000 words; more than ~3 is a rhythm problem regardless of individual merit.
- **Earned use:** Earned when the concession is **costly** — you are giving up something that actually weakens your case, and the reader can tell. Unearned when the concession is a token (`While there are many approaches…`) that costs nothing and exists only to make the pivot sound balanced. Test: **delete the concessive clause.** If the remaining sentence says the same thing with the same force, the concession was decoration.

### Antithesis Pairs (balanced for shape, not content)
- **Shape:** `X is A; Y is B.` — two clauses in matched syntax, usually with a semicolon or colon, where the symmetry is doing the persuading.
- **Why it reads as AI:** The parallel frame implies a discovered opposition; when the two halves are not genuinely opposed, the reader gets the *form* of an insight with none of its substance.
- **Specimens:**
  1. "A type is a promise; a test is a constraint."
  2. "Documentation describes what is; comments explain why."
  3. "Products impress people; platforms empower them."
- **Repairs:**
  1. → "Types are checked before the code runs; tests are checked after." *(Keeps the balance but now the two halves differ in a real, checkable way.)*
  2. → Keep — this one is close to true and useful; tighten to "Docs say what, comments say why."
  3. → Cut. It is a slogan with no referent. Replace with the concrete claim you had in mind, or nothing.
- **Detection cue:** Semicolon-joined clauses whose two halves have the same word count ±2 and the same POS skeleton (`DET N V DET N`). *(needs POS for the skeleton match; the semicolon + length symmetry is a cheap proxy.)* Also scan for noun-pair slogans in which both nouns are abstractions and neither clause contains a concrete detail.
- **Earned use:** **The swap test.** Exchange the two predicates. If the sentence is *also* plausible reversed ("A type is a constraint; a test is a promise" — arguably truer), the antithesis is decorative and the symmetry is faking a distinction. Keep antithesis only when reversal produces something obviously false. Second test: at least one half must contain a fact.

### Chiasmus / Mirrored Metaphor
- **Shape:** `A of B is not B of A.` · `We shape our X; thereafter our X shapes us.` · `The map is not the territory; the territory is not the map.`
- **Why it reads as AI:** Chiasmus is a memorable-quote shape; a model reaches for it when it wants a line to *feel* quotable, and the second limb is frequently a tautology or an inversion that means nothing.
- **Specimens:**
  1. "The map is not the territory; the territory is not the map." *(The second limb is empty — it restates the first.)*
  2. "We build the tools, and then the tools build us."
  3. "Code you don't write is code you don't maintain."
- **Repairs:**
  1. → "The map is not the territory." *(Half the words, all the meaning.)*
  2. → Keep if you then show one way the tools changed the team. Cut if not.
  3. → Keep. This one is a real claim with a real mechanism, and the mirror is doing the compression.
- **Detection cue:** Look for a repeated content-word pair in reversed order across a semicolon, comma, or `and then`. Approximate finder: two clauses sharing ≥ 2 content lemmas where their order inverts.
  ```regex
  \b(\w{4,})\b[^.;\n]{0,40}\b(\w{4,})\b\s*[;,—–]\s*(?:\w+\s+){0,3}\b\2\b[^.\n]{0,40}\b\1\b
  ```
- **Earned use:** **The asymmetry test.** The second limb must assert something the first does not. If reversing the terms produces a restatement rather than a new claim, cut the second limb and keep the first. Chiasmus is earned roughly once per essay, and only for the single line you most want remembered.

---

# PART III — BALANCE AND ENUMERATION SHAPES

### Tricolon (rule of three)
- **Shape:** three coordinated items — adjectives, noun phrases, or clauses — where two would carry the content.
- **Why it reads as AI:** The third slot gets filled by whatever word is statistically adjacent rather than by a third real thing, so the list gains a beat and loses precision.
- **Specimens:**
  1. "The result is faster, cleaner, and more maintainable code."
  2. "This approach improves reliability, reduces cost, and simplifies onboarding."
  3. "We need better tooling, clearer ownership, and stronger conventions."
- **Repairs:**
  1. → "The result is 40% less code and one fewer service to run." *(Two concrete things beat three adjectives.)*
  2. → "It cut our on-call pages roughly in half." *(Pick the one that matters; drop the other two.)*
  3. → "Nobody owns the deploy pipeline. That's the whole problem." *(One item, sharpened.)*
- **Detection cue:** the Oxford-comma triple, especially with all-abstract or all-adjectival members:
  ```regex
  \b(\w+(?:\s\w+){0,2}),\s+(\w+(?:\s\w+){0,2}),\s+and\s+(\w+(?:\s\w+){0,2})\b
  ```
  Then apply the tests below. Also flag **stacked tricolons**: two or more triples within three sentences is always wrong.
- **Earned use:** **The third-item test** — does the third element *surprise*, or does it complete? Aristotle's *veni, vidi, vici* escalates: seeing, then conquering. "Faster, cleaner, more maintainable" does not escalate; it pads. Keep the triple when (a) the third item is the strongest or the funniest, (b) you are naming three things that genuinely exist and can be counted, or (c) the passage is deliberately incantatory. Cut to two by default — **two is the least AI-sounding list length**, because models rarely produce it.

### Asyndeton (three clauses joined by commas, no conjunction)
- **Shape:** `Clause, clause, clause.` — no *and*.
- **Why it reads as AI:** Asyndeton is a high-intensity figure that models deploy at low intensity, producing a breathless cadence that the content does not justify.
- **Specimens:**
  1. "The build breaks, the tests hang, the deploy rolls back."
  2. "You write the migration, you run it in staging, you pray."
  3. "It's fast, it's cheap, it's wrong."
- **Repairs:**
  1. → "The build breaks. The tests hang. Then the deploy rolls back on its own." *(Full stops give each item weight; the last one gets a detail.)*
  2. → Keep — the escalation to "pray" earns the acceleration.
  3. → "It's fast and cheap and wrong." *(Polysyndeton reads more human here.)* Or just "It's wrong, but it's fast."
- **Detection cue:**
  ```regex
  [^.!?\n]{6,60},\s+[^.!?,\n]{6,60},\s+[^.!?,\n]{6,60}[.!?]
  ```
  restricted to cases where each segment contains a finite verb *(needs POS to do well)*.
- **Earned use:** Earned when the content is genuinely accelerating — a cascade, a rush, a list of things happening at once — and the last item lands hardest. Unearned when the three items are merely coordinate and could equally take an *and*. Test: **insert "and" before the last item.** If nothing is lost, the asyndeton was decorative; use the *and*.

### The Appositive Stack
- **Shape:** `X, the thing that does Y, the reason Z works, is …` — two or more appositives before the main verb.
- **Why it reads as AI:** It front-loads every qualification the model can think of, suspending the predicate so long that the sentence becomes a definition looking for a verb.
- **Specimens:**
  1. "The scheduler, the component that assigns work to nodes, the piece that makes the whole cluster feel responsive, is where the latency comes from."
  2. "Redis, an in-memory store, a tool most teams already run, is the obvious choice here."
- **Repairs:**
  1. → "The latency is in the scheduler — the thing that hands work to nodes." *(One appositive, and the predicate arrives first.)*
  2. → "Use Redis. Most teams already run it."
- **Detection cue:** count comma-delimited nominal phrases between the subject and the main verb. Two or more is a flag. Also flag any sentence where more than ~15 words separate the subject head from its finite verb *(needs POS)*.
- **Earned use:** **One appositive, earning its keep by being necessary.** Keep the appositive when the reader genuinely may not know the referent. Cut the second one always — the second appositive is never information the reader needed *before* the verb; move it to its own sentence or delete it.

---

# PART IV — EMPHASIS AND RHYTHM SHAPES

### Fragment as Punchline
- **Shape:** A verbless (or subjectless) fragment following a full sentence, used for emphasis. *"Every time." · "By design." · "That's the whole game." · "Always."*
- **Why it reads as AI:** The fragment mimics the cadence of a hard-won conclusion, and models attach it to conclusions that were not hard-won, so the emphasis has nothing under it.
- **Specimens:**
  1. "The migration will fail on the first run. Every time."
  2. "It's not an accident that the API is annoying. By design."
  3. "You can't cache your way out of a bad query. That's the whole game."
- **Repairs:**
  1. → "The migration fails on the first run — it always has, on every environment we've tried." *(Or keep it; see the test.)*
  2. → "The API is annoying on purpose: they want you on the SDK."
  3. → "You can't cache your way out of a bad query." *(Delete the punchline; the sentence was already the punchline.)*
- **Detection cue:** sentences with no finite verb *(needs POS)*, and a small closed list of stock closers:
  ```regex
  (?m)(?<=[.!?]\s)(?:Every time|Always|Never|By design|That'?s the (?:whole )?(?:game|point|trick)|Full stop|Period|Not even close|Exactly|Both\.)[.!]
  ```
- **Earned use:** **The one-per-piece rule, plus the surprise test.** A fragment is earned when it delivers information the preceding sentence did not — "Every time" adds universality; "That's the whole game" adds nothing. Rule of thumb: *fragments that add a quantifier or a scope are usually earned; fragments that add an evaluation are usually not.* And: if there are two fragments in a piece, delete the weaker; if there are three, the writer has a tic regardless of individual merit.

### Inverted Emphasis (cleft sentences)
- **Shape:** `What makes X work is Y.` · `What matters here is Z.` · `Where this breaks down is at the boundary.` · `It's Y that does the work.` · `The reason X is Y.`
- **Why it reads as AI:** Clefts exist to mark focus against a *given* background; models use them to open cold, where nothing is given yet, so the emphasis machinery spins with no load.
- **Specimens:**
  1. "What makes this design work is the separation between read and write paths."
  2. "Where the complexity actually lives is in the retry logic."
  3. "It's the migration order that causes the deadlock."
- **Repairs:**
  1. → "This design works because reads and writes are separate." *(11 words → 8, and the causal verb is explicit.)*
  2. → "The complexity is in the retry logic." *(Unless the reader has just guessed wrong about where it is — see the test.)*
  3. → Keep. The cleft is doing real work: it corrects an expectation that something else caused the deadlock.
- **Detection cue:**
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:What|Where|Why|How|The (?:reason|thing|point|question|problem))\b[^.!?\n]{5,80}\b(?:is|was|are|were)\b
  ```
  plus `\bIt'?s\s+[^.!?\n]{2,50}\s+that\b`.
  Count clefts per 1,000 words; more than ~2 is a habit, not a choice.
- **Earned use:** **The given-information test** (the strongest test in this catalog, and it comes straight from information structure). Everything *before* the "is" must already be in the reader's head. In "What makes this design work is X," the reader must already be wondering *why the design works*. If they aren't — if the question is being invented by the cleft itself — the construction is unearned. Operational version: **delete everything before "is" and see whether the sentence still makes sense in context.** If it does, the cleft added nothing; use the plain sentence. If deleting it strands the reader, the cleft was carrying real given-new structure. Keep it.

### The Rhetorical Question + Immediate Answer
- **Shape:** `The result? Devastating.` · `Why does this matter? Because X.` · `So what changed? Everything.`
- **Why it reads as AI:** It fabricates a dialogue with a reader who asked nothing, and the "answer" is almost always shorter and vaguer than the question implied.
- **Specimens:**
  1. "The result? A 40% drop in build times."
  2. "So why does anyone still use it? Inertia."
  3. "What's the fix? Better tests."
- **Repairs:**
  1. → "Build times dropped 40%."
  2. → Keep if the piece has been building to the puzzle of why it survives. Otherwise: "People still use it out of inertia."
  3. → "The fix is better tests." *(And then, ideally, say which tests — the shape was hiding the vagueness.)*
- **Detection cue:**
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:The\s+\w+|So\s+what|Why|What|How|And\s+then)\??[^.!?\n]{0,40}\?\s+[^.!?\n]{1,60}[.!]
  ```
  narrowed to cases where the answer is under ~8 words.
- **Earned use:** Earned when the question is one the reader **is actually asking at that moment** — you have set up a genuine puzzle in the preceding paragraph and are now paying it off. Test: **could you delete the question and start with the answer?** If yes (nearly always), delete. Budget: one per piece, and put it where the tension is highest.

### Trailing Adverb for Rhythm
- **Shape:** a sentence-final adverb or short adverbial that adds cadence and no content: `…, quietly.` · `…, mostly.` · `…, always.` · `…, eventually.` · `…, by design.` · `…, at scale.`
- **Why it reads as AI:** The adverb is a syllable count, added to give the sentence a falling close, and it usually hedges or inflates a claim the writer did not want to defend precisely.
- **Specimens:**
  1. "The retry logic doubles your write load, quietly."
  2. "That assumption breaks, eventually."
  3. "The abstraction leaks, predictably."
- **Repairs:**
  1. → "The retry logic doubles your write load, and nothing in the metrics shows it." *(Say what "quietly" meant.)*
  2. → "That assumption breaks the first time two writes land in the same millisecond."
  3. → "The abstraction leaks." *(Or name the leak.)*
- **Detection cue:**
  ```regex
  ,\s*(?:quietly|slowly|eventually|inevitably|predictably|mostly|always|entirely|precisely|necessarily|automatically|deliberately|permanently|instantly)\s*[.!]
  ```
  Also flag sentence-final `, by design.` / `, at scale.` / `, in practice.`
- **Earned use:** Earned when the adverb is **contrastive** — it corrects an expectation the sentence just created ("The retry logic doubles your write load, *silently*" is earned only if the reader expected an alarm). Unearned when it merely intensifies. Test: **would you accept the adverb in the middle of the sentence?** "The retry logic quietly doubles your write load" — if the mid-position version feels redundant, the adverb was rhythm, not meaning.

---

# PART V — ATTACHMENT AND TAIL SHAPES

### Participial Tail (the "-ing" coda)
- **Shape:** `[full sentence], [V-ing] + [restatement of the sentence's significance].`
- **Why it reads as AI:** The tail is a significance-generator — it converts a stated fact into a stated fact plus an assertion that the fact matters, without adding any new fact.
- **Specimens:**
  1. "We moved the queue behind an interface, making it easier to swap implementations later."
  2. "The team adopted trunk-based development, reducing merge conflicts and improving velocity."
  3. "Paris hosts dozens of galleries, underscoring its role as a cultural hub."
- **Repairs:**
  1. → "We put the queue behind an interface so we can swap SQS for Kafka without touching callers." *(The purpose becomes explicit and specific.)*
  2. → "We moved to trunk-based development. Merge conflicts dropped from ~5 a week to almost none."  *(The tail becomes evidence.)*
  3. → "Paris has dozens of galleries." *(Delete the tail entirely; it asserted only that the fact was significant.)*
- **Detection cue:** highest-precision regex in this section — a comma followed by an `-ing` verb from the evaluative set:
  ```regex
  ,\s+(?:making|creating|ensuring|allowing|enabling|providing|highlighting|underscoring|showcasing|emphasizing|reflecting|demonstrating|reinforcing|contributing|helping|offering|resulting|leading|leaving|giving|adding|improving|reducing|increasing)\b
  ```
  Then triage: does the tail introduce a *new fact* or restate significance?
- **Earned use:** **The new-fact test.** A participial tail is earned when it reports a distinct event or a simultaneous action ("The deploy hung, taking the read replicas with it") — that is a second thing that happened. It is unearned when it reports the *importance* of what precedes ("…, making it more maintainable"). Rule: **tails that narrate are fine; tails that evaluate are cut.** Also cap the count: more than ~3 per 1,000 words is a habit, and two in one sentence is always wrong.

### Comma-Clipped Trailing Phrase
- **Shape:** `[main clause], [short dangling nominal or phrase].` — a two-to-four-word tail hung off a comma instead of landing in the sentence.
- **Why it reads as AI:** It produces a decelerating, trailing-off cadence that reads as thoughtful, but the tail is grammatically stranded and semantically parasitic.
- **Specimens:**
  1. "He'd been asked the same question forty times, mentoring."
  2. "You add the header above the content, and save."
  3. "The whole thing runs in CI now, nightly."
- **Repairs:**
  1. → "He'd mentored enough juniors to have been asked that question forty times."
  2. → "Add the header above the content, then save."
  3. → "It runs nightly in CI."
- **Detection cue:** a comma near end-of-sentence followed by ≤ 4 words with no finite verb *(needs POS)*. Cheap proxy: `,\s+\w+(?:\s+\w+){0,2}[.]` where the tail contains no verb from a stoplist.
- **Earned use:** Rarely earned in expository prose; it is a fiction device. Keep only when the tail is a genuine afterthought whose delay is the point, and never more than once in a piece.

### Noun-Heavy / Verb-Light Sentences
- **Shape:** the action lives in nominalizations; the verb is `is`, `has`, `provides`, `serves as`, `represents`, `constitutes`.
- **Why it reads as AI:** Nominalizing the action lets the sentence stay agnostic about who did it and whether it worked — Helen Sword's "zombie nouns," which "cannibalize active verbs… and substitute abstract entities for human beings."
- **Specimens:**
  1. "The implementation of the caching layer resulted in a reduction in latency."
  2. "This module serves as an abstraction over the storage backend."
  3. "There is a requirement for validation at the boundary."
- **Repairs:**
  1. → "Caching cut latency in half."
  2. → "This module wraps the storage backend."
  3. → "Validate at the boundary."
- **Detection cue:** count `-tion|-ment|-ance|-ence|-ity|-ness` nouns per sentence (≥ 2 is a flag) alongside a copular or light verb. Plus the "serves as" family:
  ```regex
  \b(?:serves? as|stands? as|acts? as|functions? as|represents?|constitutes?|marks?|embodies)\b
  ```
- **Earned use:** Nominalization is earned when the *concept* is the topic ("Normalization is expensive" — you're talking about normalization as a thing, not an event). Unearned when it hides an event with an actor. Test: **ask "who did what?"** If the sentence can't answer and the answer matters, un-nominalize.

---

# PART VI — CONNECTIVE AND PUNCTUATION SHAPES

### The Default Em Dash (apposition as connective)
- **Shape:** `Clause — restatement or qualification of that clause.` used wherever a comma, period, colon, or nothing would serve.
- **Why it reads as AI:** The em dash is a *rupture* mark; using it as the general-purpose joiner flattens every relation between clauses into the same gesture of dramatic aside.
- **Specimens:**
  1. "The cache is fine — the invalidation is the problem."
  2. "We shipped it Friday — a decision I'd make again — and nothing broke."
  3. "Types help — a lot."
- **Repairs:**
  1. → "The cache is fine. The invalidation is the problem." *(Full stop is stronger; the contrast survives.)*
  2. → Keep. This is real interruption: the aside genuinely interrupts, and the sentence resumes.
  3. → "Types help a lot."
- **Detection cue:** count em dashes per 1,000 words and per paragraph. Two in one sentence without them forming a matched pair is a flag; more than one paragraph in three containing an em dash is a habit. Note carefully: **em-dash frequency alone is not evidence of authorship** — it correlates with explanatory register, and the panic about it has pushed some human writers to avoid a good mark entirely.
  ```regex
  [—–]
  ```
  (Count, don't match. Then check pairing.)
- **Earned use:** **The three-way test.** For each em dash, ask which mark it is standing in for:
  - *Matched pair around a genuine interruption* → keep. This is what em dashes are for.
  - *Standing in for a colon* (the second half explains or lists) → use the colon.
  - *Standing in for a period* (the second half is a new assertion) → use the period. **This is the AI default and the most common repair.**
  - *Standing in for a comma* (the second half is a mere continuation) → use the comma or nothing.
  Budget 2–3 per 1,000 words, and prefer that at least one be a matched pair.

### The Colon Reveal
- **Shape:** `[Setup]: [payoff]` — often `Here's the thing:` / `The result:` / `And that's the catch:`
- **Why it reads as AI:** The colon promises a reveal; models spend the promise on a payoff that was already implied by the setup, so the reader pays attention and gets change.
- **Specimens:**
  1. "The result: a 40% reduction in build times."
  2. "Here's what nobody tells you about distributed systems: they're hard."
  3. "The tradeoff is simple: latency for consistency."
- **Repairs:**
  1. → "Build times dropped 40%." *(Colon-elision of causation is its own tic: "The result: X, Y, Z" avoids saying why.)*
  2. → Cut the setup entirely; if the payoff is a cliché, the setup makes it worse.
  3. → Keep. Both halves carry weight and the colon is doing real work.
- **Detection cue:**
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:Here'?s (?:the thing|what|why)|The (?:result|catch|problem|point|kicker|upshot)|And that'?s (?:the|why))\b[^.\n]{0,40}:
  ```
- **Earned use:** **Both halves must carry weight.** The setup must contain information (not just "Here's the thing"), and the payoff must be something the setup did not already imply. Test: **read only the text after the colon.** If it stands alone and loses nothing, the setup was throat-clearing.

### Colon-Then-Restatement (the tautological colon)
- **Shape:** `[Claim]: [the same claim in different words].`
- **Why it reads as AI:** The colon's grammar of elaboration is used for repetition, so the sentence performs explanation while explaining nothing.
- **Specimens:**
  1. "The answer is simple: it's simple."
  2. "The problem is architectural: it's a problem with the architecture."
  3. "There's one rule: keep it simple."
- **Repairs:**
  1. → Delete, or state the answer.
  2. → "The problem is that every service reads the same table."
  3. → Keep if "keep it simple" is the actual rule you then apply. Cut if it's a slogan.
- **Detection cue:** compute lexical overlap between the two sides of a colon. High content-word overlap (≥ 50%) or a shared head noun with no new content on the right is the signature. No regex; this needs a similarity check.
- **Earned use:** Earned only when the right side *specifies* — moves from category to instance, or from abstract to concrete. If the right side is the same abstraction re-lexicalized, cut.

---

# PART VII — RESTATEMENT MOVES

### The Explicit Restatement Marker
- **Shape:** `Which is to say, …` · `Put another way, …` · `In other words, …` · `Or: …` · `To put it differently, …`
- **Why it reads as AI:** The marker announces that clarification is coming, which means the previous sentence failed — and the "clarification" is usually the same abstraction at a different altitude, so nothing is clarified.
- **Specimens:**
  1. "The system is eventually consistent. In other words, reads may be stale."
  2. "The abstraction leaks. Which is to say, you can't ignore what's underneath."
  3. "Ownership is diffuse. Put another way, nobody owns it."
- **Repairs:**
  1. → "The system is eventually consistent: a read right after a write can return the old value." *(Merge and specify — the restatement becomes the sentence.)*
  2. → "You can't ignore what's underneath the abstraction." *(Keep only the clearer version. Almost always the second one.)*
  3. → "Nobody owns it." *(Same.)*
- **Detection cue:**
  ```regex
  (?m)(?:^|(?<=[.!?]\s))(?:In other words|Which is to say|Put another way|To put (?:it|this) (?:another way|differently)|That is to say|Or, more precisely|Said differently|Another way to (?:say|put) (?:it|this))\b
  ```
  This one is safe to flag aggressively — the phrases are near-fixed.
- **Earned use:** **Keep the better sentence and delete the other.** A restatement is earned only when the two formulations are genuinely different *tools* — e.g. a formal statement followed by an intuitive gloss, where a reader might need either one. That is rare in short prose and common in teaching prose. Default action: **merge.** Budget: one per piece.

### The "Serves As" Dodge
- Covered under §Noun-Heavy above; listed here because it is a restatement move as much as a nominalization one. `X serves as Y` is almost always `X is Y` with a formality tax, and often `X is Y` is itself a dodge for `X does Z`.

---

# PART VIII — DISTRIBUTIONAL PROPERTIES

*These are not sentence patterns; they are properties of the sequence of sentences. They are measurable and they are the layer most editing passes miss.*

### 8.1 Sentence-Length Uniformity
- **Shape:** sentence lengths clustered in a narrow band (commonly ~14–24 words), with few very short and few very long sentences, and — critically — **few adjacent large jumps**.
- **Why it reads as AI:** The reader's ear entrains to a fixed period; human prose varies as the writer's thinking varies, and the absence of variation reads as an absence of thinking.
- **What the research actually supports:**
  - **Peer-reviewed and solid:** LLM-regenerated text shows *narrower distributions than human text across every syntactic metric tested* — Flesch-Kincaid, dependency-tag diversity, parse depth, Yngve (branching) scores, constituency-label counts — with notably **thinner right tails**, i.e. the rare-but-valid constructions go missing. This held across model families and sizes (Llama, Mistral), suggesting a general property rather than a model quirk. Related work finds LLM summaries have shallower syntactic structures and lower lexical diversity than human summaries, and that LLM-mediated writing reduces linguistic diversity in aggregate.
  - **Folk metric, treat with suspicion:** the AI-detector industry's "burstiness" = `stdev(sentence_length) / mean(sentence_length)` (i.e. coefficient of variation), with claimed human range 0.65–0.85 and "flagged" below 0.30. These thresholds come from vendor marketing, not from peer review, and detection research (Counter Turing Test) reports that newer models' output is close to statistically indistinguishable on exactly these measures. **Do not target a burstiness number.** Use the metric diagnostically, never as an objective.
- **Detection cue — three measurements worth running:**
  1. **Coefficient of variation** of sentence length over the piece. Below ~0.4 is worth a look. It is a smell, not a verdict.
  2. **The run test (most useful):** flag any span of **three or more consecutive sentences whose lengths are within ±3 words of each other**. This catches the actual perceptual problem — local monotony — which the global CV hides.
  3. **The extremes test:** in any 10-sentence window, is there at least one sentence under 8 words and at least one over 28? If not, the passage has no dynamic range.
- **Repairs:** Do not "add variety." Vary length *for a reason*: split a compound sentence where the two halves are genuinely separate claims; merge two sentences that are one thought; and let a genuinely emphatic point be short. Fixing rhythm by inserting decorative fragments just swaps one tic for another.
- **Earned use:** Uniform length is earned in reference material, API docs, procedure lists, and legal or spec text, where predictable rhythm aids scanning and variation reads as noise. It is unearned in anything argumentative or narrative.

### 8.2 Opener Uniformity
- **Shape:** consecutive sentences beginning with the same syntactic slot — most often `The + noun`, a sentence-initial adverbial disjunct (`Crucially,` `Notably,` `In practice,`), or a gerund subject (`Building X requires…`).
- **Why it reads as AI:** Models sample openers from a narrow prior; humans start sentences with pronouns, conjunctions, prepositional phrases, and bare verbs far more often. Detectors note that AI "avoids starting sentences with *And* or *But*."
- **Detection cue:** tabulate the first two tokens of every sentence. Flag: (a) any first-token repeated in ≥ 40% of sentences; (b) three consecutive sentences opening `The`; (c) zero sentences in the piece opening with a conjunction, when the register permits them.
- **Repairs:** Invert one sentence to lead with its adverbial. Start one with *But* or *And*. Lead one with the object. Do this to about one sentence in five, not to all of them.
- **Earned use:** Repeated openers are earned as **anaphora** when the repetition is the point and the run is bounded (three, then stop) — "We tried X. We tried Y. We tried Z." Unearned when it is accidental.

### 8.3 Anaphora Abuse
- **Shape:** identical sentence openings repeated in quick succession — "They assume… They assume… They could… They could…"
- **Why it reads as AI:** The model has found a productive frame and keeps filling it; the repetition is a generation artifact, not an emphasis choice.
- **Specimens:** "They assume users will pay. They assume developers will build. They assume the market exists."
- **Repairs:** "They're assuming three things at once: that users will pay, that developers will build, and that the market exists — and the third one is the load-bearing assumption." *(Or keep the anaphora and cut it to two, then break the pattern hard on the third.)*
- **Detection cue:** ≥ 3 consecutive sentences sharing their first 2–3 tokens.
- **Earned use:** Earned when the repetition builds and then **breaks** — the power of anaphora is in the departure. Three repetitions maximum, and the fourth sentence must differ structurally.

### 8.4 The 4-Beat Paragraph
- **Shape:** paragraph after paragraph following `frame → expand → contrast → resolve`, with the contrast usually a `But`/`Yet` and the resolution a summary sentence.
- **Why it reads as AI:** It is the model's default paragraph prior; individually invisible, but four paragraphs in a row with the same internal arc is a metronome.
- **Detection cue:** per paragraph, note whether it contains a mid-paragraph contrastive conjunction and a final summarizing sentence. Flag when ≥ 3 consecutive paragraphs share the profile. Also flag **paragraph-length uniformity** (all paragraphs within ±1 sentence of each other).
- **Repairs:** Delete the resolution sentence from two of the four paragraphs — the reader can resolve. Let one paragraph end mid-argument. Let one paragraph be one sentence long.
- **Earned use:** Earned once or twice per piece; it is a good paragraph shape. It is the *repetition* that is the tic. (This straddles the syntax/document-structure boundary; flagged here because the cue is clause-level.)

---

# PART IX — COMPOSITE SIGNATURES

The patterns above rarely appear alone. These recurring *combinations* are the strongest signal, and worth detecting as units.

### 9.1 The Closing Cadence
`[long sentence with an em-dash aside] + [short declarative] + [fragment or Terminal Beat].`

> "We moved the queue behind an interface — a change that took two days and touched forty files — and the migration went cleanly. The pattern held. Every time."

This three-beat descent is the single most recognizable AI paragraph ending. **Repair: keep one of the three closers.** Usually the long sentence, with a period where the em dash was.

### 9.2 The Insight Sandwich
`[rhetorical question] + [negative parallelism] + [tricolon].`

> "So what actually went wrong? It wasn't a technical failure — it was an organizational one. We lacked ownership, clarity, and accountability."

Three devices, zero facts. **Repair: replace all three with the one fact you have.** "Nobody had been on-call for that service in four months."

### 9.3 The Agentless Argument
`Animacy stacking (§1.6) + Tier-2 evaluative agency + participial evaluative tails.`

> "The architecture separates concerns cleanly, making the system easier to reason about. The separation earns its complexity. The design holds."

Nobody appears; nothing is measured; three shapes agree with each other. **Repair: put a person and a number in the first sentence and delete the other two.**

### 9.4 Density rule of thumb
If a 200-word passage contains **three or more** distinct patterns from this catalog, the passage reads as AI-written *even if every instance individually passes its earned-use test.* At that density, edit for subtraction: keep the single best figure and make the rest plain. This is the most important operational rule in the file.

---

# PART X — WHAT NOT TO DO

Failure modes of a deslopifying pass, ranked by how much damage they cause:

1. **Flattening.** Removing every figure produces uniform, mid-length, subject-verb-object prose — which is itself a recognizable machine register (and scores *worse* on §8.1). Variance must increase.
2. **Breaking Tier-0 metonymy.** "The parser rejects malformed input" is correct, idiomatic technical English. An editor that rewrites it to name a human has made the document wrong. **Protect Tier 0 explicitly.**
3. **Em-dash panic.** Deleting all em dashes to avoid a detector is capitulation to a bad heuristic; the mark is good and the matched-pair interruption should survive.
4. **Substituting one tic for another.** Replacing every em dash with a semicolon, every tricolon with a pair, every fragment with a full clause — mechanical substitution leaves a mechanical text.
5. **Rewriting instead of cutting.** For most patterns here, the best repair is deletion. The sentence that was pure cadence should go, not get rebuilt.
6. **Editing to a detector score.** The detection literature's own conclusion is that these statistics no longer separate the classes reliably. Edit for the reader.

---

## Appendix: Sources and confidence

**Peer-reviewed / academic (high confidence):**
- *Domain Regeneration: How well do LLMs match syntactic properties of text domains?* — arXiv 2505.07784. Narrower distributions and thinner right tails across FK, dependency tags, parse depth, Yngve scores, constituency labels; consistent across Llama/Mistral families and sizes. **The strongest empirical support for §8.1.**
- *Stylometry recognizes human and LLM-generated texts in short samples* — arXiv 2507.00838 / Expert Systems with Applications. Syntactic + punctuation features separate classes in short samples.
- *The Shrinking Landscape of Linguistic Diversity in the Age of LLMs* — arXiv 2502.11266. Aggregate diversity reduction from LLM-mediated writing.
- *Counter Turing Test (CT²)* — arXiv 2310.05030. Perplexity/burstiness detection degrades sharply for newer models. **The reason not to target a burstiness score.**
- Peter Master's corpus study (~3,000 subject–verb pairs in scientific prose): inanimate-subject active constructions outnumber passives in English scientific writing. **The license for Tier 0.**
- Halliday on grammatical metaphor; animacy-hierarchy literature (Wikipedia *Animacy*; corpus work on animacy within inanimate nouns). **The frame for Part I.**
- Helen Sword, *Zombie Nouns* (NYT / TED-Ed) — nominalization critique; "substitute abstract entities for human beings."

**Practitioner catalogs (useful, unvalidated):**
- tropes.fyi / `tropes.md` (Ossama Chaib, 2026) — 6 categories; sentence-structure entries include Negative Parallelism, Rule of Three, "Not X. Not Y. Just Z.", "The X? A Y.", Anaphora Abuse, Comma-clipped Trailing Phrase, Superficial Analyses (-ing tails), False Ranges, the "Serves As" Dodge.
- Colin Gorrie, *Why ChatGPT writes like that* (Dead Language Society) — parallelism, antithesis, tricolon, ascending tricolon; notes LLMs use only the *explicit-negation* form of antithesis, avoiding subtler implicit contrast.
- *The internet made a ban list for AI writing. I'm making a case for the defense* (robotsatemyhomework) — **the best source for earned-use tests**; supplies the given-information test for clefts, the third-item-surprise test for tricolon, the mistaken-reader test for binary contrast, and the Master citation for inanimate agency.
- STRYNG, Bloomberry, Pangram, Proofed — pattern lists; Bloomberry's 4-beat paragraph progression is the source for §8.4.

**Vendor/marketing (low confidence — cited only to be explicitly discounted):**
- Burstiness thresholds (human 0.65–0.85, flagged < 0.30) from AI-humanizer blogs. Not peer-reviewed. Used here as a diagnostic smell only.

**Frequency claims worth repeating with care:**
- Negative parallelism at roughly 3× human base rate.
- Variants of "not just X, but Y" in ~6% of messages in one large deployment corpus (Washington Post dataset).
Both are suggestive of magnitude, not precise.
