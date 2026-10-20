# How much de minimis aid has an undertaking received in the rolling three-year window, and is it under the ceiling (Regulation (EU) 2023/2831)?

`eu/state_aid/de_minimis_cumulation`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 120/120 | enforced: 10 units: 4 formalized, 6 deferred (0 authorized, 6 expansion), 0 unaccounted | pass | pass | pass |

## Scope

Computes EU de minimis state-aid cumulation under Commission Regulation (EU) 2023/2831. For each reference date, sums the de minimis aid received by a single undertaking within the rolling three-year window ending on that date (grants whose date falls strictly after REF minus three calendar years and on or before REF; the window is counted in calendar years, not days, and a REF of 29 February starts it from 28 February three years earlier) and checks the total against the EUR 300,000 (30,000,000 euro-cent) ceiling. Inputs must be complete: a grants list or reference date that is unbound, a date that is not a date(Y, M, D), an amount that is not a non-negative integer of euro-cents, or a grant that is not a [DATE, AMOUNT] pair gives the verdict indeterminate and no window total (de_minimis_input_problem/3 names the first problem).

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32023R2831 | base act | 2026-09-09 | `070197f6116a93ed...` |

[Side-by-side provision report](../reports/eu-state_aid-de_minimis_cumulation.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/state_aid/de_minimis_cumulation){ .md-button }

## Provisions deferred, and what follows

??? info "single_undertaking_grouping"

    **Why:** Which legal entities form one single undertaking is supplied by the caller as a pre-grouped grant list; it is not derived here.

    **Consequence for a user:** If the caller passes the grants of only one entity of a group, the aid of the other linked entities is not counted, and the ceiling test can pass when it should fail.

??? info "sector_ceilings"

    **Why:** Only the general EUR 300 000 ceiling of Regulation 2023/2831 is applied.

    **Consequence for a user:** Aid to an undertaking in a sector with its own de minimis regulation is tested against the general ceiling, which can be the wrong line for that sector.

??? info "merger_and_split_allocation"

    **Why:** Art 3(8)-(9) say how prior de minimis aid is attributed when undertakings merge, are acquired or split. This domain takes the grant list as already attributed to the undertaking being assessed.

    **Consequence for a user:** After a merger, acquisition or split, the caller must build the grant list per Art 3(8)-(9). A list built otherwise gives a cumulation total for the wrong set of grants.

??? info "aid_amount_and_grant_date_inputs"

    **Why:** Art 3(3), 3(5) and 3(6) fix how an aid amount and its date are established: the moment the legal right is conferred, the gross grant equivalent, and the discounted value of instalments. Each grant arrives here as a date and an amount already established that way.

    **Consequence for a user:** The caller must supply, for each grant, the date the legal right was conferred and the gross grant equivalent discounted to that date. Payment dates, net amounts or undiscounted instalments give a wrong total.

??? info "article_headings"

    **Why:** The heading of Art 3 carries no obligation. Deferred so that every unit of the pinned extract is accounted for.

    **Consequence for a user:** None. A heading states no rule.

