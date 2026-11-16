% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_queries, [eprivacy_art_5_3_terminal_equipment_profile_keys/1, eprivacy_art_5_3_terminal_equipment_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2, eprivacy_art_5_3_terminal_equipment_contract_keys/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [eprivacy_art_5_3_terminal_equipment_status/2]).

eprivacy_art_5_3_terminal_equipment_profile_keys(Keys) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(Keys).

eprivacy_art_5_3_terminal_equipment_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    proper_list_t(Profile, IsProperList),
    hypothesis(IsProperList, Profile, OverriddenKey, NewValue, Hypothesis),
    eprivacy_art_5_3_terminal_equipment_status(Hypothesis, NewStatus).

hypothesis(false, Profile, _, _, Profile).
hypothesis(true, Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, KeptElements),
    append(KeptElements, [attribute(OverriddenKey, NewValue)], Hypothesis).

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Rest],
    proper_list_t(Rest, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

without_key([], _, []).
without_key([Element|Elements], Key, Kept) :-
    element_key_match_t(Element, Key, Match),
    keep_element(Match, Element, Elements, Key, Kept).

keep_element(true, _, Elements, Key, Kept) :-
    without_key(Elements, Key, Kept).
keep_element(false, Element, Elements, Key, [Element|Kept]) :-
    without_key(Elements, Key, Kept).

element_key_match_t(Element, _, false) :-
    var(Element).
element_key_match_t(Element, Key, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
element_key_match_t(Element, Key, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
element_key_match_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

test(profile_keys_are_the_six_in_order) :-
    eprivacy_art_5_3_terminal_equipment_profile_keys(Keys),
    Keys == [storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided].
test(what_if_transmission_true_permits) :-
    findall(Status, eprivacy_art_5_3_terminal_equipment_what_if([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, false)], storage_or_access_solely_for_transmission, true, Status), Statuses),
    Statuses == [permitted].
test(what_if_transmission_false_is_not_permitted) :-
    eprivacy_art_5_3_terminal_equipment_what_if([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, false)], storage_or_access_solely_for_transmission, false, not_permitted).
test(what_if_scope_false_is_not_applicable) :-
    eprivacy_art_5_3_terminal_equipment_what_if([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], storage_or_access_in_terminal_equipment, false, not_applicable).
test(what_if_adds_an_absent_key) :-
    eprivacy_art_5_3_terminal_equipment_what_if([attribute(storage_or_access_in_terminal_equipment, true)], storage_or_access_solely_for_transmission, true, permitted).
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    eprivacy_art_5_3_terminal_equipment_what_if(not_a_list, storage_or_access_in_terminal_equipment, true, input_problems([wrong_type(profile)])).

test(what_if_scope_false_is_not_permitted, fail) :-
    eprivacy_art_5_3_terminal_equipment_what_if([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], storage_or_access_in_terminal_equipment, false, permitted).
