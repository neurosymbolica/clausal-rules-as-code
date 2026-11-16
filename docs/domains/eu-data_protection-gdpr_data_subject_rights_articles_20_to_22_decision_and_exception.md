# Whether a controller must comply with one data subject request of type portability (GDPR Art 20), objection (Art 21) or automated decision (Art 22), under Regulation ...

`eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 153/153 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether a controller must comply with one data subject request of type portability (GDPR Art 20), objection (Art 21) or automated decision (Art 22), under Regulation (EU) 2016/679 Arts 12(2)-(6), 20(1),(3),(4), 21(1),(2),(3),(6), 22(1)-(4) and 23(1) opening words. Decided: engagement of the right, the first relieving exception (Art 12(5), Art 12(2), Art 23 and the specific ones), and the Art 12(6) identity suspension. Out of scope and handed to the lawyer or a sibling order: access, rectification, erasure and restriction requests, the response period, Art 20(2), Arts 21(4)-(5), the grounds and content rules of Art 23, and the lawfulness of the processing under Arts 6 and 9.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `e998747fde48d7b3...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `735cc0fbeef553cf...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `ea38f3c329be6281...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `fa84ff95836abf60...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception){ .md-button }

## Provisions deferred, and what follows

??? info "art12_5_fee_amount"

    **Why:** Point (a) (a reasonable fee taking into account administrative costs) and point (b) (refuse to act) are the two alternatives of the Art 12(5) relief; the order reports the relief and the fee option as the CONDITIONS item reasonable_fee_may_be_charged (reading 5, Q4 RULED), not the controller's choice between them.

    **Consequence for a user:** The answer does not say whether the controller charges a reasonable fee (Art 12(5)(a)) or refuses to act (Art 12(5)(b)), nor what fee is reasonable: the caller decides that choice and checks that any fee reflects the administrative costs of the information, communication or action.

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

??? info "art20_1_engagement_conditions_as_profile_facts"

    **Why:** The conditions of Art 20(1) (data provided by the data subject, processing based on consent or contract, processing by automated means) are read from three profile flags; the technical format and the transmission without hindrance are not scored.

    **Consequence for a user:** The answer takes the three Art 20(1) conditions as facts stated in the profile and does not check the structured, commonly used and machine-readable format or that the transmission to another controller is without hindrance: the caller checks those.

??? info "art21_2_and_21_3_direct_marketing_as_profile_fact"

    **Why:** The right to object to direct marketing and its consequence (no further processing for such purposes) are read from the single flag processing_for_direct_marketing, with no balancing; the extent of profiling related to direct marketing and what ceasing the processing consists of are not modelled.

    **Consequence for a user:** The answer takes whether the processing is for direct marketing as a fact stated in the profile and says only that the controller must comply; the caller checks that profiling related to such marketing also stops and that the data are no longer processed for those purposes (Art 21(2), 21(3)).

??? info "art22_2_exceptions_as_profile_facts"

    **Why:** The three exceptions of Art 22(2) are read from a contract-necessity judgement, the attested outside fact on authorisation by law and the explicit-consent flag; whether the law also lays down suitable measures is folded into that outside fact.

    **Consequence for a user:** The answer takes the three Art 22(2) exceptions as facts stated or attested in the profile: the caller checks that the contract necessity is real, that the authorising law lays down suitable measures to safeguard the data subject, and that the consent is explicit.

??? info "art22_4_special_categories_bar"

    **Why:** The bar on decisions based on special categories is read from two profile flags (decision_based_on_special_categories and special_category_condition_and_safeguards_met_for_decision); whether point (a) or (g) of Art 9(2) really applies is not checked.

    **Consequence for a user:** The answer takes whether a special-category condition under Art 9(2)(a) or (g) and suitable safeguards are in place as a fact stated in the profile: the caller checks that under Art 9 before relying on the answer.

