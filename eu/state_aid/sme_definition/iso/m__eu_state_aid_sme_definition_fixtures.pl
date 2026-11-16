% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_subject/1, sme_definition_profile_for/2, sme_definition_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [decide_sme_definition/2]).

autonomous_figures(Staff, Turnover, Balance, [attribute(own_staff_annual_work_units_hundredths, Staff), attribute(own_annual_turnover_cents, Turnover), attribute(own_annual_balance_sheet_total_cents, Balance), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]).

estimate_profile(Staff, Turnover, Balance, Profile) :-
    autonomous_figures(Staff, Turnover, Balance, Figures),
    append([attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(accounting_basis, bona_fide_estimate)], Figures, Profile).

approved_small_profile(Extras, Profile) :-
    autonomous_figures(2000, 500000000, 500000000, Figures),
    append([[attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(accounting_basis, approved_accounts)], Figures, Extras], Profile).

relation_profile(Dominant, Extras, Profile) :-
    append([attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, Dominant)], Extras, Profile).

fixture(micro_staff_just_below_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(999, 100000000, 100000000, Profile).
fixture(micro_staff_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(1000, 100000000, 100000000, Profile).
fixture(micro_turnover_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(500, 200000000, 300000000, Profile).
fixture(micro_turnover_one_cent_above_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(500, 200000001, 300000000, Profile).
fixture(micro_balance_sheet_at_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(500, 300000000, 200000000, Profile).
fixture(micro_balance_sheet_one_cent_above_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(500, 300000000, 200000001, Profile).
fixture(small_staff_just_below_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(4999, 500000000, 500000000, Profile).
fixture(small_staff_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(5000, 500000000, 500000000, Profile).
fixture(small_turnover_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(2000, 1000000000, 1100000000, Profile).
fixture(small_turnover_one_cent_above_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(2000, 1000000001, 1100000000, Profile).
fixture(small_balance_sheet_at_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(2000, 1100000000, 1000000000, Profile).
fixture(small_balance_sheet_one_cent_above_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(2000, 1100000000, 1000000001, Profile).
fixture(medium_staff_just_below_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(24999, 3000000000, 3000000000, Profile).
fixture(medium_staff_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(25000, 3000000000, 3000000000, Profile).
fixture(medium_turnover_at_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(10000, 5000000000, 5000000000, Profile).
fixture(medium_turnover_one_cent_above_ceiling, period_size_class, recommendation_2003_361_annex, Profile) :-
    autonomous_figures(10000, 5000000001, 5000000000, Profile).
fixture(medium_balance_sheet_at_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(10000, 6000000000, 4300000000, Profile).
fixture(medium_balance_sheet_one_cent_above_ceiling, period_size_class, gber_annex_i, Profile) :-
    autonomous_figures(10000, 6000000000, 4300000001, Profile).
fixture(partner_share_lifts_staff_to_ceiling, period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 800), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [partner_enterprise_data(2500, 800, 0, 0)]), attribute(linked_enterprises, [])]).
fixture(partner_share_one_point_below, period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 800), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [partner_enterprise_data(2499, 800, 0, 0)]), attribute(linked_enterprises, [])]).
fixture(linked_staff_lifts_to_ceiling, period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [linked_enterprise_data(500, 0, 0)])]).
fixture(linked_staff_one_hundredth_below, period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [linked_enterprise_data(499, 0, 0)])]).
fixture(linked_list_not_given, period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [])]).
fixture(entity_not_an_enterprise, size_class, recommendation_2003_361_annex, [attribute(is_enterprise, false)]).
fixture(enterprise_status_unsure_under_public_control, size_class, recommendation_2003_361_annex, [attribute(is_enterprise, unsure), attribute(public_bodies_control_25_percent_or_more, true)]).
fixture(public_body_control_reached, size_class, gber_annex_i, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, true)]).
fixture(public_body_control_not_reached, size_class, gber_annex_i, Profile) :-
    estimate_profile(999, 100000000, 100000000, Profile).
fixture(two_periods_held_micro_kept, size_class, recommendation_2003_361_annex, Profile) :-
    approved_small_profile([attribute(previous_period_size_class, micro_enterprise), attribute(size_class_held, micro_enterprise)], Profile).
fixture(two_periods_held_small_kept, size_class, recommendation_2003_361_annex, Profile) :-
    approved_small_profile([attribute(previous_period_size_class, micro_enterprise), attribute(size_class_held, small_enterprise)], Profile).
fixture(two_periods_both_small, size_class, recommendation_2003_361_annex, Profile) :-
    approved_small_profile([attribute(previous_period_size_class, small_enterprise)], Profile).
fixture(sme_staff_just_below_medium_ceiling, sme_status, recommendation_2003_361_annex, Profile) :-
    estimate_profile(24999, 3000000000, 3000000000, Profile).
fixture(sme_staff_at_medium_ceiling, sme_status, recommendation_2003_361_annex, Profile) :-
    estimate_profile(25000, 3000000000, 3000000000, Profile).
fixture(sme_under_public_control, sme_status, gber_annex_i, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, true)]).
fixture(staff_just_below_small_ceiling_is_below_medium, at_least_medium, recommendation_2003_361_annex, Profile) :-
    estimate_profile(4999, 500000000, 500000000, Profile).
fixture(staff_at_small_ceiling_is_at_least_medium, at_least_medium, recommendation_2003_361_annex, Profile) :-
    estimate_profile(5000, 500000000, 500000000, Profile).
fixture(majority_of_voting_rights_links, relationship_type, recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, false)]).
fixture(holding_at_partner_threshold, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 2500), attribute(investor_category, not_a_listed_investor)], Profile).
fixture(holding_one_point_below_partner_threshold, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 2499), attribute(investor_category, not_a_listed_investor)], Profile).
fixture(business_angels_one_cent_below_limit, relationship_type, gber_annex_i, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 3000), attribute(investor_category, business_angel), attribute(business_angels_total_investment_cents, 124999999)], Profile).
fixture(business_angels_at_limit, relationship_type, gber_annex_i, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 3000), attribute(investor_category, business_angel), attribute(business_angels_total_investment_cents, 125000000)], Profile).
fixture(local_authority_within_limits, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 3000), attribute(investor_category, autonomous_local_authority), attribute(local_authority_annual_budget_cents, 999999999), attribute(local_authority_inhabitants, 4999)], Profile).
fixture(local_authority_inhabitants_at_limit, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 3000), attribute(investor_category, autonomous_local_authority), attribute(local_authority_annual_budget_cents, 999999999), attribute(local_authority_inhabitants, 5000)], Profile).
fixture(local_authority_budget_at_limit, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(false, [attribute(holding_basis_points, 3000), attribute(investor_category, autonomous_local_authority), attribute(local_authority_annual_budget_cents, 1000000000), attribute(local_authority_inhabitants, 4999)], Profile).
fixture(presumed_investor_not_involved_in_management, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(true, [attribute(holding_basis_points, 3000), attribute(investor_category, institutional_investor), attribute(investor_involved_in_management, false)], Profile).
fixture(investor_involved_in_management_links, relationship_type, recommendation_2003_361_annex, Profile) :-
    relation_profile(true, [attribute(holding_basis_points, 3000), attribute(investor_category, institutional_investor), attribute(investor_involved_in_management, true)], Profile).
fixture(natural_persons_in_same_market, relationship_type, recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, true), attribute(same_or_adjacent_market, true)]).
fixture(natural_persons_in_other_market, relationship_type, recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, true), attribute(same_or_adjacent_market, false), attribute(holding_basis_points, 1000)]).
fixture(dominant_influence_unsure, relationship_type, gber_annex_i, Profile) :-
    relation_profile(unsure, [attribute(holding_basis_points, 3000), attribute(investor_category, not_a_listed_investor)], Profile).
fixture(unknown_text, size_class, directive_unknown, [attribute(is_enterprise, true)]).

sme_definition_subject(Subject) :-
    fixture(Subject, _, _, _).

sme_definition_profile_for(Subject, query(Query, Text, Profile)) :-
    fixture(Subject, Query, Text, Profile).

sme_definition_assess(Subject, Verdict) :-
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, Verdict).
