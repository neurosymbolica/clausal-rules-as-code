# SIGNATURE — eu/dora_ict_risk_response_and_recovery

## Public query surface

The package facade exposes the three contract queries, the input check, and the scaffold facade:

- `decide_dora_ict_risk_response_and_recovery(PROFILE, dora_ict_risk_response_and_recovery_verdict(STATUS, CITATIONS))`. STATUS and CITATIONS are exactly the RESULT and CITATIONS of `ict_risk_response_and_recovery_duties_complete/3`.
- `dora_ict_risk_response_and_recovery_status(PROFILE, STATUS)`.

The properties of the surface:

- **Total**: every query yields a RESULT for every term, a non-list included.
- **Deterministic**: EXACTLY ONE solution per call (COUNTING). The scorer collects every solution.
- **Cut-free.** Single-solution routes come from:
  - disjoint clause heads, one per route, with the ground verdict folded into the head (C17);
  - `once/1`-guarded selection of 'the first' key;
  - `findall/3` over duty order.
- No `!`, `->` or `*->`.
- No value is a float, a string, or a Python boolean.
- No figure is imported or declared. The order has no numeric parameters.

## Verdict STATUS atoms (replacing the placeholders required / permitted / not_applicable)

Final answers:

- `required(DUTIES)`, arity 1. Required query only.
- `complete`.
- `incomplete`.
- `none_outstanding`.
- `outstanding(DUTIES)`, arity 1.
- `simplified_framework_entity`. All three queries.

Status compounds (CITATIONS always `[]`):

- `indeterminate([KEY])`. Exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`. CONTEXT may optionally carry one unscored `provenance(CLAUSE, CITATIONS)` as its last item. This order omits it.
- `input_problems(PROBLEMS)`.

Result constructors are exported and never called as queries:

- required/1, outstanding/1, indeterminate/1;
- needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2;
- input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1.

verdict_vocabulary pins:

- complete, incomplete, none_outstanding, simplified_framework_entity;
- required/1, outstanding/1;
- the thirty-seven duty atoms.

NEVER pinned: true, false, unsure.

Eligibility mapping (query type #2): complete is eligible, incomplete is ineligible, and `indeterminate([KEY])` or `needs_legal_review/2` is undetermined.

## Profile keys (root_exports and input_contract order; all bare atoms; no numeric keys, no dates)

PROFILE is `[attribute(KEY, VALUE), ...]`. It is read only with `profile_get/3` and `profile_has/2` / `profile_lacks/2` from formalize_lib.

| # | Key | Type |
|---|---|---|
| 1 | financial_entity_is_article_16_1_entity | fact: true / false (the GATE) |
| 2 | financial_entity_is_microenterprise | fact: true / false |
| 3 | dora_entity_type | entity_type: one of 29 atoms |
| 4 | business_continuity_or_response_and_recovery_plans_activated | fact (trigger) |
| 5 | authority_requested_estimate_of_annual_ict_incident_costs_and_losses | fact (trigger) |
| 6 | backup_data_restored_using_own_systems | fact (trigger) |
| 7 | recovered_from_ict_related_incident | fact (trigger) |
| 8 | data_reconstructed_from_external_stakeholders | fact (trigger) |
| 9-45 | the thirty-seven duty keys, in duty order (slice table below) | judgement: true / false / unsure |

The twenty-nine entity_type atoms:

- credit_institution, institution_exempted_pursuant_to_directive_2013_36
- payment_institution, exempted_payment_institution, account_information_service_provider
- electronic_money_institution, exempted_electronic_money_institution
- investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens
- central_securities_depository, central_counterparty, trading_venue, trade_repository
- manager_of_alternative_investment_funds, management_company, data_reporting_service_provider
- insurance_undertaking, reinsurance_undertaking
- insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary
- institution_for_occupational_retirement_provision
- credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository
- ict_third_party_service_provider, none_of_the_listed_types

## Citation-key atoms (citations.clausal; canonical _lexicon/citations.yaml scheme; never shortened)

The lexicon's canonical prefix `eu_reg_2022_2554` is kept verbatim. Its segment `reg` is the lexicon scheme, not a new abbreviation; it carries a `% lint: lexicon citation key` pragma.

Article 11:

- eu_reg_2022_2554_art_11_1
- eu_reg_2022_2554_art_11_2, plus points eu_reg_2022_2554_art_11_2_a, _b, _c, _d, _e
- eu_reg_2022_2554_art_11_3, eu_reg_2022_2554_art_11_4, eu_reg_2022_2554_art_11_5
- eu_reg_2022_2554_art_11_6, plus points eu_reg_2022_2554_art_11_6_a, eu_reg_2022_2554_art_11_6_b
- eu_reg_2022_2554_art_11_7, eu_reg_2022_2554_art_11_8, eu_reg_2022_2554_art_11_9, eu_reg_2022_2554_art_11_10

Article 12:

- eu_reg_2022_2554_art_12_1, plus points eu_reg_2022_2554_art_12_1_a, eu_reg_2022_2554_art_12_1_b
- eu_reg_2022_2554_art_12_2, eu_reg_2022_2554_art_12_3, eu_reg_2022_2554_art_12_4
- eu_reg_2022_2554_art_12_5, plus points eu_reg_2022_2554_art_12_5_a, _b, _c
- eu_reg_2022_2554_art_12_6, eu_reg_2022_2554_art_12_7

Article 16:

- eu_reg_2022_2554_art_16_1

The FIXED CITATIONS are the seventeen paragraph keys: 11_1 to 11_10 and 12_1 to 12_7.

## Public predicates

- `ict_risk_response_and_recovery_duties_required(Profile, Result, Citations)`: which duties apply. Steps R0, R-G1, R-G2, R1, R2. Citations:
  - R2: the paragraph of each listed duty;
  - gate true: [cite(eu_reg_2022_2554_art_16_1)];
  - status compounds: [].

  Provisions: DORA Art 11, Art 12, Art 16(1).
- `ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations)`: whether every applying duty is performed. Steps S0, S-G1, S-G2, S1 to S5. Citations: the fixed citations, or Art 16(1). This is the compliance_check (#13) and the eligibility (#2) query. Provisions: DORA Art 11(1)-(10), Art 12(1)-(7), Art 16(1).
- `ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations)`: which applying duties fail, in duty order. Steps M0, M-G1, M-G2, M1 to M3. Citations: each outstanding duty's own key, or the fixed citations for none_outstanding. Provisions: DORA Art 11, Art 12, Art 16(1).
- `dora_ict_risk_response_and_recovery_input_problems(Profile, Problems)`: typed input check against input_contract. Exactly one solution; never fails; never raises.
- `decide_dora_ict_risk_response_and_recovery(Profile, Verdict)`: Verdict is `dora_ict_risk_response_and_recovery_verdict(Status, Citations)` from duties_complete. Provisions: DORA Art 11, Art 12, Art 16(1).
- `dora_ict_risk_response_and_recovery_status(Profile, Status)`: Status only, from duties_complete. Provisions: DORA Art 11, Art 12.
- `dora_ict_risk_response_and_recovery_checklist(Profile, Checklist)`: the justification query (#7).
  - Checklist is one `item(DutyAtom, Status, cite(CitationKey))` per duty, in duty order, built with `eval_requirements/4` over the slice's requirement/4 closure.
  - Status is one of:
    - met;
    - `unmet(not_performed)`;
    - `unknown([KEY])` when the key is absent or unsure;
    - inapplicable, when a condition fails or the gate is true;
    - `unknown([CONDITION_KEY])` when a condition is open.
  - Every item carries cite(...), met items included.
  - For a non-attribute-list profile the checklist is [].
- `dora_ict_risk_response_and_recovery_what_if(Profile, Key, Value, Verdict)`: the verdict of `decide_dora_ict_risk_response_and_recovery/2` on Profile with attribute(Key, Value) overriding or adding Key. Uses kit `what_if/5` with Decide closure `decide_dora_ict_risk_response_and_recovery`. Provisions: DORA Art 11, Art 12.
- `dora_ict_risk_response_and_recovery_fixture(Name, Profile)` and `dora_ict_risk_response_and_recovery_fixture_expected(Name, Query, Result, Citations)`: named fixtures (fixtures.clausal), each tied to a reading.

## Planned reuse (manifest uses:)

- **formalize_lib**:
  - profile_get/3, profile_has/2, profile_lacks/2, profile_set/3;
  - check_tri/4: duty-key status in the checklist; unsure is reported as unknown;
  - eval_requirements/4, item/3, unmet/1, unknown/1;
  - not_defeated/3: guarded defeaters;
  - not_member/2, memberd/2;
  - vocabulary atoms met and inapplicable.
- **kit/query_combinators**: what_if/5, diff_checklists/3 (what-if test mode).
- **validate_props** (tests only):
  - run_props/1;
  - prop_totality/3, prop_determinism/3;
  - prop_citation_complete/3, prop_missing_key_coverage/3;
  - bad_citation/1.
- **Not used, with the reason:**
  - kit/compliance_lib: single modality; precedence is the LIMBS step order.
  - kit/deadline_lib, kit/rolling_window, date_time: no dates are read (reading (9), reading (18)).
  - currency_vocab, vat_category, country: none applies.

## Kernel (kernel.clausal): the shared floor only

There is one determination slice, so no predicate is shared between slices. The kernel holds only what the queries and facade layers also call:

- `dora_ict_risk_response_and_recovery_contract_key(Ordinal, Key, Type)`: the forty-five rows in root_exports order. Type is gate_fact, fact, entity_type or judgement.
- `dora_ict_risk_response_and_recovery_entity_type_atom(Atom)`: the twenty-nine atoms.
- `dora_ict_risk_response_and_recovery_input_problems/2`. Its logic:
  1. Attribute-list test. A variable, a partial list, an unbound element, or any non-attribute/2 element gives [wrong_type(profile)].
  2. Per contract key, in contract order:
     - duplicate_key(KEY) if it occurs twice or more (counted with ==; values not read);
     - else wrong_type(KEY) if its value fails its type. Var values and numbers always fail.
  3. unknown_key(KEY) for each non-contract key, by first occurrence, compared with ==. A variable key is reported as the same variable.

## Slice: dora_ict_risk_response_and_recovery.clausal (self-contained)

### Value facts it owns

There are no thresholds, periods or money: no constant_value. The statutory content is a closed table.

- `dora_ict_risk_response_and_recovery_duty(Ordinal, Duty, Key, CitationKey, ParagraphKey)`: thirty-seven rows, listed below.
- `dora_ict_risk_response_and_recovery_duty_condition(Duty, ConditionKey, Value)`: zero or more rows per duty. No duty has two conditions on the same key.
- `dora_ict_risk_response_and_recovery_condition_key(Key)`: the seven keys that carry conditions, in key order.
- `dora_ict_risk_response_and_recovery_fixed_citations(List)`: the seventeen paragraph cites.
- `dora_ict_risk_response_and_recovery_referral_citation(Key, cite(CitationKey))`: equal to the duty's CitationKey column.

| # | Duty | Key | Citation | Paragraph | Conditions |
|---|---|---|---|---|---|
| 1 | ict_business_continuity_policy | has_ict_business_continuity_policy | art_11_1 | art_11_1 | always |
| 2 | continuity_policy_implementation_arrangements | continuity_policy_implemented_through_documented_arrangements | art_11_2 | art_11_2 | always |
| 3 | continuity_of_critical_or_important_functions | arrangements_ensure_continuity_of_critical_or_important_functions | art_11_2_a | art_11_2 | always |
| 4 | incident_response_and_resolution | arrangements_respond_to_and_resolve_ict_related_incidents | art_11_2_b | art_11_2 | always |
| 5 | activation_of_containment_plans | arrangements_activate_containment_plans_without_delay | art_11_2_c | art_11_2 | always |
| 6 | estimation_of_impacts_damages_and_losses | arrangements_estimate_preliminary_impacts_damages_and_losses | art_11_2_d | art_11_2 | always |
| 7 | communication_and_crisis_management_actions | arrangements_set_out_communication_and_crisis_management_actions | art_11_2_e | art_11_2 | always |
| 8 | ict_response_and_recovery_plans | ict_response_and_recovery_plans_implemented | art_11_3 | art_11_3 | always |
| 9 | independent_internal_audit_review_of_response_and_recovery_plans | response_and_recovery_plans_subject_to_independent_internal_audit_reviews | art_11_3 | art_11_3 | microenterprise false |
| 10 | ict_business_continuity_plans | ict_business_continuity_plans_in_place_maintained_and_periodically_tested | art_11_4 | art_11_4 | always |
| 11 | business_impact_analysis | business_impact_analysis_conducted | art_11_5 | art_11_5 | always |
| 12 | alignment_with_business_impact_analysis | ict_assets_and_services_aligned_with_business_impact_analysis | art_11_5 | art_11_5 | always |
| 13 | yearly_testing_of_continuity_and_response_and_recovery_plans | plans_tested_at_least_yearly_and_on_substantive_changes | art_11_6_a | art_11_6 | always |
| 14 | testing_of_crisis_communication_plans | crisis_communication_plans_tested | art_11_6_b | art_11_6 | always |
| 15 | cyber_attack_and_switchover_scenarios_in_testing_plans | testing_plans_include_cyber_attack_and_switchover_scenarios | art_11_6 | art_11_6 | microenterprise false |
| 16 | regular_review_of_continuity_policy_and_plans | continuity_policy_and_plans_regularly_reviewed | art_11_6 | art_11_6 | always |
| 17 | crisis_management_function | has_crisis_management_function | art_11_7 | art_11_7 | microenterprise false |
| 18 | records_of_activities_during_disruption_events | records_of_activities_during_disruption_events_kept | art_11_8 | art_11_8 | plans_activated true |
| 19 | continuity_test_results_to_competent_authorities | continuity_test_results_provided_to_competent_authorities | art_11_9 | art_11_9 | type central_securities_depository |
| 20 | estimate_of_aggregated_annual_costs_and_losses | estimate_of_aggregated_annual_costs_and_losses_reported | art_11_10 | art_11_10 | microenterprise false AND authority_requested true |
| 21 | backup_policies_and_procedures | backup_policies_and_procedures_developed_and_documented | art_12_1_a | art_12_1 | always |
| 22 | restoration_and_recovery_procedures_and_methods | restoration_and_recovery_procedures_and_methods_developed_and_documented | art_12_1_b | art_12_1 | always |
| 23 | backup_systems | backup_systems_that_can_be_activated_set_up | art_12_2 | art_12_2 | always |
| 24 | secure_activation_of_backup_systems | backup_activation_does_not_jeopardise_security | art_12_2 | art_12_2 | always |
| 25 | periodic_testing_of_backup_and_restoration_procedures | backup_and_restoration_procedures_periodically_tested | art_12_2 | art_12_2 | always |
| 26 | segregated_and_protected_restoration_systems | restoration_uses_segregated_and_protected_ict_systems | art_12_3 | art_12_3 | backup_data_restored_using_own_systems true |
| 27 | recovery_of_all_transactions | recovery_plans_enable_recovery_of_all_transactions | art_12_3 | art_12_3 | type central_counterparty |
| 28 | data_reporting_resources_and_facilities | adequate_resources_and_backup_and_restoration_facilities_maintained | art_12_3 | art_12_3 | type data_reporting_service_provider |
| 29 | redundant_ict_capacities | redundant_ict_capacities_maintained | art_12_4 | art_12_4 | microenterprise false |
| 30 | assessment_of_need_for_redundant_ict_capacities | need_for_redundant_ict_capacities_assessed | art_12_4 | art_12_4 | microenterprise true |
| 31 | secondary_processing_site | secondary_processing_site_maintained | art_12_5 | art_12_5 | type central_securities_depository |
| 32 | secondary_site_at_geographical_distance | secondary_site_located_at_geographical_distance | art_12_5_a | art_12_5 | type central_securities_depository |
| 33 | secondary_site_capable_of_ensuring_continuity | secondary_site_can_ensure_continuity_of_critical_or_important_functions | art_12_5_b | art_12_5 | type central_securities_depository |
| 34 | secondary_site_immediately_accessible | secondary_site_immediately_accessible_to_staff | art_12_5_c | art_12_5 | type central_securities_depository |
| 35 | recovery_time_and_recovery_point_objectives | recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account | art_12_6 | art_12_6 | always |
| 36 | data_integrity_checks_when_recovering | data_integrity_checks_performed_when_recovering | art_12_7 | art_12_7 | recovered_from_ict_related_incident true |
| 37 | data_consistency_checks_when_reconstructing_data | data_consistency_checks_performed_when_reconstructing_data | art_12_7 | art_12_7 | data_reconstructed_from_external_stakeholders true |

Notes on the table:

- Citation and Paragraph cells abbreviate the full atom `eu_reg_2022_2554_` + cell. The cells are written out in full in the file.
- In the Conditions column:
  - `microenterprise` stands for `financial_entity_is_microenterprise`;
  - `plans_activated` stands for `business_continuity_or_response_and_recovery_plans_activated`;
  - `authority_requested` stands for `authority_requested_estimate_of_annual_ict_incident_costs_and_losses`;
  - `type` stands for `dora_entity_type`.

### Rules / requirements (defeasible, cut-free)

**Condition state.** `dora_ict_risk_response_and_recovery_condition_state(Profile, ConditionKey, Value, State)` gives State as holds, fails or open. It has three disjoint clauses: present with Value, present with another value, absent.

**Defeaters.** These are guarded with once/1 and consumed through formalize_lib `not_defeated/3`:

- `defeater(article_16_1_gate, Duty, Profile)` when the gate is true;
- `defeater(condition_fails, Duty, Profile)` when some condition of Duty fails. This covers the microenterprise exceptions and the type and trigger conditions.

**Duty predicates.**

- `dora_ict_risk_response_and_recovery_duty_applies(Profile, Duty)`: every condition holds and the duty is not defeated.
- `dora_ict_risk_response_and_recovery_duty_open(Profile, Duty)`: no condition fails.
- `dora_ict_risk_response_and_recovery_duty_fails(Profile, Duty)`: the duty applies and its key is false.
- `dora_ict_risk_response_and_recovery_key_not_true(Profile, Key)`: the key is false, unsure or absent.

**requirement/4 closure.** `dora_ict_risk_response_and_recovery_requirement(Duty, Profile, Status, cite(CitationKey))`. RequirementId comes first. It has three exclusive routes per duty, via check_tri/4 on applying duties, plus the inapplicable route. It is consumed by eval_requirements/4 for the checklist.

**Required query, step R1.** The first absent condition key, in key order, that is a condition of some open duty. An absent microenterprise or type key always qualifies. The trigger of Art 11(10) does not qualify while microenterprise is true.

**Complete query, step S2.** Microenterprise is absent, and for EACH of true and false there is some duty whose key is false that has that microenterprise value as a condition and all its other conditions holding.

**Complete query, step S4 (can still change the answer).**

- (a) The key of an open duty D, when no other false-keyed duty has each of its conditions holding or among D's conditions.
- (b) A condition key X with values V and W such that:
  - some open duty D, whose condition on X holds for V and not for W, has a key that is not true; and
  - no false-keyed duty E other than D has, at once, a condition on X holding for W (or none on X) and every other condition holding or among D's conditions.
- Values range over true/false, or over the twenty-nine type atoms.

**DECIDES ALONE.** The key of an applying duty; or a condition key X with some value V such that a false-keyed duty has a condition on X holding for V and all its other conditions holding.

**BEHIND.** X is behind Y when Y decides alone and X does not. The key named is the first, in key order, among the absent keys that can still change the answer and are not behind another of them.

**Step S5.** The first unsure judgement key that satisfies (a).

**Outstanding query, step M1.** The first absent key that is either the key of an open duty, or a condition key of an open duty whose key is not true.

**Outstanding query, step M2.** The first unsure key of an open duty.

**PAIRS.** Every attribute present in PROFILE, as `KEY-VALUE` with the value as given, in key order. Each referral row's inputs are all forty-five keys.

### Verdict atoms owned by this slice

- complete, incomplete, none_outstanding, simplified_framework_entity;
- required/1, outstanding/1;
- the thirty-seven duty atoms, which are result atoms only and never profile keys.

### Shared with another slice

None. The only floor used is kernel's contract table and input check.

## Queries layer (queries.clausal)

- The three contract queries are written as one clause per LIMBS step.
- Each step's guard negates the earlier steps through disjoint conditions, so the first step that answers decides.
- 'The first key' is selected with once/1 over the contract_key ordinal enumeration.
- Lists are built with findall/3 in duty order. Citation lists are deduplicated with sort/2; order is not scored.

## Fixtures (fixtures.clausal)

One named fixture per reading, including at least:

- gate_true: simplified_framework_entity.
- gate_absent.
- large credit institution, all true, no triggers: complete; required lists 23 duties.
- microenterprise, all true: complete.
- central securities depository with secondary site false: outstanding([secondary_processing_site]).
- central counterparty with recovery_of_all_transactions unsure: needs_legal_review.
- microenterprise absent, with duty 9 false and duty 30 false: S2 incomplete.
- absent duty key behind an absent trigger.
- an Art 11(10) request with microenterprise true: the trigger is not read.
- input problems:
  - a duplicate key;
  - unsure on a fact;
  - a number value;
  - a variable key;
  - a non-list profile.

## Tests (seven modes)

1. Load.
2. Per-rule: one test per duty row and condition.
3. Fixtures against expected.
4. Properties via validate_props: totality, determinism (exactly one solution), citation completeness, missing-key coverage.
5. Input check.
6. What-if.
7. Checklist justification: every item carries cite.

Every `test(_, fail)` is paired with a positive test over the same case.
