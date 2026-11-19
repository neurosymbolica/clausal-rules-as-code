# For ONE customs line of goods the caller treats as goods listed in Annex I of Regulation (EU) 2023/956 (CBAM), whether one of the exclusions of Article 2 by use, origin ...

`eu/cbam/origin_exclusions`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 199/199 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE customs line of goods the caller treats as goods listed in Annex I of Regulation (EU) 2023/956 (CBAM), whether one of the exclusions of Article 2 by use, origin or place of production takes those goods outside the Regulation: goods for military activities (Art 2(3)), goods originating in a country or territory of Annex III point 1 (Art 2(4), Art 2(5)), electricity generated and hydrogen originating on the continental shelf or in the exclusive economic zone of a Member State or of an Annex III point 1 country or territory (Art 2(3a) points (a) and (b), Art 3 points (8) and (9)), or goods not originating in a third country (Art 2(1), Art 3 point (7)). One answer, the first exclusion the keys present decide, in the fixed order of THE LIMBS; a missing key is named, one at a time. Annex III is read as pinned on 20 October 2025. Out of scope: whether goods are Annex I goods (package P4), the non-preferential origin rules of Regulation (EU) No 952/2013 Art 59, the definition of military activities in Delegated Regulation (EU) 2015/2446, the law of the sea, the route of Art 2(2), the electricity exemption of Art 2(7) and Annex III point 2 (empty on the pin), and the application ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02023R0956 | 2025-10-20 | 2026-11-16 | `bec7227879be368c...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-16 | `0fc04c1d7ecd756e...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-16 | `196cbcacda2b105b...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-16 | `9f2891aa3288f9a7...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/cbam/origin_exclusions){ .md-button }

## Provisions deferred, and what follows

??? info "scope_route_continental_shelf_structures"

    **Why:** Art 2(2) applies the Regulation to goods brought to an artificial island or a structure on the continental shelf or in the exclusive economic zone of a Member State. It is a route into the Regulation, not an exclusion, and this order answers only the exclusions (reading (11)). Quoted because reading (11) relies on it.

    **Consequence for a user:** The answers never say whether goods enter the Regulation through Art 2(2).

??? info "listing_conditions_annex_iii_point_1"

    **Why:** Art 2(6) and its points state when a third country or territory 'shall be listed' in point 1 of Annex III. Listing is an act of the Commission (Art 2(11)); a caller does not apply the conditions (reading (6)). Quoted because reading (6) relies on it.

    **Consequence for a user:** A country that meets the conditions of Art 2(6) but is not listed in point 1 is not excluded by this order.

??? info "electricity_market_coupling_and_annex_iii_point_2"

    **Why:** Art 2(7) and its points (exemption of electricity from a market-coupled third country, 'provided that the Commission has assessed' the conditions), Art 2(8) (such a country 'shall be listed in point 2 of Annex III' and reports), Art 2(9) and its points (removal from point 2), Art 2(10) (delegated acts after removal) and Art 3, point (11) (market coupling) are assessments, listings and acts of the Commission. Point 2 of Annex III is an empty placeholder on the pin, so no country qualifies (reading (8), open question Q2). Art 2(7), lead, Art 2(8) and point 2 are quoted because reading (8) relies on them.

    **Consequence for a user:** The answers give no exclusion for electricity under Art 2(7) or through point 2 of Annex III; a later listing needs a new pin.

??? info "delegated_acts_and_agreements"

    **Why:** Art 2(11) empowers the Commission to amend the lists of Annex III by delegated act, and Art 2(12) lets the Union conclude agreements on carbon pricing for Art 9: acts of the Commission and the Union. Art 2(11) is quoted because reading (2) relies on it.

    **Consequence for a user:** The answers follow Annex III as pinned; a later delegated act is not seen until a new pin.

??? info "importation_and_customs_territory_definitions"

    **Why:** Art 3, point (4) (importation is release for free circulation) and point (6) (the customs territory of the Union is the territory defined in Article 4 of Regulation (EU) No 952/2013) are not read by any limb: the order takes origin and place of production as the caller's keys and never decides whether goods are imported. Point (6) is quoted because reading (9) relies on point (7), which uses its term.

    **Consequence for a user:** The answers never say whether goods are imported or where the customs territory ends.

??? info "application_dates"

    **Why:** Art 36(2), lead (the Regulation applies from 1 October 2023) and points (a) to (d) (later dates for named articles, Art 2(2) from 1 January 2026 under point (b)). The exclusions of Art 2(3), (3a) and (4) apply from the general date; the order has no date key (reading (2)) and does not answer Art 2(2) (reading (11)).

    **Consequence for a user:** The answers say nothing about the dates from which the articles apply.

