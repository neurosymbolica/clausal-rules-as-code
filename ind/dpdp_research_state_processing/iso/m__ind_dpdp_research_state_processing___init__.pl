% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_day_before/3, dpdp_research_state_processing_first_step/4, dpdp_research_state_processing_input_problems/2, dpdp_research_state_processing_key_state/3, dpdp_research_state_processing_referral/3]).
:- use_module(m__ind_dpdp_research_state_processing_citations, [citation/2, citation_vocabulary/1, implements/1]).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [decide_dpdp_research_state_processing/2, dpdp_research_state_processing_checklist/2, dpdp_research_state_processing_decision_resolvable/1, dpdp_research_state_processing_status/2, dpdp_research_state_processing_status_values/1, research_exemption/3, state_processing_disapplied_provisions/3, state_processing_standards/3]).
:- use_module(m__ind_dpdp_research_state_processing_queries, [dpdp_research_state_processing_profile_keys/1, dpdp_research_state_processing_what_if/4, duplicate_key/1, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, provenance/2, unknown_key/1, wrong_type/1]).
:- use_module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_assess/2, dpdp_research_state_processing_profile_for/2, dpdp_research_state_processing_subject/1]).

root_export(accountability_for_observance).
root_export(business_contact_for_questions).
root_export(completeness_accuracy_and_consistency).
root_export(consistent_with_other_applicable_standards).
root_export(does_not_follow_second_schedule).
root_export(exempt_from_act).
root_export(follows_second_schedule).
root_export(intimation_to_data_principal).
root_export(lawful_manner).
root_export(limited_to_necessary_personal_data).
root_export(link_and_means_to_exercise_rights).
root_export(not_applicable).
root_export(not_exempt).
root_export(not_in_force).
root_export(personal_data_to_be_used_for_decision_specific_to_data_principal).
root_export(processing_by_state_or_instrumentality).
root_export(processing_for_section_7_b_use).
root_export(processing_necessary_for_research_archiving_or_statistical_purposes).
root_export(purpose_includes_decision_affecting_data_principal).
root_export(reasonable_security_safeguards).
root_export(reference_date).
root_export(retention_only_while_required).
root_export(section_17_in_force_on_reference_date).
root_export(section_7_in_force_on_reference_date).
root_export(sections_8_7_12_2_and_12_3_do_not_apply).
root_export(sections_8_7_and_12_3_do_not_apply).
root_export(unsure).
