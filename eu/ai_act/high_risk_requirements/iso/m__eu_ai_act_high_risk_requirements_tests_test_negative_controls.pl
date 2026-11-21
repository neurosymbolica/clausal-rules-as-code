% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_high_risk_requirements_high_risk_requirements, [high_risk_requirement_status/5]).
:- use_module(m__eu_ai_act_high_risk_requirements_fixtures, [high_risk_requirements_profile_for/2, high_risk_requirements_assess/2]).

verdict_of(Subject, Result) :-
    high_risk_requirements_assess(Subject, high_risk_requirements_verdict(Result, _)).

test(annex_iii_route_applies_on_its_date) :-
    verdict_of(annex_iii_on_application_date, requirement_applies).
test(annex_iii_route_waits_the_day_before) :-
    verdict_of(annex_iii_day_before_application_date, not_applicable_on_date).
test(annex_i_route_applies_on_its_date) :-
    verdict_of(annex_i_only_on_application_date, requirement_applies).
test(annex_i_route_waits_the_day_before) :-
    verdict_of(annex_i_only_day_before_application_date, not_applicable_on_date).
test(dual_route_applies_on_the_annex_iii_date) :-
    verdict_of(dual_route_on_annex_iii_application_date, requirement_applies).
test(not_high_risk_route) :-
    verdict_of(not_a_high_risk_system, not_a_high_risk_ai_system).
test(annex_i_system_has_the_requirement) :-
    verdict_of(annex_i_system_after_application_date, requirement_applies).
test(logging_minimum_applies_to_a_point_one_a_system) :-
    verdict_of(point_one_a_system_logging, requirement_applies).
test(logging_minimum_does_not_apply_to_another_system) :-
    verdict_of(other_annex_iii_system_logging, requirement_does_not_apply).
test(verification_exception_with_both_conditions) :-
    verdict_of(verification_exception_both_conditions, requirement_does_not_apply).
test(verification_with_purposes_only_applies) :-
    verdict_of(verification_purposes_without_law_view, requirement_applies).
test(annex_x_component_before_the_deadline) :-
    verdict_of(annex_x_component_day_before_deadline, compliance_required_by_31_december_2030).
test(annex_x_component_on_the_deadline_applies) :-
    verdict_of(annex_x_component_on_deadline, requirement_applies).
test(existing_system_without_changes_is_not_covered) :-
    verdict_of(existing_system_without_changes, existing_system_without_significant_changes_not_covered).
test(existing_system_with_changes_applies) :-
    verdict_of(existing_system_with_changes, requirement_applies).
test(public_authority_system_before_the_deadline) :-
    verdict_of(public_authority_system_day_before_deadline, compliance_required_by_2_august_2030).
test(public_authority_system_on_the_deadline_applies) :-
    verdict_of(public_authority_system_on_deadline, requirement_applies).
test(without_training_only_testing_data_sets) :-
    verdict_of(system_without_training_data, requirement_applies_to_testing_data_sets_only).
test(with_training_all_data_sets) :-
    verdict_of(system_with_training_data, requirement_applies).
test(small_enterprise_may_use_the_simplified_form) :-
    verdict_of(small_enterprise_provider_documentation, requirement_applies_and_the_simplified_form_may_be_used).
test(large_provider_documentation_applies) :-
    verdict_of(large_provider_documentation, requirement_applies).
test(photographs_not_required_for_a_non_component) :-
    verdict_of(component_photographs_not_a_component, element_not_required).
test(photographs_required_for_a_component) :-
    verdict_of(component_photographs_component, element_required).
test(product_information_not_required_when_unrelated) :-
    verdict_of(annex_i_section_a_information_unrelated, element_not_required).
test(product_information_required_when_related) :-
    verdict_of(annex_i_section_a_information_related, element_required).
test(pre_determined_changes_not_required_when_absent) :-
    verdict_of(pre_determined_changes_absent, element_not_required).
test(pre_determined_changes_required_when_present) :-
    verdict_of(pre_determined_changes_present, element_required).
test(log_mechanisms_are_subject_to_an_open_condition) :-
    verdict_of(log_mechanisms_open_element, element_required_subject_to_an_open_condition).
test(instructions_for_use_are_required) :-
    verdict_of(instructions_for_use_element, element_required).
test(missing_classification_is_named) :-
    verdict_of(missing_annex_iii_classification, indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii])).
test(unsure_design_change_is_referred) :-
    verdict_of(unsure_design_changes, needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), _)).
test(a_malformed_value_is_an_input_problem) :-
    verdict_of(malformed_classification_value, input_problems([wrong_type(system_is_a_high_risk_ai_system_listed_in_annex_iii)])).

test(annex_iii_route_does_not_apply_the_day_before, fail) :-
    verdict_of(annex_iii_day_before_application_date, requirement_applies).
test(annex_iii_route_is_applicable_on_its_date, fail) :-
    verdict_of(annex_iii_on_application_date, not_applicable_on_date).
test(annex_i_route_does_not_apply_the_day_before, fail) :-
    verdict_of(annex_i_only_day_before_application_date, requirement_applies).
test(annex_i_only_does_not_apply_on_the_annex_iii_date, fail) :-
    high_risk_requirements_profile_for(annex_i_only_on_application_date, Profile),
    high_risk_requirement_status(Profile, human_oversight, date(2027, 12, 2), requirement_applies, _).
test(annex_i_system_is_high_risk, fail) :-
    verdict_of(annex_i_system_after_application_date, not_a_high_risk_ai_system).
test(logging_minimum_is_not_applied_to_another_system, fail) :-
    verdict_of(other_annex_iii_system_logging, requirement_applies).
test(logging_minimum_point_one_a_system_is_not_exempt, fail) :-
    verdict_of(point_one_a_system_logging, requirement_does_not_apply).
test(verification_purposes_only_is_not_exempt, fail) :-
    verdict_of(verification_purposes_without_law_view, requirement_does_not_apply).
test(annex_x_component_on_the_deadline_has_no_more_time, fail) :-
    verdict_of(annex_x_component_on_deadline, compliance_required_by_31_december_2030).
test(existing_system_with_changes_is_covered, fail) :-
    verdict_of(existing_system_with_changes, existing_system_without_significant_changes_not_covered).
test(public_authority_system_on_the_deadline_has_no_more_time, fail) :-
    verdict_of(public_authority_system_on_deadline, compliance_required_by_2_august_2030).
test(with_training_not_only_testing_data_sets, fail) :-
    verdict_of(system_with_training_data, requirement_applies_to_testing_data_sets_only).
test(large_provider_has_no_simplified_form, fail) :-
    verdict_of(large_provider_documentation, requirement_applies_and_the_simplified_form_may_be_used).
test(photographs_are_required_for_a_component, fail) :-
    verdict_of(component_photographs_component, element_not_required).
test(product_information_is_required_when_related, fail) :-
    verdict_of(annex_i_section_a_information_related, element_not_required).
test(pre_determined_changes_are_required_when_present, fail) :-
    verdict_of(pre_determined_changes_present, element_not_required).
test(instructions_for_use_have_no_open_condition, fail) :-
    verdict_of(instructions_for_use_element, element_required_subject_to_an_open_condition).
test(a_complete_profile_misses_no_key, fail) :-
    verdict_of(annex_iii_on_application_date, indeterminate(_)).
test(a_known_design_change_is_not_referred, fail) :-
    verdict_of(existing_system_without_changes, needs_legal_review(_, _)).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    verdict_of(annex_iii_on_application_date, input_problems(_)).

cp_test_names([annex_iii_route_applies_on_its_date, annex_iii_route_waits_the_day_before, annex_i_route_applies_on_its_date, annex_i_route_waits_the_day_before, dual_route_applies_on_the_annex_iii_date, not_high_risk_route, annex_i_system_has_the_requirement, logging_minimum_applies_to_a_point_one_a_system, logging_minimum_does_not_apply_to_another_system, verification_exception_with_both_conditions, verification_with_purposes_only_applies, annex_x_component_before_the_deadline, annex_x_component_on_the_deadline_applies, existing_system_without_changes_is_not_covered, existing_system_with_changes_applies, public_authority_system_before_the_deadline, public_authority_system_on_the_deadline_applies, without_training_only_testing_data_sets, with_training_all_data_sets, small_enterprise_may_use_the_simplified_form, large_provider_documentation_applies, photographs_not_required_for_a_non_component, photographs_required_for_a_component, product_information_not_required_when_unrelated, product_information_required_when_related, pre_determined_changes_not_required_when_absent, pre_determined_changes_required_when_present, log_mechanisms_are_subject_to_an_open_condition, instructions_for_use_are_required, missing_classification_is_named, unsure_design_change_is_referred, a_malformed_value_is_an_input_problem]).
cp_test_fail_names([annex_iii_route_does_not_apply_the_day_before, annex_iii_route_is_applicable_on_its_date, annex_i_route_does_not_apply_the_day_before, annex_i_only_does_not_apply_on_the_annex_iii_date, annex_i_system_is_high_risk, logging_minimum_is_not_applied_to_another_system, logging_minimum_point_one_a_system_is_not_exempt, verification_purposes_only_is_not_exempt, annex_x_component_on_the_deadline_has_no_more_time, existing_system_with_changes_is_covered, public_authority_system_on_the_deadline_has_no_more_time, with_training_not_only_testing_data_sets, large_provider_has_no_simplified_form, photographs_are_required_for_a_component, product_information_is_required_when_related, pre_determined_changes_are_required_when_present, instructions_for_use_have_no_open_condition, a_complete_profile_misses_no_key, a_known_design_change_is_not_referred, a_well_formed_profile_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
