# Directive (EU) 2022/2555 (NIS 2), original OJ text, Art 26(1) to (3), Art 27(1) to (3) and Art 3(3) and (4). Decided here, for an entity whose category the caller gives: ...

`eu/nis2_jurisdiction_registration`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 216/216 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Directive (EU) 2022/2555 (NIS 2), original OJ text, Art 26(1) to (3), Art 27(1) to (3) and Art 3(3) and (4). Decided here, for an entity whose category the caller gives: the basis of its jurisdiction (never the Member State itself), the step of Art 26(2) that fixes the main establishment of a provider named in Art 26(1)(b), the information it must submit for the ENISA registry (Art 27(2)) and for the Member States list of entities (Art 3(4)), and the limits for notifying changes (Art 27(3), Art 3(4) second subparagraph), listed and not computed. Unsure judgements on Art 26(2) are referred to a lawyer. Out of scope: whether the entity is in scope and which category it falls in (sibling order on scope), the authorities duties, the national register and channel (country orders), calendar computation of periods (Regulation 1182/71), and whether an initial submission was on time.

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

??? info "registry_submission_chapeau_and_initial_date"

    **Why:** The chapeau of Art 27(2) ('Member States shall require entities referred to in paragraph 1 to submit the following information to the competent authorities by 17 January 2025') binds the Member States and sets the date of the initial submission. The date has passed and no query gives or checks it (reading (6)); the information items themselves are formalized through points (a) to (f) (32022L2555#point_027.002_a to _f), and the entities addressed through the list of Art 27(1) (reading (6)).

    **Consequence for a user:** The answers list what an entity of Art 27(1) must submit; they do not say whether an initial submission was on time.

