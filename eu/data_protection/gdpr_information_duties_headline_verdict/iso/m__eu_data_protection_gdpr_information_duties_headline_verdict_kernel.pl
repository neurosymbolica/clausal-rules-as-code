% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2, contract_keys/1, key_status/3, attested_status/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

contract_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

key_status(Profile, Key, unknown([Key])) :-
    profile_lacks(Profile, Key).
key_status(Profile, Key, value(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

attested_status(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
attested_status(Profile, Key, value(AttestedValue)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(AttestedValue, _)).

gdpr_information_duties_headline_verdict_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    contract_keys(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(personal_data_collected_from_data_subject, boolean).
key_type(items_provided, list(item_provided)).
key_type(items_data_subject_already_has, list(item)).
key_type(data_protection_officer_designated, boolean).
key_type(processing_based_on_legitimate_interests, boolean).
key_type(recipients_exist, boolean).
key_type(transfer_intended, boolean).
key_type(processing_based_on_consent, boolean).
key_type(automated_decision_making_under_article_22, judgement).
key_type(obtaining_date, date).
key_type(provision_date, date).
key_type(data_used_for_communication_with_data_subject, boolean).
key_type(first_communication_date, date).
key_type(disclosure_to_another_recipient_envisaged, boolean).
key_type(first_disclosure_date, date).
key_type(provided_within_reasonable_period, judgement).
key_type(provision_impossible_or_disproportionate_effort, judgement).
key_type(protective_measures_taken, boolean).
key_type(obtaining_or_disclosure_laid_down_by_law, outside_fact).
key_type(professional_secrecy_obligation_by_law, outside_fact).
key_type(further_processing_for_another_purpose_intended, boolean).
key_type(further_processing_start_date, date).
key_type(further_processing_information_date, date).
key_type(further_processing_items_provided, list(item)).
key_type(paragraph_2_information_relevant_to_further_processing, judgement).
key_type(public_holidays, public_holidays_fact).

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

in_type_t(item_provided, Value, T) :-
    in_type_t(enum([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, legitimate_interests, recipients_or_categories_of_recipients, third_country_transfer_information, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_withdraw_consent, right_to_lodge_complaint, statutory_or_contractual_requirement, source_of_personal_data, automated_decision_making_information]), Value, T).
in_type_t(item, Value, T) :-
    in_type_t(enum([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, legitimate_interests, recipients_or_categories_of_recipients, third_country_transfer_information, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_withdraw_consent, right_to_lodge_complaint, statutory_or_contractual_requirement, source_of_personal_data, automated_decision_making_information, other_purpose_information]), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(public_holidays_fact, Value, T) :-
    in_type_t(attested(list(date)), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(date, Value, T) :-
    calendar_date_t(Value, T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(list(Type), Value, T) :-
    list_in_type_t(Value, Type, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

list_in_type_t(Value, _, true) :-
    Value == [].
list_in_type_t([Element|Elements], Type, T) :-
    in_type_t(Type, Element, ElementInType),
    list_in_type_t(Elements, Type, ElementsInType),
    truth_and(ElementInType, ElementsInType, T).
list_in_type_t(Value, _, false) :-
    Value \== [],
    Value \= [_|_].

attested_t(attested(AttestedValue, Attestation), Type, T) :-
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, Type, AttestedValue, T).
attested_t(Value, _, false) :-
    Value \= attested(_, _).

attestation_t(attestation(_, _, _, _), true).
attestation_t(Value, false) :-
    Value \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, Type, AttestedValue, T) :-
    in_type_t(Type, AttestedValue, T).

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

test(a_well_formed_profile_has_no_problem) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2028, 2, 29)), attribute(automated_decision_making_under_article_22, unsure)], []).
test(the_empty_profile_has_no_problem) :-
    gdpr_information_duties_headline_verdict_input_problems([], []).
test(an_atom_is_not_a_profile) :-
    gdpr_information_duties_headline_verdict_input_problems(foo, [wrong_type(profile)]).
test(duplicate_wrong_type_and_unknown_in_order) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(items_provided, []), attribute(obtaining_date, date(2026, 2, 30)), attribute(items_provided, [not_an_item]), attribute(colour, red), attribute(colour, blue)], [duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)]).
test(other_purpose_information_is_not_an_item_provided) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(items_provided, [other_purpose_information])], [wrong_type(items_provided)]).
test(other_purpose_information_may_be_already_held) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(items_data_subject_already_has, [other_purpose_information])], []).
test(a_crisp_flag_given_unsure_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(recipients_exist, unsure)], [wrong_type(recipients_exist)]).
test(an_attested_outside_fact_is_well_formed) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(professional_secrecy_obligation_by_law, attested(true, attestation(by, at, reason, none))), attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))], []).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(obtaining_or_disclosure_laid_down_by_law, true)], [wrong_type(obtaining_or_disclosure_laid_down_by_law)]).
test(the_input_check_has_one_answer) :-
    findall(Problems, gdpr_information_duties_headline_verdict_input_problems([attribute(recipients_exist, true)], Problems), Answers),
    Answers == [[]].
test(an_absent_key_is_unknown) :-
    key_status([attribute(recipients_exist, true)], transfer_intended, unknown([transfer_intended])).
test(a_present_key_gives_its_value) :-
    key_status([attribute(provided_within_reasonable_period, unsure)], provided_within_reasonable_period, value(unsure)).
test(an_absent_outside_fact_is_absent) :-
    attested_status([], professional_secrecy_obligation_by_law, absent).
test(an_attested_outside_fact_gives_its_value) :-
    attested_status([attribute(obtaining_or_disclosure_laid_down_by_law, attested(false, attestation(by, at, reason, none)))], obtaining_or_disclosure_laid_down_by_law, value(false)).
test(the_contract_has_twenty_six_keys) :-
    contract_keys(Keys),
    length(Keys, 26).

test(an_atom_is_not_a_clean_profile, fail) :-
    gdpr_information_duties_headline_verdict_input_problems(foo, []).
test(an_absent_key_has_no_value, fail) :-
    key_status([attribute(recipients_exist, true)], transfer_intended, value(_)).
