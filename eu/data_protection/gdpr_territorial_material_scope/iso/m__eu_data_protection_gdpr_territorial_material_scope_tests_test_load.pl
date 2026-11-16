% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [all_status/2, any_status/2, negated/2, citation_order/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [citation/2, implements/1]).

test(an_unmet_element_dominates_an_and) :-
    all_status([met, absent, unmet], unmet).
test(absence_ranks_before_judgement_in_an_and) :-
    all_status([met, judgement, absent], absent).
test(all_met_is_met) :-
    all_status([met, met], met).
test(met_dominates_an_or) :-
    any_status([unmet, absent, met], met).
test(all_unmet_or_is_unmet) :-
    any_status([unmet, unmet], unmet).
test(negation_swaps_met_and_unmet) :-
    negated(met, unmet),
    negated(unmet, met),
    negated(absent, absent).
test(the_verdict_atoms_are_distinct) :-
    dif(applies, does_not_apply).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_scope_verdict(applies, art3_1, not_applicable, []),
    Verdict = gdpr_scope_verdict(Applies, Ground, Representative, Citations),
    Applies == applies,
    Ground == art3_1,
    Representative == not_applicable,
    Citations == [].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_3_1, _Record),
    implements(eu_reg_2016_679_art_3_1).
test(the_citation_vocabulary_starts_with_article_2_1) :-
    citation_order([cite(eu_reg_2016_679_art_2_1)|_]).

cp_test_names([an_unmet_element_dominates_an_and, absence_ranks_before_judgement_in_an_and, all_met_is_met, met_dominates_an_or, all_unmet_or_is_unmet, negation_swaps_met_and_unmet, the_verdict_atoms_are_distinct, the_verdict_term_builds_and_destructures, a_real_citation_record_resolves, the_citation_vocabulary_starts_with_article_2_1]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
