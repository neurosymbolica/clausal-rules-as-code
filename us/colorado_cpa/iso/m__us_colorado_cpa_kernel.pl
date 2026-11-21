% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_kernel, [colorado_cpa_input_problems/2, query_problems/3, date_plus_days/3, date_plus_months_same_day/3, date_earlier/2, date_on_or_earlier/2, date_later_of/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_datetime, [date_add/3, timedelta/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(deadline_lib, [month_last_day/3]).

colorado_cpa_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [entity_category, colorado_link_for_general_duties, consumer_count, revenue_or_discount_from_sale, processes_biometric_data, colorado_link_for_minors_duties, extension_reasonably_necessary, extension_notice_given_within_initial_period, appeal_extension_reasonably_necessary, appeal_extension_notice_given_within_initial_period, action_enforces_minors_duties, cure_deemed_possible, cured_within_cure_period, processes_for_targeted_advertising_or_sale],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(entity_category, entity_category).
key_type(colorado_link_for_general_duties, judgement).
key_type(consumer_count, non_negative_integer).
key_type(revenue_or_discount_from_sale, boolean).
key_type(processes_biometric_data, boolean).
key_type(colorado_link_for_minors_duties, judgement).
key_type(extension_reasonably_necessary, judgement).
key_type(extension_notice_given_within_initial_period, boolean).
key_type(appeal_extension_reasonably_necessary, judgement).
key_type(appeal_extension_notice_given_within_initial_period, boolean).
key_type(action_enforces_minors_duties, boolean).
key_type(cure_deemed_possible, boolean).
key_type(cured_within_cure_period, boolean).
key_type(processes_for_targeted_advertising_or_sale, boolean).

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
    in_type_t(enum([financial_institution_or_affiliate_subject_to_glba, air_carrier, national_securities_association, none_of_the_exempt_categories]), Value, T).
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
    colorado_cpa_input_problems(Profile, ProfileProblems),
    date_argument_problems(NamedDates, DateProblems),
    append(ProfileProblems, DateProblems, Problems).

date_argument_problems([], []).
date_argument_problems([Name - Date|NamedDates], Problems) :-
    date_term_valid_t(Date, IsValid),
    date_argument_problems(NamedDates, LaterProblems),
    name_date_problem(IsValid, Name, LaterProblems, Problems).

name_date_problem(true, _, Problems, Problems).
name_date_problem(false, Name, Problems, [wrong_type(Name)|Problems]).

earliest_accepted_year(2000).

latest_accepted_year(2100).

date_term_valid_t(Term, false) :-
    term_variables(Term, [_|_]).
date_term_valid_t(Term, T) :-
    term_variables(Term, []),
    Term = date(Year, Month, Day),
    date_fields_valid_t(Year, Month, Day, T).
date_term_valid_t(Term, false) :-
    term_variables(Term, []),
    Term \= date(_, _, _).

date_fields_valid_t(Year, Month, Day, T) :-
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, FieldsAreIntegers),
    integer_fields_valid_t(FieldsAreIntegers, Year, Month, Day, T).

integer_fields_valid_t(false, _, _, _, false).
integer_fields_valid_t(true, Year, Month, Day, T) :-
    earliest_accepted_year(EarliestYear),
    latest_accepted_year(LatestYear),
    closed_range_t(EarliestYear, LatestYear, Year, YearInRange),
    closed_range_t(1, 12, Month, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearAndMonthInRange),
    day_valid_t(YearAndMonthInRange, Year, Month, Day, T).

day_valid_t(false, _, _, _, false).
day_valid_t(true, Year, Month, Day, T) :-
    month_last_day(Year, Month, LastDay),
    closed_range_t(1, LastDay, Day, T).

closed_range_t(Low, High, Value, true) :-
    Value >= Low,
    Value =< High.
closed_range_t(Low, _, Value, false) :-
    Value < Low.
closed_range_t(_, High, Value, false) :-
    Value > High.

date_plus_days(Date, Days, Result) :-
    timedelta(Days, 0, Period),
    date_add(Date, Period, Result).

date_plus_months_same_day(date(Year, Month, Day), Months, date(NewYear, NewMonth, NewDay)) :-
    MonthIndex #= Year * 12 + Month - 1 + Months,
    NewYear #= MonthIndex // 12,
    NewMonth #= MonthIndex mod 12 + 1,
    month_last_day(NewYear, NewMonth, LastDay),
    NewDay #= min(Day, LastDay).

date_earlier(First, Second) :-
    days_between(Second, First, ElapsedDays),
    ElapsedDays #> 0.

date_on_or_earlier(First, Second) :-
    days_between(Second, First, ElapsedDays),
    ElapsedDays #>= 0.

date_later_of(First, Second, Second) :-
    date_earlier(First, Second).
date_later_of(First, Second, First) :-
    date_on_or_earlier(Second, First).

test(a_well_formed_profile_and_date_have_no_problem) :-
    query_problems([attribute(consumer_count, 5)], [received_date - date(2026, 1, 1)], []).
test(a_day_missing_from_a_common_year_is_wrong_type) :-
    query_problems([], [received_date - date(2027, 2, 29)], [wrong_type(received_date)]).
test(a_leap_day_is_a_real_day) :-
    query_problems([], [received_date - date(2028, 2, 29)], []).
test(a_year_before_two_thousand_is_wrong_type) :-
    query_problems([], [list_added_date - date(1999, 12, 31)], [wrong_type(list_added_date)]).
test(an_unbound_date_is_wrong_type) :-
    query_problems([], [reference_date - _], [wrong_type(reference_date)]).
test(date_problems_follow_profile_problems_in_signature_order) :-
    query_problems(nonsense, [notice_received_date - date(2026, 13, 1), reference_date - x], [wrong_type(profile), wrong_type(notice_received_date), wrong_type(reference_date)]).
test(forty_five_days_cross_a_month_end) :-
    date_plus_days(date(2026, 1, 1), 45, date(2026, 2, 15)).
test(six_months_keep_the_day_number) :-
    date_plus_months_same_day(date(2024, 3, 15), 6, date(2024, 9, 15)).
test(six_months_clamp_to_a_leap_day) :-
    date_plus_months_same_day(date(2027, 8, 31), 6, date(2028, 2, 29)).
test(six_months_clamp_to_the_end_of_a_common_february) :-
    date_plus_months_same_day(date(2026, 8, 31), 6, date(2027, 2, 28)).
test(the_day_before_is_earlier) :-
    date_earlier(date(2025, 9, 30), date(2025, 10, 1)).
test(the_same_day_is_on_or_earlier) :-
    date_on_or_earlier(date(2025, 10, 1), date(2025, 10, 1)).
test(equal_dates_give_one_later_date) :-
    findall(Later, date_later_of(date(2024, 7, 1), date(2024, 7, 1), Later), Laters),
    Laters == [date(2024, 7, 1)].

test(the_same_day_is_not_earlier, fail) :-
    date_earlier(date(2025, 10, 1), date(2025, 10, 1)).
