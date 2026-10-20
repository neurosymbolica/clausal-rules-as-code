# Predicate Signatures — eu_aml_amlr_beneficial_ownership_threshold

## Public predicates

`beneficial_ownership_threshold(THRESHOLD_BP)`: unifies THRESHOLD_BP with the integer
    constant **2500**, representing the Art 52(1) 25% threshold in basis points
    (1 bp = 0.01%; 10 000 bp = 100%).  This is the sole threshold boundary at which
    a natural person qualifies as a beneficial owner of a corporate or other legal entity.

`effective_ownership_interest(PERSON, ENTITY, GRAPH, INTEREST_BP)`: given PERSON
    (atom identifying a natural person), ENTITY (atom identifying the target legal
    entity), and GRAPH (list of `holding(Holder, Held, InterestBP)` terms describing
    every direct stake in the ownership structure), unifies INTEREST_BP with the
    aggregate effective ownership interest of PERSON in ENTITY expressed in basis
    points.  Computed by (a) enumerating all acyclic directed paths from PERSON to
    ENTITY in GRAPH, (b) multiplying the basis-point interests along each path
    (renormalising by 10 000 at each step), and (c) summing the per-path products
    across all paths — implementing the Art 52 chain-multiplication / parallel-chain-
    addition rule.

`beneficial_owner_status(PERSON, ENTITY, GRAPH, STATUS)`: unifies STATUS with the
    shared terminal-triple atom `eligible` (a beneficial owner) when
    `effective_ownership_interest/4` yields an INTEREST_BP ≥ 2500 (inclusive, per
    "25% or more" in Art 52(1)); unifies STATUS with `ineligible` (not a
    beneficial owner) otherwise.

## Support predicates (internal — not part of the public API)

`all_paths(PERSON, ENTITY, GRAPH, PATHS)`: enumerates all acyclic directed paths
    (lists of node atoms) from PERSON to ENTITY in GRAPH; used by
    `effective_ownership_interest/4` to collect chains for summation.

`chain_interest_bp(PATH, GRAPH, PRODUCT_BP)`: given a PATH (ordered list of atoms
    from source to target) and GRAPH, unifies PRODUCT_BP with the integer result of
    multiplying the basis-point interests of consecutive `holding/3` edges along PATH,
    renormalising by dividing by 10 000 after each multiplication to maintain integer
    basis-point scale.

`direct_holding_bp(HOLDER, HELD, GRAPH, INTEREST_BP)`: unifies INTEREST_BP with the
    sum of all `holding(HOLDER, HELD, I)` facts present in GRAPH (handles the case
    where a holder has multiple separately-listed stakes in the same entity); yields 0
    if no such fact exists.
