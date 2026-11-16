% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [sme_definition_status/2, sme_definition_status_values/1]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_profile_for/2]).

status_of(Subject, Status) :-
    sme_definition_profile_for(Subject, Request),
    sme_definition_status(Request, Status).

test(the_denied_atoms_are_real_verdict_atoms) :-
    sme_definition_status_values(StatusValues),
    member(micro_enterprise, StatusValues),
    member(small_enterprise, StatusValues),
    member(medium_sized_enterprise, StatusValues),
    member(not_an_enterprise, StatusValues),
    member(not_sme_public_control, StatusValues),
    member(sme, StatusValues),
    member(at_least_medium, StatusValues),
    member(below_medium, StatusValues),
    member(linked_enterprise, StatusValues),
    member(partner_enterprise, StatusValues),
    member(neither_partner_nor_linked, StatusValues).
test(micro_staff_route_positive) :-
    status_of(micro_staff_just_below_ceiling, micro_enterprise).
test(micro_turnover_route_positive) :-
    status_of(micro_turnover_at_ceiling, micro_enterprise).
test(micro_balance_sheet_route_positive) :-
    status_of(micro_balance_sheet_at_ceiling, micro_enterprise).
test(small_staff_route_positive) :-
    status_of(small_staff_just_below_ceiling, small_enterprise).
test(small_turnover_route_positive) :-
    status_of(small_turnover_at_ceiling, small_enterprise).
test(small_balance_sheet_route_positive) :-
    status_of(small_balance_sheet_at_ceiling, small_enterprise).
test(medium_staff_route_positive) :-
    status_of(medium_staff_just_below_ceiling, medium_sized_enterprise).
test(medium_turnover_route_positive) :-
    status_of(medium_turnover_at_ceiling, medium_sized_enterprise).
test(medium_balance_sheet_route_positive) :-
    status_of(medium_balance_sheet_at_ceiling, medium_sized_enterprise).
test(partner_aggregation_route_positive) :-
    status_of(partner_share_lifts_staff_to_ceiling, small_enterprise).
test(linked_aggregation_route_positive) :-
    status_of(linked_staff_lifts_to_ceiling, small_enterprise).
test(not_an_enterprise_route_positive) :-
    status_of(entity_not_an_enterprise, not_an_enterprise).
test(public_control_route_positive) :-
    status_of(public_body_control_reached, not_sme_public_control).
test(two_period_route_positive) :-
    status_of(two_periods_held_micro_kept, micro_enterprise).
test(sme_route_positive) :-
    status_of(sme_staff_just_below_medium_ceiling, sme).
test(at_least_medium_route_positive) :-
    status_of(staff_at_small_ceiling_is_at_least_medium, at_least_medium).
test(below_medium_route_positive) :-
    status_of(staff_just_below_small_ceiling_is_below_medium, below_medium).
test(linked_route_positive) :-
    status_of(investor_involved_in_management_links, linked_enterprise).
test(partner_route_positive) :-
    status_of(holding_at_partner_threshold, partner_enterprise).
test(business_angel_exception_positive) :-
    status_of(business_angels_one_cent_below_limit, neither_partner_nor_linked).
test(local_authority_exception_positive) :-
    status_of(local_authority_within_limits, neither_partner_nor_linked).
test(natural_persons_route_positive) :-
    status_of(natural_persons_in_same_market, linked_enterprise).
test(referral_route_positive) :-
    status_of(dominant_influence_unsure, needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_651_2014_annex_i_art_3_3_c)), _)).
test(missing_key_route_positive) :-
    status_of(linked_list_not_given, indeterminate([linked_enterprises])).
test(input_problem_route_positive) :-
    status_of(unknown_text, input_problems([wrong_type(text)])).

test(micro_staff_route_near_miss, fail) :-
    status_of(micro_staff_at_ceiling, micro_enterprise).
test(micro_turnover_route_near_miss, fail) :-
    status_of(micro_turnover_one_cent_above_ceiling, micro_enterprise).
test(micro_balance_sheet_route_near_miss, fail) :-
    status_of(micro_balance_sheet_one_cent_above_ceiling, micro_enterprise).
test(small_staff_route_near_miss, fail) :-
    status_of(small_staff_at_ceiling, small_enterprise).
test(small_turnover_route_near_miss, fail) :-
    status_of(small_turnover_one_cent_above_ceiling, small_enterprise).
test(small_balance_sheet_route_near_miss, fail) :-
    status_of(small_balance_sheet_one_cent_above_ceiling, small_enterprise).
test(medium_staff_route_near_miss, fail) :-
    status_of(medium_staff_at_ceiling, medium_sized_enterprise).
test(medium_turnover_route_near_miss, fail) :-
    status_of(medium_turnover_one_cent_above_ceiling, medium_sized_enterprise).
test(medium_balance_sheet_route_near_miss, fail) :-
    status_of(medium_balance_sheet_one_cent_above_ceiling, medium_sized_enterprise).
test(partner_aggregation_route_near_miss, fail) :-
    status_of(partner_share_one_point_below, small_enterprise).
test(linked_aggregation_route_near_miss, fail) :-
    status_of(linked_staff_one_hundredth_below, small_enterprise).
test(not_an_enterprise_route_near_miss, fail) :-
    status_of(public_body_control_reached, not_an_enterprise).
test(public_control_route_near_miss, fail) :-
    status_of(public_body_control_not_reached, not_sme_public_control).
test(two_period_route_near_miss, fail) :-
    status_of(two_periods_held_small_kept, micro_enterprise).
test(sme_route_near_miss, fail) :-
    status_of(sme_staff_at_medium_ceiling, sme).
test(sme_public_control_near_miss, fail) :-
    status_of(sme_under_public_control, sme).
test(at_least_medium_route_near_miss, fail) :-
    status_of(staff_just_below_small_ceiling_is_below_medium, at_least_medium).
test(below_medium_route_near_miss, fail) :-
    status_of(staff_at_small_ceiling_is_at_least_medium, below_medium).
test(linked_route_near_miss, fail) :-
    status_of(presumed_investor_not_involved_in_management, linked_enterprise).
test(partner_route_near_miss, fail) :-
    status_of(holding_one_point_below_partner_threshold, partner_enterprise).
test(business_angel_exception_near_miss, fail) :-
    status_of(business_angels_at_limit, neither_partner_nor_linked).
test(local_authority_inhabitants_near_miss, fail) :-
    status_of(local_authority_inhabitants_at_limit, neither_partner_nor_linked).
test(local_authority_budget_near_miss, fail) :-
    status_of(local_authority_budget_at_limit, neither_partner_nor_linked).
test(natural_persons_route_near_miss, fail) :-
    status_of(natural_persons_in_other_market, linked_enterprise).
test(referral_route_near_miss, fail) :-
    status_of(holding_at_partner_threshold, needs_legal_review(_, _)).
test(missing_key_route_near_miss, fail) :-
    status_of(linked_staff_one_hundredth_below, indeterminate(_)).
test(input_problem_route_near_miss, fail) :-
    status_of(entity_not_an_enterprise, input_problems(_)).

cp_test_names([the_denied_atoms_are_real_verdict_atoms, micro_staff_route_positive, micro_turnover_route_positive, micro_balance_sheet_route_positive, small_staff_route_positive, small_turnover_route_positive, small_balance_sheet_route_positive, medium_staff_route_positive, medium_turnover_route_positive, medium_balance_sheet_route_positive, partner_aggregation_route_positive, linked_aggregation_route_positive, not_an_enterprise_route_positive, public_control_route_positive, two_period_route_positive, sme_route_positive, at_least_medium_route_positive, below_medium_route_positive, linked_route_positive, partner_route_positive, business_angel_exception_positive, local_authority_exception_positive, natural_persons_route_positive, referral_route_positive, missing_key_route_positive, input_problem_route_positive]).
cp_test_fail_names([micro_staff_route_near_miss, micro_turnover_route_near_miss, micro_balance_sheet_route_near_miss, small_staff_route_near_miss, small_turnover_route_near_miss, small_balance_sheet_route_near_miss, medium_staff_route_near_miss, medium_turnover_route_near_miss, medium_balance_sheet_route_near_miss, partner_aggregation_route_near_miss, linked_aggregation_route_near_miss, not_an_enterprise_route_near_miss, public_control_route_near_miss, two_period_route_near_miss, sme_route_near_miss, sme_public_control_near_miss, at_least_medium_route_near_miss, below_medium_route_near_miss, linked_route_near_miss, partner_route_near_miss, business_angel_exception_near_miss, local_authority_inhabitants_near_miss, local_authority_budget_near_miss, natural_persons_route_near_miss, referral_route_near_miss, missing_key_route_near_miss, input_problem_route_near_miss]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
