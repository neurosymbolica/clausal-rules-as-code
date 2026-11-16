# SIGNATURE — eu/labour/daily_rest

The public query surface follows the CALLED CONTRACT. Three queries take `(PROFILE, WORKER, SHIFTS, PERIOD_START, PERIOD_END, ...)`:

- `daily_rest_status/7`
- `shortest_daily_rest_minutes/6`
- `first_window_without_daily_rest/6`

`daily_rest_input_problems/2` takes the PROFILE only.

The scaffold facade names are kept. Their first argument is the case term `daily_rest_case(PROFILE, WORKER, SHIFTS, PERIOD_START, PERIOD_END)`, which bundles the five contract inputs.

Every public predicate is total (one solution for every input, never failing, never raising) and deterministic (exactly one solution, not one distinct answer). This is achieved with disjoint guarded clauses and with ground verdicts folded into clause heads (C17). There is no `!`, no `->` and no `*->`. Both statutory figures are declared once, in `daily_rest.clausal`.

## 1. Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

**Final answers of `daily_rest_status`:**

- `daily_rest_given`
- `daily_rest_not_given`
- `daily_rest_not_applied_to_worker`
- `daily_rest_derogation_applies`

**Final atoms of the measuring queries:**

- `no_work_start_in_period` (`shortest_daily_rest_minutes`)
- `no_window_without_daily_rest` (`first_window_without_daily_rest`)

**Not-final status compounds:** each is the argument ITSELF, never wrapped in a list.

- `indeterminate([KEY])`. Exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(PAIRS)])`
  - PAIRS holds the present judgement keys in root_exports order, written `KEY-VALUE`.
  - It may be followed by an unscored `provenance(CLAUSE, CITATIONS)`.
- `input_problems(PROBLEMS)`

**Result constructors** (exported, never called as queries), with these exact arities:

- `date_time/5`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

## 2. Profile keys

The four keys appear in this order, which is root_exports and input_contract order. Keys are bare atoms read only by `profile_get/3`: presence first, then value.

1. **`on_call_on_site_counts_as_working_time`**: a judgement key, tri-state `true | false | unsure` (Art 2(1)).
2. **`on_call_standby_counts_as_working_time`**: a judgement key, tri-state `true | false | unsure` (Art 2(1)).
3. **`worker_category`**: an enumeration key (Art 2(7), 20(1), 21(1)). Values:
   - `other_worker`
   - `mobile_worker`
   - `seagoing_fishing_vessel_worker`
4. **`derogation_from_article_3`**: an enumeration key (Art 17(1), 17(3), 17(4), 18). Values:
   - `no_derogation`
   - `derogation_under_article_17_1`
   - `derogation_under_article_17_3`
   - `derogation_under_article_17_4`
   - `derogation_under_article_18`

There are no numeric or date profile keys. The period and the rota are arguments, not keys:

- **`WORKER`**: an atom or an integer.
- **`SHIFTS`**: a list of `shift(WORKER_ID, date_time(Y, M, D, H, MIN), date_time(Y, M, D, H, MIN), KIND)`.
  - KIND is one of `work`, `on_call_on_site`, `on_call_standby`, `paid_annual_leave` or `sick_leave`.
- **`PERIOD_START`** and **`PERIOD_END`**: `date(Year, Month, Day)` terms.
- Every numeric figure is an integer of minutes.

## 3. Citation-key atoms

These are canonical lexicon atoms (`_lexicon/citations.yaml`), always written `cite(KEY)`. No shortened atom is ever invented.

- `eu_dir_2003_88_art_2_1`: Art 2(1), working time.
- `eu_dir_2003_88_art_2_2`: Art 2(2), rest period.
- `eu_dir_2003_88_art_2_7`: Art 2(7), mobile worker.
- `eu_dir_2003_88_art_3`: Art 3, daily rest. This is the article unit together with its one subparagraph.
- `eu_dir_2003_88_art_17_1`: Art 17(1), opening words.
- `eu_dir_2003_88_art_17_3`: Art 17(3), opening words.
- `eu_dir_2003_88_art_17_4`: Art 17(4), opening words.
- `eu_dir_2003_88_art_18_first_subpara`: Art 18, first subparagraph.
- `eu_dir_2003_88_art_18_second_subpara`: Art 18, second subparagraph.
- `eu_dir_2003_88_art_20_1`: Art 20(1), first subparagraph.
- `eu_dir_2003_88_art_21_1`: Art 21(1), first subparagraph.

The deferred units have no answer citation:

- Art 1(3) and its second sentence
- Art 14
- Art 17(2)
- Art 17(4)(a) and (b)
- Art 18, third subparagraph
- Art 20(1) and 21(1), second subparagraphs

## 4. Public predicates

**The contract queries:**

- `daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)`
  - Query type #2, the eligibility verdict.
  - Steps 0 / 1 / 2a / 2b / 2c / 3 of THE LIMBS.
  - Result is one status atom or one status compound. Citations is a flat set-like list of `cite(KEY)`, `[]` when not final.
  - Cites Art 3 with Art 2(1) and 2(2); Art 2(7) and 20(1); Art 21(1); Art 17(1), 17(3), 17(4); Art 18 first and second subparagraphs.
- `shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes)`
  - Query type #23, the calculation.
  - Minutes is one of: a bare integer 0..1439 (SHORTEST), `no_work_start_in_period`, `indeterminate([KEY])` or `needs_legal_review(...)`.
  - Art 3 read with Art 2(1) and 2(2). It never reads `worker_category` or `derogation_from_article_3`.
- `first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Start)`
  - Query type #6, the threshold.
  - Start is one of: `date_time(Y, M, D, H, MIN)` (FIRST_SHORT), `no_window_without_daily_rest`, `indeterminate([KEY])` or `needs_legal_review(...)`.
  - Art 3 read with Art 2(1) and 2(2).
- `daily_rest_input_problems(Profile, Problems)`
  - The bare flat list, in this order: duplicate_key / wrong_type per contract key in contract order, then unknown_key in order of first occurrence.
  - `[wrong_type(profile)]` for a profile that is not an attribute list.
  - No citation (input check).
- `daily_rest_minimum_consecutive_minutes(Minutes)`
  - Query type #6. Exposes the threshold boundary 660: the outcome changes between 659 and 660, and `>=` holds.
  - Art 3.

**Scaffold facade** (Case = `daily_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)`):

- `decide_daily_rest(Case, daily_rest_verdict(Status, Citations))`
  - Delegates to `daily_rest_status/7`. Status and Citations are exactly its arguments 6 and 7.
  - Same citations as `daily_rest_status/7`.
- `daily_rest_status(Case, Status)`
  - Status is argument 6 of `daily_rest_status/7`. It differs from the contract query by arity, which is allowed.
  - Art 3.
- `daily_rest_checklist(Case, Checklist)`
  - Built with formalize_lib `assess/6` / `eval_requirements/4` over the requirement closure `daily_rest_requirement(RequirementId, Profile, Status, Citation)`, where Profile is the case term.
  - Items: `item(Id, Status, cite(Key))`. Ids and their citations:
    - `rest_held_in_every_window`: `eu_dir_2003_88_art_3`
    - `working_time_classified`: `eu_dir_2003_88_art_2_1`
    - `article_3_applies_to_worker`: `eu_dir_2003_88_art_20_1` or `eu_dir_2003_88_art_21_1`
    - `no_derogation_stated`: the derogating key
  - Each item has exactly three disjoint clauses: met / unmet / unknown.
- `daily_rest_what_if(Case, Key, Value, Status)`
  - Overrides one profile key with formalize_lib `profile_set/3` (or query_combinators `what_if/5` with closure `daily_rest_case_status`), then re-runs `daily_rest_status/7`. Status is its argument 6.
  - Same citations as `daily_rest_status/7`.
- `daily_rest_fixture(Name, Case)` and `daily_rest_fixture_expected(Name, Query, Answer)` in `fixtures.clausal`.
  - Named rotas with their expected answers (see §6).
  - No citation (fixtures).

## 5. Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
  - `assess/6`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `attribute/2`
  - `int_min/3`, `int_max/3`, `not_member/2`, `memberd/2`
  - There is no hand-rolled `check_tri`: the tri-state on-call keys are read by presence and value into counted / not_counted / unresolved, which is a three-way classification and not a Kleene check. If a lint flags C15, switch to `check_tri/4`.
- **library(datetime)**:
  - `days_between/3` for the Gregorian day count in minute arithmetic.
  - `date_add/3` and `timedelta/3` to turn an absolute minute back into `date_time/5`.
  - Dates are constructed in the form the module registers (`date/4` object until `date/3` lands). Objects are carried, never `[Y, M, D]` lists.
- **kit/deadline_lib**:
  - `month_last_day/3` to check that `date_time` and `date` terms name real calendar days.
  - `next_day/2` for END_OF_PERIOD (00:00 on the day after PERIOD_END).
- **kit/query_combinators**:
  - `what_if/5` (closure) for `daily_rest_what_if/4`.
  - `flip_scan/4` in the boundary tests (closure `held_at_rest_minutes(660)` over 0..1439).
- **validate_props**:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `prop_monotone/5`.
  - Used by the property test mode. For example, adding a counted row never raises SHORTEST.
- **Family backbone `_common` (deontic):** the verdict wrapper and checklist conventions only. No `_common` predicate re-declares a figure.
- **Not used:**
  - compliance_lib: the modal lattice does not fit a caller-stated derogation.
  - rolling_window: day resolution only, too coarse. Noted in the working notes (not published) as a kit candidate.
  - currency, vat and country vocabularies: no money and no country input.

## 6. Layout: kernel -> citations -> parameters -> daily_rest -> queries -> fixtures -> package facade

- **kernel.clausal** holds the shared floor only: predicates used by both the slice and `queries.clausal`.
  - `date_time_absolute_minute(DateTime, AbsoluteMinute)`: minutes from a fixed library(datetime) epoch date, by `days_between/3` x 1440 + H x 60 + MIN.
  - `absolute_minute_date_time(AbsoluteMinute, DateTime)`: the inverse, by `date_add/3` + `timedelta/3`, then integer division and remainder.
  - `real_date_time(Term)` and `real_calendar_date(Term)`: ground, integer fields, `month_last_day/3`, H 0..23, MIN 0..59.
  - `period_bounds(PeriodStart, PeriodEnd, StartOfPeriodMinute, EndOfPeriodMinute)`.
  - The input check:
    - `daily_rest_input_problems/2` for the profile;
    - `daily_rest_argument_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems)` for step 0, in this order: profile, worker, shifts (malformed row or overlapping rows of WORKER), period_start, period_end.
    - The check never fails and never raises. It guards with `var/1`, `nonvar/1`, `ground/1`, `atom/1`, `integer/1` and a proper-list walk that rejects partial lists and unbound elements.
- **citations.clausal** holds `citation_vocabulary/1` facts for the eleven keys of §3, plus the deferred-unit notes as comments.
- **parameters.clausal** holds the input_contract only:
  - `contract_key/2` in key order, with type `judgement` or `enumeration(Atoms)`;
  - `shift_kind/1`;
  - the root_exports order.
  - It declares no statutory figure (those live in the slice).
- **daily_rest.clausal** is the determination slice (§7).
- **queries.clausal** holds the three contract queries and the step logic of THE LIMBS:
  - settled / matters / behind / absent key to name;
  - the PAIRS rule;
  - one disjoint clause per route.
- **fixtures.clausal** holds the named cases (below).
- **The package facade** re-exports the contract queries, the facade predicates and the result constructors.

Planned fixtures. All use `w1`. The default profile is `[attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)]`.

- **F_ordinary**:
  - Rota: work 2026-03-02 08:00-17:00 and 2026-03-03 08:00-17:00. Period 2026-03-02..2026-03-02.
  - Answers: `daily_rest_given`; SHORTEST 900; `no_window_without_daily_rest`.
- **F_short**:
  - Rota: work 03-02 08:00-20:00 and 03-03 06:00-14:00. Period 03-02..03-03.
  - Answers: SHORTEST 600; FIRST_SHORT `date_time(2026, 3, 2, 8, 0)`; `daily_rest_not_given`.
  - With `mobile_worker`: `daily_rest_not_applied_to_worker` with `[cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]`.
  - With `seagoing_fishing_vessel_worker`: `[cite(eu_dir_2003_88_art_21_1)]`.
  - With `derogation_under_article_18`: both Art 18 citations.
  - With `worker_category` absent: `indeterminate([worker_category])`.
- **F_boundary_660**:
  - Rota: work ending 21:00, next start 08:00. Rest 660, held.
  - Answers: `daily_rest_given`; SHORTEST 660.
- **F_boundary_659**:
  - Rota: end 21:01. Rest 659, short.
  - Answers: SHORTEST 659; `daily_rest_not_given`.
- **F_on_call_on_site**:
  - Rota: work 03-02 08:00-17:00, on_call_on_site 17:00-22:00, work 03-03 08:00-17:00. Period 03-02.
  - If counted, rest is 600; if not, 900.
  - With the key absent: all three queries give `indeterminate([on_call_on_site_counts_as_working_time])`.
  - With the key `unsure`: `needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time-unsure])])`.
  - With the key `true`: `daily_rest_not_given`.
  - With the key `false`: `daily_rest_given`.
- **F_no_work**:
  - Rota: SHIFTS empty, or only other workers' rows.
  - Answers: `daily_rest_given`; `no_work_start_in_period`; `no_window_without_daily_rest`.
- **F_period_cut**:
  - Rota: work 03-01 22:00 to 03-02 06:00. Period 03-02.
  - One window from 00:00 03-02. Rest 1080: given.
- **F_leave**:
  - Rota: paid_annual_leave and sick_leave rows between work rows. They count as rest.
- **F_standby_behind**:
  - Rota: both on-call keys absent.
  - The on-site kind matters for the measuring queries only when standby is counted, while standby matters either way.
  - Measuring queries: `indeterminate([on_call_standby_counts_as_working_time])`.
  - `daily_rest_status`: names the on-site key.
- **F_input_problems**:
  - `[attribute(worker_category, pilot), attribute(derogation_from_article_3, no_derogation), attribute(derogation_from_article_3, no_derogation), attribute(colour, red)]` gives `[wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]`.
  - An unbound profile gives `[wrong_type(profile)]`.
  - A bad period end appends `wrong_type(period_end)`.

The seven test modes are: load, unit (per rule), boundary (659/660, window edges), indeterminate (each missing key, the first-missing-key rule naming), referral (unsure), input (every problem term and order), and property (totality, determinism by solution count with `findall` + `length(Solutions, 1)`, citation completeness, monotonicity). Every `test(_, fail)` is paired with a positive test over the same case.

## 7. Slice — daily_rest.clausal

**Statutory VALUE facts owned here** (declared once, read with `constant(Name)`):

- `:- constant_value(daily_rest_minimum_consecutive_minutes, 660).` Art 3: 11 consecutive hours. Inclusive `>=`.
- `:- constant_value(daily_rest_window_minutes, 1440).` Art 3: per 24-hour period.
- `:- constant_value(minutes_per_day, 1440).` Used for date arithmetic. It is not a statute; it lives here beside the window figure.
- The kind-count table:
  - `kind_counting(work, always_counted)`
  - `kind_counting(paid_annual_leave, never_counted)`
  - `kind_counting(sick_leave, never_counted)`
  - `kind_counting(on_call_on_site, judgement(on_call_on_site_counts_as_working_time))`
  - `kind_counting(on_call_standby, judgement(on_call_standby_counts_as_working_time))`
- The derogation table:
  - `derogation_citations(derogation_under_article_17_1, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_1)])`
  - the same pattern for `derogation_under_article_17_3` and `derogation_under_article_17_4`;
  - `derogation_under_article_18` with Art 3 and both Art 18 subparagraphs.
- The category table: `mobile_worker` cites Art 2(7) and Art 20(1); `seagoing_fishing_vessel_worker` cites Art 21(1).

**Rules and requirements** (all arithmetic on exact integer absolute minutes):

1. `worker_rows(Worker, Shifts, Rows)`: the rows whose WORKER_ID `==` Worker, converted to `row(StartMinute, EndMinute, Kind)`.
2. `kind_resolution(Profile, Kind, Resolution)`: one of `counted`, `not_counted` or `unresolved`. Absent or `unsure` is unresolved. The clauses are disjoint, and the profile is read with `profile_get/3`.
3. `completion(Profile, Completion)`: a list `[on_call_on_site-Choice, on_call_standby-Choice]`. Fixed kinds take their resolution; each unresolved kind takes counted or not_counted. Enumerated with `findall` only inside `all_completions/2`, which yields one list.
4. `working_intervals(Rows, Completion, Intervals)`: the counted rows, sorted by start and merged where they touch or overlap.
5. `window_starts(Intervals, StartOfPeriodMinute, EndOfPeriodMinute, Starts)`:
   - StartOfPeriod, if a counted interval has start < StartOfPeriod < end;
   - each counted row start S with StartOfPeriod =< S < EndOfPeriod.
   - The list is deduplicated with `sort/2` over integers.
6. `longest_rest_in_window(Intervals, WindowStart, LongestRestMinutes)`: the largest gap between working intervals, clipped to `[WindowStart, WindowStart + 1440)`, including the leading and trailing gaps; 0 if there is none.
7. `window_holds_daily_rest(LongestRestMinutes)`: `LongestRestMinutes >= constant(daily_rest_minimum_consecutive_minutes)`.
8. `completion_measure(Rows, Completion, PeriodBounds, measure(Given, Shortest, FirstShort))`:
   - Given is `given` or `short`.
   - Shortest is an integer or `none`.
   - FirstShort is an absolute minute or `none`.
9. `kind_matters(Query, Kind, Measures)`: two completions differing only in Kind give different values for that query's component.
10. `kind_behind(Query, Kind, OtherKind, Measures)`: some fixing of OtherKind makes Kind not matter.
11. `absent_key_to_name(Query, Profile, Measures, Key)`:
    - with one absent key whose kind matters, that key;
    - with two, the key whose kind is not behind;
    - on a tie, `on_call_on_site_counts_as_working_time`.
    - It fails when there is none. That is a disjoint guard used by queries.clausal, never exposed as a public answer.
12. `unsure_key_to_refer(Query, Profile, Measures, Key)`: the first unsure key, in root order, whose kind matters.
13. `relied_on_pairs(Profile, Pairs)`: the present judgement keys as `KEY-VALUE`, in root order.

**Requirements for the checklist closure:** `daily_rest_requirement(RequirementId, Case, Status, Citation)`, with three disjoint clauses each:

- `rest_held_in_every_window`:
  - met when given in every completion;
  - unmet when short in every completion;
  - unknown(`[Key]`) otherwise.
- `working_time_classified`: met when no unresolved kind matters; unknown otherwise.
- `article_3_applies_to_worker`: met for `other_worker`; unmet for the two excluded categories; unknown when absent.
- `no_derogation_stated`: met for `no_derogation`; unmet for a derogation; unknown when absent.

**Verdict atoms produced here:**

- `daily_rest_given`
- `daily_rest_not_given`
- `daily_rest_not_applied_to_worker`
- `daily_rest_derogation_applies`
- `no_work_start_in_period`
- `no_window_without_daily_rest`

These are produced through clause heads in queries.clausal, one clause per disjoint route.

**Predicates SHARED with other files** (and only these live in kernel.clausal):

- `date_time_absolute_minute/2`
- `absolute_minute_date_time/2`
- `real_date_time/1`
- `real_calendar_date/1`
- `period_bounds/4`

These are needed by both this slice and the step-0 input check. Nothing statutory is shared: 660 and 1440 stay in this file.
