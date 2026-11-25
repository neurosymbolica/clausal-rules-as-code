% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, simplified_internal_governance_and_control_framework_in_place, management_body_bears_overall_responsibility_for_simplified_framework, management_body_set_ict_roles_and_responsibilities, management_body_set_information_security_objectives_and_ict_requirements, management_body_approves_and_reviews_classification_risks_and_impact_analysis, management_body_approves_and_reviews_continuity_plans_and_recovery_measures, management_body_allocates_and_reviews_resilience_budget_yearly, management_body_specifies_and_implements_title_iii_policies_and_measures, management_body_identifies_and_implements_asset_protection_procedures, management_body_keeps_staff_ict_risk_knowledge_up_to_date, management_body_established_reporting_arrangements, control_and_internal_audit_functions_segregated_and_independent, simplified_framework_subject_to_internal_audit, critical_ict_audit_findings_verified_and_remediated, information_security_policy_developed_documented_and_implemented, ict_security_measures_established_and_implemented, critical_functions_and_supporting_assets_identified_classified_and_documented, critical_functions_supported_by_third_party_providers_identified, framework_determines_ict_risk_tolerance_levels, framework_identifies_and_assesses_ict_risks, framework_specifies_mitigation_strategies, framework_monitors_mitigation_effectiveness, framework_assesses_risks_from_changes_tests_and_incidents, ict_risk_assessment_carried_out_and_documented_periodically, threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed, incident_response_alert_thresholds_and_criteria_set, physical_security_measures_identified_and_implemented, premises_and_data_centres_protected, access_control_procedures_developed_enforced_and_reviewed, access_rights_managed_on_need_to_know_and_least_privilege, user_accountability_ensured, account_management_procedures_in_place, authentication_methods_commensurate_and_strong_where_required, access_rights_reviewed_and_withdrawn_when_not_required, ict_asset_lifecycle_monitored_and_managed, third_party_support_of_ict_assets_monitored, ict_capacity_requirements_and_availability_measures_identified, vulnerability_scanning_performed_and_patches_deployed, legacy_and_unsupported_ict_asset_risks_managed, access_operations_and_change_events_logged, anomalous_activities_monitored_and_analysed, cyber_threat_information_monitored, leakages_malicious_code_and_vulnerabilities_identified, network_and_data_security_safeguards_developed_and_implemented, data_in_use_in_transit_and_at_rest_protected, software_storage_media_and_endpoint_security_measures_implemented, unauthorised_connections_prevented_and_network_traffic_secured, data_secured_during_network_transmissions, secure_data_deletion_process_in_place, secure_storage_device_disposal_process_in_place, teleworking_and_private_device_measures_implemented],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(simplified_internal_governance_and_control_framework_in_place, judgement).
key_type(management_body_bears_overall_responsibility_for_simplified_framework, judgement).
key_type(management_body_set_ict_roles_and_responsibilities, judgement).
key_type(management_body_set_information_security_objectives_and_ict_requirements, judgement).
key_type(management_body_approves_and_reviews_classification_risks_and_impact_analysis, judgement).
key_type(management_body_approves_and_reviews_continuity_plans_and_recovery_measures, judgement).
key_type(management_body_allocates_and_reviews_resilience_budget_yearly, judgement).
key_type(management_body_specifies_and_implements_title_iii_policies_and_measures, judgement).
key_type(management_body_identifies_and_implements_asset_protection_procedures, judgement).
key_type(management_body_keeps_staff_ict_risk_knowledge_up_to_date, judgement).
key_type(management_body_established_reporting_arrangements, judgement).
key_type(control_and_internal_audit_functions_segregated_and_independent, judgement).
key_type(simplified_framework_subject_to_internal_audit, judgement).
key_type(critical_ict_audit_findings_verified_and_remediated, judgement).
key_type(information_security_policy_developed_documented_and_implemented, judgement).
key_type(ict_security_measures_established_and_implemented, judgement).
key_type(critical_functions_and_supporting_assets_identified_classified_and_documented, judgement).
key_type(critical_functions_supported_by_third_party_providers_identified, judgement).
key_type(framework_determines_ict_risk_tolerance_levels, judgement).
key_type(framework_identifies_and_assesses_ict_risks, judgement).
key_type(framework_specifies_mitigation_strategies, judgement).
key_type(framework_monitors_mitigation_effectiveness, judgement).
key_type(framework_assesses_risks_from_changes_tests_and_incidents, judgement).
key_type(ict_risk_assessment_carried_out_and_documented_periodically, judgement).
key_type(threats_and_vulnerabilities_monitored_and_risk_scenarios_reviewed, judgement).
key_type(incident_response_alert_thresholds_and_criteria_set, judgement).
key_type(physical_security_measures_identified_and_implemented, judgement).
key_type(premises_and_data_centres_protected, judgement).
key_type(access_control_procedures_developed_enforced_and_reviewed, judgement).
key_type(access_rights_managed_on_need_to_know_and_least_privilege, judgement).
key_type(user_accountability_ensured, judgement).
key_type(account_management_procedures_in_place, judgement).
key_type(authentication_methods_commensurate_and_strong_where_required, judgement).
key_type(access_rights_reviewed_and_withdrawn_when_not_required, judgement).
key_type(ict_asset_lifecycle_monitored_and_managed, judgement).
key_type(third_party_support_of_ict_assets_monitored, judgement).
key_type(ict_capacity_requirements_and_availability_measures_identified, judgement).
key_type(vulnerability_scanning_performed_and_patches_deployed, judgement).
key_type(legacy_and_unsupported_ict_asset_risks_managed, judgement).
key_type(access_operations_and_change_events_logged, judgement).
key_type(anomalous_activities_monitored_and_analysed, judgement).
key_type(cyber_threat_information_monitored, judgement).
key_type(leakages_malicious_code_and_vulnerabilities_identified, judgement).
key_type(network_and_data_security_safeguards_developed_and_implemented, judgement).
key_type(data_in_use_in_transit_and_at_rest_protected, judgement).
key_type(software_storage_media_and_endpoint_security_measures_implemented, judgement).
key_type(unauthorised_connections_prevented_and_network_traffic_secured, judgement).
key_type(data_secured_during_network_transmissions, judgement).
key_type(secure_data_deletion_process_in_place, judgement).
key_type(secure_storage_device_disposal_process_in_place, judgement).
key_type(teleworking_and_private_device_measures_implemented, judgement).

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
