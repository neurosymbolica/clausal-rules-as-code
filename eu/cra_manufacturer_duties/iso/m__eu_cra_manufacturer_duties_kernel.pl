% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2, real_calendar_day/1, date_earlier/2, date_not_earlier/2, date_later_of/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

cra_manufacturer_duties_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [placing_on_market_date, substantially_modified_on_or_after_application_date, expected_use_time_in_months, security_update_issue_date, support_period_end_date],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(placing_on_market_date, date).
key_type(substantially_modified_on_or_after_application_date, judgement).
key_type(expected_use_time_in_months, non_negative_integer).
key_type(security_update_issue_date, date).
key_type(support_period_end_date, date).

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
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

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
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(date, Value, T) :-
    calendar_date_t(Value, T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

calendar_date_t(date(Year, Month, DayNumber), T) :-
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(DayNumber, DayNumberIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayNumberIsInteger, AllAreIntegers),
    calendar_day_t(AllAreIntegers, Year, Month, DayNumber, T).
calendar_date_t(Value, false) :-
    Value \= date(_, _, _).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, DayNumber, T) :-
    between_t(1, 12, Month, IsMonth),
    day_of_month_t(IsMonth, Year, Month, DayNumber, T).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, Year, Month, DayNumber, T) :-
    month_length(Year, Month, Length),
    between_t(1, Length, DayNumber, T).

between_t(Lowest, Highest, Number, true) :-
    Number >= Lowest,
    Number =< Highest.
between_t(Lowest, _, Number, false) :-
    Number < Lowest.
between_t(_, Highest, Number, false) :-
    Number > Highest.

month_length(_, 1, 31).
month_length(Year, 2, Length) :-
    leap_year_t(Year, IsLeapYear),
    february_length(IsLeapYear, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year_t(Year, IsLeapYear) :-
    FourYearRemainder is Year mod 4,
    CenturyRemainder is Year mod 100,
    FourCenturyRemainder is Year mod 400,
    gregorian_leap_year_t(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_year_t(_, _, 0, true).
gregorian_leap_year_t(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_year_t(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_year_t(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.

real_calendar_day(Value) :-
    ground(Value),
    calendar_date_t(Value, true).

date_earlier(date(FirstYear, _, _), date(SecondYear, _, _)) :-
    FirstYear < SecondYear.
date_earlier(date(FirstYear, FirstMonth, _), date(SecondYear, SecondMonth, _)) :-
    FirstYear =:= SecondYear,
    FirstMonth < SecondMonth.
date_earlier(date(FirstYear, FirstMonth, FirstDay), date(SecondYear, SecondMonth, SecondDay)) :-
    FirstYear =:= SecondYear,
    FirstMonth =:= SecondMonth,
    FirstDay < SecondDay.

date_not_earlier(date(FirstYear, _, _), date(SecondYear, _, _)) :-
    FirstYear > SecondYear.
date_not_earlier(date(FirstYear, FirstMonth, _), date(SecondYear, SecondMonth, _)) :-
    FirstYear =:= SecondYear,
    FirstMonth > SecondMonth.
date_not_earlier(date(FirstYear, FirstMonth, FirstDay), date(SecondYear, SecondMonth, SecondDay)) :-
    FirstYear =:= SecondYear,
    FirstMonth =:= SecondMonth,
    FirstDay >= SecondDay.

date_later_of(FirstDate, SecondDate, SecondDate) :-
    date_earlier(FirstDate, SecondDate).
date_later_of(FirstDate, SecondDate, FirstDate) :-
    date_not_earlier(FirstDate, SecondDate).

test(a_leap_day_is_a_real_calendar_day) :-
    real_calendar_day(date(2028, 2, 29)).
test(day_two_is_earlier_than_day_fifteen) :-
    date_earlier(date(2027, 12, 2), date(2027, 12, 15)).
test(the_same_day_is_not_earlier_holds) :-
    date_not_earlier(date(2027, 12, 11), date(2027, 12, 11)).
test(an_earlier_year_wins_over_a_later_month) :-
    date_earlier(date(2026, 12, 31), date(2027, 1, 1)).
test(the_later_date_is_given) :-
    findall(LaterDate, date_later_of(date(2038, 2, 1), date(2040, 6, 30), LaterDate), LaterDates),
    LaterDates == [date(2040, 6, 30)].
test(equal_dates_give_one_answer) :-
    findall(LaterDate, date_later_of(date(2038, 2, 1), date(2038, 2, 1), LaterDate), LaterDates),
    LaterDates == [date(2038, 2, 1)].
test(a_well_formed_profile_has_no_problem) :-
    cra_manufacturer_duties_input_problems([attribute(placing_on_market_date, date(2028, 1, 10)), attribute(substantially_modified_on_or_after_application_date, unsure)], []).
test(a_duplicate_key_comes_before_an_unknown_key) :-
    cra_manufacturer_duties_input_problems([attribute(placing_on_market_date, date(2028, 1, 10)), attribute(placing_on_market_date, nonsense), attribute(colour, red)], Problems),
    Problems == [duplicate_key(placing_on_market_date), unknown_key(colour)].
test(a_negative_month_count_is_wrong_type) :-
    cra_manufacturer_duties_input_problems([attribute(expected_use_time_in_months, -1)], Problems),
    Problems == [wrong_type(expected_use_time_in_months)].
test(an_atom_is_not_an_attribute_list) :-
    cra_manufacturer_duties_input_problems(nonsense, Problems),
    Problems == [wrong_type(profile)].

test(a_leap_day_outside_a_leap_year_is_not_a_real_day, fail) :-
    real_calendar_day(date(2027, 2, 29)).
test(a_partly_unbound_date_is_not_a_real_day, fail) :-
    real_calendar_day(date(2027, _, 1)).
test(an_atom_is_not_a_real_day, fail) :-
    real_calendar_day(tomorrow).
test(day_fifteen_is_not_earlier_than_day_two, fail) :-
    date_earlier(date(2027, 12, 15), date(2027, 12, 2)).
test(the_same_day_is_not_earlier, fail) :-
    date_earlier(date(2027, 12, 11), date(2027, 12, 11)).
