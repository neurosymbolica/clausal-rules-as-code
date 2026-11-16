# SIGNATURE — eu/labour/working_time_weekly_limit

This is the plan the later phases execute. Do NOT restructure the package. The layering is:

`kernel -> citations -> parameters -> working_time_weekly_limit -> queries -> fixtures -> package facade`

Shape family: deontic. Query types served:

- #2 eligibility: `weekly_limit_status/7` plus `working_time_weekly_limit_checklist/2`.
- #23 calculation: `weekly_working_time_average/6` and `required_reduction_minutes/6`.
- #6 threshold: `working_time_weekly_limit_maximum_counted_minutes/6`.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every input. Clauses are disjoint routes, with ground outputs folded into the head (C17). There is no `!`, no `->` and no `*->`. The scorer collects every solution, so a duplicate answer is a refutation.

## 1. Verdict STATUS atoms (these replace `required / permitted / not_applicable`)

Final atoms of `weekly_limit_status/7` argument 6:

- `within_weekly_limit`
- `over_weekly_limit`
- `weekly_limit_not_applied_by_agreement`
- `reference_period_longer_than_allowed`
- `no_countable_period`

Not-final status compounds. Each is returned ITSELF and never inside a list. The bare atom `indeterminate` is never written.

- `input_problems(PROBLEMS)`: PROBLEMS is a flat list of `unknown_key(KEY)`, `wrong_type(KEY)` and `duplicate_key(KEY)` terms.
- `indeterminate([KEY])`: the list holds exactly ONE bare key atom.
- `needs_legal_review(open_textured(KEY, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(PAIRS)])`. PAIRS are the `KEY-VALUE` pairs of the PRESENT judgement keys, in root_exports order. An optional trailing `provenance(CLAUSE, CITATIONS)` may follow; it is unscored.

Result constructors are exported and never called as queries:

- `minutes_per_seven_days/2`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

Facade verdict term: `working_time_weekly_limit_verdict(STATUS, CITATIONS)`.

## 2. Profile keys (root_exports and input_contract order)

PROFILE is `[attribute(KEY, VALUE), ...]`. Every decision reads it ONLY with `profile_get/3`, by presence first and then by value. Absence is never a problem.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `reference_period_basis` | enumeration | `member_state_reference_period`, `derogation_under_article_17_3_or_article_18`, `collective_agreement_under_article_19`, `offshore_work_under_article_20_2` |
| 2 | `on_call_on_site_counts_as_working_time` | judgement (tri-state) | `true`, `false`, `unsure` |
| 3 | `on_call_standby_counts_as_working_time` | judgement (tri-state) | `true`, `false`, `unsure` |
| 4 | `member_state_uses_article_22_option` | crisp | `true`, `false` |
| 5 | `worker_agreement_to_exceed_obtained_first` | crisp | `true`, `false` |

The arguments are not profile keys:

- `WORKER`: an atom or an integer.
- `SHIFTS`: a proper list of `shift(WORKER_ID, date_time(Y, M, D, H, MIN), date_time(Y, M, D, H, MIN), KIND)`. KIND is one of `work`, `on_call_on_site`, `on_call_standby`, `paid_annual_leave` or `sick_leave`.
- `PERIOD_START` and `PERIOD_END`: `date(Y, M, D)`, both days included.

Every figure is an integer number of minutes. The names carry a `_minutes` suffix inside the code, for example `CountedLowMinutes` and `CountableMinutes`.

## 3. Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened, never invented)

| Key | Units |
|---|---|
| `eu_dir_2003_88_art_2_1` | `32003L0088#parag_002.001` |
| `eu_dir_2003_88_art_6_b` | `32003L0088#point_006_b` |
| `eu_dir_2003_88_art_16_b` | `32003L0088#point_016_b`, `32003L0088#subpara_016_1` |
| `eu_dir_2003_88_art_19_first_subpara` | `32003L0088#subpara_019_1` |
| `eu_dir_2003_88_art_19_second_subpara` | `32003L0088#subpara_019_2` |
| `eu_dir_2003_88_art_20_2` | `32003L0088#parag_020.002` |
| `eu_dir_2003_88_art_22_1` | `32003L0088#parag_022.001` |
| `eu_dir_2003_88_art_22_1_a` | `32003L0088#point_022.001_a` |

The deferred units have no citation key in `citation_vocabulary`: `parag_001.003`, `subpara_001.003_1`, `art_006`, `art_016`, `parag_017.001`, `parag_017.005` and `subpara_016_2`. `citations.clausal` holds one `citation(KEY, UNITS, PIN)` row per key above, and only those rows.

## 4. Public predicates (one line each)

In this section, CASE is `weekly_limit_case(PROFILE, WORKER, SHIFTS, PERIOD_START, PERIOD_END)`.

- `weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)`: THE LIMBS steps 0 to 6. Result is a final atom or a status compound. Citations is a set-like flat list of `cite(KEY)`, and `[]` when the answer is not final. Cites Art 2(1), 6(b), 16(b), 19 first and second subparagraphs, 20(2), 22(1) and 22(1)(a) as each step states.
- `weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average)`: Average is `minutes_per_seven_days(Numerator, Denominator)`, the exact fraction `COUNTED * 10080 / COUNTABLE` in lowest terms. Otherwise it is `no_countable_period` or a status compound. This predicate does not read the limit, the basis or the option keys. Cites Art 6(b) and 16(b), with Art 2(1) for what counts.
- `required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes)`: Minutes is `0` when COUNTED_HIGH is within the limit. Otherwise it is `COUNTED - floor(2880 * COUNTABLE / 10080)`, or `no_countable_period`, or a status compound. This predicate does not read the ceiling or the option keys (reading (9)). Cites Art 6(b) and 16(b).
- `working_time_weekly_limit_maximum_counted_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Maximum)`: THRESHOLD (#6). Maximum is the bare integer `floor(2880 * COUNTABLE / 10080)`, the largest counted figure within the limit. The outcome flips between Maximum and Maximum + 1. Otherwise it is `no_countable_period`, or `input_problems(PROBLEMS)` at step 0. It reads no on-call key, because COUNTABLE does not depend on one. Cites Art 6(b) and 16(b).
- `working_time_weekly_limit_input_problems(Profile, Problems)`: THE INPUT CHECK of the PROFILE alone. Problems is a bare flat list: `[]`, or the contract keys in contract order (`duplicate_key/1`, else `wrong_type/1`), followed by `unknown_key/1` in order of first occurrence. It gives `[wrong_type(profile)]` for a non-attribute-list. It never fails and never raises.
- `decide_working_time_weekly_limit(Case, working_time_weekly_limit_verdict(Status, Citations))`: the facade. It is `weekly_limit_status/7` on the five parts of Case.
- `working_time_weekly_limit_status(Case, Status)`: the facade. It gives the Status of the verdict only.
- `working_time_weekly_limit_checklist(Case, Checklist)`: the cited checklist for #2. It is built by `eval_requirements/4` over the closure `working_time_weekly_limit_requirement`, which is called as `working_time_weekly_limit_requirement(RequirementId, Case, Status, Citation)`. Items are `item(Id, met | unmet(Reason) | unknown([KEY]), cite(KEY))`.
- `working_time_weekly_limit_what_if(Case, Key, Value, Verdict)`: replaces `attribute(Key, _)` in the profile through `profile_set/3`, then gives the facade verdict for the changed case.
- `working_time_weekly_limit_fixture(Name, Case)` and `working_time_weekly_limit_fixture_expected(Name, Status, Citations)`: the fixtures (section 7).

## 5. Slice: `working_time_weekly_limit.clausal`

This slice is self-contained for the concept 'the 48-hour average over one reference period'.

### 5.1 Statutory VALUE facts it owns (declared once, read with `constant(Name)`)

The limit and the averaging unit:

- `:- constant_value(weekly_limit_average_minutes, 2880).`: 48 hours on average (Art 6(b)).
- `:- constant_value(seven_day_period_minutes, 10080).`: seven days (Art 6(b)).

The reference-period ceilings:

- `:- constant_value(member_state_reference_period_ceiling_months, 4).` (Art 16(b))
- `:- constant_value(derogation_reference_period_ceiling_months, 6).` (Art 19 first subparagraph)
- `:- constant_value(collective_agreement_reference_period_ceiling_months, 12).` (Art 19 second subparagraph)
- `:- constant_value(offshore_work_reference_period_ceiling_months, 12).` (Art 20(2))
- `:- constant_value(longest_reference_period_ceiling_months, 12).`: the largest ceiling of any basis.

The basis table, which maps each basis to its ceiling constant:

- `reference_period_ceiling(member_state_reference_period, member_state_reference_period_ceiling_months)`
- `reference_period_ceiling(derogation_under_article_17_3_or_article_18, derogation_reference_period_ceiling_months)`
- `reference_period_ceiling(collective_agreement_under_article_19, collective_agreement_reference_period_ceiling_months)`
- `reference_period_ceiling(offshore_work_under_article_20_2, offshore_work_reference_period_ceiling_months)`

Shift-kind role facts:

- `shift_kind_role(work, counted)`
- `shift_kind_role(on_call_on_site, judged(on_call_on_site_counts_as_working_time))`
- `shift_kind_role(on_call_standby, judged(on_call_standby_counts_as_working_time))`
- `shift_kind_role(paid_annual_leave, neutral)`
- `shift_kind_role(sick_leave, neutral)`

### 5.2 Derived arithmetic (exact integers; no float; no rounding of the average)

The limit is 2880 minutes per seven-day period on average. Shift times are taken to the minute as given. The average is exact: there is no rounding of any kind (ruling 6 as scoped by the deadline-only rounding scope (2026-11-12, every law: deadline clocks only) and the labour ruling: a measured duration is summed exactly).

- `working_time_weekly_limit_period_window(PeriodStart, PeriodEnd, StartMinute, EndMinute)`: StartMinute is 00:00 on PeriodStart. EndMinute is 00:00 on the day after PeriodEnd. LENGTH is `EndMinute - StartMinute`. Built on `kernel` `working_time_weekly_limit_date_ordinal/2`.
- `working_time_weekly_limit_kind_minutes(Worker, Shifts, StartMinute, EndMinute, Kind, Minutes)`: the sum of the PARTS of Worker's shifts of Kind. Each part is `int_max(0, int_min(End, EndMinute) - int_max(Start, StartMinute))`. Worker shifts are matched by term identity (`==`). The parts are summed with `sum_list/2` over a `findall/3`.
- `working_time_weekly_limit_figures(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Figures)`: internal only. Figures is the compound `weekly_figures(LengthMinutes, NeutralMinutes, CountableMinutes, WorkMinutes, OnSiteMinutes, StandbyMinutes)`. It is never placed in a public scalar position.
- `working_time_weekly_limit_on_call_state(Profile, Key, KindMinutes, State)`: State is `counted` (the key is true), `not_counted` (the key is false), `unresolved` (the key is absent or unsure, with KindMinutes > 0), or `not_counted` (KindMinutes = 0). These are disjoint clauses.
- `working_time_weekly_limit_counted_low/2` and `working_time_weekly_limit_counted_high/2`: computed as the FIGURES section says.
- `working_time_weekly_limit_within_limit(CountedMinutes, CountableMinutes)`: true when `CountedMinutes * constant(seven_day_period_minutes) =< constant(weekly_limit_average_minutes) * CountableMinutes`. The complementary clause is `working_time_weekly_limit_over_limit/2`, written with `>`.
- `working_time_weekly_limit_kind_matters(Key, LowMinutes, KindMinutes, OtherState, OtherMinutes, CountableMinutes)`: the two disjuncts of MATTERS, written as two clauses that cannot both fire. The second clause carries the guard that the first fails, so a case where both hold still answers once.
- `working_time_weekly_limit_ceiling_exceeded(PeriodStart, PeriodEnd, Months)`: true when `ordinal(NEXT) > ordinal(PERIOD_START + Months)`, by the month rule of `kernel`.
- `working_time_weekly_limit_lowest_terms(Numerator, Denominator, minutes_per_seven_days(N, D))`: uses `G is gcd(Numerator, Denominator)`. A numerator of 0 gives `minutes_per_seven_days(0, 1)`. If `gcd/2` is not evaluable in the engine, use the exact rational `{Numerator/Denominator}` and read back its numerator and denominator. Never use a float.
- `working_time_weekly_limit_largest_within(CountableMinutes, Maximum)`: `Maximum is (constant(weekly_limit_average_minutes) * CountableMinutes) // constant(seven_day_period_minutes)`. This equals `floor(2 x COUNTABLE / 7)`. formalize_lib `max_numerator_lte/3` is NOT used, because it works in floored basis points and is not exact.

### 5.3 Rules (each becomes its own disjoint, head-folded clause group, with per-rule tests)

- R0 `input_check`: step 0 of every query. It concatenates the kernel PROFILE problems with the argument problems, in this order: `wrong_type(worker)`, `wrong_type(shifts)` (including overlap of two of WORKER's shifts), `wrong_type(period_start)`, and `wrong_type(period_end)` (a date check only when PERIOD_START is wrong).
- R1 `longest_ceiling` (status step 1): when NEXT is after P12, the result is `reference_period_longer_than_allowed` with `[cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara), cite(eu_dir_2003_88_art_19_second_subpara), cite(eu_dir_2003_88_art_20_2)]`. The basis is not read.
- R2 `basis_ceiling` (status step 2): applies when NEXT is after P4 and not after P12.
  - The basis is absent: `indeterminate([reference_period_basis])`.
  - The basis is `member_state_reference_period`: the result is `reference_period_longer_than_allowed` with `[cite(eu_dir_2003_88_art_16_b)]`.
  - The basis is the derogation and NEXT is after P6: the result is `reference_period_longer_than_allowed` with `[cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara)]`.
  - Otherwise the step falls through to R3.
  - When NEXT is not after P4, the basis is never read.
- R3 `no_countable_period` (status step 3, average step 1, reduction step 1, threshold): COUNTABLE = 0. Status gives `no_countable_period` with `[cite(eu_dir_2003_88_art_16_b)]`. The others give the bare atom.
- R4 `within_whatever_unresolved` (status step 4): COUNTED_HIGH is within the limit, so the result is `within_weekly_limit` with `[cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]`. No on-call key and no option key is read.
- R5 `turns_on_on_call` (status step 5): COUNTED_LOW is within the limit and COUNTED_HIGH is over it.
  - 5a: the first ABSENT judgement key whose kind MATTERS gives `indeterminate([KEY])`.
  - 5b: the option is absent and the agreement is not false: `indeterminate([member_state_uses_article_22_option])`.
  - 5b: the option is true and the agreement is absent: `indeterminate([worker_agreement_to_exceed_obtained_first])`.
  - 5c: otherwise, `needs_legal_review(open_textured(KEY, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(PAIRS)])`. KEY is the first unsure judgement key whose kind MATTERS.
  - Citations are `[]` in every case.
- R6 `over_whatever_unresolved` (status step 6): COUNTED_LOW is over the limit, and no on-call key is read. Six disjoint clauses, keyed on (option, agreement):
  - (false, any): `over_weekly_limit` with art_2_1, art_6_b and art_16_b.
  - (true, false): `over_weekly_limit` with art_2_1, art_16_b and art_22_1_a.
  - (absent, false): `over_weekly_limit` with art_2_1, art_6_b, art_16_b and art_22_1_a.
  - (absent, true or absent): `indeterminate([member_state_uses_article_22_option])`.
  - (true, absent): `indeterminate([worker_agreement_to_exceed_obtained_first])`.
  - (true, true): `weekly_limit_not_applied_by_agreement` with art_22_1 and art_22_1_a.
- R7 `average_value` (average steps 2 to 4):
  - The first absent judgement key with minutes > 0 gives `indeterminate([KEY])`.
  - Otherwise, the first unsure key with minutes > 0 gives `needs_legal_review(...)`.
  - Otherwise, the result is `minutes_per_seven_days(N, D)` in lowest terms.
- R8 `reduction_value` (reduction steps 2 to 5):
  - COUNTED_HIGH is within the limit: `0`.
  - Otherwise, the first absent key with minutes > 0 gives `indeterminate`, then the first unsure key gives `needs_legal_review`.
  - Otherwise, the result is `COUNTED - Maximum`, a positive integer.
- R9 `pairs`: PAIRS are the present judgement keys in root_exports order, as `KEY-VALUE` with unsure included. No other key is a pair.

Checklist requirement ids, used for `working_time_weekly_limit_requirement/4` in this order:

| Requirement id | Citation | met when | unmet / unknown when |
|---|---|---|---|
| `reference_period_within_ceiling` | `eu_dir_2003_88_art_16_b` | the period is within the ceiling | unmet `reference_period_longer_than_allowed`; unknown `[reference_period_basis]` |
| `countable_period_exists` | `eu_dir_2003_88_art_16_b` | COUNTABLE > 0 | unmet `no_countable_period` |
| `on_call_on_site_resolved` | `eu_dir_2003_88_art_2_1` | the kind does not matter, or its key is true or false | unknown `[on_call_on_site_counts_as_working_time]` when absent or unsure and matters |
| `on_call_standby_resolved` | `eu_dir_2003_88_art_2_1` | likewise | unknown `[on_call_standby_counts_as_working_time]` |
| `average_within_weekly_limit` | `eu_dir_2003_88_art_6_b` | COUNTED_HIGH is within the limit | unmet `over_weekly_limit` when COUNTED_LOW is over it |
| `article_22_agreement_disapplies_limit` | `eu_dir_2003_88_art_22_1_a` | the option and the agreement are both true | unmet otherwise |

Each requirement has exactly three mutually exclusive clauses (met / unmet / unknown), with no cut. The verdict comes ONLY from `weekly_limit_status/7`. A consistency test asserts that the checklist agrees with it.

### 5.4 Verdict atoms of this slice

The slice uses all five final atoms of section 1, plus the three status compounds.

### 5.5 Predicates SHARED with another slice (these go to `kernel.clausal`)

There is one determination slice, so nothing is shared between slices. The kernel holds only the floor that every query and the input check need:

- `working_time_weekly_limit_valid_date(date(Y, M, D))`: integer guards, `1 =< M =< 12`, `1 =< Y =< 9999`, and D at most `month_last_day(Y, M, Last)`. It never raises.
- `working_time_weekly_limit_valid_date_time(date_time(Y, M, D, H, MIN))`: the date check, `0 =< H =< 23` and `0 =< MIN =< 59`.
- `working_time_weekly_limit_date_ordinal(date(Y, M, D), Ordinal)`: `datetime(Y, M, D, 0, 0, 0, Native)`, then `date_of(Native, Day)`, then `ordinal(Day, Ordinal)`. These are native datetime calls. No hand-rolled day count. `date/3` is never constructed.
- `working_time_weekly_limit_minute_of(date_time(Y, M, D, H, MIN), Minute)`: `Ordinal * 1440 + H * 60 + MIN`. The 1440 is `constant(day_minutes)` and is declared in the kernel.
- `working_time_weekly_limit_months_later(date(Y, M, D), Months, Target)`: the month rule, with the day clamped by `month_last_day/3`. Target is `ordinal(O)`, or `beyond_calendar` when the target year is over 9999, which lies after every NEXT.
- `working_time_weekly_limit_input_contract(KEY, TYPE)`: five rows in contract order. TYPE is `enumeration([...])`, `judgement` or `crisp`.
- `working_time_weekly_limit_profile_problems(Profile, Problems)`: the structural walk of the list. It handles `wrong_type(profile)`, `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` (including non-atom keys), and treats an unbound value as wrong_type. This is the only place the raw list is walked. Every decision reads values through `profile_get/3`.

`parameters.clausal` holds the pin metadata only: the act, the OJ reference, the sha256 and `no_consolidation`. It holds no statutory figure; the figures live in the slice.

## 6. Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_set/3`, `eval_requirements/4`, `sum_list/2`, `int_min/3`, `int_max/3`, `attribute/2`, `item/3`, `unmet/1` and `unknown/1`, plus the vocabulary atom `met`.
- `library(datetime)` (date_time): `datetime/7`, `date_of/2` and `ordinal/2`.
- `kit/deadline_lib`: `month_last_day/3`, used for date validity and for the month-rule clamp. `deadline_months_after/3` is deliberately NOT used, because its semantics differ (the working notes (not published)).
- `kit/query_combinators`: `flip_scan/4` in the tests only, to cross-check the closed-form threshold. Probe closure: `counted_verdict_at(CountableMinutes)`, called with `(Counted, Verdict)`.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` and `prop_missing_key_coverage/3`.
- `_common` (deontic family backbone): no predicate is needed beyond the verdict-term convention.

Not used, and why:

- `ratio_bps/4`, `check_ratio_lte/6` and `max_numerator_lte/3` floor to basis points. The average must be exact.
- `check_tri/4` assumes a single key whose unsure value maps to unknown. Here an unsure key must go to `needs_legal_review` only when its kind MATTERS.

## 7. Fixtures (`fixtures.clausal`; each fixture also has a per-rule test)

A week is 2026-01-05 to 2026-01-11, with LENGTH 10080 minutes.

| Fixture | Case | Expected |
|---|---|---|
| `exactly_at_limit` | work 2880 | `within_weekly_limit`; average `minutes_per_seven_days(2880, 1)`; reduction 0; maximum 2880 |
| `one_minute_over` | work 2881, option false | `over_weekly_limit` [2_1, 6_b, 16_b]; reduction 1 |
| `leave_day_neutral` | one whole day of paid_annual_leave (COUNTABLE 8640), work 2469 | over; maximum 2468; reduction 1 |
| `shift_across_period_end` | a shift from 2026-01-11 22:00 to 2026-01-12 06:00 | counts 120 minutes |
| `midnight_shift` | a shift from 22:00 to 06:00 the next day, inside the period | counts 480 minutes |
| `other_worker_ignored` | shifts of `1`, query about `w1` | COUNTED 0, `within_weekly_limit` |
| `on_site_absent_matters` | work 2800, on-site 200, key absent | `indeterminate([on_call_on_site_counts_as_working_time])` |
| `on_site_unsure_matters` | as above, unsure, option false | `needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time-unsure])])` |
| `opt_out_agreed` | work 3500, option true, agreement true | `weekly_limit_not_applied_by_agreement` [22_1, 22_1_a] |
| `agreement_false_option_absent` | work 3500, agreement false | `over_weekly_limit` [2_1, 6_b, 16_b, 22_1_a] |
| `four_months_edge` | 2026-01-31 to 2026-05-30, member_state basis | within the ceiling |
| `four_months_edge_over` | 2026-01-31 to 2026-05-31, member_state basis | `reference_period_longer_than_allowed` [16_b] |
| `thirteen_months` | any basis, absent included | `reference_period_longer_than_allowed` [16_b, 19_first, 19_second, 20_2] |
| `all_leave` | every minute is sick_leave | `no_countable_period` [16_b] |
| `bad_profile` | `[attribute(reference_period_basis, x), attribute(foo, 1), attribute(foo, 2)]` | `input_problems([wrong_type(reference_period_basis), unknown_key(foo)])` |
