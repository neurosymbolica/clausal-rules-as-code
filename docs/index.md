---
hide:
  - navigation
---

# EU law as executable, tested, traceable logic

<p class="hero">This repository holds EU legal provisions written as small logic programs that
answer one legal question each: <em>is this person a beneficial owner?</em>, <em>what is the
minimum time limit for receipt of tenders?</em>, <em>does this aid stay under the de minimis
ceiling?</em> Every rule names the provision it implements, every quotation is checked against
the official text, and every domain says what it deliberately does not cover. The rules are
written in Clausal Prolog, a cut-free subset of the ISO Prolog standard: each rule can be read and
checked on its own, and the programs are meant to run on any standard Prolog engine, not only
ours.</p>

<div class="facts" markdown>
<div><strong>8</strong><span>EU domains in this release</span></div>
<div><strong>1,187</strong><span>tests, all passing</span></div>
<div><strong>121</strong><span>statute units tracked, 0 left unaccounted</span></div>
<div><strong>EUPL-1.2</strong><span>open source, the EU's own licence</span></div>
</div>

## What this is, and what it is not

It is a **working, checked starting point**: a set of formalizations built to a stated method,
with the evidence for each claim inside the repository, so that anyone can re-run the checks.

It is **not a finished product and not legal advice**. The interpretive choices are recorded so
that lawyers can review them, the provisions not formalized are listed with the consequence of
leaving them out, and the scope of each domain is narrow on purpose. See
[Lawyers in the loop](lawyers.md) and [Status of each domain](status.md).

## A rule, its provision, and its test

The minimum time limit in an open procedure, from Directive 2014/24/EU Article 27:

```python
# Art 27(1) subpara 2: base minimum 35 days from contract-notice dispatch.
minimum_time_limit_days(open_procedure, receipt_of_tenders,
    baseline_minimum, 35, cite(eu_dir_2014_24_art_27)) <- (
    implements(eu_dir_2014_24_art_27)
),
# Art 27(2): prior information notice published 35 days - 12 months before
# the contract notice -> minimum may be shortened to 15 days.
minimum_time_limit_days(open_procedure, receipt_of_tenders,
    with_prior_information_notice, 15, cite(eu_dir_2014_24_art_27)) <- (
    implements(eu_dir_2014_24_art_27)
),
```

The citation `eu_dir_2014_24_art_27` is a record holding the exact words of the Directive,
checked character for character against a pinned copy of the consolidated text from EUR-Lex:

```python
citation(eu_dir_2014_24_art_27, {
  label:    "Directive 2014/24/EU, Article 27 (Open procedure)",
  ref:      "http://publications.europa.eu/resource/celex/02014L0024-20260101.ENG.fmx4",
  verbatim: "The minimum time limit for the receipt of tenders shall be 35 days from the date on which the contract notice was sent."
}),
```

Each answer the domain gives carries the citations that produced it, so a reader can go from any
result back to the sentence of law it rests on.

## Where to start

<div class="grid cards" markdown>

-   :material-gavel: **[For lawyers and policy makers](questions.md)**

    The questions we expect: liability, versions of the law, discretion, languages, the AI Act.

-   :material-check-decagram: **[How it is checked](validation.md)**

    Ten kinds of check, from unit tests to hidden mutation testing.

-   :material-file-compare: **[From statute to rule](traceability.md)**

    Pinned sources, verified quotations, and a side-by-side report per domain.

-   :material-account-tie: **[Lawyers in the loop](lawyers.md)**

    Where human legal judgement sits, and how it is recorded.

</div>
