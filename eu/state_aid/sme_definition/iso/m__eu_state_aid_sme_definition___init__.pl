% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_citations, [citation/2, implements/1]).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [at_least_medium/0, at_least_medium/4, below_medium/0, decide_sme_definition/2, duplicate_key/1, indeterminate/1, input_problems/1, inputs_relied_on/1, large_enterprise/0, linked_enterprise/0, linked_enterprise_data/3, medium_sized_enterprise/0, micro_enterprise/0, needs_legal_review/2, neither_partner_nor_linked/0, not_an_enterprise/0, not_sme/0, not_sme_public_control/0, open_textured/2, partner_enterprise/0, partner_enterprise_data/4, period_size_class/4, provenance/2, relationship_type/4, size_class/4, small_enterprise/0, sme/0, sme_definition_checklist/2, sme_definition_decision_resolvable/1, sme_definition_status/2, sme_definition_status_values/1, sme_status/4, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_state_aid_sme_definition_queries, [sme_definition_profile_keys/1, sme_definition_what_if/4]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_assess/2, sme_definition_profile_for/2, sme_definition_subject/1]).

root_export(accounting_basis).
root_export(approved_accounts).
root_export(at_least_medium).
root_export(autonomous_local_authority).
root_export(below_medium).
root_export(bona_fide_estimate).
root_export(business_angel).
root_export(business_angels_total_investment_cents).
root_export(dominant_influence_by_contract_or_articles).
root_export(gber_annex_i).
root_export(holding_basis_points).
root_export(institutional_investor).
root_export(investor_category).
root_export(investor_involved_in_management).
root_export(is_enterprise).
root_export(large_enterprise).
root_export(linked_enterprise).
root_export(linked_enterprises).
root_export(local_authority_annual_budget_cents).
root_export(local_authority_inhabitants).
root_export(majority_of_voting_rights).
root_export(majority_of_voting_rights_by_shareholder_agreement).
root_export(medium_sized_enterprise).
root_export(micro_enterprise).
root_export(neither_partner_nor_linked).
root_export(no_previous_period).
root_export(not_a_listed_investor).
root_export(not_an_enterprise).
root_export(not_sme).
root_export(not_sme_public_control).
root_export(own_annual_balance_sheet_total_cents).
root_export(own_annual_turnover_cents).
root_export(own_staff_annual_work_units_hundredths).
root_export(partner_enterprise).
root_export(partner_enterprises).
root_export(previous_period_size_class).
root_export(public_bodies_control_25_percent_or_more).
root_export(public_investment_corporation_or_venture_capital_company).
root_export(recommendation_2003_361_annex).
root_export(relationship_only_through_natural_persons).
root_export(right_to_appoint_or_remove_majority_of_board).
root_export(same_or_adjacent_market).
root_export(size_class_held).
root_export(small_enterprise).
root_export(sme).
root_export(university_or_non_profit_research_centre).
root_export(unsure).
