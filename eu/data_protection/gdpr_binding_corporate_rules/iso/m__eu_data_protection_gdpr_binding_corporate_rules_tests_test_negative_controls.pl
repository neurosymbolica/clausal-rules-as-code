% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3, binding_corporate_rules_content_checklist/2, gdpr_binding_corporate_rules_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_profile_for/2]).

definition_of(Subject, Result) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    binding_corporate_rules_definition(Profile, Result, _).

content_of(Subject, Result) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    binding_corporate_rules_content(Profile, Result, _).

test(the_status_table_holds_both_definition_atoms) :-
    gdpr_binding_corporate_rules_status_values(StatusValues),
    StatusValues == [binding_corporate_rules, not_binding_corporate_rules].
test(route_binding_positive) :-
    definition_of(all_elements_and_points_hold, binding_corporate_rules).
test(route_binding_near_miss_transfers_inside_union) :-
    definition_of(transfers_inside_union_only, not_binding_corporate_rules).
test(route_not_binding_positive_role_denied) :-
    definition_of(adhering_party_role_denied, not_binding_corporate_rules).
test(route_not_binding_near_miss_role_unsure) :-
    definition_of(adhering_party_role_unsure, needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on(_)])).
test(route_not_binding_positive_group_denied) :-
    definition_of(group_membership_denied, not_binding_corporate_rules).
test(route_definition_indeterminate_positive) :-
    definition_of(empty_profile, indeterminate([policies_are_personal_data_protection_policies])).
test(route_definition_indeterminate_near_miss_false_element) :-
    definition_of(false_element_beats_absent_keys, not_binding_corporate_rules).
test(route_definition_referral_positive) :-
    definition_of(recipient_role_unsure, needs_legal_review(open_textured(recipients_are_controllers_or_processors, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on(_)])).
test(route_definition_referral_near_miss_role_denied) :-
    definition_of(recipient_role_denied, not_binding_corporate_rules).
test(route_content_complete_positive) :-
    content_of(all_elements_and_points_hold, content_complete).
test(route_content_complete_near_miss_point_in_part) :-
    content_of(principles_point_covered_in_part, content_incomplete).
test(route_content_incomplete_positive_training_not_appropriate) :-
    content_of(training_not_appropriate, content_incomplete).
test(route_content_incomplete_near_miss_training_unsure) :-
    content_of(training_appropriateness_unsure, needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])])).
test(route_content_indeterminate_positive) :-
    content_of(first_absent_point_named_while_training_unsure, indeterminate([rules_specify_legally_binding_nature])).
test(route_content_indeterminate_near_miss_false_point) :-
    content_of(false_point_beats_absent_points, content_incomplete).
test(route_content_referral_positive) :-
    content_of(training_appropriateness_unsure, needs_legal_review(_, _)).
test(route_checklist_open_by_judgement_positive) :-
    gdpr_binding_corporate_rules_profile_for(training_appropriateness_unsure, Profile),
    binding_corporate_rules_content_checklist(Profile, Items),
    member(checklist_item(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n), open_by_judgement), Items).
test(route_checklist_open_by_judgement_near_miss_unmet) :-
    gdpr_binding_corporate_rules_profile_for(training_not_appropriate, Profile),
    binding_corporate_rules_content_checklist(Profile, Items),
    member(checklist_item(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n), unmet), Items).
test(route_checklist_open_by_absence_positive) :-
    gdpr_binding_corporate_rules_profile_for(definition_keys_only, Profile),
    binding_corporate_rules_content_checklist(Profile, [checklist_item(_, _, open_by_absence)|_]).
test(route_input_problems_positive) :-
    definition_of(input_crisp_key_unsure, input_problems([wrong_type(policies_are_personal_data_protection_policies)])).
test(route_input_problems_near_miss_well_formed) :-
    definition_of(input_well_formed_single_key, indeterminate([policies_adhered_to_by_adhering_party])).
test(route_input_problems_well_formed_check_is_empty) :-
    gdpr_binding_corporate_rules_profile_for(input_well_formed_single_key, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, []).
test(a_false_point_does_not_change_the_definition) :-
    definition_of(principles_point_covered_in_part, binding_corporate_rules).
test(a_false_element_does_not_change_the_content) :-
    content_of(transfers_inside_union_only, content_complete).

test(route_binding_near_miss_is_not_binding, fail) :-
    definition_of(transfers_inside_union_only, binding_corporate_rules).
test(route_not_binding_near_miss_is_not_not_binding, fail) :-
    definition_of(adhering_party_role_unsure, not_binding_corporate_rules).
test(route_not_binding_group_unsure_is_not_not_binding, fail) :-
    definition_of(group_membership_unsure, not_binding_corporate_rules).
test(route_definition_indeterminate_near_miss_is_not_indeterminate, fail) :-
    definition_of(false_element_beats_absent_keys, indeterminate(_)).
test(route_definition_absent_beats_unsure_is_not_a_referral, fail) :-
    definition_of(first_absent_element_named_while_role_unsure, needs_legal_review(_, _)).
test(route_definition_referral_near_miss_is_not_referred, fail) :-
    definition_of(recipient_role_denied, needs_legal_review(_, _)).
test(route_content_complete_near_miss_is_not_complete, fail) :-
    content_of(principles_point_covered_in_part, content_complete).
test(route_content_incomplete_near_miss_is_not_incomplete, fail) :-
    content_of(training_appropriateness_unsure, content_incomplete).
test(route_content_indeterminate_near_miss_is_not_indeterminate, fail) :-
    content_of(false_point_beats_absent_points, indeterminate(_)).
test(route_content_referral_near_miss_all_true_is_not_referred, fail) :-
    content_of(all_elements_and_points_hold, needs_legal_review(_, _)).
test(route_checklist_near_miss_is_not_open_by_judgement, fail) :-
    gdpr_binding_corporate_rules_profile_for(training_not_appropriate, Profile),
    binding_corporate_rules_content_checklist(Profile, Items),
    member(checklist_item(_, _, open_by_judgement), Items).
test(route_checklist_content_keys_have_no_absence, fail) :-
    gdpr_binding_corporate_rules_profile_for(content_keys_only, Profile),
    binding_corporate_rules_content_checklist(Profile, Items),
    member(checklist_item(_, _, open_by_absence), Items).
test(route_input_problems_near_miss_has_no_problems, fail) :-
    definition_of(input_well_formed_single_key, input_problems(_)).
test(route_input_problems_duplicate_is_never_also_wrong_type, fail) :-
    gdpr_binding_corporate_rules_profile_for(input_duplicate_key, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    member(wrong_type(_), Problems).

cp_test_names([the_status_table_holds_both_definition_atoms, route_binding_positive, route_binding_near_miss_transfers_inside_union, route_not_binding_positive_role_denied, route_not_binding_near_miss_role_unsure, route_not_binding_positive_group_denied, route_definition_indeterminate_positive, route_definition_indeterminate_near_miss_false_element, route_definition_referral_positive, route_definition_referral_near_miss_role_denied, route_content_complete_positive, route_content_complete_near_miss_point_in_part, route_content_incomplete_positive_training_not_appropriate, route_content_incomplete_near_miss_training_unsure, route_content_indeterminate_positive, route_content_indeterminate_near_miss_false_point, route_content_referral_positive, route_checklist_open_by_judgement_positive, route_checklist_open_by_judgement_near_miss_unmet, route_checklist_open_by_absence_positive, route_input_problems_positive, route_input_problems_near_miss_well_formed, route_input_problems_well_formed_check_is_empty, a_false_point_does_not_change_the_definition, a_false_element_does_not_change_the_content]).
cp_test_fail_names([route_binding_near_miss_is_not_binding, route_not_binding_near_miss_is_not_not_binding, route_not_binding_group_unsure_is_not_not_binding, route_definition_indeterminate_near_miss_is_not_indeterminate, route_definition_absent_beats_unsure_is_not_a_referral, route_definition_referral_near_miss_is_not_referred, route_content_complete_near_miss_is_not_complete, route_content_incomplete_near_miss_is_not_incomplete, route_content_indeterminate_near_miss_is_not_indeterminate, route_content_referral_near_miss_all_true_is_not_referred, route_checklist_near_miss_is_not_open_by_judgement, route_checklist_content_keys_have_no_absence, route_input_problems_near_miss_has_no_problems, route_input_problems_duplicate_is_never_also_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
