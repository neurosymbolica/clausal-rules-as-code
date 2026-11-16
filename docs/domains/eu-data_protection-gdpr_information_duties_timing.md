# WHEN the controller must give the data subject the information of GDPR Art 13(1) (data collected from the data subject: at the time the personal data are obtained) or ...

`eu/data_protection/gdpr_information_duties_timing`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 164/164 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

WHEN the controller must give the data subject the information of GDPR Art 13(1) (data collected from the data subject: at the time the personal data are obtained) or Art 14 (data not obtained from the data subject: Art 14(3)(a) within a reasonable period and at the latest within one month, (b) at the latest at the first communication, (c) at the latest at the first disclosure to another recipient, the earliest applicable date binding), and whether the one provision carried by the profile came in time. The one-month period is computed by Regulation (EEC, Euratom) No 1182/71 Art 3(1), 3(2)(c) and 3(4), applied to the GDPR by the G4 order, with an attested public-holiday list. Answers information_deadline/2 (the date), information_deadline_basis/2 (the limb) and information_timing_verdict/3 (timely | late, cited), with the input check gdpr_information_duties_timing_input_problems/2. The reasonable period is the user's judgement provided_within_reasonable_period; unsure refers to a lawyer. Out of scope: which items are owed or missing, the Art 14(5) exemptions, further processing and the headline verdict (sibling orders), the adequacy of an item's content (Q11), the form of the ...

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

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_information_duties_timing){ .md-button }

## Provisions deferred, and what follows

??? info "art4_definitions_used_for_reasoning"

    **Why:** Quoted above for the terms data subject (Art 4(1)), profiling (Art 4(4), inside the automated decision-making item), controller (Art 4(7)) and recipient (Art 4(9), whose exception for public authorities in a particular inquiry bounds recipients_exist). No limb reads them: the profile states the facts in those terms already.

    **Consequence for a user:** whether data is personal data, who is the controller and whether a body is a recipient are not tested. The caller must establish them under Art 4(1), (7) and (9) itself before stating the profile, in particular recipients_exist.

??? info "art14_3_a_specific_circumstances"

    **Why:** Formalized as the one-month outer limit (exact) and the judgement provided_within_reasonable_period. The words "having regard to the specific circumstances in which the personal data are processed" are inside the judgement.

    **Consequence for a user:** The answer takes provided_within_reasonable_period as the caller's judgement and checks only the one-month outer limit; the caller must weigh the specific circumstances of the processing under Art 14(3)(a) itself before judging it.

??? info "regulation_1182_71_article_1_scope"

    **Why:** Article 1 limits Regulation (EEC, Euratom) No 1182/71 to acts of the Council or Commission; Regulation (EU) 2016/679 is an act of the European Parliament and of the Council. This order applies Article 3 to the periods of Regulation (EU) 2016/679 by analogy (a lawyer point, see PERIODS), so no rule reads Article 1.

    **Consequence for a user:** Every deadline this order gives rests on applying Article 3 of Regulation (EEC, Euratom) No 1182/71 to Regulation (EU) 2016/679, which Article 1 of that Regulation does not itself provide: a caller that relies on the date accepts that reading, or computes the period under the rule it holds applicable.

??? info "regulation_1182_71_article_2_public_holidays_and_working_days"

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal; Article 2(2) defines working days as all days other than public holidays, Sundays and Saturdays. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays, and PERIODS states the working day of the Article 3(4) shift itself.

    **Consequence for a user:** The caller attests in public_holidays the public holidays of the Member State or Community institution in which the action is to be taken (Article 2(1)); a public holiday missing from that list, or an absent list, leaves a deadline that falls on that day unmoved, one working day early.

??? info "art14_1_route_chapeau_and_items_owed"

    **Why:** The chapeau of Art 14(1) is reached only as the route (the caller's crisp flag personal_data_collected_from_data_subject false selects Art 14(3), reading 1); points (a) to (f) list the items owed, answered by the sibling order gdpr-information-duties-items-and-further-processing (SPLIT SCOPE).

    **Consequence for a user:** Whether the data were obtained from the data subject is the caller's statement (Q5), and which Art 14(1) items are owed is not tested here; the caller asks the sibling order for the items.

??? info "art14_5_exemptions"

    **Why:** The exemptions of Art 14(5) are answered by the sibling orders (SPLIT SCOPE); the keys they read (provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law) are accepted, checked by the input check and ignored here.

    **Consequence for a user:** The deadline and the timing verdict are given even where an Art 14(5) exemption would lift the duty; the caller asks the sibling order whether the duty applies at all before relying on a late verdict.

