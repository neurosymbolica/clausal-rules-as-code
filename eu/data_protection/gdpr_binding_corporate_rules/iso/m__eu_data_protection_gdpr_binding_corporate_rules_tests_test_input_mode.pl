% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3, binding_corporate_rules_content_checklist/2, gdpr_binding_corporate_rules_status/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_profile_for/2]).

test(definition_holds_with_binding_corporate_rules_bound) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    binding_corporate_rules_definition(Profile, binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)]).
test(definition_holds_with_not_binding_bound) :-
    gdpr_binding_corporate_rules_profile_for(transfers_inside_union_only, Profile),
    binding_corporate_rules_definition(Profile, not_binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)]).
test(definition_holds_with_the_first_absent_element_bound) :-
    gdpr_binding_corporate_rules_profile_for(first_absent_element_named_while_role_unsure, Profile),
    binding_corporate_rules_definition(Profile, indeterminate([adhering_party_established_on_territory_of_member_state]), []).
test(definition_holds_with_the_referral_bound) :-
    gdpr_binding_corporate_rules_profile_for(group_membership_unsure, Profile),
    binding_corporate_rules_definition(Profile, needs_legal_review(open_textured(transfers_within_group_of_undertakings_or_group_of_enterprises, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor - true, recipients_are_controllers_or_processors - true, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure])]), []).
test(content_holds_with_content_complete_bound) :-
    gdpr_binding_corporate_rules_profile_for(content_keys_only, Profile),
    binding_corporate_rules_content(Profile, content_complete, [cite(eu_reg_2016_679_art_47_2)|_]).
test(content_holds_with_content_incomplete_bound) :-
    gdpr_binding_corporate_rules_profile_for(false_point_beats_absent_points, Profile),
    binding_corporate_rules_content(Profile, content_incomplete, [cite(eu_reg_2016_679_art_47_2)]).
test(content_holds_with_the_first_absent_point_bound) :-
    gdpr_binding_corporate_rules_profile_for(first_absent_point_named_while_training_unsure, Profile),
    binding_corporate_rules_content(Profile, indeterminate([rules_specify_legally_binding_nature]), []).
test(content_holds_with_the_training_referral_bound) :-
    gdpr_binding_corporate_rules_profile_for(training_appropriateness_unsure, Profile),
    binding_corporate_rules_content(Profile, needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]), []).
test(checklist_holds_with_its_first_item_bound) :-
    gdpr_binding_corporate_rules_profile_for(training_not_appropriate, Profile),
    binding_corporate_rules_content_checklist(Profile, [checklist_item(rules_specify_group_structure_and_contact_details, cite(eu_reg_2016_679_art_47_2_a), met)|_]).
test(input_problems_hold_with_the_full_list_bound) :-
    gdpr_binding_corporate_rules_profile_for(input_mixed_problems, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, [wrong_type(policies_are_personal_data_protection_policies), duplicate_key(adhering_party_is_controller_or_processor), wrong_type(rules_specify_data_transfers), unknown_key(colour), unknown_key(shade)]).
test(status_projection_holds_with_the_status_bound) :-
    gdpr_binding_corporate_rules_profile_for(recipient_role_denied, Profile),
    gdpr_binding_corporate_rules_status(Profile, not_binding_corporate_rules).
test(a_term_that_is_not_a_list_is_wrong_type) :-
    gdpr_binding_corporate_rules_input_problems(nothing, [wrong_type(profile)]).
test(a_term_that_is_not_a_list_gets_input_problems_from_every_query) :-
    binding_corporate_rules_definition(nothing, input_problems([wrong_type(profile)]), []),
    binding_corporate_rules_content(nothing, input_problems([wrong_type(profile)]), []),
    binding_corporate_rules_content_checklist(nothing, input_problems([wrong_type(profile)])).
test(an_improper_list_is_wrong_type) :-
    gdpr_binding_corporate_rules_input_problems([attribute(policies_are_personal_data_protection_policies, true)|tail], [wrong_type(profile)]).
test(an_element_that_is_not_an_attribute_is_wrong_type) :-
    gdpr_binding_corporate_rules_profile_for(input_element_not_attribute, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, [wrong_type(profile)]).
test(a_number_key_is_an_unknown_key) :-
    gdpr_binding_corporate_rules_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_named_as_given) :-
    gdpr_binding_corporate_rules_input_problems([attribute(colour(red), true)], [unknown_key(colour(red))]).
test(a_compound_value_is_wrong_type) :-
    gdpr_binding_corporate_rules_input_problems([attribute(rules_specify_complaint_procedures, maybe(true))], [wrong_type(rules_specify_complaint_procedures)]).
test(a_number_value_is_wrong_type) :-
    gdpr_binding_corporate_rules_input_problems([attribute(rules_specify_data_transfers, 1)], [wrong_type(rules_specify_data_transfers)]).
test(an_attested_value_is_wrong_type) :-
    gdpr_binding_corporate_rules_profile_for(input_attested_judgement, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, [wrong_type(adhering_party_is_controller_or_processor)]).
test(unsure_on_a_judgement_is_well_formed) :-
    gdpr_binding_corporate_rules_input_problems([attribute(recipients_are_controllers_or_processors, unsure)], []).
test(absence_is_not_a_problem) :-
    gdpr_binding_corporate_rules_input_problems([], []).

test(definition_rejects_not_binding_bound_when_all_elements_hold, fail) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    binding_corporate_rules_definition(Profile, not_binding_corporate_rules, _).
test(definition_rejects_binding_bound_for_transfers_inside_the_union, fail) :-
    gdpr_binding_corporate_rules_profile_for(transfers_inside_union_only, Profile),
    binding_corporate_rules_definition(Profile, binding_corporate_rules, _).
test(definition_rejects_a_later_absent_element_bound, fail) :-
    gdpr_binding_corporate_rules_profile_for(first_absent_element_named_while_role_unsure, Profile),
    binding_corporate_rules_definition(Profile, indeterminate([recipients_are_controllers_or_processors]), _).
test(content_rejects_content_complete_bound_on_a_false_point, fail) :-
    gdpr_binding_corporate_rules_profile_for(false_point_beats_absent_points, Profile),
    binding_corporate_rules_content(Profile, content_complete, _).
test(checklist_rejects_a_wrong_first_state_bound, fail) :-
    gdpr_binding_corporate_rules_profile_for(training_not_appropriate, Profile),
    binding_corporate_rules_content_checklist(Profile, [checklist_item(rules_specify_group_structure_and_contact_details, cite(eu_reg_2016_679_art_47_2_a), unmet)|_]).

cp_test_names([definition_holds_with_binding_corporate_rules_bound, definition_holds_with_not_binding_bound, definition_holds_with_the_first_absent_element_bound, definition_holds_with_the_referral_bound, content_holds_with_content_complete_bound, content_holds_with_content_incomplete_bound, content_holds_with_the_first_absent_point_bound, content_holds_with_the_training_referral_bound, checklist_holds_with_its_first_item_bound, input_problems_hold_with_the_full_list_bound, status_projection_holds_with_the_status_bound, a_term_that_is_not_a_list_is_wrong_type, a_term_that_is_not_a_list_gets_input_problems_from_every_query, an_improper_list_is_wrong_type, an_element_that_is_not_an_attribute_is_wrong_type, a_number_key_is_an_unknown_key, a_compound_key_is_named_as_given, a_compound_value_is_wrong_type, a_number_value_is_wrong_type, an_attested_value_is_wrong_type, unsure_on_a_judgement_is_well_formed, absence_is_not_a_problem]).
cp_test_fail_names([definition_rejects_not_binding_bound_when_all_elements_hold, definition_rejects_binding_bound_for_transfers_inside_the_union, definition_rejects_a_later_absent_element_bound, content_rejects_content_complete_bound_on_a_false_point, checklist_rejects_a_wrong_first_state_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
