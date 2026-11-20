% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [small_company_audit_exemption/2, decide_small_company_audit_exemption/2, small_company_audit_exemption_status/2, small_company_audit_exemption_checklist/2, small_company_audit_exemption_decision_resolvable/1, small_company_audit_exemption_status_values/1]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_subject/1, small_company_audit_exemption_profile_for/2, small_company_audit_exemption_assess/2]).
:- use_module(m__sg_companies_small_company_audit_exemption_queries, [small_company_audit_exemption_what_if/4, small_company_audit_exemption_threshold/2, small_company_audit_exemption_reaches/3]).

test(small_company_exempt_is_exempt) :-
    small_company_audit_exemption_assess(small_company_exempt, audit_exemption(exempt, true, n_a, [])).
test(revenue_at_boundary_is_exempt) :-
    small_company_audit_exemption_assess(revenue_at_boundary, audit_exemption(exempt, true, n_a, [])).
test(revenue_just_above_is_exempt) :-
    small_company_audit_exemption_assess(revenue_just_above, audit_exemption(exempt, true, n_a, [])).
test(two_criteria_above_is_not_exempt) :-
    small_company_audit_exemption_assess(two_criteria_above, audit_exemption(not_exempt, false, n_a, [not_small_company])).
test(assets_at_boundary_is_exempt) :-
    small_company_audit_exemption_assess(assets_at_boundary, audit_exemption(exempt, true, n_a, [])).
test(assets_just_above_is_exempt) :-
    small_company_audit_exemption_assess(assets_just_above, audit_exemption(exempt, true, n_a, [])).
test(employees_at_boundary_is_exempt) :-
    small_company_audit_exemption_assess(employees_at_boundary, audit_exemption(exempt, true, n_a, [])).
test(employees_just_above_is_exempt) :-
    small_company_audit_exemption_assess(employees_just_above, audit_exemption(exempt, true, n_a, [])).
test(not_private_year3_is_not_exempt) :-
    small_company_audit_exemption_assess(not_private_year3, audit_exemption(not_exempt, false, n_a, [not_small_company])).
test(fy_before_2015_is_not_exempt) :-
    small_company_audit_exemption_assess(fy_before_2015, audit_exemption(not_exempt, _, _, Reasons)),
    member(financial_year_before_1_july_2015, Reasons).
test(audit_notice_in_window_is_not_exempt) :-
    small_company_audit_exemption_assess(audit_notice_in_window, audit_exemption(not_exempt, true, n_a, [audit_requisition_notice])).
test(audit_notice_outside_window_is_exempt) :-
    small_company_audit_exemption_assess(audit_notice_outside_window, audit_exemption(exempt, true, n_a, [])).
test(parent_not_small_group_is_not_exempt) :-
    small_company_audit_exemption_assess(parent_not_small_group, audit_exemption(not_exempt, true, false, [not_small_group])).
test(parent_small_group_is_exempt) :-
    small_company_audit_exemption_assess(parent_small_group, audit_exemption(exempt, true, true, [])).
test(two_criteria_above_is_not_exempt_only) :-
    findall(Decision, small_company_audit_exemption_assess(two_criteria_above, audit_exemption(Decision, _, _, _)), Decisions),
    sort(Decisions, [not_exempt]).
test(not_private_year3_is_not_exempt_only) :-
    findall(Decision, small_company_audit_exemption_assess(not_private_year3, audit_exemption(Decision, _, _, _)), Decisions),
    sort(Decisions, [not_exempt]).
test(audit_notice_in_window_is_not_exempt_only) :-
    findall(Decision, small_company_audit_exemption_assess(audit_notice_in_window, audit_exemption(Decision, _, _, _)), Decisions),
    sort(Decisions, [not_exempt]).
test(parent_not_small_group_is_not_exempt_only) :-
    findall(Decision, small_company_audit_exemption_assess(parent_not_small_group, audit_exemption(Decision, _, _, _)), Decisions),
    sort(Decisions, [not_exempt]).
test(status_predicate_gives_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_status(Profile, exempt).
test(status_predicate_gives_not_exempt) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption_status(Profile, not_exempt).
test(status_values_are_correct) :-
    small_company_audit_exemption_status_values([exempt, not_exempt, indeterminate]).
test(checklist_non_empty_on_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_checklist(Profile, [_FirstItem|_OtherItems]).
test(checklist_non_empty_on_not_exempt) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    small_company_audit_exemption_checklist(Profile, [_FirstItem|_OtherItems]).
test(decision_resolvable_on_all_fixtures) :-
    small_company_audit_exemption_subject(Subject),
    small_company_audit_exemption_profile_for(Subject, Profile),
    small_company_audit_exemption_decision_resolvable(Profile).
test(revenue_threshold_is_10_million_cents) :-
    small_company_audit_exemption_threshold(revenue_cents, threshold(revenue_cents, 1000000000, _Cite)).
test(assets_threshold_is_10_million_cents) :-
    small_company_audit_exemption_threshold(total_assets_cents, threshold(total_assets_cents, 1000000000, _Cite)).
test(employees_threshold_is_50) :-
    small_company_audit_exemption_threshold(employees_count, threshold(employees_count, 50, _Cite)).
test(revenue_at_boundary_is_satisfied) :-
    small_company_audit_exemption_reaches(revenue_cents, 1000000000, satisfied).
test(revenue_just_above_is_not_satisfied) :-
    small_company_audit_exemption_reaches(revenue_cents, 1000000001, not_satisfied).
test(revenue_just_above_is_not_satisfied_only) :-
    findall(Status, small_company_audit_exemption_reaches(revenue_cents, 1000000001, Status), Statuses),
    sort(Statuses, [not_satisfied]).
test(assets_at_boundary_is_satisfied) :-
    small_company_audit_exemption_reaches(total_assets_cents, 1000000000, satisfied).
test(assets_just_above_is_not_satisfied) :-
    small_company_audit_exemption_reaches(total_assets_cents, 1000000001, not_satisfied).
test(assets_just_above_is_not_satisfied_only) :-
    findall(Status, small_company_audit_exemption_reaches(total_assets_cents, 1000000001, Status), Statuses),
    sort(Statuses, [not_satisfied]).
test(employees_at_boundary_is_satisfied) :-
    small_company_audit_exemption_reaches(employees_count, 50, satisfied).
test(employees_just_above_is_not_satisfied) :-
    small_company_audit_exemption_reaches(employees_count, 51, not_satisfied).
test(employees_just_above_is_not_satisfied_only) :-
    findall(Status, small_company_audit_exemption_reaches(employees_count, 51, Status), Statuses),
    sort(Statuses, [not_satisfied]).
test(what_if_revenue_above_still_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_what_if(Profile, financial_years, [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000001, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000001, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000001, 500000000, 25)], exempt).
test(what_if_two_criteria_above_not_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_what_if(Profile, financial_years, [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000001, 1000000001, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000001, 1000000001, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000001, 1000000001, 25)], not_exempt).

cp_test_names([small_company_exempt_is_exempt, revenue_at_boundary_is_exempt, revenue_just_above_is_exempt, two_criteria_above_is_not_exempt, assets_at_boundary_is_exempt, assets_just_above_is_exempt, employees_at_boundary_is_exempt, employees_just_above_is_exempt, not_private_year3_is_not_exempt, fy_before_2015_is_not_exempt, audit_notice_in_window_is_not_exempt, audit_notice_outside_window_is_exempt, parent_not_small_group_is_not_exempt, parent_small_group_is_exempt, two_criteria_above_is_not_exempt_only, not_private_year3_is_not_exempt_only, audit_notice_in_window_is_not_exempt_only, parent_not_small_group_is_not_exempt_only, status_predicate_gives_exempt, status_predicate_gives_not_exempt, status_values_are_correct, checklist_non_empty_on_exempt, checklist_non_empty_on_not_exempt, decision_resolvable_on_all_fixtures, revenue_threshold_is_10_million_cents, assets_threshold_is_10_million_cents, employees_threshold_is_50, revenue_at_boundary_is_satisfied, revenue_just_above_is_not_satisfied, revenue_just_above_is_not_satisfied_only, assets_at_boundary_is_satisfied, assets_just_above_is_not_satisfied, assets_just_above_is_not_satisfied_only, employees_at_boundary_is_satisfied, employees_just_above_is_not_satisfied, employees_just_above_is_not_satisfied_only, what_if_revenue_above_still_exempt, what_if_two_criteria_above_not_exempt]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
