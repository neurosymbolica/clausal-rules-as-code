% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_profile_for/2]).

result_of(Subject, Result) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    compensation_liability(Profile, Result, _Basis, _Citations).

test(every_final_atom_named_below_is_a_verdict_atom) :-
    gdpr_compensation_and_liability_status_values(StatusValues),
    member(liable_for_damage, StatusValues),
    member(exempt_from_liability, StatusValues),
    member(not_liable_for_damage, StatusValues),
    member(right_not_established, StatusValues).
test(liable_controller_is_liable) :-
    result_of(liable_controller, liable_for_damage).
test(exempt_controller_is_exempt) :-
    result_of(exempt_controller, exempt_from_liability).
test(not_liable_processor_is_not_liable) :-
    result_of(not_liable_processor, not_liable_for_damage).
test(breaching_processor_is_liable) :-
    result_of(liable_processor_breach, liable_for_damage).
test(uninvolved_controller_is_not_liable) :-
    result_of(not_liable_uninvolved_controller, not_liable_for_damage).
test(no_damage_is_right_not_established) :-
    result_of(right_not_established_no_damage, right_not_established).
test(no_infringement_is_right_not_established) :-
    result_of(right_not_established_no_infringement, right_not_established).
test(no_causation_is_right_not_established) :-
    result_of(right_not_established_no_causation, right_not_established).
test(outside_caller_with_a_false_condition_is_right_not_established) :-
    result_of(right_not_established_outside_caller, right_not_established).
test(absent_causation_is_named) :-
    result_of(indeterminate_judgement_absent, indeterminate([damage_resulted_from_the_infringement])).
test(absent_role_is_named) :-
    result_of(indeterminate_role_absent, indeterminate([party_role])).
test(absent_involvement_is_named) :-
    result_of(indeterminate_involvement_absent, indeterminate([involved_in_the_processing])).
test(absent_second_processor_ground_is_named) :-
    result_of(indeterminate_processor_ground_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions])).
test(one_true_processor_ground_is_liable) :-
    result_of(liable_processor_instructions, liable_for_damage).
test(outside_with_unsure_is_referred) :-
    result_of(referred_outside_unsure, needs_legal_review(open_textured(infringement_of_the_regulation_occurred, cite(eu_reg_2016_679_art_82_1)), _Context)).
test(absent_statement_is_a_cross_reference) :-
    result_of(referred_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), _Context)).
test(outside_caller_without_statement_is_not_referred) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(inside_with_unsure_is_referred) :-
    result_of(referred_inside_unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), _Context)).
test(unknown_key_is_refused) :-
    result_of(input_problem_unknown_key, input_problems([unknown_key(colour)])).
test(wrong_type_is_refused) :-
    result_of(input_problem_wrong_type, input_problems([wrong_type(involved_in_the_processing)])).
test(duplicate_key_is_refused) :-
    result_of(input_problem_duplicate_key, input_problems([duplicate_key(damage_suffered)])).
test(the_baseline_status_is_liable) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    gdpr_compensation_and_liability_status(Profile, liable_for_damage).

test(exempt_controller_is_not_liable_for_damage, fail) :-
    result_of(exempt_controller, liable_for_damage).
test(liable_controller_is_not_exempt, fail) :-
    result_of(liable_controller, exempt_from_liability).
test(breaching_processor_is_not_outside, fail) :-
    result_of(liable_processor_breach, not_liable_for_damage).
test(involved_controller_is_not_outside, fail) :-
    result_of(liable_controller, not_liable_for_damage).
test(all_conditions_true_is_not_right_not_established, fail) :-
    result_of(liable_controller, right_not_established).
test(outside_caller_with_a_false_condition_is_not_not_liable, fail) :-
    result_of(right_not_established_outside_caller, not_liable_for_damage).
test(outside_caller_with_true_conditions_is_not_right_not_established, fail) :-
    result_of(not_liable_uninvolved_controller, right_not_established).
test(present_causation_is_not_indeterminate, fail) :-
    result_of(liable_controller, indeterminate(_)).
test(one_true_processor_ground_needs_not_the_other, fail) :-
    result_of(liable_processor_instructions, indeterminate(_)).
test(outside_with_unsure_is_not_not_liable, fail) :-
    result_of(referred_outside_unsure, not_liable_for_damage).
test(outside_with_all_true_is_not_referred, fail) :-
    result_of(not_liable_uninvolved_controller, needs_legal_review(_, _)).
test(absent_statement_is_not_liable_for_damage, fail) :-
    result_of(referred_statement_absent, liable_for_damage).
test(present_statement_is_not_a_cross_reference, fail) :-
    result_of(liable_controller, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(inside_with_unsure_is_not_liable_for_damage, fail) :-
    result_of(referred_inside_unsure, liable_for_damage).
test(inside_with_all_true_is_not_open_textured, fail) :-
    result_of(liable_controller, needs_legal_review(open_textured(_, _), _)).
test(unknown_key_is_not_liable_for_damage, fail) :-
    result_of(input_problem_unknown_key, liable_for_damage).
test(a_well_formed_profile_is_not_refused, fail) :-
    result_of(liable_controller, input_problems(_)).
test(the_baseline_status_is_not_not_liable, fail) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    gdpr_compensation_and_liability_status(Profile, not_liable_for_damage).

cp_test_names([every_final_atom_named_below_is_a_verdict_atom, liable_controller_is_liable, exempt_controller_is_exempt, not_liable_processor_is_not_liable, breaching_processor_is_liable, uninvolved_controller_is_not_liable, no_damage_is_right_not_established, no_infringement_is_right_not_established, no_causation_is_right_not_established, outside_caller_with_a_false_condition_is_right_not_established, absent_causation_is_named, absent_role_is_named, absent_involvement_is_named, absent_second_processor_ground_is_named, one_true_processor_ground_is_liable, outside_with_unsure_is_referred, absent_statement_is_a_cross_reference, outside_caller_without_statement_is_not_referred, inside_with_unsure_is_referred, unknown_key_is_refused, wrong_type_is_refused, duplicate_key_is_refused, the_baseline_status_is_liable]).
cp_test_fail_names([exempt_controller_is_not_liable_for_damage, liable_controller_is_not_exempt, breaching_processor_is_not_outside, involved_controller_is_not_outside, all_conditions_true_is_not_right_not_established, outside_caller_with_a_false_condition_is_not_not_liable, outside_caller_with_true_conditions_is_not_right_not_established, present_causation_is_not_indeterminate, one_true_processor_ground_needs_not_the_other, outside_with_unsure_is_not_not_liable, outside_with_all_true_is_not_referred, absent_statement_is_not_liable_for_damage, present_statement_is_not_a_cross_reference, inside_with_unsure_is_not_liable_for_damage, inside_with_all_true_is_not_open_textured, unknown_key_is_not_liable_for_damage, a_well_formed_profile_is_not_refused, the_baseline_status_is_not_not_liable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
