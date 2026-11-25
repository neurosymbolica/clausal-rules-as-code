% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_incident_management_process_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [ict_related_incident_management_process_defined_established_and_implemented, all_ict_related_incidents_and_significant_cyber_threats_recorded, procedures_for_monitoring_handling_follow_up_and_root_causes_established, early_warning_indicators_put_in_place, procedures_to_identify_track_log_categorise_and_classify_incidents_established, roles_and_responsibilities_for_incident_types_and_scenarios_assigned, communication_notification_escalation_and_counterpart_information_plans_set_out, major_incidents_reported_to_senior_management_and_management_body_informed, incident_response_procedures_established, cyber_threats_classified_as_significant_on_the_article_18_2_criteria],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(ict_related_incident_management_process_defined_established_and_implemented, judgement).
key_type(all_ict_related_incidents_and_significant_cyber_threats_recorded, judgement).
key_type(procedures_for_monitoring_handling_follow_up_and_root_causes_established, judgement).
key_type(early_warning_indicators_put_in_place, judgement).
key_type(procedures_to_identify_track_log_categorise_and_classify_incidents_established, judgement).
key_type(roles_and_responsibilities_for_incident_types_and_scenarios_assigned, judgement).
key_type(communication_notification_escalation_and_counterpart_information_plans_set_out, judgement).
key_type(major_incidents_reported_to_senior_management_and_management_body_informed, judgement).
key_type(incident_response_procedures_established, judgement).
key_type(cyber_threats_classified_as_significant_on_the_article_18_2_criteria, judgement).

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

test(an_empty_profile_has_no_problem) :-
    dora_ict_incident_management_process_input_problems([], []).
test(a_judgement_key_with_a_judgement_value_has_no_problem) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, unsure)], []).
test(a_non_list_profile_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems(not_a_list, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems(_, [wrong_type(profile)]).
test(a_value_outside_the_judgement_type_is_wrong_type) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, yes)], [wrong_type(early_warning_indicators_put_in_place)]).
test(a_repeated_contract_key_is_duplicate_key_only) :-
    dora_ict_incident_management_process_input_problems([attribute(incident_response_procedures_established, true), attribute(incident_response_procedures_established, maybe)], [duplicate_key(incident_response_procedures_established)]).
test(a_key_outside_the_contract_is_unknown_key) :-
    dora_ict_incident_management_process_input_problems([attribute(colour, red)], [unknown_key(colour)]).
