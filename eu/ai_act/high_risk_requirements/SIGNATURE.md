# SIGNATURE — eu/ai_act/high_risk_requirements

## Public query surface (summary)

The CALLED CONTRACT has three predicates. They are non-negotiable, keep their exact names and return bare terms:
- `high_risk_requirement_status(Profile, Requirement, AssessmentDate, Result, Citations)`
- `documentation_element_status(Profile, Element, Result, Citations)`
- `high_risk_requirements_input_problems(Profile, Problems)`

The scaffold facade (`decide_high_risk_requirements/2`, `high_risk_requirements_status/2`, `high_risk_requirements_checklist/2`, `high_risk_requirements_what_if/4` and the fixtures) wraps them without changing any answer. Two predicates are added for the query types this domain must serve:
- `high_risk_requirements_obligations/3` serves #14, obligation surfacing.
- `high_risk_requirements_compliance_date/4` serves #15, deadline.

### Claims

- **Totality:** every call of every public predicate yields exactly ONE solution, for every term given, unbound arguments included.
- **Determinism:** no answer is yielded twice.
- **Citations:** compared as a set, each atom written once, `[]` on every not-final answer.
- **No imported figures:** the order has no money and no thresholds. Its only figures are five statutory dates, owned by the slice.

## Verdict STATUS atoms (replacing the placeholder `{ required, permitted, not_applicable }`)

### `high_risk_requirement_status/5` RESULT (final atoms)

- `not_applicable_on_date`
- `not_a_high_risk_ai_system`
- `requirement_does_not_apply`
- `compliance_required_by_31_december_2030`
- `existing_system_without_significant_changes_not_covered`
- `compliance_required_by_2_august_2030`
- `requirement_applies_to_testing_data_sets_only`
- `requirement_applies_and_the_simplified_form_may_be_used`
- `requirement_applies`

### `documentation_element_status/4` RESULT (final atoms)

- `element_not_required`
- `element_required_subject_to_an_open_condition`
- `element_required`

### Not-final status compounds (both queries; CITATIONS always `[]`)

- `input_problems(Problems)` — Problems is a flat list in the order of the input check, then step (0).
- `indeterminate([Key])` — exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(JudgementKey, cite(CitationKey)), [inputs_relied_on(Pairs)])` — Pairs holds the `Key-Value` pairs of the PRESENT judgement keys, in root_exports order, unsure included.

### Problem terms and result constructors

- Problem terms: `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, `wrong_type(profile)`, `wrong_type(requirement)`, `wrong_type(element)`, `wrong_type(assessment_date)`.
- Result constructors (exported, never queried): `date/3`, `cite/1`, `attribute/2`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (fourteen, in root_exports / input_contract order)

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. A crisp key takes `true` or `false`. A judgement key takes `true`, `false` or `unsure`. There is no numeric key and no date key. ASSESSMENT_DATE is an argument: a caller-supplied `date(Year, Month, Day)` of bare integers.

| # | Key | Type | Read by |
|---|-----|------|---------|
| 1 | `system_is_a_high_risk_ai_system_listed_in_annex_iii` | crisp | requirement status |
| 2 | `system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i` | crisp | requirement status |
| 3 | `system_listed_under_point_1_a_of_annex_iii` | crisp | requirement status |
| 4 | `used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum` | crisp | requirement status |
| 5 | `union_or_national_law_considers_the_separate_verification_disproportionate` | crisp | requirement status |
| 6 | `uses_techniques_involving_the_training_of_ai_models_with_data` | crisp | requirement status |
| 7 | `provider_is_an_sme_including_a_start_up_or_an_smc` | crisp | requirement status |
| 8 | `component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027` | crisp | requirement status |
| 9 | `placed_on_the_market_or_put_into_service_before_the_chapter_iii_date` | crisp | requirement status |
| 10 | `significant_changes_in_design_as_from_the_chapter_iii_date` | judgement | requirement status |
| 11 | `intended_to_be_used_by_public_authorities` | judgement | requirement status |
| 12 | `system_is_a_component_of_products` | crisp | element status |
| 13 | `pre_determined_changes_to_the_system_and_its_performance` | crisp | element status |
| 14 | `related_to_a_product_covered_by_annex_i_section_a` | crisp | element status |

### The query's keys (decision order)

- `high_risk_requirement_status/5`: keys 1 to 11.
- `documentation_element_status/4`: keys 12 to 14.

### Referral rows (judgement key, citation, inputs)

- `significant_changes_in_design_as_from_the_chapter_iii_date` cites `eu_reg_2024_1689_art_111_2`. Inputs: keys 10 and 11.
- `intended_to_be_used_by_public_authorities` cites `eu_reg_2024_1689_art_111_2`. Inputs: keys 10 and 11.

## Argument atoms

### REQUIREMENT (nine atoms; never enumerated on an unbound argument)

- `risk_management_system`
- `data_and_data_governance`
- `technical_documentation`
- `record_keeping`
- `minimum_logging_capabilities_for_point_1_a_systems`
- `transparency_and_instructions_for_use`
- `human_oversight`
- `separate_verification_by_at_least_two_natural_persons`
- `accuracy_robustness_and_cybersecurity`

### ELEMENT (thirty-seven atoms; never enumerated)

**Annex IV (23 atoms):**
- `annex_iv_point_1_a`
- `annex_iv_point_1_b` — open condition
- `annex_iv_point_1_c`
- `annex_iv_point_1_d`
- `annex_iv_point_1_e`
- `annex_iv_point_1_f` — condition key `system_is_a_component_of_products`
- `annex_iv_point_1_g`
- `annex_iv_point_1_h`
- `annex_iv_point_2_a`
- `annex_iv_point_2_b`
- `annex_iv_point_2_c`
- `annex_iv_point_2_d` — open condition
- `annex_iv_point_2_e`
- `annex_iv_point_2_f` — condition key `pre_determined_changes_to_the_system_and_its_performance`
- `annex_iv_point_2_g`
- `annex_iv_point_2_h`
- `annex_iv_point_3`
- `annex_iv_point_4`
- `annex_iv_point_5`
- `annex_iv_point_6`
- `annex_iv_point_7`
- `annex_iv_point_8`
- `annex_iv_point_9`

**Art 11(2) (1 atom):**
- `article_11_2_information_under_annex_i_section_a_legislation` — condition key `related_to_a_product_covered_by_annex_i_section_a`

**Art 13(3) (12 atoms):**
- `article_13_3_point_a`
- `article_13_3_point_b_i`
- `article_13_3_point_b_ii`
- `article_13_3_point_b_iii`
- `article_13_3_point_b_iv` — open condition
- `article_13_3_point_b_v` — open condition
- `article_13_3_point_b_vi` — open condition
- `article_13_3_point_b_vii` — open condition
- `article_13_3_point_c` — condition key `pre_determined_changes_to_the_system_and_its_performance`
- `article_13_3_point_d`
- `article_13_3_point_e`
- `article_13_3_point_f` — open condition

**Art 15(3) (1 atom):**
- `article_15_3_levels_of_accuracy_and_accuracy_metrics`

## Citation-key atoms (canonical lexicon scheme; never shortened)

**Requirements and transition:**
- `eu_reg_2024_1689_art_8_1`
- `eu_reg_2024_1689_art_9_1`
- `eu_reg_2024_1689_art_10_1`
- `eu_reg_2024_1689_art_10_6`
- `eu_reg_2024_1689_art_11_1`
- `eu_reg_2024_1689_art_11_2`
- `eu_reg_2024_1689_art_12_1`
- `eu_reg_2024_1689_art_12_3`
- `eu_reg_2024_1689_art_13_1`
- `eu_reg_2024_1689_art_13_2`
- `eu_reg_2024_1689_art_14_1`
- `eu_reg_2024_1689_art_14_5`
- `eu_reg_2024_1689_art_15_1`
- `eu_reg_2024_1689_art_15_3`
- `eu_reg_2024_1689_art_111_1`
- `eu_reg_2024_1689_art_111_2`
- `eu_reg_2024_1689_art_113_c`
- `eu_reg_2024_1689_art_113_c_i`
- `eu_reg_2024_1689_art_113_c_ii`

**Instructions for use:**
- `eu_reg_2024_1689_art_13_3`
- `eu_reg_2024_1689_art_13_3_a`
- `eu_reg_2024_1689_art_13_3_b_i`
- `eu_reg_2024_1689_art_13_3_b_ii`
- `eu_reg_2024_1689_art_13_3_b_iii`
- `eu_reg_2024_1689_art_13_3_b_iv`
- `eu_reg_2024_1689_art_13_3_b_v`
- `eu_reg_2024_1689_art_13_3_b_vi`
- `eu_reg_2024_1689_art_13_3_b_vii`
- `eu_reg_2024_1689_art_13_3_c`
- `eu_reg_2024_1689_art_13_3_d`
- `eu_reg_2024_1689_art_13_3_e`
- `eu_reg_2024_1689_art_13_3_f`

**Annex IV:**
- `eu_reg_2024_1689_annex_iv_1_a`
- `eu_reg_2024_1689_annex_iv_1_b`
- `eu_reg_2024_1689_annex_iv_1_c`
- `eu_reg_2024_1689_annex_iv_1_d`
- `eu_reg_2024_1689_annex_iv_1_e`
- `eu_reg_2024_1689_annex_iv_1_f`
- `eu_reg_2024_1689_annex_iv_1_g`
- `eu_reg_2024_1689_annex_iv_1_h`
- `eu_reg_2024_1689_annex_iv_2_a`
- `eu_reg_2024_1689_annex_iv_2_b`
- `eu_reg_2024_1689_annex_iv_2_c`
- `eu_reg_2024_1689_annex_iv_2_d`
- `eu_reg_2024_1689_annex_iv_2_e`
- `eu_reg_2024_1689_annex_iv_2_f`
- `eu_reg_2024_1689_annex_iv_2_g`
- `eu_reg_2024_1689_annex_iv_2_h`
- `eu_reg_2024_1689_annex_iv_3`
- `eu_reg_2024_1689_annex_iv_4`
- `eu_reg_2024_1689_annex_iv_5`
- `eu_reg_2024_1689_annex_iv_6`
- `eu_reg_2024_1689_annex_iv_7`
- `eu_reg_2024_1689_annex_iv_8`
- `eu_reg_2024_1689_annex_iv_9`

### Notes on citations

- citations.clausal declares the `citation_vocabulary` with exactly these atoms. Each atom carries its pinned unit id (for example `02024R1689-20260727#parag_008.001`).
- Art 3 points (8), (9), (11), (14a), (14b), Art 113 (heading and other points), Art 12(3)(a) to (d), the Annex IV lead words and Art 8 (title) are read but never emitted as citations. They are recorded in citations.clausal as provenance only.

## Public predicates

### The called contract

- `high_risk_requirement_status(Profile, Requirement, AssessmentDate, Result, Citations)`: whether one of the nine Section 2 requirements applies to the system on AssessmentDate, by THE LADDER steps (0) to (10) and THE STATUS RULE. Cites Art 8(1) and Arts 9 to 15, Art 111(1) and (2), Art 113(c).
- `documentation_element_status(Profile, Element, Result, Citations)`: whether one Annex IV, Art 11(2), Art 13(3) or Art 15(3) element is required, by steps (0) to (3) and THE STATUS RULE. Takes no date. Cites Art 11(1) and (2), Art 13(3), Art 15(3), Annex IV.
- `high_risk_requirements_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the bare flat list, `[]` when well-formed. It never fails or raises. Input contract only; no provision.

### Scaffold facade

Request terms:
- `requirement_question(Profile, Requirement, AssessmentDate)`
- `element_question(Profile, Element)`

Any other Request gives `input_problems([wrong_type(request)])`.

- `decide_high_risk_requirements(Request, Verdict)`: #3 status determination. Verdict is `high_risk_requirements_verdict(Result, Citations)` built from the contract answer for the Request. Citations are as the contract gives them.
- `high_risk_requirements_status(Request, Result)`: #3, the bare Result of the contract answer.
- `high_risk_requirements_checklist(Request, Checklist)`: #7 justification. Every item carries its `cite(...)` provenance.
  - Request `requirements_on(Profile, AssessmentDate)` gives the nine items `item(Requirement, Result, Citations)`, in REQUIREMENT atom order.
  - Request `elements_of(Profile)` gives the thirty-seven element items, in ELEMENT atom order.
  - A profile or date with input problems gives the single item `item(input_check, input_problems(Problems), [])`.
- `high_risk_requirements_what_if(Request, Key, Value, Verdict)`: counterfactual. Replaces Key with Value in the Request's profile (`profile_set/3`), then answers as `decide_high_risk_requirements/2`. The input check runs on the edited profile.
- `high_risk_requirements_fixture(FixtureName, Request, Result, Citations)`: fixtures. Named worked cases with their expected contract answers, enumerable by FixtureName.

### Added for the required query types

- `high_risk_requirements_obligations(Profile, AssessmentDate, Obligations)`: #14 obligation surfacing. Obligations is the list of `item(Requirement, Result, Citations)` for the requirements whose answer on the day is one of:
  - `requirement_applies`;
  - `requirement_applies_to_testing_data_sets_only`;
  - `requirement_applies_and_the_simplified_form_may_be_used`;
  - `compliance_required_by_31_december_2030`;
  - `compliance_required_by_2_august_2030`.

  If any of the nine answers is not final, Obligations is `[item(Requirement, StatusCompound, [])]` for the FIRST such requirement in atom order. Input problems give `[item(input_check, input_problems(Problems), [])]`. Cites Art 8(1) and Arts 9 to 15, Art 111.
- `high_risk_requirements_compliance_date(Profile, Requirement, ComplianceDate, Citations)`: #15 deadline. Probes `high_risk_requirement_status/5` at the candidate days, in order: the system's Chapter III date (2027-12-02, then 2028-08-02), 2030-08-02, then 2030-12-31.
  - The first candidate whose answer is an applies atom gives ComplianceDate `date(Y, M, D)`, with that answer's Citations.
  - A final not-applying answer (`not_a_high_risk_ai_system`, `requirement_does_not_apply`, `existing_system_without_significant_changes_not_covered`) is returned as the atom itself.
  - A not-final answer at a candidate is returned as the status compound, with `[]`.
  - `not_applicable_on_date` and the transitional atoms pass to the next candidate.
  - The consequence of missing the date is only that the requirement applies (and binds through Art 16). Penalties are out of scope. Cites Art 113(c), Art 111(1) and (2).

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3` and `profile_set/3`;
  - `not_defeated/3` (defeasible ladder steps);
  - `memberd/2` and `not_member/2`;
  - `attribute/2` and `item/3` constructors.
- `kit.deadline_lib`: `month_last_day/3`, for real-calendar validation of ASSESSMENT_DATE (leap years included).
- `date_time` (`library(datetime)`): the native date object through the `date/4` constructor, and chronological comparison of native dates for the DATE LITERAL. Compound `date/3` terms are never compared by standard order.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`. Used in the tests.

### Not used, and why

- `kit.compliance_lib`: the order surfaces whether a requirement applies, not a modality conflict between norms. There is no deny-overrides combination.
- `kit.query_combinators`: its `what_if` works on dicts, while PROFILE is an attribute list, so `profile_set/3` is used instead.
- Rolling window: not relevant.
- Currency, VAT and country vocabularies: not used.

## Module chain (layout kept)

The chain runs in this order: `kernel` → `citations` → `parameters` → `high_risk_requirements` → `queries` → `fixtures` → package facade.

- **kernel.clausal** — the shared floor. It holds ONLY the predicates that queries, facade, fixtures and the slice all call:
  - `high_risk_requirements_input_problems/2`, with the typed `input_contract` key table: `contract_key(Key, crisp)` or `contract_key(Key, judgement)`, in root_exports order;
  - `high_risk_requirements_settle(QueryKeys, Profile, Ladder, Referral, Result, Citations)`: the generic status-rule engine over a Ladder closure, called as `call(Ladder, CompleteProfile, Result, Citations)`, and a Referral closure that maps a judgement key to its citation;
  - `high_risk_requirements_valid_date(Term)`: bare-integer date, real day, Y from 1 to 9999;
  - `high_risk_requirements_day_before(DateTermA, DateTermB)`: strict calendar order through native date objects.
- **citations.clausal** — `citation_vocabulary` with the atoms above and their pinned unit ids.
- **parameters.clausal** — kept as a scaffold module. It owns NO statutory figure, because the dates live in the slice. It re-exports nothing domain-specific.
- **queries.clausal** — `decide_high_risk_requirements/2`, `high_risk_requirements_status/2`, `high_risk_requirements_checklist/2`, `high_risk_requirements_what_if/4`, `high_risk_requirements_obligations/3`, `high_risk_requirements_compliance_date/4`.
- **fixtures.clausal** — `high_risk_requirements_fixture/4`.
- **Package facade** — re-exports the contract predicates, the queries, the fixtures and the result constructors.

## Kernel: the status engine (THE STATUS RULE)

The engine is cut-free and uses findall, forall and `once/1` only.

1. **Free keys.** Free = the query keys that are absent, plus the query keys that are judgement keys valued `unsure`. Present crisp values, and present true or false judgements, are kept.
2. **Completions.** Enumerate the 2^|Free| assignments over true and false (at most 2^11 = 2048). Each completion is answered by the Ladder. Answers are compared as `Result` with `sort(Citations)`.
3. **(S1) Settled.** If every completion has the same answer, return it.
4. **Matters.** `matters(K)` holds when there exist two completions that differ only on K and have different answers. A witness of K is such a pair.
5. **Behind.** An absent K is behind an absent L when both hold:
   - every witness of K gives L one and the same value;
   - the witnesses of L give K both values.

   A key that does not matter is behind nothing.
6. **(S2) The missing key.** The first absent mattering key in decision order that is behind no other absent key gives `indeterminate([K])`, with `[]`.
7. **(S3) The referral.** Otherwise, the first unsure mattering judgement J gives `needs_legal_review(open_textured(J, cite(C)), [inputs_relied_on(Pairs)])`, with `[]`.
   - C comes from the referral rows.
   - Pairs are the present judgement query keys, in root_exports order, with their values as given.

Precedence is fixed: input problems come first, then argument problems, then the engine.

## Kernel: the input check

1. **Not an attribute list.** A Profile that is not a proper list of `attribute(_, _)` gives `[wrong_type(profile)]`. This covers an unbound term, a partial list, an unbound element and any non-attribute element.
2. **Contract keys.** For each contract key, in order:
   - more than one occurrence gives `duplicate_key(Key)`, and its values are not read;
   - otherwise, a present value outside its type (unbound included) gives `wrong_type(Key)`.
3. **Unknown keys.** Then `unknown_key(Key)` for each key outside the fourteen, once, in order of first occurrence. Non-atom keys count here, as given.

Type tests use ground atom comparison, so an unbound value never unifies with `true`.

## Slice: high_risk_requirements.clausal

This is the only determination slice. It is self-contained for the legal concept 'does a Section 2 requirement apply, and is a documentation element required'. It needs nothing from another slice and shares nothing beyond the kernel floor above.

### Statutory VALUE facts owned here

| Constant | Value | Source |
|----------|-------|--------|
| `annex_iii_route_application_date` | `date(2027, 12, 2)` | Art 113(c)(i) |
| `annex_i_route_application_date` | `date(2028, 8, 2)` | Art 113(c)(ii) |
| `large_scale_it_system_compliance_date` | `date(2030, 12, 31)` | Art 111(1) |
| `public_authorities_compliance_date` | `date(2030, 8, 2)` | Art 111(2) |
| `large_scale_it_system_placement_cut_off_date` | `date(2027, 8, 2)` | Art 111(1) |

- Each date is a data term inside `:- constant_value(Name, Value).`, read with `constant(Name)`.
- The Annex X cut-off date is read into a key and never compared. It is declared for documentation.
- Fallback, if the loader rejects `date/3` as data: three integer constants per date (`..._year`, `..._month`, `..._day`).
- Also owned here, as tables:
  - `requirement_citations(Requirement, Citations)` — the nine REQUIREMENT CITATIONS;
  - `not_applying_citations(Requirement, Citations)` — two rows;
  - `element_citations(Element, Citations)` — thirty-seven rows;
  - `element_condition_key(Element, Key)` — four rows;
  - `open_element(Element)` — seven rows;
  - `requirement_atom/1` and `element_atom/1` — membership checks on bound atoms only.

### Rules: `high_risk_requirement_status/5` ladder (complete profile)

Each step is a separate clause with its Result and Citations folded into the head (C17), defeated by any lower step (`not_defeated/3`).

**Step (0)** — input problems: the profile problems, then `wrong_type(requirement)`, then `wrong_type(assessment_date)`. Gives `input_problems(Problems)`, `[]`. An unbound Requirement or date gives its wrong_type, and the atoms are never enumerated.

**Step (1)** — date before 2027-12-02. Gives `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]`.

**Step (2)** — Annex III false and Annex I false. Gives `not_a_high_risk_ai_system`, `[cite(eu_reg_2024_1689_art_8_1)]`.

**Step (3)** — Annex III false, Annex I true, and date before 2028-08-02. Gives `not_applicable_on_date`, `[cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]`.

**Step (4)** — the not-applying test of Requirement, guarded by `once/1` because it is an ANY test. Gives `requirement_does_not_apply`, with the not-applying citations.
- For `minimum_logging_capabilities_for_point_1_a_systems`, the test is ANY of:
  - Annex III false;
  - point 1(a) false.
- For `separate_verification_by_at_least_two_natural_persons`, the test is ANY of:
  - Annex III false;
  - point 1(a) false;
  - ALL(law-enforcement purposes true, law disproportionate true).
- For the other seven requirements, the test always fails.

**Step (5)** — Annex X key true and date before 2030-12-31. Gives `compliance_required_by_31_december_2030`, with `[cite(eu_reg_2024_1689_art_111_1)]` joined to the requirement citations.

**Step (6)** — the existing-system test and public authorities false. The existing-system test is: Annex X false, placed before the Chapter III date true, significant changes false. Gives `existing_system_without_significant_changes_not_covered`, `[cite(eu_reg_2024_1689_art_111_2)]`.

**Step (7)** — the existing-system test, public authorities true, and date before 2030-08-02. Gives `compliance_required_by_2_august_2030`, with `[cite(eu_reg_2024_1689_art_111_2)]` joined to the requirement citations.

**Step (8)** — Requirement `data_and_data_governance` and training-with-data false. Gives `requirement_applies_to_testing_data_sets_only`, `[cite(eu_reg_2024_1689_art_8_1), cite(eu_reg_2024_1689_art_10_6)]`.

**Step (9)** — Requirement `technical_documentation` and SME/SMC true. Gives `requirement_applies_and_the_simplified_form_may_be_used`, `[cite(eu_reg_2024_1689_art_8_1), cite(eu_reg_2024_1689_art_11_1)]`.

**Step (10)** — otherwise. Gives `requirement_applies`, with the requirement citations.

The public predicate runs step (0), then hands this ladder to `high_risk_requirements_settle/6` with query keys 1 to 11. The Referral closure maps both judgement keys to `eu_reg_2024_1689_art_111_2`.

### Rules: `documentation_element_status/4` ladder (complete profile)

**Step (0)** — the profile problems, then `wrong_type(element)`. Gives `input_problems(Problems)`, `[]`.

**Step (1)** — `element_condition_key(Element, Key)` and Key is false. Gives `element_not_required`, with the element citations.

**Step (2)** — `open_element(Element)`. Gives `element_required_subject_to_an_open_condition`, with the element citations.

**Step (3)** — otherwise. Gives `element_required`, with the element citations.

The engine uses query keys 12 to 14 and no referral, because these keys are crisp only.

### Verdict atoms

The nine requirement atoms and three element atoms listed above, plus the three not-final compounds.

### Predicates this slice must SHARE

None of its own. It consumes the kernel's input check, status engine and date helpers. Its tables and ladders stay private, apart from the two contract predicates.

### Per-rule tests

The seven test modes are covered by per-rule tests, boundaries, the status rule, the input check, properties, fixtures and mutations. Each negative test is paired with a positive test over the same case.

**Boundary days** (the day before, and the day itself):
- 2027-12-01 and 2027-12-02;
- 2028-08-01 and 2028-08-02;
- 2030-08-01 and 2030-08-02;
- 2030-12-30 and 2030-12-31.

**Calendar validity:**
- 2028-02-29 is valid;
- 2027-02-29, month 13, day 0 and year 10000 give `wrong_type(assessment_date)`.

**One test per ladder step.** For the dual-route system, Annex III and Annex I true on 2027-12-02 give `requirement_applies`.

**Art 14(5) exception:** both conditions give does-not-apply; only one condition gives applies.

**Status rule:**
- the Annex III key absent on 2028-01-01 gives `indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii])`;
- a judgement unsure with an existing system gives `needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date-unsure, intended_to_be_used_by_public_authorities-false])])`;
- the behind test: public authorities absent while significant changes is absent gives `indeterminate([significant_changes_in_design_as_from_the_chapter_iii_date])`;
- a key irrelevant to the requirement is never named.

**Input check:**
- duplicate, wrong type, unknown key, non-atom key, unbound value, partial list, non-attribute element;
- the problem order is checked exactly.

**Elements:**
- each of the four condition keys, both values;
- all seven open elements;
- 1(h) and 13(3)(a) give `element_required`.

**Properties** (`validate_props`): totality and determinism (exactly one solution) and citation completeness (every cite atom is in the vocabulary).
