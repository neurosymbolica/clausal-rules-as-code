% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3, binding_corporate_rules_content_checklist/2, decide_gdpr_binding_corporate_rules/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_profile_for/2]).

complete_citations([cite(eu_reg_2016_679_art_47_2), cite(eu_reg_2016_679_art_47_2_a), cite(eu_reg_2016_679_art_47_2_b), cite(eu_reg_2016_679_art_47_2_c), cite(eu_reg_2016_679_art_47_2_d), cite(eu_reg_2016_679_art_47_2_e), cite(eu_reg_2016_679_art_47_2_f), cite(eu_reg_2016_679_art_47_2_g), cite(eu_reg_2016_679_art_47_2_h), cite(eu_reg_2016_679_art_47_2_i), cite(eu_reg_2016_679_art_47_2_j), cite(eu_reg_2016_679_art_47_2_k), cite(eu_reg_2016_679_art_47_2_l), cite(eu_reg_2016_679_art_47_2_m), cite(eu_reg_2016_679_art_47_2_n)]).

point_keys([rules_specify_group_structure_and_contact_details, rules_specify_data_transfers, rules_specify_legally_binding_nature, rules_specify_application_of_general_data_protection_principles, rules_specify_data_subject_rights_and_means_to_exercise_them, rules_specify_acceptance_of_liability_for_members_outside_union, rules_specify_how_information_is_provided_to_data_subjects, rules_specify_tasks_of_compliance_monitoring_persons, rules_specify_complaint_procedures, rules_specify_compliance_verification_mechanisms, rules_specify_change_reporting_and_recording_mechanisms, rules_specify_cooperation_mechanism_with_supervisory_authority, rules_specify_reporting_of_third_country_legal_requirements, rules_specify_appropriate_data_protection_training]).

definition_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_definition(Profile, Result, Citations), Answers).

content_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_content(Profile, Result, Citations), Answers).

checklist_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Items, binding_corporate_rules_content_checklist(Profile, Items), Answers).

item_key(checklist_item(Key, _, _), Key).

item_state(checklist_item(_, _, State), State).

test(all_elements_give_binding_corporate_rules) :-
    definition_answers(all_elements_and_points_hold, Answers),
    Answers == [binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(an_adhering_party_not_established_gives_not_binding) :-
    definition_answers(adhering_party_not_established, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(a_false_element_beats_absent_keys) :-
    definition_answers(false_element_beats_absent_keys, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(the_first_absent_element_is_named_while_a_role_is_unsure) :-
    definition_answers(first_absent_element_named_while_role_unsure, Answers),
    Answers == [indeterminate([adhering_party_established_on_territory_of_member_state]) - []].
test(an_unsure_adhering_party_role_is_referred) :-
    definition_answers(adhering_party_role_unsure, Answers),
    Answers == [needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - unsure, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - true])]) - []].
test(two_unsure_judgements_refer_the_first) :-
    definition_answers(two_judgements_unsure, Answers),
    Answers == [needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - unsure, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure])]) - []].
test(an_unsure_group_membership_is_referred) :-
    definition_answers(group_membership_unsure, Answers),
    Answers == [needs_legal_review(open_textured(transfers_within_group_of_undertakings_or_group_of_enterprises, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - true, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure])]) - []].
test(content_keys_only_name_the_first_definition_key) :-
    definition_answers(content_keys_only, Answers),
    Answers == [indeterminate([policies_are_personal_data_protection_policies]) - []].
test(a_single_key_profile_names_the_next_key) :-
    definition_answers(input_well_formed_single_key, Answers),
    Answers == [indeterminate([policies_adhered_to_by_adhering_party]) - []].
test(an_input_problem_is_the_only_definition_answer) :-
    definition_answers(input_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(rules_specify_complaint_procedures)]) - []].
test(all_points_give_content_complete_with_fifteen_citations) :-
    content_answers(all_elements_and_points_hold, Answers),
    complete_citations(Citations),
    Answers == [content_complete - Citations].
test(a_point_covered_in_part_gives_content_incomplete) :-
    content_answers(principles_point_covered_in_part, Answers),
    Answers == [content_incomplete - [cite(eu_reg_2016_679_art_47_2)]].
test(training_not_appropriate_gives_content_incomplete) :-
    content_answers(training_not_appropriate, Answers),
    Answers == [content_incomplete - [cite(eu_reg_2016_679_art_47_2)]].
test(the_first_absent_point_is_named_while_training_is_unsure) :-
    content_answers(first_absent_point_named_while_training_unsure, Answers),
    Answers == [indeterminate([rules_specify_legally_binding_nature]) - []].
test(unsure_training_is_referred) :-
    content_answers(training_appropriateness_unsure, Answers),
    Answers == [needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]) - []].
test(an_empty_profile_names_point_a) :-
    content_answers(empty_profile, Answers),
    Answers == [indeterminate([rules_specify_group_structure_and_contact_details]) - []].
test(the_checklist_lists_every_point_in_order_all_met) :-
    checklist_answers(all_elements_and_points_hold, [Items]),
    point_keys(Keys),
    maplist(item_key, Items, ItemKeys),
    ItemKeys == Keys,
    maplist(item_state, Items, States),
    maplist(==(met), States).
test(the_checklist_of_an_empty_profile_is_open_by_absence) :-
    checklist_answers(empty_profile, [Items]),
    length(Items, 14),
    maplist(item_state, Items, States),
    maplist(==(open_by_absence), States).
test(the_checklist_shows_absence_and_judgement_per_point) :-
    checklist_answers(first_absent_point_named_while_training_unsure, Answers),
    Answers == [[checklist_item(rules_specify_group_structure_and_contact_details, cite(eu_reg_2016_679_art_47_2_a), met), checklist_item(rules_specify_data_transfers, cite(eu_reg_2016_679_art_47_2_b), met), checklist_item(rules_specify_legally_binding_nature, cite(eu_reg_2016_679_art_47_2_c), open_by_absence), checklist_item(rules_specify_application_of_general_data_protection_principles, cite(eu_reg_2016_679_art_47_2_d), met), checklist_item(rules_specify_data_subject_rights_and_means_to_exercise_them, cite(eu_reg_2016_679_art_47_2_e), met), checklist_item(rules_specify_acceptance_of_liability_for_members_outside_union, cite(eu_reg_2016_679_art_47_2_f), met), checklist_item(rules_specify_how_information_is_provided_to_data_subjects, cite(eu_reg_2016_679_art_47_2_g), met), checklist_item(rules_specify_tasks_of_compliance_monitoring_persons, cite(eu_reg_2016_679_art_47_2_h), met), checklist_item(rules_specify_complaint_procedures, cite(eu_reg_2016_679_art_47_2_i), met), checklist_item(rules_specify_compliance_verification_mechanisms, cite(eu_reg_2016_679_art_47_2_j), met), checklist_item(rules_specify_change_reporting_and_recording_mechanisms, cite(eu_reg_2016_679_art_47_2_k), met), checklist_item(rules_specify_cooperation_mechanism_with_supervisory_authority, cite(eu_reg_2016_679_art_47_2_l), met), checklist_item(rules_specify_reporting_of_third_country_legal_requirements, cite(eu_reg_2016_679_art_47_2_m), met), checklist_item(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n), open_by_judgement)]].
test(the_checklist_marks_a_false_point_unmet) :-
    checklist_answers(principles_point_covered_in_part, [Items]),
    member(checklist_item(rules_specify_application_of_general_data_protection_principles, cite(eu_reg_2016_679_art_47_2_d), unmet), Items).
test(the_checklist_of_a_malformed_profile_is_its_input_problems) :-
    checklist_answers(input_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(rules_specify_complaint_procedures)])].
test(the_input_check_reads_out_the_problems_in_order) :-
    gdpr_binding_corporate_rules_profile_for(input_mixed_problems, Profile),
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(policies_are_personal_data_protection_policies), duplicate_key(adhering_party_is_controller_or_processor), wrong_type(rules_specify_data_transfers), unknown_key(colour), unknown_key(shade)]].
test(an_unknown_key_repeated_is_named_once) :-
    gdpr_binding_corporate_rules_profile_for(input_unknown_key_twice, Profile),
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(the_facade_verdict_carries_the_definition_citation) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    findall(Verdict, decide_gdpr_binding_corporate_rules(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)])].

cp_test_names([all_elements_give_binding_corporate_rules, an_adhering_party_not_established_gives_not_binding, a_false_element_beats_absent_keys, the_first_absent_element_is_named_while_a_role_is_unsure, an_unsure_adhering_party_role_is_referred, two_unsure_judgements_refer_the_first, an_unsure_group_membership_is_referred, content_keys_only_name_the_first_definition_key, a_single_key_profile_names_the_next_key, an_input_problem_is_the_only_definition_answer, all_points_give_content_complete_with_fifteen_citations, a_point_covered_in_part_gives_content_incomplete, training_not_appropriate_gives_content_incomplete, the_first_absent_point_is_named_while_training_is_unsure, unsure_training_is_referred, an_empty_profile_names_point_a, the_checklist_lists_every_point_in_order_all_met, the_checklist_of_an_empty_profile_is_open_by_absence, the_checklist_shows_absence_and_judgement_per_point, the_checklist_marks_a_false_point_unmet, the_checklist_of_a_malformed_profile_is_its_input_problems, the_input_check_reads_out_the_problems_in_order, an_unknown_key_repeated_is_named_once, the_facade_verdict_carries_the_definition_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
