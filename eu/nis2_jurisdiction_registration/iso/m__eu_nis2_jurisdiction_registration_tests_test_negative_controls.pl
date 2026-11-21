% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_profile_for/2]).

control_profile(general_entity, [attribute(entity_category, general_entity)]).
control_profile(public_administration, [attribute(entity_category, public_administration_entity)]).
control_profile(communications_provider, [attribute(entity_category, public_electronic_communications_provider)]).
control_profile(no_category, []).
control_profile(provider_established, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, true)]).
control_profile(provider_outside_offering_nothing, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, false)]).
control_profile(provider_outside_with_representative, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, true)]).
control_profile(provider_outside_without_representative, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true), attribute(representative_designated_in_union, false)]).
control_profile(decisions_determined, [attribute(decisions_predominantly_taken_in_one_union_member_state, true)]).
control_profile(decisions_failed_operations_failed, [attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, false)]).
control_profile(decisions_failed_operations_determined, [attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, true)]).
control_profile(decisions_failed_operations_unsure, [attribute(decisions_predominantly_taken_in_one_union_member_state, false), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, unsure)]).
control_profile(decisions_unsure_operations_failed, [attribute(decisions_predominantly_taken_in_one_union_member_state, unsure), attribute(cybersecurity_operations_carried_out_in_one_union_member_state, false)]).
control_profile(decisions_unsure_operations_absent, [attribute(decisions_predominantly_taken_in_one_union_member_state, unsure)]).
control_profile(registry_established_with_sector, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(sector_and_subsector_applicable, true)]).
control_profile(registry_established_without_sector, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(sector_and_subsector_applicable, false)]).
control_profile(registry_outside_with_representative, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(representative_designated_in_union, true), attribute(sector_and_subsector_applicable, false)]).
control_profile(registry_outside_without_representative, [attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(representative_designated_in_union, false), attribute(sector_and_subsector_applicable, false)]).
control_profile(list_with_member_states, [attribute(sector_and_subsector_applicable, false), attribute(member_states_list_applicable, true)]).
control_profile(list_without_member_states, [attribute(sector_and_subsector_applicable, false), attribute(member_states_list_applicable, false)]).
control_profile(unknown_key_added, [attribute(entity_category, general_entity), attribute(colour, red)]).

basis_of(Name, Basis) :-
    control_profile(Name, Profile),
    jurisdiction_basis(Profile, Basis, _).

result_of(Name, Result) :-
    control_profile(Name, Profile),
    main_establishment_rule(Profile, Result, _).

registry_of(Name, Items) :-
    control_profile(Name, Profile),
    registry_submission_items(Profile, Items).

list_of(Name, Items) :-
    control_profile(Name, Profile),
    entity_list_submission_items(Profile, Items).

limits_of(Name, Limits) :-
    control_profile(Name, Profile),
    change_notification_limits(Profile, Limits).

subject_status(Subject, Status) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_status(Profile, Status).

test(general_entity_is_state_of_establishment) :-
    basis_of(general_entity, state_of_establishment).
test(public_administration_is_state_that_established_it) :-
    basis_of(public_administration, state_that_established_the_entity).
test(communications_provider_is_where_services_are_provided) :-
    basis_of(communications_provider, state_where_services_are_provided).
test(no_category_is_indeterminate) :-
    basis_of(no_category, indeterminate([entity_category])).
test(established_provider_is_main_establishment) :-
    basis_of(provider_established, state_of_main_establishment).
test(outside_provider_offering_nothing_has_no_rule) :-
    basis_of(provider_outside_offering_nothing, no_rule_in_article_26).
test(represented_provider_is_state_of_representative) :-
    basis_of(provider_outside_with_representative, state_of_representative).
test(unrepresented_provider_may_be_sued_anywhere_it_serves) :-
    basis_of(provider_outside_without_representative, any_member_state_where_services_are_provided_may_take_legal_action).
test(decisions_determined_fixes_the_main_establishment) :-
    result_of(decisions_determined, state_where_cybersecurity_risk_management_decisions_are_taken).
test(both_failed_is_the_employees_step) :-
    result_of(decisions_failed_operations_failed, state_of_establishment_with_most_employees_in_the_union).
test(operations_determined_is_the_operations_step) :-
    result_of(decisions_failed_operations_determined, state_where_cybersecurity_operations_are_carried_out).
test(unsure_decisions_with_operations_present_refers) :-
    result_of(decisions_unsure_operations_failed, needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), _)).
test(unsure_decisions_with_operations_absent_names_operations) :-
    result_of(decisions_unsure_operations_absent, indeterminate([cybersecurity_operations_carried_out_in_one_union_member_state])).
test(unsure_operations_refers) :-
    result_of(decisions_failed_operations_unsure, needs_legal_review(open_textured(cybersecurity_operations_carried_out_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), _)).
test(provider_owes_registry_items) :-
    registry_of(registry_established_with_sector, [item(entity_name, _)|_]).
test(general_entity_registry_list_is_empty) :-
    registry_of(general_entity, []).
test(sector_item_owed_when_applicable) :-
    registry_of(registry_established_with_sector, Items),
    member(item(sector_subsector_and_type_of_entity, cite(eu_dir_2022_2555_art_27_2_b)), Items).
test(established_provider_gives_union_establishments) :-
    registry_of(registry_established_without_sector, Items),
    member(item(address_of_main_establishment_and_other_legal_establishments_in_the_union, cite(eu_dir_2022_2555_art_27_2_c)), Items).
test(represented_provider_gives_representative_address) :-
    registry_of(registry_outside_with_representative, Items),
    member(item(address_of_representative, cite(eu_dir_2022_2555_art_27_2_c)), Items).
test(unrepresented_provider_gives_four_items) :-
    registry_of(registry_outside_without_representative, Items),
    length(Items, 4).
test(member_states_item_owed_when_applicable) :-
    list_of(list_with_member_states, Items),
    member(item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d)), Items).
test(entity_list_minimal_has_two_items) :-
    list_of(list_without_member_states, Items),
    length(Items, 2).
test(provider_has_registry_change_limit) :-
    limits_of(provider_established, [limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3))|_]).
test(general_entity_has_the_two_week_limit) :-
    limits_of(general_entity, [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(unknown_key_is_reported_first) :-
    basis_of(unknown_key_added, input_problems([unknown_key(colour)])).
test(settled_route) :-
    subject_status(general_entity_settled, registration_position_settled).
test(dropped_list_key_is_open) :-
    subject_status(general_entity_member_states_list_absent, registration_position_open).
test(no_representative_route_is_no_single_state) :-
    subject_status(provider_outside_union_without_representative, no_single_member_state_jurisdiction).
test(no_services_route_is_no_single_state) :-
    subject_status(provider_outside_union_offering_no_services, no_single_member_state_jurisdiction).
test(failed_operations_route_is_settled) :-
    subject_status(provider_established_decisions_false_operations_false, registration_position_settled).

test(public_administration_is_not_state_of_establishment, fail) :-
    basis_of(public_administration, state_of_establishment).
test(general_entity_is_not_where_services_are_provided, fail) :-
    basis_of(general_entity, state_where_services_are_provided).
test(given_category_is_not_indeterminate, fail) :-
    basis_of(general_entity, indeterminate(_)).
test(outside_provider_is_not_main_establishment, fail) :-
    basis_of(provider_outside_offering_nothing, state_of_main_establishment).
test(outside_provider_offering_services_has_a_rule, fail) :-
    basis_of(provider_outside_with_representative, no_rule_in_article_26).
test(unrepresented_provider_is_not_state_of_representative, fail) :-
    basis_of(provider_outside_without_representative, state_of_representative).
test(decisions_failed_is_not_the_decisions_step, fail) :-
    result_of(decisions_failed_operations_failed, state_where_cybersecurity_risk_management_decisions_are_taken).
test(operations_failed_is_not_the_operations_step, fail) :-
    result_of(decisions_failed_operations_failed, state_where_cybersecurity_operations_are_carried_out).
test(unsure_decisions_with_operations_absent_does_not_refer, fail) :-
    result_of(decisions_unsure_operations_absent, needs_legal_review(_, _)).
test(determined_operations_does_not_refer, fail) :-
    result_of(decisions_failed_operations_determined, needs_legal_review(_, _)).
test(general_entity_owes_no_registry_items, fail) :-
    control_profile(general_entity, Profile),
    registry_submission_items(Profile, [_|_]).
test(sector_item_not_owed_when_not_applicable, fail) :-
    registry_of(registry_established_without_sector, Items),
    member(item(sector_subsector_and_type_of_entity, _), Items).
test(outside_provider_gives_no_union_establishments, fail) :-
    registry_of(registry_outside_with_representative, Items),
    member(item(address_of_main_establishment_and_other_legal_establishments_in_the_union, _), Items).
test(unrepresented_provider_gives_no_representative_address, fail) :-
    registry_of(registry_outside_without_representative, Items),
    member(item(address_of_representative, _), Items).
test(member_states_item_not_owed_when_not_applicable, fail) :-
    list_of(list_without_member_states, Items),
    member(item(member_states_where_services_in_scope_are_provided, _), Items).
test(general_entity_has_no_registry_change_limit, fail) :-
    limits_of(general_entity, Limits),
    member(limit(registry_information, _, _), Limits).
test(well_formed_profile_has_no_input_problem, fail) :-
    basis_of(general_entity, input_problems(_)).
test(dropped_list_key_is_not_settled, fail) :-
    subject_status(general_entity_member_states_list_absent, registration_position_settled).
test(representative_route_is_not_no_single_state, fail) :-
    subject_status(provider_outside_union_with_representative, no_single_member_state_jurisdiction).
test(unsure_operations_route_is_not_settled, fail) :-
    subject_status(provider_established_decisions_false_operations_unsure, registration_position_settled).

cp_test_names([general_entity_is_state_of_establishment, public_administration_is_state_that_established_it, communications_provider_is_where_services_are_provided, no_category_is_indeterminate, established_provider_is_main_establishment, outside_provider_offering_nothing_has_no_rule, represented_provider_is_state_of_representative, unrepresented_provider_may_be_sued_anywhere_it_serves, decisions_determined_fixes_the_main_establishment, both_failed_is_the_employees_step, operations_determined_is_the_operations_step, unsure_decisions_with_operations_present_refers, unsure_decisions_with_operations_absent_names_operations, unsure_operations_refers, provider_owes_registry_items, general_entity_registry_list_is_empty, sector_item_owed_when_applicable, established_provider_gives_union_establishments, represented_provider_gives_representative_address, unrepresented_provider_gives_four_items, member_states_item_owed_when_applicable, entity_list_minimal_has_two_items, provider_has_registry_change_limit, general_entity_has_the_two_week_limit, unknown_key_is_reported_first, settled_route, dropped_list_key_is_open, no_representative_route_is_no_single_state, no_services_route_is_no_single_state, failed_operations_route_is_settled]).
cp_test_fail_names([public_administration_is_not_state_of_establishment, general_entity_is_not_where_services_are_provided, given_category_is_not_indeterminate, outside_provider_is_not_main_establishment, outside_provider_offering_services_has_a_rule, unrepresented_provider_is_not_state_of_representative, decisions_failed_is_not_the_decisions_step, operations_failed_is_not_the_operations_step, unsure_decisions_with_operations_absent_does_not_refer, determined_operations_does_not_refer, general_entity_owes_no_registry_items, sector_item_not_owed_when_not_applicable, outside_provider_gives_no_union_establishments, unrepresented_provider_gives_no_representative_address, member_states_item_not_owed_when_not_applicable, general_entity_has_no_registry_change_limit, well_formed_profile_has_no_input_problem, dropped_list_key_is_not_settled, representative_route_is_not_no_single_state, unsure_operations_route_is_not_settled]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
