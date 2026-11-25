# For ONE financial entity within the scope of DORA (presupposed, not decided): which of the duties on logging (Article 12), network security management (Article 13) and ...

`eu/dora_rts_logging_and_network_security`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 175/175 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE financial entity within the scope of DORA (presupposed, not decided): which of the duties on logging (Article 12), network security management (Article 13) and securing information in transit (Article 14) of Commission Delegated Regulation (EU) 2024/1774 apply to it, whether it has performed all of them, and which are outstanding, with the rule of Regulation (EU) 2022/2554 (DORA) Article 16(1), first subparagraph, that Articles 5 to 15 of DORA do not apply to the entities it lists (answered simplified_framework_entity). Each duty is the caller's judgement (true, false or unsure); an unsure judgement that decides goes to a lawyer as needs_legal_review. Out of scope: the simplified ICT risk management framework of DORA Article 16(1), second subparagraph, (2) and (3) (deferred); the other articles of the technical standards, DORA Articles 2 to 15, the proportionality principle, the standards of Regulation (EU) No 1025/2012 and the dates of application (excluded; sibling orders).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `d51d1b4aff2a6604...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `83d411373ee78fe4...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `53c194d290cd2a85...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_rts_logging_and_network_security){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_duties"

    **Why:** DORA Art 16(1), first subparagraph (Articles 5 to 15 do not apply to the entities it lists), is formalised as the gate of every query (reading (2)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework; those are the subject of the orders on the simplified framework.

    **Consequence for a user:** simplified_framework_entity says only that Articles 12 to 14 of the technical standards do not apply; it gives none of the duties the entity has instead.

??? info "simplified_framework_duty_list"

    **Why:** DORA Art 16(1), second subparagraph, points (a) to (h), list the duties of the simplified ICT risk management framework, and Art 16(2) requires that framework to be documented and reviewed. They bind only the entities of Article 16(1), for which every query answers simplified_framework_entity.

    **Consequence for a user:** The order does not check the simplified framework.

