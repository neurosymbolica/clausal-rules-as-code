# Two duties of the controller under Regulation (EU) 2016/679 (GDPR) that follow a data subject's right, on the pinned consolidated text 02016R0679-20160504. (A) Art ...

`eu/data_protection/gdpr_data_subject_rights_objection_notice_and_erasure_follow_up`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 219/219 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Two duties of the controller under Regulation (EU) 2016/679 (GDPR) that follow a data subject's right, on the pinned consolidated text 02016R0679-20160504. (A) Art 21(4), objection_right_notice/4: whether the right to object of Art 21(1) and (2) was explicitly brought to the data subject's attention at the latest at the time of the first communication with the data subject, and presented clearly and separately from any other information (notice_not_owed, notice_not_yet_due, notice_complies, notice_does_not_comply). (B) Art 17(2), erasure_follow_up_duty/4: whether a controller that has made personal data public and is obliged under Art 17(1) to erase them has taken reasonable steps to inform the controllers processing the data of the request for erasure (follow_up_duty_does_not_apply, follow_up_duty_met, follow_up_duty_not_met). Out of scope and read only as attested outside facts: whether the right to object exists (Art 21(1), (2); gdpr-data-subject-rights-portability-and-objection) and whether the controller is obliged to erase (Art 17(1) with Art 17(3); gdpr-data-subject-rights-erasure). The open-textured words 'presented clearly' and 'reasonable steps' are the caller's ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6acc6d77b6847633...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `735cc0fbeef553cf...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_objection_notice_and_erasure_follow_up){ .md-button }

## Provisions deferred, and what follows

??? info "art17_1_erasure_obligation"

    **Why:** Art 17(1) (the right to erasure and the controller's obligation to erase where one of the grounds (a) to (f) applies) is quoted above for the words 'obliged pursuant to paragraph 1' of Art 17(2) (reading (9)); no limb of this order reads it. It is decided, the paragraph and all six points, by gdpr-data-subject-rights-erasure, whose answer this order reads only as the attested outside fact controller_obliged_to_erase_under_article_17_1.

    **Consequence for a user:** Whether the controller is obliged to erase is not tested here: the caller supplies the attested statement (from gdpr-data-subject-rights-erasure or a human).

??? info "art17_3_exceptions"

    **Why:** Art 17(3) (paragraphs 1 and 2 shall not apply to the extent that processing is necessary for the purposes in points (a) to (e)) is quoted above (reading (9)); no limb of this order reads it. Its effect on the obligation of paragraph 1 is decided, the paragraph and all five points, by gdpr-data-subject-rights-erasure; its effect on paragraph 2 reaches this order only through the attested outside fact controller_obliged_to_erase_under_article_17_1, which is false where Art 17(3) removes the obligation (reading (9), Q6).

    **Consequence for a user:** Where an exception of Art 17(3) applies, the caller supplies controller_obliged_to_erase_under_article_17_1 attested false, and the follow-up duty does not apply; how far a partial exception reaches is not tested.

??? info "art21_1_to_21_3_and_21_6_right_to_object"

    **Why:** Art 21(1) and (2) (the right to object to processing based on Art 6(1)(e) or (f) and to processing for direct marketing) are quoted above because Art 21(4) names 'the right referred to in paragraphs 1 and 2' (reading (2)); Art 21(3) (no further processing for direct marketing after an objection) and Art 21(6) (objection to processing for research or statistical purposes) are not quoted. No limb of this order reads any of the four; they are decided by gdpr-data-subject-rights-portability-and-objection, whose answer on Art 21(1) and (2) this order reads only as the attested outside fact right_to_object_applies.

    **Consequence for a user:** Whether the data subject has a right to object, and what follows from an objection, are not tested here: the caller supplies the attested statement for right_to_object_applies.

