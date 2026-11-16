% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_public_task, Profile),
    request_exception_status(Profile, art20_3_public_task).
test(decision_bound_must_comply) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_decision(Profile, must_comply).
test(decision_bound_need_not_comply) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_not_automated, Profile),
    request_decision(Profile, need_not_comply).
test(decision_bound_suspended) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_identity_unconfirmed, Profile),
    request_decision(Profile, suspended(art12_6_identity_not_confirmed)).
test(decision_bound_indeterminate) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(no_request_type, Profile),
    request_decision(Profile, indeterminate([request_type])).
test(decision_bound_unknown_key) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(unknown_key_problem, Profile),
    request_decision(Profile, input_problems([unknown_key(not_a_contract_key)])).
test(decision_bound_wrong_type) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(wrong_type_problem, Profile),
    request_decision(Profile, input_problems([wrong_type(extension_claimed)])).
test(decision_bound_duplicate_key) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(duplicate_key_problem, Profile),
    request_decision(Profile, input_problems([duplicate_key(processing_carried_out_by_automated_means)])).
test(exception_bound_none_for_input_problems) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(duplicate_key_problem, Profile),
    request_exception(Profile, none).
test(exception_bound_none_for_suspension) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_identity_unconfirmed, Profile),
    request_exception(Profile, none).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_public_task, Profile),
    request_exception_status(Profile, art20_4_rights_of_others).
test(decision_bound_wrong_is_rejected, fail) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_decision(Profile, need_not_comply).

cp_test_names([status_holds_with_the_verdict_bound, decision_bound_must_comply, decision_bound_need_not_comply, decision_bound_suspended, decision_bound_indeterminate, decision_bound_unknown_key, decision_bound_wrong_type, decision_bound_duplicate_key, exception_bound_none_for_input_problems, exception_bound_none_for_suspension]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, decision_bound_wrong_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
