# For one general-purpose AI model and the provider the caller names, under Regulation (EU) 2024/1689 (Artificial Intelligence Act) as consolidated on 27 July 2026 ...

`eu/ai_act/gpai_models`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 282/282 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For one general-purpose AI model and the provider the caller names, under Regulation (EU) 2024/1689 (Artificial Intelligence Act) as consolidated on 27 July 2026 (02024R1689-20260727): (1) whether on a day the model is a general-purpose AI model with systemic risk (Art 3(63), Art 51(1) and (2), Art 52(2) to (4)); (2) whether the provider's notification to the Commission under Art 52(1) came within the outer limit of two weeks, read with Art 111(3) and Art 113(b); (3) whether one of the ten duties of Art 53(1)(a) to (d), Art 53(3), Art 54(1) and (2) and Art 55(1)(a) to (d) applies to the provider on a day, with the open-source exceptions of Art 53(2) and Art 54(6), the transitional period of Art 111(3) and the date of Art 113(b); (4) the minimum elements Annex XI and Annex XII list for the technical documentation and the information to downstream providers. Out of scope and left to the caller or a lawyer: the scope of the Regulation under Art 2, who the provider is and when the model is placed on the market, the content of each duty and whether it is met (codes of practice under Art 56, harmonised standards), the words 'without delay' and the content of the notification, the ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `f5629f2c102ee5ab...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `a713c364d5a1c036...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `afa8b0400ba69989...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `3de76398209303f5...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `9fdbb69e17e17ac8...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `c8eebc2b114b482f...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `27c64af2b8d60f9d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `23473647be25b145...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `74af503c9d0ee72c...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `e8ccf4aff93ac521...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `3299e42e8e44be0d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/gpai_models){ .md-button }

## Provisions deferred, and what follows

??? info "provider_and_placing_on_the_market_of_a_general_purpose_ai_model"

    **Why:** Art 3, points (3) provider, (5) authorised representative, (9) placing on the market and (10) making available on the market, as they apply to general-purpose AI models: who is the provider of the model, and when it is placed on the market, are not tested by this order; every query answers for the provider of the model the caller names (reading (1), open question Q20). The AI-system parts of these points are formalised elsewhere.

    **Consequence for a user:** The caller checks that the actor is the provider of the model, and gives placed_on_the_market_before_2_august_2025 and the research key from the definition of placing on the market.

??? info "content_of_the_notification_and_without_delay"

    **Why:** Art 52(1) asks the provider to notify 'without delay and in any event within two weeks' and says the notification shall include the information necessary to demonstrate that the requirement has been met; the order checks only the outer limit of two weeks (reading (8), open question Q21), not the words 'without delay' and not the content.

    **Consequence for a user:** An answer notification_within_the_time_limit does not say that the notification was made without delay or that it holds the necessary information.

??? info "tasks_and_mandate_of_the_authorised_representative"

    **Why:** Art 54(3) to (5) set the tasks of the authorised representative and the content of its mandate; they bind the representative, not the provider, and no query of this order answers for the representative.

    **Consequence for a user:** An answer on the obligation authorised_representative says only whether the provider must appoint and enable one.

