% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [small_company_audit_exemption_status/2, small_company_audit_exemption_status_values/1]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_profile_for/2]).

test(fy_before_2015_is_not_exempt) :-
    small_company_audit_exemption_profile_for(fy_before_2015, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(small_company_exempt_is_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(two_criteria_above_is_not_exempt) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(revenue_at_boundary_is_exempt) :-
    small_company_audit_exemption_profile_for(revenue_at_boundary, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(parent_not_small_group_is_not_exempt) :-
    small_company_audit_exemption_profile_for(parent_not_small_group, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(parent_small_group_is_exempt) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(audit_notice_in_window_is_not_exempt) :-
    small_company_audit_exemption_profile_for(audit_notice_in_window, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(audit_notice_outside_window_is_exempt) :-
    small_company_audit_exemption_profile_for(audit_notice_outside_window, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(not_exempt_is_a_real_verdict_atom) :-
    small_company_audit_exemption_status_values(StatusValues),
    member(not_exempt, StatusValues).
test(exempt_is_a_real_verdict_atom) :-
    small_company_audit_exemption_status_values(StatusValues),
    member(exempt, StatusValues).

test(small_company_exempt_is_not_not_exempt, fail) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(revenue_at_boundary_is_not_not_exempt, fail) :-
    small_company_audit_exemption_profile_for(revenue_at_boundary, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(parent_small_group_is_not_not_exempt, fail) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(audit_notice_outside_window_is_not_not_exempt, fail) :-
    small_company_audit_exemption_profile_for(audit_notice_outside_window, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).

cp_test_names([fy_before_2015_is_not_exempt, small_company_exempt_is_exempt, two_criteria_above_is_not_exempt, revenue_at_boundary_is_exempt, parent_not_small_group_is_not_exempt, parent_small_group_is_exempt, audit_notice_in_window_is_not_exempt, audit_notice_outside_window_is_exempt, not_exempt_is_a_real_verdict_atom, exempt_is_a_real_verdict_atom]).
cp_test_fail_names([small_company_exempt_is_not_not_exempt, revenue_at_boundary_is_not_not_exempt, parent_small_group_is_not_not_exempt, audit_notice_outside_window_is_not_not_exempt]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
