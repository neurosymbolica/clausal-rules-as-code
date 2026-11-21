# For one aid measure (a scheme, individual aid under a scheme, or ad hoc aid) and the undertaking receiving it, the GENERAL conditions of Chapter I of Commission ...

`eu/state_aid/gber_general_conditions`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 219/219 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For one aid measure (a scheme, individual aid under a scheme, or ad hoc aid) and the undertaking receiving it, the GENERAL conditions of Chapter I of Commission Regulation (EU) No 651/2014 (GBER) in the text applicable from 1 July 2023: scope and exclusions (Art 1(2) to (5), with Art 2(18)), a slice of eleven notification thresholds (Art 4(1) rows (c), (d), (e), (i)(i) to (iv), (i)(vi), (l), (m), (n), (s), with Art 8(1)), transparency (Art 5), incentive effect (Art 6) and cumulation (Art 8(3) and 8(5)), each answered alone and joined under Art 3. No answer says that aid is exempted: Chapter III, Art 9 (publication), the computation of amounts under Art 7, the other rows of Art 4(1), Art 8(4), 8(6) and 8(7) are not tested. Open-textured judgements (excluded schemes, export aid, separation of activities, undertaking in difficulty, violation of Union law, the general transparency test) are handed to a lawyer when unsure; the size of the undertaking comes from the SME order's answer, passed by the caller.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `aeec34278eba28d7...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `344cb75c56cb49c7...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `64e0fdb4cc12a8fd...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `2282c643c2675421...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `93bf7afe778af540...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `ed6b6bd16bbbf023...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `2caf6d6ebbea5fa7...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `0c06ed57dd8d3911...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `71afd36374c5b256...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `0bdd1726c4343e3e...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/state_aid/gber_general_conditions){ .md-button }

## Provisions deferred, and what follows

??? info "categories_of_aid"

    **Why:** Art 1(1) lists the categories of aid to which the Regulation applies. No limb reads the category except through article_4_category for the threshold slice; which category the aid belongs to is the caller's.

    **Consequence for a user:** The answers do not test that the aid is in a category of Art 1(1); Chapter III is not in this order (reading (1)).

??? info "sector_exceptions_list"

    **Why:** The indents of Art 1(3)(a) list the exceptions for the fishery and aquaculture sector. The caller states whether the aid is one of them (sector_exception_applies, condition A3); the order does not classify the aid itself.

    **Consequence for a user:** The answers rest on the caller's sector_exception_applies.

??? info "nuclear_energy"

    **Why:** Art 1(6) excludes nuclear energy production measures from Chapter III Section 7 only; it is a condition of that Section, not of Chapter I's general conditions this order tests.

    **Consequence for a user:** The answers never test Art 1(6); a caller checks it with Section 7.

??? info "undertaking_in_difficulty_tests"

    **Why:** Art 2(18)(a) to (e) are the tests of an undertaking in difficulty (share capital lost, insolvency, rescue and restructuring aid, debt to equity and interest cover). They need accounting facts; the caller applies them and states undertaking_in_difficulty as a judgement (reading (5)).

    **Consequence for a user:** The answers rest on the caller's judgement undertaking_in_difficulty.

??? info "definitions_read_by_readings"

    **Why:** Art 2(2) (SMEs), 2(23) (start of works), 2(24) (large enterprises), 2(26) (aid intensity) and 2(28) (date of granting) give the meaning of terms the readings use; the order applies them through the caller's size_class, dates and figures (readings (3), (8), (9), (12)).

    **Consequence for a user:** The answers rest on the caller's size_class, dates and figures.

??? info "other_definitions"

    **Why:** The other definitions of Art 2 (with its lead-in) serve Chapter III or terms no limb of this order reads. Definitions deleted by amending acts are placeholders in the pin and their text is not in it.

    **Consequence for a user:** None for a caller of this order: no answer turns on them.

??? info "thresholds_outside_the_slice"

    **Why:** The rows of Art 4(1) other than (c), (d), (e), (i)(i) to (iv), (i)(vi), (l), (m), (n) and (s) are not formalised: row (a) (regional investment aid) needs the maximum regional aid intensity of the map as a caller fact and was left out of this order; point (i)(v) increases the research figures by 50 % for certain repayable advances and is not formalised; the other rows refer to amounts in other Articles, count per year, per scheme or per infrastructure, or depend on total costs. Points (t) and (u), deleted by an amending act, are not in the pin (a placeholder only).

    **Consequence for a user:** For those categories the caller states other_category, the threshold answer is threshold_not_formalised and the joined answer at best chapter_i_conditions_partly_untested. This includes research and development aid granted as repayable advances under point (i)(v), whose figures are increased by 50 %: a caller who names a research category for it gets the figure without the increase (Q18).

??? info "artificial_splitting"

    **Why:** Art 4(2) forbids circumventing a threshold by artificially splitting schemes or projects. The caller includes split parts in PROJECT_AID_CENTS (reading (11); Q4).

    **Consequence for a user:** The answers rest on the caller's total.

??? info "transparency_category_points"

    **Why:** The category points of Art 5(2) ((e), (ea), (f), (g), (ga) with its points, (h), (i), (l), (m), (n)) make aid transparent when conditions of Chapter III articles are met; the caller states that as category_transparency_condition_met (condition C2; Q10).

    **Consequence for a user:** The answers rest on the caller's category_transparency_condition_met.

??? info "application_content_points"

    **Why:** Art 6(2)(a) to (e) list the information the written application must contain; the caller states whether it does (application_contains_required_information, condition D3).

    **Consequence for a user:** The answers rest on the caller's statement.

??? info "verification_results"

    **Why:** The indents of Art 6(3)(b) list the material increases the documentation may establish; the caller states whether the verification of Art 6(3) was made (large_enterprise_verification_done, condition D3).

    **Consequence for a user:** The answers rest on the caller's statement.

??? info "deemed_incentive_categories"

    **Why:** The points of Art 6(5) list the categories not required to have, or deemed to have, an incentive effect, each with conditions in Chapter III; the caller states whether one applies with its conditions fulfilled (article_6_5_category_conditions_met, condition D1).

    **Consequence for a user:** The answers rest on the caller's statement.

??? info "amount_computation"

    **Why:** Art 7(1) to (3) say how figures are taken (before tax, as gross grant equivalent, discounted to the moment of grant). The caller computes every amount so (reading (12); Q17).

    **Consequence for a user:** The answers rest on the caller's figures; the order never computes a gross grant equivalent or a discount.

??? info "repayable_advances_regional"

    **Why:** Art 7(5) and 7(6) concern repayable advances (7(4) was deleted; a placeholder only). They concern aid intensities of Chapter III and regional aid maps, which this order does not test.

    **Consequence for a user:** None for a caller of this order.

??? info "union_funding"

    **Why:** Art 8(2) says centrally managed Union funding is left out when thresholds and intensities are tested. The caller leaves it out of PROJECT_AID_CENTS and SAME_COSTS_AID_CENTS (readings (11) and (12)).

    **Consequence for a user:** The answers rest on the caller's figures.

??? info "other_cumulation_rules"

    **Why:** Art 8(4) (aid without identifiable eligible costs), 8(6) (workers with disabilities) and 8(7) (regional operating aid in outermost regions) are not formalised (Q12).

    **Consequence for a user:** Aid without identifiable eligible costs gets cumulation_not_formalised; the two derogations are never applied, so a caller to whom one applies must not rely on cumulation_not_allowed.

??? info "publication"

    **Why:** Art 9 is the Member State's duty to publish information on aid, after the award. It is left to a later order (reading (2); Q2).

    **Consequence for a user:** The answers never say whether the publication duty applies to the aid or has been met.

