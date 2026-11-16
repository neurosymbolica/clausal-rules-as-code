% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_queries, [sme_definition_profile_keys/1, sme_definition_what_if/4]).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [sme_definition_status/2, sme_definition_checklist/2]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    sme_definition_profile_keys(ProfileKeys),
    ProfileKeys == [is_enterprise, public_bodies_control_25_percent_or_more, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held, majority_of_voting_rights, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, majority_of_voting_rights_by_shareholder_agreement, relationship_only_through_natural_persons, same_or_adjacent_market, holding_basis_points, investor_category, investor_involved_in_management, business_angels_total_investment_cents, local_authority_annual_budget_cents, local_authority_inhabitants].
test(status_of_a_request) :-
    sme_definition_profile_for(holding_at_partner_threshold, Request),
    findall(Status, sme_definition_status(Request, Status), Statuses),
    Statuses == [partner_enterprise].
test(checklist_carries_a_cite_per_item) :-
    sme_definition_profile_for(entity_not_an_enterprise, Request),
    sme_definition_checklist(Request, Checklist),
    Checklist == [item(determination, not_an_enterprise, [cite(eu_rec_2003_361_annex_art_1_t1)]), item(eu_rec_2003_361_annex_art_1_t1, met, cite(eu_rec_2003_361_annex_art_1_t1))].
test(a_non_final_checklist_has_only_the_determination) :-
    sme_definition_profile_for(linked_list_not_given, Request),
    sme_definition_checklist(Request, Checklist),
    Checklist == [item(determination, indeterminate([linked_enterprises]), [])].
test(what_if_one_point_below_the_holding_threshold) :-
    sme_definition_profile_for(holding_at_partner_threshold, Request),
    sme_definition_what_if(Request, holding_basis_points, 2499, Status),
    Status == neither_partner_nor_linked.
test(what_if_public_bodies_take_control) :-
    sme_definition_profile_for(public_body_control_not_reached, Request),
    sme_definition_what_if(Request, public_bodies_control_25_percent_or_more, true, Status),
    Status == not_sme_public_control.
test(what_if_staff_reaches_the_medium_ceiling) :-
    sme_definition_profile_for(sme_staff_just_below_medium_ceiling, Request),
    sme_definition_what_if(Request, own_staff_annual_work_units_hundredths, 25000, Status),
    Status == not_sme.
test(what_if_the_dominant_influence_is_decided) :-
    sme_definition_profile_for(dominant_influence_unsure, Request),
    sme_definition_what_if(Request, dominant_influence_by_contract_or_articles, true, Linked),
    Linked == linked_enterprise,
    sme_definition_what_if(Request, dominant_influence_by_contract_or_articles, false, Partner),
    Partner == partner_enterprise.
test(what_if_replaces_a_duplicated_key) :-
    sme_definition_what_if(query(size_class, recommendation_2003_361_annex, [attribute(is_enterprise, true), attribute(is_enterprise, unsure)]), is_enterprise, false, Status),
    Status == not_an_enterprise.
test(the_reexported_input_check_names_an_unknown_key) :-
    sme_definition_input_problems([attribute(colour, red)], [unknown_key(colour)]).

test(what_if_one_point_below_is_not_partner, fail) :-
    sme_definition_profile_for(holding_at_partner_threshold, Request),
    sme_definition_what_if(Request, holding_basis_points, 2499, partner_enterprise).

cp_test_names([profile_keys_are_the_contract_keys, status_of_a_request, checklist_carries_a_cite_per_item, a_non_final_checklist_has_only_the_determination, what_if_one_point_below_the_holding_threshold, what_if_public_bodies_take_control, what_if_staff_reaches_the_medium_ceiling, what_if_the_dominant_influence_is_decided, what_if_replaces_a_duplicated_key, the_reexported_input_check_names_an_unknown_key]).
cp_test_fail_names([what_if_one_point_below_is_not_partner]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
