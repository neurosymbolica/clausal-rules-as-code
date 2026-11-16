# SIGNATURE — eu/cra_art14_manufacturer_reporting

## Public query surface

The package exposes three sets of predicates, all from `queries.clausal` through the package facade.

**Contract queries (the called contract), names exactly as the contract gives them:**
- `severe_incident_status(Profile, Status, Citations)` — query type #2, eligibility.
- `manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps)` — query type #15, deadline: what is due and by when.
- `manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result)` — query type #15: the consequence of missing the limit.
- `cra_art14_manufacturer_reporting_input_problems(Profile, Problems)` — the input check.

**Scaffold facade (names kept):**
- `decide_cra_art14_manufacturer_reporting/2`
- `cra_art14_manufacturer_reporting_status/2`
- `cra_art14_manufacturer_reporting_checklist/2`
- `cra_art14_manufacturer_reporting_what_if/4`
- fixtures

The facade is the severity determination.

**Guarantees:**
- Totality: every query yields exactly ONE solution for every term, including unbound or ill-typed arguments.
- Determinism: the routes are written as disjoint clauses with the ground output folded into the head (C17). There is no `!`, `->`, `*->` or `once/1`, and no route can fire twice.
- The input check never fails and never raises.
- Statutory figures are declared once with `:- constant_value/2` in the slice file and read with `constant(Name)`. Nothing is imported from another domain, and nothing is re-declared.

## Verdict STATUS atoms (replace the placeholder satisfied / not_satisfied)

**Severity (severe_incident_status, decide, status):**
- `severe`
- `not_severe`

**Timeliness (RESULT):**
- `on_time`
- `late(hour_limit)`
- `late(without_undue_delay)`

**Steps (STEPS):**
- a list of `step_due(Step, Limit, cite(Key))`; or
- `[]`; or
- a non-final compound alone.

**Step atoms:**
- `early_warning`
- `notification`
- `final_report`
- `intermediate_report`

**Limit terms:**
- `hours_after_awareness(24)`
- `hours_after_awareness(72)`
- `days_after_measure_available(14)`
- `months_after_notification(1)`
- `on_request_of_coordinator_csirt`

**Non-final, shared by all queries:**
- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: the only REASON produced is `open_textured/2`.
- `input_problems(Problems)`.

**Problem terms:**
- `wrong_type(profile)`
- `wrong_type(Key)`
- `duplicate_key(Key)`
- `unknown_key(Key)`
- `wrong_type(event)`
- `wrong_type(awareness_date)`
- `wrong_type(step)`
- `wrong_type(hours_elapsed)`

**Result constructors (exported, never called as queries):**
`date/3`, `step_due/3`, `hours_after_awareness/1`, `days_after_measure_available/1`, `months_after_notification/1`, `late/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (attribute list, read ONLY with formalize_lib profile_get/3)

The four keys are listed in root_exports and input_contract order. All are JUDGEMENT keys. Each is tri-state: the atom `true`, the atom `false` or the atom `unsure`. In the typed contract the type is `one_of boolean or unsure`, where boolean means the two atoms.

1. `affects_protection_of_sensitive_or_important_data_or_functions`
   - Art 14(5)(a). In formulas: A.
2. `leads_to_malicious_code_in_product_or_user_systems`
   - Art 14(5)(b). In formulas: B.
3. `early_warning_without_undue_delay`
   - Points (a) of Art 14(2) and (4). In formulas: EW.
4. `notification_without_undue_delay`
   - Points (b) of Art 14(2) and (4). In formulas: N.

There are no numeric profile keys. RULINGS ruling 2 (the attested wrapper) is NOT used.

**Arguments (not profile keys):**
- `Event`: `actively_exploited_vulnerability` or `incident_impacting_product_security`.
- `AwarenessDate`: a ground `date(Year, Month, Day)` of a real calendar day.
- `Step`: `early_warning` or `notification`.
- `HoursElapsed`: a non-negative integer. It counts hours from awareness to submission, with a partial hour rounded UP (RULINGS ruling 6).

## Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml)

These keys are produced in answers:

- `eu_reg_2024_2847_art_14_5`: Art 14(5) lead words. Cited by `severe` (S1).
- `eu_reg_2024_2847_art_14_5_a`: Art 14(5)(a). Cited by `not_severe` and by the referral on A.
- `eu_reg_2024_2847_art_14_5_b`: Art 14(5)(b). Cited by `not_severe` and by the referral on B.
- `eu_reg_2024_2847_art_14_2_a`: early warning for a vulnerability. Used in the steps list and the timeliness referral.
- `eu_reg_2024_2847_art_14_2_b`: vulnerability notification. Used in the steps list and the timeliness referral.
- `eu_reg_2024_2847_art_14_2_c`: final report for a vulnerability.
- `eu_reg_2024_2847_art_14_4_a`: early warning for a severe incident.
- `eu_reg_2024_2847_art_14_4_b`: incident notification.
- `eu_reg_2024_2847_art_14_4_c`: final report for a severe incident.
- `eu_reg_2024_2847_art_14_6`: intermediate report on request.

These keys appear only in the checklist, provenance and citation_vocabulary. They are never placed in a scored answer list:

- `eu_reg_2024_2847_art_14_1`: the duty for a vulnerability.
- `eu_reg_2024_2847_art_14_3`: the duty for a severe incident.
- `eu_reg_2024_2847_art_71_2`: the application date. Its provenance is the R1 empty list.

Each atom is used verbatim from the lexicon. Do NOT shorten any atom. If the lexicon lacks one of the three non-scored keys, drop it rather than invent it.

## Public predicates (one line each)

- `severe_incident_status(Profile, Status, Citations)`: severity of an incident impacting product security, by limbs S0–S4.
  - Status is `severe` / `not_severe` / `indeterminate([Key])` / `needs_legal_review(...)` / `input_problems(Problems)`.
  - Citations is `[]` on every non-final status.
  - Cites Art 14(5), (5)(a), (5)(b).
- `manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps)`: due steps in the order early_warning, notification, final_report, intermediate_report, by limbs R0–R3, returned as a single solution.
  - Cites Art 14(2)(a)–(c) or (4)(a)–(c), and Art 14(6).
  - Gated by Art 71(2).
- `manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result)`: hour limit, then undue delay, by limbs T0–T2.
  - Cites Art 14(2)(a)/(b) or (4)(a)/(b) in a referral.
- `cra_art14_manufacturer_reporting_input_problems(Profile, Problems)`: the typed profile check. It gives `[]` when the profile is well formed and exactly one solution in all cases.
  - Input contract (THE INPUT CHECK).
- `decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, Citations))`: the facade verdict. It wraps `severe_incident_status/3` one to one.
  - Cites Art 14(5).
- `cra_art14_manufacturer_reporting_status(Profile, Status)`: the Status of the facade verdict only.
  - Cites Art 14(5).
- `cra_art14_manufacturer_reporting_checklist(Profile, Checklist)`: an explanatory checklist of the two severity limbs. It is built by `formalize_lib:eval_requirements/4` over `requirement/4`.
  - Items are `item(sensitive_or_important_data_or_functions_limb, ItemStatus, cite(eu_reg_2024_2847_art_14_5_a))` and `item(malicious_code_limb, ItemStatus, cite(eu_reg_2024_2847_art_14_5_b))`.
  - ItemStatus is `met` for `true`, `unmet(limb_not_met)` for `false`, and `unknown([Key])` when the key is absent or `unsure`.
  - It is not scored; the verdict comes from the limbs, not from the checklist.
  - With input problems the checklist is `[]`.
  - Cites Art 14(5)(a), (b).
- `cra_art14_manufacturer_reporting_what_if(Profile, Key, Value, Verdict)`: the facade verdict after overriding one profile key. It uses `kit/query_combinators:what_if/5` with the closure `decide_cra_art14_manufacturer_reporting`.
  - An override that makes the profile ill-formed gives the `input_problems` verdict.
  - Cites Art 14(5).
- `cra_art14_manufacturer_reporting_fixture(Name, Profile)`: named sample profiles. Each one drives one limb, as listed in the fixtures section.

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**
- `profile_get/3`: every key read, by presence first, then value.
- `profile_has/2` and `profile_lacks/2`: absence routes.
- `eval_requirements/4`: the checklist. The requirement closure is `requirement`, called as `requirement(RequirementId, Profile, Status, Citation)`.
- `item/3`, `unmet/1`, `unknown/1`, `attribute/2`: constructors.
- `not_member/2`: unknown-key collection.

`check_tri/4` is not used for the verdict. Its tri-valued Kleene status does not carry the `unsure` value, the status rule first-missing, or the `open_textured` referral. Using a local three-clause requirement avoids a C15 clone, because it is not a Kleene combinator.

**`kit/deadline_lib`:**
- `month_last_day/3`: the real-calendar-day check of AwarenessDate, including the leap year rule.

**`kit/query_combinators`:**
- `what_if/5`: the facade what_if.

**`validate_props` (tests only):**
- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`: every query has one solution.
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`: HoursElapsed 24/25 and 72/73; AwarenessDate 2026-09-10/2026-09-11.
- `prop_missing_key_coverage/3`

**`library(datetime)`:** not imported.
- No date arithmetic is performed (the calendar periods are listed, not computed).
- AwarenessDate stays the contract term `date(Y, M, D)` and is compared component-wise.
- The native-datetime idiom is honoured by computing no hand-rolled day counts at all.

**`_common` family backbone:** none needed beyond the kernel floor.

## Slice: cra_art14_manufacturer_reporting.clausal

This file is SELF-CONTAINED for the whole determination: the severity, the steps, the timeliness and the input check.

### Statutory VALUE facts it owns

These live in this file, not in parameters or the kernel:

- `:- constant_value(early_warning_limit_hours, 24).`: Art 14(2)(a), (4)(a).
- `:- constant_value(notification_limit_hours, 72).`: Art 14(2)(b), (4)(b).
- `:- constant_value(vulnerability_final_report_days, 14).`: Art 14(2)(c). Listed only.
- `:- constant_value(incident_final_report_months, 1).`: Art 14(4)(c). Listed only.
- `:- constant_value(application_year, 2026).`: Art 71(2).
- `:- constant_value(application_month, 9).`: Art 71(2).
- `:- constant_value(application_day, 11).`: Art 71(2).

Table facts:

- `judgement_key/1`: the four keys, in root_exports order. This is also the input_contract key order.
- `judgement_value/1`: `true`, `false`, `unsure`.
- `event_atom/1`: the two EVENT atoms.
- `timed_step/1`: `early_warning`, `notification`.
- `step_undue_delay_key(Step, Key)`: `early_warning` with EW, `notification` with N.
- `step_limit_constant(Step, ConstantName)`.
- `step_citation(Event, Step, CitationKey)`: the four combinations of Art 14(2)(a)/(b) and (4)(a)/(b).
- `severity_limb_citation(Key, CitationKey)`: A with 14_5_a, B with 14_5_b.

### Rules / requirements

The first step that applies decides. Each route is a disjoint clause with its ground output in the head.

**Input check: `cra_art14_manufacturer_reporting_input_problems(Profile, Problems)`**

- **I1.** If Profile is not a proper attribute list, Problems is `[wrong_type(profile)]`. Not a proper attribute list means any of:
  - an unbound variable;
  - a partial list;
  - a list with an unbound element;
  - a list with an element that is not `attribute(_, _)`.
- **I2.** For each contract key, in contract order:
  - if the key occurs more than once, matched by `==` on atom keys, add `duplicate_key(Key)`; its values are not read;
  - else, if it occurs once with a value not `==` to `true`, `false` or `unsure` (an unbound value included), add `wrong_type(Key)`.
- **I3.** Then add `unknown_key(Key)` once for each distinct key not in the contract, in order of first occurrence.
  - Distinct keys are compared with `==`.
  - This includes non-atom keys (numbers, strings, compounds, unbound variables), each given as written.
- **I4.** An absent key is never a problem.
- **I5. Argument problems.** These are appended after the profile problems, including after `[wrong_type(profile)]`. Each is added only if its argument fails the stated test.
  - `wrong_type(event)` if Event is not one of the two EVENT atoms; an unbound Event included.
  - `wrong_type(awareness_date)` if AwarenessDate is not a ground `date(Y, M, D)` with all of these:
    - Y an integer;
    - M an integer from 1 to 12;
    - D an integer from 1 to `month_last_day(Y, M, LastDay)`.
  - `wrong_type(step)` if Step is not `early_warning` or `notification`.
  - `wrong_type(hours_elapsed)` if HoursElapsed is not a non-negative integer; an unbound value included.
- **I6.** The check is built with type tests before unification (`var/1`, `nonvar/1`, `atom/1`, `integer/1`, `is_list/1`, `==`), so it never raises and never fails. A query-level helper builds the full problem list per query: profile problems followed by that query's argument problems.

**Severity: `severe_incident_status/3`, also used inside R3**

Let A be `affects_protection_of_sensitive_or_important_data_or_functions` and B be `leads_to_malicious_code_in_product_or_user_systems`.

- **S0.** If Problems is not `[]`: `input_problems(Problems)`, `[]`.
- **S1.** If A is `true`, or B is `true`: `severe`, `[cite(eu_reg_2024_2847_art_14_5)]`.
  - The disjoint clauses are (A true) and (A not true and B true), so the route never yields twice.
- **S2.** Otherwise, if neither is `true` and A is absent: `indeterminate([A])`, `[]`.
  - Otherwise, if A is present and not `true`, and B is absent: `indeterminate([B])`, `[]`.
- **S3.** Otherwise, both are present, neither is `true`, and at least one is `unsure`. Refer on the first unsure key:
  - if A is `unsure`: `needs_legal_review(open_textured(A, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([A-ValueA, B-ValueB])])`, `[]`;
  - else (A is `false`, B is `unsure`): the same compound with B and `cite(eu_reg_2024_2847_art_14_5_b)`.
- **S4.** Otherwise (A and B both `false`): `not_severe`, `[cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]`.

**Steps: `manufacturer_reporting_steps/4`**

- **R0.** If Problems is not `[]`: `input_problems(Problems)`.
- **R1.** If AwarenessDate is before the application date: `[]`. No key is read.
  - The predicate `date_before_application(date(Y, M, D))` is true in exactly one of three disjoint cases:
    - Y is less than the application year;
    - Y equals the year and M is less than the application month;
    - Y and M are equal and D is less than the application day.
- **R2.** If the date is on or after the application date and Event is `actively_exploited_vulnerability`:
  - `[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]`.
  - The numbers are built from the constants. No key is read.
- **R3.** If the date is on or after the application date and Event is `incident_impacting_product_security`, read the severity core (S1–S4, without S0) once:
  - `not_severe` gives `[]`;
  - `indeterminate([Key])` or `needs_legal_review(...)` gives the same compound, unchanged;
  - `severe` gives `[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]`.
- EW and N are never read here.

**Timeliness: `manufacturer_reporting_step_timeliness/5`**

This query presupposes that the step is due. It reads neither the date nor A or B. Let K be `step_undue_delay_key(Step, K)` and Limit be `constant` of `step_limit_constant(Step)`.

- **T0.** If Problems is not `[]`: `input_problems(Problems)`.
- **T1.** If `HoursElapsed > Limit`: `late(hour_limit)`. No key is read.
- **T2.** If `HoursElapsed =< Limit`:
  - K absent gives `indeterminate([K])`;
  - K `true` gives `on_time`;
  - K `false` gives `late(without_undue_delay)`;
  - K `unsure` gives `needs_legal_review(open_textured(K, cite(CitationKey)), [inputs_relied_on([K-unsure])])`, with CitationKey from `step_citation(Event, Step, CitationKey)`.
- The other step's key is never read.

**Checklist requirement: `requirement(RequirementId, Profile, Status, Citation)`**

For each of the two limb ids there are exactly three mutually exclusive clauses:

- `met` when the key is `true`;
- `unmet(limb_not_met)` when the key is `false`;
- `unknown([Key])` when the key is absent or `unsure`.

### Verdict atoms of the slice

- `severe`, `not_severe`
- `on_time`, `late(hour_limit)`, `late(without_undue_delay)`
- the step lists and limit terms above
- the non-final compounds above

### Shared predicates (kernel.clausal)

None. This is the only determination slice, so no predicate needs sharing. The kernel stays the small floor:

- the scaffold's result-constructor declarations;
- the package-wide status vocabulary, if the scaffold already holds it there.

No domain rule, figure or citation goes into the kernel. Citations and parameters keep their scaffold files:

- `citations.clausal` holds the cite-key table and its pinned unit ids;
- `parameters.clausal` re-exports nothing and holds no copy of the slice constants.

## queries.clausal

This file holds thin public wrappers that delegate to the slice:

- the four contract predicates;
- the facade `decide_cra_art14_manufacturer_reporting/2`, `cra_art14_manufacturer_reporting_status/2`, `cra_art14_manufacturer_reporting_checklist/2` and `cra_art14_manufacturer_reporting_what_if/4`.

Each wrapper is one clause, which keeps one solution per call.

## fixtures.clausal

`cra_art14_manufacturer_reporting_fixture(Name, Profile)`. Each fixture drives the limb named in brackets.

**Severity fixtures:**
- `severe_by_sensitive_data`: A `true`, B absent [S1].
- `severe_by_malicious_code`: A `false`, B `true` [S1].
- `severity_missing_both`: empty profile [S2, names A].
- `severity_unsure_a_missing_b`: A `unsure` [S2, names B].
- `severity_missing_a_false_b`: B `false` [S2, names A].
- `severity_unsure_a_false_b`: A `unsure`, B `false` [S3 on A].
- `severity_false_a_unsure_b`: A `false`, B `unsure` [S3 on B].
- `not_severe_incident`: A `false`, B `false` [S4].

**Timeliness fixtures:**
- `early_warning_without_delay`: EW `true` [T2 on_time].
- `early_warning_with_delay`: EW `false` [T2 late].
- `early_warning_unsure`: EW `unsure` [T2 referral].
- `notification_without_delay`: N `true`.

**Input-check fixtures:**
- `duplicate_severity_key`: A twice [I2].
- `wrong_type_value`: A `yes` [I2].
- `unknown_extra_key`: `attribute(severity_score, 7)` [I3].
- `not_an_attribute_list`: `[foo]` [I1].

**Boundary arguments used in tests:**
- HoursElapsed 24/25 for `early_warning` and 72/73 for `notification`.
- AwarenessDate `date(2026, 9, 10)` (gives `[]`) and `date(2026, 9, 11)` (steps listed).
- `date(2027, 2, 29)` gives `wrong_type(awareness_date)`; `date(2028, 2, 29)` is valid.
- An unbound Event gives `wrong_type(event)`.

The tests pair every `fail` test with a positive test over the same case. They also assert one solution with `findall` and `length(Solutions, 1)`.
