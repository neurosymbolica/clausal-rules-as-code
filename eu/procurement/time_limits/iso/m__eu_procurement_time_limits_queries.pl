:- module(m__eu_procurement_time_limits_queries, [time_limits_profile_keys/1, time_limits_what_if/4, time_limits_enumerate/4, time_limits_floor/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__eu_procurement_time_limits_time_limits, [minimum_days/2, minimum_time_limit_days/5]).

time_limits_profile_keys([procedure_type_key, stage_key, prior_information_notice_published, electronic_submission_accepted, state_of_urgency_substantiated, observed_time_limit_days]).

time_limits_what_if(Profile, OverriddenKey, NewValue, NewMinimumDays) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    minimum_days(Hypothesis, NewMinimumDays).

time_limits_enumerate(ProcedureType, Stage, ReductionCondition, Days) :-
    minimum_time_limit_days(ProcedureType, Stage, ReductionCondition, Days, _Citation).

time_limits_floor(ProcedureType, Stage, FloorDays) :-
    minimum_time_limit_days(ProcedureType, Stage, baseline_minimum, _, _),
    findall(Days, minimum_time_limit_days(ProcedureType, Stage, _, Days, _), DaysList),
    dif(DaysList, []),
    min_list(DaysList, FloorDays).
