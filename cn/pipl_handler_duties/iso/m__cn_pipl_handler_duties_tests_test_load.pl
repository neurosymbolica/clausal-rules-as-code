% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_citations, [citation/2, implements/1, citation_vocabulary/1, duty_primary_citation/2]).

test(the_final_result_atoms_are_distinct) :-
    Atoms = [required, required_in_advance, required_immediately, required_for_at_least_three_years, notice_may_be_omitted, not_required, not_in_force, pinned_text_not_applicable],
    sort(Atoms, Sorted),
    length(Atoms, 8),
    length(Sorted, 8).
test(required_differs_from_not_required) :-
    dif(required, not_required).
test(not_in_force_differs_from_pinned_text_not_applicable) :-
    dif(not_in_force, pinned_text_not_applicable).
test(notice_may_be_omitted_differs_from_required) :-
    dif(notice_may_be_omitted, required).
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([reference_date]),
    Result = indeterminate([MissingKey]),
    MissingKey == reference_date.
test(the_referral_term_carries_reason_and_pairs) :-
    Result = needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == decides_purposes_and_means,
    Key == cn_pipl_art_73_p1_i1,
    Pairs == [decides_purposes_and_means - unsure],
    citation(Key, _).
test(the_input_problems_term_carries_its_list) :-
    Result = input_problems([wrong_type(reaches_officer_quantity)]),
    Result = input_problems([Problem]),
    Problem == wrong_type(reaches_officer_quantity).
test(a_content_item_carries_name_and_citation) :-
    Item = content_item(internal_management_rules_and_operating_procedures, cite(cn_pipl_art_51_p1_i1)),
    Item = content_item(Name, cite(Key)),
    Name == internal_management_rules_and_operating_procedures,
    citation(Key, _).
test(the_entry_into_force_citation_is_recorded) :-
    citation(cn_pipl_art_74_p1, Record),
    Record = [label - _, ref - Ref, verbatim - _],
    Ref == 'cn-pipl-2021#art_74_p1'.
test(the_handler_definition_citation_is_recorded) :-
    implements(cn_pipl_art_73_p1_i1).
test(the_citation_vocabulary_is_recorded_in_full) :-
    citation_vocabulary(Keys),
    length(Keys, 40),
    maplist(implements, Keys).
test(the_article_fifty_three_duty_has_its_primary_citation) :-
    duty_primary_citation(china_representative, cite(Key)),
    Key == cn_pipl_art_53_p1.
test(the_input_check_accepts_an_empty_profile) :-
    pipl_handler_duties_input_problems([], []).
test(the_input_check_names_an_unknown_key) :-
    pipl_handler_duties_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_input_check_refuses_a_non_list) :-
    pipl_handler_duties_input_problems(stray, [wrong_type(profile)]).

test(required_is_not_not_required, fail) :-
    required = not_required.
test(a_placeholder_citation_is_not_recorded, fail) :-
    citation(cn_todo_primary_source, _).

cp_test_names([the_final_result_atoms_are_distinct, required_differs_from_not_required, not_in_force_differs_from_pinned_text_not_applicable, notice_may_be_omitted_differs_from_required, the_indeterminate_term_names_one_key, the_referral_term_carries_reason_and_pairs, the_input_problems_term_carries_its_list, a_content_item_carries_name_and_citation, the_entry_into_force_citation_is_recorded, the_handler_definition_citation_is_recorded, the_citation_vocabulary_is_recorded_in_full, the_article_fifty_three_duty_has_its_primary_citation, the_input_check_accepts_an_empty_profile, the_input_check_names_an_unknown_key, the_input_check_refuses_a_non_list]).
cp_test_fail_names([required_is_not_not_required, a_placeholder_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
