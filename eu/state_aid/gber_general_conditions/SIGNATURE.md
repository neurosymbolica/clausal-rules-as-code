# SIGNATURE — eu/state_aid/gber_general_conditions

Package `eu/state_aid/gber_general_conditions`, predicate prefix `gber_general_conditions_`, shape family deontic. The layout is kept unchanged:

`kernel -> citations -> parameters -> gber_general_conditions -> queries -> fixtures -> package facade`

The package has one determination slice, `gber_general_conditions.clausal`. It uses the v2 manifest and seven test modes.

## 1. Public query surface

### The seven contract predicates

These are non-negotiable and exported from the facade.

- `gber_scope(Profile, Result, Citations)`: scope under Art 1(2) to (5) and Art 2(18). Result is `within_scope`, `excluded_from_scope` or a status compound. Cites the fixed scope list.
- `gber_notification_threshold(Profile, ProjectAidCents, Result, Citations)`: Art 4(1) slice with Art 8(1). Result is `within_threshold`, `threshold_exceeded`, `threshold_not_formalised` or a status compound. Cites `eu_reg_651_2014_art_4_1`, the row and `eu_reg_651_2014_art_8_1`.
- `gber_transparency(Profile, Result, Citations)`: Art 5. Result is `transparent_aid`, `not_transparent_aid` or a status compound. Cites the fixed Art 5 list.
- `gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, Result, Citations)`: Art 6. Result is `incentive_effect`, `no_incentive_effect` or a status compound. Cites the fixed Art 6 list.
- `gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, Result, Citations)`: Art 8(3) and 8(5). Result is `cumulation_allowed`, `cumulation_not_allowed`, `cumulation_not_formalised` or a status compound.
- `gber_chapter_i_conditions(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, Result, Citations)`: the joined answer under Art 3. Result is `tested_chapter_i_conditions_met`, `chapter_i_conditions_not_met`, `chapter_i_conditions_partly_untested` or a status compound. Cites `eu_reg_651_2014_art_3_t1`, plus the fixed list when the conditions are not met.
- `gber_general_conditions_input_problems(Profile, Problems)`: the input check of the profile alone. It gives a BARE flat list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms. It always yields exactly one solution, for every term.

### Scaffold facade names (kept)

Case term:

`gber_case(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints)`

- `decide_gber_general_conditions(Case, gber_general_conditions_verdict(Status, Citations))`: eligibility (#2). Status and Citations are exactly the Result and Citations of `gber_chapter_i_conditions/10` on the unpacked case, under Art 3 (`eu_reg_651_2014_art_3_t1`).
- `gber_general_conditions_status(Case, Status)`: status determination (#3). It classifies the measure as one of the three joined atoms or a status compound, under Art 3. It is defined only via `decide_gber_general_conditions/2`.
- `gber_general_conditions_checklist(Case, Checklist)`: the cited checklist for #2. It is a list of five `item(TestId, ItemStatus, cite(Key))` rows in the order `scope_test`, `notification_threshold_test`, `transparency_test`, `incentive_effect_test`, `cumulation_test`.
  - It is built with `eval_requirements/4` (formalize_lib) over `gber_general_conditions_requirement/4`, whose head is `(RequirementId, Case, Status, Citation)`.
  - ItemStatus is `met` for FOR and `unmet(Result)` for AGAINST.
  - ItemStatus is `unknown([Key])` when the test is indeterminate, `unknown([])` when it needs review, input problems or is UNTESTED.
  - The cite per test:
    - scope: `eu_reg_651_2014_art_1_2`
    - threshold: `eu_reg_651_2014_art_4_1`
    - transparency: `eu_reg_651_2014_art_5_1`
    - incentive: `eu_reg_651_2014_art_6_1`
    - cumulation: `eu_reg_651_2014_art_8_3`
  - The checklist is a VIEW. The scored verdict is always `decide_gber_general_conditions/2`.
- `gber_general_conditions_what_if(Case, Key, Value, Verdict)`: replaces the profile entry Key with `attribute(Key, Value)` using `profile_set/3` (formalize_lib). It then re-runs `decide_gber_general_conditions/2` and returns the new verdict, under Art 3. It is forward-only; Key and Value must be bound.
- Fixtures: `gber_general_conditions_fixture(Name, Case)` and `gber_general_conditions_fixture_expected(Name, Status, Citations)`. See section 7.

### Result constructors

These are exported and never called as queries:

`date/3`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Totality and determinism

- Every public query yields exactly ONE solution for every profile, including malformed ones, which give `input_problems`.
- No cut, `->` or `*->` is used.
- Ground results are folded into clause heads, one clause per disjoint limb, and each limb is guarded by the negation of the earlier limbs.
- The bare atom `indeterminate` is NEVER written.

## 2. Verdict STATUS atoms (replacing the placeholder `required / permitted / not_applicable`)

- **Joined (facade STATUS):** `tested_chapter_i_conditions_met`, `chapter_i_conditions_not_met`, `chapter_i_conditions_partly_untested`.
- **Per test:**
  - scope: `within_scope`, `excluded_from_scope`
  - threshold: `within_threshold`, `threshold_exceeded`, `threshold_not_formalised`
  - transparency: `transparent_aid`, `not_transparent_aid`
  - incentive: `incentive_effect`, `no_incentive_effect`
  - cumulation: `cumulation_allowed`, `cumulation_not_allowed`, `cumulation_not_formalised`
- **Status compounds (not final):**
  - `indeterminate([Key])`
  - `needs_legal_review(open_textured(Key, cite(Cite)), [inputs_relied_on(Pairs)])`
  - `input_problems(Problems)`
- **Checklist labels:** `labels(chapter_i_checklist_met, chapter_i_checklist_open, chapter_i_checklist_not_met)`.

## 3. Profile keys (root_exports order; plain caller facts; attribute list read ONLY via profile_get/3)

Boolean keys take `true` or `false`. Judgement keys take `true`, `false` or `unsure`.

| # | Key | Type | Condition |
|---|-----|------|-----------|
| 1 | `scheme_excluded_by_article_1_2_a_or_b` | judgement | A1 |
| 2 | `export_or_domestic_goods_aid` | judgement | A2 |
| 3 | `aided_sector` | enum: `other_sector`, `fishery_and_aquaculture`, `primary_agricultural_production`, `processing_and_marketing_of_agricultural_products`, `closure_of_uncompetitive_coal_mines` | A3 |
| 4 | `sector_exception_applies` | boolean | A3 |
| 5 | `price_or_pass_on_condition` | boolean | A3 |
| 6 | `article_13_regional_aid_category` | boolean | A4 |
| 7 | `also_active_in_excluded_sector` | boolean | A5 |
| 8 | `separation_of_activities_or_costs_ensured` | judgement | A5 |
| 9 | `recovery_order_exclusion_applies` | boolean | A6 |
| 10 | `undertaking_in_difficulty` | judgement | A7 |
| 11 | `difficulty_exception_applies` | boolean | A7 |
| 12 | `difficulty_2020_2021_derogation` | boolean | A7 |
| 13 | `non_severable_violation_of_union_law` | judgement | A8 |
| 14 | `article_4_category` | enum: `sme_investment`, `sme_consultancy`, `sme_fair_participation`, `fundamental_research`, `industrial_research`, `experimental_development`, `feasibility_study`, `sme_innovation`, `process_and_organisational_innovation`, `training`, `environmental_investment`, `other_category` | threshold |
| 15 | `research_project_doubled` | boolean | threshold |
| 16 | `aid_form` | enum: `grant`, `interest_rate_subsidy`, `loan`, `guarantee`, `tax_advantage`, `repayable_advance`, `sale_or_lease_of_tangible_assets`, `other_form` | C1 |
| 17 | `form_transparency_condition_met` | boolean | C1 |
| 18 | `category_transparency_condition_met` | boolean | C2 |
| 19 | `transparent_under_article_5_1` | judgement | C3 |
| 20 | `article_6_5_category_conditions_met` | boolean | D1 |
| 21 | `tax_measure_conditions_met` | boolean | D2 |
| 22 | `application_contains_required_information` | boolean | D3 |
| 23 | `aid_type` | enum: `scheme`, `individual_aid_under_scheme`, `ad_hoc_aid` | D3 |
| 24 | `size_class` | enum: `micro_enterprise`, `small_enterprise`, `medium_sized_enterprise`, `large_enterprise`, `not_sme_public_control` | D3 |
| 25 | `large_enterprise_verification_done` | boolean | D3 |
| 26 | `identifiable_eligible_costs` | boolean | cumulation |

That is fifteen boolean keys, six judgement keys and five enumeration keys.

### Arguments (not profile keys; checked at step 0 of the queries that take them, in signature order)

- `ProjectAidCents`: a non-negative integer of euro cents. A bad value gives `wrong_type(project_aid_cents)`.
- `ApplicationDate`: a ground `date(Year, Month, Day)` real Gregorian day with Year from 1 to 9999, or the atom `no_application`. A bad value gives `wrong_type(application_date)`.
- `WorkStartDate`: a ground `date(Year, Month, Day)` real day. A bad value gives `wrong_type(work_start_date)`.
- `EligibleCostsCents`, `SameCostsAidCents`, `SameCostsDeMinimisCents`: non-negative integers of euro cents. Bad values give `wrong_type(eligible_costs_cents)`, `wrong_type(same_costs_aid_cents)` or `wrong_type(same_costs_de_minimis_cents)`.
- `MaxIntensityBasisPoints`: a non-negative integer with no upper bound. A bad value gives `wrong_type(max_intensity_basis_points)`.

## 4. Citation-key atoms (canonical lexicon; never shortened)

**Article 1:**
- `eu_reg_651_2014_art_1_2`, `eu_reg_651_2014_art_1_2_a`, `eu_reg_651_2014_art_1_2_b`, `eu_reg_651_2014_art_1_2_c`, `eu_reg_651_2014_art_1_2_d`
- `eu_reg_651_2014_art_1_3`, `eu_reg_651_2014_art_1_3_a`, `eu_reg_651_2014_art_1_3_b`, `eu_reg_651_2014_art_1_3_c`, `eu_reg_651_2014_art_1_3_c_i`, `eu_reg_651_2014_art_1_3_c_ii`, `eu_reg_651_2014_art_1_3_d`, `eu_reg_651_2014_art_1_3_e`
- `eu_reg_651_2014_art_1_t1`
- `eu_reg_651_2014_art_1_4`, `eu_reg_651_2014_art_1_4_a`, `eu_reg_651_2014_art_1_4_b`, `eu_reg_651_2014_art_1_4_c`
- `eu_reg_651_2014_art_1_5`, `eu_reg_651_2014_art_1_5_a`, `eu_reg_651_2014_art_1_5_b`, `eu_reg_651_2014_art_1_5_c`

**Articles 2 and 3:**
- `eu_reg_651_2014_art_2_18`
- `eu_reg_651_2014_art_3_t1`

**Article 4:**
- `eu_reg_651_2014_art_4_1`, `eu_reg_651_2014_art_4_1_c`, `eu_reg_651_2014_art_4_1_d`, `eu_reg_651_2014_art_4_1_e`
- `eu_reg_651_2014_art_4_1_i`, `eu_reg_651_2014_art_4_1_i_i`, `eu_reg_651_2014_art_4_1_i_ii`, `eu_reg_651_2014_art_4_1_i_iii`, `eu_reg_651_2014_art_4_1_i_iv`, `eu_reg_651_2014_art_4_1_i_vi`
- `eu_reg_651_2014_art_4_1_l`, `eu_reg_651_2014_art_4_1_m`, `eu_reg_651_2014_art_4_1_n`, `eu_reg_651_2014_art_4_1_s`

**Article 5:**
- `eu_reg_651_2014_art_5_1`, `eu_reg_651_2014_art_5_2`
- `eu_reg_651_2014_art_5_2_a`, `eu_reg_651_2014_art_5_2_b`, `eu_reg_651_2014_art_5_2_c`, `eu_reg_651_2014_art_5_2_c_i`, `eu_reg_651_2014_art_5_2_c_ii`, `eu_reg_651_2014_art_5_2_d`, `eu_reg_651_2014_art_5_2_j`, `eu_reg_651_2014_art_5_2_k`

**Article 6:**
- `eu_reg_651_2014_art_6_1`, `eu_reg_651_2014_art_6_2`
- `eu_reg_651_2014_art_6_3`, `eu_reg_651_2014_art_6_3_a`, `eu_reg_651_2014_art_6_3_b`
- `eu_reg_651_2014_art_6_4`, `eu_reg_651_2014_art_6_4_a`, `eu_reg_651_2014_art_6_4_b`
- `eu_reg_651_2014_art_6_5`

**Article 8:**
- `eu_reg_651_2014_art_8_1`
- `eu_reg_651_2014_art_8_3`, `eu_reg_651_2014_art_8_3_a`, `eu_reg_651_2014_art_8_3_b`
- `eu_reg_651_2014_art_8_5`

`citations.clausal` holds them as `citation_vocabulary/1` facts. Deferred units are NOT given citation atoms, because no answer cites them.

## 5. Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` for all key reads, by presence then by value;
  - `profile_set/3` for what_if;
  - `eval_requirements/4` for the checklist;
  - `item/3`, `unknown/1`, `unmet/1`, `attribute/2` as constructors;
  - `memberd/2` and `not_member/2` where membership is needed.
- **kit/deadline_lib**: `month_last_day/3`, used only to validate that `date(Y, M, D)` is a real calendar day.
  - Ordering is an explicit integer (Y, M, D) comparison, because the contract fixes bare date/3 terms and library(datetime) date/3 is not yet registered.
  - No day arithmetic is done.
- **validate_props** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used, with reasons:**
  - `check_tri/4` and `check_tri_neg/4`: Kleene checks do not express the COST / UNSURE COUNT ranking THE PICK needs.
  - `ratio_bps/4`: its integer division would round. Cumulation uses exact cross-multiplication.
  - `assess/6` decision labels: the joined answer has a third, partly untested ending that assess cannot express.
- **Family backbone `_common`:** none needed.
- **Kit candidate (noted in NOTES.md):** the conjunction / way / pick engine.

## 6. Files and what each holds

### kernel.clausal (the shared floor)

These are the predicates the slice, queries and facade all need.

- `gber_general_conditions_contract_key(Key, Type)`: 26 facts in root_exports order. Type is `boolean`, `judgement` or `enumeration(Atoms)`.
- `gber_general_conditions_key_order(Keys)`: the root_exports list.
- `gber_general_conditions_input_problems/2`: duplicate, then wrong_type, per contract key in order, then unknown_key in first-occurrence order, with `==` de-duplication.
  - Guards use `var/1`, `is_list/1` and an element shape check.
  - Non-list, partial list, or an unbound or non-attribute element gives `[wrong_type(profile)]`.
  - An unbound value gives `wrong_type(Key)`.
- Argument checks:
  - `non_negative_cents_argument/1`;
  - `real_calendar_date/1`, which needs a ground date with integer Y from 1 to 9999, M from 1 to 12 and D from 1 to `month_last_day`;
  - `application_date_argument/1`;
  - `argument_problems/2`, from a list of `Name-Value` pairs in signature order.
- `application_before_start(ApplicationDate, WorkStartDate)`: strict lexicographic integer comparison. It is false for `no_application`.
- The conjunction engine:
  - a conjunction is a list of `key_allows(Key, AllowedValues)`;
  - `conjunction_met/2`;
  - `conjunction_possible/2`;
  - `conjunction_rank(Profile, Conjunction, Cost, UnsureCount, AbsentKeys)`, with AbsentKeys in root_exports order;
  - `way_rank/5`, the first possible conjunction of lowest rank;
  - `all_fail_way_rank/5`, which sums cost and unsure count and unions absent keys in key order;
  - `pick_missing_key(Profile, CandidateWays, Key)`, which fails when no possible way has COST at least 1;
  - candidate ways are `conjunction_way(Conjunctions)`, `all_fail_way(Conditions)` or `sum_way(Parts)`.
- `pairs_relied_on(Profile, Keys, Pairs)`: the present keys as `Key-Value`, in root_exports order.

### citations.clausal

The citation vocabulary of section 4, and the fixed lists:

- `scope_citations/1`
- `transparency_citations/1`
- `incentive_citations/1`
- `chapter_i_not_met_citations/1`
- `threshold_row_citation(Category, RowKey)`

### parameters.clausal

Empty of figures by design, because the figures live in the slice. It holds only the money unit note: euro cents, the `eur` currency atom.

### gber_general_conditions.clausal

The slice; see section 8.

### queries.clausal

The seven contract predicates, implementing THE LIMBS steps 0 to 24 over the slice's conditions and the kernel engine.

### fixtures.clausal

See section 7.

### Package facade

The facade predicates and exports.

### tests

Seven modes:

1. load;
2. per-rule unit tests, one per limb;
3. boundary (each figure, the figure + 1, 2 x figure, 2 x figure + 1, same-day dates, cumulation equality);
4. missing-key / pick;
5. needs_legal_review pairs;
6. input check, including unbound, partial list, compound key, variable key and duplicates;
7. properties via validate_props (totality, determinism, citation completeness against `citation_vocabulary`).

Every `test(_, fail)` is paired with a positive test over the same case.

## 7. Fixtures (name: case, expected)

**Base profile.** All keys present, set so that every scope condition FAILS:

- `scheme_excluded_by_article_1_2_a_or_b` false
- `export_or_domestic_goods_aid` false
- `aided_sector` other_sector
- `sector_exception_applies` false
- `price_or_pass_on_condition` false
- `article_13_regional_aid_category` false
- `also_active_in_excluded_sector` false
- `separation_of_activities_or_costs_ensured` true
- `recovery_order_exclusion_applies` false
- `undertaking_in_difficulty` false
- `difficulty_exception_applies` false
- `difficulty_2020_2021_derogation` false
- `non_severable_violation_of_union_law` false

The remaining keys:

- `article_4_category` sme_investment
- `research_project_doubled` false
- `aid_form` grant
- `form_transparency_condition_met` false
- `category_transparency_condition_met` false
- `transparent_under_article_5_1` false
- `article_6_5_category_conditions_met` false
- `tax_measure_conditions_met` false
- `application_contains_required_information` true
- `aid_type` scheme
- `size_class` small_enterprise
- `large_enterprise_verification_done` false
- `identifiable_eligible_costs` true

The cases:

- **compliant_sme_grant**: base profile, 800000000 cents, `date(2024, 1, 10)`, `date(2024, 2, 1)`, eligible costs 2000000000, same-costs aid 800000000, de minimis 0, intensity 5000. Expected `tested_chapter_i_conditions_met` with `[cite(eu_reg_651_2014_art_3_t1)]`.
- **same_day_application**: as above with both dates `date(2024, 2, 1)`. Expected `chapter_i_conditions_not_met` with the fixed list; incentive is `no_incentive_effect` (Q1).
- **threshold_at_figure / threshold_one_cent_over**: 825000000 gives `within_threshold`; 825000001 gives `threshold_exceeded`. The citations are `[cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_c), cite(eu_reg_651_2014_art_8_1)]`.
- **doubled_industrial_research**: `industrial_research`, doubled true, 5000000000 cents. Expected `within_threshold`, citing art_4_1, art_4_1_i_ii, art_8_1, art_4_1_i and art_4_1_i_iv. With doubled absent the answer is `indeterminate([research_project_doubled])`. At 7000000001 cents the answer is `threshold_exceeded` whatever the doubling.
- **other_category_row**: `other_category`. The threshold gives `threshold_not_formalised` with []. Joined, the answer is `chapter_i_conditions_partly_untested` with `[cite(eu_reg_651_2014_art_3_t1)]`.
- **difficulty_unsure**: base with `undertaking_in_difficulty` unsure. Scope gives `needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), [inputs_relied_on([undertaking_in_difficulty-unsure, difficulty_exception_applies-false, difficulty_2020_2021_derogation-false])])` with [].
- **empty_profile_scope**: `[]`. Scope gives `indeterminate([scheme_excluded_by_article_1_2_a_or_b])`.
- **not_an_enterprise_size**: `size_class` not_an_enterprise. Every query gives `input_problems([wrong_type(size_class)])` with [].
- **de_minimis_tips_over**: eligible costs 1000, aid 600, de minimis 500, intensity 10000. Expected `cumulation_not_allowed` with `[cite(eu_reg_651_2014_art_8_5)]`, because aid alone is not over.

## 8. Slice — gber_general_conditions.clausal

The slice is self-contained: value facts, conditions, derived arithmetic, its per-rule tests, checklist rows and verdict atoms. It authors the conditions as DATA consumed by the kernel engine; queries.clausal sequences the limbs.

### Value facts owned here (declared once, read with `constant(Name)`)

```
constant_value(sme_investment_threshold_eur_cents, 825000000)                 % Art 4(1)(c)
constant_value(sme_consultancy_threshold_eur_cents, 220000000)                % Art 4(1)(d)
constant_value(sme_fair_participation_threshold_eur_cents, 220000000)         % Art 4(1)(e)
constant_value(fundamental_research_threshold_eur_cents, 5500000000)          % Art 4(1)(i)(i)
constant_value(industrial_research_threshold_eur_cents, 3500000000)           % Art 4(1)(i)(ii)
constant_value(experimental_development_threshold_eur_cents, 2500000000)      % Art 4(1)(i)(iii)
constant_value(feasibility_study_threshold_eur_cents, 825000000)              % Art 4(1)(i)(vi)
constant_value(sme_innovation_threshold_eur_cents, 1000000000)                % Art 4(1)(l)
constant_value(process_and_organisational_innovation_threshold_eur_cents, 1250000000) % Art 4(1)(m)
constant_value(training_threshold_eur_cents, 300000000)                       % Art 4(1)(n)
constant_value(environmental_investment_threshold_eur_cents, 3000000000)      % Art 4(1)(s)
constant_value(research_doubling_factor, 2)                                   % Art 4(1)(i)(iv)
constant_value(basis_points_per_whole, 10000)                                 % Art 2(26), 8(3)(b), 8(5)
```

Also owned here:

- `threshold_category_figure(Category, ConstantName)`: eleven rows in slice order.
- `research_category/1`: `fundamental_research`, `industrial_research`, `experimental_development`.

### Conditions (named by full words; HOLDS / FAILS conjunctions as data)

The facts are `condition_holds_conjunction(Condition, Conjunction)` and `condition_fails_conjunction(Condition, Conjunction)`, listed in order.

**Scope conditions** (HOLDS means excluded):

- **`excluded_scheme`** (A1)
  - HOLDS: [scheme_excluded_by_article_1_2_a_or_b true]
  - FAILS: [... false]
  - Referral key `scheme_excluded_by_article_1_2_a_or_b`, cite `eu_reg_651_2014_art_1_2`.
- **`export_or_domestic_goods`** (A2)
  - HOLDS: [export_or_domestic_goods_aid true]
  - FAILS: [... false]
  - Referral cite `eu_reg_651_2014_art_1_2`.
- **`excluded_sector`** (A3)
  - HOLDS: [aided_sector in {fishery_and_aquaculture, primary_agricultural_production}, sector_exception_applies false]; [aided_sector processing_and_marketing_of_agricultural_products, price_or_pass_on_condition true]; [aided_sector closure_of_uncompetitive_coal_mines]
  - FAILS: [aided_sector other_sector]; [aided_sector in {fishery..., primary...}, sector_exception_applies true]; [aided_sector processing..., price_or_pass_on_condition false]
- **`regional_aid_category`** (A4)
  - HOLDS: [article_13_regional_aid_category true]
  - FAILS: [... false]
- **`excluded_sector_activity`** (A5)
  - HOLDS: [also_active_in_excluded_sector true, separation_of_activities_or_costs_ensured false]
  - FAILS: [also_active_in_excluded_sector false]; [separation_of_activities_or_costs_ensured true]
  - Referral key `separation_of_activities_or_costs_ensured`, cite `eu_reg_651_2014_art_1_t1`.
- **`recovery_order`** (A6)
  - HOLDS: [recovery_order_exclusion_applies true]
  - FAILS: [... false]
- **`difficulty`** (A7)
  - HOLDS: [undertaking_in_difficulty true, difficulty_exception_applies false, difficulty_2020_2021_derogation false]
  - FAILS: [undertaking_in_difficulty false]; [difficulty_exception_applies true]; [difficulty_2020_2021_derogation true]
  - Referral key `undertaking_in_difficulty`, cite `eu_reg_651_2014_art_1_4_c`.
- **`union_law_violation`** (A8)
  - HOLDS: [non_severable_violation_of_union_law true]
  - FAILS: [... false]
  - Referral cite `eu_reg_651_2014_art_1_5`.

**Transparency conditions** (HOLDS means transparent):

- **`transparent_form`** (C1)
  - HOLDS: [aid_form in {grant, interest_rate_subsidy}]; [aid_form in {loan, guarantee, tax_advantage, repayable_advance, sale_or_lease_of_tangible_assets}, form_transparency_condition_met true]
  - FAILS: [aid_form other_form]; [aid_form in {loan ... sale_or_lease_of_tangible_assets}, form_transparency_condition_met false]
- **`transparent_category`** (C2)
  - HOLDS: [category_transparency_condition_met true]
  - FAILS: [... false]
- **`transparent_general_test`** (C3)
  - HOLDS: [transparent_under_article_5_1 true]
  - FAILS: [... false]
  - Referral key `transparent_under_article_5_1`, cite `eu_reg_651_2014_art_5_1`.

**Incentive conditions** (HOLDS means an incentive effect):

- **`listed_category`** (D1)
  - HOLDS: [article_6_5_category_conditions_met true]
  - FAILS: [... false]
- **`tax_measure`** (D2)
  - HOLDS: [tax_measure_conditions_met true]
  - FAILS: [... false]
- **`written_application`** (D3)
  - These conjunctions are built from the dates by `written_application_conjunctions(ApplicationDate, WorkStartDate, Holds, Fails)`.
  - When `application_before_start` is true:
    - HOLDS: [application_contains_required_information true, aid_type in {scheme, individual_aid_under_scheme}]; [application_contains_required_information true, size_class in {micro_enterprise, small_enterprise, medium_sized_enterprise}]; [application_contains_required_information true, large_enterprise_verification_done true]
    - FAILS: [application_contains_required_information false]; [aid_type ad_hoc_aid, size_class in {large_enterprise, not_sme_public_control}, large_enterprise_verification_done false]
  - Otherwise: Holds = [] and Fails = [[]]. The empty conjunction is always MET with COST 0.

### Derived arithmetic

- `threshold_conjunctions(Category, ProjectAidCents, Exceeded, Within, Untested)`, in slice order:
  - A non-research row X gives [article_4_category X] as EXCEEDED if aid > FIGURE(X), else WITHIN.
  - A research row with aid at or below FIGURE gives WITHIN.
  - A research row with aid > 2 x FIGURE gives EXCEEDED.
  - Otherwise a research row gives [article_4_category X, research_project_doubled true] as WITHIN and [article_4_category X, research_project_doubled false] as EXCEEDED.
  - [article_4_category other_category] is UNTESTED.
  - The figure is read via `constant/1`, never inlined.
- `cumulation_exceeds(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints)` holds when (Aid + DeMinimis) x constant(basis_points_per_whole) > MaxIntensity x Eligible. The arithmetic is exact integer.
- `cumulation_aid_alone_exceeds/3` is the same test with the aid alone, used for the art_8_3 / art_8_3_b citations on not_allowed.
- `cumulation_conjunctions(Exceeds, NotAllowed, Allowed, Untested)`, where [identifiable_eligible_costs true] goes to exactly one of NotAllowed and Allowed, and Untested is [[identifiable_eligible_costs false]].

### Rules and requirements authored in this slice

1. The scope, transparency and incentive condition tables above.
2. The threshold rows with figures and citations: the row key; `eu_reg_651_2014_art_4_1_i` for research; `eu_reg_651_2014_art_4_1_i_iv` when WITHIN and aid > FIGURE.
3. The cumulation arithmetic and its citations:
   - not_allowed: art_8_3 and art_8_3_b only if aid alone exceeds, plus art_8_5 if de minimis > 0;
   - allowed: art_8_3, art_8_3_a and art_8_3_b, plus art_8_5 if de minimis > 0.
4. Referral rows `referral(Condition, JudgementKey, CiteKey, InputKeys)` for A1, A2, A5, A7, A8 and C3. InputKeys are the condition's keys, used by the pairs rule.
5. Checklist requirement rows `gber_general_conditions_requirement(TestId, Case, Status, Citation)`, one per test, three exclusive clauses (met / unmet / unknown) each. They are built from the query answers.

### Verdict atoms of this slice

All of section 2. The joined logic, steps 20 to 24, lives in queries.clausal and relies on:

- **AGAINST / FOR ways** per test, as in THE LIMBS.
- **MET IS POSSIBLE**: the FOR way of every test is possible.
- **THE WAY TO MET**: a `sum_way` of five parts. A part for a test with no possible AGAINST way counts as cost 0 when MET IS NOT POSSIBLE.
- **Pick candidate order**:
  1. A1 to A8 HOLDS, each its own way;
  2. the threshold EXCEEDED conjunctions;
  3. the all-fail way over C1 to C3;
  4. the all-fail way over D1 to D3;
  5. the cumulation NOT_ALLOWED conjunction;
  6. THE WAY TO MET.
- **Step 24 referral order**: A1 to A8 when the scope is OPEN, then C1 to C3 when transparency is OPEN.

### Predicates shared with another slice

None; there is only one slice. The engine, input check, date helpers and pairs rule sit in kernel.clausal because queries.clausal and the facade also call them, not because a second slice does.
