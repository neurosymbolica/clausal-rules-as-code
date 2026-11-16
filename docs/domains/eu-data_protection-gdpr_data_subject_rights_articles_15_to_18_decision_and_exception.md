# Regulation (EU) 2016/679 (GDPR), Art 12(2) second sentence, Art 12(5), Art 12(6), Art 15(1), Art 16, Art 17(1) and (3), Art 18(1) and Art 23(1): for one data subject ...

`eu/data_protection/gdpr_data_subject_rights_articles_15_to_18_decision_and_exception`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 218/218 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), Art 12(2) second sentence, Art 12(5), Art 12(6), Art 15(1), Art 16, Art 17(1) and (3), Art 18(1) and Art 23(1): for one data subject request whose request_type is access, rectification, erasure or restriction, whether the controller must comply (the right invoked is engaged, no exception relieves the controller and the Art 12(6) identity suspension does not hold) and which exception, if any, relieves it (request_decision/2 and request_exception/2), behind the input check of the typed contract. Decided here: the engagement of each of the four rights, the Art 17(3) exceptions, the common exceptions of Art 12(5), Art 12(2) and Art 23(1), the Art 12(6) suspension, missing required facts (every one is named) and referrals. Explicitly out of scope: portability, objection and automated decisions (Arts 20 to 22, a sibling order), the response period of Art 12(3) and the response duties of Art 12(4) (sibling orders), the content and cost of the answer (Art 15(1)(a)-(h), Art 15(2)-(4)), Art 17(2), Art 18(2)-(3), the grounds of Art 23(1)(a)-(j) and Art 23(2). Every open-textured judgement the user marks unsure, and an unattested Union or Member State law ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6a0964641d4ee107...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `4f8c3a5b9cad7027...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6acc6d77b6847633...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `d54bba6c1503fdc6...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `fa84ff95836abf60...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_articles_15_to_18_decision_and_exception){ .md-button }

## Provisions deferred, and what follows

??? info "art12_5_fee_amount"

    **Why:** Point (a) (a reasonable fee taking into account administrative costs) and point (b) (refuse to act) are the two alternatives of the Art 12(5) relief; the order reports the relief and the fee option as the CONDITIONS item reasonable_fee_may_be_charged (reading 5, Q4 RULED), not the controller's choice between them.

    **Consequence for a user:** The answer does not say whether the controller charges a reasonable fee (Art 12(5)(a)) or refuses to act (Art 12(5)(b)), nor what fee is reasonable: the caller decides that choice and checks that any fee reflects the administrative costs of the information, communication or action.

??? info "art15_2_to_15_4_safeguards_copy_and_rights_of_others"

    **Why:** Art 15(2) (information on Art 46 safeguards for a transfer), Art 15(3) (a copy; a reasonable fee for further copies) and Art 15(4) (the copy shall not adversely affect the rights and freedoms of others) shape the content and cost of the answer; Art 15(4) limits the copy and not the right (reading 7, Q16).

    **Consequence for a user:** The answer says whether access is owed, not what the copy must contain or cost: the caller checks the Art 15(2) information on transfer safeguards, the fee for further copies under Art 15(3), and that the copy does not adversely affect the rights and freedoms of others (Art 15(4)), for example by redacting third-party data.

??? info "art23_1_grounds_of_restriction"

    **Why:** The ten grounds (national security, defence, public security, criminal law enforcement, other important public interests, judicial independence, regulated professions ethics, official-authority monitoring, protection of the data subject or others, civil law claims) that a restriction must safeguard are not formalized: whether a restriction applies is the OUTSIDE FACT legislative_restriction_applies_to_the_right.

    **Consequence for a user:** The grounds of Art 23(1)(a) to (j) are not checked: a restriction arrives only as the attested outside fact legislative_restriction_applies_to_the_right, so the caller, or whoever attests it, checks that the restricting measure safeguards one of those grounds. Without an attestation no restriction is assumed.

??? info "art23_2_content_of_a_restricting_measure"

    **Why:** The specific provisions any restricting legislative measure shall contain (purposes, categories of data, scope, safeguards, controllers, storage periods, risks, the right to be informed) are conditions on the Union or Member State measure, not on the controller; they are part of what the outside fact stands for.

    **Consequence for a user:** The answer does not check that the restricting Union or Member State measure contains what Art 23(2) requires (purposes, categories of data, scope, safeguards, storage periods, the right to be informed and the rest): whoever attests legislative_restriction_applies_to_the_right checks it, and the caller relies on that attestation.

??? info "art23_1_chapeau_essence_and_proportionality"

    **Why:** The words 'respects the essence of the fundamental rights and freedoms and is a necessary and proportionate measure in a democratic society' (Art 23(1)) and the extent to which the restriction reaches Arts 12-22, Art 34 and Art 5 are assessed by whoever attests the outside fact; not formalized.

    **Consequence for a user:** The answer does not assess whether a restriction respects the essence of the fundamental rights and is necessary and proportionate, or how far it reaches the right invoked (Art 23(1)): the caller relies on whoever attests legislative_restriction_applies_to_the_right to have checked that.

??? info "art6_art9_lawfulness_and_special_categories"

    **Why:** whether the processing is lawful or rests on a given basis is the work of the siblings eu/data-protection/gdpr-art6-lawfulness and eu/data-protection/gdpr-special-categories; this order takes the answer as a profile fact (personal_data_unlawfully_processed, consent_is_the_basis_of_processing, processing_based_on_art6_1_e_or_f)

    **Consequence for a user:** The answer takes whether the processing is lawful, and on which Art 6 or Art 9 basis it rests, as facts stated in the profile: the caller establishes those facts under Arts 6 and 9 before relying on the answer.

??? info "art89_research_safeguards"

    **Why:** the safeguards for archiving, research and statistics arrive inside the judgements that read them; Art 89 is not pinned

    **Consequence for a user:** Whether the processing meets the Art 89(1) safeguards is folded into the archiving, research or statistics judgements: the caller assesses Art 89(1) itself before answering those judgements true.

