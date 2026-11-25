# SIGNATURE — eu/dora_rts_incident_policy_and_detection

## Public query surface (summary)

The called contract has four predicates. Each takes PROFILE and yields exactly ONE solution.

- `rts_incident_policy_and_detection_duties_required(Profile, Result, Citations)`
- `rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations)`
- `rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations)`
- `dora_rts_incident_policy_and_detection_input_problems(Profile, Problems)`

The facade (scaffold names, kept) wraps the complete query as the verdict:

- `decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(Status, Citations))`
- `dora_rts_incident_policy_and_detection_status(Profile, Status)`

The order makes these claims:

- **Total**: every term yields an answer.
- **Deterministic**: exactly one solution.
- **Self-contained**: no constant is imported from another domain, because the order has no numeric figures.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

Final results:

- `complete`: every duty is judged performed.
- `incomplete`: some duty key is `false`.
- `simplified_framework_entity`: the gate is true (DORA Art 16(1)).
- `required(Duties)`: the required query only; all seventeen duties in duty order.
- `none_outstanding`: the outstanding query only.
- `outstanding(Duties)`: the outstanding query only; the failing duties in duty order.

Status compounds (never final; CITATIONS `[]`):

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, optionally followed by one unscored `provenance(Clause, Citations)`.
- `input_problems(Problems)`: `Problems` holds `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

The facade STATUS is the functor of the complete-query result:

| STATUS | Meaning |
|---|---|
| `complete` | eligible / compliant |
| `incomplete` | ineligible / non-compliant |
| `simplified_framework_entity` | not bound by these articles |
| `indeterminate` | a key is missing |
| `needs_legal_review` | referred to a lawyer |
| `input_problems` | the profile is badly formed |

These facade atoms are pinned in `verdict_vocabulary` together with `required`, `none_outstanding` and `outstanding`. `true` and `false` are never pinned.

## Profile keys (eighteen, root_exports and input_contract order)

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. No key is numeric or a date.

1. `financial_entity_is_article_16_1_entity`: a FACT, typed `boolean` (the atoms `true` and `false` only).
2. `ict_related_incident_policy_developed_documented_and_implemented`
3. `ict_related_incident_management_process_documented`
4. `list_of_relevant_internal_and_external_contacts_established`
5. `technical_organisational_and_operational_incident_management_mechanisms_operated`
6. `incident_evidence_retained_for_a_period_no_longer_than_necessary`
7. `mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented`
8. `incident_evidence_retained_in_a_secure_manner`
9. `clear_roles_and_responsibilities_for_detection_and_response_set`
10. `factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed`
11. `anomalous_activities_identified_and_alerting_tools_implemented`
12. `alerts_prioritised_within_expected_resolution_time`
13. `information_on_anomalous_activities_recorded_analysed_and_evaluated`
14. `alerting_tools_include_automated_alerts_on_data_source_and_log_integrity`
15. `records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access`
16. `information_on_each_detected_anomalous_activity_logged`
17. `criteria_triggering_incident_detection_and_response_considered`
18. `criticality_of_affected_services_considered`

Keys 2 to 18 are JUDGEMENT keys, typed `one_of boolean or unsure`: `true`, `false` or `unsure`.

## Citation-key atoms (citation_vocabulary, canonical `_lexicon/citations.yaml` scheme)

RTS citation keys:

- `eu_reg_2024_1774_art_22` (lead words and second subparagraph)
- `eu_reg_2024_1774_art_22_a`
- `eu_reg_2024_1774_art_22_b`
- `eu_reg_2024_1774_art_22_c`
- `eu_reg_2024_1774_art_22_d`
- `eu_reg_2024_1774_art_22_e`
- `eu_reg_2024_1774_art_23_1`
- `eu_reg_2024_1774_art_23_2` (second subparagraph)
- `eu_reg_2024_1774_art_23_2_a`
- `eu_reg_2024_1774_art_23_2_b`
- `eu_reg_2024_1774_art_23_2_c`
- `eu_reg_2024_1774_art_23_2_d`
- `eu_reg_2024_1774_art_23_3`
- `eu_reg_2024_1774_art_23_4`
- `eu_reg_2024_1774_art_23_5`
- `eu_reg_2024_1774_art_23_6`

DORA citation key:

- `eu_reg_2022_2554_art_16_1`

THE FIXED CITATIONS are:

`[cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_1), cite(eu_reg_2024_1774_art_23_2), cite(eu_reg_2024_1774_art_23_3), cite(eu_reg_2024_1774_art_23_4), cite(eu_reg_2024_1774_art_23_5), cite(eu_reg_2024_1774_art_23_6)]`

No shortened atom is ever invented.

## Public predicates

- `rts_incident_policy_and_detection_duties_required(Profile, Result, Citations)`: which duties apply. The limbs, in order:
  - R0: input problems.
  - R-G1: gate true gives `simplified_framework_entity` with `[cite(eu_reg_2022_2554_art_16_1)]`.
  - R-G2: gate absent gives `indeterminate([financial_entity_is_article_16_1_entity])`.
  - R1: otherwise `required(AllSeventeenDuties)` with THE FIXED CITATIONS. It never refers. Cites RTS Art 22 and 23, and DORA Art 16(1).
- `rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations)`: compliance check, #13. The limbs, in order:
  - S0: input problems.
  - S-G1 and S-G2: the gate, as above.
  - S1: any duty key `false` gives `incomplete` with THE FIXED CITATIONS.
  - S2: otherwise the first absent duty key gives `indeterminate([Key])`.
  - S3: otherwise the first unsure duty key gives `needs_legal_review(open_textured(Key, Cite), [inputs_relied_on(Pairs)])`.
  - S4: otherwise `complete` with THE FIXED CITATIONS. Cites RTS Art 22 and 23.
- `rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations)`: which duties are outstanding. The limbs, in order:
  - M0, M-G1 and M-G2: as above.
  - M1: the first absent duty key gives `indeterminate([Key])`.
  - M2: the first unsure duty key gives `needs_legal_review(...)`.
  - M3: no failing duty gives `none_outstanding` with THE FIXED CITATIONS. Otherwise `outstanding(FailingDutiesInDutyOrder)`, citing each failing duty's own key once. Cites RTS Art 22 and 23.
- `dora_rts_incident_policy_and_detection_input_problems(Profile, Problems)`: the typed input check (INTERFACE - THE INPUT CHECK); it never fails and never raises. Cites no provision.
- `decide_dora_rts_incident_policy_and_detection(Profile, Verdict)`: `Verdict = dora_rts_incident_policy_and_detection_verdict(Status, Citations)`, from the complete query, as an eligibility verdict (#2). Cites RTS Art 22 and 23, and DORA Art 16(1).
- `dora_rts_incident_policy_and_detection_status(Profile, Status)`: the Status atom of the decision, as above. Cites RTS Art 22 and 23.
- `dora_rts_incident_policy_and_detection_checklist(Profile, Checklist)`: justification (#7). The checklist is the seventeen `item(Duty, Status, cite(CitationKey))` items in duty order, with `Status` as `met`, `unmet(not_performed)` or `unknown([Key])`. It is built through `formalize_lib:assess/6`, with the requirement closure `dora_rts_incident_policy_and_detection_requirement`. When the gate is true, it is the single item `item(simplified_framework_entity, inapplicable, cite(eu_reg_2022_2554_art_16_1))`. Every item carries `cite(...)`.
- `dora_rts_incident_policy_and_detection_what_if(Profile, Key, Value, Verdict)`: the verdict after one key is overridden. It is built through `kit/query_combinators:what_if/5` with Decide `decide_dora_rts_incident_policy_and_detection`. Cites as the verdict.
- Fixtures: `dora_rts_incident_policy_and_detection_fixture(Name, Profile)` and `dora_rts_incident_policy_and_detection_expected(Name, Query, Result, Citations)`. There is one fixture per limb:
  - gate true;
  - gate absent;
  - all true;
  - one false and others absent (incomplete versus indeterminate);
  - first absent;
  - unsure only;
  - unsure plus absent (missing first);
  - several false (outstanding list and its citations);
  - closing-subparagraph duties false (citations art_22 and art_23_2);
  - input-problem cases: duplicate key, wrong type, unknown key, an unbound key variable, a non-list profile, a partial list, and `unsure` on the gate.

## Planned reuse (manifest `uses:`)

- `formalize_lib` provides:
  - `profile_get/3`, `profile_has/2` and `profile_lacks/2` (the only profile access);
  - `check_tri/4` for the per-duty met / unmet / unknown status of the checklist;
  - `assess/6`, `item/3`, `labels/3`, `unknown/1` and `unmet/1`;
  - `not_defeated/3` for the Art 16(1) defeater;
  - `memberd/2`.
- `validate_props` is used in the tests: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `bad_citation/1`.
- `kit/query_combinators` provides `what_if/5` for the what-if facade.
- `kit/compliance_lib` is NOT used. The duties are unconditional obligations whose status is a caller judgement, not a modality resolution, and the order's own limbs fix the precedence.
- `deadline_lib`, `date_time` and `rolling_window` are not used, because no date or period is read.

## Idioms

- **Defeasible gate.** The rule is: every duty applies to a financial entity. Its defeater is the DORA Art 16(1) entity.
  - The defeater fires through `dora_rts_incident_policy_and_detection_defeater(duties_apply, Profile)`, which holds when `profile_get(Profile, financial_entity_is_article_16_1_entity, true)`.
  - The rule is tested by `not_defeated(duties_apply, Profile, dora_rts_incident_policy_and_detection_defeater)`, guarded with `once/1`.
  - The code is cut-free: no `!`, `->` or `*->`.
- **Head folding.** Ground verdict outputs are folded into clause heads (C17), one clause per disjoint limb.
- **Disjoint limbs.** The limbs are made disjoint by guards:
  - input problems are `[]` or non-empty;
  - the gate is true, false or absent;
  - for the complete query, whether a false duty key exists;
  - for the duty keys, whether an absent key exists, then whether an unsure key exists.
- **First-key selection.** `once(member(duty(_, _, Key, _), OrderedDuties))` is guarded by `profile_lacks/2` for the absent case, and by `profile_get(Profile, Key, unsure)` for the unsure case.

## Slice: kernel.clausal (shared floor)

kernel.clausal owns only what the slice facade and the input check share:

- `dora_rts_incident_policy_and_detection_contract_key(Key, Type)`: the eighteen keys, in order, typed `fact` or `judgement`.
- `dora_rts_incident_policy_and_detection_value_has_type(Type, Value)`:
  - `fact` accepts `true` and `false`;
  - `judgement` accepts `true`, `false` and `unsure`;
  - an unbound value is never typed;
  - no number is ever typed.
- `dora_rts_incident_policy_and_detection_input_problems/2`: the INPUT CHECK.
  - A profile that is not an attribute list gives `[wrong_type(profile)]`.
  - Then, per contract key in order: `duplicate_key` (values not read), else `wrong_type`.
  - Then `unknown_key` per non-contract key, in order of first occurrence. Keys are compared by `==`, so variables, numbers, strings and compounds are all handled; the values of non-contract keys are not checked.
- `dora_rts_incident_policy_and_detection_inputs_relied_on(Profile, Pairs)`: every present Key-Value pair in root_exports order, with values as given.

The kernel holds no statutory value facts.

## Slice: dora_rts_incident_policy_and_detection.clausal

**Statutory VALUE facts it owns.** There are no thresholds, periods or amounts. The facts are tables, all local to this file:

- `dora_rts_incident_policy_and_detection_duty(Ordinal, DutyAtom, ProfileKey, CitationKey)`: seventeen rows in DUTY ORDER, with ordinals 1 to 17 and the atoms below.
- `dora_rts_incident_policy_and_detection_fixed_citation(CitationKey)`: seven rows, from `eu_reg_2024_1774_art_22` to `eu_reg_2024_1774_art_23_6`.
- `dora_rts_incident_policy_and_detection_referral(ProfileKey, CitationKey, Inputs)`: seventeen rows. `CitationKey` is the duty's citation; `Inputs` is all eighteen keys.

The duty table:

| Ordinal | Duty atom | Citation key |
|---|---|---|
| 1 | `ict_related_incident_policy` | `art_22` |
| 2 | `documentation_of_incident_management_process` | `art_22_a` |
| 3 | `list_of_relevant_contacts` | `art_22_b` |
| 4 | `incident_management_mechanisms` | `art_22_c` |
| 5 | `retention_of_incident_evidence` | `art_22_d` |
| 6 | `analysis_of_significant_or_recurring_incidents` | `art_22_e` |
| 7 | `secure_retention_of_incident_evidence` | `art_22` |
| 8 | `detection_and_response_roles_and_responsibilities` | `art_23_1` |
| 9 | `collection_monitoring_and_analysis` | `art_23_2_a` |
| 10 | `identification_of_anomalies_and_alerting_tools` | `art_23_2_b` |
| 11 | `prioritisation_of_alerts` | `art_23_2_c` |
| 12 | `recording_and_evaluation_of_anomalous_activities` | `art_23_2_d` |
| 13 | `automated_alerts_on_data_source_and_log_integrity` | `art_23_2` |
| 14 | `protection_of_records_of_anomalous_activities` | `art_23_3` |
| 15 | `logging_of_detected_anomalous_activities` | `art_23_4` |
| 16 | `consideration_of_incident_detection_criteria` | `art_23_5` |
| 17 | `consideration_of_criticality_of_affected_services` | `art_23_6` |

Each citation key in the table is written in full in the code, as `eu_reg_2024_1774_` followed by the suffix shown.

**Rules and requirements.**

- The gate rule and its defeater, as in the Idioms section above.
- `dora_rts_incident_policy_and_detection_requirement(DutyAtom, Profile, Status, Citation)`: a closure for `assess/6`, with the RequirementId first. It has three exclusive clauses:
  - key `true` gives `met`;
  - key `false` gives `unmet(not_performed)`;
  - key unsure or absent gives `unknown([Key])`.

  The citation is `cite(CitationKey)`.
- Helpers:
  - `..._duty_fails(Profile, Duty)`: the key is `false`.
  - `..._first_absent_duty_key(Profile, Key)`, with a guarded `once/1` over duty order.
  - `..._first_unsure_duty_key(Profile, Key)`, likewise.
  - `..._no_absent_duty_key/1` and `..._no_unsure_duty_key/1`, both as `\+` guards.
  - `..._outstanding_duties(Profile, Duties)`, by `findall/3` in duty order.
  - `..._outstanding_citations(Duties, Citations)`, each written once, with `sort/2` used for de-duplication: `art_22` can come from duties 1 and 7.
- The limbs R0 to R1, S0 to S4 and M0 to M3 exactly as in the Public predicates section, one head-folded clause each.

**Verdict atoms.** `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`, and the three status compounds.

**Per-rule tests (seven modes).** Fixtures cover every limb and every closing-subparagraph duty. The required tests are:

- false beats absent in the complete query, but not in the outstanding query;
- absent beats unsure;
- gate true beats everything except input problems;
- citations for `outstanding` are de-duplicated;
- the PAIRS order follows root_exports;
- every query yields exactly one solution, checked with `findall` and `length` 1.

**Predicates shared with another slice.** The only shared predicates are the contract-key table, the input check and `inputs_relied_on`. They live in kernel.clausal, and nothing else is shared.
