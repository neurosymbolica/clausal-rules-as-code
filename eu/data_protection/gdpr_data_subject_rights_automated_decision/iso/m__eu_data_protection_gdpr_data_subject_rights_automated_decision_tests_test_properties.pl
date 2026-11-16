% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [decide_request_basis/2, decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_subject/1, gdpr_data_subject_rights_automated_decision_profile_for/2]).

verdict_count(Subject, Count) :-
    gdpr_data_subject_rights_automated_decision_subject(Subject),
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

basis_count(Subject, Count) :-
    gdpr_data_subject_rights_automated_decision_subject(Subject),
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    findall(Basis, request_basis(Profile, Basis), Bases),
    length(Bases, Count).

profile_count(Subject, Count) :-
    gdpr_data_subject_rights_automated_decision_subject(Subject),
    findall(Profile, gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile), Profiles),
    length(Profiles, Count).

basis_agrees(Subject) :-
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, Basis, _, _, _)),
    request_basis(Profile, Basis).

test(totality_every_subject_has_exactly_one_verdict) :-
    findall(Count, verdict_count(_, Count), Counts),
    sort(Counts, [1]).
test(determinism_request_basis_has_one_answer) :-
    findall(Count, basis_count(_, Count), Counts),
    sort(Counts, [1]).
test(every_subject_has_one_profile) :-
    findall(Count, profile_count(_, Count), Counts),
    sort(Counts, [1]).
test(basis_projection_agrees_with_the_verdict_for_a_final_answer) :-
    basis_agrees(contract_exception),
    basis_agrees(baseline_must_comply),
    basis_agrees(not_solely_automated).
test(verdict_citations_are_cite_terms) :-
    gdpr_data_subject_rights_automated_decision_profile_for(contract_exception, Profile),
    decide_request_basis(Profile, request_basis_verdict(_, Citations)),
    Citations = [cite(_)|_].

cp_test_names([totality_every_subject_has_exactly_one_verdict, determinism_request_basis_has_one_answer, every_subject_has_one_profile, basis_projection_agrees_with_the_verdict_for_a_final_answer, verdict_citations_are_cite_terms]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
