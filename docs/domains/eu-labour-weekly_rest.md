# Whether one worker's rota, over one stated period, gives the weekly rest that Art 5 of Directive 2003/88/EC requires a Member State to ensure: the period is cut into ...

`eu/labour/weekly_rest`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 219/219 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether one worker's rota, over one stated period, gives the weekly rest that Art 5 of Directive 2003/88/EC requires a Member State to ensure: the period is cut into blocks of 7 days (14 days under a reference period of Art 16(a)) from 00:00 on its first day; every minute that is not working time is rest (Art 2(1), Art 2(2)); a block holds the weekly rest when it holds one unbroken run of at least 2100 minutes (24 hours plus the 11 hours of daily rest), or 1440 minutes under the reduced minimum of Art 5 second subparagraph, two such rests in a 14-day block, measured in exact minutes. Decided here: the status (weekly_rest_status/7), the smallest block rest in minutes (shortest_weekly_rest_minutes/6), the first day of the first block without the weekly rest (first_period_without_weekly_rest/6), and the threshold boundary (weekly_rest_threshold/2); Art 5 not applied to mobile workers (Art 20(1) with Art 2(7)) and seagoing fishing vessel workers (Art 21(1)); a derogation stated under Art 17(1), 17(3), 17(4) or Art 18. Handed to the caller or a lawyer: whether on-call time is working time under national laws and/or practice (open-textured, Art 2(1)); whether the reduced minimum, a ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32003L0088 | as pinned | 2026-11-12 | `40ac5e178a8f1ac0...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `2598d77627093329...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `57c197fecc812a29...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `e1afab5a4fbaf2ea...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `7d3f2d066c8f8749...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `db9c67936759714b...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `19bbe261365db475...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `c0e93c7625f50289...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `28a058b6490992ed...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `5117cc10892dcb7d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/labour/weekly_rest){ .md-button }

## Provisions deferred, and what follows

??? info "scope_of_the_directive"

    **Why:** Art 1 states the purpose and scope (all sectors within the meaning of Directive 89/391/EEC; not seafarers) and Art 14 leaves room for more specific Community rules for certain occupations. The order does not decide whether a worker is within the Directive; it assumes so (reading (12), Q19).

    **Consequence for a user:** A caller whose worker is outside Art 1 (a seafarer, for example) or under a more specific rule of Art 14 must not rely on the answers.

??? info "conditions_of_the_derogations"

    **Why:** The points of Art 17(1), 17(3) and 17(4) list the activities and cases a derogation may cover; Art 17(2) and the third subparagraph of Art 18 require equivalent compensatory rest or appropriate protection; the fourth subparagraph of Art 18 lets the Member States lay down rules for applying it. Whether a derogation exists and meets them is a matter of national law and of the agreements; the caller states the derogation (reading (10), Q14).

    **Consequence for a user:** weekly_rest_derogation_applies never says that the conditions were met or that compensatory rest was given.

??? info "adequate_rest_of_mobile_and_fishing_vessel_workers"

    **Why:** The second subparagraphs of Art 20(1) and Art 21(1) and Art 21(2) to (7) ask the Member States to ensure adequate rest, and limits on hours of work or rest, for mobile workers and workers on board seagoing fishing vessels, by national measures. This order only says that Art 5 does not apply to them (reading (9), Q13).

    **Consequence for a user:** weekly_rest_not_applied_to_worker never says that the worker had adequate rest or that the limits of Art 21 were kept.

