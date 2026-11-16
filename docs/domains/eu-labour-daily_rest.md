# Whether one worker's rota, over one period of whole days, gives the daily rest that Article 3 of Directive 2003/88/EC requires the Member States to ensure: at least 11 ...

`eu/labour/daily_rest`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 227/227 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether one worker's rota, over one period of whole days, gives the daily rest that Article 3 of Directive 2003/88/EC requires the Member States to ensure: at least 11 consecutive hours (660 minutes) of rest in every 24-hour period that begins when the worker starts counted work inside the period, or at the start of the period when the worker is at work then; working time and rest told apart by Article 2(1) and 2(2), with the caller judging whether on-call time on site or on standby is working time. Decided here: the status (given, not given, Article 3 not applied to a mobile worker under Article 20(1) with 2(7) or to a seagoing fishing vessel worker under Article 21(1), or a caller-stated derogation under Article 17(1), 17(3), 17(4) or Article 18); the shortest longest unbroken rest in minutes; the start of the first window without the daily rest. Out of scope: whether the worker is within Article 1 or under Article 14; the conditions of any derogation and its compensatory rest; the adequate rest of mobile and fishing vessel workers; weekly rest, breaks and night work; national rules on daily rest; amendments after the original act. Unsure on-call judgements go to a lawyer.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32003L0088 | as pinned | 2026-11-12 | `40ac5e178a8f1ac0...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `2598d77627093329...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `57c197fecc812a29...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `cf998a76e82699ec...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `e1afab5a4fbaf2ea...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `7d3f2d066c8f8749...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `19bbe261365db475...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `c0e93c7625f50289...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `28a058b6490992ed...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `5117cc10892dcb7d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/labour/daily_rest){ .md-button }

## Provisions deferred, and what follows

??? info "scope_of_the_directive"

    **Why:** Art 1 states the purpose and scope (all sectors within the meaning of Directive 89/391/EEC; not seafarers) and Art 14 leaves room for more specific Community rules for certain occupations. The order does not decide whether a worker is within the Directive; it assumes so (reading (10), Q15).

    **Consequence for a user:** A caller whose worker is outside Art 1 (a seafarer, for example) or under a more specific rule of Art 14 must not rely on the answers.

??? info "conditions_of_the_derogations"

    **Why:** The points of Art 17(1), 17(3) and 17(4) list the activities and cases a derogation may cover; Art 17(2) and the third subparagraph of Art 18 require equivalent compensatory rest or appropriate protection; the fourth subparagraph of Art 18 lets the Member States lay down rules for applying it. Whether a derogation exists and meets them is a matter of national law and of the agreements; the caller states the derogation (reading (8), Q10).

    **Consequence for a user:** daily_rest_derogation_applies never says that the conditions were met or that compensatory rest was given.

??? info "adequate_rest_of_mobile_and_fishing_vessel_workers"

    **Why:** The second subparagraphs of Art 20(1) and Art 21(1) and Art 21(2) to (7) ask the Member States to ensure adequate rest, and limits on hours of work or rest, for mobile workers and workers on board seagoing fishing vessels, by national measures. This order only says that Art 3 does not apply to them (reading (7), Q9).

    **Consequence for a user:** daily_rest_not_applied_to_worker never says that the worker had adequate rest or that the limits of Art 21 were kept.

