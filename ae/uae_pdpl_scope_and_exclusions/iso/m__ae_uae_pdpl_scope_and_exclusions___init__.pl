% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_citations, [citation/2, implements/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [decide_uae_pdpl_scope_and_exclusions/2, pdpl_applies/3, pdpl_in_force/3, uae_pdpl_scope_and_exclusions_checklist/2, uae_pdpl_scope_and_exclusions_decision_resolvable/1, uae_pdpl_scope_and_exclusions_status/2, uae_pdpl_scope_and_exclusions_status_values/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_queries, [duplicate_key/1, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, provenance/2, uae_pdpl_scope_and_exclusions_profile_keys/1, uae_pdpl_scope_and_exclusions_what_if/4, wrong_type/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_assess/2, uae_pdpl_scope_and_exclusions_profile_for/2, uae_pdpl_scope_and_exclusions_subject/1]).

root_export(activity_is_processing_of_personal_data).
root_export(applies).
root_export(controller_or_processor_resides_in_state).
root_export(data_subject_inside_state).
root_export(data_subject_processing_own_data_for_personal_purposes).
root_export(data_subject_resides_or_has_place_of_business_in_state).
root_export(does_not_apply).
root_export(free_zone_company_or_establishment_with_own_data_protection_legislation).
root_export(governmental_entity_controls_or_processes).
root_export(in_force).
root_export(not_in_force).
root_export(personal_banking_or_credit_data_with_own_protection_legislation).
root_export(personal_data_held_by_security_or_judicial_authorities).
root_export(personal_data_is_government_data).
root_export(personal_health_data_with_own_protection_legislation).
root_export(processing_date).
root_export(unknown_key).
root_export(unsure).
