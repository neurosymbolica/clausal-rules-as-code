% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_checklist/2, nis2_jurisdiction_registration_decision_resolvable/1, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2, public_electronic_communications_provider/0, main_establishment_provider/0, public_administration_entity/0, state_of_establishment/0, state_where_services_are_provided/0, state_of_main_establishment/0, state_that_established_the_entity/0]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_subject/1, nis2_jurisdiction_registration_profile_for/2, nis2_jurisdiction_registration_assess/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_queries, [nis2_jurisdiction_registration_what_if/4]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).

test(general_entity_is_eligible) :-
    nis2_jurisdiction_registration_assess(general_entity_established, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1)])).
test(missing_category_is_indeterminate) :-
    nis2_jurisdiction_registration_assess(category_missing, nis2_jurisdiction_registration_verdict(indeterminate([entity_category]), [])).
test(public_electronic_communications_is_eligible) :-
    nis2_jurisdiction_registration_assess(public_electronic_communications_provider_established, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1_a)])).
test(public_administration_is_eligible) :-
    nis2_jurisdiction_registration_assess(public_administration_established, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1_c)])).
test(provider_established_is_eligible) :-
    nis2_jurisdiction_registration_assess(provider_established_in_union, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1_b), cite(eu_dir_2022_2555_art_26_2)])).
test(provider_established_missing_is_indeterminate) :-
    nis2_jurisdiction_registration_assess(provider_established_missing, nis2_jurisdiction_registration_verdict(indeterminate([established_in_union]), [])).
test(provider_with_representative_is_eligible) :-
    nis2_jurisdiction_registration_assess(provider_non_union_with_representative, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_3)])).
test(provider_without_representative_is_eligible) :-
    nis2_jurisdiction_registration_assess(provider_non_union_without_representative, nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_3)])).
test(provider_no_services_is_ineligible) :-
    nis2_jurisdiction_registration_assess(provider_non_union_no_services, nis2_jurisdiction_registration_verdict(ineligible, [cite(eu_dir_2022_2555_art_26_3)])).
test(provider_offers_missing_is_indeterminate) :-
    nis2_jurisdiction_registration_assess(provider_non_union_offers_missing, nis2_jurisdiction_registration_verdict(indeterminate([offers_services_in_union]), [])).
test(malformed_profile_gives_input_problems) :-
    nis2_jurisdiction_registration_assess(malformed_unknown_key, nis2_jurisdiction_registration_verdict(input_problems([unknown_key(bogus)]), [])).
test(status_projection_matches_verdict) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    nis2_jurisdiction_registration_status(Profile, ineligible).
test(checklist_is_non_empty_and_cited) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    nis2_jurisdiction_registration_decision_resolvable(Profile),
    nis2_jurisdiction_registration_checklist(Profile, [item(overall, eligible, [cite(eu_dir_2022_2555_art_26_1_b), cite(eu_dir_2022_2555_art_26_2)])|_]).
test(every_subject_has_a_checklist) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_checklist(Profile, [_FirstItem|_OtherItems]).
test(basis_of_representative) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_with_representative, Profile),
    jurisdiction_basis(Profile, state_of_representative, [cite(eu_dir_2022_2555_art_26_3)]).
test(basis_of_legal_action) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_without_representative, Profile),
    jurisdiction_basis(Profile, any_member_state_where_services_are_provided_may_take_legal_action, [cite(eu_dir_2022_2555_art_26_3)]).
test(basis_of_no_rule) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    jurisdiction_basis(Profile, no_rule_in_article_26, [cite(eu_dir_2022_2555_art_26_3)]).
test(general_entity_basis_is_state_of_establishment) :-
    state_of_establishment,
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    jurisdiction_basis(Profile, Basis, _Citations),
    Basis == state_of_establishment.
test(public_electronic_communications_basis_is_services_state) :-
    public_electronic_communications_provider,
    state_where_services_are_provided,
    nis2_jurisdiction_registration_profile_for(public_electronic_communications_provider_established, Profile),
    jurisdiction_basis(Profile, Basis, _Citations),
    Basis == state_where_services_are_provided.
test(public_administration_basis_is_establishing_state) :-
    public_administration_entity,
    state_that_established_the_entity,
    nis2_jurisdiction_registration_profile_for(public_administration_established, Profile),
    jurisdiction_basis(Profile, Basis, _Citations),
    Basis == state_that_established_the_entity.
test(provider_basis_is_main_establishment) :-
    main_establishment_provider,
    state_of_main_establishment,
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    jurisdiction_basis(Profile, Basis, _Citations),
    Basis == state_of_main_establishment.
test(provenance_term_builds_and_destructures) :-
    Marker = provenance(decisions_step, [cite(eu_dir_2022_2555_art_26_2)]),
    Marker = provenance(Clause, Citations),
    Clause == decisions_step,
    Citations == [cite(eu_dir_2022_2555_art_26_2)].
test(main_establishment_by_decisions) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_decisions, Profile),
    main_establishment_rule(Profile, state_where_cybersecurity_risk_management_decisions_are_taken, [cite(eu_dir_2022_2555_art_26_2)]).
test(main_establishment_by_operations) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_operations, Profile),
    main_establishment_rule(Profile, state_where_cybersecurity_operations_are_carried_out, [cite(eu_dir_2022_2555_art_26_2)]).
test(main_establishment_by_employees) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_employees, Profile),
    main_establishment_rule(Profile, state_of_establishment_with_most_employees_in_the_union, [cite(eu_dir_2022_2555_art_26_2)]).
test(main_establishment_decisions_unsure_is_referred) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_decisions_unsure, Profile),
    main_establishment_rule(Profile, needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure])]), []).
test(main_establishment_operations_unsure_is_referred) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_operations_unsure, Profile),
    main_establishment_rule(Profile, needs_legal_review(open_textured(cybersecurity_operations_carried_out_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - false, cybersecurity_operations_carried_out_in_one_union_member_state - unsure])]), []).
test(main_establishment_missing_decisions) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_decisions_missing, Profile),
    main_establishment_rule(Profile, indeterminate([decisions_predominantly_taken_in_one_union_member_state]), []).
test(registry_items_established_with_sector) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    registry_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(sector_subsector_and_type_of_entity, cite(eu_dir_2022_2555_art_27_2_b)), item(address_of_main_establishment_and_other_legal_establishments_in_the_union, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]).
test(registry_items_non_union_with_representative) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_with_representative, Profile),
    registry_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(address_of_representative, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(contact_details_of_representative, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]).
test(registry_items_non_union_without_representative_has_no_address) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_without_representative, Profile),
    registry_submission_items(Profile, indeterminate([sector_and_subsector_applicable])).
test(registry_items_missing_keys_named) :-
    nis2_jurisdiction_registration_profile_for(provider_established_missing, Profile),
    registry_submission_items(Profile, indeterminate([established_in_union])).
test(registry_items_empty_for_general_entity) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    registry_submission_items(Profile, []).
test(entity_list_items_all_applicable) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b)), item(sector_and_subsector, cite(eu_dir_2022_2555_art_3_4_c)), item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d))]).
test(entity_list_items_none_applicable) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_with_representative, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b))]).
test(entity_list_items_missing_keys) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    entity_list_submission_items(Profile, indeterminate([sector_and_subsector_applicable, member_states_list_applicable])).
test(limits_for_provider) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    change_notification_limits(Profile, [limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)), limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(limits_for_general_entity) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    change_notification_limits(Profile, [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(input_check_accepts_a_fixture) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, []).
test(input_check_names_unknown_key) :-
    nis2_jurisdiction_registration_profile_for(malformed_unknown_key, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [unknown_key(bogus)]).
test(input_check_names_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, unsure)], [wrong_type(established_in_union)]).
test(input_check_names_duplicate_key) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, true), attribute(established_in_union, true)], [duplicate_key(established_in_union)]).
test(input_check_non_list_profile) :-
    nis2_jurisdiction_registration_input_problems(not_a_profile, [wrong_type(profile)]).
test(what_if_offering_services_flips_to_eligible) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    nis2_jurisdiction_registration_status(Profile, ineligible),
    nis2_jurisdiction_registration_what_if(Profile, offers_services_in_union, true, eligible).
test(what_if_establishing_in_union_flips_to_eligible) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    nis2_jurisdiction_registration_what_if(Profile, established_in_union, true, eligible).
test(what_if_unchanged_value_keeps_status) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    nis2_jurisdiction_registration_what_if(Profile, offers_services_in_union, false, ineligible).

test(missing_category_is_not_eligible, fail) :-
    nis2_jurisdiction_registration_assess(category_missing, nis2_jurisdiction_registration_verdict(eligible, _)).
test(provider_no_services_is_not_eligible, fail) :-
    nis2_jurisdiction_registration_assess(provider_non_union_no_services, nis2_jurisdiction_registration_verdict(eligible, _)).
test(general_entity_basis_is_not_services_state, fail) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    jurisdiction_basis(Profile, state_where_services_are_provided, _).
test(public_electronic_communications_basis_is_not_establishment, fail) :-
    nis2_jurisdiction_registration_profile_for(public_electronic_communications_provider_established, Profile),
    jurisdiction_basis(Profile, state_of_establishment, _).
test(public_administration_basis_is_not_main_establishment, fail) :-
    nis2_jurisdiction_registration_profile_for(public_administration_established, Profile),
    jurisdiction_basis(Profile, state_of_main_establishment, _).
test(provider_basis_is_not_establishing_state, fail) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    jurisdiction_basis(Profile, state_that_established_the_entity, _).
test(provenance_term_is_not_an_open_textured_reason, fail) :-
    provenance(decisions_step, [cite(eu_dir_2022_2555_art_26_2)]) = open_textured(_, _).
test(decisions_true_is_not_the_operations_step, fail) :-
    nis2_jurisdiction_registration_profile_for(main_establishment_decisions, Profile),
    main_establishment_rule(Profile, state_where_cybersecurity_operations_are_carried_out, _).
test(limits_for_general_entity_have_no_registry_limit, fail) :-
    nis2_jurisdiction_registration_profile_for(general_entity_established, Profile),
    change_notification_limits(Profile, [limit(registry_information, _, _)|_]).

cp_test_names([general_entity_is_eligible, missing_category_is_indeterminate, public_electronic_communications_is_eligible, public_administration_is_eligible, provider_established_is_eligible, provider_established_missing_is_indeterminate, provider_with_representative_is_eligible, provider_without_representative_is_eligible, provider_no_services_is_ineligible, provider_offers_missing_is_indeterminate, malformed_profile_gives_input_problems, status_projection_matches_verdict, checklist_is_non_empty_and_cited, every_subject_has_a_checklist, basis_of_representative, basis_of_legal_action, basis_of_no_rule, general_entity_basis_is_state_of_establishment, public_electronic_communications_basis_is_services_state, public_administration_basis_is_establishing_state, provider_basis_is_main_establishment, provenance_term_builds_and_destructures, main_establishment_by_decisions, main_establishment_by_operations, main_establishment_by_employees, main_establishment_decisions_unsure_is_referred, main_establishment_operations_unsure_is_referred, main_establishment_missing_decisions, registry_items_established_with_sector, registry_items_non_union_with_representative, registry_items_non_union_without_representative_has_no_address, registry_items_missing_keys_named, registry_items_empty_for_general_entity, entity_list_items_all_applicable, entity_list_items_none_applicable, entity_list_items_missing_keys, limits_for_provider, limits_for_general_entity, input_check_accepts_a_fixture, input_check_names_unknown_key, input_check_names_wrong_type, input_check_names_duplicate_key, input_check_non_list_profile, what_if_offering_services_flips_to_eligible, what_if_establishing_in_union_flips_to_eligible, what_if_unchanged_value_keeps_status]).
cp_test_fail_names([missing_category_is_not_eligible, provider_no_services_is_not_eligible, general_entity_basis_is_not_services_state, public_electronic_communications_basis_is_not_establishment, public_administration_basis_is_not_main_establishment, provider_basis_is_not_establishing_state, provenance_term_is_not_an_open_textured_reason, decisions_true_is_not_the_operations_step, limits_for_general_entity_have_no_registry_limit]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
