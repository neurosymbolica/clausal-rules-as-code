:- module(m__eu_procurement_time_limits_time_limits, [time_limits_status_values/1, time_limits_conformity_values/1, time_limits_stage_values/1, time_limits_reduction_condition_values/1, minimum_time_limit_days/5, no_minimum_prescribed_for/3, stage_not_provided_for/3, decide_time_limits/2, time_limits_status/2, minimum_days/2, time_limits_conformity/2, observed_days_conformity/3, conformity_of_check_status/2, applicable_reduction_condition/2, candidate_time_limit/3, time_limits_checklist/2, time_limits_decision_resolvable/1, time_limits_input_problem/2, time_limits_input_acceptable/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, get/3]).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, check_gte/5, not_member/2]).

time_limits_status_values([minimum_days_prescribed, no_minimum_prescribed, stage_not_applicable]).

time_limits_conformity_values([meets_prescribed_minimum, shorter_than_prescribed_minimum, observed_days_not_supplied, no_prescribed_minimum_to_meet]).

time_limits_stage_values([receipt_of_tenders, receipt_of_participation_requests]).

time_limits_reduction_condition_values([baseline_minimum, with_prior_information_notice, with_electronic_submission, under_state_of_urgency]).

minimum_time_limit_days(open_procedure, receipt_of_tenders, baseline_minimum, 35, cite(eu_dir_2014_24_art_27)) :-
    implements(eu_dir_2014_24_art_27).
minimum_time_limit_days(open_procedure, receipt_of_tenders, with_prior_information_notice, 15, cite(eu_dir_2014_24_art_27)) :-
    implements(eu_dir_2014_24_art_27).
minimum_time_limit_days(open_procedure, receipt_of_tenders, with_electronic_submission, 30, cite(eu_dir_2014_24_art_27)) :-
    implements(eu_dir_2014_24_art_27).
minimum_time_limit_days(open_procedure, receipt_of_tenders, under_state_of_urgency, 15, cite(eu_dir_2014_24_art_27)) :-
    implements(eu_dir_2014_24_art_27).
minimum_time_limit_days(restricted_procedure, receipt_of_participation_requests, baseline_minimum, 30, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(restricted_procedure, receipt_of_participation_requests, under_state_of_urgency, 15, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(restricted_procedure, receipt_of_tenders, baseline_minimum, 30, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(restricted_procedure, receipt_of_tenders, with_prior_information_notice, 10, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(restricted_procedure, receipt_of_tenders, with_electronic_submission, 25, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(restricted_procedure, receipt_of_tenders, under_state_of_urgency, 10, cite(eu_dir_2014_24_art_28)) :-
    implements(eu_dir_2014_24_art_28).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_participation_requests, baseline_minimum, 30, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_participation_requests, under_state_of_urgency, 15, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_tenders, baseline_minimum, 30, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_tenders, with_prior_information_notice, 10, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_tenders, with_electronic_submission, 25, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_procedure_with_negotiation, receipt_of_tenders, under_state_of_urgency, 10, cite(eu_dir_2014_24_art_29)) :-
    implements(eu_dir_2014_24_art_29).
minimum_time_limit_days(competitive_dialogue, receipt_of_participation_requests, baseline_minimum, 30, cite(eu_dir_2014_24_art_30)) :-
    implements(eu_dir_2014_24_art_30).
minimum_time_limit_days(innovation_partnership, receipt_of_participation_requests, baseline_minimum, 30, cite(eu_dir_2014_24_art_31)) :-
    implements(eu_dir_2014_24_art_31).

no_minimum_prescribed_for(competitive_dialogue, receipt_of_tenders, cite(eu_dir_2014_24_art_30)) :-
    implements(eu_dir_2014_24_art_30).
no_minimum_prescribed_for(innovation_partnership, receipt_of_tenders, cite(eu_dir_2014_24_art_31)) :-
    implements(eu_dir_2014_24_art_31).

stage_not_provided_for(open_procedure, receipt_of_participation_requests, cite(eu_dir_2014_24_art_27)) :-
    implements(eu_dir_2014_24_art_27).

applicable_reduction_condition(Profile, baseline_minimum) :-
    time_limits_input_acceptable(Profile).
applicable_reduction_condition(Profile, with_prior_information_notice) :-
    time_limits_input_acceptable(Profile),
    profile_get(Profile, prior_information_notice_published, true).
applicable_reduction_condition(Profile, with_electronic_submission) :-
    time_limits_input_acceptable(Profile),
    profile_get(Profile, electronic_submission_accepted, true).
applicable_reduction_condition(Profile, under_state_of_urgency) :-
    time_limits_input_acceptable(Profile),
    profile_get(Profile, state_of_urgency_substantiated, true).

candidate_time_limit(Profile, Days, Citation) :-
    time_limits_input_acceptable(Profile),
    get(Profile, procedure_type_key, ProcedureType),
    get(Profile, stage_key, Stage),
    applicable_reduction_condition(Profile, ReductionCondition),
    minimum_time_limit_days(ProcedureType, Stage, ReductionCondition, Days, Citation).

observed_days_conformity(Profile, MinimumDays, Conformity) :-
    time_limits_input_acceptable(Profile),
    check_gte(Profile, observed_time_limit_days, MinimumDays, _, CheckStatus),
    conformity_of_check_status(CheckStatus, Conformity).

conformity_of_check_status(CheckStatus, meets_prescribed_minimum) :-
    CheckStatus = met.
conformity_of_check_status(CheckStatus, shorter_than_prescribed_minimum) :-
    CheckStatus = unmet(_).
conformity_of_check_status(CheckStatus, observed_days_not_supplied) :-
    CheckStatus = unknown(_).

time_limits_input_problems(Profile, Problems) :-
    findall(Problem, input_problem_in_order(Profile, Problem), Problems).

time_limits_input_problem(Profile, Problem) :-
    time_limits_input_problems(Profile, [Problem|_]).

time_limits_input_acceptable(Profile) :-
    time_limits_input_problems(Profile, []).

input_problem_in_order(Profile, not_ground) :-
    term_variables(Profile, [_|_]).
input_problem_in_order(Profile, not_a_dict) :-
    ground(Profile),
    \+ dict_keys(Profile, _).
input_problem_in_order(Profile, missing_key(procedure_type_key)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_lacks(Profile, procedure_type_key).
input_problem_in_order(Profile, wrong_value(procedure_type_key, expected_procedure_type)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_get(Profile, procedure_type_key, ProcedureType),
    unrecognised_procedure_type(ProcedureType).
input_problem_in_order(Profile, missing_key(stage_key)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_lacks(Profile, stage_key).
input_problem_in_order(Profile, wrong_value(stage_key, expected_stage)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_get(Profile, stage_key, Stage),
    time_limits_stage_values(StageValues),
    not_member(Stage, StageValues).
input_problem_in_order(Profile, wrong_type(FlagKey, expected_boolean)) :-
    ground(Profile),
    dict_keys(Profile, _),
    circumstance_flag_key(FlagKey),
    profile_get(Profile, FlagKey, FlagValue),
    dif(FlagValue, true),
    dif(FlagValue, false).
input_problem_in_order(Profile, wrong_type(observed_time_limit_days, expected_integer)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_get(Profile, observed_time_limit_days, Days),
    not_an_integer(Days).
input_problem_in_order(Profile, negative_count(observed_time_limit_days)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_get(Profile, observed_time_limit_days, Days),
    integer(Days),
    Days #< 0.

unrecognised_procedure_type(ProcedureType) :-
    findall(Known, recognised_procedure_type(Known), KnownTypes),
    not_member(ProcedureType, KnownTypes).

not_an_integer(Value) :-
    atom(Value).
not_an_integer(Value) :-
    float(Value).
not_an_integer(Value) :-
    compound(Value).
not_an_integer(Value) :-
    dict_keys(Value, _).

no_statute("time_limits_input_problems", 2, "computation_helper").
no_statute("unrecognised_procedure_type", 1, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").

recognised_procedure_type(open_procedure).
recognised_procedure_type(restricted_procedure).
recognised_procedure_type(competitive_procedure_with_negotiation).
recognised_procedure_type(competitive_dialogue).
recognised_procedure_type(innovation_partnership).

circumstance_flag_key(prior_information_notice_published).
circumstance_flag_key(electronic_submission_accepted).
circumstance_flag_key(state_of_urgency_substantiated).

decide_time_limits(Profile, time_limits_verdict(minimum_days_prescribed, MinimumDays, Conformity, Citations)) :-
    time_limits_input_acceptable(Profile),
    findall(Days, candidate_time_limit(Profile, Days, _), CandidateDaysList),
    dif(CandidateDaysList, []),
    min_list(CandidateDaysList, MinimumDays),
    findall(Citation, candidate_time_limit(Profile, MinimumDays, Citation), MinimalCiteTerms),
    sort(MinimalCiteTerms, Citations),
    observed_days_conformity(Profile, MinimumDays, Conformity).
decide_time_limits(Profile, time_limits_verdict(no_minimum_prescribed, n_a, no_prescribed_minimum_to_meet, Citations)) :-
    time_limits_input_acceptable(Profile),
    get(Profile, procedure_type_key, ProcedureType),
    get(Profile, stage_key, Stage),
    no_minimum_prescribed_for(ProcedureType, Stage, Citation),
    Citations = [Citation].
decide_time_limits(Profile, time_limits_verdict(stage_not_applicable, n_a, no_prescribed_minimum_to_meet, Citations)) :-
    time_limits_input_acceptable(Profile),
    get(Profile, procedure_type_key, ProcedureType),
    get(Profile, stage_key, Stage),
    stage_not_provided_for(ProcedureType, Stage, Citation),
    Citations = [Citation].

time_limits_status(Profile, Status) :-
    decide_time_limits(Profile, time_limits_verdict(Status, _, _, _)).

minimum_days(Profile, MinimumDays) :-
    decide_time_limits(Profile, time_limits_verdict(_, MinimumDays, _, _)).

time_limits_conformity(Profile, Conformity) :-
    decide_time_limits(Profile, time_limits_verdict(_, _, Conformity, _)).

time_limits_checklist(Profile, Checklist) :-
    decide_time_limits(Profile, time_limits_verdict(Status, _, _, Citations)),
    Checklist = [item(overall, Status, Citations)].

time_limits_decision_resolvable(Profile) :-
    decide_time_limits(Profile, _).
