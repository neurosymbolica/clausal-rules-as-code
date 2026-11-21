% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).

test(an_empty_attribute_list_gets_exactly_one_answer) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_profile_that_is_not_a_list_gets_one_non_empty_answer) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems(not_a_profile, Problems), Answers),
    Answers = [[_|_]].
test(an_unknown_key_is_named) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([attribute(not_a_key_of_the_contract, processing_for_online_advertising_services)], Problems), Answers),
    Answers = [Problems],
    memberchk(unknown_key(not_a_key_of_the_contract), Problems).
test(a_value_outside_the_type_of_designated_as_gatekeeper_for_core_platform_service_is_named) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([attribute(designated_as_gatekeeper_for_core_platform_service, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(designated_as_gatekeeper_for_core_platform_service), Problems).
test(a_value_outside_the_type_of_practice_under_article_5_2_is_named) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(practice_under_article_5_2), Problems).
test(a_value_outside_the_type_of_consent_request_already_repeated_in_period_is_named) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([attribute(consent_request_already_repeated_in_period, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(consent_request_already_repeated_in_period), Problems).

cp_test_names([an_empty_attribute_list_gets_exactly_one_answer, a_profile_that_is_not_a_list_gets_one_non_empty_answer, an_unknown_key_is_named, a_value_outside_the_type_of_designated_as_gatekeeper_for_core_platform_service_is_named, a_value_outside_the_type_of_practice_under_article_5_2_is_named, a_value_outside_the_type_of_consent_request_already_repeated_in_period_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
