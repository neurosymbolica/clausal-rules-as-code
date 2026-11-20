% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_queries, [small_company_audit_exemption_profile_keys/1, small_company_audit_exemption_what_if/4, small_company_audit_exemption_threshold/2, small_company_audit_exemption_reaches/3]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_profile_for/2]).

test(profile_keys_include_incorporation_date) :-
    small_company_audit_exemption_profile_keys(Keys),
    member(incorporation_date, Keys).
test(profile_keys_include_financial_years) :-
    small_company_audit_exemption_profile_keys(Keys),
    member(financial_years, Keys).
test(profile_keys_include_is_parent_company) :-
    small_company_audit_exemption_profile_keys(Keys),
    member(is_parent_company, Keys).
test(profile_keys_include_audit_requisition_notice_date) :-
    small_company_audit_exemption_profile_keys(Keys),
    member(audit_requisition_notice_date, Keys).
test(what_if_overriding_financial_years_flips_verdict) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_what_if(Profile, financial_years, [fy(date(2020, 1, 1), date(2020, 12, 31), true, 2000000000, 2000000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 2000000000, 2000000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 2000000000, 2000000000, 25)], not_exempt).
test(what_if_overriding_to_small_stays_exempt) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    small_company_audit_exemption_what_if(Profile, financial_years, [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000000, 1000000000, 50), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000000, 1000000000, 50), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000000, 1000000000, 50)], exempt).
test(threshold_revenue_cents) :-
    small_company_audit_exemption_threshold(revenue_cents, threshold(revenue_cents, 1000000000, _)).
test(threshold_total_assets_cents) :-
    small_company_audit_exemption_threshold(total_assets_cents, threshold(total_assets_cents, 1000000000, _)).
test(threshold_employees_count) :-
    small_company_audit_exemption_threshold(employees_count, threshold(employees_count, 50, _)).
test(reaches_revenue_at_boundary_satisfied) :-
    small_company_audit_exemption_reaches(revenue_cents, 1000000000, satisfied).
test(reaches_revenue_above_not_satisfied) :-
    small_company_audit_exemption_reaches(revenue_cents, 1000000001, not_satisfied).
test(reaches_assets_at_boundary_satisfied) :-
    small_company_audit_exemption_reaches(total_assets_cents, 1000000000, satisfied).
test(reaches_assets_above_not_satisfied) :-
    small_company_audit_exemption_reaches(total_assets_cents, 1000000001, not_satisfied).
test(reaches_employees_at_boundary_satisfied) :-
    small_company_audit_exemption_reaches(employees_count, 50, satisfied).
test(reaches_employees_above_not_satisfied) :-
    small_company_audit_exemption_reaches(employees_count, 51, not_satisfied).
test(reaches_employees_below_satisfied) :-
    small_company_audit_exemption_reaches(employees_count, 25, satisfied).

cp_test_names([profile_keys_include_incorporation_date, profile_keys_include_financial_years, profile_keys_include_is_parent_company, profile_keys_include_audit_requisition_notice_date, what_if_overriding_financial_years_flips_verdict, what_if_overriding_to_small_stays_exempt, threshold_revenue_cents, threshold_total_assets_cents, threshold_employees_count, reaches_revenue_at_boundary_satisfied, reaches_revenue_above_not_satisfied, reaches_assets_at_boundary_satisfied, reaches_assets_above_not_satisfied, reaches_employees_at_boundary_satisfied, reaches_employees_above_not_satisfied, reaches_employees_below_satisfied]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
