% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_profile_for/2]).

subject_status(Subject, Status) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_status(Profile, Status).

test(settled_general_entity_bound) :-
    subject_status(general_entity_settled, registration_position_settled).
test(open_without_member_states_key_bound) :-
    subject_status(general_entity_member_states_list_absent, registration_position_open).
test(no_single_state_without_representative_bound) :-
    subject_status(provider_outside_union_without_representative, no_single_member_state_jurisdiction).
test(representative_route_settled_bound) :-
    subject_status(provider_outside_union_with_representative, registration_position_settled).
test(unsure_decisions_route_open_bound) :-
    subject_status(provider_established_decisions_unsure_operations_false, registration_position_open).
test(rejected_profile_bound) :-
    subject_status(duplicate_and_wrong_type, profile_rejected).
test(basis_bound_state_of_main_establishment) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    jurisdiction_basis(Profile, state_of_main_establishment, _).
test(main_establishment_bound_most_employees) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_false_operations_false, Profile),
    main_establishment_rule(Profile, state_of_establishment_with_most_employees_in_the_union, [cite(eu_dir_2022_2555_art_26_2)]).
test(registry_bound_empty_for_public_administration) :-
    nis2_jurisdiction_registration_profile_for(public_administration_settled, Profile),
    registry_submission_items(Profile, []).
test(limits_bound_for_communications_provider) :-
    nis2_jurisdiction_registration_profile_for(communications_provider_settled, Profile),
    change_notification_limits(Profile, [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(key_order_does_not_matter) :-
    nis2_jurisdiction_registration_status([attribute(member_states_list_applicable, false), attribute(sector_and_subsector_applicable, false), attribute(entity_category, general_entity)], registration_position_settled).
test(empty_profile_is_well_formed) :-
    nis2_jurisdiction_registration_input_problems([], []).
test(empty_profile_asks_for_the_category) :-
    jurisdiction_basis([], indeterminate([entity_category]), []).
test(non_attribute_element_gives_wrong_type_profile_alone) :-
    nis2_jurisdiction_registration_profile_for(non_attribute_element, Profile),
    entity_list_submission_items(Profile, input_problems([wrong_type(profile)])).
test(not_a_list_gives_wrong_type_profile) :-
    nis2_jurisdiction_registration_profile_for(not_an_attribute_list, Profile),
    main_establishment_rule(Profile, input_problems([wrong_type(profile)]), []).
test(duplicate_is_never_also_wrong_type) :-
    nis2_jurisdiction_registration_profile_for(duplicate_and_wrong_type, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(entity_category), duplicate_key(established_in_union)]).
test(unknown_key_named_once_in_first_occurrence_order) :-
    nis2_jurisdiction_registration_profile_for(unknown_keys_repeated, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [unknown_key(head_office), unknown_key(employee_count)]).
test(crisp_key_given_unsure_is_wrong_type) :-
    nis2_jurisdiction_registration_profile_for(crisp_key_given_unsure, Profile),
    registry_submission_items(Profile, input_problems([wrong_type(sector_and_subsector_applicable)])).
test(judgement_key_accepts_unsure) :-
    nis2_jurisdiction_registration_input_problems([attribute(decisions_predominantly_taken_in_one_union_member_state, unsure)], []).
test(judgement_key_rejects_other_atoms) :-
    nis2_jurisdiction_registration_input_problems([attribute(cybersecurity_operations_carried_out_in_one_union_member_state, maybe)], [wrong_type(cybersecurity_operations_carried_out_in_one_union_member_state)]).
test(string_value_is_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, "true")], [wrong_type(established_in_union)]).
test(unread_key_is_still_checked) :-
    change_notification_limits([attribute(entity_category, general_entity), attribute(offers_services_in_union, unsure)], input_problems([wrong_type(offers_services_in_union)])).

test(settled_general_entity_is_not_open, fail) :-
    subject_status(general_entity_settled, registration_position_open).
test(open_without_member_states_key_is_not_settled, fail) :-
    subject_status(general_entity_member_states_list_absent, registration_position_settled).
test(no_single_state_without_representative_is_not_settled, fail) :-
    subject_status(provider_outside_union_without_representative, registration_position_settled).
test(unsure_decisions_route_is_not_settled, fail) :-
    subject_status(provider_established_decisions_unsure_operations_false, registration_position_settled).
test(rejected_profile_is_not_open, fail) :-
    subject_status(duplicate_and_wrong_type, registration_position_open).
test(basis_bound_wrong_atom_fails, fail) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    jurisdiction_basis(Profile, state_of_establishment, _).

cp_test_names([settled_general_entity_bound, open_without_member_states_key_bound, no_single_state_without_representative_bound, representative_route_settled_bound, unsure_decisions_route_open_bound, rejected_profile_bound, basis_bound_state_of_main_establishment, main_establishment_bound_most_employees, registry_bound_empty_for_public_administration, limits_bound_for_communications_provider, key_order_does_not_matter, empty_profile_is_well_formed, empty_profile_asks_for_the_category, non_attribute_element_gives_wrong_type_profile_alone, not_a_list_gives_wrong_type_profile, duplicate_is_never_also_wrong_type, unknown_key_named_once_in_first_occurrence_order, crisp_key_given_unsure_is_wrong_type, judgement_key_accepts_unsure, judgement_key_rejects_other_atoms, string_value_is_wrong_type, unread_key_is_still_checked]).
cp_test_fail_names([settled_general_entity_is_not_open, open_without_member_states_key_is_not_settled, no_single_state_without_representative_is_not_settled, unsure_decisions_route_is_not_settled, rejected_profile_is_not_open, basis_bound_wrong_atom_fails]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
