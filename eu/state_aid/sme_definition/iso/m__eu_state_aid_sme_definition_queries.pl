% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_queries, [sme_definition_profile_keys/1, sme_definition_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [sme_definition_status/2]).

sme_definition_profile_keys([is_enterprise, public_bodies_control_25_percent_or_more, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held, majority_of_voting_rights, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, majority_of_voting_rights_by_shareholder_agreement, relationship_only_through_natural_persons, same_or_adjacent_market, holding_basis_points, investor_category, investor_involved_in_management, business_angels_total_investment_cents, local_authority_annual_budget_cents, local_authority_inhabitants]).

sme_definition_what_if(query(Query, Text, Profile), OverriddenKey, NewValue, NewStatus) :-
    profile_with_key(Profile, OverriddenKey, NewValue, Hypothesis),
    sme_definition_status(query(Query, Text, Hypothesis), NewStatus).

profile_with_key(Profile, Key, Value, Hypothesis) :-
    profile_without_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

profile_without_key(Profile, _, []) :-
    Profile == [].
profile_without_key(Profile, Key, Kept) :-
    nonvar(Profile),
    Profile = [Element|Elements],
    element_kept(Element, Key, Kept, LaterKept),
    profile_without_key(Elements, Key, LaterKept).

element_kept(Element, Key, Kept, Kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
element_kept(Element, Key, [Element|Kept], Kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
element_kept(Element, _, [Element|Kept], Kept) :-
    nonvar(Element),
    Element \= attribute(_, _).
element_kept(Element, _, [Element|Kept], Kept) :-
    var(Element).

micro_figures([attribute(own_staff_annual_work_units_hundredths, 999), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]).

test(the_profile_keys_are_twenty_two) :-
    sme_definition_profile_keys(Keys),
    length(Keys, 22).
test(the_unchanged_staff_keeps_micro) :-
    micro_figures(Profile),
    sme_definition_what_if(query(period_size_class, recommendation_2003_361_annex, Profile), own_staff_annual_work_units_hundredths, 999, Status),
    Status == micro_enterprise.
test(one_more_hundredth_of_staff_makes_it_small) :-
    micro_figures(Profile),
    sme_definition_what_if(query(period_size_class, recommendation_2003_361_annex, Profile), own_staff_annual_work_units_hundredths, 1000, Status),
    Status == small_enterprise.
test(the_override_replaces_the_key_once) :-
    profile_with_key([attribute(is_enterprise, true), attribute(holding_basis_points, 10)], is_enterprise, false, Hypothesis),
    Hypothesis == [attribute(holding_basis_points, 10), attribute(is_enterprise, false)].
test(the_reexported_input_check_accepts_an_empty_profile) :-
    sme_definition_input_problems([], []).

test(one_more_hundredth_of_staff_is_not_micro, fail) :-
    micro_figures(Profile),
    sme_definition_what_if(query(period_size_class, recommendation_2003_361_annex, Profile), own_staff_annual_work_units_hundredths, 1000, micro_enterprise).
