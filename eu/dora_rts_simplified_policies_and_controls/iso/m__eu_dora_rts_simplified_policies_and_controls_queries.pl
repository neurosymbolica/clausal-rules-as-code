% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_queries, [dora_rts_simplified_policies_and_controls_profile_keys/1, dora_rts_simplified_policies_and_controls_what_if/4, dora_rts_simplified_policies_and_controls_eligibility/2, dora_rts_simplified_policies_and_controls_compliance_check/3, dora_rts_simplified_policies_and_controls_justification/3, required/1, outstanding/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, wrong_type/1, duplicate_key/1, complete/0, incomplete/0, none_outstanding/0, not_article_16_1_entity/0, unsure/0, financial_entity_is_article_16_1_entity/0, simplified_internal_governance_and_control_framework_in_place/0, management_body_bears_overall_responsibility_for_simplified_framework/0, management_body_set_ict_roles_and_responsibilities/0, management_body_set_information_security_objectives_and_ict_requirements/0, management_body_approves_and_reviews_classification_risks_and_impact_analysis/0, management_body_approves_and_reviews_continuity_plans_and_recovery_measures/0, management_body_allocates_and_reviews_resilience_budget_yearly/0, management_body_specifies_and_implements_title_iii_policies_and_measures/0, management_body_identifies_and_implements_asset_protection_procedures/0, management_body_keeps_staff_ict_risk_knowledge_up_to_date/0, management_body_established_reporting_arrangements/0, control_and_internal_audit_functions_segregated_and_independent/0, simplified_framework_subject_to_internal_audit/0, critical_ict_audit_findings_verified_and_remediated/0, information_security_policy_developed_documented_and_implemented/0, ict_security_measures_established_and_implemented/0, critical_functions_and_supporting_assets_identified_classified_and_documented/0, critical_functions_supported_by_third_party_providers_identified/0, framework_determines_ict_risk_tolerance_levels/0, framework_identifies_and_assesses_ict_risks/0, framework_specifies_mitigation_strategies/0, framework_monitors_mitigation_effectiveness/0, framework_assesses_risks_from_changes_tests_and_incidents/0, ict_risk_assessment_carried_out_and_documented_periodically/0, threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed/0, incident_response_alert_thresholds_and_criteria_set/0, physical_security_measures_identified_and_implemented/0, premises_and_data_centres_protected/0, access_control_procedures_developed_enforced_and_reviewed/0, access_rights_managed_on_need_to_know_and_least_privilege/0, user_accountability_ensured/0, account_management_procedures_in_place/0, authentication_methods_commensurate_and_strong_where_required/0, access_rights_reviewed_and_withdrawn_when_not_required/0, ict_asset_lifecycle_monitored_and_managed/0, third_party_support_of_ict_assets_monitored/0, ict_capacity_requirements_and_availability_measures_identified/0, vulnerability_scanning_performed_and_patches_deployed/0, legacy_and_unsupported_ict_asset_risks_managed/0, access_operations_and_change_events_logged/0, anomalous_activities_monitored_and_analysed/0, cyber_threat_information_monitored/0, leakages_malicious_code_and_vulnerabilities_identified/0, network_and_data_security_safeguards_developed_and_implemented/0, data_in_use_in_transit_and_at_rest_protected/0, software_storage_media_and_endpoint_security_measures_implemented/0, unauthorised_connections_prevented_and_network_traffic_secured/0, data_secured_during_network_transmissions/0, secure_data_deletion_process_in_place/0, secure_storage_device_disposal_process_in_place/0, teleworking_and_private_device_measures_implemented/0, internal_governance_and_control_framework/0, management_body_overall_responsibility/0, ict_roles_and_responsibilities/0, information_security_objectives_and_ict_requirements/0, approval_of_classification_risks_and_impact_analysis/0, approval_of_continuity_plans_and_recovery_measures/0, yearly_digital_operational_resilience_budget/0, policies_and_measures_of_title_iii/0, asset_protection_procedures_protocols_and_tools/0, staff_ict_risk_knowledge_and_skills/0, reporting_arrangements_to_management_body/0, segregation_and_independence_of_control_functions/0, internal_audit_of_simplified_framework/0, remediation_of_critical_audit_findings/0, information_security_policy/0, ict_security_measures/0, classification_of_functions_and_assets/0, functions_supported_by_third_party_providers/0, risk_tolerance_levels/0, identification_and_assessment_of_ict_risks/0, mitigation_strategies/0, monitoring_of_mitigation_effectiveness/0, assessment_of_change_test_and_incident_risks/0, periodic_ict_risk_assessment/0, threat_and_vulnerability_monitoring/0, incident_response_alert_thresholds/0, physical_security_measures/0, protection_of_premises_and_data_centres/0, access_control_procedures/0, need_to_know_access_rights/0, user_accountability/0, account_management_procedures/0, authentication_methods/0, periodic_review_of_access_rights/0, lifecycle_of_ict_assets/0, third_party_support_of_ict_assets/0, capacity_management/0, vulnerability_scanning_and_patching/0, legacy_ict_asset_risks/0, event_logging/0, anomalous_activity_monitoring/0, cyber_threat_information_monitoring/0, leakage_malicious_code_and_vulnerability_detection/0, network_and_data_safeguards/0, protection_of_data_in_use_transit_and_rest/0, security_of_software_media_systems_and_endpoints/0, prevention_of_unauthorised_connections/0, security_of_network_transmissions/0, secure_data_deletion/0, secure_disposal_of_storage_devices/0, teleworking_and_private_devices/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_citations, [implements/1]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [simplified_policies_and_controls_duties_required/3, dora_rts_simplified_policies_and_controls_status/2, dora_rts_simplified_policies_and_controls_checklist/2]).

dora_rts_simplified_policies_and_controls_profile_keys([financial_entity_is_article_16_1_entity, simplified_internal_governance_and_control_framework_in_place, management_body_bears_overall_responsibility_for_simplified_framework, management_body_set_ict_roles_and_responsibilities, management_body_set_information_security_objectives_and_ict_requirements, management_body_approves_and_reviews_classification_risks_and_impact_analysis, management_body_approves_and_reviews_continuity_plans_and_recovery_measures, management_body_allocates_and_reviews_resilience_budget_yearly, management_body_specifies_and_implements_title_iii_policies_and_measures, management_body_identifies_and_implements_asset_protection_procedures, management_body_keeps_staff_ict_risk_knowledge_up_to_date, management_body_established_reporting_arrangements, control_and_internal_audit_functions_segregated_and_independent, simplified_framework_subject_to_internal_audit, critical_ict_audit_findings_verified_and_remediated, information_security_policy_developed_documented_and_implemented, ict_security_measures_established_and_implemented, critical_functions_and_supporting_assets_identified_classified_and_documented, critical_functions_supported_by_third_party_providers_identified, framework_determines_ict_risk_tolerance_levels, framework_identifies_and_assesses_ict_risks, framework_specifies_mitigation_strategies, framework_monitors_mitigation_effectiveness, framework_assesses_risks_from_changes_tests_and_incidents, ict_risk_assessment_carried_out_and_documented_periodically, threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed, incident_response_alert_thresholds_and_criteria_set, physical_security_measures_identified_and_implemented, premises_and_data_centres_protected, access_control_procedures_developed_enforced_and_reviewed, access_rights_managed_on_need_to_know_and_least_privilege, user_accountability_ensured, account_management_procedures_in_place, authentication_methods_commensurate_and_strong_where_required, access_rights_reviewed_and_withdrawn_when_not_required, ict_asset_lifecycle_monitored_and_managed, third_party_support_of_ict_assets_monitored, ict_capacity_requirements_and_availability_measures_identified, vulnerability_scanning_performed_and_patches_deployed, legacy_and_unsupported_ict_asset_risks_managed, access_operations_and_change_events_logged, anomalous_activities_monitored_and_analysed, cyber_threat_information_monitored, leakages_malicious_code_and_vulnerabilities_identified, network_and_data_security_safeguards_developed_and_implemented, data_in_use_in_transit_and_at_rest_protected, software_storage_media_and_endpoint_security_measures_implemented, unauthorised_connections_prevented_and_network_traffic_secured, data_secured_during_network_transmissions, secure_data_deletion_process_in_place, secure_storage_device_disposal_process_in_place, teleworking_and_private_device_measures_implemented]).

dora_rts_simplified_policies_and_controls_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems),
    what_if_from_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_from_problems([wrong_type(profile)], _, _, _, input_problems([wrong_type(profile)])).
what_if_from_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_rts_simplified_policies_and_controls_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Rest]) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, Rest).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, Rest).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], Key, Rest) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, Rest).
drop_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    drop_attribute(Elements, Key, Rest).

dora_rts_simplified_policies_and_controls_eligibility(Profile, Verdict) :-
    simplified_policies_and_controls_duties_required(Profile, Result, _Citations),
    eligibility_from_required(Result, Verdict).

eligibility_from_required(required(_), eligibility(bound_by_title_iii, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))])) :-
    implements(eu_reg_2022_2554_art_16_1).
eligibility_from_required(not_article_16_1_entity, eligibility(not_article_16_1_entity, [item(article_16_1_entity, unmet(not_article_16_1_entity), cite(eu_reg_2022_2554_art_16_1))])) :-
    implements(eu_reg_2022_2554_art_16_1).
eligibility_from_required(indeterminate(MissingKeys), eligibility(indeterminate(MissingKeys), [item(article_16_1_entity, unknown(MissingKeys), cite(eu_reg_2022_2554_art_16_1))])).
eligibility_from_required(input_problems(Problems), eligibility(input_problems(Problems), [])).

dora_rts_simplified_policies_and_controls_compliance_check(Profile, Duty, Verdict) :-
    simplified_policies_and_controls_duties_required(Profile, Result, _Citations),
    compliance_from_required(Result, Profile, Duty, Verdict).

compliance_from_required(input_problems(Problems), _, _, input_problems(Problems)).
compliance_from_required(not_article_16_1_entity, _, _, not_article_16_1_entity) :-
    implements(eu_reg_2022_2554_art_16_1).
compliance_from_required(indeterminate(MissingKeys), _, _, indeterminate(MissingKeys)).
compliance_from_required(required(Duties), Profile, Duty, Verdict) :-
    member(Duty, Duties),
    dora_rts_simplified_policies_and_controls_checklist(Profile, Items),
    member(item(Duty, ItemStatus, Citation), Items),
    compliance_from_item(ItemStatus, Profile, Duty, Citation, Verdict).

compliance_from_item(met, _, Duty, Citation, compliance(Duty, performed, Citation)).
compliance_from_item(unmet(_), _, Duty, Citation, compliance(Duty, omitted, Citation)).
compliance_from_item(unknown([Key]), Profile, _, _, indeterminate([Key])) :-
    profile_lacks(Profile, Key).
compliance_from_item(unknown([Key]), Profile, _, Citation, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    profile_get(Profile, Key, unsure),
    relied_on_pairs(Profile, Pairs).

relied_on_pairs(Profile, Pairs) :-
    dora_rts_simplified_policies_and_controls_profile_keys(ProfileKeys),
    findall(Key - Value, (member(Key, ProfileKeys), profile_get(Profile, Key, Value)), Pairs).

dora_rts_simplified_policies_and_controls_justification(Profile, Requirement, Citation) :-
    dora_rts_simplified_policies_and_controls_checklist(Profile, Items),
    member(item(Requirement, _, Citation), Items).

required(Duties) :-
    clausal_is_list(Duties).

outstanding(Duties) :-
    clausal_is_list(Duties).

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Key, Citation) :-
    atom(Key),
    compound(Citation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    nonvar(Clause),
    clausal_is_list(Citations).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

complete.

incomplete.

none_outstanding.

not_article_16_1_entity.

unsure.

financial_entity_is_article_16_1_entity.

simplified_internal_governance_and_control_framework_in_place.

management_body_bears_overall_responsibility_for_simplified_framework.

management_body_set_ict_roles_and_responsibilities.

management_body_set_information_security_objectives_and_ict_requirements.

management_body_approves_and_reviews_classification_risks_and_impact_analysis.

management_body_approves_and_reviews_continuity_plans_and_recovery_measures.

management_body_allocates_and_reviews_resilience_budget_yearly.

management_body_specifies_and_implements_title_iii_policies_and_measures.

management_body_identifies_and_implements_asset_protection_procedures.

management_body_keeps_staff_ict_risk_knowledge_up_to_date.

management_body_established_reporting_arrangements.

control_and_internal_audit_functions_segregated_and_independent.

simplified_framework_subject_to_internal_audit.

critical_ict_audit_findings_verified_and_remediated.

information_security_policy_developed_documented_and_implemented.

ict_security_measures_established_and_implemented.

critical_functions_and_supporting_assets_identified_classified_and_documented.

critical_functions_supported_by_third_party_providers_identified.

framework_determines_ict_risk_tolerance_levels.

framework_identifies_and_assesses_ict_risks.

framework_specifies_mitigation_strategies.

framework_monitors_mitigation_effectiveness.

framework_assesses_risks_from_changes_tests_and_incidents.

ict_risk_assessment_carried_out_and_documented_periodically.

threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed.

incident_response_alert_thresholds_and_criteria_set.

physical_security_measures_identified_and_implemented.

premises_and_data_centres_protected.

access_control_procedures_developed_enforced_and_reviewed.

access_rights_managed_on_need_to_know_and_least_privilege.

user_accountability_ensured.

account_management_procedures_in_place.

authentication_methods_commensurate_and_strong_where_required.

access_rights_reviewed_and_withdrawn_when_not_required.

ict_asset_lifecycle_monitored_and_managed.

third_party_support_of_ict_assets_monitored.

ict_capacity_requirements_and_availability_measures_identified.

vulnerability_scanning_performed_and_patches_deployed.

legacy_and_unsupported_ict_asset_risks_managed.

access_operations_and_change_events_logged.

anomalous_activities_monitored_and_analysed.

cyber_threat_information_monitored.

leakages_malicious_code_and_vulnerabilities_identified.

network_and_data_security_safeguards_developed_and_implemented.

data_in_use_in_transit_and_at_rest_protected.

software_storage_media_and_endpoint_security_measures_implemented.

unauthorised_connections_prevented_and_network_traffic_secured.

data_secured_during_network_transmissions.

secure_data_deletion_process_in_place.

secure_storage_device_disposal_process_in_place.

teleworking_and_private_device_measures_implemented.

internal_governance_and_control_framework.

management_body_overall_responsibility.

ict_roles_and_responsibilities.

information_security_objectives_and_ict_requirements.

approval_of_classification_risks_and_impact_analysis.

approval_of_continuity_plans_and_recovery_measures.

yearly_digital_operational_resilience_budget.

policies_and_measures_of_title_iii.

asset_protection_procedures_protocols_and_tools.

staff_ict_risk_knowledge_and_skills.

reporting_arrangements_to_management_body.

segregation_and_independence_of_control_functions.

internal_audit_of_simplified_framework.

remediation_of_critical_audit_findings.

information_security_policy.

ict_security_measures.

classification_of_functions_and_assets.

functions_supported_by_third_party_providers.

risk_tolerance_levels.

identification_and_assessment_of_ict_risks.

mitigation_strategies.

monitoring_of_mitigation_effectiveness.

assessment_of_change_test_and_incident_risks.

periodic_ict_risk_assessment.

threat_and_vulnerability_monitoring.

incident_response_alert_thresholds.

physical_security_measures.

protection_of_premises_and_data_centres.

access_control_procedures.

need_to_know_access_rights.

user_accountability.

account_management_procedures.

authentication_methods.

periodic_review_of_access_rights.

lifecycle_of_ict_assets.

third_party_support_of_ict_assets.

capacity_management.

vulnerability_scanning_and_patching.

legacy_ict_asset_risks.

event_logging.

anomalous_activity_monitoring.

cyber_threat_information_monitoring.

leakage_malicious_code_and_vulnerability_detection.

network_and_data_safeguards.

protection_of_data_in_use_transit_and_rest.

security_of_software_media_systems_and_endpoints.

prevention_of_unauthorised_connections.

security_of_network_transmissions.

secure_data_deletion.

secure_disposal_of_storage_devices.

teleworking_and_private_devices.
