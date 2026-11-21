# Regulation (EU) 2024/2847 (Cyber Resilience Act), duties of manufacturers, three bounded questions at an ASSESSMENT_DATE: requirements_applicability, which requirements ...

`eu/cra_manufacturer_duties`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 188/188 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2024/2847 (Cyber Resilience Act), duties of manufacturers, three bounded questions at an ASSESSMENT_DATE: requirements_applicability, which requirements bind a product at that date (Art 69(2) and (3) with Art 71(2): not_yet_applicable before 11 September 2026, article_14_only from 11 September 2026 to 10 December 2027, and from 11 December 2027 subject_to_requirements for a product placed on the market on or after that date or placed earlier and substantially modified on or after it, otherwise article_14_only; an unsure modification judgement goes to a lawyer); support_period_minimum, the five-year (60-month) floor of the support period or the shorter expected use time (Art 13(8), third subparagraph); and retention_end_date, the date until which the technical documentation and EU declaration of conformity (Art 13(13)), the information and instructions to the user (Art 13(18)) or a security update (Art 13(9)) must stay available, the later of ten calendar years after the start date and the support period end date. Out of scope: whether the product is within the scope of the Regulation (the order for product scope), the deadlines of Article 14 (the order for ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32024R2847 | as pinned | 2026-11-14 | `f8b2836b0b1ae35a...` |
| CELEX 32024R2847 | as pinned | 2026-11-17 | `bb2adf67c0dd971f...` |
| CELEX 32024R2847 | as pinned | 2026-11-16 | `ff1792dc2c7fb0dc...` |
| CELEX 32024R2847 | as pinned | 2026-11-14 | `30840275fab12de3...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/cra_manufacturer_duties){ .md-button }

## Provisions deferred, and what follows

??? info "support_period_determination"

    **Why:** Art 13(8) is read for its third subparagraph only (at least five years; the expected use time where it is less). Its other subparagraphs (the first, handling vulnerabilities for the support period; the second, determining the support period to reflect the expected use time, with the matters to be taken into account; the fourth, the delegated acts on category minimums; the fifth, the documentation of the determination; the sixth, the vulnerability policies) set duties and a manufacturer's determination with no computation this order makes (reading (5)).

    **Consequence for a user:** The answer gives the floor only: the caller checks that the support period reflects the expected use time and the other matters of Art 13(8), and whether a delegated act sets a higher minimum for the product's category (open questions (Q6), (Q7)).

??? info "information_and_instructions_content_and_form"

    **Why:** Art 13(18) is read for its last two sentences only (kept at the disposal of users and authorities, and online where provided online, for at least 10 years or the support period, whichever is longer). Its first sentences (accompany the product with the Annex II information, in a language easily understood, clear and legible) set the content and form of the information, with no date (reading (7)).

    **Consequence for a user:** The answer gives the end of the period of availability only; the caller checks the content, language and form of the information (Annex II, not pinned).

??? info "support_period_end_date_statement"

    **Why:** Art 13(19) requires the end date of the support period (at least month and year) to be specified at the time of purchase and, where feasible, an end-of-support notification. It is quoted for reading (6): the end date is the caller's input, and the duty to state it has no computation.

    **Consequence for a user:** The order does not check that the end date was stated; it takes the date given (open question (Q8)).

??? info "definitions_read_as_the_callers_input"

    **Why:** Art 3(20) (support period), 3(21) (placing on the market) and 3(30) (substantial modification) are quoted for readings (2), (5) and (6): the placing date and the support period end date are the caller's dates, and substantial modification is the caller's judgement substantially_modified_on_or_after_application_date; the order does not test the definitions.

    **Consequence for a user:** The caller applies these definitions when it gives the dates and the judgement.

