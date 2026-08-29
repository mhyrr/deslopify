# The Lexical Layer of LLM Slop — a catalog for `/deslopify`

Scope: individual words, collocations, short fixed phrases. Sentence architecture and
document architecture are covered by sibling research and are deliberately excluded here,
except where a fixed phrase is the lexical handle on a structural pattern (noted inline).

---

## 0. How to read this catalog

### Evidence grades

Every claim below carries one of three grades. Do not treat them as equivalent.

- **[V] VERIFIED** — measured in a corpus study with a published frequency delta. Cited with URL.
- **[C] CURATED** — appears on a published, maintained banlist compiled by editors or practitioners.
  Real evidence of *perception*, not of frequency. Cited with URL.
- **[A] ASSERTED** — my own report of my generation tendencies, or inference from the above.
  No external backing. Treat as a hypothesis a corpus check could falsify.

### The three tiers

- **TIER 1 — cut on sight.** The word is doing decorative work in ~95% of its appearances.
  A single instance is already a tell. `/deslopify` should rewrite without asking.
- **TIER 2 — context-dependent.** The word has a real technical or precise sense. It is slop
  when used as a general-purpose booster, legitimate when the precise sense is meant.
  `/deslopify` should flag and ask, or apply the disambiguation test given in the entry.
- **TIER 3 — frequency tic.** Any one use is unremarkable. Density is the signal.
  `/deslopify` should count, not judge individual instances.

### Density thresholds for Tier 3

Empirically anchored where possible:

| Signal | Threshold | Grade | Source |
|---|---|---|---|
| Flagged style words | >3 per 500 words | [C] | slopdetector.org |
| Inflated corporate verbs | >1 per 300 words | [C] | slopdetector.org |
| Empty-opener clichés | ≥2 per 500 words | [C] | slopdetector.org |
| Paragraphs opening with a formal transition | >50% | [C] | slopdetector.org |
| Em dashes | see §J1 — sources disagree | [V] | Freeburg 2026 / slopdetector |
| "Not just X, it's Y" | ≥3 per article | [C] | slopdetector.org |

### The synonym-swap trap — read before implementing

The single most important design constraint on `/deslopify`. From the explainx.ai analysis
of Claude tics [C]:

> "Swap 'load-bearing' for 'central' by hand across an essay and you get something worse
> than the tic: prose that reads as stitched, the same idea wearing a different coat in
> every paragraph, none of the coats chosen by the writer."

A lexical substitution table applied mechanically produces *thesaurus slop*, which reads
worse than the original because it has the same skeleton with less confident flesh. Every
**Repair** field below rewrites the clause, not the word. Where the honest repair is
"delete the sentence," it says so. `/deslopify` should prefer deletion and clause-recasting
over one-for-one substitution, and should never rotate synonyms to avoid repetition —
synonym cycling is itself a documented tell [C].

### Register modifiers

The same word carries different risk by context. Adapted from the `avoid-ai-writing` skill's
context profiles [C]:

- **technical docs / API reference** — `robust`, `comprehensive`, `seamless`, `ecosystem`,
  `leverage`, `facilitate`, `streamline`, `framework` are often literal. Downgrade one tier.
- **marketing / landing page** — corporate verbs are native to the genre but that is exactly
  why they read as filler. Hold at listed tier; the genre's own conventions are the slop.
- **academic abstract** — highest-risk register. The PubMed studies measured excess vocabulary
  *here*. Upgrade Tier 2 → Tier 1 for `delve`, `underscore`, `showcase`, `pivotal`, `meticulous`.
- **casual / personal** — P0 items only (sycophancy, vague attribution, cutoff disclaimers).
  Aggressive lexical editing destroys voice.

---

## 1. Sources and what each one actually establishes

**[V] Kobak, González-Márquez, Horvát & Lause — "Delving into LLM-assisted writing in
biomedical publications through excess vocabulary."** *Science Advances* (2025).
<https://www.science.org/doi/10.1126/sciadv.adt3813> · preprint
<https://arxiv.org/html/2406.07016v1> · PMC <https://pmc.ncbi.nlm.nih.gov/articles/PMC12219543/>

The strongest evidence in the field. 15M+ PubMed abstracts, 2010–2024, using an
excess-mortality-style counterfactual. Findings I verified from the text:

- 379 excess style words in 2024; **66% verbs, 14% adjectives**. This is the key structural
  finding: *LLM vocabulary drift is verb-and-adjective drift, not noun drift.* The COVID-era
  vocabulary shift, by contrast, was noun-dominated (`coronavirus`, `pandemic`, `lockdown`).
  A vocabulary shift made of style words with no content is the fingerprint.
- Top frequency *ratios* (rare words that exploded): `delves` r=28.0, `underscores` r=13.8,
  `showcasing` r=10.7.
- Top frequency *gaps* (common words with the largest absolute rise): `potential` δ=0.052,
  `findings` δ=0.041, `crucial` δ=0.037.
- The 10-word set that maximizes combined detection power: **across, additionally,
  comprehensive, crucial, enhancing, exhibited, insights, notably, particularly, within.**
  Note how mundane these are. The high-detection set is *not* `tapestry` and `delve`. This
  matters enormously for `/deslopify` design and is the most under-appreciated finding.
- Lower bound: ≥13.5% of 2024 abstracts LLM-processed, up to 40% in some subcorpora.

**[V] "Delving Into PubMed Records: How AI-Influenced Vocabulary has Transformed Medical
Writing since ChatGPT."** *Perspectives on Medical Education*.
<https://pmejournal.org/articles/10.5334/pme.1929>

135 candidate terms tracked; **103 of 135 showed meaningful increases (modified Z-score ≥3.5)
by 2024**. Largest increases: `delve`, `underscore`, `primarily`, `meticulous`, `boast`.
Their full 135-term list is the backbone of families A–D below and I reproduce it in §11.

**[V] E. M. Freeburg — "The Last Fingerprint: How Markdown Training Shapes LLM Prose."**
arXiv (2026). <https://arxiv.org/html/2603.27006v1>

Measured em dashes per 1,000 words. Human baseline mean **3.23** (range 0.33–17.12, n=57,232
words across eight published essays). Model rates unconstrained → prose-constrained:
GPT-4.1 **10.62 → 9.10** (and 6.97 even under *explicit* em-dash prohibition);
**Claude Opus 4.6 9.09 → 0.19**; DeepSeek V3 6.95 → 5.41; Gemini 2.5 Pro 3.53 → 0.0;
Llama 3.1/3.3 **0.0** throughout; GPT-5.4 1.43 → 0.29.
Two conclusions worth carrying: (a) em-dash density is a *model-specific* tell, not an
AI-vs-human tell — Llama at zero and Gemini at human baseline break the binary;
(b) Claude's rate collapses ~48× under instruction, meaning this is the one tic that a
system-prompt line genuinely fixes, unlike GPT-4.1's.

**[C] Wikipedia:Signs of AI writing.** <https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing>
Maintained by WikiProject AI Cleanup — editors who do this adversarially at scale, all day.
The best *curated* list in existence. Notably it versions its vocabulary by era
(2023–mid-2024 vs. mid-2024–mid-2025), which is direct evidence that **the lexicon drifts**
and any static blacklist decays.

**[C] claudisms.ai — "a living banlist of AI-writing tells."** <https://claudisms.ai/>
Claude-specific and startlingly precise. Independently contains `load-bearing`, the
entire `worth ___` family, and `the tell` — i.e. it independently confirms the user's own
seed list. Community-curated, no frequency data.

**[C] explainx.ai, "Claude Opus 5 Claudisms."**
<https://www.explainx.ai/blog/claude-opus-5-load-bearing-claudisms-writing-tells-2026>
**[C] 7minai.com, "How to Stop Claude Overusing Filler Phrases."**
<https://7minai.com/how-to-stop-claude-overusing-filler-phrases/>
Both name `load-bearing` as the flagship Claude tic; the latter also names `seam`/`seams`,
`honest take`, and `you're absolutely right`. Again: independent confirmation of the seeds.

**[C] conorbronsdon/avoid-ai-writing** (SKILL.md).
<https://github.com/conorbronsdon/avoid-ai-writing>
Prior art — an existing agent skill for this exact job. Already implements a 3-tier structure
plus P0/P1/P2 severity, voice profiles, and context profiles. Worth reading before building.

**[C] slopdetector.org** — <https://slopdetector.org/blog/signs-of-ai-writing> ·
<https://slopdetector.org/blog/em-dash-ai-tell-data>. Source of the density thresholds table.
Methodology is not peer-reviewed; its human em-dash baseline (3.7–10/1000) disagrees with
Freeburg's (3.23 mean). Treat thresholds as starting points to tune, not constants.

**[C] contentbeta.com** <https://www.contentbeta.com/blog/list-of-words-overused-by-ai/> ·
**oliviacal.com** <https://www.oliviacal.com/post/ai-writing-tells> — SEO-industry blacklists.
Low rigor, high recall; useful only for cross-checking coverage.

---

# FAMILY A — The empirical core: excess verbs

The PubMed studies found excess vocabulary is **66% verbs**. This family is therefore the
highest-yield target in the whole catalog and should be `/deslopify`'s first pass.

### delve / delve into / delving
- **Tier:** 1
- **Why it reads as AI:** The single most-measured word in the field — r=28.0 excess ratio in
  2024 PubMed abstracts, the largest of any term studied [V]. It is now a punchline; using it
  sincerely signals you were not in the room for the last three years.
- **Specimen:** "Let's delve into the tradeoffs between the two caching strategies."
- **Repair:** "Here's how the two caching strategies trade off."
- **Legitimate use:** Literal descent — "delve into the archive," a mine, a burrow. Also fine
  when you are visibly joking about the word itself. Otherwise none.

### underscore / underscores / underscoring
- **Tier:** 1
- **Why it reads as AI:** r=13.8 excess ratio [V], second only to `delve`. Ninety percent of
  its uses are "underscores the importance of," which is a sentence that announces significance
  instead of demonstrating it.
- **Specimen:** "The outage underscores the importance of circuit breakers."
- **Repair:** "The outage happened because there was no circuit breaker."
- **Legitimate use:** Typography — underscoring text, the `_` character. In prose, essentially none;
  even the honest sense ("emphasizes") is better served by showing the emphasis.

### showcase / showcasing / showcases
- **Tier:** 1
- **Why it reads as AI:** r=10.7 [V]. A trade-show word doing the job of `shows`. The extra
  two syllables buy nothing, which is the definition of decorative.
- **Specimen:** "The demo showcases the new streaming API."
- **Repair:** "The demo runs the new streaming API end to end."
- **Legitimate use:** An actual showcase — a curated exhibition, a product showcase event,
  a display case. Literal senses only.

### highlight / highlighting / emphasize / emphasizing (the -ing significance participle)
- **Tier:** 2
- **Why it reads as AI:** Wikipedia's editors list the trailing `-ing` participle
  (`highlighting`, `emphasizing`, `reflecting`, `symbolizing`, `contributing to`) as the
  signature of *superficial analysis* [C]: a clause tacked onto a fact that asserts the fact
  means something without saying what.
- **Specimen:** "Deploys dropped 40%, highlighting the value of the new CI pipeline."
- **Repair:** "Deploys dropped 40% after the new CI pipeline landed."
- **Legitimate use:** Front-position and finite — "I want to highlight one number" — is fine.
  It is the trailing participial version that is slop. Also literal highlighting in a UI.

### foster
- **Tier:** 1
- **Why it reads as AI:** On the verified 41-verb PubMed list [V] and on essentially every
  curated list [C]. Almost always paired with an abstract noun it cannot literally act on
  (`foster collaboration`, `foster innovation`, `foster a culture of`).
- **Specimen:** "Pair programming fosters a culture of shared ownership."
- **Repair:** "When two people write the code, two people can maintain it."
- **Legitimate use:** Foster care, foster parent, foster child. Literal only.

### harness
- **Tier:** 2
- **Why it reads as AI:** On the verified list [V] and in the seed set. Reaches for a
  horse-and-cart metaphor to describe using a thing. `Harness the power of` is the terminal case.
- **Specimen:** "We harness the power of vector search to surface related tickets."
- **Repair:** "We use vector search to find related tickets."
- **Legitimate use:** Real: a climbing harness, a wiring harness, a test harness (standard term
  of art in software — do not touch it), harnessing a horse, harnessing tidal energy where the
  physical capture metaphor is exact.

### leverage (verb)
- **Tier:** 1
- **Why it reads as AI:** Verified excess verb [V]; sits at the top of every curated list [C];
  named explicitly on claudisms.ai [C]. The canonical corporate-verb-for-`use`. Its own
  measured excess plus its cultural notoriety put it in Tier 1 despite a real financial sense.
- **Specimen:** "We can leverage the existing auth middleware for this endpoint."
- **Repair:** "The existing auth middleware already covers this endpoint."
- **Legitimate use:** The **noun** in its financial/mechanical sense — leverage ratio, levered
  returns, mechanical leverage, "we have leverage in this negotiation." The noun is fine.
  The verb is not.

### navigate / navigating (figurative)
- **Tier:** 2
- **Why it reads as AI:** Verified excess verb [V]. Figurative `navigate` treats every
  difficulty as a maritime journey and pairs with the `landscape` noun family to build a
  fully dead metaphor system (`navigating the evolving landscape of`).
- **Specimen:** "Teams must navigate the complexities of multi-region failover."
- **Repair:** "Multi-region failover has three failure modes teams get wrong."
- **Legitimate use:** Literal navigation — ships, maps, GPS. Also UI navigation ("navigate to
  Settings"), which is standard product vocabulary and should be left alone.

### garner
- **Tier:** 1
- **Why it reads as AI:** Verified excess verb [V]; on Wikipedia's era-one vocabulary list [C].
  A word almost no one says aloud, which is why models like it — it reads as elevated register
  at zero semantic cost.
- **Specimen:** "The proposal garnered support from three teams."
- **Repair:** "Three teams backed the proposal."
- **Legitimate use:** None worth defending. `got`, `won`, `drew`, or a named actor is always better.

### boast / boasts
- **Tier:** 1
- **Why it reads as AI:** Verified — one of the five largest increases in the PME study [V].
  Doubly damning: it is both an excess verb *and* an instance of copula avoidance (§M), so it
  trips two independent detectors.
- **Specimen:** "The service boasts 99.99% uptime."
- **Repair:** "The service has had four minutes of downtime this year."
- **Legitimate use:** When a person is actually bragging — "he boasted about the benchmark."
  Human subject, real vanity. Never for a product having a feature.

### bolster
- **Tier:** 2
- **Why it reads as AI:** Verified excess verb [V]; on *both* of Wikipedia's era lists, meaning
  it survived the 2024 vocabulary turnover [C] — one of the more persistent tells.
- **Specimen:** "Adding retries bolsters the reliability of the pipeline."
- **Repair:** "Retries take the pipeline's failure rate from 2% to 0.1%."
- **Legitimate use:** Literal — bolstering a wall, a bolster cushion. Figuratively acceptable
  when something genuinely *props up* something at risk of falling: "the loan bolstered a
  balance sheet that was about to break covenant."

### elucidate / illuminate / shed light on
- **Tier:** 1
- **Why it reads as AI:** All three on the verified list [V]; `shed light on` is on the verified
  two-word-phrase list [V] and every curated list [C]. Three ways to say `explain` while
  suggesting the writer has brought a lantern into a cave.
- **Specimen:** "This section elucidates the retry semantics."
- **Repair:** "Retries back off exponentially and stop after five attempts."
- **Legitimate use:** `illuminate` literally — lighting, optics, a lit sign. `elucidate` has no
  defensible prose use over `explain`.

### embark (on)
- **Tier:** 1
- **Why it reads as AI:** Verified excess verb [V]; on every curated list [C]. Combines with the
  `journey` noun (§D) to form `embark on a journey`, the densest slop collocation in English.
- **Specimen:** "Before we embark on the migration, let's audit the schema."
- **Repair:** "Audit the schema before the migration starts."
- **Legitimate use:** Boarding a ship or plane. Literal only.

### unveil / unearth / uncover / reveal
- **Tier:** 2
- **Why it reads as AI:** `unveil` and `unearth` are on the verified list [V]. All four dramatize
  ordinary disclosure — a product is `unveiled`, a bug is `unearthed`, an insight `uncovered`.
  The theatricality is the tell.
- **Specimen:** "Profiling unearthed a hidden N+1 query."
- **Repair:** "Profiling found an N+1 query in the serializer."
- **Legitimate use:** `unveil` for an actual ceremony (a statue, a keynote launch). `uncover` and
  `reveal` when something was genuinely concealed by an agent — a cover-up, a redaction,
  a deliberately hidden field. Not for things that were merely not yet looked at.

### unlock / unleash
- **Tier:** 1
- **Why it reads as AI:** Marketing verbs on every curated list [C]. `unlock value`, `unleash
  potential` — both promise a barrier was removed without naming the barrier.
- **Specimen:** "Caching unlocks significant performance gains."
- **Repair:** "Caching cuts p99 from 800ms to 90ms."
- **Legitimate use:** Literal locks, doors, phones, feature flags gated behind a paywall
  ("unlocks the Pro tier"). `unleash` literally — a dog, a leash. Otherwise none.

### facilitate
- **Tier:** 2
- **Why it reads as AI:** Verified excess verb [V]. Four syllables for `help` or, more often,
  for a verb the writer never chose at all.
- **Specimen:** "The adapter facilitates communication between the two services."
- **Repair:** "The adapter translates service A's protobuf into service B's JSON."
- **Legitimate use:** A person facilitating a meeting or workshop — that is the word for the role.
  Also legal/logistics senses ("facilitate payment"). Not as a general-purpose transitive verb.

### utilize / utilization
- **Tier:** 1
- **Why it reads as AI:** Top of every curated list [C]. Never once improves on `use`.
- **Specimen:** "The service utilizes a connection pool."
- **Repair:** "The service pools connections."
- **Legitimate use:** One narrow real sense: `utilization` as a measured ratio — CPU utilization,
  bed utilization, capacity utilization. That noun is a term of art. The verb is not.

### encompass / comprise / span
- **Tier:** 3
- **Why it reads as AI:** `encompass` is a verified excess verb [V]. All three inflate `includes`
  or `covers`. Individually invisible; three in a page is the tell.
- **Specimen:** "The audit encompasses all services in the payments domain."
- **Repair:** "The audit covers every payments service."
- **Legitimate use:** `span` for genuine ranges (time, frequency, a bridge). `comprise` when you
  mean whole-to-parts and are being careful about it. Fine at low density.

### surface (verb) / bubble up
- **Tier:** 2
- **Why it reads as AI:** Named on claudisms.ai as a corporate-adjacent verb tic [C];
  `surface the insight`, `surface a pattern`. Product-manager register leaking into prose. [A]
  I reach for this constantly.
- **Specimen:** "The dashboard surfaces anomalies in the request logs."
- **Repair:** "The dashboard flags requests slower than the 99th percentile."
- **Legitimate use:** Genuinely standard in UI/product engineering for making buried data
  visible — "surface the error in the toast." In technical docs this is native vocabulary.
  It is slop in essayistic prose.

### unpack / double-click on / deep dive / dive into
- **Tier:** 1
- **Why it reads as AI:** All four on claudisms.ai's corporate-filler list [C]; `deep dive` is on
  the verified two-word-phrase list [V]. Consultant register. `double-click on` is the worst of
  them — a metaphor from a UI interaction, used to mean "discuss further."
- **Specimen:** "Let's unpack why the retry storm happened."
- **Repair:** "The retry storm happened because every client used the same 30s timeout."
- **Legitimate use:** `unpack` literally — luggage, archives, `tar -x`, destructuring assignment
  in code. `dive` for actual diving. Nothing else.

### align / align with / resonate with
- **Tier:** 2
- **Why it reads as AI:** `align` is on the verified verb list [V] and heads Wikipedia's
  era-two list [C]; `resonate` is on every curated list [C]. Both replace a concrete relation
  with a vague sympathy.
- **Specimen:** "This approach aligns with our reliability goals and resonates with the team."
- **Repair:** "This approach hits the 99.9% target, and the team prefers it."
- **Legitimate use:** `align` literally — text alignment, aligning two data series, wheel
  alignment, aligning incentives where you then specify how. `resonance` in physics and audio.

### revolutionize / transform / reimagine / disrupt
- **Tier:** 1
- **Why it reads as AI:** `revolutionize` and `transform` are on the verified list [V]; all four
  are on every curated list [C]. Each claims a discontinuity the sentence never evidences.
- **Specimen:** "Vector databases are transforming how we build search."
- **Repair:** "Vector databases replaced the inverted index in three of our four search paths."
- **Legitimate use:** `transform` in its exact technical senses — a data transform, a matrix
  transform, a CSS transform, Fourier. Those are untouchable. The vague-change sense is not.

### empower / enable (of people)
- **Tier:** 1
- **Why it reads as AI:** The archetypal corporate verb; every curated list [C]. The
  oliviacal.com before/after is the cleanest illustration in the literature [C]:
  "We empower users to optimize their workflows" → "We help you work faster."
- **Specimen:** "The new API empowers developers to build custom integrations."
- **Repair:** "Developers can now write their own integrations against the API."
- **Legitimate use:** Legal empowerment — a statute empowers an agency, a POA empowers an agent.
  `enable` for software features being switched on is completely standard and should be left alone.

### elevate / amplify / supercharge / turbocharge / catalyze / galvanize
- **Tier:** 1
- **Why it reads as AI:** A single family of engine-and-chemistry verbs for "make better,"
  all on curated lists [C]; `catalyze` also on the verified list [V]. The mechanical metaphor
  is always dead on arrival.
- **Specimen:** "These changes supercharge the onboarding experience."
- **Repair:** "New users reach their first successful call in two minutes instead of eleven."
- **Legitimate use:** `elevate` literally (height, elevation, elevated privileges — a real
  security term). `catalyze`/`catalyst` in actual chemistry. `amplify` in audio and signal
  processing. All exact and fine in domain.

### streamline / optimize
- **Tier:** 2
- **Why it reads as AI:** Both on curated lists [C]. `optimize` is the more insidious: it has a
  precise technical meaning and is therefore constantly used as a vague booster under cover of
  that precision.
- **Specimen:** "We streamlined the checkout flow and optimized the queries."
- **Repair:** "Checkout dropped from five screens to two. The N+1 in the cart query is gone."
- **Legitimate use:** `optimize` when there is a named objective function and a measured
  before/after — compiler optimization, query planning, gradient descent, SEO. `streamline`
  literally in fluid dynamics. Rule: if you cannot state *what was optimized against*, cut it.

### spearhead / champion / drive
- **Tier:** 3
- **Why it reads as AI:** Curated-list corporate verbs [C] for "led." Low individual signal,
  clusters badly in bios and project write-ups.
- **Specimen:** "She spearheaded the migration and championed the new review process."
- **Repair:** "She ran the migration and wrote the review process we now use."
- **Legitimate use:** `drive` in mechanical and data senses (drive shaft, data-driven, a disk
  drive). `champion` as a noun. Fine singly; count them.

### grapple with / wrestle with / contend with
- **Tier:** 2
- **Why it reads as AI:** `grapple` is on the verified verb list [V]. Physicalizes intellectual
  difficulty to make a routine tradeoff sound heroic.
- **Specimen:** "Engineers grapple with the tradeoff between consistency and availability."
- **Repair:** "You pick consistency or availability. You don't get both."
- **Legitimate use:** Real struggle with real stakes and a named opponent — "the team wrestled
  with the outage for six hours." Fine once when the difficulty is genuinely sustained.

### explore / examine / investigate (as article throat-clearing)
- **Tier:** 3
- **Why it reads as AI:** On the verified verb list [V]. Slop only in the announcement frame
  ("This post explores…"), where the sentence describes the document instead of saying anything.
- **Specimen:** "This post explores three approaches to rate limiting."
- **Repair:** "There are three ways to rate-limit, and two of them are wrong for bursty traffic."
- **Legitimate use:** Constantly legitimate as a real verb — explore a codebase, investigate a
  bug, examine the logs. Only the meta-announcement use is slop.

---

# FAMILY B — Grandeur adjectives and intensifiers

14% of measured excess vocabulary is adjectives [V]. Note that the highest-*detection* words
here are the boring ones (`crucial`, `comprehensive`), not the florid ones.

### crucial
- **Tier:** 1
- **Why it reads as AI:** δ=0.037, the third-largest absolute frequency gap of any word measured,
  and a member of the optimal 10-word detection set [V]. On both Wikipedia era lists [C]. This is
  the highest-value single adjective in the entire catalog.
- **Specimen:** "It's crucial to set a timeout on every outbound call."
- **Repair:** "Set a timeout on every outbound call. Without one, a slow dependency takes the
  whole pool down."
- **Legitimate use:** When something genuinely decides an outcome and you say why in the next
  clause. Rare. Default to cutting.

### comprehensive
- **Tier:** 1
- **Why it reads as AI:** Member of the optimal 10-word detection set [V] — one of the ten words
  that best separate 2024 abstracts from 2022 abstracts. Nearly always self-congratulation about
  coverage the text does not have.
- **Specimen:** "This guide provides a comprehensive overview of the auth system."
- **Repair:** "This guide covers login, token refresh, and revocation. It does not cover SSO."
- **Legitimate use:** When the scope claim is checkable and true — a comprehensive test suite
  with a stated coverage number, comprehensive insurance (a term of art), a comprehensive exam.
  If the boundary isn't stated, cut it.

### pivotal
- **Tier:** 1
- **Why it reads as AI:** Verified excess adjective [V]; on both Wikipedia era lists [C]. Almost
  exclusively appears as `plays a pivotal role in`, which is a seven-word way to say "matters."
- **Specimen:** "Caching plays a pivotal role in the read path."
- **Repair:** "Ninety-four percent of reads never reach the database."
- **Legitimate use:** A genuine hinge event where the outcome turned — a pivotal battle, a
  pivotal vote. Historical, singular, and specifiable.

### meticulous / meticulously
- **Tier:** 1
- **Why it reads as AI:** One of the five largest measured increases in the PME study [V]; on
  Wikipedia's era-one list [C]. The flagship **false-precision qualifier** (see §G): it asserts
  care rather than showing it, and is almost always applied to work the writer did not observe.
- **Specimen:** "The schema was meticulously designed to avoid write amplification."
- **Repair:** "The schema keeps hot and cold columns in separate tables, so updates touch one page."
- **Legitimate use:** Describing an observed, unusual, documented degree of care — a restorer's
  meticulous work on a painting, where you then say what made it meticulous.

### intricate / intricacies
- **Tier:** 2
- **Why it reads as AI:** Verified excess adjective [V]; Wikipedia era-one [C]. Asserts complexity
  as a substitute for describing it. `The intricacies of X` almost always precedes no intricacies.
- **Specimen:** "The intricacies of the consensus protocol are beyond this post."
- **Repair:** "The consensus protocol needs its own post. The short version: two round trips, one leader."
- **Legitimate use:** Physical intricacy you can point at — intricate carving, an intricate mechanism,
  intricate lacework. Concrete and visible.

### robust
- **Tier:** 2
- **Why it reads as AI:** On every curated list [C] and in the seed set. Used as a general-purpose
  approval adjective ~90% of the time. But it is a genuine technical term in at least three fields,
  which is exactly why it's Tier 2.
- **Specimen:** "We built a robust error-handling layer."
- **Repair:** "Every handler retries twice, then writes to the dead-letter queue."
- **Legitimate use:** **Real and important.** Statistics: robust estimators, robust standard errors,
  robustness to outliers — a precise, defined property. Control theory: robust control. CS:
  robustness to adversarial input, Postel's law. Materials: robust under load. Test: if you can
  name *what perturbation it is robust to*, keep it. If not, cut it.

### seamless / seamlessly
- **Tier:** 1
- **Why it reads as AI:** On the verified adverb list [V] and every curated list [C]; in the seed
  set. Describes an absence (of friction) rather than a presence, so it can never be checked.
  Its natural habitat is integration marketing.
- **Specimen:** "The plugin integrates seamlessly with your existing pipeline."
- **Repair:** "The plugin is one line in your config and needs no code changes."
- **Legitimate use:** Literal seams — seamless steel pipe, seamless garments, a seamless texture
  tile in graphics. Manufacturing and rendering only.

### vital / essential / paramount / indispensable / imperative
- **Tier:** 2
- **Why it reads as AI:** A single interchangeable importance-booster family; `essential` and
  `paramount` on curated lists [C], `indispensability` cited as an excess word in the arXiv
  preprint [V]. The interchangeability is the tell — none was chosen, one was sampled.
- **Specimen:** "Monitoring is essential for any production service."
- **Repair:** "Without monitoring you find out about outages from customers."
- **Legitimate use:** `vital` medically (vital signs, vital organs). `essential` in its exact
  sense of *belonging to the essence* — essential oils, essential complexity vs. accidental
  complexity (Brooks), an essential singularity. Precise senses survive.

### profound / powerful / remarkable / extraordinary / striking
- **Tier:** 2
- **Why it reads as AI:** `profoundly` is on the verified adverb list [V]; the rest are on curated
  lists [C]. A family of reader-reaction adjectives: they tell the reader what to feel instead of
  giving them cause. `powerful` is the worst offender in technical writing — `a powerful tool`
  says nothing about capability.
- **Specimen:** "Rust's ownership model is a powerful abstraction with profound implications."
- **Repair:** "Rust's ownership model makes use-after-free a compile error."
- **Legitimate use:** `profound` in medicine (profound hypothermia, profound deafness) and
  literally of depth. `powerful` of measurable power — engines, radio transmitters, statistical
  power. `remarkable` when you then say what remark it prompted.

### significant
- **Tier:** 2
- **Why it reads as AI:** On the verified adjective list [V]. Sits in a dangerous spot: it means
  something exact in statistics and nothing at all in prose, and models exploit the ambiguity to
  sound rigorous.
- **Specimen:** "We saw a significant improvement in latency."
- **Repair:** "p99 latency fell from 400ms to 120ms."
- **Legitimate use:** Statistical significance with a test and a p-value attached. Also
  `significant digits`. Elsewhere, replace with the number.

### innovative / groundbreaking / cutting-edge / state-of-the-art / revolutionary
- **Tier:** 1
- **Why it reads as AI:** `innovative` and `groundbreaking` on the verified list [V]; the whole
  family on Wikipedia's promotional-language list [C]. Pure novelty assertion — always
  unfalsifiable, usually false, and in a fast field, stale within a year.
- **Specimen:** "Our cutting-edge retrieval pipeline uses a groundbreaking reranker."
- **Repair:** "The reranker is a cross-encoder we fine-tuned on 40k of our own click pairs."
- **Legitimate use:** `state of the art` as a benchmark claim with a leaderboard and a number
  behind it. `groundbreaking` at a literal groundbreaking ceremony. Otherwise none.

### transformative / game-changing / watershed / paradigm-shifting
- **Tier:** 1
- **Why it reads as AI:** Verified [V] plus every curated list [C]. Escalated novelty assertion.
  `game-changer` is on contentbeta's single-word list [C].
- **Specimen:** "This release is a game-changer for local development."
- **Repair:** "Local dev no longer needs Docker. `npm start` boots the whole stack in 4 seconds."
- **Legitimate use:** `transformer`/`transformation` in their technical senses. `watershed` in
  hydrology. The figurative senses: none.

### nuanced / multifaceted / holistic / sophisticated / complex
- **Tier:** 2
- **Why it reads as AI:** All on the verified adjective list [V] and curated lists [C]. Each
  claims dimensionality while supplying none. `nuanced` is the archetype: it is what you say
  instead of stating the nuance.
- **Specimen:** "The tradeoff here is nuanced and multifaceted."
- **Repair:** "The tradeoff depends on read/write ratio. Above 10:1, cache. Below, don't."
- **Legitimate use:** `holistic` in medicine and systems analysis where the whole-system framing
  is the actual point. `complex` in math (complex numbers) and in complexity theory. `sophisticated`
  of an attacker or a piece of machinery whose sophistication you then describe.

### invaluable / valuable / actionable / impactful / compelling
- **Tier:** 2
- **Why it reads as AI:** `valuable`, `invaluable`, `actionable` on the verified list [V];
  `impactful` and `compelling` on curated lists [C]. `valuable insights` is on Wikipedia's
  superficial-analysis list [C] and is arguably the single most hollow two-word phrase in
  business English.
- **Specimen:** "The retro produced valuable insights and actionable takeaways."
- **Repair:** "The retro produced two changes: we cap deploy size at 400 lines, and on-call
  now owns the rollback."
- **Legitimate use:** `actionable` in its legal sense (actionable claim). `valuable` with a value
  attached. `compelling` of an argument you then reproduce.

### myriad / plethora / vast array / diverse array / wealth of
- **Tier:** 1
- **Why it reads as AI:** Curated lists [C]; `diverse array` is on Wikipedia's promotional list [C].
  Elevated quantity words used where a number belongs.
- **Specimen:** "The library offers a myriad of configuration options."
- **Repair:** "There are 34 config options. You need four of them."
- **Legitimate use:** `myriad` in its literal Greek sense of ten thousand, if you're being playful
  about it. Otherwise: use the number.

### vibrant / thriving / bustling / burgeoning / nascent / poised
- **Tier:** 1
- **Why it reads as AI:** Wikipedia's promotional-language cluster [C]; `burgeoning`, `nascent`,
  `poised` on the avoid-ai-writing Tier 2 [C]. Travel-brochure vocabulary. `nestled` and
  `in the heart of` belong to the same family and are equally damning.
- **Specimen:** "A vibrant open-source ecosystem has emerged around the protocol."
- **Repair:** "Six independent implementations exist; three are used in production."
- **Legitimate use:** `vibrant` of actual color or actual vibration. `nascent` of a genuinely
  new field where you can date its start. Otherwise none.

### key
- **Tier:** 3
- **Why it reads as AI:** Wikipedia era-one vocabulary [C]. Too common to ban and too weak to
  keep. `plays a key role`, `the key insight`, `key takeaways` — each is a load-free adjective
  slot. Density is the only usable signal.
- **Specimen:** "The key thing to remember is that the key metric here is p99, not the mean."
- **Repair:** "Measure p99, not the mean. The mean hides the tail."
- **Legitimate use:** Constantly — a cryptographic key, a database key, a map key, a key signature.
  Never touch the noun. Count the adjective.

---

# FAMILY C — Corporate and marketing verbs

Substantially overlaps Family A; entries here are the ones with no measured academic excess but
heavy curated-list presence, i.e. marketing-native rather than abstract-native.

### curate / curated / hand-picked
- **Tier:** 2
- **Why it reads as AI:** Curated lists [C]. Applied to anything selected, which drains the word
  of the editorial-judgment meaning that made it useful.
- **Specimen:** "A curated selection of the best debugging tools."
- **Repair:** "Six debugging tools I actually use, and why the seventh didn't make it."
- **Legitimate use:** Actual curation with a named curator and stated criteria — museums,
  editorial collections, a curated dataset with documented inclusion rules.

### tailor / tailored / bespoke
- **Tier:** 2
- **Why it reads as AI:** On contentbeta's list [C]. `tailored to your needs` is the terminal form
  and asserts customization that is almost never real.
- **Specimen:** "The onboarding is tailored to each user's role."
- **Repair:** "Admins see the billing tour. Engineers see the API tour."
- **Legitimate use:** Actual tailoring of clothes. Figuratively fine when the customization axis
  is named in the same sentence.

### cultivate / nurture / build (of abstractions)
- **Tier:** 3
- **Why it reads as AI:** `cultivate` on curated lists [C], grouped with `foster` on Wikipedia [C].
  Horticultural metaphor for abstract nouns — `cultivate a culture`, `nurture talent`.
- **Specimen:** "We cultivate a culture of psychological safety."
- **Repair:** "Postmortems name systems, not people. That rule is in writing."
- **Legitimate use:** Literal agriculture. `build` is fine and constant — do not flag it.

### underpin / underpinning
- **Tier:** 2
- **Why it reads as AI:** avoid-ai-writing Tier 2 [C]. A structural metaphor for "supports,"
  cousin to `load-bearing` (§H) and equally over-applied to non-structures.
- **Specimen:** "Trust underpins every successful engineering org."
- **Repair:** "If people hide bad news, every other process fails."
- **Legitimate use:** Literal underpinning of a foundation in construction. Also acceptable of a
  genuine dependency stack where you can name what sits on what.

### deliver / drive / enable value
- **Tier:** 1
- **Why it reads as AI:** `deliver value`, `drive outcomes`, `enable growth` — the object is
  always an abstract noun that no verb can act on. Consultant register; a documented register
  tic on claudisms.ai [C].
- **Specimen:** "The platform delivers value across the customer lifecycle."
- **Repair:** "Support tickets per account dropped 30% after we shipped self-serve refunds."
- **Legitimate use:** `deliver` of things actually delivered — packages, a talk, a baby, a
  message, a payload. Concrete objects only.

---

# FAMILY D — Abstract-noun clichés

The PubMed studies found excess vocabulary is verb-and-adjective-dominated, so this family
carries *less* verified frequency evidence than A and B. But it carries the most *cultural*
signal: `tapestry` and `realm` are what people point at when they say "AI wrote this" [C].
Treat this family as high-perception, medium-frequency.

### tapestry / rich tapestry
- **Tier:** 1
- **Why it reads as AI:** On the verified noun list [V] and on essentially every curated list [C];
  named on Wikipedia era-one [C]. The single most mocked AI noun. Cultural radioactivity now
  exceeds its actual frequency.
- **Specimen:** "Kubernetes sits inside a rich tapestry of cloud-native tooling."
- **Repair:** "Kubernetes needs a CNI, a CSI driver, and an ingress controller before it does anything."
- **Legitimate use:** Actual woven textiles. The Bayeux Tapestry. Nothing else.

### landscape (figurative)
- **Tier:** 1
- **Why it reads as AI:** Verified noun [V]; Wikipedia era-one [C]; `evolving landscape` is on
  Wikipedia's significance-inflation list [C]. Combines with `navigate` (§A) and `evolving` to
  form the densest opener cliché in the corpus.
- **Specimen:** "The observability landscape has evolved rapidly."
- **Repair:** "Three years ago you bought Datadog. Now you run OpenTelemetry and pick a backend."
- **Legitimate use:** Actual terrain, landscape photography, landscape orientation, landscape
  architecture, a fitness landscape in evolutionary biology (a real technical term).

### realm
- **Tier:** 1
- **Why it reads as AI:** Verified excess noun [V], cited by name in the arXiv preprint [V].
  Fantasy-register word doing the job of `area` or, more often, of nothing — `in the realm of X`
  is deletable in full.
- **Specimen:** "In the realm of distributed systems, consensus is expensive."
- **Repair:** "Consensus is expensive."
- **Legitimate use:** Kingdoms and fantasy settings. Also a real term in Kerberos and in
  authentication config (`realm` in HTTP Basic auth) — leave those alone.

### journey
- **Tier:** 2
- **Why it reads as AI:** Verified excess noun [V]. Pairs with `embark` (§A). Turns any process
  into a hero's arc, which flatters the reader and describes nothing.
- **Specimen:** "Your journey to production-grade observability starts here."
- **Repair:** "Start by instrumenting one service. Here's which one."
- **Legitimate use:** Actual travel. And `customer journey` / `user journey` are established terms
  of art in product and UX with real methodology behind them — do not flag those.

### ecosystem (figurative)
- **Tier:** 2
- **Why it reads as AI:** Verified excess noun [V]; avoid-ai-writing Tier 2 [C]. Borrowed from
  biology to imply organic interdependence that is usually just "a set of packages."
- **Specimen:** "The Rust ecosystem has matured considerably."
- **Repair:** "Rust now has a stable async runtime, a working ORM, and a serialization crate
  everyone agrees on."
- **Legitimate use:** Actual ecology. And genuinely standard in tech for a platform's third-party
  surroundings — "the npm ecosystem" is not slop, it is the accepted noun. Flag only when it
  replaces a describable set.

### framework / paradigm
- **Tier:** 2
- **Why it reads as AI:** `paradigm` and `paradigm shift` are on claudisms.ai's tired-phrases
  list [C] and every curated list [C]. Both are legitimate technical nouns constantly conscripted
  as vague-structure words.
- **Specimen:** "This represents a new paradigm for building agents, backed by a framework for
  thinking about tool use."
- **Repair:** "Agents that write their own tool definitions behave differently. Here's how."
- **Legitimate use:** **Very often legitimate.** A software framework (React, Rails, Django) is
  literally a framework. `paradigm` in Kuhn's exact sense, and in programming-paradigm (functional,
  OO) which is standard. Flag only the vague-noun use: "a framework for thinking about."

### testament / a testament to
- **Tier:** 1
- **Why it reads as AI:** Verified excess noun [V]; on Wikipedia's significance-inflation list
  alongside `stands as`, `serves as` [C]. Pure significance assertion with a faintly biblical
  register.
- **Specimen:** "The uptime record is a testament to the team's engineering discipline."
- **Repair:** "The team has run four minutes of downtime in a year on a two-person on-call rotation."
- **Legitimate use:** A will (last will and testament). The Old/New Testament. Literal only.

### insights / learnings / takeaways
- **Tier:** 1
- **Why it reads as AI:** `insights` is in the **optimal 10-word detection set** [V] — one of the
  ten most diagnostic words in the entire PubMed study. `learnings` is on every curated list [C].
  Container nouns that promise contents and rarely deliver them.
- **Specimen:** "Here are the key learnings and insights from the migration."
- **Repair:** "Two things went wrong in the migration. Both were DNS."
- **Legitimate use:** `insight` singular, when a specific one follows immediately. `learning` as
  a mass noun in ML (machine learning, learning rate). The plural business noun `learnings`: never.

### beacon / cornerstone / bedrock / linchpin / north star
- **Tier:** 1
- **Why it reads as AI:** `cornerstone` and `beacon` on curated lists [C]; `north star` flagged as
  consultant register on claudisms.ai [C]. Architectural and navigational metaphors for
  "important thing."
- **Specimen:** "Type safety is the cornerstone of our engineering approach."
- **Repair:** "Nothing merges without passing `tsc --strict`."
- **Legitimate use:** Literal cornerstones, beacons, linchpins. `North Star metric` is established
  (if tired) product vocabulary — allow in product docs, flag in prose.

### symphony / orchestra / dance / ballet (of coordination)
- **Tier:** 1
- **Why it reads as AI:** On oliviacal's flowery-metaphor list [C]. Performing-arts metaphor for
  systems working together. Always decorative.
- **Specimen:** "The scheduler conducts a symphony of containers across the fleet."
- **Repair:** "The scheduler places containers by bin-packing on CPU and memory requests."
- **Legitimate use:** Music. Also `orchestration` is standard infrastructure vocabulary
  (container orchestration) — leave it.

### throughline / thread / the shape of
- **Tier:** 2
- **Why it reads as AI:** All three named on claudisms.ai [C] — `throughline` as buzzy language,
  `shape` as a writerly metaphor. [A] These are strongly mine. I reach for "the shape of the
  problem" as a way to gesture at structure I haven't articulated.
- **Specimen:** "The throughline across all three incidents is the shape of our retry logic."
- **Repair:** "All three incidents came from retrying non-idempotent writes."
- **Legitimate use:** `throughline` in dramaturgy, where it originates. `shape` of actual shapes,
  distributions, and curves. `thread` in concurrency.

### arena / space / domain / sphere
- **Tier:** 3
- **Why it reads as AI:** `arena` on contentbeta's list [C]. Low-grade vagueness nouns.
  Individually harmless; three per page means no concrete subject was ever named.
- **Specimen:** "In the observability space, several players have entered the arena."
- **Repair:** "Grafana, Honeycomb, and Datadog all sell this now."
- **Legitimate use:** `domain` constantly and precisely — domain names, problem domains, DDD,
  domain of a function. `space` in math and ML (vector space, latent space). Only the vague-field
  sense is slop.

---

# FAMILY E — Transitional filler

### moreover / furthermore / additionally
- **Tier:** 1 (`moreover`, `furthermore`) / Tier 2 (`additionally`)
- **Why it reads as AI:** `additionally` is in the **optimal 10-word detection set** [V] — it is
  measurably one of the ten best discriminators. Stanford/UT work reports LLMs repeat connective
  phrases up to 6× human rates [C]. These words assert a logical relation ("further in the same
  direction") that a plain new sentence supplies for free.
- **Specimen:** "The cache reduced load. Moreover, it improved p99. Furthermore, costs fell."
- **Repair:** "The cache cut database load by 70%, p99 by 300ms, and the bill by $4k a month."
- **Legitimate use:** `additionally` in a genuine enumeration where order matters and the reader
  is tracking a list. `moreover` and `furthermore` in formal argumentative prose where you are
  explicitly stacking premises — rare, and one per document is the ceiling.

### in conclusion / in summary / to summarize / in essence
- **Tier:** 1
- **Why it reads as AI:** `in summary` on the verified two-word-phrase list [V]; on every curated
  list [C]. In a document with headings, the conclusion is visibly the conclusion. The phrase
  exists only because five-paragraph-essay training data demanded it.
- **Specimen:** "In conclusion, the migration was worth the effort."
- **Repair:** "The migration cost three weeks and saved eleven hours of toil a month. It paid
  back in twelve weeks."
- **Legitimate use:** Spoken delivery, where the audience has no scrollbar and needs the signal.
  Also long-form legal or academic writing with a formal Conclusion section — where the *heading*
  does the work and the phrase still shouldn't appear beneath it.

### that said / that being said / with that said
- **Tier:** 2
- **Why it reads as AI:** avoid-ai-writing transition list [C]. Announces a concession that the
  contrast could carry alone. Its real crime is that it is usually followed by a hedge, producing
  a paragraph that concedes without conceding.
- **Specimen:** "The benchmark is impressive. That said, it may not reflect production workloads."
- **Repair:** "The benchmark ran on one machine with a warm cache. Production has neither."
- **Legitimate use:** Genuinely fine once per piece as a conversational pivot, especially in
  spoken-register writing. It's the second and third use that kill.

### ultimately
- **Tier:** 3
- **Why it reads as AI:** On slopdetector's transition-stacking list [C] and claudisms.ai
  register tics [C]. [A] Strongly mine: I use it to give a sentence an air of final judgment it
  hasn't earned. Nearly always deletable with zero loss.
- **Specimen:** "Ultimately, the choice depends on your read/write ratio."
- **Repair:** "The choice depends on your read/write ratio."
- **Legitimate use:** When there is a real chain of causes and you're naming its end — "the
  request ultimately reaches the origin." Temporal and causal, not rhetorical.

### when it comes to
- **Tier:** 1
- **Why it reads as AI:** On claudisms.ai's imported-phrases list [C] and avoid-ai-writing [C].
  Five words of runway before a topic that could have started the sentence.
- **Specimen:** "When it comes to caching, invalidation is the hard part."
- **Repair:** "Cache invalidation is the hard part."
- **Legitimate use:** None. This phrase is always deletable.

### at the end of the day / when all is said and done
- **Tier:** 1
- **Why it reads as AI:** Corporate filler on claudisms.ai [C] and avoid-ai-writing [C].
  Idiomatic throat-clearing that signals a summary judgment is coming, in place of the judgment.
- **Specimen:** "At the end of the day, it's about developer experience."
- **Repair:** "Developers abandoned the tool because setup took forty minutes."
- **Legitimate use:** Literal end of a day. Otherwise none.

### in terms of
- **Tier:** 3
- **Why it reads as AI:** avoid-ai-writing transition list [C]. A dead prepositional bridge that
  usually replaces a real verb.
- **Specimen:** "In terms of performance, the new parser is better."
- **Repair:** "The new parser is 3× faster."
- **Legitimate use:** When genuinely converting between units or frames — "expressed in terms of
  base units," "in terms of x." Mathematical and explicit.

### the reality is / the truth is / here's the thing
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing [C]; `here's the thing` flagged as an infomercial
  engagement hook [C]. Manufactured pivot that claims to cut through spin the passage never had.
- **Specimen:** "Here's the thing: most teams don't need Kubernetes."
- **Repair:** "Most teams don't need Kubernetes."
- **Legitimate use:** None in written prose. Tolerable in genuine transcribed speech.

---

# FAMILY F — Hedging that hedges nothing

The seed category, and the most Claude-specific of the generic families. Claude's hedging is a
documented differentiator against GPT [C], attributed to safety training producing a
"consistently tentative voice that rarely commits" [C].

The operative test, and the one `/deslopify` should implement: **a hedge is legitimate if
removing it would make the sentence assert something the writer does not believe.** If removing
it changes nothing but tone, it is filler.

### it's worth noting that / it's important to note that
- **Tier:** 1
- **Why it reads as AI:** On claudisms.ai's imported-phrase list, avoid-ai-writing's transition
  list, and named in the hedging-frequency literature [C]. If it's worth noting, note it. The
  phrase spends six words certifying the value of the words that follow.
- **Specimen:** "It's worth noting that the cache is only invalidated on write."
- **Repair:** "The cache is only invalidated on write — reads can serve stale data for up to 60s."
- **Legitimate use:** None. This is the cleanest always-delete in the catalog.

### the entire "worth ___" family
- **Tier:** 2
- **Why it reads as AI:** claudisms.ai bans the whole family explicitly: `worth asking`,
  `worth a look`, `worth examining`, `worth considering`, `worth exploring`, `worth sitting with`,
  `worth stating plainly` [C]; explainx names `worth stating plainly` as a top Claudism [C].
  Each one recommends attention instead of paying it.
- **Specimen:** "It's worth considering whether the retry budget is the real constraint."
- **Repair:** "The retry budget is the real constraint: at 3 retries we exhaust the pool at 200 rps."
- **Legitimate use:** With a stated cost/benefit — "worth the three days it'll take" — where
  `worth` is doing genuine economic comparison. Rare, and always has a price attached.

### importantly / notably / significantly (sentence-initial)
- **Tier:** 1
- **Why it reads as AI:** `notably` is in the **optimal 10-word detection set** [V]; `notably`
  also appears on the verified adverb list [V]. Sentence-initial importance adverbs pre-chew the
  reader's judgment. If the fact is notable, its content will show that.
- **Specimen:** "Notably, the p99 barely moved."
- **Repair:** "The p99 barely moved — 4ms, against a 300ms drop in the mean."
- **Legitimate use:** Mid-sentence `notably` introducing an example ("several databases, notably
  Postgres") is standard and fine. It's the sentence-initial adverbial that's slop.

### arguably
- **Tier:** 1
- **Why it reads as AI:** A hedge that hedges nothing — it neither commits nor identifies who
  would argue otherwise. Almost always attached to a superlative to make it unfalsifiable. [A]
  Not on the corpus lists; asserting from my own tendency, which is strong.
- **Specimen:** "This is arguably the most important decision in the design."
- **Repair:** "This decision determines whether we can ever shard. Nothing else does."
- **Legitimate use:** When you immediately supply the argument on both sides. If no counter-position
  follows within two sentences, it's filler.

### to some extent / in many ways / to a degree / in some sense
- **Tier:** 1
- **Why it reads as AI:** Named in the hedging literature as disproportionately frequent in
  machine text [C]. Each supplies an unspecified quantity of an unspecified quality.
- **Specimen:** "The abstraction leaks, to some extent."
- **Repair:** "The abstraction leaks whenever a transaction spans two shards."
- **Legitimate use:** None. `In many ways` is a particularly reliable delete.

### generally speaking / broadly / typically / in most cases
- **Tier:** 3
- **Why it reads as AI:** `generally speaking` named in the hedging literature [C]. These are
  legitimate quantifiers that become filler when stacked — three in a paragraph means the writer
  is defending against a reader who doesn't exist.
- **Specimen:** "Generally speaking, in most cases you'll typically want the default."
- **Repair:** "Use the default unless you're running on ARM."
- **Legitimate use:** Genuinely useful when there is a real exception you're excluding and you
  either name it or explicitly defer it. One per paragraph, maximum.

### could potentially / may possibly / might perhaps (stacked hedges)
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing flags hedge-stacked predictions as a P1 tell [C].
  Two modal hedges in one verb phrase is redundant by construction — `could` already contains
  `potentially`.
- **Specimen:** "This could potentially cause a cascading failure."
- **Repair:** "This causes a cascading failure if the downstream pool is smaller than the upstream."
- **Legitimate use:** Never stacked. A single modal is fine and often necessary.

### I want to be careful here / to be fair / I should note (narrated candor)
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai lists false-modest asides ("I want to be careful here") [C];
  avoid-ai-writing has "narrated candor" as a distinct P1 pattern [C]. [A] This one is
  distinctively mine and I do it constantly: performing scrupulousness as a substitute for
  exercising it.
- **Specimen:** "I want to be careful here — I don't have visibility into your production traffic."
- **Repair:** "This assumes reads dominate. If your workload is write-heavy, ignore all of it."
- **Legitimate use:** When the caveat is real and specific, state the caveat and delete the
  announcement. The announcement is never the useful part.

### honest / honestly / the honest version is / honest take
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai bans self-qualifying `honest`/`honestly` [C]; 7minai names
  `honest take` as a top-four Claude tic [C]. Implies the surrounding text was less honest.
- **Specimen:** "Honestly, the honest take is that this design won't scale."
- **Repair:** "This design stops working above 10k writes per second."
- **Legitimate use:** Contrasting with a stated euphemism you just used. Otherwise it's a
  reliability claim you should not need to make.

---

# FAMILY G — False-precision qualifiers

The seed category "carefully / thoughtfully / meticulously." The mechanism is distinct enough to
deserve separation from Family B: these adverbs assert that judgment was exercised, without
naming the judgment. They are unfalsifiable *and* self-flattering, which is a rare combination.

### carefully / thoughtfully / deliberately / intentionally
- **Tier:** 2
- **Why it reads as AI:** `thoughtfully` is on the verified adverb list [V]. These describe the
  writer's or designer's internal state — unobservable, unverifiable, and always favorable.
  [A] `deliberate` and `intentional` are especially mine in design and code-review contexts.
- **Specimen:** "The API surface was carefully designed to minimize footguns."
- **Repair:** "The API has no method that mutates its receiver, so there's no aliasing bug to hit."
- **Legitimate use:** **Real and important:** contrasting with accident. "The `unsafe` block is
  deliberate — see the comment" genuinely distinguishes intent from oversight. Keep it when the
  alternative reading is "this was a mistake." Cut it when it's decorating a design claim.

### rigorously / systematically / methodically / precisely
- **Tier:** 2
- **Why it reads as AI:** `methodically` on the verified adverb list [V]. Same mechanism, applied
  to process rather than design.
- **Specimen:** "We rigorously tested every code path."
- **Repair:** "Line coverage is 94%; the uncovered 6% is error handling for `ENOSPC`."
- **Legitimate use:** With the method named. "Rigorously" is legitimate in mathematics, where
  rigor is a defined standard (a rigorous proof) rather than a compliment.

### thoroughly / comprehensively / exhaustively
- **Tier:** 2
- **Why it reads as AI:** `thoroughly` on the verified adverb list [V]; `exhaustive` on the
  verified adjective list [V]. Coverage claims made without a boundary.
- **Specimen:** "We thoroughly reviewed the security implications."
- **Repair:** "We threat-modeled the auth flow and the upload path. We did not review the admin CLI."
- **Legitimate use:** `exhaustive` in its exact sense — an exhaustive search, exhaustive
  pattern-matching in a compiler, an exhaustive case analysis. Those are checkable.

### effortlessly / seamlessly / smoothly
- **Tier:** 1
- **Why it reads as AI:** `effortlessly` and `seamlessly` are both on the verified adverb list [V].
  These promise an absence of friction, which is the one property a reader can immediately
  falsify — making them uniquely damaging to trust.
- **Specimen:** "The migration runs effortlessly in the background."
- **Repair:** "The migration runs in the background and takes about four hours on a 200GB table."
- **Legitimate use:** None in technical writing. If it truly is effortless, the effort figure
  (zero config, one command) says it better.

### quietly
- **Tier:** 2
- **Why it reads as AI:** claudisms.ai names it as the "hidden-drama adverb" [C] — used to imply a
  change was significant *and* overlooked, flattering the writer as the one who noticed.
  avoid-ai-writing has it in Tier 2 with the note "cut or name contrast" [C].
- **Specimen:** "The team quietly shipped the biggest change in the release."
- **Repair:** "The change shipped without a changelog entry, which is how it took three weeks
  to notice."
- **Legitimate use:** Literal quiet. Also legitimate when there is a real, named contrast with
  something loud — a quiet deprecation next to a publicized one.

### genuinely / truly / really / actually
- **Tier:** 3
- **Why it reads as AI:** avoid-ai-writing groups these as "hollow intensifiers" and flags
  "real/actual inflation" as a P1 pattern [C]; claudisms.ai bans the `real` family [C].
  Each implies a contrast with a fake version that was never on the table.
- **Specimen:** "This is a genuinely useful abstraction that actually solves the real problem."
- **Repair:** "This abstraction removes the three-way handshake from every call site."
- **Legitimate use:** With an explicit foil. "The benchmark is real, unlike the marketing number"
  earns `real` because the fake version is named.

---

# FAMILY H — The engineering-metaphor connoisseurship family (Claude-specific)

The user's distinctive seeds. **This family is independently documented**, which is the single
most notable confirmation in this research: `load-bearing`, `seams`, and the `worth ___` family
all appear on claudisms.ai [C], and `load-bearing` is the headline item on two separate
Claude-tic writeups [C]. The user's private observations match a public banlist they had no
part in.

The mechanism is specific: borrowing a term from structural engineering, security, or systems
theory and applying it to prose, decisions, or abstractions. The borrowed term flatters both
writer and reader with a sense of technical rigor while asserting nothing checkable. It is
*connoisseur register* — it signals membership, not meaning.

### load-bearing
- **Tier:** 1
- **Why it reads as AI:** The flagship Claudism. Named as "most flagrant" by explainx [C], the
  "most frequently cited offender" by 7minai [C], and listed under insider-knowledge framing on
  claudisms.ai [C]. Documented drift path: structural engineering → comedy theory ("load-bearing
  joke") → everything [C].
- **Specimen:** "That test is load-bearing — don't delete it without understanding the seam."
- **Repair:** "That test is the only thing checking the retry path. Deleting it means the next
  regression ships." *(7minai's own repair: "That test guards the module boundary. Changing it
  risks the integration path, so update it deliberately.")*
- **Legitimate use:** Literal structural engineering — a load-bearing wall, beam, or column.
  In software, arguably acceptable once per document for a genuine single-point-of-failure
  dependency, but the word is now burned enough that "the only thing holding X up" is safer.

### earns its place / earns its keep / pays rent / carries its weight
- **Tier:** 1
- **Why it reads as AI:** [A] Not on the published lists — asserting this from my own strong
  tendency, and the user flagged it independently. The mechanism matches the documented
  `worth ___` family exactly [C]: an economic metaphor that certifies value instead of
  demonstrating it. The rent/keep/weight variants are interchangeable, which is the tell —
  none was chosen.
- **Specimen:** "Every abstraction in this codebase earns its keep."
- **Repair:** "There are four abstractions here. Each replaced at least three call sites."
- **Legitimate use:** In a genuine cut-list exercise where you are literally deciding what stays,
  once, as the framing of the exercise itself. Not as a per-item verdict.

### seam / seams / find the seams
- **Tier:** 2
- **Why it reads as AI:** Named by 7minai as a top-four Claude tic — "overused when discussing
  code structure or boundaries" [C]. [A] Confirmed: I reach for `seam` whenever I mean
  "boundary," "interface," or "the place where two things meet," which is most places.
- **Specimen:** "We should find the seams in this module before we split it."
- **Repair:** "Split it where the auth code stops touching the storage code — around line 340."
- **Legitimate use:** **Real term of art.** Michael Feathers, *Working Effectively with Legacy
  Code*, defines a seam precisely: a place where you can alter behavior without editing in that
  place. When you mean *that*, and especially when testing legacy code, use it. When you mean
  "boundary," say boundary.

### defense in depth
- **Tier:** 2
- **Why it reads as AI:** [A] Not on published lists. Asserting from tendency: I deploy it as a
  general endorsement of having more than one check, which drains a term that means something
  specific. The connoisseur-register mechanism is identical to `load-bearing`.
- **Specimen:** "Validating on both client and server gives us defense in depth."
- **Repair:** "The client validation is for UX. The server validation is the one that matters —
  the client's can be bypassed with curl."
- **Legitimate use:** **Real security term** for deliberately layered, independent controls where
  each layer assumes the others have failed. Legitimate when you can name the layers and the
  threat each stops. Slop when it means "we did two things."

### doing the work / doing the heavy lifting / carrying the argument
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai catalogs this as the "abstract-agency metaphor" family
  with the exact variants: `the word was doing the work`, `X is doing the work here`,
  `doing the heavy lifting`, `carrying the argument`, `holding the sentence up`,
  `the noun is doing all the lifting` [C]. explainx names `carry the argument` separately [C].
- **Specimen:** "The word 'mostly' is doing a lot of work in that sentence."
- **Repair:** "'Mostly' is hiding the failure case: it's true 95% of the time and catastrophic
  the other 5%."
- **Legitimate use:** Rare but real in close reading, once, when you then say *what* work.
  The construction has become a verbal tic precisely because it feels like analysis.

### the tell / that's the tell
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai, insider-knowledge framing [C]. Poker register that
  positions the writer as the one who reads the room. Self-congratulatory by construction.
- **Specimen:** "Three retries with no jitter — that's the tell."
- **Repair:** "Three retries with no jitter means every client retries at the same millisecond."
- **Legitimate use:** Actual poker and actual deception detection. Also, mildly ironically, in a
  document *about* AI tells, where it's the subject term.

### surface area / blast radius / footgun / sharp edges
- **Tier:** 2
- **Why it reads as AI:** [A] Not on published lists. Asserting: this is a cluster of borrowed
  hazard metaphors I reach for reflexively. Each has a real origin (attack surface; nuclear/SRE
  blast radius) and each has been diluted to mean "amount of stuff" and "how bad."
- **Specimen:** "The refactor reduces the API surface area and shrinks the blast radius."
- **Repair:** "The refactor drops the public API from 40 methods to 12, and a bad deploy now
  takes down one region instead of all four."
- **Legitimate use:** **All genuinely real.** `attack surface` in security, `blast radius` in
  SRE incident scoping, `footgun` in API design — established, useful, and precise when you
  attach a number or a boundary. Slop only when unquantified.

### compounds / compounding
- **Tier:** 2
- **Why it reads as AI:** claudisms.ai bans it in any context as a finance-adjacent growth
  metaphor [C]. Claims exponential dynamics for anything that merely accumulates.
- **Specimen:** "Small improvements to CI compound over time."
- **Repair:** "Cutting CI from 20 minutes to 8 gives each of the six engineers back about an
  hour a day."
- **Legitimate use:** Actual compounding — compound interest, compounding returns, compound
  growth with a rate. Also chemical compounds. Numbers make it legitimate.

### the whole game / that's the whole ballgame / the only thing that matters
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai's "totalizing-superlatives" category, with the full
  variant set [C]. Manufactured stakes: elevates one factor to sole importance to make the
  sentence land.
- **Specimen:** "Getting the data model right is the whole game."
- **Repair:** "A wrong data model means a migration later. Everything else here is reversible
  in an afternoon."
- **Legitimate use:** None. If one thing genuinely dominates, say what the others cost by
  comparison.

### the physics of / different physics / the rules of physics
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai, "pseudo-scientific metaphors" [C]. [A] Also mine —
  "the physics of the problem" is a phrase I use to mean "the constraints," dressed as natural law.
- **Specimen:** "Distributed systems have different physics."
- **Repair:** "In a distributed system you can't tell a slow node from a dead one. Every design
  follows from that."
- **Legitimate use:** Actual physics. Also arguably legitimate for genuine hard physical limits
  — speed of light and latency floors between datacenters is real physics, not a metaphor.

### lives / where X lives / sits
- **Tier:** 2
- **Why it reads as AI:** claudisms.ai, "pseudo-anthropomorphic placement," with the example
  "the risk lives somewhere specific" [C].
- **Specimen:** "The complexity lives in the reconciliation loop."
- **Repair:** "The reconciliation loop is 400 lines and has six early returns."
- **Legitimate use:** Completely standard for code location — "the config lives in `/etc`,"
  "that logic lives in the service layer." Native developer vocabulary; leave it. Flag only when
  the subject is abstract (complexity, risk, tension).

### reach for / reaches for
- **Tier:** 3
- **Why it reads as AI:** claudisms.ai, "grasping-metaphor tic" [C]. [A] Guilty — I use it
  constantly, including elsewhere in this document, for "chooses" or "uses."
- **Specimen:** "Most engineers reach for a queue when they should reach for a database."
- **Repair:** "Most engineers add a queue where a table with a status column would do."
- **Legitimate use:** Fine at low density and genuinely idiomatic for tool selection. Count it;
  don't ban it.

### first-class / non-trivial / under the hood / out of the box
- **Tier:** 3
- **Why it reads as AI:** [A] Not on published lists. Asserting: standard developer idiom that
  models overproduce because it's dense in training data and reads as fluent insider register.
  `non-trivial` is the weakest — it means "hard" while implying a proof.
- **Specimen:** "Under the hood, the driver has first-class support for non-trivial batch sizes."
- **Repair:** "The driver batches writes up to 64MB without extra config."
- **Legitimate use:** All four are ordinary technical English at normal density. `first-class`
  is precise in language design (first-class functions). Purely a frequency tic.

---

# FAMILY I — Reflective-pose and insight-announcement phrases

Distinct from hedging: these don't soften a claim, they stage the *arrival* at a claim, importing
an essayist's persona and a fabricated interior history. claudisms.ai devotes several categories
to this and it is heavily Claude-flavored [C].

### the key insight is / the crucial insight here
- **Tier:** 1
- **Why it reads as AI:** Seed item. Combines two independently verified excess words (`key`,
  `crucial`, `insights` — the last in the optimal 10-word detection set [V]) into one phrase that
  labels its own contents as insight. If it is one, the reader will notice.
- **Specimen:** "The key insight is that reads and writes have different consistency needs."
- **Repair:** "Reads can be stale. Writes can't. That asymmetry is what makes the cache safe."
- **Legitimate use:** None. Delete the frame, keep the claim.

### here's where it gets interesting / here's the thing that clicked
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai, "lecture-hall framing," with the full variant set:
  `Here's the analogy that clicked for me`, `Here's the moment that hit me`, `Here's the part
  that stuck` [C]. avoid-ai-writing flags "here-steering frames" as P1 [C]. Judges what's
  interesting on the reader's behalf.
- **Specimen:** "Here's where it gets interesting: the retry made it worse."
- **Repair:** "The retry made it worse."
- **Legitimate use:** None. The interest has to be in the content.

### what struck me / the part that stuck with me / I keep coming back to
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai has three separate categories for this —
  "false-singularity framing," "false-intimacy clichés," and "reflective-pose fillers" — with
  variants `the one that surprised me most`, `what struck me hardest`, `I can't stop thinking
  about`, `the question I keep coming back to`, `worth sitting with` [C]. avoid-ai-writing flags
  "lingering-attention claims" and "emotional flatline" as P1 [C].
- **Specimen:** "The thing I keep coming back to is how simple the fix was."
- **Repair:** "The fix was one line: a `WHERE` clause on the index."
- **Legitimate use:** In genuine first-person memoir, from someone who genuinely kept coming back
  to it. For an LLM, the interior history is fabricated, which makes it a lie as well as a tic.

### the point is / to be clear / let me be clear / let's break it down
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai lists `the point is` under throat-clearing and
  `Let's break it down` among imported phrases [C]; avoid-ai-writing bans "let's" openers as P1 [C].
  Announcing clarity in place of being clear.
- **Specimen:** "Let's break it down. The point is, the lock is held too long."
- **Repair:** "The lock is held across the network call. That's the bug."
- **Legitimate use:** `to be clear` when correcting a genuine, stated misreading. Once.

### full stop / period / and that's it
- **Tier:** 2
- **Why it reads as AI:** explainx names `full stop` as a distinct Claudism used as an emphasis
  device [C]. Punctuation-as-rhetoric: adds finality by naming a punctuation mark.
- **Specimen:** "Don't parse HTML with regex. Full stop."
- **Repair:** "Don't parse HTML with regex."
- **Legitimate use:** Rarely, once per long document, to mark a genuine refusal to qualify —
  where the surrounding text has been heavily qualified and this deliberately isn't. The contrast
  has to be real.

### at its core / fundamentally / essentially / in essence
- **Tier:** 1
- **Why it reads as AI:** `at its core` on claudisms.ai's imported phrases [C] and
  avoid-ai-writing's cut list ("cut it") [C]. Promises to strip away inessentials, then restates.
- **Specimen:** "At its core, a database is just a place to put bytes."
- **Repair:** "A database is a place to put bytes that you can find again after a power cut."
- **Legitimate use:** `fundamental` in its exact senses — fundamental frequency, fundamental
  theorem, fundamental group. Terms of art only.

### this matters / because it matters / here's why this matters
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai, "value-claim fillers": `worth talking about`,
  `because it matters`, `this matters`, `and that matters` [C]. Asserts stakes rather than
  showing consequences.
- **Specimen:** "The ordering guarantee matters here."
- **Repair:** "Without the ordering guarantee, a refund can post before the charge it refunds."
- **Legitimate use:** None. Replace with the consequence.

### we've seen this movie before / history rhymes / this is not new
- **Tier:** 1
- **Why it reads as AI:** claudisms.ai, "historical-precedent clichés," with variants
  `we have stood here before`, `we've been here before` [C]. Claims a precedent without naming it.
- **Specimen:** "We've seen this movie before with microservices."
- **Repair:** "This is the 2015 microservices argument with the nouns swapped: the same
  distribution costs, the same claimed team-autonomy benefit."
- **Legitimate use:** None as a bare phrase. Name the precedent and the phrase becomes unnecessary.

### that's not X, that's Y (as fixed phrase) / it's not just X, it's Y
- **Tier:** 2 — **boundary case, hand to the sentence-structure agent**
- **Why it reads as AI:** Structurally this is negative parallelism, which belongs to the sentence
  agent — Wikipedia lists it [C], slopdetector gives a threshold of ≥3 per article [C], explainx
  calls it "the most-cited pattern variant" [C]. It appears here only because `/deslopify` will
  want a lexical trigger to detect it: the literal strings `not just`, `isn't just`, `it's not X,
  it's`, `rather than`.
- **Specimen:** "It's not just faster — it's fundamentally cheaper."
- **Repair:** "It's 3× faster and costs 60% less."
- **Legitimate use:** Once per document, for a genuine correction of a live misconception the
  reader actually holds. The threshold, not the instance, is the rule.

---

# FAMILY J — Punctuation-adjacent lexical habits

### J1 — em dash overuse
- **Tier:** 3 (frequency), **model-dependent**
- **Why it reads as AI:** The most publicly discussed tell ("the ChatGPT hyphen") and the most
  misunderstood. **The best data [V]** (Freeburg 2026): human baseline **3.23 per 1,000 words**
  (range 0.33–17.12); **Claude Opus 4.6 at 9.09** unconstrained — ~2.8× human; GPT-4.1 at 10.62;
  but **Gemini 2.5 Pro at 3.53** (human-indistinguishable) and **Llama at 0.0**. So it is not an
  AI tell, it is an *OpenAI-and-Anthropic* tell.

  Two things `/deslopify` should take from this:
  1. **Sources disagree on the threshold.** Freeburg's human mean is 3.23; slopdetector's human
     range is 3.7–10 with a flag at 20/1000 [C]. Mark Twain measured 10.13 [C] — a canonical human
     writer above Claude's rate. Do not implement a hard cap; implement a ratio against the rest
     of the document's punctuation and the author's own baseline if you have one.
  2. **Claude's rate collapses 48× under instruction** (9.09 → 0.19), where GPT-4.1's barely
     moves (10.62 → 6.97, and 6.97 even under explicit prohibition) [V]. For Claude this is the
     one tic a single system-prompt line genuinely fixes. That is a real finding and it argues
     for prevention over post-hoc editing.
- **Specimen:** "The cache — which we added last quarter — helps, but the real fix — and this
  matters — is the index."
- **Repair:** "The cache we added last quarter helps. The real fix is the index."
- **Legitimate use:** **Genuinely a good mark.** One per paragraph for a real interruption or a
  sharp appositive is excellent prose. The tell is *stacking* — claudisms.ai's rule of "more than
  one per sentence" [C] is the better heuristic than any per-1,000-word cap. Also: never replace
  an em dash with a semicolon to dodge detection. That produces §J3.

### J2 — the rhetorical colon
- **Tier:** 2
- **Why it reads as AI:** explainx names colon/semicolon excess as a Claudism, "replaces
  conjunctions" [C]. The pattern is *setup: payoff* used as a rhythm device — "The problem is
  simple: X." It manufactures a beat of anticipation before an ordinary clause, and it is the
  prose residue of markdown's `**Label:** explanation` list format [V, by inference from Freeburg's
  markdown-training thesis].
- **Specimen:** "The problem is simple: the lock is held too long."
- **Repair:** "The lock is held across the network call."
- **Legitimate use:** Constantly legitimate — before a genuine list, a quotation, a definition,
  or a term being introduced. Flag the *dramatic* colon where both halves are full clauses and
  the first only announces the second.

### J3 — the semicolon as em-dash substitute
- **Tier:** 3
- **Why it reads as AI:** [A] Asserting. A second-order effect of em-dash awareness: prose edited
  to remove em dashes acquires an unnatural semicolon density, which is a *different* tell.
  Human technical writers use very few semicolons.
- **Specimen:** "The cache helps; the index is the real fix; both shipped last week."
- **Repair:** "The cache helps. The index is the real fix. Both shipped last week."
- **Legitimate use:** Separating list items that contain commas — the one place a semicolon is
  unambiguously correct. And in genuinely formal registers, sparingly.

### J4 — scare quotes / ironic quotation marks
- **Tier:** 2
- **Why it reads as AI:** [A] Asserting from tendency. Quoting a word to signal distance from it
  — "the 'simple' solution," "our 'temporary' fix" — is a hedge in punctuation form. It lets the
  writer criticize without committing to the criticism, which is the exact hedging profile of
  Family F.
- **Specimen:** "This is a 'temporary' workaround for the 'edge case.'"
- **Repair:** "This workaround has been in place for two years and fires on 8% of requests."
- **Legitimate use:** **Real and necessary:** quoting actual speech, marking a term you are about
  to define, mentioning a word rather than using it (the use/mention distinction), and flagging
  a term of art you consider contested where you then contest it.

### J5 — the bolded lead-in
- **Tier:** 2
- **Why it reads as AI:** avoid-ai-writing flags "inline-header lists with bold labels repeated"
  and bold overuse (limit: one phrase per major section) [C]; Wikipedia lists "vertical lists with
  inline headers" [C]. Freeburg's thesis — markdown saturation in training data shapes prose
  even when markdown is suppressed [V] — is the mechanism.
- **Specimen:** "**Performance:** The new parser is faster. **Safety:** It also rejects bad input."
- **Repair:** "The new parser is 3× faster and rejects malformed input instead of panicking."
- **Legitimate use:** Genuine reference material where the reader scans for a label — API docs,
  glossaries, option tables. This catalog uses the pattern deliberately for that reason.

### J6 — the ellipsis of anticipation / the one-word paragraph
- **Tier:** 2
- **Why it reads as AI:** [A] Asserting. Trailing "…" and single-word paragraphs ("Wrong.")
  import a listicle's dramatic pacing. Related to explainx's "fragment drama" finding — "Not a
  detail. A design decision." — which they note is *underreported* and creates a "pitch deck
  rhythm" across a document [C].
- **Specimen:** "We thought the index would fix it.\n\nIt didn't."
- **Repair:** "We added the index. p99 didn't move, because the query was scanning anyway —
  the planner ignored it."
- **Legitimate use:** Once per long piece, for a genuine reversal. The tell is the rhythm being
  the point.

---

# FAMILY K — Conversational and sycophantic artifacts

Chat-native residue. In published prose these are P0 — instant credibility loss [C].

### Great question / I love that you asked / Excellent point
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing P0 [C]; claudisms.ai imported phrases [C]. Evaluates
  the interlocutor before answering. In prose it has no referent at all.
- **Specimen:** "Great question! The answer depends on your consistency model."
- **Repair:** "It depends on your consistency model."
- **Legitimate use:** None in written deliverables. In live conversation it is at best a filler
  token; at worst, sycophancy.

### You're absolutely right
- **Tier:** 1
- **Why it reads as AI:** Named as a top-four Claude tic by 7minai [C], which recommends
  "simply making the correction and proceeding" [C]; avoid-ai-writing lists it under sycophantic
  tone, P0 [C].
- **Specimen:** "You're absolutely right — I should have checked the index first."
- **Repair:** "The index was already there. The query wasn't using it because of the type cast."
- **Legitimate use:** None. Agreement is shown by acting on the correction.

### I hope this helps / Feel free to reach out / Let me know if you have questions
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing P0 [C]. Customer-service closers on a technical document.
- **Specimen:** "I hope this helps! Let me know if you have any questions."
- **Repair:** *(delete)*
- **Legitimate use:** Actual correspondence with an actual person, where it's ordinary politeness.
  Never in a document.

### Certainly / Of course / Absolutely (as opener)
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing P0 [C]. Compliance tokens.
- **Specimen:** "Certainly! Here's how to configure the retry policy."
- **Repair:** "Retries are configured in `client.yaml`."
- **Legitimate use:** None as a standalone opener.

### As of my last update / I don't have access to (cutoff disclaimers)
- **Tier:** 1
- **Why it reads as AI:** avoid-ai-writing P0 — the single most damaging artifact because it
  identifies the author as a model [C].
- **Specimen:** "As of my last update, the library was at version 3.2."
- **Repair:** "This was written against v3.2." *(or: check and state the real version)*
- **Legitimate use:** In a live conversation where the knowledge boundary genuinely affects the
  answer. Never in a document that will be read later.

---

# FAMILY L — Vague attribution

Lexical because the tell is a small set of fixed subject phrases. Wikipedia treats this as one of
the strongest signals [C], and avoid-ai-writing rates it P0 [C].

### studies show / research suggests / experts agree / it is widely believed
- **Tier:** 1
- **Why it reads as AI:** Wikipedia's "vague attributions" list: `Industry reports`,
  `Observers have cited`, `Experts argue`, `Some critics argue`, `several sources` [C].
  slopdetector's threshold: >50% uncited authority claims [C]. A citation-shaped object with no
  citation, which is worse than no citation.
- **Specimen:** "Studies show that code review catches most defects before release."
- **Repair:** "Fagan's 1976 inspection data put pre-release defect capture around 60%. Modern
  replications are noisier." *(or: cut the claim)*
- **Legitimate use:** With the study named, ideally linked. `Research suggests` is acceptable as a
  lead-in to a footnote, never as a substitute for one.

### many argue / some would say / critics point out
- **Tier:** 1
- **Why it reads as AI:** Wikipedia [C]. Manufactures a debate to stage a balanced treatment.
  This is the lexical signature of Claude's documented both-sides reflex [C].
- **Specimen:** "Some would argue that monorepos don't scale."
- **Repair:** "Google runs a monorepo at billions of lines with custom tooling. Without that
  tooling, `git status` takes 40 seconds at ~10M lines."
- **Legitimate use:** When you name who, and preferably where.

### it is generally accepted / conventional wisdom holds
- **Tier:** 2
- **Why it reads as AI:** Same family. Slightly more defensible because sometimes consensus really
  is the referent.
- **Specimen:** "It's generally accepted that premature optimization is harmful."
- **Repair:** "Knuth's line about premature optimization gets quoted without its second half,
  which says the remaining 3% matters."
- **Legitimate use:** When the consensus is real, checkable, and you are about to dispute it.

---

# FAMILY M — Copula avoidance

Wikipedia treats this as a discrete category [C] and avoid-ai-writing lists it as a P2 pattern [C].
Lexically it is a closed set of verbs replacing `is`/`are`, which makes it trivially detectable
and therefore high-value for `/deslopify`.

### serves as / stands as / functions as / operates as / represents / marks
- **Tier:** 1
- **Why it reads as AI:** Wikipedia's full copula-avoidance set [C]. Models avoid `is` because
  training data rewards varied predicates, so ordinary identity statements get inflated into
  role-assignments.
- **Specimen:** "The gateway serves as the single entry point and represents a key part of the
  architecture."
- **Repair:** "Every request goes through the gateway."
- **Legitimate use:** `serves as` when something is standing in for something else it isn't —
  "the conference room serves as our recording studio." Genuine substitution, not identity.
  `represents` when there is a real representation relation — a symbol representing a value,
  a delegate representing a constituency.

### boasts / features / offers / provides / maintains (of inanimate subjects)
- **Tier:** 2
- **Why it reads as AI:** Wikipedia's copula-avoidance list [C]; `boast` also verified as one of
  the five largest measured increases [V]. Products don't offer, boast, or provide — they have.
- **Specimen:** "The library provides comprehensive support for streaming and offers a robust
  plugin API."
- **Repair:** "The library streams, and you can write plugins against a documented interface."
- **Legitimate use:** `provides` and `offers` where there is a genuine giver and receiver —
  a service provider, an API offering an endpoint under a contract. `maintains` of state
  ("the struct maintains an invariant") is precise and standard.

---

# 11. Appendix — the verified 135-term list, reproduced

From *Perspectives on Medical Education*, "Delving Into PubMed Records"
<https://pmejournal.org/articles/10.5334/pme.1929> [V]. **103 of these 135 showed meaningful
increases (modified Z-score ≥3.5) by 2024.** This is the highest-confidence raw material
available and should seed `/deslopify`'s detector directly. Terms already covered above are
included for completeness.

**Verbs (41):** address, align, boast, bolster, catalyze, comprehend, delve, elucidate, embark,
emerge, employ, emphasize, encompass, endeavor, enhance, excel, exhibit, explore, facilitate,
fortify, foster, garner, grapple, harness, highlight, illuminate, integrate, interplay, juxtapose,
leverage, navigate, necessitate, offer, outperform, revolutionize, scrutinize, showcase, surpass,
transform, transcend, underscore, unearth, unveil

**Adjectives (32):** actionable, commendable, complex, comprehensive, critical, crucial, deeper,
essential, exceptional, exhaustive, expansive, fresh, fundamental, groundbreaking, ingenious,
innovative, intricate, intriguing, invaluable, meticulous, multifaceted, noteworthy, nuanced,
pivotal, potent, potential, renowned, significant, transformative, unlocking, valuable, versatile,
well-rounded

**Adverbs (26):** accurately, additionally, aptly, compellingly, effectively, effortlessly,
excellently, impressively, lucidly, methodically, notably, particularly, predominantly, primarily,
profoundly, promptly, reportedly, scholarly, seamlessly, strategically, subsequently, thereby,
thoroughly, thoughtfully, ultimately, undoubtedly

**Nouns (23):** advancement, capability, complexity, ecosystem, enhancement, essence, finding,
foundation, insight, intricacy, journey, landscape, milestone, pipeline, prowess, realm,
significance, tapestry, testament, thought, understanding, utilization

**Two-word phrases (10):** deep dive, driving force, ethical consideration, exercise caution,
game changer, in addition, in summary, knowledge gap, shed light, vital role

**Largest measured increases:** delve, underscore, primarily, meticulous, boast.

---

# 12. Design notes for `/deslopify`

1. **Verbs first.** 66% of measured excess is verbs [V]. A verb-first pass will beat an
   adjective-first pass on the same budget.
2. **Do not build the detector out of the famous words.** The optimal 10-word discriminating set
   from the largest study is *across, additionally, comprehensive, crucial, enhancing, exhibited,
   insights, notably, particularly, within* [V]. `tapestry` and `delve` are high-notoriety,
   low-frequency. The words that actually separate machine from human text are boring.
3. **Deletion beats substitution.** See §0. A large share of Tier 1 entries above repair to
   *nothing* — the phrase is removed and the sentence improves. Weight the edit policy toward cut.
4. **The lexicon decays.** Wikipedia already versions its list by era (2023–mid-2024 vs.
   mid-2024–mid-2025) [C] and the words turned over between them. Any static list needs a
   review date. Consider storing the catalog with per-entry `last_verified`.
5. **Density, not presence, for Tier 3.** Implement the §0 thresholds as counters over a rolling
   window, not as string matches.
6. **Prevention beats editing for punctuation.** Claude's em-dash rate falls 48× on instruction;
   GPT-4.1's barely moves [V]. If the pipeline can inject a system-prompt line, do that instead
   of post-editing.
7. **Register-gate everything.** `robust` in a statistics paper, `harness` for a test harness,
   `seam` in Feathers' sense, `framework` for React, `journey` for a user journey, `surface` in
   product engineering — all correct. A context-blind pass will do real damage to technical prose.
   The `avoid-ai-writing` skill's context profiles [C] are a reasonable model to copy.
8. **Watch for second-order tells.** Editing for one signal creates another: removing em dashes
   raises semicolon density (§J3); avoiding word repetition produces synonym cycling, itself a
   documented tell [C]. The edit pass needs its own output audited.

---

# 13. The lift list — measured overrepresentation `[V]`

1,000 words, measured over **461,121 documents and 51.1M word appearances across 85 weeks
(2025–2026)** from the load-bearing dashboard (<https://louisabraham.github.io/load-bearing/>).

Two files, and the difference matters:

- **`lift-words.txt`** — the source, in the published order: descending **lift**, how much
  more often a word appears in LLM text than in a matched human baseline. `load-bearing`
  tops it at **39.5×**; the tail at #1,000 sits near **5×**. Input only.
- **`lift-words.tsv`** — the working file, re-ranked by **salience**. Carries the `tf`
  and `idf` terms alongside the score, so any row can be audited without rerunning
  anything. `scan.sh` reads columns 1, 2 and 5; the rest show the working. 999 rows: the published
  list counts the em dash as a word (lift #852), and `scan.sh` measures em dashes directly,
  so that entry keeps its rank but gets no row. Regenerate with
  `uv run --with wordfreq --python 3.12 tools/rescore.py`, and `bash tests/check.sh`
  asserts that the committed file is what the script produces.

Neither is alphabetized. Sorting either would throw away the only thing separating a
fingerprint from a common word.

### Why lift alone is the wrong order

Lift answers "does an LLM say this more than a human does?" That ranks `nothing` at #25,
`never` at #127, `four` at #428 — words no editor can act on, because deleting them is not
a repair. High lift on a word that is everywhere in English produces hits you cannot use.

Salience answers the operational question instead: **how much does one occurrence deserve
your attention?** A word earns attention only when it is both overrepresented *and*
unusual in English at all — lift × rarity, the same shape as TF-IDF. Rarity comes from
`wordfreq`'s Zipf scale (8 ≈ *the*, 3 ≈ uncommon, 0 ≈ absent).

**The combination is a product, not a sum, and that is the whole design.** A sum lets
either term rescue a word, which promotes engineering jargon that is rare in general
English but ordinary in a pull request: `greps`, `diffed`, `retargets`, and `grepped` all
landed in the top 28 under a sum, on lift ranks of 244–392. The product requires both, so
weakness on either axis is fatal — `greps` sits at #95 instead of #22. Nothing rises on
rarity alone.

What moved:

| | lift rank | salience rank |
|---|---|---|
| `load-bearing` | 1 | **1** |
| `byte-identical` | 16 | **2** |
| `re-derived` | 6 | **3** |
| `chokepoint` | 58 | **8** |
| `nothing` | 25 | 401 |
| `never` | 127 | 820 |
| `four` | 428 | 802 |
| `said` | 335 | 939 |

**Three assumptions, all disclosed in `tools/rescore.py`, all one constant from changing.**
Lift is *modelled from rank* — the source publishes rank order and only two lift values, so
`lift(r) = 39.47·r^-0.299` is fitted to those anchors; being monotone in rank it sets how
steeply attention decays, never which word beats which. Hyphenated compounds take a **1.5
Zipf penalty**, because `wordfreq` splits `byte-identical` into *byte* + *identical* and
returns 3.11 — scoring a minted compound as more common than the dictionary word
`chokepoint` at 1.46. It answers "how plausible is this compound" when the question is "how
often does this exact string occur," which for a coinage is never; minting it is the tell.
Twenty-one words absent from `wordfreq` entirely get a **0.8 floor** rather than infinite rarity,
since zero is a sentinel for "not in corpus," not a measurement.

### Why this list is different from every other list in this file

Families A–L are *curated*: someone noticed a word and wrote it down. This one is
*measured*, and it was built without reference to any of them. So the overlap is
evidence rather than echo.

Four of the top eleven — `load-bearing` (#1), `quietly` (#3), `genuinely` (#10),
`deliberately` (#11) — already have hand-written entries above, arrived at independently.
Several §H "Claudisms" reappear too: `seam` at #51, `earns` at #249. And the list
corroborates `tics.md` from the other direction: `nothing` (#25) is the noun inside
*"that's not nothing"*, `mattered` (#82) inside *"that's why X mattered"*, `honest` (#83)
and `honestly` (#138) inside performative honesty, `worth` (#185) inside *"worth naming"*,
`whole` (#298) inside *"that's the whole point"*.

Two methods, different corpora, same words. That upgrades those entries from opinion to
finding — and it means the seven top-11 words with *no* curated entry (`plainly`,
`refusal`, `survived`, `re-derived`, `halves`, `asserted`, `nobody`) are the ones this
catalog was missing.

### The corpus caveat — read before using it

**The corpus is GitHub pull requests.** That is why `goldens`, `mutation-checked`,
`round-2`, `byte-identical`, and `fleet-wide` rank so high, and it sets where the list
works:

- **Agent-written engineering prose** — PR descriptions, commit messages, review
  comments, design docs, session summaries. Highest precision. This is the list's home
  turf and it is very good there.
- **Essays and technical writing** — useful, with the ordinary words ignored.
- **Marketing and landing copy** — weak. Use `marketing.md` instead. Half of what
  makes a landing page slop does not appear here at all.

### Reading a hit

**Presence means nothing; salience and density mean something.** The list still contains
`never`, `whole`, `said`, `four`, and `every` — ordinary English, kept because they
corroborate, scored so they cannot trigger. A document using them is a document written in
English.

Band on the salience score, which `scan.sh` prints beside every hit:

| Salience | Ruling |
|---|---|
| **50+** (38 words) | Distinctive. One instance is worth reading in context; two of the same word is a finding. |
| **30–49** | Density band. Above **15 hits per 1,000 words** in this band, run the verb-first pass over it; below that, act only on an instance `scan.sh` marks `⨯` (it sits on a line a tic detector also hit). Cross-reference against the families above and `tics.md` before acting. |
| **under 30** | Corroborating evidence, never a trigger. Do not edit a word because it appears here. |

Calibration: four human-written technical READMEs (abseil, apache-arrow, aws-c-common,
ada-url) scored **1.6–10.9 hits per 1,000 words with nothing above salience 50**; a
paragraph of agent-written engineering prose scored **294/1k with 8 words above 50**. The
raw hit count includes the ordinary words that score under 30, so read the 50+ count
first. Treat **any two hits at 50+** as worth a close read. Below that, the list has
told you nothing. The 15/1k trigger for the 30–49 band comes from three fixtures:
model-written clean prose sits at 5.4, agent-written engineering prose at 19.6, the
seeded tic fixture at 20.7. Three points is a first calibration, not a law.

### Ruling an instance

The list ranks words. The ruling is on an instance, in its sentence, and `scan.sh`
prints what the sentence needs decided:

- **`"quoted"`** — the word sits inside double quotes. The document is talking about
  slop, not committing it. Skip.
- **`⨯ tic-id`** — the word sits on a line a tic detector also hit. Read the
  construction, not the word: `mattered` inside *"that's why X mattered"* is that
  tic's symptom, and repairing the tic removes the word. This mark makes a 30–49
  word actionable on its own; a 50+ word carrying it is two findings on one line.
- **No mark** — read the sentence for the third question: is this the document's term
  of art, defined once and repeated on purpose? A README that says `ruling` eleven
  times because rulings are what it describes has vocabulary, not accent. Leave it,
  and do not cycle synonyms to make the count go down.

### Three shapes worth more than any single word

The list's real value is not its members but what they have in common.

1. **Coined hyphenated compounds — 159 of 1,000 (16%).** Salience ranks these hardest, by
   construction: six of the top fifteen are compounds. `byte-identical`, `mutation-checked`,
   `self-heals`, `fail-loud`, `behaviour-preserving`, `caller-supplied`, `data-loss`,
   `fall-through`. Minting a precise-sounding compound is the single most distinctive move
   on the list, and it is rare in human engineering prose, which reuses the team's existing
   vocabulary instead. *Repair:* use the phrase the codebase already uses.
2. **Spelled-out cardinals — `eleven` (#55), `nine` (#134), `thirteen` (#135), `twelve`
   (#151), `fourteen` (#260), `eight` (#311).** Odd numbers written as words, deep in
   prose: "eleven call sites," "thirteen of the fourteen tests." The count is usually real;
   the habit of narrating it is the tell. *Repair:* keep the number, drop the ceremony —
   or use the numeral.
3. **Whole inflection families.** `refuse / refused / refuses / refusing / refusal /
   refusals` — six entries. Likewise `derive`, `assert`, `survive`, `stamp`, `contradict`,
   `measure`, `widen`. A family appearing across the document beats any single member
   appearing twice. Grep the stem, not the word.

**One more, easy to miss:** the list carries British spellings — `behavioural`, `honoured`,
`modelled`, `recognised`, `unrecognised`, `neighbour(s)`, `judgement`. For a writer in US
register these are not vocabulary tells at all; they are *provenance* tells, and no amount
of rewriting hides them. Check spelling register before anything else.

### How not to use it

Not as a banlist, and never with `sed`. Every §0 warning applies with more force here,
because a ranked list of 1,000 words is exactly the artifact that invites a mechanical pass.
Rank tells you where to look. The context tells you whether there is anything there.


---

# 14. Sources

- Kobak et al., *Science Advances* — <https://www.science.org/doi/10.1126/sciadv.adt3813>
- Preprint (fuller tables) — <https://arxiv.org/html/2406.07016v1>
- PMC mirror — <https://pmc.ncbi.nlm.nih.gov/articles/PMC12219543/>
- *Perspectives on Medical Education* (135-term list) — <https://pmejournal.org/articles/10.5334/pme.1929>
- Freeburg, "The Last Fingerprint" (em-dash rates) — <https://arxiv.org/html/2603.27006v1>
- Wikipedia:Signs of AI writing — <https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing>
- claudisms.ai — <https://claudisms.ai/>
- explainx.ai, Claude Opus 5 Claudisms — <https://www.explainx.ai/blog/claude-opus-5-load-bearing-claudisms-writing-tells-2026>
- 7minai, Claude filler phrases — <https://7minai.com/how-to-stop-claude-overusing-filler-phrases/>
- conorbronsdon/avoid-ai-writing — <https://github.com/conorbronsdon/avoid-ai-writing>
- slopdetector, signs + thresholds — <https://slopdetector.org/blog/signs-of-ai-writing>
- slopdetector, em-dash data — <https://slopdetector.org/blog/em-dash-ai-tell-data>
- contentbeta word list — <https://www.contentbeta.com/blog/list-of-words-overused-by-ai/>
- oliviacal, AI writing tells + blacklist — <https://www.oliviacal.com/post/ai-writing-tells>
- load-bearing, measured word lift over 461k PRs — <https://louisabraham.github.io/load-bearing/>
- LLM cliché highlighter (38 patterns) — transcribed into `tics.md`

**Entry count:** 123 catalog entries across 13 families, plus the §14 lift list (1,000 ranked words) (65 Tier 1, 42 Tier 2, 13 Tier 3, 3 split),
plus the 135-term verified appendix. Many entries are families rather than single terms, so the
underlying vocabulary covered is roughly 350 distinct words and phrases.
