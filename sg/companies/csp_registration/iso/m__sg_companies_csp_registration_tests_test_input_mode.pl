% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_registration_status/2]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_profile_for/2]).

test(status_holds_with_no_corporate_service_bound) :-
    csp_registration_profile_for(no_service, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(status_holds_with_registered_bound) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, registered).
test(status_holds_with_registration_required_bound) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(status_holds_with_indeterminate_bound) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_status(Profile, indeterminate).
test(status_holds_with_not_carrying_bound) :-
    csp_registration_profile_for(not_in_singapore, Profile),
    csp_registration_status(Profile, not_carrying_on_business_in_singapore).

test(the_wrong_bound_status_is_rejected, fail) :-
    csp_registration_profile_for(no_service, Profile),
    csp_registration_status(Profile, registered).
test(another_wrong_bound_status_is_rejected, fail) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, indeterminate).

cp_test_names([status_holds_with_no_corporate_service_bound, status_holds_with_registered_bound, status_holds_with_registration_required_bound, status_holds_with_indeterminate_bound, status_holds_with_not_carrying_bound]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, another_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
