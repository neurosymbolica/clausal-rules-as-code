% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_citations, [citation/2, implements/1]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_dma_art_5_2_data_combination_order, [article_5_application_status/4, consent_request_repetition_status/6, decide_dma_art_5_2_data_combination_order/2, dma_art_5_2_data_combination_order_checklist/2, dma_art_5_2_data_combination_order_decision_resolvable/1, dma_art_5_2_data_combination_order_status/2, dma_art_5_2_data_combination_order_status_values/1, personal_data_practice_status/4]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_queries, [absent/0, article_5_obligations_apply/0, article_5_obligations_do_not_apply/0, combining_personal_data/0, consent_request_already_repeated_in_period/0, cross_using_personal_data/0, designated_as_gatekeeper_for_core_platform_service/0, dma_art_5_2_data_combination_order_profile_keys/1, dma_art_5_2_data_combination_order_what_if/4, end_user_consent_given/0, end_user_presented_with_specific_choice/0, gatekeeper_may_rely_on_article_6_1_c_d_or_e/0, none_of_the_four_practices/0, not_attempted/0, practice_allowed_on_other_legal_basis/0, practice_allowed_with_consent/0, practice_outside_article_5_2/0, practice_prohibited/0, practice_under_article_5_2/0, processing_for_online_advertising_services/0, repeated_request_not_permitted/0, repeated_request_permitted/0, request_after_one_year_period/0, signing_in_end_users_to_combine_personal_data/0, unsure/0]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_fixtures, [dma_art_5_2_data_combination_order_assess/2, dma_art_5_2_data_combination_order_profile_for/2, dma_art_5_2_data_combination_order_subject/1]).

root_export(absent).
root_export(article_5_obligations_apply).
root_export(article_5_obligations_do_not_apply).
root_export(attestation).
root_export(combining_personal_data).
root_export(consent_request_already_repeated_in_period).
root_export(cross_reference_unresolved).
root_export(cross_using_personal_data).
root_export(designated_as_gatekeeper_for_core_platform_service).
root_export(end_user_consent_given).
root_export(end_user_presented_with_specific_choice).
root_export(gatekeeper_may_rely_on_article_6_1_c_d_or_e).
root_export(indeterminate).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(none_of_the_four_practices).
root_export(not_attempted).
root_export(open_textured).
root_export(outside_fact).
root_export(practice_allowed_on_other_legal_basis).
root_export(practice_allowed_with_consent).
root_export(practice_outside_article_5_2).
root_export(practice_prohibited).
root_export(practice_under_article_5_2).
root_export(processing_for_online_advertising_services).
root_export(repeated_request_not_permitted).
root_export(repeated_request_permitted).
root_export(request_after_one_year_period).
root_export(resolution).
root_export(signing_in_end_users_to_combine_personal_data).
root_export(unsure).
