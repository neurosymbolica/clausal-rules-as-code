% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2, daily_rest_argument_problems/6, date_time_absolute_minute/2, absolute_minute_date_time/2, period_bounds/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(library(clpz)).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(deadline_lib, [month_last_day/3]).

daily_rest_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, worker_category, derogation_from_article_3],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(on_call_on_site_counts_as_working_time, judgement).
key_type(on_call_standby_counts_as_working_time, judgement).
key_type(worker_category, worker_category_atom).
key_type(derogation_from_article_3, derogation_from_article_3_atom).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(worker_category_atom, Value, T) :-
    in_type_t(enum([other_worker, mobile_worker, seagoing_fishing_vessel_worker]), Value, T).
in_type_t(derogation_from_article_3_atom, Value, T) :-
    in_type_t(enum([no_derogation, derogation_under_article_17_1, derogation_under_article_17_3, derogation_under_article_17_4, derogation_under_article_18]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

daily_rest_argument_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems) :-
    daily_rest_input_problems(Profile, ProfileProblems),
    worker_valid_t(Worker, WorkerValid),
    worker_problems(WorkerValid, WorkerProblems),
    shift_list_t(Shifts, ShiftListValid),
    shifts_problems(ShiftListValid, WorkerValid, Worker, Shifts, ShiftsProblems),
    real_calendar_date_t(PeriodStart, PeriodStartValid),
    period_start_problems(PeriodStartValid, PeriodStartProblems),
    real_calendar_date_t(PeriodEnd, PeriodEndValid),
    period_end_problems(PeriodStartValid, PeriodEndValid, PeriodStart, PeriodEnd, PeriodEndProblems),
    append([ProfileProblems, WorkerProblems, ShiftsProblems, PeriodStartProblems, PeriodEndProblems], Problems).

worker_problems(true, []).
worker_problems(false, [wrong_type(worker)]).

satisfies_t(Test, Term, Truth) :-
    findall(Test, call(Test, Term), Satisfied),
    satisfied_truth(Satisfied, Truth).

satisfied_truth([], false).
satisfied_truth([_|_], true).

worker_valid_t(Worker, Truth) :-
    satisfies_t(atom, Worker, IsAtom),
    satisfies_t(integer, Worker, IsInteger),
    truth_or(IsAtom, IsInteger, Truth).

shift_kind_values([work, on_call_on_site, on_call_standby, paid_annual_leave, sick_leave]).

shift_list_t(Term, false) :-
    var(Term).
shift_list_t(Term, true) :-
    Term == [].
shift_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [Shift|Shifts],
    shift_t(Shift, ShiftValid),
    shift_list_t(Shifts, ShiftsValid),
    truth_and(ShiftValid, ShiftsValid, Truth).
shift_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

shift_t(Shift, false) :-
    term_variables(Shift, [_|_]).
shift_t(Shift, Truth) :-
    term_variables(Shift, []),
    shift_shape_t(Shift, Truth).

shift_shape_t(Shift, false) :-
    Shift \= shift(_, _, _, _).
shift_shape_t(shift(WorkerIdentifier, Start, End, Kind), Truth) :-
    worker_valid_t(WorkerIdentifier, IdentifierValid),
    real_date_time_t(Start, StartValid),
    real_date_time_t(End, EndValid),
    shift_kind_values(Kinds),
    memberd_t(Kind, Kinds, KindValid),
    truth_and(StartValid, EndValid, TimesValid),
    times_in_order_t(TimesValid, Start, End, TimesInOrder),
    truth_and(IdentifierValid, KindValid, LabelsValid),
    truth_and(LabelsValid, TimesInOrder, Truth).

times_in_order_t(false, _, _, false).
times_in_order_t(true, Start, End, Truth) :-
    date_time_absolute_minute(Start, StartMinute),
    date_time_absolute_minute(End, EndMinute),
    zcompare(Order, StartMinute, EndMinute),
    before_order_truth(Order, Truth).

before_order_truth(<, true).
before_order_truth(=, false).
before_order_truth(>, false).

shifts_problems(false, _, _, _, [wrong_type(shifts)]).
shifts_problems(true, false, _, _, []).
shifts_problems(true, true, Worker, Shifts, Problems) :-
    worker_intervals(Worker, Shifts, Intervals),
    overlap_t(Intervals, Overlap),
    overlap_problems(Overlap, Problems).

overlap_problems(true, [wrong_type(shifts)]).
overlap_problems(false, []).

worker_intervals(Worker, Shifts, Intervals) :-
    findall(StartMinute - EndMinute, (member(shift(WorkerIdentifier, Start, End, _), Shifts), WorkerIdentifier == Worker, date_time_absolute_minute(Start, StartMinute), date_time_absolute_minute(End, EndMinute)), Unsorted),
    msort(Unsorted, Intervals).

overlap_t([], false).
overlap_t([_], false).
overlap_t([_ - FirstEnd, SecondStart - SecondEnd|Rest], Truth) :-
    zcompare(Order, SecondStart, FirstEnd),
    overlap_order_truth(Order, [SecondStart - SecondEnd|Rest], Truth).

overlap_order_truth(<, _, true).
overlap_order_truth(=, Rest, Truth) :-
    overlap_t(Rest, Truth).
overlap_order_truth(>, Rest, Truth) :-
    overlap_t(Rest, Truth).

period_start_problems(true, []).
period_start_problems(false, [wrong_type(period_start)]).

period_end_problems(_, false, _, _, [wrong_type(period_end)]).
period_end_problems(false, true, _, _, []).
period_end_problems(true, true, PeriodStart, PeriodEnd, Problems) :-
    days_between(PeriodEnd, PeriodStart, DaysFromStartToEnd),
    at_most_t(0, DaysFromStartToEnd, InOrder),
    period_order_problems(InOrder, Problems).

period_order_problems(true, []).
period_order_problems(false, [wrong_type(period_end)]).

real_calendar_date_t(Term, false) :-
    term_variables(Term, [_|_]).
real_calendar_date_t(Term, Truth) :-
    term_variables(Term, []),
    calendar_date_shape_t(Term, Truth).

calendar_date_shape_t(Term, false) :-
    Term \= date(_, _, _).
calendar_date_shape_t(date(Year, Month, DayOfMonth), Truth) :-
    integers_t([Year, Month, DayOfMonth], AreIntegers),
    calendar_fields_t(AreIntegers, Year, Month, DayOfMonth, Truth).

calendar_fields_t(false, _, _, _, false).
calendar_fields_t(true, Year, Month, DayOfMonth, Truth) :-
    real_day_t(Year, Month, DayOfMonth, Truth).

real_date_time_t(Term, false) :-
    term_variables(Term, [_|_]).
real_date_time_t(Term, Truth) :-
    term_variables(Term, []),
    date_time_shape_t(Term, Truth).

date_time_shape_t(Term, false) :-
    Term \= date_time(_, _, _, _, _).
date_time_shape_t(date_time(Year, Month, DayOfMonth, HourOfDay, MinuteOfHour), Truth) :-
    integers_t([Year, Month, DayOfMonth, HourOfDay, MinuteOfHour], AreIntegers),
    date_time_fields_t(AreIntegers, Year, Month, DayOfMonth, HourOfDay, MinuteOfHour, Truth).

date_time_fields_t(false, _, _, _, _, _, false).
date_time_fields_t(true, Year, Month, DayOfMonth, HourOfDay, MinuteOfHour, Truth) :-
    real_day_t(Year, Month, DayOfMonth, RealDay),
    in_range_t(0, 23, HourOfDay, RealHour),
    in_range_t(0, 59, MinuteOfHour, RealMinute),
    truth_and(RealHour, RealMinute, RealClock),
    truth_and(RealDay, RealClock, Truth).

integers_t([], true).
integers_t([Value|Values], Truth) :-
    satisfies_t(integer, Value, IsInteger),
    integers_t(Values, RestAreIntegers),
    truth_and(IsInteger, RestAreIntegers, Truth).

real_day_t(Year, Month, DayOfMonth, Truth) :-
    in_range_t(1, 9999, Year, RealYear),
    in_range_t(1, 12, Month, RealMonth),
    truth_and(RealYear, RealMonth, RealYearAndMonth),
    day_of_month_t(RealYearAndMonth, Year, Month, DayOfMonth, Truth).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, Year, Month, DayOfMonth, Truth) :-
    month_last_day(Year, Month, LastDayOfMonth),
    in_range_t(1, LastDayOfMonth, DayOfMonth, Truth).

in_range_t(Low, High, Value, Truth) :-
    at_most_t(Low, Value, AboveLow),
    at_most_t(Value, High, BelowHigh),
    truth_and(AboveLow, BelowHigh, Truth).

at_most_t(Smaller, Larger, Truth) :-
    zcompare(Order, Smaller, Larger),
    at_most_order_truth(Order, Truth).

at_most_order_truth(<, true).
at_most_order_truth(=, true).
at_most_order_truth(>, false).

calendar_epoch(date(1, 1, 1)).

date_time_absolute_minute(date_time(Year, Month, DayOfMonth, HourOfDay, MinuteOfHour), AbsoluteMinute) :-
    calendar_epoch(Epoch),
    days_between(date(Year, Month, DayOfMonth), Epoch, DaysSinceEpoch),
    AbsoluteMinute #= DaysSinceEpoch * 1440 + HourOfDay * 60 + MinuteOfHour.

absolute_minute_date_time(AbsoluteMinute, date_time(Year, Month, DayOfMonth, HourOfDay, MinuteOfHour)) :-
    DaysSinceEpoch #= AbsoluteMinute // 1440,
    MinuteOfDay #= AbsoluteMinute mod 1440,
    HourOfDay #= MinuteOfDay // 60,
    MinuteOfHour #= MinuteOfDay mod 60,
    calendar_epoch(Epoch),
    timedelta(DaysSinceEpoch, 0, OffsetFromEpoch),
    date_add(Epoch, OffsetFromEpoch, Date),
    Date = date(Year, Month, DayOfMonth).

period_bounds(date(StartYear, StartMonth, StartDayOfMonth), date(EndYear, EndMonth, EndDayOfMonth), StartOfPeriodMinute, EndOfPeriodMinute) :-
    date_time_absolute_minute(date_time(StartYear, StartMonth, StartDayOfMonth, 0, 0), StartOfPeriodMinute),
    date_time_absolute_minute(date_time(EndYear, EndMonth, EndDayOfMonth, 0, 0), EndDayMinute),
    EndOfPeriodMinute #= EndDayMinute + 1440.

test(a_well_formed_profile_has_no_problem) :-
    daily_rest_input_problems([attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], []).
test(the_problems_come_in_contract_order_then_unknown_keys) :-
    daily_rest_input_problems([attribute(worker_category, pilot), attribute(derogation_from_article_3, no_derogation), attribute(derogation_from_article_3, no_derogation), attribute(colour, red)], Problems),
    Problems == [wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    daily_rest_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(unsure_is_a_judgement_value) :-
    daily_rest_input_problems([attribute(on_call_on_site_counts_as_working_time, unsure)], []).
test(unsure_as_worker_category_is_a_wrong_type) :-
    daily_rest_input_problems([attribute(worker_category, unsure)], [wrong_type(worker_category)]).
test(an_unbound_worker_is_a_wrong_type) :-
    daily_rest_argument_problems([], _, [], date(2026, 3, 2), date(2026, 3, 2), Problems),
    Problems == [wrong_type(worker)].
test(an_unbound_shift_list_is_a_wrong_type) :-
    daily_rest_argument_problems([], w1, _, date(2026, 3, 2), date(2026, 3, 2), Problems),
    Problems == [wrong_type(shifts)].

test(unsure_is_not_a_worker_category, fail) :-
    daily_rest_input_problems([attribute(worker_category, unsure)], []).
