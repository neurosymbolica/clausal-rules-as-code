:- module(m__eu_procurement_time_limits_fixtures, [time_limits_subject/1, time_limits_profile_for/2, time_limits_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2]).

time_limits_subject("open_tenders_baseline").
time_limits_subject("open_tenders_prior_information_notice").
time_limits_subject("open_tenders_electronic_submission").
time_limits_subject("open_tenders_urgency").
time_limits_subject("open_tenders_prior_notice_and_electronic").
time_limits_subject("open_participation_requests").
time_limits_subject("restricted_requests_baseline").
time_limits_subject("restricted_requests_urgency").
time_limits_subject("restricted_tenders_baseline").
time_limits_subject("restricted_tenders_prior_information_notice").
time_limits_subject("restricted_tenders_electronic_submission").
time_limits_subject("restricted_tenders_urgency").
time_limits_subject("negotiation_requests_urgency").
time_limits_subject("negotiation_tenders_electronic_submission").
time_limits_subject("dialogue_requests_baseline").
time_limits_subject("dialogue_requests_urgency_claimed").
time_limits_subject("dialogue_tenders").
time_limits_subject("partnership_requests_baseline").
time_limits_subject("partnership_tenders").
time_limits_subject("open_tenders_baseline_allowing_20").
time_limits_subject("open_tenders_baseline_allowing_34").
time_limits_subject("open_tenders_baseline_allowing_35").
time_limits_subject("open_tenders_prior_notice_allowing_20").
time_limits_subject("dialogue_tenders_allowing_20").

time_limits_profile_for("open_tenders_baseline", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("open_tenders_prior_information_notice", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - true, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("open_tenders_electronic_submission", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - true, state_of_urgency_substantiated - false]).
time_limits_profile_for("open_tenders_urgency", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true]).
time_limits_profile_for("open_tenders_prior_notice_and_electronic", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - true, electronic_submission_accepted - true, state_of_urgency_substantiated - false]).
time_limits_profile_for("open_participation_requests", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("restricted_requests_baseline", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("restricted_requests_urgency", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true]).
time_limits_profile_for("restricted_tenders_baseline", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("restricted_tenders_prior_information_notice", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - true, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("restricted_tenders_electronic_submission", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - true, state_of_urgency_substantiated - false]).
time_limits_profile_for("restricted_tenders_urgency", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true]).
time_limits_profile_for("negotiation_requests_urgency", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_procedure_with_negotiation, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true]).
time_limits_profile_for("negotiation_tenders_electronic_submission", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_procedure_with_negotiation, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - true, state_of_urgency_substantiated - false]).
time_limits_profile_for("dialogue_requests_baseline", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_dialogue, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("dialogue_requests_urgency_claimed", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_dialogue, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true]).
time_limits_profile_for("dialogue_tenders", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_dialogue, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("partnership_requests_baseline", Profile) :-
    dict_pairs(Profile, [procedure_type_key - innovation_partnership, stage_key - receipt_of_participation_requests, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("partnership_tenders", Profile) :-
    dict_pairs(Profile, [procedure_type_key - innovation_partnership, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]).
time_limits_profile_for("open_tenders_baseline_allowing_20", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 20]).
time_limits_profile_for("open_tenders_baseline_allowing_34", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 34]).
time_limits_profile_for("open_tenders_baseline_allowing_35", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 35]).
time_limits_profile_for("open_tenders_prior_notice_allowing_20", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - true, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 20]).
time_limits_profile_for("dialogue_tenders_allowing_20", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_dialogue, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 20]).

time_limits_assess(Subject, Result) :-
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, Result).
