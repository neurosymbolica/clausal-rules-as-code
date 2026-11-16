% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_citations, [citation/2, implements/1]).

test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [eu_reg_2016_679_art_20_1]),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == must_comply,
    Basis == art20_1,
    Exception == none,
    Conditions == [],
    Citations == [eu_reg_2016_679_art_20_1].
test(the_comply_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(the_exception_atoms_are_distinct) :-
    dif(art20_3_public_task, art20_4_rights_of_others).
test(a_compound_status_is_not_a_bare_atom) :-
    Status = suspended(art12_6_identity_not_confirmed),
    Status = suspended(Reason),
    Reason == art12_6_identity_not_confirmed.
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_20_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_22_1).
test(the_empty_profile_has_no_input_problem) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([], []).
test(an_unknown_key_is_an_input_problem) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems([attribute(no_such_key, true)], [unknown_key(no_such_key)]).

test(equal_comply_atoms_are_not_distinct, fail) :-
    dif(must_comply, must_comply).
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_99_9).

cp_test_names([the_verdict_term_builds_and_destructures, the_comply_atoms_are_distinct, the_exception_atoms_are_distinct, a_compound_status_is_not_a_bare_atom, a_real_citation_record_resolves, a_recorded_key_is_implemented, the_empty_profile_has_no_input_problem, an_unknown_key_is_an_input_problem]).
cp_test_fail_names([equal_comply_atoms_are_not_distinct, an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
