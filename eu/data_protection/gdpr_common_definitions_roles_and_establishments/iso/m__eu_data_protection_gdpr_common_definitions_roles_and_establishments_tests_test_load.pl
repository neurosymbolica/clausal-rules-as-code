% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_citations, [citation/2, implements/1]).

test(a_real_citation_resolves) :-
    citation(eu_reg_2016_679_art_4_7, _Record).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_4_8).
test(the_answer_term_builds_and_destructures) :-
    Answer = definition_answer(met, none, [cite(eu_reg_2016_679_art_4_8)]),
    Answer = definition_answer(Status, Ground, Citations),
    Status == met,
    Ground == none,
    Citations == [cite(eu_reg_2016_679_art_4_8)].
test(the_status_atoms_are_distinct) :-
    dif(met, not_met).
test(an_empty_profile_has_no_input_problems) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([], []).

test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_9_9).

cp_test_names([a_real_citation_resolves, implements_succeeds_for_a_recorded_key, the_answer_term_builds_and_destructures, the_status_atoms_are_distinct, an_empty_profile_has_no_input_problems]).
cp_test_fail_names([implements_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
