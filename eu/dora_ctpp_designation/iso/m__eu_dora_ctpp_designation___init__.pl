% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_designation_kernel, [dora_ctpp_designation_category_synonym/3, dora_ctpp_designation_financial_entity_type/2, dora_ctpp_designation_input_problems/2, dora_ctpp_designation_shared_type/3]).
:- use_module(m__eu_dora_ctpp_designation_citations, [citation/2, implements/1]).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [ctpp_designated_provider_duties/3, ctpp_designation_criteria_status/3, ctpp_lead_overseer/3, ctpp_step_1_indicators/3, decide_dora_ctpp_designation/2, designation_not_applicable/1, dora_ctpp_designation_checklist/2, dora_ctpp_designation_decision_resolvable/1, dora_ctpp_designation_status/2, dora_ctpp_designation_status_values/1, indeterminate/1, input_problems/1, lead_overseer/1, lead_overseer_tied/1, not_an_ict_third_party_service_provider/0, not_designated_as_critical/0, required/1, step_1_indicators/1, step_1_sub_criteria_fulfilled/0, step_1_sub_criteria_not_fulfilled/0, sub_criteria_1_1_and_1_2/1, sub_criterion_2_1/0, sub_criterion_2_2/0, sub_criterion_4_1/1, sub_criterion_4_2/1]).
:- use_module(m__eu_dora_ctpp_designation_queries, [dora_ctpp_designation_profile_keys/1, dora_ctpp_designation_what_if/4]).
:- use_module(m__eu_dora_ctpp_designation_fixtures, [dora_ctpp_designation_assess/2, dora_ctpp_designation_profile_for/2, dora_ctpp_designation_subject/1]).

root_export(account_information_service_provider).
root_export(administrator_of_critical_benchmarks).
root_export(ancillary_insurance_intermediary).
root_export(article_127_2_tfeu_oversight_framework).
root_export(central_counterparty).
root_export(central_securities_depository).
root_export(credit_institution).
root_export(credit_rating_agency).
root_export(crowdfunding_service_provider).
root_export(crypto_asset_service_provider).
root_export(data_reporting_service_provider).
root_export(designate_coordination_point).
root_export(dora_entity_type).
root_export(duplicate_key).
root_export(eba).
root_export(eiopa).
root_export(electronic_money_institution).
root_export(esma).
root_export(exempted_electronic_money_institution).
root_export(exempted_payment_institution).
root_export(financial_entities_served_are_active_only_in_that_member_state).
root_export(financial_entity).
root_export(g_sii_served_count).
root_export(ict_intra_group_service_provider).
root_export(ict_third_party_service_provider).
root_export(institution_exempted_pursuant_to_directive_2013_36).
root_export(institution_for_occupational_retirement_provision).
root_export(insurance_intermediary).
root_export(insurance_undertaking).
root_export(investment_firm).
root_export(issuer_of_asset_referenced_tokens).
root_export(management_company).
root_export(manager_of_alternative_investment_funds).
root_export(none_of_the_listed_types).
root_export(not_an_ict_third_party_service_provider).
root_export(not_designated_as_critical).
root_export(notify_financial_entities_of_designation).
root_export(notify_lead_overseer_of_subsidiary_management_changes).
root_export(o_sii_scores_of_o_siis_served).
root_export(payment_institution).
root_export(provider_designated_as_critical).
root_export(provider_established_in_third_country).
root_export(provider_is_ict_intra_group_service_provider).
root_export(provider_is_part_of_a_group).
root_export(provider_provides_ict_services_solely_in_one_member_state).
root_export(provider_subject_to_article_127_2_tfeu_oversight_framework).
root_export(reinsurance_intermediary).
root_export(reinsurance_undertaking).
root_export(securitisation_repository).
root_export(single_member_state_provider).
root_export(step_1_sub_criteria_fulfilled).
root_export(step_1_sub_criteria_not_fulfilled).
root_export(sub_criterion_2_1).
root_export(sub_criterion_2_2).
root_export(substitutability_figures).
root_export(systemic_impact_figures).
root_export(systemic_infrastructure_entities_served_count).
root_export(systemic_other_entities_served_count).
root_export(total_assets_of_users_within_eba_responsibility).
root_export(total_assets_of_users_within_eiopa_responsibility).
root_export(total_assets_of_users_within_esma_responsibility).
root_export(trade_repository).
root_export(trading_venue).
root_export(unknown_key).
root_export(wrong_type).
