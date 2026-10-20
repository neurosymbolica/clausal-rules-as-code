:- module(m__eu_procurement_shortlisting___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_shortlisting_citations, [citation/2]).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_checklist/2, shortlisting_decision_resolvable/1, shortlisting_inclusion_modality/2, shortlisting_input_problem/2, shortlisting_invitation_floor/4, shortlisting_limitation_modality/4, shortlisting_profile_keys/1, shortlisting_status/2, shortlisting_status_values/1, shortlisting_what_if/4, statutory_minimum_candidates/2]).
:- use_module(m__eu_procurement_shortlisting_queries, [shortlisting_floor_comparison/7, shortlisting_threshold_flip/5]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_assess/2, shortlisting_profile_for/2, shortlisting_subject/1]).
