:- module(m__eu_aml_amlr_beneficial_ownership_threshold___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_requirement_ids/1, amlr_bo_minimum_holding_bps/1, amlr_bo_effective_holding_bps/2, amlr_bo_threshold/1, amlr_bo_effective_holding/2, amlr_bo_status/2, requirement/4, assess_amlr_bo/3, amlr_bo_decision/2, amlr_bo_checklist/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_fixtures, [amlr_bo_assess/2, amlr_bo_subject/1, amlr_bo_profile_for/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_queries, [amlr_bo_diff/3, amlr_bo_what_if/3, amlr_bo_direct_boundary/1, amlr_bo_gap_to_threshold/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_citations, [citation/2]).
