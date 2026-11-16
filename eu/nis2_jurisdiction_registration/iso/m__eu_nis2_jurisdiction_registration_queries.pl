% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_queries, [nis2_jurisdiction_registration_profile_keys/1, nis2_jurisdiction_registration_what_if/4, nis2_jurisdiction_registration_status_by_category/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2]).

nis2_jurisdiction_registration_profile_keys([entity_category, established_in_union, offers_services_in_union, representative_designated_in_union, decisions_predominantly_taken_in_one_union_member_state, cybersecurity_operations_carried_out_in_one_union_member_state, sector_and_subsector_applicable, member_states_list_applicable]).

nis2_jurisdiction_registration_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_jurisdiction_registration_status(Hypothesis, NewStatus).

nis2_jurisdiction_registration_status_by_category(Profile, Pairs) :-
    findall(Category - Status, (member(Category, [general_entity, public_electronic_communications_provider, main_establishment_provider, public_administration_entity]), nis2_jurisdiction_registration_what_if(Profile, entity_category, Category, Status)), Pairs).

override_attribute(Profile, Key, Value, [attribute(Key, Value)|Kept]) :-
    drop_attribute(Profile, Key, Kept).

drop_attribute([], _, []).
drop_attribute([attribute(OtherKey, OtherValue)|Rest], Key, [attribute(OtherKey, OtherValue)|Kept]) :-
    dif(OtherKey, Key),
    drop_attribute(Rest, Key, Kept).
drop_attribute([attribute(Key, _)|Rest], Key, Kept) :-
    drop_attribute(Rest, Key, Kept).
