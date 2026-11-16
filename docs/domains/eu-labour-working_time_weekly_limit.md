# What Art 6(b) of Directive 2003/88/EC, read with Art 2(1) (working time), Art 16(b) and the sentence printed after it (a reference period of at most four months; paid ...

`eu/labour/working_time_weekly_limit`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 273/273 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

What Art 6(b) of Directive 2003/88/EC, read with Art 2(1) (working time), Art 16(b) and the sentence printed after it (a reference period of at most four months; paid annual leave and sick leave neutral), Art 19 first and second subparagraphs and Art 20(2) (longer reference periods) and Art 22(1) and Art 22(1)(a) (the option not to apply Art 6), requires a Member State to ensure, measured on one worker's shifts over one reference period given by the caller. Decided here are whether the reference period is within the ceiling of the basis the caller states, whether the counted working time is within the 48-hour average (2880 minutes per seven-day period, exact, no rounding), over it, not limited because of the Art 22(1) option with the worker's prior agreement, or not measurable; the exact average itself; the whole minutes of counted working time that would have to be removed; and the threshold of counted minutes at which the outcome flips. Out of scope and handed to the caller or a lawyer are whether on-call time is working time under national laws and/or practice (an unsure judgement that decides goes to needs_legal_review), the conditions of Art 17(3), Art 18, Art 19 second ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32003L0088 | as pinned | 2026-11-12 | `40ac5e178a8f1ac0...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `2598d77627093329...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `37065d249c600a7c...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `db9c67936759714b...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `19bbe261365db475...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `c0e93c7625f50289...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `bafc6d69532bdd28...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `28a058b6490992ed...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `c3c6633c41086064...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/labour/working_time_weekly_limit){ .md-button }

## Provisions deferred, and what follows

??? info "scope_of_the_directive"

    **Why:** Art 1 states the purpose and scope (all sectors within the meaning of Directive 89/391/EEC; not seafarers). The order does not decide whether a worker is within the Directive; it assumes so (reading (10), Q13).

    **Consequence for a user:** A caller whose worker is outside Art 1 (a seafarer, for example) must not rely on the answers.

??? info "derogations_of_article_17"

    **Why:** Art 17 lets the Member States derogate, by laws, regulations, administrative provisions or agreements, from Arts 3 to 6, 8 and 16. Whether a derogation exists for a worker is a matter of national law. Art 17(3) enters only as the basis of the reference period (reading (3)); Art 17(1) and Art 17(5), which can lift the limit of Art 6 itself, are assumed not to apply (reading (10), Q13).

    **Consequence for a user:** A caller whose worker falls under a derogation from Art 6 under Art 17(1) or Art 17(5) must not rely on the answers; a derogated reference period is given through reference_period_basis.

??? info "derogations_by_collective_agreement_of_article_18"

    **Why:** Art 18 lets collective agreements or agreements between the two sides of industry derogate from Arts 3, 4, 5, 8 and 16, on conditions. Whether such an agreement exists is a matter of national law and of the agreements; it enters only as the basis of the reference period (reading (3)).

    **Consequence for a user:** A derogated reference period is given through reference_period_basis; its conditions are not checked (Q8).

??? info "member_state_measures_for_the_article_22_option"

    **Why:** Art 22(1)(b) to (e) list the measures a Member State must take when it uses the option (no detriment, records, records for the authorities, information to the authorities). They bind the Member State and, through national law, the employer; the order takes member_state_uses_article_22_option as given and does not check the measures (reading (8), Q7).

    **Consequence for a user:** weekly_limit_not_applied_by_agreement never says that the measures were taken or that the employer keeps the records.

