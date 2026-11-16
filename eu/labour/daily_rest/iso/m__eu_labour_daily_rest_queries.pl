% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_queries, [daily_rest_profile_keys/1, daily_rest_what_if/4, daily_rest_given/0, daily_rest_not_given/0, daily_rest_not_applied_to_worker/0, daily_rest_derogation_applies/0, no_work_start_in_period/0, no_window_without_daily_rest/0, date_time/5, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, on_call_on_site_counts_as_working_time/0, on_call_standby_counts_as_working_time/0, worker_category/0, derogation_from_article_3/0, other_worker/0, mobile_worker/0, seagoing_fishing_vessel_worker/0, no_derogation/0, derogation_under_article_17_1/0, derogation_under_article_17_3/0, derogation_under_article_17_4/0, derogation_under_article_18/0, work/0, on_call_on_site/0, on_call_standby/0, paid_annual_leave/0, sick_leave/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2]).
:- use_module(m__eu_labour_daily_rest_daily_rest, [daily_rest_status/7]).

daily_rest_profile_keys([on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, worker_category, derogation_from_article_3]).

date_time(Year, Month, DayOfMonth, HourOfDay, MinuteOfHour) :-
    integer(Year),
    integer(Month),
    integer(DayOfMonth),
    integer(HourOfDay),
    integer(MinuteOfHour),
    Year #>= 1,
    Year #< 10000,
    Month #>= 1,
    Month #< 13,
    month_last_day(Year, Month, LastDayOfMonth),
    DayOfMonth #>= 1,
    DayOfMonth #=< LastDayOfMonth,
    HourOfDay #>= 0,
    HourOfDay #< 24,
    MinuteOfHour #>= 0,
    MinuteOfHour #< 60.

indeterminate([Key]) :-
    daily_rest_profile_keys(Keys),
    memberd_t(Key, Keys, true).

open_textured(Key, cite(eu_dir_2003_88_art_2_1)) :-
    memberd_t(Key, [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time], true).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) :-
    open_textured(Key, Citation),
    inputs_relied_on(Pairs).
needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs), provenance(Clause, Citations)]) :-
    open_textured(Key, Citation),
    inputs_relied_on(Pairs),
    provenance(Clause, Citations).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

input_problems([Problem|Problems]) :-
    nonvar(Problem),
    is_list(Problems).

unknown_key(Key) :-
    daily_rest_profile_keys(Keys),
    not_member(Key, Keys).

wrong_type(Key) :-
    daily_rest_profile_keys(ProfileKeys),
    append([profile, worker, shifts, period_start, period_end], ProfileKeys, CheckedNames),
    memberd_t(Key, CheckedNames, true).

duplicate_key(Key) :-
    daily_rest_profile_keys(Keys),
    memberd_t(Key, Keys, true).

daily_rest_what_if(case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), OverriddenKey, NewValue, daily_rest_verdict(Result, Citations)) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    daily_rest_status(Hypothesis, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

override_attribute(Profile, Key, Value, Hypothesis) :-
    exclude(attribute_has_key(Key), Profile, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

attribute_has_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

daily_rest_given.

daily_rest_not_given.

daily_rest_not_applied_to_worker.

daily_rest_derogation_applies.

no_work_start_in_period.

no_window_without_daily_rest.

on_call_on_site_counts_as_working_time.

on_call_standby_counts_as_working_time.

worker_category.

derogation_from_article_3.

other_worker.

mobile_worker.

seagoing_fishing_vessel_worker.

no_derogation.

derogation_under_article_17_1.

derogation_under_article_17_3.

derogation_under_article_17_4.

derogation_under_article_18.

work.

on_call_on_site.

on_call_standby.

paid_annual_leave.

sick_leave.

unsure.

ordinary_profile([attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)]).

short_rest_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 20, 0), work), shift(w1, date_time(2026, 3, 3, 4, 0), date_time(2026, 3, 3, 12, 0), work)]).

on_call_on_site_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 22, 0), on_call_on_site), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

test(the_profile_keys_are_in_contract_order) :-
    daily_rest_profile_keys([on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, worker_category, derogation_from_article_3]).
test(what_if_a_derogation_is_stated) :-
    ordinary_profile(Profile),
    short_rest_shifts(Shifts),
    daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), derogation_from_article_3, derogation_under_article_17_4, daily_rest_verdict(daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_4)])).
test(what_if_no_derogation_is_stated_the_rest_is_not_given) :-
    ordinary_profile(Profile),
    short_rest_shifts(Shifts),
    daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), derogation_from_article_3, no_derogation, daily_rest_verdict(daily_rest_not_given, _)).
test(what_if_the_worker_is_mobile) :-
    ordinary_profile(Profile),
    short_rest_shifts(Shifts),
    findall(Verdict, daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), worker_category, mobile_worker, Verdict), Verdicts),
    Verdicts == [daily_rest_verdict(daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)])].
test(what_if_on_call_on_site_counts) :-
    ordinary_profile(Profile),
    on_call_on_site_shifts(Shifts),
    daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), on_call_on_site_counts_as_working_time, true, daily_rest_verdict(daily_rest_not_given, _)).
test(what_if_on_call_on_site_does_not_count) :-
    ordinary_profile(Profile),
    on_call_on_site_shifts(Shifts),
    daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), on_call_on_site_counts_as_working_time, false, daily_rest_verdict(daily_rest_given, _)).
test(the_override_replaces_every_attribute_of_the_key) :-
    override_attribute([attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], worker_category, mobile_worker, Hypothesis),
    Hypothesis == [attribute(derogation_from_article_3, no_derogation), attribute(worker_category, mobile_worker)].
test(the_result_atoms_are_served) :-
    daily_rest_given,
    daily_rest_not_given,
    daily_rest_not_applied_to_worker,
    daily_rest_derogation_applies,
    no_work_start_in_period,
    no_window_without_daily_rest.
test(the_result_constructors_are_served) :-
    date_time(2026, 3, 2, 8, 0),
    indeterminate([worker_category]),
    open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)),
    inputs_relied_on([on_call_on_site_counts_as_working_time - unsure]),
    needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]),
    provenance(daily_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)]),
    input_problems([wrong_type(worker)]),
    unknown_key(colour),
    wrong_type(period_end),
    duplicate_key(derogation_from_article_3).

test(what_if_on_call_on_site_does_not_count_is_not_short, fail) :-
    ordinary_profile(Profile),
    on_call_on_site_shifts(Shifts),
    daily_rest_what_if(case(Profile, w1, Shifts, date(2026, 3, 2), date(2026, 3, 3)), on_call_on_site_counts_as_working_time, false, daily_rest_verdict(daily_rest_not_given, _)).
test(an_unreal_day_is_not_a_date_time, fail) :-
    date_time(2026, 2, 30, 8, 0).
test(an_open_texture_of_a_category_key_is_not_well_shaped, fail) :-
    open_textured(worker_category, cite(eu_dir_2003_88_art_2_1)).
