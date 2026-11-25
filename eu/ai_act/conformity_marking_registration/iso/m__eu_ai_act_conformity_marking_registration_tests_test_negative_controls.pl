% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, annex_vii_notified_body/4, new_conformity_assessment_status/4, declaration_of_conformity_status/4, declaration_keeping_status/4, ce_marking_status/5, registration_status/5, conformity_marking_registration_status/2, conformity_marking_registration_status_values/1]).
:- use_module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_profile_for/2]).

subject_case(Subject, Profile, AssessmentDate) :-
    conformity_marking_registration_profile_for(Subject, assessment(Profile, AssessmentDate)).

procedure_of(Subject, Result) :-
    subject_case(Subject, Profile, AssessmentDate),
    conformity_assessment_procedure(Profile, AssessmentDate, Result, _).

test(the_status_table_has_a_near_miss_atom) :-
    conformity_marking_registration_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_baseline_profile_yields_exactly_one_status) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    findall(Status, conformity_marking_registration_status(AssessmentCase, Status), [_]).
test(the_day_before_is_not_applicable) :-
    procedure_of(point_three_day_before_application_day, not_applicable_on_date).
test(a_section_a_product_on_its_day_follows_its_legislation) :-
    procedure_of(section_a_product_on_application_day, procedure_of_the_union_harmonisation_legislation).
test(a_concluded_system_is_not_high_risk) :-
    procedure_of(point_three_concluded_not_high_risk, not_high_risk_under_annex_iii_or_section_a_of_annex_i).
test(point_three_follows_internal_control) :-
    procedure_of(point_three_internal_control, internal_control_under_annex_vi).
test(partial_standards_follow_annex_vii) :-
    procedure_of(point_one_partial_standards, notified_body_procedure_under_annex_vii).
test(full_standards_give_the_choice) :-
    procedure_of(point_one_full_standards, choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii).
test(a_restricted_standard_gives_annex_vii_for_the_restricted_part) :-
    procedure_of(point_one_restricted_standard, choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part).
test(the_option_with_full_standards) :-
    procedure_of(section_a_product_option_with_full_standards, procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party).
test(the_option_without_full_standards_needs_a_third_party) :-
    procedure_of(section_a_product_option_without_full_standards, procedure_of_the_union_harmonisation_legislation_with_third_party_assessment).
test(an_annex_x_component_before_31_december_2030) :-
    procedure_of(annex_x_component_day_before_compliance_day, compliance_required_by_31_december_2030).
test(a_public_authority_legacy_system_before_2_august_2030) :-
    procedure_of(public_authority_legacy_day_before_compliance_day, compliance_required_by_2_august_2030).
test(a_legacy_system_without_changes_is_outside) :-
    procedure_of(legacy_system_without_significant_changes, not_applicable_to_a_system_placed_before_the_application_day).
test(law_enforcement_gets_the_market_surveillance_authority) :-
    subject_case(point_one_law_enforcement, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, market_surveillance_authority_acts_as_notified_body, _).
test(a_private_point_one_system_chooses) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, notified_body_of_the_providers_choice, _).
test(point_three_is_outside_article_43_1) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, article_43_1_not_applicable, _).
test(a_substantial_modification_needs_a_new_assessment) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, new_conformity_assessment_required, _).
test(a_minor_change_needs_no_new_assessment) :-
    subject_case(point_three_not_substantial, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, new_conformity_assessment_not_required, _).
test(a_pre_determined_change_needs_no_new_assessment) :-
    subject_case(point_three_predetermined_change, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, new_conformity_assessment_not_required, _).
test(a_first_assessment_has_no_previous_one) :-
    subject_case(point_three_first_assessment, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, no_previous_conformity_assessment, _).
test(other_legislation_gives_a_single_declaration) :-
    subject_case(point_three_other_declaration, Profile, AssessmentDate),
    declaration_of_conformity_status(Profile, AssessmentDate, single_declaration_for_all_applicable_union_law, _).
test(no_other_legislation_gives_the_declaration_under_this_regulation) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    declaration_of_conformity_status(Profile, AssessmentDate, declaration_under_this_regulation, _).
test(the_declaration_is_kept_on_the_end_day) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 2, 28), declaration_to_be_kept, _).
test(the_keeping_period_ends_the_next_day) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 3, 1), keeping_period_ended, _).
test(a_digital_system_needs_the_digital_marking) :-
    subject_case(point_three_provided_digitally, Profile, AssessmentDate),
    ce_marking_status(Profile, digital_ce_marking, AssessmentDate, marking_element_required, _).
test(a_physical_system_needs_no_digital_marking) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    ce_marking_status(Profile, digital_ce_marking, AssessmentDate, marking_element_not_required, _).
test(a_point_two_provider_registers_at_national_level) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, registration_at_national_level, _).
test(a_point_one_provider_registers_in_the_secure_section) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, registration_in_the_secure_non_public_section_of_the_eu_database, _).
test(a_public_deployer_registers) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, registration_in_the_eu_database, _).
test(a_private_deployer_has_no_registration_duty) :-
    subject_case(point_three_private_deployer, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, no_registration_duty, _).
test(a_deployer_of_a_point_two_system_has_no_registration_duty) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, no_registration_duty, _).
test(an_absent_standards_key_is_named) :-
    procedure_of(point_one_standards_unstated, indeterminate([harmonised_standards_or_common_specifications_applied_in_full])).
test(an_unsure_substantial_modification_is_referred) :-
    subject_case(point_three_substantial_unsure, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, needs_legal_review(open_textured(substantial_modification, cite(eu_reg_2024_1689_art_3_23)), _), []).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    findall(Status, conformity_marking_registration_status(AssessmentCase, Status), [BaselineStatus]),
    conformity_marking_registration_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    conformity_marking_registration_status(AssessmentCase, Other).
test(the_application_day_itself_is_not_not_applicable, fail) :-
    procedure_of(point_three_on_application_day, not_applicable_on_date).
test(a_section_a_product_the_day_before_does_not, fail) :-
    procedure_of(section_a_product_day_before_application_day, procedure_of_the_union_harmonisation_legislation).
test(an_unconcluded_system_is_not_not_high_risk, fail) :-
    procedure_of(point_three_internal_control, not_high_risk_under_annex_iii_or_section_a_of_annex_i).
test(point_one_does_not_follow_internal_control_alone, fail) :-
    procedure_of(point_one_full_standards, internal_control_under_annex_vi).
test(full_standards_do_not_force_annex_vii, fail) :-
    procedure_of(point_one_full_standards, notified_body_procedure_under_annex_vii).
test(an_unrestricted_standard_does_not, fail) :-
    procedure_of(point_one_full_standards, choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part).
test(the_option_without_full_standards_is_not_available, fail) :-
    procedure_of(section_a_product_option_without_full_standards, procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party).
test(an_annex_x_component_on_31_december_2030_is_answered_as_any_other, fail) :-
    procedure_of(annex_x_component_on_compliance_day, compliance_required_by_31_december_2030).
test(a_public_authority_legacy_system_on_2_august_2030, fail) :-
    procedure_of(public_authority_legacy_on_compliance_day, compliance_required_by_2_august_2030).
test(a_legacy_system_with_changes_is_inside, fail) :-
    procedure_of(legacy_system_with_significant_changes, not_applicable_to_a_system_placed_before_the_application_day).
test(a_private_point_one_system_does_not, fail) :-
    subject_case(point_one_full_standards, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, market_surveillance_authority_acts_as_notified_body, _).
test(a_minor_change_does_not, fail) :-
    subject_case(point_three_not_substantial, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, new_conformity_assessment_required, _).
test(an_assessed_system_has_a_previous_one, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, no_previous_conformity_assessment, _).
test(no_other_legislation_gives_no_single_declaration, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    declaration_of_conformity_status(Profile, AssessmentDate, single_declaration_for_all_applicable_union_law, _).
test(the_end_day_is_not_after_the_end_day, fail) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 2, 28), keeping_period_ended, _).
test(a_physical_system_does_not, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    ce_marking_status(Profile, digital_ce_marking, AssessmentDate, marking_element_required, _).
test(a_digital_system_is_not_marked_on_the_system, fail) :-
    subject_case(point_three_provided_digitally, Profile, AssessmentDate),
    ce_marking_status(Profile, ce_marking_affixed_to_the_system, AssessmentDate, marking_element_required, _).
test(a_point_three_provider_does_not, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, registration_at_national_level, _).
test(a_point_three_provider_does_not_use_the_secure_section, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, registration_in_the_secure_non_public_section_of_the_eu_database, _).
test(a_private_deployer_does_not, fail) :-
    subject_case(point_three_private_deployer, Profile, AssessmentDate),
    registration_status(Profile, deployer, AssessmentDate, registration_in_the_eu_database, _).
test(a_stated_standards_key_is_not_named, fail) :-
    procedure_of(point_one_full_standards, indeterminate(_)).
test(a_stated_substantial_modification_is_not_referred, fail) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, needs_legal_review(_, _), _).
test(an_unsure_change_that_does_not_matter_is_not_referred, fail) :-
    subject_case(point_three_substantial_unsure, Profile, AssessmentDate),
    conformity_assessment_procedure(Profile, AssessmentDate, needs_legal_review(_, _), _).

cp_test_names([the_status_table_has_a_near_miss_atom, the_baseline_profile_yields_exactly_one_status, the_day_before_is_not_applicable, a_section_a_product_on_its_day_follows_its_legislation, a_concluded_system_is_not_high_risk, point_three_follows_internal_control, partial_standards_follow_annex_vii, full_standards_give_the_choice, a_restricted_standard_gives_annex_vii_for_the_restricted_part, the_option_with_full_standards, the_option_without_full_standards_needs_a_third_party, an_annex_x_component_before_31_december_2030, a_public_authority_legacy_system_before_2_august_2030, a_legacy_system_without_changes_is_outside, law_enforcement_gets_the_market_surveillance_authority, a_private_point_one_system_chooses, point_three_is_outside_article_43_1, a_substantial_modification_needs_a_new_assessment, a_minor_change_needs_no_new_assessment, a_pre_determined_change_needs_no_new_assessment, a_first_assessment_has_no_previous_one, other_legislation_gives_a_single_declaration, no_other_legislation_gives_the_declaration_under_this_regulation, the_declaration_is_kept_on_the_end_day, the_keeping_period_ends_the_next_day, a_digital_system_needs_the_digital_marking, a_physical_system_needs_no_digital_marking, a_point_two_provider_registers_at_national_level, a_point_one_provider_registers_in_the_secure_section, a_public_deployer_registers, a_private_deployer_has_no_registration_duty, a_deployer_of_a_point_two_system_has_no_registration_duty, an_absent_standards_key_is_named, an_unsure_substantial_modification_is_referred]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, the_application_day_itself_is_not_not_applicable, a_section_a_product_the_day_before_does_not, an_unconcluded_system_is_not_not_high_risk, point_one_does_not_follow_internal_control_alone, full_standards_do_not_force_annex_vii, an_unrestricted_standard_does_not, the_option_without_full_standards_is_not_available, an_annex_x_component_on_31_december_2030_is_answered_as_any_other, a_public_authority_legacy_system_on_2_august_2030, a_legacy_system_with_changes_is_inside, a_private_point_one_system_does_not, a_minor_change_does_not, an_assessed_system_has_a_previous_one, no_other_legislation_gives_no_single_declaration, the_end_day_is_not_after_the_end_day, a_physical_system_does_not, a_digital_system_is_not_marked_on_the_system, a_point_three_provider_does_not, a_point_three_provider_does_not_use_the_secure_section, a_private_deployer_does_not, a_stated_standards_key_is_not_named, a_stated_substantial_modification_is_not_referred, an_unsure_change_that_does_not_matter_is_not_referred]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
