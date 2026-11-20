% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_queries, [csp_registration_profile_keys/1, csp_registration_what_if/4]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_profile_for/2]).

test(profile_keys_include_activities) :-
    csp_registration_profile_keys(Keys),
    member(activities, Keys).
test(profile_keys_include_carries) :-
    csp_registration_profile_keys(Keys),
    member(carries_on_business_in_singapore, Keys).
test(profile_keys_include_registered_service_types) :-
    csp_registration_profile_keys(Keys),
    member(registered_service_types, Keys).
test(profile_keys_include_arranges_nominee_director) :-
    csp_registration_profile_keys(Keys),
    member(arranges_nominee_director, Keys).
test(what_if_overriding_carries_to_false_changes_status) :-
    csp_registration_profile_for(no_service_near_miss, Profile),
    csp_registration_what_if(Profile, carries_on_business_in_singapore, false, not_carrying_on_business_in_singapore).
test(what_if_overriding_registered_types_to_cover_all) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_registration_what_if(Profile, registered_service_types, [formation, address], registered).
test(what_if_overriding_activities_to_empty) :-
    csp_registration_profile_for(no_service_near_miss, Profile),
    csp_registration_what_if(Profile, activities, [], no_corporate_service).
test(what_if_overriding_is_accounting_entity) :-
    csp_registration_profile_for(deemed_accounting_near_miss, Profile),
    csp_registration_what_if(Profile, accounting_service_is_own, true, registered).

cp_test_names([profile_keys_include_activities, profile_keys_include_carries, profile_keys_include_registered_service_types, profile_keys_include_arranges_nominee_director, what_if_overriding_carries_to_false_changes_status, what_if_overriding_registered_types_to_cover_all, what_if_overriding_activities_to_empty, what_if_overriding_is_accounting_entity]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
