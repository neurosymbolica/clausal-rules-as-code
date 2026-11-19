% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_kernel, [virginia_vcdpa_input_problems/2, query_problems/3, date_argument_problems/2, value_or_absent/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).

virginia_vcdpa_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [entity_category, conducts_business_in_or_targets_virginia, consumer_count, over_half_of_gross_revenue_from_sale, extension_reasonably_necessary, extension_notice_given_within_initial_period, cured_with_express_written_statement, continued_violation_or_statement_breached, violation_count],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(entity_category, entity_category).
key_type(conducts_business_in_or_targets_virginia, judgement).
key_type(consumer_count, non_negative_integer).
key_type(over_half_of_gross_revenue_from_sale, boolean).
key_type(extension_reasonably_necessary, judgement).
key_type(extension_notice_given_within_initial_period, boolean).
key_type(cured_with_express_written_statement, boolean).
key_type(continued_violation_or_statement_breached, boolean).
key_type(violation_count, non_negative_integer).

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

in_type_t(entity_category, Value, T) :-
    in_type_t(enum([public_body_of_the_commonwealth, financial_institution_subject_to_glba, hipaa_covered_entity_or_business_associate, nonprofit_organization, institution_of_higher_education, none_of_the_exempt_categories]), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
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

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.

query_problems(Profile, NamedDates, Problems) :-
    virginia_vcdpa_input_problems(Profile, ProfileProblems),
    date_argument_problems(NamedDates, DateProblems),
    append(ProfileProblems, DateProblems, Problems).

date_argument_problems([], []).
date_argument_problems([ArgumentName - Date|NamedDates], Problems) :-
    valid_contract_date_t(Date, IsValid),
    date_argument_problems(NamedDates, LaterProblems),
    name_date_problem(IsValid, ArgumentName, LaterProblems, Problems).

name_date_problem(true, _, Problems, Problems).
name_date_problem(false, ArgumentName, Problems, [wrong_type(ArgumentName)|Problems]).

valid_contract_date_t(Date, false) :-
    var(Date).
valid_contract_date_t(Date, T) :-
    nonvar(Date),
    Date = date(Year, Month, Day),
    date_parts_t(Year, Month, Day, T).
valid_contract_date_t(Date, false) :-
    nonvar(Date),
    Date \= date(_, _, _).

date_parts_t(Year, Month, Day, T) :-
    term_variables([Year, Month, Day], Variables),
    ground_date_parts_t(Variables, Year, Month, Day, T).

ground_date_parts_t([_|_], _, _, _, false).
ground_date_parts_t([], Year, Month, Day, T) :-
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, PartsAreIntegers),
    integer_date_parts_t(PartsAreIntegers, Year, Month, Day, T).

integer_date_parts_t(false, _, _, _, false).
integer_date_parts_t(true, Year, Month, Day, T) :-
    supported_year_t(Year, YearIsSupported),
    in_range_t(Month, 1, 12, MonthIsReal),
    truth_and(YearIsSupported, MonthIsReal, YearAndMonthAreValid),
    day_in_month_t(YearAndMonthAreValid, Year, Month, Day, T).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, Year, Month, Day, T) :-
    month_last_day(Year, Month, LastDay),
    in_range_t(Day, 1, LastDay, T).

supported_year_t(Year, true) :-
    Year #>= 2000,
    Year #< 2101.
supported_year_t(Year, false) :-
    Year #< 2000.
supported_year_t(Year, false) :-
    Year #> 2100.

in_range_t(Value, Lowest, Highest, true) :-
    Value #>= Lowest,
    Value #=< Highest.
in_range_t(Value, Lowest, _, false) :-
    Value #< Lowest.
in_range_t(Value, _, Highest, false) :-
    Value #> Highest.

value_or_absent(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).
value_or_absent(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

test(an_empty_profile_has_no_problem) :-
    virginia_vcdpa_input_problems([], []).
test(a_list_of_atoms_is_not_a_profile) :-
    virginia_vcdpa_input_problems([entity_category], [wrong_type(profile)]).
test(problems_come_in_the_stated_order) :-
    virginia_vcdpa_input_problems([attribute(colour, red), attribute(consumer_count, 1), attribute(consumer_count, 2), attribute(violation_count, minus)], Problems),
    Problems == [duplicate_key(consumer_count), wrong_type(violation_count), unknown_key(colour)].
test(a_real_day_is_no_date_problem) :-
    date_argument_problems([received_date - date(2026, 1, 15)], []).
test(a_leap_day_in_a_leap_year_is_real) :-
    date_argument_problems([received_date - date(2028, 2, 29)], []).
test(a_year_before_2000_is_a_date_problem) :-
    date_argument_problems([notice_date - date(1999, 12, 31)], [wrong_type(notice_date)]).
test(an_unbound_date_is_a_date_problem) :-
    date_argument_problems([reference_date - _], [wrong_type(reference_date)]).
test(an_atom_is_not_a_date) :-
    date_argument_problems([appeal_received_date - today], [wrong_type(appeal_received_date)]).
test(date_problems_follow_profile_problems) :-
    query_problems([attribute(colour, red)], [notice_date - date(2026, 1, 1), reference_date - nothing], Problems),
    Problems == [unknown_key(colour), wrong_type(reference_date)].
test(a_present_key_gives_its_value) :-
    findall(Value, value_or_absent([attribute(consumer_count, 5)], consumer_count, Value), Values),
    Values == [5].
test(a_missing_key_gives_absent) :-
    findall(Value, value_or_absent([], consumer_count, Value), Values),
    Values == [absent].
