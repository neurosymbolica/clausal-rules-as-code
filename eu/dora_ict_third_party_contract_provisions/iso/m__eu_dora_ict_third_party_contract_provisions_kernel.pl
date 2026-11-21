% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_kernel, [dora_ict_third_party_contract_provisions_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_third_party_contract_provisions_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [contract_provides_termination_for_significant_breach, contract_provides_termination_for_circumstances_altering_performance, contract_provides_termination_for_risk_management_weaknesses, contract_provides_termination_where_supervision_impeded, contract_is_single_written_document, contract_provides_description_of_functions_services_and_subcontracting, contract_provides_service_and_data_locations, contract_provides_data_protection_provisions, contract_provides_data_access_recovery_and_return, contract_provides_service_level_descriptions, contract_provides_incident_assistance, contract_provides_cooperation_with_authorities, contract_provides_termination_rights_and_notice_periods, contract_provides_security_awareness_and_training_participation, supports_critical_or_important_function, contract_provides_full_service_levels_with_performance_targets, contract_provides_notice_periods_and_reporting_obligations, contract_provides_contingency_plans_and_security_measures, contract_provides_threat_led_penetration_testing_participation, contract_provides_monitoring_rights_of_the_authorities, contract_provides_exit_strategy_and_transition_period, contract_provides_monitoring_rights_of_the_financial_entity, financial_entity_is_microenterprise, contract_provides_delegated_access_inspection_and_audit],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(contract_provides_termination_for_significant_breach, judgement).
key_type(contract_provides_termination_for_circumstances_altering_performance, judgement).
key_type(contract_provides_termination_for_risk_management_weaknesses, judgement).
key_type(contract_provides_termination_where_supervision_impeded, judgement).
key_type(contract_is_single_written_document, judgement).
key_type(contract_provides_description_of_functions_services_and_subcontracting, judgement).
key_type(contract_provides_service_and_data_locations, judgement).
key_type(contract_provides_data_protection_provisions, judgement).
key_type(contract_provides_data_access_recovery_and_return, judgement).
key_type(contract_provides_service_level_descriptions, judgement).
key_type(contract_provides_incident_assistance, judgement).
key_type(contract_provides_cooperation_with_authorities, judgement).
key_type(contract_provides_termination_rights_and_notice_periods, judgement).
key_type(contract_provides_security_awareness_and_training_participation, judgement).
key_type(supports_critical_or_important_function, judgement).
key_type(contract_provides_full_service_levels_with_performance_targets, judgement).
key_type(contract_provides_notice_periods_and_reporting_obligations, judgement).
key_type(contract_provides_contingency_plans_and_security_measures, judgement).
key_type(contract_provides_threat_led_penetration_testing_participation, judgement).
key_type(contract_provides_monitoring_rights_of_the_authorities, judgement).
key_type(contract_provides_exit_strategy_and_transition_period, judgement).
key_type(contract_provides_monitoring_rights_of_the_financial_entity, judgement).
key_type(financial_entity_is_microenterprise, fact).
key_type(contract_provides_delegated_access_inspection_and_audit, judgement).

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
in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
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
