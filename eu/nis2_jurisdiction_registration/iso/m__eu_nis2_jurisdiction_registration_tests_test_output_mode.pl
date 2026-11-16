% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_checklist/2, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_profile_for/2]).

test(general_entity_yields_exactly_one_status) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    findall(Status, nis2_jurisdiction_registration_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_citation) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1)])).
test(checklist_row_carries_provenance) :-
    nis2_jurisdiction_registration_profile_for(public_administration_established, Profile),
    findall(Row, nis2_jurisdiction_registration_checklist(Profile, Row), Rows),
    Rows == [[item(overall, eligible, [cite(eu_dir_2022_2555_art_26_1_c)])]].
test(basis_public_electronic_communications) :-
    findall(Basis - Citations, jurisdiction_basis([attribute(entity_category, public_electronic_communications_provider)], Basis, Citations), Answers),
    Answers == [state_where_services_are_provided - [cite(eu_dir_2022_2555_art_26_1_a)]].
test(basis_public_administration) :-
    findall(Basis - Citations, jurisdiction_basis([attribute(entity_category, public_administration_entity)], Basis, Citations), Answers),
    Answers == [state_that_established_the_entity - [cite(eu_dir_2022_2555_art_26_1_c)]].
test(basis_provider_established) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [state_of_main_establishment - [cite(eu_dir_2022_2555_art_26_1_b), cite(eu_dir_2022_2555_art_26_2)]].
test(basis_provider_with_representative) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_with_representative, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [state_of_representative - [cite(eu_dir_2022_2555_art_26_3)]].
test(basis_provider_without_representative) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_without_representative, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [any_member_state_where_services_are_provided_may_take_legal_action - [cite(eu_dir_2022_2555_art_26_3)]].
test(basis_provider_no_services) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [no_rule_in_article_26 - [cite(eu_dir_2022_2555_art_26_3)]].
test(basis_missing_keys) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_offers_missing, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Answers),
    Answers == [indeterminate([offers_services_in_union]) - []].
test(basis_missing_representative) :-
    findall(Basis, jurisdiction_basis([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(offers_services_in_union, true)], Basis, _), Answers),
    Answers == [indeterminate([representative_designated_in_union])].
test(main_establishment_operations) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_operations, Profile),
    findall(Result - Citations, main_establishment_rule(Profile, Result, Citations), Answers),
    Answers == [state_where_cybersecurity_operations_are_carried_out - [cite(eu_dir_2022_2555_art_26_2)]].
test(main_establishment_employees) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_employees, Profile),
    findall(Result, main_establishment_rule(Profile, Result, _), Answers),
    Answers == [state_of_establishment_with_most_employees_in_the_union].
test(main_establishment_decisions_missing) :-
    findall(Result - Citations, main_establishment_rule([], Result, Citations), Answers),
    Answers == [indeterminate([decisions_predominantly_taken_in_one_union_member_state]) - []].
test(main_establishment_operations_missing) :-
    findall(Result, main_establishment_rule([attribute(decisions_predominantly_taken_in_one_union_member_state, false)], Result, _), Answers),
    Answers == [indeterminate([cybersecurity_operations_carried_out_in_one_union_member_state])].
test(main_establishment_decisions_unsure_refers) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_decisions_unsure, Profile),
    findall(Result - Citations, main_establishment_rule(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure])]) - []].
test(main_establishment_operations_unsure_refers) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_operations_unsure, Profile),
    findall(Result - Citations, main_establishment_rule(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(cybersecurity_operations_carried_out_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - false, cybersecurity_operations_carried_out_in_one_union_member_state - unsure])]) - []].
test(registry_established_full_list) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    findall(Items, registry_submission_items(Profile, Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(sector_subsector_and_type_of_entity, cite(eu_dir_2022_2555_art_27_2_b)), item(address_of_main_establishment_and_other_legal_establishments_in_the_union, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]].
test(registry_with_representative) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_with_representative, Profile),
    findall(Items, registry_submission_items(Profile, Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(address_of_representative, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(contact_details_of_representative, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]].
test(registry_without_representative_has_no_address) :-
    findall(Items, registry_submission_items([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false), attribute(representative_designated_in_union, false), attribute(sector_and_subsector_applicable, false)], Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]].
test(registry_missing_keys_in_root_order) :-
    findall(Items, registry_submission_items([attribute(entity_category, main_establishment_provider), attribute(established_in_union, false)], Items), Answers),
    Answers == [indeterminate([representative_designated_in_union, sector_and_subsector_applicable])].
test(registry_category_absent) :-
    findall(Items, registry_submission_items([], Items), Answers),
    Answers == [indeterminate([entity_category])].
test(entity_list_missing_keys) :-
    findall(Items, entity_list_submission_items([], Items), Answers),
    Answers == [indeterminate([sector_and_subsector_applicable, member_states_list_applicable])].
test(entity_list_without_sector) :-
    findall(Items, entity_list_submission_items([attribute(sector_and_subsector_applicable, false), attribute(member_states_list_applicable, true)], Items), Answers),
    Answers == [[item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b)), item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d))]].
test(limits_for_general_entity_only_list) :-
    findall(Limits, change_notification_limits([attribute(entity_category, general_entity)], Limits), Answers),
    Answers == [[limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]].
test(limits_category_absent) :-
    findall(Limits, change_notification_limits([], Limits), Answers),
    Answers == [indeterminate([entity_category])].

cp_test_names([general_entity_yields_exactly_one_status, the_verdict_carries_a_citation, checklist_row_carries_provenance, basis_public_electronic_communications, basis_public_administration, basis_provider_established, basis_provider_with_representative, basis_provider_without_representative, basis_provider_no_services, basis_missing_keys, basis_missing_representative, main_establishment_operations, main_establishment_employees, main_establishment_decisions_missing, main_establishment_operations_missing, main_establishment_decisions_unsure_refers, main_establishment_operations_unsure_refers, registry_established_full_list, registry_with_representative, registry_without_representative_has_no_address, registry_missing_keys_in_root_order, registry_category_absent, entity_list_missing_keys, entity_list_without_sector, limits_for_general_entity_only_list, limits_category_absent]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
