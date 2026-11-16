# Regulation (EU) 2023/956 (CBAM), consolidated as amended to 2025-10-20, Art 2a(1), (2) and (4), read with Art 2(1), Art 3 point (15), Annex I point 1 and its Electricity ...

`eu/cbam/de_minimis`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 188/188 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2023/956 (CBAM), consolidated as amended to 2025-10-20, Art 2a(1), (2) and (4), read with Art 2(1), Art 3 point (15), Annex I point 1 and its Electricity division, and Annex VII point 1. Decided here: (a) for ONE importer and ONE calendar year, whether the single mass-based de minimis exemption applies, on the caller's figures of net mass in whole kilograms of the importer's Annex I goods other than electricity and hydrogen, compared (not more than) with 1000 times the threshold in tonnes the caller states for the year; (b) for ONE import, whether its goods are outside the exemption (electricity, hydrogen), counted toward the threshold, or not goods of this Regulation. Which date puts an import into a year is not chosen: an unsure date basis that decides goes to a lawyer (needs_legal_review). Out of scope: the Commission's review of the threshold (Art 2a(3), Annex VII point 2), the exclusions of Art 2(2) to (12), CN-code classification under Annex I, who is the importer, authorised CBAM declarant status (Arts 4, 5, 17) and the annual CBAM declaration (Art 6).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02023R0956 | 2025-10-20 | 2026-11-12 | `1ad99cad56d6d497...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-12 | `f59bde74b39a9da4...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-12 | `0fc04c1d7ecd756e...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-12 | `33d66ba24374be03...` |
| CELEX 02023R0956 | 2025-10-20 | 2026-11-12 | `533586087313c429...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/cbam/de_minimis){ .md-button }

## Provisions deferred, and what follows

??? info "scope_exclusions_and_third_country_lists"

    **Why:** Art 2(2) to (12): goods brought to installations on the continental shelf or in the exclusive economic zone, the military exclusion, the continental-shelf exclusion for electricity and hydrogen (Art 2(3a)), the exclusion of the countries of point 1 of Annex III, non-preferential origin, and the lists of Annex III and the Commission's powers to change them. They decide whether the Regulation applies to goods at all; this order leaves them to the caller (reading (9), Q3). A later package (P5) is to formalise them.

    **Consequence for a user:** A caller whose goods are excluded under Art 2 does not count them and does not give them as other_annex_i_goods; the order does not check this.

??? info "annex_i_classification_and_greenhouse_gases"

    **Why:** Which goods are listed in Annex I is a lookup of the CN code in the table of Annex I, point 1; point 2 names the greenhouse gases for each good. The order does not classify goods: the caller states goods_kind and adds up the figures (reading (9)). The Chemicals division is quoted because reading (3) relies on its one entry being hydrogen. The unit the corpus reader names point_annex_i-fertilisers_72 holds the first row of the Iron and steel division (CN 72, with its exceptions); the reader places it under the Fertilisers division. Greenhouse gases are outside this order.

    **Consequence for a user:** The answers never say whether a CN code is listed in Annex I; the caller's goods_kind and figures carry that.

