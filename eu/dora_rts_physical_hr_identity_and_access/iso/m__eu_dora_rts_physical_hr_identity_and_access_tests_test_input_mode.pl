% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_dora_rts_physical_hr_identity_and_access, [physical_hr_identity_and_access_duties_required/3, physical_hr_identity_and_access_duties_complete/3, physical_hr_identity_and_access_duties_outstanding/3, dora_rts_physical_hr_identity_and_access_status/2, dora_rts_physical_hr_identity_and_access_status_values/1]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_kernel, [dora_rts_physical_hr_identity_and_access_input_problems/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_fixtures, [dora_rts_physical_hr_identity_and_access_profile_for/2]).

test(an_article_16_1_entity_is_bound_to_simplified_framework_entity) :-
    dora_rts_physical_hr_identity_and_access_profile_for(article_16_1_entity, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, simplified_framework_entity).
test(all_duties_performed_is_bound_to_complete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, complete).
test(one_duty_not_performed_is_bound_to_incomplete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, incomplete).
test(an_absent_gate_is_bound_to_indeterminate) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_absent, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(an_absent_duty_is_bound_to_indeterminate) :-
    dora_rts_physical_hr_identity_and_access_profile_for(first_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible])).
test(only_the_gate_given_asks_the_first_duty) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_only_false, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([physical_and_environmental_security_policy_specified_documented_and_implemented])).
test(an_unsure_duty_is_bound_to_needs_legal_review) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), [inputs_relied_on(_)])).
test(a_failing_duty_with_an_absent_duty_is_bound_to_incomplete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, incomplete).
test(a_duplicate_and_a_wrong_type_are_bound_to_input_problems) :-
    dora_rts_physical_hr_identity_and_access_profile_for(duplicate_and_wrong_type, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), wrong_type(access_control_policy_contains_segregation_of_duties)])).
test(an_unknown_key_is_bound_to_input_problems) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unknown_key, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, input_problems([unknown_key(colour)])).
test(required_is_bound_with_its_citations) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_required(Profile, required([physical_and_environmental_security_policy|_]), [_|_]).
test(outstanding_is_bound_to_the_one_failing_duty) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding([segregation_of_duties]), [cite(eu_reg_2024_1774_art_21_b)]).
test(complete_is_bound_with_empty_citations_for_a_status) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_absent, Profile),
    physical_hr_identity_and_access_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_], [wrong_type(profile)]).
test(an_atom_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems(not_a_profile, [wrong_type(profile)]).
test(a_foreign_element_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, false), colour], [wrong_type(profile)]).
test(an_unbound_element_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, false), _], [wrong_type(profile)]).
test(a_number_key_is_unknown) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(7, yes)], [unknown_key(7)]).
test(an_integer_and_a_float_key_are_two_keys) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(7, yes), attribute(7.0, yes)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(an_unbound_key_is_named_as_given) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(Key, yes)], [unknown_key(Named)]),
    Named == Key.
test(the_same_unbound_key_twice_is_one_key) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(Key, yes), attribute(Key, no)], Problems),
    length(Problems, 1).
test(two_unbound_keys_are_two_keys) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(_, yes), attribute(_, no)], Problems),
    length(Problems, 2).
test(an_unknown_key_value_is_not_checked) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(colour, _)], [unknown_key(colour)]).
test(an_unknown_key_repeated_is_named_once) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(colour, blue), attribute(colour, red)], [unknown_key(colour)]).
test(an_unbound_value_of_a_contract_key_is_wrong_type) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, _)], [wrong_type(access_control_policy_contains_segregation_of_duties)]).
test(a_number_value_is_wrong_type) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, 1.0)], [wrong_type(access_control_policy_contains_segregation_of_duties)]).
test(a_string_value_is_wrong_type) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, "true")], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(contract_problems_come_before_unknown_keys) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(colour, blue), attribute(financial_entity_is_article_16_1_entity, unsure)], [wrong_type(financial_entity_is_article_16_1_entity), unknown_key(colour)]).
test(contract_problems_follow_contract_order) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, maybe), attribute(financial_entity_is_article_16_1_entity, maybe)], [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(access_control_policy_contains_segregation_of_duties)]).
test(a_duplicate_with_equal_values_is_a_duplicate) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, true), attribute(access_control_policy_contains_segregation_of_duties, true)], [duplicate_key(access_control_policy_contains_segregation_of_duties)]).
test(a_present_duty_key_is_checked_by_the_required_query) :-
    physical_hr_identity_and_access_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(access_control_policy_contains_segregation_of_duties, maybe)], input_problems([wrong_type(access_control_policy_contains_segregation_of_duties)]), []).
test(an_input_problem_comes_before_the_gate) :-
    physical_hr_identity_and_access_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true), attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(the_gate_true_with_duty_keys_is_no_problem) :-
    dora_rts_physical_hr_identity_and_access_profile_for(article_16_1_entity, Profile),
    dora_rts_physical_hr_identity_and_access_input_problems(Profile, []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, complete),
    dora_rts_physical_hr_identity_and_access_status(Profile, Other).

cp_test_names([an_article_16_1_entity_is_bound_to_simplified_framework_entity, all_duties_performed_is_bound_to_complete, one_duty_not_performed_is_bound_to_incomplete, an_absent_gate_is_bound_to_indeterminate, an_absent_duty_is_bound_to_indeterminate, only_the_gate_given_asks_the_first_duty, an_unsure_duty_is_bound_to_needs_legal_review, a_failing_duty_with_an_absent_duty_is_bound_to_incomplete, a_duplicate_and_a_wrong_type_are_bound_to_input_problems, an_unknown_key_is_bound_to_input_problems, required_is_bound_with_its_citations, outstanding_is_bound_to_the_one_failing_duty, complete_is_bound_with_empty_citations_for_a_status, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute_list, a_number_key_is_unknown, an_integer_and_a_float_key_are_two_keys, an_unbound_key_is_named_as_given, the_same_unbound_key_twice_is_one_key, two_unbound_keys_are_two_keys, an_unknown_key_value_is_not_checked, an_unknown_key_repeated_is_named_once, an_unbound_value_of_a_contract_key_is_wrong_type, a_number_value_is_wrong_type, a_string_value_is_wrong_type, contract_problems_come_before_unknown_keys, contract_problems_follow_contract_order, a_duplicate_with_equal_values_is_a_duplicate, a_present_duty_key_is_checked_by_the_required_query, an_input_problem_comes_before_the_gate, the_gate_true_with_duty_keys_is_no_problem]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
