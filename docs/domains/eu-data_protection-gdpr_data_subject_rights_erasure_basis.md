# Which Art 17(1) ground (a)-(f) of Regulation (EU) 2016/679 engages an erasure request, once the Art 17(3) exceptions, the Art 12(2) and 12(5) reliefs, the Art 12(6) ...

`eu/data_protection/gdpr_data_subject_rights_erasure_basis`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 130/130 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Which Art 17(1) ground (a)-(f) of Regulation (EU) 2016/679 engages an erasure request, once the Art 17(3) exceptions, the Art 12(2) and 12(5) reliefs, the Art 12(6) identity suspension and an Art 23 legislative restriction are applied. Decides only profiles with request_type erasure. Out of scope and handed to the lawyer or a sibling order: Art 17(2), the response period, the fee amount, Arts 6, 9 and 89 lawfulness, the grounds and content of an Art 23 measure.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6acc6d77b6847633...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `fa84ff95836abf60...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_erasure_basis){ .md-button }

## Provisions deferred, and what follows

??? info "art6_art9_lawfulness_and_special_categories"

    **Why:** whether the processing is lawful or rests on a given basis is the work of the siblings eu/data-protection/gdpr-art6-lawfulness and eu/data-protection/gdpr-special-categories; this order takes the answer as a profile fact (personal_data_unlawfully_processed, consent_is_the_basis_of_processing, processing_based_on_art6_1_e_or_f)

    **Consequence for a user:** The answer takes whether the processing is lawful, and on which Art 6 or Art 9 basis it rests, as facts stated in the profile: the caller establishes those facts under Arts 6 and 9 before relying on the answer.

??? info "art89_research_safeguards"

    **Why:** the safeguards for archiving, research and statistics arrive inside the judgements that read them; Art 89 is not pinned

    **Consequence for a user:** Whether the processing meets the Art 89(1) safeguards is folded into the archiving, research or statistics judgements: the caller assesses Art 89(1) itself before answering those judgements true.

??? info "art12_5_art12_6_art17_formalized_in_request_basis"

    **Why:** These units are the operative core of the order and are modelled in request_basis.clausal (the six Art 17(1) grounds, the Art 17(3) exceptions, the Art 12(5) relief and the Art 12(6) suspension), each citing its citations.clausal record. They are listed here so the ledger accounts for them as modelled rules.

    **Consequence for a user:** None beyond the verdict itself: the grounds, exceptions, relief and suspension are decided by request_basis/2 and carry their cite(...) terms.

