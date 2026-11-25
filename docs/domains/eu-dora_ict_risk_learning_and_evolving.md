# Regulation (EU) 2022/2554 (DORA), Article 13 (learning and evolving), paragraphs (1) to (7) with points (a) to (d) of Article 13(2), gated by the rule of Article 16(1), ...

`eu/dora_ict_risk_learning_and_evolving`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 180/180 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2022/2554 (DORA), Article 13 (learning and evolving), paragraphs (1) to (7) with points (a) to (d) of Article 13(2), gated by the rule of Article 16(1), first subparagraph, that Articles 5 to 15 do not apply to the entities it lists. For ONE financial entity, presupposed to be within the scope of the Regulation, the order decides which of the twenty Article 13 duties apply to it (ict_risk_learning_and_evolving_duties_required), whether it has performed all of them (ict_risk_learning_and_evolving_duties_complete) and which are outstanding (ict_risk_learning_and_evolving_duties_outstanding). Every duty is a caller judgement (true, false or unsure); an unsure judgement that decides is handed to a lawyer as needs_legal_review. Out of scope: entity scope and types (Articles 2 and 3), who the Article 16(1) entities are and their simplified framework (Article 16(1) second subparagraph, (2) and (3): deferred), Articles 5 to 12, 14 and 15, incident classification and reporting (Articles 17 to 20), testing (Articles 26 and 27), contractual provisions (Article 30), proportionality (Article 4), the date of application (Article 64) and the regulatory technical standards on ICT ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `bcd53e250e7d28db...` |
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_ict_risk_learning_and_evolving){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_duties"

    **Why:** Art 16(1), first subparagraph (Articles 5 to 15 do not apply to the entities it lists), is formalised as the gate of every query (reading (2)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework; those are the subject of the order on proportionality and the simplified framework.

    **Consequence for a user:** simplified_framework_entity says only that Article 13 does not apply; it gives none of the duties the entity has instead.

??? info "simplified_framework_duty_list"

    **Why:** Art 16(1), second subparagraph, points (a) to (h), list the duties of the simplified ICT risk management framework, and Art 16(2) requires that framework to be documented and reviewed. They bind only the entities of Article 16(1), for which every query answers simplified_framework_entity.

    **Consequence for a user:** The order does not check the simplified framework.

