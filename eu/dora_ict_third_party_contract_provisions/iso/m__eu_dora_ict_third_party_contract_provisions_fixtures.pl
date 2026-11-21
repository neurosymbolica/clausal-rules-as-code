% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_subject/1, dora_ict_third_party_contract_provisions_profile_for/2, dora_ict_third_party_contract_provisions_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [decide_dora_ict_third_party_contract_provisions/2]).

dora_ict_third_party_contract_provisions_subject(critical_all_met).
dora_ict_third_party_contract_provisions_subject(critical_exit_strategy_false).
dora_ict_third_party_contract_provisions_subject(not_critical_all_met).
dora_ict_third_party_contract_provisions_subject(not_critical_incident_assistance_false).
dora_ict_third_party_contract_provisions_subject(not_critical_art_30_3_false).
dora_ict_third_party_contract_provisions_subject(microenterprise_delegation).
dora_ict_third_party_contract_provisions_subject(microenterprise_delegation_refused).
dora_ict_third_party_contract_provisions_subject(not_microenterprise_delegation).
dora_ict_third_party_contract_provisions_subject(critical_absent_art_30_3_open).
dora_ict_third_party_contract_provisions_subject(critical_absent_art_30_3_met).
dora_ict_third_party_contract_provisions_subject(critical_unsure).
dora_ict_third_party_contract_provisions_subject(critical_unsure_microenterprise_absent).
dora_ict_third_party_contract_provisions_subject(document_unsure).
dora_ict_third_party_contract_provisions_subject(base_false_and_absent).
dora_ict_third_party_contract_provisions_subject(duplicate_and_unknown_keys).
dora_ict_third_party_contract_provisions_subject(microenterprise_unsure).

subject_overrides(critical_all_met, []).
subject_overrides(critical_exit_strategy_false, [contract_provides_exit_strategy_and_transition_period - false]).
subject_overrides(not_critical_all_met, [supports_critical_or_important_function - false]).
subject_overrides(not_critical_incident_assistance_false, [supports_critical_or_important_function - false, contract_provides_incident_assistance - false]).
subject_overrides(not_critical_art_30_3_false, [supports_critical_or_important_function - false, contract_provides_full_service_levels_with_performance_targets - false]).
subject_overrides(microenterprise_delegation, [contract_provides_monitoring_rights_of_the_financial_entity - false, financial_entity_is_microenterprise - true, contract_provides_delegated_access_inspection_and_audit - true]).
subject_overrides(microenterprise_delegation_refused, [contract_provides_monitoring_rights_of_the_financial_entity - false, financial_entity_is_microenterprise - true, contract_provides_delegated_access_inspection_and_audit - false]).
subject_overrides(not_microenterprise_delegation, [contract_provides_monitoring_rights_of_the_financial_entity - false, financial_entity_is_microenterprise - false, contract_provides_delegated_access_inspection_and_audit - true]).
subject_overrides(critical_absent_art_30_3_open, [supports_critical_or_important_function - absent, contract_provides_exit_strategy_and_transition_period - absent]).
subject_overrides(critical_absent_art_30_3_met, [supports_critical_or_important_function - absent]).
subject_overrides(critical_unsure, [supports_critical_or_important_function - unsure]).
subject_overrides(critical_unsure_microenterprise_absent, [supports_critical_or_important_function - unsure, financial_entity_is_microenterprise - absent]).
subject_overrides(document_unsure, [contract_is_single_written_document - unsure]).
subject_overrides(base_false_and_absent, [contract_provides_termination_for_significant_breach - absent, contract_provides_incident_assistance - false]).
subject_overrides(microenterprise_unsure, [financial_entity_is_microenterprise - unsure]).

dora_ict_third_party_contract_provisions_profile_for(duplicate_and_unknown_keys, Profile) :-
    fixture_profile([], Baseline),
    append(Baseline, [attribute(supports_critical_or_important_function, false), attribute(colour, blue)], Profile).
dora_ict_third_party_contract_provisions_profile_for(Subject, Profile) :-
    subject_overrides(Subject, Overrides),
    fixture_profile(Overrides, Profile).

fixture_key_order([contract_provides_termination_for_significant_breach, contract_provides_termination_for_circumstances_altering_performance, contract_provides_termination_for_risk_management_weaknesses, contract_provides_termination_where_supervision_impeded, contract_is_single_written_document, contract_provides_description_of_functions_services_and_subcontracting, contract_provides_service_and_data_locations, contract_provides_data_protection_provisions, contract_provides_data_access_recovery_and_return, contract_provides_service_level_descriptions, contract_provides_incident_assistance, contract_provides_cooperation_with_authorities, contract_provides_termination_rights_and_notice_periods, contract_provides_security_awareness_and_training_participation, supports_critical_or_important_function, contract_provides_full_service_levels_with_performance_targets, contract_provides_notice_periods_and_reporting_obligations, contract_provides_contingency_plans_and_security_measures, contract_provides_threat_led_penetration_testing_participation, contract_provides_monitoring_rights_of_the_authorities, contract_provides_exit_strategy_and_transition_period, contract_provides_monitoring_rights_of_the_financial_entity, financial_entity_is_microenterprise, contract_provides_delegated_access_inspection_and_audit]).

fixture_profile(Overrides, Profile) :-
    fixture_key_order(ProfileKeys),
    maplist(fixture_attribute(Overrides), ProfileKeys, Attributes),
    exclude(absent_attribute, Attributes, Profile).

fixture_attribute(Overrides, ProfileKey, attribute(ProfileKey, Value)) :-
    pairs_keys(Overrides, OverriddenKeys),
    memberd_t(ProfileKey, OverriddenKeys, Overridden),
    fixture_value(Overridden, Overrides, ProfileKey, Value).

fixture_value(true, Overrides, ProfileKey, Value) :-
    member(ProfileKey - Value, Overrides).
fixture_value(false, _, financial_entity_is_microenterprise, false).
fixture_value(false, _, ProfileKey, true) :-
    dif(ProfileKey, financial_entity_is_microenterprise).

absent_attribute(attribute(_, absent)).

dora_ict_third_party_contract_provisions_assess(Subject, Result) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    decide_dora_ict_third_party_contract_provisions(Profile, Result).
