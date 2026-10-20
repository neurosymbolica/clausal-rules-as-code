:- module(m__eu_procurement_framework_agreements___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_citations, [citation/2]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [framework_term_limit_years/1]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [call_off_award_window_status/4, call_off_defect_id/1, call_off_method/1, call_off_route/2, call_off_route_id/1, decide_call_off/2, decide_framework_agreements/2, decide_framework_term/2, framework_agreements_checklist/2, framework_agreements_decision_resolvable/1, framework_agreements_status/2, framework_agreements_status_values/1, framework_term_defect_id/1, framework_term_limit_date/2, framework_term_within_limit/3]).
:- use_module(m__eu_procurement_framework_agreements_queries, [framework_agreements_enumerate_defects/2, framework_agreements_profile_keys/1, framework_agreements_route_status/2, framework_agreements_term_boundary/2, framework_agreements_threshold_status/3, framework_agreements_what_if/4]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_assess/2, framework_agreements_profile_for/2, framework_agreements_subject/1]).
