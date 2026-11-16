% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [decide_request_basis/2, decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_kernel, [gdpr_data_subject_rights_access_rectification_restriction_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_fixtures, [gdpr_data_subject_rights_access_rectification_restriction_subject/1, gdpr_data_subject_rights_access_rectification_restriction_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_access_rectification_restriction_subject(Subject),
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile),
    decide_request_basis(Profile, _Verdict).

subject_decided_once(Subject) :-
    gdpr_data_subject_rights_access_rectification_restriction_subject(Subject),
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), [_OnlyVerdict]).

subject_basis_once(Subject) :-
    gdpr_data_subject_rights_access_rectification_restriction_subject(Subject),
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile),
    findall(Basis, request_basis(Profile, Basis), [_OnlyBasis]).

subject_checked_once(Subject) :-
    gdpr_data_subject_rights_access_rectification_restriction_subject(Subject),
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile),
    findall(Problems, gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, Problems), [_OnlyProblems]).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), Subjects),
    findall(Subject, subject_decided_once(Subject), DecidedSubjects),
    DecidedSubjects == Subjects.
test(determinism_every_subject_has_exactly_one_basis) :-
    findall(Subject, gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), Subjects),
    findall(Subject, subject_basis_once(Subject), BasisSubjects),
    BasisSubjects == Subjects.
test(determinism_the_input_check_has_exactly_one_answer) :-
    findall(Subject, gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), Subjects),
    findall(Subject, subject_checked_once(Subject), CheckedSubjects),
    CheckedSubjects == Subjects.
test(invariant_must_comply_never_names_an_exception) :-
    findall(Exception, (gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile), decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, _, Exception, _, _))), Exceptions),
    sort(Exceptions, [none]).
test(invariant_every_must_comply_carries_a_citation) :-
    findall(Citations, (gdpr_data_subject_rights_access_rectification_restriction_subject(Subject), gdpr_data_subject_rights_access_rectification_restriction_profile_for(Subject, Profile), decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, _, _, _, Citations))), CitationLists),
    CitationLists = [_|_],
    sort(CitationLists, SortedLists),
    member([], SortedLists, false).

member(_, [], false).
member(Item, [Head|_], true) :-
    Item == Head.
member(Item, [Head|Tail], Truth) :-
    dif(Item, Head),
    member(Item, Tail, Truth).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_basis, determinism_the_input_check_has_exactly_one_answer, invariant_must_comply_never_names_an_exception, invariant_every_must_comply_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
