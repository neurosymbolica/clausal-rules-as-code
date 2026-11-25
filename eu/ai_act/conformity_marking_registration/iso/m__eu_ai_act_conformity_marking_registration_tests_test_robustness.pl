% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2]).

test(an_empty_attribute_list_gets_exactly_one_answer) :-
    findall(Problems, conformity_marking_registration_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_profile_that_is_not_a_list_gets_one_non_empty_answer) :-
    findall(Problems, conformity_marking_registration_input_problems(not_a_profile, Problems), Answers),
    Answers = [[_|_]].
test(an_unknown_key_is_named) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(not_a_key_of_the_contract, not_listed_in_annex_iii)], Problems), Answers),
    Answers = [Problems],
    memberchk(unknown_key(not_a_key_of_the_contract), Problems).
test(a_value_outside_the_type_of_annex_iii_point_is_named) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(annex_iii_point, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(annex_iii_point), Problems).
test(a_value_outside_the_type_of_provider_concluded_under_article_6_3_that_the_system_is_not_high_risk_is_named) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk), Problems).
test(a_value_outside_the_type_of_significant_changes_in_design_from_the_application_day_is_named) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(significant_changes_in_design_from_the_application_day, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(significant_changes_in_design_from_the_application_day), Problems).

cp_test_names([an_empty_attribute_list_gets_exactly_one_answer, a_profile_that_is_not_a_list_gets_one_non_empty_answer, an_unknown_key_is_named, a_value_outside_the_type_of_annex_iii_point_is_named, a_value_outside_the_type_of_provider_concluded_under_article_6_3_that_the_system_is_not_high_risk_is_named, a_value_outside_the_type_of_significant_changes_in_design_from_the_application_day_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
