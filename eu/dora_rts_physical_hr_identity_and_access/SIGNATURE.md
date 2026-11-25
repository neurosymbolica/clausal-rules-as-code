# SIGNATURE — eu/dora_rts_physical_hr_identity_and_access

## Public query surface

The package exposes the three contract queries and the input check. Around them sits the scaffold facade:

- `decide_dora_rts_physical_hr_identity_and_access(Profile, dora_rts_physical_hr_identity_and_access_verdict(Status, Citations))`
- `dora_rts_physical_hr_identity_and_access_status(Profile, Status)`
- `dora_rts_physical_hr_identity_and_access_checklist(Profile, Checklist)`
- `dora_rts_physical_hr_identity_and_access_what_if(Profile, Key, Value, Result)`
- `dora_rts_physical_hr_identity_and_access_compliance_check(Profile, Duty, Verdict)`
- the fixtures

`Status` is drawn from the verdict atoms below. Its default facade meaning is the answer of `physical_hr_identity_and_access_duties_complete`.

### Totality and determinism

Every call of every public predicate on any term yields exactly ONE solution. The input check never fails and never raises.

### Statutory figures

There are no statutory figures.

- The order has no thresholds, periods or amounts.
- The six-month and one-year intervals of RTS Art 21(e)(iv) are content of a judgement (reading (8)), never computed.
- `parameters.clausal` therefore declares no `constant_value/2`, and nothing is imported from another domain.

## Verdict STATUS atoms (replace the scaffold placeholders)

The scaffold placeholders `required / permitted / not_applicable` are replaced as follows.

### Final answers

| Answer | Form |
|---|---|
| `required(Duties)` | compound of arity 1; `Duties` is all 36 duty atoms in duty order |
| `complete` | atom |
| `incomplete` | atom |
| `none_outstanding` | atom |
| `outstanding(Duties)` | compound of arity 1; `Duties` is a non-empty list in duty order |
| `simplified_framework_entity` | atom |

### Status compounds (never final; `Citations` always `[]`)

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: an optional unscored `provenance(Clause, Citations)` may follow.
- `input_problems(Problems)`.

### Problem terms

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `wrong_type(profile)`

### Result constructors (exported, never queried)

`required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Facade verdict labels

These are the eligibility labels (query type #2), given to `assess/6` as `labels(complete, indeterminate, incomplete)`.

### Compliance-check modality atoms

These are used for query type #13 through `kit/compliance_lib`: `obligatory`, `satisfied`, `violated`, `indeterminate`.

### Atoms never pinned

`true`, `false` and `unsure` are profile VALUES only. They are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (input_contract order = root_exports order)

`Profile` is `[attribute(Key, Value), ...]`. It is read ONLY with `profile_get/3`, by presence first, then by value. No key is numeric, and no key is a date.

The value types are:

- `fact`: the atom `true` or the atom `false` (typed `boolean`).
- `judgement`: the atom `true`, the atom `false` or the atom `unsure` (typed `one_of boolean or unsure`).

| # | Key | Type |
|---|---|---|
| 1 | `financial_entity_is_article_16_1_entity` | fact (the GATE) |
| 2 | `physical_and_environmental_security_policy_specified_documented_and_implemented` | judgement |
| 3 | `physical_security_policy_designed_in_light_of_threat_landscape_classification_and_risk_profile` | judgement |
| 4 | `physical_security_policy_refers_to_section_on_physical_access_controls` | judgement |
| 5 | `physical_security_policy_contains_measures_protecting_premises_data_centres_and_sensitive_areas` | judgement |
| 6 | `physical_security_policy_contains_measures_securing_ict_assets_within_and_outside_premises` | judgement |
| 7 | `physical_security_policy_contains_measures_of_appropriate_maintenance` | judgement |
| 8 | `physical_security_policy_contains_clear_desk_policy_for_papers` | judgement |
| 9 | `physical_security_policy_contains_clear_screen_policy_for_information_processing_facilities` | judgement |
| 10 | `physical_security_policy_contains_measures_protecting_unattended_ict_assets` | judgement |
| 11 | `human_resource_policy_identifies_and_assigns_ict_security_responsibilities` | judgement |
| 12 | `human_resource_policy_requires_staff_to_be_informed_of_and_adhere_to_ict_security_policies` | judgement |
| 13 | `human_resource_policy_requires_staff_to_be_aware_of_reporting_channels` | judgement |
| 14 | `human_resource_policy_requires_staff_to_return_assets_upon_termination_of_employment` | judgement |
| 15 | `identity_management_policies_and_procedures_developed_documented_and_implemented` | judgement |
| 16 | `identity_management_assigns_unique_identity_corresponding_to_unique_user_account` | judgement |
| 17 | `identity_management_contains_lifecycle_management_process_for_identities_and_accounts` | judgement |
| 18 | `records_of_all_identity_assignments_maintained_and_kept` | judgement |
| 19 | `automated_solutions_for_lifecycle_identity_management_deployed_where_feasible_and_appropriate` | judgement |
| 20 | `access_control_policy_developed_documented_and_implemented` | judgement |
| 21 | `access_control_policy_assigns_access_rights_on_need_to_know_need_to_use_and_least_privilege` | judgement |
| 22 | `access_control_policy_contains_segregation_of_duties` | judgement |
| 23 | `access_control_policy_contains_provision_on_user_accountability` | judgement |
| 24 | `access_control_policy_contains_provision_on_restrictions_of_access_to_ict_assets` | judgement |
| 25 | `account_management_procedures_assign_roles_for_granting_reviewing_and_revoking_access_rights` | judgement |
| 26 | `account_management_procedures_assign_privileged_emergency_and_administrator_access_on_need_to_use_or_ad_hoc_basis` | judgement |
| 27 | `account_management_procedures_withdraw_access_rights_without_undue_delay` | judgement |
| 28 | `account_management_procedures_update_access_rights_where_necessary_and_at_the_required_intervals` | judgement |
| 29 | `access_control_policy_uses_authentication_methods_commensurate_to_classification_and_risk_profile` | judgement |
| 30 | `access_control_policy_uses_strong_authentication_methods_where_required` | judgement |
| 31 | `physical_access_controls_identify_and_log_persons_authorised_to_access_premises` | judgement |
| 32 | `physical_access_rights_to_critical_ict_assets_granted_to_authorised_persons_only` | judgement |
| 33 | `physical_access_to_premises_data_centres_and_sensitive_areas_monitored` | judgement |
| 34 | `physical_access_rights_reviewed_and_unnecessary_rights_promptly_revoked` | judgement |
| 35 | `retention_period_for_the_purposes_of_point_e_i_established` | judgement |
| 36 | `dedicated_accounts_used_for_administrative_tasks_where_possible` | judgement |
| 37 | `automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate` | judgement |

The segments `ict`, `eur` and `ad_hoc` are the statute's own terms, not abbreviations.

## Citation-key atoms (canonical lexicon `_lexicon/citations.yaml`; never shortened)

The `reg` and `art` segments are the canonical lexicon scheme, not local abbreviations. No other citation atom may be invented.

### Paragraph-level keys (THE FIXED CITATIONS)

- `eu_reg_2024_1774_art_18_1`
- `eu_reg_2024_1774_art_18_2`
- `eu_reg_2024_1774_art_19`
- `eu_reg_2024_1774_art_20_1`
- `eu_reg_2024_1774_art_20_2`
- `eu_reg_2024_1774_art_21`

### Point keys

- Article 18(2): `eu_reg_2024_1774_art_18_2_a`, `eu_reg_2024_1774_art_18_2_b`, `eu_reg_2024_1774_art_18_2_c`, `eu_reg_2024_1774_art_18_2_d`, `eu_reg_2024_1774_art_18_2_e_i`, `eu_reg_2024_1774_art_18_2_e_ii`
- Article 19: `eu_reg_2024_1774_art_19_a`, `eu_reg_2024_1774_art_19_b_i`, `eu_reg_2024_1774_art_19_b_ii`, `eu_reg_2024_1774_art_19_b_iii`
- Article 20(2): `eu_reg_2024_1774_art_20_2_a`, `eu_reg_2024_1774_art_20_2_b`
- Article 21: `eu_reg_2024_1774_art_21_a`, `eu_reg_2024_1774_art_21_b`, `eu_reg_2024_1774_art_21_c`, `eu_reg_2024_1774_art_21_d`, `eu_reg_2024_1774_art_21_e_i`, `eu_reg_2024_1774_art_21_e_ii`, `eu_reg_2024_1774_art_21_e_iii`, `eu_reg_2024_1774_art_21_e_iv`, `eu_reg_2024_1774_art_21_f_i`, `eu_reg_2024_1774_art_21_f_ii`, `eu_reg_2024_1774_art_21_g_i`, `eu_reg_2024_1774_art_21_g_ii`, `eu_reg_2024_1774_art_21_g_iii`, `eu_reg_2024_1774_art_21_g_iv`

### Gate key

- `eu_reg_2022_2554_art_16_1`

### Where the keys are declared

`citations.clausal` declares every atom above, with its pinned unit ids. For example, `eu_reg_2024_1774_art_21` covers unit `32024R1774#art_021` together with its point units, and `eu_reg_2022_2554_art_16_1` covers `32022R2554#parag_016.001`.

The deferred units carry no citation key: DORA Art 16(1)(a) to (h), Art 16(2), Art 16(3), and the headings.

## Public predicates

### Contract queries and input check

- `physical_hr_identity_and_access_duties_required(Profile, Result, Citations)`: steps R0, R-G1, R-G2, R1. It returns `required(AllThirtySixDuties)` with THE FIXED CITATIONS, `simplified_framework_entity` with `[cite(eu_reg_2022_2554_art_16_1)]`, or a status. It reads the gate only and never refers. Citation: RTS Art 18 to 21; DORA Art 16(1).
- `physical_hr_identity_and_access_duties_complete(Profile, Result, Citations)`: steps S0, S-G1, S-G2, then S1 (any false gives `incomplete`), S2 (all true gives `complete`, both with THE FIXED CITATIONS), S3 (first absent duty key gives `indeterminate([Key])`) and S4 (first unsure key gives `needs_legal_review`). Citation: RTS Art 18(1), 18(2), 19, 20(1), 20(2), 21; DORA Art 16(1).
- `physical_hr_identity_and_access_duties_outstanding(Profile, Result, Citations)`: steps M0, M-G1, M-G2, M1 (first absent), M2 (first unsure) and M3. M3 gives `none_outstanding` with THE FIXED CITATIONS, or `outstanding(FailingDutiesInDutyOrder)` with the union of those duties' own citations, each written once. Citation: as above.
- `dora_rts_physical_hr_identity_and_access_input_problems(Profile, Problems)`: THE INPUT CHECK. Citation: the input contract, which carries no statutory citation.

### Facade (scaffold names kept)

- `decide_dora_rts_physical_hr_identity_and_access(Profile, dora_rts_physical_hr_identity_and_access_verdict(Status, Citations))`: the eligibility verdict (query type #2), meaning the answer of the complete query packaged as a verdict. Citation: the fixed six keys, or DORA Art 16(1).
- `dora_rts_physical_hr_identity_and_access_status(Profile, Status)`: `Status` alone, as above.
- `dora_rts_physical_hr_identity_and_access_checklist(Profile, Checklist)`: the justification (query type #7). It is built with `assess/6` and `eval_requirements/4` over the 36 duty requirement ids in duty order.
  - Each item is `item(Duty, ItemStatus, cite(PointKey))`. `ItemStatus` is `met`, `unmet(duty_not_performed)`, or `unknown([Key])` (for an absent or unsure key). Met items also carry their cite.
  - When the gate is true, the checklist is `[item(article_16_1_gate, inapplicable, cite(eu_reg_2022_2554_art_16_1))]`.
  - Input problems give `[]`.
- `dora_rts_physical_hr_identity_and_access_what_if(Profile, Key, Value, Result)`: the status after `Key` is overridden with `Value`. It uses `what_if/5` from `kit/query_combinators` with the closure `dora_rts_physical_hr_identity_and_access_status`. The overridden profile passes through the input check, so a bad value gives `input_problems`.
- `dora_rts_physical_hr_identity_and_access_compliance_check(Profile, Duty, Verdict)`: query type #13, asking whether the entity's current state meets the obligation `Duty`.
  - Each duty is a norm `nm(Duty, obligatory)` whose bearer is the financial entity. The gate true is a defeater, so no norm applies.
  - `Verdict` is one of `satisfied`, `violated`, `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, `simplified_framework_entity`, or `input_problems(Problems)`.
  - An unknown `Duty` atom gives `input_problems([unknown_key(Duty)])`. Citation: the duty's own keys.

### Fixtures

- `dora_rts_physical_hr_identity_and_access_fixture(Name, Profile)` together with `dora_rts_physical_hr_identity_and_access_fixture_expected(Name, Query, Result, Citations)`. Named cases include:
  - `article_16_1_entity`
  - `gate_absent`
  - `all_duties_performed`
  - `one_duty_false_others_absent` (complete gives `incomplete`; outstanding gives `indeterminate`)
  - `first_absent_duty`
  - `unsure_referral`
  - `several_outstanding`
  - `closing_subparagraph_duties_outstanding`
  - `duplicate_and_wrong_type`
  - `unknown_and_variable_keys`
  - `not_an_attribute_list`

## Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - profile reading: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - checks: `check_tri/4` for the per-duty checklist status (true gives met, false gives unmet, unsure or absent gives unknown; never hand-rolled, C15);
  - checklist engine: `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `summarize/3`, `has_unmet/1`, `has_unknown/1`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`;
  - defeaters: `not_defeated/3` for the gate defeater;
  - lists: `memberd/2`, `not_member/2`;
  - vocabulary: `met`, `applicable`, `inapplicable`.
- **`kit/compliance_lib`:** `nm/2`, `compliance_check/7`, `applicable_norms/5` and `verdict/5`, for the compliance_check facade.
- **`kit/query_combinators`:** `what_if/5` and `override_key/4` for the what_if facade; `failing_ids/4` for the outstanding list over the requirement closure.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `bad_citation/1` in the tests.
- **Not used:** `kit/deadline_lib`, `kit/rolling_window`, `library(datetime)`, `currency_vocab`, `vat_category`, `country`. This order reads no date, amount, currency or country (readings (8) and (17)).
- **Family backbone `_common` (deontic):** none is needed beyond the above. The ordered first-absent and first-unsure scans are local (see NOTES reuse notes).

## Idioms (hard rules for the later phases)

- **Defeasible structure.** Each duty rule `duty_applies(Duty, Profile)` holds unless the Art 16(1) defeater fires. The defeater is the guarded `once(profile_get(Profile, financial_entity_is_article_16_1_entity, true))`, inside `not_defeated/3`.
  - No `!`, `->` or `*->` is used anywhere.
  - `once/1` appears only as the guard of a defeater.
- **Single solutions.** Exactly one solution per call is achieved by mutually exclusive clause guards. These are:
  - input problems non-empty or empty;
  - gate true, absent, or false;
  - some duty false, or none false;
  - first absent found, or none absent;
  - first unsure found, or none unsure.
  - Each first-key scan walks the ordered duty table recursively with disjoint clauses for present and absent (or for unsure and not unsure). It never uses `findall` plus head selection over non-deterministic goals.
- **Ground statuses in the clause head (C17).** One clause per disjoint route.
- **Open-textured judgements are handed to the user, never given a crisp test.** Every judgement key is caller-supplied, and an unsure key that decides the answer becomes `needs_legal_review`.
- **Pairs.** `Pairs` is every `Key-Value` attribute present in `Profile` whose key is one of the 37 contract keys, in root_exports order, with the value exactly as given. Each referral row's `inputs` are all 37 keys.
- **Variables.** Full CamelCase words: `Profile`, `Duties`, `OutstandingDuties`, `CitationKey`, `ProblemList`.

## Determination slice: dora_rts_physical_hr_identity_and_access.clausal

This is the only slice. It is self-contained for the legal concept 'the physical, human resources, identity and access duties of RTS Articles 18 to 21 and their DORA Art 16(1) gate'.

### Value facts owned (in this file, not in a shared constants file)

There are no numeric statutory values. The slice owns the legal tables.

**The duty table.** One fact per duty, in duty order: `duty_row(Position, Duty, ProfileKey, Citations, Paragraph)`.

| Position | Duty | Citations | Paragraph |
|---|---|---|---|
| 1 | `physical_and_environmental_security_policy` | `[eu_reg_2024_1774_art_18_1]` | `eu_reg_2024_1774_art_18_1` |
| 2 | `physical_security_policy_design_basis` | `[eu_reg_2024_1774_art_18_1]` | `eu_reg_2024_1774_art_18_1` |
| 3 | `reference_to_physical_access_controls_section` | `[eu_reg_2024_1774_art_18_2_a]` | `eu_reg_2024_1774_art_18_2` |
| 4 | `protection_of_premises_data_centres_and_sensitive_areas` | `[eu_reg_2024_1774_art_18_2_b]` | `eu_reg_2024_1774_art_18_2` |
| 5 | `securing_of_ict_assets_within_and_outside_premises` | `[eu_reg_2024_1774_art_18_2_c]` | `eu_reg_2024_1774_art_18_2` |
| 6 | `appropriate_maintenance_of_assets_and_access_control_devices` | `[eu_reg_2024_1774_art_18_2_d]` | `eu_reg_2024_1774_art_18_2` |
| 7 | `clear_desk_policy_for_papers` | `[eu_reg_2024_1774_art_18_2_e_i]` | `eu_reg_2024_1774_art_18_2` |
| 8 | `clear_screen_policy` | `[eu_reg_2024_1774_art_18_2_e_ii]` | `eu_reg_2024_1774_art_18_2` |
| 9 | `protection_of_unattended_ict_assets` | `[eu_reg_2024_1774_art_18_2]` | `eu_reg_2024_1774_art_18_2` |
| 10 | `ict_security_responsibilities` | `[eu_reg_2024_1774_art_19_a]` | `eu_reg_2024_1774_art_19` |
| 11 | `staff_informed_of_and_adhering_to_ict_security_policies` | `[eu_reg_2024_1774_art_19_b_i]` | `eu_reg_2024_1774_art_19` |
| 12 | `staff_aware_of_reporting_channels` | `[eu_reg_2024_1774_art_19_b_ii]` | `eu_reg_2024_1774_art_19` |
| 13 | `return_of_assets_upon_termination_of_employment` | `[eu_reg_2024_1774_art_19_b_iii]` | `eu_reg_2024_1774_art_19` |
| 14 | `identity_management_policies_and_procedures` | `[eu_reg_2024_1774_art_20_1]` | `eu_reg_2024_1774_art_20_1` |
| 15 | `unique_identity_for_each_user_account` | `[eu_reg_2024_1774_art_20_2_a]` | `eu_reg_2024_1774_art_20_2` |
| 16 | `identity_and_account_lifecycle_management_process` | `[eu_reg_2024_1774_art_20_2_b]` | `eu_reg_2024_1774_art_20_2` |
| 17 | `records_of_identity_assignments` | `[eu_reg_2024_1774_art_20_2]` | `eu_reg_2024_1774_art_20_2` |
| 18 | `automated_identity_lifecycle_solutions` | `[eu_reg_2024_1774_art_20_2]` | `eu_reg_2024_1774_art_20_2` |
| 19 | `access_control_policy` | `[eu_reg_2024_1774_art_21]` | `eu_reg_2024_1774_art_21` |
| 20 | `need_to_know_and_least_privilege_access_rights` | `[eu_reg_2024_1774_art_21_a]` | `eu_reg_2024_1774_art_21` |
| 21 | `segregation_of_duties` | `[eu_reg_2024_1774_art_21_b]` | `eu_reg_2024_1774_art_21` |
| 22 | `user_accountability` | `[eu_reg_2024_1774_art_21_c]` | `eu_reg_2024_1774_art_21` |
| 23 | `restrictions_of_access_to_ict_assets` | `[eu_reg_2024_1774_art_21_d]` | `eu_reg_2024_1774_art_21` |
| 24 | `roles_for_granting_reviewing_and_revoking_access` | `[eu_reg_2024_1774_art_21_e_i]` | `eu_reg_2024_1774_art_21` |
| 25 | `privileged_emergency_and_administrator_access` | `[eu_reg_2024_1774_art_21_e_ii]` | `eu_reg_2024_1774_art_21` |
| 26 | `withdrawal_of_access_rights` | `[eu_reg_2024_1774_art_21_e_iii]` | `eu_reg_2024_1774_art_21` |
| 27 | `update_of_access_rights` | `[eu_reg_2024_1774_art_21_e_iv]` | `eu_reg_2024_1774_art_21` |
| 28 | `authentication_methods_commensurate_to_classification_and_risk` | `[eu_reg_2024_1774_art_21_f_i]` | `eu_reg_2024_1774_art_21` |
| 29 | `strong_authentication_methods` | `[eu_reg_2024_1774_art_21_f_ii]` | `eu_reg_2024_1774_art_21` |
| 30 | `identification_and_logging_of_authorised_persons` | `[eu_reg_2024_1774_art_21_g_i]` | `eu_reg_2024_1774_art_21` |
| 31 | `physical_access_rights_to_critical_ict_assets` | `[eu_reg_2024_1774_art_21_g_ii]` | `eu_reg_2024_1774_art_21` |
| 32 | `monitoring_of_physical_access` | `[eu_reg_2024_1774_art_21_g_iii]` | `eu_reg_2024_1774_art_21` |
| 33 | `review_of_physical_access_rights` | `[eu_reg_2024_1774_art_21_g_iv]` | `eu_reg_2024_1774_art_21` |
| 34 | `retention_period_for_point_e_i` | `[eu_reg_2024_1774_art_21]` | `eu_reg_2024_1774_art_21` |
| 35 | `dedicated_administrative_accounts` | `[eu_reg_2024_1774_art_21]` | `eu_reg_2024_1774_art_21` |
| 36 | `automated_privileged_access_management` | `[eu_reg_2024_1774_art_21]` | `eu_reg_2024_1774_art_21` |

The profile key of the duty at Position N is profile key N+1 of the key table. The duty atoms are result atoms only, never profile keys.

**The referral table.** `referral_row(ProfileKey, cite(CitationKey), Inputs)` holds one row per judgement key. The citation is the one given in THE LIMBS:

- a point key for a duty of a point;
- `eu_reg_2024_1774_art_18_1` for both Art 18(1) duties;
- `eu_reg_2024_1774_art_18_2` for the unattended-assets duty;
- `eu_reg_2024_1774_art_20_1` for the Art 20(1) duty;
- `eu_reg_2024_1774_art_20_2` for the two Art 20(2) closing duties;
- `eu_reg_2024_1774_art_21` for the Art 21 lead duty and its three closing duties.

`Inputs` is all 37 keys in root_exports order.

**Other facts.**

- `fixed_citations([cite(eu_reg_2024_1774_art_18_1), cite(eu_reg_2024_1774_art_18_2), cite(eu_reg_2024_1774_art_19), cite(eu_reg_2024_1774_art_20_1), cite(eu_reg_2024_1774_art_20_2), cite(eu_reg_2024_1774_art_21)])`.
- `gate_citation(cite(eu_reg_2022_2554_art_16_1))`.

### Rules and requirements

- `article_16_1_defeater(Rule, Profile)`: the guarded `once/1` defeater on gate true.
- `duty_applies(Duty, Profile)`: every duty, subject to the defeater. No other condition is read (reading (3)).
- `requirement(Duty, Profile, Status, Citation)`: the kit requirement head, with `RequirementId` first. It delegates to `check_tri/4` on the duty's key, with `Citation` as `cite(FirstPointKey)`. It has three exclusive outcomes: met, unmet, or unknown.
- The ordered scans:
  - `first_false_duty/2` (existence only, used by S1);
  - `first_absent_duty_key/2`;
  - `first_unsure_duty_key/2`;
  - `failing_duties/2` (in duty order);
  - `none_false/1`, `none_absent/1`, `none_unsure/1`.
  - Each is a deterministic recursion over `duty_row/5` positions, with disjoint clauses.
- `inputs_relied_on_pairs(Profile, Pairs)`: the present contract keys in root_exports order, as `Key-Value`.
- `outstanding_citations(Duties, Citations)`: each duty's citations, in duty order, each written once.
- `required_citations(Citations)`: the paragraph of each of the 36 duties, each written once. This equals THE FIXED CITATIONS.
- The three contract queries: the steps of THE LIMBS, one head clause per disjoint route, ground results in the head.

### Verdict atoms of this slice

- `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`;
- the statuses `indeterminate/1`, `needs_legal_review/2` (with `open_textured/2` and `inputs_relied_on/1`) and `input_problems/1`;
- the checklist statuses `met`, `unmet(duty_not_performed)`, `unknown([Key])` and `inapplicable`.

### Per-rule tests (tests/)

The tests cover the following:

- one test per duty: its false gives `incomplete` and `outstanding([Duty])` with that duty's own citations;
- one test per duty: its unsure gives `needs_legal_review` with its referral citation;
- gate true, gate absent, and gate given `unsure` (`wrong_type`);
- a false duty with an absent earlier duty: complete gives `incomplete`, while outstanding gives `indeterminate([EarlierKey])`;
- an absent key named before an unsure key;
- the citation set of `outstanding` deduplicated (34, 35 and 36 all give `eu_reg_2024_1774_art_21` once);
- the input-check matrix: duplicates, an unbound value, a variable key, the same variable twice, `7` and `7.0`, a non-attribute element, a partial list, an unbound profile;
- every positive test paired with a negative test.

`validate_props` checks totality, determinism and citation completeness over the fixtures.

### Predicates this slice must SHARE (and only these belong in kernel.clausal)

The slice shares the following with the `queries` and `fixtures` modules and the package facade, so they live in `kernel.clausal`:

- `contract_key(Position, Key, Type)`: the 37 keys in root_exports order. `Type` is `fact` or `judgement`.
- `value_has_type(Type, Value)`: `fact` accepts the atoms `true` and `false`; `judgement` accepts the atoms `true`, `false` and `unsure`. An unbound variable or a number never has the type.
- `dora_rts_physical_hr_identity_and_access_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - If the profile is not a proper list of `attribute(Key, Value)` elements (an unbound profile, a partial list, or an unbound or foreign element), the answer is `[wrong_type(profile)]`.
  - Otherwise, for each contract key in order: `duplicate_key(Key)` if it occurs more than once (no value is read), else `wrong_type(Key)` if its value is outside its type.
  - Then `unknown_key(Key)` for each non-contract key, at its first occurrence, with identity by `==`. Distinct variables are distinct keys; the same variable twice is one key, at its first occurrence. A non-atom key is reported as given, and its value is not checked.
  - It never fails and never raises.

Nothing else is shared. The duty table, referrals and citations stay in the slice.

## Other modules (layout kept)

- **`citations.clausal`:** the citation atoms above, each with its pinned unit ids and instrument (`32024R1774` or `32022R2554`).
- **`parameters.clausal`:** intentionally empty of statutory figures. It carries a comment that no threshold or period exists (readings (8) and (17)).
- **`queries.clausal`:** re-exports the three contract queries. It implements `decide_.../2`, `status/2`, `checklist/2`, `what_if/4` and `compliance_check/3` over the slice.
- **`fixtures.clausal`:** the named fixtures and their expected results.
- **Package facade:** exports exactly the public predicates and result constructors listed above.