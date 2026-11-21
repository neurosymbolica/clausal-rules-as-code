% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_fixtures, [night_work_subject/1, night_work_profile_for/2, night_work_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_night_work, [decide_night_work/2]).

night_work_subject(average_at_the_limit_kept).
night_work_subject(average_one_minute_over_exceeded).
night_work_subject(average_mobile_worker_outside_article_8).
night_work_subject(average_mobile_worker_at_the_limit_kept).
night_work_subject(average_fishing_vessel_worker_outside_article_8).
night_work_subject(average_not_a_night_worker).
night_work_subject(average_derogation_under_article_17_1).
night_work_subject(average_derogation_under_article_17_3).
night_work_subject(average_derogation_under_article_18).
night_work_subject(average_absent_reference_period_asked).
night_work_subject(average_one_day_reference_period_kept).
night_work_subject(average_category_named_before_derogation).
night_work_subject(average_derogation_named_once_category_stated).
night_work_subject(average_unsure_night_worker_referred).
night_work_subject(average_absent_on_site_key_asked).
night_work_subject(average_on_site_counted_exceeded).
night_work_subject(average_on_site_not_counted_kept).
night_work_subject(average_leave_not_counted_kept).
night_work_subject(average_same_hours_worked_exceeded).
night_work_subject(average_cut_last_block_exceeded).
night_work_subject(average_cut_last_block_at_the_limit_kept).
night_work_subject(average_unknown_key_problem).
night_work_subject(average_period_end_before_start_problem).
night_work_subject(hazardous_eight_hours_kept).
night_work_subject(hazardous_one_minute_over_exceeded).
night_work_subject(hazardous_no_special_hazards).
night_work_subject(hazardous_not_a_night_worker).
night_work_subject(hazardous_mobile_worker_outside_article_8).
night_work_subject(hazardous_fishing_vessel_worker_outside_article_8).
night_work_subject(hazardous_derogation_under_article_18).
night_work_subject(hazardous_day_shift_ending_at_night_start_kept).
night_work_subject(hazardous_day_shift_one_night_minute_exceeded).
night_work_subject(hazardous_shift_from_night_end_kept).
night_work_subject(hazardous_shift_one_minute_before_night_end_exceeded).
night_work_subject(hazardous_window_past_period_exceeded).
night_work_subject(hazardous_window_past_period_at_the_limit_kept).
night_work_subject(hazardous_touching_rows_exceeded).
night_work_subject(hazardous_touching_rows_at_the_limit_kept).
night_work_subject(hazardous_absent_night_time_asked).
night_work_subject(hazardous_stated_night_time_kept).
night_work_subject(hazardous_unsure_standby_referred).
night_work_subject(hazardous_standby_counted_exceeded).
night_work_subject(hazardous_standby_not_counted_kept).
night_work_subject(hazardous_float_worker_problem).

full_profile(Site, Standby, Category, NightWorker, Special, Derogation, [attribute(on_call_on_site_counts_as_working_time, Site), attribute(on_call_standby_counts_as_working_time, Standby), attribute(night_time_start, 1320), attribute(night_time_end, 300), attribute(night_work_reference_period_days, 7), attribute(worker_category, Category), attribute(night_worker, NightWorker), attribute(special_hazards_or_heavy_strain, Special), attribute(derogation_from_article_8, Derogation)]).

stated_profile(Category, NightWorker, Special, Derogation, Profile) :-
    full_profile(true, false, Category, NightWorker, Special, Derogation, Profile).

profile_without_on_site_key([attribute(on_call_standby_counts_as_working_time, false), attribute(night_time_start, 1320), attribute(night_time_end, 300), attribute(night_work_reference_period_days, 7), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, true), attribute(derogation_from_article_8, no_derogation)]).

average_week_case(Profile, Shifts, average_case(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8))).

hazardous_day_case(Profile, Shifts, hazardous_case(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2))).

night_shift(Day, shift(worker_1, date_time(2026, 3, Day, 22, 0), date_time(2026, 3, NextDay, 6, 0), work)) :-
    succ(Day, NextDay).

nights(Days, Shifts) :-
    findall(Shift, (member(Day, Days), night_shift(Day, Shift)), Shifts).

six_nights(Shifts) :-
    nights([2, 3, 4, 5, 6, 7], Shifts).

seven_nights(Shifts) :-
    nights([2, 3, 4, 5, 6, 7, 8], Shifts).

six_nights_one_minute_over(Shifts) :-
    nights([2, 3, 4, 5, 6], FiveNights),
    append(FiveNights, [shift(worker_1, date_time(2026, 3, 7, 22, 0), date_time(2026, 3, 8, 6, 1), work)], Shifts).

six_nights_with(Extra, Shifts) :-
    six_nights(SixNights),
    append(SixNights, [Extra], Shifts).

long_night([shift(worker_1, date_time(2026, 3, 2, 21, 59), date_time(2026, 3, 3, 6, 0), work)]).

night_work_profile_for(todo_baseline_subject, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    six_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_at_the_limit_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    six_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_one_minute_over_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_mobile_worker_outside_article_8, Case) :-
    stated_profile(mobile_worker, true, true, no_derogation, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_mobile_worker_at_the_limit_kept, Case) :-
    stated_profile(mobile_worker, true, true, no_derogation, Profile),
    six_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_fishing_vessel_worker_outside_article_8, Case) :-
    stated_profile(seagoing_fishing_vessel_worker, true, true, no_derogation, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_not_a_night_worker, Case) :-
    stated_profile(other_worker, false, true, no_derogation, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_derogation_under_article_17_1, Case) :-
    stated_profile(other_worker, true, true, derogation_under_article_17_1, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_derogation_under_article_17_3, Case) :-
    stated_profile(other_worker, true, true, derogation_under_article_17_3, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_derogation_under_article_18, Case) :-
    stated_profile(other_worker, true, true, derogation_under_article_18, Profile),
    six_nights_one_minute_over(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_absent_reference_period_asked, Case) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(derogation_from_article_8, no_derogation)],
    seven_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_one_day_reference_period_kept, Case) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_work_reference_period_days, 1), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(derogation_from_article_8, no_derogation)],
    seven_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_category_named_before_derogation, Case) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_work_reference_period_days, 7), attribute(night_worker, true)],
    seven_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_derogation_named_once_category_stated, Case) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_work_reference_period_days, 7), attribute(worker_category, other_worker), attribute(night_worker, true)],
    seven_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_unsure_night_worker_referred, Case) :-
    stated_profile(other_worker, unsure, true, no_derogation, Profile),
    seven_nights(Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_absent_on_site_key_asked, Case) :-
    profile_without_on_site_key(Profile),
    six_nights_with(shift(worker_1, date_time(2026, 3, 8, 12, 0), date_time(2026, 3, 8, 12, 1), on_call_on_site), Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_on_site_counted_exceeded, Case) :-
    full_profile(true, false, other_worker, true, true, no_derogation, Profile),
    six_nights_with(shift(worker_1, date_time(2026, 3, 8, 12, 0), date_time(2026, 3, 8, 12, 1), on_call_on_site), Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_on_site_not_counted_kept, Case) :-
    full_profile(false, false, other_worker, true, true, no_derogation, Profile),
    six_nights_with(shift(worker_1, date_time(2026, 3, 8, 12, 0), date_time(2026, 3, 8, 12, 1), on_call_on_site), Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_leave_not_counted_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    six_nights_with(shift(worker_1, date_time(2026, 3, 8, 9, 0), date_time(2026, 3, 8, 17, 0), paid_annual_leave), Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_same_hours_worked_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    six_nights_with(shift(worker_1, date_time(2026, 3, 8, 9, 0), date_time(2026, 3, 8, 17, 0), work), Shifts),
    average_week_case(Profile, Shifts, Case).
night_work_profile_for(average_cut_last_block_exceeded, average_case(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 9))) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 9, 8, 0), date_time(2026, 3, 9, 16, 1), work)].
night_work_profile_for(average_cut_last_block_at_the_limit_kept, average_case(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 9))) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 9, 8, 0), date_time(2026, 3, 9, 16, 0), work)].
night_work_profile_for(average_unknown_key_problem, average_case([attribute(colour, red)], worker_1, [], date(2026, 3, 2), date(2026, 3, 8))).
night_work_profile_for(average_period_end_before_start_problem, average_case([], worker_1, [], date(2026, 3, 8), date(2026, 3, 2))).
night_work_profile_for(hazardous_eight_hours_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work)], Case).
night_work_profile_for(hazardous_one_minute_over_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_no_special_hazards, Case) :-
    stated_profile(other_worker, true, false, no_derogation, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_not_a_night_worker, Case) :-
    stated_profile(other_worker, false, true, no_derogation, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_mobile_worker_outside_article_8, Case) :-
    stated_profile(mobile_worker, true, true, no_derogation, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_fishing_vessel_worker_outside_article_8, Case) :-
    stated_profile(seagoing_fishing_vessel_worker, true, true, no_derogation, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_derogation_under_article_18, Case) :-
    stated_profile(other_worker, true, true, derogation_under_article_18, Profile),
    long_night(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_day_shift_ending_at_night_start_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 12, 0), date_time(2026, 3, 2, 22, 0), work)], Case).
night_work_profile_for(hazardous_day_shift_one_night_minute_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 12, 0), date_time(2026, 3, 2, 22, 1), work)], Case).
night_work_profile_for(hazardous_shift_from_night_end_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 5, 0), date_time(2026, 3, 2, 15, 0), work)], Case).
night_work_profile_for(hazardous_shift_one_minute_before_night_end_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 4, 59), date_time(2026, 3, 2, 15, 0), work)], Case).
night_work_profile_for(hazardous_window_past_period_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 10, 0), date_time(2026, 3, 3, 14, 1), work)], Case).
night_work_profile_for(hazardous_window_past_period_at_the_limit_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 10, 0), date_time(2026, 3, 3, 14, 0), work)], Case).
night_work_profile_for(hazardous_touching_rows_exceeded, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 6, 1), work)], Case).
night_work_profile_for(hazardous_touching_rows_at_the_limit_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 6, 0), work)], Case).
night_work_profile_for(hazardous_absent_night_time_asked, Case) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, true), attribute(derogation_from_article_8, no_derogation)],
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 6, 0), date_time(2026, 3, 2, 17, 0), work)], Case).
night_work_profile_for(hazardous_stated_night_time_kept, Case) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    hazardous_day_case(Profile, [shift(worker_1, date_time(2026, 3, 2, 6, 0), date_time(2026, 3, 2, 17, 0), work)], Case).
night_work_profile_for(hazardous_unsure_standby_referred, Case) :-
    full_profile(true, unsure, other_worker, true, true, no_derogation, Profile),
    standby_rota(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_standby_counted_exceeded, Case) :-
    full_profile(true, true, other_worker, true, true, no_derogation, Profile),
    standby_rota(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_standby_not_counted_kept, Case) :-
    full_profile(true, false, other_worker, true, true, no_derogation, Profile),
    standby_rota(Shifts),
    hazardous_day_case(Profile, Shifts, Case).
night_work_profile_for(hazardous_float_worker_problem, hazardous_case(Profile, worker(3), Shifts, date(2026, 3, 2), date(2026, 3, 2))) :-
    stated_profile(other_worker, true, true, no_derogation, Profile),
    long_night(Shifts).

standby_rota([shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 8, 0), on_call_standby)]).

night_work_assess(Subject, Result) :-
    night_work_profile_for(Subject, Case),
    decide_night_work(Case, Result).
