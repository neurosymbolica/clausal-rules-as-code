% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_queries, [data_act_connected_product_data_sharing_profile_keys/1, data_act_connected_product_data_sharing_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [data_act_connected_product_data_sharing_status/2]).

data_act_connected_product_data_sharing_profile_keys([connected_product_or_related_service, small_enterprise_exemption_applies, placed_on_market_after_12_september_2026, data_accessible_by_default_as_required, directly_accessible_where_relevant_and_feasible, pre_contract_contract_kind, required_information_provided_before_contract, requester_is_user, request_by_or_on_behalf_of_user, addressee_is_data_holder, requested_data_readily_available, data_directly_accessible_by_user, security_restriction_agreed_applies, testing_data_not_yet_on_market, third_party_use_contractually_permitted, third_party_is_designated_gatekeeper, other_persons_personal_data_requested, gdpr_conditions_for_making_available_met, requested_data_identified_as_trade_secrets, trade_secret_disclosure_strictly_necessary, trade_secret_measures_agreed_and_kept, exceptional_trade_secret_refusal_invoked]).

data_act_connected_product_data_sharing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    data_act_connected_product_data_sharing_input_problems(Profile, Problems),
    hypothesis_status(Problems, Profile, OverriddenKey, NewValue, NewStatus).

hypothesis_status([wrong_type(profile)], _, _, _, input_problems([wrong_type(profile)])).
hypothesis_status(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    without_key(Profile, OverriddenKey, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis),
    data_act_connected_product_data_sharing_status(Hypothesis, NewStatus).

without_key([], _, []).
without_key([attribute(ElementKey, _OldValue)|Elements], Key, Remaining) :-
    ElementKey == Key,
    without_key(Elements, Key, Remaining).
without_key([attribute(ElementKey, Value)|Elements], Key, [attribute(ElementKey, Value)|Remaining]) :-
    ElementKey \== Key,
    without_key(Elements, Key, Remaining).

clean_access_profile([attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false), attribute(requester_is_user, true), attribute(addressee_is_data_holder, true), attribute(requested_data_readily_available, true), attribute(data_directly_accessible_by_user, false), attribute(security_restriction_agreed_applies, false), attribute(other_persons_personal_data_requested, false), attribute(requested_data_identified_as_trade_secrets, false)]).

test(what_if_direct_access_flips_to_ineligible) :-
    clean_access_profile(Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, data_directly_accessible_by_user, true, Status), Statuses),
    Statuses == [ineligible].
test(what_if_same_value_stays_eligible) :-
    clean_access_profile(Profile),
    data_act_connected_product_data_sharing_what_if(Profile, data_directly_accessible_by_user, false, eligible).
test(what_if_on_a_non_list_reports_the_profile) :-
    findall(Status, data_act_connected_product_data_sharing_what_if(not_an_attribute_list, requester_is_user, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(profile_keys_are_the_twenty_two) :-
    data_act_connected_product_data_sharing_profile_keys(Keys),
    length(Keys, 22).

test(what_if_same_value_is_not_ineligible, fail) :-
    clean_access_profile(Profile),
    data_act_connected_product_data_sharing_what_if(Profile, data_directly_accessible_by_user, false, ineligible).
