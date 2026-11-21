% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2, nis2_scope_entity_class_profile_key_order/1]).
:- use_module(m__eu_nis2_scope_entity_class_citations, [citation/2, citation_vocabulary/2, implements/1]).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [decide_nis2_scope_entity_class/2, entity_class/3, nis2_scope_entity_class_checklist/2, nis2_scope_entity_class_decision_resolvable/1, nis2_scope_entity_class_status/2, nis2_scope_entity_class_status_values/1, scope_decision/3, size_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_queries, [annex_i_type/0, annex_ii_type/0, annual_balance_sheet_total_eur/0, annual_turnover_eur/0, central_government/0, critical_by_specific_national_or_regional_importance/0, critical_entity_under_directive_2022_2557/0, disruption_could_induce_a_significant_systemic_risk/0, disruption_could_significantly_impact_public_safety_security_or_health/0, dns_service_provider/0, domain_name_registration_service_entity/0, essential_entity/0, exempted_from_dora_scope_by_member_state/0, former_operator_of_essential_services_kept_essential_by_member_state/0, identified_by_member_state_as_essential_entity/0, important_entity/0, in_scope/0, large_enterprise/0, medium_sized_enterprise/0, microenterprise/0, nis2_scope_entity_class_profile_keys/1, nis2_scope_entity_class_what_if/4, non_qualified_trust_service_provider/0, not_a_trust_service_provider/0, not_public_administration/0, other_public_administration/0, out_of_scope/0, public_administration_in_national_security_defence_or_law_enforcement/0, public_administration_kind/0, public_electronic_communications_provider/0, qualified_trust_service_provider/0, regional_with_risk_assessed_services/0, services_or_activities_in_union/0, small_enterprise/0, sole_provider_of_an_essential_service_in_a_member_state/0, staff_headcount/0, tld_name_registry/0, trust_service_provider_status/0, unsure/0]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_assess/2, nis2_scope_entity_class_profile_for/2, nis2_scope_entity_class_subject/1]).

root_export(annex_i_type).
root_export(annex_ii_type).
root_export(annual_balance_sheet_total_eur).
root_export(annual_turnover_eur).
root_export(central_government).
root_export(critical_by_specific_national_or_regional_importance).
root_export(critical_entity_under_directive_2022_2557).
root_export(disruption_could_induce_a_significant_systemic_risk).
root_export(disruption_could_significantly_impact_public_safety_security_or_health).
root_export(dns_service_provider).
root_export(domain_name_registration_service_entity).
root_export(duplicate_key).
root_export(essential_entity).
root_export(exempted_from_dora_scope_by_member_state).
root_export(former_operator_of_essential_services_kept_essential_by_member_state).
root_export(identified_by_member_state_as_essential_entity).
root_export(important_entity).
root_export(in_scope).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(large_enterprise).
root_export(medium_sized_enterprise).
root_export(microenterprise).
root_export(needs_legal_review).
root_export(non_qualified_trust_service_provider).
root_export(not_a_trust_service_provider).
root_export(not_public_administration).
root_export(open_textured).
root_export(other_public_administration).
root_export(out_of_scope).
root_export(provenance).
root_export(public_administration_in_national_security_defence_or_law_enforcement).
root_export(public_administration_kind).
root_export(public_electronic_communications_provider).
root_export(qualified_trust_service_provider).
root_export(regional_with_risk_assessed_services).
root_export(services_or_activities_in_union).
root_export(small_enterprise).
root_export(sole_provider_of_an_essential_service_in_a_member_state).
root_export(staff_headcount).
root_export(tld_name_registry).
root_export(trust_service_provider_status).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
