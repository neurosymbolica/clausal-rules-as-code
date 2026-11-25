# SIGNATURE — eu/dora_incident_classification_thresholds

This is the authoring plan for phases P2 onward. It does not restructure the package. The layout is:

`kernel.clausal -> citations.clausal -> parameters.clausal -> dora_incident_classification_thresholds.clausal -> queries.clausal -> fixtures.clausal -> package facade`

File and module names stay as scaffolded. The manifest is v2, with seven test modes.

## 1. Public query surface

### Called contract (exact; queries.clausal, exported through the facade)

- `dora_incident_threshold_status(Profile, Threshold, Status, Citations)`
  - Takes ONE of the eight condition atoms.
  - Status is `met`, `not_met`, `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` or `input_problems(Problems)`.
  - Citations are the fixed list of the condition for a final answer, and `[]` otherwise.
  - Cites Art 18(1) DORA plus the condition's articles (section 4).
- `dora_final_report_timeliness(Profile, LatestIntermediateDate, FinalDate, Result, Citations)`
  - Result is `on_time`, `late(month_limit)`, `indeterminate([final_report_weekend_extension])` or `input_problems(Problems)`. It never refers.
  - Citations are `[cite(eu_reg_2025_301_art_5_1_c)]` when FinalDate is on or before DUE.
  - Citations are `[cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)]` when the weekend key decides.
  - Cites Art 5(1)(c) and (4) to (6) of 2025/301.
- `dora_incident_classification_thresholds_input_problems(Profile, Problems)`
  - The profile-only input check (kernel). Problems is `[]` or a list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms, in the INPUT CHECK order.
  - Cites the typed input_contract.

### Totality and determinism

- Every call of the three predicates yields EXACTLY ONE solution, on every term, unbound arguments included. Each call never raises and never fails.
- One solution is achieved by construction, without `!`, `->`, `*->` or `once/1`:
  - mutually exclusive step clauses, with each step guarded by the negation of the earlier steps;
  - the 'first in root_exports order' selections done by `findall/3` over an ordered key list, then taking the head of the list.

### Facade (package facade; scaffold names kept)

Request is `threshold_request(Profile, Threshold)` or `final_report_request(Profile, LatestIntermediateDate, FinalDate)`.

- `decide_dora_incident_classification_thresholds(Request, Verdict)`
  - Verdict is `dora_incident_classification_thresholds_verdict(Status, Citations)`, where Status and Citations are exactly those of the called predicate.
  - Query type #2 (eligibility).
  - The eligibility labels are `labels(met, indeterminate, not_met)` for a threshold request and `labels(on_time, indeterminate, late(month_limit))` for a final-report request.
  - Cites as the called predicate.
- `dora_incident_classification_thresholds_status(Request, Status)`: Status alone. Cites as the called predicate.
- `dora_incident_classification_thresholds_checklist(Request, Checklist)`
  - The cited checklist: a list of `item(PointId, PointState, cite(CitationKey))` (formalize_lib `item/3`), PointState `met`, `closed` or `open`.
  - For a threshold request it is built with formalize_lib `eval_requirements/4` over the condition's point ids, with requirement closure `dora_incident_classification_thresholds_point`.
  - For a final-report request it holds `item(final_report_month_limit, State, cite(eu_reg_2025_301_art_5_1_c))` and `item(final_report_weekend_extension, State, cite(eu_reg_2025_301_art_5_4))`.
  - It yields `[]` when the input check finds problems.
- `dora_incident_classification_thresholds_what_if(Request, Key, Value, Verdict)`
  - The verdict of Request with `attribute(Key, Value)` set in its profile, via formalize_lib `profile_set/3`.
  - It is decided by `decide_dora_incident_classification_thresholds/2`, and gives one solution.
- `dora_incident_classification_thresholds_deadline(LatestIntermediateDate, DueDate)`
  - Query type #15 (deadline): DUE, the last day on which the final report is in time.
  - The consequence of missing it is `late(month_limit)` unless `final_report_weekend_extension` is true.
  - Wrong date arguments give no solution here, because this is a helper. The checked route is `dora_final_report_timeliness/5`.
  - Cites `eu_reg_2025_301_art_5_1_c`.
- **Fixtures** (fixtures.clausal): `dora_incident_classification_thresholds_fixture(Name, Request, ExpectedVerdict)`. See section 7.

## 2. Verdict / STATUS atoms (replacing the scaffold `satisfied / not_satisfied`)

- **Threshold query final answers:** `met`, `not_met`.
- **Final report final answers:** `on_time`, `late(month_limit)`. `late/1`'s argument is always the atom `month_limit`.
- **Status compounds (never final):** `indeterminate([Key])` with exactly one bare key, `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` and `input_problems(Problems)`. The bare atom `indeterminate` is NEVER written.
- **Problem terms:** `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, plus the argument problems `wrong_type(profile)`, `wrong_type(threshold)`, `wrong_type(latest_intermediate_date)` and `wrong_type(final_date)`.
- **Part and point states (internal and in the checklist):** `met`, `closed`, `open`.
- **verdict_vocabulary** pins `met`, `not_met`, `on_time`, `late`, `month_limit`, `indeterminate`, `needs_legal_review`, `input_problems`, plus the eight condition atoms. It never pins `true` or `false`.
- **Result constructors** (exported, never queries): `late/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### The eight condition atoms (values of Threshold, never profile keys)

`critical_services_affected`, `data_losses_malicious_access_threshold_met`, `clients_financial_counterparts_and_transactions_threshold_met`, `reputational_impact_threshold_met`, `duration_and_service_downtime_threshold_met`, `geographical_spread_threshold_met`, `data_losses_impact_threshold_met`, `economic_impact_threshold_met`.

## 3. Profile keys (thirty-six, in root_exports / input_contract order)

Types:

- **J** is a judgement: the atom `true`, `false` or `unsure`.
- **N** is a non-negative integer.
- **F** is a fact: the atom `true` or `false` only.

The profile is read only with formalize_lib `profile_get/3`, by presence first and then by value.

| # | Key | Type | Rule |
|---|---|---|---|
| 1 | `affects_ict_services_supporting_critical_or_important_functions` | J | Art 6(a) |
| 2 | `affects_authorised_registered_or_supervised_financial_services` | J | Art 6(b) |
| 3 | `successful_malicious_unauthorised_access` | J | Art 6(c) and Art 9(5)(b) |
| 4 | `access_may_result_in_data_losses` | J | Art 9(5)(b) |
| 5 | `affected_clients` | N | Art 1(1), 9(1)(a)(b) |
| 6 | `clients_using_affected_service` | N | Art 9(1)(a) |
| 7 | `affected_financial_counterparts` | N | Art 1(2), 9(1)(c) |
| 8 | `financial_counterparts_of_affected_service` | N | Art 9(1)(c) |
| 9 | `affected_transactions_number` | N | Art 1(4), 9(1)(d) |
| 10 | `affected_transactions_amount` | N, caller currency unit | Art 9(1)(e) |
| 11 | `reference_period_transactions_number` | N | Art 9(1)(d) |
| 12 | `reference_period_transactions_amount` | N, same unit as 10 | Art 9(1)(e) |
| 13 | `reference_period_days` | N | Art 1(5), 9(1)(d)(e) |
| 14 | `relevant_clients_or_financial_counterparts_affected` | J | Art 1(3), 9(1)(f) |
| 15 | `incident_reflected_in_media` | J | Art 2(1)(a) |
| 16 | `repetitive_complaints_from_different_clients_or_counterparts` | J | Art 2(1)(b) |
| 17 | `regulatory_requirements_likely_not_met` | J | Art 2(1)(c) |
| 18 | `material_loss_of_clients_or_counterparts_likely` | J | Art 2(1)(d) |
| 19 | `incident_duration_seconds` | N | Art 3(1), 9(3)(a) |
| 20 | `critical_or_important_function_service_downtime_seconds` | N | Art 3(2), 9(3)(b) |
| 21 | `member_states_with_impact` | N | Art 4, 9(4) |
| 22 | `data_impact_adverse_to_business_objectives_or_regulatory_requirements` | J | Art 9(5)(a) |
| 23 | `data_availability_impact` | J | Art 5(a) |
| 24 | `data_authenticity_impact` | J | Art 5(b) |
| 25 | `data_integrity_impact` | J | Art 5(c) |
| 26 | `data_confidentiality_impact` | J | Art 5(d) |
| 27 | `expropriated_funds_and_assets_cents` | N | Art 7(1)(a) |
| 28 | `replacement_and_relocation_costs_cents` | N | Art 7(1)(b) |
| 29 | `staff_costs_cents` | N | Art 7(1)(c) |
| 30 | `contractual_non_compliance_fees_cents` | N | Art 7(1)(d) |
| 31 | `redress_and_compensation_costs_cents` | N | Art 7(1)(e) |
| 32 | `forgone_revenue_losses_cents` | N | Art 7(1)(f) |
| 33 | `communication_costs_cents` | N | Art 7(1)(g) |
| 34 | `advisory_costs_cents` | N | Art 7(1)(h) |
| 35 | `costs_and_losses_likely_to_exceed_threshold` | J | Art 9(6) |
| 36 | `final_report_weekend_extension` | F | Art 5(4) of 2025/301 |

### Notes on the keys

- **Dates are arguments, not profile keys.** They are ground `date(Year, Month, Day)` integer terms of a real Gregorian day.
- **Unsuffixed integer keys.** Each integer key carries its unit in its name where it has one (`_seconds`, `_cents`, `_days`). Counts, the transaction amount (caller currency) and Member State counts are unit-free counts, as the order fixes the names.
- **No attested wrapper.** No key uses the attested wrapper (ruling 2) and there are no outside facts, so <<DNUM>>, <<DNUM>> and <<DNUM>> do not arise.

## 4. Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; citation_vocabulary)

| Citation key | Provision |
|---|---|
| `eu_reg_2022_2554_art_18_1` | DORA Art 18(1)(a) to (f) |
| `eu_reg_2024_1772_art_1` | Art 1 |
| `eu_reg_2024_1772_art_2` | Art 2 |
| `eu_reg_2024_1772_art_3` | Art 3 |
| `eu_reg_2024_1772_art_4` | Art 4 |
| `eu_reg_2024_1772_art_5` | Art 5 |
| `eu_reg_2024_1772_art_6` | Art 6 |
| `eu_reg_2024_1772_art_7` | Art 7 |
| `eu_reg_2024_1772_art_8_1` | Art 8(1) |
| `eu_reg_2024_1772_art_9_1` | Art 9(1) |
| `eu_reg_2024_1772_art_9_2` | Art 9(2) |
| `eu_reg_2024_1772_art_9_3` | Art 9(3) |
| `eu_reg_2024_1772_art_9_4` | Art 9(4) |
| `eu_reg_2024_1772_art_9_5_a` | Art 9(5)(a) |
| `eu_reg_2024_1772_art_9_5_b` | Art 9(5)(b) |
| `eu_reg_2024_1772_art_9_6` | Art 9(6) |
| `eu_reg_2025_301_art_5_1_c` | Art 5(1)(c) of 2025/301 |
| `eu_reg_2025_301_art_5_4` | Art 5(4) of 2025/301 |
| `eu_reg_2025_301_art_5_5` | Art 5(5) of 2025/301 |
| `eu_reg_2025_301_art_5_6` | Art 5(6) of 2025/301 |

### citations.clausal

- `citation(Key, Instrument, Unit, Gloss)` rows, with the pinned unit ids. For example, `eu_reg_2024_1772_art_9_5_b` maps to `32024R1772#point_009.005_b`.
- The segment `reg` is the canonical lexicon form. It is not on the C6 blocked list.
- No shortened atom is ever invented.

### Fixed final-answer citations per condition (set-like, each once)

| Condition | Citations |
|---|---|
| `critical_services_affected` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_8_1), cite(eu_reg_2024_1772_art_6)]` |
| `data_losses_malicious_access_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_b)]` |
| `clients_financial_counterparts_and_transactions_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)]` |
| `reputational_impact_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_2), cite(eu_reg_2024_1772_art_2)]` |
| `duration_and_service_downtime_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_3), cite(eu_reg_2024_1772_art_3)]` |
| `geographical_spread_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_4), cite(eu_reg_2024_1772_art_4)]` |
| `data_losses_impact_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_a), cite(eu_reg_2024_1772_art_5)]` |
| `economic_impact_threshold_met` | `[cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)]` |

### Referral citation per condition (the `citation` of the referral row)

| Condition | Referral citation |
|---|---|
| `critical_services_affected` | `cite(eu_reg_2024_1772_art_6)` |
| `data_losses_malicious_access_threshold_met` | `cite(eu_reg_2024_1772_art_9_5_b)` |
| `clients_financial_counterparts_and_transactions_threshold_met` | `cite(eu_reg_2024_1772_art_9_1)` |
| `reputational_impact_threshold_met` | `cite(eu_reg_2024_1772_art_9_2)` |
| `data_losses_impact_threshold_met` | `cite(eu_reg_2024_1772_art_9_5_a)` |
| `economic_impact_threshold_met` | `cite(eu_reg_2024_1772_art_9_6)` |

Duration and geographical spread never refer.

## 5. Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3`: the ONLY profile reader.
- `profile_set/3`: what_if.
- `eval_requirements/4` and `item/3`: the checklist. A hand-rolled findall-over-item would trip lint R1.
- `sum_list/2`: the Art 7(4) sum.
- `attribute/2`: the profile element shape.

`check_tri/4` and `ratio_bps/4` are NOT used:

- The tri-state here is a part state (met, closed, open) with absence distinct from unsure.
- `ratio_bps/4` divides with `//` and fail-closes a zero denominator. Both contradict the exact cross-multiplied tests and the Q8 reading. A clone would trip C14 or C15, so the tests are written as plain cross-multiplication, not as a bps helper.

### kit/deadline_lib

- `month_last_day/3`: the clamping in `one_month_after/2`, and the real-day check of date arguments.
- `deadline_months_after/3` is NOT used. It has a different month rule (see NOTES S2).

### kit/query_combinators

- `what_if/5`: the facade what_if delegates to it, with the decide closure `decide_request_profile(Request)`.

### validate_props (tests only)

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `prop_citation_complete/3`, `bad_citation/1`.

### library(datetime)

- No day arithmetic is needed. The one-month rule is integer field arithmetic plus `month_last_day/3`, and comparison is integer-lexicographic on (Year, Month, Day), as step B1 defines.
- The contract fixes `date(Y, M, D)` compound arguments. Per the date_time card, date/3 objects are not yet registered, and compound `@<` is not relied on.
- The 'native datetime' idiom is therefore satisfied by not hand-rolling any day count.

### Not used

`compliance_lib`, `rolling_window`, `country`, `currency_vocab`, `vat_category`. Member States are a count, not a list of countries. Amounts are cents or a caller unit, never a currency atom.

## 6. Files other than the slice

### kernel.clausal (shared floor)

Kernel holds only what queries.clausal and the slice both need:

- `contract_key(Key, Type)`: thirty-six rows in root order, Type `judgement`, `non_negative_integer` or `fact`.
- `contract_keys(Keys)`: the ordered list.
- `value_has_type(Type, Value)`: integer >= 0; `true`, `false`, `unsure`; `true`, `false`. An unbound value, a float and the atoms `true`/`false` (for integers) all fail it.
- `attribute_list(Profile)`: a proper list of `attribute(_, _)`, with no unbound or partial tail and no unbound or other element.
- `dora_incident_classification_thresholds_input_problems(Profile, Problems)`, built in this order:
  1. For each contract key in contract order: `duplicate_key(Key)` if it occurs twice or more (the value is not read); else `wrong_type(Key)` if its single value fails `value_has_type`.
  2. Then `unknown_key(Key)` for each non-contract key, distinct by `==`, in order of first occurrence. The value is never checked. Non-atom and unbound keys are reported as given.
  3. A non-attribute-list gives `[wrong_type(profile)]` alone.
- `condition_atom(Threshold)`: the eight atoms, tested with a ground atom guard so that an unbound Threshold is wrong_type.
- `real_date(Date)`: a ground `date(Y, M, D)` with integer Y, M in 1..12 and D in 1..LastDay by `month_last_day/3`. `date(2025, 2, 29)` fails; `date(2024.0, 1, 1)` fails.
- `argument_problems_threshold(Threshold, Problems)` and `argument_problems_dates(LatestIntermediateDate, FinalDate, Problems)`: appended after the profile problems.

Full words throughout. Every clause has exactly one solution by exclusive guards.

### parameters.clausal

Empty of statutory figures: every figure lives in its slice. It only re-exports nothing (kept for layout).

### queries.clausal

The three called-contract predicates. Step T0 / B0 is the kernel check plus the argument problems. Steps T1 to T4 and B1 to B3 come from the slice.

## 7. Fixtures (fixtures.clausal) — expected answers, from the readings

### Threshold fixtures

| Fixture | Profile | Threshold | Expected |
|---|---|---|---|
| `fixture_clients_over_absolute_limit` | `affected_clients` 100001, others absent | clients | `met` |
| `fixture_clients_exactly_at_absolute_limit` | `affected_clients` 100000, `clients_using_affected_service` 1000000, others absent | clients | `indeterminate([affected_financial_counterparts])`. Points (a) and (b) are closed; point (c) has its affected figure absent, so `affected_financial_counterparts` (key 7) is the first absent key not behind another. |
| `fixture_clients_zero_days_closes_transactions` | every Art 9(1) key present with `affected_clients` 0, `affected_financial_counterparts` 0, `reference_period_days` 0 and point (f) false | clients | `not_met` |
| `fixture_clients_days_named_first` | `affected_clients` 0, point (f) false, `affected_financial_counterparts` 0, points (d) and (e) absent | clients | `indeterminate([reference_period_days])` |
| `fixture_duration_exactly_24_hours` | `incident_duration_seconds` 86400, `critical_or_important_function_service_downtime_seconds` 7200 | duration | `not_met` |
| `fixture_downtime_over_2_hours` | `critical_or_important_function_service_downtime_seconds` 7201 | duration | `met` |
| `fixture_two_member_states` | `member_states_with_impact` 2 | geographical | `met` |
| `fixture_one_member_state` | `member_states_with_impact` 1 | geographical | `not_met` |
| `fixture_data_impact_authenticity_named` | adverse `unsure`, availability `unsure`, authenticity absent | data impact | `indeterminate([data_authenticity_impact])` |
| `fixture_data_impact_referred` | adverse `unsure`, availability `true`, others `false` | data impact | `needs_legal_review(open_textured(data_impact_adverse_to_business_objectives_or_regulatory_requirements, cite(eu_reg_2024_1772_art_9_5_a)), [inputs_relied_on([data_impact_adverse_to_business_objectives_or_regulatory_requirements-unsure, data_availability_impact-true, data_authenticity_impact-false, data_integrity_impact-false, data_confidentiality_impact-false])])` |
| `fixture_economic_exactly_at_limit` | eight amounts summing to 10000000, judgement `false` | economic | `not_met` |
| `fixture_economic_one_cent_over` | eight amounts summing to 10000001 | economic | `met` |
| `fixture_economic_first_amount_named` | all absent | economic | `indeterminate([expropriated_funds_and_assets_cents])` |
| `fixture_access_both_true` | keys 3 and 4 `true` | access | `met` |
| `fixture_critical_services_all_false` | keys 1 to 3 `false` | critical services | `not_met` |
| `fixture_unknown_key_and_wrong_type` | `[attribute(staff_costs_cents, 12.5), attribute(colour, red)]` | economic | `input_problems([wrong_type(staff_costs_cents), unknown_key(colour)])` |
| `fixture_bad_threshold` | `[]` | `major` | `input_problems([wrong_type(threshold)])` |

### Final-report fixtures

| Fixture | Latest intermediate | Final | Weekend key | Expected |
|---|---|---|---|---|
| `fixture_final_report_leap_year` | `date(2024, 1, 31)` | `date(2024, 2, 29)` | absent | `on_time` (DUE 29 Feb 2024) |
| `fixture_final_report_late` | `date(2025, 1, 31)` | `date(2025, 3, 1)` | `false` | `late(month_limit)` (DUE 28 Feb 2025) |
| `fixture_final_report_weekend_extension` | `date(2025, 5, 31)` | `date(2025, 7, 1)` | `true` | `on_time` (DUE 30 Jun 2025) |
| `fixture_final_report_weekend_key_needed` | `date(2025, 12, 15)` | `date(2026, 1, 16)` | absent | `indeterminate([final_report_weekend_extension])` |
| `fixture_final_report_not_a_date` | `date(2025, 2, 29)` | `date(2025, 3, 1)` | — | `input_problems([wrong_type(latest_intermediate_date)])` |

## 8. Determination slice: dora_incident_classification_thresholds.clausal

This is the ONE slice. It is self-contained for the eight Art 8(1) conditions and for the final-report time limit.

### 8.1 Statutory VALUE facts owned by this slice

They are declared here, read with `#Name`, and never inlined.

- `:- constant_value(percentage_scale, 10).`
  - It is the multiplier of each affected figure in the cross-multiplied tests (10 % and 30 %).
- `:- constant_value(counterparts_share_tenths, 3).`
  - Art 9(1)(c), 30 %: `affected * #percentage_scale > total * #counterparts_share_tenths`.
  - The 10 % tests compare with `total * 1`.
- `:- constant_value(affected_clients_limit, 100000).` — Art 9(1)(b), strictly higher than.
- `:- constant_value(incident_duration_limit_seconds, 86400).` — Art 9(3)(a), 24 hours, strictly longer than.
- `:- constant_value(service_downtime_limit_seconds, 7200).` — Art 9(3)(b), 2 hours, strictly longer than.
- `:- constant_value(member_states_minimum, 2).` — Art 9(4), two or more (`>=`).
- `:- constant_value(economic_impact_limit_eur_cents, 10000000).` — Art 9(6), 100 000 euro, exceeded (`>`).
- `:- constant_value(final_report_period_months, 1).` — Art 5(1)(c) of 2025/301.

### 8.2 Tables owned by this slice

- `condition_citations(Condition, Citations)`: eight rows (section 4).
- `condition_referral_citation(Condition, Citation)`: six rows.
- `condition_keys(Condition, Keys)`: THE KEYS OF EACH CONDITION, in root order. These are also each referral row's `inputs`.
- `condition_point(Condition, PointId)`, in this order:
  - critical services: `critical_services_point_a`, `critical_services_point_b`, `critical_services_point_c`;
  - access: `malicious_access_point`;
  - clients: `clients_point_a` to `clients_point_f`;
  - reputational: `reputational_point_a` to `reputational_point_d`;
  - duration: `duration_point_a`, `downtime_point_b`;
  - geographical: `geographical_spread_point`;
  - data impact: `data_impact_point`;
  - economic: `economic_sum_point`, `economic_likelihood_point`.
- `point_part(PointId, Part)`. Part is one of:
  - `judgement_part(Key)`;
  - `any_of_part([Keys])`;
  - `limit_part(Key, Comparison, ConstantName)`, Comparison `above` or `at_least`;
  - `ratio_part(AffectedKey, TotalKey, ShareTenths)` for Art 9(1)(a) and (c);
  - `ratio_days_part(AffectedKey, TotalKey)` for Art 9(1)(d) and (e);
  - `sum_part([EightAmountKeys], ConstantName)`.
- `point_citation(PointId, cite(Key))`, for the checklist: the condition's measuring or threshold article. For example:
  - `clients_point_f` gives `eu_reg_2024_1772_art_9_1`;
  - `critical_services_point_c` gives `eu_reg_2024_1772_art_6`.
- `condition_group(Condition, GroupId, PointIds)`: the key-disjoint groups of points. Each point is its own group, except two clients groups:
  - `clients_count_group` is points a and b, which share `affected_clients`;
  - `clients_transactions_group` is points d and e, which share `reference_period_days`.

### 8.3 Rules (requirements)

**R-part (part state on the profile).** Each part is `met`, `closed` or `open`, by THE LIMBS.

- **Judgement part.** `true` means met, `false` means closed, `unsure` or absent means open.
- **Any-of part.** Met when some key is `true`; closed when all keys are `false`; open otherwise.
- **Limit part.** Met when the key is present and the test holds; closed when it is present and the test fails; open when the key is absent.
- **Ratio part.** Met when all keys are present and the test holds. Closed when:
  - the affected figure is 0;
  - for a days part, the days are 0; or
  - all keys are present and the test fails.

  Open otherwise.
- **Sum part.** Met when the sum of the present amounts > limit (`sum_list/2`); closed when all eight are present and the sum <= limit; open otherwise.

**R-point.** A point is met when all its parts are met, closed when some part is closed, and open otherwise. The predicate is `dora_incident_classification_thresholds_point(PointId, Profile, PointState, Citation)`. It is the `eval_requirements/4` closure, with RequirementId first.

**T1 (met).** Some point of the condition is met. The status is `met`, with the condition's citations.

**T2 (not met).** Every point of the condition is closed. The status is `not_met`, with the condition's citations.

**T3 (one missing key).**

- Candidates are the absent keys of open parts of open points, in root order.
- 'Can still change the answer' and 'BEHIND' are computed by THE COMPLETION MEANING on finite witness values, factorised by group. The groups are key-disjoint, so the condition is not met iff every group is not met.
- **Witness values for an absent key or an unsure judgement:**
  - a judgement takes `true` or `false`;
  - an affected figure, `reference_period_days`, `incident_duration_seconds`, the downtime, `member_states_with_impact` and each amount take 0, 1 or Large;
  - a total takes 0 or Huge.
- **Large and Huge.** Large = 1 + the largest present integer of the condition + `#affected_clients_limit` + `#economic_impact_limit_eur_cents`. Huge = 10 * Large * Large * Large + 1. So any absent figure can be made large enough, and any absent total can exceed every product affected * 10 * days.
- **The group of X can flip.** There is a completion of the group's other absent keys and unsure judgements under which two witness values of X make the group met and not met.
- **Every other group is closable.** Each other group has a completion under which it is not met.
- **Can change.** X can change the answer iff its group can flip AND every other group is closable.
- **X behind Y.** Y can change the answer for every witness value of X, and for some witness value of Y, X can no longer change it.
  - Across groups this reduces to two conditions: X's group is closable for every X value, AND Y has a value that forces its own group met.
  - Within a group it is enumerated directly.
- **The key named.** It is the first candidate in root order that is behind no other candidate. The status is `indeterminate([Key])` with citations `[]`.
- **Behaviour this yields:**
  - critical services, reputational, duration, economic: the first absent key;
  - access: the first absent key;
  - data impact: the adverse judgement first, while it is absent; else the first absent impact key;
  - clients: totals behind their own absent affected figure; points (d) and (e) figures behind `reference_period_days` while both points stay open; non-forcing keys behind an absent point-(f) judgement.

**T4 (referral).** No candidate can change the answer. The step takes the first unsure judgement, in root order, of an open part of an open point. The status is `needs_legal_review(open_textured(Key, ReferralCitation), [inputs_relied_on(Pairs)])` with citations `[]`. Pairs are the Key-Value pairs of `condition_keys(Condition, Keys)` present in the profile, in root order, with values exactly as given, the unsure key included.

**B1 (in time).**

- `one_month_after(date(Year, Month, Day), date(DueYear, DueMonth, DueDay))`:
  - Month < 12 gives DueYear = Year and DueMonth = Month + 1.
  - Month = 12 gives DueYear = Year + 1 and DueMonth = 1.
  - DueDay = Day when Day <= LastDay, else LastDay, where `month_last_day(DueYear, DueMonth, LastDay)`. These are two exclusive clauses; the minimum is not computed with if-then-else.
- `date_on_or_before/2` here is a local integer-lexicographic comparison on (Year, Month, Day), named `calendar_day_on_or_before/2` to avoid shadowing deadline_lib.
- FinalDate on or before DUE gives `on_time` with `[cite(eu_reg_2025_301_art_5_1_c)]`.

**B2 (after DUE, weekend key decides).** FinalDate is after DUE. `final_report_weekend_extension` `true` gives `on_time`; `false` gives `late(month_limit)`. Both carry the four 2025/301 citations.

**B3 (weekend key missing).** FinalDate is after DUE and the weekend key is absent. The result is `indeterminate([final_report_weekend_extension])` with citations `[]`.

The only key B1 to B3 read is `final_report_weekend_extension`, and only at B2/B3.

**Checklist rows.** `final_report_month_limit` is `met` when FinalDate is on or before DUE, else `closed`. `final_report_weekend_extension` is `met` / `closed` / `open` for `true` / `false` / absent.

### 8.4 Verdict atoms of this slice

`met`, `not_met`, `on_time`, `late(month_limit)`; the part and point states `met`, `closed`, `open`.

### 8.5 Exported to queries.clausal

- `dora_incident_classification_thresholds_condition_answer(Profile, Condition, Status, Citations)`: steps T1 to T4, called only after T0 passes.
- `dora_incident_classification_thresholds_final_report_answer(Profile, LatestIntermediateDate, FinalDate, Result, Citations)`: steps B1 to B3, called only after B0 passes.
- `dora_incident_classification_thresholds_point/4`, `condition_point/2` and `one_month_after/2`: for the facade checklist and deadline.

### 8.6 Shared with other slices

NONE. There is only one slice. Kernel holds only the type predicates and the input check (section 6), which queries.clausal also needs.

### 8.7 Per-rule tests (tests/), seven modes

- **Boundaries.**
  - Art 9(1)(b): 100000 / 100001.
  - Art 9(1)(a): 10 % exactly versus just above; for example, clients 1000 with affected 100 is not met and affected 101 is met.
  - Art 9(1)(c): 30 % exactly; for example, 10 counterparts with 3 affected is not met and 4 affected is met.
  - Art 9(3): 86400 / 86401 and 7200 / 7201.
  - Art 9(4): 1 / 2.
  - Art 9(6): 10000000 / 10000001.
- **Zero days** closes points (d) and (e). A zero total with a positive affected figure is met (Q8).
- **Every BEHIND example** of THE LIMBS (T3) and the data-impact referral-before-absent mutation.
- **Input check:** duplicate keys (equal and unequal values), unbound keys and values, float integers, `unsure` given to the fact key, a partial list and an unbound profile. Each runs with the argument problems appended.
- **Final report:** month ends, December roll-over, leap years, before, on, one day after and three days after DUE, the weekend key in its three states, and non-dates.
- **Determinism:** `findall` length 1 on every query, via validate_props `prop_determinism/3`. Every negative test is paired with a positive test over the same case.
