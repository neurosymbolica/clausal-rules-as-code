% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_queries, [night_work_profile_keys/1, night_work_what_if/4, night_work_block_limit_minutes/2, night_work_span_working_minutes/6, on_call_on_site_counts_as_working_time/0, on_call_standby_counts_as_working_time/0, night_time_start/0, night_time_end/0, night_work_reference_period_days/0, worker_category/0, night_worker/0, special_hazards_or_heavy_strain/0, derogation_from_article_8/0, other_worker/0, mobile_worker/0, seagoing_fishing_vessel_worker/0, no_derogation/0, derogation_under_article_17_1/0, derogation_under_article_17_3/0, derogation_under_article_18/0, work/0, on_call_on_site/0, on_call_standby/0, paid_annual_leave/0, sick_leave/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(m__eu_labour_night_work_kernel, [night_work_input_problems/2]).
:- use_module(m__eu_labour_night_work_citations, [implements/1]).
:- use_module(m__eu_labour_night_work_night_work, [night_work_status/2]).

on_call_on_site_counts_as_working_time.

on_call_standby_counts_as_working_time.

night_time_start.

night_time_end.

night_work_reference_period_days.

worker_category.

night_worker.

special_hazards_or_heavy_strain.

derogation_from_article_8.

other_worker.

mobile_worker.

seagoing_fishing_vessel_worker.

no_derogation.

derogation_under_article_17_1.

derogation_under_article_17_3.

derogation_under_article_18.

work.

on_call_on_site.

on_call_standby.

paid_annual_leave.

sick_leave.

unsure.

night_work_profile_keys([on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, night_time_start, night_time_end, night_work_reference_period_days, worker_category, night_worker, special_hazards_or_heavy_strain, derogation_from_article_8]).

night_work_what_if(Case, OverriddenKey, NewValue, NewStatus) :-
    case_with_profile(Case, Profile, Hypothesis, HypotheticalCase),
    profile_override(Profile, OverriddenKey, NewValue, Hypothesis),
    night_work_status(HypotheticalCase, NewStatus).

case_with_profile(average_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), Profile, Hypothesis, average_case(Hypothesis, Worker, Shifts, PeriodStart, PeriodEnd)).
case_with_profile(hazardous_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), Profile, Hypothesis, hazardous_case(Hypothesis, Worker, Shifts, PeriodStart, PeriodEnd)).

profile_override([], Key, Value, [attribute(Key, Value)]).
profile_override([attribute(ElementKey, _)|Elements], Key, Value, Overridden) :-
    ElementKey == Key,
    profile_override(Elements, Key, Value, Overridden).
profile_override([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Overridden]) :-
    ElementKey \== Key,
    profile_override(Elements, Key, Value, Overridden).

night_work_block_limit_minutes(BlockDays, LimitMinutes) :-
    implements(eu_dir_2003_88_art_16_final_subpara),
    BlockDays #>= 1,
    Divisor #= BlockDays - BlockDays // 7,
    LimitMinutes #= 480 * Divisor.

night_work_span_working_minutes(Worker, Shifts, CountedKinds, SpanStart, SpanEnd, WorkingMinutes) :-
    implements(eu_dir_2003_88_art_2_1),
    span_anchor(SpanStart, Anchor),
    minute_offset(SpanStart, Anchor, SpanLow),
    minute_offset(SpanEnd, Anchor, SpanHigh),
    findall(Minutes, (member(shift(Identity, StartTime, EndTime, Kind), Shifts), Identity == Worker, memberd_t(Kind, CountedKinds, true), minute_offset(StartTime, Anchor, Start), minute_offset(EndTime, Anchor, End), Low #= max(Start, SpanLow), High #= min(End, SpanHigh), overlap_minutes(Low, High, Minutes)), Portions),
    sum_list(Portions, WorkingMinutes).

span_anchor(date_time(Year, Month, Day, _, _), date(Year, Month, Day)).

minute_offset(date_time(Year, Month, Day, Hour, MinuteOfHour), Anchor, Offset) :-
    days_between(date(Year, Month, Day), Anchor, Days),
    Offset #= Days * 1440 + Hour * 60 + MinuteOfHour.

overlap_minutes(Low, High, Minutes) :-
    implements(eu_dir_2003_88_art_2_1),
    Low #< High,
    Minutes #= High - Low.
overlap_minutes(Low, High, 0) :-
    implements(eu_dir_2003_88_art_2_1),
    Low #>= High.

sample_hazardous_case(hazardous_case([attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_time_start, 1320), attribute(night_time_end, 300), attribute(night_work_reference_period_days, 7), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, true), attribute(derogation_from_article_8, no_derogation)], worker_1, [shift(worker_1, date_time(2026, 3, 2, 21, 59), date_time(2026, 3, 3, 6, 0), work)], date(2026, 3, 2), date(2026, 3, 2))).

test(the_profile_keys_are_the_nine_contract_keys) :-
    night_work_profile_keys(Keys),
    length(Keys, 9).
test(the_root_export_atoms_hold) :-
    unsure,
    work,
    other_worker,
    no_derogation,
    night_worker.
test(what_if_keeping_the_stated_value_exceeds) :-
    sample_hazardous_case(Case),
    night_work_what_if(Case, derogation_from_article_8, no_derogation, hazardous_night_work_hours_exceeded).
test(what_if_without_special_hazards) :-
    sample_hazardous_case(Case),
    night_work_what_if(Case, special_hazards_or_heavy_strain, false, no_special_hazards_or_heavy_strain).
test(what_if_a_derogation_under_article_18) :-
    sample_hazardous_case(Case),
    night_work_what_if(Case, derogation_from_article_8, derogation_under_article_18, night_work_derogation_applies).
test(what_if_a_mobile_worker) :-
    sample_hazardous_case(Case),
    night_work_what_if(Case, worker_category, mobile_worker, night_work_limits_not_applied_to_worker).
test(a_seven_day_block_holds_2880_minutes) :-
    night_work_block_limit_minutes(7, 2880).
test(a_six_day_block_also_holds_2880_minutes) :-
    night_work_block_limit_minutes(6, 2880).
test(a_fourteen_day_block_holds_5760_minutes) :-
    night_work_block_limit_minutes(14, 5760).
test(a_one_day_block_holds_480_minutes) :-
    night_work_block_limit_minutes(1, 480).
test(working_minutes_are_cut_at_the_span) :-
    night_work_span_working_minutes(worker_1, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work), shift(worker_2, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(worker_1, date_time(2026, 3, 3, 10, 0), date_time(2026, 3, 3, 12, 0), paid_annual_leave)], [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), 120).
test(working_minutes_over_two_days_are_exact) :-
    night_work_span_working_minutes(worker_1, [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 1), work), shift(worker_1, date_time(2026, 3, 3, 10, 0), date_time(2026, 3, 3, 12, 0), paid_annual_leave)], [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), 481).

test(what_if_without_special_hazards_is_not_exceeded, fail) :-
    sample_hazardous_case(Case),
    night_work_what_if(Case, special_hazards_or_heavy_strain, false, hazardous_night_work_hours_exceeded).
test(a_zero_day_block_has_no_limit, fail) :-
    night_work_block_limit_minutes(0, _).
