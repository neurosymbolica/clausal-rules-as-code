% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_subject/1, small_company_audit_exemption_profile_for/2, small_company_audit_exemption_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [decide_small_company_audit_exemption/2]).

small_company_audit_exemption_subject(small_company_exempt).
small_company_audit_exemption_subject(revenue_at_boundary).
small_company_audit_exemption_subject(revenue_just_above).
small_company_audit_exemption_subject(two_criteria_above).
small_company_audit_exemption_subject(assets_at_boundary).
small_company_audit_exemption_subject(assets_just_above).
small_company_audit_exemption_subject(employees_at_boundary).
small_company_audit_exemption_subject(employees_just_above).
small_company_audit_exemption_subject(not_private_year3).
small_company_audit_exemption_subject(fy_before_2015).
small_company_audit_exemption_subject(audit_notice_in_window).
small_company_audit_exemption_subject(audit_notice_outside_window).
small_company_audit_exemption_subject(parent_not_small_group).
small_company_audit_exemption_subject(parent_small_group).

small_company_audit_exemption_profile_for(small_company_exempt, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(revenue_at_boundary, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(revenue_just_above, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000001, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000001, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000001, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(two_criteria_above, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 1000000001, 1000000001, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 1000000001, 1000000001, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 1000000001, 1000000001, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(assets_at_boundary, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 1000000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 1000000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 1000000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(assets_just_above, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 1000000001, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 1000000001, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 1000000001, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(employees_at_boundary, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 50), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 50), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 50)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(employees_just_above, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 51), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 51), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 51)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(not_private_year3, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), false, 500000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(fy_before_2015, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2010, 1, 1), financial_years - [fy(date(2010, 1, 1), date(2010, 12, 31), true, 500000000, 500000000, 25), fy(date(2011, 1, 1), date(2011, 12, 31), true, 500000000, 500000000, 25), fy(date(2012, 1, 1), date(2012, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false]).
small_company_audit_exemption_profile_for(audit_notice_in_window, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false, audit_requisition_notice_date - date(2022, 11, 15)]).
small_company_audit_exemption_profile_for(audit_notice_outside_window, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - false, is_subsidiary_company - false, audit_requisition_notice_date - date(2022, 12, 15)]).
small_company_audit_exemption_profile_for(parent_not_small_group, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - true, is_subsidiary_company - false, group_formation_date - date(2020, 1, 1), group_financial_years - [gfy(date(2020, 1, 1), date(2020, 12, 31), 2000000000, 2000000000, 25), gfy(date(2021, 1, 1), date(2021, 12, 31), 2000000000, 2000000000, 25), gfy(date(2022, 1, 1), date(2022, 12, 31), 2000000000, 2000000000, 25)]]).
small_company_audit_exemption_profile_for(parent_small_group, Profile) :-
    dict_pairs(Profile, [incorporation_date - date(2020, 1, 1), financial_years - [fy(date(2020, 1, 1), date(2020, 12, 31), true, 500000000, 500000000, 25), fy(date(2021, 1, 1), date(2021, 12, 31), true, 500000000, 500000000, 25), fy(date(2022, 1, 1), date(2022, 12, 31), true, 500000000, 500000000, 25)], is_parent_company - true, is_subsidiary_company - false, group_formation_date - date(2020, 1, 1), group_financial_years - [gfy(date(2020, 1, 1), date(2020, 12, 31), 500000000, 500000000, 25), gfy(date(2021, 1, 1), date(2021, 12, 31), 500000000, 500000000, 25), gfy(date(2022, 1, 1), date(2022, 12, 31), 500000000, 500000000, 25)]]).

small_company_audit_exemption_assess(Subject, Result) :-
    small_company_audit_exemption_profile_for(Subject, Profile),
    decide_small_company_audit_exemption(Profile, Result).
