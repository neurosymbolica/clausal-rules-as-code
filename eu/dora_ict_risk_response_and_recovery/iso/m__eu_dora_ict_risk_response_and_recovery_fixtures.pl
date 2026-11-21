% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_subject/1, dora_ict_risk_response_and_recovery_profile_for/2, dora_ict_risk_response_and_recovery_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [decide_dora_ict_risk_response_and_recovery/2]).

baseline_profile([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(business_continuity_or_response_and_recovery_plans_activated, false), attribute(authority_requested_estimate_of_annual_ict_incident_costs_and_losses, false), attribute(backup_data_restored_using_own_systems, false), attribute(recovered_from_ict_related_incident, false), attribute(data_reconstructed_from_external_stakeholders, false), attribute(has_ict_business_continuity_policy, true), attribute(continuity_policy_implemented_through_documented_arrangements, true), attribute(arrangements_ensure_continuity_of_critical_or_important_functions, true), attribute(arrangements_respond_to_and_resolve_ict_related_incidents, true), attribute(arrangements_activate_containment_plans_without_delay, true), attribute(arrangements_estimate_preliminary_impacts_damages_and_losses, true), attribute(arrangements_set_out_communication_and_crisis_management_actions, true), attribute(ict_response_and_recovery_plans_implemented, true), attribute(response_and_recovery_plans_subject_to_independent_internal_audit_reviews, true), attribute(ict_business_continuity_plans_in_place_maintained_and_periodically_tested, true), attribute(business_impact_analysis_conducted, true), attribute(ict_assets_and_services_aligned_with_business_impact_analysis, true), attribute(plans_tested_at_least_yearly_and_on_substantive_changes, true), attribute(crisis_communication_plans_tested, true), attribute(testing_plans_include_cyber_attack_and_switchover_scenarios, true), attribute(continuity_policy_and_plans_regularly_reviewed, true), attribute(has_crisis_management_function, true), attribute(records_of_activities_during_disruption_events_kept, true), attribute(continuity_test_results_provided_to_competent_authorities, true), attribute(estimate_of_aggregated_annual_costs_and_losses_reported, true), attribute(backup_policies_and_procedures_developed_and_documented, true), attribute(restoration_and_recovery_procedures_and_methods_developed_and_documented, true), attribute(backup_systems_that_can_be_activated_set_up, true), attribute(backup_activation_does_not_jeopardise_security, true), attribute(backup_and_restoration_procedures_periodically_tested, true), attribute(restoration_uses_segregated_and_protected_ict_systems, true), attribute(recovery_plans_enable_recovery_of_all_transactions, true), attribute(adequate_resources_and_backup_and_restoration_facilities_maintained, true), attribute(redundant_ict_capacities_maintained, true), attribute(need_for_redundant_ict_capacities_assessed, true), attribute(secondary_processing_site_maintained, true), attribute(secondary_site_located_at_geographical_distance, true), attribute(secondary_site_can_ensure_continuity_of_critical_or_important_functions, true), attribute(secondary_site_immediately_accessible_to_staff, true), attribute(recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, true), attribute(data_integrity_checks_performed_when_recovering, true), attribute(data_consistency_checks_performed_when_reconstructing_data, true)]).

fixture_edits(large_credit_institution_all_performed, []).
fixture_edits(large_credit_institution_policy_not_performed, [set(has_ict_business_continuity_policy, false)]).
fixture_edits(article_16_1_entity, [set(financial_entity_is_article_16_1_entity, true)]).
fixture_edits(article_16_1_status_not_stated, [drop(financial_entity_is_article_16_1_entity)]).
fixture_edits(microenterprise_all_performed, [set(financial_entity_is_microenterprise, true)]).
fixture_edits(microenterprise_need_for_redundancy_not_assessed, [set(financial_entity_is_microenterprise, true), set(need_for_redundant_ict_capacities_assessed, false)]).
fixture_edits(microenterprise_without_audit_review, [set(financial_entity_is_microenterprise, true), set(response_and_recovery_plans_subject_to_independent_internal_audit_reviews, false)]).
fixture_edits(large_credit_institution_without_audit_review, [set(response_and_recovery_plans_subject_to_independent_internal_audit_reviews, false)]).
fixture_edits(central_securities_depository_all_performed, [set(dora_entity_type, central_securities_depository)]).
fixture_edits(central_securities_depository_without_secondary_site, [set(dora_entity_type, central_securities_depository), set(secondary_processing_site_maintained, false)]).
fixture_edits(credit_institution_without_secondary_site, [set(secondary_processing_site_maintained, false)]).
fixture_edits(central_counterparty_recovery_unsure, [set(dora_entity_type, central_counterparty), set(recovery_plans_enable_recovery_of_all_transactions, unsure)]).
fixture_edits(central_counterparty_recovery_performed, [set(dora_entity_type, central_counterparty)]).
fixture_edits(size_not_stated_both_redundancy_duties_failing, [drop(financial_entity_is_microenterprise), set(redundant_ict_capacities_maintained, false), set(need_for_redundant_ict_capacities_assessed, false)]).
fixture_edits(size_not_stated_one_redundancy_duty_failing, [drop(financial_entity_is_microenterprise), set(redundant_ict_capacities_maintained, false)]).
fixture_edits(plans_activated_records_not_kept, [set(business_continuity_or_response_and_recovery_plans_activated, true), set(records_of_activities_during_disruption_events_kept, false)]).
fixture_edits(plans_not_activated_records_not_kept, [set(records_of_activities_during_disruption_events_kept, false)]).
fixture_edits(policy_and_activation_not_stated, [drop(has_ict_business_continuity_policy), drop(business_continuity_or_response_and_recovery_plans_activated), drop(records_of_activities_during_disruption_events_kept)]).
fixture_edits(activation_not_stated, [drop(business_continuity_or_response_and_recovery_plans_activated), drop(records_of_activities_during_disruption_events_kept)]).
fixture_edits(microenterprise_cost_request_not_stated, [set(financial_entity_is_microenterprise, true), drop(authority_requested_estimate_of_annual_ict_incident_costs_and_losses)]).
fixture_edits(large_entity_cost_request_not_stated, [drop(authority_requested_estimate_of_annual_ict_incident_costs_and_losses)]).
fixture_edits(duplicate_key_profile, [append(attribute(has_ict_business_continuity_policy, false))]).
fixture_edits(unsure_gate_profile, [set(financial_entity_is_article_16_1_entity, unsure)]).
fixture_edits(numeric_entity_type_profile, [set(dora_entity_type, 7)]).
fixture_edits(unknown_key_profile, [append(attribute(no_such_key, true))]).
fixture_edits(variable_key_profile, [append(attribute(_UnboundKey, true))]).

dora_ict_risk_response_and_recovery_subject(Subject) :-
    fixture_edits(Subject, _).
dora_ict_risk_response_and_recovery_subject(not_an_attribute_list_profile).

dora_ict_risk_response_and_recovery_profile_for(Subject, Profile) :-
    fixture_edits(Subject, Edits),
    baseline_profile(Baseline),
    foldl(apply_edit, Edits, Baseline, Profile).
dora_ict_risk_response_and_recovery_profile_for(not_an_attribute_list_profile, not_an_attribute_list).

apply_edit(set(Key, Value), Profile, Updated) :-
    replace_value(Profile, Key, Value, Updated).
apply_edit(drop(Key), Profile, Updated) :-
    drop_key(Profile, Key, Updated).
apply_edit(append(Attribute), Profile, Updated) :-
    append(Profile, [Attribute], Updated).

replace_value([], _, _, []).
replace_value([attribute(Key, _)|Attributes], Wanted, Replacement, [attribute(Key, Replacement)|Updated]) :-
    Key == Wanted,
    replace_value(Attributes, Wanted, Replacement, Updated).
replace_value([attribute(Key, Value)|Attributes], Wanted, Replacement, [attribute(Key, Value)|Updated]) :-
    Key \== Wanted,
    replace_value(Attributes, Wanted, Replacement, Updated).

drop_key([], _, []).
drop_key([attribute(Key, _)|Attributes], Wanted, Updated) :-
    Key == Wanted,
    drop_key(Attributes, Wanted, Updated).
drop_key([attribute(Key, Value)|Attributes], Wanted, [attribute(Key, Value)|Updated]) :-
    Key \== Wanted,
    drop_key(Attributes, Wanted, Updated).

dora_ict_risk_response_and_recovery_assess(Subject, Result) :-
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    decide_dora_ict_risk_response_and_recovery(Profile, Result).
