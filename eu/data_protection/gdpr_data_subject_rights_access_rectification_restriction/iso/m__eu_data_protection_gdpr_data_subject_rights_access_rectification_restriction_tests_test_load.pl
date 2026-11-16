% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_citations, [citation/2]).

test(the_pinned_vocabulary_is_the_status_table) :-
    request_basis_status_values([art15_1, art16_inaccurate_data, art16_incomplete_data, art18_1_a, art18_1_b, art18_1_c, art18_1_d, none]).
test(the_verdict_atoms_are_distinct) :-
    dif(art15_1, art16_inaccurate_data).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = request_basis_verdict(art15_1, []),
    Verdict = request_basis_verdict(Status, Citations),
    Status == art15_1,
    Citations == [].
test(a_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_15_1, _Record).

cp_test_names([the_pinned_vocabulary_is_the_status_table, the_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, a_real_citation_is_recorded]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
