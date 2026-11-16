# Regulation (EU) 2016/679 (GDPR), Chapter V, Articles 44, 45(1), 45(3), 45(8), 46(1), 46(2)(b), 47(1), 48 and 49(1) to 49(4). Decided here: given a transfer profile, ...

`eu/data_protection/gdpr_chapter_v_transfers`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 201/201 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), Chapter V, Articles 44, 45(1), 45(3), 45(8), 46(1), 46(2)(b), 47(1), 48 and 49(1) to 49(4). Decided here: given a transfer profile, whether a transfer of personal data to a third country or an international organisation may take place and on which basis of the cascade (Art 45 adequacy decision as an attested outside fact, then Art 46 appropriate safeguards including approved binding corporate rules, then the claimed Art 49 derogation with the subsidiarity of the second subparagraph, the Art 49(3) public-authority carve-out and the Art 49(2) register limits). Open-textured judgements are handed to the user and referred to a lawyer when unsure. Out of scope: the Art 6 lawful basis (sibling gdpr-art6-lawfulness), the content of adequacy decisions and of Art 46(2) and (3) instruments, the content of binding corporate rules under Art 47(2), recognition of third-country judgments under Art 48 (recorded only), onward transfers as separate assessments (recorded only), and Art 49(5) and (6) (see deferred_set).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `d394c2e970597f1e...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `4c863c474020224f...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `8ec2982c82aa6e6b...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `ad2caffaf9909d27...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `ba71e390dcb232b9...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `ee6ad917aa8bffd4...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_chapter_v_transfers){ .md-button }

## Provisions deferred, and what follows

??? info "adequacy_decision_content"

    **Why:** Art 45(2) (what the Commission assesses), (4)-(7) (monitoring, repeal and consultation) and (9) (decisions under the former Directive): whether a given country is covered by a decision is the OUTSIDE FACT adequacy_decision_in_force, not derived here.

    **Consequence for a user:** the caller or the host states, with evidence, that a decision is in force; the order does not check the review, repeal or suspension machinery.

??? info "art_46_instrument_mechanics"

    **Why:** Art 46(2) points (a) and (c) to (f) and Art 46(3) (point (b), binding corporate rules, is read by stage two through the outside fact binding_corporate_rules_approved): which instrument supplies the appropriate safeguards (public-authority instrument, binding corporate rules, standard clauses, code of conduct, certification, authorised contractual clauses, administrative arrangements) arrives inside the judgement safeguard_in_place; the sub-conditions and authorisations are out of scope.

    **Consequence for a user:** The answer takes safeguard_in_place as given: the caller must check which Art 46(2) or (3) instrument applies and that its conditions and any authorisation are met itself.

??? info "art_46_consistency_and_transitional"

    **Why:** Art 46(4) (consistency mechanism) and (5) (transitional validity of older authorisations) are procedure and transition, not conditions scored here.

    **Consequence for a user:** The answer does not check the consistency mechanism or whether an older authorisation is still valid: the caller must check Art 46(4) and (5) itself before setting safeguard_in_place.

??? info "art_47_binding_corporate_rules_approval"

    **Why:** Art 47(2) lists the content binding corporate rules must have (points (a) to (n)) and Art 47(3) the implementing acts on the exchange of information. The approval under Art 47(1) is read as the attested outside fact binding_corporate_rules_approved; the content and the procedure stay out of scope.

    **Consequence for a user:** The answer does not check the content of binding corporate rules under Art 47(2): it takes the approval under Art 47(1) as attested.

??? info "art_49_5_and_6_limits_and_records"

    **Why:** Art 49(5) (Union or Member State law may limit transfers of specific categories where there is no adequacy decision) and Art 49(6) (the controller documents the assessment and safeguards) are a power and a record-keeping duty, not conditions scored here.

    **Consequence for a user:** the order does not check a national limit under Art 49(5). The caller must check any such limit, and document the assessment and safeguards under Art 49(6), itself.

