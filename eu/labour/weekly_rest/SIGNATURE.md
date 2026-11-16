# SIGNATURE — eu/labour/weekly_rest

## Public query surface

The package layout stays as scaffolded:

`kernel -> citations -> parameters -> weekly_rest -> queries -> fixtures -> package facade`

The contract predicates are the following.

- `weekly_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)` returns one of:
  - `weekly_rest_given`
  - `weekly_rest_not_given`
  - `weekly_rest_not_applied_to_worker`
  - `weekly_rest_derogation_applies`
  - a status compound.
- `shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes)` returns an integer from 0 to 10080, or a status compound.
- `first_period_without_weekly_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Day)` returns `date(Y, M, D)`, `no_period_without_weekly_rest`, or a status compound.
- `weekly_rest_input_problems(Profile, Problems)` returns a bare list.

The scaffold facade names are kept. They wrap the contract over a case term `weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)`.

The facade `weekly_rest_status/2` and the contract `weekly_rest_status/7` are distinct predicates by arity. Both are exported.

Totality and determinism are claimed for every public predicate: exactly one solution for every input. The input check never fails and never raises.

Statutory figures live in the slice `weekly_rest.clausal` as `constant_value/2` facts. They are never re-declared elsewhere.

## Verdict STATUS atoms (replace the placeholders `required`, `permitted`, `not_applicable`)

**Final results of the status query:**

- `weekly_rest_given`
- `weekly_rest_not_given`
- `weekly_rest_not_applied_to_worker`
- `weekly_rest_derogation_applies`

**Final results of the day query:**

- `no_period_without_weekly_rest`
- `date(Year, Month, Day)`

**Not-final status compounds.** Each is the compound itself, never wrapped in a list.

- `input_problems(Problems)`
- `indeterminate([Key])`: always exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(Pairs)])`
  - An optional trailing `provenance(Clause, Citations)` may follow.
  - Pairs are the present judgement keys in root_exports order, written `Key-Value`.

**Problem terms:**

- `unknown_key(Key)`
- `wrong_type(Key)`
- `duplicate_key(Key)`
- `wrong_type(profile)`
- `wrong_type(worker)`
- `wrong_type(shifts)`
- `wrong_type(period_start)`
- `wrong_type(period_end)`

**Exported result constructors, with exact arities:**

- `date/3`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

**Checklist labels for the facade:** `labels(weekly_rest_given, indeterminate_weekly_rest, weekly_rest_not_given)`. These are used only inside `assess/6`. The contract predicates never return them.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`. Keys appear here in root_exports and input_contract order. An absent key is never an input problem.

| Order | Key | Kind | Values |
|---|---|---|---|
| 1 | `on_call_on_site_counts_as_working_time` | judgement | `true`, `false` or `unsure` |
| 2 | `on_call_standby_counts_as_working_time` | judgement | `true`, `false` or `unsure` |
| 3 | `weekly_rest_minimum` | enumeration | `rest_of_24_plus_11_hours`, `reduced_rest_of_24_hours` |
| 4 | `weekly_rest_reference_period` | enumeration | `seven_day_period`, `fourteen_day_reference_period` |
| 5 | `worker_category` | enumeration | `other_worker`, `mobile_worker`, `seagoing_fishing_vessel_worker` |
| 6 | `derogation_from_article_5` | enumeration | `no_derogation`, `derogation_under_article_17_1`, `derogation_under_article_17_3`, `derogation_under_article_17_4`, `derogation_under_article_18` |

The arguments are not profile keys:

- `Worker`: an atom or an integer.
- `Shifts`: a list of `shift(WorkerId, date_time(Y, M, D, H, MIN), date_time(Y, M, D, H, MIN), Kind)`.
  - Kind is one of `work`, `on_call_on_site`, `on_call_standby`, `paid_annual_leave`, `sick_leave`.
- `PeriodStart` and `PeriodEnd`: `date(Year, Month, Day)` terms. Both days are included in the period.

There is no numeric profile key. Every numeric figure is a derived integer in minutes, with a `_minutes` suffix.

## Citation-key atoms

The atoms below come from the canonical lexicon. They are never shortened or invented.

| Citation key | Load-bearing unit |
|---|---|
| `eu_dir_2003_88_art_2_1` | Art 2(1), working time; also the referral row |
| `eu_dir_2003_88_art_2_2` | Art 2(2), rest period |
| `eu_dir_2003_88_art_2_7` | Art 2(7), mobile worker |
| `eu_dir_2003_88_art_5_first_subpara` | Art 5, first subparagraph |
| `eu_dir_2003_88_art_5_second_subpara` | Art 5, second subparagraph |
| `eu_dir_2003_88_art_16_a` | Art 16(a) |
| `eu_dir_2003_88_art_17_1` | Art 17(1) |
| `eu_dir_2003_88_art_17_3` | Art 17(3) |
| `eu_dir_2003_88_art_17_4` | Art 17(4) |
| `eu_dir_2003_88_art_18_first_subpara` | Art 18, first subparagraph |
| `eu_dir_2003_88_art_18_second_subpara` | Art 18, second subparagraph |
| `eu_dir_2003_88_art_20_1` | Art 20(1), first subparagraph |
| `eu_dir_2003_88_art_21_1` | Art 21(1), first subparagraph |

**Citation sets.** Each is a set-like list, with each atom written once.

- `weekly_rest_given` and `weekly_rest_not_given`:
  - `cite(eu_dir_2003_88_art_2_1)`
  - `cite(eu_dir_2003_88_art_2_2)`
  - `cite(eu_dir_2003_88_art_5_first_subpara)`
  - `cite(eu_dir_2003_88_art_5_second_subpara)`
  - `cite(eu_dir_2003_88_art_16_a)`
- `weekly_rest_not_applied_to_worker`:
  - for a mobile worker: `cite(eu_dir_2003_88_art_2_7)`, `cite(eu_dir_2003_88_art_20_1)`;
  - for a fishing-vessel worker: `cite(eu_dir_2003_88_art_21_1)`.
- `weekly_rest_derogation_applies`: `cite(eu_dir_2003_88_art_5_first_subpara)` plus the derogating provision:
  - `cite(eu_dir_2003_88_art_17_1)`, or
  - `cite(eu_dir_2003_88_art_17_3)`, or
  - `cite(eu_dir_2003_88_art_17_4)`, or
  - `cite(eu_dir_2003_88_art_18_first_subpara)` together with `cite(eu_dir_2003_88_art_18_second_subpara)`.
- Every not-final answer: `[]`.

## Public predicates

**Facade and contract (eligibility, #2):**

- `weekly_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)`: the contract verdict. It follows the limbs:
  - step 0: input problems;
  - step 1: the rest is given in every completion;
  - step 2a: name the absent key that matters;
  - step 2b: name `worker_category`, then `derogation_from_article_5`;
  - step 2c: refer the first `unsure` on-call key to a lawyer;
  - step 3: the rest is short in every completion, so decide by category and derogation.
  
  Cites Art 5 (both subparagraphs) and Art 16(a), with Art 2(1) and Art 2(2); or Art 20(1) with Art 2(7); or Art 21(1); or Art 17 or Art 18.
- `decide_weekly_rest(Case, weekly_rest_verdict(Status, Citations))`: facade. It unpacks `weekly_rest_case/5` and calls `weekly_rest_status/7`. It has the same citations.
- `weekly_rest_status(Case, Status)`: facade. It gives the status only, from `weekly_rest_status/7`.
- `weekly_rest_checklist(Case, Checklist)`: a cited checklist built with `assess/6`, using requirement closure `weekly_rest_requirement`. The requirements are:
  - `weekly_rest_input_well_formed`, which cites no provision: `cite(input_contract)`;
  - `weekly_rest_article_5_applies_to_worker`, citing Art 20(1), Art 21(1) and Art 2(7);
  - `weekly_rest_no_derogation_from_article_5`, citing Art 17(1), Art 17(3), Art 17(4) and Art 18;
  - `weekly_rest_every_block_holds_weekly_rest`, citing Art 5 and Art 16(a), with Art 2(1) and Art 2(2).
  
  Each requirement has three disjoint clauses: met, unmet and unknown.
- `weekly_rest_what_if(Case, Key, Value, Result)`: re-runs `weekly_rest_status/7` with one profile key overridden, using `kit/query_combinators what_if/5` on the profile. It has the same citations as the status it returns.

**Calculation (#23):**

- `shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes)`: the smallest BLOCK_REST over the blocks, an exact integer of minutes. It never reads `worker_category`, `derogation_from_article_5` or `weekly_rest_minimum`. Cites Art 5 with Art 16(a), Art 2(1) and Art 2(2).

**Day:**

- `first_period_without_weekly_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Day)`: the start day of the earliest block that does not hold the weekly rest, or `no_period_without_weekly_rest`. Cites Art 5 with Art 16(a), Art 2(1) and Art 2(2).

**Threshold (#6):**

- `weekly_rest_required_minutes(Profile, RequiredMinutes)`: the outcome boundary REQUIRED.
  - 2100 for `rest_of_24_plus_11_hours`, citing Art 5, first subparagraph.
  - 1440 for `reduced_rest_of_24_hours`, citing Art 5, second subparagraph.
  - `indeterminate([weekly_rest_minimum])` when the key is absent.
  - `input_problems(Problems)` first.
  
  A block holds the weekly rest exactly when `BlockRestMinutes >= RequiredMinutes`.
- `weekly_rest_threshold_boundary(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Boundary)`: `boundary(RequiredMinutes, ShortestMinutes)`, the two exact integers whose comparison flips the verdict. If either is not final, its status compound is returned instead. Cites Art 5 and Art 16(a).

**Input check:**

- `weekly_rest_input_problems(Profile, Problems)`: the input check, `[]` or problem terms in contract order. It yields exactly one solution and never raises. No provision is cited.

**Fixtures:**

- `weekly_rest_fixture(Name, Case, ExpectedStatus)`: test fixtures in `fixtures.clausal`. They cover each limb and each boundary: runs of 2099, 2100, 1439 and 1440 minutes, a fourteen-day run of 4199 versus 4200 minutes, block-edge splitting, and the BEHIND naming cases.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - checklist engine: `assess/6`, `item/3`, `labels/3`, `unmet/1`, `unknown/1`;
  - list and integer helpers: `memberd/2`, `not_member/2`, `int_min/3`, `int_max/3`, `sum_list/2`.
- **`library(datetime)`** (native datetime):
  - `days_between/3` for exact day counts;
  - `date_add/3` and `timedelta/3` for block start days;
  - `ordinal/2` for chronological comparison;
  - the `date/4` object constructor for validation until `date/3` lands.
- **`kit/query_combinators`:**
  - `what_if/5` for `weekly_rest_what_if/4`;
  - `flip_scan/4` in the threshold tests, to locate the run length at which a block flips.
- **`list_item/3`** (built-in): positional reads of sorted runs (longest and second longest).
- **`validate_props`:**
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`;
  - `prop_monotone/5`: adding rest never lowers SHORTEST.
- **`_common` family backbone:** none needed beyond formalize_lib.
- **Not used, with reasons:**
  - kit.deadline_lib: no deadlines here (the deadline-only rounding scope scopes rounding to deadline clocks).
  - kit.rolling_window: whole days only; blocks here are fixed, not rolling.
  - kit.compliance_lib: the verdict is a fixed limb order, not a modality lattice.

## Determination slices

### kernel.clausal (shared floor)

Only one determination slice exists, so no domain predicate must be shared. The kernel keeps the scaffold floor only: module header, the result-constructor declarations, and the re-export of `profile_get/3`.

Minute arithmetic and run extraction stay in the slice. They move to the kernel only if a second slice (for example, a future daily-rest slice) needs them.

### weekly_rest.clausal

**Value facts owned by this slice.** These are the only home of these figures; they are read with `constant(Name)`.

- `:- constant_value(weekly_rest_full_minimum_minutes, 2100).` (Art 5, first subparagraph: 24 hours plus 11 hours.)
- `:- constant_value(weekly_rest_reduced_minimum_minutes, 1440).` (Art 5, second subparagraph.)
- `:- constant_value(weekly_rest_seven_day_block_minutes, 10080).`
- `:- constant_value(weekly_rest_fourteen_day_block_minutes, 20160).` (Art 16(a).)
- `:- constant_value(minutes_per_day, 1440).`
- `:- constant_value(minutes_per_hour, 60).`
- Tables:
  - `weekly_rest_minimum_required(Atom, ConstantName)`;
  - `weekly_rest_reference_block(Atom, ConstantName)`;
  - `weekly_rest_kind_counting(Kind, always_counted | never_counted | judged_by(Key))`;
  - `weekly_rest_profile_key_type(Key, Order, Atoms)` for the six keys in contract order;
  - `weekly_rest_derogation_citations(Atom, Citations)`;
  - `weekly_rest_category_citations(Atom, Citations)`.

**Rules and requirements, in order of authoring:**

1. **Input check.**
   - `weekly_rest_input_problems/2`: attribute-list test, duplicates, wrong types and unknown keys.
   - `weekly_rest_argument_problems/5`:
     - Worker is an atom or an integer.
     - Shifts form a ground proper list of valid shifts, START before END, with no overlap among the worker's rows.
     - Both period dates are real days.
     - The period end is not before the period start.
   
   The check never raises: types are tested before any datetime call.
2. **Minute arithmetic.** `weekly_rest_minute_offset(PeriodStart, date_time(Y, M, D, H, MIN), Minutes)` computes `days_between * 1440 + H * 60 + MIN`. Start and end of period become offsets 0 and `(days_between(PeriodStart, PeriodEnd) + 1) * 1440`.
3. **Completions.** `weekly_rest_unresolved_choices/2` and `weekly_rest_completion/3` enumerate choices for:
   - each on-call kind that is absent or `unsure`;
   - an absent minimum;
   - an absent reference period.
   
   `weekly_rest_completions/2` collects them with findall.
4. **Working intervals.** In a completion, working intervals are the rows of counted kinds, as minute offsets.
5. **Blocks.** Blocks are `[N * Length, (N + 1) * Length)` while the start is below the end of period.
6. **Runs.** A block's runs are the gaps between merged working intervals, clipped to the block.
7. **Block rest.** `weekly_rest_block_rest_minutes/3`:
   - seven days: the longest run, or 0;
   - fourteen days: `max(SecondLongest, Longest // 2)`.
8. **Per completion:**
   - `weekly_rest_completion_outcome/4`: given or short;
   - `weekly_rest_completion_shortest/4`: the minimum block rest;
   - `weekly_rest_completion_first_short/4`: a block start offset, or `none`.
9. **Naming.** `weekly_rest_settled/3`, `weekly_rest_choice_matters/4`, `weekly_rest_key_behind/5`, and `weekly_rest_absent_key_to_name/4`:
   - drop every key strictly behind another key that matters;
   - name the first remaining key in root_exports order;
   - if none remains, name the first key that matters.
10. **Limbs.** The limbs of the three queries and the threshold query. Each limb is one clause per disjoint route, with the constant result folded into the head. The routes are disjoint because each clause tests a mutually exclusive condition: problems empty or not, settled or not, key present or absent, and so on.
11. **Back to calendar days.** Day of FIRST_SHORT: offset divided by 1440 gives a day count, and `date_add` with `timedelta(Days, 0, _)` converts it back to `date(Y, M, D)`.
12. **Pairs.** `weekly_rest_inputs_relied_on/2`: the present judgement keys as `Key-Value`, in order.
13. **Checklist requirements.** `weekly_rest_requirement(RequirementId, Case, Status, Citation)`, with RequirementId first, for the four checklist ids above.

**Verdict atoms of this slice:**

- `weekly_rest_given`
- `weekly_rest_not_given`
- `weekly_rest_not_applied_to_worker`
- `weekly_rest_derogation_applies`
- `no_period_without_weekly_rest`
- the status compounds above.

**Shared predicates:** none. Nothing from this slice belongs in kernel.clausal.

**Tests owned by this slice (per rule):**

- input-check ordering and degenerate terms (unbound, partial list, non-atom key);
- `wrong_type(period_end)` when the end is before the start;
- exact boundary runs: 2099 and 2100 minutes; 1439 and 1440 minutes;
- fourteen-day halving: 4199 versus 4200 minutes; a 4201-minute run;
- edge clipping across blocks;
- the last block running past PERIOD_END;
- step 1 for a mobile worker;
- step 2a naming, both the first-in-order case and the strictly-behind case;
- step 2b for a missing `worker_category` and a missing derogation;
- step 2c pairs;
- step 3 for each category and derogation;
- determinism: `findall` length 1 for every query.
