% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_fixtures, [dora_rts_logging_and_network_security_subject/1, dora_rts_logging_and_network_security_profile_for/2, dora_rts_logging_and_network_security_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [decide_dora_rts_logging_and_network_security/2]).

dora_rts_logging_and_network_security_subject(all_performed_larger_entity_with_critical_systems).
dora_rts_logging_and_network_security_subject(encryption_not_performed_larger_entity).
dora_rts_logging_and_network_security_subject(all_performed_microenterprise_without_critical_systems).
dora_rts_logging_and_network_security_subject(periodic_review_not_performed_microenterprise).
dora_rts_logging_and_network_security_subject(yearly_review_not_performed_microenterprise).
dora_rts_logging_and_network_security_subject(yearly_review_not_performed_larger_entity).
dora_rts_logging_and_network_security_subject(verification_not_performed_without_critical_systems).
dora_rts_logging_and_network_security_subject(verification_not_performed_with_critical_systems).
dora_rts_logging_and_network_security_subject(article_16_1_entity).
dora_rts_logging_and_network_security_subject(gate_not_stated).
dora_rts_logging_and_network_security_subject(both_reviews_not_performed_size_not_stated).
dora_rts_logging_and_network_security_subject(yearly_review_not_performed_size_not_stated).
dora_rts_logging_and_network_security_subject(logging_duty_and_size_not_stated).
dora_rts_logging_and_network_security_subject(size_not_stated_logging_duty_performed).
dora_rts_logging_and_network_security_subject(verification_performed_critical_not_stated).
dora_rts_logging_and_network_security_subject(verification_not_performed_critical_not_stated).
dora_rts_logging_and_network_security_subject(encryption_unsure).
dora_rts_logging_and_network_security_subject(several_duties_not_performed).
dora_rts_logging_and_network_security_subject(unknown_key_present).
dora_rts_logging_and_network_security_subject(fact_given_unsure).
dora_rts_logging_and_network_security_subject(duplicate_gate_key).
dora_rts_logging_and_network_security_subject(gate_only_stated).

dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile) :-
    performed_profile(false, true, Profile).
dora_rts_logging_and_network_security_profile_for(encryption_not_performed_larger_entity, Profile) :-
    performed_profile(false, true, Base),
    with_value(Base, network_connections_encrypted, false, Profile).
dora_rts_logging_and_network_security_profile_for(all_performed_microenterprise_without_critical_systems, Profile) :-
    performed_profile(true, false, Profile).
dora_rts_logging_and_network_security_profile_for(periodic_review_not_performed_microenterprise, Profile) :-
    performed_profile(true, false, Base),
    with_value(Base, network_architecture_and_security_design_reviewed_periodically, false, Profile).
dora_rts_logging_and_network_security_profile_for(yearly_review_not_performed_microenterprise, Profile) :-
    performed_profile(true, false, Base),
    with_value(Base, network_architecture_and_security_design_reviewed_once_a_year, false, Profile).
dora_rts_logging_and_network_security_profile_for(yearly_review_not_performed_larger_entity, Profile) :-
    performed_profile(false, false, Base),
    with_value(Base, network_architecture_and_security_design_reviewed_once_a_year, false, Profile).
dora_rts_logging_and_network_security_profile_for(verification_not_performed_without_critical_systems, Profile) :-
    performed_profile(false, false, Base),
    with_value(Base, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile).
dora_rts_logging_and_network_security_profile_for(verification_not_performed_with_critical_systems, Profile) :-
    performed_profile(false, true, Base),
    with_value(Base, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile).
dora_rts_logging_and_network_security_profile_for(article_16_1_entity, Profile) :-
    performed_profile(false, true, Base),
    with_value(Base, financial_entity_is_article_16_1_entity, true, Profile).
dora_rts_logging_and_network_security_profile_for(gate_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_is_article_16_1_entity, Profile).
dora_rts_logging_and_network_security_profile_for(both_reviews_not_performed_size_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_is_microenterprise, NoSize),
    with_value(NoSize, network_architecture_and_security_design_reviewed_once_a_year, false, YearlyFalse),
    with_value(YearlyFalse, network_architecture_and_security_design_reviewed_periodically, false, Profile).
dora_rts_logging_and_network_security_profile_for(yearly_review_not_performed_size_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_is_microenterprise, NoSize),
    with_value(NoSize, network_architecture_and_security_design_reviewed_once_a_year, false, Profile).
dora_rts_logging_and_network_security_profile_for(logging_duty_and_size_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_is_microenterprise, NoSize),
    without_key(NoSize, logging_procedures_protocols_and_tools_developed_documented_and_implemented, NoLogging),
    with_value(NoLogging, network_architecture_and_security_design_reviewed_periodically, unsure, Profile).
dora_rts_logging_and_network_security_profile_for(size_not_stated_logging_duty_performed, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_is_microenterprise, NoSize),
    with_value(NoSize, network_architecture_and_security_design_reviewed_periodically, unsure, Profile).
dora_rts_logging_and_network_security_profile_for(verification_performed_critical_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_has_ict_systems_supporting_critical_or_important_functions, Profile).
dora_rts_logging_and_network_security_profile_for(verification_not_performed_critical_not_stated, Profile) :-
    performed_profile(false, true, Base),
    without_key(Base, financial_entity_has_ict_systems_supporting_critical_or_important_functions, NoCritical),
    with_value(NoCritical, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile).
dora_rts_logging_and_network_security_profile_for(encryption_unsure, Profile) :-
    performed_profile(false, true, Base),
    with_value(Base, network_connections_encrypted, unsure, Profile).
dora_rts_logging_and_network_security_profile_for(several_duties_not_performed, Profile) :-
    performed_profile(false, true, Base),
    with_value(Base, log_retention_period_established_taking_into_account_required_considerations, false, RetentionFalse),
    with_value(RetentionFalse, network_connections_encrypted, false, EncryptionFalse),
    with_value(EncryptionFalse, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile).
dora_rts_logging_and_network_security_profile_for(unknown_key_present, Profile) :-
    performed_profile(false, true, Base),
    append(Base, [attribute(colour, blue)], Profile).
dora_rts_logging_and_network_security_profile_for(fact_given_unsure, Profile) :-
    performed_profile(unsure, true, Profile).
dora_rts_logging_and_network_security_profile_for(duplicate_gate_key, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, true)]).
dora_rts_logging_and_network_security_profile_for(gate_only_stated, [attribute(financial_entity_is_article_16_1_entity, false)]).

performed_profile(MicroenterpriseValue, CriticalFunctionValue, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, MicroenterpriseValue), attribute(financial_entity_has_ict_systems_supporting_critical_or_important_functions, CriticalFunctionValue), attribute(logging_procedures_protocols_and_tools_developed_documented_and_implemented, true), attribute(logging_procedures_identify_logged_events_retention_and_log_data_security, true), attribute(logging_detail_aligned_with_purpose_and_usage, true), attribute(logging_covers_access_control_and_identity_management_events, true), attribute(logging_covers_capacity_management_events, true), attribute(logging_covers_change_management_events, true), attribute(logging_covers_ict_operations_events, true), attribute(logging_covers_network_traffic_events, true), attribute(logging_systems_and_log_information_protected, true), attribute(logging_system_failure_detection_measures_in_place, true), attribute(ict_system_clocks_synchronised_to_reliable_reference_time_source, true), attribute(log_retention_period_established_taking_into_account_required_considerations, true), attribute(network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, true), attribute(network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, true), attribute(network_connections_and_data_flows_documented, true), attribute(separate_dedicated_administration_network_used, true), attribute(network_access_controls_identified_and_implemented, true), attribute(network_connections_encrypted, true), attribute(networks_designed_in_line_with_ict_security_requirements, true), attribute(traffic_to_internet_and_external_connections_secured, true), attribute(firewall_rules_roles_responsibilities_and_steps_identified, true), attribute(network_architecture_and_security_design_reviewed_once_a_year, true), attribute(network_architecture_and_security_design_reviewed_periodically, true), attribute(subnetworks_and_network_components_isolation_measures_in_place, true), attribute(secure_network_configuration_baseline_and_hardening_implemented, true), attribute(inactive_system_and_remote_sessions_limited_locked_and_terminated, true), attribute(network_services_security_measures_and_service_levels_specified, true), attribute(network_services_provider_type_identified, true), attribute(firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, true), attribute(firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, true), attribute(information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, true), attribute(data_protected_during_network_transmission_with_compliance_assessment, true), attribute(data_leakage_prevented_and_detected_and_external_transfer_secured, true), attribute(confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, true), attribute(information_in_transit_policies_designed_on_classification_and_risk_assessment, true)]).

with_value([], _, _, []).
with_value([attribute(ProfileKey, _)|Remaining], Target, Value, [attribute(ProfileKey, Value)|NewRemaining]) :-
    ProfileKey == Target,
    with_value(Remaining, Target, Value, NewRemaining).
with_value([attribute(ProfileKey, OldValue)|Remaining], Target, Value, [attribute(ProfileKey, OldValue)|NewRemaining]) :-
    ProfileKey \== Target,
    with_value(Remaining, Target, Value, NewRemaining).

without_key([], _, []).
without_key([attribute(ProfileKey, _)|Remaining], Target, NewRemaining) :-
    ProfileKey == Target,
    without_key(Remaining, Target, NewRemaining).
without_key([attribute(ProfileKey, OldValue)|Remaining], Target, [attribute(ProfileKey, OldValue)|NewRemaining]) :-
    ProfileKey \== Target,
    without_key(Remaining, Target, NewRemaining).

dora_rts_logging_and_network_security_assess(Subject, Result) :-
    dora_rts_logging_and_network_security_profile_for(Subject, Profile),
    decide_dora_rts_logging_and_network_security(Profile, Result).
