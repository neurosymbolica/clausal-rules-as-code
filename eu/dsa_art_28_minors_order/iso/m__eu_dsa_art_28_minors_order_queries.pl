% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_queries, [dsa_art_28_minors_order_profile_keys/1, dsa_art_28_minors_order_what_if/4, platform_accessible_to_minors/0, advertisements_presented_to_recipient_on_interface/0, advertisements_based_on_profiling_of_recipient/0, aware_with_reasonable_certainty_recipient_is_minor/0, provider_qualifies_as_micro_or_small_enterprise/0, provider_within_12_months_after_losing_micro_or_small_status/0, designated_as_very_large_online_platform/0, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [dsa_art_28_minors_order_status/2]).

platform_accessible_to_minors.

advertisements_presented_to_recipient_on_interface.

advertisements_based_on_profiling_of_recipient.

aware_with_reasonable_certainty_recipient_is_minor.

provider_qualifies_as_micro_or_small_enterprise.

provider_within_12_months_after_losing_micro_or_small_status.

designated_as_very_large_online_platform.

measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors.

unsure.

absent.

not_attempted.

dsa_art_28_minors_order_profile_keys([platform_accessible_to_minors, advertisements_presented_to_recipient_on_interface, advertisements_based_on_profiling_of_recipient, aware_with_reasonable_certainty_recipient_is_minor, provider_qualifies_as_micro_or_small_enterprise, provider_within_12_months_after_losing_micro_or_small_status, designated_as_very_large_online_platform, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors]).

dsa_art_28_minors_order_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dsa_art_28_minors_order_input_problems(Profile, Problems),
    what_if_on(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_on([wrong_type(profile)], _, _, _, input_problems([wrong_type(profile)])).
what_if_on(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dsa_art_28_minors_order_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).
override_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).

test(the_schema_holds_the_eight_contract_keys) :-
    dsa_art_28_minors_order_profile_keys(ProfileKeys),
    length(ProfileKeys, 8).
test(the_root_atoms_are_served) :-
    platform_accessible_to_minors,
    designated_as_very_large_online_platform,
    unsure,
    absent,
    not_attempted.
test(adequate_measures_turn_a_breach_into_compliance) :-
    findall(NewStatus, dsa_art_28_minors_order_what_if([attribute(platform_accessible_to_minors, true), attribute(advertisements_presented_to_recipient_on_interface, false), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false), attribute(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, false)], measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, true, NewStatus), Statuses),
    Statuses == [dsa_art_28_minors_order_complied].
test(the_unchanged_profile_is_a_breach) :-
    findall(NewStatus, dsa_art_28_minors_order_what_if([attribute(platform_accessible_to_minors, true), attribute(advertisements_presented_to_recipient_on_interface, false), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false), attribute(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, false)], measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, false, NewStatus), Statuses),
    Statuses == [dsa_art_28_minors_order_breached].
test(an_override_outside_the_type_is_an_input_problem) :-
    findall(NewStatus, dsa_art_28_minors_order_what_if([], platform_accessible_to_minors, maybe, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(platform_accessible_to_minors)])].
test(a_term_that_is_not_a_profile_stays_an_input_problem) :-
    findall(NewStatus, dsa_art_28_minors_order_what_if(not_a_profile, platform_accessible_to_minors, true, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
