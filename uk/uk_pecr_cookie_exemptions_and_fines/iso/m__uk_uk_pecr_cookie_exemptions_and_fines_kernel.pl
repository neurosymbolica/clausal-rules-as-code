% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_kernel, [uk_pecr_cookie_exemptions_and_fines_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, consent_to_the_storage_or_access_given, technical_storage_or_access_solely_for_transmission_of_a_communication, information_society_service_requested_by_the_subscriber_or_user, storage_or_access_strictly_necessary_for_the_requested_service, person_provides_an_information_society_service, sole_purpose_is_statistical_information_to_improve_the_service_or_website, collected_information_shared_only_to_assist_with_improvements, access_does_not_collect_or_monitor_automatically_emitted_information, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected, person_provides_an_information_society_service_by_means_of_a_website, sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality, communication_received_requests_or_indicates_need_of_emergency_assistance, sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance, storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided, provider_of_a_public_electronic_communications_service, personal_data_breach_occurred, became_aware_on_or_after_20_august_2025, notification_made_without_undue_delay, hours_elapsed_at_notification, notification_within_72_hours_was_feasible, notification_accompanied_by_reasons_for_the_delay, act_or_omission_on_or_after_5_february_2026, provision_infringed, penalised_person_is_an_undertaking, total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(storage_or_access_within_regulation_6, judgement).
key_type(clear_and_comprehensive_information_about_the_purpose_provided, judgement).
key_type(consent_to_the_storage_or_access_given, judgement).
key_type(technical_storage_or_access_solely_for_transmission_of_a_communication, judgement).
key_type(information_society_service_requested_by_the_subscriber_or_user, judgement).
key_type(storage_or_access_strictly_necessary_for_the_requested_service, judgement).
key_type(person_provides_an_information_society_service, judgement).
key_type(sole_purpose_is_statistical_information_to_improve_the_service_or_website, judgement).
key_type(collected_information_shared_only_to_assist_with_improvements, judgement).
key_type(access_does_not_collect_or_monitor_automatically_emitted_information, judgement).
key_type(simple_free_means_of_objecting_given, judgement).
key_type(subscriber_or_user_has_not_objected, boolean).
key_type(person_provides_an_information_society_service_by_means_of_a_website, judgement).
key_type(sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality, judgement).
key_type(communication_received_requests_or_indicates_need_of_emergency_assistance, judgement).
key_type(sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance, judgement).
key_type(storage_or_access_in_terminal_equipment, judgement).
key_type(storage_or_access_solely_for_transmission, judgement).
key_type(service_explicitly_requested_by_user, judgement).
key_type(strictly_necessary_to_provide_requested_service, judgement).
key_type(user_consent_given, judgement).
key_type(clear_and_comprehensive_information_provided, judgement).
key_type(provider_of_a_public_electronic_communications_service, judgement).
key_type(personal_data_breach_occurred, judgement).
key_type(became_aware_on_or_after_20_august_2025, boolean).
key_type(notification_made_without_undue_delay, judgement).
key_type(hours_elapsed_at_notification, non_negative_integer).
key_type(notification_within_72_hours_was_feasible, judgement).
key_type(notification_accompanied_by_reasons_for_the_delay, boolean).
key_type(act_or_omission_on_or_after_5_february_2026, boolean).
key_type(provision_infringed, enum([regulation_5, regulation_6, regulation_7, regulation_8, regulation_14, regulation_19, regulation_20, regulation_21, regulation_21a, regulation_21b, regulation_22, regulation_23, regulation_24, regulation_32b_4_or_5, commission_notice_not_complied_with, section_142_8b_of_the_data_protection_act_2018, other_provision_of_the_pec_regulations])).
key_type(penalised_person_is_an_undertaking, judgement).
key_type(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds, non_negative_integer).

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
