% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_binding_corporate_rules_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [policies_are_personal_data_protection_policies, policies_adhered_to_by_adhering_party, adhering_party_is_controller_or_processor, adhering_party_established_on_territory_of_member_state, policies_cover_transfers_to_third_countries, recipients_are_controllers_or_processors, transfers_within_group_of_undertakings_or_group_of_enterprises, rules_specify_group_structure_and_contact_details, rules_specify_data_transfers, rules_specify_legally_binding_nature, rules_specify_application_of_general_data_protection_principles, rules_specify_data_subject_rights_and_means_to_exercise_them, rules_specify_acceptance_of_liability_for_members_outside_union, rules_specify_how_information_is_provided_to_data_subjects, rules_specify_tasks_of_compliance_monitoring_persons, rules_specify_complaint_procedures, rules_specify_compliance_verification_mechanisms, rules_specify_change_reporting_and_recording_mechanisms, rules_specify_cooperation_mechanism_with_supervisory_authority, rules_specify_reporting_of_third_country_legal_requirements, rules_specify_appropriate_data_protection_training],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(policies_are_personal_data_protection_policies, boolean).
key_type(policies_adhered_to_by_adhering_party, boolean).
key_type(adhering_party_is_controller_or_processor, judgement).
key_type(adhering_party_established_on_territory_of_member_state, boolean).
key_type(policies_cover_transfers_to_third_countries, boolean).
key_type(recipients_are_controllers_or_processors, judgement).
key_type(transfers_within_group_of_undertakings_or_group_of_enterprises, judgement).
key_type(rules_specify_group_structure_and_contact_details, boolean).
key_type(rules_specify_data_transfers, boolean).
key_type(rules_specify_legally_binding_nature, boolean).
key_type(rules_specify_application_of_general_data_protection_principles, boolean).
key_type(rules_specify_data_subject_rights_and_means_to_exercise_them, boolean).
key_type(rules_specify_acceptance_of_liability_for_members_outside_union, boolean).
key_type(rules_specify_how_information_is_provided_to_data_subjects, boolean).
key_type(rules_specify_tasks_of_compliance_monitoring_persons, boolean).
key_type(rules_specify_complaint_procedures, boolean).
key_type(rules_specify_compliance_verification_mechanisms, boolean).
key_type(rules_specify_change_reporting_and_recording_mechanisms, boolean).
key_type(rules_specify_cooperation_mechanism_with_supervisory_authority, boolean).
key_type(rules_specify_reporting_of_third_country_legal_requirements, boolean).
key_type(rules_specify_appropriate_data_protection_training, judgement).

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

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).
