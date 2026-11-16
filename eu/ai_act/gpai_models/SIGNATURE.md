# SIGNATURE — eu/ai_act/gpai_models

This is the authoring plan for phases P2 onward. The layout is unchanged:

`kernel.clausal -> citations.clausal -> parameters.clausal -> gpai_models.clausal -> queries.clausal -> fixtures.clausal -> package facade (gpai_models package module)`

The predicate prefix is `gpai_models_`. The shape family is deontic. The manifest is v2, with seven test modes. File and module names stay exactly as scaffolded; only the TODO logic is replaced.

## 1. Public query surface (summary)

### The contract

The called contract has five predicates, and each yields EXACTLY ONE solution for every input:

- `systemic_risk_classification_status(Profile, AssessmentDate, Result, Citations)`
- `systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, Citations)`
- `provider_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations)`
- `documentation_elements(Document, Elements, Citations)`
- `gpai_models_input_problems(Profile, Problems)`

`Result` is ONE term: either a result atom of the query, or one of the status compounds below. It is never wrapped in a list. `Citations` is one flat, set-like list of `cite(Key)` terms, and it is `[]` whenever the answer is not final.

The status compounds are:

- `indeterminate([Key])`
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

### Totality and determinism

The whole surface is total and deterministic:

- There is no cut, no `->` and no `*->`.
- The ladder steps are written as disjoint clause guards.
- A defeater is guarded by `once/1` and read through `not_defeated/3`.
- Every exported predicate is proved single-solution by the determinism test mode, using `findall` plus `length(Solutions, 1)`.

### The facade

The facade keeps the scaffold names and dispatches on a request term. The facade wrapper `gpai_models_verdict/2` is the scaffold's verdict record; the five contract predicates never return it.

## 2. Verdict STATUS atoms (replace the scaffold placeholder `{ required, permitted, not_applicable }`)

- **Classification:** `not_applicable_on_date`, `not_a_general_purpose_ai_model`, `general_purpose_ai_model_with_systemic_risk`, `general_purpose_ai_model_without_systemic_risk`.
- **Notification:** `not_a_general_purpose_ai_model`, `no_notification_duty`, `notification_after_the_time_limit`, `notification_within_the_time_limit`.
- **Obligation:** `not_applicable_on_date`, `not_a_general_purpose_ai_model`, `obligation_does_not_apply`, `compliance_required_by_2_august_2027`, `obligation_applies`.
- **Not final, shared:** `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.
  - The bare atom `indeterminate` is NEVER written, to avoid the atom-shadowing trap.
  - Problem terms: `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.
  - Context terms: `open_textured/2`, `inputs_relied_on/1`, `provenance/2` (optional, unscored).

## 3. Profile keys (attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`)

The ten keys are listed in root_exports and input_contract order. This order is also the DECISION ORDER.

| # | key | type | read by |
|---|-----|------|---------|
| 1 | `general_purpose_ai_model` | judgement: `true` / `false` / `unsure` | classification, notification, obligation |
| 2 | `used_for_research_development_or_prototyping_before_being_placed_on_the_market` | crisp: `true` / `false` | classification, obligation |
| 3 | `cumulative_training_computation_in_floating_point_operations` | non-negative integer, any size (unit: floating-point operations) | classification, notification, obligation |
| 4 | `high_impact_capabilities` | judgement | classification, notification, obligation |
| 5 | `designated_by_a_commission_decision_as_a_model_with_systemic_risk` | crisp | classification, obligation |
| 6 | `commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks` | crisp | classification, obligation |
| 7 | `released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution` | judgement | obligation |
| 8 | `parameters_weights_architecture_and_usage_information_made_publicly_available` | crisp | obligation |
| 9 | `provider_established_in_a_third_country` | crisp | obligation |
| 10 | `placed_on_the_market_before_2_august_2025` | crisp | notification, obligation |

Dates are not profile keys. `AssessmentDate`, `TriggerDate` and `NotificationDate` are caller arguments, given as ground `date(Year, Month, Day)` terms of integers: a real calendar day with Year from 1 to 9999.

The query's keys are:

- **Classification:** keys 1 to 6.
- **Notification:** keys 1, 3, 4 and 10.
- **Obligation:** all ten keys, the same set for every obligation.

**Argument atoms.**

- `Obligation` is one of: `technical_documentation`, `information_for_downstream_providers`, `copyright_policy`, `training_content_summary`, `cooperation_with_authorities`, `authorised_representative`, `model_evaluation`, `systemic_risk_assessment_and_mitigation`, `serious_incident_reporting`, `cybersecurity_protection`.
- `Document` is one of: `technical_documentation`, `additional_technical_documentation_for_models_with_systemic_risk`, `information_for_downstream_providers`.

## 4. Citation-key atoms (citations.clausal, canonical lexicon scheme, `citation_vocabulary`)

No shortened atom is ever invented.

**Emitted by answers:**

- **Classification and notification:** `eu_reg_2024_1689_art_3_63`, `eu_reg_2024_1689_art_51_1`, `eu_reg_2024_1689_art_51_1_a`, `eu_reg_2024_1689_art_51_1_b`, `eu_reg_2024_1689_art_51_2`, `eu_reg_2024_1689_art_52_1`, `eu_reg_2024_1689_art_52_2`, `eu_reg_2024_1689_art_52_3`, `eu_reg_2024_1689_art_52_4`.
- **Obligations:** `eu_reg_2024_1689_art_53_1`, `eu_reg_2024_1689_art_53_1_a`, `eu_reg_2024_1689_art_53_1_b`, `eu_reg_2024_1689_art_53_1_b_i`, `eu_reg_2024_1689_art_53_1_b_ii`, `eu_reg_2024_1689_art_53_1_c`, `eu_reg_2024_1689_art_53_1_d`, `eu_reg_2024_1689_art_53_2`, `eu_reg_2024_1689_art_53_3`, `eu_reg_2024_1689_art_54_1`, `eu_reg_2024_1689_art_54_2`, `eu_reg_2024_1689_art_54_6`, `eu_reg_2024_1689_art_55_1`, `eu_reg_2024_1689_art_55_1_a`, `eu_reg_2024_1689_art_55_1_b`, `eu_reg_2024_1689_art_55_1_c`, `eu_reg_2024_1689_art_55_1_d`.
- **Dates and transition:** `eu_reg_2024_1689_art_111_3`, `eu_reg_2024_1689_art_113_b`.
- **Annex XI, Section 1:** `eu_reg_2024_1689_annex_xi`, `eu_reg_2024_1689_annex_xi_section_1`, `eu_reg_2024_1689_annex_xi_section_1_1`, `eu_reg_2024_1689_annex_xi_section_1_1_a` to `eu_reg_2024_1689_annex_xi_section_1_1_f`, `eu_reg_2024_1689_annex_xi_section_1_2`, `eu_reg_2024_1689_annex_xi_section_1_2_a` to `eu_reg_2024_1689_annex_xi_section_1_2_e`.
- **Annex XI, Section 2:** `eu_reg_2024_1689_annex_xi_section_2`, `eu_reg_2024_1689_annex_xi_section_2_1`, `eu_reg_2024_1689_annex_xi_section_2_2`, `eu_reg_2024_1689_annex_xi_section_2_3`.
- **Annex XII:** `eu_reg_2024_1689_annex_xii`, `eu_reg_2024_1689_annex_xii_1`, `eu_reg_2024_1689_annex_xii_1_a` to `eu_reg_2024_1689_annex_xii_1_h`, `eu_reg_2024_1689_annex_xii_2`, `eu_reg_2024_1689_annex_xii_2_a` to `eu_reg_2024_1689_annex_xii_2_c`.

**Vocabulary only, read into key meaning and never emitted:** `eu_reg_2024_1689_art_3_64`, `eu_reg_2024_1689_art_3_65`, `eu_reg_2024_1689_art_3_67`, `eu_reg_2024_1689_art_3_68`.

Each entry carries its pinned unit identifier, for example `02024R1689-20260727#point_051.001_a`.

**Referral rows (citations.clausal, `gpai_models_referral_row(Query, JudgementKey, Citation, Inputs)`):**

| query | judgement | citation | inputs |
|-------|-----------|----------|--------|
| classification | `general_purpose_ai_model` | `eu_reg_2024_1689_art_3_63` | `[general_purpose_ai_model, high_impact_capabilities]` |
| classification | `high_impact_capabilities` | `eu_reg_2024_1689_art_51_1_a` | same as above |
| notification | `general_purpose_ai_model` | `eu_reg_2024_1689_art_3_63` | `[general_purpose_ai_model, high_impact_capabilities]` |
| notification | `high_impact_capabilities` | `eu_reg_2024_1689_art_51_1_a` | same as above |
| obligation | `general_purpose_ai_model` | `eu_reg_2024_1689_art_3_63` | the three judgement keys, in root_exports order |
| obligation | `high_impact_capabilities` | `eu_reg_2024_1689_art_51_1_a` | the three judgement keys, in root_exports order |
| obligation | `released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution` | `eu_reg_2024_1689_art_53_2` | the three judgement keys, in root_exports order |

## 5. Public predicates (one line each)

**Contract queries:**

- `systemic_risk_classification_status(Profile, AssessmentDate, Result, Citations)`: classification on a day. Cites Art 3(63), Art 51(1) with (a) and (b), Art 51(2), Art 52(2) to (4), Art 113(b).
- `systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, Citations)`: two-week outer limit of the notification (query type #15 deadline). Cites Art 52(1), Art 51(1)(a), Art 51(2), Art 111(3), Art 113(b).
- `provider_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations)`: whether one of ten duties applies (query type #14 obligation surfacing). Cites Art 53(1)(a) to (d), Art 53(2), Art 53(3), Art 54(1), (2) and (6), Art 55(1)(a) to (d), Art 111(3), Art 113(b).
- `documentation_elements(Document, Elements, Citations)`: minimum element lists (query type #1 factual lookup). Cites Annex XI Sections 1 and 2, and Annex XII.
- `gpai_models_input_problems(Profile, Problems)`: the typed input check. It returns the bare problem list, never fails and never raises. It reflects the input contract of the order.

**Element atoms of `documentation_elements/3` (pinned public names, spelled exactly as the order gives them).** Each is a BARE atom inside an `Elements` list, never called as a query and never wrapped; the line form `atom(Document)` below names the document list(s) `Document` in which the atom appears, in the Annex order of §9. Atoms worded alike in Annex XI and Annex XII are shared (Q18).

- `intended_tasks_and_type_and_nature_of_ai_systems_for_integration(Document)`: the tasks the model is intended to perform and the type and nature of AI systems in which it can be integrated; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(a) [`eu_reg_2024_1689_annex_xi_section_1_1_a`]; Annex XII, point 1(a) [`eu_reg_2024_1689_annex_xii_1_a`].
- `acceptable_use_policies(Document)`: the acceptable use policies applicable; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(b) [`eu_reg_2024_1689_annex_xi_section_1_1_b`]; Annex XII, point 1(b) [`eu_reg_2024_1689_annex_xii_1_b`].
- `date_of_release_and_methods_of_distribution(Document)`: the date of release and methods of distribution; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(c) [`eu_reg_2024_1689_annex_xi_section_1_1_c`]; Annex XII, point 1(c) [`eu_reg_2024_1689_annex_xii_1_c`].
- `architecture_and_number_of_parameters(Document)`: the architecture and number of parameters; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(d) [`eu_reg_2024_1689_annex_xi_section_1_1_d`]; Annex XII, point 1(f) [`eu_reg_2024_1689_annex_xii_1_f`].
- `modality_and_format_of_inputs_and_outputs(Document)`: the modality (e.g. text, image) and format of inputs and outputs; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(e) [`eu_reg_2024_1689_annex_xi_section_1_1_e`]; Annex XII, point 1(g) [`eu_reg_2024_1689_annex_xii_1_g`].
- `licence(Document)`: the licence (for the model); Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 1(f) [`eu_reg_2024_1689_annex_xi_section_1_1_f`]; Annex XII, point 1(h) [`eu_reg_2024_1689_annex_xii_1_h`].
- `technical_means_required_for_integration(Document)`: the technical means (e.g. instructions of use, infrastructure, tools) required for the model to be integrated in AI systems; Document `technical_documentation` or `information_for_downstream_providers`. Annex XI, Section 1, point 2(a) [`eu_reg_2024_1689_annex_xi_section_1_2_a`]; Annex XII, point 2(a) [`eu_reg_2024_1689_annex_xii_2_a`].
- `design_specifications_of_the_model_and_training_process(Document)`: the design specifications of the model and training process, methodologies, key design choices, rationale and assumptions; Document `technical_documentation`. Annex XI, Section 1, point 2(b) [`eu_reg_2024_1689_annex_xi_section_1_2_b`].
- `detailed_information_on_training_testing_and_validation_data(Document)`: information on the data used for training, testing and validation, with type, provenance, curation, data points, scope, selection and bias detection; Document `technical_documentation`. Annex XI, Section 1, point 2(c) [`eu_reg_2024_1689_annex_xi_section_1_2_c`].
- `computational_resources_used_for_training(Document)`: the computational resources used to train the model (e.g. number of floating point operations), training time and other training details; Document `technical_documentation`. Annex XI, Section 1, point 2(d) [`eu_reg_2024_1689_annex_xi_section_1_2_d`].
- `known_or_estimated_energy_consumption(Document)`: known or estimated energy consumption of the model; Document `technical_documentation`. Annex XI, Section 1, point 2(e) [`eu_reg_2024_1689_annex_xi_section_1_2_e`].
- `evaluation_strategies_and_results(Document)`: a detailed description of the evaluation strategies, including evaluation results, criteria, metrics and the methodology on the identification of limitations; Document `additional_technical_documentation_for_models_with_systemic_risk`. Annex XI, Section 2, point 1 [`eu_reg_2024_1689_annex_xi_section_2_1`].
- `adversarial_testing_and_model_adaptation_measures(Document)`: where applicable, the measures for internal and/or external adversarial testing (e.g. red teaming) and model adaptations, including alignment and fine-tuning; Document `additional_technical_documentation_for_models_with_systemic_risk`. Annex XI, Section 2, point 2 [`eu_reg_2024_1689_annex_xi_section_2_2`].
- `system_architecture(Document)`: where applicable, the system architecture explaining how software components build or feed into each other and integrate into the overall processing; Document `additional_technical_documentation_for_models_with_systemic_risk`. Annex XI, Section 2, point 3 [`eu_reg_2024_1689_annex_xi_section_2_3`].
- `interaction_with_hardware_or_software_outside_the_model(Document)`: how the model interacts, or can be used to interact, with hardware or software that is not part of the model itself, where applicable; Document `information_for_downstream_providers`. Annex XII, point 1(d) [`eu_reg_2024_1689_annex_xii_1_d`].
- `versions_of_relevant_software(Document)`: the versions of relevant software related to the use of the model, where applicable; Document `information_for_downstream_providers`. Annex XII, point 1(e) [`eu_reg_2024_1689_annex_xii_1_e`].
- `modality_format_and_maximum_size_of_inputs_and_outputs(Document)`: the modality and format of the inputs and outputs and their maximum size (e.g. context window length); Document `information_for_downstream_providers`. Annex XII, point 2(b) [`eu_reg_2024_1689_annex_xii_2_b`].
- `information_on_training_testing_and_validation_data(Document)`: information on the data used for training, testing and validation, where applicable, including type, provenance and curation methodologies (shorter than Annex XI, so its own atom); Document `information_for_downstream_providers`. Annex XII, point 2(c) [`eu_reg_2024_1689_annex_xii_2_c`].

**Deadline helper:**

- `gpai_models_two_week_day(TriggerDate, TwoWeekDay)`: the later of TriggerDate and 2 August 2025, plus 14 calendar days. Cites Art 52(1) and Art 113(b). It is forward-only: TriggerDate must be bound.

**Scaffold facade (names kept).** `Request` is one of:

- `classification(Profile, AssessmentDate)`
- `notification(Profile, TriggerDate, NotificationDate)`
- `obligation(Profile, Obligation, AssessmentDate)`
- `documentation(Document)`

The facade predicates are:

- `decide_gpai_models(Request, gpai_models_verdict(Status, Citations))`: dispatches to the matching contract query, one solution. Its citations are those of the query.
- `gpai_models_status(Request, Status)`: the Status of `decide_gpai_models/2` alone. Its citations are those of the query.
- `gpai_models_checklist(Request, Checklist)`: the justification checklist (query type #7). It gives one `item(TestId, Status, cite(Key))` per named test or ladder step evaluated, and every item carries `cite(...)`, met items included.
  - Test identifiers: `application_date_test`, `general_purpose_ai_model_test`, `high_impact_test`, `systemic_risk_test`, `open_source_test`, `third_country_establishment_test`, `transitional_test`, `late_test`.
  - Item statuses come from `check_tri/4`, `check_true/4` and `check_false/4`: `met` / `unmet(Reason)` / `unknown(Keys)`.
- `gpai_models_what_if(Request, Key, Value, Status)`: re-decides with `attribute(Key, Value)` replacing the key, using `profile_set/3`. Its citations are those of the query.
- **Fixtures** (fixtures.clausal): `gpai_models_fixture(Name, Request)` and `gpai_models_fixture_expected(Name, Status, Citations)`. They cover:
  - the threshold boundary: 10^25 and 10^25 + 1;
  - 1 and 2 August 2025;
  - 1 and 2 August 2027;
  - the two-week day itself, and the day after;
  - a trigger date of 1 July 2025, giving a two-week day of 16 August 2025;
  - an already-placed model notifying on 2 and 3 August 2027;
  - each obligation in each exception route;
  - a designation with accepted arguments;
  - dual establishment (key false);
  - each status form: `indeterminate`, `needs_legal_review` and each problem term.

## 6. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`;
  - status checks: `check_tri/4`, `check_tri_neg/4`, `check_true/4`, `check_false/4`;
  - defeaters: `not_defeated/3`;
  - checklist items: `item/3`, `unmet/1`, `unknown/1`;
  - list helpers: `not_member/2`, `memberd/2`;
  - vocabulary atoms: `met`, `applicable`, `inapplicable`.
- **`kit/deadline_lib`:**
  - `deadline/4`, as `deadline(eu_reg_2024_1689_art_52_1, 14, StartDay, TwoWeekDay)`;
  - comparisons: `date_before/2`, `date_after/2`, `date_on_or_before/2`;
  - `month_last_day/3`, for real-calendar-day validation;
  - `add_business_days/3` is NOT used (Q6).
- **`date_time` (`library(datetime)`):** `date_max/3`, used only if bridged. Caller dates are compound `date(Y, M, D)` terms. date/3 is not yet registered natively, so all date arithmetic goes through deadline_lib, and comparisons use deadline_lib or `@<` on validated integer triples. A [Y, M, D] list is never built.
- **`kit/query_combinators`:** `what_if/5`, for `gpai_models_what_if/4`, with the decide closure `gpai_models_status_of(Request)`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:** `kit/compliance_lib`, `rolling_window`, `currency_vocab`, `vat_category`, `country`. There are no money, VAT or country codes; establishment is a crisp key.
- **Integer units:** the threshold is an exact integer constant in floating-point operations. There is no float anywhere.

## 7. kernel.clausal (the shared floor; ONLY what more than one consumer needs)

**Calendar-day validation:**

- `gpai_models_calendar_day(Term)`: `Term = date(Year, Month, Day)` of integers, with Year from 1 to 9999, Month from 1 to 12, and Day from 1 to `month_last_day`.
- `gpai_models_not_calendar_day(Term)`: the complement, written as an exhaustive cut-free negative. It also covers unbound terms, checked with `var/1` or `nonvar/1` guards first.

**The input check:**

- `gpai_models_input_problems/2` itself, plus its helpers:
  - `gpai_models_attribute_list/1`, a proper list whose every element is `attribute(_, _)`; partial lists and unbound elements are rejected;
  - `gpai_models_contract_key/2`, giving key and type (`judgement`, `crisp`, `non_negative_integer`), in contract order;
  - `gpai_models_value_has_type/2`;
  - `gpai_models_key_occurrences/3`.
- Problem order:
  - contract keys in contract order: `duplicate_key(Key)` if the key repeats (its values are not read), else `wrong_type(Key)`;
  - then `unknown_key(Key)` for each non-contract key, in first-occurrence order. A non-atom key is unknown, and appears as given.
- A profile that is not an attribute list gives `[wrong_type(profile)]` alone.

**The STATUS RULE engine (domain-independent; candidate kit module):**

- `gpai_models_completions(Profile, QueryKeys, Completions)`:
  - each absent query key takes the values of its type;
  - each unsure judgement takes `true` / `false`;
  - the integer key takes the representatives 10000000000000000000000000 and 10000000000000000000000001.
- `gpai_models_settle(LadderClosure, Profile, QueryKeys, ReferralQuery, Result, Citations)`. The closure is called as `call(LadderClosure, CompleteProfile, Answer)`, where `Answer = answer(Result, Citations)` with Citations sorted to a set. It applies:
  - **S1:** all completion answers equal, so return that answer;
  - **S2:** the first absent key in decision order that MATTERS (has a witness pair differing only in that key with different answers) and is not BEHIND another absent key (the behind relation relation over witness pairs) gives `indeterminate([Key])`, `[]`;
  - **S3:** the first unsure judgement in decision order that matters gives `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`, `[]`. Pairs are the present judgement keys of the query, in root_exports order, with their given values. C comes from the referral row.
- The engine is cut-free and is written with `findall/3`, `sort/2` and `once/1`-guarded selection of the first qualifying key. There are at most 2^10 completions.

## 8. citations.clausal and parameters.clausal

**citations.clausal:**

- `gpai_models_citation(Key, PinnedUnit, Gloss)` for every atom in §4;
- the referral rows in §4;
- `citation_vocabulary` export.

**parameters.clausal** is empty of statutory figures: every figure lives in the slice. It holds only the decision-order list `gpai_models_key_order/1`, and the per-query key lists `gpai_models_query_keys(Query, Keys)` with `Query` one of `classification`, `notification`, `obligation`.

## 9. SLICE — gpai_models.clausal (self-contained determination)

### Statutory VALUE facts owned here (declared once; read with `constant(Name)`)

- `:- constant_value(high_impact_presumption_threshold_floating_point_operations, 10000000000000000000000000).` (Art 51(2); strictly greater than.)
- `:- constant_value(notification_period_days, 14).` (Art 52(1), two weeks.)
- `gpai_models_milestone(chapter_five_application, date(2025, 8, 2)).` (Art 113(b).)
- `gpai_models_milestone(transitional_compliance, date(2027, 8, 2)).` (Art 111(3).)
- **Tables:**
  - `gpai_models_obligation(Obligation)` (ten facts);
  - `gpai_models_applying_citations(Obligation, Citations)` (ten rows, exactly as THE LIMBS);
  - `gpai_models_not_applying_citations(Obligation, Citations)` (seven rows: none for `copyright_policy`, `training_content_summary` or `cooperation_with_authorities`);
  - `gpai_models_documentation_list(Document, Elements, Citations)` (three rows, element order = Annex order, exactly as THE LIMBS and the element atoms of §5).

### Named tests (on a COMPLETE profile; outcome `met` / `failed`, three-clause style)

- `general_purpose_ai_model_test(Profile, Outcome)`: ALL(`general_purpose_ai_model` true, research key false). Art 3(63).
- `high_impact_test(Profile, Outcome)`: ANY(computation greater than the threshold constant, `high_impact_capabilities` true). Art 51(1)(a), Art 51(2).
- `systemic_risk_test(Profile, Outcome)`: ANY(designated true, ALL(high_impact met, accepted false)). Art 51(1), Art 52(2) to (4).
- `open_source_test(Profile, Outcome)`: ALL(licence judgement true, public availability true). Art 53(2), Art 54(6).
- `exception_test(Obligation, Profile, Outcome)`:
  - for documentation and downstream information: ALL(open_source met, systemic_risk failed);
  - for the representative: ANY(that, third-country false);
  - for the four Art 55 duties: systemic_risk failed;
  - for copyright, training summary and cooperation: always failed.
- Implemented as the DEFEATER `obligation_defeated(Obligation, Profile)`, guarded by `once/1`; `obligation_applies` is read through `not_defeated/3`.
- `late_test(Profile, TriggerDate, NotificationDate, Outcome)`: ALL(NotificationDate after the two-week day, ANY(placed-before false, NotificationDate after 2 August 2027)).

### Ladders on a complete profile (C17: the ground result is folded into the clause head; disjoint guards, one clause per route)

**`classification_answer(Date, Profile, answer(Result, Citations))`:**

1. Date before 2 August 2025: `not_applicable_on_date`, `[art_113_b]`.
2. General-purpose test failed: `not_a_general_purpose_ai_model`, `[art_3_63]`.
3. Systemic risk test met: `general_purpose_ai_model_with_systemic_risk`, `[51_1, 51_1_a, 51_1_b, 51_2, 52_3, 52_4]`.
4. Otherwise: `general_purpose_ai_model_without_systemic_risk`, `[51_1, 51_1_a, 51_1_b, 51_2, 52_2]`.

**`notification_answer(TriggerDate, NotificationDate, Profile, Answer)`:**

1. `general_purpose_ai_model` not true: `not_a_general_purpose_ai_model`, `[3_63]`.
2. High-impact test failed: `no_notification_duty`, `[51_1_a, 51_2, 52_1]`.
3. Late test met: `notification_after_the_time_limit`, `[52_1, 111_3, 113_b]`.
4. Otherwise: `notification_within_the_time_limit`, with the same citations.

**`obligation_answer(Obligation, Date, Profile, Answer)`:**

1. Date before 2 August 2025: `not_applicable_on_date`.
2. General-purpose test failed: `not_a_general_purpose_ai_model`.
3. Defeated: `obligation_does_not_apply`, with the not-applying citations.
4. Placed before 2 August 2025 true and Date before 2 August 2027: `compliance_required_by_2_august_2027`, with `[art_111_3]` plus the applying citations.
5. Otherwise: `obligation_applies`, with the applying citations.

### Step (0) argument checks (before the ladder; the profile problems come first)

- **Classification:** the profile problems, then `wrong_type(assessment_date)`.
- **Notification:** the profile problems, then `wrong_type(trigger_date)`, then `wrong_type(notification_date)` when NotificationDate is not a calendar day, or when both are days and NotificationDate is before TriggerDate.
- **Obligation:** the profile problems, then `wrong_type(obligation)`, then `wrong_type(assessment_date)`.
- **Documentation:** a Document that is not a document atom, an unbound variable included, gives `input_problems([wrong_type(document)])` as Elements, with Citations `[]`.

### Verdict atoms of the slice

The slice uses the atoms of §2.

### Shared with the kernel (and ONLY these)

- `gpai_models_calendar_day/1` and `gpai_models_not_calendar_day/1`;
- `gpai_models_input_problems/2`;
- `gpai_models_settle/6` and `gpai_models_completions/3`.

Everything else (thresholds, milestones, tables, tests and ladders) stays in this slice.

### Per-rule tests owned by the slice (tests/, seven modes)

The slice owns tests in all seven modes:

- **load:** the package loads.
- **unit:** every test and ladder step, with a positive test paired to each `fail` test.
- **boundary:** the threshold equal to and one above 10^25; dates 1 and 2 August 2025 and 1 and 2 August 2027; the two-week day, and the day after it.
- **determinism:** `findall` and `length(_, 1)` for every query over the fixtures.
- **status rule:**
  - S2 names the first key that matters and is not behind another; for example, the research key is not named while `general_purpose_ai_model` is absent and could settle the answer as `not_a_general_purpose_ai_model`;
  - S3 referral pairs;
  - settled answers with irrelevant keys absent.
- **input check:** duplicates, unknown non-atom keys, partial lists, unbound values, Python-like strings, floats and negative integers.
- **citation completeness:** every emitted key is in `citation_vocabulary`, and the citations are fixed per answer, whatever the route (reading (7)).
- **element lists:** each `documentation_elements/3` list equals, element for element and in order, the element atoms of §5 for its Document.
