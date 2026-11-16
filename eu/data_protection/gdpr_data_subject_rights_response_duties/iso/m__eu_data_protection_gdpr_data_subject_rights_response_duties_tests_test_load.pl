% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_citations, [citation/2]).

test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(must_comply, art15_1, none, [], [cite(eu_reg_2016_679_art_12_3)]),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == must_comply,
    Basis == art15_1,
    Exception == none,
    Conditions == [],
    Citations == [cite(eu_reg_2016_679_art_12_3)].
test(the_verdict_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(a_status_compound_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], []),
    Verdict = gdpr_data_subject_request_verdict(suspended(Reason), _, _, _, _),
    Reason == art12_6_identity_not_confirmed.
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_12_3, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_empty_attribute_list_has_no_input_problems) :-
    gdpr_data_subject_rights_response_duties_input_problems([], []).
test(a_non_list_profile_is_a_wrong_type_profile) :-
    gdpr_data_subject_rights_response_duties_input_problems(not_a_profile, [wrong_type(profile)]).

test(an_unrecorded_citation_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_verdict_term_builds_and_destructures, the_verdict_atoms_are_distinct, a_status_compound_destructures, a_real_citation_record_resolves, the_empty_attribute_list_has_no_input_problems, a_non_list_profile_is_a_wrong_type_profile]).
cp_test_fail_names([an_unrecorded_citation_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
