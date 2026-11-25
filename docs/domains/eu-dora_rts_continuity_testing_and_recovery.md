# For ONE financial entity: which of the twenty-three duties of Articles 25 (testing of the ICT business continuity plans) and 26 (ICT response and recovery plans) of ...

`eu/dora_rts_continuity_testing_and_recovery`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 191/191 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE financial entity: which of the twenty-three duties of Articles 25 (testing of the ICT business continuity plans) and 26 (ICT response and recovery plans) of Commission Delegated Regulation (EU) 2024/1774 apply to it, whether it has performed all of them as the caller judges each, and which are outstanding; gated by Article 16(1), first subparagraph, of Regulation (EU) 2022/2554 (DORA), under which those articles do not bind the entities it lists (answered simplified_framework_entity). Conditions read: the microenterprise size class (Art 25(2)(c)), the entity type central counterparty or central securities depository (Art 25(3), 25(4)) and the use of ICT third-party service providers (Art 25(2)(b), 26(4)). Each duty is one caller judgement (true, false, unsure); an unsure judgement that decides is referred to a lawyer (needs_legal_review). Out of scope: whether the entity is a financial entity within DORA (Art 2, 3), DORA Article 11 itself, the other articles of the RTS, the simplified ICT risk management framework (DORA Art 16(1) second subparagraph, 16(2), 16(3); RTS Title III) and dates of application.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `c22db6d15b84f1d5...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `74095fde47a6e5fb...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_rts_continuity_testing_and_recovery){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_duties"

    **Why:** Art 16(1), first subparagraph, of DORA (Articles 5 to 15 do not apply to the entities it lists) is formalised as the gate of every query (reading (2)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework; those are the subject of the orders on proportionality and the simplified framework.

    **Consequence for a user:** simplified_framework_entity says only that Articles 25 and 26 of the RTS do not apply; it gives none of the duties the entity has instead.

??? info "simplified_framework_duty_list"

    **Why:** Art 16(1), second subparagraph, points (a) to (h), of DORA list the duties of the simplified ICT risk management framework, among them business continuity plans (point (f)) and their testing (point (g)), and Art 16(2) requires that framework to be documented and reviewed. They bind only the entities of Article 16(1), for which every query answers simplified_framework_entity.

    **Consequence for a user:** The order does not check the simplified framework.

