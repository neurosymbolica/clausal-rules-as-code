# SIGNATURE — eu/dora_rts_ict_operations_and_capacity

The package layout is unchanged:

`kernel -> citations -> parameters -> dora_rts_ict_operations_and_capacity -> queries -> fixtures -> package facade`

There is ONE determination slice, `dora_rts_ict_operations_and_capacity.clausal`. The manifest is v2 and there are seven test modes.

## Global contracts

- Every public predicate yields EXACTLY ONE solution for every term. The scorer collects all solutions, so a duplicate counts as wrong.
- Clauses are disjoint by guards. There is no `!`, `->` or `*->`, and ground outputs are folded into heads (C17).
- Defeaters are guarded with `once/1`.
- No public predicate returns a float, a string or a record.
- The profile is read ONLY with `profile_get/3`, presence first and then value.
- Booleans are the atoms `true` and `false`. There are no numeric keys.

## Verdict STATUS atoms (replace the scaffold placeholders)

The placeholders `required`, `permitted` and `not_applicable` are removed. The RESULT forms are as follows.

Final answers:

- `required(Duties)`, arity 1, from the required query. Duties is a non-empty list in duty order.
- `complete` and `incomplete`, from the complete query.
- `none_outstanding` and `outstanding(Duties)`, arity 1, from the outstanding query. Duties is a non-empty list in duty order.
- `simplified_framework_entity`, from all three queries when the gate is true.

Status compounds (never final; CITATIONS is always `[]`):

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is NEVER written, because of the atom-shadowing trap.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`. An unscored `provenance(Clause, Citations)` item may follow the `inputs_relied_on` item; it is omitted in this order.
- `input_problems(Problems)`. Problems holds `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

Result constructors are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.

Checklist item statuses come from the formalize_lib vocabulary: `met`, `unmet(not_performed(Key))`, and `unknown([Key])`.

## Profile keys (27, in root_exports / input_contract order)

The two crisp facts take the type `fact`, which is `boolean`: the atoms true and false only.

1. `financial_entity_is_article_16_1_entity` (the GATE)
2. `development_or_testing_performed_in_production_environment` (the TRIGGER; PRODUCTION means this key is true)

The twenty-five judgement keys take the type `judgement`, which is `one_of(boolean, unsure)`: the atoms true, false and unsure.

3. `ict_operations_policies_and_procedures_developed_documented_and_implemented`
4. `ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets`
5. `ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems`
6. `ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets`
7. `ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems`
8. `ict_operations_policies_cover_backup_and_restore_requirements`
9. `ict_operations_policies_cover_scheduling_requirements_considering_interdependencies`
10. `ict_operations_policies_cover_audit_trail_and_system_log_protocols`
11. `ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption`
12. `ict_operations_policies_cover_separation_of_production_from_non_production_environments`
13. `ict_operations_policies_cover_development_and_testing_in_separated_environments`
14. `ict_operations_policies_cover_development_and_testing_in_production_environments`
15. `ict_operations_policies_cover_error_handling_procedures_and_protocols`
16. `ict_operations_policies_cover_support_and_escalation_contacts`
17. `ict_operations_policies_cover_restart_rollback_and_recovery_procedures`
18. `environment_separation_considers_all_components_of_the_environment`
19. `production_testing_instances_identified_reasoned_time_limited_and_approved`
20. `security_of_ict_systems_and_production_data_ensured_during_production_testing`
21. `capacity_and_performance_management_procedures_developed_documented_and_implemented`
22. `capacity_procedures_identify_capacity_requirements_of_ict_systems`
23. `capacity_procedures_apply_resource_optimisation`
24. `capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems`
25. `capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems`
26. `capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages`
27. `capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems`

There are no money, number or date keys. No attested wrapper is used: ruling 2 is not applied, and <<DNUM>>, <<DNUM>> and <<DNUM>> do not arise.

## Citation-key atoms (citation_vocabulary, canonical lexicon scheme)

The gate:

- `eu_reg_2022_2554_art_16_1`

The four paragraph keys, which are also THE FIXED CITATIONS:

- `eu_reg_2024_1774_art_8_1`
- `eu_reg_2024_1774_art_8_2`
- `eu_reg_2024_1774_art_9_1`
- `eu_reg_2024_1774_art_9_2`

The point keys:

- Art 8(2)(a): `eu_reg_2024_1774_art_8_2_a_i`, `eu_reg_2024_1774_art_8_2_a_ii`, `eu_reg_2024_1774_art_8_2_a_iii`
- Art 8(2)(b): `eu_reg_2024_1774_art_8_2_b_i`, `eu_reg_2024_1774_art_8_2_b_ii`, `eu_reg_2024_1774_art_8_2_b_iii`, `eu_reg_2024_1774_art_8_2_b_iv`, `eu_reg_2024_1774_art_8_2_b_v`, `eu_reg_2024_1774_art_8_2_b_vi`, `eu_reg_2024_1774_art_8_2_b_vii`
- Art 8(2)(c): `eu_reg_2024_1774_art_8_2_c_i`, `eu_reg_2024_1774_art_8_2_c_ii`, `eu_reg_2024_1774_art_8_2_c_iii`
- Art 9(1): `eu_reg_2024_1774_art_9_1_a`, `eu_reg_2024_1774_art_9_1_b`, `eu_reg_2024_1774_art_9_1_c_i`, `eu_reg_2024_1774_art_9_1_c_ii`, `eu_reg_2024_1774_art_9_1_c_iii`

No shortened citation atom is ever invented. Every citation is written `cite(Key)`.

## Public predicates

### Contract queries (names fixed by THE CALLED CONTRACT)

- `rts_ict_operations_and_capacity_duties_required(Profile, Result, Citations)`: which duties apply.
  - Result: `required(Duties)` | `simplified_framework_entity` | a status compound.
  - Reads the gate and the trigger only.
  - Citations: the four fixed paragraph keys, or `cite(eu_reg_2022_2554_art_16_1)` when the gate is true.
  - Cites RTS 2024/1774 Arts 8(1), 8(2), 9(1) and 9(2), and DORA Art 16(1).
- `rts_ict_operations_and_capacity_duties_complete(Profile, Result, Citations)`: compliance check of the entity's current state.
  - Result: `complete` | `incomplete` | `simplified_framework_entity` | a status compound.
  - Citations: the fixed four for `complete` and `incomplete`.
  - Cites RTS 2024/1774 Arts 8 and 9, and DORA Art 16(1).
  - Query type #13.
- `rts_ict_operations_and_capacity_duties_outstanding(Profile, Result, Citations)`: the outstanding duties.
  - Result: `none_outstanding` (with the fixed four) | `outstanding(Duties)` (with each outstanding duty's own key, written once) | `simplified_framework_entity` | a status compound.
  - Cites RTS 2024/1774 Arts 8 and 9, and DORA Art 16(1).
- `dora_rts_ict_operations_and_capacity_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - Problems is `[]` or the ordered problem list.
  - It never fails and never raises.
  - Cites the typed input_contract.

### Facade (scaffold names kept)

- `decide_dora_rts_ict_operations_and_capacity(Profile, dora_rts_ict_operations_and_capacity_verdict(Status, Citations))`: the verdict. It delegates to the complete query; Status is its Result and Citations its Citations. This serves query types #2 and #13, and cites RTS 2024/1774 Arts 8 and 9 and DORA Art 16(1).
- `dora_rts_ict_operations_and_capacity_status(Profile, Status)`: Status alone, taken from the decide verdict. Same citations.
- `dora_rts_ict_operations_and_capacity_checklist(Profile, Checklist)`: the justification, query type #7.
  - Each item is `item(DutyAtom, ItemStatus, cite(CitationKey))`.
  - One item per OPEN duty, in duty order, built with `eval_requirements/4` over the injected `requirement/4` closure.
  - The duty-18 item, when the trigger is absent, is `unknown([development_or_testing_performed_in_production_environment])`.
  - The checklist is `[]` when there are input problems, when the gate is true, or when the gate is absent.
  - Met items carry `cite(...)` too.
- `dora_rts_ict_operations_and_capacity_what_if(Profile, Key, Value, Result)`: Result is the complete-query Result for the profile with `Key` set to `Value`. It uses `what_if/5` from `kit/query_combinators` with the closure `decide_result`, and `override_key` semantics: it replaces the key or adds it. Cites RTS 2024/1774 Arts 8 and 9.
- Fixtures:
  - `dora_rts_ict_operations_and_capacity_fixture(FixtureName, Profile)` gives the named cases.
  - `dora_rts_ict_operations_and_capacity_fixture_expected(FixtureName, QueryName, Result, Citations)` gives their expected answers.
  - The cases are:
    - gate true;
    - gate absent;
    - all true without production;
    - all true with production;
    - production absent and duty-18 false;
    - one always-duty false with others absent;
    - an unsure always-duty;
    - duty-18 unsure with production;
    - duplicate key;
    - wrong type;
    - unknown variable key;
    - non-list profile;
    - several outstanding.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:

- `profile_get/3`, `profile_has/2` and `profile_lacks/2` for all profile access.
- `check_tri/4` for the tri-state duty items. The authoring phase verifies how it maps unsure; if needed it is wrapped, never cloned (C15).
- `eval_requirements/4` for the checklist, avoiding R1.
- `not_defeated/3` for the Art 16(1) defeater, and `first_applicable/2` where useful.
- `memberd/2` and `not_member/2`.
- The vocabulary atoms `attribute/2`, `item/3`, `unmet/1` and `unknown/1`.

From `kit/query_combinators`:

- `what_if/5` and `override_key/4` for the what-if facade.

From `validate_props`, for the test modes:

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `bad_citation/1`.

Modules not used:

- `kit/compliance_lib`: there is no action-modality lattice here. Obligations are checked state-wise per THE LIMBS.
- `assess/6`: its decision would emit the bare atom `indeterminate`, which is forbidden.
- `deadline_lib`, `datetime` and `rolling_window`: there is no time.
- `currency_vocab`, `vat_category` and `country`: irrelevant.

## Slice: dora_rts_ict_operations_and_capacity.clausal

### VALUE facts it owns

There are no numeric thresholds, periods or `constant_value` figures. The statutory tables live in this file:

- `duty_row(Position, DutyAtom, ProfileKey, CitationKey, ParagraphKey, Conditions)`: 25 rows in DUTY ORDER, from 1 to 25 as in NOTES.md. Conditions is `[]` for 24 rows and `[condition(development_or_testing_performed_in_production_environment, true)]` for row 18 (`security_during_production_testing`).
  - Paragraph keys:
    - rows 1 and 2: art_8_1;
    - rows 3 to 18: art_8_2;
    - rows 19 to 24: art_9_1;
    - row 25: art_9_2.
  - The citation key is the point key for rows 3 to 15 and 20 to 24, and the paragraph key for rows 1, 2, 16 to 19 and 25.
- `fixed_citations([cite(eu_reg_2024_1774_art_8_1), cite(eu_reg_2024_1774_art_8_2), cite(eu_reg_2024_1774_art_9_1), cite(eu_reg_2024_1774_art_9_2)])`.
- `referral_row(JudgementKey, cite(CitationKey), Inputs)`: one per judgement key. The citation is the duty's citation key. Inputs is all 27 keys in root_exports order.
- `gate_key(financial_entity_is_article_16_1_entity)` and `trigger_key(development_or_testing_performed_in_production_environment)`.

### Rules and requirements

The building blocks:

- `requirement(DutyAtom, Profile, Status, Citation)`: the checklist closure, RequirementId first. It has three disjoint clauses, met, unmet and unknown, built on `check_tri/4`.
- Condition state: `condition_holds`, `condition_fails` and `condition_open`, by the presence and value of the trigger.
- Duty state: `duty_applies`, `duty_open` and `duty_fails`.
- Defeater: `article_16_1_defeater(Profile)` is guarded with `once(profile_get(Profile, financial_entity_is_article_16_1_entity, true))`. `not_defeated/3` gates every duty.

Required query:

1. R0: input problems.
2. R-G1: gate true gives `simplified_framework_entity`.
3. R-G2: gate absent gives `indeterminate([gate])`.
4. R1: trigger absent gives `indeterminate([trigger])`.
5. R2: `required(Duties)`. Duties is the 24 always-duties, plus duty 18 inserted at position 18 when the trigger is true. Citations are the fixed four.

Complete query:

1. S0, S-G1 and S-G2 as in the required query.
2. S1: if any always-duty key is false, or the trigger is true and the duty-18 key is false, the answer is `incomplete` with the fixed four.
3. S2: the absent key named. Its concrete resolution for this order's single trigger:
   - If the duty-18 key is false and the trigger is absent: name the trigger. It decides alone and is key 2.
   - Otherwise, if an always-duty key is absent: name the first such key in root_exports order. The trigger and the duty-18 key are behind it.
   - Otherwise, if the trigger is absent and the duty-18 key is unsure or absent: name the trigger. Neither key is behind the other, and the trigger comes first.
   - Otherwise, if the trigger is true and the duty-18 key is absent: name the duty-18 key.
4. S3: the first unsure judgement key, among the always-duties and duty 18 when the trigger is true, gives `needs_legal_review` with `open_textured(Key, Citation)` from its `referral_row` and Pairs = every present Key-Value pair in root_exports order.
5. S4: `complete` with the fixed four.

Outstanding query:

1. M0, M-G1 and M-G2 as above.
2. M1: the absent key named.
   - If the trigger is absent and the duty-18 key is not true: the first in root_exports order among the trigger and the absent always-duty keys. That is the trigger, since it is key 2. The duty-18 key is behind the trigger.
   - Otherwise: the first absent key of an open duty.
3. M2: the first unsure judgement key of an open duty gives `needs_legal_review`, with Pairs as above.
4. M3: the duties that fail, in duty order. Empty gives `none_outstanding` with the fixed four. Otherwise `outstanding(Duties)` with each duty's citation key, written once.

General form: the S2 and M1 selections are implemented as one generic `can_still_change/3`, `decides_alone/2` and `behind/3` per THE LIMBS. The concrete cases above are acceptance tests for it.

### Verdict atoms

`required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`, plus the status compounds above.

### Shared with kernel.clausal (and only this)

- `contract_key(Position, Key, Type)`: the 27-row typed contract, with Type being `fact` or `judgement`.
- `type_admits(Type, Value)`: fact admits true and false; judgement admits true, false and unsure. An unbound value is never admitted.
- `dora_rts_ict_operations_and_capacity_input_problems(Profile, Problems)`, which works in this order:
  1. Check the attribute-list shape: a variable, a partial list, an unbound element or a non-attribute element gives `[wrong_type(profile)]`.
  2. For each contract key in order, report `duplicate_key` when the key occurs twice or more by `==` (values not read); otherwise `wrong_type` when the value is not admitted.
  3. Then report `unknown_key` for each non-contract key in first-occurrence order, deduplicated by `==`, with the value never checked and a variable reported as itself.
- `present_pairs(Profile, Pairs)`: the Key-Value pairs in contract order, for `inputs_relied_on`.

### Tests (seven modes)

- Per-duty tests: true, false, unsure and absent for each key, against each query.
- Gate tests.
- Trigger matrix for duty 18 crossed with the key values.
- <<DNUM>> ordering cases.
- Input check edge cases: a variable key, distinct variables, 7 versus 7.0, a float value, an unbound value, a duplicate with equal values.
- Exactly-one-solution checks via `findall` and `length` equal to 1.
- Citation completeness via `bad_citation/1`.
- Every negative test is paired with a positive one over the same case.
