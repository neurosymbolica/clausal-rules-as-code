% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_ai_act_penalties_kernel, [penalties_input_problems/2, penalties_date_relation/3]).
:- use_module(m__eu_ai_act_penalties_citations, [citation/2, implements/1, citation_vocabulary/2]).

test(the_fine_maximum_term_carries_amount_and_basis) :-
    Maximum = fine_maximum(3500000000, fixed_amount),
    Maximum = fine_maximum(AmountEurCents, Basis),
    AmountEurCents =:= 3500000000,
    Basis == fixed_amount.
test(the_query_answer_is_one_term_and_one_flat_citation_list) :-
    Answer = answer(fine_maximum(75000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]),
    Answer = answer(fine_maximum(AmountEurCents, Basis), Citations),
    AmountEurCents =:= 75000000,
    Basis == fixed_amount,
    Citations == [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)].
test(the_indeterminate_status_names_one_bare_key) :-
    Status = indeterminate([offender_category]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [offender_category].
test(the_legal_review_status_has_its_reason_and_context) :-
    Status = needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently - unsure])]),
    Status = needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]),
    Input == provider_acted_intentionally_or_negligently,
    Citation == cite(eu_reg_2024_1689_art_101_1),
    Pairs == [provider_acted_intentionally_or_negligently - unsure].
test(the_input_problems_status_holds_a_flat_problem_list) :-
    Status = input_problems([unknown_key(colour), wrong_type(infringement_date)]),
    Status = input_problems(Problems),
    Problems == [unknown_key(colour), wrong_type(infringement_date)].
test(the_basis_atoms_are_distinct) :-
    dif(fixed_amount, turnover_percentage).
test(the_union_maximum_atoms_are_distinct) :-
    Atoms = [no_union_maximum, set_by_member_state_rules, not_applicable_on_date, earlier_version_applies],
    sort(Atoms, DistinctAtoms),
    length(DistinctAtoms, 4).
test(the_commission_atoms_are_distinct) :-
    dif(no_commission_fine, not_applicable_on_date).
test(the_problem_constructors_are_distinct) :-
    dif(unknown_key(colour), wrong_type(colour)),
    dif(wrong_type(colour), duplicate_key(colour)),
    dif(unknown_key(colour), duplicate_key(colour)).
test(the_article_99_3_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_99_3, Record),
    member(label - _, Record).
test(the_article_101_1_citation_is_implemented) :-
    implements(eu_reg_2024_1689_art_101_1).
test(the_article_113_a_key_is_in_the_vocabulary) :-
    citation_vocabulary(eu_reg_2024_1689_art_113_a, Unit),
    Unit == 'point_113_a'.
test(the_correct_spelling_of_that_key_is_recorded) :-
    citation(eu_reg_2024_1689_art_99_6a, _).
test(the_kernel_input_check_accepts_an_empty_profile) :-
    penalties_input_problems([], Problems),
    Problems == [].
test(the_kernel_input_check_names_an_unknown_key) :-
    penalties_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_kernel_compares_calendar_days) :-
    penalties_date_relation(date(2026, 8, 1), date(2026, 8, 2), before).

test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(eu_reg_2024_1689_art_99_6_a, _).
test(the_stated_day_is_not_before_itself, fail) :-
    penalties_date_relation(date(2026, 8, 2), date(2026, 8, 2), before).

cp_test_names([the_fine_maximum_term_carries_amount_and_basis, the_query_answer_is_one_term_and_one_flat_citation_list, the_indeterminate_status_names_one_bare_key, the_legal_review_status_has_its_reason_and_context, the_input_problems_status_holds_a_flat_problem_list, the_basis_atoms_are_distinct, the_union_maximum_atoms_are_distinct, the_commission_atoms_are_distinct, the_problem_constructors_are_distinct, the_article_99_3_citation_is_recorded, the_article_101_1_citation_is_implemented, the_article_113_a_key_is_in_the_vocabulary, the_correct_spelling_of_that_key_is_recorded, the_kernel_input_check_accepts_an_empty_profile, the_kernel_input_check_names_an_unknown_key, the_kernel_compares_calendar_days]).
cp_test_fail_names([a_shortened_citation_key_is_not_recorded, the_stated_day_is_not_before_itself]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
