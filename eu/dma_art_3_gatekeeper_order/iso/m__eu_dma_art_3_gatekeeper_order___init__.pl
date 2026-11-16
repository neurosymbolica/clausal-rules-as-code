% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_contract_key/2, dma_art_3_gatekeeper_order_input_problems/2, dma_art_3_gatekeeper_order_merge_citations/3, dma_art_3_gatekeeper_order_outside_fact/3]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_citations, [citation/2, implements/1]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [decide_dma_art_3_gatekeeper_order/2, designation_requirements_status/4, dma_art_3_gatekeeper_order_checklist/2, dma_art_3_gatekeeper_order_decision_resolvable/1, dma_art_3_gatekeeper_order_status/2, dma_art_3_gatekeeper_order_status_values/1, entrenchment_threshold_status/3, gatekeeper_status/4, gateway_threshold_status/3, impact_threshold_status/3, presumption_status/3]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_queries, [attested/2, designated_gatekeeper/0, dma_art_3_gatekeeper_order_eligibility/3, dma_art_3_gatekeeper_order_profile_keys/1, dma_art_3_gatekeeper_order_what_if/4, document/2, duplicate_key/1, entrenchment_threshold_met/0, entrenchment_threshold_not_met/0, gatekeeper_not_presumed/0, gatekeeper_presumed/0, gateway_threshold_met/0, gateway_threshold_not_met/0, impact_threshold_met/0, impact_threshold_not_met/0, indeterminate/1, input_problems/1, needs_legal_review/2, not_designated_gatekeeper/0, outside_fact/2, provenance/2, requirements_met/0, requirements_not_met/0, requirements_presumed_met/0, unknown_key/1, url/2, wrong_type/1]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_fixtures, [dma_art_3_gatekeeper_order_assess/2, dma_art_3_gatekeeper_order_profile_for/2, dma_art_3_gatekeeper_order_subject/1]).

root_export(absent).
root_export(attestation).
root_export(core_platform_service_is_important_gateway).
root_export(cross_reference_unresolved).
root_export(designated_as_gatekeeper_for_core_platform_service).
root_export(designated_gatekeeper).
root_export(entrenched_and_durable_position).
root_export(entrenchment_threshold_met).
root_export(entrenchment_threshold_not_met).
root_export(gatekeeper_not_presumed).
root_export(gatekeeper_presumed).
root_export(gateway_threshold_met).
root_export(gateway_threshold_not_met).
root_export(impact_threshold_met).
root_export(impact_threshold_not_met).
root_export(inputs_relied_on).
root_export(market_capitalisation_eur_most_recent_financial_year).
root_export(member_states_where_core_platform_service_provided).
root_export(monthly_active_end_users_most_recent_financial_year).
root_export(monthly_active_end_users_second_most_recent_financial_year).
root_export(monthly_active_end_users_third_most_recent_financial_year).
root_export(not_attempted).
root_export(not_designated_gatekeeper).
root_export(open_textured).
root_export(rebuttal_accepted_by_commission).
root_export(rebuttal_arguments_presented).
root_export(requirements_met).
root_export(requirements_not_met).
root_export(requirements_presumed_met).
root_export(resolution).
root_export(significant_impact_on_internal_market).
root_export(union_turnover_eur_most_recent_financial_year).
root_export(union_turnover_eur_second_most_recent_financial_year).
root_export(union_turnover_eur_third_most_recent_financial_year).
root_export(unsure).
root_export(yearly_active_business_users_most_recent_financial_year).
root_export(yearly_active_business_users_second_most_recent_financial_year).
root_export(yearly_active_business_users_third_most_recent_financial_year).
