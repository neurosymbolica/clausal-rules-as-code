% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [data_act_connected_product_data_sharing_checklist/2, data_act_connected_product_data_sharing_decision_resolvable/1, data_act_connected_product_data_sharing_status/2, data_act_connected_product_data_sharing_status_values/1, decide_data_act_connected_product_data_sharing/2, pre_contract_information_duty_status/3, product_design_duty_status/3, third_party_sharing_request_status/3, user_access_request_status/3]).
:- use_module(m__eu_data_act_connected_product_data_sharing_queries, [data_act_connected_product_data_sharing_profile_keys/1, data_act_connected_product_data_sharing_what_if/4]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_assess/2, data_act_connected_product_data_sharing_profile_for/2, data_act_connected_product_data_sharing_subject/1]).

root_export(addressee_is_data_holder).
root_export(connected_product_or_related_service).
root_export(data_accessible_by_default_as_required).
root_export(data_directly_accessible_by_user).
root_export(directly_accessible_where_relevant_and_feasible).
root_export(duplicate_key).
root_export(exceptional_trade_secret_refusal_invoked).
root_export(gdpr_conditions_for_making_available_met).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(open_textured).
root_export(other_persons_personal_data_requested).
root_export(placed_on_market_after_12_september_2026).
root_export(pre_contract_contract_kind).
root_export(provenance).
root_export(provision_of_related_service).
root_export(purchase_rent_or_lease_of_connected_product).
root_export(request_by_or_on_behalf_of_user).
root_export(requested_data_identified_as_trade_secrets).
root_export(requested_data_readily_available).
root_export(requester_is_user).
root_export(required_information_provided_before_contract).
root_export(security_restriction_agreed_applies).
root_export(small_enterprise_exemption_applies).
root_export(testing_data_not_yet_on_market).
root_export(third_party_is_designated_gatekeeper).
root_export(third_party_use_contractually_permitted).
root_export(trade_secret_disclosure_strictly_necessary).
root_export(trade_secret_measures_agreed_and_kept).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
