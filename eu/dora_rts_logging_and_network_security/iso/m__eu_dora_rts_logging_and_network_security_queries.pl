% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_queries, [dora_rts_logging_and_network_security_profile_keys/1, dora_rts_logging_and_network_security_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [dora_rts_logging_and_network_security_status/2]).

dora_rts_logging_and_network_security_profile_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, financial_entity_has_ict_systems_supporting_critical_or_important_functions, logging_procedures_protocols_and_tools_developed_documented_and_implemented, logging_procedures_identify_logged_events_retention_and_log_data_security, logging_detail_aligned_with_purpose_and_usage, logging_covers_access_control_and_identity_management_events, logging_covers_capacity_management_events, logging_covers_change_management_events, logging_covers_ict_operations_events, logging_covers_network_traffic_events, logging_systems_and_log_information_protected, logging_system_failure_detection_measures_in_place, ict_system_clocks_synchronised_to_reliable_reference_time_source, log_retention_period_established_taking_into_account_required_considerations, network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, network_connections_and_data_flows_documented, separate_dedicated_administration_network_used, network_access_controls_identified_and_implemented, network_connections_encrypted, networks_designed_in_line_with_ict_security_requirements, traffic_to_internet_and_external_connections_secured, firewall_rules_roles_responsibilities_and_steps_identified, network_architecture_and_security_design_reviewed_once_a_year, network_architecture_and_security_design_reviewed_periodically, subnetworks_and_network_components_isolation_measures_in_place, secure_network_configuration_baseline_and_hardening_implemented, inactive_system_and_remote_sessions_limited_locked_and_terminated, network_services_security_measures_and_service_levels_specified, network_services_provider_type_identified, firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, data_protected_during_network_transmission_with_compliance_assessment, data_leakage_prevented_and_detected_and_external_transfer_secured, confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, information_in_transit_policies_designed_on_classification_and_risk_assessment]).

dora_rts_logging_and_network_security_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_value(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_rts_logging_and_network_security_status(Hypothesis, NewStatus).

profile_with_value(Profile, ProfileKey, NewValue, NewProfile) :-
    key_occurs_t(Profile, ProfileKey, Occurs),
    set_key_value(Occurs, Profile, ProfileKey, NewValue, NewProfile).

set_key_value(true, Profile, ProfileKey, NewValue, NewProfile) :-
    replace_key_values(Profile, ProfileKey, NewValue, NewProfile).
set_key_value(false, Profile, ProfileKey, NewValue, NewProfile) :-
    append(Profile, [attribute(ProfileKey, NewValue)], NewProfile).

key_occurs_t([], _, false).
key_occurs_t([attribute(ElementKey, _)|_], ProfileKey, true) :-
    ElementKey == ProfileKey.
key_occurs_t([attribute(ElementKey, _)|Remaining], ProfileKey, Occurs) :-
    ElementKey \== ProfileKey,
    key_occurs_t(Remaining, ProfileKey, Occurs).

replace_key_values([], _, _, []).
replace_key_values([attribute(ElementKey, _)|Remaining], ProfileKey, NewValue, [attribute(ElementKey, NewValue)|NewRemaining]) :-
    ElementKey == ProfileKey,
    replace_key_values(Remaining, ProfileKey, NewValue, NewRemaining).
replace_key_values([attribute(ElementKey, OldValue)|Remaining], ProfileKey, NewValue, [attribute(ElementKey, OldValue)|NewRemaining]) :-
    ElementKey \== ProfileKey,
    replace_key_values(Remaining, ProfileKey, NewValue, NewRemaining).

test(the_key_schema_has_thirty_eight_keys) :-
    dora_rts_logging_and_network_security_profile_keys(ProfileKeys),
    length(ProfileKeys, 38).
test(the_key_schema_starts_with_the_gate) :-
    dora_rts_logging_and_network_security_profile_keys([financial_entity_is_article_16_1_entity|_]).
test(setting_the_gate_true_answers_simplified_framework_entity) :-
    dora_rts_logging_and_network_security_what_if([attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(an_absent_key_is_added) :-
    profile_with_value([], financial_entity_is_article_16_1_entity, true, NewProfile),
    NewProfile == [attribute(financial_entity_is_article_16_1_entity, true)].
test(a_present_key_is_replaced_in_place) :-
    profile_with_value([attribute(financial_entity_is_article_16_1_entity, false), attribute(network_connections_encrypted, true)], network_connections_encrypted, false, NewProfile),
    NewProfile == [attribute(financial_entity_is_article_16_1_entity, false), attribute(network_connections_encrypted, false)].
