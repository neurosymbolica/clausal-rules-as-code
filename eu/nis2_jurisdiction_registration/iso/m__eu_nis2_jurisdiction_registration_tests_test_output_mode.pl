% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_checklist/2, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_subject/1, nis2_jurisdiction_registration_profile_for/2]).

expected_status(general_entity_settled, registration_position_settled).
expected_status(general_entity_member_states_list_absent, registration_position_open).
expected_status(communications_provider_settled, registration_position_settled).
expected_status(public_administration_settled, registration_position_settled).
expected_status(category_absent, registration_position_open).
expected_status(provider_established_decisions_determined, registration_position_settled).
expected_status(provider_established_decisions_unsure_operations_false, registration_position_open).
expected_status(provider_established_decisions_unsure_operations_absent, registration_position_open).
expected_status(provider_established_decisions_false_operations_unsure, registration_position_open).
expected_status(provider_established_decisions_false_operations_false, registration_position_settled).
expected_status(provider_established_decisions_false_operations_true, registration_position_settled).
expected_status(provider_established_key_absent, registration_position_open).
expected_status(provider_outside_union_with_representative, registration_position_settled).
expected_status(provider_outside_union_without_representative, no_single_member_state_jurisdiction).
expected_status(provider_outside_union_representative_key_absent, registration_position_open).
expected_status(provider_outside_union_offering_no_services, no_single_member_state_jurisdiction).
expected_status(duplicate_and_wrong_type, profile_rejected).
expected_status(unknown_keys_repeated, profile_rejected).
expected_status(crisp_key_given_unsure, profile_rejected).
expected_status(not_an_attribute_list, profile_rejected).
expected_status(non_attribute_element, profile_rejected).

status_is_exactly_expected(Subject) :-
    expected_status(Subject, Expected),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Status, nis2_jurisdiction_registration_status(Profile, Status), Statuses),
    Statuses == [Expected].

test(every_subject_yields_exactly_its_status) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    maplist(status_is_exactly_expected, Subjects).
test(every_registered_subject_has_an_expected_status) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Registered),
    sort(Registered, RegisteredSet),
    findall(Subject, expected_status(Subject, _), Expected),
    sort(Expected, RegisteredSet).
test(the_settled_verdict_carries_its_citations) :-
    nis2_jurisdiction_registration_profile_for(general_entity_settled, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(registration_position_settled, Citations)),
    member(cite(eu_dir_2022_2555_art_26_1), Citations),
    member(cite(eu_dir_2022_2555_art_3_4_a), Citations),
    member(cite(eu_dir_2022_2555_art_3_4), Citations).
test(the_rejected_verdict_has_no_citation) :-
    nis2_jurisdiction_registration_profile_for(unknown_keys_repeated, Profile),
    findall(Verdict, decide_nis2_jurisdiction_registration(Profile, Verdict), Verdicts),
    Verdicts == [nis2_jurisdiction_registration_verdict(profile_rejected, [])].
test(checklist_rows_read_out_in_order) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    nis2_jurisdiction_registration_checklist(Profile, Items),
    findall(Row, member(item(Row, _, _), Items), Rows),
    Rows == [jurisdiction_basis, main_establishment, registry_submission, entity_list_submission, change_notification].
test(basis_read_out_once) :-
    nis2_jurisdiction_registration_profile_for(provider_outside_union_with_representative, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [state_of_representative - [cite(eu_dir_2022_2555_art_26_3)]].
test(main_establishment_read_out_once) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_false_operations_true, Profile),
    findall(Result - Citations, main_establishment_rule(Profile, Result, Citations), Answers),
    Answers == [state_where_cybersecurity_operations_are_carried_out - [cite(eu_dir_2022_2555_art_26_2)]].
test(referral_on_operations_read_out) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_false_operations_unsure, Profile),
    findall(Result - Citations, main_establishment_rule(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(cybersecurity_operations_carried_out_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - false, cybersecurity_operations_carried_out_in_one_union_member_state - unsure])]) - []].
test(operations_named_beside_unsure_decisions) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_unsure_operations_absent, Profile),
    findall(Result, main_establishment_rule(Profile, Result, _), Results),
    Results == [indeterminate([cybersecurity_operations_carried_out_in_one_union_member_state])].
test(registry_items_in_order_for_represented_provider) :-
    nis2_jurisdiction_registration_profile_for(provider_outside_union_with_representative, Profile),
    findall(Items, registry_submission_items(Profile, Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(address_of_representative, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(contact_details_of_representative, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]].
test(entity_list_items_in_order_for_public_administration) :-
    nis2_jurisdiction_registration_profile_for(public_administration_settled, Profile),
    findall(Items, entity_list_submission_items(Profile, Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b)), item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d))]].
test(limits_in_order_for_provider) :-
    nis2_jurisdiction_registration_profile_for(provider_established_decisions_determined, Profile),
    findall(Limits, change_notification_limits(Profile, Limits), Answers),
    Answers == [[limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)), limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]].
test(status_compound_is_never_inside_a_list) :-
    nis2_jurisdiction_registration_profile_for(category_absent, Profile),
    findall(Items, registry_submission_items(Profile, Items), Answers),
    Answers == [indeterminate([entity_category])].

cp_test_names([every_subject_yields_exactly_its_status, every_registered_subject_has_an_expected_status, the_settled_verdict_carries_its_citations, the_rejected_verdict_has_no_citation, checklist_rows_read_out_in_order, basis_read_out_once, main_establishment_read_out_once, referral_on_operations_read_out, operations_named_beside_unsure_decisions, registry_items_in_order_for_represented_provider, entity_list_items_in_order_for_public_administration, limits_in_order_for_provider, status_compound_is_never_inside_a_list]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
