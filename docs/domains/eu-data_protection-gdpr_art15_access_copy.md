# When a controller answers a data subject's request for access under Art 15 of Regulation (EU) 2016/679 (GDPR), what must the answer and the copy contain? Decided here, ...

`eu/data_protection/gdpr_art15_access_copy`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 172/172 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

When a controller answers a data subject's request for access under Art 15 of Regulation (EU) 2016/679 (GDPR), what must the answer and the copy contain? Decided here, from the pinned text of Art 15 only: the confirmation and the items of information of Art 15(1), points (a) to (h) (access_answer_items/4, and the items still missing from a given answer, access_answer_items_missing/4); the information on Art 46 transfer safeguards of Art 15(2); the copy (copy_scope/3), the fee for further copies (copy_fee/3) and the commonly used electronic form (information_form/3) of Art 15(3); and Art 15(4) as a limit on the copy only. The Art 15(4) judgement is the caller's (unsure goes to a lawyer); the Art 22(1) and (4) statement and the Art 46 safeguards statement arrive as attested outside facts and an absent one is referred. Out of scope: whether access is owed at all (identity and Art 11, manifestly unfounded or excessive requests, Art 23 restrictions), the time limits of Art 12(3) and (4) (no deadline is computed here; deferred to gdpr-data-subject-rights-response-period), the fee and refusal of Art 12(5), the form rules of Art 12(1), the adequacy of the content of any item, Art 22 and ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6a0964641d4ee107...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_art15_access_copy){ .md-button }

## Provisions deferred, and what follows

??? info "art4_definitions_decided_in_common_definitions_data_and_processing"

    **Why:** Art 4(1) personal data and data subject, 4(2) processing and 4(9) recipient are quoted above to tie the terms of Art 15 and of the keys (readings (1), (2), (4)); no limb of this order reads them, and they are decided by gdpr-common-definitions-data-and-processing with the other definitions of this list (restriction, profiling, pseudonymisation, filing system, third party, consent, personal data breach, information society service, international organisation), none of which this order reads.

    **Consequence for a user:** Whether information is personal data, whether an operation is processing and whether a body is a recipient are not tested: the caller establishes them before stating personal_data_concerning_data_subject_processed and disclosure_to_recipients_made_or_envisaged.

??? info "art4_definitions_decided_in_common_definitions_roles_and_establishments"

    **Why:** Art 4(7) controller is quoted above to tie the term (reading (1)); no limb reads it. It and the other definitions of this list (processor, genetic, biometric and health data, main establishment, enterprise, group of undertakings, cross-border processing, relevant and reasoned objection and the rest) are decided by gdpr-common-definitions-roles-and-establishments; none is read here.

    **Consequence for a user:** Who is the controller is not tested: the caller addresses the profile to the controller of the processing.

??? info "art12_1_form_of_communication"

    **Why:** Art 12(1) (a concise, transparent, intelligible and easily accessible form, clear and plain language; in writing or by other means, including electronic means; orally on request) governs how any communication under Arts 15 to 22 is given. This order reads only the electronic form of Art 15(3), third sentence (information_form); no order on main formalises Art 12(1).

    **Consequence for a user:** Whether the answer is concise, intelligible and in plain language, and whether an oral answer was allowed, are not tested; the caller checks Art 12(1) itself.

??? info "art12_4_to_12_6_no_action_fee_and_identity"

    **Why:** Art 12(4) (informing of reasons for not taking action), Art 12(5) (free of charge; a manifestly unfounded or excessive request) and Art 12(6) (reasonable doubts about identity) are decided by gdpr-data-subject-rights-response-duties. This order's fee answer reads Art 15(3), second sentence, only (reading (12)).

    **Consequence for a user:** Whether the request may be refused or charged for as manifestly unfounded or excessive, and whether additional information to confirm identity may be requested, are answered by gdpr-data-subject-rights-response-duties, not here.

??? info "art12_5_fee_amount_and_refusal"

    **Why:** Art 12(5)(a) (a reasonable fee taking into account the administrative costs) and (b) (refusal) are the two options for a manifestly unfounded or excessive request; no order on main formalises the amount of the fee, and this order reads only the fee for further copies of Art 15(3).

    **Consequence for a user:** The amount of any fee is not tested; the caller checks it against the administrative costs itself.

