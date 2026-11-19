# SIGNATURE — uk/uk_subject_access_requests

Package `uk/uk_subject_access_requests`, predicate prefix `uk_subject_access_requests_`. Shape family: deontic.

Layout (kept): `kernel -> citations -> parameters -> uk_subject_access_requests -> queries -> fixtures -> package facade`. File names, module names and the package layout are unchanged.

The manifest is v2 and there are seven test modes. Every query yields EXACTLY ONE solution. There is no `!`, `->` or `*->`. Disjoint clauses are guarded by mutually exclusive tests. Ground verdict atoms are folded into clause heads (C17).

## 1. Verdict STATUS atoms (replace the placeholder `required/permitted/not_applicable`)

The facade verdict `uk_subject_access_requests_verdict(STATUS, CITATIONS)` uses STATUS equal to the RESULT of `uk_access_entitlement/3`. It is exactly one of:

- `item_due`
- `item_not_within_article_15_1`
- `item_beyond_reasonable_and_proportionate_search`
- a status compound: `indeterminate([KEY])`, `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])` or `input_problems(PROBLEMS)`

Other answer atoms of the contract:

| Answer | Atoms |
|---|---|
| PERIOD | `one_month`, `three_months` |
| clock stop RESULT | `clock_stop_applies`, `clock_stop_does_not_apply` |
| REGIME | `article_12a_time_rules`, `earlier_time_limits_saved` |
| RELEVANT | a date, or `not_yet_started` |
| UK_DEADLINE | a date, or `earlier_time_limits_saved` |
| DIFFERENCE | `uk_earlier`, `same`, `uk_later`, `not_comparable` |

All of these may also be a status compound where the contract allows it.

Result constructors (exported, never called as queries):

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

The bare atom `indeterminate` is NEVER written.

## 2. Profile keys (attribute list `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`; root_exports / input_contract order)

| # | Key | Type | Source |
|---|-----|------|--------|
| 1 | `item_described_in_article_15_1` | crisp `true`/`false` | Art 15(1) |
| 2 | `item_within_reasonable_and_proportionate_search` | judgement `true`/`false`/`unsure` | Art 15(1A) |
| 3 | `extension_notice_given` | crisp | Art 12A(3) |
| 4 | `extension_notice_given_before_end_of_first_month` | crisp | Art 12A(4)(a) |
| 5 | `extension_notice_states_reasons` | crisp | Art 12A(4)(b) |
| 6 | `extension_necessary_for_complexity_or_number` | judgement | Art 12A(3)(a),(b) |
| 7 | `request_made_under_article_15` | crisp | Art 12A(5) |
| 8 | `controller_asked_for_further_information` | crisp | Art 12A(5)(a) |
| 9 | `further_information_reasonably_required` | judgement | Art 12A(5) |

Which keys each query reads:

- `uk_access_entitlement/3` reads keys 1-2.
- `uk_applicable_time_period/3` reads keys 3-6.
- `uk_clock_stop/3` reads keys 7-9.
- An unread key never changes an answer.

There are no numeric profile keys and no money.

Date arguments (not profile keys) are ground `date(Year, Month, Day)` terms of bare integers. Year is from 1900 to 2199 (an ADDED check), and the date must be a real Gregorian day. The arguments are:

- `receipt_date`
- `relevant_time_date`
- `request_for_information_date`
- `information_received_date`
- `identity_information`: a date, `not_requested` or `requested_not_received`
- `fee`: a date, `no_fee` or `fee_not_paid`
- `response_period`: `one_month` or `three_months`
- `paused_days`: a non-negative integer

## 3. Citation-key atoms (canonical lexicon `_lexicon/citations.yaml`; never shortened or invented)

The segments `art`/`reg` are the canonical lexicon scheme, mandated by the contract.

| Citation key | Unit |
|---|---|
| `uk_gdpr_art_15_1` | article-15-1 |
| `uk_gdpr_art_15_1a` | article-15-1A |
| `uk_gdpr_art_12_3` | article-12-3 |
| `uk_gdpr_art_12_4` | article-12-4 |
| `uk_gdpr_art_12a_1` | article-12A.-1 |
| `uk_gdpr_art_12a_2` | article-12A.-2 |
| `uk_gdpr_art_12a_2_a` | article-12A.-2-a |
| `uk_gdpr_art_12a_2_b` | article-12A.-2-b |
| `uk_gdpr_art_12a_2_c` | article-12A.-2-c |
| `uk_gdpr_art_12a_3` | article-12A.-3 |
| `uk_gdpr_art_12a_3_a` | article-12A.-3-a |
| `uk_gdpr_art_12a_3_b` | article-12A.-3-b |
| `uk_gdpr_art_12a_4` | article-12A.-4 |
| `uk_gdpr_art_12a_4_a` | article-12A.-4-a |
| `uk_gdpr_art_12a_4_b` | article-12A.-4-b |
| `uk_gdpr_art_12a_5` | article-12A.-5 |
| `uk_gdpr_art_12a_5_a` | article-12A.-5-a |
| `uk_gdpr_art_12a_5_b` | article-12A.-5-b |
| `uk_gdpr_art_12a_5_b_i` | article-12A.-5-b-i |
| `uk_gdpr_art_12a_5_b_ii` | article-12A.-5-b-ii |
| `uk_si_2026_82_reg_2` | regulation-2 |
| `uk_si_2026_82_reg_2_h` | regulation-2-h |
| `uk_si_2026_82_reg_4` | regulation-4 |
| `uk_si_2026_82_reg_4_a` | regulation-4-a |
| `eu_reg_2016_679_art_12_3` | parag_012.003 |
| `eu_reg_1971_1182_art_3_1` | parag_003.001 |
| `eu_reg_1971_1182_art_3_2_c` | point_003.002_c |
| `eu_reg_1971_1182_art_3_4` | parag_003.004 |

`citations.clausal` declares each atom once, with its pin and unit id. CITATIONS is always a flat set-like list of `cite(KEY)`, and `[]` when the answer is not final.

## 4. Public predicates

Contract queries. These are status determination (#3), deadline (#15), calculation (#23) and comparison (#5):

- `uk_access_entitlement(Profile, Result, Citations)`: item due, not within Art 15(1), or beyond a reasonable and proportionate search. Cites `uk_gdpr_art_15_1` and `uk_gdpr_art_15_1a`. (#3)
- `uk_applicable_time_period(Profile, Period, Citations)`: `one_month` or `three_months`. Cites `uk_gdpr_art_12a_1`, `_3`, `_4`, and adds `_3_a`, `_3_b`, `_4_a`, `_4_b` for three months. (#3)
- `uk_clock_stop(Profile, Result, Citations)`: whether Art 12A(5) stops the clock. Cites `uk_gdpr_art_12a_5`, and adds `_5_a`, `_5_b`, `_5_b_i`, `_5_b_ii` when it applies. (#3)
- `uk_time_rules_regime(ReceiptDate, Regime, Citations)`: `article_12a_time_rules` or `earlier_time_limits_saved`. Cites `uk_si_2026_82_reg_2`, `_reg_2_h`, `uk_gdpr_art_12_3`, `_12_4`, `_12a_1`, or for saved requests `uk_si_2026_82_reg_4`, `_reg_4_a`. (#3)
- `uk_relevant_time(ReceiptDate, IdentityInformation, Fee, RelevantTime, Citations)`: the latest of the three days, or `not_yet_started`. Cites `uk_gdpr_art_12a_2`, `_2_a`, `_2_b`, `_2_c`. (#15)
- `uk_paused_days(RequestForInformationDate, InformationReceivedDate, Days, Citations)`: inclusive day count (the later date minus the earlier, plus 1). Cites `uk_gdpr_art_12a_5_b`. (#23)
- `uk_response_deadline(RelevantTime, ResponsePeriod, PausedDays, Deadline, Citations)`: the last day of the applicable time period. Cites `uk_gdpr_art_12_3`, `_12_4`, `_12a_1`, adds `_12a_3` for three months and `_12a_5_b` when paused days are more than 0. (#15, #23)
- `compare_uk_eu_response_deadline(ReceiptDate, ResponsePeriod, UkDeadline, EuDeadline, Difference, Citations)`: UK last day against the EU last day for a plain request. Cites `uk_gdpr_art_12a_1` (adds `_12a_3` for three months), `eu_reg_2016_679_art_12_3`, `eu_reg_1971_1182_art_3_1`, `_3_2_c`, `_3_4`. For a saved request it cites `uk_si_2026_82_reg_4` and `_reg_4_a`, merged with the EU citations. (#5)
- `uk_subject_access_requests_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is a bare flat list.
  - Contract keys are checked in key order: `duplicate_key(KEY)`, else `wrong_type(KEY)`.
  - Then `unknown_key(KEY)` in order of first occurrence.
  - A profile that is not an attribute list gives `[wrong_type(profile)]`.
  - The check never fails or raises and gives one solution for every term.

Scaffold facade names (kept). These are justification (#7) and status:

- `decide_uk_subject_access_requests(Profile, uk_subject_access_requests_verdict(Status, Citations))`: Status and Citations are exactly those of `uk_access_entitlement/3`.
- `uk_subject_access_requests_status(Profile, Status)`: the Status of the verdict alone.
- `uk_subject_access_requests_checklist(Profile, Checklist)`: one checklist row per Art 15 condition, via `eval_requirements/4` over `requirement/4`. Each row is `item(RequirementId, Status, cite(KEY))` and carries `cite(...)` (#7). The rows are:
  - `item(item_described_in_article_15_1, Status, cite(uk_gdpr_art_15_1))`
  - `item(item_within_reasonable_and_proportionate_search, Status, cite(uk_gdpr_art_15_1a))`
  - Status is `met`, `unmet(Reason)` or `unknown([KEY])`. `unsure` maps to `unknown([KEY])`.
  - With input problems the checklist is `[]`.
- `uk_subject_access_requests_what_if(Profile, Key, Value, Verdict)`: overrides Key with `profile_set/3`, then re-runs `decide_uk_subject_access_requests/2`.
- Fixtures: `uk_subject_access_requests_fixture(Name, Profile)` and `uk_subject_access_requests_date_fixture(Name, Goal)` in `fixtures.clausal`. They cover every limb, every status, the worked examples of readings (6), (7) and (10), leap-year cases, and argument-problem cases.

## 5. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3` (the only profile reader)
  - `profile_set/3` (what-if)
  - `eval_requirements/4` and `item/3` (checklist)
  - `memberd/2`
  - `sum_list/2`
  - `attribute/2`
  - `unmet/1`, `unknown/1`
  - vocabulary atom `met`
  - `check_tri/4` is NOT used, because tri-state `unsure` must route to `needs_legal_review`, not to a Kleene unknown. That routing is explicit per-key clauses.
- `kit/deadline_lib`: `month_last_day/3` (Gregorian last day of a month, integers in and out).
  - `deadline_months_after/3` is NOT used. It counts from the day after the anchor to the month-end, which is neither reading.
- `validate_props` (tests):
  - `run_props/1`
  - `prop_totality/3`
  - `prop_determinism/3`
  - `prop_citation_complete/3`
  - `prop_boundary_coverage/2` (2026-02-04 / 2026-02-05; month-end and leap-year days)
  - `prop_missing_key_coverage/3`
- Local, domain-specific, and noted in NOTES.md as recurring-module candidates:
  - integer day-number arithmetic on `date(Y,M,D)` compounds, because native `date/3` is not registered and dates are compared by day number, not `@<`
  - the weekday from the day number
  - the UK 'one month beginning with' end-day rule
  - the 1182/71 end-day rule with its weekend shift
- No `_common` family-backbone predicate is needed beyond `formalize_lib`.

## 6. Determination slices

### kernel.clausal (shared floor)

There is only one determination slice, so NO domain predicate is shared between slices.

The kernel keeps only the scaffold floor:

- module declaration
- re-export of the result constructors listed in section 1

It holds no value facts and no rules.

### citations.clausal / parameters.clausal

`citations.clausal` holds the citation facts of section 3.

`parameters.clausal` stays the scaffold floor (pin metadata: pin ids and the fetch date 2026-11-15). The statutory VALUE facts live in the slice, not here.

### Slice: uk_subject_access_requests.clausal

**Value facts it owns** (`:- constant_value(Name, Value).`, read with `constant(Name)`):

| Constant | Value | Source |
|---|---|---|
| `article_12a_time_rules_commencement_year` | 2026 | reg 2(h), reg 4(a) |
| `article_12a_time_rules_commencement_month` | 2 | reg 2(h), reg 4(a) |
| `article_12a_time_rules_commencement_day` | 5 | reg 2(h), reg 4(a) |
| `base_period_months` | 1 | Art 12A(1); EU Art 12(3) |
| `extended_period_months` | 3 | Art 12A(3), one plus two further months |
| `input_year_minimum` | 1900 | ADDED check |
| `input_year_maximum` | 2199 | ADDED check |
| `saturday_shift_days` | 2 | 1182/71 Art 3(4), holidays excluded |
| `sunday_shift_days` | 1 | 1182/71 Art 3(4), holidays excluded |

Table fact `period_months(one_month, 1)` and `period_months(three_months, 3)` map the period atoms to these month counts.

**Rules / requirements:**

1. **Input check.** `uk_subject_access_requests_input_problems/2` and the contract-key table `profile_key_type(Key, crisp|judgement)` in input_contract order.
   - The profile shape is tested without unifying unbound elements.
   - Duplicates are counted per contract key.
   - Value type is checked with `memberd/2` against `[true,false]` or `[true,false,unsure]`. An unbound value is `wrong_type`.
   - Unknown keys are collected in first-occurrence order and deduplicated.
2. **Access entitlement.** Limbs (0)-(6) of THE LIMBS, one clause per disjoint route:
   - key 1 `false` gives `item_not_within_article_15_1`
   - key 1 absent gives `indeterminate([item_described_in_article_15_1])`
   - key 2 `false` gives `item_beyond_reasonable_and_proportionate_search`
   - key 2 absent gives `indeterminate([...])`
   - key 2 `unsure` gives `needs_legal_review(open_textured(item_within_reasonable_and_proportionate_search, cite(uk_gdpr_art_15_1a)), [inputs_relied_on([item_described_in_article_15_1-true, item_within_reasonable_and_proportionate_search-unsure])])`
   - both `true` give `item_due`
3. **Applicable time period.** Limbs (1)-(5):
   - Notice `false`, or any of keys 4-6 `false`, gives `one_month` with a single clause. It is guarded so that it yields once even when several keys are false: compute the boolean `some_condition_false` once.
   - Then the first absent key, then an `unsure` necessity, then `three_months`.
4. **Clock stop.** Limbs (1)-(4):
   - Any of keys 7-9 `false` gives `clock_stop_does_not_apply`, yielding once.
   - Then the first absent key, then `unsure` gives a referral with `cite(uk_gdpr_art_12a_5)`.
   - All `true` give `clock_stop_applies`.
5. **Date validity.** `valid_input_date/1` checks:
   - the term is ground and of shape `date(Y,M,D)`
   - the components are integers
   - Y is in range and M is from 1 to 12
   - D is from 1 to `month_last_day`
6. **Day number.** `date_day_number/2` and `day_number_date/2` convert by exact integer civil-calendar arithmetic. Also `date_add_days/3`, `date_weekday/2` (with 1970-01-01, a Thursday, as reference), and `date_compare/3` giving `before`, `same` or `after`.
7. **Time rules regime.** Compares the receipt day number with the commencement day number.
8. **Relevant time.** Argument problems are listed in argument order.
   - Any outstanding item (identity `requested_not_received` or fee `fee_not_paid`) gives `not_yet_started`, yielding once.
   - Otherwise the result is the maximum day number of the date-valued arguments.
9. **Paused days.** Argument problems, including received earlier than requested, which gives `wrong_type(information_received_date)`. Otherwise the result is the received day number minus the requested day number, plus 1.
10. **UK end day.** `uk_period_end(Relevant, Months, End)`:
    - Find the target month (month plus Months, with year carry).
    - If the target month has day D, the end is the day before `date(TY, TM, D)`.
    - Otherwise the end is the last day of the target month.
    - The deadline is End plus PausedDays.
11. **EU end day.** `eu_period_end(Receipt, Months, End)`:
    - Find the target month.
    - The end is `date(TY,TM,min(D,last))`.
    - A Saturday adds 2 days and a Sunday adds 1 day.
12. **Comparison.** Argument problems give both deadlines `input_problems`, `not_comparable` and `[]`.
    - A saved receipt gives `earlier_time_limits_saved` with the EU date computed.
    - Otherwise the result is `uk_earlier`, `same` or `uk_later` by day number.
13. **Checklist.** `requirement/4` rows for keys 1 and 2, with the RequirementId first, for `eval_requirements/4`.

**Verdict atoms:** as in section 1. The facade verdict mirrors `uk_access_entitlement/3`.

**Shares with another slice:** nothing. The day-number helpers stay local to the slice and are not exported to the kernel.

**Totality / determinism claims:**

- Every public predicate is total over all terms (malformed input routes to `input_problems`) and yields exactly one solution.
- Tested by `prop_totality` and `prop_determinism`, and by `findall` + `length(L, 1)` per fixture.
- Every negative test is paired with a positive test over the same case.
