% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_queries, [nis2_scope_entity_class_profile_keys/1, nis2_scope_entity_class_what_if/4, annex_i_type/0, annex_ii_type/0, services_or_activities_in_union/0, staff_headcount/0, annual_turnover_eur/0, annual_balance_sheet_total_eur/0, public_electronic_communications_provider/0, trust_service_provider_status/0, tld_name_registry/0, dns_service_provider/0, sole_provider_of_an_essential_service_in_a_member_state/0, disruption_could_significantly_impact_public_safety_security_or_health/0, disruption_could_induce_a_significant_systemic_risk/0, critical_by_specific_national_or_regional_importance/0, public_administration_kind/0, public_administration_in_national_security_defence_or_law_enforcement/0, critical_entity_under_directive_2022_2557/0, domain_name_registration_service_entity/0, exempted_from_dora_scope_by_member_state/0, identified_by_member_state_as_essential_entity/0, former_operator_of_essential_services_kept_essential_by_member_state/0, not_a_trust_service_provider/0, non_qualified_trust_service_provider/0, qualified_trust_service_provider/0, not_public_administration/0, central_government/0, regional_with_risk_assessed_services/0, other_public_administration/0, microenterprise/0, small_enterprise/0, medium_sized_enterprise/0, large_enterprise/0, in_scope/0, out_of_scope/0, essential_entity/0, important_entity/0, unsure/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2]).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [nis2_scope_entity_class_status/2]).

nis2_scope_entity_class_profile_keys([annex_i_type, annex_ii_type, services_or_activities_in_union, staff_headcount, annual_turnover_eur, annual_balance_sheet_total_eur, public_electronic_communications_provider, trust_service_provider_status, tld_name_registry, dns_service_provider, sole_provider_of_an_essential_service_in_a_member_state, disruption_could_significantly_impact_public_safety_security_or_health, disruption_could_induce_a_significant_systemic_risk, critical_by_specific_national_or_regional_importance, public_administration_kind, public_administration_in_national_security_defence_or_law_enforcement, critical_entity_under_directive_2022_2557, domain_name_registration_service_entity, exempted_from_dora_scope_by_member_state, identified_by_member_state_as_essential_entity, former_operator_of_essential_services_kept_essential_by_member_state]).

nis2_scope_entity_class_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_scope_entity_class_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, NewAttributes) :-
    ElementKey == Key,
    override_attribute(Elements, Key, Value, NewAttributes).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|NewAttributes]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, NewAttributes).

annex_i_type.

annex_ii_type.

services_or_activities_in_union.

staff_headcount.

annual_turnover_eur.

annual_balance_sheet_total_eur.

public_electronic_communications_provider.

trust_service_provider_status.

tld_name_registry.

dns_service_provider.

sole_provider_of_an_essential_service_in_a_member_state.

disruption_could_significantly_impact_public_safety_security_or_health.

disruption_could_induce_a_significant_systemic_risk.

critical_by_specific_national_or_regional_importance.

public_administration_kind.

public_administration_in_national_security_defence_or_law_enforcement.

critical_entity_under_directive_2022_2557.

domain_name_registration_service_entity.

exempted_from_dora_scope_by_member_state.

identified_by_member_state_as_essential_entity.

former_operator_of_essential_services_kept_essential_by_member_state.

not_a_trust_service_provider.

non_qualified_trust_service_provider.

qualified_trust_service_provider.

not_public_administration.

central_government.

regional_with_risk_assessed_services.

other_public_administration.

microenterprise.

small_enterprise.

medium_sized_enterprise.

large_enterprise.

in_scope.

out_of_scope.

essential_entity.

important_entity.

unsure.

indeterminate([_|_]).

needs_legal_review(open_textured(_, _), [inputs_relied_on(_)|_]).

open_textured(Key, cite(_)) :-
    atom(Key).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

input_problems([_|_]).

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).
