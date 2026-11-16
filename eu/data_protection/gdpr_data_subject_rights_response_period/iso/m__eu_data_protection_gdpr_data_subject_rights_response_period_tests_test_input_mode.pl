% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [gdpr_data_subject_rights_response_period_status/2, applicable_response_period/2, response_deadline/3, request_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_profile_for/2]).

test(extended_status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    gdpr_data_subject_rights_response_period_status(Profile, extended_period).
test(first_period_holds_bound_for_no_claim) :-
    gdpr_data_subject_rights_response_period_profile_for(no_extension_claimed, Profile),
    applicable_response_period(Profile, first_period).
test(indeterminate_holds_bound) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_without_judgement, Profile),
    applicable_response_period(Profile, indeterminate([extension_necessary_for_complexity_and_number])).
test(referral_holds_bound) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, Profile),
    applicable_response_period(Profile, needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])).
test(deadline_holds_bound) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 30)).
test(duplicate_key_holds_bound) :-
    gdpr_data_subject_rights_response_period_profile_for(duplicate_claim_given, Profile),
    gdpr_data_subject_rights_response_period_input_problems(Profile, [duplicate_key(extension_claimed)]).
test(crisp_key_given_unsure_is_wrong_type) :-
    gdpr_data_subject_rights_response_period_profile_for(claim_given_unsure, Profile),
    gdpr_data_subject_rights_response_period_input_problems(Profile, [wrong_type(extension_claimed)]).
test(a_non_list_profile_is_wrong_type_profile) :-
    gdpr_data_subject_rights_response_period_profile_for(profile_not_a_list, Profile),
    gdpr_data_subject_rights_response_period_input_problems(Profile, [wrong_type(profile)]).
test(outside_facts_bound_for_an_input_problem) :-
    gdpr_data_subject_rights_response_period_profile_for(unknown_key_given, Profile),
    request_outside_facts(Profile, input_problems([unknown_key(colour)])).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    gdpr_data_subject_rights_response_period_status(Profile, first_period).
test(the_sunday_deadline_is_rejected, fail) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 29)).

cp_test_names([extended_status_holds_with_the_verdict_bound, first_period_holds_bound_for_no_claim, indeterminate_holds_bound, referral_holds_bound, deadline_holds_bound, duplicate_key_holds_bound, crisp_key_given_unsure_is_wrong_type, a_non_list_profile_is_wrong_type_profile, outside_facts_bound_for_an_input_problem]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, the_sunday_deadline_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
