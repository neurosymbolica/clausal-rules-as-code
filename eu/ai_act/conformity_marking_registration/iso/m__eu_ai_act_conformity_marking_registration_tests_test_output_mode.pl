% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, annex_vii_notified_body/4, new_conformity_assessment_status/4, declaration_of_conformity_status/4, declaration_keeping_status/4, ce_marking_status/5, registration_status/5, listed_items/3, decide_conformity_marking_registration/2, conformity_marking_registration_status/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_profile_for/2]).

subject_case(Subject, Profile, AssessmentDate) :-
    conformity_marking_registration_profile_for(Subject, assessment(Profile, AssessmentDate)).

same_citations(Citations, Expected) :-
    clausal_msort(Citations, Sorted),
    clausal_msort(Expected, Sorted).

procedure_of(Subject, Result, Citations) :-
    subject_case(Subject, Profile, AssessmentDate),
    conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations).

test(the_baseline_profile_yields_exactly_one_status) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    findall(Status, conformity_marking_registration_status(AssessmentCase, Status), Statuses),
    Statuses == [high_risk_obligations_apply].
test(the_verdict_carries_a_citation) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    decide_conformity_marking_registration(AssessmentCase, conformity_marking_registration_verdict(_, [_|_])).
test(on_the_application_day_the_procedure_applies) :-
    procedure_of(point_three_on_application_day, Result, _),
    Result == internal_control_under_annex_vi.
test(the_day_before_the_application_day_nothing_applies) :-
    procedure_of(point_three_day_before_application_day, Result, Citations),
    Result == not_applicable_on_date,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(a_section_a_product_on_its_application_day) :-
    procedure_of(section_a_product_on_application_day, Result, Citations),
    Result == procedure_of_the_union_harmonisation_legislation,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_3)]).
test(a_section_a_product_the_day_before_its_application_day) :-
    procedure_of(section_a_product_day_before_application_day, Result, Citations),
    Result == not_applicable_on_date,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(a_concluded_system_is_not_high_risk) :-
    procedure_of(point_three_concluded_not_high_risk, Result, Citations),
    Result == not_high_risk_under_annex_iii_or_section_a_of_annex_i,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_art_43_3)]).
test(point_three_follows_internal_control) :-
    procedure_of(point_three_internal_control, Result, Citations),
    Result == internal_control_under_annex_vi,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_annex_vi)]).
test(point_one_with_full_standards_chooses) :-
    procedure_of(point_one_full_standards, Result, Citations),
    Result == choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_b), cite(eu_reg_2024_1689_annex_vi), cite(eu_reg_2024_1689_annex_vii)]).
test(point_one_with_partial_standards_follows_annex_vii) :-
    procedure_of(point_one_partial_standards, Result, Citations),
    Result == notified_body_procedure_under_annex_vii,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_b), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_c), cite(eu_reg_2024_1689_annex_vii)]).
test(point_one_with_a_restricted_standard) :-
    procedure_of(point_one_restricted_standard, Result, Citations),
    Result == choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_b), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_d), cite(eu_reg_2024_1689_annex_vi), cite(eu_reg_2024_1689_annex_vii)]).
test(a_section_a_product_with_the_option_and_full_standards) :-
    procedure_of(section_a_product_option_with_full_standards, Result, _),
    Result == procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party.
test(a_section_a_product_with_the_option_without_full_standards) :-
    procedure_of(section_a_product_option_without_full_standards, Result, _),
    Result == procedure_of_the_union_harmonisation_legislation_with_third_party_assessment.
test(point_one_with_the_standards_unstated_asks_for_them) :-
    procedure_of(point_one_standards_unstated, Result, Citations),
    Result == indeterminate([harmonised_standards_or_common_specifications_applied_in_full]),
    Citations == [].
test(an_annex_x_component_the_day_before_31_december_2030) :-
    procedure_of(annex_x_component_day_before_compliance_day, Result, Citations),
    Result == compliance_required_by_31_december_2030,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_111_1)]).
test(an_annex_x_component_on_31_december_2030) :-
    procedure_of(annex_x_component_on_compliance_day, Result, _),
    Result == internal_control_under_annex_vi.
test(a_public_authority_legacy_system_the_day_before_2_august_2030) :-
    procedure_of(public_authority_legacy_day_before_compliance_day, Result, Citations),
    Result == compliance_required_by_2_august_2030,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_111_2)]).
test(a_public_authority_legacy_system_on_2_august_2030) :-
    procedure_of(public_authority_legacy_on_compliance_day, Result, _),
    Result == internal_control_under_annex_vi.
test(a_legacy_system_without_significant_changes) :-
    procedure_of(legacy_system_without_significant_changes, Result, Citations),
    Result == not_applicable_to_a_system_placed_before_the_application_day,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_111_2)]).
test(a_legacy_system_with_significant_changes) :-
    procedure_of(legacy_system_with_significant_changes, Result, _),
    Result == internal_control_under_annex_vi.
test(an_unsure_significant_change_goes_to_a_lawyer) :-
    procedure_of(legacy_system_significant_changes_unsure, Result, Citations),
    Result == needs_legal_review(open_textured(significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_from_the_application_day - unsure, intended_to_be_used_by_public_authorities - false])]),
    Citations == [].
test(point_three_is_outside_article_43_1) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, Result, Citations),
    Result == article_43_1_not_applicable,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_art_43_3)]).
test(point_one_chooses_its_notified_body) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_43_1)]),
    Result == notified_body_of_the_providers_choice.
test(an_unread_absent_key_does_not_matter) :-
    subject_case(point_one_standards_unstated, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, Result, _),
    Result == notified_body_of_the_providers_choice.
test(a_substantial_modification_asks_for_a_new_assessment) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, Result, Citations),
    Result == new_conformity_assessment_required,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_43_4), cite(eu_reg_2024_1689_art_3_23)]).
test(a_first_assessment_has_no_previous_one) :-
    subject_case(point_three_first_assessment, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_43_4)]),
    Result == no_previous_conformity_assessment.
test(an_unsure_substantial_modification_goes_to_a_lawyer) :-
    subject_case(point_three_substantial_unsure, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, Result, []),
    Result == needs_legal_review(open_textured(substantial_modification, cite(eu_reg_2024_1689_art_3_23)), [inputs_relied_on([significant_changes_in_design_from_the_application_day - false, intended_to_be_used_by_public_authorities - false, substantial_modification - unsure])]).
test(other_legislation_gives_a_single_declaration) :-
    subject_case(point_three_other_declaration, Profile, AssessmentDate),
    declaration_of_conformity_status(Profile, AssessmentDate, Result, Citations),
    Result == single_declaration_for_all_applicable_union_law,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_47_1), cite(eu_reg_2024_1689_art_47_3)]).
test(the_declaration_is_kept_on_the_end_day) :-
    declaration_keeping_status(date(2027, 12, 2), date(2037, 12, 2), Result, _),
    Result == declaration_to_be_kept.
test(the_keeping_period_ends_the_day_after_the_end_day) :-
    declaration_keeping_status(date(2027, 12, 2), date(2037, 12, 3), Result, [cite(eu_reg_2024_1689_art_47_1)]),
    Result == keeping_period_ended.
test(a_leap_day_placing_is_kept_to_28_february) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 2, 28), Result, _),
    Result == declaration_to_be_kept.
test(a_digital_system_uses_the_digital_marking) :-
    subject_case(point_three_provided_digitally, Profile, AssessmentDate),
    ce_marking_status(Profile, digital_ce_marking, AssessmentDate, Result, Citations),
    Result == marking_element_required,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_2)]).
test(a_physical_system_carries_the_marking) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    ce_marking_status(Profile, ce_marking_affixed_to_the_system, AssessmentDate, Result, Citations),
    Result == marking_element_required,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_2), cite(eu_reg_2024_1689_art_48_3)]).
test(no_notified_body_number_without_a_notified_body) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    ce_marking_status(Profile, identification_number_of_the_notified_body, AssessmentDate, Result, Citations),
    Result == marking_element_not_required,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_4)]).
test(an_unsure_affixing_goes_to_a_lawyer) :-
    subject_case(point_three_affixing_unsure, Profile, AssessmentDate),
    ce_marking_status(Profile, ce_marking_affixed_to_the_packaging_or_accompanying_documentation, AssessmentDate, Result, []),
    Result == needs_legal_review(open_textured(affixing_to_the_system_possible_and_warranted, cite(eu_reg_2024_1689_art_48_3)), [inputs_relied_on([significant_changes_in_design_from_the_application_day - false, intended_to_be_used_by_public_authorities - false, affixing_to_the_system_possible_and_warranted - unsure])]).
test(an_unsure_affixing_does_not_reach_the_digital_marking) :-
    subject_case(point_three_affixing_unsure, Profile, AssessmentDate),
    ce_marking_status(Profile, digital_ce_marking, AssessmentDate, Result, _),
    Result == marking_element_not_required.
test(a_point_three_provider_registers_in_the_eu_database) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_49_1)]),
    Result == registration_in_the_eu_database.
test(a_point_two_provider_registers_at_national_level) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, Citations),
    Result == registration_at_national_level,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_5)]).
test(a_point_one_provider_registers_in_the_secure_section) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, Citations),
    Result == registration_in_the_secure_non_public_section_of_the_eu_database,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_a)]).
test(a_concluded_point_one_provider_registers_under_article_49_2) :-
    subject_case(point_one_concluded_not_high_risk, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, Citations),
    Result == registration_in_the_secure_non_public_section_of_the_eu_database,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_49_2), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_b)]).
test(a_concluded_point_three_provider_registers_under_article_49_2) :-
    subject_case(point_three_concluded_not_high_risk, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_49_2)]),
    Result == registration_in_the_eu_database.
test(a_section_a_product_has_no_registration) :-
    subject_case(section_a_product_on_application_day, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, Result, Citations),
    Result == no_registration_duty,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_2)]).
test(a_public_deployer_registers_its_use) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_49_3)]),
    Result == registration_in_the_eu_database.
test(a_public_deployer_of_a_point_one_system_uses_the_secure_section) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, Result, Citations),
    Result == registration_in_the_secure_non_public_section_of_the_eu_database,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_49_3), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_c)]).
test(a_private_deployer_has_no_registration) :-
    subject_case(point_three_private_deployer, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, Result, [cite(eu_reg_2024_1689_art_49_3)]),
    Result == no_registration_duty.
test(section_b_follows_the_law_as_amended) :-
    listed_items(annex_viii_section_b, Items, _),
    Items == [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose, conditions_under_article_6_3_on_which_the_system_is_considered_not_high_risk, status_of_the_ai_system].
test(the_secure_section_b_list_has_points_1_to_5_and_8) :-
    listed_items(annex_viii_section_b_secure_section, Items, Citations),
    Items == [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose, status_of_the_ai_system],
    member(cite(eu_reg_2024_1689_art_49_4_b), Citations).
test(annex_vi_lists_its_three_steps) :-
    listed_items(annex_vi_internal_control, Items, _),
    Items == [verification_of_the_quality_management_system_against_article_17, examination_of_the_technical_documentation_against_the_essential_requirements, verification_of_the_consistency_of_design_development_and_post_market_monitoring_with_the_technical_documentation].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, on_the_application_day_the_procedure_applies, the_day_before_the_application_day_nothing_applies, a_section_a_product_on_its_application_day, a_section_a_product_the_day_before_its_application_day, a_concluded_system_is_not_high_risk, point_three_follows_internal_control, point_one_with_full_standards_chooses, point_one_with_partial_standards_follows_annex_vii, point_one_with_a_restricted_standard, a_section_a_product_with_the_option_and_full_standards, a_section_a_product_with_the_option_without_full_standards, point_one_with_the_standards_unstated_asks_for_them, an_annex_x_component_the_day_before_31_december_2030, an_annex_x_component_on_31_december_2030, a_public_authority_legacy_system_the_day_before_2_august_2030, a_public_authority_legacy_system_on_2_august_2030, a_legacy_system_without_significant_changes, a_legacy_system_with_significant_changes, an_unsure_significant_change_goes_to_a_lawyer, point_three_is_outside_article_43_1, point_one_chooses_its_notified_body, an_unread_absent_key_does_not_matter, a_substantial_modification_asks_for_a_new_assessment, a_first_assessment_has_no_previous_one, an_unsure_substantial_modification_goes_to_a_lawyer, other_legislation_gives_a_single_declaration, the_declaration_is_kept_on_the_end_day, the_keeping_period_ends_the_day_after_the_end_day, a_leap_day_placing_is_kept_to_28_february, a_digital_system_uses_the_digital_marking, a_physical_system_carries_the_marking, no_notified_body_number_without_a_notified_body, an_unsure_affixing_goes_to_a_lawyer, an_unsure_affixing_does_not_reach_the_digital_marking, a_point_three_provider_registers_in_the_eu_database, a_point_two_provider_registers_at_national_level, a_point_one_provider_registers_in_the_secure_section, a_concluded_point_one_provider_registers_under_article_49_2, a_concluded_point_three_provider_registers_under_article_49_2, a_section_a_product_has_no_registration, a_public_deployer_registers_its_use, a_public_deployer_of_a_point_one_system_uses_the_secure_section, a_private_deployer_has_no_registration, section_b_follows_the_law_as_amended, the_secure_section_b_list_has_points_1_to_5_and_8, annex_vi_lists_its_three_steps]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
