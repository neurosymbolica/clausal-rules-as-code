# SIGNATURE — eu/dora_rts_simplified_testing_continuity_and_report

## Public query surface (one paragraph)

The contract queries each take `PROFILE` and return exactly ONE solution (`RESULT`, `CITATIONS`):

- `simplified_testing_continuity_and_report_duties_required/3`
- `simplified_testing_continuity_and_report_duties_complete/3`
- `simplified_testing_continuity_and_report_duties_outstanding/3`

The input check `dora_rts_simplified_testing_continuity_and_report_input_problems/2` also returns exactly one solution.

The scaffold facade wraps the complete query:

- `decide_dora_rts_simplified_testing_continuity_and_report(PROFILE, dora_rts_simplified_testing_continuity_and_report_verdict(STATUS, CITATIONS))`
- `dora_rts_simplified_testing_continuity_and_report_status(PROFILE, STATUS)`

`PROFILE` is an attribute list `[attribute(Key, Value), ...]` of up to forty-two keys. It is read only with `profile_get/3`.

- The gate and the three triggers take `true` or `false`.
- The thirty-eight duty keys take `true`, `false` or `unsure`.

Totality and determinism:

- Every public predicate is total: it yields exactly one solution for every term, never fails and never raises.
- It is cut-free: no `!`, `->` or `*->`.
- Disjoint clause routes carry the ground result in the head (C17).
- The 'first key' is selected by `findall/3` plus head-pattern first element, never `once/1` on an answer.

This order has no statutory figures, so nothing is imported or declared as a figure.

## Verdict STATUS atoms (replace placeholder `{ required, permitted, not_applicable }`)

Final answers:

- `complete` — complete query; also the facade STATUS.
- `incomplete` — complete query; also the facade STATUS.
- `not_article_16_1_entity` — every query; also the facade STATUS.
- `none_outstanding` — outstanding query.
- `required(Duties)` — required query; arity 1; `Duties` is a non-empty list in duty order.
- `outstanding(Duties)` — outstanding query; arity 1; `Duties` is a non-empty list in duty order.

Status compounds (never final, `CITATIONS` is always `[]`):

- `indeterminate([Key])` — exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`
  - This order produces only `open_textured/2`.
  - `Pairs` holds every present `Key-Value` in root_exports order.
  - An optional unscored `provenance(Clause, Citations)` may follow.
- `input_problems(Problems)` — `Problems` holds `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

Compliance-check verdict atoms, used only by the compliance-check facade predicate:

- `prohibited` — omitting a duty that applies.
- `permitted` — omitting a duty that does not apply (a condition fails or the gate is false).
- `indeterminate([Key])` — with `Key` the gate or the first open condition.

Checklist item statuses (formalize_lib vocabulary): `met`, `unmet(not_performed(Key))`, `unknown([Key])`, `inapplicable`.

- `unknown([Key])` is used where the key is absent or unsure.
- `inapplicable` is used where a condition of the duty fails.

Result constructors are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (root_exports / input_contract order; no numeric or date keys)

Types:

- `fact` = `boolean` (the atoms `true` and `false`).
- `judgement` = `one_of(boolean, unsure)`.

| # | Key | Type |
|---|---|---|
| 1 | `financial_entity_is_article_16_1_entity` | fact (gate) |
| 2 | `authority_requested_framework_review_report` | fact (trigger) |
| 3 | `framework_review_initiated_following_supervisory_instructions` | fact (trigger) |
| 4 | `framework_review_initiated_following_ict_related_incidents` | fact (trigger) |
| 5 | `ict_security_testing_plan_established_and_implemented` | judgement |
| 6 | `ict_security_measures_reviewed_assessed_and_tested` | judgement |
| 7 | `security_test_results_evaluated_and_measures_updated` | judgement |
| 8 | `ict_systems_acquisition_and_development_procedure_in_place` | judgement |
| 9 | `requirements_specified_and_approved_before_acquisition` | judgement |
| 10 | `ict_systems_tested_and_approved_before_use_and_changes` | judgement |
| 11 | `alteration_and_manipulation_risk_measures_identified` | judgement |
| 12 | `ict_project_management_procedure_in_place` | judgement |
| 13 | `ict_change_management_procedure_in_place` | judgement |
| 14 | `continuity_plans_developed_on_disruption_and_scenario_analysis` | judgement |
| 15 | `continuity_plans_approved_by_management_body` | judgement |
| 16 | `continuity_plans_documented_and_readily_accessible` | judgement |
| 17 | `continuity_plans_allocate_sufficient_resources` | judgement |
| 18 | `continuity_plans_establish_recovery_levels_and_timeframes` | judgement |
| 19 | `continuity_plans_identify_activation_conditions_and_actions` | judgement |
| 20 | `continuity_plans_identify_restoration_and_recovery_measures` | judgement |
| 21 | `continuity_plans_identify_backup_procedures_scope_and_frequency` | judgement |
| 22 | `continuity_plans_consider_alternative_options` | judgement |
| 23 | `continuity_plans_specify_communication_and_escalation` | judgement |
| 24 | `continuity_plans_updated_with_lessons_learned` | judgement |
| 25 | `continuity_plans_tested_yearly_and_on_major_change` | judgement |
| 26 | `continuity_plan_testing_demonstrates_viability_and_finds_deficiencies` | judgement |
| 27 | `continuity_test_results_documented_and_deficiencies_reported` | judgement |
| 28 | `review_report_submitted_in_searchable_electronic_format` | judgement |
| 29 | `review_report_describes_context` | judgement |
| 30 | `review_report_has_executive_summary` | judgement |
| 31 | `review_report_informs_on_reported_area` | judgement |
| 32 | `review_report_summarises_major_framework_changes` | judgement |
| 33 | `review_report_describes_impact_of_major_changes` | judgement |
| 34 | `review_report_states_approval_date_where_applicable` | judgement |
| 35 | `review_report_describes_reasons_for_review` | judgement |
| 36 | `review_report_gives_evidence_of_supervisory_instructions` | judgement |
| 37 | `review_report_lists_incidents_with_root_cause_analysis` | judgement |
| 38 | `review_report_states_review_period` | judgement |
| 39 | `review_report_names_person_responsible` | judgement |
| 40 | `review_report_summarises_findings_and_self_assessment` | judgement |
| 41 | `review_report_states_remedying_measures` | judgement |
| 42 | `review_report_states_overall_conclusions` | judgement |

This order has no money keys and no date keys, so it constructs no `date(...)` term.

`financial_entity_is_microenterprise` and `dora_entity_type` are NOT contract keys. They give `unknown_key`.

## Citation-key atoms (citation_vocabulary = THE FIXED CITATIONS, canonical `_lexicon/citations.yaml`)

The fourteen keys, in fixed order:

1. `eu_reg_2022_2554_art_16_1`
2. `eu_reg_2024_1774_art_36_1`
3. `eu_reg_2024_1774_art_36_2`
4. `eu_reg_2024_1774_art_36_3`
5. `eu_reg_2024_1774_art_37`
6. `eu_reg_2024_1774_art_38_1`
7. `eu_reg_2024_1774_art_38_2`
8. `eu_reg_2024_1774_art_39_1`
9. `eu_reg_2024_1774_art_39_2`
10. `eu_reg_2024_1774_art_40_1`
11. `eu_reg_2024_1774_art_40_2`
12. `eu_reg_2024_1774_art_40_3`
13. `eu_reg_2024_1774_art_41_1`
14. `eu_reg_2024_1774_art_41_2`

These atoms are fixed by the canonical lexicon. Their `reg` and `art` segments are lexicon-sanctioned and are not renamed. Each declaration line carries `% lint: canonical-citation-key` so that C6 can whitelist it.

Never invent a shortened citation atom.

## Public predicates

All public predicates yield exactly one solution and are cut-free.

- `dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems)`
  - THE INPUT CHECK.
  - For each contract key in input_contract order: `duplicate_key(Key)` if the key repeats (compared by `==`); otherwise `wrong_type(Key)` if its value is outside its type (an unbound value counts as outside).
  - Then `unknown_key(Key)` for every non-contract key in first-occurrence order, compared by `==`. Variables and non-atoms are reported as given, and their values are never checked.
  - A profile that is not an attribute list gives `[wrong_type(profile)]`.
  - Cites the input_contract of the RTS Arts 36 to 41 order.
- `simplified_testing_continuity_and_report_duties_required(Profile, Result, Citations)`
  - Steps R0, R-G1, R-G2, R1 and R2.
  - Reads the gate and the triggers only, and never refers.
  - Cites `eu_reg_2022_2554_art_16_1` plus the key of each listed duty, each once.
- `simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations)`
  - Steps S0, S-G1, S-G2, S1, S2 (with BEHIND per the behind test), S3 and S4.
  - `complete` and `incomplete` cite THE FIXED CITATIONS (RTS Arts 36 to 41 and DORA Art 16(1)).
- `simplified_testing_continuity_and_report_duties_outstanding(Profile, Result, Citations)`
  - Steps M0, M-G1, M-G2, M1, M2 and M3.
  - `none_outstanding` cites THE FIXED CITATIONS.
  - `outstanding(Duties)` cites each outstanding duty's key, each once.
- `decide_dora_rts_simplified_testing_continuity_and_report(Profile, dora_rts_simplified_testing_continuity_and_report_verdict(Status, Citations))`
  - The eligibility verdict (query type #2).
  - `Status` and `Citations` are exactly the `Result` and `Citations` of the complete query.
  - Cites as the complete query does.
- `dora_rts_simplified_testing_continuity_and_report_status(Profile, Status)`
  - `Status` only, from the same call.
  - Cites as the complete query does: RTS Arts 36 to 41 and DORA Art 16(1).
- `dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Checklist)`
  - The justification output (query type #7).
  - The list starts with `item(article_16_1_entity_gate, Status, cite(eu_reg_2022_2554_art_16_1))`.
  - When the gate is true, one `item(Duty, Status, cite(CitationKey))` follows per duty, in duty order.
  - Every item, met items included, carries `cite(...)`.
  - Built with `eval_requirements/4` over `requirement/4`.
- `dora_rts_simplified_testing_continuity_and_report_what_if(Profile, Key, Value, Result)`
  - Replaces or adds `attribute(Key, Value)` with `profile_set/3`, then re-runs the complete query. The new profile goes through the input check like any other.
  - Cites as the complete query does.
- `dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(Duty), Verdict)`
  - The compliance check (query type #13): is the proposed action of omitting `Duty` allowed?
  - Possible verdicts: `prohibited` (the duty applies), `permitted` (a condition fails or the gate is false), `indeterminate([Key])` or `input_problems(Problems)`.
  - The obligation is resolved through `kit/compliance_lib` `compliance_check/7`. The `Applies` closure `duty_norm_applies(Profile)` yields `nm(Duty, obligatory)` for an applying duty. Deny-overrides is trivial here, because there is one norm per duty.
  - Cites the duty's own key.
- `dora_rts_simplified_testing_continuity_and_report_fixture(FixtureName, Profile)` — the fixtures; see the fixtures plan below.

## Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3` and `profile_has/2` / `profile_lacks/2`, for reading by presence first and then by value.
- `profile_set/3`, for what_if.
- `check_tri/4`, for the three-way met/unmet/unknown status of a judgement key inside `requirement/4`. If the exact handling of `unsure` in `check_tri/4` differs from 'unknown', the slice maps unsure to `unknown([Key])` with a dedicated clause and never re-implements check_tri (C15).
- `eval_requirements/4`, for the checklist (R1: no hand-rolled findall item builder).
- `not_defeated/3`, for the defeasible applicability of duties.
- `item/3`, `unmet/1`, `unknown/1` and `attribute/2` (constructors).
- `memberd/2` and `not_member/2`.
- `assess/6` is NOT used for the facade decision: its label scheme would require a bare indeterminate atom.

### kit/compliance_lib

- `nm/2` and `compliance_check/7`, for query type #13.

### validate_props (tests only)

- `run_props/1`
- `prop_totality/3` and `prop_determinism/3`: exactly one solution for each of the four contract predicates, over generated profiles.
- `prop_citation_complete/3`: every final RESULT has non-empty citations drawn from citation_vocabulary, and every status compound has `[]`.
- `prop_missing_key_coverage/3`
- `prop_monotone/5`: a false duty key never turns incomplete into complete.

### Not used, and why

- `kit/deadline_lib`, `kit/rolling_window`, `library(datetime)`: no dates are read (Q4, Q16).
- `currency_vocab`, `vat_category`, `country`: not relevant to this order.
- `kit/query_combinators` (`what_if/5` takes a Dict, not an attribute list): not relevant to this order.

### Family backbone (`_common`)

- The deontic defeater idiom: default obligation, a defeater per failing condition, `not_defeated/3` guarding with `once/1` inside the defeater predicate.
- The facade naming convention.

## Layout (do not restructure)

The layers run: kernel, then citations, then parameters, then the slice `dora_rts_simplified_testing_continuity_and_report`, then queries, then fixtures, then the package facade.

- **kernel.clausal** (the shared floor, and nothing domain-substantive beyond the contract table):
  - `contract_key_type(Key, Type)`: 42 facts in input_contract order, with `Type` in {`fact`, `judgement`}.
  - `value_has_type/2`.
  - The input check, used by every query and by the facade.
  - `present_pairs(Profile, Pairs)`: the present `Key-Value` pairs in contract order.
  - `gate_state(Profile, State)`, with `State` in {`holds`, `fails`, `open`}.
- **citations.clausal**: the fourteen citation facts, `fixed_citations(List)` and the citation_vocabulary.
- **parameters.clausal**: intentionally empty of `constant_value` declarations. The order has no thresholds, periods or amounts, and a comment says so.
- **queries.clausal**: the three contract queries.
  - Each step is a disjoint clause with its RESULT folded into the head.
  - Clauses are guarded by the step predicates of the slice.
- **fixtures.clausal**: the named fixture profiles; see the fixtures plan.
- **package facade**: decide, status, checklist, what_if, compliance_check, fixture.

## Slice: dora_rts_simplified_testing_continuity_and_report.clausal

### Statutory VALUE facts owned (they live in this file only)

The slice owns the duty table. No numeric thresholds, periods or tables exist in Arts 36 to 41: the frequency of Art 40(1) is inside a judgement (Q4).

- `duty(Ordinal, Duty)`: duty order 1 to 38.
- `duty_profile_key(Duty, Key)`
- `duty_citation(Duty, CitationKey)`
- `duty_condition(Duty, Trigger)`, with zero, one or two facts per duty.
- `trigger(Trigger)`, three facts in key order.

The duty table:

| # | duty | provision | citation key | profile key | conditions |
|---|---|---|---|---|---|
| 1 | `ict_security_testing_plan` | Art 36(1) | `eu_reg_2024_1774_art_36_1` | `ict_security_testing_plan_established_and_implemented` | none |
| 2 | `review_and_testing_of_security_measures` | Art 36(2) | `eu_reg_2024_1774_art_36_2` | `ict_security_measures_reviewed_assessed_and_tested` | none |
| 3 | `evaluation_of_security_test_results` | Art 36(3) | `eu_reg_2024_1774_art_36_3` | `security_test_results_evaluated_and_measures_updated` | none |
| 4 | `acquisition_development_and_maintenance_procedure` | Art 37 lead | `eu_reg_2024_1774_art_37` | `ict_systems_acquisition_and_development_procedure_in_place` | none |
| 5 | `requirements_specified_before_acquisition` | Art 37(a) | `eu_reg_2024_1774_art_37` | `requirements_specified_and_approved_before_acquisition` | none |
| 6 | `testing_and_approval_before_use` | Art 37(b) | `eu_reg_2024_1774_art_37` | `ict_systems_tested_and_approved_before_use_and_changes` | none |
| 7 | `manipulation_risk_measures` | Art 37(c) | `eu_reg_2024_1774_art_37` | `alteration_and_manipulation_risk_measures_identified` | none |
| 8 | `ict_project_management_procedure` | Art 38(1) | `eu_reg_2024_1774_art_38_1` | `ict_project_management_procedure_in_place` | none |
| 9 | `ict_change_management_procedure` | Art 38(2) | `eu_reg_2024_1774_art_38_2` | `ict_change_management_procedure_in_place` | none |
| 10 | `continuity_plans_based_on_disruption_analysis` | Art 39(1) | `eu_reg_2024_1774_art_39_1` | `continuity_plans_developed_on_disruption_and_scenario_analysis` | none |
| 11 | `management_body_approval_of_continuity_plans` | Art 39(2)(a) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_approved_by_management_body` | none |
| 12 | `continuity_plans_documented_and_accessible` | Art 39(2)(b) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_documented_and_readily_accessible` | none |
| 13 | `continuity_plan_resources` | Art 39(2)(c) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_allocate_sufficient_resources` | none |
| 14 | `recovery_levels_and_timeframes` | Art 39(2)(d) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_establish_recovery_levels_and_timeframes` | none |
| 15 | `activation_conditions_and_actions` | Art 39(2)(e) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_identify_activation_conditions_and_actions` | none |
| 16 | `restoration_and_recovery_measures` | Art 39(2)(f) + closing sentence | `eu_reg_2024_1774_art_39_2` | `continuity_plans_identify_restoration_and_recovery_measures` | none |
| 17 | `backup_procedures` | Art 39(2)(g) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_identify_backup_procedures_scope_and_frequency` | none |
| 18 | `alternative_options` | Art 39(2)(h) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_consider_alternative_options` | none |
| 19 | `communication_arrangements` | Art 39(2)(i) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_specify_communication_and_escalation` | none |
| 20 | `updating_of_continuity_plans` | Art 39(2)(j) | `eu_reg_2024_1774_art_39_2` | `continuity_plans_updated_with_lessons_learned` | none |
| 21 | `testing_of_continuity_plans` | Art 40(1) | `eu_reg_2024_1774_art_40_1` | `continuity_plans_tested_yearly_and_on_major_change` | none |
| 22 | `continuity_testing_demonstrates_viability` | Art 40(2) | `eu_reg_2024_1774_art_40_2` | `continuity_plan_testing_demonstrates_viability_and_finds_deficiencies` | none |
| 23 | `continuity_test_results_and_deficiencies` | Art 40(3) | `eu_reg_2024_1774_art_40_3` | `continuity_test_results_documented_and_deficiencies_reported` | none |
| 24 | `review_report_in_searchable_electronic_format` | Art 41(1) | `eu_reg_2024_1774_art_41_1` | `review_report_submitted_in_searchable_electronic_format` | request |
| 25 | `report_context_description` | Art 41(2)(a)(i) | `eu_reg_2024_1774_art_41_2` | `review_report_describes_context` | request |
| 26 | `report_executive_summary` | Art 41(2)(a)(ii) | `eu_reg_2024_1774_art_41_2` | `review_report_has_executive_summary` | request |
| 27 | `report_reported_area` | Art 41(2)(a)(iii) | `eu_reg_2024_1774_art_41_2` | `review_report_informs_on_reported_area` | request |
| 28 | `report_major_framework_changes` | Art 41(2)(a)(iv) | `eu_reg_2024_1774_art_41_2` | `review_report_summarises_major_framework_changes` | request |
| 29 | `report_impact_of_major_changes` | Art 41(2)(a)(v) | `eu_reg_2024_1774_art_41_2` | `review_report_describes_impact_of_major_changes` | request |
| 30 | `report_approval_date` | Art 41(2)(b) | `eu_reg_2024_1774_art_41_2` | `review_report_states_approval_date_where_applicable` | request |
| 31 | `report_reasons_for_review` | Art 41(2)(c) lead | `eu_reg_2024_1774_art_41_2` | `review_report_describes_reasons_for_review` | request |
| 32 | `report_evidence_of_supervisory_instructions` | Art 41(2)(c)(i) | `eu_reg_2024_1774_art_41_2` | `review_report_gives_evidence_of_supervisory_instructions` | request + supervisory |
| 33 | `report_incidents_and_root_cause_analysis` | Art 41(2)(c)(ii) | `eu_reg_2024_1774_art_41_2` | `review_report_lists_incidents_with_root_cause_analysis` | request + incidents |
| 34 | `report_review_period` | Art 41(2)(d) | `eu_reg_2024_1774_art_41_2` | `review_report_states_review_period` | request |
| 35 | `report_person_responsible` | Art 41(2)(e) | `eu_reg_2024_1774_art_41_2` | `review_report_names_person_responsible` | request |
| 36 | `report_findings_and_self_assessment` | Art 41(2)(f) | `eu_reg_2024_1774_art_41_2` | `review_report_summarises_findings_and_self_assessment` | request |
| 37 | `report_remedying_measures` | Art 41(2)(g) | `eu_reg_2024_1774_art_41_2` | `review_report_states_remedying_measures` | request |
| 38 | `report_overall_conclusions` | Art 41(2)(h) | `eu_reg_2024_1774_art_41_2` | `review_report_states_overall_conclusions` | request |

Condition triggers:

- request = `authority_requested_framework_review_report`
- supervisory = `framework_review_initiated_following_supervisory_instructions`
- incidents = `framework_review_initiated_following_ict_related_incidents`

The referral citation of each judgement key is its duty's citation key.

### Rules / requirements

All rules are cut-free, and every route is a disjoint clause.

1. **Condition state.**
   - `condition_state(Profile, Trigger, holds)`: the trigger is present and `true`.
   - `condition_state(Profile, Trigger, fails)`: the trigger is present and `false`.
   - `condition_state(Profile, Trigger, open)`: the trigger is absent.
   - There are three mutually exclusive clauses, keyed on `profile_lacks/2` or on the read value.
2. **Defeasible duty applicability (deontic default with defeaters).**
   - Default rule: `duty_applies(Profile, Duty)` holds when the gate holds and `not_defeated(Duty, Profile, duty_defeater)`.
   - `duty_defeater(Duty, Profile)` holds when `once(condition_failing_or_open(Duty, Profile))`. The `once/1` is guarded inside the defeater, so the defeater answers once whatever the number of witnesses.
   - `duty_open(Profile, Duty)`: the gate holds and no condition of the duty fails. This is a second defeater, `condition_failing`, also guarded by `once/1`.
   - `duty_fails(Profile, Duty)`: the duty applies and its key is present and `false`.
3. **Duty key state.** `duty_key_state(Profile, Duty, State)`, with `State` in {`true`, `false`, `unsure`, `absent`}.
4. **Can change the answer (complete query, S2).**
   - (a) Duty key: `key_can_change_answer(Profile, Key)` when `Key` is the absent key of an open duty D, and no false-keyed duty E has all its conditions in holds ∪ conds(D).
   - (b) Trigger: when `Key` is an absent trigger X, and some open duty D under X has a key that is not true, and no false-keyed duty E without a condition on X has all its conditions in holds ∪ (conds(D) \ {X}).
5. **Decides alone.** `key_decides_alone(Profile, Key)` holds when either:
   - `Key` is the key of a duty that applies; or
   - `Key` is a trigger X and some duty under X has a false key with its other conditions holding.
6. **Which key is named in the complete query.** BEHIND reduces to a simple choice: name the first candidate in key order that decides alone; if none decides alone, name the first candidate.
   - The candidates are gathered with `findall/3` over `contract_key_type/2` order.
   - Two disjoint clauses pick the head element. They are distinguished by whether the deciding-alone list is empty.
7. **Can change the list (outstanding query, M1).** Either:
   - the absent key of an open duty; or
   - an absent trigger that carries a condition of an open duty whose key is not true.
   - The first such key in key order is named.
8. **Required query (R1).** The first absent trigger that carries a condition of an open duty.
9. **Unsure selection.**
   - S3: the first unsure duty key satisfying 4(a) with 'absent' widened to 'unsure'.
   - M2: the first unsure key of an open duty.
10. **Lists.**
    - `applying_duties(Profile, Duties)`: findall in duty order.
    - `failing_duties(Profile, Duties)`: findall in duty order.
    - `duty_citations(Duties, Citations)`: distinct, in first-occurrence order.
11. **Checklist requirement.** `requirement(RequirementId, Profile, Status, Citation)` takes RequirementId FIRST, with one clause per status:
    - `met`: the key is true and the duty applies.
    - `unmet(not_performed(Key))`: the key is false and the duty applies.
    - `unknown([Key])`: the key is absent or unsure, or the duty is open but not applying.
    - `inapplicable`: a condition fails.
    - The same predicate also covers the gate item.

### Verdict atoms produced by this slice

- Step-level facts consumed by queries.clausal:
  - `applies`, `open`, `fails` (duty state);
  - `holds`, `fails`, `open` (condition state).
- Result atoms assembled in queries.clausal: `complete`, `incomplete`, `none_outstanding`, `not_article_16_1_entity`, `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2` with `open_textured/2`.

### Predicates SHARED with other files (only these belong in kernel.clausal)

- `contract_key_type/2` and the input check: shared by every query and the facade.
- `gate_state/2`: shared by the slice, the queries and the compliance check.
- `present_pairs/2`: shared by the S3 and M2 referral routes.
- No other slice exists, so nothing else is shared. The duty table, conditions, citations-per-duty and selection rules stay in this slice.

### Tests (seven modes, v2 manifest)

The slice's tests cover these modes:

1. load;
2. per-rule unit tests: one per duty, plus the gate and the triggers;
3. fixtures;
4. properties: totality, exactly one solution, citations;
5. mutations;
6. contract golds for the three queries and the input check;
7. what-if and compliance-check facade tests.

Every `test(Name, fail)` is paired with a positive test over the same case.

### Fixtures (fixtures.clausal)

- `gate_false`: gives `not_article_16_1_entity`.
- `gate_absent`: gives `indeterminate([financial_entity_is_article_16_1_entity])`.
- `all_performed_no_request`: complete; required lists the 23 duties of Arts 36 to 40.
- `all_performed_request_both_reasons`: complete; required lists 38 duties.
- `request_without_reasons`: required lists 36 duties.
- `one_continuity_duty_false_request_absent`: incomplete, decided before the absent request key is named; outstanding gives `indeterminate([authority_requested_framework_review_report])`.
- `article_41_key_false_request_absent`: complete gives `indeterminate([authority_requested_framework_review_report])`, because the request decides alone.
- `unsure_backup_procedures`: `needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on(Pairs)])`.
- `unknown_microenterprise_key`: `input_problems([unknown_key(financial_entity_is_microenterprise)])`.
- `duplicate_gate`: `input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])`.
- `trigger_unsure`: `input_problems([wrong_type(authority_requested_framework_review_report)])`.
