# Regulation (EU) 2016/679 (GDPR), Arts 20 to 22 with the Art 12(2) second sentence, 12(5), 12(6) and the Art 23(1) restriction: for ONE data subject request whose ...

`eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 251/251 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), Arts 20 to 22 with the Art 12(2) second sentence, 12(5), 12(6) and the Art 23(1) restriction: for ONE data subject request whose request_type is portability (Art 20), objection (Art 21, claim-driven by objection_ground_claimed: art21_1, art21_2 or art21_6) or automated_decision (Art 22), decides whether the controller must comply (must_comply / need_not_comply, or the non-final statuses indeterminate, needs_legal_review, suspended under Art 12(6), input_problems) and which exception relieves it (Art 20(3) second sentence, Art 20(4), Art 21(1) compelling grounds and legal claims, Art 21(6) public-interest task, Art 22(2)(a)-(c) subject to the Art 22(4) bar, Art 12(5), Art 12(2), Art 23). Out of scope: access, rectification, erasure and restriction (sibling order), the response period and the Art 19 communication, Art 12(3) and 12(4) response duties, the Art 23(1)(a)-(j) grounds and Art 23(2) content (attested outside fact), Art 20(2), Art 21(4)-(5), the adequacy of the Art 22(3) safeguards, and every open-textured judgement, which is handed to the user or a lawyer.

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

??? info "art22_exceptions_and_bar_without_an_order_citation_key"

    **Why:** The Art 22(2)(b) and (c) exceptions and the Art 22(4) bar ARE decided in request_exception.clausal (exception rows art22_2_b and art22_2_c, special_category_bar), under the package citation keys eu_reg_2016_679_art_22_2_b, eu_reg_2016_679_art_22_2_c and eu_reg_2016_679_art_22_4; the order's citation table names no key for these units (point (a) has one), so the provision ledger cannot count them as formalized. Recorded here for ledger accounting only (reading 15, Q8 RULED).

    **Consequence for a user:** None in the answers: an authorising law (attested outside fact) or explicit consent relieves the controller unless the Art 22(4) bar applies, as reading 15 states; the caller relies on that reading, not on a ledger key.

