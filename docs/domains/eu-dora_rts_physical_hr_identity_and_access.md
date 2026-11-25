# For ONE financial entity presupposed to be within the scope of DORA: which of the thirty-six duties of Commission Delegated Regulation (EU) 2024/1774 Articles 18 ...

`eu/dora_rts_physical_hr_identity_and_access`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 175/175 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE financial entity presupposed to be within the scope of DORA: which of the thirty-six duties of Commission Delegated Regulation (EU) 2024/1774 Articles 18 (physical and environmental security policy), 19 (ICT security elements of the human resource policy), 20 (identity management) and 21 (access control) apply to it, whether it has performed all of them, and which are outstanding; with DORA Article 16(1), first subparagraph, as the gate that takes the entities it lists out of these Title II duties (simplified_framework_entity). Each duty is a caller judgement (true, false, unsure); an unsure judgement that decides is handed to a lawyer (needs_legal_review). Out of scope: whether the entity is a financial entity in scope (DORA Articles 2 and 3), who is an Article 16(1) entity and the simplified framework (DORA Article 16(1) second subparagraph, 16(2), 16(3); RTS Title III), DORA Articles 4 to 15, the other RTS articles and the date of application.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `46572456a74d842c...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `01388035eac9cfd9...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `3eb150fab43f8d49...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `818bd8b9a90f9f66...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_rts_physical_hr_identity_and_access){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_duties"

    **Why:** DORA Art 16(1), first subparagraph (Articles 5 to 15 of DORA do not apply to the entities it lists), is formalised as the gate of every query (reading (2)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework; those are the subject of the order on proportionality and the simplified framework.

    **Consequence for a user:** simplified_framework_entity says only that RTS Articles 18 to 21 do not apply; it gives none of the duties the entity has instead.

??? info "simplified_framework_duty_list"

    **Why:** DORA Art 16(1), second subparagraph, points (a) to (h), list the duties of the simplified ICT risk management framework, among them the protection of relevant physical components and infrastructures (point (a)), and DORA Art 16(2) requires that framework to be documented and reviewed. They bind only the entities of Article 16(1), for which every query answers simplified_framework_entity.

    **Consequence for a user:** The order does not check the simplified framework.

