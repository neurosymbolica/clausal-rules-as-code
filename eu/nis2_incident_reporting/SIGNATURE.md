# SIGNATURE — eu/nis2_incident_reporting

Public query surface: `decide_nis2_incident_reporting(PROFILE, nis2_incident_reporting_verdict(STATUS, CITATIONS))` is the significance verdict (#2). `nis2_incident_reporting_status(PROFILE, STATUS)`, `nis2_incident_reporting_checklist(PROFILE, CHECKLIST)`, `nis2_incident_reporting_what_if(PROFILE, KEY, VALUE, RESULT)` and the fixtures keep their scaffold names. The deadline queries (#15) are `incident_reporting_steps/2` and `reporting_step_timeliness/4`. PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only with `profile_get/3` from formalize_lib. Every query is total and deterministic, with exactly one solution. No figure is imported or re-declared outside its slice.

## Verdict STATUS atoms (replace the placeholders satisfied / not_satisfied)

- Significance: `significant`, `not_significant`, `indeterminate(MISSING_KEYS)`, `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`, `input_problems(PROBLEMS)`.
- Timeliness RESULT: `on_time`, `late(hour_limit)`, `late(without_undue_delay)`, plus the same three non-final forms.
- Steps: a list of `step_due(STEP, LIMIT, cite(KEY))`, or a non-final compound alone.
- Never write the bare atom `indeterminate`.
- Problem terms: `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (six, in root_exports / input_contract order)

1. `severe_operational_disruption_or_financial_loss`: judgement (true / false / unsure), Art 23(3)(a).
2. `considerable_damage_to_other_persons`: judgement, Art 23(3)(b).
3. `trust_service_provider_incident_affects_trust_services`: crisp (true / false), Art 23(4) last sentence.
4. `incident_ongoing_at_final_report_due`: crisp, Art 23(4)(e).
5. `early_warning_without_undue_delay`: judgement, Art 23(4)(a).
6. `incident_notification_without_undue_delay`: judgement, Art 23(4)(b).

Arguments, not profile keys: STEP (`early_warning` or `incident_notification`) and HOURS_ELAPSED (a non-negative integer, rounded up). No date terms are used, because the caller supplies hours.

## Citation-key atoms

- `eu_dir_2022_2555_art_23_1`
- `eu_dir_2022_2555_art_23_3`
- `eu_dir_2022_2555_art_23_3_a`
- `eu_dir_2022_2555_art_23_3_b`
- `eu_dir_2022_2555_art_23_4`
- `eu_dir_2022_2555_art_23_4_a`
- `eu_dir_2022_2555_art_23_4_b`
- `eu_dir_2022_2555_art_23_4_c`
- `eu_dir_2022_2555_art_23_4_d`
- `eu_dir_2022_2555_art_23_4_e`

These must match _lexicon/citations.yaml and are always written as `cite(KEY)`. No shortened atoms are invented.

## Public predicates

- `decide_nis2_incident_reporting(Profile, Verdict)`: facade; Verdict is `nis2_incident_reporting_verdict(Status, Citations)` for significance; Art 23(3).
- `nis2_incident_reporting_status(Profile, Status)`: the significance status alone; Art 23(3).
- `nis2_incident_reporting_checklist(Profile, Checklist)`: cited checklist of limbs (a) and (b); Art 23(3)(a), (b).
- `nis2_incident_reporting_what_if(Profile, Key, Value, Result)`: re-decide with one key overridden; Art 23(3).
- `incident_significance(Profile, Status, Citations)`: the OR of two judgement limbs; Art 23(3).
- `incident_reporting_steps(Profile, Steps)`: the single list of `step_due/3` terms, or a non-final status alone; Art 23(4)(a)-(e).
- `reporting_step_timeliness(Profile, Step, HoursElapsed, Result)`: on_time or late for the early warning or incident notification; Art 23(4)(a), (b), last sentence.
- `nis2_incident_reporting_input_problems(Profile, Problems)`: the typed input check, run first by every query.
- `fixtures`: the scaffold fixture facade, unchanged.
- Result constructors, exported and never called: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `step_due/3`, `hours_after_awareness/1`, `months_after_notification/1`, `months_after_handling/1`, `late/1`.

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`, `missing_keys/3`, `memberd/2`, `not_member/2`, and the `assess/6` engine for the checklist.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.
- `kit.query_combinators`: `what_if/5` for the what_if query.
- Not used: `kit/deadline_lib` and `library(datetime)`, because hours are an integer input and month limits are only listed. If month limits are computed later, they must use `deadline_months_after/3`.

## Determination slice: nis2_incident_reporting.clausal

This is the single slice. It is self-contained for the whole legal concept.

**Statutory value facts it owns** (declared once with `constant_value`, read with `constant(Name)`):

- `early_warning_hour_limit` = 24 (Art 23(4)(a))
- `incident_notification_hour_limit` = 72 (Art 23(4)(b))
- `trust_service_provider_hour_limit` = 24 (Art 23(4) last sentence)
- `final_report_months_after_notification` = 1 (Art 23(4)(d))
- `final_report_months_after_handling` = 1 (Art 23(4)(e))

**Derived arithmetic:** `HoursElapsed =< Limit` is within the limit, and `HoursElapsed > Limit` is late. There is no other arithmetic.

**Rules and requirements:**

- Input check, run first: duplicate_key, wrong_type, unknown_key, and wrong_type(profile) for a non-attribute list. Order: contract-key problems in contract order, then unknown keys in first-occurrence order. Argument problems for timeliness: wrong_type(step), then wrong_type(hours_elapsed).
- Significance requirement `limb_a`: met if the key is true, unmet if false, unknown if absent, referral if unsure. Cites cite(eu_dir_2022_2555_art_23_3_a).
- Significance requirement `limb_b`: same shape, cites cite(eu_dir_2022_2555_art_23_3_b).
- Significance verdict, first step that answers decides:
  - A or B true gives `significant`. Citation is the first met limb only.
  - Otherwise any absent key gives `indeterminate` naming all absent keys in order.
  - Otherwise any unsure key gives `needs_legal_review(open_textured(FirstUnsureKey, cite(Limb)), [inputs_relied_on(Pairs)])`.
  - Otherwise both false gives `not_significant` citing both limbs.
- Steps: not significant gives []. A non-final significance status is returned alone. Significant needs the trust-service-provider and ongoing keys: any absent gives `indeterminate` naming the absent ones. Otherwise the list is early_warning (24), incident_notification (24 with cite_4 if the trust-service-provider key is true, else 72 with cite_4_b), intermediate_report, final_report (months_after_notification(1)), and, only if ongoing, progress_report (at_final_report_due) and final_report_after_handling (months_after_handling(1)).
- Early-warning timeliness: HoursElapsed > 24 gives late(hour_limit) and reads no key. Otherwise the without-undue-delay key decides: absent gives indeterminate, true gives on_time, false gives late(without_undue_delay), unsure gives needs_legal_review.
- Incident-notification timeliness: above 72 gives late(hour_limit) and does not read the trust-service-provider key. From 25 to 72 the trust-service-provider key is needed: absent gives indeterminate, true gives late(hour_limit), false goes on. At 24 or fewer the key is not read. The without-undue-delay key then decides as above.
- Pairs rule: PAIRS are the present judgement keys the query reads, in root_exports order, unsure included, optionally followed by `provenance(Clause, Citations)`.
- Each clause has one disjoint route with outputs folded into the head. No `!`, `->` or `*->`. Every query yields exactly one solution.

**Verdict atoms:** as in the STATUS list above.

**Shared predicates for kernel.clausal:** none beyond the scaffold kernel. The `memberd` / `profile_get` style helpers come from formalize_lib, not the kernel.
