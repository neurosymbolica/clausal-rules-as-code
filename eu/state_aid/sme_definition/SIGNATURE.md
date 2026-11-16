# SIGNATURE — eu/state_aid/sme_definition

## Public query surface

Five core queries, each `query(TEXT, PROFILE, RESULT, CITATIONS)`:

- TEXT is `recommendation_2003_361_annex` or `gber_annex_i`.
- PROFILE is a list of `attribute(KEY, VALUE)`, read only with `profile_get/3`.
- RESULT is a final atom or a non-final status.
- CITATIONS is a set-like list of `cite(KEY)`.

Every query is total and deterministic: exactly ONE solution for every input term, with no cut, no `->`, no `*->`. Disjoint clause heads with ground results are folded into the head (C17). Completions are enumerated by `findall/3` and compared after `sort/2`.

No figure is imported from another domain. Every statutory figure is declared once in `sme_definition.clausal` with `constant_value/2`.

## Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

**Final RESULT atoms, by query:**

| Query | Final RESULT atoms |
|---|---|
| `sme_definition_period_size_class` | `micro_enterprise`, `small_enterprise`, `medium_sized_enterprise`, `large_enterprise` |
| `sme_definition_size_class` | the four classes, plus `not_sme_public_control`, `not_an_enterprise` |
| `sme_definition_sme_status` | `sme`, `not_sme`, `not_an_enterprise` |
| `sme_definition_at_least_medium` | `at_least_medium`, `below_medium`, `not_an_enterprise` |
| `sme_definition_relationship_type` | `linked_enterprise`, `partner_enterprise`, `neither_partner_nor_linked` |

**Non-final RESULT, exactly one of:**

- `input_problems(PROBLEMS)`, where PROBLEMS is built from `wrong_type(text)`, `wrong_type(KEY)`, `wrong_type(profile)`, `duplicate_key(KEY)` and `unknown_key(KEY)`;
- `indeterminate([KEY])`, always ONE key; the bare atom `indeterminate` is never written;
- `needs_legal_review(open_textured(JUDGEMENT, cite(KEY)), [inputs_relied_on(PAIRS)])`.

In all three cases CITATIONS is `[]`.

**Result constructors** (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `partner_enterprise_data/4`, `linked_enterprise_data/3`.

## Profile keys (22, in root_exports / input_contract order)

| # | Key | Type | Values / unit |
|---|---|---|---|
| 1 | `is_enterprise` | judgement | true, false, unsure |
| 2 | `public_bodies_control_25_percent_or_more` | boolean | true, false |
| 3 | `accounting_basis` | enumeration | approved_accounts, bona_fide_estimate |
| 4 | `own_staff_annual_work_units_hundredths` | integer >= 0 | hundredths of an AWU |
| 5 | `own_annual_turnover_cents` | integer >= 0 | euro cents |
| 6 | `own_annual_balance_sheet_total_cents` | integer >= 0 | euro cents |
| 7 | `partner_enterprises` | list | proper list of `partner_enterprise_data(SHARE_BASIS_POINTS, STAFF_HUNDREDTHS, TURNOVER_CENTS, BALANCE_CENTS)` |
| 8 | `linked_enterprises` | list | proper list of `linked_enterprise_data(STAFF_HUNDREDTHS, TURNOVER_CENTS, BALANCE_CENTS)` |
| 9 | `previous_period_size_class` | enumeration | micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, no_previous_period |
| 10 | `size_class_held` | enumeration | micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise |
| 11 | `majority_of_voting_rights` | boolean | true, false |
| 12 | `right_to_appoint_or_remove_majority_of_board` | boolean | true, false |
| 13 | `dominant_influence_by_contract_or_articles` | judgement | true, false, unsure |
| 14 | `majority_of_voting_rights_by_shareholder_agreement` | boolean | true, false |
| 15 | `relationship_only_through_natural_persons` | boolean | true, false |
| 16 | `same_or_adjacent_market` | judgement | true, false, unsure |
| 17 | `holding_basis_points` | integer >= 0 | hundredths of a percent |
| 18 | `investor_category` | enumeration | not_a_listed_investor, public_investment_corporation_or_venture_capital_company, business_angel, university_or_non_profit_research_centre, institutional_investor, autonomous_local_authority |
| 19 | `investor_involved_in_management` | boolean | true, false |
| 20 | `business_angels_total_investment_cents` | integer >= 0 | euro cents |
| 21 | `local_authority_annual_budget_cents` | integer >= 0 | euro cents |
| 22 | `local_authority_inhabitants` | integer >= 0 | inhabitants |

**Which query reads which keys:**

- `period_size_class` reads keys 4 to 8.
- `size_class` and `sme_status` read keys 1 to 10.
- `at_least_medium` reads keys 1 to 10 except key 2.
- `relationship_type` reads keys 11 to 22.

Every present key is type-checked whatever query is asked. No dates are used: reference periods are expressed by `accounting_basis`, `previous_period_size_class` and `size_class_held`, not by dates.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`)

| Role | `recommendation_2003_361_annex` | `gber_annex_i` |
|---|---|---|
| ART1 | `eu_rec_2003_361_annex_art_1_t1` | `eu_reg_651_2014_annex_i_art_1_t1` |
| ART2_1 | `eu_rec_2003_361_annex_art_2_1` | `eu_reg_651_2014_annex_i_art_2_1` |
| ART2_2 | `eu_rec_2003_361_annex_art_2_2` | `eu_reg_651_2014_annex_i_art_2_2` |
| ART2_3 | `eu_rec_2003_361_annex_art_2_3` | `eu_reg_651_2014_annex_i_art_2_3` |
| ART3_1 | `eu_rec_2003_361_annex_art_3_1` | `eu_reg_651_2014_annex_i_art_3_1` |
| ART3_2 | `eu_rec_2003_361_annex_art_3_2` | `eu_reg_651_2014_annex_i_art_3_2` |
| ART3_2_EXCEPTION | `eu_rec_2003_361_annex_art_3_t3` | `eu_reg_651_2014_annex_i_art_3_t1` |
| ART3_2_A | `eu_rec_2003_361_annex_art_3_t4` | `eu_reg_651_2014_annex_i_art_3_2_a` |
| ART3_2_B | `eu_rec_2003_361_annex_art_3_t5` | `eu_reg_651_2014_annex_i_art_3_2_b` |
| ART3_2_C | `eu_rec_2003_361_annex_art_3_t6` | `eu_reg_651_2014_annex_i_art_3_2_c` |
| ART3_2_D | `eu_rec_2003_361_annex_art_3_t7` | `eu_reg_651_2014_annex_i_art_3_2_d` |
| ART3_3 | `eu_rec_2003_361_annex_art_3_3` | `eu_reg_651_2014_annex_i_art_3_3` |
| ART3_3_A | `eu_rec_2003_361_annex_art_3_t9` | `eu_reg_651_2014_annex_i_art_3_3_a` |
| ART3_3_B | `eu_rec_2003_361_annex_art_3_t10` | `eu_reg_651_2014_annex_i_art_3_3_b` |
| ART3_3_C | `eu_rec_2003_361_annex_art_3_t11` | `eu_reg_651_2014_annex_i_art_3_3_c` |
| ART3_3_D | `eu_rec_2003_361_annex_art_3_t12` | `eu_reg_651_2014_annex_i_art_3_3_d` |
| ART3_3_PRESUMPTION | `eu_rec_2003_361_annex_art_3_t13` | `eu_reg_651_2014_annex_i_art_3_t2` |
| ART3_3_NATURAL_PERSONS | `eu_rec_2003_361_annex_art_3_t15` | `eu_reg_651_2014_annex_i_art_3_t4` |
| ART3_3_ADJACENT_MARKET | `eu_rec_2003_361_annex_art_3_t16` | `eu_reg_651_2014_annex_i_art_3_t5` |
| ART3_4 | `eu_rec_2003_361_annex_art_3_4` | `eu_reg_651_2014_annex_i_art_3_4` |
| ART4_1 | `eu_rec_2003_361_annex_art_4_1` | `eu_reg_651_2014_annex_i_art_4_1` |
| ART4_2 | `eu_rec_2003_361_annex_art_4_2` | `eu_reg_651_2014_annex_i_art_4_2` |
| ART4_3 | `eu_rec_2003_361_annex_art_4_3` | `eu_reg_651_2014_annex_i_art_4_3` |
| ART5 | `eu_rec_2003_361_annex_art_5` | `eu_reg_651_2014_annex_i_art_5` |
| ART6_1 | `eu_rec_2003_361_annex_art_6_1` | `eu_reg_651_2014_annex_i_art_6_1` |
| ART6_2 | `eu_rec_2003_361_annex_art_6_2` | `eu_reg_651_2014_annex_i_art_6_2` |
| ART6_2_PARTNERS | `eu_rec_2003_361_annex_art_6_t3` | `eu_reg_651_2014_annex_i_art_6_t1` |
| ART6_2_LINKED | `eu_rec_2003_361_annex_art_6_t4` | `eu_reg_651_2014_annex_i_art_6_t2` |

The referral rows are:

- `is_enterprise` refers to ART1;
- `dominant_influence_by_contract_or_articles` refers to ART3_3_C;
- `same_or_adjacent_market` refers to ART3_3_NATURAL_PERSONS.

## Public predicates

**Core queries:**

- `sme_definition_period_size_class(Text, Profile, Result, Citations)`: the class met by the aggregated figures of one period (THE PERIOD CLASS) + cite(ART2_3 / ART2_2 / ART2_1), cite(ART5), cite(ART6_1) or cite(ART6_2) [+ ART6_2_PARTNERS, ART6_2_LINKED].
- `sme_definition_size_class(Text, Profile, Result, Citations)`: the class held, after Art 1, Art 3(4), Art 4(1)-(3) + cite(ART1) / cite(ART3_4) / class unit with PERIOD (ART5, ART6_*, ART4_1 / ART4_3, ART4_2).
- `sme_definition_sme_status(Text, Profile, Result, Citations)`: sme / not_sme / not_an_enterprise for the energy-efficiency domain + cite(ART2_1) with PERIOD, cite(ART3_4), or cite(ART1).
- `sme_definition_at_least_medium(Text, Profile, Result, Citations)`: medium-sized or large without Art 3(4), for the NIS2 domain + cite(ART2_1) or cite(ART2_2) with PERIOD, or cite(ART1).
- `sme_definition_relationship_type(Text, Profile, Result, Citations)`: linked / partner / neither for ONE other enterprise + cite(ART3_3) [+ ART3_3_A..D], cite(ART3_2), or cite(ART3_1) [+ ART3_2_EXCEPTION + point], with ART3_3_PRESUMPTION and ART3_3_NATURAL_PERSONS + ART3_3_ADJACENT_MARKET as the rules give them.
- `sme_definition_input_problems(Profile, Problems)`: the typed input check, exactly one solution, never fails or raises + no citation (contract check).

**Package facade** (scaffold names kept). In all four, QueryName is one of `period_size_class`, `size_class`, `sme_status`, `at_least_medium`, `relationship_type`.

- `decide_sme_definition(Request, Verdict)`: Request is `sme_definition_request(QueryName, Text, Profile)`. Verdict is `sme_definition_verdict(Result, Citations)`, from the core query + the citations of that query.
- `sme_definition_status(Request, Status)`: Status is the Result of `decide_sme_definition/2` (#3 status determination) + citations as the core query gives them.
- `sme_definition_checklist(Request, Checklist)`: #7 justification. Checklist is a list of `item(RequirementIdentifier, Status, cite(Key))`, built with `eval_requirements/4` over the requirement/4 rows of the asked query. Status is `met` / `unmet(Reason)` / `unknown([Key])`. Every item, met items included, carries cite(...) from THE CITATION ROLES for Text.
- `sme_definition_what_if(Request, Key, Value, Verdict)`: the verdict after overriding Key with Value in Profile, via `what_if/5` + the citations of the re-decided verdict.

**Fixtures:**

- `sme_definition_fixture(FixtureName, Request)`: named example requests covering the WORKED CASES of the design (every final atom, each non-final status, both TEXT atoms, boundary values at each ceiling) + citations per expected verdict.
- `sme_definition_fixture_expected(FixtureName, Verdict)`: the expected verdict of each fixture + the expected citations.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3` and `profile_has/2` / `profile_lacks/2`: presence first, then value. These are the ONLY profile access.
  - `profile_set/3`: completions and what-if.
  - `check_tri/4`: is_enterprise and the other judgement items.
  - `check_true/4`, `check_false/4`, `check_eq/5`: checklist rows.
  - `status_lt/4`, `status_lte/4`, `status_gte/4`: ceiling items on the computed sums.
  - `sum_list/2`: list aggregation.
  - `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`: the checklist.
  - `memberd/2`, `not_member/2`: enumeration membership.
  - `int_min/3`, `int_max/3`: the two-period rule (lower/higher class rank).
  - Vocabulary atom `met`.
- **kit.query_combinators:** `what_if/5` (sme_definition_what_if/4), `diff_checklists/3` (justification diffs in tests).
- **validate_props:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `prop_monotone/5` (staff monotone in class).
- **currency_vocab:** the atom `eur` names the money unit in documentation and fixtures. No conversion is done.
- **Not used:** compliance_lib, deadline_lib, rolling_window, date_time (no dates in this domain).

## Module layout (unchanged)

`kernel -> citations -> parameters -> sme_definition -> queries -> fixtures -> package facade`

- **kernel.clausal:** the shared floor.
  - `sme_definition_text/1` (the two TEXT atoms).
  - The result constructors.
  - `sme_definition_class_rank/2`: micro_enterprise 1, small_enterprise 2, medium_sized_enterprise 3, large_enterprise 4.
- **citations.clausal:** `sme_definition_citation(Text, Role, cite(Key))`, the role table above.
- **parameters.clausal:** `sme_definition_contract_key(Position, Key, Type)`, the typed input_contract rows in the order above. It holds no statutory figures.
- **queries.clausal:** the public query predicates and the input check, delegating to the slice.

## Slice: sme_definition.clausal

### Statutory VALUE facts owned by this slice

All are declared once with `:- constant_value(Name, Value).` and read with `constant(Name)`.

- `aggregation_scale_basis_points` = 10000 (100 % in hundredths of a percent; the scale of every sum)
- `micro_enterprise_staff_ceiling_annual_work_units_hundredths` = 1000 (Art 2(3), strict)
- `small_enterprise_staff_ceiling_annual_work_units_hundredths` = 5000 (Art 2(2), strict)
- `medium_sized_enterprise_staff_ceiling_annual_work_units_hundredths` = 25000 (Art 2(1), strict)
- `micro_enterprise_turnover_ceiling_cents` = 200000000 (Art 2(3), inclusive)
- `micro_enterprise_balance_sheet_ceiling_cents` = 200000000 (Art 2(3), inclusive)
- `small_enterprise_turnover_ceiling_cents` = 1000000000 (Art 2(2), inclusive)
- `small_enterprise_balance_sheet_ceiling_cents` = 1000000000 (Art 2(2), inclusive)
- `medium_sized_enterprise_turnover_ceiling_cents` = 5000000000 (Art 2(1), inclusive)
- `medium_sized_enterprise_balance_sheet_ceiling_cents` = 4300000000 (Art 2(1), inclusive)
- `partner_holding_threshold_basis_points` = 2500 (Art 3(2), `>=`)
- `business_angels_investment_limit_cents` = 125000000 (Art 3(2)(a), strict `<`)
- `local_authority_budget_limit_cents` = 1000000000 (Art 3(2)(d), strict `<`)
- `local_authority_inhabitants_limit` = 5000 (Art 3(2)(d), strict `<`)

### Rules / requirements

1. **Input check.** `sme_definition_input_problems/2` and its helpers:
   - well-formed attribute list, else `[wrong_type(profile)]`;
   - then `duplicate_key` / `wrong_type` per contract key in contract order;
   - then `unknown_key` in first-occurrence order.

   Lists must be proper and ground, with well-formed items of non-negative integers.
2. **Aggregation (Art 6(1), 6(2)).** `sme_definition_staff_sum/2`, `sme_definition_turnover_sum/2` and `sme_definition_balance_sheet_sum/2`: exact integer sums in ten-thousandths of the unit, over present keys (LOW).
3. **Bands (M1).** `sme_definition_staff_band/2`, `sme_definition_turnover_band/2` and `sme_definition_balance_sheet_band/2` give bands 1 to 4 from the ceilings × scale. `sme_definition_free_sum/3` gives a sum free when one of its contributing keys is absent.
4. **Period class (Art 2(1)-(3)).** `sme_definition_class_of_bands(StaffBand, TurnoverBand, BalanceBand, Class)`. Micro needs staff band 1 and (turnover band 1 or balance band 1); small and medium are built the same way; otherwise large. One clause per disjoint route, with the class in the head.
5. **Two-period rule (Art 4(2)).** `sme_definition_two_period(LatestClass, PreviousClass, HeldClass, Class)` over class ranks.
6. **Status (Art 4(1), 4(3)).** `sme_definition_status_of(AccountingBasis, LatestClass, PreviousClass, HeldClass, Class)`.
7. **Answer rules.** One per query, over a completion: `sme_definition_answer(Query, Completion, Result)`.
   - size_class: Art 1, then Art 3(4), then status.
   - sme_status: maps the size_class answer.
   - at_least_medium: ignores Art 3(4).
   - relationship_type: PRESUMED, POINT_C, RELATED, LINKED, EXCEPTED, as in reading (9).
8. **Completions (M2, M3).** `sme_definition_completion(Query, Profile, Completion)` enumerates choices of bands, atoms, threshold sides and true/false for unsure judgements.
9. **Decision steps.** `sme_definition_decide(Query, Text, Profile, Result, Citations)` takes the steps in this order:
   - (0) input problems;
   - (1) settled: all completion RESULTs equal, after sort;
   - (2) missing: candidates are absent keys that can change the RESULT (M4); the gating test BEHIND/GATED is one key against one key; name the first non-gated candidate in root order, or else the first candidate (the first-missing-key rule, Q13);
   - (3) referral: the first unsure judgement that can change the RESULT, with PAIRS of the present judgement keys the query reads.

   The steps are mutually exclusive by construction, which gives one solution.
10. **Citations.** `sme_definition_citations(Query, Text, Profile, Result, Citations)` gives FIGURES, PERIOD, the CLASS UNIT and the relationship citations, read from PRESENT keys only, as a sorted set-like list.
11. **Checklist rows.** `sme_definition_requirement(RequirementIdentifier, Profile, Status, Citation)`, in the order kit requires, for the facade checklist:
    - `enterprise_engaged_in_economic_activity` (ART1);
    - `no_public_body_control` (ART3_4);
    - `staff_below_ceiling_of_class` (ART2_x, ART5);
    - `financial_ceiling_of_class_met` (ART2_x, ART6_*);
    - `reference_period_basis` (ART4_1 / ART4_3);
    - `two_consecutive_periods` (ART4_2);
    - for relationship_type: `control_relationship_point_a` to `control_relationship_point_d` (ART3_3_A..D), `presumption_of_no_dominant_influence` (ART3_3_PRESUMPTION), `same_or_adjacent_market_condition` (ART3_3_NATURAL_PERSONS), `holding_reaches_partner_threshold` (ART3_2), `listed_investor_exception` (ART3_2_EXCEPTION and its point).

    Each row has exactly three exclusive clauses: met / unmet / unknown.

### Verdict atoms of this slice

- **Final atoms:** all final RESULT atoms listed above.
- **Non-final statuses:** `input_problems/1`, `indeterminate/1`, `needs_legal_review/2`.

### Predicates shared with another slice (kernel.clausal)

There is only one slice, so no predicate is shared across slices. The kernel keeps only the floor: `sme_definition_text/1`, `sme_definition_class_rank/2` and the result constructors. All value facts and rules above stay in `sme_definition.clausal`.

### Tests (seven modes, v2 manifest)

- **Per-rule tests:** each ceiling at, just below and just above its figure, in units; each investor limit; the two-period table; the presumption.
- **Worked cases:** every WORKED CASE of the design as a fixture.
- **Determinism:** exactly one solution per query.
- **Totality:** an answer for malformed terms.
- **Citation completeness:** every cite key is in the vocabulary.
- **Missing-key coverage:** every absent key behaves as specified.
- **Text invariance:** the same RESULT under both TEXT atoms.

Negative tests are paired with positive ones over the same case.
