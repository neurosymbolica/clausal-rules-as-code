# SIGNATURE — sg/companies/small_company_audit_exemption

## Public query surface

The domain exposes five public predicates (scaffold facade names preserved). The primary entry point is `decide_small_company_audit_exemption/2`, which returns a single `audit_exemption(Decision, SmallCompany, SmallGroup, Reasons)` term per profile. `Decision` is one of `exempt`, `not_exempt`, `indeterminate`. `SmallCompany` and `SmallGroup` are `true`, `false`, or `n_a`. `Reasons` is an ordered list drawn from `[financial_year_before_1_july_2015, not_small_company, not_small_group, audit_requisition_notice]` (empty when exempt or indeterminate). The `what_if/4` predicate supports threshold-boundary exploration by overriding a single profile key. Totality: exactly one solution per well-formed profile. Determinism: the walk is a deterministic left-to-right fold; no backtracking ambiguity.

## Profile keys

| Key | Type | Notes |
|---|---|---|
| `incorporation_date` | `date(Y, M, D)` | Required. |
| `financial_years` | list of `fy(StartDate, EndDate, PrivateThroughout, RevenueCents, TotalAssetsCents, Employees)` | Required, non-empty, chronological, no gaps. First element = first FY after incorporation; last element = assessed year. `PrivateThroughout` is `true`/`false`. Money in integer cents. `Employees` is a non-negative integer. |
| `is_parent_company` | `true` / `false` | Required. |
| `is_subsidiary_company` | `true` / `false` | Required. |
| `group_formation_date` | `date(Y, M, D)` | Required when either flag is `true`. |
| `group_financial_years` | list of `gfy(StartDate, EndDate, ConsolidatedRevenueCents, ConsolidatedTotalAssetsCents, AggregateEmployees)` | Required when either flag is `true`, non-empty, chronological. Last element = same assessed year by convention. |
| `audit_requisition_notice_date` | `date(Y, M, D)` | Optional. Absent = no notice. |

## Citation-key atoms

| Atom | Source |
|---|---|
| `ca1967_s205c_1` | s 205C(1) — small company exempt from audit |
| `ca1967_s205c_3` | s 205C(3) — parent must be small + small group |
| `ca1967_s205c_4` | s 205C(4) — subsidiary must be small + small group |
| `ca1967_s205c_6` | s 205C(6) — no exemption for FYs before 1 Jul 2015 |
| `ca1967_s205b_6` | s 205B(6) — members' requisition notice |
| `ca1967_s205b_7` | s 205B(7) — notice defeats exemption |
| `ca1967_sc13_para_2` | Thirteenth Schedule para 2 — small company definition |
| `ca1967_sc13_para_3` | Thirteenth Schedule para 3 — first/second year carve-out |
| `ca1967_sc13_para_4` | Thirteenth Schedule para 4 — pre-2015 incorporation |
| `ca1967_sc13_para_5` | Thirteenth Schedule para 5 — ceasing to be small |
| `ca1967_sc13_para_6` | Thirteenth Schedule para 6 — para 5 inapplicable before 3rd year |
| `ca1967_sc13_para_7` | Thirteenth Schedule para 7 — small group definition |
| `ca1967_sc13_para_8` | Thirteenth Schedule para 8 — group first/second year |
| `ca1967_sc13_para_9` | Thirteenth Schedule para 9 — group pre-2015 |
| `ca1967_sc13_para_10` | Thirteenth Schedule para 10 — group ceasing |
| `ca1967_sc13_para_11` | Thirteenth Schedule para 11 — group para 10 inapplicable before 3rd year |
| `ca1967_sc13_para_12` | Thirteenth Schedule para 12 — group membership per Accounting Standards |
| `ca1967_sc13_para_13` | Thirteenth Schedule para 13 — "small from" is forward-looking |
| `ca1967_sc13_para_14` | Thirteenth Schedule para 14 — re-qualification after ceasing |

## Public predicates

```
decide_small_company_audit_exemption(Profile, Result):
    Main entry. Result = audit_exemption(Decision, SmallCompany, SmallGroup, Reasons).
    Decision in {exempt, not_exempt, indeterminate}.
    Cites: ca1967_s205c_1, ca1967_s205c_3, ca1967_s205c_4, ca1967_s205c_6,
           ca1967_s205b_6, ca1967_s205b_7, ca1967_sc13_para_2..14.

small_company_audit_exemption_status(Profile, Status):
    Returns only the Decision atom (exempt | not_exempt | indeterminate).
    Cites: ca1967_s205c_1.

small_company_audit_exemption_checklist(Profile, Checklist):
    Returns the cited checklist: list of item(RequirementId, Status, Citation).
    RequirementIds: [financial_year_before_1_july_2015, small_company_status,
                     small_group_status, parent_group_condition,
                     subsidiary_group_condition, audit_requisition_notice].
    Cites: all citation-key atoms above.

small_company_audit_exemption_what_if(Profile, Key, Value, Result):
    Override one profile key and re-decide. Supports threshold-boundary queries
    (e.g., set RevenueCents to 1000000000 vs 1000000001 to find the flip point).
    Cites: same as decide/2.

small_company_audit_exemption_fixtures(FixtureList):
    Enumerates the test fixture profiles for this domain.
```

## Imports (measured from the code, 2026-10-05)

Every kit and engine-library module this package's rule files import, with the predicates imported
(read from the `:- use_module` directives of its non-test `.clausal` files; sibling `sg/...` modules omitted).
This replaces the producer's "Planned reuse" table, which listed modules and predicates the code never
imports (e.g. `kit/deadline_lib`).

| Module | Predicates imported | Imported by |
|---|---|---|
| `formalize_lib` | `item/3`, `not_member/2`, `profile_lacks/2` | small_company_audit_exemption.clausal |
| `kit/query_combinators` | `override_key/4` | queries.clausal |
| `library(clpz)` | (whole module) | queries.clausal, small_company_audit_exemption.clausal |
| `library(datetime)` | `date_sub/3`, `timedelta/3` | small_company_audit_exemption.clausal |

## Determination slice: `small_company_audit_exemption.clausal`

### Statutory value facts owned by this slice

Declared once via `:- constant_value(Name, Value).` and read with `constant(Name)`:

| Constant name | Value | Source |
|---|---|---|
| `small_company_revenue_threshold_cents` | `1000000000` | Thirteenth Schedule para 2(a) / para 7(a) |
| `small_company_assets_threshold_cents` | `1000000000` | Thirteenth Schedule para 2(b) / para 7(b) |
| `small_company_employees_threshold` | `50` | Thirteenth Schedule para 2(c) / para 7(c) |
| `small_group_revenue_threshold_cents` | `1000000000` | Thirteenth Schedule para 7(a) |
| `small_group_assets_threshold_cents` | `1000000000` | Thirteenth Schedule para 7(b) |
| `small_group_employees_threshold` | `50` | Thirteenth Schedule para 7(c) |
| `effective_date` | `date(2015, 7, 1)` | s 205C(6); Thirteenth Schedule paras 4, 6, 9, 11 |

(Company and group thresholds are numerically identical but declared separately for clarity and to allow future divergence.)

### Rules / requirements (one per checklist item)

| Requirement ID | Rule | Cites |
|---|---|---|
| `financial_year_before_1_july_2015` | The assessed year's `StartDate` is before `effective_date`. If true, the exemption does not apply. | `ca1967_s205c_6` |
| `small_company_status` | Walk `financial_years` per the STATUS RULE. Result: `true` (small) or `false` (not small) for the assessed year. | `ca1967_sc13_para_2`, `ca1967_sc13_para_3`, `ca1967_sc13_para_4`, `ca1967_sc13_para_5`, `ca1967_sc13_para_6`, `ca1967_sc13_para_13`, `ca1967_sc13_para_14` |
| `small_group_status` | Walk `group_financial_years` per the STATUS RULE (no private-company condition). Result: `true` or `false`. `n_a` if neither flag is set. | `ca1967_sc13_para_7`, `ca1967_sc13_para_8`, `ca1967_sc13_para_9`, `ca1967_sc13_para_10`, `ca1967_sc13_para_11`, `ca1967_sc13_para_12` |
| `parent_group_condition` | If `is_parent_company` is `true`, the company must be a small group. Fails if `small_group_status` is `false`. | `ca1967_s205c_3` |
| `subsidiary_group_condition` | If `is_subsidiary_company` is `true`, the company must be a small group. Fails if `small_group_status` is `false`. | `ca1967_s205c_4` |
| `audit_requisition_notice` | If `audit_requisition_notice_date` is present and falls on or after the assessed year's `StartDate` and on or before the one-month-before-end date, the exemption is defeated. | `ca1967_s205b_6`, `ca1967_s205b_7` |

### Verdict atoms

```
exempt
not_exempt
indeterminate
```

`exempt` iff `Reasons` is `[]`. `not_exempt` iff `Reasons` is non-empty. `indeterminate` iff a required key is missing (both status fields are `n_a`, `Reasons` is `[]`).

### Predicates shared with another slice

None. This is the sole determination slice in the package. The `kernel.clausal` file contains only the minimal shared floor (module declaration, imports of `formalize_lib` and `library(datetime)`, and the `effective_date` constant if it is referenced by more than one slice — here it is not, so it lives in this slice). No predicate is shared.

### Internal helper predicates (private to this slice)

| Predicate | Purpose |
|---|---|
| `fy_qualifies(Fy, True)` | True iff at least 2 of the 3 criteria are satisfied for the given `fy/6` record. |
| `gfy_qualifies(Gfy, True)` | True iff at least 2 of the 3 consolidated criteria are satisfied for the given `gfy/5` record. |
| `walk_company_status(FinancialYears, IncorporationDate, SmallCompany)` | The stateful left-to-right fold implementing paras 2–6, 13, 14. |
| `walk_group_status(GroupFinancialYears, GroupFormationDate, SmallGroup)` | The stateful left-to-right fold implementing paras 7–11, 13, 14 (no private condition). |
| `one_month_before_end(EndDate, OneMonthBefore)` | Computes the clamped one-month-before date. |
| `notice_within_window(NoticeDate, StartDate, EndDate, True)` | True iff the notice date is on or after `StartDate` and on or before `OneMonthBefore`. |
| `collect_reasons(Checklist, Reasons)` | Extracts the ordered failure-reason list from the checklist. |
