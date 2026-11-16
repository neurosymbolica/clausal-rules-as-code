% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, gdpr_cooperation_with_the_supervisory_authority_status/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

bound_status(Subject, Status) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status).

problems_once(Term, Problems) :-
    findall(Found, gdpr_cooperation_with_the_supervisory_authority_input_problems(Term, Found), [Problems]).

test(step_zero_bound) :-
    bound_status(wrong_type_role_key, input_problems([wrong_type(acts_as_controller)])).
test(step_one_bound) :-
    bound_status(no_request_made, cooperation_not_required).
test(step_two_bound) :-
    bound_status(request_outside_authority_tasks, cooperation_not_required).
test(step_three_bound) :-
    bound_status(caller_not_bound, cooperation_not_required).
test(step_four_bound) :-
    bound_status(processor_key_missing, indeterminate([acts_as_processor])).
test(step_five_bound) :-
    bound_status(cooperation_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])])).
test(step_six_bound) :-
    bound_status(tasks_judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
test(step_seven_bound) :-
    bound_status(request_made_and_cooperated, cooperation_met).
test(step_eight_bound) :-
    bound_status(cooperation_statement_attested_false, cooperation_not_met).
test(full_answer_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request_made, Profile),
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    problems_once(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    problems_once([attribute(acts_as_controller, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_element_is_not_an_attribute) :-
    problems_once([attribute(acts_as_controller, true), _], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_is_not_an_attribute) :-
    problems_once([acts_as_controller - true], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    problems_once(profile, Problems),
    Problems == [wrong_type(profile)].
test(the_empty_profile_has_no_problem) :-
    problems_once([], Problems),
    Problems == [].
test(an_unbound_value_is_wrong_type) :-
    problems_once([attribute(authority_request_made, _)], Problems),
    Problems == [wrong_type(authority_request_made)].
test(a_numeric_key_is_unknown) :-
    problems_once([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(a_compound_key_is_unknown_as_given) :-
    problems_once([attribute(key(seven), true)], Problems),
    Problems == [unknown_key(key(seven))].
test(a_duplicate_is_never_also_wrong_type) :-
    problems_once([attribute(acts_as_controller, true), attribute(acts_as_controller, unsure)], Problems),
    Problems == [duplicate_key(acts_as_controller)].
test(contract_problems_come_before_unknown_keys) :-
    problems_once([attribute(zeta, one), attribute(cooperation_given, true), attribute(acts_as_controller, unsure), attribute(zeta, two)], Problems),
    Problems == [wrong_type(acts_as_controller), wrong_type(cooperation_given), unknown_key(zeta)].
test(the_judgement_accepts_unsure) :-
    problems_once([attribute(request_is_in_performance_of_authority_tasks, unsure)], Problems),
    Problems == [].
test(a_crisp_key_refuses_unsure) :-
    problems_once([attribute(authority_request_made, unsure)], Problems),
    Problems == [wrong_type(authority_request_made)].
test(an_attestation_needs_four_arguments) :-
    problems_once([attribute(cooperation_given, attested(true, attestation(by, at, reason)))], Problems),
    Problems == [wrong_type(cooperation_given)].
test(a_non_list_profile_gets_input_problems) :-
    cooperation_duty(profile, input_problems([wrong_type(profile)]), [], []).

test(the_wrong_bound_status_is_rejected, fail) :-
    bound_status(request_made_and_cooperated, cooperation_not_met).
test(the_bare_indeterminate_atom_is_never_given, fail) :-
    bound_status(processor_key_missing, indeterminate).

cp_test_names([step_zero_bound, step_one_bound, step_two_bound, step_three_bound, step_four_bound, step_five_bound, step_six_bound, step_seven_bound, step_eight_bound, full_answer_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute, a_foreign_element_is_not_an_attribute, an_atom_is_not_a_profile, the_empty_profile_has_no_problem, an_unbound_value_is_wrong_type, a_numeric_key_is_unknown, a_compound_key_is_unknown_as_given, a_duplicate_is_never_also_wrong_type, contract_problems_come_before_unknown_keys, the_judgement_accepts_unsure, a_crisp_key_refuses_unsure, an_attestation_needs_four_arguments, a_non_list_profile_gets_input_problems]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, the_bare_indeterminate_atom_is_never_given]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
