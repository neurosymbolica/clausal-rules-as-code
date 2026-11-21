% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_queries, [nis2_scope_entity_class_profile_keys/1, nis2_scope_entity_class_what_if/4, annex_i_type/0, annex_ii_type/0, services_or_activities_in_union/0, staff_headcount/0, annual_turnover_eur/0, annual_balance_sheet_total_eur/0, public_electronic_communications_provider/0, trust_service_provider_status/0, tld_name_registry/0, dns_service_provider/0, sole_provider_of_an_essential_service_in_a_member_state/0, disruption_could_significantly_impact_public_safety_security_or_health/0, disruption_could_induce_a_significant_systemic_risk/0, critical_by_specific_national_or_regional_importance/0, public_administration_kind/0, public_administration_in_national_security_defence_or_law_enforcement/0, critical_entity_under_directive_2022_2557/0, domain_name_registration_service_entity/0, exempted_from_dora_scope_by_member_state/0, identified_by_member_state_as_essential_entity/0, former_operator_of_essential_services_kept_essential_by_member_state/0, unsure/0, not_a_trust_service_provider/0, non_qualified_trust_service_provider/0, qualified_trust_service_provider/0, not_public_administration/0, central_government/0, regional_with_risk_assessed_services/0, other_public_administration/0, microenterprise/0, small_enterprise/0, medium_sized_enterprise/0, large_enterprise/0, in_scope/0, out_of_scope/0, essential_entity/0, important_entity/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(library(reif), [if_/3]).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2]).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [nis2_scope_entity_class_status/2]).

nis2_scope_entity_class_profile_keys([annex_i_type, annex_ii_type, services_or_activities_in_union, staff_headcount, annual_turnover_eur, annual_balance_sheet_total_eur, public_electronic_communications_provider, trust_service_provider_status, tld_name_registry, dns_service_provider, sole_provider_of_an_essential_service_in_a_member_state, disruption_could_significantly_impact_public_safety_security_or_health, disruption_could_induce_a_significant_systemic_risk, critical_by_specific_national_or_regional_importance, public_administration_kind, public_administration_in_national_security_defence_or_law_enforcement, critical_entity_under_directive_2022_2557, domain_name_registration_service_entity, exempted_from_dora_scope_by_member_state, identified_by_member_state_as_essential_entity, former_operator_of_essential_services_kept_essential_by_member_state]).

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

unsure.

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

nis2_scope_entity_class_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_scope_entity_class_status(Hypothesis, NewStatus).

attribute_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    tfilter(other_key_t(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

other_key_t(OverriddenKey, attribute(ElementKey, _), Truth) :-
    if_(ElementKey = OverriddenKey, Truth = false, Truth = true).

test(the_key_schema_holds_twenty_one_keys) :-
    nis2_scope_entity_class_profile_keys(Keys),
    length(Keys, 21).
test(a_hypothetical_exemption_takes_the_entity_out_of_scope) :-
    nis2_scope_entity_class_what_if([], exempted_from_dora_scope_by_member_state, true, out_of_scope).
test(an_override_replaces_the_present_value) :-
    nis2_scope_entity_class_what_if([attribute(exempted_from_dora_scope_by_member_state, false)], exempted_from_dora_scope_by_member_state, true, out_of_scope).
test(an_override_answers_once) :-
    findall(Status, nis2_scope_entity_class_what_if([attribute(exempted_from_dora_scope_by_member_state, false)], exempted_from_dora_scope_by_member_state, true, Status), Statuses),
    Statuses == [out_of_scope].
test(the_root_atoms_are_served) :-
    annex_i_type,
    unsure,
    qualified_trust_service_provider,
    central_government,
    large_enterprise,
    important_entity.

test(a_hypothetical_exemption_is_not_essential, fail) :-
    nis2_scope_entity_class_what_if([], exempted_from_dora_scope_by_member_state, true, essential_entity).
