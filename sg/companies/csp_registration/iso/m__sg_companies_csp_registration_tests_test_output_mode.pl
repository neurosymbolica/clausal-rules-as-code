% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_csp_registration, [decide_csp_registration/2, csp_registration_status/2]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_profile_for/2]).

test(no_service_profile_yields_exactly_one_status) :-
    csp_registration_profile_for(no_service, Profile),
    findall(Status, csp_registration_status(Profile, Status), Statuses),
    Statuses == [no_corporate_service].
test(fully_registered_profile_yields_exactly_one_status) :-
    csp_registration_profile_for(fully_registered, Profile),
    findall(Status, csp_registration_status(Profile, Status), Statuses),
    Statuses == [registered].
test(deemed_accounting_profile_yields_registered) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    findall(Status, csp_registration_status(Profile, Status), Statuses),
    Statuses == [registered].
test(decide_csp_carries_a_citation) :-
    csp_registration_profile_for(no_service, Profile),
    decide_csp_registration(Profile, csp_registration_verdict(no_corporate_service, [sg_cspa_2024_s2_1_corporate_service])).
test(decide_csp_registered_carries_s7_citation) :-
    csp_registration_profile_for(fully_registered, Profile),
    decide_csp_registration(Profile, csp_registration_verdict(registered, [sg_cspa_2024_s7_1])).
test(decide_csp_deemed_carries_s7_2_citation) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    decide_csp_registration(Profile, csp_registration_verdict(registered, [sg_cspa_2024_s7_1, sg_cspa_2024_s7_2])).

cp_test_names([no_service_profile_yields_exactly_one_status, fully_registered_profile_yields_exactly_one_status, deemed_accounting_profile_yields_registered, decide_csp_carries_a_citation, decide_csp_registered_carries_s7_citation, decide_csp_deemed_carries_s7_2_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
