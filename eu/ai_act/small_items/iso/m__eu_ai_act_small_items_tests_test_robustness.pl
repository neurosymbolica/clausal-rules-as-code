% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_kernel, [small_items_input_problems/2]).

test(an_empty_attribute_list_gets_exactly_one_answer) :-
    findall(Problems, small_items_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_profile_that_is_not_a_list_gets_one_non_empty_answer) :-
    findall(Problems, small_items_input_problems(not_a_profile, Problems), Answers),
    Answers = [[_|_]].
test(an_unknown_key_is_named) :-
    findall(Problems, small_items_input_problems([attribute(not_a_key_of_the_contract, provider_of_a_high_risk_system)], Problems), Answers),
    Answers = [Problems],
    memberchk(unknown_key(not_a_key_of_the_contract), Problems).
test(a_value_outside_the_type_of_bias_processing_capacity_is_named) :-
    findall(Problems, small_items_input_problems([attribute(bias_processing_capacity, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(bias_processing_capacity), Problems).
test(a_value_outside_the_type_of_strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g_is_named) :-
    findall(Problems, small_items_input_problems([attribute(strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g), Problems).
test(a_value_outside_the_type_of_data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties_is_named) :-
    findall(Problems, small_items_input_problems([attribute(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties), Problems).

cp_test_names([an_empty_attribute_list_gets_exactly_one_answer, a_profile_that_is_not_a_list_gets_one_non_empty_answer, an_unknown_key_is_named, a_value_outside_the_type_of_bias_processing_capacity_is_named, a_value_outside_the_type_of_strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g_is_named, a_value_outside_the_type_of_data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
