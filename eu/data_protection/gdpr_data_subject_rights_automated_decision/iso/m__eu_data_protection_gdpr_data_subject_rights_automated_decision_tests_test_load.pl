% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_kernel, [gdpr_data_subject_rights_automated_decision_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_citations, [citation/2, implements/1]).

test(the_empty_profile_has_no_problem) :-
    gdpr_data_subject_rights_automated_decision_input_problems([], []).
test(an_unknown_key_is_named) :-
    gdpr_data_subject_rights_automated_decision_input_problems([attribute(bogus_key, true)], [unknown_key(bogus_key)]).
test(a_wrong_type_is_named) :-
    gdpr_data_subject_rights_automated_decision_input_problems([attribute(request_type, bogus_value)], [wrong_type(request_type)]).
test(the_verdict_atoms_are_distinct) :-
    dif(must_comply, need_not_comply),
    dif(art22_1, none).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(must_comply, art22_1, none, [], [cite(eu_reg_2016_679_art_22_1)]),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == must_comply,
    Basis == art22_1,
    Exception == none,
    Conditions == [],
    Citations == [cite(eu_reg_2016_679_art_22_1)].
test(a_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_22_1, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_22_2_a).

cp_test_names([the_empty_profile_has_no_problem, an_unknown_key_is_named, a_wrong_type_is_named, the_verdict_atoms_are_distinct, the_verdict_term_builds_and_destructures, a_real_citation_is_recorded, a_recorded_key_is_implemented]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
