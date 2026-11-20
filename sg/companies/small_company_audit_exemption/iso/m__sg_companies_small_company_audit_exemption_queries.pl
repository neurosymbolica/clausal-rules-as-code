% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_queries, [small_company_audit_exemption_profile_keys/1, small_company_audit_exemption_what_if/4, small_company_audit_exemption_threshold/2, small_company_audit_exemption_reaches/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [small_company_audit_exemption_status/2]).

small_company_audit_exemption_profile_keys([incorporation_date, financial_years, is_parent_company, is_subsidiary_company, group_formation_date, group_financial_years, audit_requisition_notice_date]).

small_company_audit_exemption_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    small_company_audit_exemption_status(Hypothesis, NewStatus).

small_company_audit_exemption_threshold(revenue_cents, threshold(revenue_cents, 1000000000, cite(ca1967_sc13_para_2))).
small_company_audit_exemption_threshold(total_assets_cents, threshold(total_assets_cents, 1000000000, cite(ca1967_sc13_para_2))).
small_company_audit_exemption_threshold(employees_count, threshold(employees_count, 50, cite(ca1967_sc13_para_2))).

small_company_audit_exemption_reaches(revenue_cents, Value, satisfied) :-
    Value #< 1000000001.
small_company_audit_exemption_reaches(revenue_cents, Value, not_satisfied) :-
    Value #> 1000000000.
small_company_audit_exemption_reaches(total_assets_cents, Value, satisfied) :-
    Value #< 1000000001.
small_company_audit_exemption_reaches(total_assets_cents, Value, not_satisfied) :-
    Value #> 1000000000.
small_company_audit_exemption_reaches(employees_count, Value, satisfied) :-
    Value #< 51.
small_company_audit_exemption_reaches(employees_count, Value, not_satisfied) :-
    Value #> 50.
