:- module(m__eu_procurement_utilities_negotiated_without_prior_call___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_citations, [citation/2, implements/1]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2, utilities_negotiated_without_prior_call_checklist/2, utilities_negotiated_without_prior_call_status/2, utilities_negotiated_without_prior_call_unmet_count/2, utilities_negotiated_without_prior_call_input_problem/2, utilities_negotiated_without_prior_call_input_acceptable/1]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_queries, [utilities_negotiated_without_prior_call_profile_keys/1, utilities_negotiated_without_prior_call_what_if/4]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_assess/2, utilities_negotiated_without_prior_call_profile_for/2, utilities_negotiated_without_prior_call_subject/1]).
