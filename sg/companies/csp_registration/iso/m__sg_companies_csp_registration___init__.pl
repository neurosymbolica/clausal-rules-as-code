% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_citations, [citation/2, implements/1]).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp/5, csp_assessment/2, csp_registration_checklist/2, csp_registration_decision_resolvable/1, csp_registration_status/2, csp_registration_status_values/1, decide_csp_registration/2]).
:- use_module(m__sg_companies_csp_registration_queries, [csp_registration_profile_keys/1, csp_registration_what_if/4]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_assess/2, csp_registration_profile_for/2, csp_registration_subject/1]).
