% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_incident_policy_and_detection_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, ict_related_incident_policy_developed_documented_and_implemented, ict_related_incident_management_process_documented, list_of_relevant_internal_and_external_contacts_established, technical_organisational_and_operational_incident_management_mechanisms_operated, incident_evidence_retained_for_a_period_no_longer_than_necessary, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, incident_evidence_retained_in_a_secure_manner, clear_roles_and_responsibilities_for_detection_and_response_set, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, anomalous_activities_identified_and_alerting_tools_implemented, alerts_prioritised_within_expected_resolution_time, information_on_anomalous_activities_recorded_analysed_and_evaluated, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, information_on_each_detected_anomalous_activity_logged, criteria_triggering_incident_detection_and_response_considered, criticality_of_affected_services_considered],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(ict_related_incident_policy_developed_documented_and_implemented, judgement).
key_type(ict_related_incident_management_process_documented, judgement).
key_type(list_of_relevant_internal_and_external_contacts_established, judgement).
key_type(technical_organisational_and_operational_incident_management_mechanisms_operated, judgement).
key_type(incident_evidence_retained_for_a_period_no_longer_than_necessary, judgement).
key_type(mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, judgement).
key_type(incident_evidence_retained_in_a_secure_manner, judgement).
key_type(clear_roles_and_responsibilities_for_detection_and_response_set, judgement).
key_type(factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, judgement).
key_type(anomalous_activities_identified_and_alerting_tools_implemented, judgement).
key_type(alerts_prioritised_within_expected_resolution_time, judgement).
key_type(information_on_anomalous_activities_recorded_analysed_and_evaluated, judgement).
key_type(alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, judgement).
key_type(records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, judgement).
key_type(information_on_each_detected_anomalous_activity_logged, judgement).
key_type(criteria_triggering_incident_detection_and_response_considered, judgement).
key_type(criticality_of_affected_services_considered, judgement).

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

in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
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
