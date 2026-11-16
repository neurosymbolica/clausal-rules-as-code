% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_queries, [nis2_jurisdiction_registration_profile_keys/1, nis2_jurisdiction_registration_what_if/4, nis2_jurisdiction_registration_status_by_category/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_jurisdiction_registration_profile_keys(ProfileKeys),
    ProfileKeys == [entity_category, established_in_union, offers_services_in_union, representative_designated_in_union, decisions_predominantly_taken_in_one_union_member_state, cybersecurity_operations_carried_out_in_one_union_member_state, sector_and_subsector_applicable, member_states_list_applicable].
test(input_problems_is_reexported) :-
    nis2_jurisdiction_registration_input_problems([attribute(zzz, true)], [unknown_key(zzz)]).
test(what_if_changes_the_category) :-
    findall(Status, nis2_jurisdiction_registration_what_if([attribute(entity_category, general_entity)], entity_category, main_establishment_provider, Status), Statuses),
    Statuses == [indeterminate([established_in_union])].
test(what_if_leaves_the_original_unchanged) :-
    nis2_jurisdiction_registration_status([attribute(entity_category, general_entity)], eligible).
test(what_if_sets_a_missing_key) :-
    findall(Status, nis2_jurisdiction_registration_what_if([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false)], offers_services_in_union, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_flips_offers_services) :-
    findall(Status, nis2_jurisdiction_registration_what_if([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, false)], offers_services_in_union, true, Status), Statuses),
    Statuses == [indeterminate([representative_designated_in_union])].
test(what_if_replaces_every_duplicate) :-
    findall(Status, nis2_jurisdiction_registration_what_if([attribute(entity_category, general_entity), attribute(entity_category, public_administration_entity)], entity_category, general_entity, Status), Statuses),
    Statuses == [eligible].
test(what_if_into_a_wrong_type_gives_input_problems) :-
    findall(Status, nis2_jurisdiction_registration_what_if([attribute(entity_category, general_entity)], entity_category, bogus, Status), Statuses),
    Statuses == [input_problems([wrong_type(entity_category)])].
test(status_by_category_enumerates_all_four) :-
    findall(Pairs, nis2_jurisdiction_registration_status_by_category([], Pairs), Answers),
    Answers == [[general_entity - eligible, public_electronic_communications_provider - eligible, main_establishment_provider - indeterminate([established_in_union]), public_administration_entity - eligible]].
test(status_by_category_for_a_non_union_provider_profile) :-
    findall(Pairs, nis2_jurisdiction_registration_status_by_category([attribute(established_in_union, false), attribute(offers_services_in_union, false)], Pairs), Answers),
    Answers == [[general_entity - eligible, public_electronic_communications_provider - eligible, main_establishment_provider - ineligible, public_administration_entity - eligible]].

cp_test_names([profile_keys_are_the_contract_keys, input_problems_is_reexported, what_if_changes_the_category, what_if_leaves_the_original_unchanged, what_if_sets_a_missing_key, what_if_flips_offers_services, what_if_replaces_every_duplicate, what_if_into_a_wrong_type_gives_input_problems, status_by_category_enumerates_all_four, status_by_category_for_a_non_union_provider_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
