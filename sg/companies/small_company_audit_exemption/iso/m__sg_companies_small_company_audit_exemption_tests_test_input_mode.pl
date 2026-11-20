% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [small_company_audit_exemption_status/2]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_profile_for/2]).

test(exempt_profile_with_exempt_bound) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(not_exempt_profile_with_not_exempt_bound) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(fy_before_2015_with_not_exempt_bound) :-
    small_company_audit_exemption_profile_for(fy_before_2015, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(audit_notice_in_window_with_not_exempt_bound) :-
    small_company_audit_exemption_profile_for(audit_notice_in_window, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(parent_not_small_group_with_not_exempt_bound) :-
    small_company_audit_exemption_profile_for(parent_not_small_group, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(parent_small_group_with_exempt_bound) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    small_company_audit_exemption_status(Profile, exempt).

test(exempt_profile_with_not_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(not_exempt_profile_with_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(fy_before_2015_with_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(fy_before_2015, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(audit_notice_in_window_with_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(audit_notice_in_window, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(parent_not_small_group_with_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(parent_not_small_group, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(parent_small_group_with_not_exempt_rejected, fail) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).

cp_test_names([exempt_profile_with_exempt_bound, not_exempt_profile_with_not_exempt_bound, fy_before_2015_with_not_exempt_bound, audit_notice_in_window_with_not_exempt_bound, parent_not_small_group_with_not_exempt_bound, parent_small_group_with_exempt_bound]).
cp_test_fail_names([exempt_profile_with_not_exempt_rejected, not_exempt_profile_with_exempt_rejected, fy_before_2015_with_exempt_rejected, audit_notice_in_window_with_exempt_rejected, parent_not_small_group_with_exempt_rejected, parent_small_group_with_not_exempt_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
