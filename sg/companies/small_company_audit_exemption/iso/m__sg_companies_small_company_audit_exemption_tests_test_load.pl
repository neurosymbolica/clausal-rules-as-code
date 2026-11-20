% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_citations, [citation/2, implements/1]).

test(result_term_exempt) :-
    Result = audit_exemption(exempt, true, n_a, []),
    Result = audit_exemption(Decision, SmallCompany, SmallGroup, Reasons),
    Decision == exempt,
    SmallCompany == true,
    SmallGroup == n_a,
    Reasons == [].
test(result_term_not_exempt) :-
    Result = audit_exemption(not_exempt, false, false, [not_small_company, not_small_group]),
    Result = audit_exemption(Decision, SmallCompany, SmallGroup, Reasons),
    Decision == not_exempt,
    SmallCompany == false,
    SmallGroup == false,
    Reasons == [not_small_company, not_small_group].
test(result_term_indeterminate) :-
    Result = audit_exemption(indeterminate, n_a, n_a, []),
    Result = audit_exemption(Decision, SmallCompany, SmallGroup, Reasons),
    Decision == indeterminate,
    SmallCompany == n_a,
    SmallGroup == n_a,
    Reasons == [].
test(decision_atoms_are_distinct) :-
    dif(exempt, not_exempt),
    dif(exempt, indeterminate),
    dif(not_exempt, indeterminate).
test(small_company_status_atoms_are_distinct) :-
    dif(true, false),
    dif(true, n_a),
    dif(false, n_a).
test(reasons_atoms_are_distinct) :-
    dif(financial_year_before_1_july_2015, not_small_company),
    dif(financial_year_before_1_july_2015, not_small_group),
    dif(financial_year_before_1_july_2015, audit_requisition_notice),
    dif(not_small_company, not_small_group),
    dif(not_small_company, audit_requisition_notice),
    dif(not_small_group, audit_requisition_notice).
test(reasons_list_full_order) :-
    Result = audit_exemption(not_exempt, false, false, [financial_year_before_1_july_2015, not_small_company, not_small_group, audit_requisition_notice]),
    Result = audit_exemption(_, _, _, Reasons),
    Reasons == [financial_year_before_1_july_2015, not_small_company, not_small_group, audit_requisition_notice].
test(fy_term_builds) :-
    FinancialYearRecord = fy(date(2024, 1, 1), date(2024, 12, 31), true, 500000000, 800000000, 30),
    FinancialYearRecord = fy(StartDate, EndDate, PrivateThroughout, RevenueCents, TotalAssetsCents, Employees),
    StartDate == date(2024, 1, 1),
    EndDate == date(2024, 12, 31),
    PrivateThroughout == true,
    RevenueCents == 500000000,
    TotalAssetsCents == 800000000,
    Employees == 30.
test(gfy_term_builds) :-
    GroupFinancialYearRecord = gfy(date(2024, 1, 1), date(2024, 12, 31), 900000000, 950000000, 45),
    GroupFinancialYearRecord = gfy(StartDate, EndDate, ConsolidatedRevenueCents, ConsolidatedTotalAssetsCents, AggregateEmployees),
    StartDate == date(2024, 1, 1),
    EndDate == date(2024, 12, 31),
    ConsolidatedRevenueCents == 900000000,
    ConsolidatedTotalAssetsCents == 950000000,
    AggregateEmployees == 45.
test(real_citation_s205c_1_resolves) :-
    citation(ca1967_s205c_1, _Record).
test(real_citation_sc13_para_2_resolves) :-
    citation(ca1967_sc13_para_2, _Record).
test(real_citation_s205b_6_resolves) :-
    citation(ca1967_s205b_6, _Record).
test(implements_succeeds_for_s205c_1) :-
    implements(ca1967_s205c_1).
test(implements_succeeds_for_sc13_para_5) :-
    implements(ca1967_sc13_para_5).

cp_test_names([result_term_exempt, result_term_not_exempt, result_term_indeterminate, decision_atoms_are_distinct, small_company_status_atoms_are_distinct, reasons_atoms_are_distinct, reasons_list_full_order, fy_term_builds, gfy_term_builds, real_citation_s205c_1_resolves, real_citation_sc13_para_2_resolves, real_citation_s205b_6_resolves, implements_succeeds_for_s205c_1, implements_succeeds_for_sc13_para_5]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
