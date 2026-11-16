% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3, binding_corporate_rules_content_checklist/2, decide_gdpr_binding_corporate_rules/2, gdpr_binding_corporate_rules_status/2, gdpr_binding_corporate_rules_checklist/2, gdpr_binding_corporate_rules_decision_resolvable/1, gdpr_binding_corporate_rules_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_subject/1, gdpr_binding_corporate_rules_profile_for/2, gdpr_binding_corporate_rules_assess/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_queries, [gdpr_binding_corporate_rules_what_if/4]).

definition_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_definition(Profile, Result, Citations), Answers).

content_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_content(Profile, Result, Citations), Answers).

checklist_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Items, binding_corporate_rules_content_checklist(Profile, Items), Answers).

problem_answers(Subject, Answers) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers).

item_in_state(State, checklist_item(_, _, State)).

keys_in_state(Items, State, Keys) :-
    findall(Key, member(checklist_item(Key, _, State), Items), Keys).

assessed_once(Subject) :-
    findall(Verdict, gdpr_binding_corporate_rules_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

resolvable(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    gdpr_binding_corporate_rules_decision_resolvable(Profile).

complete_content_citations([cite(eu_reg_2016_679_art_47_2), cite(eu_reg_2016_679_art_47_2_a), cite(eu_reg_2016_679_art_47_2_b), cite(eu_reg_2016_679_art_47_2_c), cite(eu_reg_2016_679_art_47_2_d), cite(eu_reg_2016_679_art_47_2_e), cite(eu_reg_2016_679_art_47_2_f), cite(eu_reg_2016_679_art_47_2_g), cite(eu_reg_2016_679_art_47_2_h), cite(eu_reg_2016_679_art_47_2_i), cite(eu_reg_2016_679_art_47_2_j), cite(eu_reg_2016_679_art_47_2_k), cite(eu_reg_2016_679_art_47_2_l), cite(eu_reg_2016_679_art_47_2_m), cite(eu_reg_2016_679_art_47_2_n)]).

test(all_elements_hold_gives_binding_corporate_rules) :-
    definition_answers(all_elements_and_points_hold, Answers),
    Answers == [binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(transfers_inside_union_only_are_not_binding_corporate_rules) :-
    definition_answers(transfers_inside_union_only, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(an_adhering_party_not_established_defeats_the_definition) :-
    definition_answers(adhering_party_not_established, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(a_false_element_decides_before_absent_keys) :-
    definition_answers(false_element_beats_absent_keys, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(the_first_absent_element_is_named_while_a_judgement_is_unsure) :-
    definition_answers(first_absent_element_named_while_role_unsure, Answers),
    Answers == [indeterminate([adhering_party_established_on_territory_of_member_state]) - []].
test(an_unsure_adhering_party_role_goes_to_a_lawyer) :-
    definition_answers(adhering_party_role_unsure, Answers),
    Answers == [needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - unsure, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - true])]) - []].
test(a_denied_adhering_party_role_defeats_the_definition) :-
    definition_answers(adhering_party_role_denied, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(an_unsure_recipient_role_goes_to_a_lawyer) :-
    definition_answers(recipient_role_unsure, Answers),
    Answers == [needs_legal_review(open_textured(recipients_are_controllers_or_processors, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - true, recipients_are_controllers_or_processors - unsure, transfers_within_group_of_undertakings_or_group_of_enterprises - true])]) - []].
test(a_denied_recipient_role_defeats_the_definition) :-
    definition_answers(recipient_role_denied, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(an_unsure_group_membership_goes_to_a_lawyer) :-
    definition_answers(group_membership_unsure, Answers),
    Answers == [needs_legal_review(open_textured(transfers_within_group_of_undertakings_or_group_of_enterprises, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - true, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure])]) - []].
test(a_denied_group_membership_defeats_the_definition) :-
    definition_answers(group_membership_denied, Answers),
    Answers == [not_binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(with_two_judgements_unsure_the_first_is_referred) :-
    definition_answers(two_judgements_unsure, Answers),
    Answers == [needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - unsure, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure])]) - []].
test(the_definition_keys_alone_give_binding_corporate_rules) :-
    definition_answers(definition_keys_only, Answers),
    Answers == [binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(the_content_keys_alone_leave_the_definition_open) :-
    definition_answers(content_keys_only, Answers),
    Answers == [indeterminate([policies_are_personal_data_protection_policies]) - []].
test(an_empty_profile_names_the_first_element) :-
    definition_answers(empty_profile, Answers),
    Answers == [indeterminate([policies_are_personal_data_protection_policies]) - []].
test(a_false_point_does_not_change_the_definition) :-
    definition_answers(principles_point_covered_in_part, Answers),
    Answers == [binding_corporate_rules - [cite(eu_reg_2016_679_art_4_20)]].
test(all_points_give_complete_content) :-
    content_answers(all_elements_and_points_hold, Answers),
    complete_content_citations(Citations),
    Answers == [content_complete - Citations].
test(a_false_element_does_not_change_the_content) :-
    content_answers(transfers_inside_union_only, Answers),
    complete_content_citations(Citations),
    Answers == [content_complete - Citations].
test(a_point_covered_in_part_gives_incomplete_content) :-
    content_answers(principles_point_covered_in_part, Answers),
    Answers == [content_incomplete - [cite(eu_reg_2016_679_art_47_2)]].
test(a_false_point_decides_before_absent_points) :-
    content_answers(false_point_beats_absent_points, Answers),
    Answers == [content_incomplete - [cite(eu_reg_2016_679_art_47_2)]].
test(the_first_absent_point_is_named_while_training_is_unsure) :-
    content_answers(first_absent_point_named_while_training_unsure, Answers),
    Answers == [indeterminate([rules_specify_legally_binding_nature]) - []].
test(unsure_training_goes_to_a_lawyer) :-
    content_answers(training_appropriateness_unsure, Answers),
    Answers == [needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]) - []].
test(training_not_appropriate_gives_incomplete_content) :-
    content_answers(training_not_appropriate, Answers),
    Answers == [content_incomplete - [cite(eu_reg_2016_679_art_47_2)]].
test(the_definition_keys_alone_leave_the_content_open) :-
    content_answers(definition_keys_only, Answers),
    Answers == [indeterminate([rules_specify_group_structure_and_contact_details]) - []].
test(the_content_keys_alone_give_complete_content) :-
    content_answers(content_keys_only, Answers),
    complete_content_citations(Citations),
    Answers == [content_complete - Citations].
test(an_empty_profile_names_the_first_point) :-
    content_answers(empty_profile, Answers),
    Answers == [indeterminate([rules_specify_group_structure_and_contact_details]) - []].
test(all_points_give_fourteen_met_items) :-
    checklist_answers(all_elements_and_points_hold, [Items]),
    length(Items, 14),
    maplist(item_in_state(met), Items),
    Items = [checklist_item(rules_specify_group_structure_and_contact_details, cite(eu_reg_2016_679_art_47_2_a), met)|_].
test(a_point_covered_in_part_is_the_one_unmet_item) :-
    checklist_answers(principles_point_covered_in_part, [Items]),
    length(Items, 14),
    keys_in_state(Items, unmet, UnmetKeys),
    UnmetKeys == [rules_specify_application_of_general_data_protection_principles],
    member(checklist_item(rules_specify_application_of_general_data_protection_principles, cite(eu_reg_2016_679_art_47_2_d), unmet), Items).
test(the_checklist_shows_false_and_absent_points) :-
    checklist_answers(false_point_beats_absent_points, [Items]),
    keys_in_state(Items, unmet, UnmetKeys),
    UnmetKeys == [rules_specify_acceptance_of_liability_for_members_outside_union],
    keys_in_state(Items, open_by_absence, AbsentKeys),
    AbsentKeys == [rules_specify_group_structure_and_contact_details, rules_specify_data_transfers].
test(the_checklist_shows_an_absent_point_and_unsure_training) :-
    checklist_answers(first_absent_point_named_while_training_unsure, [Items]),
    keys_in_state(Items, open_by_absence, AbsentKeys),
    AbsentKeys == [rules_specify_legally_binding_nature],
    member(checklist_item(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n), open_by_judgement), Items).
test(training_not_appropriate_is_unmet_in_the_checklist) :-
    checklist_answers(training_not_appropriate, [Items]),
    member(checklist_item(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n), unmet), Items).
test(the_definition_keys_alone_leave_every_point_open) :-
    checklist_answers(definition_keys_only, [Items]),
    length(Items, 14),
    maplist(item_in_state(open_by_absence), Items).
test(a_well_formed_single_key_has_no_problem) :-
    problem_answers(input_well_formed_single_key, Answers),
    Answers == [[]],
    definition_answers(input_well_formed_single_key, DefinitionAnswers),
    DefinitionAnswers == [indeterminate([policies_adhered_to_by_adhering_party]) - []].
test(a_crisp_key_unsure_is_a_wrong_type) :-
    problem_answers(input_crisp_key_unsure, Answers),
    Answers == [[wrong_type(policies_are_personal_data_protection_policies)]],
    definition_answers(input_crisp_key_unsure, DefinitionAnswers),
    DefinitionAnswers == [input_problems([wrong_type(policies_are_personal_data_protection_policies)]) - []].
test(an_attested_judgement_is_a_wrong_type) :-
    problem_answers(input_attested_judgement, Answers),
    Answers == [[wrong_type(adhering_party_is_controller_or_processor)]].
test(a_repeated_key_is_a_duplicate_only) :-
    problem_answers(input_duplicate_key, Answers),
    Answers == [[duplicate_key(rules_specify_complaint_procedures)]],
    content_answers(input_duplicate_key, ContentAnswers),
    ContentAnswers == [input_problems([duplicate_key(rules_specify_complaint_procedures)]) - []],
    checklist_answers(input_duplicate_key, ChecklistAnswers),
    ChecklistAnswers == [input_problems([duplicate_key(rules_specify_complaint_procedures)])].
test(an_unknown_key_twice_is_named_once) :-
    problem_answers(input_unknown_key_twice, Answers),
    Answers == [[unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_a_wrong_profile) :-
    problem_answers(input_not_a_list, Answers),
    Answers == [[wrong_type(profile)]],
    definition_answers(input_not_a_list, DefinitionAnswers),
    DefinitionAnswers == [input_problems([wrong_type(profile)]) - []].
test(an_element_that_is_not_an_attribute_is_a_wrong_profile) :-
    problem_answers(input_element_not_attribute, Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_a_wrong_profile) :-
    problem_answers(input_partial_list, Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_a_wrong_type) :-
    problem_answers(input_unbound_value, Answers),
    Answers == [[wrong_type(rules_specify_complaint_procedures)]].
test(mixed_problems_follow_the_contract_order_then_first_occurrence) :-
    problem_answers(input_mixed_problems, Answers),
    Answers == [[wrong_type(policies_are_personal_data_protection_policies), duplicate_key(adhering_party_is_controller_or_processor), wrong_type(rules_specify_data_transfers), unknown_key(colour), unknown_key(shade)]].
test(every_subject_is_assessed_exactly_once) :-
    findall(Subject, gdpr_binding_corporate_rules_subject(Subject), Subjects),
    maplist(assessed_once, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_binding_corporate_rules_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(the_assessment_wraps_the_definition) :-
    gdpr_binding_corporate_rules_assess(all_elements_and_points_hold, gdpr_binding_corporate_rules_verdict(Status, Citations)),
    Status == binding_corporate_rules,
    Citations == [cite(eu_reg_2016_679_art_4_20)],
    gdpr_binding_corporate_rules_status_values(StatusValues),
    member(Status, StatusValues).
test(the_near_miss_assessment_is_not_binding_corporate_rules) :-
    gdpr_binding_corporate_rules_assess(transfers_inside_union_only, gdpr_binding_corporate_rules_verdict(Status, _Citations)),
    Status == not_binding_corporate_rules.
test(the_status_projects_the_definition) :-
    gdpr_binding_corporate_rules_profile_for(recipient_role_denied, Profile),
    gdpr_binding_corporate_rules_status(Profile, Status),
    Status == not_binding_corporate_rules.
test(the_decision_matches_the_definition_query) :-
    gdpr_binding_corporate_rules_profile_for(group_membership_unsure, Profile),
    decide_gdpr_binding_corporate_rules(Profile, gdpr_binding_corporate_rules_verdict(Status, Citations)),
    binding_corporate_rules_definition(Profile, Status, Citations).
test(the_facade_checklist_is_non_empty_with_provenance) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    gdpr_binding_corporate_rules_checklist(Profile, Items),
    length(Items, 7),
    Items = [item(policies_are_personal_data_protection_policies, met, cite(eu_reg_2016_679_art_4_20))|_].
test(what_if_third_country_transfers_flips_the_near_miss) :-
    gdpr_binding_corporate_rules_profile_for(transfers_inside_union_only, Profile),
    findall(Verdict, gdpr_binding_corporate_rules_what_if(Profile, policies_cover_transfers_to_third_countries, true, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)])].
test(what_if_training_appropriate_completes_the_content) :-
    gdpr_binding_corporate_rules_profile_for(training_appropriateness_unsure, Profile),
    complete_content_citations(Citations),
    findall(Verdict, gdpr_binding_corporate_rules_what_if(Profile, rules_specify_appropriate_data_protection_training, true, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(content_complete, Citations)].
test(what_if_an_unknown_key_is_an_input_problem) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    findall(Verdict, gdpr_binding_corporate_rules_what_if(Profile, colour, red, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(input_problems([unknown_key(colour)]), [])].

test(all_elements_hold_is_not_not_binding_corporate_rules, fail) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    binding_corporate_rules_definition(Profile, not_binding_corporate_rules, _).
test(transfers_inside_union_only_are_not_binding_corporate_rules_positive_absent, fail) :-
    gdpr_binding_corporate_rules_profile_for(transfers_inside_union_only, Profile),
    binding_corporate_rules_definition(Profile, binding_corporate_rules, _).
test(an_unsure_adhering_party_role_is_not_binding_corporate_rules, fail) :-
    gdpr_binding_corporate_rules_profile_for(adhering_party_role_unsure, Profile),
    binding_corporate_rules_definition(Profile, binding_corporate_rules, _).
test(all_points_are_not_incomplete, fail) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    binding_corporate_rules_content(Profile, content_incomplete, _).
test(a_point_covered_in_part_is_not_complete, fail) :-
    gdpr_binding_corporate_rules_profile_for(principles_point_covered_in_part, Profile),
    binding_corporate_rules_content(Profile, content_complete, _).
test(unsure_training_is_not_complete, fail) :-
    gdpr_binding_corporate_rules_profile_for(training_appropriateness_unsure, Profile),
    binding_corporate_rules_content(Profile, content_complete, _).
test(an_input_problem_gets_no_final_answer, fail) :-
    gdpr_binding_corporate_rules_profile_for(input_crisp_key_unsure, Profile),
    binding_corporate_rules_definition(Profile, not_binding_corporate_rules, _).

cp_test_names([all_elements_hold_gives_binding_corporate_rules, transfers_inside_union_only_are_not_binding_corporate_rules, an_adhering_party_not_established_defeats_the_definition, a_false_element_decides_before_absent_keys, the_first_absent_element_is_named_while_a_judgement_is_unsure, an_unsure_adhering_party_role_goes_to_a_lawyer, a_denied_adhering_party_role_defeats_the_definition, an_unsure_recipient_role_goes_to_a_lawyer, a_denied_recipient_role_defeats_the_definition, an_unsure_group_membership_goes_to_a_lawyer, a_denied_group_membership_defeats_the_definition, with_two_judgements_unsure_the_first_is_referred, the_definition_keys_alone_give_binding_corporate_rules, the_content_keys_alone_leave_the_definition_open, an_empty_profile_names_the_first_element, a_false_point_does_not_change_the_definition, all_points_give_complete_content, a_false_element_does_not_change_the_content, a_point_covered_in_part_gives_incomplete_content, a_false_point_decides_before_absent_points, the_first_absent_point_is_named_while_training_is_unsure, unsure_training_goes_to_a_lawyer, training_not_appropriate_gives_incomplete_content, the_definition_keys_alone_leave_the_content_open, the_content_keys_alone_give_complete_content, an_empty_profile_names_the_first_point, all_points_give_fourteen_met_items, a_point_covered_in_part_is_the_one_unmet_item, the_checklist_shows_false_and_absent_points, the_checklist_shows_an_absent_point_and_unsure_training, training_not_appropriate_is_unmet_in_the_checklist, the_definition_keys_alone_leave_every_point_open, a_well_formed_single_key_has_no_problem, a_crisp_key_unsure_is_a_wrong_type, an_attested_judgement_is_a_wrong_type, a_repeated_key_is_a_duplicate_only, an_unknown_key_twice_is_named_once, a_term_that_is_not_a_list_is_a_wrong_profile, an_element_that_is_not_an_attribute_is_a_wrong_profile, a_partial_list_is_a_wrong_profile, an_unbound_value_is_a_wrong_type, mixed_problems_follow_the_contract_order_then_first_occurrence, every_subject_is_assessed_exactly_once, every_subject_is_resolvable, the_assessment_wraps_the_definition, the_near_miss_assessment_is_not_binding_corporate_rules, the_status_projects_the_definition, the_decision_matches_the_definition_query, the_facade_checklist_is_non_empty_with_provenance, what_if_third_country_transfers_flips_the_near_miss, what_if_training_appropriate_completes_the_content, what_if_an_unknown_key_is_an_input_problem]).
cp_test_fail_names([all_elements_hold_is_not_not_binding_corporate_rules, transfers_inside_union_only_are_not_binding_corporate_rules_positive_absent, an_unsure_adhering_party_role_is_not_binding_corporate_rules, all_points_are_not_incomplete, a_point_covered_in_part_is_not_complete, unsure_training_is_not_complete, an_input_problem_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
