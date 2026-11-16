% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_fixtures, [weekly_rest_subject/1, weekly_rest_profile_for/2, weekly_rest_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_weekly_rest_weekly_rest, [decide_weekly_rest/2]).

weekly_rest_subject(rest_of_2100_minutes_given).
weekly_rest_subject(rest_of_2099_minutes_not_given).
weekly_rest_subject(reduced_rest_of_1440_minutes_given).
weekly_rest_subject(reduced_rest_of_1439_minutes_not_given).
weekly_rest_subject(fourteen_day_run_of_4200_minutes_given).
weekly_rest_subject(fourteen_day_run_of_4199_minutes_not_given).
weekly_rest_subject(mobile_worker_short_rest_not_applied).
weekly_rest_subject(mobile_worker_full_rest_given).
weekly_rest_subject(fishing_vessel_worker_short_rest_not_applied).
weekly_rest_subject(fishing_vessel_worker_full_rest_given).
weekly_rest_subject(derogation_under_article_17_1_short_rest).
weekly_rest_subject(derogation_under_article_17_3_short_rest).
weekly_rest_subject(derogation_under_article_17_4_short_rest).
weekly_rest_subject(derogation_under_article_18_short_rest).
weekly_rest_subject(derogation_under_article_17_4_full_rest_given).
weekly_rest_subject(short_rest_without_worker_category).
weekly_rest_subject(short_rest_without_derogation).
weekly_rest_subject(unsure_standby_needs_legal_review).
weekly_rest_subject(standby_not_working_time_given).
weekly_rest_subject(standby_working_time_not_given).
weekly_rest_subject(absent_standby_indeterminate).
weekly_rest_subject(unknown_key_input_problems).

weekly_rest_profile_for(Subject, weekly_rest_case(Profile, worker_one, Shifts, PeriodStart, PeriodEnd)) :-
    subject_case(Subject, Profile, Shifts, PeriodStart, PeriodEnd).

subject_case(rest_of_2100_minutes_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([], Profile),
    work_until(date_time(2026, 3, 7, 13, 0), Shifts).
subject_case(rest_of_2099_minutes_not_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    ordinary_worker_without_derogation(Ordinary),
    full_minimum_profile(Ordinary, Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(reduced_rest_of_1440_minutes_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    reduced_minimum_profile([], Profile),
    work_until(date_time(2026, 3, 8, 0, 0), Shifts).
subject_case(reduced_rest_of_1439_minutes_not_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    ordinary_worker_without_derogation(Ordinary),
    reduced_minimum_profile(Ordinary, Profile),
    work_until(date_time(2026, 3, 8, 0, 1), Shifts).
subject_case(fourteen_day_run_of_4200_minutes_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 15)) :-
    fourteen_day_profile([], Profile),
    work_until(date_time(2026, 3, 13, 2, 0), Shifts).
subject_case(fourteen_day_run_of_4199_minutes_not_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 15)) :-
    ordinary_worker_without_derogation(Ordinary),
    fourteen_day_profile(Ordinary, Profile),
    work_until(date_time(2026, 3, 13, 2, 1), Shifts).
subject_case(mobile_worker_short_rest_not_applied, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, mobile_worker)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(mobile_worker_full_rest_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, mobile_worker)], Profile),
    work_until(date_time(2026, 3, 7, 13, 0), Shifts).
subject_case(fishing_vessel_worker_short_rest_not_applied, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, seagoing_fishing_vessel_worker)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(fishing_vessel_worker_full_rest_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, seagoing_fishing_vessel_worker)], Profile),
    work_until(date_time(2026, 3, 7, 13, 0), Shifts).
subject_case(derogation_under_article_17_1_short_rest, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_5, derogation_under_article_17_1)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(derogation_under_article_17_3_short_rest, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_5, derogation_under_article_17_3)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(derogation_under_article_17_4_short_rest, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_5, derogation_under_article_17_4)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(derogation_under_article_18_short_rest, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_5, derogation_under_article_18)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(derogation_under_article_17_4_full_rest_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_5, derogation_under_article_17_4)], Profile),
    work_until(date_time(2026, 3, 7, 13, 0), Shifts).
subject_case(short_rest_without_worker_category, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(short_rest_without_derogation, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(worker_category, other_worker)], Profile),
    work_until(date_time(2026, 3, 7, 13, 1), Shifts).
subject_case(unsure_standby_needs_legal_review, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(on_call_standby_counts_as_working_time, unsure), attribute(worker_category, other_worker), attribute(derogation_from_article_5, no_derogation)], Profile),
    standby_weekend(Shifts).
subject_case(standby_not_working_time_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(derogation_from_article_5, no_derogation)], Profile),
    standby_weekend(Shifts).
subject_case(standby_working_time_not_given, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(on_call_standby_counts_as_working_time, true), attribute(worker_category, other_worker), attribute(derogation_from_article_5, no_derogation)], Profile),
    standby_weekend(Shifts).
subject_case(absent_standby_indeterminate, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    ordinary_worker_without_derogation(Ordinary),
    full_minimum_profile(Ordinary, Profile),
    standby_weekend(Shifts).
subject_case(unknown_key_input_problems, Profile, Shifts, date(2026, 3, 2), date(2026, 3, 8)) :-
    full_minimum_profile([attribute(audit_note, reviewed)], Profile),
    work_until(date_time(2026, 3, 7, 13, 0), Shifts).

full_minimum_profile(Extra, Profile) :-
    append([attribute(weekly_rest_minimum, rest_of_24_plus_11_hours), attribute(weekly_rest_reference_period, seven_day_period)], Extra, Profile).

reduced_minimum_profile(Extra, Profile) :-
    append([attribute(weekly_rest_minimum, reduced_rest_of_24_hours), attribute(weekly_rest_reference_period, seven_day_period)], Extra, Profile).

fourteen_day_profile(Extra, Profile) :-
    append([attribute(weekly_rest_minimum, rest_of_24_plus_11_hours), attribute(weekly_rest_reference_period, fourteen_day_reference_period)], Extra, Profile).

ordinary_worker_without_derogation([attribute(worker_category, other_worker), attribute(derogation_from_article_5, no_derogation)]).

work_until(FinishTime, [shift(worker_one, date_time(2026, 3, 2, 0, 0), FinishTime, work)]).

standby_weekend([shift(worker_one, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 7, 13, 0), work), shift(worker_one, date_time(2026, 3, 7, 13, 0), date_time(2026, 3, 9, 0, 0), on_call_standby)]).

weekly_rest_assess(Subject, Result) :-
    weekly_rest_profile_for(Subject, Case),
    decide_weekly_rest(Case, Result).
