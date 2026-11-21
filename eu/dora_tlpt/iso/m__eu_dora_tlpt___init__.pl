% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_kernel, [dora_tlpt_input_problems/2]).
:- use_module(m__eu_dora_tlpt_citations, [citation/2, implements/1]).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [decide_dora_tlpt/2, dora_tlpt_checklist/2, dora_tlpt_decision_resolvable/1, dora_tlpt_status/2, dora_tlpt_status_values/1, tlpt_duty/3, tlpt_identification_basis/3]).
:- use_module(m__eu_dora_tlpt_queries, [dora_tlpt_profile_keys/1, dora_tlpt_what_if/4, duplicate_key/1, excluded_from_tlpt/1, indeterminate/1, input_problems/1, listed_for_tlpt/1, no_tlpt_duty/1, not_listed_for_tlpt/0, tlpt_required/1]).
:- use_module(m__eu_dora_tlpt_fixtures, [dora_tlpt_assess/2, dora_tlpt_profile_for/2, dora_tlpt_subject/1]).

root_export(account_information_service_provider).
root_export(administrator_of_critical_benchmarks).
root_export(ancillary_insurance_intermediary).
root_export(article_16_1_entity).
root_export(at_least_every_three_years).
root_export(central_counterparty).
root_export(central_securities_depository).
root_export(credit_institution).
root_export(credit_institution_is_or_is_part_of_g_sii_or_o_sii).
root_export(credit_rating_agency).
root_export(crowdfunding_service_provider).
root_export(crypto_asset_service_provider).
root_export(data_reporting_service_provider).
root_export(dora_entity_type).
root_export(electronic_money_institution).
root_export(exempted_electronic_money_institution).
root_export(exempted_payment_institution).
root_export(financial_entity_is_article_16_1_entity).
root_export(financial_entity_is_microenterprise).
root_export(frequency_set_by_competent_authority).
root_export(gross_written_premium_eur).
root_export(ict_third_party_service_provider).
root_export(identified_by_tlpt_authority_as_required_to_perform_tlpt).
root_export(institution_exempted_pursuant_to_directive_2013_36).
root_export(institution_for_occupational_retirement_provision).
root_export(insurance_intermediary).
root_export(insurance_undertaking).
root_export(insurance_undertaking_activities).
root_export(investment_firm).
root_export(issuer_of_asset_referenced_tokens).
root_export(life_and_non_life).
root_export(life_only).
root_export(management_company).
root_export(manager_of_alternative_investment_funds).
root_export(microenterprise).
root_export(non_life_only).
root_export(none_of_the_listed_types).
root_export(not_identified).
root_export(not_listed_for_tlpt).
root_export(outstanding_electronic_money_eur_first_preceding_calendar_year).
root_export(outstanding_electronic_money_eur_second_preceding_calendar_year).
root_export(payment_institution).
root_export(payment_transactions_total_value_eur_first_preceding_calendar_year).
root_export(payment_transactions_total_value_eur_second_preceding_calendar_year).
root_export(point_a).
root_export(point_b).
root_export(point_c).
root_export(point_d).
root_export(point_e).
root_export(point_f).
root_export(point_g).
root_export(reinsurance_intermediary).
root_export(reinsurance_undertaking).
root_export(securitisation_repository).
root_export(technical_provisions_eur).
root_export(tlpt_frequency_changed_by_competent_authority).
root_export(total_assets_share_of_member_state_insurance_sector_basis_points).
root_export(trade_repository).
root_export(trading_venue).
root_export(trading_venue_has_electronic_trading_system).
root_export(trading_venue_has_highest_national_turnover_share_in_both_preceding_years).
root_export(trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years).
root_export(unknown_key).
root_export(wrong_type).
