% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_fixtures, [dora_ict_risk_protection_and_detection_subject/1, dora_ict_risk_protection_and_detection_profile_for/2, dora_ict_risk_protection_and_detection_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [decide_dora_ict_risk_protection_and_detection/2]).

dora_ict_risk_protection_and_detection_subject(Subject) :-
    fixture_edits(Subject, _, _).

dora_ict_risk_protection_and_detection_profile_for(Subject, Profile) :-
    fixture_edits(Subject, EntityType, Edits),
    base_profile(EntityType, Base),
    foldl(apply_edit, Edits, Base, Profile).

fixture_edits(credit_institution_all_duties_performed, credit_institution, []).
fixture_edits(credit_institution_patch_policies_not_documented, credit_institution, [set(patch_and_update_policies_documented, false)]).
fixture_edits(data_reporting_provider_all_duties_performed, data_reporting_service_provider, []).
fixture_edits(data_reporting_provider_trade_report_checking_not_in_place, data_reporting_service_provider, [set(trade_report_checking_systems_in_place, false)]).
fixture_edits(credit_institution_trade_report_checking_not_in_place, credit_institution, [set(trade_report_checking_systems_in_place, false)]).
fixture_edits(credit_institution_trade_report_checking_unsure, credit_institution, [set(trade_report_checking_systems_in_place, unsure)]).
fixture_edits(data_reporting_provider_trade_report_checking_unanswered, data_reporting_service_provider, [drop(trade_report_checking_systems_in_place)]).
fixture_edits(article_16_1_entity_with_duties_not_performed, credit_institution, [set(financial_entity_is_article_16_1_entity, true), set(patch_and_update_policies_documented, false), set(anomaly_detection_mechanisms_in_place, unsure)]).
fixture_edits(article_16_1_status_unanswered, credit_institution, [drop(financial_entity_is_article_16_1_entity)]).
fixture_edits(entity_type_and_trade_report_checking_unanswered, credit_institution, [drop(dora_entity_type), drop(trade_report_checking_systems_in_place)]).
fixture_edits(entity_type_unanswered_trade_report_checking_in_place, credit_institution, [drop(dora_entity_type)]).
fixture_edits(entity_type_monitoring_and_trade_report_checking_unanswered, credit_institution, [drop(dora_entity_type), drop(monitors_and_controls_security_and_functioning_of_ict_systems), drop(trade_report_checking_systems_in_place)]).
fixture_edits(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, credit_institution, [drop(dora_entity_type), drop(monitors_and_controls_security_and_functioning_of_ict_systems), set(trade_report_checking_systems_in_place, false)]).
fixture_edits(security_tools_deployment_unsure, credit_institution, [set(deploys_ict_security_tools_policies_and_procedures, unsure)]).
fixture_edits(security_tools_deployment_unsure_patch_policies_not_documented, credit_institution, [set(deploys_ict_security_tools_policies_and_procedures, unsure), set(patch_and_update_policies_documented, false)]).
fixture_edits(security_tools_deployment_unsure_anomaly_detection_unanswered, credit_institution, [set(deploys_ict_security_tools_policies_and_procedures, unsure), drop(anomaly_detection_mechanisms_in_place)]).
fixture_edits(ict_third_party_service_provider_all_duties_performed, ict_third_party_service_provider, []).
fixture_edits(article_16_1_status_given_as_unsure, credit_institution, [set(financial_entity_is_article_16_1_entity, unsure)]).
fixture_edits(unknown_key_given, credit_institution, [add(colour, true)]).
fixture_edits(anomaly_detection_given_twice, credit_institution, [add(anomaly_detection_mechanisms_in_place, false)]).

base_profile(EntityType, [attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, EntityType)|DutyAttributes]) :-
    fixture_duty_keys(DutyKeys),
    maplist(performed_attribute, DutyKeys, DutyAttributes).

performed_attribute(Key, attribute(Key, true)).

fixture_duty_keys([monitors_and_controls_security_and_functioning_of_ict_systems, deploys_ict_security_tools_policies_and_procedures, ict_security_policies_procedures_protocols_and_tools_implemented, uses_appropriate_ict_solutions_and_processes, ict_solutions_ensure_security_of_data_transfer, ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws, ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss, ict_solutions_protect_data_from_data_management_risks, information_security_policy_developed_and_documented, network_and_infrastructure_management_structure_established, access_limiting_policies_and_access_rights_controls_implemented, strong_authentication_and_cryptographic_key_protection_implemented, ict_change_management_policies_procedures_and_controls_implemented, patch_and_update_policies_documented, network_connection_infrastructure_can_be_severed_or_segmented, ict_change_management_process_approved_with_specific_protocols, anomaly_detection_mechanisms_in_place, mechanisms_to_identify_single_points_of_failure_in_place, detection_mechanisms_regularly_tested, detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts, sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents, trade_report_checking_systems_in_place]).

apply_edit(set(Key, Value), ProfileBefore, ProfileAfter) :-
    set_value(Key, Value, ProfileBefore, ProfileAfter).
apply_edit(drop(Key), ProfileBefore, ProfileAfter) :-
    drop_value(Key, ProfileBefore, ProfileAfter).
apply_edit(add(Key, Value), ProfileBefore, ProfileAfter) :-
    append(ProfileBefore, [attribute(Key, Value)], ProfileAfter).

set_value(Key, Value, [attribute(ElementKey, _)|Elements], [attribute(Key, Value)|Elements]) :-
    ElementKey == Key.
set_value(Key, Value, [attribute(ElementKey, ElementValue)|Elements], [attribute(ElementKey, ElementValue)|Changed]) :-
    ElementKey \== Key,
    set_value(Key, Value, Elements, Changed).

drop_value(Key, [attribute(ElementKey, _)|Elements], Elements) :-
    ElementKey == Key.
drop_value(Key, [attribute(ElementKey, ElementValue)|Elements], [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    drop_value(Key, Elements, Kept).

dora_ict_risk_protection_and_detection_assess(Subject, Result) :-
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile),
    decide_dora_ict_risk_protection_and_detection(Profile, Result).
