# Whether one worker's rota, over one period from PERIOD_START to PERIOD_END (both days included), keeps the two limits on the length of night work that Article 8 of ...

`eu/labour/night_work`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 249/249 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether one worker's rota, over one period from PERIOD_START to PERIOD_END (both days included), keeps the two limits on the length of night work that Article 8 of Directive 2003/88/EC requires the Member States to ensure: Art 8(a), normal hours of work of night workers not exceeding an average of eight hours in any 24-hour period, averaged over consecutive reference blocks of the Art 16(c) reference period with one 24-hour period left out of the divisor for each whole seven days (Art 16, last sentence); and Art 8(b), night workers whose work involves special hazards or heavy physical or mental strain not working more than eight hours in any period of 24 hours during which they perform night work. Working time is read under Art 2(1) (on-call time by the caller's judgement), night time under Art 2(3) (the caller's national night time), and the outcomes apply Art 20(1) with Art 2(7) (mobile workers), Art 21(1) (seagoing fishing vessels) and the derogations of Art 17(1), Art 17(3) and Art 18 as stated by the caller. It is a check of a rota against the Directive, not a finding against an employer. Out of scope, handed to a lawyer or a sibling order: whether the worker is within Art 1 ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32003L0088 | as pinned | 2026-11-12 | `40ac5e178a8f1ac0...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `2598d77627093329...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `57c197fecc812a29...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `43b7dcd5d7599461...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `2eae95124f5c4753...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `7d3f2d066c8f8749...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `db9c67936759714b...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `19bbe261365db475...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `c0e93c7625f50289...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `28a058b6490992ed...` |
| CELEX 32003L0088 | as pinned | 2026-11-12 | `5117cc10892dcb7d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/labour/night_work){ .md-button }

## Provisions deferred, and what follows

??? info "scope_of_the_directive"

    **Why:** Art 1 states the purpose and scope (all sectors within the meaning of Directive 89/391/EEC; not seafarers) and Art 14 leaves room for more specific Community rules for certain occupations. The order does not decide whether a worker is within the Directive; it assumes so (reading (16), Q23).

    **Consequence for a user:** A caller whose worker is outside Art 1 (a seafarer, for example) or under a more specific rule of Art 14 must not rely on the answers.

??? info "night_worker_definition_points"

    **Why:** Points (a) and (b) of Art 2(4), with (b)(i) and (b)(ii), say who is a night worker: three hours of daily working time during night time as a normal course, or a proportion of annual working time defined by national legislation or collective agreement. The caller states the result as the judgement night_worker; the order does not apply the points to the rota (reading (11), Q15).

    **Consequence for a user:** not_a_night_worker and every answer that relies on night_worker rest on the caller's judgement, not on a check of the rota against Art 2(4).

??? info "other_reference_periods_and_the_leave_sentence"

    **Why:** Art 16(a) and 16(b) let the Member States lay down reference periods for Art 5 (weekly rest) and Art 6 (maximum weekly working time). The sentence printed after 16(b) (subpara_016_1) makes paid annual leave and sick leave neutral in the calculation of the average; the order reads it as belonging to Art 16(b) and does not apply it to the average of Art 8(a) (reading (6), Q10).

    **Consequence for a user:** Leave days stay in the divisor of the Art 8(a) average.

??? info "conditions_of_the_derogations"

    **Why:** The points of Art 17(1) and 17(3) list the activities and cases a derogation may cover; Art 17(2) and the third subparagraph of Art 18 require equivalent compensating rest or appropriate protection; the fourth subparagraph of Art 18 lets the Member States lay down rules for applying it. Whether a derogation exists and meets them is a matter of national law and of the agreements; the caller states the derogation (reading (14), Q19).

    **Consequence for a user:** night_work_derogation_applies never says that the conditions were met or that compensating rest was given.

??? info "adequate_rest_and_limits_of_mobile_and_fishing_vessel_workers"

    **Why:** The second subparagraphs of Art 20(1) and Art 21(1) and Art 21(2) to (7) ask the Member States to ensure adequate rest, and limits on hours of work or rest, for mobile workers and workers on board seagoing fishing vessels, by national measures. This order only says that Art 8 does not apply to them (reading (13), Q18).

    **Consequence for a user:** night_work_limits_not_applied_to_worker never says that the worker had adequate rest or that the limits of Art 21 were kept.

