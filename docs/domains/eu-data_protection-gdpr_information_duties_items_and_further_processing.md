# Regulation (EU) 2016/679 Arts 13 and 14 (items part of the split order): which route applies (Art 13 data collected from the data subject, Art 14 not obtained from the ...

`eu/data_protection/gdpr_information_duties_items_and_further_processing`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 144/144 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 Arts 13 and 14 (items part of the split order): which route applies (Art 13 data collected from the data subject, Art 14 not obtained from the data subject), the checklist of information items owed (Art 13(1), 13(2), 14(1), 14(2)) once each conditional item's condition is applied, the items still missing given the items provided and the items the data subject already has (Art 13(4), 14(5)(a)), and the further-processing verdict for another purpose (Art 13(3), 14(4)): information on the other purpose and any relevant paragraph-2 information strictly before the further processing. Out of scope (sibling parts or lawyer): the Art 14(3) deadline, the timing verdict, the Art 14(5)(b)-(d) exemptions, the headline verdict, the adequacy of the content of an item given, Art 12 modalities, Art 22.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `269536b20c4776e5...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `c107f300fe1ec05f...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `cf9451469dd7aa34...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `c7d819a8ee942b7c...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `55a56126f24456ad...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `27a4c5d981f76151...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `359886d5081f218d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_information_duties_items_and_further_processing){ .md-button }

## Provisions deferred, and what follows

??? info "art4_definitions_used_for_reasoning"

    **Why:** Quoted above for the terms data subject (Art 4(1)), profiling (Art 4(4), inside the automated decision-making item), controller (Art 4(7)) and recipient (Art 4(9), whose exception for public authorities in a particular inquiry bounds recipients_exist). No limb reads them: the profile states the facts in those terms already.

    **Consequence for a user:** whether data is personal data, who is the controller and whether a body is a recipient are not tested. The caller must establish them under Art 4(1), (7) and (9) itself before stating the profile, in particular recipients_exist.

??? info "art13_1_a_representative_detail"

    **Why:** Formalized as the controller_identity_and_contact_details item. The words "and, where applicable, of the controller's representative" are inside the item: whether the controller has a representative (Art 27) is not tested, and a provided item counts as complete (open question Q11).

    **Consequence for a user:** A missing representative is not detected: where the controller must designate a representative under Art 27, the caller must check itself that the notice gives the representative's identity and contact details, since a provided controller_identity_and_contact_details item counts as complete.

??? info "already_has_the_information_exemption_applied_through_item_lists"

    **Why:** Art 13(4) and Art 14(5)(a) (the data subject already has the information) are applied item by item through the profile list items_data_subject_already_has: an item in that list is covered like an item provided and is never missing, and it also covers the further-processing items. The list is the controller's statement of fact (open question Q7); no separate citation key of the order is cited for these two units.

    **Consequence for a user:** Whether the data subject really has the information is not proved or tested; the caller states the items and must establish for itself that the data subject already holds them.

??? info "art14_3_deadline_sibling_part"

    **Why:** The Art 14(3) deadline (reasonable period, at the latest within one month; first communication; first disclosure) is answered by the sibling timing part of the split order, not by this part.

    **Consequence for a user:** This order gives no Art 14(3) deadline; a caller takes it from the sibling timing part.

??? info "art14_5_exemptions_b_to_d_sibling_part"

    **Why:** The Art 14(5) chapeau and the exemptions of points (b)-(d) (impossible or disproportionate effort, laid down by law, professional secrecy) are answered by the sibling parts; this part reads only point (a), the data subject already has the information.

    **Consequence for a user:** This order does not test the Art 14(5)(b)-(d) exemptions; a caller applies them through the sibling parts.

