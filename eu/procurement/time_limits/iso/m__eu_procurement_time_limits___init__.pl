:- module(m__eu_procurement_time_limits___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_time_limits_time_limits, [time_limits_status_values/1, time_limits_conformity_values/1, time_limits_stage_values/1, time_limits_reduction_condition_values/1, minimum_time_limit_days/5, no_minimum_prescribed_for/3, stage_not_provided_for/3, decide_time_limits/2, time_limits_status/2, minimum_days/2, time_limits_conformity/2, observed_days_conformity/3, applicable_reduction_condition/2, candidate_time_limit/3, time_limits_checklist/2, time_limits_decision_resolvable/1, time_limits_input_problem/2, time_limits_input_acceptable/1]).
:- use_module(m__eu_procurement_time_limits_citations, [citation/2]).
:- use_module(m__eu_procurement_time_limits_queries, [time_limits_profile_keys/1, time_limits_what_if/4, time_limits_enumerate/4, time_limits_floor/3]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_subject/1, time_limits_profile_for/2, time_limits_assess/2]).

root_export(electronic_submission_accepted).
root_export(prior_information_notice_published).
root_export(procedure_type_key).
root_export(stage_key).
root_export(state_of_urgency_substantiated).
root_export(time_limits_verdict).
