% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_checklist/2, nis2_jurisdiction_registration_decision_resolvable/1, nis2_jurisdiction_registration_status_values/1, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_subject/1, nis2_jurisdiction_registration_profile_for/2, nis2_jurisdiction_registration_assess/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).

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

subject_has_expected_status(Subject) :-
    expected_status(Subject, Status),
    nis2_jurisdiction_registration_assess(Subject, nis2_jurisdiction_registration_verdict(Status, _)).

subject_has_exactly_one_verdict(Subject) :-
    findall(Verdict, nis2_jurisdiction_registration_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_non_empty_checklist(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_checklist(Profile, [_|_]).

subject_answers_every_query_once(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Basis - BasisCitations, jurisdiction_basis(Profile, Basis, BasisCitations), BasisAnswers),
    length(BasisAnswers, 1),
    findall(Result - ResultCitations, main_establishment_rule(Profile, Result, ResultCitations), ResultAnswers),
    length(ResultAnswers, 1),
    findall(RegistryItems, registry_submission_items(Profile, RegistryItems), RegistryAnswers),
    length(RegistryAnswers, 1),
    findall(ListItems, entity_list_submission_items(Profile, ListItems), ListAnswers),
    length(ListAnswers, 1),
    findall(Limits, change_notification_limits(Profile, Limits), LimitAnswers),
    length(LimitAnswers, 1),
    findall(Problems, nis2_jurisdiction_registration_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

item_is_cited(item(_, _, [cite(_)|_])).

status_in_vocabulary(StatusValues, Status) :-
    member(Status, StatusValues).

subject_status(Subject, Status) :-
    nis2_jurisdiction_registration_assess(Subject, nis2_jurisdiction_registration_verdict(Status, _)).

subject_profile(Subject, Profile) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile).

test(every_subject_has_an_expected_status) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    length(Subjects, 21),
    findall(Listed, expected_status(Listed, _), ListedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ListedSubjects, SortedSubjects).
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    maplist(subject_has_expected_status, Subjects).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    maplist(subject_has_exactly_one_verdict, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    maplist(subject_has_non_empty_checklist, Subjects).
test(every_query_answers_every_subject_exactly_once) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    maplist(subject_answers_every_query_once, Subjects).
test(every_status_is_in_the_vocabulary) :-
    nis2_jurisdiction_registration_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    sort(Statuses, DistinctStatuses),
    length(DistinctStatuses, 4),
    maplist(status_in_vocabulary(StatusValues), DistinctStatuses).
test(every_subject_is_resolvable) :-
    findall(Profile, (nis2_jurisdiction_registration_subject(Subject), subject_profile(Subject, Profile)), Profiles),
    maplist(nis2_jurisdiction_registration_decision_resolvable, Profiles).
test(public_electronic_communications_provider_category_gives_its_basis) :-
    jurisdiction_basis([attribute(entity_category, public_electronic_communications_provider)], state_where_services_are_provided, [cite(eu_dir_2022_2555_art_26_1_a)]),
    registry_submission_items([attribute(entity_category, public_electronic_communications_provider)], []),
    change_notification_limits([attribute(entity_category, public_electronic_communications_provider)], [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(public_administration_entity_category_gives_its_basis) :-
    jurisdiction_basis([attribute(entity_category, public_administration_entity)], state_that_established_the_entity, [cite(eu_dir_2022_2555_art_26_1_c)]),
    registry_submission_items([attribute(entity_category, public_administration_entity)], []),
    change_notification_limits([attribute(entity_category, public_administration_entity)], [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(provenance_element_builds_and_destructures) :-
    Referral = needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure]), provenance(main_establishment_rule, [cite(eu_dir_2022_2555_art_26_2)])]),
    Referral = needs_legal_review(_, [inputs_relied_on(_), provenance(Clause, Citations)]),
    Clause == main_establishment_rule,
    Citations == [cite(eu_dir_2022_2555_art_26_2)].
test(settled_checklist_rows_are_all_cited) :-
    subject_profile(provider_established_decisions_determined, Profile),
    nis2_jurisdiction_registration_checklist(Profile, Items),
    length(Items, 5),
    maplist(item_is_cited, Items).
test(open_checklist_rows_are_all_cited) :-
    subject_profile(category_absent, Profile),
    nis2_jurisdiction_registration_checklist(Profile, Items),
    maplist(item_is_cited, Items).
test(settled_verdict_cites_the_main_establishment_rule) :-
    decide_nis2_jurisdiction_registration([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(decisions_predominantly_taken_in_one_union_member_state, true), attribute(sector_and_subsector_applicable, true), attribute(member_states_list_applicable, true)], nis2_jurisdiction_registration_verdict(registration_position_settled, Citations)),
    member(cite(eu_dir_2022_2555_art_26_1_b), Citations),
    member(cite(eu_dir_2022_2555_art_26_2), Citations),
    member(cite(eu_dir_2022_2555_art_27_3), Citations).
test(rejected_verdict_has_no_citations) :-
    nis2_jurisdiction_registration_assess(duplicate_and_wrong_type, nis2_jurisdiction_registration_verdict(profile_rejected, [])).
test(general_entity_settled_is_settled) :-
    subject_status(general_entity_settled, registration_position_settled).
test(member_states_list_absent_control_is_open) :-
    subject_status(general_entity_member_states_list_absent, registration_position_open).
test(decisions_determined_is_settled) :-
    subject_status(provider_established_decisions_determined, registration_position_settled).
test(with_representative_is_settled) :-
    subject_status(provider_outside_union_with_representative, registration_position_settled).
test(without_representative_control_has_no_single_state) :-
    subject_status(provider_outside_union_without_representative, no_single_member_state_jurisdiction).
test(representative_key_absent_control_is_open) :-
    subject_status(provider_outside_union_representative_key_absent, registration_position_open).
test(no_services_control_has_no_single_state) :-
    subject_status(provider_outside_union_offering_no_services, no_single_member_state_jurisdiction).
test(unsure_decisions_are_handed_to_the_user_on_the_checklist) :-
    subject_profile(provider_established_decisions_unsure_operations_false, Profile),
    nis2_jurisdiction_registration_checklist(Profile, Items),
    member(item(main_establishment, unknown([decisions_predominantly_taken_in_one_union_member_state]), _), Items).
test(unsure_decisions_with_absent_operations_name_the_operations_key) :-
    subject_profile(provider_established_decisions_unsure_operations_absent, Profile),
    nis2_jurisdiction_registration_checklist(Profile, Items),
    member(item(main_establishment, unknown([cybersecurity_operations_carried_out_in_one_union_member_state]), _), Items).
test(fixture_basis_general_entity) :-
    subject_profile(general_entity_settled, Profile),
    jurisdiction_basis(Profile, state_of_establishment, [cite(eu_dir_2022_2555_art_26_1)]).
test(fixture_basis_communications_provider) :-
    subject_profile(communications_provider_settled, Profile),
    jurisdiction_basis(Profile, state_where_services_are_provided, [cite(eu_dir_2022_2555_art_26_1_a)]).
test(fixture_basis_public_administration) :-
    subject_profile(public_administration_settled, Profile),
    jurisdiction_basis(Profile, state_that_established_the_entity, [cite(eu_dir_2022_2555_art_26_1_c)]).
test(fixture_basis_category_absent) :-
    subject_profile(category_absent, Profile),
    jurisdiction_basis(Profile, indeterminate([entity_category]), []).
test(fixture_basis_main_establishment) :-
    subject_profile(provider_established_decisions_determined, Profile),
    jurisdiction_basis(Profile, state_of_main_establishment, Citations),
    clausal_msort(Citations, [cite(eu_dir_2022_2555_art_26_1_b), cite(eu_dir_2022_2555_art_26_2)]).
test(fixture_basis_established_key_absent) :-
    subject_profile(provider_established_key_absent, Profile),
    jurisdiction_basis(Profile, indeterminate([established_in_union]), []).
test(fixture_basis_representative) :-
    subject_profile(provider_outside_union_with_representative, Profile),
    jurisdiction_basis(Profile, state_of_representative, [cite(eu_dir_2022_2555_art_26_3)]).
test(fixture_basis_without_representative) :-
    subject_profile(provider_outside_union_without_representative, Profile),
    jurisdiction_basis(Profile, any_member_state_where_services_are_provided_may_take_legal_action, [cite(eu_dir_2022_2555_art_26_3)]).
test(fixture_basis_representative_key_absent) :-
    subject_profile(provider_outside_union_representative_key_absent, Profile),
    jurisdiction_basis(Profile, indeterminate([representative_designated_in_union]), []).
test(fixture_basis_no_services) :-
    subject_profile(provider_outside_union_offering_no_services, Profile),
    jurisdiction_basis(Profile, no_rule_in_article_26, [cite(eu_dir_2022_2555_art_26_3)]).
test(fixture_main_establishment_decisions_step) :-
    subject_profile(provider_established_decisions_determined, Profile),
    main_establishment_rule(Profile, state_where_cybersecurity_risk_management_decisions_are_taken, [cite(eu_dir_2022_2555_art_26_2)]).
test(fixture_main_establishment_referral_on_decisions) :-
    subject_profile(provider_established_decisions_unsure_operations_false, Profile),
    main_establishment_rule(Profile, needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure])]), []).
test(fixture_main_establishment_operations_named_before_referral) :-
    subject_profile(provider_established_decisions_unsure_operations_absent, Profile),
    main_establishment_rule(Profile, indeterminate([cybersecurity_operations_carried_out_in_one_union_member_state]), []).
test(fixture_main_establishment_referral_on_operations) :-
    subject_profile(provider_established_decisions_false_operations_unsure, Profile),
    main_establishment_rule(Profile, needs_legal_review(open_textured(cybersecurity_operations_carried_out_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - false, cybersecurity_operations_carried_out_in_one_union_member_state - unsure])]), []).
test(fixture_main_establishment_employees_step) :-
    subject_profile(provider_established_decisions_false_operations_false, Profile),
    main_establishment_rule(Profile, state_of_establishment_with_most_employees_in_the_union, [cite(eu_dir_2022_2555_art_26_2)]).
test(fixture_main_establishment_operations_step) :-
    subject_profile(provider_established_decisions_false_operations_true, Profile),
    main_establishment_rule(Profile, state_where_cybersecurity_operations_are_carried_out, [cite(eu_dir_2022_2555_art_26_2)]).
test(fixture_registry_established_provider) :-
    subject_profile(provider_established_decisions_determined, Profile),
    registry_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(sector_subsector_and_type_of_entity, cite(eu_dir_2022_2555_art_27_2_b)), item(address_of_main_establishment_and_other_legal_establishments_in_the_union, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]).
test(fixture_registry_with_representative) :-
    subject_profile(provider_outside_union_with_representative, Profile),
    registry_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(address_of_representative, cite(eu_dir_2022_2555_art_27_2_c)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(contact_details_of_representative, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]).
test(fixture_registry_without_representative_has_no_address) :-
    subject_profile(provider_outside_union_without_representative, Profile),
    registry_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)), item(contact_details_of_entity, cite(eu_dir_2022_2555_art_27_2_d)), item(member_states_where_services_are_provided, cite(eu_dir_2022_2555_art_27_2_e)), item(ip_ranges, cite(eu_dir_2022_2555_art_27_2_f))]).
test(fixture_registry_not_owed_by_general_entity) :-
    subject_profile(general_entity_settled, Profile),
    registry_submission_items(Profile, []).
test(fixture_registry_category_absent) :-
    subject_profile(category_absent, Profile),
    registry_submission_items(Profile, indeterminate([entity_category])).
test(fixture_registry_established_key_absent) :-
    subject_profile(provider_established_key_absent, Profile),
    registry_submission_items(Profile, indeterminate([established_in_union])).
test(fixture_registry_representative_key_absent) :-
    subject_profile(provider_outside_union_representative_key_absent, Profile),
    registry_submission_items(Profile, indeterminate([representative_designated_in_union])).
test(fixture_entity_list_full) :-
    subject_profile(provider_established_decisions_determined, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b)), item(sector_and_subsector, cite(eu_dir_2022_2555_art_3_4_c)), item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d))]).
test(fixture_entity_list_without_sector) :-
    subject_profile(public_administration_settled, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b)), item(member_states_where_services_in_scope_are_provided, cite(eu_dir_2022_2555_art_3_4_d))]).
test(fixture_entity_list_minimal) :-
    subject_profile(general_entity_settled, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b))]).
test(fixture_entity_list_member_states_key_absent) :-
    subject_profile(general_entity_member_states_list_absent, Profile),
    entity_list_submission_items(Profile, indeterminate([member_states_list_applicable])).
test(fixture_entity_list_does_not_read_the_category) :-
    subject_profile(category_absent, Profile),
    entity_list_submission_items(Profile, [item(entity_name, cite(eu_dir_2022_2555_art_3_4_a)), item(address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers, cite(eu_dir_2022_2555_art_3_4_b))]).
test(fixture_limits_provider) :-
    subject_profile(provider_outside_union_with_representative, Profile),
    change_notification_limits(Profile, [limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)), limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(fixture_limits_general_entity) :-
    subject_profile(general_entity_settled, Profile),
    change_notification_limits(Profile, [limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]).
test(fixture_limits_category_absent) :-
    subject_profile(category_absent, Profile),
    change_notification_limits(Profile, indeterminate([entity_category])).
test(fixture_clean_profile_has_no_problems) :-
    subject_profile(provider_established_decisions_determined, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, []).
test(fixture_duplicate_and_wrong_type_problems) :-
    subject_profile(duplicate_and_wrong_type, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(entity_category), duplicate_key(established_in_union)]).
test(fixture_duplicate_and_wrong_type_reaches_every_query) :-
    subject_profile(duplicate_and_wrong_type, Profile),
    jurisdiction_basis(Profile, input_problems([wrong_type(entity_category), duplicate_key(established_in_union)]), []),
    main_establishment_rule(Profile, input_problems([wrong_type(entity_category), duplicate_key(established_in_union)]), []),
    registry_submission_items(Profile, input_problems([wrong_type(entity_category), duplicate_key(established_in_union)])),
    entity_list_submission_items(Profile, input_problems([wrong_type(entity_category), duplicate_key(established_in_union)])),
    change_notification_limits(Profile, input_problems([wrong_type(entity_category), duplicate_key(established_in_union)])).
test(fixture_unknown_keys_once_each_in_first_occurrence_order) :-
    subject_profile(unknown_keys_repeated, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [unknown_key(head_office), unknown_key(employee_count)]).
test(fixture_crisp_key_given_unsure) :-
    subject_profile(crisp_key_given_unsure, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(sector_and_subsector_applicable)]).
test(fixture_not_an_attribute_list) :-
    subject_profile(not_an_attribute_list, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(profile)]),
    change_notification_limits(Profile, input_problems([wrong_type(profile)])).
test(fixture_non_attribute_element) :-
    subject_profile(non_attribute_element, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, [wrong_type(profile)]),
    jurisdiction_basis(Profile, input_problems([wrong_type(profile)]), []).
test(status_projection_agrees_with_the_verdict) :-
    subject_profile(provider_outside_union_offering_no_services, Profile),
    nis2_jurisdiction_registration_status(Profile, no_single_member_state_jurisdiction),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(no_single_member_state_jurisdiction, [_|_])).

test(public_electronic_communications_provider_is_not_main_establishment, fail) :-
    jurisdiction_basis([attribute(entity_category, public_electronic_communications_provider)], state_of_main_establishment, _).
test(public_administration_entity_is_not_state_of_establishment, fail) :-
    jurisdiction_basis([attribute(entity_category, public_administration_entity)], state_of_establishment, _).
test(the_referral_omits_the_unscored_provenance_element, fail) :-
    subject_profile(provider_established_decisions_unsure_operations_false, Profile),
    main_establishment_rule(Profile, needs_legal_review(_, [_, provenance(_, _)]), _).
test(general_entity_settled_is_not_open, fail) :-
    subject_status(general_entity_settled, registration_position_open).
test(member_states_list_absent_control_is_not_settled, fail) :-
    subject_status(general_entity_member_states_list_absent, registration_position_settled).
test(category_absent_control_is_not_settled, fail) :-
    subject_status(category_absent, registration_position_settled).
test(decisions_unsure_control_is_not_settled, fail) :-
    subject_status(provider_established_decisions_unsure_operations_false, registration_position_settled).
test(operations_unsure_control_is_not_settled, fail) :-
    subject_status(provider_established_decisions_false_operations_unsure, registration_position_settled).
test(established_key_absent_control_is_not_settled, fail) :-
    subject_status(provider_established_key_absent, registration_position_settled).
test(without_representative_control_is_not_settled, fail) :-
    subject_status(provider_outside_union_without_representative, registration_position_settled).
test(no_services_control_is_not_open, fail) :-
    subject_status(provider_outside_union_offering_no_services, registration_position_open).
test(fixture_basis_without_representative_is_not_representative, fail) :-
    subject_profile(provider_outside_union_without_representative, Profile),
    jurisdiction_basis(Profile, state_of_representative, _).
test(fixture_main_establishment_operations_step_is_not_employees, fail) :-
    subject_profile(provider_established_decisions_false_operations_true, Profile),
    main_establishment_rule(Profile, state_of_establishment_with_most_employees_in_the_union, _).
test(fixture_limits_general_entity_has_no_registry_limit, fail) :-
    subject_profile(general_entity_settled, Profile),
    change_notification_limits(Profile, [limit(registry_information, _, _)|_]).
test(fixture_unknown_keys_give_no_basis, fail) :-
    subject_profile(unknown_keys_repeated, Profile),
    jurisdiction_basis(Profile, state_of_establishment, _).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_has_exactly_one_verdict, every_subject_has_a_non_empty_checklist, every_query_answers_every_subject_exactly_once, every_status_is_in_the_vocabulary, every_subject_is_resolvable, public_electronic_communications_provider_category_gives_its_basis, public_administration_entity_category_gives_its_basis, provenance_element_builds_and_destructures, settled_checklist_rows_are_all_cited, open_checklist_rows_are_all_cited, settled_verdict_cites_the_main_establishment_rule, rejected_verdict_has_no_citations, general_entity_settled_is_settled, member_states_list_absent_control_is_open, decisions_determined_is_settled, with_representative_is_settled, without_representative_control_has_no_single_state, representative_key_absent_control_is_open, no_services_control_has_no_single_state, unsure_decisions_are_handed_to_the_user_on_the_checklist, unsure_decisions_with_absent_operations_name_the_operations_key, fixture_basis_general_entity, fixture_basis_communications_provider, fixture_basis_public_administration, fixture_basis_category_absent, fixture_basis_main_establishment, fixture_basis_established_key_absent, fixture_basis_representative, fixture_basis_without_representative, fixture_basis_representative_key_absent, fixture_basis_no_services, fixture_main_establishment_decisions_step, fixture_main_establishment_referral_on_decisions, fixture_main_establishment_operations_named_before_referral, fixture_main_establishment_referral_on_operations, fixture_main_establishment_employees_step, fixture_main_establishment_operations_step, fixture_registry_established_provider, fixture_registry_with_representative, fixture_registry_without_representative_has_no_address, fixture_registry_not_owed_by_general_entity, fixture_registry_category_absent, fixture_registry_established_key_absent, fixture_registry_representative_key_absent, fixture_entity_list_full, fixture_entity_list_without_sector, fixture_entity_list_minimal, fixture_entity_list_member_states_key_absent, fixture_entity_list_does_not_read_the_category, fixture_limits_provider, fixture_limits_general_entity, fixture_limits_category_absent, fixture_clean_profile_has_no_problems, fixture_duplicate_and_wrong_type_problems, fixture_duplicate_and_wrong_type_reaches_every_query, fixture_unknown_keys_once_each_in_first_occurrence_order, fixture_crisp_key_given_unsure, fixture_not_an_attribute_list, fixture_non_attribute_element, status_projection_agrees_with_the_verdict]).
cp_test_fail_names([public_electronic_communications_provider_is_not_main_establishment, public_administration_entity_is_not_state_of_establishment, the_referral_omits_the_unscored_provenance_element, general_entity_settled_is_not_open, member_states_list_absent_control_is_not_settled, category_absent_control_is_not_settled, decisions_unsure_control_is_not_settled, operations_unsure_control_is_not_settled, established_key_absent_control_is_not_settled, without_representative_control_is_not_settled, no_services_control_is_not_open, fixture_basis_without_representative_is_not_representative, fixture_main_establishment_operations_step_is_not_employees, fixture_limits_general_entity_has_no_registry_limit, fixture_unknown_keys_give_no_basis]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
