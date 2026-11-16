# Regulation (EU) 2016/679 (GDPR), consolidated text 02016R0679-20160504. Decided here: whether a controller must comply with ONE data subject request for ERASURE ...

`eu/data_protection/gdpr_data_subject_rights_erasure`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 215/215 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), consolidated text 02016R0679-20160504. Decided here: whether a controller must comply with ONE data subject request for ERASURE (request_type erasure only; split 2026-11-03 of the order gdpr-data-subject-rights): the engagement of the right under Art 17(1)(a)-(f) (BASIS the first met ground), the exceptions of Art 17(3)(a)-(e) (whole-request relief, Q5), the manifestly unfounded or excessive relief of Art 12(5) with the condition reasonable_fee_may_be_charged, the unable-to-identify relief of Art 12(2) second sentence, a legislative restriction under Art 23(1) (attested outside fact, blocking) and the Art 12(6) identity suspension (non-final). Out of scope: the other request types (sibling orders), the response period and duties of Art 12(3) and 12(4), Art 17(2), the grounds of Art 23(1)(a)-(j) and the content rules of Art 23(2). Open-textured judgements given as unsure and an unattested Art 17(1)(e) legal obligation are handed to a lawyer as needs_legal_review.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6acc6d77b6847633...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `fa84ff95836abf60...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_erasure){ .md-button }

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

??? info "art6_art9_lawfulness_and_special_categories"

    **Why:** whether the processing is lawful or rests on a given basis is the work of the siblings eu/data-protection/gdpr-art6-lawfulness and eu/data-protection/gdpr-special-categories; this order takes the answer as a profile fact (personal_data_unlawfully_processed, consent_is_the_basis_of_processing, processing_based_on_art6_1_e_or_f)

    **Consequence for a user:** The answer takes whether the processing is lawful, and on which Art 6 or Art 9 basis it rests, as facts stated in the profile: the caller establishes those facts under Arts 6 and 9 before relying on the answer.

??? info "art89_research_safeguards"

    **Why:** the safeguards for archiving, research and statistics arrive inside the judgements that read them; Art 89 is not pinned

    **Consequence for a user:** Whether the processing meets the Art 89(1) safeguards is folded into the archiving, research or statistics judgements: the caller assesses Art 89(1) itself before answering those judgements true.

