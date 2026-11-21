# SIGNATURE — eu/dora_ict_risk_governance_and_framework

## Query surface

The order has three called queries and an input check. Each takes `PROFILE` and yields EXACTLY ONE solution:

- `ict_risk_governance_duties_required(PROFILE, RESULT, CITATIONS)`
- `ict_risk_governance_duties_complete(PROFILE, RESULT, CITATIONS)`
- `ict_risk_governance_duties_outstanding(PROFILE, RESULT, CITATIONS)`
- `dora_ict_risk_governance_and_framework_input_problems(PROFILE, PROBLEMS)`

The scaffold facade is kept as follows:

- `decide_dora_ict_risk_governance_and_framework(PROFILE, dora_ict_risk_governance_and_framework_verdict(STATUS, CITATIONS))` is the complete query.
- `dora_ict_risk_governance_and_framework_status(PROFILE, STATUS)` projects its STATUS.

Other contract rules:

- `PROFILE` is an attribute list `[attribute(KEY, VALUE), ...]`. It is read only with `profile_get/3`, presence first.
- Totality: every call of every public predicate succeeds once, whatever term is passed. The input check never fails and never raises.
- Determinism: one solution per call, checked by `prop_determinism/3`.
- No figure is imported or declared. The order has no numeric values.
- No public predicate returns a float, a string or a record.

## Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

| Query | Final RESULT | Non-final RESULT |
|---|---|---|
| required | `required(DUTIES)`, `simplified_framework_entity` | `indeterminate([KEY])`, `input_problems(PROBLEMS)` |
| complete | `complete`, `incomplete`, `simplified_framework_entity` | `indeterminate([KEY])`, `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`, `input_problems(PROBLEMS)` |
| outstanding | `none_outstanding`, `outstanding(DUTIES)`, `simplified_framework_entity` | as for complete |

Rules for these results:

- The bare atom `indeterminate` is NEVER written. This avoids atom-shadowing beside `indeterminate/1`.
- Every non-final RESULT has CITATIONS `[]`.
- `DUTIES` is in DUTY ORDER, and its order is scored.
- `PROBLEMS` is in input-check order, and its order is scored.
- `PAIRS` is in root_exports order, and its order is scored.
- `CITATIONS` is set-like: each term is written once and the order is not scored.
- `CONTEXT` may carry one trailing `provenance(CLAUSE, CITATIONS)`, which is not scored.

The facade STATUS for `dora_ict_risk_governance_and_framework_status/2` is the functor of the complete query's RESULT:

- `complete`
- `incomplete`
- `simplified_framework_entity`
- `indeterminate`
- `needs_legal_review`
- `input_problems`

The value projected is the functor name only. The RESULT keeps the compound.

The eligibility mapping for query type #2 is `labels(complete, indeterminate, incomplete)`:

- positive is `complete`;
- indeterminate is `indeterminate`;
- negative is `incomplete`.

## Result constructors

These are exported and never called as queries:

`required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `dora_ict_risk_governance_and_framework_verdict/2`.

## Profile keys

The forty keys are listed in root_exports and input_contract order. There are no numeric keys and no dates.

**Crisp keys** (the atoms `true` or `false` only; `unsure` is `wrong_type`):

1. `financial_entity_is_article_16_1_entity`
2. `financial_entity_is_microenterprise`
3. `authority_requested_ict_risk_information`
4. `authority_requested_framework_review_report`
5. `major_change_occurred`
6. `entity_operates_legacy_ict_systems`

**Duty keys** (keys 7 to 40, one per duty, in duty order). Every one is a judgement key (`true`, `false` or `unsure`) except key 26, `framework_reviewed_at_least_yearly`, which is crisp.

7. `has_internal_governance_and_control_framework`
8. `management_body_defines_approves_and_oversees_framework`
9. `management_body_bears_ultimate_ict_risk_responsibility`
10. `management_body_put_in_place_data_security_policies`
11. `ict_roles_and_governance_arrangements_set`
12. `management_body_approved_strategy_and_risk_tolerance`
13. `management_body_oversees_continuity_policy_and_plans`
14. `management_body_approves_ict_audit_plans`
15. `management_body_allocates_resilience_budget`
16. `management_body_approves_third_party_policy`
17. `reporting_channels_to_management_body_in_place`
18. `third_party_monitoring_role_established`
19. `management_body_keeps_ict_knowledge_up_to_date`
20. `has_sound_documented_ict_risk_management_framework`
21. `framework_protects_information_and_ict_assets`
22. `minimises_ict_risk_impact`
23. `provided_ict_risk_information_on_request`
24. `independent_ict_risk_control_function_assigned`
25. `risk_control_and_audit_functions_segregated`
26. `framework_reviewed_at_least_yearly` (crisp)
27. `framework_reviewed_periodically`
28. `framework_reviewed_upon_events_and_improved`
29. `review_report_submitted_on_request`
30. `framework_internally_audited`
31. `formal_audit_follow_up_process_established`
32. `resilience_strategy_in_framework`
33. `uses_updated_appropriate_ict_systems`
34. `functions_and_assets_identified_and_classified`
35. `ict_risk_sources_identified_and_assessed`
36. `risk_assessed_upon_major_change`
37. `assets_identified_and_mapped`
38. `third_party_dependencies_identified`
39. `inventories_maintained_and_updated`
40. `legacy_systems_risk_assessed`

Types in the typed input_contract:

- `judgement` is one_of boolean or unsure.
- `fact` is boolean.
- Boolean means the atoms `true` and `false`. It is never a Python boolean or a string.
- `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Citation-key atoms

These use the canonical lexicon scheme of `_lexicon/citations.yaml`. They are never shortened.

| Provision | Citation keys |
|---|---|
| Art 5(1) | `eu_reg_2022_2554_art_5_1` |
| Art 5(2) | `eu_reg_2022_2554_art_5_2` |
| Art 5(2)(a) to (h) | `eu_reg_2022_2554_art_5_2_a`, `eu_reg_2022_2554_art_5_2_b`, `eu_reg_2022_2554_art_5_2_c`, `eu_reg_2022_2554_art_5_2_d`, `eu_reg_2022_2554_art_5_2_e`, `eu_reg_2022_2554_art_5_2_f`, `eu_reg_2022_2554_art_5_2_g`, `eu_reg_2022_2554_art_5_2_h` |
| Art 5(2)(i), with (i) to (iii) | `eu_reg_2022_2554_art_5_2_i`, `eu_reg_2022_2554_art_5_2_i_i`, `eu_reg_2022_2554_art_5_2_i_ii`, `eu_reg_2022_2554_art_5_2_i_iii` |
| Art 5(3) and (4) | `eu_reg_2022_2554_art_5_3`, `eu_reg_2022_2554_art_5_4` |
| Art 6(1) to (8) | `eu_reg_2022_2554_art_6_1`, `eu_reg_2022_2554_art_6_2`, `eu_reg_2022_2554_art_6_3`, `eu_reg_2022_2554_art_6_4`, `eu_reg_2022_2554_art_6_5`, `eu_reg_2022_2554_art_6_6`, `eu_reg_2022_2554_art_6_7`, `eu_reg_2022_2554_art_6_8` |
| Art 6(8)(a) to (h) | `eu_reg_2022_2554_art_6_8_a`, `eu_reg_2022_2554_art_6_8_b`, `eu_reg_2022_2554_art_6_8_c`, `eu_reg_2022_2554_art_6_8_d`, `eu_reg_2022_2554_art_6_8_e`, `eu_reg_2022_2554_art_6_8_f`, `eu_reg_2022_2554_art_6_8_g`, `eu_reg_2022_2554_art_6_8_h` |
| Art 7, with (a) to (d) | `eu_reg_2022_2554_art_7`, `eu_reg_2022_2554_art_7_a`, `eu_reg_2022_2554_art_7_b`, `eu_reg_2022_2554_art_7_c`, `eu_reg_2022_2554_art_7_d` |
| Art 8(1) to (7) | `eu_reg_2022_2554_art_8_1`, `eu_reg_2022_2554_art_8_2`, `eu_reg_2022_2554_art_8_3`, `eu_reg_2022_2554_art_8_4`, `eu_reg_2022_2554_art_8_5`, `eu_reg_2022_2554_art_8_6`, `eu_reg_2022_2554_art_8_7` |
| Art 16(1) | `eu_reg_2022_2554_art_16_1` |

THE FIXED CITATIONS are the twenty paragraph-level keys:

- `art_5_1` to `art_5_4`;
- `art_6_1` to `art_6_8`;
- `art_7`;
- `art_8_1` to `art_8_7`.

Each is written as `cite(eu_reg_2022_2554_...)`. They are used for `complete`, `incomplete` and `none_outstanding`. The point-level keys appear only as duty citations, in `required(...)` and `outstanding(...)`.

## Public predicates

### The three queries and the input check

- `ict_risk_governance_duties_required(Profile, Result, Citations)`: which duties apply, per steps R0 to R5. Reads only the two entity facts and the four triggers, and never refers. Cites the duty citations, or `eu_reg_2022_2554_art_16_1`.
- `ict_risk_governance_duties_complete(Profile, Result, Citations)`: whether all applicable duties are performed, per steps S0 to S7. Cites THE FIXED CITATIONS, or Art 16(1).
- `ict_risk_governance_duties_outstanding(Profile, Result, Citations)`: which applicable duties are not performed, per steps M0 to M5. Cites the duty citations, THE FIXED CITATIONS, or Art 16(1).
- `dora_ict_risk_governance_and_framework_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. Gives `[]`, or ordered `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms, or `[wrong_type(profile)]`. Never fails and never raises.

### Facade

- `decide_dora_ict_risk_governance_and_framework(Profile, Verdict)`: `Verdict = dora_ict_risk_governance_and_framework_verdict(Result, Citations)` from `ict_risk_governance_duties_complete/3` (eligibility, #2). Arts 5 to 8, and Art 16(1).
- `dora_ict_risk_governance_and_framework_status(Profile, Status)`: the functor name of the complete RESULT.
- `dora_ict_risk_governance_and_framework_checklist(Profile, Checklist)` (justification, #7):
  - one `item(Duty, Status, cite(CitationKey))` per duty that APPLIES, in duty order;
  - Status is `met`, `unmet(Reason)` or `unknown([Key])`;
  - built with `assess/6`, passing the requirement closure `dora_ict_risk_governance_and_framework_requirement`;
  - every item carries `cite(...)`, met items included;
  - for duty 11, duty 26 and duty 27 the item cites the paragraph key, and the point keys stay in the duty citation table;
  - `[]` for an Article 16(1) entity, or when a crisp condition key is absent.
- `dora_ict_risk_governance_and_framework_what_if(Profile, Key, Value, Result)`: re-decides with `Key` set to `Value`, through `what_if/5` of kit.query_combinators. The closure is `decide_dora_ict_risk_governance_and_framework`.
- `dora_ict_risk_governance_and_framework_compliance_check(Profile, Action, Verdict)` (compliance check, #13):
  - `Action` is `omit_duty(Duty)` or `perform_duty(Duty)`.
  - Norms: `nm(Duty, obligatory)` when the duty APPLIES. When it does not apply, it is `permitted` either way.
  - Built on `compliance_check/7` of kit/compliance_lib, deny-overrides.
  - An omitted duty that applies is `forbidden`, with the duty citations.
  - A crisp condition key that is absent gives `indeterminate([Key])`.
- `dora_ict_risk_governance_and_framework_fixture(Name, Profile)`: the named test profiles.
- `dora_ict_risk_governance_and_framework_fixture_expected(Name, Query, Result, Citations)`: the expected answers.

### Exported table predicates

These are exported for tests and translation:

- `dora_ict_risk_governance_and_framework_duty(Position, Duty)`
- `dora_ict_risk_governance_and_framework_duty_key(Duty, Key)`
- `dora_ict_risk_governance_and_framework_duty_condition(Duty, Key, Value)`
- `dora_ict_risk_governance_and_framework_duty_citation(Duty, CitationKey)`
- `dora_ict_risk_governance_and_framework_referral_citation(Key, CitationKey)`
- `dora_ict_risk_governance_and_framework_key_type(Key, Type)`

## Planned reuse (manifest `uses:`)

### formalize_lib

- **Profile access:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`.
- **Statuses and checks:** `check_tri/4` gives the tri-state status of each judgement key in the checklist; `check_true/4` covers the crisp `framework_reviewed_at_least_yearly`.
- **Missing keys:** `missing_keys/3` for R4.
- **Checklist engine:** `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `labels/3`, `item/3`.
- **Defeater:** `not_defeated/3`, for the Article 16(1) defeater. Its call is guarded by `once/1`, cut-free.
- **List helpers:** `memberd/2`, `not_member/2`.
- **Constructors:** `attribute/2`, `unmet/1`, `unknown/1`.

No `check_tri` clone and no `eval_requirements` clone is written. This avoids lint rules C15 and R1.

### Kit modules

- **kit/compliance_lib:** `nm/2`, `compliance_check/7`, `verdict/5`.
- **kit/query_combinators:** `what_if/5`, `override_key/4`.
- **validate_props:**
  - `run_props/1` and `prop_totality/3`;
  - `prop_determinism/3`;
  - `prop_citation_complete/3`;
  - `prop_missing_key_coverage/3`, over the forty keys;
  - `bad_citation/1`.
- **Not used:** deadline_lib, rolling_window and datetime. No date is read (reading (15)).

### Family backbone (`_common`)

The deontic duty-table pattern (applies, open, fails) is local. It is noted in NOTES S3 as a candidate for the kit.

## Kernel (`kernel.clausal`): shared floor

There is a single determination slice, so there is NO predicate that must be shared between slices. The kernel keeps its scaffold floor unchanged:

- the module header;
- re-exports of the formalize_lib profile accessors;
- the result constructors listed above.

No domain fact lives in the kernel. `citations.clausal` holds the citation-key vocabulary, and `parameters.clausal` stays empty of figures (no numeric values).

## Slice — `dora_ict_risk_governance_and_framework.clausal`

### Value facts owned

There are no numeric values, so there is no `constant_value/2`. The statutory tables, all in this file, are:

- `dora_ict_risk_governance_and_framework_duty(Position, Duty)`: positions 1 to 34, in duty order.
- `dora_ict_risk_governance_and_framework_duty_key(Duty, Key)`: as in the table below.
- `dora_ict_risk_governance_and_framework_duty_condition(Duty, Key, Value)`: only the conditions beyond `financial_entity_is_article_16_1_entity false`. That condition is carried by the Article 16(1) defeater, not repeated per row.
- `dora_ict_risk_governance_and_framework_duty_citation(Duty, CitationKey)`: one row per citation, as in the table below.
- `dora_ict_risk_governance_and_framework_referral_citation(Key, CitationKey)`: thirty-three rows, one per judgement key, as in THE LIMBS.
- `dora_ict_risk_governance_and_framework_key_type(Key, Type)`: forty rows in root_exports order. The type is `judgement` or `fact`.
- `dora_ict_risk_governance_and_framework_fixed_citation(CitationKey)`: twenty rows.

### Duty table

In the Conditions column, `micro` stands for the key `financial_entity_is_microenterprise`.

| # | Duty | Key | Conditions | Citations |
|---|---|---|---|---|
| 1 | `internal_governance_and_control_framework` | `has_internal_governance_and_control_framework` | always | `art_5_1` |
| 2 | `management_body_framework_responsibility` | `management_body_defines_approves_and_oversees_framework` | always | `art_5_2` |
| 3 | `management_body_ultimate_ict_risk_responsibility` | `management_body_bears_ultimate_ict_risk_responsibility` | always | `art_5_2_a` |
| 4 | `data_security_policies` | `management_body_put_in_place_data_security_policies` | always | `art_5_2_b` |
| 5 | `ict_roles_and_governance_arrangements` | `ict_roles_and_governance_arrangements_set` | always | `art_5_2_c` |
| 6 | `resilience_strategy_and_risk_tolerance_approval` | `management_body_approved_strategy_and_risk_tolerance` | always | `art_5_2_d` |
| 7 | `business_continuity_policy_oversight` | `management_body_oversees_continuity_policy_and_plans` | always | `art_5_2_e` |
| 8 | `ict_audit_plan_approval` | `management_body_approves_ict_audit_plans` | always | `art_5_2_f` |
| 9 | `resilience_budget_allocation` | `management_body_allocates_resilience_budget` | always | `art_5_2_g` |
| 10 | `third_party_policy_approval` | `management_body_approves_third_party_policy` | always | `art_5_2_h` |
| 11 | `management_body_reporting_channels` | `reporting_channels_to_management_body_in_place` | always | `art_5_2_i`, `art_5_2_i_i`, `art_5_2_i_ii`, `art_5_2_i_iii` |
| 12 | `third_party_monitoring_role` | `third_party_monitoring_role_established` | micro false | `art_5_3` |
| 13 | `management_body_ict_knowledge_and_training` | `management_body_keeps_ict_knowledge_up_to_date` | always | `art_5_4` |
| 14 | `ict_risk_management_framework` | `has_sound_documented_ict_risk_management_framework` | always | `art_6_1` |
| 15 | `protection_of_information_and_ict_assets` | `framework_protects_information_and_ict_assets` | always | `art_6_2` |
| 16 | `ict_risk_impact_minimisation` | `minimises_ict_risk_impact` | always | `art_6_3` |
| 17 | `ict_risk_information_to_authority` | `provided_ict_risk_information_on_request` | `authority_requested_ict_risk_information` true | `art_6_3` |
| 18 | `ict_risk_control_function` | `independent_ict_risk_control_function_assigned` | micro false | `art_6_4` |
| 19 | `segregation_of_risk_control_and_audit_functions` | `risk_control_and_audit_functions_segregated` | always | `art_6_4` |
| 20 | `annual_framework_review` | `framework_reviewed_at_least_yearly` (crisp) | micro false | `art_6_5` |
| 21 | `periodic_framework_review` | `framework_reviewed_periodically` | micro true | `art_6_5` |
| 22 | `event_driven_framework_review_and_improvement` | `framework_reviewed_upon_events_and_improved` | always | `art_6_5` |
| 23 | `framework_review_report_to_authority` | `review_report_submitted_on_request` | `authority_requested_framework_review_report` true | `art_6_5` |
| 24 | `internal_audit_of_framework` | `framework_internally_audited` | micro false | `art_6_6` |
| 25 | `audit_follow_up_process` | `formal_audit_follow_up_process_established` | micro false | `art_6_7` |
| 26 | `digital_operational_resilience_strategy` | `resilience_strategy_in_framework` | always | `art_6_8`, `art_6_8_a` to `art_6_8_h` |
| 27 | `ict_systems_protocols_and_tools` | `uses_updated_appropriate_ict_systems` | always | `art_7`, `art_7_a` to `art_7_d` |
| 28 | `identification_and_classification` | `functions_and_assets_identified_and_classified` | always | `art_8_1` |
| 29 | `identification_of_ict_risk_sources` | `ict_risk_sources_identified_and_assessed` | always | `art_8_2` |
| 30 | `risk_assessment_upon_major_change` | `risk_assessed_upon_major_change` | micro false, `major_change_occurred` true | `art_8_3` |
| 31 | `asset_identification_and_mapping` | `assets_identified_and_mapped` | always | `art_8_4` |
| 32 | `third_party_dependency_identification` | `third_party_dependencies_identified` | always | `art_8_5` |
| 33 | `inventories_maintained` | `inventories_maintained_and_updated` | always | `art_8_6` |
| 34 | `legacy_systems_risk_assessment` | `legacy_systems_risk_assessed` | micro false, `entity_operates_legacy_ict_systems` true | `art_8_7` |

Every citation in the table is prefixed `eu_reg_2022_2554_`. Twenty-four duties apply always (when not an Article 16(1) entity).

### Rules (local helpers, all prefixed `dora_ict_risk_governance_and_framework_`)

**Conditions**

- `condition_holds(Profile, Key, Value)`: Key is present with Value.
- `condition_fails(Profile, Key, Value)`: Key is present with the other boolean.
- `condition_open(Profile, Key)`: Key is absent.

**Defeater**

- `article_16_1_defeater(Profile)`: `financial_entity_is_article_16_1_entity` is present and `true`.
- Each duty is defeasible. `duty_applies` is reached only through `not_defeated/3` with this defeater, under guarded `once/1`.

**Duty status**

- `duty_applies(Profile, Duty)`: all conditions hold, and the duty is not defeated.
- `duty_open(Profile, Duty)`: no condition fails, and the duty is not defeated.
- `duty_fails(Profile, Duty)`: the duty applies and its key is `false`.
- `key_not_true(Profile, Key)`: the key is `false`, `unsure` or absent.

**Step S4**

- `microenterprise_settles_incomplete(Profile)`: `financial_entity_is_microenterprise` is absent, and for EACH of `true` and `false` some duty whose key is `false` has that value as a condition, with every other condition holding.

**Step S6: changing the answer**

- `key_can_change_answer(Profile, Key)`, case (a): Key is the key of an open duty D, and no other false-keyed duty has each of its conditions holding or among D's conditions.
- `key_can_change_answer(Profile, Key)`, case (b): Key is a condition key X with a value V such that both of the following hold:
  - some open duty D with condition X V has a key that is not true;
  - no other false-keyed duty, without condition X V, has each of its conditions other than those on X holding or among D's conditions.

**Step S6: choosing the key to name**

- `key_decides_alone(Profile, Key)` holds in either of two cases:
  - Key is the key of a duty that applies;
  - Key is a condition key X where, for one of its values, some false-keyed duty has that value as a condition and every other condition holding.
- `key_behind(Profile, KeyX, KeyY)`: KeyY decides alone and KeyX does not.
- `first_named_key(Profile, CandidateKeys, Key)`: the first key in root_exports order among the candidates that is not behind another candidate.

**Step M3: changing the list**

- `key_can_change_list(Profile, Key)` holds in either of two cases:
  - Key is the key of an open duty;
  - Key is a condition of some open duty whose key is not true.

**Results and citations**

- `pairs_relied_on(Profile, Pairs)`: the `KEY-VALUE` pairs present in Profile, for all forty keys, in root_exports order, with the values exactly as given.
- `duty_citations(Duties, Citations)`: the `cite(KEY)` terms of the listed duties, each written once.

**Checklist**

- `requirement(Duty, Profile, Status, Citation)`: the closure for `assess/6`, with RequirementId FIRST.
  - Three mutually exclusive clauses, through `check_tri/4`: met, `unmet`, `unknown`.
  - For an `unsure` key it gives `unknown([Key])`.

**Input check**

- `input_problems_of(Profile, Problems)`.
  - The profile shape is checked first: an unbound profile, a partial list, an unbound element, or an element other than `attribute/2` gives `[wrong_type(profile)]`.
  - Then, per contract key in order, `duplicate_key(Key)` (identity `==`), else `wrong_type(Key)`.
  - Then `unknown_key(Key)` per non-contract key, by first occurrence. A non-atom key or a variable key is reported as given.

### Step order per query

Each step is one clause, guarded by the negation of all earlier steps. The ground result is folded into the clause head (C17).

**Required**

- R0 `input_problems(Problems)`.
- R1 `indeterminate([financial_entity_is_article_16_1_entity])`.
- R2 `simplified_framework_entity` with `[cite(eu_reg_2022_2554_art_16_1)]`.
- R3 `indeterminate([financial_entity_is_microenterprise])`.
- R4 `indeterminate([Key])`: the first absent key among the two request triggers, and, for a microenterprise `false`, the two event triggers.
- R5 `required(Duties)` with the duty citations.

**Complete**

- S0 input problems.
- S1 the Article 16(1) key absent.
- S2 `simplified_framework_entity`.
- S3 `incomplete` with THE FIXED CITATIONS, when some duty fails.
- S4 `incomplete` with THE FIXED CITATIONS, when the microenterprise key settles it.
- S5 `complete` with THE FIXED CITATIONS, when no open duty has a key that is not true.
- S6 `indeterminate([Key])`, Key from `first_named_key` over the absent keys that can change the answer.
- S7 `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`, for the first unsure judgement key that can change the answer by S6 (a).

**Outstanding**

- M0, M1 and M2 as S0 to S2.
- M3 `indeterminate([Key])`, for the first absent key that can change the list.
- M4 `needs_legal_review(...)`, for the first unsure key of an open duty.
- M5 `none_outstanding` with THE FIXED CITATIONS, or `outstanding(Duties)` with the duty citations.

### Verdict atoms of this slice

- Final: `required/1`, `outstanding/1`, `simplified_framework_entity`, `complete`, `incomplete`, `none_outstanding`.
- Status: `indeterminate/1`, `needs_legal_review/2` (reason `open_textured/2` only), `input_problems/1`.

### Shared with another slice

Nothing. This is the only slice, so the kernel receives no predicate.

### Per-rule tests

The tests are planned across seven modes: unit, fixture, property, boundary, mutation, counting and input.

**Final answers**

- `article_16_1_entity`: all queries give `simplified_framework_entity` with `[cite(eu_reg_2022_2554_art_16_1)]`.
- `non_micro_no_triggers_all_true`: required lists 29 duties (24, plus 12, 18, 20, 24 and 25), and complete is `complete`.
- `micro_all_true`: required lists 25 duties (24 plus duty 21), and outstanding is `none_outstanding`.
- `non_micro_all_triggers`: required lists all duties except 21, which is 33 duties.
- `false_duty_with_absent_keys`: S3 gives `incomplete` before any absent key is read.
- `micro_absent_both_ways_fail`: key 18 `false` and key 27 `false` give `incomplete` (S4).

**Missing and unsure keys**

- `micro_absent_behind`: only an always-duty key absent, with the microenterprise key absent. The always-duty key decides alone and is named first. Condition-only keys behind the microenterprise key are not named.
- `unsure_judgement_only`: `needs_legal_review` with ordered PAIRS that include `unsure`.
- `unsure_with_relevant_absent`: the absent key is named before the referral.
- `outstanding_false_does_not_end`: an absent key with another key `false` gives `indeterminate`, not `outstanding`.

**Input check**

- `duplicate_key`;
- `wrong_type` with `unsure` on a crisp key;
- a numeric value 7 or 7.0;
- an unknown key;
- a variable key;
- a non-list profile;
- order of problems.

**Counting**

- `findall` over each query gives length 1.

**Properties**

- totality and determinism over generated profiles;
- citation completeness (every cite in citation_vocabulary);
- missing-key coverage over the forty keys.

**Mutation targets**

- drop the microenterprise condition of duty 25;
- swap duties 20 and 21;
- remove the defeater;
- read the triggers for a microenterprise.
