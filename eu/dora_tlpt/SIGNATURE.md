# SIGNATURE — eu/dora_tlpt

## 0 Public query surface (one paragraph)

The contract predicates are:

- `tlpt_identification_basis(Profile, Result, Citations)`
- `tlpt_duty(Profile, Result, Citations)`
- `dora_tlpt_input_problems(Profile, Problems)`

They are exported from `queries.clausal` and re-exported by the package facade. Each call yields EXACTLY ONE solution for every term, whether ground, unbound or malformed. There is no cut, no `->` and no `*->`. Determinism comes from mutually exclusive guards, with ground verdicts folded into the clause heads (C17).

The scaffold facade wraps the duty answer as the eligibility verdict:

- `decide_dora_tlpt(Profile, dora_tlpt_verdict(Status, Citations))`
- `dora_tlpt_status(Profile, Status)`

`Status` is exactly the `Result` of `tlpt_duty/3`. It replaces the scaffold placeholders `eligible` / `ineligible`.

`Citations` is a set-like list of `cite(Key)` terms, with each key written once. It is `[]` for every status compound.

Profile values are bare atoms or non-negative integers. There are no floats, strings, Python booleans or dates.

No figure is imported. Every statutory figure is declared once, with `constant_value/2`, in `dora_tlpt.clausal`.

## 1 Status atoms (replace the scaffold placeholders)

### Final results of `tlpt_identification_basis/3`

- `excluded_from_tlpt(Ground)`, where `Ground` is one of:
  - `article_16_1_entity`
  - `microenterprise`
- `listed_for_tlpt(Point)`, where `Point` is one of: `point_a`, `point_b`, `point_c`, `point_d`, `point_e`, `point_f`, `point_g`
- `not_listed_for_tlpt` (a bare atom)

### Final results of `tlpt_duty/3` (the eligibility verdict)

- `no_tlpt_duty(Ground)`, where `Ground` is one of:
  - `article_16_1_entity`
  - `microenterprise`
  - `not_identified`
- `tlpt_required(Frequency)`, where `Frequency` is one of:
  - `at_least_every_three_years`
  - `frequency_set_by_competent_authority`

### Status compounds (both queries)

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is never written.
- `input_problems(Problems)`: `Problems` is a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

### Result constructors

These are exported and never called as queries: `excluded_from_tlpt/1`, `listed_for_tlpt/1`, `no_tlpt_duty/1`, `tlpt_required/1`, `indeterminate/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## 2 Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`. The keys are given in contract order, which is also `root_exports` and `input_contract` order. No date key exists: the order reads no date.

| # | Key | Type |
|---|---|---|
| 1 | `financial_entity_is_article_16_1_entity` | crisp: `true` / `false` |
| 2 | `financial_entity_is_microenterprise` | crisp |
| 3 | `dora_entity_type` | enumeration: the 28 atoms of THE SHARED TYPE SET plus `none_of_the_listed_types` |
| 4 | `credit_institution_is_or_is_part_of_g_sii_or_o_sii` | crisp |
| 5 | `payment_transactions_total_value_eur_first_preceding_calendar_year` | non-negative integer, whole euro |
| 6 | `payment_transactions_total_value_eur_second_preceding_calendar_year` | non-negative integer, whole euro |
| 7 | `outstanding_electronic_money_eur_first_preceding_calendar_year` | non-negative integer, whole euro |
| 8 | `outstanding_electronic_money_eur_second_preceding_calendar_year` | non-negative integer, whole euro |
| 9 | `trading_venue_has_electronic_trading_system` | crisp |
| 10 | `trading_venue_has_highest_national_turnover_share_in_both_preceding_years` | crisp |
| 11 | `trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years` | crisp |
| 12 | `insurance_undertaking_activities` | enumeration: `life_only`, `life_and_non_life`, `non_life_only` |
| 13 | `gross_written_premium_eur` | non-negative integer, whole euro |
| 14 | `technical_provisions_eur` | non-negative integer, whole euro |
| 15 | `total_assets_share_of_member_state_insurance_sector_basis_points` | non-negative integer, basis points |
| 16 | `identified_by_tlpt_authority_as_required_to_perform_tlpt` | crisp |
| 17 | `tlpt_frequency_changed_by_competent_authority` | crisp |

THE SHARED TYPE SET, in order:

- `credit_institution`
- `institution_exempted_pursuant_to_directive_2013_36`
- `payment_institution`
- `exempted_payment_institution`
- `account_information_service_provider`
- `electronic_money_institution`
- `exempted_electronic_money_institution`
- `investment_firm`
- `crypto_asset_service_provider`
- `issuer_of_asset_referenced_tokens`
- `central_securities_depository`
- `central_counterparty`
- `trading_venue`
- `trade_repository`
- `manager_of_alternative_investment_funds`
- `management_company`
- `data_reporting_service_provider`
- `insurance_undertaking`
- `reinsurance_undertaking`
- `insurance_intermediary`
- `reinsurance_intermediary`
- `ancillary_insurance_intermediary`
- `institution_for_occupational_retirement_provision`
- `credit_rating_agency`
- `administrator_of_critical_benchmarks`
- `crowdfunding_service_provider`
- `securitisation_repository`
- `ict_third_party_service_provider`

## 3 Citation-key atoms (canonical lexicon scheme; never shortened)

| Key | Pinned units |
|---|---|
| `eu_reg_2022_2554_art_26_1` | 32022R2554#parag_026.001 |
| `eu_reg_2022_2554_art_26_8` | 32022R2554#parag_026.008 and points _a, _b, _c (third subparagraph) |
| `eu_reg_2025_1190_art_2_1` | 32025R1190#parag_002.001 and all its points |
| `eu_reg_2025_1190_art_2_2` | 32025R1190#parag_002.002 lead words and closing subparagraphs |
| `eu_reg_2025_1190_art_2_2_a` | point_002.002_a~1, a_i, a_ii, a_iii |
| `eu_reg_2025_1190_art_2_2_b` | point_002.002_b~1 |
| `eu_reg_2025_1190_art_2_2_c` | point_002.002_c~1 |
| `eu_reg_2025_1190_art_2_2_d` | point_002.002_d |
| `eu_reg_2025_1190_art_2_2_e` | point_002.002_e |
| `eu_reg_2025_1190_art_2_2_f` | point_002.002_f, f_i, f_i_1..5, f_ii, f_ii_1..5, and the closing subparagraph on (f)(ii) |
| `eu_reg_2025_1190_art_2_2_g` | point_002.002_g, g_i, g_ii, g_iii, and THE SECOND LIST point_002.002_a~2, b~2, c~2 |

The unit ids are recorded as facts in `citations.clausal`: `citation_unit(Key, UnitId)`.

Fixed citations per final answer:

| Answer | Citations |
|---|---|
| `excluded_from_tlpt(_)` | `[cite(eu_reg_2022_2554_art_26_1)]` |
| `no_tlpt_duty(article_16_1_entity)` | `[cite(eu_reg_2022_2554_art_26_1)]` |
| `no_tlpt_duty(microenterprise)` | `[cite(eu_reg_2022_2554_art_26_1)]` |
| `listed_for_tlpt(P)` | `[cite(eu_reg_2025_1190_art_2_2), cite(PointKey)]` |
| `not_listed_for_tlpt` | `[cite(eu_reg_2022_2554_art_26_8), cite(eu_reg_2025_1190_art_2_1), cite(eu_reg_2025_1190_art_2_2)]` |
| `no_tlpt_duty(not_identified)` | `[cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_8)]` |
| `tlpt_required(_)` | `[cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_8)]` |
| every status compound | `[]` |

## 4 Public predicates

- `tlpt_identification_basis(Profile, Result, Citations)`: whether Art 26(1) excludes the entity, or else how Art 2(2) of THE TLPT RTS places it. Limbs (A0) to (A8). Cites as in section 3.
- `tlpt_duty(Profile, Result, Citations)`: whether the entity must carry out TLPT, and how often. Limbs (B0) to (B8). Cites `eu_reg_2022_2554_art_26_1` and `eu_reg_2022_2554_art_26_8`.
- `dora_tlpt_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. It is total, never fails and never raises. Its basis is INTERFACE - THE INPUT CHECK; it has no legal citation.
- `decide_dora_tlpt(Profile, Verdict)`: `Verdict` is `dora_tlpt_verdict(Status, Citations)`, where `Status` and `Citations` are those of `tlpt_duty/3`. This is query type #2, eligibility. Cites `eu_reg_2022_2554_art_26_1` and `eu_reg_2022_2554_art_26_8`.
- `dora_tlpt_status(Profile, Status)`: `Status` is the `Result` of `tlpt_duty/3`. Cites as `tlpt_duty/3`.
- `dora_tlpt_checklist(Profile, Checklist)`: query type #7, justification. `Checklist` is a list of formalize_lib `item(RequirementId, Status, cite(Key))` terms, built by `eval_requirements/4` with the closure `dora_tlpt_requirement`. Every item, met items included, carries its cite. The items are, in this order:
  1. `article_16_1_carve_out_does_not_apply`, cite `eu_reg_2022_2554_art_26_1`. Met when the key is false, `unmet(article_16_1_entity)` when true, `unknown([financial_entity_is_article_16_1_entity])` when absent.
  2. `microenterprise_carve_out_does_not_apply`, cite `eu_reg_2022_2554_art_26_1`. Same pattern on `financial_entity_is_microenterprise`.
  3. `identified_by_tlpt_authority`, cite `eu_reg_2022_2554_art_26_8`. Met when the key is true, `unmet(not_identified)` when false, `unknown([identified_by_tlpt_authority_as_required_to_perform_tlpt])` when absent.

  A profile with input problems gives the checklist `[]`. The checklist explains; it never decides. Consistency property: `tlpt_required(_)` holds iff every item is met.
- `dora_tlpt_what_if(Profile, Key, Value, Verdict)`: sets `attribute(Key, Value)` with formalize_lib `profile_set/3` (the key replaced, not duplicated), then gives `decide_dora_tlpt/2` on the new profile. Exactly one solution. Cites as `decide_dora_tlpt/2`.
- `dora_tlpt_fixture(Name, Profile)` and `dora_tlpt_fixture_expected(Name, IdentificationResult, DutyResult)` (fixtures): named golden profiles, from section 7.

## 5 Planned reuse (manifest `uses:`)

### formalize_lib

Imports:

- `profile_get/3`
- `profile_has/2`
- `profile_lacks/2`
- `profile_set/3`
- `eval_requirements/4`
- `item/3`
- `unmet/1`
- `unknown/1`
- `attribute/2`
- `memberd/2`

It also uses the vocabulary atom `met`.

**Not used:**

- `check_gte`: it is `>=`, but the order needs strictly `>`.
- `ratio_bps`: the share is the caller's figure, not computed.
- `check_tri`: no tri-valued judgement keys.

### validate_props

Used in the property tests:

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`
- `prop_missing_key_coverage/3`
- `bad_citation/1`

### Not used

These are not used because the order reads no dates, does no planning and computes no money:

- `deadline_lib`
- `date_time`
- `rolling_window`
- `compliance_lib`
- `currency_vocab`
- `country`

`query_combinators` is also not used, because `what_if` is a single `profile_set/3`.

## 6 Package layout (unchanged file and module names)

The chain is: `kernel` -> `citations` -> `parameters` -> `dora_tlpt` -> `queries` -> `fixtures` -> facade.

- **`kernel.clausal`** holds only what the slice and the queries/facade share:
  - `input_contract_key/2`, which gives the 17 contract keys with their position.
  - `input_contract_key_type(Key, Type)`, where `Type` is `crisp`, `entity_type`, `insurance_activities` or `non_negative_integer`.
  - `dora_entity_type_atom/1`, the 29 atoms.
  - `insurance_undertaking_activities_atom/1`, the 3 atoms.
  - The total input check `dora_tlpt_input_problems/2` and its helpers:
    - list shape: `proper`, `partial` or `improper`, decided by `var/nonvar` guards;
    - the element shape test;
    - occurrence counting by `==`;
    - the value-type tests (crisp: `V == true` or `V == false`; figure: `integer(V)` and `V >= 0`).

  Neither the key nor the value is ever unified during the check.
- **`citations.clausal`** holds the citation-key facts of section 3.
- **`parameters.clausal`** holds no domain figure. By the slice rule, the figures live in `dora_tlpt.clausal`. It keeps its module, which exports nothing domain-numeric.
- **`queries.clausal`** exports the three contract predicates. It delegates to the slice.
- **`fixtures.clausal`** holds the section 7 rows.
- **The facade** exports `decide_dora_tlpt/2`, `dora_tlpt_status/2`, `dora_tlpt_checklist/2` and `dora_tlpt_what_if/4`, plus the contract predicates and the result constructors.

## 7 Slice — dora_tlpt.clausal (self-contained determination)

### 7.1 Value facts owned (declared once, read with `constant(Name)`)

| Constant | Value | Source |
|---|---|---|
| `payment_institution_payment_transactions_threshold_eur` | 150000000000 | (b), (c) |
| `electronic_money_institution_outstanding_electronic_money_threshold_eur` | 40000000000 | (c) |
| `insurance_subset_gross_written_premium_threshold_eur` | 1500000000 | (g)(i) |
| `insurance_subset_technical_provisions_threshold_eur` | 10000000000 | (g)(ii) |
| `insurance_subset_total_assets_share_threshold_basis_points` | 350 | (g)(iii) |
| `insurance_second_list_gross_written_premium_threshold_eur` | 3000000000 | second list (a) |
| `insurance_second_list_technical_provisions_threshold_eur` | 30000000000 | second list (b) |
| `insurance_second_list_total_assets_share_threshold_basis_points` | 1000 | second list (c) |

Every comparison is strictly `>`.

THE LIST TABLE is a total fact table with one row per atom of the 29: `type_point(Type, point(Point, PointCitationKey, PointKeys))` or `type_point(Type, no_point)`. The rows with a point are:

| Type | Point | Citation key | Point keys (root order) |
|---|---|---|---|
| `credit_institution` | `point_a` | `eu_reg_2025_1190_art_2_2_a` | `[credit_institution_is_or_is_part_of_g_sii_or_o_sii]` |
| `payment_institution` | `point_b` | `eu_reg_2025_1190_art_2_2_b` | `[payment_transactions_total_value_eur_first_preceding_calendar_year, payment_transactions_total_value_eur_second_preceding_calendar_year]` |
| `electronic_money_institution` | `point_c` | `eu_reg_2025_1190_art_2_2_c` | the two payment keys, then the two outstanding-electronic-money keys |
| `central_securities_depository` | `point_d` | `eu_reg_2025_1190_art_2_2_d` | `[]` |
| `central_counterparty` | `point_e` | `eu_reg_2025_1190_art_2_2_e` | `[]` |
| `trading_venue` | `point_f` | `eu_reg_2025_1190_art_2_2_f` | keys 9, 10, 11 |
| `insurance_undertaking` | `point_g` | `eu_reg_2025_1190_art_2_2_g` | keys 12, 13, 14, 15 |
| `reinsurance_undertaking` | `point_g` | `eu_reg_2025_1190_art_2_2_g` | keys 13, 14, 15 |

Every other type has `no_point`.

### 7.2 Rules and requirements

**MET conditions.** Each one is `point_met(Type, Assignment)` over a complete assignment of the point keys:

- **`point_a`:** the key is `true`.
- **`point_b`:** P1 > 150e9 and P2 > 150e9.
- **`point_c`:** (P1 > 150e9 or E1 > 40e9) and (P2 > 150e9 or E2 > 40e9).
- **`point_d`, `point_e`:** always met.
- **`point_f`:** the electronic-trading-system key is `true`, and the national key or the Union key is `true`.
- **`point_g`, `insurance_undertaking`:** the undertaking is in the subset and on THE SECOND LIST.
  - Subset: GWP > 1.5e9 and TP > 1e10, and either the activities are `non_life_only` or SHARE > 350.
  - Second list: GWP > 3e9 or TP > 3e10 or SHARE > 1000.
- **`point_g`, `reinsurance_undertaking`:** subset GWP > 1.5e9 and TP > 1e10, and THE SECOND LIST as above.

**Completions (limb A7).** An absent key is completed over FINITE REPRESENTATIVES, one value per threshold interval. This is exact because MET depends only on the interval class.

| Key | Representatives |
|---|---|
| crisp | `true`, `false` |
| activities | the 3 atoms |
| P1, P2 | 150000000000, 150000000001 |
| E1, E2 | 40000000000, 40000000001 |
| GWP | 1500000000, 3000000000, 3000000001 |
| TP | 10000000000, 30000000000, 30000000001 |
| SHARE | 350, 1000, 1001 |

`point_outcome(Type, Profile, Outcome)` works as follows:

1. Collect `findall` of MET or not-MET over all completions, then `sort` it.
2. `[met]` gives `settled(met)`.
3. `[not_met]` gives `settled(not_met)`.
4. `[met, not_met]` gives `unsettled(Key)`, where `Key` is:
   - the first absent key, in root order, that DECIDES ALONE (some value of it gives one outcome in all completions);
   - otherwise, the first absent key that CAN CHANGE the answer.

   This is equivalent to the 'not behind another' rule: a key that decides alone always can change an unsettled point.

**Identification basis clauses.** Each limb is one clause with the result in the head. Every limb after (A0) is guarded by `dora_tlpt_input_problems(Profile, [])`.

| Limb | Condition | Result |
|---|---|---|
| (A0) | `Problems = [_|_]` | `input_problems(Problems)` |
| (A1) | key 1 `true` | `excluded_from_tlpt(article_16_1_entity)` |
| (A2) | key 1 absent | `indeterminate([financial_entity_is_article_16_1_entity])` |
| (A3) | key 1 `false`, key 2 `true` | `excluded_from_tlpt(microenterprise)` |
| (A4) | key 1 `false`, key 2 absent | `indeterminate([financial_entity_is_microenterprise])` |
| (A5) | keys 1 and 2 `false`, type absent | `indeterminate([dora_entity_type])` |
| (A6) | `type_point(Type, no_point)` | `not_listed_for_tlpt` |
| (A7) | `unsettled(Key)` | `indeterminate([Key])` |
| (A8) | `settled(met)` | `listed_for_tlpt(Point)` |
| (A8) | `settled(not_met)` | `not_listed_for_tlpt` |

The input check guarantees that no key repeats and that no key or value is a variable. So `profile_get/3` and `profile_lacks/2` are single-solution and safe.

**Duty clauses.** Each limb is one clause with the result in the head. (B0) to (B4) mirror (A0) to (A4), with `no_tlpt_duty/1` as the result. The later limbs, all with keys 1 and 2 `false`, are:

| Limb | Condition | Result |
|---|---|---|
| (B5) | identification `false` | `no_tlpt_duty(not_identified)` |
| (B6) | identification absent | `indeterminate([identified_by_tlpt_authority_as_required_to_perform_tlpt])` |
| (B7) | identification `true`, frequency absent | `indeterminate([tlpt_frequency_changed_by_competent_authority])` |
| (B8) | identification `true`, frequency `true` | `tlpt_required(frequency_set_by_competent_authority)` |
| (B8) | identification `true`, frequency `false` | `tlpt_required(at_least_every_three_years)` |

The duty clauses read no key of the list.

**Requirements for the checklist.** These are the three `dora_tlpt_requirement(RequirementId, Profile, Status, Citation)` rows of section 4. The id comes FIRST. Each requirement has three exclusive clauses: met, unmet and unknown.

### 7.3 Verdict atoms

This slice owns all the atoms of section 1.

### 7.4 Shared with another slice

The slice consumes `dora_tlpt_input_problems/2` and the contract-key and type facts from `kernel.clausal`. It shares nothing else: `type_point`, `point_outcome` and the constants stay in this slice.

### 7.5 Per-rule tests

The seven test modes are: load, unit, golden fixture, boundary, missing-key, input-check and property.

Unless a row says otherwise, the base profile has keys 1 and 2 `false`. Threshold figures are written below as `150e9` and so on; the fixtures write each one as the full integer, for example 150000000000. Some rows give the expected result for one query only.

| Case | Profile beyond the base | `identification_basis` | `tlpt_duty` |
|---|---|---|---|
| G1 | key 1 `true`, identification `true` | `excluded_from_tlpt(article_16_1_entity)` | `no_tlpt_duty(article_16_1_entity)` |
| G2 | key 1 absent, key 2 `true` | `indeterminate([financial_entity_is_article_16_1_entity])` | the same |
| G3 | key 1 `false`, key 2 absent | `indeterminate([financial_entity_is_microenterprise])` | — |
| G4 | key 2 `true` | `excluded_from_tlpt(microenterprise)` | `no_tlpt_duty(microenterprise)` |
| G5 | no type | `indeterminate([dora_entity_type])` | — |
| G6 | `investment_firm` | `not_listed_for_tlpt` | — |
| G7 | `ict_third_party_service_provider` | `not_listed_for_tlpt` | — |
| G8 | `credit_institution`, point (a) absent | `indeterminate([credit_institution_is_or_is_part_of_g_sii_or_o_sii])` | — |
| G9 | `credit_institution`, point (a) `true` | `listed_for_tlpt(point_a)` | — |
| G10 | `payment_institution`, nothing else | `indeterminate([payment_transactions_total_value_eur_first_preceding_calendar_year])` | — |
| G11 | `payment_institution`, P1 = 150e9 (equal) | `not_listed_for_tlpt` | — |
| G12 | `payment_institution`, P1 = 150e9 + 1, P2 absent | `indeterminate([payment_transactions_total_value_eur_second_preceding_calendar_year])` | — |
| G13 | `payment_institution`, P1 = P2 = 150e9 + 1 | `listed_for_tlpt(point_b)` | — |
| G14 | `electronic_money_institution`, all absent | `indeterminate([payment_transactions_total_value_eur_first_preceding_calendar_year])` | — |
| G15 | `electronic_money_institution`, P1 = 0 | `indeterminate([outstanding_electronic_money_eur_first_preceding_calendar_year])` | — |
| G16 | `electronic_money_institution`, P1 = 0, E1 = 40e9 + 1 | `indeterminate([payment_transactions_total_value_eur_second_preceding_calendar_year])` | — |
| G17 | `electronic_money_institution`, P1 = 150e9 + 1, E1 = 0, P2 = 0, E2 = 40e9 + 1 (Q3) | `listed_for_tlpt(point_c)` | — |
| G18 | `electronic_money_institution`, P2 = 0, E2 = 40e9 (equal), others absent | `not_listed_for_tlpt` | — |
| G19 | `central_counterparty`, no other key | `listed_for_tlpt(point_e)` | — |
| G20 | `trading_venue`, all absent | `indeterminate([trading_venue_has_electronic_trading_system])` | — |
| G21 | `trading_venue`, ETS `true` | `indeterminate([trading_venue_has_highest_national_turnover_share_in_both_preceding_years])` | — |
| G22 | `trading_venue`, ETS `true`, national `false` | `indeterminate([trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years])` | — |
| G23 | `trading_venue`, ETS `false` | `not_listed_for_tlpt` | — |
| G24 | `trading_venue`, ETS absent, national `true` | `indeterminate([trading_venue_has_electronic_trading_system])` | — |
| G25 | `insurance_undertaking`, all absent | `indeterminate([gross_written_premium_eur])` | — |
| G26 | `insurance_undertaking`, GWP = 3e9 + 1 | `indeterminate([technical_provisions_eur])` | — |
| G27 | `insurance_undertaking`, GWP = 3e9 + 1, TP = 10e9 + 1 | `indeterminate([insurance_undertaking_activities])` | — |
| G28 | as G27, plus `life_only` | `indeterminate([total_assets_share_of_member_state_insurance_sector_basis_points])` | — |
| G29 | as G28, SHARE = 350 | `not_listed_for_tlpt` | — |
| G30 | as G28, SHARE = 351 | `listed_for_tlpt(point_g)` | — |
| G31 | `insurance_undertaking`, `non_life_only`, GWP = 2e9, TP = 20e9, SHARE absent | `indeterminate([total_assets_share_of_member_state_insurance_sector_basis_points])` | — |
| G32 | as G31, SHARE = 1000 | `not_listed_for_tlpt` | — |
| G33 | as G31, SHARE = 1001 | `listed_for_tlpt(point_g)` | — |
| G34 | `reinsurance_undertaking`, GWP = 2e9, TP = 40e9 | `listed_for_tlpt(point_g)` | — |
| G35 | a listed CSD, identification absent | `listed_for_tlpt(point_d)` | `indeterminate([identified_by_tlpt_authority_as_required_to_perform_tlpt])` |
| G36 | identification `false` | — | `no_tlpt_duty(not_identified)` |
| G37 | identification `true`, frequency absent | — | `indeterminate([tlpt_frequency_changed_by_competent_authority])` |
| G38 | identification `true`, frequency `false` | — | `tlpt_required(at_least_every_three_years)` |
| G39 | identification `true`, frequency `true` | — | `tlpt_required(frequency_set_by_competent_authority)` |
| G40 | a non-identified listed CSD (Q1) | `listed_for_tlpt(point_d)` | `no_tlpt_duty(not_identified)` |

**Input-check cases.**

| Case | Profile | Problems |
|---|---|---|
| I1 | `[attribute(gross_written_premium_eur, 1500000000.0)]` | `[wrong_type(gross_written_premium_eur)]` |
| I2 | `[attribute(foo, 1), attribute(dora_entity_type, bank), attribute(financial_entity_is_microenterprise, unsure), attribute(foo, 2), attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, false)]` | `[duplicate_key(financial_entity_is_article_16_1_entity), wrong_type(financial_entity_is_microenterprise), wrong_type(dora_entity_type), unknown_key(foo)]` |
| I3 | a profile holding the variable key `X` | `unknown_key(X)`, with `X` that same variable |
| I4 | the profile `[a]` | `[wrong_type(profile)]` |
| I5 | an unbound profile | `[wrong_type(profile)]` |
| I6 | a partial list | `[wrong_type(profile)]` |
| I7 | a negative figure | `wrong_type` |
| I8 | `[]` | `[]` |

When the problems are non-empty, each query gives `input_problems(Problems)` with `[]` citations.

Pair every `test(_, fail)` with a positive test over the same case. Count the solutions with `findall`: every query must give `length(Results, 1)`.

**Property tests (validate_props).** These run over generated profiles:

- totality and determinism (exactly one solution);
- citation completeness (every final answer has its fixed cites; status compounds have `[]`);
- boundary coverage at every threshold and at threshold + 1;
- missing-key coverage (every absent key named somewhere);
- consistency of checklist and verdict.
