# Regulation (EU) 2016/679 (GDPR), beside gdpr-chapter-v-transfers (which it never re-decides). Decided here, from the pinned text only: the controller's two duties to ...

`eu/data_protection/gdpr_chapter_v_extras`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 142/142 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), beside gdpr-chapter-v-transfers (which it never re-decides). Decided here, from the pinned text only: the controller's two duties to inform (the supervisory authority; the data subject of the transfer and of the compelling legitimate interests) in the second and third sentences of the second subparagraph of Art 49(1), and the Art 49(6) duty of the controller or processor to document the assessment and the suitable safeguards in its Art 30 records, for a transfer made under that subparagraph (second_subparagraph_duty/5); Art 48 as a bar on recognising or enforcing a third-country judgment or decision requiring a transfer or disclosure without an international agreement (foreign_judgment_or_decision_recognition/4); and Art 44, first sentence, for an onward transfer, whose own Chapter V answer is supplied as an outside fact (onward_transfer_condition/4). Out of scope: whether a transfer may take place under Chapter V and on which basis (gdpr-chapter-v-transfers), the conditions of the first sentence of the second subparagraph of Art 49(1), whether an Art 30 record is required and what else it holds (gdpr-records-and-officer, including Art 30(5)), the ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `be94a9b44f8186dd...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `d394c2e970597f1e...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `4c863c474020224f...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `8ec2982c82aa6e6b...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `ba71e390dcb232b9...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `ee6ad917aa8bffd4...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_chapter_v_extras){ .md-button }

## Provisions deferred, and what follows

??? info "chapter_v_units_read_by_no_order"

    **Why:** Art 45(2), (4) to (7) and (9) (the Commission's assessment, review, repeal and older decisions), Art 46(2) points (a) and (c) to (f), Art 46(3) to (5) (which instrument supplies the safeguards, the consistency mechanism, transitional validity) and Art 49(5) (limits set by Union or Member State law) are read by no limb of this order, and gdpr-chapter-v-transfers defers them too.

    **Consequence for a user:** No answer checks an adequacy decision's machinery, which safeguard instrument applies, or a limit under Art 49(5): the caller checks them before asking gdpr-chapter-v-transfers.

??? info "art_49_1_first_subparagraph_and_conditions"

    **Why:** The paragraph unit of Art 49(1) holds the first subparagraph (its opening words) and the second subparagraph. Its last two sentences (the duties to inform) are formalised here (second_subparagraph_duty). The opening words of the first subparagraph and the conditions in the first sentence of the second subparagraph are decided by gdpr-chapter-v-transfers and read here only through the outside fact transfer_relies_on_article_49_1_second_subparagraph (reading (2)).

    **Consequence for a user:** No answer tests whether a transfer meets the conditions of the second subparagraph: the caller supplies transfer_relies_on_article_49_1_second_subparagraph from gdpr-chapter-v-transfers or a human statement.

??? info "records_form_and_availability"

    **Why:** Art 30(3) (the records in writing, including in electronic form) and Art 30(4) (the record made available to the supervisory authority on request) are read by no limb of this order; gdpr-records-and-officer defers them too.

    **Consequence for a user:** No answer checks the form of the record or its availability to the supervisory authority.

