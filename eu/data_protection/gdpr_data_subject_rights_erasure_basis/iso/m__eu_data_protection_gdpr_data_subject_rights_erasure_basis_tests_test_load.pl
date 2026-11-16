% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_kernel, [gdpr_data_subject_rights_erasure_basis_input_problems/2]).

test(the_pinned_vocabulary_is_the_status_table) :-
    request_basis_status_values([art17_1_a, art17_1_b, art17_1_c, art17_1_d, art17_1_e, art17_1_f, none]).
test(the_verdict_atoms_are_distinct) :-
    dif(art17_1_a, art17_1_b).
test(none_is_distinct_from_a_basis) :-
    dif(none, art17_1_a).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = request_basis_verdict(art17_1_a, []),
    Verdict = request_basis_verdict(Status, Citations),
    Status == art17_1_a,
    Citations == [].
test(a_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_17_1_a, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_17_1_a).
test(an_empty_profile_has_no_problem) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([], []).
test(an_unknown_key_is_named) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(no_such_key, true)], [unknown_key(no_such_key)]).
test(a_wrong_request_type_is_named) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_type, bogus)], [wrong_type(request_type)]).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(no_such_citation_key).

cp_test_names([the_pinned_vocabulary_is_the_status_table, the_verdict_atoms_are_distinct, none_is_distinct_from_a_basis, the_verdict_term_carries_status_and_citations, a_real_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, an_unknown_key_is_named, a_wrong_request_type_is_named]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
