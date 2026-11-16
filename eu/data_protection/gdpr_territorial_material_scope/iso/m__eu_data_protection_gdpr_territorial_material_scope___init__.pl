% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [absent_keys/3, all_status/2, any_status/2, both_status/3, checklist_status/2, citation_order/1, either_status/3, gdpr_territorial_material_scope_input_problems/2, judgement_citation/2, limb_citation/2, limb_items/3, limb_status/3, limbs_absent_keys/3, negated/2, ordered_members/3, outside_fact_reading/2, present_pairs/3, reading/3, role_reading/2, scope_ground/2, scope_key_order/1, stage_limbs/2, stage_status/3, stage_statuses/4]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [decide_gdpr_applies/2, gdpr_applies/2, gdpr_applies_checklist/2, gdpr_applies_decision_resolvable/1, gdpr_applies_status/2, gdpr_applies_status_values/1, scope_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [decide_gdpr_scope_ground/2, gdpr_scope_ground/2, gdpr_scope_ground_checklist/2, gdpr_scope_ground_decision_resolvable/1, gdpr_scope_ground_status/2, gdpr_scope_ground_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [decide_representative_requirement/2, representative_requirement/2, representative_requirement_checklist/2, representative_requirement_decision_resolvable/1, representative_requirement_status/2, representative_requirement_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_queries, [decide_gdpr_scope/2, gdpr_territorial_material_scope_compliance_check/3, gdpr_territorial_material_scope_profile_keys/1, gdpr_territorial_material_scope_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_fixtures, [gdpr_territorial_material_scope_assess/2, gdpr_territorial_material_scope_profile_for/2, gdpr_territorial_material_scope_subject/1]).

root_export(absent).
root_export(activity_outside_union_law).
root_export(attestation).
root_export(attested).
root_export(controller).
root_export(criminal_law_enforcement_purpose).
root_export(cross_reference_unresolved).
root_export(data_subjects_in_union).
root_export(document).
root_export(duplicate_key).
root_export(established_in_union).
root_export(gdpr_scope_verdict).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(member_state_common_foreign_security_activity).
root_export(member_state_law_applies_by_public_international_law).
root_export(monitoring_behaviour_of_data_subjects_in_union).
root_export(needs_legal_review).
root_export(none).
root_export(not_attempted).
root_export(occasional_processing).
root_export(offering_goods_or_services_to_data_subjects_in_union).
root_export(open_textured).
root_export(outside_fact).
root_export(party_role).
root_export(personal_data_in_filing_system).
root_export(personal_data_processed).
root_export(processing_by_competent_authority).
root_export(processing_by_natural_person).
root_export(processing_by_union_institution).
root_export(processing_in_context_of_establishment_activities).
root_export(processing_wholly_or_partly_automated).
root_export(processor).
root_export(provenance).
root_export(public_authority_or_body).
root_export(purely_personal_or_household_activity).
root_export(resolution).
root_export(special_or_criminal_data_on_large_scale).
root_export(unknown_key).
root_export(unlikely_to_result_in_risk).
root_export(unsure).
root_export(url).
root_export(wrong_type).
