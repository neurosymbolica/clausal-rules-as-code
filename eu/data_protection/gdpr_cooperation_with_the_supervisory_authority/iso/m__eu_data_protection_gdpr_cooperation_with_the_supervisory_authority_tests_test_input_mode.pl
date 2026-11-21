% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, gdpr_cooperation_with_the_supervisory_authority_status/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

single_problem_list(Profile, Expected) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems), AllProblems),
    AllProblems == [Expected].

test(met_holds_with_the_verdict_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, cooperation_met).
test(met_answer_with_every_argument_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    cooperation_duty(Profile, cooperation_met, [outside_fact(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))], [cite(eu_reg_2016_679_art_31)]).
test(not_met_holds_with_the_verdict_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, cooperation_not_met).
test(no_request_holds_with_not_required_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request, Profile),
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(outside_tasks_holds_with_not_required_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_outside_tasks, Profile),
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(not_bound_holds_with_not_required_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(not_bound, Profile),
    cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(missing_role_holds_with_indeterminate_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(role_unknown, Profile),
    cooperation_duty(Profile, indeterminate([acts_as_controller]), [], []).
test(absent_statement_holds_with_the_referral_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(statement_missing_true, Profile),
    cooperation_duty(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]), [], []).
test(unsure_judgement_holds_with_the_referral_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(judgement_unsure, Profile),
    cooperation_duty(Profile, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), [], []).
test(input_problems_hold_with_the_problems_bound) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(duplicate_and_unknown, Profile),
    cooperation_duty(Profile, input_problems([duplicate_key(acts_as_controller), unknown_key(colour)]), [], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    single_problem_list(_, [wrong_type(profile)]).
test(a_non_list_profile_gets_input_problems_from_the_query) :-
    cooperation_duty(not_a_profile, input_problems([wrong_type(profile)]), [], []).
test(an_atom_is_not_an_attribute_list) :-
    single_problem_list(profile, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    single_problem_list([attribute(acts_as_controller, true)|_], [wrong_type(profile)]).
test(an_unbound_element_is_not_an_attribute) :-
    single_problem_list([_], [wrong_type(profile)]).
test(a_stray_element_makes_the_whole_profile_wrong) :-
    single_problem_list([attribute(acts_as_controller, true), attribute(colour, blue), stray], [wrong_type(profile)]).
test(the_empty_profile_has_no_problem) :-
    single_problem_list([], []).
test(a_number_key_is_an_unknown_key) :-
    single_problem_list([attribute(7, true)], [unknown_key(7)]).
test(a_compound_key_is_an_unknown_key_as_given) :-
    single_problem_list([attribute(colour(blue), true)], [unknown_key(colour(blue))]).
test(a_repeated_unknown_key_is_named_once) :-
    single_problem_list([attribute(colour, blue), attribute(colour, red)], [unknown_key(colour)]).
test(an_unbound_value_is_a_wrong_type) :-
    single_problem_list([attribute(acts_as_controller, _)], [wrong_type(acts_as_controller)]).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    single_problem_list([attribute(authority_request_made, unsure)], [wrong_type(authority_request_made)]).
test(a_judgement_outside_its_three_values_is_a_wrong_type) :-
    single_problem_list([attribute(request_is_in_performance_of_authority_tasks, maybe)], [wrong_type(request_is_in_performance_of_authority_tasks)]).
test(an_unsure_judgement_is_well_formed) :-
    single_problem_list([attribute(request_is_in_performance_of_authority_tasks, unsure)], []).
test(a_bare_true_outside_fact_is_a_wrong_type) :-
    single_problem_list([attribute(cooperation_given, true)], [wrong_type(cooperation_given)]).
test(an_attestation_with_three_arguments_is_a_wrong_type) :-
    single_problem_list([attribute(cooperation_given, attested(true, attestation(host, at_time, reason)))], [wrong_type(cooperation_given)]).
test(an_attested_unsure_is_a_wrong_type) :-
    single_problem_list([attribute(cooperation_given, attested(unsure, attestation(host, at_time, reason, none)))], [wrong_type(cooperation_given)]).
test(an_attestation_holding_an_unbound_argument_is_a_wrong_type) :-
    single_problem_list([attribute(cooperation_given, attested(true, attestation(_, at_time, reason, none)))], [wrong_type(cooperation_given)]).
test(attestation_arguments_are_not_inspected) :-
    single_problem_list([attribute(cooperation_given, attested(false, attestation(1, [x], reason(any), url(address, retrieved))))], []).
test(a_duplicate_key_is_never_also_a_wrong_type) :-
    single_problem_list([attribute(acts_as_processor, true), attribute(acts_as_processor, unsure)], [duplicate_key(acts_as_processor)]).
test(problems_follow_the_contract_order_then_unknown_keys) :-
    single_problem_list([attribute(colour, blue), attribute(cooperation_given, yes), attribute(acts_as_controller, maybe), attribute(authority_request_made, true), attribute(authority_request_made, true)], [wrong_type(acts_as_controller), duplicate_key(authority_request_made), wrong_type(cooperation_given), unknown_key(colour)]).

test(met_profile_rejects_a_bound_not_met, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, cooperation_not_met).
test(not_met_profile_rejects_a_bound_met, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, cooperation_met).
test(not_bound_rejects_a_bound_met, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(not_bound, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, cooperation_met).
test(missing_role_rejects_a_second_missing_key, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(two_keys_missing, Profile),
    cooperation_duty(Profile, indeterminate([authority_request_made, request_is_in_performance_of_authority_tasks]), _, _).

cp_test_names([met_holds_with_the_verdict_bound, met_answer_with_every_argument_bound, not_met_holds_with_the_verdict_bound, no_request_holds_with_not_required_bound, outside_tasks_holds_with_not_required_bound, not_bound_holds_with_not_required_bound, missing_role_holds_with_indeterminate_bound, absent_statement_holds_with_the_referral_bound, unsure_judgement_holds_with_the_referral_bound, input_problems_hold_with_the_problems_bound, an_unbound_profile_is_not_an_attribute_list, a_non_list_profile_gets_input_problems_from_the_query, an_atom_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute, a_stray_element_makes_the_whole_profile_wrong, the_empty_profile_has_no_problem, a_number_key_is_an_unknown_key, a_compound_key_is_an_unknown_key_as_given, a_repeated_unknown_key_is_named_once, an_unbound_value_is_a_wrong_type, a_crisp_key_given_unsure_is_a_wrong_type, a_judgement_outside_its_three_values_is_a_wrong_type, an_unsure_judgement_is_well_formed, a_bare_true_outside_fact_is_a_wrong_type, an_attestation_with_three_arguments_is_a_wrong_type, an_attested_unsure_is_a_wrong_type, an_attestation_holding_an_unbound_argument_is_a_wrong_type, attestation_arguments_are_not_inspected, a_duplicate_key_is_never_also_a_wrong_type, problems_follow_the_contract_order_then_unknown_keys]).
cp_test_fail_names([met_profile_rejects_a_bound_not_met, not_met_profile_rejects_a_bound_met, not_bound_rejects_a_bound_met, missing_role_rejects_a_second_missing_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
