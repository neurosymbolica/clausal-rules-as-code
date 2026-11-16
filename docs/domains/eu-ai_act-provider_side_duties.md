# For ONE AI system and ONE actor in one role (provider, deployer, importer, distributor, product manufacturer, authorised representative or affected person), whether a ...

`eu/ai_act/provider_side_duties`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 187/187 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE AI system and ONE actor in one role (provider, deployer, importer, distributor, product manufacturer, authorised representative or affected person), whether a named duty of Regulation (EU) 2024/1689 (consolidated text 02024R1689-20260727, as amended by Regulation (EU) 2026/1744) applies on the day asked: the forty duties of Art 16 and Arts 18 to 24 (providers, authorised representatives, importers and distributors of high-risk AI systems) and of Art 4(1) (AI literacy, providers and deployers of any AI system), at their own dates of application (Art 113, third paragraph, points (a) and (c)) and under the transitional rules of Art 111(1) and (2); and, for the four keeping duties (Art 18(1), Art 19(1), Art 22(3)(b), Art 23(5)), the last day of the retention period from its start. Decided here: whether a duty applies, never what it asks or whether it is met. Out of scope, handed to the caller, a lawyer or a sibling order: the scope of the Regulation (Art 2), roles along the value chain (Art 25), the classification as high-risk (Art 6, Annexes I and III), the content of the duties and of Art 17, the Section 2 requirements, Art 79 risk, Annex X, the deployer duties of Arts 26 ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `3de76398209303f5...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `4807600f2046ff06...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `d57c5e03e896086f...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `2f319e7a440cf9e1...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `a83a0735bd04c361...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `25ea833e55f3775d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `f0d4d0411c4a5c29...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `5f4ae316b4978f0f...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `71fa6a967ce0332a...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `528bf51ad347a8ed...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `1e2a396504a5ac1e...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `e8ccf4aff93ac521...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `3299e42e8e44be0d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/provider_side_duties){ .md-button }

## Provisions deferred, and what follows

??? info "content_of_the_quality_management_system"

    **Why:** Art 17 sets what the quality management system of Art 16(c) holds: thirteen aspects in paragraph 1, implemented in a way 'proportionate to the size of the provider's organisation' (paragraph 2, an open-textured measure), with the sectoral (paragraph 3) and financial-institution (paragraph 4) rules. The order answers only whether the duty of Art 16(c) to have such a system applies (DUTY quality_management_system), not whether a system complies with Art 17 (reading (14), open question Q21).

    **Consequence for a user:** An answer duty_applies for quality_management_system does not say what the system must hold or whether it complies with Art 17; for a financial institution the caller also checks Art 17(4).

??? info "log_retention_beyond_the_six_month_minimum"

    **Why:** Art 19(1) asks that the logs be kept 'for a period appropriate to the intended purpose of the high-risk AI system, of at least six months, unless provided otherwise in the applicable Union or national law'; the order formalises whether the duty applies (DUTY log_keeping) and the end of the six-month minimum (retention_period_end/4, KEEPING_DUTY log_keeping); the appropriate longer period is open-textured and the other Union or national law is not pinned (reading (16), open question Q10).

    **Consequence for a user:** An END_DATE for log_keeping is the end of the minimum only: a longer period may be appropriate, and another law may provide otherwise.

