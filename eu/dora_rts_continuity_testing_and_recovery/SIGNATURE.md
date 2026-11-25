# SIGNATURE — eu/dora_rts_continuity_testing_and_recovery

Shape family: deontic.

Layout: `kernel -> citations -> parameters -> dora_rts_continuity_testing_and_recovery -> queries -> fixtures -> package facade`.

The public query surface consists of:

- three contract queries;
- the input check;
- the scaffold facade (decide / status / checklist / what_if);
- the three required query types: compliance_check #13, eligibility #2 and justification #7.

Every public predicate:

- takes PROFILE, an attribute list `[attribute(Key, Value), ...]` read only with `formalize_lib:profile_get/3`;
- is TOTAL;
- is DETERMINISTIC: exactly one solution per call, cut-free. It uses no `!`, `->` or `*->`. The gate and the step precedence are guarded `once/1` defeaters over mutually exclusive clauses.

This order declares no numeric statutory figure (no threshold, period or date; reading (15)). So there is no `constant_value/2`, and nothing is imported from another domain's parameters.

## 1. Verdict / status atoms (replace the placeholder `{required, permitted, not_applicable}`)

**Final answers**

- `required(Duties)`: arity 1. `Duties` is a non-empty list of duty atoms in DUTY ORDER.
- `complete`, `incomplete`: atoms.
- `none_outstanding`: atom.
- `outstanding(Duties)`: arity 1. `Duties` is non-empty, in DUTY ORDER.
- `simplified_framework_entity`: atom (the DORA Art 16(1) gate).

**Status compounds** (never final; CITATIONS always `[]`)

- `input_problems(Problems)`, where each problem is one of:
  - `duplicate_key(Key)`
  - `wrong_type(Key)`
  - `unknown_key(Key)`
  - `wrong_type(profile)`
- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`.
  - An unscored `provenance(Clause, Citations)` may follow it.
  - `Pairs` is every `Key-Value` present in PROFILE, in root_exports order, with the unsure one included.

**Facade eligibility labels** (query type #2), via `labels(Pos, Indet, Neg)`:

- `eligible`: all applicable duties performed, i.e. `complete`;
- `ineligible`: `incomplete`;
- `indeterminate_eligibility`: any status compound.

These labels are facade-only and never replace the contract atoms.

**Compliance-check verdicts** (query type #13): `compliant`, `non_compliant`, `not_applicable`.

- `not_applicable` = the gate is true;
- `non_compliant` = at least one duty fails;
- `compliant` = none fails.

A status compound is passed through unchanged.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## 2. Profile keys (27, in root_exports / input_contract order)

| # | Key | Type |
|---|---|---|
| 1 | `financial_entity_is_article_16_1_entity` | fact: `true` / `false` (THE GATE) |
| 2 | `financial_entity_is_microenterprise` | fact: `true` / `false` |
| 3 | `dora_entity_type` | entity_type: one of 29 atoms |
| 4 | `financial_entity_uses_ict_services_of_ict_third_party_service_providers` | fact: `true` / `false` (THE TRIGGER) |
| 5 | `continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment` | judgement |
| 6 | `continuity_testing_assesses_continuity_of_critical_or_important_functions` | judgement |
| 7 | `continuity_testing_based_on_scenarios_including_severe_but_plausible_scenarios` | judgement |
| 8 | `continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers` | judgement |
| 9 | `continuity_testing_contains_switchover_scenarios` | judgement |
| 10 | `continuity_testing_challenges_assumptions_of_business_continuity_plans` | judgement |
| 11 | `continuity_testing_contains_procedures_to_verify_ability_to_respond` | judgement |
| 12 | `continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions` | judgement |
| 13 | `continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions` | judgement |
| 14 | `continuity_test_results_documented` | judgement |
| 15 | `continuity_test_deficiencies_analysed_addressed_and_reported_to_management_body` | judgement |
| 16 | `response_and_recovery_plans_take_into_account_business_impact_analysis` | judgement |
| 17 | `response_and_recovery_plans_specify_activation_and_deactivation_conditions_and_exceptions` | judgement |
| 18 | `response_and_recovery_plans_describe_actions_for_ict_systems_and_services_supporting_critical_or_important_functions` | judgement |
| 19 | `response_and_recovery_plans_designed_to_meet_recovery_objectives` | judgement |
| 20 | `response_and_recovery_plans_documented_available_and_accessible_with_roles_and_responsibilities` | judgement |
| 21 | `response_and_recovery_plans_provide_short_term_and_long_term_recovery_options` | judgement |
| 22 | `response_and_recovery_plans_lay_down_objectives_and_conditions_of_successful_execution` | judgement |
| 23 | `response_and_recovery_plans_identify_relevant_scenarios` | judgement |
| 24 | `response_and_recovery_plans_develop_scenarios_on_current_threat_information_and_lessons_learned` | judgement |
| 25 | `listed_disruption_scenarios_duly_taken_into_account` | judgement |
| 26 | `response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible` | judgement |
| 27 | `continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented` | judgement |

**Types**

- **judgement**: `one_of(boolean, unsure)`, i.e. the atoms `true`, `false`, `unsure`.
- **fact**: `boolean`, i.e. the atoms `true`, `false`. `unsure` is wrong_type.
- **entity_type**: an enum of these 29 atoms. Any other atom, `unsure`, or an unbound value is wrong_type.
  - credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution;
  - account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm;
  - crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty;
  - trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider;
  - insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary;
  - institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider;
  - securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types.

**Other key rules**

- There are no numeric, money or date keys. A number given as a value is wrong_type.
- The conditioning keys are #2, #3 and #4.
- Duty atoms are result atoms only, never profile keys.

## 3. Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; citation_vocabulary)

Each is used as `cite(Key)`. No shortened atom is ever invented.

**Gate**

- `eu_reg_2022_2554_art_16_1`

**Article 25 of the RTS**

- `eu_reg_2024_1774_art_25_1`
- `eu_reg_2024_1774_art_25_2`, with the points `eu_reg_2024_1774_art_25_2_a`, `_2_b`, `_2_c`, `_2_d`, `_2_e`
- `eu_reg_2024_1774_art_25_3`, with the points `eu_reg_2024_1774_art_25_3_a`, `_3_b`, `_3_c`
- `eu_reg_2024_1774_art_25_4`, with the points `eu_reg_2024_1774_art_25_4_a`, `_4_b`, `_4_c`, `_4_d`, `_4_e`
- `eu_reg_2024_1774_art_25_5`

**Article 26 of the RTS**

- `eu_reg_2024_1774_art_26_1`, with the points `eu_reg_2024_1774_art_26_1_a` … `_1_f`
- `eu_reg_2024_1774_art_26_2`, with the points `eu_reg_2024_1774_art_26_2_a` … `_2_i`
- `eu_reg_2024_1774_art_26_3`
- `eu_reg_2024_1774_art_26_4`

All point atoms are written out in full in `citations.clausal`.

**THE FIXED CITATIONS** (for `complete`, `incomplete` and `none_outstanding`):

`[cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_3), cite(eu_reg_2024_1774_art_25_4), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3), cite(eu_reg_2024_1774_art_26_4)]`

The units that carry no rule are pinned but never cited:

- the headings `32024R1774#art_025`, `32024R1774#art_026` and `32022R2554#art_016`;
- DORA Art 16(1)(a)–(h), 16(2) and 16(3)(a)–(e).

## 4. Public predicates

**Contract queries** (in `queries.clausal`, re-exported by the facade):

- `rts_continuity_testing_and_recovery_duties_required(Profile, Result, Citations)`: which duties apply. Steps R0 → R-G1 → R-G2 → R1 → R2.
  - It reads only the gate and the conditioning keys, and never refers.
  - Result: `required(Duties)`, `simplified_framework_entity`, `indeterminate([Key])` or `input_problems(P)`.
  - Citations: the paragraph of each listed duty, once each; or `[cite(eu_reg_2022_2554_art_16_1)]`; or `[]`.
  - Cites RTS Art 25(1)–(5) and 26(1)–(4), and DORA Art 16(1).
- `rts_continuity_testing_and_recovery_duties_complete(Profile, Result, Citations)`: whether every applicable duty is performed. Steps S0 → S-G1 → S-G2 → S1 → S2 → S3 → S4. S3 is the <<DNUM>> key-naming step.
  - Result: `complete`, `incomplete`, `simplified_framework_entity`, `indeterminate([Key])`, `needs_legal_review(...)` or `input_problems(P)`.
  - Citations: THE FIXED CITATIONS for `complete` / `incomplete`.
  - Cites RTS Arts 25 and 26 and DORA Art 16(1).
- `rts_continuity_testing_and_recovery_duties_outstanding(Profile, Result, Citations)`: which applicable duties are not performed. Steps M0 → M-G1 → M-G2 → M1 → M2 → M3. A false key does not end this query.
  - Result: `none_outstanding`, `outstanding(Duties)`, `simplified_framework_entity` or a status.
  - Citations: THE FIXED CITATIONS for `none_outstanding`; otherwise each outstanding duty's own citations, once each.
  - Cites RTS Arts 25 and 26 and DORA Art 16(1).
- `dora_rts_continuity_testing_and_recovery_input_problems(Profile, Problems)`: THE INPUT CHECK. It yields one solution, never fails and never raises.
  - For each contract key, in contract order: `duplicate_key` if the key repeats (its values are not read), else `wrong_type` if its value is outside its type.
  - Then `unknown_key` for each non-contract key, in first-occurrence order, compared with `==`.
  - It returns `[wrong_type(profile)]` for a profile that is not an attribute list (an unbound profile, a partial list, or an unbound or malformed element).
  - Cites the input contract (no legal citation).

**Scaffold facade** (in the package facade):

- `decide_dora_rts_continuity_testing_and_recovery(Profile, Verdict)`.
  - `Verdict = dora_rts_continuity_testing_and_recovery_verdict(Status, Citations)`, where `Status, Citations` are the Result and Citations of `..._duties_complete/3`.
  - Cites RTS Arts 25 and 26 and DORA Art 16(1).
- `dora_rts_continuity_testing_and_recovery_status(Profile, Status)`: `Status` alone from `..._duties_complete/3`. Same citations.
- `dora_rts_continuity_testing_and_recovery_checklist(Profile, Checklist)`: query type #7, justification.
  - `Checklist` is a list of `item(DutyAtom, ItemStatus, cite(FirstCitationKey))` for every duty, in DUTY ORDER.
  - ItemStatus is one of:
    - `met`;
    - `unmet(duty_not_performed)`;
    - `unknown([Key])`, for an absent key or an unsure judgement;
    - `inapplicable`, for a duty whose condition fails.
  - It is built with `formalize_lib:eval_requirements/4` over the injected `dora_rts_continuity_testing_and_recovery_requirement/4`.
  - Each item cites its own RTS provision.
- `dora_rts_continuity_testing_and_recovery_what_if(Profile, Key, Value, Verdict)`: the decide verdict on the profile with `Key` set to `Value`. It uses `kit/query_combinators:what_if/5` with the closure `decide_dora_rts_continuity_testing_and_recovery`. Same citations.
- `dora_rts_continuity_testing_and_recovery_eligibility(Profile, Decision)`: query type #2.
  - It uses `formalize_lib:assess/6` with `labels(eligible, indeterminate_eligibility, ineligible)` over the requirement closure.
  - The gate true gives `ineligible`? NO. The gate true gives `assessment(Subject, not_applicable, [])` through a guarded `once/1` gate defeater (`not_defeated/3`).
  - Cites RTS Arts 25 and 26 and DORA Art 16(1).
- `dora_rts_continuity_testing_and_recovery_compliance_check(Profile, Verdict)`: query type #13. Its verdict is `compliant`, `non_compliant` or `not_applicable`, or a passed-through status compound.
  - It maps `..._duties_outstanding/3`: `none_outstanding` gives `compliant`; `outstanding/1` gives `non_compliant`; the gate gives `not_applicable`.
  - Cites the same citations as the outstanding query.

**Fixtures** (in `fixtures.clausal`):

- `dora_rts_continuity_testing_and_recovery_fixture(Name, Profile)`.
- `dora_rts_continuity_testing_and_recovery_expected(Name, Query, Result, Citations)`.
- The planned fixtures:
  - `article_16_gate_true`;
  - `gate_absent`;
  - `credit_institution_all_performed`;
  - `microenterprise_no_providers_all_performed`, which has 18 duties;
  - `central_counterparty_all_performed`;
  - `central_securities_depository_one_false`;
  - `provider_user_duty_23_false`;
  - `always_duty_absent_and_trigger_absent`, which names the duty key, not the trigger;
  - `trigger_absent_duty_4_false`, which is `incomplete`;
  - `unsure_alternative_options`, which refers with `cite(eu_reg_2024_1774_art_26_3)`;
  - `unknown_key_and_duplicate`;
  - `wrong_type_unsure_gate`;
  - `profile_not_a_list`.

**Result constructors** (exported, never called as queries):

- `required/1`, `outstanding/1`, `indeterminate/1`;
- `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`;
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 5. Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2` and `profile_lacks/2`: all profile reads, presence first and then value;
  - `check_tri/4`: the met / unmet / unknown status of a tri-state duty key in the checklist (no hand-rolled Kleene logic, C15);
  - `eval_requirements/4` and `assess/6`: the checklist and eligibility engine (no hand-rolled findall item builder, R1);
  - `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2` and `assessment/3`;
  - `not_defeated/3`: the guarded gate defeater;
  - `not_member/2` and `memberd/2`: deduplicating citation lists;
  - `profile_keys/2`: PAIRS and the input check.
- **kit/query_combinators**: `what_if/5`, for the facade what_if.
- **validate_props** (tests only):
  - `run_props/1`;
  - `prop_totality/3` and `prop_determinism/3`: the exactly-one-solution COUNTING rule;
  - `prop_citation_complete/3` and `bad_citation/1`;
  - `prop_missing_key_coverage/3`.
- **kit/compliance_lib**: NOT used. The deontic answer here is a duty list rather than an action modality, so the #13 wrapper maps the outstanding query directly. A note is added in NOTES.md.
- **Not used**:
  - deadline_lib, rolling_window and date_time (no dates; Q16);
  - currency_vocab and vat_category (no money);
  - country.
- **`_common`**: no deontic backbone predicate exists for the <<DNUM>> selector. It stays local in the slice, with a note in NOTES.md S3.

## 6. Slice: `dora_rts_continuity_testing_and_recovery.clausal`

This is the single, self-contained determination slice. It covers the duties of RTS Arts 25 and 26 for one entity.

### 6.1 Value facts it owns

**Duty table.** There are no numeric statutory figures, so there is no `constant_value/2`. The duty table is the slice's statutory table:

`duty(Ordinal, DutyAtom, ProfileKey, Citations, Condition)`

- `Condition` is one of:
  - `always`;
  - `holds(financial_entity_uses_ict_services_of_ict_third_party_service_providers, true)`;
  - `holds(financial_entity_is_microenterprise, false)`;
  - `holds(dora_entity_type, central_counterparty)`;
  - `holds(dora_entity_type, central_securities_depository)`.
- No duty has more than one condition.
- There are 23 rows in DUTY ORDER:

| # | Duty atom | Condition | Citations |
|---|---|---|---|
| 1 | `testing_informed_by_business_impact_analysis_and_ict_risk_assessment` | always | 25_1 |
| 2 | `assessment_of_continuity_of_critical_or_important_functions` | always | 25_2 |
| 3 | `testing_on_disruption_scenarios` | always | 25_2_a, 25_2 |
| 4 | `testing_of_ict_third_party_services` | trigger true | 25_2_b, 25_2 |
| 5 | `testing_of_switchover_scenarios` | microenterprise false | 25_2_c, 25_2 |
| 6 | `testing_challenges_plan_assumptions` | always | 25_2_d |
| 7 | `testing_verifies_ability_to_respond` | always | 25_2_e |
| 8 | `involvement_of_central_counterparty_parties_in_testing` | type central_counterparty | 25_3, 25_3_a, 25_3_b, 25_3_c |
| 9 | `involvement_of_central_securities_depository_parties_in_testing` | type central_securities_depository | 25_4, 25_4_a … 25_4_e |
| 10 | `documentation_of_test_results` | always | 25_5 |
| 11 | `handling_of_test_deficiencies` | always | 25_5 |
| 12 | `response_and_recovery_plans_informed_by_business_impact_analysis` | always | 26_1 |
| 13 | `activation_and_deactivation_conditions` | always | 26_1_a |
| 14 | `actions_for_critical_or_important_ict_systems_and_services` | always | 26_1_b |
| 15 | `design_to_meet_recovery_objectives` | always | 26_1_c |
| 16 | `documentation_and_availability_of_plans` | always | 26_1_d, 26_1 |
| 17 | `short_and_long_term_recovery_options` | always | 26_1_e |
| 18 | `plan_objectives_and_success_conditions` | always | 26_1_f |
| 19 | `identification_of_relevant_scenarios` | always | 26_2 |
| 20 | `scenarios_based_on_threats_and_lessons_learned` | always | 26_2 |
| 21 | `listed_disruption_scenarios` | always | 26_2, 26_2_a … 26_2_i |
| 22 | `alternative_recovery_options` | always | 26_3 |
| 23 | `continuity_measures_for_ict_third_party_service_provider_failures` | trigger true | 26_4 |

All citation keys carry the `eu_reg_2024_1774_art_` prefix. Each duty's profile key is the key with the same number + 4 in Section 2.

**Other facts**

- `duty_paragraph(CitationKey, ParagraphKey)`: maps each point key to its paragraph key, e.g. `eu_reg_2024_1774_art_25_2_a` → `eu_reg_2024_1774_art_25_2`.
- `referral_citation(JudgementKey, cite(FirstCitationKey))`: the duty's first citation (THE LIMBS table).
- `referral_row(JudgementKey, Inputs)`: `Inputs` is all 27 keys.
- `fixed_citation(Key)`: the nine paragraph keys.
- `gate_citation(eu_reg_2022_2554_art_16_1)`.
- `conditioning_key(Key, Values)`: microenterprise `[true, false]`; type its 29 atoms; trigger `[true, false]`.

### 6.2 Rules / requirements

**Condition states**

- `condition_state(Profile, Condition, State)`, with `State ∈ {holds, fails, open}`.
- There are three exclusive clauses, by presence first and then by value.

**Duty states**

- `duty_applies/2`: its condition is `always`, or its condition holds.
- `duty_open/2`: its condition does not fail.
- `duty_fails/2`: the duty applies and its key is false.
- `duty_key_not_true/2`: the key is false, unsure or absent.

**Checklist requirement**

`dora_rts_continuity_testing_and_recovery_requirement(DutyAtom, Profile, Status, Citation)`, RequirementId first, for assess/6. It has four exclusive clauses:

- condition fails → `inapplicable`;
- condition open → `unknown([ConditionKey])`;
- condition holds or always → `check_tri/4` on the duty key, giving met, unmet or unknown.

**Required**

- R1: the first absent conditioning key in root order. Each such key governs an open duty.
- R2: the duties that apply, plus their deduplicated paragraphs.

**Complete**

- S1: some duty fails → `incomplete`.
- S2: every open duty's key is true → `complete`.
- S3: candidate absent keys, per THE LIMBS (a) and (b):
  - **(a)** the key of an open duty D, where no other false-key duty E has its condition holding or equal to D's condition;
  - **(b)** a conditioning key X with values V ≠ W, where:
    - some open duty D holds for V and not for W, and has a not-true key;
    - and no false-key duty E ≠ D holds for W, has no condition on X, or has its other conditions holding or among D's conditions.

  **Decides alone**: the key of a duty that applies; or a conditioning key X such that, for one of its values, some false-key duty has a condition on X holding for that value.

  **Behind**: X is behind Y when Y decides alone and X does not.

  The query names the first candidate in root order that is not behind another candidate.
- S4: the first unsure judgement key satisfying S3(a) → `needs_legal_review`, with the referral citation and PAIRS.

**Outstanding**

- M1: the first absent key that is the key of an open duty, or a conditioning key carrying the condition of an open duty with a not-true key.
- M2: the first unsure key of an open duty.
- M3: the duties that fail, in duty order.

**Gate**

The gate is a guarded `once/1` defeater over the queries:

- `gate_state/2 ∈ {simplified, absent, proceeds}`;
- input problems come before the gate.

**Pairs**

`inputs_relied_on_pairs(Profile, Pairs)` gives every present `Key-Value`, in root order.

**Style**

- All verdict constants are folded into clause heads (C17).
- There is one clause per disjoint route, with no cut and no if-then-else.
- Duplicates are removed only by building lists deterministically in table order, never with `once` on a verdict.

### 6.3 Verdict atoms

- `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`;
- the statuses `indeterminate/1`, `needs_legal_review/2` with `open_textured/2`, and `input_problems/1`;
- the checklist item statuses `met`, `unmet(duty_not_performed)`, `unknown([Key])` and `inapplicable`.

### 6.4 Shared with kernel.clausal (and only this)

**`kernel.clausal`** holds:

- `contract_key(Ordinal, Key, Type)`: the 27-row key order and types;
- `value_has_type(Type, Value)`: judgement, fact and entity_type;
- the entity-type enum;
- `dora_rts_continuity_testing_and_recovery_input_problems/2`, because the slice queries, the facade and the fixtures/tests all call it.

**`citations.clausal`** holds the citation_vocabulary atoms.

**`parameters.clausal`** stays empty of figures (no statutory number; Q15) except for a comment saying so.

No other predicate is shared.

## 7. Test modes (v2 manifest, seven)

1. load;
2. per-duty unit tests: applies, open and fails for each of the 23 duties;
3. per-query fixtures with exact Result and set-compared Citations;
4. COUNTING (`findall` length 1 for every query and fixture);
5. input-check edge cases: duplicate, wrong_type, unknown_key; `==` identity of variables; 7 vs 7.0; partial list; unbound element;
6. properties via validate_props (totality, determinism, citation completeness, missing-key coverage);
7. mutation / what_if: flip each key and check the verdict changes as THE LIMBS predict, including the <<DNUM>> non-naming of the trigger while an always-duty key is absent.
