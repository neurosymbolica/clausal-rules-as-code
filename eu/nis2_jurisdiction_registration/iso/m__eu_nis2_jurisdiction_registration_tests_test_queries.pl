% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_queries, [nis2_jurisdiction_registration_profile_keys/1, nis2_jurisdiction_registration_what_if/4, entity_category/0, member_states_list_applicable/0, general_entity/0, main_establishment_provider/0, unsure/0]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_jurisdiction_registration_profile_keys(ProfileKeys),
    ProfileKeys == [entity_category, established_in_union, offers_services_in_union, representative_designated_in_union, decisions_predominantly_taken_in_one_union_member_state, cybersecurity_operations_carried_out_in_one_union_member_state, sector_and_subsector_applicable, member_states_list_applicable].
test(root_vocabulary_is_callable) :-
    entity_category,
    member_states_list_applicable,
    general_entity,
    main_establishment_provider,
    unsure.
test(reexported_input_check_accepts_a_fixture) :-
    nis2_jurisdiction_registration_profile_for(general_entity_settled, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, []).
test(reexported_input_check_rejects_a_fixture) :-
    nis2_jurisdiction_registration_profile_for(crisp_key_given_unsure, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(sector_and_subsector_applicable)]).
test(what_if_unchanged_value_keeps_the_status) :-
    nis2_jurisdiction_registration_profile_for(general_entity_settled, Profile),
    nis2_jurisdiction_registration_what_if(Profile, member_states_list_applicable, true, registration_position_settled).
test(what_if_dropping_the_representative_loses_a_single_state) :-
    nis2_jurisdiction_registration_profile_for(provider_outside_union_with_representative, Profile),
    nis2_jurisdiction_registration_what_if(Profile, representative_designated_in_union, false, no_single_member_state_jurisdiction).
test(what_if_unsure_decisions_opens_the_position) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    nis2_jurisdiction_registration_what_if(Profile, decisions_predominantly_taken_in_one_union_member_state, unsure, registration_position_open).
test(what_if_out_of_type_value_is_rejected) :-
    nis2_jurisdiction_registration_profile_for(general_entity_settled, Profile),
    nis2_jurisdiction_registration_what_if(Profile, sector_and_subsector_applicable, unsure, profile_rejected).
test(what_if_has_exactly_one_answer) :-
    nis2_jurisdiction_registration_profile_for(provider_outside_union_with_representative, Profile),
    findall(Status, nis2_jurisdiction_registration_what_if(Profile, representative_designated_in_union, false, Status), Statuses),
    length(Statuses, 1).

test(what_if_unsure_decisions_is_not_settled, fail) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    nis2_jurisdiction_registration_what_if(Profile, decisions_predominantly_taken_in_one_union_member_state, unsure, registration_position_settled).

cp_test_names([profile_keys_are_the_contract_keys, root_vocabulary_is_callable, reexported_input_check_accepts_a_fixture, reexported_input_check_rejects_a_fixture, what_if_unchanged_value_keeps_the_status, what_if_dropping_the_representative_loses_a_single_state, what_if_unsure_decisions_opens_the_position, what_if_out_of_type_value_is_rejected, what_if_has_exactly_one_answer]).
cp_test_fail_names([what_if_unsure_decisions_is_not_settled]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
