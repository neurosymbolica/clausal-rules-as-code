# Whether a controller must comply with a data subject request invoking one of the rights of Regulation (EU) 2016/679 Arts 15, 16, 17, 18, 20, 21 or 22 (Art 12(2) to (6) ...

`eu/data_protection/gdpr_data_subject_rights_response_duties`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 187/187 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether a controller must comply with a data subject request invoking one of the rights of Regulation (EU) 2016/679 Arts 15, 16, 17, 18, 20, 21 or 22 (Art 12(2) to (6) response rules, Art 17(3), 20(3)-(4), 21 and 22(2)-(4) exceptions, Art 23 restriction as an attested outside fact); the response deadline (one month, or three months from receipt where the extension is available) computed under Regulation (EEC, Euratom) No 1182/71 Art 3 applied to the GDPR; the controller's response duties (Art 12(3), 12(4)); and the Art 19 recipient notification duty. Out of scope, handed to the lawyer or a sibling domain: the content and form of the answer, Art 15(2)-(4), Art 17(2), Art 18(2)-(3), Art 20(2), Art 21(4)-(5), the grounds and content rules of Art 23(1)-(2), lawfulness under Arts 6 and 9, joint controllers and processors, remedies and fines.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6a0964641d4ee107...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `4f8c3a5b9cad7027...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6acc6d77b6847633...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `d54bba6c1503fdc6...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `8ffc3f847813407f...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `e998747fde48d7b3...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `735cc0fbeef553cf...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `ea38f3c329be6281...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `fa84ff95836abf60...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `cf9451469dd7aa34...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `c7d819a8ee942b7c...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `55a56126f24456ad...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `27a4c5d981f76151...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `359886d5081f218d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_response_duties){ .md-button }

## Provisions deferred, and what follows

??? info "art12_5_fee_amount"

    **Why:** Point (a) (a reasonable fee taking into account administrative costs) and point (b) (refuse to act) are the two alternatives of the Art 12(5) relief; the order reports the relief and the fee option as the CONDITIONS item reasonable_fee_may_be_charged (reading 5, Q4 RULED), not the controller's choice between them.

    **Consequence for a user:** The answer does not say whether the controller charges a reasonable fee (Art 12(5)(a)) or refuses to act (Art 12(5)(b)), nor what fee is reasonable: the caller decides that choice and checks that any fee reflects the administrative costs of the information, communication or action.

??? info "art15_2_to_15_4_safeguards_copy_and_rights_of_others"

    **Why:** Art 15(2) (information on Art 46 safeguards for a transfer), Art 15(3) (a copy; a reasonable fee for further copies) and Art 15(4) (the copy shall not adversely affect the rights and freedoms of others) shape the content and cost of the answer; Art 15(4) limits the copy and not the right (reading 7, Q16).

    **Consequence for a user:** The answer says whether access is owed, not what the copy must contain or cost: the caller checks the Art 15(2) information on transfer safeguards, the fee for further copies under Art 15(3), and that the copy does not adversely affect the rights and freedoms of others (Art 15(4)), for example by redacting third-party data.

??? info "art17_2_inform_other_controllers"

    **Why:** Where the controller made the data public and must erase, it shall take reasonable steps (taking account of available technology and cost) to inform controllers processing the data. A separate duty with its own reasonableness judgement; not scored (Q13).

    **Consequence for a user:** Where the controller must erase data it has made public, no answer includes the Art 17(2) duty to take reasonable steps to inform the other controllers processing the data of the erasure request: the caller checks whether the data were made public and what steps are reasonable, taking account of available technology and cost.

??? info "art23_1_grounds_of_restriction"

    **Why:** The ten grounds (national security, defence, public security, criminal law enforcement, other important public interests, judicial independence, regulated professions ethics, official-authority monitoring, protection of the data subject or others, civil law claims) that a restriction must safeguard are not formalized: whether a restriction applies is the OUTSIDE FACT legislative_restriction_applies_to_the_right.

    **Consequence for a user:** The grounds of Art 23(1)(a) to (j) are not checked: a restriction arrives only as the attested outside fact legislative_restriction_applies_to_the_right, so the caller, or whoever attests it, checks that the restricting measure safeguards one of those grounds. Without an attestation no restriction is assumed.

??? info "art23_2_content_of_a_restricting_measure"

    **Why:** The specific provisions any restricting legislative measure shall contain (purposes, categories of data, scope, safeguards, controllers, storage periods, risks, the right to be informed) are conditions on the Union or Member State measure, not on the controller; they are part of what the outside fact stands for.

    **Consequence for a user:** The answer does not check that the restricting Union or Member State measure contains what Art 23(2) requires (purposes, categories of data, scope, safeguards, storage periods, the right to be informed and the rest): whoever attests legislative_restriction_applies_to_the_right checks it, and the caller relies on that attestation.

??? info "art23_1_chapeau_essence_and_proportionality"

    **Why:** The words 'respects the essence of the fundamental rights and freedoms and is a necessary and proportionate measure in a democratic society' (Art 23(1)) and the extent to which the restriction reaches Arts 12-22, Art 34 and Art 5 are assessed by whoever attests the outside fact; not formalized.

    **Consequence for a user:** The answer does not assess whether a restriction respects the essence of the fundamental rights and is necessary and proportionate, or how far it reaches the right invoked (Art 23(1)): the caller relies on whoever attests legislative_restriction_applies_to_the_right to have checked that.

??? info "art22_3_safeguards_content"

    **Why:** The CONTENT of the safeguards (human intervention, express point of view, contest) is carried as the CONDITIONS atoms; their adequacy is not assessed.

    **Consequence for a user:** The answer does not check that the Art 22(3) safeguards (at least human intervention, the data subject's point of view and a way to contest the decision) are actually in place or adequate when the decision relies on Art 22(2)(a) or (c): the caller checks that.

??? info "art6_art9_lawfulness_and_special_categories"

    **Why:** whether the processing is lawful or rests on a given basis is the work of the siblings eu/data-protection/gdpr-art6-lawfulness and eu/data-protection/gdpr-special-categories; this order takes the answer as a profile fact (personal_data_unlawfully_processed, consent_is_the_basis_of_processing, processing_based_on_art6_1_e_or_f)

    **Consequence for a user:** The answer takes whether the processing is lawful, and on which Art 6 or Art 9 basis it rests, as facts stated in the profile: the caller establishes those facts under Arts 6 and 9 before relying on the answer.

??? info "art89_research_safeguards"

    **Why:** the safeguards for archiving, research and statistics arrive inside the judgements that read them; Art 89 is not pinned

    **Consequence for a user:** Whether the processing meets the Art 89(1) safeguards is folded into the archiving, research or statistics judgements: the caller assesses Art 89(1) itself before answering those judgements true.

??? info "regulation_1182_71_article_1_scope"

    **Why:** Article 1 limits Regulation (EEC, Euratom) No 1182/71 to acts of the Council or Commission; Regulation (EU) 2016/679 is an act of the European Parliament and of the Council. This order applies Article 3 to the periods of Regulation (EU) 2016/679 by analogy (a lawyer point, see PERIODS), so no rule reads Article 1.

    **Consequence for a user:** Every deadline this order gives rests on applying Article 3 of Regulation (EEC, Euratom) No 1182/71 to Regulation (EU) 2016/679, which Article 1 of that Regulation does not itself provide: a caller that relies on the date accepts that reading, or computes the period under the rule it holds applicable.

??? info "regulation_1182_71_article_2_public_holidays_and_working_days"

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal; Article 2(2) defines working days as all days other than public holidays, Sundays and Saturdays. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays, and PERIODS states the working day of the Article 3(4) shift itself.

    **Consequence for a user:** The caller attests in public_holidays the public holidays of the Member State or Community institution in which the action is to be taken (Article 2(1)); a public holiday missing from that list, or an absent list, leaves a deadline that falls on that day unmoved, one working day early.

??? info "art22_4_special_categories_bar"

    **Why:** The bar of Art 22(4) (decisions under Art 22(2) shall not rest on special categories unless Art 9(2)(a) or (g) applies with suitable safeguards) is read through the profile facts decision_based_on_special_categories and special_category_condition_and_safeguards_met_for_decision; the Art 9 conditions themselves are not applied here.

    **Consequence for a user:** The answer takes whether Art 9(2)(a) or (g) applies and whether suitable safeguards are in place as a fact stated in the profile: the caller establishes it under Art 9 before relying on the answer.

