% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

pipl_handler_duties_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [reference_date, pinned_articles_unamended_on_reference_date, decides_purposes_and_means, processes_on_entrustment, reaches_officer_quantity, handler_located_outside_china, personal_information_of_individuals_in_china, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china, other_case_prescribed_by_law, processes_sensitive_personal_information, uses_automated_decision_making, entrusts_processing, provides_to_another_handler, makes_personal_information_public, provides_outside_china, other_significant_impact_processing, incident_occurred_or_possible, harm_effectively_avoided, department_required_individual_notice, important_platform_handler],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(reference_date, date).
key_type(pinned_articles_unamended_on_reference_date, boolean).
key_type(decides_purposes_and_means, judgement).
key_type(processes_on_entrustment, boolean).
key_type(reaches_officer_quantity, boolean).
key_type(handler_located_outside_china, boolean).
key_type(personal_information_of_individuals_in_china, boolean).
key_type(offers_products_or_services_to_individuals_in_china, judgement).
key_type(analyses_or_evaluates_individuals_in_china, judgement).
key_type(other_case_prescribed_by_law, boolean).
key_type(processes_sensitive_personal_information, boolean).
key_type(uses_automated_decision_making, boolean).
key_type(entrusts_processing, boolean).
key_type(provides_to_another_handler, boolean).
key_type(makes_personal_information_public, boolean).
key_type(provides_outside_china, boolean).
key_type(other_significant_impact_processing, judgement).
key_type(incident_occurred_or_possible, boolean).
key_type(harm_effectively_avoided, judgement).
key_type(department_required_individual_notice, boolean).
key_type(important_platform_handler, judgement).

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
    year_from_one_t(Year, IsYear),
    month_and_day_t(IsYear, Year, Month, DayNumber, T).

year_from_one_t(Year, true) :-
    Year >= 1.
year_from_one_t(Year, false) :-
    Year < 1.

month_and_day_t(false, _, _, _, false).
month_and_day_t(true, Year, Month, DayNumber, T) :-
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

test(an_empty_profile_has_no_problem) :-
    pipl_handler_duties_input_problems([], []).
test(a_good_profile_has_no_problem) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2021, 11, 1)), attribute(decides_purposes_and_means, unsure)], []).
test(year_zero_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(0, 1, 1))], [wrong_type(reference_date)]).
test(year_two_thousand_leap_day_is_a_day) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2000, 2, 29))], []).
test(year_nineteen_hundred_leap_day_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(1900, 2, 29))], [wrong_type(reference_date)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reaches_officer_quantity, unsure)], [wrong_type(reaches_officer_quantity)]).
test(a_repeated_key_is_a_duplicate_only) :-
    pipl_handler_duties_input_problems([attribute(reaches_officer_quantity, unsure), attribute(reaches_officer_quantity, true)], [duplicate_key(reaches_officer_quantity)]).
test(an_unknown_key_is_named_once) :-
    pipl_handler_duties_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    pipl_handler_duties_input_problems(_, [wrong_type(profile)]).
test(a_stray_element_is_not_an_attribute_list) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2022, 1, 1)), stray], [wrong_type(profile)]).
