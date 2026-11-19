% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_queries, [origin_exclusions_profile_keys/1, origin_exclusions_what_if/4, origin_exclusions_eligibility/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusions_status/2]).

origin_exclusions_profile_keys([military_activities, non_preferential_origin, goods_kind, continental_shelf_or_eez_of]).

origin_exclusions_eligibility(Profile, Eligibility) :-
    origin_exclusions_status(Profile, Status),
    status_eligibility(Status, Eligibility).

status_eligibility(excluded_military_activities, eligible).
status_eligibility(excluded_origin_annex_iii_point_1, eligible).
status_eligibility(excluded_electricity_continental_shelf_or_eez, eligible).
status_eligibility(excluded_hydrogen_continental_shelf_or_eez, eligible).
status_eligibility(not_third_country_origin, eligible).
status_eligibility(no_origin_exclusion, ineligible).
status_eligibility(indeterminate(_), undetermined).
status_eligibility(input_problems(_), undetermined).

origin_exclusions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attributes_override(Profile, OverriddenKey, NewValue, Hypothesis),
    origin_exclusions_status(Hypothesis, NewStatus).

attributes_override(Entries, _, _, Entries) :-
    var(Entries).
attributes_override(Entries, ProfileKey, Value, [attribute(ProfileKey, Value)]) :-
    nonvar(Entries),
    Entries == [].
attributes_override(Entries, ProfileKey, Value, Hypothesis) :-
    nonvar(Entries),
    Entries = [Entry|RemainingEntries],
    entry_override(Entry, ProfileKey, Value, RemainingEntries, Hypothesis).
attributes_override(Entries, _, _, Entries) :-
    nonvar(Entries),
    Entries \== [],
    Entries \= [_|_].

entry_override(Entry, ProfileKey, Value, RemainingEntries, [Entry|Hypothesis]) :-
    var(Entry),
    attributes_override(RemainingEntries, ProfileKey, Value, Hypothesis).
entry_override(Entry, ProfileKey, Value, RemainingEntries, Hypothesis) :-
    nonvar(Entry),
    Entry = attribute(EntryKey, _),
    EntryKey == ProfileKey,
    attributes_override(RemainingEntries, ProfileKey, Value, Hypothesis).
entry_override(Entry, ProfileKey, Value, RemainingEntries, [Entry|Hypothesis]) :-
    nonvar(Entry),
    Entry = attribute(EntryKey, _),
    EntryKey \== ProfileKey,
    attributes_override(RemainingEntries, ProfileKey, Value, Hypothesis).
entry_override(Entry, ProfileKey, Value, RemainingEntries, [Entry|Hypothesis]) :-
    nonvar(Entry),
    Entry \= attribute(_, _),
    attributes_override(RemainingEntries, ProfileKey, Value, Hypothesis).

test(eligibility_of_military_goods) :-
    findall(Eligibility, origin_exclusions_eligibility([attribute(military_activities, yes)], Eligibility), Eligibilities),
    Eligibilities == [eligible].
test(eligibility_with_no_exclusion) :-
    findall(Eligibility, origin_exclusions_eligibility([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, other_annex_i_goods)], Eligibility), Eligibilities),
    Eligibilities == [ineligible].
test(eligibility_of_an_empty_profile) :-
    findall(Eligibility, origin_exclusions_eligibility([], Eligibility), Eligibilities),
    Eligibilities == [undetermined].
test(eligibility_of_a_profile_with_input_problems) :-
    findall(Eligibility, origin_exclusions_eligibility([attribute(colour, red)], Eligibility), Eligibilities),
    Eligibilities == [undetermined].
test(what_if_military_turns_yes) :-
    findall(Status, origin_exclusions_what_if([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, other_annex_i_goods)], military_activities, yes, Status), Statuses),
    Statuses == [excluded_military_activities].
test(what_if_adds_an_absent_key) :-
    findall(Status, origin_exclusions_what_if([attribute(military_activities, no)], non_preferential_origin, norway, Status), Statuses),
    Statuses == [excluded_origin_annex_iii_point_1].
test(what_if_replaces_a_duplicated_key) :-
    findall(Status, origin_exclusions_what_if([attribute(military_activities, no), attribute(military_activities, no)], military_activities, yes, Status), Statuses),
    Statuses == [excluded_military_activities].
test(what_if_keeps_a_non_list_profile) :-
    findall(Status, origin_exclusions_what_if(colour, military_activities, yes, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].

test(eligibility_with_no_exclusion_is_not_eligible, fail) :-
    origin_exclusions_eligibility([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, other_annex_i_goods)], eligible).
