% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, gdpr_cooperation_with_the_supervisory_authority_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

subject_result(Subject, Result) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    cooperation_duty(Profile, Result, _, _).

test(each_final_atom_is_in_the_status_table) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    member(cooperation_not_required, StatusValues),
    member(cooperation_met, StatusValues),
    member(cooperation_not_met, StatusValues).
test(step_seven_positive_met) :-
    subject_result(controller_cooperated, cooperation_met).
test(step_eight_positive_not_met) :-
    subject_result(controller_refused, cooperation_not_met).
test(step_one_positive_no_request) :-
    subject_result(no_request, cooperation_not_required).
test(step_one_decides_before_absent_roles) :-
    subject_result(no_request_roles_absent, cooperation_not_required).
test(step_two_positive_outside_tasks) :-
    subject_result(request_outside_tasks, cooperation_not_required).
test(step_two_control_inside_tasks_is_met) :-
    subject_result(request_inside_tasks, cooperation_met).
test(step_three_positive_not_bound) :-
    subject_result(not_bound, cooperation_not_required).
test(step_three_control_representative_is_met) :-
    subject_result(representative_cooperated, cooperation_met).
test(step_four_positive_missing_role) :-
    subject_result(role_unknown, indeterminate([acts_as_controller])).
test(step_four_control_stated_false_is_not_required) :-
    subject_result(role_stated_false, cooperation_not_required).
test(step_four_bound_caller_names_the_request_key) :-
    subject_result(two_keys_missing, indeterminate([authority_request_made])).
test(step_five_positive_absent_statement) :-
    subject_result(statement_missing_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])])).
test(step_five_refers_before_the_unsure_judgement) :-
    subject_result(statement_missing_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])])).
test(step_six_positive_unsure_judgement) :-
    subject_result(judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
test(step_zero_positive_wrong_types) :-
    subject_result(wrong_types, input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)])).
test(step_zero_positive_duplicate_and_unknown) :-
    subject_result(duplicate_and_unknown, input_problems([duplicate_key(acts_as_controller), unknown_key(colour)])).

test(step_seven_control_refused_is_not_met, fail) :-
    subject_result(controller_refused, cooperation_met).
test(step_eight_control_cooperated_is_not_not_met, fail) :-
    subject_result(controller_cooperated, cooperation_not_met).
test(step_one_control_with_request_is_required, fail) :-
    subject_result(controller_cooperated, cooperation_not_required).
test(step_one_absent_roles_are_not_named, fail) :-
    subject_result(no_request_roles_absent, indeterminate(_)).
test(step_two_control_inside_tasks_is_required, fail) :-
    subject_result(request_inside_tasks, cooperation_not_required).
test(step_three_control_representative_is_bound, fail) :-
    subject_result(representative_cooperated, cooperation_not_required).
test(step_four_control_stated_false_is_not_indeterminate, fail) :-
    subject_result(role_stated_false, indeterminate(_)).
test(step_five_control_present_statement_does_not_refer, fail) :-
    subject_result(controller_cooperated, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(step_five_absent_statement_is_not_open_textured, fail) :-
    subject_result(statement_missing_unsure, needs_legal_review(open_textured(_, _), _)).
test(step_six_control_true_judgement_does_not_refer, fail) :-
    subject_result(controller_cooperated, needs_legal_review(open_textured(_, _), _)).
test(step_six_unsure_judgement_is_not_met, fail) :-
    subject_result(judgement_unsure, cooperation_met).
test(step_zero_control_well_formed_has_no_problem, fail) :-
    subject_result(controller_cooperated, input_problems(_)).
test(step_zero_problem_profile_gets_no_final_answer, fail) :-
    subject_result(wrong_types, cooperation_met).

cp_test_names([each_final_atom_is_in_the_status_table, step_seven_positive_met, step_eight_positive_not_met, step_one_positive_no_request, step_one_decides_before_absent_roles, step_two_positive_outside_tasks, step_two_control_inside_tasks_is_met, step_three_positive_not_bound, step_three_control_representative_is_met, step_four_positive_missing_role, step_four_control_stated_false_is_not_required, step_four_bound_caller_names_the_request_key, step_five_positive_absent_statement, step_five_refers_before_the_unsure_judgement, step_six_positive_unsure_judgement, step_zero_positive_wrong_types, step_zero_positive_duplicate_and_unknown]).
cp_test_fail_names([step_seven_control_refused_is_not_met, step_eight_control_cooperated_is_not_not_met, step_one_control_with_request_is_required, step_one_absent_roles_are_not_named, step_two_control_inside_tasks_is_required, step_three_control_representative_is_bound, step_four_control_stated_false_is_not_indeterminate, step_five_control_present_statement_does_not_refer, step_five_absent_statement_is_not_open_textured, step_six_control_true_judgement_does_not_refer, step_six_unsure_judgement_is_not_met, step_zero_control_well_formed_has_no_problem, step_zero_problem_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
