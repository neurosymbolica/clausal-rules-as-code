# SIGNATURE — eu/labour/night_work

## Public query surface (overview)

The CALLED CONTRACT has three queries.

- `night_work_average_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)` answers Art 8(a).
- `hazardous_night_work_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)` answers Art 8(b).
- `night_work_input_problems(Profile, Problems)` checks a PROFILE.

Each query is TOTAL and DETERMINISTIC: exactly ONE solution for every input term, never a failure or an exception. A correct answer yielded twice is a refutation.

Two #23 calculation helpers return bare integers:

- `night_work_block_limit_minutes/2`
- `night_work_span_working_minutes/6`

The scaffold facade (`decide_night_work/2`, `night_work_status/2`, `night_work_checklist/2`, `night_work_what_if/4`, fixtures) wraps these queries over a case term.

This domain imports no figure from another domain. Every statutory figure is declared once, with `constant_value/2`, in `night_work.clausal`.

### Constraints

- **No control constructs.** No `!`, `->` or `*->`.
- **Verdicts in the head.** Ground verdicts are folded into clause heads, one clause per disjoint route (C17).
- **Full-word names.** Identifiers are full words (C6). Variables are full CamelCase words (C5).

## Verdict STATUS atoms (replacing the placeholder { required, permitted, not_applicable })

The order uses these names. They are not text of the Directive.

**Final results for `night_work_average_status`:**

- `average_night_hours_kept`
- `average_night_hours_exceeded`
- `night_work_limits_not_applied_to_worker`
- `not_a_night_worker`
- `night_work_derogation_applies`

**Final results for `hazardous_night_work_status`:**

- `hazardous_night_work_hours_kept`
- `hazardous_night_work_hours_exceeded`
- `night_work_limits_not_applied_to_worker`
- `not_a_night_worker`
- `no_special_hazards_or_heavy_strain`
- `night_work_derogation_applies`

**Not final** (Citations is `[]`; each is a compound returned ITSELF, never wrapped in a list):

- `input_problems(Problems)`
- `indeterminate([Key])`, with exactly ONE bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`. An unscored trailing `provenance(Clause, Citations)` may follow.

**Result constructors** (exported, never queried), with exact arities:

`date/3`, `date_time/5`, `shift/4`, `cite/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

**Vocabularies:**

- **Shift kinds:** `work`, `on_call_on_site`, `on_call_standby`, `paid_annual_leave`, `sick_leave`.
- **Judgement values:** `true`, `false`, `unsure`.

## Profile keys (root_exports and input_contract order; read ONLY with profile_get/3)

The contract fixes these key names. Their units are stated in the type column. The scaffold's unit-suffix convention is overridden by the non-negotiable contract. For example, `night_time_start` is in minutes after midnight.

| # | Key | Kind | Type / range | Reference |
|---|---|---|---|---|
| 1 | `on_call_on_site_counts_as_working_time` | judgement | `true` / `false` / `unsure` | Art 2(1) |
| 2 | `on_call_standby_counts_as_working_time` | judgement | `true` / `false` / `unsure` | Art 2(1) |
| 3 | `night_time_start` | integer, minutes after midnight | 0, or 301..1439 | Art 2(3) |
| 4 | `night_time_end` | integer, minutes after midnight | 300..1439 | Art 2(3) |
| 5 | `night_work_reference_period_days` | integer, whole days | at least 1 | Art 16(c) |
| 6 | `worker_category` | enumeration | `other_worker`, `mobile_worker`, `seagoing_fishing_vessel_worker` | Art 2(7), Art 20(1), Art 21(1) |
| 7 | `night_worker` | judgement | `true` / `false` / `unsure` | Art 2(4) |
| 8 | `special_hazards_or_heavy_strain` | judgement | `true` / `false` / `unsure` | Art 8, last subparagraph |
| 9 | `derogation_from_article_8` | enumeration | `no_derogation`, `derogation_under_article_17_1`, `derogation_under_article_17_3`, `derogation_under_article_18` | Art 17(1), Art 17(3), Art 18 |

**Night-time rule.** When both night-time keys are present, each once and each in range, they must satisfy one of:

- `night_time_start = 0` and `night_time_end >= 420`;
- `night_time_start >= 301`, `night_time_end < night_time_start`, and `1440 - night_time_start + night_time_end >= 420`.

Otherwise the problem is `wrong_type(night_time_end)`.

**Keys each query reads:**

- `night_work_average_status` reads keys 1, 2, 5, 6, 7 and 9.
- `hazardous_night_work_status` reads keys 1, 2, 3, 4, 6, 7, 8 and 9.

**Pairs for referral (THE PAIRS RULE).** The pairs are the present judgement keys of the query, in this order, unsure ones included:

- Art 8(a): keys 1, 2 and 7.
- Art 8(b): keys 1, 2, 7 and 8.

**Arguments:**

- `Worker` is an atom or an integer.
- `Shifts` is a list of `shift(WorkerIdentifier, date_time(Y, M, D, H, MIN), date_time(Y, M, D, H, MIN), Kind)` terms.
- `PeriodStart` and `PeriodEnd` are `date(Year, Month, Day)` terms.

These are not profile keys.

## Citation-key atoms (canonical lexicon; never shortened)

The contract and lexicon fix these keys (`_lexicon/citations.yaml`). They override the scaffold's example form.

| Citation key | Provision |
|---|---|
| `eu_dir_2003_88_art_2_1` | Art 2(1), working time |
| `eu_dir_2003_88_art_2_3` | Art 2(3), night time |
| `eu_dir_2003_88_art_2_4` | Art 2(4), night worker |
| `eu_dir_2003_88_art_2_7` | Art 2(7), mobile worker |
| `eu_dir_2003_88_art_8` | Art 8, opening words |
| `eu_dir_2003_88_art_8_a` | Art 8(a) |
| `eu_dir_2003_88_art_8_b` | Art 8(b) |
| `eu_dir_2003_88_art_8_final_subpara` | Art 8, last subparagraph |
| `eu_dir_2003_88_art_16_c` | Art 16(c) |
| `eu_dir_2003_88_art_16_final_subpara` | Art 16, last sentence |
| `eu_dir_2003_88_art_17_1` | Art 17(1) |
| `eu_dir_2003_88_art_17_3` | Art 17(3) |
| `eu_dir_2003_88_art_18_first_subpara` | Art 18, first subparagraph |
| `eu_dir_2003_88_art_18_second_subpara` | Art 18, second subparagraph |
| `eu_dir_2003_88_art_20_1` | Art 20(1) |
| `eu_dir_2003_88_art_21_1` | Art 21(1) |

Deferred units get no key: Art 1(3), Art 2(4)(a)/(b), Art 14, the Art 16 opening words and the sentence after Art 16(b), Art 17(2), Art 18 third subparagraph, and the second subparagraphs of Art 20(1) and Art 21(1).

## Public predicates (one line each)

### Called contract

- `night_work_average_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)`: Art 8(a) average limit over the reference blocks of Art 16(c), with the divisor of Art 16's last sentence. Takes the limbs 0 to 3. Citations for the kept and exceeded answers: art_2_1, art_2_4, art_8, art_8_a, art_16_c, art_16_final_subpara.
- `hazardous_night_work_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations)`: Art 8(b) limit over the 24-hour windows from each start of work. Takes the limbs 0 to 3. Citations for the kept and exceeded answers: art_2_1, art_2_3, art_2_4, art_8, art_8_b, art_8_final_subpara.
- `night_work_input_problems(Profile, Problems)`: Checks the PROFILE alone. `Problems` is the BARE flat list, in this order:
  1. `duplicate_key` or `wrong_type`, per contract key in contract order;
  2. `unknown_key`, in order of first occurrence.

  `[wrong_type(profile)]` for a non-attribute-list. No citation.

### #23 calculation helpers (auxiliary; never a status result)

- `night_work_block_limit_minutes(BlockDays, LimitMinutes)`: `LimitMinutes = 480 * (BlockDays - BlockDays // 7)`, the most working time a reference block of `BlockDays` days may hold. Bare integer. Cites Art 8(a) and Art 16, last sentence (documented, not returned).
- `night_work_span_working_minutes(Worker, Shifts, CountedKinds, SpanStart, SpanEnd, WorkingMinutes)`: Exact integer minutes of working time of `Worker`'s rows whose kind is in `CountedKinds`, inside `[SpanStart, SpanEnd)` (both `date_time/5`). Bare integer, no rounding. Cites Art 2(1).

### Scaffold facade (names kept)

The facade takes `Case = night_work_case(Limit, Profile, Worker, Shifts, PeriodStart, PeriodEnd)`, where `Limit` is `article_8_a` or `article_8_b`.

- `decide_night_work(Case, night_work_verdict(Status, Citations))`: Dispatches to the status query of `Limit`. `Status` is that query's `Result`. One solution. Cites as the underlying query.
- `night_work_status(Case, Status)`: `Status` only, from `decide_night_work/2`.
- `night_work_checklist(Case, Checklist)`: A label-neutral checklist built with `formalize_lib` `assess/6`, using `night_work_requirement(RequirementIdentifier, Profile, Status, Citation)`, with the identifier FIRST. The requirements are listed in the slice section. Every item carries `cite(...)`.
- `night_work_what_if(Case, Key, Value, Status)`: Replaces `Key` with `Value` in the profile (`formalize_lib profile_set/3`) and re-decides. The decider is passed as a closure.

### Fixtures (fixtures.clausal)

- `night_work_fixture(Name, Case, ExpectedStatus, ExpectedCitations)`: Named cases covering every row of THE OUTCOMES, each status, and the boundaries:
  - 480 versus 481 minutes;
  - 2880 versus 2881 minutes in a 7-day block;
  - a night minute at `E - 1` versus `E`;
  - a cut last block;
  - a window running past the period;
  - touching rows;
  - the behind test (`derogation_from_article_8` not named while `worker_category` is absent and could make it irrelevant).

## Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` — all key reads;
  - `profile_set/3` — what-if;
  - `assess/6`, `item/3`, `labels/3` — checklist;
  - `sum_list/2`, `int_min/3`, `int_max/3` — interval overlap arithmetic;
  - `memberd/2`, `not_member/2`.
- **`library(datetime)`:** native datetime for every calendar computation.
  - `days_between/3` is the primary route: an exact day count between dates.
  - `ordinal/2` is the alternative route, on date objects built with the module's current constructor; the date/3 versus date/4 constraint is handled in the kernel only.
  - `date_add/3`, `timedelta/3` — the day after `PERIOD_END`.
- **`kit/deadline_lib`:** `month_last_day/3` — real-calendar-day validation; `date_on_or_before/2` — `PERIOD_END` not before `PERIOD_START`.
- **`kit/query_combinators`:** `what_if/5` if its profile shape is an attribute list; otherwise `profile_set/3` directly.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3` — for the test modes.
- **No `_common` family-backbone predicate fits.** The deontic `kit/compliance_lib` modality lattice is not used: Art 8 here is a state duty checked as a measured limit, not a norm-firing over actions.

## Files and layout (unchanged)

The build order is fixed:

> kernel → citations → parameters → night_work → queries → fixtures → package facade

The roles of the files are:

- **`citations.clausal`:** `citation_vocabulary/1` facts, one per key above.
- **`parameters.clausal`:** declares only the contract metadata:
  - `input_contract_key/3` (Position, Key, Kind) in `root_exports` order;
  - `judgement_referral_citation/2`.

  It holds NO statutory figure (those live in the slice).
- **`queries.clausal`:** re-exports the three contract queries and the two calculation helpers.
- **`package facade`:** the four facade predicates.

### kernel.clausal (shared floor: only what a slice and the queries/facade both need)

- `night_work_minute_stamp(DateOrDateTime, Stamp)`: An integer of minutes from a fixed day. It is built on `library(datetime)` (`days_between/3` from a fixed anchor date, times 1440, plus `H * 60 + MIN`). No date outside the inputs is ever formed beyond the anchor.
- `night_work_real_day(Year, Month, Day)` and `night_work_real_minute(Hour, Minute)`: ground-integer range checks. `month_last_day/3` handles leap years.
- `night_work_contract_key_order(Keys)`: The nine keys in order, read from parameters.

## Slice: night_work.clausal (the single determination slice)

This slice is self-contained: its value facts, arithmetic, completions, outcome rows, input check, tests, checklist and verdict all live here. It imports only the kernel, citations and parameters.

### Statutory VALUE facts it owns (`:- constant_value(Name, Value).`, read with `constant(Name)`)

| Constant | Value | Meaning | Source |
|---|---|---|---|
| `night_work_limit_minutes` | 480 | Eight hours | Art 8(a) and 8(b) |
| `minutes_per_day` | 1440 | — | Art 8, 'any 24-hour period' |
| `days_per_week` | 7 | Weekly-rest divisor step | Art 16, last sentence; Art 5 |
| `minimum_night_time_minutes` | 420 | Seven hours | Art 2(3) |
| `mandatory_night_end_minute` | 300 | 05:00 | Art 2(3) |
| `earliest_nonzero_night_start_minute` | 301 | — | Contract range |
| `latest_clock_minute` | 1439 | — | — |
| `night_time_representative_count` | 121 | The seven-hour night times when both keys are absent | Reading (8) |
| `largest_night_time_start_minute` | 301 | Largest night time when both keys are absent | — |
| `largest_night_time_end_minute` | 300 | Largest night time when both keys are absent | — |

### Rules and requirements

**Input check**

1. **`night_work_input_problems/2`.** Walks the list structurally to check its SHAPE: it must be a proper attribute list, with duplicates detected and non-atom keys reported as `unknown_key(Key)` as given. Values are read per key; the check reports `wrong_type` for an unbound or out-of-type value, applies the ranges and the night-time rule, and never raises.
2. **Argument problems.** After the profile problems come:
   - `wrong_type(worker)`;
   - `wrong_type(shifts)`, for an improper list, a bad element, START not before END, a bad kind, or two overlapping rows of `Worker`;
   - `wrong_type(period_start)`;
   - `wrong_type(period_end)`, for a bad date or an end before the start; checked only as a date when `PeriodStart` is wrong.

**Working time and night minutes**

3. **Counted kinds per completion.** `work` is always counted; leave is never counted; each on-call kind is counted per its key or choice.
4. **Rows and runs.** `Worker`'s rows (compared as terms) are filtered to counted kinds, converted to half-open stamp intervals, and merged into maximal RUNS of touching intervals.
5. **Art 8(a) average.** For a reference period R:
   - blocks run `[PeriodStartStamp + N * R * 1440, ...)`, cut at `EndOfPeriodStamp`;
   - `BlockWork` is the overlap sum of runs within the block;
   - the block is KEPT when `BlockWork =< night_work_block_limit_minutes(BlockDays)`;
   - the average is KEPT when every block is kept.
6. **Art 8(b) windows.** Starts of work are the run starts inside `[StartOfPeriod, EndOfPeriod)`, plus `StartOfPeriod` if a run covers it. Each window is `[T, T + 1440)`, and `WindowWork` is the overlap sum of the runs.
7. **Night minute test.** A night minute exists in an overlap `[A, B)` when either holds:
   - `B - A >= 1440`;
   - the clock range `A mod 1440` to `(B - 1) mod 1440`, wrapping, intersects night time `(S, E)`.
8. **Long night work.** Exists when some window has `WindowWork > 480` and holds a night minute.

**Completions and the limbs**

9. **Choice domains per query.**
   - unresolved on-call kinds: counted or not counted;
   - absent or unsure judgement keys: `true` or `false`;
   - absent `worker_category`: its 3 atoms;
   - absent `derogation_from_article_8`: its 4 atoms;
   - for Art 8(a), absent R: 1..DAYS;
   - for Art 8(b), the representative night times when a night-time key is absent.

   The limit test is evaluated once per (on-call, R or night time) combination. The categorical keys are then folded through the outcome rows, which keeps evaluation cheap.
10. **VALUE per completion.** The first row of THE OUTCOMES that applies, one clause per row with the result and citations in the head.
11. **Limbs.** Step 0 gives input problems. Step 1 is SETTLED: every completion gives one VALUE. Step 2 is `indeterminate([Key])`. Step 3 is `needs_legal_review`.
    - **MATTERS:** two completions differing only in that choice give different values.
    - **BEHIND:** some value of O makes K no longer matter.
    - **Naming:** keys STRICTLY BEHIND another are dropped, and the first remaining key in root order is named. If none remains, the first key that matters is named.
    - **The night-time choice** is named `night_time_start` when that key is absent, else `night_time_end`.
    - **Unsure key to refer:** the first judgement key present as unsure whose choice matters.
    - **Pairs:** per THE PAIRS RULE.
12. **Single solution.** Enumeration uses `findall/3` to a list. The decision then comes from mutually exclusive clauses, so the query yields exactly one solution.

### Checklist requirements (`night_work_requirement/4`, identifier FIRST; three exclusive clauses each)

| Requirement | Citation |
|---|---|
| `profile_well_formed` | — |
| `average_limit_kept` | `cite(eu_dir_2003_88_art_8_a)` |
| `hazardous_limit_kept` | `cite(eu_dir_2003_88_art_8_b)` |
| `worker_category_within_article_8` | `cite(eu_dir_2003_88_art_20_1)`, or `cite(eu_dir_2003_88_art_21_1)` when unmet as a fishing worker |
| `worker_is_night_worker` | `cite(eu_dir_2003_88_art_2_4)` |
| `special_hazards_or_heavy_strain_stated` | `cite(eu_dir_2003_88_art_8_final_subpara)` |
| `no_derogation_from_article_8` | `cite(eu_dir_2003_88_art_17_1)` / `art_17_3` / `art_18_first_subpara` |

- **Unknown status:** `unknown([Key])` for an absent key. Defaults are never invented.
- **Unknown on-call kind:** `average_limit_kept` and `hazardous_limit_kept` are unknown when an on-call key is absent and changes the answer.

### Verdict atoms of this slice

All the final results listed above, plus the three not-final compounds.

### Predicates SHARED with another slice (belong in kernel.clausal)

Only the following are shared, with the queries and facade layers:

- `night_work_minute_stamp/2`
- `night_work_real_day/3`
- `night_work_real_minute/2`
- `night_work_contract_key_order/1`

Everything else stays in this slice.

### Tests planned in this slice (seven test modes)

1. **Unit** — the divisor, stamps and runs.
2. **Per-rule** — each outcome row, positive paired with negative.
3. **Boundary** — 480 and 481; `E - 1` and `E`; a 7-day block at 2880 and 2881.
4. **Missing-key** — the behind test and <<DNUM>> naming.
5. **Referral** — needs_legal_review pairs order.
6. **Input-check** — duplicate, wrong_type, unknown_key ordering; unbound terms; never raises.
7. **Property** — totality, determinism (exactly one solution) and citation completeness via `validate_props`.
