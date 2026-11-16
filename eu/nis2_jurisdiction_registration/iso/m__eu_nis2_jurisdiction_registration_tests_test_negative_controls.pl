% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_status_values/1, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    nis2_jurisdiction_registration_status_values(StatusValues),
    member(ineligible, StatusValues).
test(general_entity_positive) :-
    jurisdiction_basis([attribute(entity_category, general_entity)], state_of_establishment, _).
test(communications_positive) :-
    jurisdiction_basis([attribute(entity_category, public_electronic_communications_provider)], state_where_services_are_provided, _).
test(public_administration_positive) :-
    jurisdiction_basis([attribute(entity_category, public_administration_entity)], state_that_established_the_entity, _).
test(provider_established_positive) :-
    jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true)], state_of_main_establishment, _).
test(representative_positive) :-
    jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, true)], state_of_representative, _).
test(no_representative_legal_action_positive) :-
    jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, false)], any_member_state_where_services_are_provided_may_take_legal_action, _).
test(no_services_positive) :-
    nis2_jurisdiction_registration_status([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, false)], ineligible).
test(decisions_true_positive) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, true)], state_where_cybersecurity_risk_management_decisions_are_taken, _).
test(operations_true_positive) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, true)], state_where_cybersecurity_operations_are_carried_out, _).
test(employees_positive) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, false)], state_of_establishment_with_most_employees_in_the_union, _).
test(unsure_decisions_is_a_referral) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, unsure)], needs_legal_review(_, _), []).
test(registry_sector_positive) :-
    registry_submission_items([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(sector_and_subsector_applicable, true)], Items),
    member(item(sector_subsector_and_type_of_entity, cite(eu_dir_2022_2555_art_27_2_b)), Items).
test(registry_provider_list_is_not_empty) :-
    registry_submission_items([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(sector_and_subsector_applicable, false)], [_|_]).
test(entity_list_member_states_positive) :-
    entity_list_submission_items([attribute(sector_and_subsector_applicable, false), attribute(member_states_list_applicable, true)], Items),
    member(item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d)), Items).
test(limits_provider_has_registry_limit) :-
    change_notification_limits([attribute(entity_category, main_establishment_provider)], Limits),
    member(limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)), Limits).

test(general_entity_is_not_main_establishment_basis, fail) :-
    jurisdiction_basis([attribute(entity_category, general_entity)], state_of_main_establishment, _).
test(communications_is_not_state_of_establishment, fail) :-
    jurisdiction_basis([attribute(entity_category, public_electronic_communications_provider)], state_of_establishment, _).
test(public_administration_is_not_state_of_establishment, fail) :-
    jurisdiction_basis([attribute(entity_category, public_administration_entity)], state_of_establishment, _).
test(provider_not_established_is_not_main_establishment, fail) :-
    jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, true)], state_of_main_establishment, _).
test(no_representative_is_not_state_of_representative, fail) :-
    jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, false)], state_of_representative, _).
test(services_offered_is_not_ineligible, fail) :-
    nis2_jurisdiction_registration_status([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, false)], ineligible).
test(decisions_false_is_not_decisions_state, fail) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, true)], state_where_cybersecurity_risk_management_decisions_are_taken, _).
test(operations_false_is_not_operations_state, fail) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, false)], state_where_cybersecurity_operations_are_carried_out, _).
test(unsure_decisions_is_not_a_final_result, fail) :-
    main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, unsure)], state_where_cybersecurity_risk_management_decisions_are_taken, _).
test(registry_no_sector_has_no_sector_item, fail) :-
    registry_submission_items([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(sector_and_subsector_applicable, false)], Items),
    member(item(sector_subsector_and_type_of_entity, _), Items).
test(registry_general_entity_is_not_a_non_empty_list, fail) :-
    registry_submission_items([attribute(entity_category, general_entity)], [_|_]).
test(entity_list_no_member_states_item, fail) :-
    entity_list_submission_items([attribute(sector_and_subsector_applicable, false), attribute(member_states_list_applicable, false)], Items),
    member(item(member_states_where_services_in_scope_are_provided, _), Items).
test(limits_general_entity_has_no_registry_limit, fail) :-
    change_notification_limits([attribute(entity_category, general_entity)], Limits),
    member(limit(registry_information, _, _), Limits).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, general_entity_positive, communications_positive, public_administration_positive, provider_established_positive, representative_positive, no_representative_legal_action_positive, no_services_positive, decisions_true_positive, operations_true_positive, employees_positive, unsure_decisions_is_a_referral, registry_sector_positive, registry_provider_list_is_not_empty, entity_list_member_states_positive, limits_provider_has_registry_limit]).
cp_test_fail_names([general_entity_is_not_main_establishment_basis, communications_is_not_state_of_establishment, public_administration_is_not_state_of_establishment, provider_not_established_is_not_main_establishment, no_representative_is_not_state_of_representative, services_offered_is_not_ineligible, decisions_false_is_not_decisions_state, operations_false_is_not_operations_state, unsure_decisions_is_not_a_final_result, registry_no_sector_has_no_sector_item, registry_general_entity_is_not_a_non_empty_list, entity_list_no_member_states_item, limits_general_entity_has_no_registry_limit]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
