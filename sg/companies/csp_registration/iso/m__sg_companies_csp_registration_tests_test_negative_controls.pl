% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_registration_status/2, csp_registration_status_values/1]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_profile_for/2]).

test(indeterminate_is_a_valid_status) :-
    csp_registration_status_values(Statuses),
    member(indeterminate, Statuses).
test(missing_activities_is_indeterminate) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_status(Profile, indeterminate).
test(no_service_is_no_corporate_service) :-
    csp_registration_profile_for(no_service, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(not_in_singapore_is_not_carrying) :-
    csp_registration_profile_for(not_in_singapore, Profile),
    csp_registration_status(Profile, not_carrying_on_business_in_singapore).
test(fully_registered_is_registered) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, registered).
test(fully_registered_near_miss_is_registration_required) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(deemed_accounting_is_registered) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    csp_registration_status(Profile, registered).
test(deemed_accounting_near_miss_is_registration_required) :-
    csp_registration_profile_for(deemed_accounting_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(nominee_complied_is_registered) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_registration_status(Profile, registered).
test(nominee_breached_is_registered) :-
    csp_registration_profile_for(nominee_breached, Profile),
    csp_registration_status(Profile, registered).

test(missing_activities_is_not_no_corporate_service, fail) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(no_service_near_miss_is_not_no_corporate_service, fail) :-
    csp_registration_profile_for(no_service_near_miss, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(not_in_singapore_near_miss_is_not_not_carrying, fail) :-
    csp_registration_profile_for(not_in_singapore_near_miss, Profile),
    csp_registration_status(Profile, not_carrying_on_business_in_singapore).
test(fully_registered_near_miss_is_not_registered, fail) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_registration_status(Profile, registered).
test(fully_registered_is_not_registration_required, fail) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, registration_required).
test(deemed_accounting_near_miss_is_not_registered, fail) :-
    csp_registration_profile_for(deemed_accounting_near_miss, Profile),
    csp_registration_status(Profile, registered).
test(nominee_complied_is_not_registration_required, fail) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_registration_status(Profile, registration_required).

cp_test_names([indeterminate_is_a_valid_status, missing_activities_is_indeterminate, no_service_is_no_corporate_service, not_in_singapore_is_not_carrying, fully_registered_is_registered, fully_registered_near_miss_is_registration_required, deemed_accounting_is_registered, deemed_accounting_near_miss_is_registration_required, nominee_complied_is_registered, nominee_breached_is_registered]).
cp_test_fail_names([missing_activities_is_not_no_corporate_service, no_service_near_miss_is_not_no_corporate_service, not_in_singapore_near_miss_is_not_not_carrying, fully_registered_near_miss_is_not_registered, fully_registered_is_not_registration_required, deemed_accounting_near_miss_is_not_registered, nominee_complied_is_not_registration_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
