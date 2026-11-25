% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_logging_and_network_security_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, financial_entity_has_ict_systems_supporting_critical_or_important_functions, logging_procedures_protocols_and_tools_developed_documented_and_implemented, logging_procedures_identify_logged_events_retention_and_log_data_security, logging_detail_aligned_with_purpose_and_usage, logging_covers_access_control_and_identity_management_events, logging_covers_capacity_management_events, logging_covers_change_management_events, logging_covers_ict_operations_events, logging_covers_network_traffic_events, logging_systems_and_log_information_protected, logging_system_failure_detection_measures_in_place, ict_system_clocks_synchronised_to_reliable_reference_time_source, log_retention_period_established_taking_into_account_required_considerations, network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, network_connections_and_data_flows_documented, separate_dedicated_administration_network_used, network_access_controls_identified_and_implemented, network_connections_encrypted, networks_designed_in_line_with_ict_security_requirements, traffic_to_internet_and_external_connections_secured, firewall_rules_roles_responsibilities_and_steps_identified, network_architecture_and_security_design_reviewed_once_a_year, network_architecture_and_security_design_reviewed_periodically, subnetworks_and_network_components_isolation_measures_in_place, secure_network_configuration_baseline_and_hardening_implemented, inactive_system_and_remote_sessions_limited_locked_and_terminated, network_services_security_measures_and_service_levels_specified, network_services_provider_type_identified, firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, data_protected_during_network_transmission_with_compliance_assessment, data_leakage_prevented_and_detected_and_external_transfer_secured, confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, information_in_transit_policies_designed_on_classification_and_risk_assessment],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(financial_entity_has_ict_systems_supporting_critical_or_important_functions, fact).
key_type(logging_procedures_protocols_and_tools_developed_documented_and_implemented, judgement).
key_type(logging_procedures_identify_logged_events_retention_and_log_data_security, judgement).
key_type(logging_detail_aligned_with_purpose_and_usage, judgement).
key_type(logging_covers_access_control_and_identity_management_events, judgement).
key_type(logging_covers_capacity_management_events, judgement).
key_type(logging_covers_change_management_events, judgement).
key_type(logging_covers_ict_operations_events, judgement).
key_type(logging_covers_network_traffic_events, judgement).
key_type(logging_systems_and_log_information_protected, judgement).
key_type(logging_system_failure_detection_measures_in_place, judgement).
key_type(ict_system_clocks_synchronised_to_reliable_reference_time_source, judgement).
key_type(log_retention_period_established_taking_into_account_required_considerations, judgement).
key_type(network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, judgement).
key_type(network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, judgement).
key_type(network_connections_and_data_flows_documented, judgement).
key_type(separate_dedicated_administration_network_used, judgement).
key_type(network_access_controls_identified_and_implemented, judgement).
key_type(network_connections_encrypted, judgement).
key_type(networks_designed_in_line_with_ict_security_requirements, judgement).
key_type(traffic_to_internet_and_external_connections_secured, judgement).
key_type(firewall_rules_roles_responsibilities_and_steps_identified, judgement).
key_type(network_architecture_and_security_design_reviewed_once_a_year, judgement).
key_type(network_architecture_and_security_design_reviewed_periodically, judgement).
key_type(subnetworks_and_network_components_isolation_measures_in_place, judgement).
key_type(secure_network_configuration_baseline_and_hardening_implemented, judgement).
key_type(inactive_system_and_remote_sessions_limited_locked_and_terminated, judgement).
key_type(network_services_security_measures_and_service_levels_specified, judgement).
key_type(network_services_provider_type_identified, judgement).
key_type(firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, judgement).
key_type(firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, judgement).
key_type(information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, judgement).
key_type(data_protected_during_network_transmission_with_compliance_assessment, judgement).
key_type(data_leakage_prevented_and_detected_and_external_transfer_secured, judgement).
key_type(confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, judgement).
key_type(information_in_transit_policies_designed_on_classification_and_risk_assessment, judgement).

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

test(an_empty_profile_has_no_problem) :-
    dora_rts_logging_and_network_security_input_problems([], []).
test(a_good_profile_has_no_problem) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(network_connections_encrypted, unsure)], []).
test(unsure_is_wrong_type_for_a_fact) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_microenterprise, unsure)], [wrong_type(financial_entity_is_microenterprise)]).
test(a_duplicate_key_is_not_also_wrong_type) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, 7), attribute(network_connections_encrypted, true)], [duplicate_key(network_connections_encrypted)]).
test(an_unknown_key_comes_after_contract_problems) :-
    dora_rts_logging_and_network_security_input_problems([attribute(colour, blue), attribute(financial_entity_is_microenterprise, 1)], [wrong_type(financial_entity_is_microenterprise), unknown_key(colour)]).
test(a_non_list_profile) :-
    dora_rts_logging_and_network_security_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_profile) :-
    dora_rts_logging_and_network_security_input_problems(_, [wrong_type(profile)]).

test(unsure_is_not_a_problem_for_a_judgement, fail) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, unsure)], [wrong_type(network_connections_encrypted)]).
