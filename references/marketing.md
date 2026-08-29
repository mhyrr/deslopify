# Research: Marketing-Copy Slop + Prior Art

Feeds the `/deslopify` rewrite. Primary target: generic copy and landing pages
(marketing prose, product pages, README intros, docs landing text).

Two sections:
1. **Marketing-copy-specific slop catalog** + what good landing-page copy does
2. **Prior-art survey** (published deslop prompts, detectors, humanizers, prose linters)

---

# SECTION 1 — MARKETING-COPY-SPECIFIC SLOP

## Why this genre needs its own catalog

General AI-prose slop is a *sentence-level* problem: em dashes, "it's not X, it's
Y", false agency, throat-clearing. Marketing slop is a *structural* problem. The
tics are genre formulas — templates the model fills rather than phrasings it
favors. You can delete every em dash from a landing page and still have a page
that could be any of four hundred competitors, because the slop lives in the
shape of the page, not the texture of the sentences.

Two consequences for the command:

- **Sentence-level rewriting cannot fix most of these.** Repairing "The smartest
  way to manage your invoices" requires knowing something true about the product.
  If the editor doesn't know it, the honest move is to flag and ask, not to
  substitute a different empty headline.
- **Every formula here is correct sometimes.** Formula is not the disease.
  Formula applied without a specific fact is. That's why every entry has an
  Earned-use field, and why the command must be able to say "leave it."

### Three diagnostics that catch more than any blacklist

Use these before reaching for the pattern list. They are cheap, and they find the
slop that has no signature phrase.

1. **The swap test.** Replace the product name with a direct competitor's.
   Does the sentence become false? If not, the sentence carries no information.
   ("Built for modern teams" survives the swap. "Deploys in 40 seconds on a
   cold cache" doesn't.)
2. **The negation test.** Invert the claim. Would any company ever say the
   opposite? Nobody advertises "clunky, insecure, and slow." A claim whose
   negation is unsayable is table stakes, not a value proposition.
3. **The mechanism test.** After each benefit sentence, ask "how?" If the page
   never answers within two sections, the copy is benefit-only vapor. A reader
   who can't picture the product cannot buy it.

A fourth, for headlines specifically — **the specificity floor** (Ogilvy):
strip every adjective and adverb from the headline. What facts remain? If
nothing remains, the headline was decoration.

---

## The catalog

### The [Adjective] Way To [Verb] Your [Noun]

- **Formula:** `The {smartest|easiest|fastest|simplest} way to {verb} your {noun}.`
  A superlative adjective doing the work a fact should do. The construction is
  grammatically complete and semantically empty; it asserts rank without a
  comparison class.
- **Specimens:**
  - "The smartest way to manage your team's knowledge."
  - "The easiest way to turn your passion into income."
  - "The simplest way to ship faster."
- **Repair:** Replace the adjective with the mechanism or the number that
  justifies it.
  - → "Search every doc, ticket, and Slack thread from one box."
  - → "Sell your first course without building a website."
  - → "Ship on Friday. The deploy takes 40 seconds and rolls back in one click."
- **Earned use:** When you can defend the superlative on the page — a benchmark,
  a step count, a competitor comparison a reader can check. "The fastest way to
  X" is fine directly above a table showing X at 40s vs. the field's 6 minutes.
  It is also fine when the category is genuinely new and "way to" names a real
  novel path. The failure is the adjective floating free of evidence.

---

### Smarter, Not Harder (the antithetical slogan)

- **Formula:** `{Verb} {comparative}, not {comparative}.` Two abstractions in
  opposition, no referent for either. A close cousin of the general-prose
  "it's not X, it's Y" tic, but here it occupies the headline slot where a
  claim should live.
- **Specimens:**
  - "Work smarter, not harder."
  - "Build faster, not bigger."
  - "Hire better, not more."
- **Repair:** Name the specific substitution the product actually makes.
  - → "Stop rebuilding the same report every Monday. Set it once; it emails
    itself."
  - → "One service instead of nine. Same throughput."
  - → "Screen 200 applicants in the time it takes to read 20."
- **Earned use:** As a *section* header introducing a genuine either/or the
  product forces — a real tradeoff the reader is being asked to make, spelled
  out immediately below. Almost never earned as the hero headline, because the
  hero has to carry a claim and this construction carries only a posture.

---

### Finally, a [X] That [Y]

- **Formula:** `Finally, {a|an} {category} that {does the obvious thing}.`
  "Finally" pre-loads a grievance the reader may not hold, and flatters the
  writer's sense of arrival. Often the `{Y}` is a baseline expectation.
- **Specimens:**
  - "Finally, a CRM that doesn't get in your way."
  - "Finally, analytics that make sense."
  - "Finally, project management your team will actually use."
- **Repair:** Drop "finally" and see whether the claim stands alone. Usually it
  needs a fact welded on.
  - → "A CRM your reps don't have to update. It reads their sent mail."
  - → "Analytics with one number per page and a link to the query behind it."
  - → "Project management with no required fields. Ship a task in four words."
- **Earned use:** When the grievance is documented on the page — a quoted
  review, a support thread, a named category failure the audience demonstrably
  shares. If you can point at the "finally," you've earned it. Also legitimate
  in a launch post to a waitlist that has literally been waiting.

---

### Meet [Product] / [Product], Reimagined

- **Formula:** `Meet {Product}.` or `{Category}, reimagined.` or
  `{Product} 2.0` / `The future of {category}`. The announcement hero — a
  headline that announces that an announcement is occurring, spending the most
  valuable line on the page saying nothing about the product.
- **Specimens:**
  - "Meet Cascade. The future of team collaboration."
  - "Invoicing, reimagined."
  - "Introducing Vertex — the next generation of data tooling."
- **Repair:** Give the line back to a claim; the product name is already in the
  logo and the URL.
  - → "Cascade keeps your docs, tickets, and decisions in one searchable place."
  - → "Send an invoice in nine seconds. Get paid in two days, not thirty."
  - → "Query 40TB from a laptop. No cluster to provision."
- **Earned use:** "Meet X" is correct on a genuine launch page for a product the
  audience has never seen, when the visual immediately below shows the thing —
  the headline names it, the screenshot explains it. It is also correct in
  a change announcement to existing users ("Meet the new editor"), where the
  news *is* the news. It is wrong on an evergreen homepage.

---

### The Subhead That Restates The Headline

- **Formula:** Hero headline makes a claim; subhead makes the same claim with
  more syllables and a subordinate clause. The subhead slot — the highest-value
  real estate for specificity, proof, or the "for whom" — is spent on
  paraphrase. This is the single most common structural failure in AI landing
  copy, because "write a headline and a subheadline" reads to the model as
  "say it twice."
- **Specimens:**
  - H: "Ship faster." / S: "Accelerate your development velocity and get to
    market sooner."
  - H: "Analytics that make sense." / S: "Understand your data with an
    analytics platform designed for clarity and comprehension."
  - H: "One place for all your work." / S: "Bring all of your team's work
    together into a single unified workspace."
- **Repair:** The subhead must add one of exactly three things: **who it's for**,
  **how it works**, or **proof**. Never a synonym.
  - → H: "Ship faster." / S: "Preview environments in 12 seconds, on every PR.
    Free for open source."
  - → H: "Analytics that make sense." / S: "One number per page, with the SQL
    that produced it one click away."
  - → H: "One place for all your work." / S: "Docs, issues, and decisions in one
    search index. Built for teams of 10 to 200."
- **Earned use:** Restating is legitimate when the headline is deliberately
  oblique or metaphorical and the subhead is the plain-language translation —
  the headline earns attention, the subhead earns understanding. That's a
  two-move design, not a repetition. The test: could you delete the subhead and
  lose no information? If yes, it's slop. Could you delete the *headline* and
  lose no information? Then the headline was the decoration.

---

### Value-Prop Abstraction

- **Formula:** A claim assembled from category-neutral parts — `built for
  {modern|today's|growing} teams`, `designed for how you actually work`,
  `everything you need to {abstract outcome}`, `powerful yet simple`. Fails the
  swap test by construction: the sentence was generated from the category, not
  from the product.
- **Specimens:**
  - "Built for modern teams."
  - "Designed for the way you actually work."
  - "Powerful enough for enterprises, simple enough for everyone."
  - "Everything you need to grow your business, all in one place."
- **Repair:** Substitute the specific. This nearly always requires a fact the
  editor may not have — flag rather than invent.
  - → "Built for teams of 5 to 50 who share one repo."
  - → "Works in your terminal. No web app to keep open."
  - → "Runs on a laptop for one user and on 40 nodes for 4,000. Same config
    file."
  - → "Invoices, expenses, and payroll. If you need inventory, use something
    else."
- **Earned use:** Audience-naming is real information when the audience is
  *narrow*. "Built for solo accountants who file fewer than 200 returns a year"
  is one of the most valuable sentences on a page — it tells most readers to
  leave, which is a service. The formula is only slop when the "for" is
  universal. Sharpening rule: if the audience clause doesn't exclude anyone, it
  isn't an audience clause.

---

### The Feature Triad

- **Formula:** Exactly three feature cards, parallel bold headers of similar
  length, one-sentence bodies of similar length, often with three icons. The
  count is an artifact of the template, not of the product. Frequently the
  third card is visibly weaker — invented to fill the grid.
- **Specimens:**
  - **Fast** / "Lightning-fast performance keeps your team moving." — **Secure**
    / "Enterprise-grade security protects your data." — **Flexible** /
    "Adapts to any workflow your team needs."
  - **Collaborate** / "Work together in real time." — **Automate** / "Let the
    robots handle the busywork." — **Scale** / "Grows with your business."
- **Repair:** Write the features that exist, in the number that exist, at the
  length each deserves. Asymmetry is a signal of honesty.
  - → Two blocks: one long one on the thing that actually differentiates
    (with a screenshot and a number), one short one on the table-stakes cluster
    ("SSO, audit logs, SOC 2 — the usual, all included").
  - → Five, if there are five. Or one, if there is one.
- **Earned use:** Three is genuinely right when there are three, and parallel
  structure is a real readability aid for genuinely parallel things — a
  three-step "How it works" is parallel *because the steps are sequential*.
  The test is whether the third item would survive being cut. If cutting it
  loses nothing but symmetry, symmetry was the only reason it existed.

---

### Benefit-Not-Feature Overcorrection

- **Formula:** Every line describes a transformed emotional state; no line
  describes an artifact, an action, or an interface. The reader finishes the
  page unable to say what the software *is*. This is what happens when the model
  over-applies "sell benefits, not features" — good advice that becomes vapor
  when it eats the whole page.
- **Specimens:**
  - "Reclaim your focus. Rediscover your best work. Feel in control again."
  - "Spend less time on busywork and more time on what matters."
  - "Confidence in every decision. Clarity at every step."
- **Repair:** Keep the benefit; attach the mechanism in the same breath. The
  strongest copy is a benefit and a feature welded together, not one or the
  other.
  - → "Stop context-switching: Slack, email, and tickets land in one inbox you
    clear once a day."
  - → "Two hours of manual reconciliation a week, gone — it matches bank lines
    to invoices automatically and flags the 3% it can't."
  - → "Every number links to the query that produced it, so you can check it
    before you present it."
- **Earned use:** Pure-benefit copy is correct in the **hero of a
  problem-aware audience** (Schwartz level 2), where the reader knows the pain
  but not that solutions exist — you have to name the pain before you can be
  heard. It's also correct in a testimonial, where a human is describing an
  experienced outcome. Rule of thumb: pure benefit is allowed above the fold
  and inside quotes. Everywhere else, benefit must arrive attached to mechanism.

---

### CTA Slop

- **Formula:** `Get started in minutes.` / `Ready to transform your
  {workflow|business}?` / `Join thousands of teams who have already {verb}.` /
  `Start your free trial — no credit card required.` The final-CTA section
  restates the hero's abstraction, adds a rhetorical question, and asks for the
  click without ever answering "what happens when I press this?"
- **Specimens:**
  - "Ready to transform your workflow? Get started in minutes."
  - "Join thousands of teams already working smarter."
  - "Start your journey today."
- **Repair:** The button says what the reader gets; the line above it removes the
  last remaining risk. Concrete beats enthusiastic.
  - → Button: "Create your first project" / above: "Free for 3 users. Import
    from Jira in one click."
  - → Button: "Run it on your repo" / above: "Takes about 90 seconds. Nothing
    is uploaded — it runs locally."
  - → Button: "See pricing" / above: "$12 per seat. No annual commitment, no
    sales call."
- **Earned use:** **"No credit card required" is real information and should
  usually stay** — it removes a specific, common, correctly-held objection.
  Same for "Cancel anytime", "Free for open source", "Takes 2 minutes",
  "No sales call". These are risk reversals, not slop. The slop is the
  *rhetorical question* and the *abstract transformation*, not the risk
  reversal. Keep the facts, cut the hype. And "Get started" as a nav button
  where a launch page already explained the product is a convention, not a
  crime; it becomes slop when it's the *only* CTA copy on a page that never
  said what starting means.

---

### Social-Proof Boilerplate

- **Formula:** Three moves, all fakeable: `Trusted by teams at {logo wall}`,
  the invented testimonial in generic executive voice, and the unsourced
  multiplier (`10x faster`, `50% more productive`). The tell is that the proof
  contains no checkable particulars — no name, no number with a denominator,
  no method.
- **Specimens:**
  - "Trusted by innovative teams worldwide."
  - "'This tool has completely transformed how our team works. We can't imagine
    going back.' — Sarah M., VP of Operations"
  - "Teams using Acme ship 10x faster."
- **Repair:** Real proof or no proof. An honest absence beats an invented
  presence — and inventing testimonials is a liability, not just a style issue.
  - → "Used by 3,400 teams, including Vercel, Ramp, and the Django project."
    (Only if true and only naming customers who consented.)
  - → "'We cut our monthly close from 9 days to 3.' — Dana Whitfield, Controller,
    Ridgeline Foods" (real person, real number, real company).
  - → "Median PR-to-deploy time across our 200 largest customers fell from
    4.2 days to 1.6 in the first quarter after adoption." Or, if you don't have
    that: cut the claim entirely and show a screenshot instead.
- **Earned use:** A logo wall is legitimate and effective when the logos are
  real and recognizable to *this* audience — it's the fastest credibility
  transfer available. Real testimonials with names and numbers are the highest
  performing content on most pages. Vague metrics are earned when the
  methodology is one click away. The rule for the command: **never rewrite a
  testimonial into better prose** — you'd be fabricating a quote. Flag weak
  testimonials for replacement; don't improve them.

---

### The Templated Problem/Agitate Paragraph

- **Formula:** `You know the feeling. {Generic frustration}. {Second generic
  frustration}. {Third}. It doesn't have to be this way.` The
  Problem-Agitate-Solve structure executed as a mad-lib, with the agitation
  aimed at a composite person who doesn't exist. Second-person plural
  ventriloquism: the copy tells the reader what they feel.
- **Specimens:**
  - "You know the feeling. Endless spreadsheets. Missed deadlines. A team that's
    always guessing. There's a better way."
  - "Every day, marketers struggle with disconnected tools, scattered data, and
    reports that take hours to build. Sound familiar?"
  - "If you're like most founders, you're drowning in busywork."
- **Repair:** One specific, checkable scene beats three generic ones. Describe a
  situation so particular that the wrong reader knows it isn't them.
  - → "Month-end close means exporting three CSVs, VLOOKUP-ing them together,
    and finding out on day six that someone changed a currency setting in
    March."
  - → "The Monday report takes 40 minutes: pull from Stripe, pull from the
    warehouse, paste into the deck, notice a number moved, start over."
- **Earned use:** Problem-first copy is correct — often mandatory — for
  problem-aware and unaware audiences, and articulating a reader's pain better
  than they can is the oldest working move in the craft. What's slop is the
  *composite* and the *triad rhythm*, not the problem section. Also legitimate:
  a single sharp rhetorical question ("Hate returning things to Amazon?") where
  the pain is universal and instantly recognized. One question, not a cascade.

---

### Stop Doing X. Start Doing Y.

- **Formula:** `Stop {abstract bad thing}. Start {abstract good thing}.`
  Imperative antithesis, usually two abstractions. Structurally identical to
  "smarter, not harder" but in command mood, so it also carries a faint scold.
- **Specimens:**
  - "Stop guessing. Start knowing."
  - "Stop managing tools. Start managing work."
  - "Stop chasing invoices. Start getting paid."
- **Repair:** Keep the shape only if both halves are concrete actions the reader
  literally performs. Otherwise recast as a single specific claim.
  - → "Stop chasing invoices. Start getting paid." — actually the strongest of
    the three, because both halves name real activities. Sharpen with a number:
    "Stop chasing invoices. Automatic reminders get 71% of ours paid before
    the due date."
  - → "Stop guessing. Start knowing." → "Every dashboard number links to the
    query behind it."
- **Earned use:** Legitimate when the product genuinely *replaces a named
  activity* with a different named activity, and both are things a person does
  with their hands. The test: can you film both halves? "Stop copying rows
  between spreadsheets. Start writing one formula." — filmable, earned.
  "Stop settling. Start thriving." — not filmable, slop.

---

### Superlatives With No Referent

- **Formula:** `the most {powerful|advanced|comprehensive}`, `the fastest`,
  `the only {category} that {claim}`, `industry-leading`, `best-in-class`,
  `enterprise-grade`, `world-class`. A rank claim with the comparison set
  deleted. "The only" is the most dangerous: it's a falsifiable claim usually
  made without checking.
- **Specimens:**
  - "The most powerful analytics platform on the market."
  - "Industry-leading security you can trust."
  - "The only tool your team will ever need."
- **Repair:** Either supply the comparison and the measurement, or descend to a
  verifiable descriptive claim.
  - → "Runs a 40-column groupby over 2B rows in 900ms. Benchmarks and dataset
    here."
  - → "SOC 2 Type II, HIPAA BAA available, and every key is customer-managed."
  - → "Covers issues, docs, and releases. It does not do CRM or support — use
    it alongside those."
- **Earned use:** Superlatives are fine when they're *measured and cited*, and
  when the category is narrow enough for the claim to be checkable. "The
  fastest open-source vector index at 1M vectors on a single node (see
  benchmark)" is a real claim. "Enterprise-grade" is nearly always slop —
  it means nothing specific and no buyer believes it — but "SOC 2 Type II"
  is the fact it's gesturing at, and that fact should replace it. "The only"
  is earned exactly when true and verifiable, and it's very strong when it is.

---

### The Em-Dash-Joined Tagline

- **Formula:** `{Adjective}, {adjective} — and {emotional adjective}.`
  Two or three list items, then an em dash, then a payoff word. The em dash is
  performing a rhythm the sentence hasn't earned; it signals "here comes the
  clever part" and then delivers an abstraction. Marketing's local version of
  the general em-dash tell — and the highest-frequency punctuation tell in
  AI-generated taglines.
- **Specimens:**
  - "Fast, simple — and finally yours."
  - "Powerful, flexible — built for you."
  - "Your data, your rules — no compromises."
- **Repair:** Either the payoff is a real fact (keep a dash or, better, a period),
  or the whole construction goes.
  - → "Fast, simple, and self-hosted. Your data never leaves your VPC."
  - → "Your data stays in your VPC. We can't read it; the keys are yours."
  - → Or just: "Self-hosted. Apache 2.0."
- **Earned use:** An em dash earns its place when it introduces genuine
  *contrast or interruption* the sentence needs — the payoff must be
  information, not applause. "Free for open source — including private forks"
  is an em dash doing work. Note also: for taglines, a period usually beats a
  dash, because the tagline's job is to land, and a dash keeps the sentence
  open. If the target project has a blanket no-em-dash rule (as the current
  `/deslopify` does), the recast here is nearly always a period or a full stop
  plus a second sentence, not a semicolon — semicolons in taglines read as a
  different kind of wrong.

---

### Section Headers That Are Questions Nobody Asked

- **Formula:** `Why {Product}?` / `What makes us different?` / `Ready to get
  started?` / `Sound familiar?` A header that stages a dialogue with an
  imaginary visitor, then answers a question that visitor never posed. Cheap
  because the model doesn't have to commit to a claim — it can hide behind
  the interrogative.
- **Specimens:**
  - "Why choose Acme?"
  - "What makes us different?"
  - "Is this right for you?"
- **Repair:** Convert to the answer. The header slot should carry the claim; a
  reader skimming headers should get the argument.
  - → "Why choose Acme?" → "We're the only one that runs on your hardware."
  - → "What makes us different?" → "No per-seat pricing. Charge is per
    workspace, and it's $99 flat."
  - → "Is this right for you?" → "Good fit for teams of 5–50. Bad fit if you
    need offline access."
- **Earned use:** A question header works when it's a question the reader is
  *demonstrably* already asking — pricing-page objection headers ("What counts
  as an active user?"), and comparison-page headers ("How is this different
  from Postgres full-text search?") are genuinely reader-voice. The distinction
  is whether the question came from the reader's head or the writer's. A good
  proxy: would this question appear verbatim in a support ticket?

---

### The Preemptive FAQ

- **Formula:** A FAQ block answering four to eight questions the model
  generated by asking itself what a skeptic might say. Symptoms: questions
  phrased in marketing voice rather than customer voice ("How can Acme help my
  team be more productive?"), answers that restate the value prop, and
  objections nobody holds ("Is it really that easy?").
- **Specimens:**
  - "Q: Is Acme right for my team? A: Acme is designed for teams of all sizes
    and adapts to any workflow."
  - "Q: How quickly can I get started? A: Most teams are up and running in
    minutes!"
  - "Q: Do I need technical skills? A: Not at all — Acme is built for everyone."
- **Repair:** FAQs must come from real sources — support tickets, sales calls,
  churn interviews, the competitor comparison the buyer is actually running.
  Answers should be willing to say no.
  - → "Q: Can I self-host? A: Yes, on the Business plan. Docker Compose file
    here; you'll need Postgres 14+ and about 4GB of RAM."
  - → "Q: Does it work offline? A: No. It needs a connection for sync. If
    offline matters, Obsidian is a better fit."
  - → "Q: What happens to my data if I cancel? A: You get a full JSON+CSV
    export for 30 days, then we delete it. No hostage-taking."
- **Earned use:** FAQ is one of the strongest sections on a page when it's
  honest — it's where you handle objections, disqualify bad-fit buyers, and
  demonstrate confidence by admitting limits. **An FAQ that never says "no" is
  a fake FAQ.** That's the single best filter: if no answer contains a
  limitation, an exclusion, or a competitor recommendation, the section was
  generated, not gathered.

---

### Feature Names Capitalized Into Proper Nouns

- **Formula:** Ordinary functionality dressed as a branded product:
  `Smart Sync™`, `Insights Engine`, `our proprietary Workflow Intelligence
  layer`. Capitalization used to imply the existence of a technology. Related:
  wrapping a normal feature in a coined noun phrase so it can't be evaluated.
- **Specimens:**
  - "Powered by our Adaptive Intelligence Engine."
  - "With Smart Capture, nothing falls through the cracks."
  - "Our proprietary Workflow Graph keeps everything in sync."
- **Repair:** Lowercase it and say what it does; if the plain description is
  unimpressive, that's information about the feature, not about the writing.
  - → "It reads your calendar and pre-fills the meeting notes."
  - → "Anything you email to notes@ shows up in your inbox as a task."
  - → "One dependency graph across repos, so renaming a field flags the six
    services that read it."
- **Earned use:** Capitalizing is right when the thing is a **real named
  primitive users will type, click, or discuss** — a UI surface, a CLI command,
  an API object, a plan tier. Stripe's "Payment Intents" is a proper noun
  because it's a real object in the API. Users need a shared name for it.
  The test: will a customer ever say this name out loud to another customer?
  If yes, capitalize. If the name exists only in marketing, delete it.

---

### The "We Believe" Manifesto

- **Formula:** A paragraph of values in the first-person plural, usually
  positioned before or instead of the product explanation. `We believe {work}
  should be {adjective}. We believe {tools} should {serve} people, not the
  other way around.` Costless conviction: every belief is one nobody contests.
- **Specimens:**
  - "We believe software should get out of your way."
  - "We believe every team deserves tools that work as hard as they do."
  - "We started Acme because we believe work should be more human."
- **Repair:** A belief is only interesting if someone credible disagrees with
  it, and if the product visibly pays a price for it. Convert conviction into
  evidence of the tradeoff.
  - → "We don't have a mobile app and we're not building one. This is a tool
    for people at desks with keyboards."
  - → "We charge per workspace, not per seat, which costs us money on large
    accounts. We think seat-counting makes teams hide collaborators."
  - → "No AI features. We tried; the suggestions were wrong often enough that
    people stopped trusting the correct ones."
- **Earned use:** Manifestos work — Basecamp's and 37signals' entire market
  position is built on them — when the belief is **contrarian and costly**.
  The rule: a stated belief must be one a competitor could plausibly reject,
  and the page must show what it cost to hold it. If the belief is free, cut it.
  Also legitimate on an actual About page, where the reader has opted in to
  hearing about the company. On a product page, before the product is explained,
  it's throat-clearing.

---

### Precision Theater Numbers

- **Formula:** A decimal or an oddly specific integer used as a credibility
  prop: `save 4.7 hours a week`, `reduce costs by 37%`, `3.2x faster`. The
  decimal signals that a measurement occurred. No measurement occurred. AI
  copy reaches for these because "specificity converts" is in every copywriting
  guide, and a fake decimal is the cheapest imitation of specificity.
- **Specimens:**
  - "Teams save an average of 4.7 hours per week."
  - "Reduce operational overhead by up to 37%."
  - "Onboard new hires 3.2x faster."
- **Repair:** Number with a source and a denominator, or no number. When a real
  number is unavailable, a concrete *scene* substitutes better than a fake
  figure — it conveys scale without asserting a measurement.
  - → "In our 2025 survey of 412 customers, the median team reported cutting
    weekly reporting from 5 hours to under 1. (Method and raw data.)"
  - → "The Monday report used to take an afternoon. Now it's a link."
  - → Or drop it: a screenshot of the actual output persuades more than an
    invented percentage.
- **Earned use:** Real numbers, especially odd ones, are among the most powerful
  elements available — Ogilvy's Rolls-Royce headline is a fact with a
  measurement in it. "9 years average tenure on our support team" (Basecamp)
  and "84 million accounts" work precisely because they're checkable and
  unflattering-to-round. The rule for the command: **never invent, adjust, or
  round a number**, and never "improve" a vague claim into a specific one by
  supplying a figure. Flag missing evidence; don't manufacture it. This is the
  one category where the editor's error mode is fabrication rather than
  blandness, so it needs an explicit prohibition.

---

### The "Whether You're..." Universal Audience Clause

- **Formula:** `Whether you're {A}, {B}, or {C}, {Product} {vague benefit}.`
  Enumerates every possible customer so as to exclude none, which is the exact
  opposite of positioning. Frequently paired with "from X to Y" ("from startups
  to Fortune 500s").
- **Specimens:**
  - "Whether you're a solo founder, a growing startup, or an enterprise team,
    Acme scales with you."
  - "From freelancers to Fortune 500s, teams trust Acme."
  - "Perfect for developers, designers, and everyone in between."
- **Repair:** Pick one. Specificity in audience is the cheapest credibility on
  a page, and exclusion is the mechanism.
  - → "For engineering teams of 10 to 200 who deploy more than once a day."
  - → "Built for freelance designers who bill hourly. If you have a finance
    department, this isn't for you."
- **Earned use:** Legitimate when the enumeration marks a *genuinely surprising*
  span the product really covers, and the page shows it ("The same YAML file
  runs on a laptop and on 400 nodes"). Also fine on a pricing page where the
  tiers really do serve those segments and each is named with its own row.
  The failure is enumeration as a hedge against choosing.

---

### "In Today's Fast-Paced..." (the establishing-shot opener)

- **Formula:** `In today's {fast-paced|ever-evolving|increasingly digital}
  {landscape|world|business environment}, {truism}.` An opening sentence that
  situates the reader in a generic present before saying anything. The
  marketing cousin of the general-prose throat-clear.
- **Specimens:**
  - "In today's fast-paced business environment, staying organized is more
    important than ever."
  - "As remote work continues to reshape how teams collaborate..."
  - "The modern workplace is changing faster than ever before."
- **Repair:** Delete the sentence. Start at the second sentence; it is almost
  always the real opening. If the trend genuinely matters, cite it.
  - → "Staying organized is more important than ever." → cut, then open with
    the specific: "Your team's decisions are in four Slack threads, and the one
    that mattered is in a DM."
- **Earned use:** Almost never in marketing copy. The narrow exception: a
  genuinely dated claim in an analyst-style report or a post whose subject *is*
  the trend, where the sentence carries a citation and a date. Even then, lead
  with the finding, not the weather.

---

### The Staccato Adjective Tricolon

- **Formula:** `{Adjective}. {Adjective}. {Adjective}.` Three abstract
  adjectives as complete sentences, usually under the hero or as a divider.
  Reads as design, not copy — visual rhythm standing in for content. Distinct
  from the feature triad: no bodies, just words.
- **Specimens:**
  - "Fast. Secure. Scalable."
  - "Simple. Powerful. Yours."
  - "Built different. Built better. Built for you."
- **Repair:** Replace each adjective with a noun phrase carrying a fact, or
  collapse to one line that says something.
  - → "40ms p99. SOC 2. Runs on one box or forty."
  - → "Self-hosted. Apache 2.0. No telemetry."
- **Earned use:** The rhythm is legitimate when each item is a *concrete
  differentiated fact* rather than an adjective — the form survives; the vocabulary
  is what fails. Also legitimate as a genuine spec strip near a pricing table.
  Test: if each word could be swapped between competitors without anyone
  noticing, the tricolon is decoration.

---

### The Effortless-Adverb Layer (diagnose, don't blacklist)

- **Formula:** `seamlessly`, `effortlessly`, `intuitively`, `automatically`
  (when unproven), `simply`, `easily`, `instantly` — adverbs asserting that
  something is easy instead of demonstrating it. **Important:** this entry is
  deliberately *not* a word blacklist. Deleting "seamlessly" and keeping the
  sentence leaves the tic intact; the adverb is the symptom, and the missing
  mechanism is the disease.
- **Specimens:**
  - "Seamlessly integrate with the tools you already use."
  - "Effortlessly manage your entire pipeline."
  - "Intuitive interface that anyone can master in minutes."
- **Repair:** Delete the adverb, then check whether the remaining verb phrase
  still claims anything. If it doesn't, the sentence needed a fact, not an edit.
  - → "Seamlessly integrate with the tools you already use." → delete adverb →
    "Integrate with the tools you already use." → still empty → "Two-way sync
    with Jira, Linear, and GitHub Issues. Conflicts surface as a diff you
    resolve, not a silent overwrite."
  - → "Intuitive interface anyone can master in minutes." → "Four screens. No
    settings page."
- **Earned use:** "Automatically" is real information when it names a thing the
  user would otherwise do by hand ("Renewals bill automatically" — true,
  checkable, load-relieving). "Instantly" is fine attached to a measured
  latency. The adverbs fail when they modify an abstraction; they work when
  they modify a specific named action the reader was dreading.

---

## What good landing-page copy actually does

The catalog above is all prohibition. Prohibition alone produces
over-corrected, choppy, informationless copy — the well-documented failure mode
of every anti-slop prompt (see Section 2). The command needs a positive target.
These are the rules the canon converges on.

### Ogilvy — facts over adjectives

The Rolls-Royce headline ("At 60 miles an hour the loudest noise in this new
Rolls-Royce comes from the electric clock", 1958) is the canonical demonstration:
all facts, all specifics, no adjectives. Ogilvy's operative rules:

- **Give the reader facts.** The more facts, the more selling. Adjectives are
  what you write when you don't have facts.
- **Headlines can be long.** Six to twelve words is fine if the promise is in
  them. Brevity is not the value; specificity is.
- **Never write a headline your competitor could also run.** (This is the swap
  test, restated.)
- Corollary for the command: when repairing a headline, the direction of travel
  is *toward the concrete noun*, not toward a punchier abstraction.

### Eugene Schwartz — awareness levels, and "you cannot create desire"

*Breakthrough Advertising* (1966): the copywriter cannot manufacture desire, only
channel existing desire onto a product. The five awareness levels dictate what a
headline is allowed to do:

| Level | Reader state | What the hero must do |
|---|---|---|
| Unaware | Doesn't know they have a problem | Lead with the situation/story |
| Problem-aware | Feels the pain, doesn't know solutions exist | Name the pain precisely |
| Solution-aware | Knows solutions exist, hasn't picked | Differentiate the mechanism |
| Product-aware | Knows you, hasn't committed | Proof, objections, risk reversal |
| Most-aware | Ready | The offer and the button |

**This is the most useful single import for the command.** Most AI marketing
slop is *awareness-level mismatch*: pure-benefit emotional copy (level 1–2
register) served to a solution-aware reader who wants to know what it does, or
feature specs served to someone who doesn't know the category exists. Before
repairing a page, the editor should ask who's arriving and from where. It also
supplies the Earned-use logic for several patterns: pure benefit is right at
level 2 and wrong at level 3.

### Joanna Wiebe / Copyhackers — specificity, message match, one goal

- **Message match**: the top ~10% of the page must match the ad that sent the
  visitor *and* their awareness stage. A hero that doesn't echo the promise
  that earned the click is a leak, however well-written.
- **Specificity as a practice, not a preference**: "Am I being specific or am I
  being vague? Can I be more specific? Can I get deeper into my prospect's head
  than this?" — three questions run on every line.
- **Clarity is the strongest conversion lever.** Never trade clarity for
  cleverness.
- **The and/but/or/comma sweep**: challenge every "and", "but", "or", and every
  comma — especially list commas. Each is usually a sentence trying to carry two
  ideas, or a triad that's padding. This is a mechanically applicable rule and
  transfers directly into the command as an editing pass.
- **Single conversion goal per page**; competing CTAs cannibalize.
- **Voice of customer**: the best copy is lifted, not written — from reviews,
  support tickets, sales-call transcripts. Copy that sounds like a customer
  cannot sound like an AI, because the source is real speech. *This is the
  strongest positive instruction available to a deslop command:* when a line
  is empty, the fix is to go find what a customer said, not to write a better
  abstraction.

### Basecamp / 37signals — plain speech, real numbers, costly beliefs

Live specimens from basecamp.com:

- "The refreshingly straightforward project management system that's rock-solid
  and easy to use."
- "Tell me if this sounds about right." / "You're juggling people, projects,
  and expectations."
- "Remember when companies cared about service? We still do."
- "On average, each member of our customer service team has been with us 9
  years."
- "Over 84 million people have Basecamp accounts."
- "Service isn't an afterthought, it's one of Basecamp's best features."

What's operative: second person, contractions, sentence fragments where speech
would use them, a real unrounded number doing the proof work, and an explicit
contrarian position with a cost attached. Note that Basecamp's "Tell me if this
sounds about right" is a problem/agitate opener — it's the *earned* version,
because the paragraph beneath it is specific and it's written in one person's
voice, not a composite's. 37signals' own founding value: **copywriting is
interface design** — "every letter matters", and anti-jargon is a stated
company value alongside usability, simplicity, and speed.

### Linear — and the caution that exemplars are not clean

Live specimens from linear.app:

- Hero: "The product development system for teams and agents"
- Feature headers: "Make product operations self-driving" / "Define the product
  direction" / "Move work forward across teams and agents" / "Review PRs and
  agent output" / "Understand progress at scale"

Note the split. The **feature headers are strong** — verb-first, concrete, each
naming a distinct job; a reader skimming only the headers learns what the
product does. But the same page carries "A new species of product tool." and
"Purpose-built for modern teams with AI workflows at its core, Linear sets a new
standard for planning and building products" — which is textbook value-prop
abstraction and fails the swap test outright.

**Two lessons for the command.** First, don't hold up whole sites as exemplars;
hold up *lines*. Second, a page can be well-designed and still slopped in its
connective tissue — which is exactly the material a deslop pass should target,
while leaving the load-bearing specific lines alone.

### Stripe / docs-landing voice

Stripe's docs are the standard reference for technical landing text: reader-
oriented rather than brand-oriented, minimal technicality-signaling, and
consistent enough that other companies' style guides (e.g. Mattermost's) cite it
as their model. The transferable rules for README intros and docs landing text:

- Lead with what the thing does in one sentence a stranger can parse.
- Name real API objects as proper nouns; name nothing else as a proper noun.
- Show a code sample or a screenshot before making a claim about ease.
- No adjectives about the developer experience; the sample either reads well or
  it doesn't.

### The synthesized positive target

If the command needs one paragraph of "write like this", it's this:

> Say what the thing is in the first sentence, in words a stranger could repeat
> back. Attach every benefit to the mechanism that produces it. Prefer a
> checkable fact to any adjective, and an unrounded real number to a rounded
> one. Name who it's for narrowly enough that some readers leave. Say what it
> doesn't do. Use the customer's own words where you have them. Vary sentence
> length the way speech does. And when you don't have the fact, leave the gap
> visible — don't fill it with a formula.

---

## Notes on applying this in a command

- **Fabrication is the dominant risk.** Almost every repair above is "replace
  vagueness with a fact." An editor that doesn't have the fact will invent one,
  and invented testimonials and invented metrics are worse than the slop they
  replace — legally as well as stylistically. The command needs an explicit
  rule: *flag-and-ask when the repair requires a fact you don't have; never
  invent numbers, quotes, customer names, or capabilities.* Consider making
  the output format support an inline `[NEEDS FACT: ...]` marker.
- **Testimonials and quotes are read-only.** Never rewrite text inside quotation
  marks attributed to a person.
- **The unit of repair is often the section, not the sentence.** Feature triads,
  restating subheads, and fake FAQs can't be fixed line-by-line. The command
  should be allowed to propose cutting or merging blocks.
- **Earned-use is not decoration.** Without it, the command strips "no credit
  card required," breaks real logo walls, and deletes the honest three-step
  "How it works." Every pattern needs a stop condition.

