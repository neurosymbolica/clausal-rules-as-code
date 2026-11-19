% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_kernel, [dpdp_notice_consent_input_problems/2, key_state/3, relied_pairs/3, referral/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, value(Value)) :-
    profile_get(Profile, Key, Value).

relied_pairs(_, [], []).
relied_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    relied_pairs(Profile, Keys, LaterPairs),
    add_relied_pair(State, Key, LaterPairs, Pairs).

add_relied_pair(absent, _, Pairs, Pairs).
add_relied_pair(value(Value), Key, Pairs, [Key - Value|Pairs]).

referral(Key, CitationKey, Profile, PairsListKeys, needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])) :-
    relied_pairs(Profile, PairsListKeys, Pairs).

dpdp_notice_consent_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [sections_4_to_7_in_force, section_6_9_in_force, question_date, acts_as_data_fiduciary, lawful_purpose, consent_given, consent_withdrawn, consent_meets_section_6_1, legitimate_use_clause, legitimate_use_conditions_met, notice_occasion, processing_required_or_authorised_by_law, registered_with_board_as_consent_manager, consent_manager_registration_suspended_or_cancelled],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(sections_4_to_7_in_force, boolean).
key_type(section_6_9_in_force, boolean).
key_type(question_date, date).
key_type(acts_as_data_fiduciary, judgement).
key_type(lawful_purpose, judgement).
key_type(consent_given, boolean).
key_type(consent_withdrawn, boolean).
key_type(consent_meets_section_6_1, judgement).
key_type(legitimate_use_clause, legitimate_use_clause_value).
key_type(legitimate_use_conditions_met, judgement).
key_type(notice_occasion, notice_occasion_value).
key_type(processing_required_or_authorised_by_law, judgement).
key_type(registered_with_board_as_consent_manager, boolean).
key_type(consent_manager_registration_suspended_or_cancelled, boolean).

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
in_type_t(legitimate_use_clause_value, Value, T) :-
    in_type_t(enum([voluntarily_provided_for_specified_purpose, state_subsidy_benefit_service_certificate_licence_or_permit, state_function_or_sovereignty_integrity_or_security, legal_obligation_to_disclose_to_state, compliance_with_judgment_decree_or_order, medical_emergency, epidemic_outbreak_or_public_health_threat, disaster_or_breakdown_of_public_order, employment_purposes, no_listed_use]), Value, T).
in_type_t(notice_occasion_value, Value, T) :-
    in_type_t(enum([request_for_consent, consent_given_before_commencement, no_notice_occasion]), Value, T).
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
    between_t(1, 9999, Year, IsYear),
    year_in_range_day_t(IsYear, Year, Month, DayNumber, T).

year_in_range_day_t(false, _, _, _, false).
year_in_range_day_t(true, Year, Month, DayNumber, T) :-
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

test(a_well_formed_profile_has_no_problem) :-
    dpdp_notice_consent_input_problems([attribute(consent_given, true), attribute(lawful_purpose, unsure)], []).
test(a_non_list_is_not_a_profile) :-
    dpdp_notice_consent_input_problems(nothing, [wrong_type(profile)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    dpdp_notice_consent_input_problems([attribute(consent_given, unsure)], [wrong_type(consent_given)]).
test(a_duplicate_key_is_not_also_wrong_type) :-
    dpdp_notice_consent_input_problems([attribute(consent_given, maybe), attribute(consent_given, true)], [duplicate_key(consent_given)]).
test(an_unknown_key_is_named_once) :-
    dpdp_notice_consent_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(an_absent_key_reads_as_absent) :-
    key_state([attribute(consent_given, true)], lawful_purpose, absent).
test(a_present_key_reads_its_value) :-
    key_state([attribute(consent_given, true)], consent_given, value(true)).
test(a_referral_carries_the_present_judgements_in_order) :-
    referral(lawful_purpose, in_dpdp_act_2023_s_4_2, [attribute(consent_meets_section_6_1, false), attribute(lawful_purpose, unsure)], [lawful_purpose, consent_meets_section_6_1], Result),
    Result == needs_legal_review(open_textured(lawful_purpose, cite(in_dpdp_act_2023_s_4_2)), [inputs_relied_on([lawful_purpose - unsure, consent_meets_section_6_1 - false])]).
