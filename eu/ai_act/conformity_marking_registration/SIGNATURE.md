# SIGNATURE — eu/ai_act/conformity_marking_registration

## 1 Public query surface

### The nine contract predicates

The nine contract predicates keep the names fixed by the order (INTERFACE - THE CALLED CONTRACT). The package prefix `conformity_marking_registration_` is used for the input check, the facade and the fixtures.

Every public predicate:

- yields exactly ONE solution;
- is total over every term (the input check never fails or raises);
- never binds a constant status in a body: ground verdicts are folded into clause heads, one clause per disjoint route;
- uses no cut, `->` or `*->`.

### Answer shapes

- **RESULT** is one bare atom, or one status compound: `indeterminate([KEY])`, `needs_legal_review(open_textured(KEY, cite(C)), [inputs_relied_on(PAIRS)])` or `input_problems(PROBLEMS)`.
- **CITATIONS** is a flat set-like list of `cite(KEY)`, and `[]` when the answer is not final.

### Facade (scaffold names kept)

The facade argument is `case(PROFILE, ASSESSMENT_DATE)`: an attribute-list profile plus a ground `date(Y, M, D)`.

### Verdict STATUS atoms (replacing the placeholder set `required / permitted / not_applicable`)

The facade status is derived from `conformity_assessment_procedure/4`:

- `high_risk_obligations_apply` — any of the eight procedure atoms;
- `not_applicable_on_date`;
- `not_high_risk_under_annex_iii_or_section_a_of_annex_i`;
- `compliance_required_by_31_december_2030`;
- `compliance_required_by_2_august_2030`;
- `not_applicable_to_a_system_placed_before_the_application_day`;
- or the status compound itself.

## 2 Public predicates (one line each)

- `conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations)`: Art 43 procedure for the system — eu_reg_2024_1689_art_43_1, _art_43_2, _art_43_3, annex_vi, annex_vii.
- `annex_vii_notified_body(Profile, AssessmentDate, Result, Citations)`: who acts as notified body for Annex VII — eu_reg_2024_1689_art_43_1.
- `new_conformity_assessment_status(Profile, AssessmentDate, Result, Citations)`: whether a change needs a new assessment — eu_reg_2024_1689_art_43_4, _art_3_23.
- `declaration_of_conformity_status(Profile, AssessmentDate, Result, Citations)`: single or ordinary declaration — eu_reg_2024_1689_art_47_1, _art_47_3.
- `declaration_keeping_status(PlacingDate, AssessmentDate, Result, Citations)`: (deadline #15) keep, or period ended, after ten years with the end day included — eu_reg_2024_1689_art_47_1.
- `ce_marking_status(Profile, Element, AssessmentDate, Result, Citations)`: whether one of five marking elements is required — eu_reg_2024_1689_art_48_1 to _art_48_5.
- `registration_status(Profile, Registrant, AssessmentDate, Result, Citations)`: (obligation #14) which Art 49 registration applies to the provider or deployer — eu_reg_2024_1689_art_49_1 to _art_49_5, _art_49_4_a to _d, _art_111_1, _art_111_2.
- `listed_items(ItemList, Items, Citations)`: (factual lookup #1) the items of one of eleven lists, in Annex order — the annex citations below.
- `conformity_marking_registration_input_problems(Profile, Problems)`: the input check, returning a BARE problem list — no provision (the input contract).
- `decide_conformity_marking_registration(Case, Verdict)`: (status #3) `Verdict = conformity_marking_registration_verdict(Status, Citations)`, from `conformity_assessment_procedure/4` — art_43 and art_111 / art_113 citations as fired.
- `conformity_marking_registration_status(Case, Status)`: Status only, same derivation — as above.
- `conformity_marking_registration_checklist(Case, Checklist)`: (justification #7) a list of `item(QueryIdentifier, Result, Citations)` in this fixed order:
  1. conformity_assessment_procedure
  2. annex_vii_notified_body
  3. new_conformity_assessment_status
  4. declaration_of_conformity_status
  5. ce_marking_status, once for each of the five elements, in contract order
  6. registration_status with provider
  7. registration_status with deployer

  Each item carries its query's cite list.
- `conformity_marking_registration_what_if(Case, Key, Value, Verdict)`: re-decides with `attribute(Key, Value)` set via `profile_set/3` — as the decide predicate.
- `conformity_marking_registration_fixture(Name, Case)` and `conformity_marking_registration_fixture_expected(Name, Query, Result, Citations)`: worked cases.

## 2a Pinned atom names (result atoms, item atoms, constructors)

These names are pinned by the order and are spelled here EXACTLY as the reference scorer reads them. They are ATOMS (or, for the three constructors, data terms), NOT predicates to define: the parenthesised arguments only record the query arguments under which the atom is returned (or, for a constructor, its own arguments). Each line gives the description and the citation the answer carries.

### Result atoms of conformity_assessment_procedure/4

- `procedure_of_the_union_harmonisation_legislation(Profile, AssessmentDate)`: step (9); a system covered by Section A of Annex I follows the procedure of that legislation — eu_reg_2024_1689_art_43_3.
- `procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party(Profile, AssessmentDate)`: step (7); the legislation offers an option without a third party and the standards or specifications were applied in full — eu_reg_2024_1689_art_43_3.
- `procedure_of_the_union_harmonisation_legislation_with_third_party_assessment(Profile, AssessmentDate)`: step (8); the option exists but the standards or specifications were not applied in full — eu_reg_2024_1689_art_43_3.
- `choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii(Profile, AssessmentDate)`: step (12); Annex III point 1 system with standards applied in full chooses Annex VI or Annex VII — eu_reg_2024_1689_art_43_1, _art_43_1_first_subparagraph_a, _art_43_1_first_subparagraph_b, _annex_vi, _annex_vii.
- `choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part(Profile, AssessmentDate)`: step (11); an applied standard was published with a restriction, Annex VII for the restricted part, choice for the rest — eu_reg_2024_1689_art_43_1, _art_43_1_first_subparagraph_a, _art_43_1_first_subparagraph_b, _art_43_1_second_subparagraph_d, _annex_vi, _annex_vii.
- `notified_body_procedure_under_annex_vii(Profile, AssessmentDate)`: step (10); Annex III point 1 system without standards applied in full follows Annex VII — eu_reg_2024_1689_art_43_1, _art_43_1_second_subparagraph_a, _b, _c, _annex_vii.
- `internal_control_under_annex_vi(Profile, AssessmentDate)`: step (13); Annex III points 2 to 8 follow internal control — eu_reg_2024_1689_art_43_2, _annex_vi.

### Result atoms of annex_vii_notified_body/4

- `market_surveillance_authority_acts_as_notified_body(Profile, AssessmentDate)`: step (8); system intended to be put into service by law enforcement, immigration or asylum authorities or Union institutions, bodies, offices or agencies — eu_reg_2024_1689_art_43_1.
- `notified_body_of_the_providers_choice(Profile, AssessmentDate)`: step (9); the provider may choose any notified body — eu_reg_2024_1689_art_43_1.

### Result atoms of new_conformity_assessment_status/4

- `new_conformity_assessment_required(Profile, AssessmentDate)`: step (9); a substantial modification of an already-assessed system — eu_reg_2024_1689_art_43_4, _art_3_23.
- `new_conformity_assessment_not_required(Profile, AssessmentDate)`: steps (8) and (10); a pre-determined learning change, or a change that is not a substantial modification — eu_reg_2024_1689_art_43_4, _art_3_23.

### Result atoms of declaration_of_conformity_status/4

- `single_declaration_for_all_applicable_union_law(Profile, AssessmentDate)`: step (7); other harmonisation legislation also requires a declaration — eu_reg_2024_1689_art_47_1, _art_47_3.
- `declaration_under_this_regulation(Profile, AssessmentDate)`: step (8); a declaration under this Regulation alone — eu_reg_2024_1689_art_47_1.

### Result atoms of ce_marking_status/5

- `marking_element_required(Profile, Element, AssessmentDate)`: step (7); THE REQUIRED TEST of the element is met — eu_reg_2024_1689_art_48_1 with the element's _art_48_2 to _art_48_5.
- `marking_element_not_required(Profile, Element, AssessmentDate)`: step (8); THE REQUIRED TEST of the element is failed — eu_reg_2024_1689_art_48_1 with the element's _art_48_2 to _art_48_5.

### Result atoms of registration_status/5

- `no_registration_duty(Profile, Registrant, AssessmentDate)`: (P2) system not listed in Annex III — eu_reg_2024_1689_art_49_1, _art_49_2; (E2) deployer with no duty — eu_reg_2024_1689_art_49_3.
- `registration_in_the_eu_database(Profile, Registrant, AssessmentDate)`: (P5) — eu_reg_2024_1689_art_49_2; (P11) — eu_reg_2024_1689_art_49_1; (E7) — eu_reg_2024_1689_art_49_3.
- `registration_in_the_secure_non_public_section_of_the_eu_database(Profile, Registrant, AssessmentDate)`: Annex III points 1, 6, 7; (P4) — eu_reg_2024_1689_art_49_2, _art_49_4, _art_49_4_b; (P10) — eu_reg_2024_1689_art_49_1, _art_49_4, _art_49_4_a; (E6) — eu_reg_2024_1689_art_49_3, _art_49_4, _art_49_4_c.
- `registration_at_national_level(Profile, Registrant, AssessmentDate)`: (P9) Annex III point 2 system, provider — eu_reg_2024_1689_art_49_1, _art_49_5.

### Item atoms of listed_items/3 (in Annex order inside each list)

- `verification_of_the_quality_management_system_against_article_17(ItemList)`: annex_vi_internal_control, point 2 — eu_reg_2024_1689_annex_vi_2.
- `examination_of_the_technical_documentation_against_the_essential_requirements(ItemList)`: annex_vi_internal_control, point 3 — eu_reg_2024_1689_annex_vi_3.
- `verification_of_the_consistency_of_design_development_and_post_market_monitoring_with_the_technical_documentation(ItemList)`: annex_vi_internal_control, point 4 — eu_reg_2024_1689_annex_vi_4.
- `name_and_address_of_the_provider_and_of_any_authorised_representative_lodging_the_application(ItemList)`: annex_vii_quality_management_system_application, point 3.1(a) — eu_reg_2024_1689_annex_vii_3_1_a.
- `list_of_ai_systems_covered_by_the_quality_management_system(ItemList)`: annex_vii_quality_management_system_application, point 3.1(b) — eu_reg_2024_1689_annex_vii_3_1_b.
- `technical_documentation_for_each_ai_system_covered(ItemList)`: annex_vii_quality_management_system_application, point 3.1(c) — eu_reg_2024_1689_annex_vii_3_1_c.
- `documentation_of_the_quality_management_system(ItemList)`: annex_vii_quality_management_system_application, point 3.1(d) — eu_reg_2024_1689_annex_vii_3_1_d.
- `description_of_the_procedures_keeping_the_quality_management_system_adequate_and_effective(ItemList)`: annex_vii_quality_management_system_application, point 3.1(e) — eu_reg_2024_1689_annex_vii_3_1_e.
- `written_declaration_that_the_application_has_not_been_lodged_with_another_notified_body(ItemList)`: shared atom; point 3.1(f) and point 4.2(b) — eu_reg_2024_1689_annex_vii_3_1_f, _annex_vii_4_2_b.
- `name_and_address_of_the_provider(ItemList)`: annex_vii_technical_documentation_application, point 4.2(a) — eu_reg_2024_1689_annex_vii_4_2_a.
- `technical_documentation_referred_to_in_annex_iv(ItemList)`: annex_vii_technical_documentation_application, point 4.2(c) — eu_reg_2024_1689_annex_vii_4_2_c.
- `name_address_and_contact_details_of_the_provider(ItemList)`: shared; Annex VIII Section A point 1 and Section B point 1 (also in their secure lists) — eu_reg_2024_1689_annex_viii_section_a_1, _annex_viii_section_b_1.
- `name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider(ItemList)`: shared; Section A point 2 and Section B point 2 — eu_reg_2024_1689_annex_viii_section_a_2, _annex_viii_section_b_2.
- `name_address_and_contact_details_of_the_authorised_representative(ItemList)`: shared; Section A point 3 and Section B point 3 — eu_reg_2024_1689_annex_viii_section_a_3, _annex_viii_section_b_3.
- `trade_name_and_unambiguous_reference_for_identification_and_traceability(ItemList)`: shared; Section A point 4 and Section B point 4 — eu_reg_2024_1689_annex_viii_section_a_4, _annex_viii_section_b_4.
- `description_of_the_intended_purpose_and_of_the_components_and_functions(ItemList)`: Section A point 5 — eu_reg_2024_1689_annex_viii_section_a_5.
- `description_of_the_information_used_and_of_the_operating_logic(ItemList)`: Section A point 6 (not in the secure list) — eu_reg_2024_1689_annex_viii_section_a_6.
- `status_of_the_ai_system(ItemList)`: shared; Section A point 7 and Section B point 8 — eu_reg_2024_1689_annex_viii_section_a_7, _annex_viii_section_b_8.
- `type_number_and_expiry_date_of_the_certificate_and_name_or_number_of_the_notified_body(ItemList)`: Section A point 8 — eu_reg_2024_1689_annex_viii_section_a_8.
- `scanned_copy_of_the_certificate(ItemList)`: Section A point 9 — eu_reg_2024_1689_annex_viii_section_a_9.
- `member_states_where_placed_on_the_market_put_into_service_or_made_available(ItemList)`: Section A point 10 — eu_reg_2024_1689_annex_viii_section_a_10.
- `copy_of_the_eu_declaration_of_conformity(ItemList)`: Section A point 11 — eu_reg_2024_1689_annex_viii_section_a_11.
- `electronic_instructions_for_use(ItemList)`: Section A point 12 — eu_reg_2024_1689_annex_viii_section_a_12.
- `url_for_additional_information(ItemList)`: Section A point 13 — eu_reg_2024_1689_annex_viii_section_a_13.
- `description_of_the_intended_purpose(ItemList)`: Section B point 5 — eu_reg_2024_1689_annex_viii_section_b_5.
- `conditions_under_article_6_3_on_which_the_system_is_considered_not_high_risk(ItemList)`: Section B point 6 (not in the secure list) — eu_reg_2024_1689_annex_viii_section_b_6.
- `name_address_and_contact_details_of_the_deployer(ItemList)`: Section C point 1 — eu_reg_2024_1689_annex_viii_section_c_1.
- `name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_deployer(ItemList)`: Section C point 2 — eu_reg_2024_1689_annex_viii_section_c_2.
- `url_of_the_providers_entry_in_the_eu_database(ItemList)`: Section C point 3 — eu_reg_2024_1689_annex_viii_section_c_3.
- `summary_of_the_findings_of_the_fundamental_rights_impact_assessment(ItemList)`: Section C point 4 (not in the secure list) — eu_reg_2024_1689_annex_viii_section_c_4.
- `summary_of_the_data_protection_impact_assessment(ItemList)`: Section C point 5 (not in the secure list) — eu_reg_2024_1689_annex_viii_section_c_5.
- `union_wide_unique_single_identification_number_of_the_testing(ItemList)`: Annex IX point 1 — eu_reg_2024_1689_annex_ix_1.
- `name_and_contact_details_of_the_provider_and_of_the_deployers_involved_in_the_testing(ItemList)`: Annex IX point 2 — eu_reg_2024_1689_annex_ix_2.
- `brief_description_of_the_ai_system_and_of_its_intended_purpose(ItemList)`: Annex IX point 3 — eu_reg_2024_1689_annex_ix_3.
- `summary_of_the_main_characteristics_of_the_testing_plan(ItemList)`: Annex IX point 4 (not in the secure list) — eu_reg_2024_1689_annex_ix_4.
- `information_on_suspension_or_termination_of_the_testing(ItemList)`: Annex IX point 5 — eu_reg_2024_1689_annex_ix_5.

### Result constructors (exported, never called as queries)

- `provenance(Clause, Citations)`: optional, unscored trailing element after `inputs_relied_on(PAIRS)` in a needs_legal_review context, marking the deciding clause — no provision (THE STATUS RULE of this order).
- `unknown_key(Key)`: input problem for a key outside the twenty contract keys, Key as given, in order of first occurrence — no provision (the input contract of this order).
- `duplicate_key(Key)`: input problem for a contract key occurring more than once, values not read — no provision (the input contract of this order).

## 3 Profile keys (twenty, in root_exports and input_contract order)

| # | key | type |
|---|---|---|
| 1 | annex_iii_point | enum: not_listed_in_annex_iii, annex_iii_point_1 to annex_iii_point_8 |
| 2 | provider_concluded_under_article_6_3_that_the_system_is_not_high_risk | crisp |
| 3 | covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i | crisp |
| 4 | component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027 | crisp |
| 5 | placed_on_the_market_or_put_into_service_before_the_application_day | crisp |
| 6 | significant_changes_in_design_from_the_application_day | judgement |
| 7 | intended_to_be_used_by_public_authorities | judgement |
| 8 | harmonised_standards_or_common_specifications_applied_in_full | crisp |
| 9 | applied_harmonised_standard_published_with_a_restriction | crisp |
| 10 | harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment | crisp |
| 11 | intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies | judgement |
| 12 | already_subject_to_a_conformity_assessment_procedure | crisp |
| 13 | change_pre_determined_for_a_system_that_continues_to_learn | crisp |
| 14 | substantial_modification | judgement |
| 15 | other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity | crisp |
| 16 | provided_digitally | crisp |
| 17 | affixing_to_the_system_possible_and_warranted | judgement |
| 18 | notified_body_involved_in_the_conformity_assessment | crisp |
| 19 | other_union_law_provides_for_affixing_the_ce_marking | crisp |
| 20 | deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf | crisp |

Value types:

- **crisp** — the atom `true` or the atom `false`;
- **judgement** — `true`, `false` or `unsure`.

There are no numeric or money keys. Dates are arguments, not keys: ground `date(Year, Month, Day)` integer terms, with Year from 1 to 9999 and a real calendar day.

Argument atoms:

- **ELEMENT** — one of the five atoms of the contract;
- **REGISTRANT** — `provider` or `deployer`;
- **ITEM_LIST** — one of the eleven list atoms.

## 4 Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`)

### Articles

- eu_reg_2024_1689_art_3_23
- eu_reg_2024_1689_art_43_1
- eu_reg_2024_1689_art_43_1_first_subparagraph_a, eu_reg_2024_1689_art_43_1_first_subparagraph_b
- eu_reg_2024_1689_art_43_1_second_subparagraph_a, _b, _c, _d
- eu_reg_2024_1689_art_43_2, eu_reg_2024_1689_art_43_3, eu_reg_2024_1689_art_43_4
- eu_reg_2024_1689_art_47_1, eu_reg_2024_1689_art_47_3
- eu_reg_2024_1689_art_48_1 to eu_reg_2024_1689_art_48_5
- eu_reg_2024_1689_art_49_1, _49_2, _49_3, _49_4, _49_4_a, _49_4_b, _49_4_c, _49_4_d, _49_5
- eu_reg_2024_1689_art_111_1, eu_reg_2024_1689_art_111_2
- eu_reg_2024_1689_art_113, eu_reg_2024_1689_art_113_c, eu_reg_2024_1689_art_113_c_i, eu_reg_2024_1689_art_113_c_ii

### Annexes

- eu_reg_2024_1689_annex_vi, annex_vi_1 to annex_vi_4
- eu_reg_2024_1689_annex_vii, annex_vii_1
- annex_vii_3_1, annex_vii_3_1_a to annex_vii_3_1_f
- annex_vii_4_2, annex_vii_4_2_a to annex_vii_4_2_c
- eu_reg_2024_1689_annex_viii
- annex_viii_section_a, annex_viii_section_a_1 to annex_viii_section_a_13
- annex_viii_section_b, annex_viii_section_b_1 to annex_viii_section_b_6, annex_viii_section_b_8
- annex_viii_section_c, annex_viii_section_c_1 to annex_viii_section_c_5
- eu_reg_2024_1689_annex_ix, annex_ix_1 to annex_ix_5

Every shortened form in this section expands to the full `eu_reg_2024_1689_` prefix. No other atom is invented.

### Referral rows (judgement, query: citation)

| judgement key | queries | citation |
|---|---|---|
| significant_changes_in_design_from_the_application_day | every profile query | eu_reg_2024_1689_art_111_2 |
| intended_to_be_used_by_public_authorities | every profile query | eu_reg_2024_1689_art_111_2 |
| intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies | annex_vii_notified_body | eu_reg_2024_1689_art_43_1 |
| substantial_modification | new_conformity_assessment_status | eu_reg_2024_1689_art_3_23 |
| affixing_to_the_system_possible_and_warranted | ce_marking_status | eu_reg_2024_1689_art_48_3 |

## 5 Package layout (unchanged)

kernel → citations → parameters → conformity_marking_registration → queries → fixtures → package facade.

- **kernel.clausal** — the shared floor:
  - the input check;
  - real-calendar-day validity;
  - the THE STATUS RULE engine.
- **citations.clausal** — `citation_vocabulary/1` facts (section 4) and the referral rows.
- **parameters.clausal** — the key table only (key, type, order), the enumeration and argument atoms, and the query-key lists in decision order. It holds NO statutory figures: those live in the slice.
- **queries.clausal** — the nine contract predicates. Each one wires:
  1. step (0) (input problems);
  2. the status rule over the slice ladder;
  3. the RESULT / CITATIONS output.
- **fixtures.clausal**, then the facade.

### Tests (seven modes, v2 manifest)

1. load
2. per-rule positive and negative pairs over the same case
3. boundary days: 2027-12-01/02, 2028-08-01/02, 2030-08-01/02, 2030-12-30/31, and the end day plus or minus one
4. status rule: missing / unsure / behind witnesses
5. input check, including duplicates, non-atom keys, partial lists and unbound values
6. counting: every query collected with findall gives length 1
7. validate_props: totality, determinism and citation completeness

## 6 Slice: conformity_marking_registration.clausal

### VALUE facts it owns (`:- constant_value(...)`)

- `annex_iii_application_day = date(2027, 12, 2)` — Art 113(c)(i).
- `annex_i_application_day = date(2028, 8, 2)` — Art 113(c)(ii).
- `annex_x_compliance_day = date(2030, 12, 31)` — Art 111(1).
- `public_authority_compliance_day = date(2030, 8, 2)` — Art 111(2).
- `declaration_keeping_period_years = 10` — Art 47(1).
- Two dates are recorded in comments only, because no limb compares them:
  - 2 August 2026, the general date of Art 113, second paragraph;
  - 2 August 2027, inside the meaning of the Annex X key.
- The eleven item lists, as `item_list_items/2` and `item_list_citations/2` facts in Annex order (THE ITEM LISTS, verbatim; Section B without points 7 and 9; item atoms as in section 2a).
- The five CE elements, as `element_required_test/2` and `element_citations/2` facts.

### Named tests (helper predicates, three exclusive clauses each where tri-valued)

- listed
- annex_iii_high_risk
- high_risk
- secure_section_point

On a complete profile they are evaluated by `profile_get/3` after `profile_has/2`.

### Ladders (requirements)

Each ladder is a set of `ladder_step(Query, StepNumber, Profile, Arguments, AssessmentDate, Result, Citations)` rules.

- **Common steps (1) to (6)**: the date gates of Art 113(c)(i) and (ii); not high-risk; the Annex X transition; the public-authority transition; the legacy system.
- **conformity_assessment_procedure**: steps (7) to (13).
- **annex_vii_notified_body**: steps (1) to (3), (4) article_43_1_not_applicable, (5) to (7), then (8) and (9).
- **new_conformity_assessment_status**: steps (7) to (10).
- **declaration_of_conformity_status**: steps (7) and (8).
- **ce_marking_status**: steps (7) and (8), from the element facts.
- **registration_status**:
  - step (1);
  - provider: (P2) to (P11);
  - deployer: (E2) to (E7).
- **declaration_keeping_status**: the end day (same month and day, Year plus 10, clamped by `month_last_day/3`); (1) after the end day gives `keeping_period_ended`; (2) otherwise `declaration_to_be_kept`.
- **listed_items**: a fact lookup; any other term gives `input_problems([wrong_type(item_list)])`.

First-match is defeasible and cut-free. Step N answers when its test is met and no earlier step is met. The earlier-step check is a guarded defeater, `once/1` inside negation-as-failure (`not_defeated/3` pattern), so each complete profile yields exactly one ladder answer.

### Verdict atoms

All RESULT atoms of the contract (A) to (H), listed in INTERFACE - THE CALLED CONTRACT and in section 2a.

### Shared with kernel (and only this)

- `real_calendar_day/1`;
- the date order via `date_before/2` and `date_after/2`;
- the status-rule engine `status_answer(Query, Profile, Arguments, AssessmentDate, Result, Citations)`. It:
  - enumerates completions over the absent query keys and the unsure judgements;
  - computes matters, witnesses and behind;
  - applies S1, S2 and S3, with PAIRS in root_exports order.

  The slice gives it a complete-profile oracle, `ladder_answer/6`, passed as a closure.

## 7 Planned reuse (manifest `uses:`)

- **formalize_lib**: profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, profile_keys/2, memberd/2, not_member/2, not_defeated/3, item/3, attribute/2.
- **kit/deadline_lib**: month_last_day/3 (calendar validity and the 29 February clamp), date_before/2, date_after/2.
- **kit/query_combinators**: diff_checklists/3, for a what-if delta test.
- **validate_props** (tests only): run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3.
- **list_item/3** (built in): positional reads of the item lists in tests.

Not used:

- library(datetime) — no day arithmetic is needed: the anniversary is a field operation;
- compliance_lib, rolling_window, currency_vocab, vat_category, country — these do not fit a deontic ladder without money or windows.
