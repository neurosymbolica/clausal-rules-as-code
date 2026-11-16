% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_result_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [risk_management_measures/2]).

test(provenance_term_holds_a_clause_and_its_citations) :-
    Term = provenance(point_j_unsure, [cite(eu_dir_2022_2555_art_21_2_j)]),
    Term = provenance(Clause, Citations),
    Clause == point_j_unsure,
    Citations == [cite(eu_dir_2022_2555_art_21_2_j)].
test(provenance_binds_its_two_arguments) :-
    Term = provenance(Clause, Citations),
    Term = provenance(point_j_unsure, [cite(eu_dir_2022_2555_art_21_2_j)]),
    Clause == point_j_unsure,
    Citations == [cite(eu_dir_2022_2555_art_21_2_j)].
test(provenance_with_empty_citations_destructures) :-
    Term = provenance(deciding_clause, []),
    Term = provenance(deciding_clause, Citations),
    Citations == [].
test(provenance_may_trail_the_pairs_of_a_referral) :-
    risk_management_measures([attribute(entity_class, important_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)], needs_legal_review(open_textured(_, _), [inputs_relied_on(Pairs)|_Provenance])),
    Pairs == [multi_factor_authentication_and_secured_communications_appropriate - unsure].

cp_test_names([provenance_term_holds_a_clause_and_its_citations, provenance_binds_its_two_arguments, provenance_with_empty_citations_destructures, provenance_may_trail_the_pairs_of_a_referral]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
