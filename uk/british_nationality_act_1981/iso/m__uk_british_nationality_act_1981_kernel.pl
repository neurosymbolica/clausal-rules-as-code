:- module(m__uk_british_nationality_act_1981_kernel, [commencement_date/1, commencement_day_number/1, open_end_day_number/1, date_day_number/2, day_number_date/2, leap_year_t/2, valid_date_t/2, years_after/3, day_on_or_before_t/3, period_bounds/3, day_in_any_period_t/3, any_period_overlaps_t/4, interval_inside_one_period_t/4, days_in_periods_within/4, period_of_years_ending_with/4, present_on_day_t/3, attained_age_t/4, minor_t/3, and_t/3, or_t/3, profile_value/4, absence_days_in_years_ending_with/4, present_at_start_of_years_ending_with_t/4, condition_outcome/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/4]).
:- use_module(library(clpz)).
:- use_module(m__uk_british_nationality_act_1981_citations, [implements/1]).

commencement_date(date(1983, 1, 1)).

commencement_day_number(DayNumber) :-
    implements(british_nationality_act_1981_section_53_2),
    implements(commencement_order_1982_article_2),
    commencement_date(Date),
    date_day_number(Date, DayNumber).

open_end_day_number(10000000).

date_day_number(date(Year, Month, Day), DayNumber) :-
    march_based(Year, Month, MarchYear, MarchMonth),
    Era #= MarchYear // 400,
    YearOfEra #= MarchYear - Era * 400,
    DayOfYear #= (153 * MarchMonth + 2) // 5 + Day - 1,
    DayOfEra #= YearOfEra * 365 + YearOfEra // 4 - YearOfEra // 100 + DayOfYear,
    DayNumber #= Era * 146097 + DayOfEra - 719468.

march_based(Year, Month, MarchYear, MarchMonth) :-
    Month #< 3,
    MarchYear #= Year - 1,
    MarchMonth #= Month + 9.
march_based(Year, Month, Year, MarchMonth) :-
    Month #> 2,
    MarchMonth #= Month - 3.

day_number_date(DayNumber, date(Year, Month, Day)) :-
    Shifted #= DayNumber + 719468,
    Era #= Shifted // 146097,
    DayOfEra #= Shifted - Era * 146097,
    YearOfEra #= (DayOfEra - DayOfEra // 1460 + DayOfEra // 36524 - DayOfEra // 146096) // 365,
    DayOfYear #= DayOfEra - (365 * YearOfEra + YearOfEra // 4 - YearOfEra // 100),
    MarchMonth #= (5 * DayOfYear + 2) // 153,
    Day #= DayOfYear - (153 * MarchMonth + 2) // 5 + 1,
    MarchYear #= YearOfEra + Era * 400,
    civil_month(MarchMonth, MarchYear, Month, Year).

civil_month(MarchMonth, MarchYear, Month, MarchYear) :-
    MarchMonth #< 10,
    Month #= MarchMonth + 3.
civil_month(MarchMonth, MarchYear, Month, Year) :-
    MarchMonth #>= 10,
    Month #= MarchMonth - 9,
    Year #= MarchYear + 1.

leap_year_t(Year, true) :-
    Year mod 400 #= 0.
leap_year_t(Year, true) :-
    Year mod 4 #= 0,
    Year mod 100 #\= 0.
leap_year_t(Year, false) :-
    Year mod 4 #\= 0.
leap_year_t(Year, false) :-
    Year mod 100 #= 0,
    Year mod 400 #\= 0.

days_in_month(_, 1, 31).
days_in_month(Year, 2, 29) :-
    leap_year_t(Year, true).
days_in_month(Year, 2, 28) :-
    leap_year_t(Year, false).
days_in_month(_, 3, 31).
days_in_month(_, 4, 30).
days_in_month(_, 5, 31).
days_in_month(_, 6, 30).
days_in_month(_, 7, 31).
days_in_month(_, 8, 31).
days_in_month(_, 9, 30).
days_in_month(_, 10, 31).
days_in_month(_, 11, 30).
days_in_month(_, 12, 31).

valid_date_t(date(Year, Month, Day), true) :-
    Month #> 0,
    Month #< 13,
    days_in_month(Year, Month, Length),
    Day #> 0,
    Day #< Length + 1.
valid_date_t(date(_, Month, _), false) :-
    Month #< 1.
valid_date_t(date(_, Month, _), false) :-
    Month #> 12.
valid_date_t(date(Year, Month, Day), false) :-
    Month #> 0,
    Month #< 13,
    days_in_month(Year, Month, Length),
    Day #> Length.
valid_date_t(date(_, Month, Day), false) :-
    Month #> 0,
    Month #< 13,
    Day #< 1.

years_after(date(Year, Month, Day), Years, date(Year2, Month, Day)) :-
    Year2 #= Year + Years,
    valid_date_t(date(Year2, Month, Day), true).
years_after(date(Year, Month, Day), Years, date(Year2, 3, 1)) :-
    Year2 #= Year + Years,
    valid_date_t(date(Year2, Month, Day), false).

day_on_or_before_t(DayNumber, Limit, true) :-
    DayNumber #=< Limit.
day_on_or_before_t(DayNumber, Limit, false) :-
    DayNumber #> Limit.

period_bounds(period(From, To), FromDay, ToDay) :-
    implements(british_nationality_act_1981_section_50_10),
    date_day_number(From, FromDay),
    period_end_day(To, ToDay).

period_end_day(ongoing, ToDay) :-
    open_end_day_number(ToDay).
period_end_day(date(Year, Month, Day), ToDay) :-
    date_day_number(date(Year, Month, Day), ToDay).

day_in_period_t(DayNumber, Period, true) :-
    period_bounds(Period, FromDay, ToDay),
    DayNumber #>= FromDay,
    DayNumber #=< ToDay.
day_in_period_t(DayNumber, Period, false) :-
    period_bounds(Period, FromDay, _),
    DayNumber #< FromDay.
day_in_period_t(DayNumber, Period, false) :-
    period_bounds(Period, _, ToDay),
    DayNumber #> ToDay.

day_in_any_period_t([], _, false).
day_in_any_period_t([Period|Periods], DayNumber, Truth) :-
    day_in_period_t(DayNumber, Period, Here),
    day_in_rest_t(Here, Periods, DayNumber, Truth).

day_in_rest_t(true, _, _, true).
day_in_rest_t(false, Periods, DayNumber, Truth) :-
    day_in_any_period_t(Periods, DayNumber, Truth).

any_period_overlaps_t([], _, _, false).
any_period_overlaps_t([Period|Periods], StartDay, EndDay, Truth) :-
    period_bounds(Period, FromDay, ToDay),
    overlap_t(FromDay, ToDay, StartDay, EndDay, Here),
    overlaps_rest_t(Here, Periods, StartDay, EndDay, Truth).

overlaps_rest_t(true, _, _, _, true).
overlaps_rest_t(false, Periods, StartDay, EndDay, Truth) :-
    any_period_overlaps_t(Periods, StartDay, EndDay, Truth).

overlap_t(FromDay, ToDay, StartDay, EndDay, true) :-
    FromDay #=< EndDay,
    ToDay #>= StartDay.
overlap_t(FromDay, _, _, EndDay, false) :-
    FromDay #> EndDay.
overlap_t(FromDay, ToDay, StartDay, EndDay, false) :-
    FromDay #=< EndDay,
    ToDay #< StartDay.

interval_inside_one_period_t([], _, _, false).
interval_inside_one_period_t([Period|Periods], StartDay, EndDay, Truth) :-
    period_bounds(Period, FromDay, ToDay),
    inside_t(FromDay, ToDay, StartDay, EndDay, Here),
    inside_rest_t(Here, Periods, StartDay, EndDay, Truth).

inside_rest_t(true, _, _, _, true).
inside_rest_t(false, Periods, StartDay, EndDay, Truth) :-
    interval_inside_one_period_t(Periods, StartDay, EndDay, Truth).

inside_t(FromDay, ToDay, StartDay, EndDay, true) :-
    FromDay #=< StartDay,
    ToDay #>= EndDay.
inside_t(FromDay, _, StartDay, _, false) :-
    FromDay #> StartDay.
inside_t(FromDay, ToDay, StartDay, EndDay, false) :-
    FromDay #=< StartDay,
    ToDay #< EndDay.

days_in_periods_within([], _, _, 0).
days_in_periods_within([Period|Periods], StartDay, EndDay, Days) :-
    period_bounds(Period, FromDay, ToDay),
    Here #= max(0, min(ToDay, EndDay) - max(FromDay, StartDay) + 1),
    days_in_periods_within(Periods, StartDay, EndDay, Rest),
    Days #= Here + Rest.

period_of_years_ending_with(EndDate, Years, StartDay, EndDay) :-
    implements(british_nationality_act_1981_section_50_10),
    date_day_number(EndDate, EndDay),
    DayAfter #= EndDay + 1,
    day_number_date(DayAfter, DayAfterDate),
    Back #= 0 - Years,
    years_after(DayAfterDate, Back, StartDate),
    date_day_number(StartDate, StartDay).

present_on_day_t(Absences, DayNumber, true) :-
    day_in_any_period_t(Absences, DayNumber, false).
present_on_day_t(Absences, DayNumber, false) :-
    day_in_any_period_t(Absences, DayNumber, true).

attained_age_t(DateOfBirth, Age, DayNumber, Truth) :-
    implements(british_nationality_act_1981_section_50_11),
    years_after(DateOfBirth, Age, Anniversary),
    date_day_number(Anniversary, AnniversaryDay),
    attained_t(AnniversaryDay, DayNumber, Truth).

attained_t(AnniversaryDay, DayNumber, true) :-
    DayNumber #>= AnniversaryDay.
attained_t(AnniversaryDay, DayNumber, false) :-
    DayNumber #< AnniversaryDay.

minor_t(DateOfBirth, DayNumber, true) :-
    implements(british_nationality_act_1981_section_50_1_minor),
    attained_age_t(DateOfBirth, 18, DayNumber, false).
minor_t(DateOfBirth, DayNumber, false) :-
    implements(british_nationality_act_1981_section_50_1_minor),
    attained_age_t(DateOfBirth, 18, DayNumber, true).

and_t(true, Truth, Truth).
and_t(false, _, false).

or_t(true, _, true).
or_t(false, Truth, Truth).

profile_value(Profile, Key, Default, Value) :-
    get(Profile, Key, Value, Default).

absence_days_in_years_ending_with(Absences, EndDate, Years, Days) :-
    period_of_years_ending_with(EndDate, Years, StartDay, EndDay),
    days_in_periods_within(Absences, StartDay, EndDay, Days).

present_at_start_of_years_ending_with_t(Absences, EndDate, Years, Truth) :-
    period_of_years_ending_with(EndDate, Years, StartDay, _),
    present_on_day_t(Absences, StartDay, Truth).

condition_outcome([], fulfilled).
condition_outcome([condition(_, Status, _)|Conditions], Outcome) :-
    condition_outcome(Conditions, Rest),
    combine_outcome(Status, Rest, Outcome).

combine_outcome(unmet, _, not_fulfilled).
combine_outcome(met, Rest, Rest).
combine_outcome(waivable, fulfilled, fulfilled_only_if_waived).
combine_outcome(waivable, fulfilled_only_if_waived, fulfilled_only_if_waived).
combine_outcome(waivable, not_fulfilled, not_fulfilled).

no_statute("date_day_number", 2, "computation_helper").
no_statute("day_number_date", 2, "computation_helper").
no_statute("march_based", 4, "computation_helper").
no_statute("civil_month", 4, "computation_helper").
no_statute("leap_year_t", 2, "computation_helper").
no_statute("days_in_month", 3, "computation_helper").
no_statute("valid_date_t", 2, "computation_helper").
no_statute("years_after", 3, "computation_helper").
no_statute("day_on_or_before_t", 3, "computation_helper").
no_statute("period_end_day", 2, "computation_helper").
no_statute("day_in_period_t", 3, "computation_helper").
no_statute("day_in_any_period_t", 3, "computation_helper").
no_statute("day_in_rest_t", 4, "computation_helper").
no_statute("any_period_overlaps_t", 4, "computation_helper").
no_statute("overlaps_rest_t", 5, "computation_helper").
no_statute("overlap_t", 5, "computation_helper").
no_statute("interval_inside_one_period_t", 4, "computation_helper").
no_statute("inside_rest_t", 5, "computation_helper").
no_statute("inside_t", 5, "computation_helper").
no_statute("days_in_periods_within", 4, "computation_helper").
no_statute("present_on_day_t", 3, "computation_helper").
no_statute("attained_t", 3, "computation_helper").
no_statute("profile_value", 4, "computation_helper").
no_statute("absence_days_in_years_ending_with", 4, "computation_helper").
no_statute("present_at_start_of_years_ending_with_t", 4, "computation_helper").
no_statute("condition_outcome", 2, "computation_helper").
