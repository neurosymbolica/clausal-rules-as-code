# The headline question of the GDPR information duties: given a profile of one processing situation, is the controller's duty to inform the data subject satisfied or ...

`eu/data_protection/gdpr_information_duties_headline_verdict`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 163/163 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The headline question of the GDPR information duties: given a profile of one processing situation, is the controller's duty to inform the data subject satisfied or disapplied (eligible) or not (ineligible) under Regulation (EU) 2016/679 Arts 13 and 14, with the route (Art 13 or Art 14), the items owed and missing, the deadline (Art 13(1) at collection; Art 14(3) earliest of one month by Regulation 1182/71 Art 3, first communication, first disclosure), further processing (Arts 13(3), 14(4)), the already-has exemption (Arts 13(4), 14(5)(a)) and the Art 14(5)(b), (c), (d) exemptions. Also answers information_duty_exemption/2 and information_outside_facts/2 and the input check. Out of scope, handed to the lawyer or a sibling order: the adequacy of the content of an item given, Art 12 modalities, Art 22, Arts 6, 7 and 9 lawfulness, Art 89 safeguards, remedies and fines.

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

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_information_duties_headline_verdict){ .md-button }

## Provisions deferred, and what follows

??? info "art4_definitions_used_for_reasoning"

    **Why:** Quoted above for the terms data subject (Art 4(1)), profiling (Art 4(4), inside the automated decision-making item), controller (Art 4(7)) and recipient (Art 4(9), whose exception for public authorities in a particular inquiry bounds recipients_exist). No limb reads them: the profile states the facts in those terms already.

    **Consequence for a user:** whether data is personal data, who is the controller and whether a body is a recipient are not tested. The caller must establish them under Art 4(1), (7) and (9) itself before stating the profile, in particular recipients_exist.

??? info "art13_1_a_representative_detail"

    **Why:** Formalized as the controller_identity_and_contact_details item. The words "and, where applicable, of the controller's representative" are inside the item: whether the controller has a representative (Art 27) is not tested, and a provided item counts as complete (open question Q11).

    **Consequence for a user:** A missing representative is not detected: where the controller must designate a representative under Art 27, the caller must check itself that the notice gives the representative's identity and contact details, since a provided controller_identity_and_contact_details item counts as complete.

??? info "art14_5_b_archiving_research_and_art89_conditions"

    **Why:** Formalized through the judgement provision_impossible_or_disproportionate_effort and the flag protective_measures_taken. The archiving, scientific or historical research and statistical purposes and the Art 89(1) conditions and safeguards are inside the judgement; Art 89 is not pinned.

    **Consequence for a user:** The answer takes provision_impossible_or_disproportionate_effort as the caller's judgement; for archiving, research or statistical processing the caller must check the Art 89(1) conditions and safeguards itself before judging it true.

??? info "art14_3_a_specific_circumstances"

    **Why:** Formalized as the one-month outer limit (exact) and the judgement provided_within_reasonable_period. The words "having regard to the specific circumstances in which the personal data are processed" are inside the judgement.

    **Consequence for a user:** The answer takes provided_within_reasonable_period as the caller's judgement and checks only the one-month outer limit; the caller must weigh the specific circumstances of the processing under Art 14(3)(a) itself before judging it.

??? info "regulation_1182_71_article_1_scope"

    **Why:** Article 1 limits Regulation (EEC, Euratom) No 1182/71 to acts of the Council or Commission; Regulation (EU) 2016/679 is an act of the European Parliament and of the Council. This order applies Article 3 to the periods of Regulation (EU) 2016/679 by analogy (a lawyer point, see PERIODS), so no rule reads Article 1.

    **Consequence for a user:** Every deadline this order gives rests on applying Article 3 of Regulation (EEC, Euratom) No 1182/71 to Regulation (EU) 2016/679, which Article 1 of that Regulation does not itself provide: a caller that relies on the date accepts that reading, or computes the period under the rule it holds applicable.

??? info "regulation_1182_71_article_2_public_holidays_and_working_days"

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal; Article 2(2) defines working days as all days other than public holidays, Sundays and Saturdays. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays, and PERIODS states the working day of the Article 3(4) shift itself.

    **Consequence for a user:** The caller attests in public_holidays the public holidays of the Member State or Community institution in which the action is to be taken (Article 2(1)); a public holiday missing from that list, or an absent list, leaves a deadline that falls on that day unmoved, one working day early.

??? info "already_has_the_information_and_exemption_chapeau"

    **Why:** Art 13(4), the Art 14(5) chapeau and Art 14(5)(a) are applied through the list items_data_subject_already_has (an item in it is covered and never missing) and through the evaluation of points (b), (c), (d) in the exemption slice. They are not decided by a separate rule of their own that the citation gate can attribute to the unit.

    **Consequence for a user:** The list items_data_subject_already_has is the controller's statement of fact and is not proved (open question Q7); the exemptions of points (b), (c), (d) are all-or-nothing, not item by item (open question Q6).

