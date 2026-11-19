# SIGNATURE — ind/dpdp_appeal_information

The package layout is unchanged:

`kernel -> citations -> parameters -> dpdp_appeal_information -> queries -> fixtures -> package facade`

There are seven test modes and a v2 manifest. The predicate prefix is `dpdp_appeal_information_`.

## 1. Public query surface

**The five queries.** Each takes PROFILE and returns RESULT and CITATIONS, as the order's INTERFACE states:

- `appeal_period/3`
- `appeal_filing_requirements/3`
- `appeal_disposal_target/3`
- `information_call_status/3`
- `non_disclosure_status/3`

**The input check.** `dpdp_appeal_information_input_problems/2`.

**The facade.** It wraps `appeal_period/3` for query types #2 (eligibility) and #7 (justification).

**Totality and determinism.** Every public predicate yields EXACTLY ONE solution for every ground or non-ground term. This holds because:

- ladder steps are mutually exclusive clauses with guards on the keys present;
- there is no cut, no `->` and no `*->`;
- ground results are folded into heads (C17).

The input check never fails or raises. No figure is imported from another domain. Every statutory value is declared once in the slice that owns it.

### Facade verdict STATUS atoms (replacing `required / permitted / not_applicable`)

| STATUS | When |
|---|---|
| `eligible` | `appeal_period` gives `in_time(_)` |
| `ineligible` | `appeal_period` gives `not_appealable` or `not_in_force` |
| `indeterminate` | `appeal_period` gives `out_of_time_sufficient_cause_needed(_)` (the Tribunal's judgement is handed over), `indeterminate(_)`, `needs_legal_review(_, _)` or `input_problems(_)` |

The verdict term is `dpdp_appeal_information_verdict(STATUS, CITATIONS)`. CITATIONS are those of `appeal_period`, so they are `[]` when non-final.

### Query RESULT atoms and constructors (the called contract, unchanged)

- **`appeal_period`:**
  - `in_time(date(Y,M,D))`
  - `out_of_time_sufficient_cause_needed(date(Y,M,D))`
  - `not_appealable`
  - `not_in_force`
- **`appeal_filing_requirements`:**
  - `filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system])`
  - `not_yet_prescribed`
  - `not_in_force`
- **`appeal_disposal_target`:**
  - `disposed_within_target(D)`
  - `disposal_target_not_yet_passed(D)`
  - `reasons_in_writing_required(D)`
  - `not_in_force`
- **`information_call_status`:**
  - `required_to_furnish_within_specified_period`
  - `required_to_furnish_under_section_36`
  - `not_covered`
  - `not_in_force`
- **`non_disclosure_status`:**
  - `disclosure_barred_without_written_permission`
  - `disclosure_permitted_by_written_permission`
  - `not_barred_by_rule_23`
  - `not_in_force`
- **Statuses:**
  - `indeterminate([KEY])` — never the bare atom.
  - `needs_legal_review(open_textured(KEY, cite(K)), [inputs_relied_on(PAIRS)])`
  - `needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on(PAIRS)])`
  - `input_problems(PROBLEMS)`, where each problem is `duplicate_key(K)`, `wrong_type(K)`, `unknown_key(K)` or `wrong_type(profile)`.
- **PAIRS** are `KEY-VALUE` terms in root order, drawn only from the firing row's inputs:
  - for `appeal_period`: `appeal_against_board_order_or_direction` and `appellant_aggrieved`;
  - for `information_call_status`: `call_for_seventh_schedule_purpose` and `called_through_authorised_person`.

## 2. Profile keys

The profile has fourteen keys, in root_exports / input_contract order. Values are bare atoms or `date(Year, Month, Day)` terms of bare integers, with Year from 1 to 9999. There is no money and no numeric measure, so no unit suffix is needed.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `section_29_in_force_on_filing_date` | crisp | `true` / `false` |
| 2 | `appeal_against_board_order_or_direction` | judgement | `true` / `false` / `unsure` |
| 3 | `appellant_aggrieved` | judgement | `true` / `false` / `unsure` |
| 4 | `order_receipt_date` | date | `date(Year, Month, Day)` |
| 5 | `appeal_filing_date` | date | `date(Year, Month, Day)` |
| 6 | `appeal_disposed_of_within_six_months` | crisp | `true` / `false` |
| 7 | `reference_date` | date | `date(Year, Month, Day)` |
| 8 | `section_36_in_force_on_call_date` | crisp | `true` / `false` |
| 9 | `call_date` | date | `date(Year, Month, Day)` |
| 10 | `recipient_kind` | enumeration | `data_fiduciary_or_intermediary` / `board` / `other_recipient` |
| 11 | `call_for_seventh_schedule_purpose` | judgement | `true` / `false` / `unsure` |
| 12 | `called_through_authorised_person` | judgement | `true` / `false` / `unsure` |
| 13 | `non_disclosure_required` | crisp | `true` / `false` |
| 14 | `written_permission_to_disclose` | crisp | `true` / `false` |

Keys are read ONLY with `formalize_lib:profile_get/3`, checking presence first and then value. There is no `attested(...)` wrapper and there are no outside facts.

## 3. Citation-key atoms (`citation_vocabulary`, canonical lexicon scheme)

These are the load-bearing units cited by limbs:

- `in_dpdp_act_2023_s_29_1` — s 29(1), who may appeal and against what
- `in_dpdp_act_2023_s_29_2` — s 29(2), sixty days; form, manner and fee as prescribed
- `in_dpdp_act_2023_s_29_3` — s 29(3), late appeal for sufficient cause
- `in_dpdp_act_2023_s_29_6` — s 29(6), six-month endeavour
- `in_dpdp_act_2023_s_29_7` — s 29(7), reasons in writing
- `in_dpdp_act_2023_s_36` — s 36, the call for information
- `in_dpdp_rules_2025_r_1_4` — r 1(4), commencement of rr 22 and 23
- `in_dpdp_rules_2025_r_22_1` — r 22(1), digital form
- `in_dpdp_rules_2025_r_22_2` — r 22(2), the fee and its payment
- `in_dpdp_rules_2025_r_23_1` — r 23(1), a call through the authorised person for a Schedule purpose
- `in_dpdp_rules_2025_r_23_2` — r 23(2), non-disclosure
- `in_dpdp_rules_2025_sch_7_1` — Seventh Schedule row 1
- `in_dpdp_rules_2025_sch_7_2` — Seventh Schedule row 2
- `in_dpdp_rules_2025_sch_7_2_i` — Seventh Schedule row 2(i)
- `in_dpdp_rules_2025_sch_7_2_ii` — Seventh Schedule row 2(ii)
- `in_dpdp_rules_2025_sch_7_3` — Seventh Schedule row 3

The context-only units (s 2 definitions, s 28 examples, s 29 number, r 22 and r 23 headings, r 23(3), Sch 7 heading) are recorded in `citations.clausal` as unit ids with provenance. They are NOT citation atoms, and no shortened atom is ever invented.

## 4. Public predicates

- `appeal_period(Profile, Result, Citations)`: steps 0–12 of APPEAL_PERIOD. LAST_DAY is the receipt date plus 60 days. Cites `in_dpdp_act_2023_s_29_1`, `in_dpdp_act_2023_s_29_2` and `in_dpdp_act_2023_s_29_3` as each step states.
- `appeal_filing_requirements(Profile, Result, Citations)`: steps 0–5. Rule 22 applies from `date(2027,5,13)`. Cites `in_dpdp_act_2023_s_29_2`, `in_dpdp_rules_2025_r_22_1`, `in_dpdp_rules_2025_r_22_2` and `in_dpdp_rules_2025_r_1_4`.
- `appeal_disposal_target(Profile, Result, Citations)`: steps 0–8. TARGET_DAY is the same day six months later, clamped to month end. Cites `in_dpdp_act_2023_s_29_6` and `in_dpdp_act_2023_s_29_7`.
- `information_call_status(Profile, Result, Citations)`: steps 0–14. Cites `in_dpdp_act_2023_s_36`, `in_dpdp_rules_2025_r_23_1`, `in_dpdp_rules_2025_r_1_4` and every `in_dpdp_rules_2025_sch_7_*`.
- `non_disclosure_status(Profile, Result, Citations)`: steps 0–11. Cites `in_dpdp_rules_2025_r_23_2`, `in_dpdp_act_2023_s_36` and `in_dpdp_rules_2025_r_1_4`.
- `dpdp_appeal_information_input_problems(Profile, Problems)`: the typed input check, in this order: `duplicate_key` or `wrong_type` per contract key in contract order, then `unknown_key` by first occurrence. A non-attribute-list gives `[wrong_type(profile)]`. It yields exactly one solution and is uncited (structural).
- `decide_dpdp_appeal_information(Profile, Verdict)`: Verdict is `dpdp_appeal_information_verdict(Status, Citations)`, mapped from `appeal_period/3` (query type #2). Cites s 29(1)–(3) via `appeal_period`.
- `dpdp_appeal_information_status(Profile, Status)`: projects Status (`eligible`, `ineligible` or `indeterminate`) from `decide_dpdp_appeal_information/2`. Cites s 29(1)–(3).
- `dpdp_appeal_information_checklist(Profile, Checklist)`: query type #7. It returns `[item(RequirementId, ItemStatus, cite(Key)), ...]` from `formalize_lib:eval_requirements/4` over the injected closure `dpdp_appeal_information_requirement`. Requirement ids and their citations:
  - `section_29_in_force` → `cite(in_dpdp_act_2023_s_29_1)`
  - `against_board_order_or_direction` → `cite(in_dpdp_act_2023_s_29_1)`
  - `appellant_aggrieved` → `cite(in_dpdp_act_2023_s_29_1)`
  - `filed_within_sixty_days` → `cite(in_dpdp_act_2023_s_29_2)`
- `dpdp_appeal_information_requirement(RequirementId, Profile, ItemStatus, Citation)`: the requirement/4 closure, with the requirement id FIRST. Each requirement has three exclusive clauses:
  - **met**: `met`.
  - **unmet**: `unmet(Reason)`. For the period item the reason is `out_of_time_sufficient_cause_needed(LAST_DAY)`.
  - **unknown**: `unknown([Key])`. A judgement given `unsure` also gives `unknown([Key])`, handed to the user.
- `dpdp_appeal_information_what_if(Profile, Key, Value, Status)`: counterfactual status. It calls `query_combinators:what_if/5` with the closure `dpdp_appeal_information_status`. The citation is that of the status.
- `dpdp_appeal_information_fixture(Name, Profile)`: named fixture profiles (fixtures module). One per ladder step of every query, plus the worked date examples and boundary days.

The Status verdict is computed from `appeal_period`, NOT from `decide_labeled/3`. A consistency test asserts that the checklist and status agree:

- every item `met` iff `eligible`;
- an unmet item other than the period item iff `ineligible`.

## 5. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_has/2` and `profile_lacks/2` — every key read.
  - `eval_requirements/4`, `item/3`, `unmet/1` and `unknown/1` — the checklist.
  - `check_tri/4` — the judgement items.
  - `memberd/2` and `not_member/2` — the input check.
  - `int_min/3` — day clamping.
- **`kit/deadline_lib`:**
  - `date_before/2`, `date_after/2`, `date_on_or_before/2` and `date_on_or_after/2` — every calendar-day comparison.
  - `month_last_day/3` — leap years in the input check and TARGET_DAY clamping. It must give 29 for `month_last_day(10000, 2, _)`; a test checks this.
  - NOT `deadline_months_after/3`, because it has the wrong semantics (see NOTES S3).
- **`library(datetime)`:**
  - `date_add/3` and `timedelta/3`, used only in the cross-check tests that LAST_DAY equals the receipt date plus `timedelta(60, 0, _)` for years within 1–9998.
  - The production path uses local day-number arithmetic, because returned dates may reach year 10000 (kit gap noted).
- **`kit/query_combinators`:** `what_if/5` — the facade what-if.
- **`validate_props`:**
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3` and `prop_citation_complete/3` — tests.
  - `prop_boundary_coverage/2` — LAST_DAY, TARGET_DAY and `date(2027,5,13)` boundaries.
  - `prop_missing_key_coverage/3` — every named key.
- **Not used:** `currency_vocab`, `vat_category` and `country`; `compliance_lib` and `rolling_window`. There is no money and no rolling window.

## 6. kernel.clausal — the shared floor

The kernel holds ONLY predicates that the slice, queries and facade all share:

- `dpdp_appeal_information_contract_key(Key, Kind)` — fourteen facts in contract order. Kind is `judgement`, `crisp`, `date` or `recipient_enumeration`.
- `dpdp_appeal_information_input_problems/2` — the input check, with private helpers:
  - `attribute_list_shape/1` — rejects variables, partial lists and non-`attribute/2` elements;
  - `value_of_kind/2`;
  - `real_calendar_day/1` — ground integers, year 1–9999, month 1–12, day 1 to `month_last_day`;
  - duplicate and unknown-key collectors. A non-atom key is an unknown key.
- `dpdp_appeal_information_pairs(Profile, InputKeys, Pairs)` — `KEY-VALUE` for the present keys of a referral row, in root order.
- `dpdp_appeal_information_date_add_days(Date, Days, Result)` — proleptic Gregorian day-number arithmetic (days-from-civil and civil-from-days). It is total for results up to year 10000.
- `dpdp_appeal_information_same_day_months_after(Date, Months, Result)` — month carry, clamped with `month_last_day/3` and `int_min/3`.

The kernel holds NO statutory value facts.

## 7. Slice — dpdp_appeal_information.clausal

This single slice owns every determination of the order.

### Value facts owned (live here, not in a shared constants file)

- `:- constant_value(appeal_period_days, 60).` — s 29(2).
- `:- constant_value(disposal_target_months, 6).` — s 29(6).
- `rules_22_and_23_commencement_date(date(2027, 5, 13)).` — r 1(4), CALCULATED as 13 Nov 2025 plus 18 months (Q3).
- `filing_requirement_items([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]).` — r 22(1) and (2), in a fixed, scored order.
- `furnish_within_specified_period_citations([...])` — the eight citations of information step 14.
- `non_disclosure_not_in_force_citations([cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)])`.
- `not_governed_here_citations([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)])` — order scored.
- Referral rows: `referral_row(Query, Key, Citation, InputKeys)`.
  - `appeal_period`: B or A with `in_dpdp_act_2023_s_29_1` and inputs `[appeal_against_board_order_or_direction, appellant_aggrieved]`.
  - `information_call_status`: SP or AP with `in_dpdp_rules_2025_r_23_1` and inputs `[call_for_seventh_schedule_purpose, called_through_authorised_person]`.

### Derived arithmetic

- `appeal_last_day(ReceiptDate, LastDay)` is `date_add_days(ReceiptDate, constant(appeal_period_days), LastDay)`.
  - Tests: `date(2027,1,10)` gives `date(2027,3,11)`; `date(2027,12,1)` gives `date(2028,1,30)`; `date(9999,12,31)` gives `date(10000,2,29)`.
- `disposal_target_day(FilingDate, TargetDay)` is `same_day_months_after(FilingDate, constant(disposal_target_months), TargetDay)`.
  - Tests: `date(2027,3,11)` gives `date(2027,9,11)`; `date(2027,8,31)` gives `date(2028,2,29)`; `date(2028,8,31)` gives `date(2029,2,28)`.

### Rules (ladders, one guarded clause per step, steps mutually exclusive)

- **Step 0 (every query):** non-empty PROBLEMS gives `input_problems(PROBLEMS)` with CITATIONS `[]`. Later steps require PROBLEMS = `[]`.
- **APPEAL_PERIOD (1)–(12):**
  1. S29 false gives `not_in_force` with [s_29_1].
  2. S29 absent gives `indeterminate([section_29_in_force_on_filing_date])`.
  3. B false gives `not_appealable` with [s_29_1].
  4. A false (B not false) gives `not_appealable` with [s_29_1].
  5. B absent gives `indeterminate([appeal_against_board_order_or_direction])`.
  6. A absent gives `indeterminate([appellant_aggrieved])`.
  7. RD absent gives `indeterminate([order_receipt_date])`.
  8. FD absent gives `indeterminate([appeal_filing_date])`.
  9. B unsure gives `open_textured` on B.
  10. A unsure gives `open_textured` on A.
  11. FD on or before LAST_DAY gives `in_time(LAST_DAY)` with [s_29_1, s_29_2].
  12. Otherwise `out_of_time_sufficient_cause_needed(LAST_DAY)` with [s_29_2, s_29_3].
- **APPEAL_FILING_REQUIREMENTS (1)–(5):**
  1. S29 false gives `not_in_force` with [s_29_2].
  2. S29 absent gives `indeterminate`.
  3. FD absent gives `indeterminate`.
  4. FD before `date(2027,5,13)` gives `not_yet_prescribed` with [s_29_2, r_1_4].
  5. Otherwise `filing_requirements(ITEMS)` with [s_29_2, r_22_1, r_22_2, r_1_4].
- **APPEAL_DISPOSAL_TARGET (1)–(8):**
  1. S29 false gives `not_in_force` with [s_29_6].
  2. S29 absent gives `indeterminate`.
  3. FD absent gives `indeterminate`.
  4. DS true gives `disposed_within_target(T)` with [s_29_6].
  5. DS absent gives `indeterminate`.
  6. RF absent gives `indeterminate`.
  7. RF on or before T gives `disposal_target_not_yet_passed(T)` with [s_29_6].
  8. Otherwise `reasons_in_writing_required(T)` with [s_29_6, s_29_7].
- **INFORMATION_CALL_STATUS (1)–(14):**
  1. S36 false gives `not_in_force` with [s_36].
  2. S36 absent gives `indeterminate`.
  3. RK `other_recipient` gives `not_covered` with [s_36, r_23_1].
  4. RK absent gives `indeterminate`.
  5. RK `board` gives `required_to_furnish_under_section_36` with [s_36].
  6. CD absent gives `indeterminate`.
  7. CD before `date(2027,5,13)` gives `required_to_furnish_under_section_36` with [s_36].
  8. SP false gives `not_governed_here`.
  9. AP false (SP not false) gives `not_governed_here`.
  10. SP absent gives `indeterminate`.
  11. AP absent gives `indeterminate`.
  12. SP unsure gives `open_textured` on SP with r_23_1.
  13. AP unsure gives `open_textured` on AP with r_23_1.
  14. Otherwise `required_to_furnish_within_specified_period` with the eight citations.
- **NON_DISCLOSURE_STATUS (1)–(11):**
  1. S36 false gives `not_in_force` with the three citations.
  2. CD before `date(2027,5,13)` (S36 not false) gives `not_in_force` with the three citations.
  3. S36 absent gives `indeterminate`.
  4. CD absent gives `indeterminate`.
  5. RK `board` or `other_recipient` gives `not_barred_by_rule_23` with [r_23_2].
  6. ND false (RK not board or other) gives `not_barred_by_rule_23` with [r_23_2].
  7. RK absent gives `indeterminate`.
  8. ND absent gives `indeterminate`.
  9. WP true gives `disclosure_permitted_by_written_permission` with [r_23_2].
  10. WP absent gives `indeterminate`.
  11. Otherwise `disclosure_barred_without_written_permission` with [r_23_2].
- **Exclusivity guards.** Each later clause restates the negations of the earlier steps it depends on, in positive form (for example `profile_get(P, K, true)` or a `memberd` over the remaining values, or `profile_lacks/2`). No two clauses can fire on one profile, which gives COUNTING: exactly one solution.
- **Never-read keys** are never touched, as each ladder's 'Why this order' states.

### Verdict atoms

The slice owns the RESULT atoms in section 1. The facade STATUS (`eligible`, `ineligible`, `indeterminate`) is mapped in the facade from `appeal_period`.

### Shared with another slice (therefore in kernel.clausal)

The input check, `dpdp_appeal_information_pairs/3`, the two date-arithmetic helpers and the contract key facts. Nothing else is shared.

### Tests owned (seven modes)

- **Unit tests:** per-step tests, with a positive test paired with every `fail` test.
- **Boundary tests:** LAST_DAY on and plus one day; TARGET_DAY on and plus one day; 12, 13 and 14 May 2027.
- **Date tests:** the worked date examples and year-10000 results.
- **Input-check tests:** duplicate, wrong type, unknown key, non-atom key, unbound key, unbound value, partial list, unbound profile.
- **Counting tests:** `findall` with `length(Rs, 1)` for each fixture.
- **Property tests:** totality and determinism via `validate_props`.
- **Citation tests:** completeness against `citation_vocabulary`.
