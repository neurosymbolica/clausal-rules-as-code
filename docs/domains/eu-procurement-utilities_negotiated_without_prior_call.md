# May a utility negotiate without a prior call for competition (Directive 2014/25 Art 50)?

`eu/procurement/utilities_negotiated_without_prior_call`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 146/146 | enforced: 14 units: 10 formalized, 4 deferred (4 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |

## Scope

EU Directive 2014/25/EU Article 50 -- may a contracting entity use the negotiated procedure WITHOUT a prior call for competition? The chapeau makes points (a) to (j) an exhaustive gateway; a pleaded ground makes the use lawful only if the article admits it for this contract type AND its own cumulative conditions are made out. Every evaluative limb is an atomic input finding and an absent finding is NOT established (fail closed). Answers lawfulness of the PROCEDURE CHOICE only -- never whether the award itself, the notice, or the conduct of any earlier procedure was lawful. Inputs must be complete (ground) and well typed: utilities_negotiated_without_prior_call_input_problem/2 names the first problem (unbound variable, missing pleaded ground, a non-atom selector, an unknown contract type, a present flag that is not exactly true or false), and every entry point then gives no answer.

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014L0025 | 2026-01-01 | 2026-08-25 | `4bcfc05971b631d1...` |

[Side-by-side provision report](../reports/eu-procurement-utilities_negotiated_without_prior_call.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/procurement/utilities_negotiated_without_prior_call){ .md-button }

## Interpretive choices

Where the text admits more than one reading, the domain records the question, the readings and the one it takes.

??? note "proviso_attaches_to_points_ii_and_iii_only"

    The Art 50(c) proviso reads "The exceptions set out in points (ii) and (iii) shall only apply when no reasonable alternative or substitute exists and the absence of competition is not the result of an artificial narrowing down of the parameters of the procurement". Does it also condition point (i), a unique work of art or artistic performance?

    - **points_ii_and_iii_only** (chosen): A unique work of art is a complete ground on `only_particular_ operator_can_perform` alone. The proviso's own words name two points and the drafter listed them, so naming a third would be re-drafting.
    - **all_three_sub_points**, the more conservative reading: Every sole-operator plea would additionally need no reasonable alternative and no artificial narrowing. Stricter, and it would catch an entity commissioning a bespoke artwork to escape competition -- but it reads a restriction into a sentence that enumerates its own targets.

    **Why this reading:** The sentence names points (ii) and (iii) and no others. This is the clearest textual signal in the article, and Directive 2014/24 Art 32(2)(b) attaches its identical proviso the same way -- one of the genuine points of continuity between the two instruments.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "contract_type_words_are_jurisdictional_limits"

    Four grounds open with a contract type -- "in the case of supply contracts" (e), "for supplies" (g) and (h), "where the service contract concerned" (j). Are those words a LIMIT on the ground's availability, or a description of the usual case?

    - **limits** (chosen): A ground pleaded outside its type is unavailable however well its other conditions are made out, so contract_type_key is decisive on four of the ten grounds.
    - **descriptive**: The type words would constrain nothing and the four grounds would be available for any contract. More permissive -- it would let an entity plead the bargain-purchase ground for a works contract -- and it would make the drafter's decision to name a type in four grounds and not in the other six meaningless.

    **Why this reading:** The article names a contract type in exactly four of ten grounds. A reading on which that choice changes nothing cannot explain why the drafter made it four times and not ten or zero. The permissive reading is also the one that expands a derogation, which cuts against the settled rule that derogations from the obligation to compete are strictly interpreted.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "the_pleaded_ground_governs"

    If the entity pleads ground X and X is not made out, but the conditions of some other ground Y happen to be satisfied on the same facts, is the use lawful?

    - **plea_governs** (chosen): `use_unlawful`. The verdict answers the ground actually relied on, and the interface returns `n_a` for GROUND. A reviewer can always re-run the domain pleading Y.
    - **any_available_ground_saves_it**: `use_lawful` on Y. More permissive, and it would make the profile's pleaded_ground_key inert -- the domain would answer "is ANY ground made out", which is a different question from the one an award notice's justification poses.

    **Why this reading:** The justification an entity files names a ground, and review of it is review of THAT ground; the burden of establishing a derogation lies on the party relying on it. Treating any latent ground as a save would also mean an entity that pleaded nothing coherent could be rescued by a ground it never invoked and may not have evidenced. RECORDED AS CONTESTABLE because an administrative court applying the objective-lawfulness of the award, rather than reviewing the stated reasons, might well take the other view.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "the_unsuitability_sentences_are_definitions_not_limbs"

    Art 50(a) is followed by two sentences defining when a tender, and when a request to participate, is "not suitable". Are those additional cumulative conditions of the ground, or definitions of the finding the ground already requires?

    - **definitions** (chosen): The ground has two conditions -- unsuitability and unaltered initial conditions -- and the definitions fix what the first one MEANS. The profile carries one finding, `no_suitable_tenders_or_requests_received`.
    - **additional_limbs**, the more conservative reading: The profile would carry separate findings for irrelevance, manifest incapability, exclusion under Arts 78(1)/80(1) and failure of selection criteria, each independently required. Stricter, and it would make the ground harder to establish -- but it would also require this domain to decide Arts 78/80 questions it explicitly defers.

    **Why this reading:** The sentences are drafted as definitions ("shall be considered not to be suitable where...") and they define a term the ground uses, rather than adding a requirement to it. Treating them as limbs would import the Arts 78/80 determinations this domain defers, which would make the ground undecidable on the facts the profile carries.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

## Provisions deferred, and what follows

??? info "unsuitability_determination_by_reference_to_arts_78_and_80"

    **Why:** Art 50(a) defines an unsuitable REQUEST by reference to exclusion under Arts 78(1)/80(1) or failure of the selection criteria laid down under Arts 78 or 80. Those are sibling determinations; here unsuitability is the atomic input the definition describes.

    **Consequence for a user:** A caller must establish unsuitability itself, under Arts 78/80. This domain takes the finding as given and will report `use_lawful` on an (a) plea whose unsuitability claim would not survive those articles.

??? info "article_44_1_procedure_choice"

    **Why:** Art 50(f) requires the first contract to have been awarded under a procedure in accordance with Article 44(1). Whether it was is a separate determination.

    **Consequence for a user:** A caller must verify the earlier procedure itself. This domain reads `original_contract_followed_article_44_1_procedure` as an atomic finding and cannot detect a false one.

??? info "articles_15_and_16_estimated_value_aggregation"

    **Why:** Art 50(f) requires the total estimated cost of subsequent works or services to be taken into consideration when the entity applies Arts 15 and 16. A threshold-aggregation duty attached to the ground, not a condition of it.

    **Consequence for a user:** A caller must run the Arts 15-16 aggregation itself. Nothing here reads a value, so this domain cannot notice an entity that ignored it.

??? info "design_contest_conduct"

    **Why:** Art 50(j) requires the contest to have been organised in accordance with this Directive and the award to follow the contest's own rules. The conduct of a design contest is a separate determination (cf. eu/procurement/design_contests for the Directive 2014/24 equivalent).

    **Consequence for a user:** A caller must check the contest's conduct itself; this domain reads it as an atomic finding.

??? info "national_transposition"

    **Why:** A Member State may transpose narrower grounds or add procedural conditions. Directive level only.

    **Consequence for a user:** A caller in a Member State with narrower grounds must apply those itself. This domain will report `use_lawful` on a ground the Directive allows and the national transposition does not.

