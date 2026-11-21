% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_fixtures, [dora_tlpt_subject/1, dora_tlpt_profile_for/2, dora_tlpt_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [decide_dora_tlpt/2]).

dora_tlpt_subject(article_16_1_entity_identified).
dora_tlpt_subject(microenterprise_identified).
dora_tlpt_subject(article_16_1_fact_missing).
dora_tlpt_subject(microenterprise_fact_missing).
dora_tlpt_subject(entity_type_missing_not_identified).
dora_tlpt_subject(central_securities_depository_identified_standard_frequency).
dora_tlpt_subject(central_securities_depository_identified_changed_frequency).
dora_tlpt_subject(central_securities_depository_identification_missing).
dora_tlpt_subject(central_securities_depository_frequency_missing).
dora_tlpt_subject(central_counterparty_not_identified).
dora_tlpt_subject(trade_repository_identified).
dora_tlpt_subject(systemic_credit_institution).
dora_tlpt_subject(non_systemic_credit_institution).
dora_tlpt_subject(payment_institution_above_threshold_both_years).
dora_tlpt_subject(payment_institution_at_threshold_first_year).
dora_tlpt_subject(payment_institution_second_year_missing).
dora_tlpt_subject(electronic_money_institution_mixed_figures).
dora_tlpt_subject(electronic_money_institution_at_money_threshold).
dora_tlpt_subject(trading_venue_electronic_national_leader).
dora_tlpt_subject(trading_venue_without_electronic_system).
dora_tlpt_subject(life_insurer_above_subset_share).
dora_tlpt_subject(life_insurer_at_subset_share).
dora_tlpt_subject(non_life_insurer_above_second_list_share).
dora_tlpt_subject(non_life_insurer_at_second_list_share).
dora_tlpt_subject(reinsurer_above_second_list_provisions).
dora_tlpt_subject(reinsurer_at_second_list_provisions).
dora_tlpt_subject(reinsurer_above_subset_premium).
dora_tlpt_subject(reinsurer_at_subset_premium).
dora_tlpt_subject(reinsurer_above_subset_provisions).
dora_tlpt_subject(reinsurer_at_subset_provisions).
dora_tlpt_subject(reinsurer_above_second_list_premium).
dora_tlpt_subject(reinsurer_at_second_list_premium).
dora_tlpt_subject(float_premium_figure).
dora_tlpt_subject(unknown_key_present).

dora_tlpt_profile_for(Subject, Profile) :-
    subject_attributes(Subject, Profile).

subject_attributes(article_16_1_entity_identified, [attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)]).
subject_attributes(microenterprise_identified, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, true), attribute(dora_entity_type, trading_venue), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true)]).
subject_attributes(article_16_1_fact_missing, [attribute(financial_entity_is_microenterprise, true)]).
subject_attributes(microenterprise_fact_missing, [attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, central_counterparty)]).
subject_attributes(entity_type_missing_not_identified, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(central_securities_depository_identified_standard_frequency, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_securities_depository), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)]).
subject_attributes(central_securities_depository_identified_changed_frequency, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_securities_depository), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, true)]).
subject_attributes(central_securities_depository_identification_missing, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_securities_depository)]).
subject_attributes(central_securities_depository_frequency_missing, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_securities_depository), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true)]).
subject_attributes(central_counterparty_not_identified, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(trade_repository_identified, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, trade_repository), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)]).
subject_attributes(systemic_credit_institution, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(credit_institution_is_or_is_part_of_g_sii_or_o_sii, true), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(non_systemic_credit_institution, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(credit_institution_is_or_is_part_of_g_sii_or_o_sii, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(payment_institution_above_threshold_both_years, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 150000000001), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 150000000001), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(payment_institution_at_threshold_first_year, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 150000000000), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 150000000001), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(payment_institution_second_year_missing, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 150000000001), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(electronic_money_institution_mixed_figures, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, electronic_money_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 150000000001), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 0), attribute(outstanding_electronic_money_eur_first_preceding_calendar_year, 0), attribute(outstanding_electronic_money_eur_second_preceding_calendar_year, 40000000001), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(electronic_money_institution_at_money_threshold, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, electronic_money_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 150000000001), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 0), attribute(outstanding_electronic_money_eur_first_preceding_calendar_year, 0), attribute(outstanding_electronic_money_eur_second_preceding_calendar_year, 40000000000), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(trading_venue_electronic_national_leader, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, trading_venue), attribute(trading_venue_has_electronic_trading_system, true), attribute(trading_venue_has_highest_national_turnover_share_in_both_preceding_years, true), attribute(trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(trading_venue_without_electronic_system, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, trading_venue), attribute(trading_venue_has_electronic_trading_system, false), attribute(trading_venue_has_highest_national_turnover_share_in_both_preceding_years, true), attribute(trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years, true), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(life_insurer_above_subset_share, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, insurance_undertaking), attribute(insurance_undertaking_activities, life_only), attribute(gross_written_premium_eur, 3000000001), attribute(technical_provisions_eur, 10000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 351), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(life_insurer_at_subset_share, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, insurance_undertaking), attribute(insurance_undertaking_activities, life_only), attribute(gross_written_premium_eur, 3000000001), attribute(technical_provisions_eur, 10000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 350), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(non_life_insurer_above_second_list_share, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, insurance_undertaking), attribute(insurance_undertaking_activities, non_life_only), attribute(gross_written_premium_eur, 2000000000), attribute(technical_provisions_eur, 20000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 1001), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(non_life_insurer_at_second_list_share, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, insurance_undertaking), attribute(insurance_undertaking_activities, non_life_only), attribute(gross_written_premium_eur, 2000000000), attribute(technical_provisions_eur, 20000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 1000), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_above_second_list_provisions, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 2000000000), attribute(technical_provisions_eur, 30000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_at_second_list_provisions, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 2000000000), attribute(technical_provisions_eur, 30000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_above_subset_premium, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 1500000001), attribute(technical_provisions_eur, 40000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_at_subset_premium, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 1500000000), attribute(technical_provisions_eur, 40000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_above_subset_provisions, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 3500000000), attribute(technical_provisions_eur, 10000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_at_subset_provisions, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 3500000000), attribute(technical_provisions_eur, 10000000000), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_above_second_list_premium, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 3000000001), attribute(technical_provisions_eur, 10000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(reinsurer_at_second_list_premium, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, reinsurance_undertaking), attribute(gross_written_premium_eur, 3000000000), attribute(technical_provisions_eur, 10000000001), attribute(total_assets_share_of_member_state_insurance_sector_basis_points, 0), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, false)]).
subject_attributes(float_premium_figure, [attribute(gross_written_premium_eur, FloatPremiumEur)]) :-
    FloatPremiumEur is float(1500000000).
subject_attributes(unknown_key_present, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(colour_of_logo, blue)]).

dora_tlpt_assess(Subject, Result) :-
    dora_tlpt_profile_for(Subject, Profile),
    decide_dora_tlpt(Profile, Result).

test(every_subject_has_one_profile) :-
    findall(Subject, dora_tlpt_subject(Subject), Subjects),
    findall(Subject, (dora_tlpt_subject(Subject), dora_tlpt_profile_for(Subject, _)), ProfiledSubjects),
    Subjects == ProfiledSubjects.
test(every_subject_is_assessed_once) :-
    findall(Subject, dora_tlpt_subject(Subject), Subjects),
    findall(Subject, (dora_tlpt_subject(Subject), dora_tlpt_assess(Subject, _)), AssessedSubjects),
    Subjects == AssessedSubjects.
test(the_identified_depository_must_test) :-
    dora_tlpt_assess(central_securities_depository_identified_standard_frequency, dora_tlpt_verdict(tlpt_required(at_least_every_three_years), _)).
