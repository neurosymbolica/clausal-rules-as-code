# Regulation (EU) 2022/2554 (DORA), Articles 11 and 12, with Article 16(1), first subparagraph, as the gate of every query. For ONE financial entity the order answers ...

`eu/dora_ict_risk_response_and_recovery`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 184/184 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2022/2554 (DORA), Articles 11 and 12, with Article 16(1), first subparagraph, as the gate of every query. For ONE financial entity the order answers which of the duties of ICT response and recovery (Article 11) and of backup, restoration and recovery (Article 12) apply to it (duties_required), whether it has performed all of them as the caller judges (duties_complete), and which of them are outstanding (duties_outstanding). An entity listed in Article 16(1), first subparagraph, is answered simplified_framework_entity. Out of scope and handed to sibling orders or a lawyer - whether the entity is a financial entity within the scope of the Regulation (Articles 2 and 3), the simplified ICT risk management framework (Article 16(1), second subparagraph, (2) and (3)), the guidelines of Article 11(11), Articles 5 to 10, 13, 14 and 17 to 20, and Commission Delegated Regulation (EU) 2024/1774. Whether a duty is performed, and how well, is the caller's open-textured judgement; an unsure judgement that decides is referred as needs_legal_review.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `db72cba7593dd9d1...` |
| CELEX 32022R2554 | as pinned | 2026-11-20 | `6281548269b69185...` |
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_ict_risk_response_and_recovery){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_duties"

    **Why:** Art 16(1), first subparagraph (Articles 5 to 15 do not apply to the entities it lists), is formalised as the gate of every query (reading (2)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework; those are the subject of the order on proportionality and the simplified framework.

    **Consequence for a user:** simplified_framework_entity says only that Articles 11 and 12 do not apply; it gives none of the duties the entity has instead.

??? info "simplified_framework_duty_list"

    **Why:** Art 16(1), second subparagraph, points (a) to (h), list the duties of the simplified ICT risk management framework, among them business continuity plans with back-up and restoration measures (point (f)) and their testing (point (g)), and Art 16(2) requires that framework to be documented and reviewed. They bind only the entities of Article 16(1), for which every query answers simplified_framework_entity.

    **Consequence for a user:** The order does not check the simplified framework.

