% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [weekly_limit_status/7, weekly_working_time_average/6, required_reduction_minutes/6, within_weekly_limit/0, over_weekly_limit/0, weekly_limit_not_applied_by_agreement/0, reference_period_longer_than_allowed/0, no_countable_period/0, decide_working_time_weekly_limit/2, working_time_weekly_limit_status/2, working_time_weekly_limit_checklist/2, working_time_weekly_limit_decision_resolvable/1, working_time_weekly_limit_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_citations, [implements/1]).

reference_period_ceiling(member_state_reference_period, 4, cite(eu_dir_2003_88_art_16_b)).
reference_period_ceiling(derogation_under_article_17_3_or_article_18, 6, cite(eu_dir_2003_88_art_19_first_subpara)).
reference_period_ceiling(collective_agreement_under_article_19, 12, cite(eu_dir_2003_88_art_19_second_subpara)).
reference_period_ceiling(offshore_work_under_article_20_2, 12, cite(eu_dir_2003_88_art_20_2)).

within_weekly_limit.

over_weekly_limit.

weekly_limit_not_applied_by_agreement.

reference_period_longer_than_allowed.

no_countable_period.

working_time_weekly_limit_status_values([within_weekly_limit, over_weekly_limit, weekly_limit_not_applied_by_agreement, reference_period_longer_than_allowed, no_countable_period]).

weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    all_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems),
    status_after_check(Problems, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

status_after_check([Problem|Problems], _, _, _, _, _, input_problems([Problem|Problems]), []).
status_after_check([], Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    period_dating(PeriodStart, PeriodEnd, Dating),
    status_by_dating(Dating, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

status_by_dating(undated, _, _, _, _, _, no_countable_period, [cite(eu_dir_2003_88_art_16_b)]) :-
    implements(eu_dir_2003_88_art_16_b).
status_by_dating(dated, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    period_class(PeriodStart, PeriodEnd, PeriodClass),
    key_reading(Profile, reference_period_basis, BasisReading),
    period_gate(PeriodClass, BasisReading, PeriodGate),
    status_after_period(PeriodGate, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

status_after_period(decided(Result, Citations), _, _, _, _, _, Result, Citations).
status_after_period(proceed, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    period_figures(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Figures),
    countable_route(Figures, Profile, Result, Citations).

period_gate(beyond_twelve_months, _, decided(reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara), cite(eu_dir_2003_88_art_19_second_subpara), cite(eu_dir_2003_88_art_20_2)])) :-
    implements(eu_dir_2003_88_art_19_second_subpara).
period_gate(beyond_six_months, absent, decided(indeterminate([reference_period_basis]), [])) :-
    implements(eu_dir_2003_88_art_16_b).
period_gate(beyond_four_months, absent, decided(indeterminate([reference_period_basis]), [])) :-
    implements(eu_dir_2003_88_art_16_b).
period_gate(beyond_six_months, present(member_state_reference_period), decided(reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b)])) :-
    implements(eu_dir_2003_88_art_16_b).
period_gate(beyond_four_months, present(member_state_reference_period), decided(reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b)])) :-
    implements(eu_dir_2003_88_art_16_b).
period_gate(beyond_six_months, present(derogation_under_article_17_3_or_article_18), decided(reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara)])) :-
    implements(eu_dir_2003_88_art_19_first_subpara).
period_gate(beyond_four_months, present(derogation_under_article_17_3_or_article_18), proceed) :-
    implements(eu_dir_2003_88_art_19_first_subpara).
period_gate(beyond_six_months, present(collective_agreement_under_article_19), proceed) :-
    implements(eu_dir_2003_88_art_19_second_subpara).
period_gate(beyond_four_months, present(collective_agreement_under_article_19), proceed) :-
    implements(eu_dir_2003_88_art_19_second_subpara).
period_gate(beyond_six_months, present(offshore_work_under_article_20_2), proceed) :-
    implements(eu_dir_2003_88_art_20_2).
period_gate(beyond_four_months, present(offshore_work_under_article_20_2), proceed) :-
    implements(eu_dir_2003_88_art_20_2).
period_gate(within_four_months, _, proceed) :-
    implements(eu_dir_2003_88_art_16_b).

countable_route(figures(Countable, _, _, _, _, _, _), _, no_countable_period, [cite(eu_dir_2003_88_art_16_b)]) :-
    implements(eu_dir_2003_88_art_16_b),
    Countable #= 0.
countable_route(Figures, Profile, Result, Citations) :-
    implements(eu_dir_2003_88_art_16_b),
    Figures = figures(Countable, _, _, _, _, _, _),
    Countable #> 0,
    limit_route(Figures, Profile, Result, Citations).

limit_route(figures(Countable, _, CountedHigh, _, _, _, _), _, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]) :-
    implements(eu_dir_2003_88_art_6_b),
    limit_side(CountedHigh, Countable, within).
limit_route(Figures, Profile, Result, Citations) :-
    implements(eu_dir_2003_88_art_6_b),
    Figures = figures(Countable, CountedLow, CountedHigh, _, _, _, _),
    limit_side(CountedHigh, Countable, over),
    limit_side(CountedLow, Countable, within),
    turning_route(Figures, Profile, Result, Citations).
limit_route(figures(Countable, CountedLow, _, _, _, _, _), Profile, Result, Citations) :-
    implements(eu_dir_2003_88_art_6_b),
    limit_side(CountedLow, Countable, over),
    key_reading(Profile, member_state_uses_article_22_option, OptionReading),
    key_reading(Profile, worker_agreement_to_exceed_obtained_first, AgreementReading),
    over_route(OptionReading, AgreementReading, Result, Citations).

over_route(present(false), _, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]) :-
    implements(eu_dir_2003_88_art_6_b).
over_route(present(true), present(false), over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]) :-
    implements(eu_dir_2003_88_art_22_1_a).
over_route(absent, present(false), over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]) :-
    implements(eu_dir_2003_88_art_22_1_a).
over_route(absent, present(true), indeterminate([member_state_uses_article_22_option]), []) :-
    implements(eu_dir_2003_88_art_22_1).
over_route(absent, absent, indeterminate([member_state_uses_article_22_option]), []) :-
    implements(eu_dir_2003_88_art_22_1).
over_route(present(true), absent, indeterminate([worker_agreement_to_exceed_obtained_first]), []) :-
    implements(eu_dir_2003_88_art_22_1_a).
over_route(present(true), present(true), weekly_limit_not_applied_by_agreement, [cite(eu_dir_2003_88_art_22_1), cite(eu_dir_2003_88_art_22_1_a)]) :-
    implements(eu_dir_2003_88_art_22_1).

turning_route(figures(Countable, CountedLow, _, OnSiteState, OnSiteMinutes, StandbyState, StandbyMinutes), Profile, Result, Citations) :-
    implements(eu_dir_2003_88_art_2_1),
    unresolved_truth(OnSiteState, OnSiteUnresolved),
    unresolved_truth(StandbyState, StandbyUnresolved),
    matters_truth(OnSiteMinutes, StandbyUnresolved, StandbyMinutes, CountedLow, Countable, OnSiteMatters),
    matters_truth(StandbyMinutes, OnSiteUnresolved, OnSiteMinutes, CountedLow, Countable, StandbyMatters),
    kind_class(OnSiteState, OnSiteMatters, OnSiteClass),
    kind_class(StandbyState, StandbyMatters, StandbyClass),
    step_five_route(OnSiteClass, StandbyClass, StepRoute),
    step_five_answer(StepRoute, Profile, Result, Citations).

unresolved_truth(counted, false).
unresolved_truth(not_counted, false).
unresolved_truth(absent, true).
unresolved_truth(unsure, true).

matters_truth(OwnMinutes, OtherUnresolved, OtherMinutes, CountedLow, Countable, Truth) :-
    implements(eu_dir_2003_88_art_6_b),
    AloneMinutes #= CountedLow + OwnMinutes,
    OtherFirstMinutes #= CountedLow + OtherMinutes,
    TogetherMinutes #= CountedLow + OtherMinutes + OwnMinutes,
    limit_side(AloneMinutes, Countable, AloneSide),
    limit_side(OtherFirstMinutes, Countable, OtherFirstSide),
    limit_side(TogetherMinutes, Countable, TogetherSide),
    matters_from(AloneSide, OtherUnresolved, OtherFirstSide, TogetherSide, Truth).

matters_from(over, _, _, _, true).
matters_from(within, true, within, over, true).
matters_from(within, true, within, within, false).
matters_from(within, true, over, _, false).
matters_from(within, false, _, _, false).

kind_class(absent, true, absent_matters).
kind_class(absent, false, quiet).
kind_class(unsure, true, unsure_matters).
kind_class(unsure, false, quiet).
kind_class(counted, _, quiet).
kind_class(not_counted, _, quiet).

step_five_route(absent_matters, _, absent_key(on_call_on_site_counts_as_working_time)).
step_five_route(unsure_matters, absent_matters, absent_key(on_call_standby_counts_as_working_time)).
step_five_route(quiet, absent_matters, absent_key(on_call_standby_counts_as_working_time)).
step_five_route(unsure_matters, unsure_matters, unsure_key(on_call_on_site_counts_as_working_time)).
step_five_route(unsure_matters, quiet, unsure_key(on_call_on_site_counts_as_working_time)).
step_five_route(quiet, unsure_matters, unsure_key(on_call_standby_counts_as_working_time)).

step_five_answer(absent_key(KeyName), _, indeterminate([KeyName]), []).
step_five_answer(unsure_key(KeyName), Profile, Result, []) :-
    key_reading(Profile, member_state_uses_article_22_option, OptionReading),
    key_reading(Profile, worker_agreement_to_exceed_obtained_first, AgreementReading),
    review_gate(OptionReading, AgreementReading, ReviewGate),
    gate_result(ReviewGate, KeyName, Profile, Result).

review_gate(absent, absent, ask(member_state_uses_article_22_option)) :-
    implements(eu_dir_2003_88_art_22_1).
review_gate(absent, present(true), ask(member_state_uses_article_22_option)) :-
    implements(eu_dir_2003_88_art_22_1).
review_gate(absent, present(false), refer) :-
    implements(eu_dir_2003_88_art_22_1_a).
review_gate(present(true), absent, ask(worker_agreement_to_exceed_obtained_first)) :-
    implements(eu_dir_2003_88_art_22_1_a).
review_gate(present(true), present(true), refer) :-
    implements(eu_dir_2003_88_art_22_1_a).
review_gate(present(true), present(false), refer) :-
    implements(eu_dir_2003_88_art_22_1_a).
review_gate(present(false), _, refer) :-
    implements(eu_dir_2003_88_art_22_1).

gate_result(ask(KeyName), _, _, indeterminate([KeyName])).
gate_result(refer, KeyName, Profile, needs_legal_review(open_textured(KeyName, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2003_88_art_2_1),
    judgement_pairs(Profile, Pairs).

weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average) :-
    all_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems),
    average_after_check(Problems, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average).

average_after_check([Problem|Problems], _, _, _, _, _, input_problems([Problem|Problems])).
average_after_check([], Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average) :-
    period_dating(PeriodStart, PeriodEnd, Dating),
    average_by_dating(Dating, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average).

average_by_dating(undated, _, _, _, _, _, no_countable_period) :-
    implements(eu_dir_2003_88_art_16_b).
average_by_dating(dated, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average) :-
    period_figures(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Figures),
    average_answer(Figures, Profile, Average).

average_answer(figures(Countable, _, _, _, _, _, _), _, no_countable_period) :-
    implements(eu_dir_2003_88_art_16_b),
    Countable #= 0.
average_answer(figures(Countable, CountedLow, _, OnSiteState, _, StandbyState, _), Profile, Average) :-
    implements(eu_dir_2003_88_art_2_1),
    Countable #> 0,
    on_call_route(OnSiteState, StandbyState, CallRoute),
    average_from_route(CallRoute, Profile, CountedLow, Countable, Average).

average_from_route(missing(KeyName), _, _, _, indeterminate([KeyName])).
average_from_route(review(KeyName), Profile, _, _, needs_legal_review(open_textured(KeyName, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2003_88_art_2_1),
    judgement_pairs(Profile, Pairs).
average_from_route(resolved, _, Counted, Countable, minutes_per_seven_days(Numerator, Denominator)) :-
    implements(eu_dir_2003_88_art_6_b),
    exact_average(Counted, Countable, Numerator, Denominator).

on_call_route(absent, _, missing(on_call_on_site_counts_as_working_time)).
on_call_route(OnSiteState, absent, missing(on_call_standby_counts_as_working_time)) :-
    member(OnSiteState, [counted, not_counted, unsure]).
on_call_route(unsure, StandbyState, review(on_call_on_site_counts_as_working_time)) :-
    member(StandbyState, [counted, not_counted, unsure]).
on_call_route(OnSiteState, unsure, review(on_call_standby_counts_as_working_time)) :-
    member(OnSiteState, [counted, not_counted]).
on_call_route(OnSiteState, StandbyState, resolved) :-
    member(OnSiteState, [counted, not_counted]),
    member(StandbyState, [counted, not_counted]).

exact_average(Counted, Countable, Numerator, Denominator) :-
    implements(eu_dir_2003_88_art_6_b),
    WeightedMinutes #= Counted * 10080,
    common_divisor(WeightedMinutes, Countable, Divisor),
    Numerator #= WeightedMinutes // Divisor,
    Denominator #= Countable // Divisor.

common_divisor(First, 0, First).
common_divisor(First, Second, Divisor) :-
    Second #> 0,
    Remainder #= First mod Second,
    common_divisor(Second, Remainder, Divisor).

required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes) :-
    all_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems),
    reduction_after_check(Problems, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

reduction_after_check([Problem|Problems], _, _, _, _, _, input_problems([Problem|Problems])).
reduction_after_check([], Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes) :-
    period_dating(PeriodStart, PeriodEnd, Dating),
    reduction_by_dating(Dating, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

reduction_by_dating(undated, _, _, _, _, _, no_countable_period) :-
    implements(eu_dir_2003_88_art_16_b).
reduction_by_dating(dated, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes) :-
    period_figures(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Figures),
    reduction_answer(Figures, Profile, Minutes).

reduction_answer(figures(Countable, _, _, _, _, _, _), _, no_countable_period) :-
    implements(eu_dir_2003_88_art_16_b),
    Countable #= 0.
reduction_answer(figures(Countable, _, CountedHigh, _, _, _, _), _, 0) :-
    implements(eu_dir_2003_88_art_6_b),
    Countable #> 0,
    limit_side(CountedHigh, Countable, within).
reduction_answer(figures(Countable, CountedLow, CountedHigh, OnSiteState, _, StandbyState, _), Profile, Minutes) :-
    implements(eu_dir_2003_88_art_6_b),
    Countable #> 0,
    limit_side(CountedHigh, Countable, over),
    on_call_route(OnSiteState, StandbyState, CallRoute),
    reduction_from_route(CallRoute, Profile, CountedLow, Countable, Minutes).

reduction_from_route(missing(KeyName), _, _, _, indeterminate([KeyName])).
reduction_from_route(review(KeyName), Profile, _, _, needs_legal_review(open_textured(KeyName, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2003_88_art_2_1),
    judgement_pairs(Profile, Pairs).
reduction_from_route(resolved, _, Counted, Countable, Minutes) :-
    implements(eu_dir_2003_88_art_6_b),
    weekly_limit_boundary(Countable, threshold(counted_working_minutes, MaximumMinutes, _)),
    Minutes #= Counted - MaximumMinutes.

weekly_limit_boundary(Countable, threshold(counted_working_minutes, MaximumMinutes, cite(eu_dir_2003_88_art_6_b))) :-
    implements(eu_dir_2003_88_art_6_b),
    MaximumMinutes #= 2880 * Countable // 10080.

limit_side(Counted, Countable, within) :-
    implements(eu_dir_2003_88_art_6_b),
    Counted * 10080 #=< 2880 * Countable.
limit_side(Counted, Countable, over) :-
    implements(eu_dir_2003_88_art_6_b),
    Counted * 10080 #> 2880 * Countable.

period_figures(Profile, Worker, Shifts, PeriodStart, PeriodEnd, figures(Countable, CountedLow, CountedHigh, OnSiteState, OnSiteMinutes, StandbyState, StandbyMinutes)) :-
    implements(eu_dir_2003_88_art_2_1),
    period_stamps(PeriodStart, PeriodEnd, PeriodStartStamp, PeriodEndStamp),
    kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, work, WorkMinutes),
    kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, on_call_on_site, OnSiteMinutes),
    kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, on_call_standby, StandbyMinutes),
    kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, paid_annual_leave, LeaveMinutes),
    kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, sick_leave, SickLeaveMinutes),
    countable_minutes(PeriodStartStamp, PeriodEndStamp, LeaveMinutes, SickLeaveMinutes, Countable),
    key_reading(Profile, on_call_on_site_counts_as_working_time, OnSiteReading),
    key_reading(Profile, on_call_standby_counts_as_working_time, StandbyReading),
    on_call_state(OnSiteReading, OnSiteMinutes, OnSiteState),
    on_call_state(StandbyReading, StandbyMinutes, StandbyState),
    counted_minutes(WorkMinutes, OnSiteState, OnSiteMinutes, StandbyState, StandbyMinutes, CountedLow, CountedHigh).

period_stamps(PeriodStart, PeriodEnd, PeriodStartStamp, PeriodEndStamp) :-
    implements(eu_dir_2003_88_art_16_b),
    day_number(PeriodStart, StartDayNumber),
    day_number(PeriodEnd, EndDayNumber),
    PeriodStartStamp #= StartDayNumber * 1440,
    PeriodEndStamp #= (EndDayNumber + 1) * 1440.

kind_minutes(Worker, Shifts, PeriodStartStamp, PeriodEndStamp, ShiftKind, KindMinutes) :-
    implements(eu_dir_2003_88_art_16_b),
    findall(PartMinutes, (member(shift(WorkerIdentifier, ShiftStart, ShiftEnd, ShiftKind), Shifts), WorkerIdentifier == Worker, shift_part_minutes(ShiftStart, ShiftEnd, PeriodStartStamp, PeriodEndStamp, PartMinutes)), Parts),
    sum_list(Parts, KindMinutes).

shift_part_minutes(ShiftStart, ShiftEnd, PeriodStartStamp, PeriodEndStamp, PartMinutes) :-
    implements(eu_dir_2003_88_art_16_b),
    minute_stamp(ShiftStart, ShiftStartStamp),
    minute_stamp(ShiftEnd, ShiftEndStamp),
    PartMinutes #= max(0, min(ShiftEndStamp, PeriodEndStamp) - max(ShiftStartStamp, PeriodStartStamp)).

countable_minutes(PeriodStartStamp, PeriodEndStamp, LeaveMinutes, SickLeaveMinutes, Countable) :-
    implements(eu_dir_2003_88_art_16_b),
    Countable #= PeriodEndStamp - PeriodStartStamp - LeaveMinutes - SickLeaveMinutes.

on_call_state(present(true), _, counted) :-
    implements(eu_dir_2003_88_art_2_1).
on_call_state(present(false), _, not_counted) :-
    implements(eu_dir_2003_88_art_2_1).
on_call_state(present(unsure), KindMinutes, unsure) :-
    implements(eu_dir_2003_88_art_2_1),
    KindMinutes #> 0.
on_call_state(present(unsure), KindMinutes, not_counted) :-
    implements(eu_dir_2003_88_art_2_1),
    KindMinutes #= 0.
on_call_state(absent, KindMinutes, absent) :-
    implements(eu_dir_2003_88_art_2_1),
    KindMinutes #> 0.
on_call_state(absent, KindMinutes, not_counted) :-
    implements(eu_dir_2003_88_art_2_1),
    KindMinutes #= 0.

counted_minutes(WorkMinutes, OnSiteState, OnSiteMinutes, StandbyState, StandbyMinutes, CountedLow, CountedHigh) :-
    implements(eu_dir_2003_88_art_2_1),
    low_share(OnSiteState, OnSiteMinutes, OnSiteLow),
    low_share(StandbyState, StandbyMinutes, StandbyLow),
    high_share(OnSiteState, OnSiteMinutes, OnSiteHigh),
    high_share(StandbyState, StandbyMinutes, StandbyHigh),
    CountedLow #= WorkMinutes + OnSiteLow + StandbyLow,
    CountedHigh #= WorkMinutes + OnSiteHigh + StandbyHigh.

low_share(counted, KindMinutes, KindMinutes).
low_share(not_counted, _, 0).
low_share(absent, _, 0).
low_share(unsure, _, 0).

high_share(counted, KindMinutes, KindMinutes).
high_share(not_counted, _, 0).
high_share(absent, KindMinutes, KindMinutes).
high_share(unsure, KindMinutes, KindMinutes).

day_number(date(CalendarYear, CalendarMonth, CalendarDay), DayNumber) :-
    days_between(date(CalendarYear, CalendarMonth, CalendarDay), date(1, 1, 1), DayNumber).

minute_stamp(date_time(CalendarYear, CalendarMonth, CalendarDay, HourOfDay, MinuteOfHour), MinuteStamp) :-
    day_number(date(CalendarYear, CalendarMonth, CalendarDay), DayNumber),
    MinuteStamp #= DayNumber * 1440 + HourOfDay * 60 + MinuteOfHour.

months_after_day_number(date(StartYear, StartMonth, StartDay), Months, DayNumber) :-
    implements(eu_dir_2003_88_art_16_b),
    MonthIndex #= StartYear * 12 + StartMonth - 1 + Months,
    TargetYear #= MonthIndex // 12,
    TargetMonth #= MonthIndex mod 12 + 1,
    month_last_day(TargetYear, TargetMonth, LastDay),
    TargetDay #= min(StartDay, LastDay),
    day_number(date(TargetYear, TargetMonth, TargetDay), DayNumber).

period_class(PeriodStart, PeriodEnd, PeriodClass) :-
    implements(eu_dir_2003_88_art_16_b),
    reference_period_ceiling(member_state_reference_period, FourMonths, _),
    reference_period_ceiling(derogation_under_article_17_3_or_article_18, SixMonths, _),
    reference_period_ceiling(collective_agreement_under_article_19, TwelveMonths, _),
    months_after_day_number(PeriodStart, FourMonths, FourMonthDay),
    months_after_day_number(PeriodStart, SixMonths, SixMonthDay),
    months_after_day_number(PeriodStart, TwelveMonths, TwelveMonthDay),
    day_number(PeriodEnd, EndDayNumber),
    NextDayNumber #= EndDayNumber + 1,
    ceiling_class(NextDayNumber, FourMonthDay, SixMonthDay, TwelveMonthDay, PeriodClass).

ceiling_class(NextDayNumber, _, _, TwelveMonthDay, beyond_twelve_months) :-
    NextDayNumber #> TwelveMonthDay.
ceiling_class(NextDayNumber, _, SixMonthDay, TwelveMonthDay, beyond_six_months) :-
    NextDayNumber #> SixMonthDay,
    NextDayNumber #=< TwelveMonthDay.
ceiling_class(NextDayNumber, FourMonthDay, SixMonthDay, _, beyond_four_months) :-
    NextDayNumber #> FourMonthDay,
    NextDayNumber #=< SixMonthDay.
ceiling_class(NextDayNumber, FourMonthDay, _, _, within_four_months) :-
    NextDayNumber #=< FourMonthDay.

period_dating(PeriodStart, PeriodEnd, Dating) :-
    holds_truth(calendar_date(PeriodStart), StartReal),
    holds_truth(calendar_date(PeriodEnd), EndReal),
    dating_from(StartReal, EndReal, Dating).

dating_from(true, true, dated).
dating_from(true, false, undated).
dating_from(false, _, undated).

key_reading(Profile, KeyName, absent) :-
    profile_lacks(Profile, KeyName).
key_reading(Profile, KeyName, present(Value)) :-
    profile_has(Profile, KeyName),
    profile_get(Profile, KeyName, Value).

judgement_pairs(Profile, Pairs) :-
    key_reading(Profile, on_call_on_site_counts_as_working_time, OnSiteReading),
    key_reading(Profile, on_call_standby_counts_as_working_time, StandbyReading),
    reading_pair(OnSiteReading, on_call_on_site_counts_as_working_time, OnSitePairs),
    reading_pair(StandbyReading, on_call_standby_counts_as_working_time, StandbyPairs),
    append(OnSitePairs, StandbyPairs, Pairs).

reading_pair(absent, _, []).
reading_pair(present(Value), KeyName, [KeyName - Value]).

all_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems) :-
    working_time_weekly_limit_input_problems(Profile, ProfileProblems),
    argument_problems(Worker, Shifts, PeriodStart, PeriodEnd, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems).

argument_problems(Worker, Shifts, PeriodStart, PeriodEnd, Problems) :-
    holds_truth(worker_value(Worker), WorkerTruth),
    shifts_truth(WorkerTruth, Shifts, Worker, ShiftsTruth),
    date_form(PeriodStart, StartForm),
    date_form(PeriodEnd, EndForm),
    form_truth(StartForm, StartTruth),
    period_end_truth(StartForm, EndForm, PeriodStart, PeriodEnd, EndTruth),
    flag_problem(WorkerTruth, wrong_type(worker), WorkerProblems),
    flag_problem(ShiftsTruth, wrong_type(shifts), ShiftsProblems),
    flag_problem(StartTruth, wrong_type(period_start), StartProblems),
    flag_problem(EndTruth, wrong_type(period_end), EndProblems),
    append([WorkerProblems, ShiftsProblems, StartProblems, EndProblems], Problems).

flag_problem(true, _, []).
flag_problem(false, Problem, [Problem]).

holds_truth(Goal, Truth) :-
    findall(found, Goal, Found),
    sort(Found, Distinct),
    found_truth(Distinct, Truth).

found_truth([], false).
found_truth([found], true).

negated_truth(true, false).
negated_truth(false, true).

shifts_truth(WorkerTruth, Shifts, Worker, Truth) :-
    holds_truth(shifts_well_formed(Shifts), FormedTruth),
    overlap_truth(FormedTruth, WorkerTruth, Shifts, Worker, Truth).

overlap_truth(false, _, _, _, false).
overlap_truth(true, false, _, _, true).
overlap_truth(true, true, Shifts, Worker, Truth) :-
    holds_truth(worker_shifts_overlap(Shifts, Worker), OverlapTruth),
    negated_truth(OverlapTruth, Truth).

date_form(Date, Form) :-
    holds_truth(calendar_date(Date), RealTruth),
    holds_truth(template_date(Date), TemplateTruth),
    form_from(RealTruth, TemplateTruth, Form).

form_from(true, _, real).
form_from(false, true, template).
form_from(false, false, bad).

form_truth(real, true).
form_truth(template, true).
form_truth(bad, false).

period_end_truth(_, bad, _, _, false).
period_end_truth(_, template, _, _, true).
period_end_truth(bad, real, _, _, true).
period_end_truth(template, real, _, _, true).
period_end_truth(real, real, PeriodStart, PeriodEnd, Truth) :-
    day_number(PeriodStart, StartDayNumber),
    day_number(PeriodEnd, EndDayNumber),
    order_truth(StartDayNumber, EndDayNumber, Truth).

order_truth(StartDayNumber, EndDayNumber, true) :-
    EndDayNumber #>= StartDayNumber.
order_truth(StartDayNumber, EndDayNumber, false) :-
    EndDayNumber #< StartDayNumber.

worker_value(Worker) :-
    atom(Worker).
worker_value(Worker) :-
    integer(Worker).

proper_list(Elements) :-
    Elements == [].
proper_list(Elements) :-
    nonvar(Elements),
    Elements = [_|Remaining],
    proper_list(Remaining).

shifts_well_formed(Shifts) :-
    proper_list(Shifts),
    maplist(valid_shift, Shifts).

valid_shift(Shift) :-
    nonvar(Shift),
    Shift = shift(WorkerIdentifier, ShiftStart, ShiftEnd, ShiftKind),
    worker_value(WorkerIdentifier),
    valid_date_time(ShiftStart),
    valid_date_time(ShiftEnd),
    minute_stamp(ShiftStart, ShiftStartStamp),
    minute_stamp(ShiftEnd, ShiftEndStamp),
    ShiftStartStamp #< ShiftEndStamp,
    shift_kind(ShiftKind).

shift_kind(ShiftKind) :-
    atom(ShiftKind),
    member(ShiftKind, [work, on_call_on_site, on_call_standby, paid_annual_leave, sick_leave]).

calendar_date(Date) :-
    nonvar(Date),
    Date = date(CalendarYear, CalendarMonth, CalendarDay),
    integer(CalendarYear),
    integer(CalendarMonth),
    integer(CalendarDay),
    valid_day(CalendarYear, CalendarMonth, CalendarDay).

template_date(Date) :-
    nonvar(Date),
    Date = date(CalendarYear, CalendarMonth, CalendarDay),
    atom(CalendarYear),
    atom(CalendarMonth),
    atom(CalendarDay).

valid_date_time(DateTime) :-
    nonvar(DateTime),
    DateTime = date_time(CalendarYear, CalendarMonth, CalendarDay, HourOfDay, MinuteOfHour),
    integer(CalendarYear),
    integer(CalendarMonth),
    integer(CalendarDay),
    integer(HourOfDay),
    integer(MinuteOfHour),
    valid_day(CalendarYear, CalendarMonth, CalendarDay),
    between(0, 23, HourOfDay),
    between(0, 59, MinuteOfHour).

valid_day(CalendarYear, CalendarMonth, CalendarDay) :-
    between(1, 9999, CalendarYear),
    between(1, 12, CalendarMonth),
    month_last_day(CalendarYear, CalendarMonth, LastDay),
    between(1, LastDay, CalendarDay).

worker_shifts_overlap(Shifts, Worker) :-
    nth0(FirstIndex, Shifts, shift(FirstIdentifier, FirstStart, FirstEnd, _)),
    FirstIdentifier == Worker,
    nth0(SecondIndex, Shifts, shift(SecondIdentifier, SecondStart, SecondEnd, _)),
    FirstIndex #< SecondIndex,
    SecondIdentifier == Worker,
    minute_stamp(FirstStart, FirstStartStamp),
    minute_stamp(FirstEnd, FirstEndStamp),
    minute_stamp(SecondStart, SecondStartStamp),
    minute_stamp(SecondEnd, SecondEndStamp),
    FirstStartStamp #< SecondEndStamp,
    SecondStartStamp #< FirstEndStamp.

decide_working_time_weekly_limit(case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), working_time_weekly_limit_verdict(Status, Citations)) :-
    weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Status, Citations).

working_time_weekly_limit_status(Case, Status) :-
    decide_working_time_weekly_limit(Case, working_time_weekly_limit_verdict(Status, _Citations)).

working_time_weekly_limit_checklist(Case, Items) :-
    decide_working_time_weekly_limit(Case, working_time_weekly_limit_verdict(Status, _Citations)),
    checklist_items(Status, Items).

checklist_items(within_weekly_limit, [item(reference_period, met, cite(eu_dir_2003_88_art_16_b)), item(countable_period, met, cite(eu_dir_2003_88_art_16_b)), item(weekly_average, met, cite(eu_dir_2003_88_art_6_b))]).
checklist_items(over_weekly_limit, [item(reference_period, met, cite(eu_dir_2003_88_art_16_b)), item(countable_period, met, cite(eu_dir_2003_88_art_16_b)), item(weekly_average, unmet(over_weekly_limit), cite(eu_dir_2003_88_art_6_b))]).
checklist_items(weekly_limit_not_applied_by_agreement, [item(reference_period, met, cite(eu_dir_2003_88_art_16_b)), item(countable_period, met, cite(eu_dir_2003_88_art_16_b)), item(article_22_option, met, cite(eu_dir_2003_88_art_22_1))]).
checklist_items(reference_period_longer_than_allowed, [item(reference_period, unmet(reference_period_longer_than_allowed), cite(eu_dir_2003_88_art_16_b))]).
checklist_items(no_countable_period, [item(reference_period, met, cite(eu_dir_2003_88_art_16_b)), item(countable_period, unmet(no_countable_period), cite(eu_dir_2003_88_art_16_b))]).
checklist_items(indeterminate(MissingKeys), [item(overall, unknown(MissingKeys), cite(eu_dir_2003_88_art_16_b))]).
checklist_items(needs_legal_review(open_textured(KeyName, Citation), _), [item(overall, unknown([KeyName]), Citation)]).
checklist_items(input_problems(Problems), [item(overall, unmet(input_problems(Problems)), cite(eu_dir_2003_88_art_16_b))]).

working_time_weekly_limit_decision_resolvable(Case) :-
    decide_working_time_weekly_limit(Case, _Verdict).

test(a_short_week_is_within_the_limit) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(2026, 3, 2), date(2026, 3, 8), within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
test(the_status_answers_once) :-
    findall(Result - Citations, weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(2026, 3, 2), date(2026, 3, 8), Result, Citations), Answers),
    length(Answers, 1).
test(the_exact_average_of_a_short_week) :-
    weekly_working_time_average([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(2026, 3, 2), date(2026, 3, 8), minutes_per_seven_days(510, 1)).
test(exactly_2880_minutes_is_within) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8), within_weekly_limit, _).
test(exactly_2880_minutes_needs_no_reduction) :-
    required_reduction_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8), 0).
test(one_minute_over_without_the_option_is_over) :-
    weekly_limit_status([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
test(one_minute_over_asks_for_the_option) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), indeterminate([member_state_uses_article_22_option]), []).
test(one_minute_over_needs_one_minute_less) :-
    required_reduction_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), 1).
test(the_average_of_one_minute_over) :-
    weekly_working_time_average([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), minutes_per_seven_days(2881, 1)).
test(the_option_with_prior_agreement_does_not_apply_the_limit) :-
    weekly_limit_status([attribute(member_state_uses_article_22_option, true), attribute(worker_agreement_to_exceed_obtained_first, true)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), weekly_limit_not_applied_by_agreement, [cite(eu_dir_2003_88_art_22_1), cite(eu_dir_2003_88_art_22_1_a)]).
test(no_prior_agreement_and_an_absent_option_names_both_routes) :-
    weekly_limit_status([attribute(worker_agreement_to_exceed_obtained_first, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]).
test(a_period_over_twelve_months_is_too_long) :-
    weekly_limit_status([], w1, [], date(2026, 1, 1), date(2027, 1, 1), reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara), cite(eu_dir_2003_88_art_19_second_subpara), cite(eu_dir_2003_88_art_20_2)]).
test(four_months_by_the_month_rule_is_within_every_ceiling) :-
    weekly_limit_status([], w1, [], date(2026, 1, 31), date(2026, 5, 30), within_weekly_limit, _).
test(one_day_over_four_months_asks_for_the_basis) :-
    weekly_limit_status([], w1, [], date(2026, 1, 31), date(2026, 5, 31), indeterminate([reference_period_basis]), []).
test(six_months_under_the_member_state_period_is_too_long) :-
    weekly_limit_status([attribute(reference_period_basis, member_state_reference_period)], w1, [], date(2026, 1, 1), date(2026, 6, 30), reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b)]).
test(six_months_under_a_collective_agreement_is_allowed) :-
    weekly_limit_status([attribute(reference_period_basis, collective_agreement_under_article_19)], w1, [], date(2026, 1, 1), date(2026, 6, 30), within_weekly_limit, _).
test(over_six_months_under_a_derogation_is_too_long) :-
    weekly_limit_status([attribute(reference_period_basis, derogation_under_article_17_3_or_article_18)], w1, [], date(2026, 1, 1), date(2026, 7, 1), reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara)]).
test(a_period_of_leave_has_no_countable_period) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), paid_annual_leave)], date(2026, 3, 2), date(2026, 3, 8), no_countable_period, [cite(eu_dir_2003_88_art_16_b)]).
test(a_period_of_leave_has_no_average) :-
    weekly_working_time_average([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), sick_leave)], date(2026, 3, 2), date(2026, 3, 8), no_countable_period).
test(an_absent_on_call_judgement_that_matters_is_asked_for) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8), indeterminate([on_call_on_site_counts_as_working_time]), []).
test(an_unsure_on_call_judgement_that_matters_goes_to_a_lawyer) :-
    weekly_limit_status([attribute(on_call_on_site_counts_as_working_time, unsure), attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8), needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), []).
test(on_call_time_counted_as_working_time_is_over) :-
    weekly_limit_status([attribute(on_call_on_site_counts_as_working_time, true), attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8), over_weekly_limit, _).
test(on_call_time_not_counted_is_within) :-
    weekly_limit_status([attribute(on_call_on_site_counts_as_working_time, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 9, 20), work), shift(w1, date_time(2026, 3, 4, 0, 0), date_time(2026, 3, 4, 16, 40), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8), within_weekly_limit, _).
test(another_workers_shifts_are_not_counted) :-
    weekly_limit_status([], w1, [shift(w2, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 8, 0, 0), work)], date(2026, 3, 2), date(2026, 3, 8), within_weekly_limit, _).
test(a_compound_worker_is_an_input_problem) :-
    weekly_limit_status([], worker_number(15), [], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(worker)]), []).
test(overlapping_shifts_are_an_input_problem) :-
    required_reduction_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 15, 0), date_time(2026, 3, 2, 18, 0), work)], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(shifts)])).
test(touching_shifts_are_not_an_input_problem) :-
    required_reduction_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 18, 0), work)], date(2026, 3, 2), date(2026, 3, 8), 0).
test(an_end_before_the_start_is_an_input_problem) :-
    weekly_working_time_average([], w1, [], date(2026, 3, 8), date(2026, 3, 2), input_problems([wrong_type(period_end)])).
test(an_impossible_day_is_an_input_problem) :-
    weekly_working_time_average([], w1, [], date(2026, 2, 30), date(2026, 3, 2), input_problems([wrong_type(period_start)])).
test(a_template_period_is_not_an_input_problem) :-
    weekly_limit_status([], 5, [shift(worker_1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(year, month, day), date(year, month, day), no_countable_period, [cite(eu_dir_2003_88_art_16_b)]).
test(a_template_period_has_no_average) :-
    weekly_working_time_average([], 5, [], date(year, month, day), date(year, month, day), no_countable_period).
test(a_template_period_has_no_reduction) :-
    required_reduction_minutes([], 5, [], date(year, month, day), date(2026, 3, 8), no_countable_period).
test(profile_problems_come_before_argument_problems) :-
    weekly_limit_status([attribute(foo, 1)], _, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([unknown_key(foo), wrong_type(worker)]), []).
test(the_boundary_of_a_week) :-
    weekly_limit_boundary(10080, threshold(counted_working_minutes, 2880, cite(eu_dir_2003_88_art_6_b))).
test(the_facade_checklist_of_a_breach) :-
    working_time_weekly_limit_checklist(case([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8)), [item(reference_period, met, _), item(countable_period, met, _), item(weekly_average, unmet(over_weekly_limit), cite(eu_dir_2003_88_art_6_b))]).

test(a_short_week_is_not_over, fail) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(2026, 3, 2), date(2026, 3, 8), over_weekly_limit, _).
