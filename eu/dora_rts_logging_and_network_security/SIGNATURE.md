# SIGNATURE — eu/dora_rts_logging_and_network_security

## Public query surface

Three contract queries are the scored surface:

- `rts_logging_and_network_security_duties_required/3`
- `rts_logging_and_network_security_duties_complete/3`
- `rts_logging_and_network_security_duties_outstanding/3`

Each has the form `(PROFILE, RESULT, CITATIONS)`. The input check `dora_rts_logging_and_network_security_input_problems/2` sits beside them.

The facade wraps the completeness query for the eligibility and compliance-check query types:

- `decide_dora_rts_logging_and_network_security(PROFILE, dora_rts_logging_and_network_security_verdict(STATUS, CITATIONS))`
- `dora_rts_logging_and_network_security_status(PROFILE, STATUS)`

PROFILE is `[attribute(KEY, VALUE), ...]` and is read ONLY with `profile_get/3`, presence first and then value.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every term, never fails and never raises. The steps of each query are made mutually exclusive by their guards, and every list is built with `findall/3` over the ordered duty table. There is no cut, no `->` and no `*->`. Ground results are folded into clause heads (C17).

No statutory figure is imported or declared. The frequencies are caller judgements, so the parameters module declares no `constant_value`.

## Verdict STATUS atoms (replace the placeholder `required / permitted / not_applicable`)

Final answers:

- `required(DUTIES)`: arity 1; DUTIES is a non-empty list in duty order.
- `simplified_framework_entity`
- `complete`
- `incomplete`
- `none_outstanding`
- `outstanding(DUTIES)`: arity 1; DUTIES is a non-empty list in duty order.

Status compounds (CITATIONS always `[]`):

- `indeterminate([KEY])`: exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`, optionally followed by an unscored `provenance(CLAUSE, CITATIONS)`.
- `input_problems(PROBLEMS)`, where PROBLEMS holds `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

Result constructors are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

`verdict_vocabulary` is: `simplified_framework_entity`, `complete`, `incomplete`, `none_outstanding`, `required`, `outstanding`, `indeterminate`, `needs_legal_review`, `input_problems`. It never contains `true` or `false`.

## Profile keys (root_exports / input_contract order; 38 keys)

There are no numeric keys and no date keys.

### Facts (type `fact`: the atoms `true` or `false`)

1. `financial_entity_is_article_16_1_entity` (the GATE)
2. `financial_entity_is_microenterprise` (TRIGGER of duties 22 and 23)
3. `financial_entity_has_ict_systems_supporting_critical_or_important_functions` (TRIGGER of duty 30)

### Judgements (type `judgement`: the atoms `true`, `false` or `unsure`)

The key numbers run 4 to 38; key N belongs to duty N-3.

4. `logging_procedures_protocols_and_tools_developed_documented_and_implemented`
5. `logging_procedures_identify_logged_events_retention_and_log_data_security`
6. `logging_detail_aligned_with_purpose_and_usage`
7. `logging_covers_access_control_and_identity_management_events`
8. `logging_covers_capacity_management_events`
9. `logging_covers_change_management_events`
10. `logging_covers_ict_operations_events`
11. `logging_covers_network_traffic_events`
12. `logging_systems_and_log_information_protected`
13. `logging_system_failure_detection_measures_in_place`
14. `ict_system_clocks_synchronised_to_reliable_reference_time_source`
15. `log_retention_period_established_taking_into_account_required_considerations`
16. `network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented`
17. `network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile`
18. `network_connections_and_data_flows_documented`
19. `separate_dedicated_administration_network_used`
20. `network_access_controls_identified_and_implemented`
21. `network_connections_encrypted`
22. `networks_designed_in_line_with_ict_security_requirements`
23. `traffic_to_internet_and_external_connections_secured`
24. `firewall_rules_roles_responsibilities_and_steps_identified`
25. `network_architecture_and_security_design_reviewed_once_a_year` (YEARLY)
26. `network_architecture_and_security_design_reviewed_periodically` (PERIODIC)
27. `subnetworks_and_network_components_isolation_measures_in_place`
28. `secure_network_configuration_baseline_and_hardening_implemented`
29. `inactive_system_and_remote_sessions_limited_locked_and_terminated`
30. `network_services_security_measures_and_service_levels_specified`
31. `network_services_provider_type_identified`
32. `firewall_rules_and_connection_filters_reviewed_on_a_regular_basis`
33. `firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months` (SIX-MONTHLY)
34. `information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented`
35. `data_protected_during_network_transmission_with_compliance_assessment`
36. `data_leakage_prevented_and_detected_and_external_transfer_secured`
37. `confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed`
38. `information_in_transit_policies_designed_on_classification_and_risk_assessment`

## Citation-key atoms (citation_vocabulary; canonical lexicon scheme)

- `eu_reg_2022_2554_art_16_1` (gate only)

The thirty-five duty keys, in this fixed order (FIXED35):

1. `eu_reg_2024_1774_art_12_1`
2. `eu_reg_2024_1774_art_12_2_a`
3. `eu_reg_2024_1774_art_12_2_b`
4. `eu_reg_2024_1774_art_12_2_c_i`
5. `eu_reg_2024_1774_art_12_2_c_ii`
6. `eu_reg_2024_1774_art_12_2_c_iii`
7. `eu_reg_2024_1774_art_12_2_c_iv`
8. `eu_reg_2024_1774_art_12_2_c_v`
9. `eu_reg_2024_1774_art_12_2_d`
10. `eu_reg_2024_1774_art_12_2_e`
11. `eu_reg_2024_1774_art_12_2_f`
12. `eu_reg_2024_1774_art_12_2`
13. `eu_reg_2024_1774_art_13`
14. `eu_reg_2024_1774_art_13_a`
15. `eu_reg_2024_1774_art_13_a_i`
16. `eu_reg_2024_1774_art_13_a_ii`
17. `eu_reg_2024_1774_art_13_a_iii`
18. `eu_reg_2024_1774_art_13_b`
19. `eu_reg_2024_1774_art_13_c`
20. `eu_reg_2024_1774_art_13_d`
21. `eu_reg_2024_1774_art_13_e`
22. `eu_reg_2024_1774_art_13_f`
23. `eu_reg_2024_1774_art_13_g`
24. `eu_reg_2024_1774_art_13_h`
25. `eu_reg_2024_1774_art_13_i`
26. `eu_reg_2024_1774_art_13_j`
27. `eu_reg_2024_1774_art_13_k`
28. `eu_reg_2024_1774_art_13_l`
29. `eu_reg_2024_1774_art_13_m_i`
30. `eu_reg_2024_1774_art_13_m_ii`
31. `eu_reg_2024_1774_art_14_1`
32. `eu_reg_2024_1774_art_14_1_a`
33. `eu_reg_2024_1774_art_14_1_b`
34. `eu_reg_2024_1774_art_14_1_c`
35. `eu_reg_2024_1774_art_14_2`

These keys are NOT used: `art_12_2_c` (no key; cited through its points), `art_13_m` and `art_14_1` second sentence. No shortened atom is ever invented.

## Public predicates

- `rts_logging_and_network_security_duties_required(Profile, Result, Citations)`: steps R0, R-G1, R-G2, R1, R2, R3. Result is `required(DUTIES)`, `simplified_framework_entity` or a status. It reads only the gate and the triggers. Cites FIXED35, or `eu_reg_2022_2554_art_16_1`.
- `rts_logging_and_network_security_duties_complete(Profile, Result, Citations)`: steps S0, S-G1, S-G2, S1, S2, S3, S4. Result is `complete`, `incomplete`, `simplified_framework_entity` or a status. Cites FIXED35 for `complete` and `incomplete`, or `eu_reg_2022_2554_art_16_1`.
- `rts_logging_and_network_security_duties_outstanding(Profile, Result, Citations)`: steps M0, M-G1, M-G2, M1, M2, M3. Result is `none_outstanding` (FIXED35), `outstanding(DUTIES)` (the keys of the listed duties), `simplified_framework_entity` or a status.
- `dora_rts_logging_and_network_security_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. Problems is `[]` when the profile is well-formed. Exactly one solution; never fails, never raises.
- `decide_dora_rts_logging_and_network_security(Profile, dora_rts_logging_and_network_security_verdict(Status, Citations))`: the eligibility verdict (#2) and the compliance check (#13). Status and Citations are exactly those of `rts_logging_and_network_security_duties_complete/3` (`complete` is the positive label, `incomplete` the negative one, any status compound the indeterminate one). Cites RTS Art 12 to 14 (FIXED35), or DORA Art 16(1).
- `dora_rts_logging_and_network_security_status(Profile, Status)`: the Status of the verdict above; one solution.
- `dora_rts_logging_and_network_security_checklist(Profile, Checklist)`: justification (#7). If the input check passes and the gate is not true, Checklist is a list of `item(Duty, ItemStatus, Citations)` in duty order, one item for each of the 35 duties. Citations is the duty's list of `cite(KEY)` terms (four for `network_segregation_and_segmentation`). ItemStatus is one of:
  - `met`: the key is `true`;
  - `unmet(not_performed(KEY))`: the key is `false`;
  - `unknown([KEY])`: the key is absent, or `unknown([TRIGGER])` when the trigger is absent;
  - `unknown(unsure(KEY))`: the key is `unsure`;
  - `inapplicable`: the trigger excludes the duty.

  If the gate is true, Checklist is `[item(article_16_1_gate, inapplicable, [cite(eu_reg_2022_2554_art_16_1)])]`. On input problems, Checklist is `[]`. It is built with `eval_requirements/4` over `requirement/4`. It is explanatory only and never decides the verdict.
- `dora_rts_logging_and_network_security_what_if(Profile, Key, Value, Verdict)`: overrides Key with Value, using `profile_set/3` (replacing an existing attribute), and returns the verdict of `decide_dora_rts_logging_and_network_security/2` on the new profile. It is built on `query_combinators:what_if/5` with the closure `decide_dora_rts_logging_and_network_security`. One solution.
- `dora_rts_logging_and_network_security_fixture(Name, Profile)`: named fixture profiles (see fixtures).

## Planned reuse (manifest `uses:`)

### formalize_lib

Imported predicates:

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`: profile access.
- `check_tri/4`: tri-state judgement to item status; no hand-rolled clone (C15).
- `eval_requirements/4`: the checklist; no findall-item clone (R1).
- `not_defeated/3`: the defeasible gate.
- `memberd/2`, `not_member/2`: deterministic membership.
- `item/3`, `attribute/2`, `unmet/1`, `unknown/1`: constructors.

Vocabulary atoms used: `met` and `inapplicable`.

### kit/query_combinators

- `what_if/5` for the what-if predicate.

### validate_props

Used in tests: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

### Considered and not used

- `assess/6`, `decide_labeled/3`: their decision rule would not reproduce the behind rule or the absent-before-unsure order.
- `kit/compliance_lib`: there are no permissions or prohibitions to combine with deny-overrides. Every norm is an obligation, judged directly, so #13 is served by the completeness query.
- `deadline_lib`, `rolling_window`, `datetime`: there are no dates.
- `currency_vocab`, `vat_category`, `country`: not relevant.

### `_common` backbone

None. The recurring duty-table pattern is noted in NOTES.

## Module layout (unchanged file and module names)

The chain is kernel -> citations -> parameters -> dora_rts_logging_and_network_security -> queries -> fixtures -> package facade.

- `kernel.clausal`: the shared floor. It holds only the generic predicates:
  - `attribute_list_well_formed/1`: a proper list, each element `attribute(_, _)` and nonvar, with no partial tail;
  - `identical_key_occurrences/3`: counts occurrences with `==`;
  - `first_occurrence_keys/2`: keys in order of first occurrence, deduplicated with `==`.

  No other predicate is shared, because there is one determination slice.
- `citations.clausal`: `citation_vocabulary` facts for the 36 atoms above, with instrument, article and point.
- `parameters.clausal`: no statutory figures. The module exists only to keep the layout; a header comment says why.
- `dora_rts_logging_and_network_security.clausal`: the determination slice (below).
- `queries.clausal`: the facade queries `decide_*`, `*_status`, `*_checklist` and `*_what_if`, built over the slice.
- `fixtures.clausal`: named profiles.
- The package facade re-exports the root_exports in key order.

## Slice: dora_rts_logging_and_network_security.clausal

### Value facts owned (no numbers; the tables live here)

**`duty(Position, DutyAtom, Citations, ProfileKey, Applicability)`**: 35 rows in DUTY ORDER, positions 1 to 35.

- Applicability is one of:
  - `always`;
  - `when(financial_entity_is_microenterprise, false)` for duty 22;
  - `when(financial_entity_is_microenterprise, true)` for duty 23;
  - `when(financial_entity_has_ict_systems_supporting_critical_or_important_functions, true)` for duty 30.
- Citations is the list of `cite(KEY)` terms from the duty table. Duty 14 has four. Duties 13, 29 and 30 each have `eu_reg_2024_1774_art_13`. Duties 22 and 23 each have `eu_reg_2024_1774_art_13_i`.

**`referral_citation(JudgementKey, cite(KEY))`**: 35 rows, as listed in THE LIMBS. The referral row's `inputs` are all 38 keys.

**`contract_key(Position, Key, Type)`**: 38 rows in root_exports order.

- Type `fact` accepts exactly `true` and `false`.
- Type `judgement` accepts `true`, `false` and `unsure`.
- A value is checked with a nonvar guard followed by `==` against the allowed atoms. A number, a string or an unbound value is wrong_type.

**`fixed_citations(FIXED35)`**: the 35 cites in the order given above.

### Derived predicates (each three-way or disjoint, cut-free)

- `duty_applies(Profile, Duty)`: `always`, or the trigger is present with the value under which the duty applies. Defeasible: guarded by `not_defeated(Duty, Profile, article_16_1_defeater)`.
- `article_16_1_defeater(Duty, Profile)`: `once(profile_get(Profile, financial_entity_is_article_16_1_entity, true))`. This is the guarded `once/1` defeater.
- `duty_open(Profile, Duty)`: the duty is `always`, or its trigger is absent, or the trigger has the duty's value.
- `duty_fails(Profile, Duty)`: `duty_applies` and the key's value is `false`.
- `both_reviews_false(Profile)`: YEARLY is `false` and PERIODIC is `false`.
- `can_still_change(Profile, Key)`, a candidate key:
  - (a) the key of an open duty;
  - (b) `financial_entity_is_microenterprise`, when YEARLY and PERIODIC are not both `true`;
  - (c) the critical-functions trigger, when SIX-MONTHLY is not `true`.

  Not true means `false`, `unsure` or absent.
- `decides_alone(Profile, Key)`:
  - the key of an `always` duty;
  - YEARLY, PERIODIC or SIX-MONTHLY, when its duty applies;
  - the microenterprise trigger, when exactly one of YEARLY and PERIODIC is `false`;
  - the critical-functions trigger, when SIX-MONTHLY is `false`.
- `absent_candidates(Profile, Keys)`: a findall over `contract_key` in order, keeping keys that are absent and `can_still_change`.
- `named_missing_key_complete(Profile, Key)`: the first candidate that decides alone, if there is one; otherwise the first candidate. This is the behind rule, implemented as two disjoint clauses: one where some candidate decides alone, one where none does.
- `named_missing_key_outstanding(Profile, Key)`: the first candidate.
- `first_unsure_open_key(Profile, Key)`: the first judgement key, in order, whose duty is open and whose value is `unsure`.
- `relied_pairs(Profile, Pairs)`: `KEY-VALUE` for each present contract key, in root_exports order, with the value as given.
- `applying_duties(Profile, Duties)` and `failing_duties(Profile, Duties)`: findall over `duty/5` in position order.
- `outstanding_citations(Duties, Cites)`: the union of the duties' citations, each written once, by first occurrence.
- `requirement(DutyAtom, Profile, Status, Citation)`: the checklist requirement. It has three disjoint clauses for met, unmet and unknown, using `check_tri/4`, plus an `inapplicable` clause when the trigger excludes the duty.

### Rules and steps

Each step clause carries the negation of every earlier step's guard, so exactly one clause fires.

**Required (R0..R3)**

- R0: problems are non-empty, giving `input_problems(Problems)`.
- R-G1: the gate is `true`, giving `simplified_framework_entity`.
- R-G2: the gate is absent.
- R1: the microenterprise trigger is absent.
- R2: the critical-functions trigger is absent.
- R3: `required(applying_duties)`, citing FIXED35.

**Complete (S0..S4)**

- S0: input problems.
- S-G1: the gate is `true`.
- S-G2: the gate is absent.
- S1: some duty fails, or both reviews are `false`, giving `incomplete` with FIXED35.
- S2: `named_missing_key_complete`, giving `indeterminate([Key])`.
- S3: `first_unsure_open_key`, giving `needs_legal_review(open_textured(Key, Cite), [inputs_relied_on(Pairs)])`.
- S4: `complete` with FIXED35.

**Outstanding (M0..M3)**

- M0: input problems.
- M-G1: the gate is `true`.
- M-G2: the gate is absent.
- M1: `named_missing_key_outstanding`. A false key does not stop this query.
- M2: `first_unsure_open_key`.
- M3: if `failing_duties` is `[]`, the answer is `none_outstanding` with FIXED35; otherwise `outstanding(Duties)` with `outstanding_citations`.

**Input check**

1. If the profile is not a well-formed attribute list, the answer is `[wrong_type(profile)]`.
2. Otherwise, for each contract key in order: `duplicate_key(K)` if it occurs at least twice (values not read), else `wrong_type(K)` if it is present once and its value is outside its type.
3. Then `unknown_key(K)` for each non-contract key, compared with `==`, in order of first occurrence, once each. Variables and non-atoms are included, reported as given.

### Verdict atoms of the slice

- `simplified_framework_entity`, `complete`, `incomplete`, `none_outstanding`
- `required/1`, `outstanding/1`
- `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`

### Shared with other slices

None. Only the three generic attribute-list helpers in kernel.clausal are used.

## Fixtures and tests (seven test modes)

### Fixtures

The fixtures are `dora_rts_logging_and_network_security_fixture(Name, Profile)`:

- `all_performed_large_entity_with_critical_systems`: `complete`, `none_outstanding`, and 33 required duties.
- `all_performed_microenterprise_without_critical_systems`: `complete`, and 32 + 1 = 33 duties (the periodic review, no six-monthly verification).
- `article_16_1_entity`: `simplified_framework_entity` in every query.
- `gate_missing`: `indeterminate([financial_entity_is_article_16_1_entity])`.
- `one_logging_duty_false_others_absent`: `incomplete`; the outstanding query names the first absent key.
- `both_reviews_false_size_unknown`: `incomplete`.
- `yearly_false_size_unknown`: S2 names `financial_entity_is_microenterprise`, because it decides alone.
- `always_duty_absent_and_size_unknown`: the behind rule; the always-duty key is named.
- `unsure_encryption_all_else_true`: `needs_legal_review` with `cite(eu_reg_2024_1774_art_13_e)` and the full PAIRS.
- `six_monthly_false_without_critical_systems`: `complete`, since the duty does not apply.
- `several_failing`: `outstanding` in duty order, with the union of their citations.
- Malformed profiles for the input check:
  - a duplicate key;
  - a wrong type (`unsure` for a fact, a number, a string, an unbound value);
  - unknown keys (including variable keys);
  - a non-list profile, a partial list and a list with a bad element.

### Test modes

1. Per-rule unit tests for each duty and each step.
2. Golden results for the three queries.
3. Citation completeness (`prop_citation_complete/3`, `bad_citation/1`).
4. Totality and exactly-one-solution (`prop_totality/3`, `prop_determinism/3`; `findall` length 1).
5. Missing-key coverage (`prop_missing_key_coverage/3`).
6. The input check.
7. What-if and checklist justification. Every negative test is paired with a positive one over the same case.
