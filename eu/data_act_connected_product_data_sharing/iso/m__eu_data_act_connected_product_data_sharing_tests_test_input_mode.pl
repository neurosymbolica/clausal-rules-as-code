% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [product_design_duty_status/3, pre_contract_information_duty_status/3, user_access_request_status/3, third_party_sharing_request_status/3, data_act_connected_product_data_sharing_status/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_profile_for/2]).

fixture(Subject, Profile) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile).

problems_of(Profile, Problems) :-
    data_act_connected_product_data_sharing_input_problems(Profile, Problems).

test(design_duty_met_with_the_result_bound) :-
    fixture(design_duty_met_complete, Profile),
    product_design_duty_status(Profile, design_duty_met, [cite(eu_reg_2023_2854_art_3_1)]).
test(information_duty_met_with_the_result_bound) :-
    fixture(purchase_information_given, Profile),
    pre_contract_information_duty_status(Profile, information_duty_met, [cite(eu_reg_2023_2854_art_3_2)]).
test(access_due_with_the_result_bound) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, access_due, [cite(eu_reg_2023_2854_art_4_1)]).
test(sharing_due_with_the_result_bound) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, sharing_due, [cite(eu_reg_2023_2854_art_5_1)]).
test(status_eligible_with_the_status_bound) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_status(Profile, eligible).
test(attribute_order_does_not_change_the_answer) :-
    fixture(thermostat_access_due, Profile),
    reverse(Profile, Reversed),
    user_access_request_status(Reversed, access_due, [cite(eu_reg_2023_2854_art_4_1)]).
test(a_key_of_another_query_has_no_effect) :-
    fixture(thermostat_access_due, Profile),
    append(Profile, [attribute(placed_on_market_after_12_september_2026, false), attribute(third_party_is_designated_gatekeeper, true)], Extended),
    user_access_request_status(Extended, access_due, [cite(eu_reg_2023_2854_art_4_1)]).
test(an_empty_profile_has_no_input_problem) :-
    problems_of([], []).
test(an_unsure_boolean_is_a_wrong_type) :-
    fixture(input_unsure_boolean, Profile),
    user_access_request_status(Profile, input_problems([wrong_type(other_persons_personal_data_requested)]), []).
test(an_attested_value_is_a_wrong_type_in_every_query) :-
    fixture(input_attested_value, Profile),
    third_party_sharing_request_status(Profile, input_problems([wrong_type(requester_is_user)]), []).
test(an_unknown_key_is_an_input_problem) :-
    fixture(input_unknown_key, Profile),
    product_design_duty_status(Profile, input_problems([unknown_key(colour)]), []).
test(duplicate_key_with_different_values) :-
    fixture(input_duplicate_key, Profile),
    pre_contract_information_duty_status(Profile, input_problems([duplicate_key(requester_is_user)]), []).
test(duplicate_key_with_equal_values) :-
    problems_of([attribute(requester_is_user, true), attribute(requester_is_user, true)], [duplicate_key(requester_is_user)]).
test(duplicate_key_is_not_also_a_wrong_type) :-
    problems_of([attribute(requester_is_user, maybe), attribute(requester_is_user, true)], [duplicate_key(requester_is_user)]).
test(problems_in_contract_order_then_unknown_keys) :-
    problems_of([attribute(colour, red), attribute(requester_is_user, maybe), attribute(connected_product_or_related_service, 1), attribute(colour, blue)], Problems),
    Problems == [wrong_type(connected_product_or_related_service), wrong_type(requester_is_user), unknown_key(colour)].
test(an_enum_value_outside_the_enum_is_a_wrong_type) :-
    problems_of([attribute(pre_contract_contract_kind, true)], [wrong_type(pre_contract_contract_kind)]).
test(a_non_atom_key_is_unknown_as_given) :-
    problems_of([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_key_is_unknown_as_given) :-
    problems_of([attribute(Key, true)], Problems),
    Problems = [unknown_key(Named)],
    Named == Key.
test(an_unbound_value_is_a_wrong_type) :-
    problems_of([attribute(requester_is_user, _Value)], [wrong_type(requester_is_user)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, problems_of(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    problems_of([attribute(requester_is_user, true)|_Rest], [wrong_type(profile)]).
test(a_foreign_element_is_not_an_attribute_list) :-
    problems_of([attribute(requester_is_user, true), requester_is_user], [wrong_type(profile)]).
test(an_atom_profile_is_not_an_attribute_list) :-
    fixture(input_not_a_list, Profile),
    third_party_sharing_request_status(Profile, input_problems([wrong_type(profile)]), []).

test(design_duty_met_rejects_a_bound_not_met, fail) :-
    fixture(design_duty_met_complete, Profile),
    product_design_duty_status(Profile, design_duty_not_met, _).
test(information_duty_met_rejects_the_other_citation, fail) :-
    fixture(purchase_information_given, Profile),
    pre_contract_information_duty_status(Profile, information_duty_met, [cite(eu_reg_2023_2854_art_3_3)]).
test(access_due_rejects_a_bound_refusal, fail) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, refusal_permitted_security_restriction, _).
test(sharing_due_rejects_a_bound_gatekeeper_answer, fail) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, third_party_not_eligible_gatekeeper, _).
test(status_eligible_rejects_ineligible, fail) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_status(Profile, ineligible).

cp_test_names([design_duty_met_with_the_result_bound, information_duty_met_with_the_result_bound, access_due_with_the_result_bound, sharing_due_with_the_result_bound, status_eligible_with_the_status_bound, attribute_order_does_not_change_the_answer, a_key_of_another_query_has_no_effect, an_empty_profile_has_no_input_problem, an_unsure_boolean_is_a_wrong_type, an_attested_value_is_a_wrong_type_in_every_query, an_unknown_key_is_an_input_problem, duplicate_key_with_different_values, duplicate_key_with_equal_values, duplicate_key_is_not_also_a_wrong_type, problems_in_contract_order_then_unknown_keys, an_enum_value_outside_the_enum_is_a_wrong_type, a_non_atom_key_is_unknown_as_given, an_unbound_key_is_unknown_as_given, an_unbound_value_is_a_wrong_type, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, an_atom_profile_is_not_an_attribute_list]).
cp_test_fail_names([design_duty_met_rejects_a_bound_not_met, information_duty_met_rejects_the_other_citation, access_due_rejects_a_bound_refusal, sharing_due_rejects_a_bound_gatekeeper_answer, status_eligible_rejects_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
