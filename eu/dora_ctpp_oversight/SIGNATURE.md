# SIGNATURE — eu/dora_ctpp_oversight

Public query surface: six order queries `ctpp_*(Profile, Result, Citations)`, the input check `dora_ctpp_oversight_input_problems(Profile, Problems)`, and the scaffold facade `decide_dora_ctpp_oversight(Profile, dora_ctpp_oversight_verdict(Status, Citations))`, `dora_ctpp_oversight_status(Profile, Status)`, `dora_ctpp_oversight_checklist(Profile, Checklist)`, `dora_ctpp_oversight_what_if(Profile, Key, Value, Verdict)`. Every call of every public predicate yields EXACTLY ONE solution (totality + determinism): disjoint clauses with guards, no `!`, no `->`, no `once/1`; ground result atoms folded into clause heads (C17). No public predicate returns a float or a string. No imported figure exists in this order: every statutory figure is declared once in the slice with `:- constant_value(...)`.

## 1. Status atoms (replace the scaffold placeholders `required, permitted, not_applicable`)

### 1.1 Order RESULT forms (THE INTERFACE, non-negotiable)

- Shared final atom: `not_designated_as_critical`.
- (A) `required(Duties)`; Duties a non-empty ordered sublist of `[transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]`.
- (B) `powers(Powers)`; Powers a non-empty ordered sublist of `[request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations, recommend_refraining_from_further_subcontracting]`.
- (C) `window_open(LastDay)`, `window_closed(LastDay)`, `window_not_yet_open(LastDay)`.
- (D) `no_penalty_ground_recommendation`, `no_penalty_ground_full_compliance`, `penalty_decision_required`, `penalty_waiting_period_running(FirstDay)`.
- (E) `penalty_limits(amount(Numerator, Denominator), LastDay)`.
- (F) `lead_overseer_agreement_required`, `no_article_33_5_condition`.
- Status compounds (all queries): `indeterminate([Key])` (exactly one bare key; the bare atom `indeterminate` is NEVER written), `input_problems(Problems)`; Citations `[]` for both.
- Problem terms: `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, `wrong_type(profile)`.

### 1.2 Facade STATUS atoms (query types #2 / #7 / #15)

No atom shares a name with a compound of the order (atom-shadowing trap avoided):

- `subject_to_lead_overseer_oversight` — designation true (the eligibility 'eligible').
- `not_designated_as_critical` — designation false (the eligibility 'ineligible'; same meaning as in the queries).
- `oversight_indeterminate` — designation absent.
- `oversight_input_problems` — the input check is non-empty.

Never pinned in `verdict_vocabulary` or `root_exports`: `true`, `false`.

## 2. Profile keys (attribute list, read only with `profile_get/3`; root_exports / input_contract order)

| # | Key | Type |
|---|---|---|
| 1 | `provider_designated_as_critical` | boolean atom (`true`/`false`) |
| 2 | `response_window` | enumeration: `oversight_plan_statement`, `recommendation_information` |
| 3 | `draft_oversight_plan_received_on` | date `date(Year, Month, Day)` |
| 4 | `annual_oversight_plan_adopted_and_notified` | boolean atom |
| 5 | `oversight_activities_completed` | boolean atom |
| 6 | `provider_plans_further_subcontracting_arrangement` | boolean atom |
| 7 | `envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country` | boolean atom |
| 8 | `subcontracting_concerns_critical_or_important_functions` | boolean atom |
| 9 | `lead_overseer_deems_clear_and_serious_risk` | boolean atom |
| 10 | `recommendation_information_opportunity_given_on` | date |
| 11 | `measure_power` | enumeration: `information_request`, `general_investigation`, `inspection`, `remediation_report_request`, `recommendation` |
| 12 | `measure_compliance` | enumeration: `full`, `partial`, `none` |
| 13 | `measure_notification_received_on` | date |
| 14 | `penalty_decision_notified_on` | date |
| 15 | `preceding_business_year_worldwide_turnover` | non_negative_integer, whole euro (unit fixed by the contract; integer, never float) |
| 16 | `preceding_business_year_length_in_days` | integer >= 1 (unit: days, named in the key) |
| 17 | `assessment_date` | date |

The key names are fixed by the non-negotiable contract and are not renamed (the turnover key carries no `_eur` suffix by contract; its unit is documented here and in NOTES R10). Valid input date: ground `date(Y, M, D)`, three bare integers, real Gregorian day, 1900 =< Y =< 2199.

## 3. Citation-key atoms (`citations.clausal`, `citation_vocabulary`, canonical lexicon scheme)

`eu_reg_2022_2554_art_33_4`, `eu_reg_2022_2554_art_33_5`, `eu_reg_2022_2554_art_35_1`, `eu_reg_2022_2554_art_35_1_a`, `eu_reg_2022_2554_art_35_1_b`, `eu_reg_2022_2554_art_35_1_c`, `eu_reg_2022_2554_art_35_1_d`, `eu_reg_2022_2554_art_35_1_d_iv`, `eu_reg_2022_2554_art_35_3`, `eu_reg_2022_2554_art_35_5`, `eu_reg_2022_2554_art_35_6`, `eu_reg_2022_2554_art_35_7`, `eu_reg_2022_2554_art_35_8`. Always wrapped `cite(Key)`. No shortened atom, no Art 31 atom, no deferred unit cited.

## 4. Public predicates (one line each)

- `ctpp_oversight_duties_required(Profile, Result, Citations)`: duties of THE PROVIDER, steps A0..A4 — Art 35(1)(d) closing words, Art 35(5).
- `ctpp_lead_overseer_powers(Profile, Result, Citations)`: powers of the Lead Overseer, steps B0..B5 — Art 35(1), (a) to (d), (d)(iv).
- `ctpp_response_window_status(Profile, Result, Citations)`: one response window, steps C0..C6 (deadline #15) — Art 33(4), Art 35(3).
- `ctpp_periodic_penalty_payment_status(Profile, Result, Citations)`: penalty ground for one measure, steps D0..D9 (deadline #15) — Art 35(6).
- `ctpp_periodic_penalty_payment_limits(Profile, Result, Citations)`: six-month limit and daily ceiling, steps E0..E5 (deadline #15) — Art 35(7), (8).
- `ctpp_competent_authority_measure_condition(Profile, Result, Citations)`: Art 33(5) condition, steps F0..F4 — Art 33(5).
- `dora_ctpp_oversight_input_problems(Profile, Problems)`: THE INPUT CHECK; never fails, never raises, one solution — all keys of the contract.
- `decide_dora_ctpp_oversight(Profile, Verdict)`: Verdict = `dora_ctpp_oversight_verdict(Status, Citations)`; Status per 1.2; Citations = set-union (each once, first-occurrence order) of the citations of the six checklist items for the two final statuses, `[]` for `oversight_indeterminate` / `oversight_input_problems` (eligibility #2) — Art 35(1), Art 35(5) and the query citations.
- `dora_ctpp_oversight_status(Profile, Status)`: the Status of `decide_dora_ctpp_oversight/2` only.
- `dora_ctpp_oversight_checklist(Profile, Checklist)`: justification #7; Checklist = six `item(QueryName, Result, Citations)` terms (formalize_lib `item/3`), in the order A..F, each carrying its query's `cite(...)` list (`[]` for status compounds).
- `dora_ctpp_oversight_what_if(Profile, Key, Value, Verdict)`: decide on Profile with Key overridden to Value; via kit `what_if/5` with Decide closure `decide_dora_ctpp_oversight`; when Key is absent it is added.
- Fixtures (`fixtures.clausal`): `dora_ctpp_oversight_fixture(Name, Profile)` and `dora_ctpp_oversight_fixture_expected(Name, Query, Result, Citations)`.
- Result constructors (exported, never called as queries): `required/1, powers/1, window_open/1, window_closed/1, window_not_yet_open/1, penalty_waiting_period_running/1, penalty_limits/2, amount/2, date/3, indeterminate/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1`.

## 5. Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3` (every read, presence then value), `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `item/3`, `attribute/2`, `not_member/2`, `memberd/2`, `int_min/3`.
- `kit/deadline_lib`: `deadline/4` (DATE plus N days: windows + 15 / + 30, FIRST_DAY + 31), `date_before/2`, `date_after/2`, `date_on_or_before/2`, `date_on_or_after/2` (calendar comparisons; never `<` and never msort on date compounds), `month_last_day/3` (six-month clamp and Gregorian validity). `deadline_months_after/3` is deliberately NOT used (different reading, NOTES R9).
- `library(datetime)`: `date_add/3`, `timedelta/3`, `days_between/3` — only if P2 finds `deadline/4` does not accept the `date(Year, Month, Day)` term; inputs always bound first (forward-only).
- `kit/query_combinators`: `what_if/5` (facade what-if).
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1` (tests).
- Not used: `assess/6` and the checklist engine (the order's results are fixed compounds, not met/unmet labels; the facade checklist is item/3 rows built from query results, no requirement/4), `compliance_lib`, `rolling_window`, `currency_vocab` (euro is implied by the contract key), `country`.

## 6. Layout (kept as scaffolded)

`kernel -> citations -> parameters -> dora_ctpp_oversight -> queries -> fixtures -> package facade`.

- `kernel.clausal` — ONLY the predicates shared by the slice AND another layer (queries, fixtures, facade): `dora_ctpp_oversight_valid_input_date/1` (ground date(Y,M,D), integers, 1900..2199, month 1..12, 1 =< D =< `month_last_day`), `dora_ctpp_oversight_date_plus_days/3` (wraps `deadline/4`), `dora_ctpp_oversight_date_plus_six_months/2`... no: the months helper is slice-owned (see 7.3); the kernel keeps the two date helpers fixtures also use for building expected days.
- `citations.clausal` — the 13 citation atoms of section 3 as `citation_vocabulary`.
- `parameters.clausal` — holds no figure (every figure is slice-owned); keeps the scaffold module, exports nothing new.
- `queries.clausal` — re-exports the six queries and the input check under their contract names.
- `fixtures.clausal` — named profiles and expected answers (section 8).
- facade — `decide_dora_ctpp_oversight/2`, `dora_ctpp_oversight_status/2`, `dora_ctpp_oversight_checklist/2`, `dora_ctpp_oversight_what_if/4`.

## 7. Slice: `dora_ctpp_oversight.clausal` (self-contained)

### 7.1 Value facts owned (declared here, read with `#Name`)

```
:- constant_value(oversight_plan_statement_window_days, 15).        % Art 33(4)
:- constant_value(recommendation_information_window_days, 30).      % Art 35(3)
:- constant_value(penalty_waiting_period_days, 30).                 % Art 35(6)
:- constant_value(penalty_first_day_offset_days, 31).               % reading (7): 30 + day of receipt not counted
:- constant_value(penalty_maximum_period_months, 6).                % Art 35(7)
:- constant_value(penalty_ceiling_percent_denominator, 100).        % Art 35(8): 1 %
:- constant_value(input_date_first_year, 1900).                     % reading (13)
:- constant_value(input_date_last_year, 2199).                      % reading (13)
```

Vocabulary facts: `contract_key(Position, Key, Type)` for the 17 keys of section 2 (Type in `boolean`, `date`, `enumeration(Atoms)`, `non_negative_integer`, `positive_integer`); `power_citation/2`, `duty_citation/2` tables (section 4 / THE LIMBS).

### 7.2 Input check (THE INPUT CHECK)

1. Not an attribute list (unbound, partial list, unbound element, element not `attribute(K, V)`) -> `[wrong_type(profile)]` alone. Guard with `is_list/1` plus `nonvar` + functor test on every element, as disjoint clauses.
2. For each contract key in order: occurs >= 2 times (count with `==`) -> `duplicate_key(Key)` (values not read); occurs once with a value outside its type (unbound value, float, `unsure`, invalid date, negative or < 1 integer, wrong atom) -> `wrong_type(Key)`; absent -> nothing.
3. Then `unknown_key(Key)` once per distinct (`==`) non-contract key (non-atoms and unbound variables included, reported as given), in first-occurrence order; values never checked.
Problems order is scored. One solution always (findall-free accumulator over the key table; no raising predicate called on an unbound or non-integer value: type-test before arithmetic).

### 7.3 Rules / requirements (each a predicate with disjoint clauses)

- Designation gate: false -> `not_designated_as_critical` with the query's citation (A1 Art 35(5); B1 Art 35(1); C1 Art 33(4) + Art 35(3); D1 Art 35(6); E1 Art 35(7) + (8); F1 Art 33(5)); absent -> `indeterminate([provider_designated_as_critical])`.
- Duties (A3, A4): plan key absent -> indeterminate; else transmission (cite art_35_1_d) iff plan true, then cooperation (cite art_35_5).
- Powers (B3..B5): completion absent -> indeterminate; point (iv) facts in order plan, indent 1, indent 2, indent 3: if none false and one absent -> first absent; else list (a), (b), (c) iff completed true, (d), (d)(iv) iff all four true; citations art_35_1 plus each listed power's atom.
- Window (C3..C6): response_window absent; START KEY absent (only the named window's key read); assessment_date absent; else LastDay = Start + 15 / + 30 days; `date_before(Assessment, Start)` -> not yet open; `date_after(Assessment, LastDay)` -> closed; otherwise open. Citation per window only.
- Penalty status (D3..D9): measure_power `recommendation` -> no ground (checked before absence of measure_power? No: absent measure_power -> D4 indeterminate; D3 needs the value); compliance `full` -> no ground; absences in order compliance, notification date, assessment date; FirstDay = received + 31; assessment before FirstDay -> `penalty_waiting_period_running(FirstDay)`, else `penalty_decision_required`. All final citations `[cite(eu_reg_2022_2554_art_35_6)]`.
- Penalty limits (E2..E5): first absent of designation, decision notified date, turnover; turnover 0 -> `amount(0, 1)` without the days key; days absent -> indeterminate; else Numerator = Turnover // G, Denominator = (100 x Days) // G with G = gcd(Turnover, 100 x Days). LastDay = `six_months_after(Notified, LastDay)`: month index Year*12 + (Month-1) + 6 split back into year/month, Day = `int_min(Day, month_last_day(Year2, Month2))`. Citations `[art_35_7, art_35_8]`.
- Art 33(5) (F3, F4): absent -> indeterminate; true -> `lead_overseer_agreement_required`; false -> `no_article_33_5_condition`; citation art_33_5.
- Every query starts with the input check (step 0): non-empty -> `input_problems(Problems)`, `[]`.

### 7.4 Verdict atoms of the slice

All of section 1.1; facade atoms of 1.2 are derived in the facade from the A..F results.

### 7.5 Shared with another slice

None (single slice). Only the date-validity and plus-days helpers go to `kernel.clausal`, because fixtures and tests also use them; the six-month helper, gcd reduction and the input check stay in the slice.

## 8. Tests (seven modes) and fixtures

- Per-rule: one test per step A0..F4 (each final RESULT, each indeterminate key, citations as sets).
- Boundary: window day start-1 / start / start+15 / start+16 (and 30/31); penalty receipt+30 running, receipt+31 required; six months from 31 August -> 28 Feb and, leap year, 29 Feb; 31 March -> 30 September; notified in July -> January of next year; 29 Feb input in non-leap year -> wrong_type.
- Arithmetic: turnover 0 -> amount(0,1) with days absent; 36500000 / 365 -> amount(1000, 1); 1 / 366 -> amount(1, 36600); fraction always in lowest terms.
- Input check: duplicate (equal and unequal values), float 365.0, 1.0, unsure, string values, unknown key with unbound value, two distinct unbound keys, same variable twice, non-atom key, partial list, unbound profile, unbound contract value, ordering of mixed problems.
- Missing-key ladder: point (iv) fact never named once another is false; START KEY of unnamed window never read nor named.
- Determinism/totality: `findall` count = 1 for every fixture and every query (validate_props).
- Facade: status, checklist citations, what_if flip on designation; negative tests paired with positive ones.
