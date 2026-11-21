% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_risk_response_and_recovery_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, business_continuity_or_response_and_recovery_plans_activated, authority_requested_estimate_of_annual_ict_incident_costs_and_losses, backup_data_restored_using_own_systems, recovered_from_ict_related_incident, data_reconstructed_from_external_stakeholders, has_ict_business_continuity_policy, continuity_policy_implemented_through_documented_arrangements, arrangements_ensure_continuity_of_critical_or_important_functions, arrangements_respond_to_and_resolve_ict_related_incidents, arrangements_activate_containment_plans_without_delay, arrangements_estimate_preliminary_impacts_damages_and_losses, arrangements_set_out_communication_and_crisis_management_actions, ict_response_and_recovery_plans_implemented, response_and_recovery_plans_subject_to_independent_internal_audit_reviews, ict_business_continuity_plans_in_place_maintained_and_periodically_tested, business_impact_analysis_conducted, ict_assets_and_services_aligned_with_business_impact_analysis, plans_tested_at_least_yearly_and_on_substantive_changes, crisis_communication_plans_tested, testing_plans_include_cyber_attack_and_switchover_scenarios, continuity_policy_and_plans_regularly_reviewed, has_crisis_management_function, records_of_activities_during_disruption_events_kept, continuity_test_results_provided_to_competent_authorities, estimate_of_aggregated_annual_costs_and_losses_reported, backup_policies_and_procedures_developed_and_documented, restoration_and_recovery_procedures_and_methods_developed_and_documented, backup_systems_that_can_be_activated_set_up, backup_activation_does_not_jeopardise_security, backup_and_restoration_procedures_periodically_tested, restoration_uses_segregated_and_protected_ict_systems, recovery_plans_enable_recovery_of_all_transactions, adequate_resources_and_backup_and_restoration_facilities_maintained, redundant_ict_capacities_maintained, need_for_redundant_ict_capacities_assessed, secondary_processing_site_maintained, secondary_site_located_at_geographical_distance, secondary_site_can_ensure_continuity_of_critical_or_important_functions, secondary_site_immediately_accessible_to_staff, recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, data_integrity_checks_performed_when_recovering, data_consistency_checks_performed_when_reconstructing_data],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(dora_entity_type, entity_type).
key_type(business_continuity_or_response_and_recovery_plans_activated, fact).
key_type(authority_requested_estimate_of_annual_ict_incident_costs_and_losses, fact).
key_type(backup_data_restored_using_own_systems, fact).
key_type(recovered_from_ict_related_incident, fact).
key_type(data_reconstructed_from_external_stakeholders, fact).
key_type(has_ict_business_continuity_policy, judgement).
key_type(continuity_policy_implemented_through_documented_arrangements, judgement).
key_type(arrangements_ensure_continuity_of_critical_or_important_functions, judgement).
key_type(arrangements_respond_to_and_resolve_ict_related_incidents, judgement).
key_type(arrangements_activate_containment_plans_without_delay, judgement).
key_type(arrangements_estimate_preliminary_impacts_damages_and_losses, judgement).
key_type(arrangements_set_out_communication_and_crisis_management_actions, judgement).
key_type(ict_response_and_recovery_plans_implemented, judgement).
key_type(response_and_recovery_plans_subject_to_independent_internal_audit_reviews, judgement).
key_type(ict_business_continuity_plans_in_place_maintained_and_periodically_tested, judgement).
key_type(business_impact_analysis_conducted, judgement).
key_type(ict_assets_and_services_aligned_with_business_impact_analysis, judgement).
key_type(plans_tested_at_least_yearly_and_on_substantive_changes, judgement).
key_type(crisis_communication_plans_tested, judgement).
key_type(testing_plans_include_cyber_attack_and_switchover_scenarios, judgement).
key_type(continuity_policy_and_plans_regularly_reviewed, judgement).
key_type(has_crisis_management_function, judgement).
key_type(records_of_activities_during_disruption_events_kept, judgement).
key_type(continuity_test_results_provided_to_competent_authorities, judgement).
key_type(estimate_of_aggregated_annual_costs_and_losses_reported, judgement).
key_type(backup_policies_and_procedures_developed_and_documented, judgement).
key_type(restoration_and_recovery_procedures_and_methods_developed_and_documented, judgement).
key_type(backup_systems_that_can_be_activated_set_up, judgement).
key_type(backup_activation_does_not_jeopardise_security, judgement).
key_type(backup_and_restoration_procedures_periodically_tested, judgement).
key_type(restoration_uses_segregated_and_protected_ict_systems, judgement).
key_type(recovery_plans_enable_recovery_of_all_transactions, judgement).
key_type(adequate_resources_and_backup_and_restoration_facilities_maintained, judgement).
key_type(redundant_ict_capacities_maintained, judgement).
key_type(need_for_redundant_ict_capacities_assessed, judgement).
key_type(secondary_processing_site_maintained, judgement).
key_type(secondary_site_located_at_geographical_distance, judgement).
key_type(secondary_site_can_ensure_continuity_of_critical_or_important_functions, judgement).
key_type(secondary_site_immediately_accessible_to_staff, judgement).
key_type(recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, judgement).
key_type(data_integrity_checks_performed_when_recovering, judgement).
key_type(data_consistency_checks_performed_when_reconstructing_data, judgement).

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
in_type_t(entity_type, Value, T) :-
    in_type_t(enum([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]), Value, T).
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
