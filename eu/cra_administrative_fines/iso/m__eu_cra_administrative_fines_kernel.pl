% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2, cra_administrative_fines_calendar_day_t/2, cra_administrative_fines_contract_keys/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(deadline_lib, [month_last_day/3]).

cra_administrative_fines_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(infringed_provision, provision).
key_type(offender_is_open_source_software_steward, judgement).
key_type(offender_is_undertaking, judgement).
key_type(total_worldwide_annual_turnover_in_euros, non_negative_integer).

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

in_type_t(provision, Value, T) :-
    in_type_t(enum([annex_i_essential_cybersecurity_requirements, article_13, article_14, article_18, article_19, article_20, article_21, article_22, article_23, article_28, article_30_paragraphs_1_to_4, article_31_paragraphs_1_to_4, article_32_paragraphs_1_to_3, article_33_paragraph_5, article_39, article_41, article_47, article_49, article_53, incorrect_incomplete_or_misleading_information_in_reply_to_request, other_provision]), Value, T).
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

cra_administrative_fines_contract_keys([infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros]).

cra_administrative_fines_calendar_day_t(DateTerm, false) :-
    var(DateTerm).
cra_administrative_fines_calendar_day_t(DateTerm, Truth) :-
    nonvar(DateTerm),
    DateTerm = date(YearNumber, MonthNumber, DayNumber),
    date_parts_integer_t(YearNumber, MonthNumber, DayNumber, AllIntegers),
    calendar_parts_t(AllIntegers, YearNumber, MonthNumber, DayNumber, Truth).
cra_administrative_fines_calendar_day_t(DateTerm, false) :-
    nonvar(DateTerm),
    DateTerm \= date(_, _, _).

date_parts_integer_t(YearNumber, MonthNumber, DayNumber, Truth) :-
    part_integer_t(YearNumber, YearIsInteger),
    part_integer_t(MonthNumber, MonthIsInteger),
    part_integer_t(DayNumber, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, Truth).

part_integer_t(Part, false) :-
    var(Part).
part_integer_t(Part, Truth) :-
    nonvar(Part),
    integer_t(Part, Truth).

calendar_parts_t(false, _, _, _, false).
calendar_parts_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    within_bounds_t(1, 12, MonthNumber, MonthIsValid),
    day_of_month_t(MonthIsValid, YearNumber, MonthNumber, DayNumber, Truth).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_last_day(YearNumber, MonthNumber, LastDayOfMonth),
    within_bounds_t(1, LastDayOfMonth, DayNumber, Truth).

within_bounds_t(Lowest, Highest, Value, true) :-
    Value >= Lowest,
    Value =< Highest.
within_bounds_t(Lowest, _, Value, false) :-
    Value < Lowest.
within_bounds_t(_, Highest, Value, false) :-
    Value > Highest.

test(a_well_formed_profile_has_no_problem) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, unsure)], []).
test(an_empty_profile_has_no_problem) :-
    cra_administrative_fines_input_problems([], []).
test(problems_come_in_contract_order_then_unknown_keys) :-
    FloatTurnover is float(1),
    cra_administrative_fines_input_problems([attribute(colour, red), attribute(offender_is_undertaking, true), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, FloatTurnover)], Problems),
    Problems == [duplicate_key(offender_is_undertaking), wrong_type(total_worldwide_annual_turnover_in_euros), unknown_key(colour)].
test(a_provision_outside_the_closed_list_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_99)], [wrong_type(infringed_provision)]).
test(a_list_holding_a_non_attribute_is_not_a_profile) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_13), colour], [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    cra_administrative_fines_input_problems(_, [wrong_type(profile)]).
test(the_contract_keys_in_order) :-
    cra_administrative_fines_contract_keys([infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros]).
test(the_application_day_is_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2027, 12, 11), true).
test(leap_day_2028_is_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2028, 2, 29), true).
test(leap_day_2027_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2027, 2, 29), false).
test(a_float_year_is_not_a_calendar_day) :-
    FloatYear is float(2028),
    cra_administrative_fines_calendar_day_t(date(FloatYear, 1, 1), false).
test(month_thirteen_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2028, 13, 1), false).
test(an_unbound_date_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(_, false).
test(a_date_with_an_unbound_day_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2028, 1, _), false).
test(an_atom_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(tomorrow, false).
test(the_calendar_check_gives_one_answer) :-
    findall(Truth, cra_administrative_fines_calendar_day_t(date(2028, 2, 29), Truth), Truths),
    Truths == [true].

test(leap_day_2027_is_never_true, fail) :-
    cra_administrative_fines_calendar_day_t(date(2027, 2, 29), true).
