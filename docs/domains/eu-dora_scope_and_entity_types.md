# Who is within the scope of Regulation (EU) 2022/2554 (the Digital Operational Resilience Act, DORA), and as which type of entity, from the original OJ text (32022R2554): ...

`eu/dora_scope_and_entity_types`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 245/245 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Who is within the scope of Regulation (EU) 2022/2554 (the Digital Operational Resilience Act, DORA), and as which type of entity, from the original OJ text (32022R2554): Article 2(1) points (a) to (u), Article 2(2) (financial entities), the exclusions of Article 2(3) points (a) to (f) and the option of the Member States in the first sentence of Article 2(4), read with Article 3 points (19), (32), (36), (39), (60), (63) and (64). For ONE entity of ONE type stated by the caller, dora_scope_decision/3 answers in_scope(TYPE) or out_of_scope, and dora_entity_category/3 answers financial_entity, ict_third_party_service_provider or out_of_scope, each with fixed citations; an absent key the answer needs gives indeterminate([KEY]) and a badly formed profile gives input_problems(PROBLEMS). Out of scope: whether an entity meets the definition of a type in the Union act Article 3 refers to (the caller's classification), the relation to Article 4 of Directive (EU) 2022/2555 (NIS2), the duties of an entity in scope, the notice and publication duties of Article 2(4), second and third sentences, and the date of application (Article 64). Every reading is the drafter's, not a lawyer's.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `88328cd00a7a11d6...` |
| CELEX 32022R2554 | as pinned | 2026-11-20 | `f05d65fd5046b721...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_scope_and_entity_types){ .md-button }

## Provisions deferred, and what follows

??? info "member_state_notice_and_publication"

    **Why:** Art 2(4), first sentence, the option of a Member State to exclude the institutions of Article 2(5), points (4) to (23), of Directive 2013/36/EU located in its territory, is formalised through exempted_from_dora_scope_by_member_state (reading (8)). Not formalised: the second sentence (the Member State informs the Commission of its use of the option and of later changes) and the third sentence (the Commission makes that information publicly available).

    **Consequence for a user:** The answers take the exclusion as the caller states it; the order does not check the notice to the Commission or its publication.

??? info "type_definitions_by_reference"

    **Why:** These points of Article 3 define the types of Art 2(1) (credit institution, investment firm, payment institution, account information service provider, electronic money institution, central counterparty, trade repository, central securities depository, trading venue, manager of alternative investment funds, management company, data reporting service provider, insurance and reinsurance undertaking, the three kinds of insurance intermediary, institution for occupational retirement provision, credit rating agency, crypto-asset service provider, issuer of asset-referenced tokens, administrator of critical benchmarks, crowdfunding service provider and securitisation repository) by reference to other Union acts, which are not pinned here. Whether an entity meets one of them is the caller's classification, stated in dora_entity_type (reading (2)).

    **Consequence for a user:** The order takes the type as given; it does not test the definition in the act referred to.

