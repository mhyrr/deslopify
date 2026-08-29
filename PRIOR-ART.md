# Prior art: how other deslop prompts are built, and how they fail

> Design rationale for this skill. Not loaded during an edit pass.
> Read before changing SKILL.md's structure. Section 2.7 is the spec SKILL.md was built from.

## 2.0 Headline findings

Roughly 20 artifacts were read in full. Four matter more than the rest:

1. **petergyang/no-ai-slop** — the best-designed *prompt* in the space.
   Editor-role framing, two modes, ~20 pattern+repair triads, an explicit
   minimum-effective-edit stopping condition, and a stated refusal to score:
   "AI detectors guess. Named patterns are evidence the user can check."
   Launch post: https://creatoreconomy.so/p/use-my-no-ai-slop-skill-to-remove-20-ai-slop-patterns
2. **Wikipedia: Signs of AI writing** — https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing
   The best-curated, most concrete, continuously-maintained taxonomy of AI tells
   in existence. Free, versioned by era, evidence-backed with dated diffs, and
   it contains a **dedicated "Promotional and advertisement-like language"
   subsection** — one of only three places in the prior art that touches our
   genre at all.
3. **blader/humanizer** — https://github.com/blader/humanizer
   Structurally the closest thing to what `/deslopify` should be: 36 patterns in
   5 categories on a fixed field template, plus a draft → audit → final loop and
   explicit anti-fabrication guardrails. Derived from the Wikipedia page. Does
   **not** address marketing copy and explicitly scopes itself to
   encyclopedic/technical registers.
4. **Vale** (https://vale.sh) and its Google/Microsoft style packages —
   the most imitable *schema*. Each rule is `message` + `link` (rationale) +
   `tokens`/`swap` (concrete instances and replacements) + `level`
   (suggestion/warning/error), with known false positives documented inline.

**The one-sentence version of the whole survey:** the corpus splits into
blacklists, rubric-scorers, and editor-role prompts; only the third family works,
because the other two tell the model what to delete without telling it what to
put there, and never tell it when to stop.

**And the gap:** of ~20 artifacts, **two** address marketing copy natively, and
two are actively hostile to the persuasive register. Section 1 of this document
is new work, not a re-derivation.

---

## 2.1 Published deslop / anti-AI-voice prompts and skills

### Wikipedia: Signs of AI writing
https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing

**What it is:** a community-maintained detection guide from WikiProject AI
Cleanup, not a prompt — but it functions as the upstream source for most of the
good prompts.

**Structure:** eight top-level sections — Caveats, Content, Language and
grammar, Style, Communication intended for the user, Markup, Citations,
Miscellaneous. Each entry has: a header with a shortcut code, a bold
**"words to watch"** list, an explanatory paragraph, **multiple verbatim
examples pulled from real articles with dates and revision links**, and context
notes on how the pattern varies by model and by era.

**Why the structure works:** the "words to watch" list is separated from the
explanation, so the reader (or model) gets both the searchable surface marker
*and* the underlying construction. That separation is what stops the list from
being a pure blacklist.

**Marketing relevance — the one real hit in the prior art.** The
"Promotional and advertisement-like language" subsection catalogues exactly the
register we care about: `boasts a`, `vibrant`, `nestled`, `in the heart of`,
and what the page calls "travel guide" prose. Its canonical specimen:

> "Nestled within the breathtaking region of Gonder in Ethiopia, Alamata Raya
> Kobo stands as a vibrant town with a rich cultural heritage"

It has subtypes for cultural-heritage puffery and for press-release-style
writing about organizations. This is the closest existing prior art to our
Section 1, and it is still aimed at encyclopedic neutrality rather than at
persuasive copy — it tells you to *remove* the promotion, not to *replace it
with a better claim*. That's the gap our command fills: on a landing page,
neutral-and-plain is not the target; specific-and-checkable is.

**Explicit false-positive discipline** (worth copying verbatim in spirit):
- "Do not solely rely on artificial intelligence content detection tools…
  these tools have non-trivial error rates."
- Humans distinguishing AI text perform "no better than random chance."
- The signs are "potential signs of a problem, not the problem itself."

### blader/humanizer
https://github.com/blader/humanizer

**What it is:** an agent skill (SKILL.md) for de-AI-ifying prose. Derived from
the Wikipedia taxonomy.

**Structure:** 36 patterns across 5 categories —
- CONTENT PATTERNS (6): significance inflation, notability claims, superficial
  analyses, promotional language, vague attributions, formulaic sections
- LANGUAGE AND GRAMMAR (13): vocabulary, copula avoidance, negative parallelism,
  rule-of-three, synonym cycling, false ranges, passive voice, em dashes
- STYLE (5): em dashes, boldface, inline headers, title case, emojis, curly quotes
- COMMUNICATION (3): chatbot artifacts, knowledge-cutoff disclaimers, sycophancy
- FILLER AND HEDGING (9): filler phrases, hedging, generic conclusions,
  persuasive tropes, signposting, fragmented headers, manufactured drama,
  aphorisms, conversational openers

**Per-rule template:** pattern name → **words to watch** → **problem** (why LLMs
produce it) → **before/after pair**. Uniform, and the "problem" field is doing
real work: explaining the *mechanism* gives the model a generalization rule
rather than a string match.

**Process loop:** draft rewrite (preserve information, match voice, identify
patterns) → **audit** ("What makes this obviously AI?" / "Did you invent
facts?") → final rewrite. The audit turn is the single best procedural idea in
the prior art.

**Guardrails:**
- "Never invent facts" — no fabricated names, dates, citations, or claims.
- "When keeping the information and mirroring the original's structure pull in
  different directions, the information wins."
- Cluster detection: "When in doubt, look for clusters of tells, not isolated
  ones."
- Register awareness: "For encyclopedic, technical, legal, or reference text,
  neutral and plain *is* the correct human voice; don't inject opinions or first
  person there."

**Where it overreaches:** a hard "the final rewrite contains no em dashes" rule.
Wikipedia explicitly disclaims that reading — the tell is em dashes used *where
a comma, colon, or parenthesis would serve*, i.e. substitution context, not raw
presence. A blanket ban is the classic over-correction (see failure mode (c)).

**Marketing coverage:** none. Explicitly out of scope.

### petergyang/no-ai-slop — the strongest artifact in the survey
https://github.com/petergyang (skill: `skills/no-ai-slop/SKILL.md` + `eval.md`)
Launch post: https://creatoreconomy.so/p/use-my-no-ai-slop-skill-to-remove-20-ai-slop-patterns

**Structure:** role frame ("You are a sharp human editor") → **two modes (Edit /
Detect)** → intake questions → 17 editing principles → banned-word list → ~20
pattern + example + repair triads → 6-step workflow with a self-eval loop
against a separate 26-question `eval.md`. ~1,700 words.

**Why it's the best of the corpus — four mechanisms worth stealing outright:**

- **A stated stopping condition, three times over.** "Make the minimum effective
  edit… Leave strong human sentences alone. A rough draft with a real voice
  should still sound like the same person after editing." Enforced by eval Q4:
  "Is the amount of cutting proportional to the actual slop, with no aggressive
  compression that strips out character?"
- **An explicit anti-rubric stance.** In Detect mode: "Do not rewrite, score the
  draft, or guess whether AI wrote it. AI detectors guess. **Named patterns are
  evidence the user can check.**" This is the sharpest sentence in the corpus
  and a direct rebuke to every 50-point-rubric skill.
- **The portability test** — the single most transferable heuristic for our
  genre, and independently the same idea as our swap test: "If a sentence could
  move unchanged to another person, company, country, or product, it is probably
  filler. Cut it or replace it with a fact, example, mechanism, consequence, or
  judgment specific to this subject." Note that it names the *destinations*, not
  just the offense.
- **Calibrated rather than banned.** Em dash: "In short copy, use none. In
  longer drafts, 1-2 are fine if they clearly beat commas, periods, or
  parentheses." Adverbs: "Cut them when they add nothing. Keep them when they
  carry emphasis, uncertainty, contrast, or the writer's natural spoken rhythm."

Its repairs also specify the *shape* of the fix, not just the outcome:
> **Fake-profound kickers.** …Do not rewrite it into a better metaphor. Do not
> preserve the rhythm. Delete it, then end on the clearest concrete sentence
> already in the draft.

**Weak:** 17 principles + 20 patterns + 26 eval questions is a lot of surface
(failure mode (b)), and eval Q1 ("Was the edit checked directly against this
file…") is a meta-question the model can only answer yes to.
**Marketing:** partial. Intake asks "Who is this for and where will it be
published?" and it recognizes "short copy," but the pattern library is
blog/newsletter-shaped.

### mantasdigital/no-ai-slop-skill — the only artifact that names landing pages
549 words. Structure: (1) **anchor to a real voice before writing** — "Ask the
user for 2–3 samples of their previous writing… Do not fall back to a default
'professional marketing' voice. **That default IS the slop**"; (2) a 6-row
Pattern|Example table (contrast flip, triple hammer, everyone/nobody, not-just
reframe, rhetorical setup, hollow intensifiers); (3) no em dashes; (4) vary
rhythm; (5) a 5-step final pass.

Two things to carry over. Its check 4 is a marketing-native portability test:
"Could this paragraph appear on any competitor's site unchanged?" And its
caveats section is the best override clause found anywhere: **"If the user's own
voice samples use em dashes or these structures, their voice wins. Mirror the
user, not the rulebook."** It also flags the recursion problem: "A 'casual
personal anecdote opener' is itself becoming an AI pattern."

### Krirox/anti-ai-slop-skills — the best marketing word-list, because every ban has a destination
Nominally a frontend/UI de-slop skill, but its §"Copy rules (this is half the
battle)" is directly on target for landing pages. Bans: "Unlock the power of,"
"Whether you're a [X] or a [Y]…," "Take your [X] to the next level," "The future
of [X] is here," parallel triplets. Crucially it pairs each ban with a
**Replace with** column: specific numbers ("Cuts onboarding from 6 weeks to 3
days for the 47 ops teams using it"), named subjects, concrete verbs ("imports,
exports, splits, merges, queues — not leverages, facilitates, enables"),
opinions, dated claims.

Its root-cause framing is the strongest diagnostic in the corpus: four causes
(no hierarchy, no specificity, no restraint, no opinion) plus **"If a fix
doesn't address one of these four, it's cosmetic."**

### hardikpandya/stop-slop — https://github.com/hardikpandya/stop-slop
361-word SKILL.md + `phrases.md` (~90 banned strings in 8 buckets),
`structures.md` (11 patterns), `examples.md` (5 before/after pairs).
Structure: 8 numbered rules → 12-item interrogative "Quick Checks" → a
5-dimension 1–10 rubric ("Below 35/50: revise").

**Good idea:** the Quick Checks are detect-then-act pairs ("Any passive voice?
Find the actor, make them the subject") rather than bare prohibitions.

**Broken, and instructively so — it contradicts itself inside its own artifact.**
Rule 6 says "No em dashes"; `examples.md` Example 4's *After* is
`"Speed, quality, cost—pick two."` Rule 2 bans dramatic fragmentation;
Example 3's *After* is `"Move faster. Your competition is."` Worst, Example 2
lists among its changes `Cut hedging ("most")`, turning "most teams struggle
with alignment" into "Teams struggle with alignment. Nobody admits confusion."
— converting a true hedged claim into a false absolute and calling it an
improvement. "Kill all adverbs. No -ly words" is unqualified. This is the
canonical demonstration of failure mode (c), and it is the upstream source for
several downstream skills.

### stephenturner/skill-deslop — https://github.com/stephenturner/skill-deslop
Post: https://blog.stephenturner.us/p/deslop
A superset of stop-slop (1,191-word SKILL.md + 4 refs incl. a 33-entry
`tropes.md` synthesized from tropes.fyi). 10 rules → 17 Quick Checks → the same
5D/50 rubric → 15 before/after pairs.

**The one idea worth taking:** Rule 6, "Match register to context" — the *only
genre-conditional rule in the entire corpus*. It says domain terminology is fine
in scientific prose ("'Weighted interval score' is precise language, not
jargon") and that blog voice is wrong there. **This is exactly the mechanism a
marketing version needs, pointed at a different genre** — on a landing page,
persuasion is the correct register, and a rule set that treats persuasion itself
as slop will destroy the page.

**Broken:** inherits stop-slop's em-dash hypocrisy (its own `tropes.md` uses two
em dashes while Rule 9 bans them), and adds "Two items beat three" as law plus
Quick Check 17 "Tricolon (three-item list)? Use two items or one" — a blanket
ban on a legitimate rhetorical device. The blog post reports a cover letter
scoring **8/50 before, 43/50 after** — a model grading its own rewrite on an
unanchored rubric it applied mid-inference. The author's own caveat is the most
honest line: the tool is for "bureaucratic packaging," and "I *never* let AI
speak for me."

### MariusAure/anti-slop-writing
615-word single-file system prompt ("Anti-Slop Writing v6"). Four sections:
~55 banned words in one comma-run; banned patterns in 6 themed paragraphs;
7 required behaviors; a silent self-audit.

**Two genuinely good ideas.** It opens with a *failure-mode statement* rather
than a rule — "Your #1 failure mode is smooth, confident text that says little"
— which orients the whole pass. And its epistemic rule is unique: "Every
sentence must pass 'How do you know?' Add a checkable detail, narrow the claim,
or delete it."

**Actively hostile to our genre:** it is a Wikipedia-register prompt. "Present,
don't persuade… No praise, hype, moral stance." Applied to a landing page that
deletes the page. Also bans "significant, comprehensive, robust, enhance" with
the escape hatch "unless justified with specific evidence" — which the model
will not adjudicate. Zero examples, zero repairs, zero stopping condition.

### adenaufal/anti-slop-writing — the maximalist, and the best structural insight
`english/SKILL.md` is 5,182 words; `references/` ~200KB including a 176KB
Wikipedia dump. Structure: core principle → 15 structural rules → 12
English-specific → 7 content → 9 voice → 5 **anti-detector** rules → a 36-item
post-generation checklist.

**Genuinely valuable — it is the only artifact that tracks model drift:**
> "The 2026 Shift: Structure Beats Punctuation… Cadence uniformity is the #1
> tell of 2026."

It supplies two falsifiable eyeball tests: if more than half of sentence openers
start with "The," "This," "It," or "In," the text reads as LLM-assisted; and
three or more consecutive sentences in the 17–23 word band reads the same way.
Rule EN-12 names the deepest structural tic in the corpus: "82% of AI-generated
text follows the same argument cadence… Opening → Expansion → Contrast →
Resolution… **Prompt instructions do not remove it; the model rebuilds it under
any vocabulary.**" It also concedes the point that kills the whole blacklist
family: "vocabulary tells… have been trained out of the newest Claude models.
**Absence of these legacy tells proves nothing.** What survives prompt rewrites
and model updates is structural."

**Broken:** its objective function is beating Turnitin/GPTZero, not being good.
T-2 instructs "imperfect punctuation"; the checklist mandates injecting
artifacts ("if none, add at least one [fragment]," "add at least one question,"
"Add at least 2-3 register shifts"). That is manufactured quirk on a schedule —
the prompt-level version of the humanizer anti-pattern in §2.3.

### BioInfo/slopless — `rules/writing-voice.md`
A drop-in `~/.claude/rules/` file rather than a skill. ~150 banned strings in 11
semantic buckets, 10 structural anti-patterns, then quantified rhythm rules:
"Within each paragraph, include at least one sentence under 8 words and one over
20 words. Never write three consecutive sentences in the 12-18 word range."
Has a register ladder (Slack → published).

**Most important single line in the corpus for our genre** — the only artifact
that names the collision between the specificity rule and the honesty rule:
> "NEVER fabricate specifics to sound helpful. **Vague but honest beats specific
> but invented.**"

That is failure mode (g), stated by someone who hit it.

### surdijon/ultimate-humanizer — the best control structure
50 patterns (P1–P50), French-calibrated, 3,284-word SKILL.md + 21KB reference.
Despite being the most rule-dense artifact surveyed, it has by far the best
*control* apparatus:
- **Intensity tiers** (`--lite` = P1–P14 only) and an explicit priority order
  ("traite d'abord P1-P5, P7, P13, P14 — les plus fréquents et impactants").
- A **hard 2-pass cap** with a named stopping condition: "Livre toujours après
  l'étape 6 ou 7. Jamais de boucle."
- A **protected-content list**: code, numbers, quotes, proper nouns, URLs,
  markdown structure.
- A **false-positive list** ("Faux positifs — À NE PAS signaler seuls": perfect
  grammar, dry technical writing, formal vocabulary, curly quotes alone).
- A **preserve list** ("Signes d'écriture humaine à PRÉSERVER": unusual specific
  details, mixed feelings, personal opinions).
- A **no-op path**: "Si aucun pattern… livre directement 'Texte déjà humain' et
  arrête-toi. Seuil de tolérance : 1 pattern faible = pas d'intervention."
- A `--selftest` mode computing precision/recall against `tests/fixtures.md`.
- The only rubric bound to countable proxies ("Compte les méta-commentaires :
  0 = 8-10, 1-2 = 4-7, 3+ = 1-3") plus an anti-inflation clause.
- And the design principle the whole category should adopt: **"un anti-slop ne
  doit pas produire de slop"** — hence changelog by default, before/after only
  on `--explain`.

### realrossmanngroup/no_ai_slop_writing_rules
CLAUDE.md (24 rules) + a skill converting 9 of them into WRONG/RIGHT pairs.
Every repair replaces a vague claim with a checkable fact:
> WRONG: "The pricing was significantly higher than the cost of the part."
> RIGHT: "They charged $1,200 for a repair that needed a $5 chip."

Self-check is 10 steps ordered **mechanical-first** (search for the em dash
character) **then judgment-last** (read it aloud) — a good ordering to copy.
Rule 13, "Write like a researcher, not a copywriter," is explicitly
anti-marketing; useful to us as an inverted mirror.

### tropes.fyi
The upstream catalog feeding skill-deslop, the Gemini CLI skill, and others.
49 tropes in 6 categories (Word Choice, Sentence Structure, Paragraph Structure,
Tone, Formatting, Composition), each with a definition, a status label
(new/rising/consistent/fading), and labeled examples. **No repair sections —
negative examples only**, and that missing repair propagates downstream into
every skill built on it.

### sam-paech/antislop-sampler + arXiv 2510.15061
A different family entirely: inference-time backtracking suppression of a
banned-phrase list, plus FTPO fine-tuning. Relevant here as hard evidence of the
blacklist scaling ceiling — 8,000+ patterns suppressible via backtracking while
**naive token banning becomes unusable at ~2,000**. If the approach breaks down
at the logit level, a prompt-level blacklist is not going to hold.

### Also surveyed
| Artifact | URL | Note |
|---|---|---|
| Gemini CLI de-slop skill | https://glaforge.dev/posts/2026/03/08/fixing-ai-slop-with-a-skill-in-gemini-cli/ | SKILL.md text never published (screenshot only). Author: "I didn't even have to modify the generated SKILL.md as it did the job perfectly" — auto-generated and never evaluated. |
| scahyono/deslopify | https://github.com/scahyono/deslopify | Chrome extension injecting a "Basic International English" protocol into chat inputs. Prevention, not repair — a different product. |
| astromvp.com/blog/remove-ai-slop-from-copy | https://astromvp.com/blog/remove-ai-slop-from-copy | Marketing-specific listicle, 10 patterns with before/after. One heuristic worth stealing: "Read your copy out loud. If any sentence sounds like something a corporate VP would say in a quarterly earnings call, rewrite it." |
| coderjatin/anti-slop-writing | — | **404, does not exist.** Cited in search results; not a real artifact. |
| mcpmarket de-slop polisher | https://mcpmarket.com/tools/skills/de-slop-ai-content-polisher | HTTP 429, not assessed. |

### The three families, and which one works

The corpus sorts cleanly:

- **Blacklists** (MariusAure, slopless, tropes.fyi, stop-slop/turner reference
  files) — enumerate strings.
- **Rubric-scorers** (stop-slop, skill-deslop, ultimate-humanizer) — add a
  self-graded 5D/50 score.
- **Editor-role prompts** (petergyang, mantasdigital) — frame the model as an
  editor with a job, a budget, and a stopping rule.

Only the third family plausibly works. The other two fail on the same axis:
**they tell the model what to delete without telling it what to put there, and
never tell it when to stop.**

### Marketing coverage across the corpus: essentially absent

Of ~15 artifacts read in full, exactly **two** address marketing copy natively
(mantasdigital, Krirox's copy section) plus one adjacent blog post (astromvp).
Everything else is calibrated for essays, newsletters, scientific manuscripts,
or Wikipedia-register reference prose — and **two are actively hostile to
marketing register**: MariusAure's "Present, don't persuade. No praise, hype,
moral stance," and Rossmann's Rule 13 "Write like a researcher, not a
copywriter." Importing any of them wholesale into a landing-page tool would
strip persuasion along with slop.

The genre-specific gaps nobody covers: hero headline claim structure; the
proof/specificity obligation and its collision with the don't-fabricate rule
(only slopless names that conflict); CTA verbs; social-proof phrasing;
feature-vs-benefit balance; and the fact that scannable parallel structure is a
*function of the medium* rather than a tell. Section 1 of this document is
genuinely new work, not a re-derivation.

### The existing local `/deslopify`
`/Users/mhyrr/.claude/commands/deslopify.md` — three paragraphs. Notable for two
things it gets right that most published prompts miss:
- An explicit **process** instruction ("you MUST manually read each line… in a
  systematic, methodical, diligent way") and an explicit prohibition on
  scripting it. That's a real defense against a shallow single-pass skim.
- A **replacement** for the em dash rather than just a ban ("replace this with a
  semicolon, a comma, or just recast the sentence").

What it lacks: any earned-use / stop condition, any marketing-genre coverage,
any structural (as opposed to sentence-level) patterns, and any anti-fabrication
guardrail.

---

## 2.2 What AI-text detectors actually key on

Five signal families, and the actionable/measurable split is the important part.

**1. Token-probability / perplexity.** Perplexity = how surprised a reference LM
is by the token sequence. GPTZero's published calibration: human prose ~80–100,
GPT-4 output ~20–30. Research variants: **DetectGPT**
(https://arxiv.org/abs/2301.11305) — machine text sits in regions of negative
curvature of the log-prob function; **Fast-DetectGPT**
(https://arxiv.org/pdf/2310.05130) — same insight ~340× cheaper, and the source
of the best one-line framing of the whole problem: *"LLMs mirror human
**collective** writing behavior instead of human **individual** writing
behavior."* **Binoculars** (https://dl.acm.org/doi/10.5555/3692070.3692768) —
ratio of observer-model perplexity to cross-perplexity, >90% detection at
0.01% FPR zero-shot.

**2. Burstiness.** Variance of perplexity and sentence length across a document.
GPTZero: human 0.6–1.2, GPT 0.2–0.4. Note GPTZero **demoted perplexity and
burstiness from primary method in autumn 2023** to 2 of ~7 indicators behind a
deep-learning classifier (https://gptzero.me/news/perplexity-and-burstiness-what-is-it/).

**3. Trained classifiers.** Originality.ai is a fine-tuned BERT variant on
millions of labeled records; stated features include burstiness, word-frequency
distributions, **punctuation predictability**, lexical diversity, syntactic
variation (https://originality.ai/blog/how-does-ai-content-detection-work).

**4. Lexical markers.** The strongest quantitative evidence is Kobak et al.,
*Delving into ChatGPT usage in academic writing through excess vocabulary*
(https://arxiv.org/abs/2406.07016) — 15M PubMed abstracts, 2010–2024:
- ≥13.5% of 2024 abstracts LLM-processed; up to 40% in some subcorpora.
- Effect size **exceeded the Covid pandemic's** vocabulary shift.
- **The structural finding that justifies a style-only editing pass:** Covid's
  excess vocabulary was almost entirely *content* words; 2024's was almost
  entirely *style* words.
- Verbs are 66% of excess style words (delve, underscore, showcase, elevate,
  elucidate, harness, illuminate, navigate, pioneer, streamline, +~260 more);
  adjectives 14% (intricate, pivotal, comprehensive, crucial, notable,
  remarkable, exceptional, innovative, transformative, multifaceted, seamless);
  nouns include realm, intricacies, nuances, interplay, paradigm.
- **Markers decay once publicized.** https://arxiv.org/pdf/2505.12218 shows
  "delve" collapsing on arXiv shortly after the early-2024 publicity while
  "significant" kept rising. Wikipedia already versions its list by era
  (2023–mid-2024: delve, tapestry, testament, meticulous, boasts, garner,
  vibrant, pivotal → mid-2024–mid-2025: align with, fostering, highlighting,
  showcasing, enhance → mid-2025+: a narrowing set). **Any hardcoded word list
  will go stale within about a year.**

**5. Punctuation and syntactic markers.** Em dash is the strongest single
punctuation signal — relative frequency **more than doubled 2021→2025** in
ecology abstracts and was the only character showing that rise
(https://www.pieceofk.fr/the-rise-of-the-em-dash-in-ecology-abstracts/).
Mechanism: em dashes are a low-token, loss-reducing alternative to more verbose
punctuation (https://www.seangoedecke.com/em-dashes/). Wikipedia's careful
framing is the one to adopt: LLMs use em dashes *"in places where humans are
more likely to use commas, parentheses, colons, or misused hyphens"* — the tell
is substitution context, not raw count. Other durable syntactic tells:
- **Negative parallelism** — "It's not X, it's Y" / "Not just X, but Y".
  Barron's counted 50 instances in Fortune 500 filings in 2023 → 200+ in 2025.
  Hypothesized cause: RLHF raters score it higher because it *reads* as nuance.
- **Rule of three** — forced triads simulating analytic depth. (This is the
  general-prose parent of our Feature Triad and Staccato Tricolon entries.)
- **Copula avoidance** — is/are replaced by serves as, stands as, functions as,
  represents, boasts, features, offers. Documented >10% decrease in "is"/"are"
  in 2023 academic writing.
- **Superficial -ing analyses** — trailing gerund clauses asserting significance:
  "…, highlighting the importance of…", "…, underscoring…", "…, fostering…".
- **Elegant variation** — repetition-penalty artifacts causing synonym cycling.
- **False ranges** — meaningless "from X to Y" scales. (Our "Whether you're…"
  and "from freelancers to Fortune 500s" entries are the marketing instance.)
- **Formatting:** bold overuse; **inline-header vertical lists** (`**Term:**` +
  bullet restating the bold phrase — Wikipedia calls this "a ChatGPT signature
  that barely exists in natural writing"); title-case headings; emoji as
  structure; thematic breaks between sections; canned closing sections
  ("Challenges and Future Prospects").

### The actionable / measurable split

| Signal | Usable as an editing instruction? |
|---|---|
| Perplexity / log-prob curvature | **No.** It's a property of the generating distribution, not an editable surface feature. "Raise your perplexity" degenerates into randomness injection. |
| Burstiness | **Marginally.** "Put a four-word sentence next to a thirty-word one" is real craft advice that happens to move the metric. Do it for the prose, not the score. |
| Trained classifier score | **No.** Opaque black-box target; invites Goodharting. |
| Lexical markers | **Yes** — but date-stamped and decaying. Needs a maintenance story. |
| Punctuation markers | **Yes** — framed as substitution context, never as a quota. |
| Syntactic / discourse patterns | **Yes, and most durably.** Nameable, showable, fixable constructions. |

**Implication:** `/deslopify` should target families 4 and 5 and ignore 1–3, and
should declare detector evasion an explicit non-goal. The next section is the
evidence for why.

---

## 2.3 "AI humanizer" products — a category-level anti-pattern

**Undetectable.ai** (https://undetectable.ai/) claims it locates detector-flagged
spans and rewrites by varying sentence structure and vocabulary. A head-to-head
test on ChatGPT marketing copy (https://originality.ai/blog/undetectable-ai-review
— note: run by a competitor, discount accordingly, but the direction matches
other tests):

| Detector | Original | After Undetectable.ai |
|---|---|---|
| Originality.ai | 100% AI | 100% AI |
| GPTZero | 100% AI | 91% AI |
| Writer | 6% | 3% |

**QuillBot** is a paraphraser retrofitted as a humanizer; reviews report it
"mostly swaps out words or tinkers with sentences but doesn't change how the
writing feels" (https://www.twaingpt.com/blog/quillbot-review).
**StealthGPT** benchmarks better against detectors but over-rewrites — reviewers
report it "can mess up your text and make it sound confusing."
**Walter Writes** rates highest, and the stated reason is instructive: it
"rewrites sentence structure and writing patterns, not just wording." The tools
that do structural rewriting beat the ones doing synonym substitution.

**The surface-trick tier is dead.** Zero-width and homoglyph insertion (U+200B,
U+200C, U+200D, U+FEFF, U+2060, U+00A0, U+2062; Cyrillic-for-Latin swaps) was
briefly effective; Turnitin and GPTZero now inspect Unicode structure and flag
the obfuscation *itself* as suspicious, so the trick inverts into a positive
detection signal (https://justdone.com/blog/ai/invisible-unicode-tricks,
https://originality.ai/blog/fake-text-homoglyph-detector-and-generator).

An audit of 19 humanizers catalogued the recurring damage: imprecise synonym
swaps, nonsensical additions, spacing changes, degraded grammar, and in some
tools **deliberately inserted errors** to fool detectors. Two lines worth
keeping:

> "Degrading prose to chase a detection score is the opposite of what quality
> content needs."

> "Humanizers may alter detector signals, but they cannot recover a writer's
> voice if the model never had those patterns."
> (https://usenoren.ai/blog/humanizing-ai-text-fixes-the-wrong-problem)

**Lesson:** the whole category optimizes a proxy and degrades the objective.
`/deslopify`'s objective function is "does this read like a person who knows
this product wrote it," and detector evasion should be named as a non-goal in
the command itself — otherwise the model will drift toward jitter and synonym
churn, which is exactly what happens to these products.

---

## 2.4 Open-source prose linters — what transfers

### write-good — https://github.com/btford/write-good
9 checks: `passive`, `illusion` (repeated words), `so` (sentence-initial),
`thereIs` (expletive openings), `weasel`, `adverb`, `tooWordy`, `cliches`,
`eprime`.
**Transfers:** `weasel`, `adverb`, `tooWordy`, `cliches` — as generic
tightening. **Does not transfer:** `passive`, `so`, `thereIs`, `eprime`.
Passive voice is generic prose advice, orthogonal to AI-ness — an important
distinction, because several published deslop prompts import passive-voice
rules and thereby spend attention on something that isn't a tell. Low overall
value; 2014-era word lists.

### proselint — https://github.com/amperser/proselint
~80 checks curated from named authorities (Garner, Strunk & White, DFW's
*Tense Present*).
**High-transfer subset (~20 of 80):** `misc.metadiscourse` ("avoid discussing
the discussion" — nearly a direct hit on AI signposting), `hedging`,
`weasel_words`, `misc.pretension`, `industrial_language.corporate_speak`,
`industrial_language.commercialese`, `industrial_language.jargon`,
`redundancy.*`, `needless_variants`, `cliches.*`, `misc.narcissism`,
`mixed_metaphors`, `uncomparables` (directly relevant to our unreferenced-
superlatives entry — "uncomparables" is the classical name for "most unique").
**Irrelevant:** all `spelling.*`, `typography.*`, `terms.*`, `dates_times.*`,
`social_awareness.*`, `restricted.*`.

### alex — https://github.com/get-alex/alex
Inclusive-language only (`retext-equality` + `retext-profanities`).
**Transfers: essentially nothing** for AI slop. One partial exception: the
condescending-phrasing rule ("obviously", "simply", "everyone knows") overlaps
with AI's false-familiarity register — and "simply" is on our
effortless-adverb list.

### retext / retext-simplify — https://github.com/retextjs/retext-simplify
`retext-simplify` is a simpler-alternative swap list (utilize→use). Siblings:
`retext-intensify` (weak/mitigating wording), `retext-cliches`, `retext-passive`,
`retext-readability`, `retext-repeated-words`, `retext-contractions`.
**Value: as a word-list source, not a rule model.** `retext-intensify` is the
useful one.

### textlint-ja / preset-ai-writing — https://github.com/textlint-ja/textlint-rule-preset-ai-writing
**The only executable AI-slop linter found**, and its rule decomposition is
directly borrowable even though the surrounding language is Japanese:
1. `no-ai-list-formatting` — bold-prefix list items (`**重要**: …`), emoji
   bullets (✅ ❌ 💡 🔥 🚀 ⭐ 🎯 📝), em-dash separators.
2. `no-ai-hype-expressions` — "revolutionary," "game-changer," "world's first,"
   "completely solve," "paradigm shift." **Sub-toggles for *absoluteness*,
   *abstract*, and *predictive* patterns** — a genuinely useful three-way
   taxonomy of hype, and the closest any linter comes to our genre.
3. `no-ai-emphasis-patterns` — mechanical bolding of intensifiers and headings.
4. `no-ai-colon-continuation` — predicate-ending colons before lists/code blocks.
5. `ai-tech-writing-guideline` — redundancy, abstract terms, term inconsistency,
   sentence length.

Every rule ships an `allows` allowlist plus granular `disableX` sub-toggles, and
each has a before/after pair. **This is the closest existing rule *schema* for
AI slop specifically**, and rules 1–4 are language-independent in substance.

### Vale — https://vale.sh — the most imitable structure
Rules are YAML with a fixed header: `extends` (required), `message` (required),
`level` (suggestion|warning|error), `scope`, `link` (URL to the authority),
`limit`, `vocab`, plus per-check fields (`ignorecase`, `swap`, `tokens`,
`exceptions`) and an optional `action` block for autofix. Eleven extension
points: existence, substitution, occurrence, repetition, consistency,
conditional, capitalization, metric, spelling, sequence, script.

```yaml
# Google/ExcessiveClaims.yml
extends: existence
message: "Avoid the unverifiable claim '%s'."
link: https://developers.google.com/style/excessive-claims
level: suggestion
ignorecase: true
tokens:
  - 'best(?! practices?)'
  - simplest
  - fastest
  - guarantees?
```

```yaml
# Microsoft/Wordiness.yml
extends: substitution
message: "Consider using '%s' instead of '%s'."
level: warning
swap:
  (?:in order to|as a means to): to
  (?:utilize|make use of): use
  because of the fact that: because
  a myriad of: myriad
```

Style packages: **Microsoft** (https://github.com/errata-ai/Microsoft — 36
existence rules incl. Adverbs, Dashes, Passive, Wordiness; 9 substitution rules;
SentenceLength as `occurrence`) and **Google**
(https://github.com/errata-ai/Google — 36 rules incl. **Anthropomorphism,
ExcessiveClaims, EmDash, Jargon, Latin, Slang, Timeless, Will, WordList**).
Note `ExcessiveClaims` and `Anthropomorphism` map onto two of our patterns
almost exactly. Vale also repackages proselint, write-good, and alex
(https://github.com/errata-ai/packages).

**Three things to steal from Vale beyond the rule triad:**
- **`level`.** "Never fabricate a testimonial" and "prefer a period to an em dash
  in a tagline" are not the same strength of claim and must not be presented as
  if they were. A flat list of 25 equally-weighted rules is how you get a
  shallow pass on all of them.
- **`link` / rationale.** Every rule names the authority behind it. The model
  generalizes better from a reason than from a prohibition.
- **Inline false-positive documentation.** `Google/ExcessiveClaims.yml` carries a
  comment recording its own FP analysis: *"'never', 'always', and 'ensure' …
  accounted for 125 of 142 hits on a 950-file corpus."* Encoding known false
  positives next to the rule is the antidote to over-triggering — the direct
  structural ancestor of our Earned-use field.

### Also surveyed
**LanguageTool** (https://github.com/languagetool-org/languagetool) — XML rules
across STYLE, REDUNDANCY, REPETITIONS_STYLE, PLAIN_ENGLISH, COLLOQUIALISMS,
WORDINESS, TYPOGRAPHY. Mature but overwhelmingly grammar/spelling; the useful
slice (REDUNDANCY + PLAIN_ENGLISH) duplicates Microsoft/Wordiness more messily.
**Joblint** — bias in job posts. Not applicable.

---

## 2.5 Style-guide-as-prompt: what structurally works

### The one clean ablation
*Show and Tell: Prompt Strategies for Style Control in Multi-Turn LLM Code
Generation* (https://arxiv.org/html/2511.13972v1) — Gemini 2.5 Pro, 160
sessions, four arms (control / instructions-only / examples-only / combined).
Code generation rather than prose, which is a real caveat, but it's the only
controlled comparison found.

- **Turn 1:** combined −70% tokens (d = −10.97); instructions-only −56%
  (d = −7.84); examples-only −20% (d = −2.63). Accuracy ~99% across all arms.
- **Turn 2** (after an expansion request): examples-only expanded at the *same
  rate as control*, despite starting 524 tokens more compact. Instructions
  persisted.
- Conclusion: *"initial brevity is not a proxy for expansion discipline"* —
  explicit operational rules **persist**; surface-pattern imitation **drifts**.

**This contradicts the folk wisdom** that examples always beat rules because
"models are pattern-followers more than rule-followers"
(https://www.prompthub.us/blog/the-few-shot-prompting-guide,
https://latitude.so/blog/how-examples-improve-llm-style-consistency). The
controlled result: examples win the first pass, rules win on durability,
combined wins both. For a one-shot editing command, turn-1 performance
dominates — so **rule + example together** is the right structure, and the
effect size (−70% vs −56%) justifies paying the token cost of carrying examples.

### Positive framing beats prohibition
Consistent across
https://eval.16x.engineer/blog/the-pink-elephant-negative-instructions-llms-effectiveness-analysis,
*Yes is Harder than No: A Behavioral Study of Framing Effects in LLMs*
(https://dl.acm.org/doi/10.1145/3746252.3761350), and
https://gadlet.com/posts/negative-prompting/: negation must be represented
before it can be suppressed, which activates it; models misparse negation, and
InstructGPT-class models got *worse* at negative prompts as they scaled.

**Practical form:** Vale's exact message template —
*"Consider using '%s' instead of '%s'"* — rather than "don't use X." Every rule
should name the replacement, not just the offense. This is the strongest
argument for our Repair field being mandatory and concrete rather than
descriptive.

### The two-document pattern
Mature brand-voice programs maintain two guides from one source of truth: a
human-facing one with strategic rationale and annotated examples for judgment
calls, and an AI-facing one that is explicit, specific, and example-heavy
(https://www.glean.com/perspectives/why-you-need-both-brand-guidelines-and-ai-prompts-for-consistency).
The recurring concrete advice: replace "sound friendly" with "use contractions,
address readers as 'you,' keep sentences under 20 words."

---

## 2.6 Structural failure modes — named, with evidence

These are the six ways a deslop prompt produces mush. Each is observed in the
prior art above.

**(a) The blacklist that gets written around.**
*Exhibits:* MariusAure (~55 banned words, zero repairs), slopless
`writing-voice.md` (~150 strings), adenaufal's 12KB `vocabulary-banlist.md`,
stop-slop `phrases.md`, tropes.fyi (explicitly no repairs), write-good and
retext-simplify.

A word list without the underlying construction teaches the model to avoid the
*token* while keeping the *tic*. Ban "delve" → "dive deep into." Ban "unlock the
power of" → "tap into the potential of." Ban "seamlessly" → "with zero
friction." The tic is *vague-benefit-with-no-subject*, not the lexeme.

The blacklist family's own artifacts concede the point. adenaufal: "vocabulary
tells… have been trained out of the newest Claude models. **Absence of these
legacy tells proves nothing.** What survives prompt rewrites and model updates
is structural." And the antislop-sampler work puts a ceiling on the approach
even at the logit level: naive token banning becomes unusable around 2,000
patterns.

Only three artifacts attack the tic rather than the token, and all three do it
the same way — by making the repair a *specific checkable fact*: Peter Yang's
portability test, Krirox's Replace-with column, Rossmann's WRONG/RIGHT pairs.
Wikipedia's defense is structural instead: it pairs every "words to watch" list
with an explanation of the construction.

**Corollary specific to our genre:** marketing's banned phrases are
*claim-shaped* — an inventory of hollow claims, not hollow words. And the worst
of the marketing tics are section-shaped. You cannot blacklist your way out of a
feature triad.

**(b) Instruction count that forces a shallow pass.**
*Exhibits:* adenaufal (5,182-word skill + ~200KB refs + a 36-item checklist —
nothing in it will get a deep pass), skill-deslop (10 rules + 17 checks + 4
catalogs), ultimate-humanizer (50 patterns), blader/humanizer (36 equally
weighted), Peter Yang (17 principles + ~20 patterns + 26 eval questions — best
content in the corpus, borderline on volume).

A rule list without a priority order is a list the model samples uniformly and
shallowly. The two working mitigations found: ultimate-humanizer's intensity
tiers plus explicit priority order ("traite d'abord P1-P5, P7, P13, P14 — les
plus fréquents et impactants"), and Rossmann's self-check ordered
mechanical-first, judgment-last. Vale's `level` field is the same fix in schema
form. **For a marketing `/deslopify`, five patterns worked deeply beats forty
checked.**

**(c) Over-correction into stilted prose.**
*Worst exhibit:* stop-slop, which bans all adverbs, all em dashes, all passives,
and all "quotables," gives no replacement guidance, and then demonstrates the
damage in its own examples — hedge-stripping that produces a false absolute
("most teams struggle" → "Teams struggle with alignment. Nobody admits
confusion"), and a 27-word paragraph compressed into "Move faster. Your
competition is." — which is the dramatic fragmentation its own Rule 2 bans.
skill-deslop inherits all of it and adds a blanket tricolon ban. adenaufal fails
in the opposite direction: its checklist *mandates* inserting fragments,
questions, and register shifts, so the output acquires manufactured quirk on a
schedule.

The em-dash rule is the canonical instance. blader/humanizer requires "the final
rewrite contains no em dashes"; the local `/deslopify` calls it "one big tell."
But the evidence says the signal is *substitution context*, not presence. A ban
with no replacement produces comma splices. The local command partly avoids this
by naming replacements (semicolon, comma, recast) — the right instinct,
generalizable to every rule.

The correctives, present in exactly three places: Peter Yang's conditional
adverb rule and calibrated em-dash budget; mantasdigital's "their voice wins.
Mirror the user, not the rulebook"; ultimate-humanizer's protected-content list.

**Landing pages are the most over-correction-prone genre in this whole space.**
The parallel triplet, the short punchy line, and the confident absolute claim
are all legitimate hero-section devices that a stop-slop-derived prompt would
bulldoze. Two artifacts are outright hostile to the register — MariusAure's
"Present, don't persuade. No praise, hype, moral stance" and Rossmann's "Write
like a researcher, not a copywriter" — and importing either would strip
persuasion along with slop. The one artifact with the right mechanism is
skill-deslop's Rule 6, "Match register to context," pointed at a different
genre.

**(d) No stopping condition, so the model edits sentences that were fine.**
*Absent entirely from:* stop-slop, skill-deslop, MariusAure, slopless,
adenaufal, Krirox, tropes.fyi.
*Present, and worth copying verbatim, in three:*
- Peter Yang: "Make the minimum effective edit… Leave strong human sentences
  alone. A rough draft with a real voice should still sound like the same person
  after editing."
- ultimate-humanizer: a false-positive list, a preserve list, a 1-weak-pattern
  tolerance threshold, an "already human, don't rewrite" exit, and a hard 2-pass
  cap.
- mantasdigital: voice samples override the rulebook.

Plus Wikipedia's cluster principle ("look for clusters of tells, not isolated
ones"; the signs are "potential signs of a problem, not the problem itself").

**This is the single largest quality differentiator in the corpus.** A command
without an explicit "if the copy is already specific and voiced, return it
unchanged and say so" will flatten good copy every time, because the model reads
the invocation itself as a mandate to produce a diff. **Our Earned-use field is
the strongest form of this defense found anywhere** and should be a first-class
instruction, not per-rule trivia.

**(e) Abstract prohibitions with no worked example.**
*Exhibits:* MariusAure (zero examples), glaforge (text never published),
tropes.fyi (negative examples only — and it is upstream of several skills, so
the missing repair propagates), stop-slop (5 examples for 8 rules and ~90 banned
phrases, and the examples actively mislead).

The Show-and-Tell ablation quantifies the cost: instructions-only −56% vs.
combined −70%. Best-in-class is Peter Yang, where the repair is inline in the
pattern definition and the *shape* of the repair is specified, not just the
outcome: "Do not rewrite it into a better metaphor. Do not preserve the rhythm.
Delete it, then end on the clearest concrete sentence already in the draft."
Rossmann's WRONG/RIGHT pairs are equally concrete but all drawn from one domain
(right-to-repair), which teaches the pattern and the topic simultaneously — a
caution for our own specimens: vary the product category.

**(f) Rubrics the model games.**
*Exhibits:* stop-slop and skill-deslop share an identical unanchored 5×10 rubric
("Directness | Statements or announcements?") with the threshold "Below 35/50:
revise" — no anchors, no counting rules, and the same model that wrote the text
assigns the score. skill-deslop's blog post reports 8/50 → 43/50 as evidence of
efficacy, which is a model rating its own rewrite on criteria it invented
mid-inference. Nothing prevents "score it 36 and ship." Same class of error as
the humanizer products optimizing detector score (§2.3).

ultimate-humanizer is the only artifact that tries to fix this, binding each
dimension to a countable proxy plus an anti-inflation instruction. Still
self-report, but at least falsifiable.

**The correct move is Peter Yang's: delete the score.** Require named pattern +
quoted line + short fix, because "AI detectors guess. Named patterns are
evidence the user can check." If any scoring survives, it should be a
*diagnostic before editing*, never a *self-assessment after*, and the audit turn
should ask concrete questions ("did you invent any facts?") rather than request
a number.

**(g) [marketing-specific] Fabrication as the repair.**
Barely arises in the general-prose prior art; it is the dominant risk in our
genre. Nearly every repair in Section 1 is "replace vagueness with a fact." A
model without the fact will produce one — inventing metrics, testimonials,
customer names, and capabilities. Fabricated testimonials and metrics create
legal exposure, not just bad prose.

Two artifacts have a guardrail in this shape, and both are worth quoting into
the command:
- blader/humanizer: "Never invent facts"; vague claims may be cut but never
  replaced with invented specifics.
- slopless: **"NEVER fabricate specifics to sound helpful. Vague but honest
  beats specific but invented."**

slopless is the only one that names the underlying conflict explicitly: the
specificity rule and the honesty rule pull against each other, and on a landing
page the honesty rule has to win. Everything else in the corpus pushes hard
toward specificity with no counterweight, which is precisely the configuration
that produces invented numbers.

**(h) [observed in the corpus] Anti-slop prompts that produce slop.**
ultimate-humanizer states the principle — *"un anti-slop ne doit pas produire de
slop"* — and it applies to the command's own output: verbose before/after dumps,
a self-congratulatory summary, a score. Its answer is changelog by default,
before/after only on an explicit `--explain` flag. Worth adopting; a deslop
command that emits four paragraphs of commentary per fix is doing the thing it
was written to stop.

**(i) [recursion] Today's fix is tomorrow's tell.**
mantasdigital flags it: "A 'casual personal anecdote opener' is itself becoming
an AI pattern." adenaufal's version is the sharper one — the argument cadence
(Opening → Expansion → Contrast → Resolution) survives every vocabulary edit
because "the model rebuilds it under any vocabulary." Any repair the command
prescribes as a *default* will itself become a signature. This argues for
repairs that route through *the specific fact* (which is unique per product and
therefore unfakeable) rather than through a prescribed rhetorical move.

---

## 2.7 Recommended structure for the rewritten command

Synthesizing everything above. Ordered by expected value.

1. **A stopping condition, stated up front and enforced.** The largest quality
   differentiator in the corpus (§2.6d). Adopt Peter Yang's minimum-effective-
   edit framing verbatim in spirit, plus ultimate-humanizer's mechanics: a
   protected-content list (quotes, numbers, proper nouns, code, URLs), a
   false-positive list, a tolerance threshold, and an explicit **no-op output
   path** ("this copy is already specific and voiced; no changes"). Without
   this, the model reads the invocation as a mandate to produce a diff.
2. **Scope + non-goals + register.** Name the document type. Declare detector
   evasion a non-goal (§2.3). And state, following skill-deslop's Rule 6 pointed
   at our genre, that **persuasion is the correct register here** — the target is
   hollow persuasion, not persuasion. Otherwise the command inherits the
   corpus's Wikipedia-register bias and flattens the page.
3. **A small number of diagnostics before any pattern matching.** The swap /
   portability test, the negation test, and the mechanism test (§1). These find
   the slop that has no signature phrase, and they orient the pass before any
   rule list loads. Krirox's four root causes (no hierarchy, no specificity, no
   restraint, no opinion) plus "if a fix doesn't address one of these four, it's
   cosmetic" is a good companion frame.
4. **Rule + example + repair triads, with a priority order, capped in count.**
   Vale's schema (name, level, message-as-positive-swap, rationale,
   before/after, known false positives) — §2.4, §2.5. Five to eight patterns
   worked deeply, explicitly ranked, not forty checked (§2.6b). Every ban gets a
   destination (Krirox's Replace-with column: a number, a named subject, a
   concrete verb, an opinion, a dated claim).
5. **Anti-fabrication as a hard rule with an escape hatch.** "Vague but honest
   beats specific but invented," plus an explicit flag-and-ask affordance
   (`[NEEDS FACT: …]`) so an unrepairable line has somewhere to go other than
   into an invention (§2.6g). Quotes and attributed text are read-only.
6. **Separate the durable structural rules from the decaying vocabulary list,
   and date-stamp the latter.** Word tells have roughly a one-year half-life;
   constructions don't (§2.2, and adenaufal's concession in §2.6a). Weight the
   structural rules higher — for marketing, they're the whole game anyway.
7. **A process loop with an audit turn, and a hard pass cap.** Draft → audit →
   final (blader/humanizer, Peter Yang), where the audit asks concrete questions
   ("what still reads as generated?", "did I invent anything?", "is the amount
   of cutting proportional to the actual slop?") rather than requesting a score.
   Cap at two passes with a named exit (ultimate-humanizer). Keep the local
   command's existing "read every line manually, don't script it" instruction —
   it's a real defense against a skim.
8. **No rubric.** Report named pattern + quoted line + concrete fix. "AI
   detectors guess. Named patterns are evidence the user can check." (§2.6f)
9. **A positive target paragraph** (§1, "the synthesized positive target"), so
   the pass has somewhere to move *toward* rather than only things to delete —
   the direct fix for failure mode (c).
10. **Optional but cheap: a voice-sample intake.** mantasdigital's opener —
    ask for 2–3 samples of the user's existing writing, and if they conflict
    with the rulebook, **the user's voice wins**. "Do not fall back to a default
    'professional marketing' voice. That default IS the slop."
11. **Keep the command's own output lean.** Changelog by default; before/after
    only on request (§2.6h).

