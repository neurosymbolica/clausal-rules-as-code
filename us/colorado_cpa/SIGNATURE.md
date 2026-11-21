# SIGNATURE — us/colorado_cpa

## Public query surface

### Status and verdict atoms

The scaffold placeholder `{ required, permitted, not_applicable }` is REPLACED by the atoms below.

**Coverage queries.**

- `applicability_status/3` gives one of `in_scope`, `biometric_only_scope`, `out_of_scope` or `exempt_entity`.
- `minors_duties_applicability/3` gives one of `in_scope`, `out_of_scope` or `exempt_entity`.
- The facade verdict `decide_colorado_cpa(Profile, colorado_cpa_verdict(Status, Citations))` mirrors `applicability_status/3`, so its STATUS is one of `in_scope`, `biometric_only_scope`, `out_of_scope` or `exempt_entity`.

**Deadline queries.**

- Each gives a `date(Year, Month, Day)` term.
- The two extended queries may instead give `no_extension_available`.
- `cure_period_last_day/4` may instead give `cure_provision_not_in_force`.
- `universal_opt_out_recognition_date/4` may instead give `no_recognition_duty`.

**Action status.** `attorney_general_action_status/5` gives one of:

- `cure_provision_not_in_force`
- `cure_requirement_not_applicable`
- `notice_not_yet_received`
- `cure_period_running`
- `action_may_be_brought`
- `no_action_for_cured_violation`

**Not-final answers.** Every query may instead give one of these status compounds, in place of the answer itself:

- `indeterminate([Key])`, naming exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on([Key-unsure])])`. An unscored `provenance(Step, Citations)` element may follow the `inputs_relied_on` element.
- `input_problems(Problems)`.

The CITATIONS of a not-final answer are `[]`.

**Result constructors.** These are exported and never called as queries:

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

**Totality and determinism.** Every query yields EXACTLY ONE solution for every term:

- one clause per disjoint route, with the ground answer folded into the head;
- no cut, no if-then-else;
- every non-input clause guarded by `Problems = []`.

**Figures.** No figure is imported. Every statutory figure is declared once in `colorado_cpa.clausal` with `constant_value/2`.

### Profile keys

There are fourteen keys, in root_exports and input_contract order. They are bare atoms, read only with `profile_get/3`.

| # | key | type | values |
|---|-----|------|--------|
| 1 | `entity_category` | enumeration | `financial_institution_or_affiliate_subject_to_glba`, `air_carrier`, `national_securities_association`, `none_of_the_exempt_categories` |
| 2 | `colorado_link_for_general_duties` | judgement | `true`, `false`, `unsure` |
| 3 | `consumer_count` | figure (unit: consumers) | non-negative integer |
| 4 | `revenue_or_discount_from_sale` | crisp | `true`, `false` |
| 5 | `processes_biometric_data` | crisp | `true`, `false` |
| 6 | `colorado_link_for_minors_duties` | judgement | `true`, `false`, `unsure` |
| 7 | `extension_reasonably_necessary` | judgement | `true`, `false`, `unsure` |
| 8 | `extension_notice_given_within_initial_period` | crisp | `true`, `false` |
| 9 | `appeal_extension_reasonably_necessary` | judgement | `true`, `false`, `unsure` |
| 10 | `appeal_extension_notice_given_within_initial_period` | crisp | `true`, `false` |
| 11 | `action_enforces_minors_duties` | crisp | `true`, `false` |
| 12 | `cure_deemed_possible` | crisp | `true`, `false` |
| 13 | `cured_within_cure_period` | crisp | `true`, `false` |
| 14 | `processes_for_targeted_advertising_or_sale` | crisp | `true`, `false` |

Notes on the keys:

- `consumer_count` keeps the contract's spelling, because the contract is non-negotiable. Its unit (consumers) is a count and is carried by the noun.
- No key uses the `attested/2` wrapper.

### Date arguments

The date arguments are not profile keys. Each is a ground `date(Year, Month, Day)` term of three bare integers naming a real Gregorian day, with a year from 2000 to 2100. A failed check is reported as `wrong_type(ArgumentName)`.

| Argument | ArgumentName |
|----------|--------------|
| RECEIVED | `received_date` |
| APPEAL_RECEIVED | `appeal_received_date` |
| NOTICE_RECEIVED | `notice_received_date` |
| REFERENCE_DATE | `reference_date` |
| LIST_ADDED_DATE | `list_added_date` |

### Citation-key atoms

The atoms follow the canonical scheme of `_lexicon/citations.yaml`. They are never shortened. The segments `us`, `co`, `crs`, `ccr` and `glba` are lexicon-given, not invented abbreviations.

- `us_co_crs_6_1_1304_1_a`
- `us_co_crs_6_1_1304_1_a_i_a`
- `us_co_crs_6_1_1304_1_a_i_b`
- `us_co_crs_6_1_1304_1_a_ii`
- `us_co_crs_6_1_1304_1_b`
- `us_co_crs_6_1_1304_2_l`
- `us_co_crs_6_1_1304_2_m`
- `us_co_crs_6_1_1304_2_q`
- `us_co_crs_6_1_1306_1_a_iv_b`
- `us_co_crs_6_1_1306_2_a`
- `us_co_crs_6_1_1306_2_b`
- `us_co_crs_6_1_1306_3_b`
- `us_co_crs_6_1_1311_1_d_ii`
- `us_co_ccr_904_3_rule_5_07_f`
- `us_co_ccr_904_3_rule_5_08_a`
- `us_co_ccr_904_3_rule_5_08_a_3`

### Public predicates

**The nine contract queries (queries.clausal, over the slice).**

- `applicability_status(Profile, Result, Citations)`: coverage by part 13 other than the minors' sections, by THE LIMBS steps (0) to (10). Citations: `us_co_crs_6_1_1304_1_a`, `_1_a_i_a`, `_1_a_i_b`, `_1_a_ii`, `_2_q`, `_2_l`, `_2_m`.
- `minors_duties_applicability(Profile, Result, Citations)`: coverage by [quotation omitted], by steps (11) to (18). Citations: `us_co_crs_6_1_1304_1_b`, `_2_q`, `_2_l`, `_2_m`.
- `response_deadline(Profile, Received, Deadline, Citations)`: Received + 45 days, by step (19). Citations: `us_co_crs_6_1_1306_2_a`, `us_co_crs_6_1_1306_2_b`.
- `extended_response_deadline(Profile, Received, Deadline, Citations)`: Received + 90 days, `no_extension_available` or a status, by steps (20) to (24). Citation: `us_co_crs_6_1_1306_2_a`.
- `appeal_response_deadline(Profile, AppealReceived, Deadline, Citations)`: AppealReceived + 45 days, by step (25). Citation: `us_co_crs_6_1_1306_3_b`.
- `extended_appeal_response_deadline(Profile, AppealReceived, Deadline, Citations)`: AppealReceived + 105 days, `no_extension_available` or a status, by steps (26) to (30). Citation: `us_co_crs_6_1_1306_3_b`.
- `cure_period_last_day(Profile, NoticeReceived, LastDay, Citations)`: NoticeReceived + 60 days when the notice falls in the in-force period, else `cure_provision_not_in_force`, by steps (31) and (32). Citation: `us_co_crs_6_1_1311_1_d_ii`.
- `attorney_general_action_status(Profile, NoticeReceived, ReferenceDate, Result, Citations)`: how the cure provision bears on an action on ReferenceDate, by steps (33) to (40). Citation: `us_co_crs_6_1_1311_1_d_ii`.
- `universal_opt_out_recognition_date(Profile, ListAddedDate, FirstDay, Citations)`: the later of 1 July 2024 and ListAddedDate + six months (same day number, clamped to the month end), else `no_recognition_duty` or a status, by steps (41) to (43). Citations: `us_co_crs_6_1_1306_1_a_iv_b`, `us_co_ccr_904_3_rule_5_08_a`, `us_co_ccr_904_3_rule_5_08_a_3`, `us_co_ccr_904_3_rule_5_07_f`.

**The input check (kernel.clausal, re-exported).**

- `colorado_cpa_input_problems(Profile, Problems)`: the bare problem list, with no wrapper. The list is built in this order:
  1. For each contract key in contract order: `duplicate_key(Key)` if it repeats, else `wrong_type(Key)` if its value is outside its type.
  2. Then `unknown_key(Key)`, in order of first occurrence.
  3. A malformed, unbound or partial profile gives `[wrong_type(profile)]` alone.

  This is a type check, not a legal rule, so it carries no citation.

**The facade (package facade; the scaffold names are kept).**

- `decide_colorado_cpa(Profile, colorado_cpa_verdict(Status, Citations))`: the facade verdict. It is `applicability_status/3` folded into one term, with the same citations.
- `colorado_cpa_status(Profile, Status)`: the Status of `decide_colorado_cpa/2` alone, for query type #3 (status determination). Citation: 6-1-1304(1)(a), (2).
- `colorado_cpa_checklist(Profile, Checklist)`: the justification, query type #7.
  - It is a list of `item(RequirementId, Status, cite(CitationKey))`, built with `formalize_lib:eval_requirements/4` over `colorado_cpa_requirement/4`.
  - The requirement ids are `not_exempt_entity`, `colorado_business_link`, `consumer_threshold` and `biometric_processing`.
  - Each item's Status is `met`, `unmet(Reason)` or `unknown([Key])`.
  - Each item carries its cite, met items included.
  - The checklist explains; `applicability_status/3` decides.
- `colorado_cpa_what_if(Profile, Key, Value, Status)`: the Status after overriding one key, via `query_combinators:what_if/5` with the closure `colorado_cpa_status`. Citation: as `colorado_cpa_status/2`.
- `colorado_cpa_consumer_threshold(RevenueOrDiscountFromSale, MinimumConsumerCount, Citations)`: the threshold boundary, query type #6. Citation: `us_co_crs_6_1_1304_1_a_i_b`.
  - With `true` it gives 25000.
  - With `false` it gives 100000.
  - The boundary is inclusive: at MinimumConsumerCount and above, limb (I)(B) is met.

**Fixtures (fixtures.clausal; the scaffold name is kept).**

- `colorado_cpa_fixture(FixtureName, Profile)`: named, well-formed and malformed profiles for the seven test modes.

**Query types served.**

| # | Query type | Served by |
|---|------------|-----------|
| #15 | deadline | the six date queries |
| #6 | threshold | `colorado_cpa_consumer_threshold/3` |
| #3 | status determination | `colorado_cpa_status/2`, `applicability_status/3`, `minors_duties_applicability/3`, `attorney_general_action_status/5` |
| #23 | calculation | the computed dates: day counts 45, 90, 105, 60 and six months, each as a date term |
| #7 | justification | `colorado_cpa_checklist/2` |

### Planned reuse (manifest `uses:`)

- **`formalize_lib`**: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `eval_requirements/4`, `check_tri/4`, `check_eq/5`, `item/3`, `attribute/2`, `unmet/1`, `unknown/1`, `memberd/2`, `not_member/2`.
- **`library(datetime)`** (native datetime, the date_time module): `date_add/3`, `timedelta/3`, `days_between/3`, `date_max/3`. These run on `date/4` objects inside the kernel only. The contract terms stay `date(Y, M, D)`.
- **`kit/deadline_lib`**: `month_last_day/3` only, for the six-month clamp and the day-of-month validity check.
  - `deadline_months_after/3` is deliberately NOT used: its semantics are the last day of the period counted from the day after the anchor, which is not the same day number.
- **`kit/query_combinators`**: `what_if/5`, for `colorado_cpa_what_if/4`.
- **`validate_props`** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.
- **Not used**: `compliance_lib` and `rolling_window`. There is no compliance verdict and no look-back window.

## kernel.clausal — the shared floor

The kernel holds ONLY what is shared, or is not legal content. It holds no statutory figures.

- `colorado_cpa_input_problems(Profile, Problems)`: the typed input check described above, with the contract key order as a local `contract_key(Position, Key, Type)` table.
  - The types are `enumeration(Atoms)`, `judgement`, `crisp` and `figure`.
  - It needs a list walk for duplicates and unknowns. Values are still read only through `profile_get/3`.
- `date_term_valid(Term)`: the term is a ground `date(Y, M, D)` of integers with 2000 =< Y =< 2100, 1 =< M =< 12, and 1 =< D =< the month's last day (`month_last_day/3`).
- `date_argument_problems(NamedDates, Problems)`: `wrong_type(Name)` for each invalid `Name-Date` pair, in signature order.
- `query_problems(Profile, NamedDates, Problems)`: the profile problems followed by the date problems, as in step (0).
- `date_plus_days(DateTerm, Days, ResultTerm)`: converts to a native date object, applies `date_add/3` with `timedelta(Days, 0, Delta)`, and converts back to `date(Y, M, D)`.
- `date_plus_months_same_day(DateTerm, Months, ResultTerm)`: the same day number in the target month, else that month's last day.
- `date_earlier(First, Second)` and `date_on_or_earlier(First, Second)`: chronological order, by the sign of `days_between/3` on native objects.
- `date_later_of(First, Second, Later)`: one solution even when the dates are equal.

## Determination slice: colorado_cpa.clausal

This slice is self-contained. It owns every value fact, the derived arithmetic, the rules, the requirements, the per-rule tests, the checklist and the verdict.

### Value facts owned (`constant_value/2`)

**Thresholds and periods.**

- `general_consumer_threshold`: 100000 (6-1-1304(1)(a)(I)(B)).
- `sale_consumer_threshold`: 25000 (6-1-1304(1)(a)(I)(B)).
- `response_period_days`: 45 (6-1-1306(2)(a), (b)).
- `response_extension_days`: 45 (6-1-1306(2)(a)). The extended total of 90 is DERIVED.
- `appeal_response_period_days`: 45 (6-1-1306(3)(b)).
- `appeal_extension_days`: 60 (6-1-1306(3)(b)). The extended total of 105 is DERIVED.
- `cure_period_days`: 60 (6-1-1311(1)(d)(II)).
- `opt_out_notice_months`: 6 (Rules 5.07(F), 5.08(A)(3)).

**Fixed dates.**

- `universal_opt_out_effective_date`: `date(2024, 7, 1)` (6-1-1306(1)(a)(IV)(B); Rule 5.08(A)).
- `cure_provision_first_day`: `date(2025, 10, 1)` (Q4).
- `cure_provision_last_day`: `date(2026, 12, 30)` (Q3).
- `cure_provision_repeal_day`: `date(2026, 12, 31)`.

### Rules and requirements

**Applicability (steps 1 to 10).**

- One clause each for the absent category and for each of the three exempt categories, each folding `exempt_entity` and its single cite.
- `threshold_met/1`: `consumer_count >= 100000`, or `consumer_count >= 25000` with sale revenue true.
- `threshold_failed/1`: `consumer_count < 25000`, or a count from 25000 to 99999 with sale revenue false.
- `limb_one_met/1`: link true and threshold met.
- `limb_one_failed/1`: link false or threshold failed. It has two clauses, so it needs a disjointness guard: the threshold-failed clause requires the link not false.
- With limb (I) failed: `out_of_scope`, `biometric_only_scope`, or `indeterminate([processes_biometric_data])`.
- With limb (I) neither met nor failed:
  1. `first_missing_applicability_key/2`: the link, then the count, then sale revenue (only for a count from 25000 to 99999), then biometric.
  2. Otherwise, the link unsure gives `needs_legal_review` with cite `us_co_crs_6_1_1304_1_a_i_a`.

**Minors' duties (steps 11 to 18).** The exempt categories are checked first. Then the link: false gives `out_of_scope`, absent gives indeterminate, unsure gives review with cite `us_co_crs_6_1_1304_1_b`, and true gives `in_scope`.

**Response deadline (step 19).** Received + `response_period_days`.

**Extended response deadline (steps 20 to 24).** In order:

1. Notice false gives `no_extension_available`.
2. Notice not false and necessity false gives `no_extension_available`.
3. The first absent key, of necessity then notice, gives indeterminate.
4. Necessity unsure gives review.
5. Both true give Received + (45 + 45).

**Appeal deadlines (steps 25 to 30).** Mirror the response deadlines with the appeal keys. The extended total is 45 + 60.

**Cure period last day (steps 31 and 32).** A notice before the first day, or on or after the repeal day, gives `cure_provision_not_in_force`. Otherwise the answer is NoticeReceived + 60.

**Action status (steps 33 to 40).** In order:

1. A reference day out of force gives `cure_provision_not_in_force`.
2. Either key false gives `cure_requirement_not_applicable`.
3. The first absent key gives indeterminate.
4. A reference day before the notice, or a notice before the first day, gives `notice_not_yet_received`.
5. A reference day on or before notice + 60 gives `cure_period_running`.
6. After that, cured false gives `action_may_be_brought`, absent gives indeterminate, and true gives `no_action_for_cured_violation`.

**Opt-out recognition date (steps 41 to 43).** Processing false gives `no_recognition_duty`. Absent gives indeterminate. True gives `date_later_of(date(2024,7,1), ListAdded + 6 months)`.

**Requirements for the checklist (`colorado_cpa_requirement(RequirementId, Profile, Status, Citation)`, RequirementId first).** Each has three exclusive clauses: met, unmet and unknown.

| RequirementId | Checks | Cite |
|---------------|--------|------|
| `not_exempt_entity` | the entity category | the 2(q), 2(l) or 2(m) clause given, else `_1304_1_a` |
| `colorado_business_link` | the link, via `check_tri` (unsure gives unknown) | `us_co_crs_6_1_1304_1_a_i_a` |
| `consumer_threshold` | the thresholds | `us_co_crs_6_1_1304_1_a_i_b` |
| `biometric_processing` | biometric processing | `us_co_crs_6_1_1304_1_a_ii` |

### Verdict atoms (this slice)

- `in_scope`
- `biometric_only_scope`
- `out_of_scope`
- `exempt_entity`
- `no_extension_available`
- `cure_provision_not_in_force`
- `cure_requirement_not_applicable`
- `notice_not_yet_received`
- `cure_period_running`
- `action_may_be_brought`
- `no_action_for_cured_violation`
- `no_recognition_duty`
- the status compounds

### Shared with the kernel (and only these)

The slice imports:

- `query_problems/3`
- `date_plus_days/3`
- `date_plus_months_same_day/3`
- `date_earlier/2`
- `date_on_or_earlier/2`
- `date_later_of/3`

Nothing else crosses the boundary.

### Boundary fixtures and expected values (per-rule tests; calendar arithmetic checked by hand)

**Consumer count.**

| Count | Sale revenue | Limb (I)(B) |
|-------|--------------|-------------|
| 24999 | true | failed |
| 25000 | true | met |
| 25000 | false | failed |
| 99999 | false | failed |
| 100000 | false | met |

**Day counts.**

| Query | Start | Result |
|-------|-------|--------|
| response | `date(2026,1,1)` | `date(2026,2,15)` |
| extended response | `date(2026,1,1)` | `date(2026,4,1)` |
| extended appeal | `date(2026,1,1)` | `date(2026,4,16)` |
| cure (notice) | `date(2026,11,15)` | `date(2027,1,14)` (after 30 Dec 2026, as Q5 allows) |

**The cure provision in force.**

| Notice or reference day | Answer |
|-------------------------|--------|
| `date(2025,9,30)` | not in force |
| `date(2025,10,1)` | in force |
| `date(2026,12,30)` | in force |
| `date(2026,12,31)` | not in force |

**Opt-out first day.**

| List added | First day |
|------------|-----------|
| `date(2024,3,15)` | `date(2024,9,15)` |
| `date(2023,11,1)` | `date(2024,7,1)` |
| `date(2024,1,1)` | `date(2024,7,1)` (the two dates are equal, one solution) |
| `date(2027,8,31)` | `date(2028,2,29)` |
| `date(2026,8,31)` | `date(2027,2,28)` |

**Invalid dates.**

| Date | Answer |
|------|--------|
| `date(2027,2,29)` | `wrong_type(received_date)` |
| `date(1999,12,31)` | `wrong_type(list_added_date)` |
