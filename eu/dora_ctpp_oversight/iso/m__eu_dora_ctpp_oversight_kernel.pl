% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(reif), [memberd_t/3]).

dora_ctpp_oversight_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [provider_designated_as_critical, response_window, draft_oversight_plan_received_on, annual_oversight_plan_adopted_and_notified, oversight_activities_completed, provider_plans_further_subcontracting_arrangement, envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, subcontracting_concerns_critical_or_important_functions, lead_overseer_deems_clear_and_serious_risk, recommendation_information_opportunity_given_on, measure_power, measure_compliance, measure_notification_received_on, penalty_decision_notified_on, preceding_business_year_worldwide_turnover, preceding_business_year_length_in_days, assessment_date],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(provider_designated_as_critical, boolean).
key_type(response_window, response_window).
key_type(draft_oversight_plan_received_on, date).
key_type(annual_oversight_plan_adopted_and_notified, boolean).
key_type(oversight_activities_completed, boolean).
key_type(provider_plans_further_subcontracting_arrangement, boolean).
key_type(envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, boolean).
key_type(subcontracting_concerns_critical_or_important_functions, boolean).
key_type(lead_overseer_deems_clear_and_serious_risk, boolean).
key_type(recommendation_information_opportunity_given_on, date).
key_type(measure_power, measure_power).
key_type(measure_compliance, measure_compliance).
key_type(measure_notification_received_on, date).
key_type(penalty_decision_notified_on, date).
key_type(preceding_business_year_worldwide_turnover, non_negative_integer).
key_type(preceding_business_year_length_in_days, positive_integer).
key_type(assessment_date, date).

input_date_year_range(1900, 2199).

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

in_type_t(response_window, Value, T) :-
    in_type_t(enum([oversight_plan_statement, recommendation_information]), Value, T).
in_type_t(measure_power, Value, T) :-
    in_type_t(enum([information_request, general_investigation, inspection, remediation_report_request, recommendation]), Value, T).
in_type_t(measure_compliance, Value, T) :-
    in_type_t(enum([full, partial, none]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(date, Value, T) :-
    calendar_date_t(Value, T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).
in_type_t(positive_integer, Value, T) :-
    positive_integer_t(Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

integer_t(Value, T) :-
    catch((must_be(integer, Value), T = true), _, T = false).

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
    input_date_year_range(FirstYear, LastYear),
    between_t(FirstYear, LastYear, Year, IsInputYear),
    calendar_month_t(IsInputYear, Year, Month, DayNumber, T).

calendar_month_t(false, _, _, _, false).
calendar_month_t(true, Year, Month, DayNumber, T) :-
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

positive_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_one_t(IsInteger, Value, T).

not_below_one_t(false, _, false).
not_below_one_t(true, Value, true) :-
    Value >= 1.
not_below_one_t(true, Value, false) :-
    Value < 1.

test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_ctpp_oversight_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    dora_ctpp_oversight_input_problems([attribute(provider_designated_as_critical, true), attribute(assessment_date, date(2026, 2, 28)), attribute(preceding_business_year_length_in_days, 365), attribute(preceding_business_year_worldwide_turnover, 0)], Problems),
    Problems == [].
test(a_year_before_the_input_range_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(assessment_date, date(1899, 12, 31))], Problems),
    Problems == [wrong_type(assessment_date)].
test(the_first_year_of_the_input_range_is_accepted) :-
    dora_ctpp_oversight_input_problems([attribute(assessment_date, date(1900, 1, 1))], Problems),
    Problems == [].
test(the_last_year_of_the_input_range_is_accepted) :-
    dora_ctpp_oversight_input_problems([attribute(assessment_date, date(2199, 12, 31))], Problems),
    Problems == [].
test(a_year_after_the_input_range_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(assessment_date, date(2200, 1, 1))], Problems),
    Problems == [wrong_type(assessment_date)].
test(twenty_ninth_february_outside_a_leap_year_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(penalty_decision_notified_on, date(2027, 2, 29))], Problems),
    Problems == [wrong_type(penalty_decision_notified_on)].
test(zero_days_of_business_year_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(preceding_business_year_length_in_days, 0)], Problems),
    Problems == [wrong_type(preceding_business_year_length_in_days)].
test(one_day_of_business_year_is_accepted) :-
    dora_ctpp_oversight_input_problems([attribute(preceding_business_year_length_in_days, 1)], Problems),
    Problems == [].
test(a_float_number_of_days_is_wrong_type) :-
    FloatDays is float(365),
    dora_ctpp_oversight_input_problems([attribute(preceding_business_year_length_in_days, FloatDays)], Problems),
    Problems == [wrong_type(preceding_business_year_length_in_days)].
test(an_atom_turnover_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(preceding_business_year_worldwide_turnover, many)], Problems),
    Problems == [wrong_type(preceding_business_year_worldwide_turnover)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    dora_ctpp_oversight_input_problems([attribute(colour, blue), attribute(assessment_date, unsure), attribute(provider_designated_as_critical, true), attribute(provider_designated_as_critical, true), attribute(measure_compliance, unsure)], Problems),
    Problems == [duplicate_key(provider_designated_as_critical), wrong_type(measure_compliance), wrong_type(assessment_date), unknown_key(colour)].
test(an_unbound_profile_is_wrong_type) :-
    dora_ctpp_oversight_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_wrong_type) :-
    dora_ctpp_oversight_input_problems([attribute(provider_designated_as_critical, true)|_], Problems),
    Problems == [wrong_type(profile)].
