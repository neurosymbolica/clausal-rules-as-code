% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_citations, [citation/2, implements/1]).

test(retrospective_result_term_builds) :-
    Result = gst_retrospective(liable, 150000000, date(2020, 1, 30), date(2020, 3, 1), [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a]),
    Result = gst_retrospective(Decision, ValueCents, NotifyBy, RegisteredFrom, Citations),
    Decision == liable,
    ValueCents == 150000000,
    NotifyBy == date(2020, 1, 30),
    RegisteredFrom == date(2020, 3, 1),
    Citations == [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a].
test(prospective_result_term_builds) :-
    Result = gst_prospective(liable, 120000000, date(2022, 2, 14), date(2022, 2, 15), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i]),
    Result = gst_prospective(Decision, ValueCents, NotifyBy, RegisteredFrom, Citations),
    Decision == liable,
    ValueCents == 120000000,
    NotifyBy == date(2022, 2, 14),
    RegisteredFrom == date(2022, 2, 15),
    Citations == [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i].
test(retrospective_indeterminate_result_term) :-
    Result = gst_retrospective(indeterminate, n_a, n_a, n_a, []),
    Result = gst_retrospective(Decision, ValueCents, NotifyBy, RegisteredFrom, Citations),
    Decision == indeterminate,
    ValueCents == n_a,
    NotifyBy == n_a,
    RegisteredFrom == n_a,
    Citations == [].
test(prospective_indeterminate_result_term) :-
    Result = gst_prospective(indeterminate, n_a, n_a, n_a, []),
    Result = gst_prospective(Decision, ValueCents, NotifyBy, RegisteredFrom, Citations),
    Decision == indeterminate,
    ValueCents == n_a,
    NotifyBy == n_a,
    RegisteredFrom == n_a,
    Citations == [].
test(retrospective_verdict_atoms_are_distinct) :-
    dif(liable, not_liable),
    dif(liable, not_liable_comptroller_satisfied),
    dif(liable, exempted_zero_rated),
    dif(liable, already_registered),
    dif(liable, indeterminate),
    dif(not_liable, not_liable_comptroller_satisfied),
    dif(not_liable, exempted_zero_rated),
    dif(not_liable, already_registered),
    dif(not_liable, indeterminate),
    dif(not_liable_comptroller_satisfied, exempted_zero_rated),
    dif(not_liable_comptroller_satisfied, already_registered),
    dif(not_liable_comptroller_satisfied, indeterminate),
    dif(exempted_zero_rated, already_registered),
    dif(exempted_zero_rated, indeterminate),
    dif(already_registered, indeterminate).
test(prospective_verdict_atoms_are_distinct) :-
    dif(liable, not_liable),
    dif(liable, exempted_zero_rated),
    dif(liable, already_registered),
    dif(liable, indeterminate),
    dif(not_liable, exempted_zero_rated),
    dif(not_liable, already_registered),
    dif(not_liable, indeterminate),
    dif(exempted_zero_rated, already_registered),
    dif(exempted_zero_rated, indeterminate),
    dif(already_registered, indeterminate).
test(a_real_citation_resolves) :-
    citation(sg_gsta_1993_sch1_para_1_1_a_ii, _Record).
test(implements_succeeds_for_recorded_key) :-
    implements(sg_gsta_1993_sch1_para_1_1_a_ii).
test(implements_succeeds_for_prospective_key) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_ii).
test(n_a_is_an_atom) :-
    atom(n_a).
test(date_term_is_compound) :-
    compound(date(2020, 1, 30)).

cp_test_names([retrospective_result_term_builds, prospective_result_term_builds, retrospective_indeterminate_result_term, prospective_indeterminate_result_term, retrospective_verdict_atoms_are_distinct, prospective_verdict_atoms_are_distinct, a_real_citation_resolves, implements_succeeds_for_recorded_key, implements_succeeds_for_prospective_key, n_a_is_an_atom, date_term_is_compound]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
