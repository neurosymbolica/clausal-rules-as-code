% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_citations, [citation/2, implements/1]).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [decide_small_company_audit_exemption/2, small_company_audit_exemption/2, small_company_audit_exemption_checklist/2, small_company_audit_exemption_decision_resolvable/1, small_company_audit_exemption_status/2, small_company_audit_exemption_status_values/1]).
:- use_module(m__sg_companies_small_company_audit_exemption_queries, [small_company_audit_exemption_profile_keys/1, small_company_audit_exemption_reaches/3, small_company_audit_exemption_threshold/2, small_company_audit_exemption_what_if/4]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_assess/2, small_company_audit_exemption_profile_for/2, small_company_audit_exemption_subject/1]).
