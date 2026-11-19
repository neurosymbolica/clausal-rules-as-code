% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2]).

test(an_empty_attribute_list_gets_exactly_one_answer) :-
    findall(Problems, pipl_individual_rights_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_profile_that_is_not_a_list_gets_one_non_empty_answer) :-
    findall(Problems, pipl_individual_rights_input_problems(not_a_profile, Problems), Answers),
    Answers = [[_|_]].
test(an_unknown_key_is_named) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(not_a_key_of_the_contract, true)], Problems), Answers),
    Answers = [Problems],
    memberchk(unknown_key(not_a_key_of_the_contract), Problems).
test(a_value_outside_the_type_of_pinned_text_in_force_on_reference_day_is_named) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(pinned_text_in_force_on_reference_day, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(pinned_text_in_force_on_reference_day), Problems).
test(a_value_outside_the_type_of_verification_confirms_inaccurate_or_incomplete_is_named) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(verification_confirms_inaccurate_or_incomplete, outside_the_type)], Problems), Answers),
    Answers = [Problems],
    memberchk(wrong_type(verification_confirms_inaccurate_or_incomplete), Problems).

cp_test_names([an_empty_attribute_list_gets_exactly_one_answer, a_profile_that_is_not_a_list_gets_one_non_empty_answer, an_unknown_key_is_named, a_value_outside_the_type_of_pinned_text_in_force_on_reference_day_is_named, a_value_outside_the_type_of_verification_confirms_inaccurate_or_incomplete_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
