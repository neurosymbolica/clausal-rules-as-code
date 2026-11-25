# For ONE financial entity referred to in Article 16(1), first subparagraph, of Regulation (EU) 2022/2554 (DORA) -- the gate, stated by the caller -- which of the duties ...

`eu/dora_rts_simplified_testing_continuity_and_report`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 153/153 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE financial entity referred to in Article 16(1), first subparagraph, of Regulation (EU) 2022/2554 (DORA) -- the gate, stated by the caller -- which of the duties of the simplified ICT risk management framework in Title III, Articles 36 to 41, of Commission Delegated Regulation (EU) 2024/1774 (ICT security testing; ICT systems acquisition, development and maintenance; ICT project and change management; the components of the ICT business continuity plans; the testing of those plans; the format and content of the report on the review of the framework, owed only on the competent authority's request, DORA Art 16(2), third sentence) apply to it, whether it has performed all of them, and which are outstanding. Each duty is the caller's judgement true, false or unsure; an unsure judgement that decides is referred for legal review. Out of scope: whether the entity is within DORA or is an Article 16(1) entity (DORA order on scope and on proportionality), Articles 28 to 35 of the RTS (sibling order on the simplified framework's policies and controls), Article 16(1), second subparagraph, and the first two sentences of Article 16(2) of DORA, Title II of the RTS, and any date.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a4af16b4c89bc0d4...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `f89105a3c79444c3...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `6d4991d621db1744...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `f2dedfb2fd9a9bbf...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `61cda8078419cef1...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `87026bf1b182dc51...` |
| CELEX 32024R1774 | as pinned | 2026-11-20 | `6638059a2dc21292...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_rts_simplified_testing_continuity_and_report){ .md-button }

## Provisions deferred, and what follows

??? info "simplified_framework_entities"

    **Why:** Art 16(1), first subparagraph (Articles 5 to 15 do not apply to the entities it lists), is formalised as the gate of every query (reading (1)). Not formalised: who those entities are, which the caller states, and the lead words of the second subparagraph, which introduce the duties of the simplified ICT risk management framework of DORA itself; those are the subject of the DORA order on proportionality and the simplified framework.

    **Consequence for a user:** not_article_16_1_entity says only that Title III of the RTS does not bind the entity; it gives none of the duties of Title II. PARTLY FORMALISED: the first subparagraph as the gate only.

??? info "simplified_framework_duty_list"

    **Why:** Art 16(1), second subparagraph, points (a) to (h), list the duties of the simplified ICT risk management framework in DORA (reading (12)).

    **Consequence for a user:** complete and none_outstanding say nothing about these duties (open question (Q12)).

??? info "simplified_framework_review_and_report"

    **Why:** Art 16(2), third sentence (the report on the review of the ICT risk management framework is submitted to the competent authority upon its request), is formalised as the trigger authority_requested_framework_review_report, the condition of every duty of Article 41 of the RTS (reading (2)). Not formalised: its first two sentences (the framework documented, reviewed periodically and upon major ICT-related incidents in compliance with supervisory instructions, and continuously improved) and the duty to submit the report itself; those are the subject of the DORA order on proportionality and the simplified framework (reading (12)).

    **Consequence for a user:** complete and none_outstanding say nothing about the review of the framework or the submission of the report (open question (Q12)). PARTLY FORMALISED: the third sentence as the trigger authority_requested_framework_review_report only.

