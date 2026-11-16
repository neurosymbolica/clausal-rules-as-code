# SIGNATURE — eu/ai_act/scope_and_roles

This is the authoring plan the later phases execute.

- Package: `eu/ai_act/scope_and_roles`
- Predicate prefix: `scope_and_roles_`
- Shape family: deontic
- Pinned text: 02024R1689-20260727
- Layout (unchanged): kernel.clausal -> citations.clausal -> parameters.clausal -> scope_and_roles.clausal (the one determination slice) -> queries.clausal -> fixtures.clausal -> package facade. Every file name, module name and the package layout are kept. Only the TODO logic is replaced.

## 1. Public query surface (summary)

The five contract queries are exported by queries.clausal and re-exported by the facade:

- `regulation_scope_status/4`
- `defined_role_status/5`
- `value_chain_provider_status/4`
- `initial_provider_status/4`
- `supplier_agreement_status/4`

The input check is `scope_and_roles_input_problems/2`.

The facade keeps the scaffold names:

- `decide_scope_and_roles(CASE, scope_and_roles_verdict(STATUS, CITATIONS))`
- `scope_and_roles_status(CASE, STATUS)`

Here CASE is `case(PROFILE, ASSESSMENT_DATE)`, and the facade answers the leading question, regulation_scope_status. A profile cannot carry the date: ASSESSMENT_DATE is not one of the forty keys, so putting it in the profile would be `unknown_key`.

Totality and determinism:

- Every public query yields exactly ONE solution for every input. Ill-formed inputs give `input_problems(PROBLEMS)`.
- RESULT is one bare term. CITATIONS is one flat set-like list of `cite(KEY)`, which is [] for every not-final answer.
- No figure is imported from another domain. The statutory dates are owned by the slice.

## 2. Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

| Query | Final RESULT atoms |
|---|---|
| regulation_scope_status/4 | `not_applicable_on_date`, `earlier_text_not_formalised`, `out_of_scope`, `only_listed_provisions_apply`, `regulation_applies` |
| defined_role_status/5 | `not_applicable_on_date`, `earlier_text_not_formalised`, `role_does_not_hold`, `role_holds` |
| value_chain_provider_status/4 | `not_applicable_on_date`, `not_considered_provider`, `considered_provider` |
| initial_provider_status/4 | `not_applicable_on_date`, `initial_provider_unaffected`, `paragraph_2_not_applied`, `no_longer_provider_must_cooperate` |
| supplier_agreement_status/4 | `not_applicable_on_date`, `no_written_agreement_duty`, `written_agreement_required` |

The not-final status compounds are the same for every query. Each is the RESULT itself, never wrapped in a list:

- `indeterminate([KEY])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`. PAIRS is a list of `KEY-VALUE`. An optional trailing `provenance(CLAUSE, CITATIONS)` may follow; it is unscored.
- `input_problems(PROBLEMS)`.

The result constructors are exported and never called as queries: date/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1 and duplicate_key/1.

The defined roles (DEFINED_ROLE argument) are `provider`, `deployer`, `authorised_representative`, `importer`, `distributor` and `operator`.

Compliance modality atoms, used by `scope_and_roles_action_permitted/4`: `permitted`, `forbidden`.

## 3. Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]` and is read only with `profile_get/3` (presence first, then value). The forty keys are listed in root_exports and input_contract order, which is also each query's decision order. Types:

- enum: the listed atoms.
- crisp: `true` or `false`.
- judgement: `true`, `false` or `unsure`.

There are no numeric keys, so no unit suffixes are needed. Dates enter only as the ASSESSMENT_DATE argument date(Year, Month, Day).

| # | Key | Type | Read by |
|---|---|---|---|
| 1 | ai_system | judgement | scope, role |
| 2 | exclusively_for_military_defence_or_national_security_purposes | judgement | scope |
| 3 | third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation | crisp | scope |
| 4 | adequate_safeguards_for_fundamental_rights_and_freedoms | judgement | scope |
| 5 | specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development | judgement | scope |
| 6 | research_testing_or_development_before_placing_on_the_market_or_putting_into_service | crisp | scope |
| 7 | testing_in_real_world_conditions | crisp | scope |
| 8 | released_under_free_and_open_source_licence | crisp | scope |
| 9 | placed_on_the_market_or_put_into_service_as_high_risk_or_under_article_5_or_50 | crisp | scope |
| 10 | actor_role | enum {provider, deployer, importer, distributor, product_manufacturer, authorised_representative, affected_person} | scope |
| 11 | use_in_a_personal_non_professional_activity | judgement | scope, role |
| 12 | develops_or_has_developed_the_system | crisp | role |
| 13 | places_or_puts_into_service_the_system_together_with_its_product | crisp | scope |
| 14 | under_its_own_name_or_trademark | crisp | scope, role |
| 15 | uses_the_system_under_its_authority | crisp | role |
| 16 | written_mandate_from_a_provider_received_and_accepted | crisp | role |
| 17 | in_the_supply_chain | crisp | role |
| 18 | makes_the_system_available_on_the_union_market | judgement | role |
| 19 | is_a_product_manufacturer | crisp | role |
| 20 | places_the_system_on_the_union_market | judgement | scope, role |
| 21 | puts_the_system_into_service_in_the_union | judgement | scope, role |
| 22 | established_or_located_in_the_union | crisp | scope, role |
| 23 | located_in_the_union | crisp | scope |
| 24 | output_used_in_the_union | judgement | scope |
| 25 | represented_provider_established_in_the_union | crisp | scope |
| 26 | high_risk_under_article_6_1_related_to_a_product_under_section_b_of_annex_i | crisp | scope |
| 27 | system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country | crisp | role |
| 28 | high_risk_route | enum {annex_iii, annex_i} | value chain, initial, supplier |
| 29 | product_manufacturer_of_a_product_under_section_a_of_annex_i_with_the_system_as_safety_component | crisp | value chain |
| 30 | system_is_high_risk_after_the_change | crisp | value chain |
| 31 | puts_its_name_or_trademark_on_a_high_risk_system_already_placed_or_in_service | crisp | value chain |
| 32 | makes_a_substantial_modification_to_a_high_risk_system_already_placed_or_in_service | judgement | value chain |
| 33 | modifies_the_intended_purpose_of_a_system_not_classified_as_high_risk_already_placed_or_in_service | judgement | value chain |
| 34 | system_placed_on_the_market_together_with_the_product_under_the_manufacturer_name | crisp | value chain |
| 35 | system_put_into_service_under_the_manufacturer_name_after_the_product_was_placed | crisp | value chain |
| 36 | another_person_became_the_provider_under_paragraph_1 | crisp | initial |
| 37 | initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk | judgement | initial |
| 38 | supplies_items_used_or_integrated_in_a_high_risk_system | crisp | supplier |
| 39 | makes_the_items_accessible_to_the_public_under_a_free_and_open_source_licence | crisp | supplier |
| 40 | supplied_items_include_a_general_purpose_ai_model | crisp | supplier |

The typed input_contract writes crisp as `boolean` (the atoms true and false) and judgement as `one_of(boolean, unsure)`.

## 4. Citation-key atoms (canonical lexicon scheme; citation_vocabulary)

Load-bearing citations of THE LIMBS:

- Art 113: `eu_reg_2024_1689_art_113_a`, `eu_reg_2024_1689_art_113_c`, `eu_reg_2024_1689_art_113_c_i`, `eu_reg_2024_1689_art_113_c_ii`.
- Art 2(1): `eu_reg_2024_1689_art_2_1`, `eu_reg_2024_1689_art_2_1_a`, `eu_reg_2024_1689_art_2_1_b`, `eu_reg_2024_1689_art_2_1_c`, `eu_reg_2024_1689_art_2_1_d`, `eu_reg_2024_1689_art_2_1_e`, `eu_reg_2024_1689_art_2_1_f`, `eu_reg_2024_1689_art_2_1_g`.
- Art 2, other paragraphs: `eu_reg_2024_1689_art_2_2`, `eu_reg_2024_1689_art_2_3`, `eu_reg_2024_1689_art_2_4`, `eu_reg_2024_1689_art_2_6`, `eu_reg_2024_1689_art_2_8`, `eu_reg_2024_1689_art_2_10`, `eu_reg_2024_1689_art_2_12`.
- Art 3: `eu_reg_2024_1689_art_3_1`, `eu_reg_2024_1689_art_3_3`, `eu_reg_2024_1689_art_3_4`, `eu_reg_2024_1689_art_3_5`, `eu_reg_2024_1689_art_3_6`, `eu_reg_2024_1689_art_3_7`, `eu_reg_2024_1689_art_3_8`.
- Art 25: `eu_reg_2024_1689_art_25_1`, `eu_reg_2024_1689_art_25_1_a`, `eu_reg_2024_1689_art_25_1_b`, `eu_reg_2024_1689_art_25_1_c`, `eu_reg_2024_1689_art_25_2`, `eu_reg_2024_1689_art_25_2_a`, `eu_reg_2024_1689_art_25_2_b`, `eu_reg_2024_1689_art_25_2_c`, `eu_reg_2024_1689_art_25_3`, `eu_reg_2024_1689_art_25_3_a`, `eu_reg_2024_1689_art_25_3_b`, `eu_reg_2024_1689_art_25_4`.

Referral-row-only citations (the working notes (not published) decision D-5):

- `eu_reg_2024_1689_art_3_9`
- `eu_reg_2024_1689_art_3_10`
- `eu_reg_2024_1689_art_3_11`
- `eu_reg_2024_1689_art_3_23`

An atom is never shortened. Each atom appears once per CITATIONS list.

## 5. Public predicates (one line each)

Contract queries (queries.clausal, re-exported by the facade):

- `regulation_scope_status(Profile, AssessmentDate, Result, Citations)`: whether the Regulation applies to the actor in capacity actor_role for one AI system. Art 2(1) to (4), (6), (8), (10), (12); Art 3(1); Art 113(a).
- `defined_role_status(Profile, DefinedRole, AssessmentDate, Result, Citations)`: whether the actor holds the Art 3 role. Art 3(1), (3) to (8); Art 113(a).
- `value_chain_provider_status(Profile, AssessmentDate, Result, Citations)`: whether an actor other than the initial provider is considered the provider of a high-risk system. Art 25(1), (3); Art 113(c), (c)(i), (c)(ii).
- `initial_provider_status(Profile, AssessmentDate, Result, Citations)`: the effect of Art 25(2) on the initial provider. Art 25(2) with points (a) to (c); Art 113(c).
- `supplier_agreement_status(Profile, AssessmentDate, Result, Citations)`: whether Art 25(4) requires a written agreement. Art 25(4); Art 113(c).
- `scope_and_roles_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is a bare flat list. Input contract; no provision.

Facade (package facade; scaffold names kept):

- `decide_scope_and_roles(Case, Verdict)`: Case is `case(Profile, AssessmentDate)`. Verdict is `scope_and_roles_verdict(Status, Citations)`, the regulation_scope_status answer. Art 2; Art 3(1); Art 113(a).
- `scope_and_roles_status(Case, Status)`: the Status of `decide_scope_and_roles/2` alone (query type #3). Art 2.
- `scope_and_roles_checklist(Case, Checklist)`: the justification checklist (query type #7), built with `formalize_lib:assess/6` from `scope_and_roles_requirement/4`.
  - Each item is `item(RequirementId, Status, cite(CitationKey))`.
  - Requirement ids are art_113_a_in_force, art_3_1_ai_system, art_2_3_military_exclusion, art_2_4_third_country_cooperation_exclusion, art_2_6_scientific_research_exclusion, art_2_8_pre_market_research_exclusion, art_2_12_open_source_exclusion, art_2_1_coverage and art_2_2_section_b_regime.
  - The checklist justifies the verdict and never overrides it.
- `scope_and_roles_what_if(Case, Key, Value, Status)`: the regulation_scope_status Status after setting Key to Value with `formalize_lib:profile_set/3`. Art 2.
- `scope_and_roles_action_permitted(Case, Action, AssessmentDate, Modality)`: query type #13, built on kit/compliance_lib.
  - Action `supply_items_without_written_agreement` is forbidden when supplier_agreement_status is written_agreement_required (Art 25(4)).
  - Action `initial_provider_withholds_cooperation` is forbidden when initial_provider_status is no_longer_provider_must_cooperate (Art 25(2)).
  - Every other settled case is permitted.
  - A not-final status is returned as Modality itself: indeterminate/1, needs_legal_review/2 or input_problems/1.
  - Modality is a bare atom or that compound, never a record.

Fixtures (fixtures.clausal):

- `scope_and_roles_fixture(Name, Case)`: named cases. Name atoms:
  - eu_provider_placing_on_market
  - third_country_provider_output_in_union
  - personal_use_deployer
  - military_system_excluded
  - open_source_not_high_risk_excluded
  - section_b_high_risk_listed_provisions
  - authorised_representative_of_third_country_provider
  - date_before_application
  - date_in_earlier_text_window
  - missing_actor_role_indeterminate
  - unsure_ai_system_referral
  - distributor_that_is_importer
  - annex_i_in_window_not_applicable
  - rebranding_distributor_considered_provider
  - initial_provider_clearly_specified
  - open_source_supplier_no_agreement
  - general_purpose_model_supplier_agreement_required
- `scope_and_roles_fixture_expected(Name, Query, Result, Citations)`: the expected answer of each fixture under the query it targets.

## 6. Planned reuse (manifest `uses:`)

**formalize_lib**

- Imported predicates: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `memberd/2`, `not_member/2`, `not_defeated/3`, `assess/6`.
- Constructors: `item/3`, `attribute/2`, `unknown/1`, `unmet/1`.
- Requirement checks use `check_tri/4` and `check_tri_neg/4` for the judgement-valued checklist items. C15 forbids re-implementing them.

**kit/deadline_lib**

- `date_before/2`: the date literal 'ASSESSMENT_DATE before date(Y, M, D)'.
- `month_last_day/3`: the real-calendar-day check.
- Fallback: a local `calendar_day_before/6` on integers, if `date_before/2` rejects the compound. This is recorded as a kit gap in the working notes (not published).

**kit/compliance_lib**

- `nm/2`, `resolve_modality/3` and `compliance_check/7`, behind `scope_and_roles_action_permitted/4`.

**kit/query_combinators**

- `diff_checklists/3` and `changed_deltas/2`, for the what-if justification deltas.

**validate_props** (tests)

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`, which is the exactly-one-solution check
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`, over the dates 2025-02-01/02, 2026-07-26/27, 2027-12-01/02 and 2028-08-01/02
- `prop_missing_key_coverage/3`

**Not used**

- currency_vocab, vat_category and country: there is no money and no country code.
- rolling_window: not relevant to this order.

## 7. Kernel (kernel.clausal) — the shared floor

This is the only content shared between the slice and the downstream modules (queries, facade and fixtures):

- `scope_and_roles_contract_key(Key, Kind, Type)`: the forty rows in root order. Kind is enumeration, judgement or crisp.
- `scope_and_roles_input_problems/2`: the total, cut-free input check, in the order duplicate_key / wrong_type, then unknown_key.
- `scope_and_roles_valid_assessment_date/1`.
- `scope_and_roles_status_rule(Keys, Profile, LadderAnswer, Referral, Result, Citations)`: the generic STATUS RULE engine. Its arguments are:
  - Keys: the query keys in decision order.
  - LadderAnswer: a closure over a complete profile.
  - Referral: a closure giving the referral citation and inputs.

  The engine works as follows:
  - It runs a three-valued (Kleene) ladder evaluation with recursive witness search over the absent and unsure keys only.
  - It computes MATTERS and BEHIND exactly as the order defines them.
  - It emits SETTLED, `indeterminate([K])` or `needs_legal_review(...)`.
  - It builds PAIRS from the present judgement keys among Keys, in root order.

  The engine holds no statutory value.

Nothing statutory lives in the kernel. citations.clausal holds the citation_vocabulary facts and the referral rows. parameters.clausal stays a thin re-export: the statutory dates are owned by the slice.

## 8. Determination slice — scope_and_roles.clausal

This single self-contained slice holds every value fact, every ladder and every per-rule test for Arts 2, 3 and 25 as formalised here.

### 8.1 Statutory VALUE facts (owned here; never in a shared constants file)

- `:- constant_value(chapters_one_and_two_application_day, date(2025, 2, 2)).` (Art 113(a))
- `:- constant_value(pinned_consolidated_text_valid_from_day, date(2026, 7, 27)).` (document id 02024R1689-20260727; reading 3)
- `:- constant_value(chapter_three_annex_iii_application_day, date(2027, 12, 2)).` (Art 113(c)(i))
- `:- constant_value(chapter_three_annex_i_application_day, date(2028, 8, 2)).` (Art 113(c)(ii))
- If the engine rejects a date/3 compound in a constant, the slice stores year, month and day integer triples under the same names, suffixed `_year`, `_month` and `_day`.
- Citation tables, as facts:
  - `role_points(ActorRole, CitationList)`: the role points of Art 2(1).
  - `defined_role_citations(DefinedRole, CitationList)`: the role citations of Art 3.
  - `out_of_scope_citations(List)`: the fixed eight.
  - `art_25_paragraphs_1_and_3_citations(List)`.
  - `art_25_2_cooperation_citations(List)`.
  - The date citation lists for Art 113(a) and Art 113(c).

### 8.2 Rules and requirements (ladders exactly as THE LIMBS)

Each step is a clause with the ground RESULT folded into the head (C17). Each clause carries the failure of every earlier test as a guard. There are no cuts and no if-then-else.

regulation_scope_status steps:

1. Before 2025-02-02: not_applicable_on_date.
2. Before 2026-07-27: earlier_text_not_formalised.
3. out_of_scope when the defeasible coverage rule `art_2_1_coverage` does not hold. The coverage tests per actor_role are as THE COVERAGE TEST. The defeaters are a `defeater/2` table: not_ai_system, art_2_3_military, art_2_4_third_country_cooperation, art_2_6_scientific_research, art_2_8_pre_market_activity and art_2_12_open_source. The defeat test is `once(defeater(Ground, Profile))` via `not_defeated/3`, so several grounds give ONE answer.
4. only_listed_provisions_apply, with art_2_2 and the role points.
5. regulation_applies, with the role points.

defined_role_status:

- The six role tests: provider, deployer, authorised representative, importer, distributor and operator. The distributor test is defined as NOT(ANY(provider test, importer test)), and the operator test as given in THE LIMBS.
- Each role is guarded by ai_system true.
- The ladder runs date steps, then role_does_not_hold, then role_holds.

value_chain_provider_status:

1. Before 2027-12-02: not_applicable_on_date.
2. In the window, with annex_i or the Section A key true: not_applicable_on_date (Art 113(c), (c)(ii)).
3. The Art 25(1)(a) to (c) and Art 25(3)(a) to (b) test gives not_considered_provider or considered_provider.

initial_provider_status runs the date steps, then:

- initial_provider_unaffected
- paragraph_2_not_applied
- no_longer_provider_must_cooperate

supplier_agreement_status runs the date steps, then:

- no_written_agreement_duty, when nothing is supplied, or when the items are open source and include no general-purpose model
- written_agreement_required

Every query's not-final answers come from `scope_and_roles_status_rule/6` (kernel), called with the query's keys:

- for defined_role, the keys of that DEFINED_ROLE;
- the referral rows of citations.clausal, which are the working notes (not published) D-5 with the union-of-inputs rule.

### 8.3 Verdict atoms

As in section 2.

### 8.4 Per-rule tests (the seven test modes)

1. **Load**: the module and the facade load, and the exports resolve.
2. **Unit per limb**: one positive and one negative case for each ladder step and each coverage branch. Each `test(..., fail)` is paired with a positive test over the same case.
3. **Date boundaries**: each application day and the day before it.
4. **Status rule**:
   - missing actor_role gives indeterminate([actor_role]);
   - an exclusion settled with actor_role absent gives out_of_scope;
   - an unsure ai_system with all facts present gives needs_legal_review with cite(eu_reg_2024_1689_art_3_1);
   - a BEHIND case: absent adequate_safeguards behind an absent third_country key is not named;
   - a brute-force completion oracle must agree on fixtures with up to ten open keys.
5. **Input check**: duplicate_key, wrong_type, unknown_key ordering, a non-atom key, an unbound profile, a partial list, an unbound value, attested(...), wrong_type(defined_role) and wrong_type(assessment_date) (for example 2026-02-30).
6. **Counting**: findall over every query returns a list of length 1. One case has two exclusions holding together.
7. **Properties**: totality, determinism, citation completeness and missing-key coverage via validate_props.

### 8.5 Predicates the slice SHARES (and only these go to the kernel)

- `scope_and_roles_contract_key/3`
- `scope_and_roles_input_problems/2`
- `scope_and_roles_valid_assessment_date/1`
- `scope_and_roles_status_rule/6`

These are used by queries.clausal, the facade and fixtures. The slice exports to queries.clausal the five complete-profile ladder closures, one per query, plus `scope_and_roles_requirement/4` for the checklist.
