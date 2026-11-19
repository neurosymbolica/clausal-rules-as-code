% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_profile_keys/1, gdpr_administrative_fine_maximum_what_if/4, gdpr_administrative_fine_maximum_cap_in_euro_cents/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, gdpr_administrative_fine_maximum_status/2]).

gdpr_administrative_fine_maximum_profile_keys([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros, infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent]).

gdpr_administrative_fine_maximum_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attributes_with_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_administrative_fine_maximum_status(Hypothesis, NewStatus).

attributes_with_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attributes_with_override([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    attributes_with_override(Elements, OverriddenKey, NewValue, Hypothesis).
attributes_with_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    attributes_with_override(Elements, OverriddenKey, NewValue, Hypothesis).

gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents) :-
    administrative_fine_maximum(Profile, fine_maximum(_, _, CapInEuroCents), _).

test(profile_keys_are_the_five_contract_keys) :-
    gdpr_administrative_fine_maximum_profile_keys(ProfileKeys),
    length(ProfileKeys, 5).
test(cap_of_a_lower_tier_undertaking_above_the_tie) :-
    gdpr_administrative_fine_maximum_cap_in_euro_cents([attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], CapInEuroCents),
    CapInEuroCents =:= 2000000000.
test(cap_one_euro_above_the_lower_tie) :-
    gdpr_administrative_fine_maximum_cap_in_euro_cents([attribute(infringed_provisions, [article_30]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)], CapInEuroCents),
    CapInEuroCents =:= 1000000002.
test(cap_answers_exactly_once) :-
    findall(CapInEuroCents, gdpr_administrative_fine_maximum_cap_in_euro_cents([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, false)], CapInEuroCents), Caps),
    length(Caps, 1).
test(separate_maxima_have_a_separate_status) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6, article_33]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, false)], Status),
    Status == separate_fine_maxima_determined.
test(what_if_settling_the_undertaking_gives_a_maximum) :-
    gdpr_administrative_fine_maximum_what_if([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)], infringer_is_undertaking, false, NewStatus),
    NewStatus == fine_maximum_determined.
test(what_if_unchanged_profile_still_refers) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)], Status),
    Status == referred_for_legal_review.
test(what_if_replaces_and_never_duplicates_a_key) :-
    findall(NewStatus, gdpr_administrative_fine_maximum_what_if([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, false)], infringer_is_undertaking, false, NewStatus), Statuses),
    Statuses == [fine_maximum_determined].

test(separate_maxima_have_no_single_cap, fail) :-
    gdpr_administrative_fine_maximum_cap_in_euro_cents([attribute(infringed_provisions, [article_6, article_33]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, false)], _).
