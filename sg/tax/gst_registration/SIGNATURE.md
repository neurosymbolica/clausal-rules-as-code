# SIGNATURE — sg/tax/gst_registration

## Public query surface

The package exposes four public predicates (the scaffold facade names) plus two determination predicates:

- `decide_gst_registration(PROFILE, RESULT)` — dispatches to the appropriate determination (retrospective or prospective) based on which keys are present in PROFILE; RESULT is the corresponding record term.
- `gst_registration_status(PROFILE, STATUS)` — query type #2 (eligibility): returns `eligible`, `ineligible`, or `indeterminate` with a cited checklist.
- `gst_registration_checklist(PROFILE, CHECKLIST)` — the full cited checklist for the applicable determination.
- `fixtures` — test fixture generator.

Determination predicates (internal, called by the facade):
- `gst_retrospective_liability(PROFILE, RESULT)` — RESULT = gst_retrospective(DECISION, VALUE_CENTS, NOTIFY_BY, REGISTERED_FROM, CITATIONS)
- `gst_prospective_liability(PROFILE, RESULT)` — RESULT = gst_prospective(DECISION, VALUE_CENTS, NOTIFY_BY, REGISTERED_FROM, CITATIONS)

## Verdict status atoms

Retrospective DECISION (first match wins):
- `already_registered`
- `not_liable`
- `not_liable_comptroller_satisfied`
- `exempted_zero_rated`
- `liable`
- `indeterminate`

Prospective DECISION (first match wins):
- `already_registered`
- `not_liable`
- `exempted_zero_rated`
- `liable`
- `indeterminate`

Eligibility STATUS (query type #2):
- `eligible` (liable — the person MUST register)
- `ineligible` (not_liable, not_liable_comptroller_satisfied, exempted_zero_rated, or already_registered)
- `indeterminate`

## Profile keys

| Key | Type | Required? | Notes |
|-----|------|-----------|-------|
| is_registered | true / false | Yes (both) | |
| belongs_in_singapore | true / false | Yes (both) | |
| zero_rated_exemption_granted | true / false | No (both) | defaults to false |
| comptroller_satisfied_next_year_not_exceeding | true / false | No (retro only) | defaults to false; ignored by prospective |
| calendar_year | integer >= 2019 | Yes (retro) | |
| taxable_supplies_cents | integer | Yes (retro) | gross total in cents |
| capital_asset_supplies_cents | integer | No (retro) | defaults to 0 |
| reverse_charge_supplies_cents | integer | No (retro) | defaults to 0 |
| seventh_schedule_supplies_cents | integer | No (retro) | defaults to 0 |
| forecast_start_date | date(Y, M, D) | Yes (prospective) | day X, >= date(2022,1,1) |
| forecast_taxable_supplies_cents | integer | Yes (prospective) | gross total in cents |
| forecast_capital_asset_supplies_cents | integer | No (prospective) | defaults to 0 |
| forecast_reverse_charge_supplies_cents | integer | No (prospective) | defaults to 0 |
| forecast_seventh_schedule_supplies_cents | integer | No (prospective) | defaults to 0 |

## Citation-key atoms

| Atom | Statutory source |
|------|-----------------|
| sg_gsta_1993_sch1_para_1_1 | Sch 1 para 1(1) — person not registered making taxable supplies |
| sg_gsta_1993_sch1_para_1_1_a_ii | Sch 1 para 1(1)(a)(ii) — retrospective trigger |
| sg_gsta_1993_sch1_para_1_1_b | Sch 1 para 1(1)(b) — prospective trigger |
| sg_gsta_1993_sch1_para_1_3_b | Sch 1 para 1(3)(b) — comptroller-satisfied relief |
| sg_gsta_1993_sch1_para_1_4 | Sch 1 para 1(4) — reverse-charge exclusion |
| sg_gsta_1993_sch1_para_1c_2 | Sch 1 para 1C(2) — capital-asset disregard |
| sg_gsta_1993_sch1_para_4_1a | Sch 1 para 4(1A) — retrospective 30-day notification |
| sg_gsta_1993_sch1_para_4_2_a | Sch 1 para 4(2)(a) — retrospective registration effective date |
| sg_gsta_1993_sch1_para_5_1 | Sch 1 para 5(1) — prospective 30-day notification |
| sg_gsta_1993_sch1_para_5_2_a_i | Sch 1 para 5(2)(a)(i) — prospective effective date (pre-1 Jul 2025) |
| sg_gsta_1993_sch1_para_5_2_a_ii | Sch 1 para 5(2)(a)(ii) — prospective effective date (on/after 1 Jul 2025) |
| sg_gsta_1993_sch1_para_15_1 | Sch 1 para 15(1) — zero-rated exemption |

## Public predicates

```
decide_gst_registration(PROFILE, RESULT): dispatch to retrospective or prospective determination; RESULT is the record term. [sg_gsta_1993_sch1_para_1_1]
gst_registration_status(PROFILE, STATUS): eligibility verdict (eligible/ineligible/indeterminate) with cited checklist. [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_1_1_b]
gst_registration_checklist(PROFILE, CHECKLIST): full cited checklist for the applicable determination. [all citations above]
fixtures: test fixture generator for the domain.
```

## Planned reuse (kit / MODULES.yaml)

| Module | Predicates used | Purpose |
|--------|----------------|---------|
| formalize_lib | profile_get/3, profile_has/2, profile_lacks/2, missing_keys/3, all_present/2, first_applicable/2, sum_list/2 | Profile access, missing-key detection, decision cascade |
| kit/deadline_lib | month_last_day/3, add_months_to_date/3 | Date arithmetic for notification and registration effective dates |
| library(datetime) | date_add/3, timedelta/3, days_between/3, date_diff/3 | Native date arithmetic (30-day offsets, month+2 computation) |
| kit/query_combinators | what_if/5, flip_scan/4, bisect_flip/4 | Query type #6 threshold boundary exploration |
| validate_props | run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3 | Verification properties |

## Determination slice: gst_registration.clausal

### Statutory value facts owned by this slice

| Constant | Value | Source |
|----------|-------|--------|
| gst_registration_threshold_cents | 100000000 | Sch 1 para 1(1) — S$1 million |
| gst_registration_notification_days | 30 | Sch 1 para 4(1A), para 5(1) |
| gst_registration_seventh_schedule_min_year | 2022 | Sch 1 para 1(1)(a)(ii) — Seventh Schedule applies from 2022 |
| gst_registration_prospective_cutover_date | date(2025, 7, 1) | S 443/2025 — para 5(2)(a) split |

### Rules / requirements

1. **R1 — Registration status gate**: is_registered is true → already_registered. [sg_gsta_1993_sch1_para_1_1]
2. **R2 — Value computation (retrospective)**: VALUE_CENTS = taxable_supplies_cents - capital_asset_supplies_cents - reverse_charge_supplies_cents + (seventh_schedule_supplies_cents if belongs_in_singapore AND calendar_year >= 2022 else 0). [sg_gsta_1993_sch1_para_1_4, sg_gsta_1993_sch1_para_1c_2]
3. **R3 — Value computation (prospective)**: VALUE_CENTS = forecast_taxable_supplies_cents - forecast_capital_asset_supplies_cents - forecast_reverse_charge_supplies_cents + (forecast_seventh_schedule_supplies_cents if belongs_in_singapore else 0). [sg_gsta_1993_sch1_para_1_4, sg_gsta_1993_sch1_para_1c_2]
4. **R4 — Threshold test (retrospective)**: VALUE_CENTS > 100000000 → liable (subject to R5, R6); else not_liable. [sg_gsta_1993_sch1_para_1_1_a_ii]
5. **R5 — Comptroller-satisfied relief (retrospective only)**: comptroller_satisfied_next_year_not_exceeding is true → not_liable_comptroller_satisfied (outranks R6). [sg_gsta_1993_sch1_para_1_3_b]
6. **R6 — Zero-rated exemption**: zero_rated_exemption_granted is true → exempted_zero_rated. [sg_gsta_1993_sch1_para_15_1]
7. **R7 — Threshold test (prospective)**: VALUE_CENTS > 100000000 → liable (subject to R6); else not_liable. [sg_gsta_1993_sch1_para_1_1_b]
8. **R8 — Retrospective notification deadline**: NOTIFY_BY = date(calendar_year + 1, 1, 30). [sg_gsta_1993_sch1_para_4_1a]
9. **R9 — Retrospective registration effective date**: REGISTERED_FROM = date(calendar_year + 1, 3, 1). [sg_gsta_1993_sch1_para_4_2_a]
10. **R10 — Prospective notification deadline**: NOTIFY_BY = forecast_start_date + 30 days. [sg_gsta_1993_sch1_para_5_1]
11. **R11 — Prospective registration effective date (pre-cutover)**: if forecast_start_date < date(2025,7,1): REGISTERED_FROM = forecast_start_date + 31 days. [sg_gsta_1993_sch1_para_5_2_a_i]
12. **R12 — Prospective registration effective date (on/after cutover)**: if forecast_start_date >= date(2025,7,1): target month = month(forecast_start_date) + 2; target day = day(forecast_start_date) if <= last_day(target_month) else last_day(target_month); REGISTERED_FROM = date(year, target_month, target_day). [sg_gsta_1993_sch1_para_5_2_a_ii]
13. **R13 — Missing required keys**: any required key absent → (indeterminate, n_a, n_a, n_a, []).

### Verdict atoms

`already_registered`, `not_liable`, `not_liable_comptroller_satisfied`, `exempted_zero_rated`, `liable`, `indeterminate`

### Shared predicates (belong in kernel.clausal)

None. This is the only determination slice; all logic is self-contained in gst_registration.clausal. The kernel provides only the module declaration, use_module imports, and constant_value declarations for the threshold.
