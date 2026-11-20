% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [small_company_audit_exemption/2, small_company_audit_exemption_status/2]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_profile_for/2]).

test(exempt_profile_yields_exactly_one_status) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [exempt].
test(exempt_result_shape) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(revenue_at_boundary_is_exempt) :-
    small_company_audit_exemption_profile_for(revenue_at_boundary, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(revenue_just_above_still_exempt_two_of_three) :-
    small_company_audit_exemption_profile_for(revenue_just_above, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(two_criteria_above_is_not_exempt) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption(Profile, audit_exemption(not_exempt, false, n_a, [not_small_company])).
test(assets_at_boundary_is_exempt) :-
    small_company_audit_exemption_profile_for(assets_at_boundary, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(employees_at_boundary_is_exempt) :-
    small_company_audit_exemption_profile_for(employees_at_boundary, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(not_private_year3_is_not_exempt) :-
    small_company_audit_exemption_profile_for(not_private_year3, Profile),
    small_company_audit_exemption(Profile, audit_exemption(not_exempt, false, n_a, [not_small_company])).
test(fy_before_2015_is_not_exempt) :-
    small_company_audit_exemption_profile_for(fy_before_2015, Profile),
    small_company_audit_exemption(Profile, audit_exemption(not_exempt, false, n_a, [financial_year_before_1_july_2015, not_small_company])).
test(audit_notice_in_window_is_not_exempt) :-
    small_company_audit_exemption_profile_for(audit_notice_in_window, Profile),
    small_company_audit_exemption(Profile, audit_exemption(not_exempt, true, n_a, [audit_requisition_notice])).
test(audit_notice_outside_window_is_exempt) :-
    small_company_audit_exemption_profile_for(audit_notice_outside_window, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, n_a, [])).
test(parent_not_small_group_is_not_exempt) :-
    small_company_audit_exemption_profile_for(parent_not_small_group, Profile),
    small_company_audit_exemption(Profile, audit_exemption(not_exempt, true, false, [not_small_group])).
test(parent_small_group_is_exempt) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    small_company_audit_exemption(Profile, audit_exemption(exempt, true, true, [])).

cp_test_names([exempt_profile_yields_exactly_one_status, exempt_result_shape, revenue_at_boundary_is_exempt, revenue_just_above_still_exempt_two_of_three, two_criteria_above_is_not_exempt, assets_at_boundary_is_exempt, employees_at_boundary_is_exempt, not_private_year3_is_not_exempt, fy_before_2015_is_not_exempt, audit_notice_in_window_is_not_exempt, audit_notice_outside_window_is_exempt, parent_not_small_group_is_not_exempt, parent_small_group_is_exempt]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
