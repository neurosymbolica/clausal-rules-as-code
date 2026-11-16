% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_profile_for/2]).

subject_status(Subject, Status) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    gdpr_compensation_and_liability_status(Profile, Status).

test(the_four_verdict_atoms_are_real) :-
    gdpr_compensation_and_liability_status_values(StatusValues),
    member(liable_for_damage, StatusValues),
    member(exempt_from_liability, StatusValues),
    member(not_liable_for_damage, StatusValues),
    member(right_not_established, StatusValues).
test(controller_liable_is_liable) :-
    subject_status(controller_liable, liable_for_damage).
test(controller_exempt_is_exempt) :-
    subject_status(controller_exempt, exempt_from_liability).
test(controller_not_involved_is_not_liable) :-
    subject_status(controller_not_involved, not_liable_for_damage).
test(processor_with_neither_breach_is_not_liable) :-
    subject_status(processor_outside_both_false, not_liable_for_damage).
test(processor_acting_outside_instructions_is_liable) :-
    subject_status(processor_liable_by_instructions, liable_for_damage).
test(processor_breaching_obligations_is_liable) :-
    subject_status(processor_liable_by_breach, liable_for_damage).
test(damage_false_refutes_the_right) :-
    subject_status(damage_false_role_absent, right_not_established).
test(infringement_false_refutes_the_right_for_an_outside_caller) :-
    subject_status(infringement_false_outside_caller, right_not_established).
test(causation_false_refutes_the_right) :-
    subject_status(causation_false, right_not_established).
test(an_absent_judgement_is_named) :-
    subject_status(judgement_absent, indeterminate([damage_resulted_from_the_infringement])).
test(an_absent_role_is_named) :-
    subject_status(role_absent, indeterminate([party_role])).
test(a_controller_needs_its_involvement) :-
    subject_status(controller_involvement_absent, indeterminate([involved_in_the_processing])).
test(a_processor_needs_the_second_key_after_a_false_first) :-
    subject_status(processor_second_key_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions])).
test(an_outside_caller_with_an_unsure_judgement_is_referred) :-
    subject_status(outside_caller_unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), _)).
test(an_absent_statement_is_referred) :-
    subject_status(controller_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), _)).
test(an_absent_statement_refers_before_an_unsure_judgement) :-
    subject_status(inside_statement_absent_with_unsure, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(an_inside_unsure_judgement_is_referred) :-
    subject_status(inside_unsure, needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(eu_reg_2016_679_art_82_1)), _)).
test(an_unknown_key_is_an_input_problem) :-
    subject_status(input_unknown_key, input_problems([unknown_key(colour)])).
test(the_same_profile_without_the_unknown_key_names_the_next_judgement) :-
    gdpr_compensation_and_liability_status([attribute(damage_suffered, true)], indeterminate([infringement_of_the_regulation_occurred])).
test(a_crisp_key_given_unsure_is_an_input_problem) :-
    subject_status(input_wrong_type_crisp_unsure, input_problems([wrong_type(involved_in_the_processing)])).

test(controller_exempt_is_not_liable, fail) :-
    subject_status(controller_exempt, liable_for_damage).
test(controller_liable_is_not_exempt, fail) :-
    subject_status(controller_liable, exempt_from_liability).
test(an_involved_controller_is_not_outside, fail) :-
    subject_status(controller_liable, not_liable_for_damage).
test(processor_with_one_breach_is_not_outside, fail) :-
    subject_status(processor_liable_by_instructions, not_liable_for_damage).
test(processor_with_neither_breach_is_not_liable_for_damage, fail) :-
    subject_status(processor_outside_both_false, liable_for_damage).
test(damage_true_does_not_refute_the_right, fail) :-
    subject_status(judgement_absent, right_not_established).
test(infringement_true_outside_caller_is_not_refuted, fail) :-
    subject_status(controller_not_involved, right_not_established).
test(causation_true_is_not_refuted, fail) :-
    subject_status(controller_liable, right_not_established).
test(a_false_judgement_is_not_indeterminate, fail) :-
    subject_status(damage_false_role_absent, indeterminate(_)).
test(a_complete_controller_profile_is_not_indeterminate, fail) :-
    subject_status(controller_statement_absent, indeterminate(_)).
test(a_controller_never_needs_the_processor_keys, fail) :-
    subject_status(controller_involvement_absent, indeterminate([processor_breached_obligations_directed_to_processors])).
test(a_processor_never_needs_the_involvement_key, fail) :-
    subject_status(processor_keys_absent, indeterminate([involved_in_the_processing])).
test(an_outside_caller_with_true_judgements_is_not_referred, fail) :-
    subject_status(controller_not_involved, needs_legal_review(_, _)).
test(an_outside_caller_never_refers_on_the_statement, fail) :-
    subject_status(outside_caller_unsure, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(a_present_statement_is_not_referred, fail) :-
    subject_status(controller_liable, needs_legal_review(_, _)).
test(an_absent_statement_is_not_referred_as_open_textured, fail) :-
    subject_status(inside_statement_absent_with_unsure, needs_legal_review(open_textured(_, _), _)).
test(an_inside_unsure_judgement_is_not_liable, fail) :-
    subject_status(inside_unsure, liable_for_damage).
test(the_same_profile_without_the_unknown_key_has_no_problem, fail) :-
    gdpr_compensation_and_liability_status([attribute(damage_suffered, true)], input_problems(_)).

cp_test_names([the_four_verdict_atoms_are_real, controller_liable_is_liable, controller_exempt_is_exempt, controller_not_involved_is_not_liable, processor_with_neither_breach_is_not_liable, processor_acting_outside_instructions_is_liable, processor_breaching_obligations_is_liable, damage_false_refutes_the_right, infringement_false_refutes_the_right_for_an_outside_caller, causation_false_refutes_the_right, an_absent_judgement_is_named, an_absent_role_is_named, a_controller_needs_its_involvement, a_processor_needs_the_second_key_after_a_false_first, an_outside_caller_with_an_unsure_judgement_is_referred, an_absent_statement_is_referred, an_absent_statement_refers_before_an_unsure_judgement, an_inside_unsure_judgement_is_referred, an_unknown_key_is_an_input_problem, the_same_profile_without_the_unknown_key_names_the_next_judgement, a_crisp_key_given_unsure_is_an_input_problem]).
cp_test_fail_names([controller_exempt_is_not_liable, controller_liable_is_not_exempt, an_involved_controller_is_not_outside, processor_with_one_breach_is_not_outside, processor_with_neither_breach_is_not_liable_for_damage, damage_true_does_not_refute_the_right, infringement_true_outside_caller_is_not_refuted, causation_true_is_not_refuted, a_false_judgement_is_not_indeterminate, a_complete_controller_profile_is_not_indeterminate, a_controller_never_needs_the_processor_keys, a_processor_never_needs_the_involvement_key, an_outside_caller_with_true_judgements_is_not_referred, an_outside_caller_never_refers_on_the_statement, a_present_statement_is_not_referred, an_absent_statement_is_not_referred_as_open_textured, an_inside_unsure_judgement_is_not_liable, the_same_profile_without_the_unknown_key_has_no_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
