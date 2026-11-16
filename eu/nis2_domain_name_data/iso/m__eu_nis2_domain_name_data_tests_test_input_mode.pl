% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, provider_duties/2, publication_duty/3, access_duty/3, access_reply_timeliness/3, nis2_domain_name_data_checklist/2]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2]).

test(registry_status_holds_with_the_verdict_bound) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_status(Profile, eligible).
test(other_provider_status_bound) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    nis2_domain_name_data_status(Profile, ineligible).
test(missing_provider_type_status_bound) :-
    nis2_domain_name_data_profile_for(no_provider_type, Profile),
    nis2_domain_name_data_status(Profile, indeterminate([provider_type])).
test(invalid_provider_type_status_bound) :-
    nis2_domain_name_data_profile_for(invalid_provider_type, Profile),
    nis2_domain_name_data_status(Profile, input_problems([wrong_type(provider_type)])).
test(duplicate_key_is_an_input_problem) :-
    provider_duties([attribute(provider_type, other), attribute(provider_type, other)], input_problems([duplicate_key(provider_type)])).
test(unknown_key_is_an_input_problem) :-
    publication_duty([attribute(registration_data_is_personal_data, true), attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(profile_not_a_list_is_an_input_problem) :-
    access_duty(banana, input_problems([wrong_type(profile)]), []).
test(hours_not_an_integer_is_an_input_problem) :-
    access_reply_timeliness([], seventy, input_problems([wrong_type(hours_elapsed)])).
test(access_both_true_bound) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).
test(access_unsure_first_refers) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, unsure), attribute(request_is_lawful_and_duly_substantiated, true)], needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - unsure, request_is_lawful_and_duly_substantiated - true])]), []).
test(checklist_bound_for_registry) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_checklist(Profile, [item(provider_addressed, met, cite(eu_dir_2022_2555_art_28_1))]).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_status(Profile, ineligible).

cp_test_names([registry_status_holds_with_the_verdict_bound, other_provider_status_bound, missing_provider_type_status_bound, invalid_provider_type_status_bound, duplicate_key_is_an_input_problem, unknown_key_is_an_input_problem, profile_not_a_list_is_an_input_problem, hours_not_an_integer_is_an_input_problem, access_both_true_bound, access_unsure_first_refers, checklist_bound_for_registry]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
