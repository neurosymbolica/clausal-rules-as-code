% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_kernel, [uae_pdpl_lawful_processing_and_consent_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(reif), [memberd_t/3]).

uae_pdpl_lawful_processing_and_consent_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [processing_date, consent_given, consent_specific_clear_and_unambiguous, controller_able_to_prove_consent, consent_clear_simple_unambiguous_and_easily_accessible, consent_includes_right_to_withdraw_easily, consent_withdrawn_before_processing, necessary_to_protect_public_interest, personal_data_made_available_and_known_to_all_by_data_subject, necessary_for_legal_claims_defence_of_rights_or_judicial_or_security_procedures, necessary_for_occupational_or_preventive_medicine_or_health_or_social_care, necessary_to_protect_public_health, necessary_for_archival_purposes_or_scientific_historical_or_statistical_studies, necessary_to_protect_interests_of_data_subject, necessary_for_employment_social_security_or_social_protection_obligations_and_rights, necessary_for_contract_with_data_subject, necessary_for_specific_obligations_of_controller_under_other_laws, processed_fairly_transparently_and_lawfully, collected_for_specific_and_clear_purpose, later_processing_compatible_with_purpose, sufficient_and_limited_to_what_is_necessary, accurate_correct_and_updated, measures_taken_to_delete_or_correct_incorrect_data, kept_securely, not_kept_after_purpose_exhausted],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(processing_date, date).
key_type(consent_given, boolean).
key_type(consent_specific_clear_and_unambiguous, judgement).
key_type(controller_able_to_prove_consent, boolean).
key_type(consent_clear_simple_unambiguous_and_easily_accessible, judgement).
key_type(consent_includes_right_to_withdraw_easily, judgement).
key_type(consent_withdrawn_before_processing, boolean).
key_type(necessary_to_protect_public_interest, judgement).
key_type(personal_data_made_available_and_known_to_all_by_data_subject, judgement).
key_type(necessary_for_legal_claims_defence_of_rights_or_judicial_or_security_procedures, judgement).
key_type(necessary_for_occupational_or_preventive_medicine_or_health_or_social_care, judgement).
key_type(necessary_to_protect_public_health, judgement).
key_type(necessary_for_archival_purposes_or_scientific_historical_or_statistical_studies, judgement).
key_type(necessary_to_protect_interests_of_data_subject, judgement).
key_type(necessary_for_employment_social_security_or_social_protection_obligations_and_rights, judgement).
key_type(necessary_for_contract_with_data_subject, judgement).
key_type(necessary_for_specific_obligations_of_controller_under_other_laws, judgement).
key_type(processed_fairly_transparently_and_lawfully, judgement).
key_type(collected_for_specific_and_clear_purpose, judgement).
key_type(later_processing_compatible_with_purpose, judgement).
key_type(sufficient_and_limited_to_what_is_necessary, judgement).
key_type(accurate_correct_and_updated, judgement).
key_type(measures_taken_to_delete_or_correct_incorrect_data, judgement).
key_type(kept_securely, judgement).
key_type(not_kept_after_purpose_exhausted, judgement).

calendar_year_bounds(1, 9999).

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

integer_t(Value, T) :-
    catch(integer_value_t(Value, T), error(_, _), T = false).

integer_value_t(Value, true) :-
    must_be(integer, Value).

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
    calendar_year_bounds(LowestYear, HighestYear),
    between_t(LowestYear, HighestYear, Year, IsYear),
    calendar_month_day_t(IsYear, Year, Month, DayNumber, T).

calendar_month_day_t(false, _, _, _, false).
calendar_month_day_t(true, Year, Month, DayNumber, T) :-
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
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems([], Problems), Answers),
    Answers == [[]].
test(the_first_day_of_force_is_a_valid_date) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2022, 1, 2))], Problems),
    Problems == [].
test(year_one_is_a_valid_date) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(1, 1, 1))], Problems),
    Problems == [].
test(year_9999_is_a_valid_date) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(9999, 12, 31))], Problems),
    Problems == [].
test(year_zero_is_wrong_type) :-
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(0, 1, 1))], Problems), Answers),
    Answers == [[wrong_type(processing_date)]].
test(a_negative_year_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(-5, 1, 1))], Problems),
    Problems == [wrong_type(processing_date)].
test(year_10000_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(10000, 1, 1))], Problems),
    Problems == [wrong_type(processing_date)].
test(a_compound_day_is_wrong_type) :-
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2023, 1, 1 + 0))], Problems), Answers),
    Answers == [[wrong_type(processing_date)]].
test(an_atom_month_is_wrong_type) :-
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2023, june, 1))], Problems), Answers),
    Answers == [[wrong_type(processing_date)]].
test(a_leap_day_is_valid) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2024, 2, 29))], Problems),
    Problems == [].
test(a_leap_day_in_a_common_year_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2023, 2, 29))], Problems),
    Problems == [wrong_type(processing_date)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, unsure)], Problems),
    Problems == [wrong_type(consent_given)].
test(a_judgement_given_unsure_is_well_formed) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(kept_securely, unsure)], Problems),
    Problems == [].
test(a_repeated_contract_key_is_one_duplicate) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, true), attribute(consent_given, maybe)], Problems),
    Problems == [duplicate_key(consent_given)].
test(unknown_variable_keys_keep_their_first_order) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(FirstKey, 1), attribute(SecondKey, 2), attribute(FirstKey, 3)], Problems),
    Problems == [unknown_key(FirstKey), unknown_key(SecondKey)].
test(contract_problems_come_before_unknown_keys) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(color, red), attribute(kept_securely, maybe)], Problems),
    Problems == [wrong_type(kept_securely), unknown_key(color)].
test(a_partial_list_is_not_a_profile) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_stray_element_is_not_a_profile) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, true), stray], Problems),
    Problems == [wrong_type(profile)].

test(year_zero_is_not_well_formed, fail) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(0, 1, 1))], []).
