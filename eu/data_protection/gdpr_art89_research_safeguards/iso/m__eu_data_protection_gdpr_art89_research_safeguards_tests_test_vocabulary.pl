% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_vocabulary, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_queries, [gdpr_art89_verdict/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).

test(a_verdict_shape_holds) :-
    gdpr_art89_verdict(in_accordance, [], [cite(eu_reg_2016_679_art_89_1)]).
test(a_verdict_with_unmet_shape_holds) :-
    gdpr_art89_verdict(not_in_accordance, [measures], [cite(eu_reg_2016_679_art_89_1)]).
test(an_indeterminate_verdict_shape_holds) :-
    gdpr_art89_verdict(indeterminate([purpose]), [], []).
test(a_review_verdict_shape_holds) :-
    gdpr_art89_verdict(needs_legal_review(open_textured(safeguards_appropriate, cite(eu_reg_2016_679_art_89_1)), [inputs_relied_on([safeguards_appropriate - unsure])]), [], []).
test(an_input_problem_verdict_shape_holds) :-
    gdpr_art89_verdict(input_problems([wrong_type(purpose)]), [], []).
test(indeterminate_needs_keys) :-
    indeterminate([purpose]).
test(needs_legal_review_shape) :-
    needs_legal_review(open_textured(safeguards_appropriate, cite(eu_reg_2016_679_art_89_1)), [inputs_relied_on([safeguards_appropriate - unsure])]).
test(open_textured_shape) :-
    open_textured(safeguards_appropriate, cite(eu_reg_2016_679_art_89_1)).
test(inputs_relied_on_shape) :-
    inputs_relied_on([safeguards_appropriate - unsure]).
test(input_problems_shape) :-
    input_problems([unknown_key(extra_note)]).
test(unknown_key_shape) :-
    unknown_key(extra_note).
test(wrong_type_shape) :-
    wrong_type(purpose).
test(duplicate_key_shape) :-
    duplicate_key(purpose).

test(an_unknown_status_is_not_a_verdict, fail) :-
    gdpr_art89_verdict(maybe, [], []).
test(indeterminate_with_no_keys_is_rejected, fail) :-
    indeterminate([]).
test(needs_legal_review_without_reason_is_rejected, fail) :-
    needs_legal_review(other, [inputs_relied_on([safeguards_appropriate - unsure])]).
test(a_non_atom_key_is_rejected, fail) :-
    duplicate_key(1).

cp_test_names([a_verdict_shape_holds, a_verdict_with_unmet_shape_holds, an_indeterminate_verdict_shape_holds, a_review_verdict_shape_holds, an_input_problem_verdict_shape_holds, indeterminate_needs_keys, needs_legal_review_shape, open_textured_shape, inputs_relied_on_shape, input_problems_shape, unknown_key_shape, wrong_type_shape, duplicate_key_shape]).
cp_test_fail_names([an_unknown_status_is_not_a_verdict, indeterminate_with_no_keys_is_rejected, needs_legal_review_without_reason_is_rejected, a_non_atom_key_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
