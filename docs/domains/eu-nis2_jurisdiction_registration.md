# Which Member State's jurisdiction an entity falls under (Directive (EU) 2022/2555 Art 26(1)-(3)), where the main establishment of a Union provider is (Art 26(2)), what ...

`eu/nis2_jurisdiction_registration`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 176/176 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Which Member State's jurisdiction an entity falls under (Directive (EU) 2022/2555 Art 26(1)-(3)), where the main establishment of a Union provider is (Art 26(2)), what the entity must submit to the registry (Art 27(2)) and for the Member States' list of entities (Art 3(4)), and the limits for notifying changes (Art 27(3), Art 3(4)). The Directive binds the Member States; this domain states what it requires. Out of scope (handed to the lawyer or a sibling domain): whether the entity is in scope and its category (sibling order on scope), calendar computation of the periods, national registers, forms and channels.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022L2555 | as pinned | 2026-11-11 | `5a7a1cd80dd108cc...` |
| CELEX 32022L2555 | as pinned | 2026-11-11 | `3fbb759d72fdef69...` |
| CELEX 32022L2555 | as pinned | 2026-11-11 | `286a52a5e9c47552...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/nis2_jurisdiction_registration){ .md-button }

## Provisions deferred, and what follows

??? info "essential_and_important_entities"

    **Why:** Art 3(1) and (2) say which entities are essential and which important. They are to be formalized by the sibling order on scope and entity class (eu/nis2-scope-entity-class, package P1), whose ledger must formalize these units; this order takes the entity as given.

    **Consequence for a user:** None for a caller of this order: the caller establishes the entity class first.

??? info "designation_without_prejudice_to_legal_actions"

    **Why:** Art 26(4) says that designating a representative does not prevent legal actions against the entity itself. It adds no condition to any answer of this order and yields no result a query could return.

    **Consequence for a user:** The answers do not say what legal action may be brought; the caller must not read state_of_representative as excluding action against the entity.

??? info "national_registration_mechanism"

    **Why:** Art 27(5) says the information is submitted through the national mechanism referred to in Art 3(4) fourth subparagraph, where applicable. Whether a national mechanism exists, and what it is, is national law.

    **Consequence for a user:** The answers say what is to be submitted, not where; the country orders give the channel.

??? info "registry_initial_submission_date"

    **Why:** The opening words of Art 27(2) require Member States to have entities submit the information of points (a) to (f) by 17 January 2025. The items themselves are formalized through points (a) to (f) of Art 27(2) (registry_submission_items/2, each item carrying its cite(eu_dir_2022_2555_art_27_2_x)); the date has passed and no query gives or checks a date (reading (6)), so the opening words add no result of their own.

    **Consequence for a user:** The answers list what is to be submitted, not whether an initial submission was on time; the caller judges the date.

