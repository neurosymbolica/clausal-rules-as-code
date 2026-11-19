% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_queries, [uk_subject_access_requests_profile_keys/1, uk_subject_access_requests_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_kernel, [uk_subject_access_requests_input_problems/2]).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [uk_subject_access_requests_status/2]).

uk_subject_access_requests_profile_keys([item_described_in_article_15_1, item_within_reasonable_and_proportionate_search, extension_notice_given, extension_notice_given_before_end_of_first_month, extension_notice_states_reasons, extension_necessary_for_complexity_or_number, request_made_under_article_15, controller_asked_for_further_information, further_information_reasonably_required]).

uk_subject_access_requests_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis),
    uk_subject_access_requests_status(Hypothesis, NewStatus).

profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    list_shape(Profile, Shape),
    override_by_shape(Shape, Profile, OverriddenKey, NewValue, Hypothesis).

override_by_shape(proper, Profile, OverriddenKey, NewValue, Hypothesis) :-
    override_elements(Profile, OverriddenKey, NewValue, Hypothesis).
override_by_shape(improper, Profile, _OverriddenKey, _NewValue, Profile).

list_shape(Term, improper) :-
    var(Term).
list_shape(Term, proper) :-
    Term == [].
list_shape(Term, Shape) :-
    nonvar(Term),
    Term = [_Element|Elements],
    list_shape(Elements, Shape).
list_shape(Term, improper) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

override_elements([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_elements([Element|Elements], OverriddenKey, NewValue, Hypothesis) :-
    element_match(Element, OverriddenKey, Match),
    keep_element(Match, Element, KeptElements, Hypothesis),
    override_elements(Elements, OverriddenKey, NewValue, KeptElements).

element_match(Element, _OverriddenKey, keep) :-
    var(Element).
element_match(Element, _OverriddenKey, keep) :-
    nonvar(Element),
    Element \= attribute(_, _).
element_match(Element, OverriddenKey, replace) :-
    nonvar(Element),
    Element = attribute(ElementKey, _ElementValue),
    ElementKey == OverriddenKey.
element_match(Element, OverriddenKey, keep) :-
    nonvar(Element),
    Element = attribute(ElementKey, _ElementValue),
    ElementKey \== OverriddenKey.

keep_element(keep, Element, KeptElements, [Element|KeptElements]).
keep_element(replace, _Element, KeptElements, KeptElements).

test(what_if_search_turns_true_gives_item_due) :-
    uk_subject_access_requests_what_if([attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, false)], item_within_reasonable_and_proportionate_search, true, Status),
    Status == item_due.
test(what_if_adds_an_absent_key) :-
    uk_subject_access_requests_what_if([attribute(item_within_reasonable_and_proportionate_search, true)], item_described_in_article_15_1, false, Status),
    Status == item_not_within_article_15_1.
test(what_if_one_solution) :-
    findall(Status, uk_subject_access_requests_what_if([attribute(item_described_in_article_15_1, true)], item_within_reasonable_and_proportionate_search, unsure, Status), Statuses),
    length(Statuses, 1).
test(what_if_on_a_non_list_reports_the_problem) :-
    uk_subject_access_requests_what_if(not_a_profile, item_described_in_article_15_1, true, Status),
    Status == input_problems([wrong_type(profile)]).
test(what_if_replaces_a_duplicated_key) :-
    uk_subject_access_requests_what_if([attribute(item_described_in_article_15_1, true), attribute(item_described_in_article_15_1, false), attribute(item_within_reasonable_and_proportionate_search, true)], item_described_in_article_15_1, true, Status),
    Status == item_due.
test(profile_keys_are_nine) :-
    uk_subject_access_requests_profile_keys(Keys),
    length(Keys, 9).
test(input_problems_re_exported) :-
    uk_subject_access_requests_input_problems([attribute(stray_key, true)], Problems),
    Problems == [unknown_key(stray_key)].

test(what_if_search_turns_true_is_not_beyond, fail) :-
    uk_subject_access_requests_what_if([attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, false)], item_within_reasonable_and_proportionate_search, true, item_beyond_reasonable_and_proportionate_search).
