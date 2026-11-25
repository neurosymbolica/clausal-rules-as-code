# SIGNATURE - eu/dora_rts_simplified_policies_and_controls

## Public query surface

The package is laid out as a shared kernel plus determination slices:

- `kernel.clausal`
- `citations.clausal`
- `parameters.clausal`
- `dora_rts_simplified_policies_and_controls.clausal` (the single determination slice)
- `queries.clausal`
- `fixtures.clausal`
- the package facade

No file or module name changes. The shape family is deontic.

The called contract is three queries and an input check. Each yields EXACTLY ONE solution for every PROFILE term.

- `simplified_policies_and_controls_duties_required(Profile, Result, Citations)`
- `simplified_policies_and_controls_duties_complete(Profile, Result, Citations)`
- `simplified_policies_and_controls_duties_outstanding(Profile, Result, Citations)`
- `dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems)`

The facade wraps the `complete` query:

- `decide_dora_rts_simplified_policies_and_controls(Profile, dora_rts_simplified_policies_and_controls_verdict(Status, Citations))`
- `dora_rts_simplified_policies_and_controls_status(Profile, Status)`

The facade also provides the checklist, the what-if, the eligibility view (query type #2) and the compliance check (query type #13). The justification view (query type #7) is the checklist, whose every item carries `cite(...)`.

There are no imported statutory figures: the order has no thresholds, periods, money or dates.

## Verdict STATUS atoms (replace the scaffold placeholders required / permitted / not_applicable)

Final answers:

- `required(Duties)` - compound, arity 1. Duties is the non-empty list of all 51 duty atoms in DUTY ORDER.
- `not_article_16_1_entity` - atom. The gate is false.
- `complete` - atom.
- `incomplete` - atom.
- `none_outstanding` - atom.
- `outstanding(Duties)` - compound, arity 1. Duties is the non-empty list of failing duties in DUTY ORDER.

Status compounds (never final; their Citations are always []):

- `indeterminate([Key])` - exactly one bare key atom. The bare atom `indeterminate` is NEVER written (atom-shadowing trap).
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` - optionally followed by one unscored `provenance(Clause, Citations)` item.
- `input_problems(Problems)` - Problems is a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

Supporting vocabulary:

- Eligibility verdict atoms: `bound_by_title_iii` and `not_article_16_1_entity`, plus the status compounds above.
- Checklist labels for `assess/6`: `labels(duties_complete, duties_undetermined, duties_incomplete)`.
- The atoms `true`, `false` and `unsure` are profile VALUES only. They are never pinned in `verdict_vocabulary` or `root_exports`.

Result constructors (exported, never called as queries): `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (52, in root_exports / input_contract order)

PROFILE is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`: by presence first, then by value.

There are no numeric keys and no date keys. The order reads no amount, no period and no date (reading 4, reading 13).

The gate (type `fact`: the atoms true or false):

1. `financial_entity_is_article_16_1_entity`

The judgement keys (type `judgement`: one_of boolean or unsure, that is true, false or unsure). Key N+1 is the key of duty N.

2. `simplified_internal_governance_and_control_framework_in_place`
3. `management_body_bears_overall_responsibility_for_simplified_framework`
4. `management_body_set_ict_roles_and_responsibilities`
5. `management_body_set_information_security_objectives_and_ict_requirements`
6. `management_body_approves_and_reviews_classification_risks_and_impact_analysis`
7. `management_body_approves_and_reviews_continuity_plans_and_recovery_measures`
8. `management_body_allocates_and_reviews_resilience_budget_yearly`
9. `management_body_specifies_and_implements_title_iii_policies_and_measures`
10. `management_body_identifies_and_implements_asset_protection_procedures`
11. `management_body_keeps_staff_ict_risk_knowledge_up_to_date`
12. `management_body_established_reporting_arrangements`
13. `control_and_internal_audit_functions_segregated_and_independent`
14. `simplified_framework_subject_to_internal_audit`
15. `critical_ict_audit_findings_verified_and_remediated`
16. `information_security_policy_developed_documented_and_implemented`
17. `ict_security_measures_established_and_implemented`
18. `critical_functions_and_supporting_assets_identified_classified_and_documented`
19. `critical_functions_supported_by_third_party_providers_identified`
20. `framework_determines_ict_risk_tolerance_levels`
21. `framework_identifies_and_assesses_ict_risks`
22. `framework_specifies_mitigation_strategies`
23. `framework_monitors_mitigation_effectiveness`
24. `framework_assesses_risks_from_changes_tests_and_incidents`
25. `ict_risk_assessment_carried_out_and_documented_periodically`
26. `threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed`
27. `incident_response_alert_thresholds_and_criteria_set`
28. `physical_security_measures_identified_and_implemented`
29. `premises_and_data_centres_protected`
30. `access_control_procedures_developed_enforced_and_reviewed`
31. `access_rights_managed_on_need_to_know_and_least_privilege`
32. `user_accountability_ensured`
33. `account_management_procedures_in_place`
34. `authentication_methods_commensurate_and_strong_where_required`
35. `access_rights_reviewed_and_withdrawn_when_not_required`
36. `ict_asset_lifecycle_monitored_and_managed`
37. `third_party_support_of_ict_assets_monitored`
38. `ict_capacity_requirements_and_availability_measures_identified`
39. `vulnerability_scanning_performed_and_patches_deployed`
40. `legacy_and_unsupported_ict_asset_risks_managed`
41. `access_operations_and_change_events_logged`
42. `anomalous_activities_monitored_and_analysed`
43. `cyber_threat_information_monitored`
44. `leakages_malicious_code_and_vulnerabilities_identified`
45. `network_and_data_security_safeguards_developed_and_implemented`
46. `data_in_use_in_transit_and_at_rest_protected`
47. `software_storage_media_and_endpoint_security_measures_implemented`
48. `unauthorised_connections_prevented_and_network_traffic_secured`
49. `data_secured_during_network_transmissions`
50. `secure_data_deletion_process_in_place`
51. `secure_storage_device_disposal_process_in_place`
52. `teleworking_and_private_device_measures_implemented`

Not contract keys: `financial_entity_is_microenterprise`, `dora_entity_type` and `authority_requested_framework_review_report`. If supplied, each gives `unknown_key(Key)`.

## Citation-key atoms (citations.clausal; canonical lexicon scheme, _lexicon/citations.yaml)

The twenty keys, in this order, are THE FIXED CITATIONS:

1. `eu_reg_2022_2554_art_16_1` - DORA Art 16(1), first subparagraph (the gate)
2. `eu_reg_2024_1774_art_28_1` - RTS Art 28(1)
3. `eu_reg_2024_1774_art_28_2` - RTS Art 28(2), lead words and points (a) to (i), with (d)(i) and (d)(ii)
4. `eu_reg_2024_1774_art_28_4` - RTS Art 28(4)
5. `eu_reg_2024_1774_art_28_5` - RTS Art 28(5)
6. `eu_reg_2024_1774_art_28_6` - RTS Art 28(6)
7. `eu_reg_2024_1774_art_29_1` - RTS Art 29(1)
8. `eu_reg_2024_1774_art_29_2` - RTS Art 29(2)
9. `eu_reg_2024_1774_art_30_1` - RTS Art 30(1)
10. `eu_reg_2024_1774_art_30_2` - RTS Art 30(2)
11. `eu_reg_2024_1774_art_31_1` - RTS Art 31(1), lead words and points (a) to (e)
12. `eu_reg_2024_1774_art_31_2` - RTS Art 31(2)
13. `eu_reg_2024_1774_art_31_3` - RTS Art 31(3)
14. `eu_reg_2024_1774_art_31_4` - RTS Art 31(4)
15. `eu_reg_2024_1774_art_32_1` - RTS Art 32(1)
16. `eu_reg_2024_1774_art_32_2` - RTS Art 32(2)
17. `eu_reg_2024_1774_art_32_3` - RTS Art 32(3)
18. `eu_reg_2024_1774_art_33` - RTS Article 33, whole article including its closing paragraphs
19. `eu_reg_2024_1774_art_34` - RTS Article 34, whole article including its closing paragraph
20. `eu_reg_2024_1774_art_35` - RTS Article 35, whole article

Each key is mapped to its pinned unit ids, for example `32024R1774#parag_028.002` and its points. Shortened citation atoms are never invented.

## Public predicates

The three contract queries and the input check:

- `simplified_policies_and_controls_duties_required(Profile, Result, Citations)`: steps R0 to R1, reading the gate only.
  - Steps: input problems (R0); false gate gives `not_article_16_1_entity` (R-G1); absent gate gives `indeterminate([financial_entity_is_article_16_1_entity])` (R-G2); otherwise `required(AllFiftyOneDuties)` with THE FIXED CITATIONS (R1).
  - It never refers.
  - Citation: DORA Art 16(1); RTS Arts 28 to 35.
- `simplified_policies_and_controls_duties_complete(Profile, Result, Citations)`: steps S0 to S4.
  - Steps: input problems; false gate; absent gate; any false duty gives `incomplete` with the fixed citations (S1); the first absent duty key gives `indeterminate([Key])` (S2); the first unsure duty key gives `needs_legal_review(open_textured(Key, Cite), [inputs_relied_on(Pairs)])` (S3); otherwise `complete` with the fixed citations (S4).
  - Citation: RTS Arts 28 to 35, with DORA Art 16(1).
- `simplified_policies_and_controls_duties_outstanding(Profile, Result, Citations)`: steps M0 to M3.
  - Steps: input problems; false gate; absent gate; the first absent duty key (M1); the first unsure duty key (M2); otherwise `none_outstanding` with the fixed citations, or `outstanding(Failing)` citing the union of the failing duties' citation keys, each once (M3).
  - Citation: RTS Arts 28 to 35, with DORA Art 16(1).
- `dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - Never fails and never raises.
  - Citation: none (contract check).

The facade predicates (scaffold names kept):

- `decide_dora_rts_simplified_policies_and_controls(Profile, Verdict)`: Verdict is `dora_rts_simplified_policies_and_controls_verdict(Status, Citations)`, where Status and Citations are exactly the Result and Citations of `simplified_policies_and_controls_duties_complete/3`.
  - Citation: RTS Arts 28 to 35, with DORA Art 16(1).
- `dora_rts_simplified_policies_and_controls_status(Profile, Status)`: the Status of the decide verdict only.
  - Citation: as above.
- `dora_rts_simplified_policies_and_controls_checklist(Profile, Checklist)`: the justification view (query type #7).
  - Checklist is 51 `item(DutyAtom, Status, cite(FirstCitationKey))` items in DUTY ORDER, built by `eval_requirements/4` with the closure `dora_rts_simplified_policies_and_controls_requirement`.
  - Status is one of: `met`; `unmet(not_performed(Key))`; `unknown([Key])` for absent; `unknown([Key])` for unsure.
  - A false gate gives every item Status `inapplicable` with `cite(eu_reg_2022_2554_art_16_1)`. An absent gate gives `unknown([financial_entity_is_article_16_1_entity])`.
  - Citation: per item, the duty's referral citation.
- `dora_rts_simplified_policies_and_controls_what_if(Profile, Key, Value, Verdict)`: re-decides with one key overridden.
  - It uses kit `what_if/5` with the closure `decide_dora_rts_simplified_policies_and_controls`. The override is applied through `profile_set/3`, so the overridden key occurs once.
  - Citation: as decide.
- `dora_rts_simplified_policies_and_controls_eligibility(Profile, Verdict)`: query type #2, whether Title III binds the entity.
  - Verdict is `eligibility(Decision, [item(article_16_1_gate, GateStatus, cite(eu_reg_2022_2554_art_16_1))])`.
  - Decision is `bound_by_title_iii` (gate true), `not_article_16_1_entity` (gate false), `indeterminate([financial_entity_is_article_16_1_entity])` (gate absent), or `input_problems(Problems)`.
  - Citation: DORA Art 16(1), first subparagraph.
- `dora_rts_simplified_policies_and_controls_compliance_check(Profile, Duty, Verdict)`: query type #13. It asks whether the entity is in compliance with one named duty in its current state.
  - It uses kit `compliance_check/7`. Each duty is `nm(Duty, obligatory)` while the gate is true; the closure `dora_rts_simplified_policies_and_controls_norm_applies` supplies the norms.
  - Bearer is `financial_entity`. Action is `omit(Duty)` when the duty key is false and `perform(Duty)` when it is true.
  - Verdict is the kit's `verdict(Bearer, Action, Modality, Fired, Ctd)`.
  - An unsure or absent key, or a non-binding gate, is reported through the same status compounds as the queries.
  - Citation: the duty's citation keys.

Fixtures (fixtures.clausal):

- `dora_rts_simplified_policies_and_controls_fixture(Name, Profile)`: named profiles for tests and examples (see the fixture list below).
- `dora_rts_simplified_policies_and_controls_fixture_expected(Name, Query, Result, Citations)`: the gold answers.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`;
  - `check_tri/4` (true/false/absent, never cloned: C15);
  - `eval_requirements/4` (never cloned: R1);
  - `assess/6` with `labels/3`, `summarize/3`, `has_unmet/1`, `has_unknown/1`;
  - `not_defeated/3` (defeasible gate);
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `memberd/2`, `not_member/2`.
- `kit/query_combinators`:
  - `what_if/5` (what-if facade);
  - `failing_ids/4` (cross-check of the outstanding list in tests);
  - `diff_checklists/3` (what-if deltas in tests).
- `kit/compliance_lib`: `compliance_check/7`, `nm/2`, `verdict/5` (query type #13).
- `validate_props`:
  - `run_props/1`;
  - `prop_totality/3`, `prop_determinism/3` (exactly one solution);
  - `prop_citation_complete/3`, `prop_missing_key_coverage/3`;
  - `declare_vacuous/1` for `prop_boundary_coverage` and `prop_monotone`: there is no numeric axis.
- Not used, because the order reads no date, money or period: `deadline_lib`, `date_time`, `rolling_window`, `currency_vocab`, `vat_category`, `country`.
- `list_item/3` is a built-in, available if a positional read is needed. No 1-based helper is hand-rolled.

## Idioms (hard-gated)

- **Defeasible applicability with a guarded once/1 defeater, cut-free.**
  - The default rule: `duty_applies(Duty, Profile)` holds for every duty in `dora_rts_simplified_policies_and_controls_duty/4` when `not_defeated(Duty, Profile, dora_rts_simplified_policies_and_controls_defeater)` holds.
  - The defeater: `dora_rts_simplified_policies_and_controls_defeater(Duty, Profile)` holds when `once(profile_get(Profile, financial_entity_is_article_16_1_entity, false))` holds.
  - Guard: `once/1` sits only on the first-absent and first-unsure selections, over a duty table that is ground and in order. Each answer is thus produced exactly once.
  - No `!`, no `->`, no `*->`.
- **Open texture is handed to the user.** An unsure judgement becomes `needs_legal_review(open_textured(Key, cite(CitationKey)), ...)`. No crisp test replaces it.
- **Folded outputs (C17).** Ground verdict outputs are folded into clause heads, one clause per disjoint route. Each step is made mutually exclusive by guards on the gate value and on the presence of false, absent and unsure keys.
- **Profile access discipline.** Keys are bare atoms, never strings. Values are the atoms true, false and unsure. No Python booleans and no floats are used.
- **Naming.** Full-word names only (C5, C6). Variables use full CamelCase words: `Profile`, `DutyKey`, `FailingDuties`, `CitationKey`.

## Layer files

### kernel.clausal (the shared floor; only what more than one layer needs)

- **`dora_rts_simplified_policies_and_controls_contract_key(Position, Key, Type)`.** Fifty-two facts in root_exports order. Type is `fact` for the gate and `judgement` for the rest. The input check reads it. So do the queries (key order) and the facade.
- **`dora_rts_simplified_policies_and_controls_value_has_type(Type, Value)`.**
  - `fact` accepts true and false.
  - `judgement` accepts true, false and unsure.
  - Values are compared with `==` against ground atoms, so an unbound value never matches.
- **`dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems)`: THE INPUT CHECK.**
  - Order of the problem list:
    1. For each contract key in contract order: `duplicate_key` if the key occurs more than once (values not read), else `wrong_type` if its value is outside its type.
    2. Then `unknown_key`, once per non-contract key, in first-occurrence order. Key identity is `==`, so distinct variables are distinct keys; values are not checked.
  - Not an attribute list (unbound, partial, an unbound element, or a non-`attribute/2` element) gives `[wrong_type(profile)]`.
  - Exactly one solution, never fails, never raises. Built with `findall/3`, `==`-based membership and structural tests. No cut.
- **`dora_rts_simplified_policies_and_controls_gate(Profile, GateState)`.** GateState is `binding`, `not_binding` or `gate_absent`, read with `profile_get/3` and `profile_lacks/2`. It is shared with the facade's eligibility and compliance views.

### citations.clausal

- The twenty citation-key atoms above, as `citation(Key, Instrument, Provision, PinnedUnits)` facts.
- `dora_rts_simplified_policies_and_controls_fixed_citations(Citations)`: the twenty `cite/1` terms in the order above.

### parameters.clausal

No statutory figures. The text sets no threshold, amount, period or date that the order computes (reading 4: 'at least once a year' and 'periodically' are inside the judgement; reading 13: no date). The file declares no `constant_value` and keeps only its module header and a comment recording this.

### queries.clausal

- Implements the three contract queries, steps R, S and M exactly as THE LIMBS state.
- It calls the kernel input check first, then the slice's predicates.
- Each query has exactly one solution. Every status compound carries `Citations []`.

### fixtures.clausal

Named profiles, each with expected answers for all three queries:

- `all_duties_performed` - gate true, 51 true: complete / required / none_outstanding.
- `not_article_16_1_entity_gate_false` - also with duty keys present.
- `gate_absent` - also with one duty false: indeterminate on the gate.
- `one_duty_false` - `premises_and_data_centres_protected` false: incomplete / outstanding with art_32_2 and art_32_3.
- `several_duties_false` - outstanding in DUTY ORDER, with citations deduplicated.
- `false_and_absent` - complete gives incomplete; outstanding gives indeterminate on the first absent key.
- `false_and_unsure` - complete gives incomplete; outstanding gives needs_legal_review.
- `absent_before_unsure` - the absent key is named, not the unsure one.
- `first_unsure_referred` - PAIRS lists every present pair, gate included, in key order.
- `gate_unsure_wrong_type`.
- `duplicate_contract_key` - equal and unequal values.
- `unknown_keys` - `financial_entity_is_microenterprise` and `dora_entity_type`; a non-atom key; distinct unbound variable keys.
- `unbound_contract_value`.
- `not_an_attribute_list` - unbound, partial list, foreign element.
- `numeric_value_wrong_type` - 1 and 1.0.

## Determination slice: dora_rts_simplified_policies_and_controls.clausal

This is the only slice. It is self-contained for the legal concept 'the duties of the simplified ICT risk management framework, RTS Title III, Articles 28 to 35', and owns everything below.

### Statutory value facts it owns

- **The duty table.** `dora_rts_simplified_policies_and_controls_duty(Position, DutyAtom, ProfileKey, CitationKeys)` holds 51 facts in DUTY ORDER, exactly as the interface table:
  - CitationKeys is a list.
  - Duty 28, `protection_of_premises_and_data_centres`, has `[eu_reg_2024_1774_art_32_2, eu_reg_2024_1774_art_32_3]`.
  - Every other duty has one key.
- **The referral rows.** `dora_rts_simplified_policies_and_controls_referral(ProfileKey, cite(FirstCitationKey), Inputs)` holds 51 rows. Inputs is all fifty-two contract keys in root_exports order.
- **No thresholds, periods or tables beyond these.**

### Rules / requirements

1. **Applicability.** `duty_applies/2` holds by default for every duty. The gate defeater (false gate) defeats it, through `not_defeated/3`. There is no other condition.
2. **`dora_rts_simplified_policies_and_controls_requirement(DutyAtom, Profile, Status, Citation)`.** The requirement id comes first, as `assess/6` and `eval_requirements/4` call it. It has mutually exclusive clauses with ground Status folded into the head where possible:
   - Unsure (`profile_get(Profile, Key, unsure)`) gives `unknown([Key])`.
   - A value of true or false, or absent, is delegated to `check_tri(Profile, Key, not_performed(Key), Status)`.

   Citation is `cite(FirstCitationKey)`.
3. **Failing duty.** `duty_fails(Profile, DutyAtom)` holds when the gate is true and the key is false.
4. **Failing list.** `failing_duties(Profile, Duties)` is the `findall/3` over the duty table in Position order, so it comes out in DUTY ORDER.
5. **First absent duty key.** `first_absent_duty_key(Profile, Key)` is `once/1` over the ordered duty table with `profile_lacks/2`.
6. **First unsure duty key.** `first_unsure_duty_key(Profile, Key)` is `once/1` over the ordered table with `profile_get(Profile, Key, unsure)`.
7. **Pairs.** `relied_on_pairs(Profile, Pairs)` lists `Key-Value` for each contract key present, in root_exports order, with the value exactly as given. The gate and the unsure key are included.
8. **Union of citations.** `duty_citations_union(Duties, Citations)` gives the `cite/1` terms of the listed duties, each written once.
9. **Helper guards.** `any_duty_false/1`, `any_duty_absent/1` and `any_duty_unsure/1` make the S and M steps mutually exclusive without cut or if-then-else.

### Verdict atoms

- `required/1`, `not_article_16_1_entity`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`;
- the status compounds `indeterminate/1`, `needs_legal_review/2` with `open_textured/2` and `inputs_relied_on/1`, and `input_problems/1`;
- the checklist labels `duties_complete`, `duties_undetermined`, `duties_incomplete`.

### Predicates shared with another layer (these, and only these, go in kernel.clausal)

- `dora_rts_simplified_policies_and_controls_contract_key/3`
- `dora_rts_simplified_policies_and_controls_value_has_type/2`
- `dora_rts_simplified_policies_and_controls_input_problems/2`
- `dora_rts_simplified_policies_and_controls_gate/2`

The slice imports them from the kernel. Nothing else is shared.

### Per-rule tests (tests/; seven modes)

1. **Unit.** Each R, S and M step on its fixture, plus each duty's requirement on true, false, unsure and absent.
2. **Contract shape.** Functor, arity and argument positions. The bare atom `indeterminate` never appears.
3. **Determinism / counting.** Every query, the input check and the facade give exactly one solution per fixture, checked with `findall` and `length` = 1.
4. **Precedence.**
   - The input check comes before the gate.
   - A false gate comes before every duty key.
   - A false duty comes before absent and unsure keys in `complete`.
   - Absent comes before unsure.
   - The gate is named before duty keys.
5. **Citation.**
   - Final answers carry the fixed twenty, compared as a set.
   - `outstanding` carries the union.
   - Status compounds carry [].
   - `open_textured` carries the referral cite.
6. **Completion soundness.** For small sets of absent and unsure keys, every completion to true and to false agrees with the step's answer whenever the completions agree.
7. **Input check edge cases.**
   - duplicates, including duplicates with ill-typed values: `duplicate_key` only;
   - unknown keys and their values;
   - variable keys;
   - 7 and 7.0 as two keys;
   - floats as values;
   - unbound profile, partial list, foreign element.

Each `test(Name, fail)` is paired with a positive test over the same case.

## Totality and determinism claims

- All four contract predicates and the facade predicates are total over every term, and yield exactly one solution. The input check never fails or raises.
- Duty lists are in DUTY ORDER, each atom once.
- PAIRS and PROBLEMS orders are as fixed above.
- These claims are checked by `prop_totality/3` and `prop_determinism/3` over the fixtures plus generated profiles: every gate value, plus single false, absent and unsure perturbations of each of the 51 duty keys.
