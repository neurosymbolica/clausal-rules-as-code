# SIGNATURE — eu/dora_ict_risk_protection_and_detection

## Public query surface (summary)

### Contract predicates

The four contract predicates are the called contract. Each yields EXACTLY ONE solution for every term. Each takes only PROFILE.

- `ict_risk_protection_and_detection_duties_required(Profile, Result, Citations)`
- `ict_risk_protection_and_detection_duties_complete(Profile, Result, Citations)`
- `ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations)`
- `dora_ict_risk_protection_and_detection_input_problems(Profile, Problems)`

### Facade

The facade keeps the scaffold names and wraps the completeness query. The answer has the form `decide_dora_ict_risk_protection_and_detection(PROFILE, dora_ict_risk_protection_and_detection_verdict(STATUS, CITATIONS))`.

### Totality and determinism

- Each clause set is guarded by disjoint conditions, with no cut, `->` or `*->`.
- First-match selection is done by building ordered candidate lists over the ordered duty table. One clause matches `[First|_]` and one matches `[]`.
- Defeaters are guarded with `once/1`.
- Nothing is imported from another domain. There are no numeric figures, so no `constant_value` declarations are needed.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

### Final answers

- `required(Duties)`: arity 1, a non-empty list in duty order.
- `simplified_framework_entity`
- `complete`
- `incomplete`
- `none_outstanding`
- `outstanding(Duties)`: arity 1, a non-empty list in duty order.

### Status compounds (CITATIONS always `[]`)

- `indeterminate([Key])`: exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: may optionally carry a trailing unscored `provenance(Clause, Citations)`.
- `input_problems(Problems)`

### Problem terms

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `wrong_type(profile)`

### Result constructors

These are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Atoms that are never pinned

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`. There are no numbers and no dates. The keys follow root_exports and input_contract order.

| # | key | type |
|---|-----|------|
| 1 | financial_entity_is_article_16_1_entity | fact: true / false (the GATE) |
| 2 | dora_entity_type | entity_type enum, 29 atoms (the TRIGGER) |
| 3 | monitors_and_controls_security_and_functioning_of_ict_systems | judgement |
| 4 | deploys_ict_security_tools_policies_and_procedures | judgement |
| 5 | ict_security_policies_procedures_protocols_and_tools_implemented | judgement |
| 6 | uses_appropriate_ict_solutions_and_processes | judgement |
| 7 | ict_solutions_ensure_security_of_data_transfer | judgement |
| 8 | ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws | judgement |
| 9 | ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss | judgement |
| 10 | ict_solutions_protect_data_from_data_management_risks | judgement |
| 11 | information_security_policy_developed_and_documented | judgement |
| 12 | network_and_infrastructure_management_structure_established | judgement |
| 13 | access_limiting_policies_and_access_rights_controls_implemented | judgement |
| 14 | strong_authentication_and_cryptographic_key_protection_implemented | judgement |
| 15 | ict_change_management_policies_procedures_and_controls_implemented | judgement |
| 16 | patch_and_update_policies_documented | judgement |
| 17 | network_connection_infrastructure_can_be_severed_or_segmented | judgement |
| 18 | ict_change_management_process_approved_with_specific_protocols | judgement |
| 19 | anomaly_detection_mechanisms_in_place | judgement |
| 20 | mechanisms_to_identify_single_points_of_failure_in_place | judgement |
| 21 | detection_mechanisms_regularly_tested | judgement |
| 22 | detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts | judgement |
| 23 | sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents | judgement |
| 24 | trade_report_checking_systems_in_place | judgement |

### Value types

- **judgement**: the atom `true`, `false` or `unsure`. In the typed input_contract this is one_of boolean or unsure.
- **fact**: the atom `true` or `false`. In the typed input_contract this is boolean, meaning the two atoms, never a Python boolean.

### entity_type atoms

`credit_institution`, `institution_exempted_pursuant_to_directive_2013_36`, `payment_institution`, `exempted_payment_institution`, `account_information_service_provider`, `electronic_money_institution`, `exempted_electronic_money_institution`, `investment_firm`, `crypto_asset_service_provider`, `issuer_of_asset_referenced_tokens`, `central_securities_depository`, `central_counterparty`, `trading_venue`, `trade_repository`, `manager_of_alternative_investment_funds`, `management_company`, `data_reporting_service_provider`, `insurance_undertaking`, `reinsurance_undertaking`, `insurance_intermediary`, `reinsurance_intermediary`, `ancillary_insurance_intermediary`, `institution_for_occupational_retirement_provision`, `credit_rating_agency`, `administrator_of_critical_benchmarks`, `crowdfunding_service_provider`, `securitisation_repository`, `ict_third_party_service_provider`, `none_of_the_listed_types`.

## Citation-key atoms (canonical `_lexicon/citations.yaml` scheme; citation_vocabulary)

- Article 9: `eu_reg_2022_2554_art_9_1`, `eu_reg_2022_2554_art_9_2`, `eu_reg_2022_2554_art_9_3`, `eu_reg_2022_2554_art_9_3_a`, `eu_reg_2022_2554_art_9_3_b`, `eu_reg_2022_2554_art_9_3_c`, `eu_reg_2022_2554_art_9_3_d`, `eu_reg_2022_2554_art_9_4`, `eu_reg_2022_2554_art_9_4_a`, `eu_reg_2022_2554_art_9_4_b`, `eu_reg_2022_2554_art_9_4_c`, `eu_reg_2022_2554_art_9_4_d`, `eu_reg_2022_2554_art_9_4_e`, `eu_reg_2022_2554_art_9_4_f`
- Article 10: `eu_reg_2022_2554_art_10_1`, `eu_reg_2022_2554_art_10_2`, `eu_reg_2022_2554_art_10_3`, `eu_reg_2022_2554_art_10_4`
- Article 16: `eu_reg_2022_2554_art_16_1`

There are 19 keys in all. No shortened citation atom is ever invented.

### Fixed citation lists

- **The eight paragraph keys**, cited by `complete`, `incomplete` and `none_outstanding`: art_9_1, art_9_2, art_9_3, art_9_4, art_10_1, art_10_2, art_10_3, art_10_4.
- **`required` citations**: the first seven of those, plus art_10_4 when the trigger is true.

## Public predicates

### Contract predicates

- `ict_risk_protection_and_detection_duties_required(Profile, Result, Citations)`
  - Reads the gate and the trigger only. The steps are R0, R-G1, R-G2, R1 and R2.
  - Result is `required(Duties)`, or `simplified_framework_entity`, or a status compound.
  - Cites Art 9(1) to (4), Art 10(1) to (3), Art 10(4) when the trigger is true, and Art 16(1) for the gate.
- `ict_risk_protection_and_detection_duties_complete(Profile, Result, Citations)`
  - Answers the compliance check (#13).
  - The steps are S0, S-G1, S-G2, then S1 fail, S2 absent with the behind rule, S3 unsure, S4 complete.
  - Cites the eight paragraph keys, or Art 16(1).
- `ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations)`
  - The steps are M0, M-G1, M-G2, then M1 absent, M2 unsure, M3 list.
  - `none_outstanding` cites the eight paragraph keys. `outstanding(Duties)` cites the citation keys of the failing duties, once each.
- `dora_ict_risk_protection_and_detection_input_problems(Profile, Problems)`
  - The typed input check. `Problems` is `[]` when the profile is well formed.
  - Precedes every query.

### Facade predicates

- `decide_dora_ict_risk_protection_and_detection(Profile, Verdict)`
  - `Verdict` is `dora_ict_risk_protection_and_detection_verdict(Result, Citations)`, the result of the completeness query.
  - Answers the eligibility verdict (#2): `complete` is the positive label, a status compound the indeterminate label, and `incomplete` the negative label.
  - Cites as the completeness query.
- `dora_ict_risk_protection_and_detection_status(Profile, Status)`
  - `Status` is the Result of the completeness query.
  - Cites Art 9, Art 10 and Art 16(1) through the verdict.
- `dora_ict_risk_protection_and_detection_checklist(Profile, Checklist)`
  - Answers justification (#7).
  - Checklist items are `item(Duty, Status, cite(CitationKey))`, one per duty in duty order, for duties not inapplicable. `Status` is one of:
    - `met`: key true.
    - `unmet(not_performed)`: key false.
    - `unknown([Key])`: key absent or unsure.
  - The Art 10(4) duty is handled as follows:
    - trigger absent: `item(trade_report_checking_systems, unknown([dora_entity_type]), cite(eu_reg_2022_2554_art_10_4))`;
    - trigger false: omitted;
    - gate true, gate absent, or input problems: the checklist is `[]`.
  - Built with `eval_requirements/4` over `dora_ict_risk_protection_and_detection_requirement/4`. Each duty row carries its own cite.
- `dora_ict_risk_protection_and_detection_what_if(Profile, Key, Value, Verdict)`
  - Computes the verdict of `decide_...` on Profile with `attribute(Key, Value)` replacing any entry for Key, using `profile_set/3`.
  - Yields exactly one solution.
  - Cites as `decide_...`.
- `dora_ict_risk_protection_and_detection_fixture(Name, Profile, Expectations)`
  - Named test profiles. `Expectations` is the list `[required(R, C), complete(R, C), outstanding(R, C), problems(P)]`.
  - Cites through its expected citations.

## Planned reuse (manifest `uses:`)

### formalize_lib

- `profile_get/3`: the only profile reader.
- `profile_has/2` and `profile_lacks/2`.
- `profile_set/3`: used by what_if.
- `eval_requirements/4` and `item/3`: the checklist, with no hand-rolled findall clone (R1).
- `not_defeated/3`: the defeasible duty rule, defeated by the Art 16(1) gate through a once/1-guarded defeater.
- `labels/3` and `classify_labeled/4`: the eligibility labelling of the checklist summary.
- `summarize/3`, `has_unmet/1`, `has_unknown/1`.
- `memberd/2`, `not_member/2`.
- Vocabulary atoms `met`, `applicable`, `inapplicable`.

`check_tri/4` is NOT used, because the judgement keys carry a fourth state, `unsure`. The local reader is recorded in NOTES S5.

### Other modules

- **kit/query_combinators**: `diff_checklists/3` in tests, to show what_if deltas.
- **validate_props** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used**:
  - kit/compliance_lib: its deny-overrides modality lattice does not fit a duty checklist with unsure referral. The compliance check is the completeness query.
  - deadline_lib, rolling_window, date_time: no time is read.
  - currency_vocab, vat_category, country.

## Layout (kept): kernel -> citations -> parameters -> dora_ict_risk_protection_and_detection -> queries -> fixtures -> facade

- **kernel.clausal**: the scaffold floor only, re-exporting the formalize_lib profile access. There is ONE determination slice, so no domain predicate is shared and nothing domain-specific moves into the kernel.
- **citations.clausal**: the 19 `citation_vocabulary` facts, `dora_ict_risk_protection_and_detection_citation(Key)`.
- **parameters.clausal**: no statutory figures. It declares only the 29 entity_type atoms and the three judgement atoms as typed contract vocabulary.
- **queries.clausal**: re-exports the four contract predicates and the facade queries.
- **fixtures.clausal**: fixture profiles covering every step of every query.

## Slice: dora_ict_risk_protection_and_detection.clausal

### Value facts it owns

There are no numeric thresholds, periods or tables of amounts. Tables:

- `dora_ict_risk_protection_and_detection_profile_key(Position, Key, Type)`: 24 rows in root order. `Type` is `fact`, `entity_type` or `judgement`.
- `dora_ict_risk_protection_and_detection_entity_type_atom(Atom)`: 29 rows.
- `dora_ict_risk_protection_and_detection_duty(Position, Duty, Key, CitationKey, Applicability)`: 22 rows in duty order. `Applicability` is `always`, or `when_data_reporting_service_provider` for row 22.

| position | duty atom | key | citation key | applies |
|---|---|---|---|---|
| 1 | monitoring_and_control_of_ict_systems | monitors_and_controls_security_and_functioning_of_ict_systems | eu_reg_2022_2554_art_9_1 | always |
| 2 | ict_security_tools_policies_and_procedures | deploys_ict_security_tools_policies_and_procedures | eu_reg_2022_2554_art_9_1 | always |
| 3 | ict_security_policies_procedures_protocols_and_tools | ict_security_policies_procedures_protocols_and_tools_implemented | eu_reg_2022_2554_art_9_2 | always |
| 4 | appropriate_ict_solutions_and_processes | uses_appropriate_ict_solutions_and_processes | eu_reg_2022_2554_art_9_3 | always |
| 5 | security_of_data_transfer | ict_solutions_ensure_security_of_data_transfer | eu_reg_2022_2554_art_9_3_a | always |
| 6 | minimised_data_corruption_loss_and_unauthorised_access | ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws | eu_reg_2022_2554_art_9_3_b | always |
| 7 | prevention_of_unavailability_impairment_breaches_and_loss | ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss | eu_reg_2022_2554_art_9_3_c | always |
| 8 | protection_from_data_management_risks | ict_solutions_protect_data_from_data_management_risks | eu_reg_2022_2554_art_9_3_d | always |
| 9 | information_security_policy | information_security_policy_developed_and_documented | eu_reg_2022_2554_art_9_4_a | always |
| 10 | network_and_infrastructure_management | network_and_infrastructure_management_structure_established | eu_reg_2022_2554_art_9_4_b | always |
| 11 | access_control_policies | access_limiting_policies_and_access_rights_controls_implemented | eu_reg_2022_2554_art_9_4_c | always |
| 12 | strong_authentication_and_cryptographic_key_protection | strong_authentication_and_cryptographic_key_protection_implemented | eu_reg_2022_2554_art_9_4_d | always |
| 13 | ict_change_management | ict_change_management_policies_procedures_and_controls_implemented | eu_reg_2022_2554_art_9_4_e | always |
| 14 | patch_and_update_policies | patch_and_update_policies_documented | eu_reg_2022_2554_art_9_4_f | always |
| 15 | severable_network_connection_infrastructure | network_connection_infrastructure_can_be_severed_or_segmented | eu_reg_2022_2554_art_9_4 | always |
| 16 | approved_ict_change_management_process | ict_change_management_process_approved_with_specific_protocols | eu_reg_2022_2554_art_9_4 | always |
| 17 | anomaly_detection_mechanisms | anomaly_detection_mechanisms_in_place | eu_reg_2022_2554_art_10_1 | always |
| 18 | single_point_of_failure_identification | mechanisms_to_identify_single_points_of_failure_in_place | eu_reg_2022_2554_art_10_1 | always |
| 19 | regular_testing_of_detection_mechanisms | detection_mechanisms_regularly_tested | eu_reg_2022_2554_art_10_1 | always |
| 20 | detection_control_layers_alert_thresholds_and_automatic_alerts | detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts | eu_reg_2022_2554_art_10_2 | always |
| 21 | resources_to_monitor_user_activity_anomalies_and_incidents | sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents | eu_reg_2022_2554_art_10_3 | always |
| 22 | trade_report_checking_systems | trade_report_checking_systems_in_place | eu_reg_2022_2554_art_10_4 | trigger true |

The referral citation of each key is `cite(CitationKey)` of its row.

### Rules and requirements (no cut, no if-then-else; ground outputs folded into the clause head)

**Readers** (state atoms are internal and never returned):

- **Gate reader**: `gate_state(Profile, State)`. `State` is `true`, `false` or `absent`. Three disjoint clauses: `profile_get` true, `profile_get` false, `profile_lacks`.
- **Trigger reader**: `trigger_state(Profile, State)`. `State` is `true`, `false` or `absent`:
  - `true`: data_reporting_service_provider;
  - `false`: any other of the 29 atoms;
  - `absent`.
- **Duty value reader**: `duty_value(Profile, Key, State)`. `State` is `true`, `false`, `unsure` or `absent`.

**Duty status:**

- **Applies**: an always duty, or row 22 when the trigger is true. This is a defeasible rule checked through `not_defeated/3`. The defeater is `once(profile_get(Profile, financial_entity_is_article_16_1_entity, true))`.
- **Open**: always, or row 22 when the trigger is not false.
- **Fails**: applies and its key is false.

**Input check** (input_problems/2):

1. A profile that is var, a partial list, a list with a var element, or a list with a non-`attribute/2` element gives `[wrong_type(profile)]`. The test uses var/nonvar recursion, cut-free, with disjoint clauses.
2. Otherwise, for each of the 24 keys in order:
   - more than one occurrence (by `==`) gives `duplicate_key(Key)`;
   - else a value outside its type gives `wrong_type(Key)` (an unbound value is outside every type; any number is wrong);
   - else nothing.
3. Then `unknown_key(Key)` once per non-contract key (by `==`), in the order of first occurrence. A var key is reported as that same variable.

**Required** (R0, R-G1, R-G2, R1, R2):

- R0: input problems.
- R-G1: gate true gives `simplified_framework_entity`, citing `[cite(eu_reg_2022_2554_art_16_1)]`.
- R-G2: gate absent gives `indeterminate([financial_entity_is_article_16_1_entity])`.
- R1: trigger absent gives `indeterminate([dora_entity_type])`.
- R2, trigger false: `required` of duties 1 to 21, with seven citations.
- R2, trigger true: `required` of duties 1 to 22, with eight citations.

**Complete:**

- S0, S-G1 and S-G2 as for Required.
- S1: any failing duty gives `incomplete`, citing the eight keys.
- S2: candidates are:
  - absent keys of open duties;
  - the trigger, if absent and the trade-report key is not true.

  Name the first in root order that is not BEHIND another candidate. X is behind Y when Y decides alone and X does not. Who decides alone:
  - always-duty keys always decide alone;
  - the trade-report key decides alone when the trigger is true;
  - the trigger decides alone when the trade-report key is false.

  The effective rule:

  | situation | key named |
  |---|---|
  | trigger absent and trade-report key false | `dora_entity_type` |
  | else, any always-duty key absent | the first absent always-duty key |
  | else, trigger absent and trade-report key not true | `dora_entity_type` |
  | else, trigger true and trade-report key absent | `trade_report_checking_systems_in_place` |

- S3: the first unsure key of an open duty gives `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`.
- S4: `complete`, citing the eight keys.

**Outstanding:**

- M0, M-G1 and M-G2 as for Required.
- M1: the first in root order among:
  - absent keys of open duties;
  - the trigger, if absent and the trade-report key is not true.

  A false key does not stop this query.
- M2: the first unsure key of an open duty gives `needs_legal_review`.
- M3: an empty failing list gives `none_outstanding` with the eight keys. Otherwise `outstanding(Failing)`, in duty order, citing the deduplicated citation keys of the failing duties.

**PAIRS**: every `Key-Value` present in the profile, in root order, values exactly as given, the unsure key included. Every referral row's inputs are all 24 keys.

### Verdict atoms of this slice

`required/1`, `simplified_framework_entity`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `input_problems/1`, `duplicate_key/1`, `wrong_type/1`, `unknown_key/1`.

### Per-rule tests (seven modes)

1. **load**
2. **unit**: each reader; each duty applies, open or fails.
3. **limb**: every R, S and M step, with a positive and a negative test over the same case.
4. **counting**: `findall` plus `length(_, 1)` on every query.
5. **input check**: duplicate, wrong type, unknown key, var key, var value, var profile, partial list, float values, non-attribute element.
6. **properties**: validate_props totality, determinism, citation completeness and missing-key coverage.
7. **fixtures and what_if**: these include:
   - the <<DNUM>> cases: trade-report key false with trigger absent, and an always-duty key absent with trigger absent;
   - the gate true with junk duty keys present.

### Shared predicates

NONE. This is the only slice, so nothing goes into kernel.clausal beyond the scaffold floor.
