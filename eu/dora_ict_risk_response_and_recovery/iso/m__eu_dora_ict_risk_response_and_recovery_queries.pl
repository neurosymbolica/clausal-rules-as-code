% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_queries, [dora_ict_risk_response_and_recovery_profile_keys/1, dora_ict_risk_response_and_recovery_what_if/4, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [dora_ict_risk_response_and_recovery_status/2]).

dora_ict_risk_response_and_recovery_profile_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, business_continuity_or_response_and_recovery_plans_activated, authority_requested_estimate_of_annual_ict_incident_costs_and_losses, backup_data_restored_using_own_systems, recovered_from_ict_related_incident, data_reconstructed_from_external_stakeholders, has_ict_business_continuity_policy, continuity_policy_implemented_through_documented_arrangements, arrangements_ensure_continuity_of_critical_or_important_functions, arrangements_respond_to_and_resolve_ict_related_incidents, arrangements_activate_containment_plans_without_delay, arrangements_estimate_preliminary_impacts_damages_and_losses, arrangements_set_out_communication_and_crisis_management_actions, ict_response_and_recovery_plans_implemented, response_and_recovery_plans_subject_to_independent_internal_audit_reviews, ict_business_continuity_plans_in_place_maintained_and_periodically_tested, business_impact_analysis_conducted, ict_assets_and_services_aligned_with_business_impact_analysis, plans_tested_at_least_yearly_and_on_substantive_changes, crisis_communication_plans_tested, testing_plans_include_cyber_attack_and_switchover_scenarios, continuity_policy_and_plans_regularly_reviewed, has_crisis_management_function, records_of_activities_during_disruption_events_kept, continuity_test_results_provided_to_competent_authorities, estimate_of_aggregated_annual_costs_and_losses_reported, backup_policies_and_procedures_developed_and_documented, restoration_and_recovery_procedures_and_methods_developed_and_documented, backup_systems_that_can_be_activated_set_up, backup_activation_does_not_jeopardise_security, backup_and_restoration_procedures_periodically_tested, restoration_uses_segregated_and_protected_ict_systems, recovery_plans_enable_recovery_of_all_transactions, adequate_resources_and_backup_and_restoration_facilities_maintained, redundant_ict_capacities_maintained, need_for_redundant_ict_capacities_assessed, secondary_processing_site_maintained, secondary_site_located_at_geographical_distance, secondary_site_can_ensure_continuity_of_critical_or_important_functions, secondary_site_immediately_accessible_to_staff, recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, data_integrity_checks_performed_when_recovering, data_consistency_checks_performed_when_reconstructing_data]).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

dora_ict_risk_response_and_recovery_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ict_risk_response_and_recovery_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    proper_list_t(Profile, IsList),
    override_in(IsList, Profile, Key, Value, Hypothesis).

override_in(false, Profile, _, _, Profile).
override_in(true, Profile, Key, Value, Hypothesis) :-
    remove_key(Profile, Key, Remaining),
    append(Remaining, [attribute(Key, Value)], Hypothesis).

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Rest],
    proper_list_t(Rest, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

remove_key([], _, []).
remove_key([Element|Elements], Key, Remaining) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key,
    remove_key(Elements, Key, Remaining).
remove_key([Element|Elements], Key, [Element|Remaining]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key,
    remove_key(Elements, Key, Remaining).
remove_key([Element|Elements], Key, [Element|Remaining]) :-
    var(Element),
    remove_key(Elements, Key, Remaining).
remove_key([Element|Elements], Key, [Element|Remaining]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    remove_key(Elements, Key, Remaining).

test(the_schema_has_forty_five_keys) :-
    dora_ict_risk_response_and_recovery_profile_keys(Keys),
    length(Keys, 45).
test(an_override_replaces_every_occurrence) :-
    override_attribute([attribute(alpha, true), attribute(beta, true), attribute(alpha, false)], alpha, unsure, Hypothesis),
    Hypothesis == [attribute(beta, true), attribute(alpha, unsure)].
test(an_override_adds_an_absent_key) :-
    override_attribute([attribute(beta, true)], alpha, true, Hypothesis),
    Hypothesis == [attribute(beta, true), attribute(alpha, true)].
test(a_term_that_is_not_a_list_passes_through) :-
    override_attribute(not_a_list, alpha, true, Hypothesis),
    Hypothesis == not_a_list.
test(what_if_on_a_gate_true_entity) :-
    dora_ict_risk_response_and_recovery_what_if([], financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(the_result_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    simplified_framework_entity.

test(what_if_on_a_gate_true_entity_is_not_complete, fail) :-
    dora_ict_risk_response_and_recovery_what_if([], financial_entity_is_article_16_1_entity, true, complete).
