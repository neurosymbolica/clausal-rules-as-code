% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_citations, [citation/2, implements/1]).

test(the_kernel_input_check_loads_and_answers_an_empty_profile) :-
    working_time_weekly_limit_input_problems([], []).
test(the_kernel_input_check_answers_once) :-
    findall(Problems, working_time_weekly_limit_input_problems([attribute(reference_period_basis, member_state_reference_period)], Problems), Answers),
    Answers == [[]].
test(the_kernel_input_check_names_a_wrong_profile) :-
    working_time_weekly_limit_input_problems(not_a_profile, [wrong_type(profile)]).
test(the_kernel_input_check_names_the_wrong_basis) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, four_months)], [wrong_type(reference_period_basis)]).
test(the_result_atoms_are_distinct) :-
    Results = [within_weekly_limit, over_weekly_limit, weekly_limit_not_applied_by_agreement, reference_period_longer_than_allowed, no_countable_period],
    sort(Results, SortedResults),
    length(SortedResults, 5),
    dif(within_weekly_limit, over_weekly_limit),
    dif(over_weekly_limit, weekly_limit_not_applied_by_agreement),
    dif(within_weekly_limit, reference_period_longer_than_allowed),
    dif(reference_period_longer_than_allowed, no_countable_period).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = working_time_weekly_limit_verdict(within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]),
    Verdict = working_time_weekly_limit_verdict(Status, Citations),
    Status == within_weekly_limit,
    Citations == [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)].
test(the_average_term_holds_two_bare_integers) :-
    Average = minutes_per_seven_days(2880, 1),
    Average = minutes_per_seven_days(Numerator, Denominator),
    integer(Numerator),
    integer(Denominator),
    Numerator =:= 2880,
    Denominator =:= 1.
test(the_indeterminate_term_names_one_key) :-
    Status = indeterminate([reference_period_basis]),
    Status = indeterminate([MissingKey]),
    MissingKey == reference_period_basis.
test(the_legal_review_term_destructures) :-
    Status = needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == on_call_on_site_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    Pairs == [on_call_on_site_counts_as_working_time - unsure].
test(the_input_problems_term_destructures) :-
    Status = input_problems([duplicate_key(member_state_uses_article_22_option), wrong_type(worker), unknown_key(colour)]),
    Status = input_problems([First, Second, Third]),
    First == duplicate_key(member_state_uses_article_22_option),
    Second == wrong_type(worker),
    Third == unknown_key(colour).
test(the_working_time_definition_is_recorded) :-
    citation(eu_dir_2003_88_art_2_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_weekly_limit_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_6_b, _Record).
test(every_result_citation_is_implemented) :-
    implements(eu_dir_2003_88_art_2_1),
    implements(eu_dir_2003_88_art_6_b),
    implements(eu_dir_2003_88_art_16_b),
    implements(eu_dir_2003_88_art_19_first_subpara),
    implements(eu_dir_2003_88_art_19_second_subpara),
    implements(eu_dir_2003_88_art_20_2),
    implements(eu_dir_2003_88_art_22_1),
    implements(eu_dir_2003_88_art_22_1_a).

test(the_kernel_input_check_does_not_pass_a_wrong_basis, fail) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, four_months)], []).
test(an_indeterminate_term_is_not_a_legal_review, fail) :-
    indeterminate([reference_period_basis]) = needs_legal_review(_, _).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_6_b, _Record).

cp_test_names([the_kernel_input_check_loads_and_answers_an_empty_profile, the_kernel_input_check_answers_once, the_kernel_input_check_names_a_wrong_profile, the_kernel_input_check_names_the_wrong_basis, the_result_atoms_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_verdict_term_carries_status_and_citations, the_average_term_holds_two_bare_integers, the_indeterminate_term_names_one_key, the_legal_review_term_destructures, the_input_problems_term_destructures, the_working_time_definition_is_recorded, the_weekly_limit_citation_is_recorded, every_result_citation_is_implemented]).
cp_test_fail_names([the_kernel_input_check_does_not_pass_a_wrong_basis, an_indeterminate_term_is_not_a_legal_review, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
