% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_kernel, [pdpa_data_breach_notification_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

pdpa_data_breach_notification_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [breach_occurred_date, within_organisation_only, breach_kinds, is_data_breach, breached_data, publicly_available_or_lawfully_disclosed, assessed_likely_significant_harm, affected_individuals_count, assessed_likely_significant_scale, prohibited_by_law_enforcement_agency, prohibited_by_commission_direction, commission_waiver_granted, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely, assessment_date, caller_role, reason_to_believe_breach_occurred, personal_data_in_possession_or_control, notified_by_data_intermediary],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(breach_occurred_date, date).
key_type(within_organisation_only, boolean).
key_type(breach_kinds, breach_kind_list).
key_type(is_data_breach, judgement).
key_type(breached_data, data_class_list).
key_type(publicly_available_or_lawfully_disclosed, schedule_data_class_list).
key_type(assessed_likely_significant_harm, judgement).
key_type(affected_individuals_count, non_negative_integer).
key_type(assessed_likely_significant_scale, judgement).
key_type(prohibited_by_law_enforcement_agency, boolean).
key_type(prohibited_by_commission_direction, boolean).
key_type(commission_waiver_granted, boolean).
key_type(remedial_action_renders_harm_unlikely, judgement).
key_type(prior_technological_measure_renders_harm_unlikely, judgement).
key_type(assessment_date, date).
key_type(caller_role, caller_role).
key_type(reason_to_believe_breach_occurred, judgement).
key_type(personal_data_in_possession_or_control, boolean).
key_type(notified_by_data_intermediary, boolean).

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

in_type_t(breach_kind_list, Value, T) :-
    in_type_t(non_empty_list(enum([unauthorised_access, unauthorised_collection, unauthorised_use, unauthorised_disclosure, unauthorised_copying, unauthorised_modification, unauthorised_disposal, loss_of_storage_medium])), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(data_class_list, Value, T) :-
    in_type_t(list(enum([full_name_or_alias, identification_number, account_identifier, account_access_credential, remuneration, income_from_sale_of_goods_or_property, payment_card_number, bank_or_finance_company_account_number, child_or_young_person_information, vulnerable_adult_information, specified_offence_victim_identification, place_of_safety_resident_identification, private_key, net_worth, deposit_of_moneys, withdrawal_of_moneys, credit_facilities, other_liabilities_incurred, payments_or_property_received, creditworthiness, capital_markets_investment, debts, insurance_policy_information, specified_medical_condition_treatment, reproductive_or_contraceptive_treatment, organ_donation_or_transplant, suicide_or_attempted_suicide, domestic_child_or_sexual_abuse, adoption_information, other_personal_data])), Value, T).
in_type_t(schedule_data_class_list, Value, T) :-
    in_type_t(list(enum([remuneration, income_from_sale_of_goods_or_property, payment_card_number, bank_or_finance_company_account_number, child_or_young_person_information, vulnerable_adult_information, specified_offence_victim_identification, place_of_safety_resident_identification, private_key, net_worth, deposit_of_moneys, withdrawal_of_moneys, credit_facilities, other_liabilities_incurred, payments_or_property_received, creditworthiness, capital_markets_investment, debts, insurance_policy_information, specified_medical_condition_treatment, reproductive_or_contraceptive_treatment, organ_donation_or_transplant, suicide_or_attempted_suicide, domestic_child_or_sexual_abuse, adoption_information])), Value, T).
in_type_t(caller_role, Value, T) :-
    in_type_t(enum([organisation, data_intermediary_for_organisation, data_intermediary_for_public_agency]), Value, T).
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
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).
in_type_t(non_empty_list(Type), Value, T) :-
    non_empty_list_in_type_t(Value, Type, T).

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

non_empty_list_in_type_t(Value, _, false) :-
    Value == [].
non_empty_list_in_type_t(Value, Type, T) :-
    Value \== [],
    list_in_type_t(Value, Type, T).

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

test(a_well_formed_profile_has_no_problem) :-
    pdpa_data_breach_notification_input_problems([attribute(is_data_breach, true), attribute(caller_role, organisation)], Problems),
    Problems == [].
test(a_repeated_key_is_a_duplicate_only) :-
    pdpa_data_breach_notification_input_problems([attribute(is_data_breach, true), attribute(is_data_breach, sometimes)], Problems),
    Problems == [duplicate_key(is_data_breach)].
test(a_crisp_key_given_unsure_is_wrong_type_then_unknown_key_last) :-
    pdpa_data_breach_notification_input_problems([attribute(colour, red), attribute(within_organisation_only, unsure)], Problems),
    Problems == [wrong_type(within_organisation_only), unknown_key(colour)].
test(a_judgement_key_given_unsure_is_well_formed) :-
    pdpa_data_breach_notification_input_problems([attribute(assessed_likely_significant_harm, unsure)], Problems),
    Problems == [].
test(an_empty_breach_kinds_list_is_wrong_type) :-
    pdpa_data_breach_notification_input_problems([attribute(breach_kinds, [])], Problems),
    Problems == [wrong_type(breach_kinds)].
test(an_empty_breached_data_list_is_well_formed) :-
    pdpa_data_breach_notification_input_problems([attribute(breached_data, [])], Problems),
    Problems == [].
test(a_negative_count_is_wrong_type) :-
    pdpa_data_breach_notification_input_problems([attribute(affected_individuals_count, -1)], Problems),
    Problems == [wrong_type(affected_individuals_count)].
test(a_partial_list_is_not_an_attribute_list) :-
    pdpa_data_breach_notification_input_problems([attribute(is_data_breach, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_an_attribute_list) :-
    pdpa_data_breach_notification_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(the_check_gives_exactly_one_answer) :-
    findall(Problems, pdpa_data_breach_notification_input_problems([attribute(within_organisation_only, true), attribute(within_organisation_only, true)], Problems), Answers),
    Answers == [[duplicate_key(within_organisation_only)]].

test(a_well_formed_profile_is_not_refused, fail) :-
    pdpa_data_breach_notification_input_problems([attribute(is_data_breach, true), attribute(caller_role, organisation)], [_|_]).
