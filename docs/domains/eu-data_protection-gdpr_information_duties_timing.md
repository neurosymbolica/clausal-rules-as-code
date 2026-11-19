# When must the controller give the data subject the information of GDPR Art 13(1) and Art 14(3), and did it come in time? Given one profile of one processing situation ...

`eu/data_protection/gdpr_information_duties_timing`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 172/172 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

When must the controller give the data subject the information of GDPR Art 13(1) and Art 14(3), and did it come in time? Given one profile of one processing situation (one set of personal data from one source), this package answers (D) the DEADLINE, (E) the limb that fixes it and (F) whether the provision_date was timely or late. Art 13 route (data collected from the data subject): the deadline is the obtaining day. Art 14 route: the earliest of the limb (a) date (one month by Regulation (EEC, Euratom) No 1182/71 Art 3(1), 3(2)(c), 3(4) and 2(2), applied to the GDPR as a lawyer point), the first communication (b) and the first disclosure (c); the reasonable period of Art 14(3)(a) is the user's judgement, handed back when unsure; an absent public_holidays list refers only where a public holiday could change the answer. Out of scope, in the sibling orders: which items are owed or missing, further processing, the Art 14(5) exemptions and the headline verdict; Art 12 (form of the notice) is excluded; the adequacy of the content given is never decided.

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

??? info "art13_4_art14_5_a_information_already_held"

    **Why:** Whether the data subject already has an item of the information, so that Art 13(4) or Art 14(5)(a) takes it out of the duty, is decided in gdpr-information-duties-items-and-further-processing (information_items_missing/2, which reads items_data_subject_already_has); that order defers neither unit.

    **Consequence for a user:** This order does not read items_data_subject_already_has (SPLIT SCOPE): its deadline and verdict are given whatever the data subject already has; whether an item is still owed is answered by gdpr-information-duties-items-and-further-processing.

??? info "art14_5_exemptions"

    **Why:** Whether an exemption of Art 14(5)(b), (c) or (d) disapplies the information duty (the Art 14(5) chapeau) is decided in gdpr-information-duties-headline-verdict (information_duty_exemption/2). That order decides points (c) and (d) and the chapeau, and point (b) in part: the archiving, research and statistical purposes and the Art 89(1) conditions inside point (b) are its own partial deferral, decided by no order.

    **Consequence for a user:** This order does not read provision_impossible_or_disproportionate_effort, protective_measures_taken or the two law facts (SPLIT SCOPE): its deadline and verdict are given whatever exemption may apply; whether Art 14(5) disapplies the duty is answered by gdpr-information-duties-headline-verdict.

??? info "regulation_1182_71_article_1_scope"

    **Why:** Article 1 limits Regulation (EEC, Euratom) No 1182/71 to acts of the Council or Commission; Regulation (EU) 2016/679 is an act of the European Parliament and of the Council. This order applies Article 3 to the periods of Regulation (EU) 2016/679 by analogy (a lawyer point, see PERIODS), so no rule reads Article 1.

    **Consequence for a user:** Every deadline this order gives rests on applying Article 3 of Regulation (EEC, Euratom) No 1182/71 to Regulation (EU) 2016/679, which Article 1 of that Regulation does not itself provide: a caller that relies on the date accepts that reading, or computes the period under the rule it holds applicable.

??? info "regulation_1182_71_article_2_1_public_holidays"

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays. Article 2(2), the working day of the Article 3(4) shift, is Union law and is quoted and read (PERIODS); it is not in this row.

    **Consequence for a user:** The caller attests in public_holidays the public holidays of the Member State or Community institution in which the action is to be taken (Article 2(1)); a public holiday missing from an attested list leaves a deadline that falls on that day unmoved, one working day early; an absent list refers where a public holiday could change the answer (DEADLINE is a date only when a limb (b) or (c) date falls on or before the limb (a) date counted without public holidays, and is otherwise always the referral, whatever the date or weekday) (THE ANSWERS (P)).

