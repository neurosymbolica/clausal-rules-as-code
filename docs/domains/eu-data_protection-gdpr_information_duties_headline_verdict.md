# Regulation (EU) 2016/679 (GDPR) Articles 13 and 14, headline part of the split gdpr-information-duties order: whether the controller's duty to inform the data subject is ...

`eu/data_protection/gdpr_information_duties_headline_verdict`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 184/184 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR) Articles 13 and 14, headline part of the split gdpr-information-duties order: whether the controller's duty to inform the data subject is satisfied or disapplied for one processing situation (information_duty_verdict/3), whether an Art 14(5)(b), (c) or (d) exemption applies (information_duty_exemption/2), and which outside facts were attested (information_outside_facts/2), with the shared input check. The headline is built internally from the route (Art 13 or Art 14), the items owed and missing (Art 13(1), 13(2), 14(1), 14(2), with Art 13(4) and 14(5)(a) item by item), the timing (Art 13(1) at obtaining; Art 14(3) earliest applicable limb, the one-month limb computed under Regulation (EEC, Euratom) No 1182/71 Art 3 with attested public holidays) and further processing (Art 13(3), 14(4)). Open-textured questions (automated decision-making under Art 22, reasonable period, impossibility or disproportionate effort, relevance of paragraph-2 information) are the user's judgements and refer to a lawyer when unsure. Out of scope: the content adequacy of an item, Art 12 modalities, the validity of the lawful basis (Arts 6, 7, 9), Art 22 and Art 89 ...

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

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays. Article 2(2), the working day, is quoted above and has its own row.

    **Consequence for a user:** The caller attests in public_holidays the public holidays of the Member State or Community institution in which the action is to be taken (Article 2(1)); a public holiday missing from that list, or an absent list, leaves a deadline that falls on that day unmoved, one working day early.

??? info "already_has_the_information_and_exemption_chapeau_without_order_citation_key"

    **Why:** Applied in the rules (reading 7, item by item through items_data_subject_already_has; reading 10, the Art 14(5) chapeau disapplying the whole duty when an exemption (b), (c) or (d) is MET), but the order's citation vocabulary gives no key that the provision ledger maps to these three units, so no clause can be counted as formalizing them. Listed here until the order's citation lexicon names them.

    **Consequence for a user:** None for a caller beyond the readings stated: an item the data subject already has is never missing, and an Art 14(5)(b)-(d) exemption MET disapplies paragraphs 1 to 4 as a whole; the caller states items_data_subject_already_has as a fact, not proved (Q7), and exemptions are all or nothing (Q6).

