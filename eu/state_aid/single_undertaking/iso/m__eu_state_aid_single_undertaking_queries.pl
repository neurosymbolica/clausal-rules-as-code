% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_queries, [single_undertaking_profile_keys/1, single_undertaking_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [single_undertaking_status/2]).

single_undertaking_profile_keys([holder_is_an_enterprise, held_is_an_enterprise, voting_rights_held, voting_rights_total, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, holder_is_shareholder_or_member, controls_majority_of_voting_rights_alone_by_agreement, first_enterprise, second_enterprise, relationships, relationships_complete]).

single_undertaking_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    single_undertaking_status(Hypothesis, NewStatus).

overridden_profile(Profile, _, _, Profile) :-
    var(Profile).
overridden_profile(Profile, ProfileKey, Value, [attribute(ProfileKey, Value)]) :-
    Profile == [].
overridden_profile(Profile, ProfileKey, Value, Overridden) :-
    nonvar(Profile),
    Profile = [Element|Elements],
    overridden_element(Element, ProfileKey, Value, Elements, Overridden).
overridden_profile(Profile, _, _, Profile) :-
    nonvar(Profile),
    Profile \== [],
    Profile \= [_|_].

overridden_element(Element, ProfileKey, Value, Elements, [Element|Overridden]) :-
    var(Element),
    overridden_profile(Elements, ProfileKey, Value, Overridden).
overridden_element(Element, ProfileKey, Value, Elements, Overridden) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == ProfileKey,
    overridden_profile(Elements, ProfileKey, Value, Overridden).
overridden_element(Element, ProfileKey, Value, Elements, [Element|Overridden]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== ProfileKey,
    overridden_profile(Elements, ProfileKey, Value, Overridden).
overridden_element(Element, ProfileKey, Value, Elements, [Element|Overridden]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    overridden_profile(Elements, ProfileKey, Value, Overridden).

test(the_schema_has_twelve_keys) :-
    single_undertaking_profile_keys(ProfileKeys),
    length(ProfileKeys, 12).
test(an_override_replaces_the_entry_without_a_duplicate) :-
    overridden_profile([attribute(relationships_complete, false), attribute(first_enterprise, alpha)], relationships_complete, true, Overridden),
    Overridden == [attribute(first_enterprise, alpha), attribute(relationships_complete, true)].
test(completing_the_list_settles_the_answer) :-
    single_undertaking_what_if([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, false)], relationships_complete, true, NewStatus),
    NewStatus == not_single_undertaking.
test(an_incomplete_list_stays_indeterminate_without_the_override) :-
    single_undertaking_what_if([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)])], relationships_complete, false, NewStatus),
    NewStatus == indeterminate([relationships_complete]).
test(the_what_if_has_one_answer) :-
    findall(NewStatus, single_undertaking_what_if([attribute(first_enterprise, alpha)], second_enterprise, alpha, NewStatus), Answers),
    Answers == [single_undertaking].
