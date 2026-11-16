% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_fixtures, [daily_rest_subject/1, daily_rest_profile_for/2, daily_rest_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_daily_rest, [decide_daily_rest/6]).

daily_rest_subject(day_shift_worker).
daily_rest_subject(short_rest_worker).
daily_rest_subject(eleven_hour_rest_worker).
daily_rest_subject(one_minute_short_rest_worker).
daily_rest_subject(mobile_worker_short_rest).
daily_rest_subject(mobile_worker_day_shifts).
daily_rest_subject(fishing_vessel_worker_short_rest).
daily_rest_subject(fishing_vessel_worker_day_shifts).
daily_rest_subject(derogation_article_17_1_short_rest).
daily_rest_subject(derogation_article_17_3_short_rest).
daily_rest_subject(derogation_article_17_4_short_rest).
daily_rest_subject(derogation_article_18_short_rest).
daily_rest_subject(derogation_article_17_4_day_shifts).
daily_rest_subject(missing_category_short_rest).
daily_rest_subject(missing_category_day_shifts).
daily_rest_subject(missing_derogation_short_rest).
daily_rest_subject(on_call_on_site_absent).
daily_rest_subject(on_call_on_site_counted).
daily_rest_subject(on_call_on_site_not_counted).
daily_rest_subject(on_call_on_site_unsure).
daily_rest_subject(on_call_on_site_unsure_missing_category).
daily_rest_subject(on_call_standby_unsure).
daily_rest_subject(standby_behind_worker).
daily_rest_subject(standby_behind_short_worker).
daily_rest_subject(no_work_worker).
daily_rest_subject(single_shift_worker).
daily_rest_subject(period_cut_worker).
daily_rest_subject(period_cut_short_worker).
daily_rest_subject(leave_as_rest_worker).
daily_rest_subject(leave_replaced_by_work_worker).
daily_rest_subject(malformed_profile_worker).
daily_rest_subject(reversed_period_worker).

ordinary_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)]).

day_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

short_rest_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 20, 0), work), shift(w1, date_time(2026, 3, 3, 4, 0), date_time(2026, 3, 3, 12, 0), work)]).

eleven_hour_rest_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 21, 0), work), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

one_minute_short_rest_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 21, 1), work), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

on_call_on_site_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 22, 0), on_call_on_site), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

on_call_standby_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 22, 0), on_call_standby), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

standby_behind_shifts([shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 2, 2, 0), work), shift(w1, date_time(2026, 3, 2, 14, 0), date_time(2026, 3, 2, 15, 0), on_call_standby), shift(w1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 14, 0), on_call_on_site)]).

standby_behind_short_shifts([shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 2, 2, 0), work), shift(w1, date_time(2026, 3, 2, 14, 0), date_time(2026, 3, 2, 15, 0), on_call_standby), shift(w1, date_time(2026, 3, 3, 1, 59), date_time(2026, 3, 3, 14, 0), on_call_on_site)]).

another_worker_shifts([shift(w2, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work)]).

single_shift([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)]).

period_cut_shifts([shift(w1, date_time(2026, 3, 1, 22, 0), date_time(2026, 3, 2, 6, 0), work)]).

period_cut_short_shifts([shift(w1, date_time(2026, 3, 1, 22, 0), date_time(2026, 3, 2, 6, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 23, 0), work)]).

leave_as_rest_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 3, 0, 0), paid_annual_leave), shift(w1, date_time(2026, 3, 3, 0, 0), date_time(2026, 3, 3, 8, 0), sick_leave), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

leave_replaced_by_work_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 3, 0, 0), paid_annual_leave), shift(w1, date_time(2026, 3, 3, 0, 0), date_time(2026, 3, 3, 8, 0), work), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

daily_rest_profile_for(day_shift_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    ordinary_profile(Profile),
    day_shifts(Shifts).
daily_rest_profile_for(short_rest_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    ordinary_profile(Profile),
    short_rest_shifts(Shifts).
daily_rest_profile_for(eleven_hour_rest_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    eleven_hour_rest_shifts(Shifts).
daily_rest_profile_for(one_minute_short_rest_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    one_minute_short_rest_shifts(Shifts).
daily_rest_profile_for(mobile_worker_short_rest, case([attribute(worker_category, mobile_worker)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(mobile_worker_day_shifts, case([attribute(worker_category, mobile_worker)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    day_shifts(Shifts).
daily_rest_profile_for(fishing_vessel_worker_short_rest, case([attribute(worker_category, seagoing_fishing_vessel_worker)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(fishing_vessel_worker_day_shifts, case([attribute(worker_category, seagoing_fishing_vessel_worker)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    day_shifts(Shifts).
daily_rest_profile_for(derogation_article_17_1_short_rest, case([attribute(worker_category, other_worker), attribute(derogation_from_article_3, derogation_under_article_17_1)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(derogation_article_17_3_short_rest, case([attribute(worker_category, other_worker), attribute(derogation_from_article_3, derogation_under_article_17_3)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(derogation_article_17_4_short_rest, case([attribute(worker_category, other_worker), attribute(derogation_from_article_3, derogation_under_article_17_4)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(derogation_article_18_short_rest, case([attribute(worker_category, other_worker), attribute(derogation_from_article_3, derogation_under_article_18)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(derogation_article_17_4_day_shifts, case([attribute(worker_category, other_worker), attribute(derogation_from_article_3, derogation_under_article_17_4)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    day_shifts(Shifts).
daily_rest_profile_for(missing_category_short_rest, case([], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(missing_category_day_shifts, case([], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    day_shifts(Shifts).
daily_rest_profile_for(missing_derogation_short_rest, case([attribute(worker_category, other_worker)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    short_rest_shifts(Shifts).
daily_rest_profile_for(on_call_on_site_absent, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    ordinary_profile(Profile),
    on_call_on_site_shifts(Shifts).
daily_rest_profile_for(on_call_on_site_counted, case([attribute(on_call_on_site_counts_as_working_time, true), attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    on_call_on_site_shifts(Shifts).
daily_rest_profile_for(on_call_on_site_not_counted, case([attribute(on_call_on_site_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    on_call_on_site_shifts(Shifts).
daily_rest_profile_for(on_call_on_site_unsure, case([attribute(on_call_on_site_counts_as_working_time, unsure), attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    on_call_on_site_shifts(Shifts).
daily_rest_profile_for(on_call_on_site_unsure_missing_category, case([attribute(on_call_on_site_counts_as_working_time, unsure)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    on_call_on_site_shifts(Shifts).
daily_rest_profile_for(on_call_standby_unsure, case([attribute(on_call_on_site_counts_as_working_time, false), attribute(on_call_standby_counts_as_working_time, unsure), attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    on_call_standby_shifts(Shifts).
daily_rest_profile_for(standby_behind_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    standby_behind_shifts(Shifts).
daily_rest_profile_for(standby_behind_short_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    standby_behind_short_shifts(Shifts).
daily_rest_profile_for(no_work_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    another_worker_shifts(Shifts).
daily_rest_profile_for(single_shift_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    single_shift(Shifts).
daily_rest_profile_for(period_cut_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    period_cut_shifts(Shifts).
daily_rest_profile_for(period_cut_short_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    period_cut_short_shifts(Shifts).
daily_rest_profile_for(leave_as_rest_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    ordinary_profile(Profile),
    leave_as_rest_shifts(Shifts).
daily_rest_profile_for(leave_replaced_by_work_worker, case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    ordinary_profile(Profile),
    leave_replaced_by_work_shifts(Shifts).
daily_rest_profile_for(malformed_profile_worker, case([attribute(worker_category, pilot), attribute(derogation_from_article_3, no_derogation), attribute(derogation_from_article_3, no_derogation), attribute(colour, red)], w1, Shifts, date(2026, 3, 2), date(2026, 3, 3))) :-
    day_shifts(Shifts).
daily_rest_profile_for(reversed_period_worker, case(Profile, w1, Shifts, date(2026, 3, 3), date(2026, 3, 2))) :-
    ordinary_profile(Profile),
    day_shifts(Shifts).

daily_rest_assess(Subject, Result) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    decide_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result).
