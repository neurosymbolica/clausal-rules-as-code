# SIGNATURE — eu/ai_act/small_items

## 0 Public query surface (one paragraph)

The contract surface is the six queries:

- `bias_data_processing_status/4`
- `sandbox_personal_data_processing_status/4`
- `real_world_testing_status/4`
- `informed_consent_status/4`
- `sme_simplified_compliance_status/4`
- `explanation_right_status/4`

Each is called as `QUERY(Profile, AssessmentDate, Result, Citations)`. The input check is `small_items_input_problems(Profile, Problems)`.

The arguments:

- `Profile` is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`.
- `AssessmentDate` is a caller term `date(Year, Month, Day)`.
- `Result` is a contract atom, or the not-final status compound itself.
- `Citations` is one flat set-like list of `cite(Key)` terms, or `[]` when the answer is not final.

Every query yields EXACTLY ONE solution, for every input, and never raises. Determinism comes from mutually exclusive clause heads and guarded tests, with no cut and no if-then-else. Totality: every term gets one of the atoms or one status compound.

The package facade keeps the scaffold names: `decide_small_items/2`, `small_items_status/2`, `small_items_checklist/2`, `small_items_what_if/4` and fixtures. They wrap the six queries over a case term `small_items_case(QueryName, Profile, AssessmentDate)`. No statutory figure is imported: the two application dates are owned by the slice.

## 1 Verdict STATUS atoms (replace the placeholders required, permitted, not_applicable)

Final atoms, by query:

| Query | Atoms |
|---|---|
| `bias_data_processing_status/4` | `not_applicable_on_date`, `bias_processing_not_permitted`, `bias_processing_permitted` |
| `sandbox_personal_data_processing_status/4` | `not_applicable_on_date`, `sandbox_processing_not_permitted`, `sandbox_processing_permitted` |
| `real_world_testing_status/4` | `not_applicable_on_date`, `testing_not_provided_for_by_the_member_state`, `subject_to_the_member_state_framework`, `real_world_testing_not_permitted`, `real_world_testing_permitted` |
| `informed_consent_status/4` | `not_applicable_on_date`, `consent_does_not_meet_article_61`, `consent_meets_article_61` |
| `sme_simplified_compliance_status/4` | `not_applicable_on_date`, `no_simplified_compliance`, `may_comply_in_a_simplified_manner` |
| `explanation_right_status/4` | `not_applicable_on_date`, `no_right_to_explanation_under_article_86`, `right_to_explanation_under_article_86` |

Not-final status compounds (exact functors and arities):

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`.
  - `Pairs` is a list of `Key-Value` terms.
  - An optional unscored `provenance(Clause, Citations)` may follow `inputs_relied_on`.
- `input_problems(Problems)`.

Problem terms: `unknown_key(Key)`, `wrong_type(Key)`, `duplicate_key(Key)`, `wrong_type(profile)`, `wrong_type(assessment_date)`.

Result constructors (exported, never called as queries): `date/3`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 2 Profile keys (sixty-three, root_exports and input_contract order)

The keys are in three types:

- **Enumeration**: one of the listed atoms.
- **Crisp**: `true` or `false`.
- **Judgement**: `true`, `false` or `unsure`.

There are no numeric keys and no money: the 30 days and the months are caller bands.

| # | Key | Type | Query |
|---|---|---|---|
| 1 | `bias_processing_capacity` | enumeration: `provider_of_a_high_risk_system`, `other_provider_or_deployer` | bias |
| 2 | `strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g` | judgement | bias |
| 3 | `strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights` | judgement | bias |
| 4 | `appropriate_safeguards_for_fundamental_rights_and_freedoms` | judgement | bias |
| 5 | `bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data` | judgement | bias |
| 6 | `technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures` | judgement | bias |
| 7 | `measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation` | judgement | bias |
| 8 | `data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties` | crisp | bias |
| 9 | `data_deleted_once_bias_corrected_or_retention_period_ended` | crisp | bias |
| 10 | `records_of_processing_include_the_reasons_for_the_processing` | crisp | bias |
| 11 | `sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing` | crisp | sandbox |
| 12 | `developed_for_safeguarding_substantial_public_interest` | judgement | sandbox |
| 13 | `public_interest_area` | enumeration: `public_safety_and_public_health`, `environment`, `energy_sustainability`, `transport_and_critical_infrastructure`, `public_administration_and_public_services`, `none_of_the_listed_areas` | sandbox |
| 14 | `data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective` | judgement | sandbox |
| 15 | `effective_monitoring_and_response_mechanisms` | judgement | sandbox |
| 16 | `functionally_separate_isolated_and_protected_environment_under_provider_control` | crisp | sandbox |
| 17 | `data_shared_only_as_article_59_allows` | crisp | sandbox |
| 18 | `processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights` | crisp | sandbox |
| 19 | `appropriate_technical_and_organisational_measures` | judgement | sandbox |
| 20 | `data_deleted_at_end_of_participation_or_retention_period` | crisp | sandbox |
| 21 | `processing_logs_kept_for_the_duration_of_participation` | crisp | sandbox |
| 22 | `description_of_process_and_rationale_kept_in_technical_documentation` | crisp | sandbox |
| 23 | `project_summary_published_on_competent_authority_website` | crisp | sandbox |
| 24 | `for_law_enforcement_purposes_under_law_enforcement_authority_control` | crisp | sandbox |
| 25 | `based_on_specific_union_or_national_law` | crisp | sandbox |
| 26 | `testing_route` | enumeration: `annex_iii`, `annex_i_section_a`, `annex_i_section_b` | testing |
| 27 | `member_state_has_adopted_a_real_world_testing_framework` | crisp | testing |
| 28 | `testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority` | crisp | testing |
| 29 | `approval_status` | enumeration: `approved`, `no_answer_within_30_days`, `not_approved` | testing |
| 30 | `national_law_provides_for_tacit_approval` | crisp | testing |
| 31 | `testing_registered_as_article_60_4_c_requires` | crisp | testing |
| 32 | `established_in_the_union_or_legal_representative_established_in_the_union` | crisp | testing |
| 33 | `third_country_transfers_only_with_appropriate_and_applicable_safeguards` | judgement | testing |
| 34 | `testing_duration` | enumeration: `up_to_six_months`, `extended_up_to_twelve_months`, `longer` | testing |
| 35 | `extension_notified_in_advance_with_explanation` | crisp | testing |
| 36 | `testing_no_longer_than_necessary_to_achieve_its_objectives` | judgement | testing |
| 37 | `vulnerable_subjects_appropriately_protected` | judgement | testing |
| 38 | `testing_in_cooperation_with_deployers` | crisp | testing |
| 39 | `deployers_informed_instructed_and_agreement_concluded` | crisp | testing |
| 40 | `informed_consent_given_in_accordance_with_article_61` | crisp | testing |
| 41 | `law_enforcement_testing_where_seeking_consent_would_prevent_the_test` | crisp | testing |
| 42 | `no_negative_effect_on_subjects_and_data_deleted_after_the_test` | crisp | testing |
| 43 | `effectively_overseen_by_suitably_qualified_persons` | judgement | testing |
| 44 | `outputs_can_be_effectively_reversed_and_disregarded` | judgement | testing |
| 45 | `consent_freely_given` | judgement | consent |
| 46 | `consent_obtained_before_participation` | crisp | consent |
| 47 | `information_concise_clear_relevant_and_understandable` | judgement | consent |
| 48 | `informed_of_nature_objectives_and_possible_inconvenience` | crisp | consent |
| 49 | `informed_of_conditions_and_expected_duration` | crisp | consent |
| 50 | `informed_of_rights_and_guarantees_including_refusal_and_withdrawal` | crisp | consent |
| 51 | `informed_of_arrangements_for_reversal_or_disregarding` | crisp | consent |
| 52 | `informed_of_identification_number_and_contact_details` | crisp | consent |
| 53 | `consent_dated_and_documented` | crisp | consent |
| 54 | `copy_given_to_the_subject_or_legal_representative` | crisp | consent |
| 55 | `is_an_sme_including_a_start_up` | crisp | sme |
| 56 | `has_partner_or_linked_enterprises` | crisp | sme |
| 57 | `affected_person_subject_to_a_deployer_decision_based_on_the_system_output` | crisp | explanation |
| 58 | `system_is_a_high_risk_ai_system_listed_in_annex_iii` | crisp | explanation |
| 59 | `system_listed_under_point_2_of_annex_iii` | crisp | explanation |
| 60 | `decision_produces_legal_effects_or_similarly_significantly_affects_the_person` | judgement | explanation |
| 61 | `person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights` | crisp | explanation |
| 62 | `union_or_national_law_provides_an_exception_or_restriction` | crisp | explanation |
| 63 | `right_otherwise_provided_for_under_union_law` | crisp | explanation |

Counts: five enumeration keys, eighteen judgement keys and forty crisp keys. `AssessmentDate` is not a profile key. It is a caller `date(Year, Month, Day)` term, valid when its three arguments are integers, `Month` is in 1..12 and `Day` is in 1..LastDay. LastDay comes from `month_last_day/3`.

## 3 Citation-key atoms (citation_vocabulary, canonical lexicon; never shortened)

- **Art 113**: `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_113_a`
- **Art 4a(1)**: `eu_reg_2024_1689_art_4a_1`, `eu_reg_2024_1689_art_4a_1_a`, `eu_reg_2024_1689_art_4a_1_b`, `eu_reg_2024_1689_art_4a_1_c`, `eu_reg_2024_1689_art_4a_1_d`, `eu_reg_2024_1689_art_4a_1_e`, `eu_reg_2024_1689_art_4a_1_f`
- **Art 4a(2)**: `eu_reg_2024_1689_art_4a_2`, `eu_reg_2024_1689_art_4a_2_a`, `eu_reg_2024_1689_art_4a_2_b`
- **Art 59**: `eu_reg_2024_1689_art_59_1`, `eu_reg_2024_1689_art_59_2`
- **Art 60**: `eu_reg_2024_1689_art_60_1`, `eu_reg_2024_1689_art_60_4`
- **Art 60a**: `eu_reg_2024_1689_art_60a_1`, `eu_reg_2024_1689_art_60a_2`, `eu_reg_2024_1689_art_60a_5`
- **Art 61**: `eu_reg_2024_1689_art_61_1`, `eu_reg_2024_1689_art_61_1_a`, `eu_reg_2024_1689_art_61_1_b`, `eu_reg_2024_1689_art_61_1_c`, `eu_reg_2024_1689_art_61_1_d`, `eu_reg_2024_1689_art_61_1_e`, `eu_reg_2024_1689_art_61_2`
- **Art 63**: `eu_reg_2024_1689_art_63_1`, `eu_reg_2024_1689_art_63_2`
- **Art 86**: `eu_reg_2024_1689_art_86_1`, `eu_reg_2024_1689_art_86_2`, `eu_reg_2024_1689_art_86_3`

### Referral rows

There is one `referral_row(JudgementKey, Citation, Inputs)` per judgement key. `Inputs` are the judgement keys of the one query that reads `JudgementKey`, in root_exports order.

| Judgement key | Citation |
|---|---|
| `strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g` | `eu_reg_2024_1689_art_4a_1` |
| `strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights` | `eu_reg_2024_1689_art_4a_2_a` |
| `appropriate_safeguards_for_fundamental_rights_and_freedoms` | `eu_reg_2024_1689_art_4a_1` |
| `bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data` | `eu_reg_2024_1689_art_4a_1_a` |
| `technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures` | `eu_reg_2024_1689_art_4a_1_b` |
| `measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation` | `eu_reg_2024_1689_art_4a_1_c` |
| `developed_for_safeguarding_substantial_public_interest`, `data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective`, `effective_monitoring_and_response_mechanisms`, `appropriate_technical_and_organisational_measures` | `eu_reg_2024_1689_art_59_1` |
| `third_country_transfers_only_with_appropriate_and_applicable_safeguards`, `testing_no_longer_than_necessary_to_achieve_its_objectives`, `vulnerable_subjects_appropriately_protected`, `effectively_overseen_by_suitably_qualified_persons`, `outputs_can_be_effectively_reversed_and_disregarded` | `eu_reg_2024_1689_art_60_4` |
| `consent_freely_given`, `information_concise_clear_relevant_and_understandable` | `eu_reg_2024_1689_art_61_1` |
| `decision_produces_legal_effects_or_similarly_significantly_affects_the_person` | `eu_reg_2024_1689_art_86_1` |

## 4 Public predicates (one line each)

### The six queries

- `bias_data_processing_status(Profile, AssessmentDate, Result, Citations)`: Art 4a permission for special-category data in bias detection and correction. Cites `eu_reg_2024_1689_art_113_a` and `eu_reg_2024_1689_art_4a_1`, `_1_a`..`_1_f`, and `eu_reg_2024_1689_art_4a_2`, `_2_a`, `_2_b`.
- `sandbox_personal_data_processing_status(Profile, AssessmentDate, Result, Citations)`: Art 59 permission for further processing in the sandbox. Cites `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_59_1`, `eu_reg_2024_1689_art_59_2`.
- `real_world_testing_status(Profile, AssessmentDate, Result, Citations)`: Art 60 permission for real world testing, or the Art 60a Member State route. Cites `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_60_1`, `eu_reg_2024_1689_art_60_4`, `eu_reg_2024_1689_art_60a_1`, `eu_reg_2024_1689_art_60a_2`, `eu_reg_2024_1689_art_60a_5`.
- `informed_consent_status(Profile, AssessmentDate, Result, Citations)`: whether the consent meets Art 61. Cites `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_61_1`, `_1_a`..`_1_e`, `eu_reg_2024_1689_art_61_2`.
- `sme_simplified_compliance_status(Profile, AssessmentDate, Result, Citations)`: Art 63(1) simplified QMS compliance, always with the Art 63(2) reminder. Cites `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_63_1`, `eu_reg_2024_1689_art_63_2`.
- `explanation_right_status(Profile, AssessmentDate, Result, Citations)`: the Art 86 right to explanation, with the defeaters of paragraphs 2 and 3. Cites `eu_reg_2024_1689_art_113`, `eu_reg_2024_1689_art_86_1`, `eu_reg_2024_1689_art_86_2`, `eu_reg_2024_1689_art_86_3`.

### The input check

- `small_items_input_problems(Profile, Problems)`: THE INPUT CHECK. `Problems` is the bare flat list; one solution for every term; never raises. No citation: it applies the input contract of the order.

### The facade

The facade is not part of the scored contract; it wraps the six queries.

- `decide_small_items(Case, small_items_verdict(Result, Citations))`: `Case` is `small_items_case(QueryName, Profile, AssessmentDate)`, where `QueryName` is the atom `bias_data_processing_status`, `sandbox_personal_data_processing_status`, `real_world_testing_status`, `informed_consent_status`, `sme_simplified_compliance_status` or `explanation_right_status`. It calls that query once. Query type #3 status determination and #13 compliance check (is the proposed processing, testing or reliance allowed). Citations as the query.
- `small_items_status(Case, Result)`: the `Result` of `decide_small_items/2` alone. Query type #3.
- `small_items_checklist(Case, Checklist)`: one `item(RequirementIdentifier, Status, cite(CitationKey))` per condition of the route reached, built with `assess/6` over `small_items_requirement/4`. `Status` is `met`, `unmet(Reason)` or `unknown(Keys)`. Every item carries `cite(...)` provenance, met items included. Query type #7 justification.
- `small_items_what_if(Case, Key, Value, Result)`: the `Result` after `attribute(Key, Value)` replaces or adds the key in the profile. Uses `what_if/5` with the closure `small_items_status_of(QueryName, AssessmentDate)`. Citations as the query.
- `small_items_fixture(FixtureName, Case, ExpectedResult, ExpectedCitations)`: the fixtures (see section 7).

## 5 Planned reuse (manifest `uses:`)

- **`formalize_lib`**:
  - `profile_get/3`: the only profile reader. It reads by presence first, then by value.
  - `profile_keys/2`: input check and duplicate detection.
  - `profile_set/3`: the what-if override, via `override_key` semantics.
  - `check_true/4`, `check_false/4`, `check_eq/5`, `check_tri/4`: checklist items.
  - `assess/6`, `eval_requirements/4`, `item/3`, `labels/3`, `met`, `unmet/1`, `unknown/1`: the checklist.
  - `not_defeated/3`: the Art 86(2), (3) and Art 63(1) proviso defeaters, with guarded `once/1`, cut-free.
  - `memberd/2`, `not_member/2`: key typing.
- **`kit.deadline_lib`**: `month_last_day/3`, for the real-calendar-day check of `AssessmentDate`.
- **`kit.query_combinators`**: `what_if/5`, for `small_items_what_if/4`; `diff_checklists/3`, for test mode 6.
- **`validate_props`**:
  - `run_props/1`
  - `prop_totality/3`, `prop_determinism/3`
  - `prop_citation_complete/3`, `bad_citation/1`
  - `prop_boundary_coverage/2`: the date boundaries 2026-07-26 and 2026-07-27, and 2026-08-01 and 2026-08-02.
  - `prop_missing_key_coverage/3`
- **Not used, with reasons**:
  - `kit.compliance_lib`: its deny-overrides modality lattice is not needed. Each query is a single permission with its own cumulative conditions, and the order fixes the answers directly.
  - `library(datetime)`: `date/3` objects do not exist yet, and the contract fixes caller `date(Y, M, D)` compounds. Ordering uses the integer key `Year * 10000 + Month * 100 + Day`, never `@<` on the compound.
  - The rolling window libraries: not relevant.
- **Local, likely to recur (noted in the working notes (not published))**: the generic status rule engine, in `kernel.clausal`.

## 6 Layout: kernel -> citations -> parameters -> small_items -> queries -> fixtures -> package facade

### kernel.clausal (shared floor)

There is one determination slice, but the kernel holds the predicates the six queries share inside it and the facade reads.

**`small_items_key_type(Key, Type)`**: the sixty-three typed keys in root order. `Type` is one of:
- `enumeration([Atom, ...])`
- `crisp`, i.e. boolean `true` or `false`
- `judgement`, i.e. one_of boolean or `unsure`

**`small_items_input_problems/2`**: built in five checks.

1. **Attribute-list check.** The profile must be a proper list. Every element must be bound and of the form `attribute(_, _)`; otherwise the result is `[wrong_type(profile)]`.
2. **Contract keys.** For each contract key in root order: if it occurs more than once, `duplicate_key(Key)`, without reading values; otherwise, if present with a value outside its type, `wrong_type(Key)`. An unbound value is outside every type.
3. **Unknown keys.** `unknown_key(Key)` for each non-contract key, including a non-atom key, once each, in order of first occurrence.
4. **Unbound terms.** Unbound terms are handled by guards `var/1`, `nonvar/1` and `is_list/1` in mutually exclusive clauses.
5. **Exactly one solution.** The check always succeeds once.

**Date handling.**
- `small_items_valid_date(AssessmentDate)`.
- `small_items_date_key(date(Year, Month, Day), DayKey)`.
- `small_items_before(AssessmentDate, Year, Month, Day)`: strict, on the integer day key.

**`small_items_step_zero(Profile, AssessmentDate, Problems)`**: the profile problems, then `wrong_type(assessment_date)` when the date is not valid.

**THE STATUS RULE ENGINE.** `small_items_resolve(QueryName, Profile, Result, Citations)` is generic over a ladder supplied by the slice.

The ladder is given as:
- `small_items_query_keys(QueryName, Keys)`: the decision order.
- `small_items_ladder(QueryName, CompleteProfile, Result, Citations)`: the answer of a complete profile.

The slice presents each ladder test as key-disjoint GROUPS of `ALL` of groups. A group is a single literal or a small `ANY` or `ALL`, with at most three keys. This lets the engine decide exactly, without enumerating all completions:

- **Matters.** A key K in group G matters iff some valuation of G's other open keys makes G flip with K, while every other group of that step can still be MET. Route and capacity keys matter whenever they change the step reached, or the citations.
- **Witness value sets.** Each witness gives the other open keys a set of values. `behind(K, L)` holds when K's witnesses give L only some of L's values, and L's witnesses give K all of K's values.
- **(S1)** When the possible answers are a single answer: settled.
- **(S2)** Otherwise `indeterminate([Key])`, for the first absent key in decision order that matters and is not behind another absent key.
- **(S3)** Otherwise `needs_legal_review(open_textured(Judgement, cite(Citation)), [inputs_relied_on(Pairs)])`:
  - `Judgement` is the first unsure judgement that matters.
  - `Citation` comes from its referral row.
  - `Pairs` are the present judgement keys of the query, in root order, as given.
- **Brute-force oracle.** A completion oracle, `findall` over all completions, is kept in the tests only. It cross-checks the group engine on random small profiles (test mode 4).
- **Defeater guard.** `small_items_defeated(RuleIdentifier, Profile)` is guarded by `once/1`. It is used through `not_defeated/3`.

### citations.clausal

- `small_items_citation(Key)` for the twenty-nine atoms of section 3.
- The referral rows.

### parameters.clausal

It carries no statutory figure: the figures live in the slice. It keeps the scaffold module and re-exports nothing new.

### small_items.clausal

The determination slice; see section 8.

### queries.clausal

The six public queries. Each is three mutually exclusive clauses with the ground verdict folded into the head:

1. Step zero, when there are problems: `Result = input_problems(Problems)`, `Citations = []`.
2. The date step: before the application date, with the date citation in the head.
3. Otherwise: `small_items_resolve/4`.

### fixtures.clausal

Section 7.

### Package facade (small_items package module)

The facade predicates of section 4.

## 7 Fixtures and the seven test modes

### Fixtures

`small_items_fixture/4` rows:

| Fixture | Case | Expected |
|---|---|---|
| `bias_provider_all_conditions_met` | assessed 2026-07-27 | `bias_processing_permitted` with the paragraph 1 citations |
| `bias_on_twenty_sixth_july` | assessed 2026-07-26 | `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113_a)]` |
| `bias_capacity_absent` | capacity absent | `indeterminate([bias_processing_capacity])` |
| `bias_other_deployer_safeguards_unsure` | everything else met | `needs_legal_review` citing `eu_reg_2024_1689_art_4a_1` |
| `sandbox_law_enforcement_without_specific_law` | specific law `false` | `sandbox_processing_not_permitted` |
| `sandbox_none_of_the_listed_areas` | area `none_of_the_listed_areas` | `sandbox_processing_not_permitted` |
| `testing_section_b_without_framework` | — | `testing_not_provided_for_by_the_member_state` |
| `testing_section_b_with_framework` | — | `subject_to_the_member_state_framework` |
| `testing_tacit_approval_allowed` | tacit approval provided | `real_world_testing_permitted` |
| `testing_tacit_approval_not_in_national_law` | no tacit approval | `real_world_testing_not_permitted` |
| `testing_extension_not_notified` | extension not notified | `real_world_testing_not_permitted` |
| `testing_law_enforcement_without_consent` | `law_enforcement_testing_where_seeking_consent_would_prevent_the_test` and no negative effect `true` | `real_world_testing_permitted` |
| `testing_duration_absent_with_tacit_absent` | — | the first unbehind key |
| `consent_without_copy` | — | `consent_does_not_meet_article_61` |
| `sme_with_linked_enterprises` | — | `no_simplified_compliance` |
| `sme_independent` | — | `may_comply_in_a_simplified_manner` |
| `explanation_point_2_system` | — | `no_right_to_explanation_under_article_86` |
| `explanation_otherwise_provided_for` | — | `no_right_to_explanation_under_article_86` |
| `explanation_all_met` | assessed 2026-08-02 | `right_to_explanation_under_article_86` |
| `explanation_on_first_august` | assessed 2026-08-01 | `not_applicable_on_date` |
| `malformed_profile_with_duplicate_and_unknown_key` | — | `input_problems([duplicate_key(...), unknown_key(...)])` |
| `impossible_date` | `date(2026, 2, 30)` | `input_problems([wrong_type(assessment_date)])` |

### Seven test modes

1. **Unit tests**: one per ladder step of each query.
2. **Date boundary tests**: each pair of days either side of an application date.
3. **Input check**: ordering; duplicate versus wrong type; non-atom key; unbound profile, element or value; partial list.
4. **Status rule**: S1, S2, S3, and behind-gating; cross-checked by the brute-force completion oracle.
5. **Counting and determinism**: `findall` length 1 for every query and fixture.
6. **Citation completeness, and stability of citations across met and not-met**: the citations of a settled answer never change when a later key is given.
7. **Mutation tests**: `eval/mutations.yaml`, for instance flipping the boundary to `=<`, dropping a conjunct, or swapping citations.

Every `test(_, fail)` is paired with a positive test over the same case.

## 8 Slice: small_items.clausal (self-contained)

The slice holds all six determinations, because the six share no legal concept except the dates and the status machinery of the kernel.

### Statutory VALUE facts it owns

```
:- constant_value(article_4a_applies_from_year, 2026).
:- constant_value(article_4a_applies_from_month, 7).
:- constant_value(article_4a_applies_from_day, 27).
:- constant_value(regulation_applies_from_year, 2026).
:- constant_value(regulation_applies_from_month, 8).
:- constant_value(regulation_applies_from_day, 2).
```

The Art 4a values follow Art 113(a) and Q1. The general values follow Art 113, first paragraph.

The 30 days of Art 60(4)(b) and the six plus six months of Art 60(4)(f) are NOT constants. The caller counts them, and they reach the order only as the atoms of `approval_status` and `testing_duration` (Q5).

### Shared with the kernel

The slice provides `small_items_query_keys/2`, `small_items_ladder/4` (as group structure) and `small_items_requirement/4` to the kernel. It uses `small_items_before/4`, `small_items_resolve/4` and `small_items_defeated/2` from the kernel. Nothing else is shared.

### Ladder of bias_data_processing_status

This is Art 4a.

1. **Date step.** Before 27 July 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113_a)]`.
2. **Not met.** NOT(THE BIAS CONDITIONS TEST of `bias_processing_capacity`): `bias_processing_not_permitted`, with THE BIAS CITATIONS of that capacity.
3. **Otherwise.** `bias_processing_permitted`, with the same citations.

Requirements (identifier, key, citation):

| Requirement | Key | Applies to | Citation |
|---|---|---|---|
| `bias_strict_necessity_for_high_risk_data_governance` | judgement 2 | provider only | `art_4a_1` |
| `bias_strict_necessity_for_biases_affecting_health_safety_or_rights` | judgement 3 | other only | `art_4a_2_a` |
| `bias_appropriate_safeguards` | key 4 | — | `art_4a_1` |
| `bias_other_data_would_not_do` | key 5 | — | `art_4a_1_a` |
| `bias_reuse_limits_and_state_of_the_art_security` | key 6 | — | `art_4a_1_b` |
| `bias_secured_with_strict_access_controls` | key 7 | — | `art_4a_1_c` |
| `bias_no_access_by_other_parties` | key 8 | — | `art_4a_1_d` |
| `bias_deletion_when_corrected_or_retention_ends` | key 9 | — | `art_4a_1_e` |
| `bias_reasons_in_records_of_processing` | key 10 | — | `art_4a_1_f` |

For `other_provider_or_deployer`, the checklist also carries `bias_paragraph_1_conditions_applied` (`art_4a_2_b`).

The citations of each paragraph:

- `provider_of_a_high_risk_system`: `[art_4a_1, art_4a_1_a .. art_4a_1_f]`
- `other_provider_or_deployer`: `[art_4a_2, art_4a_2_a, art_4a_2_b, art_4a_1, art_4a_1_a .. art_4a_1_f]`

Every atom carries the full `eu_reg_2024_1689_` prefix.

Gates (the behind relation): key 2 is behind capacity = provider; key 3 is behind capacity = other.

### Ladder of sandbox_personal_data_processing_status

This is Art 59.

1. **Date step.** Before 2 August 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113)]`.
2. **Not met.** NOT(ALL of fourteen groups): `sandbox_processing_not_permitted`, `[cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]`. The groups are:
   - key 11 `true`
   - key 12 `true`
   - NOT key 13 `none_of_the_listed_areas`
   - key 14 `true`
   - key 15 `true`
   - key 16 `true`
   - key 17 `true`
   - key 18 `true`
   - key 19 `true`
   - key 20 `true`
   - key 21 `true`
   - key 22 `true`
   - key 23 `true`
   - ANY(key 24 `false`, key 25 `true`)
3. **Otherwise.** `sandbox_processing_permitted`, with the same citations.

Requirements, all citing `art_59_1` except the last:

- `sandbox_solely_for_developing_training_and_testing`
- `sandbox_substantial_public_interest`
- `sandbox_listed_public_interest_area`
- `sandbox_data_necessary_and_non_personal_data_not_effective`
- `sandbox_monitoring_and_response_mechanisms`
- `sandbox_isolated_environment`
- `sandbox_restricted_sharing`
- `sandbox_no_measures_or_decisions_affecting_data_subjects`
- `sandbox_technical_and_organisational_measures`
- `sandbox_deletion_at_end`
- `sandbox_processing_logs`
- `sandbox_technical_documentation`
- `sandbox_published_summary`
- `sandbox_law_enforcement_specific_law` (`art_59_2`, a guarded defeater branch)

Gate: key 25 is behind key 24 = `true`.

### Ladder of real_world_testing_status

This is Arts 60 and 60a.

1. **Date step.** Before 2 August 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113)]`.
2. **Section B without framework.** Route `annex_i_section_b` AND key 27 `false`: `testing_not_provided_for_by_the_member_state`, `[cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_2)]`.
3. **Section B with framework.** Route `annex_i_section_b`: `subject_to_the_member_state_framework`, `[cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_5)]`.
4. **Not met.** NOT(ALL of eleven groups): `real_world_testing_not_permitted`, `[cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]`. The groups are:
   - (a) key 28
   - (b) ANY(approval `approved`, ALL(approval `no_answer_within_30_days`, key 30 `true`))
   - (c) key 31
   - (d) key 32
   - (e) key 33
   - (f) ALL(key 36 `true`, ANY(duration `up_to_six_months`, ALL(duration `extended_up_to_twelve_months`, key 35 `true`)))
   - (g) key 37
   - (h) ANY(key 38 `false`, key 39 `true`)
   - (i) ANY(key 40 `true`, ALL(key 41 `true`, key 42 `true`))
   - (j) key 43
   - (k) key 44
5. **Otherwise.** `real_world_testing_permitted`, with the same citations.

Requirements, all citing `art_60_4`:

- `testing_plan_submitted`
- `testing_approved_or_tacitly_approved`
- `testing_registered`
- `testing_establishment_in_the_union`
- `testing_third_country_transfer_safeguards`
- `testing_duration_within_limits`
- `testing_vulnerable_subjects_protected`
- `testing_deployer_information_and_agreement`
- `testing_consent_or_law_enforcement_alternative` (a guarded defeater branch)
- `testing_effective_oversight`
- `testing_outputs_reversible`

The route items cite `art_60_1`, `art_60a_1`, `art_60a_2` and `art_60a_5`.

Gates:

- key 27 is behind route = `annex_i_section_b`;
- keys 28 to 44 are behind route in {`annex_iii`, `annex_i_section_a`};
- key 30 is behind approval = `no_answer_within_30_days`;
- key 35 is behind duration = `extended_up_to_twelve_months`;
- key 39 is behind key 38 = `true`;
- keys 41 and 42 are behind key 40 = `false`. Neither of keys 41 and 42 is behind the other.

### Ladder of informed_consent_status

This is Art 61.

1. **Date step.** Before 2 August 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113)]`.
2. **Not met.** NOT(ALL keys 45 to 54 `true`): `consent_does_not_meet_article_61`, `[cite(art_61_1), cite(art_61_1_a), cite(art_61_1_b), cite(art_61_1_c), cite(art_61_1_d), cite(art_61_1_e), cite(art_61_2)]`. Every atom carries the full `eu_reg_2024_1689_` prefix.
3. **Otherwise.** `consent_meets_article_61`, with the same citations.

Requirements:

| Requirement | Citation |
|---|---|
| `consent_freely_given_requirement` | `art_61_1` |
| `consent_before_participation` | `art_61_1` |
| `consent_information_quality` | `art_61_1` |
| `consent_information_on_nature_and_inconvenience` | `art_61_1_a` |
| `consent_information_on_conditions_and_duration` | `art_61_1_b` |
| `consent_information_on_rights_and_withdrawal` | `art_61_1_c` |
| `consent_information_on_reversal_arrangements` | `art_61_1_d` |
| `consent_information_on_identification_number_and_contacts` | `art_61_1_e` |
| `consent_dated_and_documented_requirement` | `art_61_2` |
| `consent_copy_given` | `art_61_2` |

No gates.

### Ladder of sme_simplified_compliance_status

This is Art 63.

1. **Date step.** Before 2 August 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113)]`.
2. **Not met.** NOT(ALL(key 55 `true`, key 56 `false`)): `no_simplified_compliance`, `[cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]`.
3. **Otherwise.** `may_comply_in_a_simplified_manner`, with the same citations.

Requirements:

- `sme_including_start_up` (`art_63_1`)
- `sme_without_partner_or_linked_enterprises` (`art_63_1`, a guarded defeater)
- `sme_other_obligations_unaffected` (`art_63_2`; informational, always met)

No gates.

### Ladder of explanation_right_status

This is Art 86.

1. **Date step.** Before 2 August 2026: `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113)]`.
2. **Not met.** NOT(ALL of seven literals): `no_right_to_explanation_under_article_86`, `[cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]`. The literals are:
   - key 57 `true`
   - key 58 `true`
   - key 59 `false`
   - key 60 `true`
   - key 61 `true`
   - key 62 `false`
   - key 63 `false`
3. **Otherwise.** `right_to_explanation_under_article_86`, with the same citations.

Requirements:

| Requirement | Citation |
|---|---|
| `explanation_affected_person_subject_to_deployer_decision` | `art_86_1` |
| `explanation_annex_iii_high_risk_system` | `art_86_1` |
| `explanation_not_a_point_2_system` | `art_86_1` |
| `explanation_legal_or_similarly_significant_effects` | `art_86_1` |
| `explanation_adverse_impact_considered_by_the_person` | `art_86_1` |
| `explanation_no_union_or_national_exception` | `art_86_2`, defeater |
| `explanation_not_otherwise_provided_for` | `art_86_3`, defeater |

No gates.

### Style obligations for the slice

- **Clauses.** One goal per line. Ground verdict atoms go in clause heads, one clause per disjoint route. No `!`, `->` or `*->`. Defeaters are cut-free guarded `once/1`.
- **Profile and figures.** Keys are read only through `profile_get/3`. Dates are read through `constant(Name)`.
- **Names.** Variable names are full CamelCase words, for example `AssessmentDate`, `BiasProcessingCapacity`, `RequirementIdentifier`, `ApplicationDayKey`. There are no abbreviated segments.
