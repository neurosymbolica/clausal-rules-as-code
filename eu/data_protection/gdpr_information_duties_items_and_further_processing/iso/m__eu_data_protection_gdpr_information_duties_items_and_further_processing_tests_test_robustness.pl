% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_kernel, [gdpr_information_duties_items_and_further_processing_input_problems/2]).

test(an_empty_attribute_list_gets_exactly_one_answer) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_profile_that_is_not_a_list_gets_one_non_empty_answer) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems(not_a_profile, Problems), Answers),
    Answers = [[_|_]].
test(an_unknown_key_is_named) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([attribute(not_a_key_of_the_contract, true)], Problems), Answers),
    Answers = [Problems],
    memberchk(unknown_key(not_a_key_of_the_contract), Problems).
test(a_value_outside_the_type_of_personal_data_collected_from_data_subject_is_named) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([attribute(personal_data_collected_from_data_subject, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(personal_data_collected_from_data_subject), Problems).
test(a_value_outside_the_type_of_items_provided_is_named) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([attribute(items_provided, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(items_provided), Problems).
test(a_value_outside_the_type_of_automated_decision_making_under_article_22_is_named) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([attribute(automated_decision_making_under_article_22, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(automated_decision_making_under_article_22), Problems).
test(a_value_outside_the_type_of_obtaining_date_is_named) :-
    findall(Problems, gdpr_information_duties_items_and_further_processing_input_problems([attribute(obtaining_date, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(obtaining_date), Problems).

cp_test_names([an_empty_attribute_list_gets_exactly_one_answer, a_profile_that_is_not_a_list_gets_one_non_empty_answer, an_unknown_key_is_named, a_value_outside_the_type_of_personal_data_collected_from_data_subject_is_named, a_value_outside_the_type_of_items_provided_is_named, a_value_outside_the_type_of_automated_decision_making_under_article_22_is_named, a_value_outside_the_type_of_obtaining_date_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
