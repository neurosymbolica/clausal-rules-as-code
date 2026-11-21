% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_texas_tdpsa_kernel, [texas_tdpsa_input_problems/2]).
:- use_module(m__us_texas_tdpsa_citations, [citation/2, implements/1]).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [appeal_response_deadline/4, applicability_status/4, attorney_general_action_status/5, civil_penalty_maximum/3, cure_period_last_day/4, decide_texas_tdpsa/2, extended_response_deadline/4, response_deadline/4, texas_tdpsa_checklist/2, texas_tdpsa_decision_resolvable/1, texas_tdpsa_status/2, texas_tdpsa_status_values/1]).
:- use_module(m__us_texas_tdpsa_queries, [action_may_be_brought/0, cure_period_running/0, in_scope/0, no_action_for_cured_violation/0, no_civil_penalty/0, no_extension_available/0, out_of_scope/0, texas_tdpsa_profile_keys/1, texas_tdpsa_what_if/4]).
:- use_module(m__us_texas_tdpsa_fixtures, [texas_tdpsa_assess/2, texas_tdpsa_profile_for/2, texas_tdpsa_subject/1]).

root_export(absent).
root_export(action_may_be_brought).
root_export(attestation).
root_export(attested).
root_export(conducts_business_in_texas_or_serves_texas_residents).
root_export(covered_entity_or_business_associate_under_hipaa).
root_export(cross_reference_unresolved).
root_export(cure_period_running).
root_export(cured_within_cure_period).
root_export(document).
root_export(duplicate_key).
root_export(electric_utility_power_generation_company_or_retail_electric_provider).
root_export(entity_category).
root_export(extension_notice_given_within_initial_period).
root_export(extension_reasonably_necessary).
root_export(financial_institution).
root_export(in_scope).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(institution_of_higher_education).
root_export(needs_legal_review).
root_export(no_action_for_cured_violation).
root_export(no_civil_penalty).
root_export(no_extension_available).
root_export(none_of_the_excluded_categories).
root_export(nonprofit_organization).
root_export(not_attempted).
root_export(open_textured).
root_export(out_of_scope).
root_export(outside_fact).
root_export(processes_or_sells_personal_data).
root_export(provenance).
root_export(resolution).
root_export(small_business_as_defined_by_sba).
root_export(state_agency_or_political_subdivision).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(violation_after_cure_period_or_statement_breach).
root_export(violation_count).
root_export(written_statement_breached).
root_export(written_statement_provided).
root_export(wrong_type).
