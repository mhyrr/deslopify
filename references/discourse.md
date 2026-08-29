# The Discourse Layer: LLM Writing Tics Above the Sentence

Catalog for `/deslopify`. Scope is architecture, not diction: what gets said in what
order, what gets announced, what gets repeated, and how the page is shaped. Vocabulary
and sentence-shape tics belong to other catalogs.

Specimens marked `[collected]` are quoted from published critiques or from AI text those
critiques reproduce. Specimens marked `[composite]` are representative constructions built
from the documented pattern.

---

## Calibration: the two axes every "earned use" ruling depends on

Almost every pattern here is a legitimate device misapplied. The deciding variables are
document **length** and **venue**. Fix these definitions once and the per-pattern rulings
become mechanical.

### Length bands

| Band | Words | Typical artifacts |
|---|---|---|
| **Micro** | < 150 | chat reply, Slack message, commit message, PR description, error copy |
| **Short** | 150–800 | blog post, email, README section, changelog entry, landing page |
| **Medium** | 800–2,500 | feature article, design doc, RFC, tutorial |
| **Long** | 2,500–8,000 | spec, whitepaper, incident report, thesis chapter, policy |
| **Extended** | 8,000+ | manual, book chapter, standard, multi-part guide |

### Venue types

| Venue | Reading mode | Consequence for structure |
|---|---|---|
| **Linear prose** | start to finish, once | signposting is friction; the reader has not lost the thread |
| **Non-linear reference** | jumped into mid-document | signposting is load-bearing; every section must stand alone |
| **Scan-first web** | F-pattern, ~20% read | bold/bullets/headings earn their place (NN/g: 79% of users scan, 16% read word by word) |
| **Instructional** | executed while read | numbered lists and one-step-per-line are correct, not slop |
| **Decision doc** | skimmed by a busy reader | BLUF/Minto answer-first is correct; the summary goes at the *top*, not the bottom |

### The three governing heuristics

1. **The deletion test.** Delete the unit. If nothing downstream breaks and no reader
   question goes unanswered, it was scaffolding. Louis Bouchard's version: "if the first
   paragraph could be used on a different article with minor changes, cut or rewrite it."
2. **The restatement ratio.** Count sentences carrying information not present in a prior
   sentence, divided by total sentences. Published diagnosis of AI drafts: "a 500-word AI
   section might contain 100 words of actual information and 400 words of restatement."
   Below ~0.6 in Short/Medium prose, the piece is padded.
3. **The navigation budget.** Signposting is priced by how far the reader is from the last
   orientation point. Under ~800 words the reader has not lost the thread and every
   signpost is a tax. Over ~2,500 words, in a non-linear venue, signposts are what make
   the document usable.

---

# Family 1: Signposting and meta-narration

### The "here's why this matters" announcement

- **Shape:** A sentence or short paragraph that asserts the significance of what follows
  instead of demonstrating it. Canonical forms: "Here's why this matters:", "Here's the
  thing:", "The key insight is...", "What's important to understand is...", "This is the
  crucial part." Frequently sits between a claim and its evidence, doing no work in either
  direction. **Test:** delete the sentence and read the two neighbors in sequence. If they
  join cleanly, the announcement was pure connective tissue.
- **Why it reads as AI:** Significance is claimed rather than earned, which is the move of a
  writer who has not decided whether the point is actually important.
- **Specimen:** [composite] "We moved the retry logic into the queue consumer. Here's why
  this matters: it means failures no longer block the request path. The key insight is that
  the client should never wait on a retry."
- **Repair:** "We moved the retry logic into the queue consumer, so failures no longer block
  the request path. The client never waits on a retry."
- **Earned use:** Almost never in Micro or Short prose. In Long/Extended technical documents
  and in decision docs, an explicit significance callout is legitimate when the reader
  genuinely cannot infer stakes from the fact itself, and it should be stated as the stake,
  not as an announcement of a stake: "This changes the on-call rotation" beats "Here's why
  this matters." The phrase-as-drumroll ("Here's the thing:") is never earned in written
  prose; it is a spoken-register tic that survives only in transcribed talks and newsletters
  written in a deliberate voice.

### "Let me explain" / "Let's unpack this" (the pedagogical voice)

- **Shape:** First-person-plural teacher framing inserted before an explanation the reader
  did not need coaxing into: "Let me explain.", "Let's break this down.", "Let's unpack
  this.", "Let's dive in.", "Let's take a closer look." The tropes.fyi catalog names this
  "Let's Break This Down" and identifies it as "pedagogical voice assuming hand-holding is
  needed." **Test:** does the next paragraph explain the thing? Then the announcement is
  redundant with the explanation.
- **Why it reads as AI:** It performs the act of teaching before doing any teaching, which is
  the rhythm of a chatbot filling a turn rather than a writer filling a page.
- **Specimen:** [composite] "The scheduler uses a leaky bucket. Let's break this down. A
  leaky bucket holds tokens that drain at a fixed rate..."
- **Repair:** "The scheduler uses a leaky bucket: tokens drain at a fixed rate, so a burst
  spends the reserve and then throttles to the drain rate."
- **Earned use:** Legitimate in Instructional venue when a genuine mode switch is happening,
  and only when it names the switch concretely: "The rest of this section works through one
  request end to end" is orientation. "Let's dive in" is not. Also earned in transcript-like
  formats (workshop notes, recorded walkthroughs) where the spoken register is the point.

### The roadmap paragraph in a document too short to need one

- **Shape:** "In this article, we will explore...", "First, let's establish...", "Before we
  dive in, it's worth covering some background.", "This post covers three things: X, Y, and
  Z." Wikipedia's signs-of-AI-writing list flags exactly this: AI "inserts excessive
  transitional phrases and explanatory preambles clarifying intent," giving "In this article,
  we will explore the unique characteristics..." as the specimen. **Test:** does the document
  have headings? If yes, the roadmap duplicates the table of contents. Is it under 800 words?
  If yes, the roadmap is a larger fraction of the reading time than the navigation it saves.
- **Why it reads as AI:** It describes the document instead of being the document, a habit
  from the five-paragraph essay template that dominates the training data.
- **Specimen:** [collected, Wikipedia:Signs of AI writing] "In this article, we will explore
  the unique characteristics..."
- **Repair:** Delete. Open on the first substantive claim. If the reader needs orientation,
  the headings and the first sentence provide it.
- **Earned use:** Genuinely load-bearing in Long and Extended documents in non-linear venues.
  The academic-writing literature is explicit that "signposting density that would feel
  over-explained in a short piece of prose is often necessary in longer documents like
  manuscripts, theses, or grant narratives because readers rarely read linearly." Google's
  own tech-writing course requires introductions in reference docs stating "what the document
  covers. What prior knowledge you expect readers to have. What the document doesn't cover."
  The scope-exclusion clause is the tell for a real roadmap: a real one says what is *not*
  here. A slop roadmap only says what is.

### Fractal summaries (tell-them-thrice at every level)

- **Shape:** The "what I'm going to tell you / what I'm telling you / what I just told you"
  structure applied recursively, so the document previews itself, each section previews
  itself, and each paragraph opens with its own thesis and closes with its own recap. Named
  "Fractal Summaries" in the tropes.fyi catalog: "applied at every level of the document."
  **Test:** read only the first and last sentence of each section. If those alone reconstruct
  the whole document, the body is decorative.
- **Why it reads as AI:** No human writer has the patience to summarize at four scales; the
  recursion is a template being applied without a cost model.
- **Specimen:** [composite] Section opens "This section covers the three failure modes."
  Three subsections follow, each opening "The first failure mode is X" and closing "In short,
  X causes Y." Section closes "To summarize, the three failure modes are X, Y, and Z."
- **Repair:** Keep exactly one layer of summary, at the level where a reader most plausibly
  enters or exits. Usually that is the document, not the section, and never the paragraph.
- **Earned use:** Two layers (document-level and section-level) are defensible in Extended
  reference material and in standards or policy documents where a reader may be quoting a
  single section in isolation. Three or more layers is never earned at any length.

### Section-ending summaries

- **Shape:** A closing sentence or short paragraph at the end of each section that restates
  the section. Momentic's specimen: "Taken together, these improvements to the technical
  foundation give the site a much stronger position heading into Q3." Common openers: "Taken
  together...", "In short...", "The upshot is...", "Put simply...", "All of this means
  that..." **Test:** does the sentence contain a noun or number that has not appeared in the
  preceding paragraphs? If not, cut it.
- **Why it reads as AI:** It treats the reader as unable to retain the paragraph they just
  read, which is a model hedging against its own incoherence rather than a writer trusting a
  reader.
- **Specimen:** [collected, Momentic] "Taken together, these improvements to the technical
  foundation give the site a much stronger position heading into Q3."
- **Repair:** Delete, unless the sentence performs a *synthesis* the parts did not contain.
  If three fixes independently bought 200ms each, "The three together cut p99 from 1.4s to
  800ms" is arithmetic the reader did not have, and it stays.
- **Earned use:** Earned when the section is longer than roughly 800 words, when the summary
  states a *combined* result rather than a list of the parts, or in Instructional venue where
  the recap doubles as a checkpoint ("At this point you should have a running container and
  a seeded database"). Never earned in a section under ~300 words.

### The empty transition between sections

- **Shape:** A sentence bridging two headed sections that carries no content: "Now that we've
  explored X, let's turn to Y.", "With that foundation in place...", "As mentioned earlier...",
  "In the next section, we will discuss..." Louis Bouchard's edit list names these directly
  as signposting to delete. **Test:** the heading already announced the topic; the transition
  announces it again in a full sentence.
- **Why it reads as AI:** Headings already do this work, so the sentence is a model narrating
  its own outline.
- **Specimen:** [collected, louisbouchard.ai] "Now that we've explored X…", "As mentioned
  earlier…", "In the next section, we will discuss…"
- **Repair:** Delete the sentence. Let the heading carry the transition. If the connection
  between sections is non-obvious, state the connection as a fact: "Y fails for the same
  reason X did" beats "Now that we've covered X, let's turn to Y."
- **Earned use:** In Extended linear prose with few or no headings (a long essay, a book
  chapter), transitions are the only navigation the reader has, and a genuine one earns its
  place by carrying an argumentative link, not a positional one. "As mentioned earlier" is
  earned only when the earlier mention is far enough back to have been forgotten, roughly
  1,500+ words, and it should name the thing rather than gesture at it.

### Telling the reader what you just told them, inside the same paragraph

- **Shape:** A paragraph whose final sentence compresses its own first three sentences.
  Distinct from the section summary because it operates at paragraph scale, where no reader
  could possibly have lost the thread. **Test:** cover the last sentence of each paragraph in
  a section and read through. If comprehension is unchanged in every case, the paragraphs all
  end in recap.
- **Why it reads as AI:** Paragraph-scale recap has no reader model behind it; it is a shape
  being satisfied.
- **Specimen:** [composite] "Postgres advisory locks are session-scoped. If the connection
  drops, the lock releases automatically. This makes them unsuitable for work that must
  survive a reconnect. So advisory locks are session-scoped and release on disconnect,
  meaning they don't survive reconnects."
- **Repair:** "Postgres advisory locks are session-scoped: drop the connection and the lock
  releases, so they can't guard work that must survive a reconnect."
- **Earned use:** Effectively never. The only paragraph-terminal restatement that earns its
  place is one that draws a consequence the parts did not state, at which point it is not a
  restatement.

### Chat-artifact leakage

- **Shape:** Turn-taking apparatus surviving into published prose: "Would you like me to
  expand on any of these?", "Let me know if you'd like me to go deeper.", "I hope this
  helps!", "Certainly! Here's...", "As an AI...", "Feel free to adjust as needed." Wikipedia's
  list groups these under communication aimed at the requester rather than the reader.
  **Test:** does the sentence address a person who commissioned the text rather than a person
  reading it?
- **Why it reads as AI:** It is literally the seam of the generation process, unedited.
- **Specimen:** [composite] "...and that covers the migration path. Let me know if you'd like
  me to expand on the rollback procedure!"
- **Repair:** Delete. If the rollback procedure matters, write it.
- **Earned use:** Never in published prose of any length or venue. Legitimate only in a live
  conversational turn, where the offer is a real offer. Any occurrence in a committed file,
  a published page, or a document sent to a third party is an editing failure.

### The synthetic-analysis tail

- **Shape:** A participial clause bolted to the end of a sentence or paragraph that asserts
  significance without adding a fact: "...further enhancing its significance", "...cementing
  its role as a key player", "...contributing to the socio-economic development of the
  region", "...underscoring the importance of...", "...highlighting the need for..."
  Wikipedia's list identifies these as "superficial analysis statements" that "attach '-ing'
  phrases end-of-sentence as synthetic analysis." **Test:** ask what the clause would look
  like if false. If it has no falsifiable content, it is decoration.
- **Why it reads as AI:** It simulates the shape of analysis, an evaluative closing move, with
  none of the content, and it recurs at a rate no human sustains.
- **Specimen:** [collected, Wikipedia:Signs of AI writing] "...further enhancing its
  significance"; "...contributing to the socio-economic development."
- **Repair:** Cut the clause, or replace it with the specific consequence: "...which cut
  onboarding from three days to four hours."
- **Earned use:** A closing participial clause is fine prose when it carries a fact or a
  mechanism. It is never earned when the clause is evaluative and unfalsifiable. This holds
  at every length; in Long documents the rate matters most, since one such tail is a stylistic
  choice and eleven is a template.

---

# Family 2: The opening move

### Restating the question before answering it

- **Shape:** The reply opens by reformulating the prompt in more general language, deferring
  the answer by one or more sentences. Momentic's specimen pair is exact: asked "should I use
  WordPress or Webflow?", the AI opens "When it comes to choosing the right CMS for a
  content-heavy site, there are a few important factors to consider." **Test:** find the first
  sentence that would change if the answer changed. Everything above it is throat-clearing.
- **Why it reads as AI:** It is the model warming up its own context window in public.
- **Specimen:** [collected, Momentic] Q: "should I use WordPress or Webflow?" A: "When it
  comes to choosing the right CMS for a content-heavy site, there are a few important factors
  to consider."
- **Repair:** "Webflow, unless you need a plugin ecosystem. Your content is 40 pages of
  marketing copy; Webflow's editor will save you the maintenance."
- **Earned use:** Restating the question is earned when the question was genuinely ambiguous
  and the restatement *disambiguates* it: "Taking 'fastest' to mean p99 latency rather than
  throughput..." That is a scoping move and it belongs in any length. Restating in order to
  fill space is never earned. In Micro and Short venues the answer belongs in sentence one.

### The throat-clearing paragraph that arrives nowhere

- **Shape:** An opening paragraph of context, framing, or scene-setting that could be
  transplanted onto a different article about a different subject with a noun swap. Symptomatic
  openers: "In today's fast-paced world...", "As we navigate the complexities of...", "In an
  era defined by...", "Technology is changing rapidly, and..." **Test:** Bouchard's
  transplant test. "If the first paragraph could be used on a different article with minor
  changes, cut or rewrite it."
- **Why it reads as AI:** Generic openers are the highest-probability continuation of a title,
  which is exactly what a language model produces before it has committed to a claim.
- **Specimen:** [collected, louisbouchard.ai] "In today's fast-paced world"; "As we navigate
  the complexities of..."
- **Repair:** Start at the first specific noun. If the piece is about queue backpressure,
  sentence one contains the word "queue" and a number.
- **Earned use:** A context paragraph is earned when the reader demonstrably lacks the context
  and the context is specific to this subject. In Long reports and Extended documents aimed at
  a mixed-expertise audience, a background paragraph is standard and correct. The test is
  specificity, not length: a background paragraph naming this system, this year, this
  constraint is earned at any length; one naming "the modern landscape" is earned at none.

### "Great question!" and its descendants

- **Shape:** Praise for the prompt before the answer: "Great question!", "That's a really
  insightful point.", "You're absolutely right to be thinking about this.", "This is a common
  and important concern." Documented as a sycophancy artifact; OpenAI rolled back a GPT-4o
  update in April 2025 that was "overly flattering or agreeable, often described as
  sycophantic." **Test:** does the first sentence evaluate the reader rather than the subject?
- **Why it reads as AI:** It is a reward-model artifact, an approval-seeking move that has no
  function in text with a reader rather than a rater.
- **Specimen:** [composite] "Great question, and one a lot of teams get wrong! The short
  answer is that you should shard by tenant."
- **Repair:** "Shard by tenant."
- **Earned use:** Never in written prose. The narrow legitimate cousin is acknowledging a
  *correction*: "You're right, I had the direction of the join backwards" is accountability,
  not flattery, and belongs in any conversational venue. Praise of the question itself is
  never earned, at any length or venue.

### Beginning with a definition nobody asked for

- **Shape:** The piece opens by defining its own title term, usually with a copular sentence:
  "Kubernetes is an open-source container orchestration platform that...". Flagged in
  practitioner critiques as over-explanation, "defining 'email' in email marketing articles,"
  which happens "because it cannot gauge what audiences already know." **Test:** would the
  reader who found this document already know the definition? For anything reached by search
  on the term, yes.
- **Why it reads as AI:** The model has no audience model, so it defaults to the widest
  possible one and defines from zero.
- **Specimen:** [composite] "Rate limiting is a technique used to control the amount of
  incoming and outgoing traffic to or from a network. In this post, we'll look at how to
  implement rate limiting in Redis."
- **Repair:** "Redis has three viable rate-limiter shapes: fixed window, sliding log, and
  token bucket. Only one of them survives a clock skew."
- **Earned use:** Earned in Extended reference material where the definition is the
  document's contract with the reader, in glossaries and standards, and in Instructional
  venue for a genuinely novice audience declared up front ("this tutorial assumes no prior
  Kubernetes experience"). Also earned when the term is contested and the piece is stipulating
  which sense it uses. Never earned as a warm-up in Short prose whose readers arrived by
  searching the term.

### The heading-restating first sentence

- **Shape:** The first sentence under a heading paraphrases the heading. Practitioner
  diagnosis: "if the H2 says 'How pricing works' and the paragraph opens 'Understanding how
  pricing works is important,' you have a wasted sentence." **Test:** compute overlap between
  the heading's content words and the first sentence's. High overlap plus no new noun means
  cut.
- **Why it reads as AI:** The model re-anchors on the heading token by token, producing an
  echo where a human would have started at the content.
- **Specimen:** [collected, paraphrased from practitioner guidance] H2: "How pricing works."
  First sentence: "Understanding how pricing works is important for making the right decision."
- **Repair:** H2: "How pricing works." First sentence: "You're billed per seat per month, and
  seats are counted at the end of the billing period, not the start."
- **Earned use:** Effectively never. The one exception is Extended reference documentation
  where a section must survive being deep-linked and quoted out of context; there, a first
  sentence that re-states the subject as a full noun phrase ("Pricing is per seat per month")
  is a real service. The echo is only slop when it restates without adding.

---

# Family 3: The closing move

### The bookend conclusion (restates the intro)

- **Shape:** A final paragraph that returns to the framing of the opening and re-asserts it.
  Momentic's paired specimen: intro "Technical SEO is often overlooked...foundation
  everything depends on," conclusion "At the end of the day, technical SEO remains the
  foundation..." **Test:** put the intro and conclusion side by side. If they are paraphrases,
  the conclusion is dead weight.
- **Why it reads as AI:** It is the five-paragraph-essay template, learned from millions of
  student essays, where "the conclusion restates the intro."
- **Specimen:** [collected, Momentic] Intro: "Technical SEO is often overlooked...foundation
  everything depends on." Conclusion: "At the end of the day, technical SEO remains the
  foundation..."
- **Repair:** Delete the conclusion. Zinsser: "Don't end by repeating in compressed form what
  you have already told the reader in detail." End on the last thing that is actually new,
  which is usually the last real paragraph you already wrote.
- **Earned use:** A closing synthesis earns its place in Long and Extended documents (roughly
  2,500 words and up) where the reader has held many parts in suspension and the ending
  performs a combination they could not do themselves. It is not earned in Short prose at
  all; a 300-word post that summarizes itself has spent 15% of its budget on nothing. Note
  the venue inversion: in decision docs the summary belongs at the *top* (BLUF/Minto,
  answer-first), and a bottom summary in a memo is a sign the writer buried the lede.

### "In conclusion" and its stealth variants

- **Shape:** Explicit announcement of the ending. Overt: "In conclusion,", "To sum up,", "In
  summary,". Stealth: "Ultimately,", "At the end of the day,", "The bottom line is,", "All
  things considered,", "When all is said and done,", "Taken together,". tropes.fyi is blunt:
  "Competent writing doesn't announce its structure." **Test:** does the paragraph open with
  a phrase whose only job is to say "this is the last paragraph"? The reader can see that.
- **Why it reads as AI:** It labels structure the layout already conveys, and the stealth
  variants cluster at a rate that betrays a template.
- **Specimen:** [composite] "Ultimately, choosing the right database comes down to
  understanding your access patterns and planning for growth."
- **Repair:** Cut the opener and the sentence usually goes with it. If a real recommendation
  survives underneath, promote it: "Use Postgres. Revisit at 50k writes/sec, not before."
- **Earned use:** "In summary" is earned as a *labeled section heading* in Long and Extended
  documents, especially specs, incident reports, and policy, where a reader may want only the
  summary. As an inline paragraph opener it is never earned. "Ultimately" and "at the end of
  the day" are earned only when they mark a genuine contrast with a proximate qualification
  ("...but ultimately none of that matters if the disk fills"), not as ending-flavored
  transitions.

### The forward-looking flourish

- **Shape:** A closing gesture toward an unspecified future: "As AI continues to evolve...",
  "As the landscape continues to shift...", "Only time will tell.", "The future of X is
  bright.", "One thing is certain: X is here to stay." Bouchard lists this among recaps to
  delete, naming "vague conclusions like 'As AI continues to evolve…'". Wikipedia's list
  identifies the same move as a formulaic section closer: "vague speculation about initiatives
  benefiting the subject." **Test:** does the sentence make a claim that could be wrong? If
  not, it is atmosphere.
- **Why it reads as AI:** It is a maximally safe, maximally generic terminal token sequence:
  optimism without commitment.
- **Specimen:** [collected pattern, composite instance] "As the observability landscape
  continues to evolve, teams that invest in strong instrumentation today will be well
  positioned for whatever comes next."
- **Repair:** Delete, or replace with a dated, falsifiable prediction: "OpenTelemetry's logs
  spec stabilizes in the next release; until it does, keep your log pipeline separate."
- **Earned use:** Earned in Long analysis pieces, research write-ups, and strategy memos where
  the forward look is a *specific* claim with a horizon and a condition, and where the reader
  is deciding something on that horizon. The test is falsifiability, not length. A closing
  prediction with a date, a named actor, or a threshold is earned; "the space continues to
  evolve" is earned nowhere.

### The rhetorical-question close

- **Shape:** A question posed and immediately answered, used as an ending beat. "The result?
  A 40% drop in latency." "So what does this mean for your team? Everything." "The takeaway?
  Start small." **Test:** the question has one possible answer and the writer supplies it
  within the same breath, so it is punctuation cosplaying as inquiry.
- **Why it reads as AI:** It is a stock rhythm from marketing copy that the model applies to
  every register, including ones where nobody speaks that way.
- **Specimen:** [composite] "We cut the index, batched the writes, and moved the job off the
  request path. The result? A system that finally holds under load."
- **Repair:** "We cut the index, batched the writes, and moved the job off the request path.
  p99 went from 1.4s to 310ms."
- **Earned use:** Legitimate at low frequency in scan-first web copy, opinion columns, and
  newsletters where a spoken cadence is the house voice; once per piece, never twice. Never
  earned in reference documentation, specs, incident reports, or academic prose. The hard rule
  is frequency: two or more in a document is a tell regardless of venue.

### The "challenges and future prospects" section

- **Shape:** A formulaic penultimate section that pairs generic obstacles with generic
  optimism. Wikipedia's list gives the template: opening "Despite its [positive claims],
  [subject] faces challenges...", closing with "vague speculation about initiatives benefiting
  the subject." Sibling headings: "Challenges and Opportunities", "Limitations and Future
  Work", "Impact and Legacy". **Test:** are the challenges named specifically enough that
  someone could work on one? Are the prospects attached to an actor?
- **Why it reads as AI:** It fills a slot the template demands, whether or not the writer knows
  of any actual challenges.
- **Specimen:** [collected template, Wikipedia:Signs of AI writing] "Despite its rapid growth,
  the sector faces challenges including infrastructure constraints and regulatory uncertainty.
  Ongoing initiatives are expected to further strengthen its position."
- **Repair:** Either name the real limitation with its cost ("The parser is O(n²) on nested
  arrays; a 4MB payload takes 11 seconds") or delete the section.
- **Earned use:** A limitations section is required in research write-ups, RFCs, design docs,
  and incident reports at any length, and omitting it is its own failure. It is earned when it
  is specific and self-incriminating. It is slop when it is symmetrical, hedged, and followed
  by reassurance. The one-line test: a real limitations section makes the author look worse.

### Ending on a summary when the piece already made its point

- **Shape:** The argument concludes at paragraph N; paragraphs N+1 and N+2 exist to satisfy a
  felt obligation to close. **Test:** find the last paragraph containing a fact, number, or
  instruction not present earlier. Everything after it is candidate for deletion.
- **Why it reads as AI:** Generation continues until a closing cadence is produced, rather than
  stopping when the content runs out.
- **Specimen:** [composite] A 600-word post ends with: "So there you have it. Choosing between
  the two approaches depends on your specific needs, but with the considerations above you
  should be well equipped to make the right call for your situation."
- **Repair:** Delete. Zinsser: "The perfect ending should take the reader slightly by surprise
  and yet seem exactly right." He recommends ending on a quotation, a funny remark, or "an
  unexpected last detail." The strongest available ending is usually the sharpest concrete
  detail you already have; move it to the end and stop there.
- **Earned use:** In Short prose (under 800 words), the correct number of summary paragraphs
  is zero. In Medium prose, zero or one, and only if it synthesizes. In Long and Extended
  documents a summary section is standard and expected, and in decision docs it moves to the
  top. Instructional venue is the exception where a terminal "what you built" recap earns its
  place at any length, because it functions as a verification checkpoint.

---

# Family 4: Formatting as a substitute for thinking

### Bolded lead-ins on every bullet

- **Shape:** Every list item opens with a bolded term or phrase followed by a colon or dash and
  a clause. Wikipedia's list names this "inline-header vertical lists" and flags it as an AI
  formatting signature; tropes.fyi calls it "Bold-First Bullets" and notes "almost nobody
  formats lists this way when writing by hand." **Test:** strip the bold. Do the lead-in terms
  form a meaningful taxonomy, or are they just the first words of each sentence promoted to
  labels?
- **Why it reads as AI:** It applies a visual template uniformly, which manufactures the look
  of a structured taxonomy over content that has no such structure.
- **Specimen:** [composite] "**Speed:** The new pipeline is faster. **Reliability:** It's more
  reliable. **Cost:** It costs less."
- **Repair:** "The new pipeline is faster (3.2s to 900ms), fails less often (two incidents last
  quarter, zero this one), and costs about $400/month less."
- **Earned use:** Genuinely correct when the bolded terms are a real, closed, scannable set the
  reader will look things up by: parameter names in API reference, option flags, glossary
  entries, error codes, enum values. That is the description-list case, and Google's style
  guide sanctions description lists for "pairs of related pieces of data." It is earned in
  non-linear reference at any length. It is not earned in linear prose, and it is not earned
  when the labels are abstractions the writer invented to have something to bold. Hard test: if
  the bolded word appears nowhere else in the document or codebase, it is decoration.

### Bullet lists where prose is better

- **Shape:** Continuous reasoning fragmented into bullets, so causal and concessive relations
  between the items vanish. Bouchard's edit list: replace bullets with "developed paragraphs
  with examples or nuance" because models overuse lists. Momentic names "excessive bulleting"
  as flattening nuance. **Test:** do the items have relationships to each other (because,
  but, therefore, unless)? Bullets suppress exactly those connectives, so if the content needs
  them, prose is correct.
- **Why it reads as AI:** Bulleting is a way to look organized without committing to how the
  ideas connect, which is precisely the reasoning a model most often has not done.
- **Specimen:** [collected, Momentic] A benefits list reading: saves time, gives visibility,
  easier sharing, reduces back-and-forth.
- **Repair:** "It saves time mainly by cutting the back-and-forth: everyone can see the current
  state without asking, so the daily status thread disappears."
- **Earned use:** Earned for genuinely parallel, unordered, non-causal items where order does
  not matter and the reader will scan rather than read: feature lists, prerequisites, option
  sets, checklists. Earned for sequences as *numbered* lists in Instructional venue, where
  ASD-STE100's guidance applies directly: "use vertical (numbered or bulleted) lists for
  sequences, conditions, or complex enumerations instead of burying them in prose," and "write
  one instruction per sentence." Strongly earned in scan-first web (NN/g's scannable version
  used bulleted lists, bold keywords, and more headings, and measurably outperformed prose).
  Not earned when the items are stages of an argument.

### Prose where a list is better (the listicle in a trench coat)

- **Shape:** The inverse failure. Enumerated content written as paragraphs with ordinal
  scaffolding: "The first wall is the absence of a free, scoped API... The second wall is the
  lack of delegated access..." tropes.fyi names this "Listicle in a Trench Coat." **Test:**
  count the ordinals. Three or more "the first/second/third X is" constructions means the
  content is a list wearing paragraphs.
- **Why it reads as AI:** It satisfies a "write in prose" instruction by keeping list logic and
  removing list formatting, which is the worst of both.
- **Specimen:** [collected, tropes.fyi] "The first wall is the absence of a free, scoped API...
  The second wall is the lack of delegated access..."
- **Repair:** Make it a list, or make it an argument. If the three items are genuinely parallel
  and unordered, bullet them. If they build, write the causal chain and drop the ordinals.
- **Earned use:** Ordinal prose is earned when the items are unequal in weight and the ordering
  carries meaning, and when there are exactly two or three. In Long argumentative prose, "the
  first problem is X; the second, and worse, is Y" earns the ordinals because the ranking is
  the point. Beyond three items, list formatting is almost always right.

### Tables built for two data points

- **Shape:** A markdown table with two columns and two or three rows, presenting information a
  sentence would carry. Wikipedia's list flags "unusual use of tables": tables appearing "in
  contexts where prose or standard lists would be appropriate." **Test:** Google's style guide
  gives the operational threshold: tables suit "data with three or more related pieces of
  information per item," while "lists are better for simpler data structures." Two columns
  means the table is a list; one row means it is a sentence.
- **Why it reads as AI:** Table syntax is cheap for a model and reads as rigor, so it gets
  applied to content with no dimensionality.
- **Specimen:** [composite] A table with header row `| Option | Description |` and two body
  rows: `| Fast mode | Faster |`, `| Safe mode | Safer |`.
- **Repair:** "Fast mode skips checksum verification; safe mode doesn't. Use safe mode unless
  you're restoring from a known-good snapshot."
- **Earned use:** Earned at three or more columns, or two columns with many rows (six-plus)
  that the reader will look up rather than read: parameter references, compatibility matrices,
  comparison grids, config keys, error-code tables. Strongly earned in non-linear reference at
  any length. Never earned for a two-by-two of adjectives.

### Headers phrased as questions

- **Shape:** Every heading is an interrogative: "What Is Rate Limiting?", "Why Does It
  Matter?", "How Do You Implement It?", "What's Next?" **Test:** are the questions ones a
  reader actually typed, or ones invented to have a heading? If a heading is a question no user
  would search, it is filler.
- **Why it reads as AI:** It reproduces the FAQ-and-featured-snippet template that saturates
  the web-content training distribution, applied to venues where nobody asked anything.
- **Specimen:** [composite] Headings in a 700-word internal design doc: "What Is the Problem?",
  "Why Now?", "What Are the Options?", "What Do We Recommend?"
- **Repair:** Convert to declarative statements that carry the answer: "Retries amplify load
  3x during an outage", "Ship the token bucket before Q3", "Recommendation: token bucket in
  the gateway."
- **Earned use:** Genuinely earned in FAQ sections, support documentation, and SEO-targeted
  pages where the heading mirrors a real user query verbatim; matching the searcher's phrasing
  is the whole function. Also earned in Instructional venue for troubleshooting sections ("Why
  is my build failing?"). Not earned in specs, design docs, memos, or narrative prose, where a
  declarative heading that states the finding is strictly more informative. Mixed evidence
  matters here: a question header is a real device in one venue and pure tic in another, so
  venue governs, not length.

### Emoji as section markers

- **Shape:** Emoji used as structural furniture: 🚀 before "Getting Started", ✅ on every
  benefit, ⚠️ on every caveat, 🔑 on "Key Takeaways". Wikipedia's list names "emoji as
  formatting" as an AI style signature, noting it violates neutral register. **Test:** does
  the emoji encode information not in the adjacent text, or is it a bullet with a costume?
- **Why it reads as AI:** Uniform decorative emoji is a chat-interface habit transplanted into
  documents, and it appears at a density and consistency no human sustains.
- **Specimen:** [composite] "## 🚀 Getting Started ... ## 📦 Installation ... ## ⚡ Performance
  ... ## 🎯 Key Takeaways"
- **Repair:** Remove all of them. Keep headings as words.
- **Earned use:** Earned as a *semantic* marker in a small, consistent, documented set:
  ⚠️ for warnings in a runbook, ✅/❌ in a compatibility matrix, a status dot in a dashboard.
  That is iconography and it carries meaning. Also earned in venues with an established playful
  register (some OSS READMEs, changelogs, internal Slack docs). Never earned as one-per-heading
  decoration, and never in specs, policy, academic, or journalistic venues at any length.

### Over-nesting: three levels of hierarchy for four facts

- **Shape:** H2 containing a single H3 containing a single H4; or nested bullets three deep
  where the deepest level holds one item. Wikipedia's list flags "headings only containing
  other headings," a nested structure with no intermediate text. **Test:** does any heading
  level contain exactly one child? Does any heading have no prose under it before the next
  heading? Both are structural padding.
- **Why it reads as AI:** Outline generation is separable from content generation, so the
  outline gets built to a target depth and the content never fills it.
- **Specimen:** [composite] "## Configuration → ### Environment Variables → #### DATABASE_URL
  → The Postgres connection string." One fact, three headings.
- **Repair:** "## Configuration — `DATABASE_URL` is the Postgres connection string; `REDIS_URL`
  is the cache."
- **Earned use:** Earned in Extended reference material and standards where the hierarchy is a
  *citable addressing scheme* (section 4.2.1 of a spec), where depth serves cross-reference
  rather than emphasis. Google's guidance is the practical floor: include "at least a brief
  introduction under each heading," which kills empty parent nodes outright. Rule of thumb: no
  heading level should exist unless it has at least two siblings, and no heading should be
  immediately followed by another heading.

### The three-item list as default cardinality

- **Shape:** Everything comes in threes, whether or not reality does: three benefits, three
  challenges, three adjectives, three examples. Wikipedia's list has a dedicated "rule of
  three" entry, noting LLMs overuse "adjective, adjective, adjective" and "phrase, phrase, and
  phrase," and that lists get forced into triads even when awkward: "three types of saws,
  three application categories, three artistic constraints repeatedly reinforced." Momentic
  calls it "reflexive rule of three," with the specimen "better targeting, stronger creative,
  and consistent follow-up" offered "when only two factors may have mattered." **Test:** count
  list cardinalities across the document. If a majority are exactly three, the number is a
  template, not a finding.
- **Why it reads as AI:** Three is rhetorically satisfying, so a model optimizing for
  plausibility lands there regardless of the true count, and the giveaway is the third item
  being weakest.
- **Specimen:** [collected, Momentic] "better targeting, stronger creative, and consistent
  follow-up."
- **Repair:** Delete the item you had to invent. "Better targeting and stronger creative"
  is honest at two. Where the real count is seven, use seven.
- **Earned use:** Three is earned whenever three is the true count, which is often. The pattern
  to flag is not any individual triad; it is *cardinality uniformity across a document*. In any
  piece over ~800 words containing four or more lists, expect a spread of counts. Rhetorical
  tricolon as a deliberate device is earned once per piece in persuasive venues (speeches,
  op-eds, marketing) and reads as craft; at four occurrences it reads as a machine.

### Symmetrical sections and template headings

- **Shape:** Every section is roughly the same length and every heading fits the same mold.
  Bouchard's edit list names the pattern: "every couple of paragraphs has a heading like
  'Understanding X,' 'The Importance of Y,' 'The Future of Z.'" Wikipedia's list notes "'X and
  Y' format" boilerplate headers. **Test:** measure section word counts. Real subjects are
  lumpy; a document whose sections all land within 15% of each other was outlined to a target.
- **Why it reads as AI:** Uniform section length means the outline was filled to a quota rather
  than sized to the material.
- **Specimen:** [collected, louisbouchard.ai] "Understanding X", "The Importance of Y", "The
  Future of Z."
- **Repair:** Let the section about the thing you actually know run four times as long as the
  one where you only have a fact and a caveat. Cut the sections that exist only to complete the
  pattern.
- **Earned use:** Uniform structure is correct and required in genuinely templated venues:
  API endpoint documentation, release notes, incident report templates, structured abstracts,
  catalog entries (including this file). In those venues symmetry is the contract. In
  argumentative or narrative prose at any length, symmetry is a defect.

---

# Family 5: Paragraph shape

### Uniform paragraph length

- **Shape:** Every paragraph is three to five sentences, roughly 60 to 80 words. Bouchard lists
  "same-sized paragraphs" among the things to break up. **Test:** compute the standard
  deviation of paragraph word counts. Human prose is wildly uneven; a tight distribution is a
  machine fingerprint.
- **Why it reads as AI:** Paragraph breaks are being placed on a rhythm rather than at the
  boundaries of ideas, so the ideas do not get to be different sizes.
- **Specimen:** [composite] Eight consecutive paragraphs of 4 sentences each, all 65 to 78
  words, in a 900-word post.
- **Repair:** Merge paragraphs that develop one idea. Split the one that carries three. Let a
  paragraph be one sentence when the idea is one sentence long, and let one run twelve
  sentences when it is a single sustained argument.
- **Earned use:** Bounded, consistent paragraphs are correct in Instructional and reference
  venues, and ASD-STE100 codifies it: "one topic per paragraph," "maximum ~6 sentences per
  paragraph." In technical procedures, uniformity is a readability feature and a translation
  memory feature, not a tic. In essays, features, opinion, and narrative at any length,
  uniformity is the defect. Venue decides this one entirely.

### Topic-sentence-then-support in every single paragraph

- **Shape:** Rigid claim-evidence-recap in each paragraph, with no variation. Practitioner
  diagnosis: AI "follows an identical pattern, topic sentence, supporting evidence, summary
  sentence, in every paragraph," where "humans vary their approach with questions, one-word
  paragraphs, or stories." **Test:** read only the first sentence of every paragraph. If the
  document is fully intelligible from that alone, the paragraphs are all the same machine.
- **Why it reads as AI:** The pattern is right often enough to have been learned, and applying
  it universally is the giveaway that no per-paragraph decision was made.
- **Specimen:** [composite] Every paragraph in a 1,200-word piece opens with a declarative
  claim, follows with two supporting sentences, and closes with "This means that..."
- **Repair:** Vary the entry point. Open some paragraphs on the evidence and let the claim
  land last. Open one on a question. Open one mid-scene. Let at least one paragraph be a
  single sentence because the idea is a single sentence.
- **Earned use:** Topic-first paragraphs are correct and expected in reference documentation,
  scan-first web (NN/g: "one idea per paragraph," "the inverted pyramid style starting with the
  conclusion"), and decision docs following BLUF. In those venues, deviating costs the scanning
  reader real money. The pattern is slop specifically in Medium-and-longer linear prose meant
  to be read continuously, where the uniformity flattens emphasis.

### The one-sentence paragraph used for emphasis, repeatedly

- **Shape:** Isolated short lines deployed for drama, in clusters. Momentic names "staccato
  clusters" with the specimen "Traffic dropped 40% overnight. Rankings disappeared. The client
  called." tropes.fyi calls the paragraph-level version "Short Punchy Fragments," with "He
  published this. Openly. In a book. As a priest." **Test:** count one-sentence paragraphs.
  One in a long piece is a hammer blow; four is a tic; the device costs nothing to produce and
  its value is entirely scarcity.
- **Why it reads as AI:** Emphasis formatting is being applied where emphasis was not earned,
  and the model cannot tell which of its sentences deserves the spotlight, so it lights several.
- **Specimen:** [collected, Momentic] "Traffic dropped 40% overnight. Rankings disappeared. The
  client called."
- **Repair:** Keep at most one, on the sentence that genuinely carries the turn. Fold the rest
  back into paragraphs: "Traffic dropped 40% overnight and rankings vanished; the client called
  before we'd finished reading the alert."
- **Earned use:** Earned once, maybe twice, in Medium and Long persuasive or narrative prose
  (essays, op-eds, feature writing, newsletters), at the pivot of the argument. Earned freely
  in scan-first web copy, where short lines are the format. Never earned in reference,
  academic, or specification venues. The operative rule is a budget: roughly one per 1,000
  words in prose, and zero in technical documentation.

### Balanced treatment of unbalanced things

- **Shape:** A major factor and a marginal one get the same number of words, the same heading
  level, and the same hedging. Three options with wildly different merit each get a paragraph
  of equal length. **Test:** rank the items by how much they actually matter, then rank them by
  word count. If the two orderings disagree, the piece is misallocating attention.
- **Why it reads as AI:** Section-filling is uniform by default; proportioning coverage to
  importance requires a judgment the model avoids making.
- **Specimen:** [composite] A postmortem giving 140 words to "the primary database ran out of
  disk" and 140 words to "the runbook link in the alert was stale."
- **Repair:** 400 words on the disk, one sentence on the stale link, and the ratio itself tells
  the reader what happened.
- **Earned use:** Equal treatment is earned when the things are genuinely equal, and in venues
  where symmetry is a fairness obligation: comparison tables, RFP responses, candidate
  evaluations, catalog entries, structured product comparisons. In those, unequal coverage
  reads as bias. Everywhere else, and at every length, proportion is the writer's main
  instrument for expressing judgment, and spending it evenly is the same as declining to judge.

---

# Family 6: Rhetorical posture

### Both-sidesing when one side is right

- **Shape:** Symmetrical presentation of asymmetric evidence: "Some argue X, while others
  contend Y", "There are compelling arguments on both sides", "Proponents say... critics
  counter..." Media criticism has a name and a canonical joke for this: false balance, or
  bothsidesism, "a media bias in which journalists present an issue as being more balanced
  between opposing viewpoints than the evidence supports," and Krugman's "Views Differ on Shape
  of Planet." **Test:** does the passage give equal words and equal hedging to positions with
  unequal evidence? Would a specialist reading it be able to tell which side is right?
- **Why it reads as AI:** Symmetric framing is the safest output, and models are trained toward
  agreeableness and non-commitment; the result is text that "presents, for the supposed sake of
  fairness, every perspective held on a topic."
- **Specimen:** [composite] "There are arguments on both sides of the tabs-versus-spaces
  question. Some developers prefer tabs for configurable indentation, while others favor spaces
  for rendering consistency. Ultimately, the right choice depends on your team."
- **Repair:** "Use whatever your formatter enforces. The question stopped mattering when
  gofmt/prettier/black shipped; pick one, commit the config, and never discuss it again."
- **Earned use:** Genuinely earned when the disagreement is real and live among informed people
  and the reader must decide: unsettled research, contested design tradeoffs, policy questions
  turning on values rather than facts. In Long analysis and decision docs, laying out both
  positions fairly is the job. The distinguishing move: an earned both-sides passage still tells
  you where the weight of evidence sits, or names precisely what would settle it. A slop one
  ends in symmetry.

### Unearned hedging on things the writer knows

- **Shape:** Qualifiers stacked on claims the author is not actually uncertain about: "It's
  worth noting that this may potentially...", "arguably", "in many cases", "generally
  speaking", "could be seen as", "some might say". Practitioner diagnosis: hedges appear
  "uniformly throughout, showing relentless cautiousness" where humans vary confidence.
  Research on LLM behavior identifies hedging as an RLHF artifact: "maybe", "perhaps", "it
  depends" and general refusals to take definitive positions, "potentially reinforced by RLHF
  and preference-based finetuning." **Test:** count hedges per 100 words and check the
  variance. Real writers hedge hard where they are unsure and not at all where they are sure;
  flat hedging across a document means the hedges track style, not epistemics.
- **Why it reads as AI:** Uniform caution is a policy, not a belief, and it signals a writer
  with no stake in being right.
- **Specimen:** [composite] "It's worth noting that in many cases, adding an index could
  potentially help improve query performance, though results may vary depending on your
  specific workload."
- **Repair:** "Add the index. It turns the sequential scan into an index scan; on your row
  count that's roughly 200ms to under 5ms. It costs you about 8% on write throughput."
- **Earned use:** Hedging is earned, and required, where the uncertainty is real and its shape
  is stated: sample sizes, confidence intervals, untested configurations, predictions.
  Required in academic, medical, legal, and safety-critical venues at any length. The rule is
  that a legitimate hedge names its source: "in Postgres 14 and earlier" or "we tested only on
  the read replica" is a hedge with content. "May potentially, in some cases" is not.

### The "it depends" that never says on what

- **Shape:** A dependency asserted and then never resolved. "It depends on your use case."
  "The answer varies by organization." "There's no one-size-fits-all solution." **Test:** does
  the passage name the variable and give the reader a way to check their own value of it? If
  not, it has converted a question into a shrug.
- **Why it reads as AI:** Naming the deciding variable requires a model of the reader's
  situation and a willingness to be wrong about it; the bare "it depends" is the cost-free
  version.
- **Specimen:** [composite] "Whether you should use microservices depends on your specific
  context, team structure, and organizational needs. There's no one-size-fits-all answer here."
- **Repair:** "Split the service when two teams are blocking each other on deploys. Below that
  threshold the coordination cost is lower than the operational cost, so stay monolithic. You
  have one team; stay monolithic."
- **Earned use:** "It depends" is a strong opening when the very next clause supplies the
  dependency and, ideally, the reader's likely value: "It depends on whether your writes are
  bursty; if p99 write rate is more than 5x median, use the queue." Earned in any venue and any
  length in that form. The bare, unresolved version is earned nowhere; it is the shape of an
  answer with the answer removed.

### Enumerating options instead of recommending one

- **Shape:** Three to five approaches presented with balanced pros and cons and no
  recommendation, often closing with "the best choice depends on your needs." **Test:** does
  the document contain a sentence in the imperative mood, or a sentence beginning "I'd" or "We
  should"? If not, no recommendation was made.
- **Why it reads as AI:** Enumerating is safe and recommending is falsifiable, and a model
  optimizing for approval avoids the second.
- **Specimen:** [composite] "Option A: Redis. Pros: fast, simple. Cons: memory-bound.
  Option B: Postgres. Pros: durable, already deployed. Cons: slower. Option C: Kafka. Pros:
  scales. Cons: operational overhead. Each has tradeoffs to consider for your use case."
- **Repair:** Keep the options, then add: "Use Postgres. You already run it, your queue depth
  peaks at 400, and neither of the other two buys you anything at that volume. Revisit at 50k
  messages/sec."
- **Earned use:** Option enumeration without a recommendation is legitimate in exactly two
  situations. First, when the writer genuinely lacks the information to decide and says so,
  naming what they'd need. Second, in venues where recommending is out of scope: neutral
  reference material, standards, comparison documentation, encyclopedia entries. In RFCs,
  design docs, memos, consulting deliverables, and answers to a direct question, at any length,
  an options list with no recommendation is an unfinished document. The strongest form keeps
  both: options for the reader who disagrees, recommendation for the reader who doesn't.

### Praising the reader's premise mid-document

- **Shape:** Validation inserted into the body: "This is a great point to consider.", "You're
  right to be cautious here.", "That's an important distinction to make.", "This is where many
  teams get it wrong, and rightly so." **Test:** does the sentence evaluate the reader's
  thinking rather than the subject?
- **Why it reads as AI:** Sycophancy is a documented reward-model artifact; human labelers
  "show a preference for agreeable and validating responses," so the behavior is trained in.
- **Specimen:** [composite] "You're right to be thinking about idempotency here, and it's a
  consideration many teams overlook. The way to handle it is..."
- **Repair:** "Handle idempotency with a dedupe key on the consumer side..."
- **Earned use:** Earned in genuinely interpersonal venues where the relationship is the point:
  code review comments, teaching feedback, mentoring notes, editorial letters. There,
  acknowledging what someone got right is information, and specificity is what makes it real
  ("the retry backoff is right" beats "great thinking"). Never earned in documentation,
  articles, specs, or any prose with an anonymous reader.

### Apologizing or self-deprecating in the copy

- **Shape:** The document undermining itself: "This is just a quick overview and doesn't cover
  everything.", "Admittedly, this is an oversimplification.", "I'm no expert, but...",
  "Apologies if this is already obvious." **Test:** does the sentence lower the reader's
  expectation without changing what the document delivers?
- **Why it reads as AI:** It is defensive scaffolding against being wrong, and Wikipedia's list
  notes that human writing "avoids such defensive scaffolding."
- **Specimen:** [composite] "This is admittedly a simplification, and there's much more nuance
  than can be covered here, but the basic idea is that the scheduler batches work."
- **Repair:** "The scheduler batches work into 50ms windows. Nested batches and priority
  inversion are out of scope."
- **Earned use:** Scope limitation is earned and valuable at any length, stated as scope rather
  than apology: "Out of scope: authentication, multi-region." That is a contract with the
  reader. Genuine epistemic disclosure is earned in research and analysis: "we tested three
  configurations, not the fourth." What is never earned is the tonal apology, the one that
  lowers confidence without narrowing scope. Rewrite every apology as a scope statement or
  delete it.

---

# Family 7: Information-density failures

### The restatement sentence

- **Shape:** A sentence that re-expresses its predecessor in different words, adding no new
  noun, number, mechanism, or consequence. Often introduced by "In other words,", "Put
  differently,", "That is to say,", "Essentially,", "Simply put,". **Test:** list the
  content-bearing nouns in sentence N and sentence N+1. If N+1 introduces none, delete it.
- **Why it reads as AI:** Paraphrase is the cheapest way to continue generating, so it is what
  fills the gap when the model has run out of things it knows.
- **Specimen:** [composite] "The cache is invalidated on every write. This means that whenever
  a write occurs, the cached value is discarded. In other words, writes clear the cache."
- **Repair:** "Every write invalidates the cache, so a write-heavy workload gets no cache
  benefit at all."
- **Earned use:** One restatement is earned when it translates registers for a stated reason:
  a formal definition followed by a plain-language gloss, a mathematical statement followed by
  its intuition, jargon followed by its everyday equivalent. Earned in Instructional and
  Extended reference venues aimed at mixed-expertise readers. Never earned twice on the same
  idea, and never when both versions are in the same register.

### The treadmill (one point diluted across a document)

- **Shape:** A single argument restated in many guises across thousands of words with no
  development. Named "One-Point Dilution" in tropes.fyi: "making a single argument and
  restating it multiple ways across thousands of words without adding substance." The
  quantified version: "a 500-word AI section might contain 100 words of actual information and
  400 words of restatement," and "you finish reading and realize you learned almost nothing new
  after the first paragraph." **Test:** the restatement ratio from the calibration section. Also
  useful: write a one-sentence summary of the document, then ask what any given section adds to
  it. If several sections give the same answer, they are the same section.
- **Why it reads as AI:** Length targets are easy to hit by expansion and hard to hit by
  research, so a model asked for 1,500 words on a 300-word idea produces the 300-word idea five
  times.
- **Specimen:** [collected pattern] A 1,500-word post whose thesis ("write tests before you
  refactor") appears in the intro, in each of three sections, and in the conclusion, with no
  new evidence in any of them.
- **Repair:** Cut to the length the material actually supports. A sharp 400 words beats a padded
  1,500 in every venue. If the length is contractual, add research: a benchmark, a case, a
  counterexample, an interview, a number.
- **Earned use:** Deliberate repetition is earned in pedagogy (spaced reinforcement across a
  course or tutorial series), in speeches, and in safety documentation where a warning is
  repeated at each point of hazard. In all three, repetition is placed where the reader
  re-encounters the need, not scattered to fill a word count. Never earned in Short or Medium
  prose.

### Examples that illustrate nothing

- **Shape:** An example that restates the abstraction at the same level of abstraction:
  "For example, businesses can use AI to streamline workflows and improve outcomes." Bouchard
  flags exactly this as a "generic example" to replace with "concrete, specific details."
  **Test:** does the example contain a proper noun, a number, a date, a quote, or a named
  system? If not, it is the abstraction wearing an "for example."
- **Why it reads as AI:** Real examples require specific knowledge; generic ones can be
  generated from the abstraction alone, which is precisely what happens.
- **Specimen:** [collected, louisbouchard.ai] "businesses can use AI to streamline workflows
  and improve outcomes."
- **Repair:** "Klarna's support bot handled 2.3M chats in its first month, doing the work of
  about 700 agents, and their average resolution time went from 11 minutes to under 2."
- **Earned use:** An example without specifics is never earned. What *is* earned, at any length,
  is a deliberately schematic example when teaching a form rather than a fact: "for example,
  `f(x) = x + 1`" in a math text, or `foo`/`bar` in a syntax demonstration. There the
  genericness is the pedagogy. Outside that, if the example can't name something, cut it and
  keep the abstraction; two abstractions are worse than one.

### Abstraction stacked on abstraction

- **Shape:** Successive sentences each operating at a high level with no concrete anchor
  anywhere in the paragraph: capability, framework, ecosystem, alignment, transformation,
  landscape, solution, approach, strategy, leverage. **Test:** scan the paragraph for a
  concrete noun (something you could photograph), a number, or a proper noun. A paragraph with
  none is unanchored.
- **Why it reads as AI:** Abstract prose is unfalsifiable and therefore safe, and it is what
  remains when a model writes about a topic it has patterns for but no facts about.
- **Specimen:** [composite] "Organizations seeking to leverage modern data infrastructure must
  align their strategic priorities with the evolving capabilities of the ecosystem, ensuring
  that transformation initiatives deliver sustainable value across the enterprise."
- **Repair:** "Before you buy a data warehouse, count your daily row volume. Under 10M rows a
  day, Postgres is still the answer and Snowflake is a $40k/year mistake."
- **Earned use:** Sustained abstraction is earned in genuinely abstract subjects: mathematics,
  formal specification, type theory, philosophy, legal drafting. In those, precision lives at
  the abstract level and concretizing loses information. Also earned briefly in Long documents
  where a general principle is being stated before its instances. The operational rule for
  everything else: no more than two consecutive sentences without a concrete anchor, at any
  length.

### The "which means" chain

- **Shape:** Consequence connectives strung together where each link merely rephrases the last:
  "which means", "so that means", "in other words", "what this really means is", "and that
  translates to". **Test:** at each link, ask whether the consequent contains information not
  derivable from the antecedent by synonym substitution. If it does not, the link is a
  paraphrase wearing an inference.
- **Why it reads as AI:** Inference connectives are cheap to emit and produce the cadence of
  reasoning; whether a real inference occurred is not checked.
- **Specimen:** [composite] "The lock is held for the whole transaction, which means other
  writers have to wait, which means throughput drops under contention, which means the system
  doesn't scale well with concurrent writes."
- **Repair:** "The lock is held for the whole transaction, so concurrent writers serialize.
  At 40 concurrent writers we measured 12 tx/sec against 380 with row-level locking."
- **Earned use:** A "which means" chain is earned when each step is a genuine derivation the
  reader could not have made, and it is the right structure for walking someone through
  consequences in Instructional venue and in incident analysis, where the causal chain is the
  content. The limit is roughly two links before it should be restated as a single claim with
  evidence. Any chain whose final term is a synonym of its first term is circular and gets cut.

### Over-explanation of what the reader already knows

- **Shape:** Definitions, background, and caveats calibrated for a reader far below the actual
  audience. Documented as a consequence of the model having no audience model: it explains
  basic concepts unnecessarily, "defining 'email' in email marketing articles," "because it
  cannot gauge what audiences already know." **Test:** name the reader in one sentence. Then
  check every explanatory passage against that reader.
- **Why it reads as AI:** With no audience model, the safest target is the least-informed
  possible reader, and that target is almost never the real one.
- **Specimen:** [composite] In a document for backend engineers: "A database is a structured
  collection of data. Databases allow applications to store and retrieve information."
- **Repair:** Delete. Start at the first thing this reader does not already know.
- **Earned use:** Earned when the audience is genuinely mixed and the explanation is
  *skippable*: a linked glossary, a collapsible aside, a footnote, a clearly-marked "background"
  section a reader can jump. Earned inline in Instructional venue for a declared beginner
  audience. In Extended reference, a definition section is standard because readers arrive at
  every level. Never earned inline in prose whose reader has been identified as an expert.

---

## Cross-cutting detection notes for the command

Three measurements catch most of this layer before any pattern matching:

1. **Paragraph-length variance.** Low variance is the single strongest discourse fingerprint,
   and it is cheap to compute. Applies to linear prose; skip for reference and instructional
   venues, where uniformity is correct.
2. **First-sentence readthrough.** Read only the first sentence of each paragraph. If that
   alone reconstructs the document, every paragraph is topic-sentence-first and the body text
   is filler. If the first sentences are also all the same grammatical shape, that is two
   findings.
3. **Head-and-tail deletion.** Delete the first paragraph and the last paragraph, then read.
   In a large share of AI drafts nothing is lost, which is the fastest available evidence that
   the opening and closing moves were both template.

Two rulings that decide most disputed cases:

- **Length governs the closing move.** Under 800 words, zero summary paragraphs. 800–2,500,
  zero or one, and only if it synthesizes rather than restates. Over 2,500, a summary is
  expected. In decision docs the summary inverts to the top regardless of length.
- **Venue governs the formatting moves.** Bold lead-ins, bullets, tables, question headings,
  uniform paragraphs, and topic-sentence-first are correct in non-linear reference,
  instructional, and scan-first web, and are tics in linear prose. Do not flag them without
  first classifying the venue.

---

## Sources

- [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
- [How AI-generated prose diverges from human writing and why it matters — Reuters Institute](https://reutersinstitute.politics.ox.ac.uk/news/how-ai-generated-prose-diverges-human-writing-and-why-it-matters)
- [34 types of AI slop you should avoid in your content — Momentic](https://momenticmarketing.com/blog/avoid-ai-slop)
- [AI Writing Tropes to Avoid — tropes.fyi](https://gist.github.com/ossa-ma/f3baa9d25154c33095e22272c631f5a1)
- [How to Clean Up AI-Generated Drafts Without Sounding Like ChatGPT — Louis Bouchard](https://www.louisbouchard.ai/ai-editing/)
- [Signs of AI Writing: 27 Red Flags You Keep Missing — vrid.ai](https://vrid.ai/blog/signs-of-ai-writing)
- [ASD-STE100 Simplified Technical English writing rules](https://github.com/danyuchn/asd-ste100-skill/blob/master/references/writing-rules.md)
- [Organizing large documents — Google technical writing course](https://developers.google.com/tech-writing/two/large-docs)
- [Tables — Google developer documentation style guide](https://developers.google.com/style/tables)
- [Lists — Google developer documentation style guide](https://developers.google.com/style/lists)
- [How Users Read on the Web — Nielsen Norman Group](https://www.nngroup.com/articles/how-users-read-on-the-web/)
- [Concise, SCANNABLE, and Objective: How to Write for the Web — Nielsen Norman Group](https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/)
- [Signposting Language in Academic Writing — CASRAI](https://casrai.org/guides/signposting-language-in-academic-writing)
- [On Writing Well by William Zinsser — book summary](https://tylerdevries.com/book-summaries/on-writing-well/)
- [False balance — Wikipedia](https://en.wikipedia.org/wiki/False_balance)
- [Paul Krugman on Journalistic Balance — Columbia Journalism Review](https://archives.cjr.org/campaign_desk/paul_krugman_on_journalistic_b.php)
- [What Is Information Gain in SEO — Semrush](https://www.semrush.com/blog/information-gain/)
- [BLUF (communication) — Wikipedia](https://en.wikipedia.org/wiki/BLUF_(communication))
- [The Minto Pyramid Principle Explained — BetterUp](https://www.betterup.com/blog/minto-pyramid)
- [AI sycophancy: The downside of a digital yes-man — Axios](https://www.axios.com/2025/07/07/ai-sycophancy-chatbots-mental-health)
- [The Social Sycophancy Scale — arXiv](https://arxiv.org/pdf/2603.15448)
