% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_route/2, information_items_owed/2, information_items_missing/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_subject/1, gdpr_information_duties_items_and_further_processing_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_information_duties_items_and_further_processing_subject(Subject),
    gdpr_information_duties_items_and_further_processing_profile_for(Subject, Profile).

single_route(Subject) :-
    subject_profile(Subject, Profile),
    findall(Answer, information_route(Profile, Answer), Answers),
    length(Answers, 1).

single_owed(Subject) :-
    subject_profile(Subject, Profile),
    findall(Answer, information_items_owed(Profile, Answer), Answers),
    length(Answers, 1).

single_missing(Subject) :-
    subject_profile(Subject, Profile),
    findall(Answer, information_items_missing(Profile, Answer), Answers),
    length(Answers, 1).

single_further(Subject) :-
    subject_profile(Subject, Profile),
    findall(Verdict - Cites, further_processing_information_verdict(Profile, Verdict, Cites), Answers),
    length(Answers, 1).

owed_shape_ok(Subject) :-
    subject_profile(Subject, Profile),
    information_items_owed(Profile, Answer),
    owed_shape(Answer).

owed_shape([owed_item(_, _)|_]).
owed_shape(needs_legal_review(_, _)).

missing_shape_ok(Subject) :-
    subject_profile(Subject, Profile),
    information_items_missing(Profile, Answer),
    missing_shape(Answer).

missing_shape([missing_item(_, _)|_]).
missing_shape([no_item_missing]).
missing_shape(needs_legal_review(_, _)).

cites_ok(Subject) :-
    subject_profile(Subject, Profile),
    further_processing_information_verdict(Profile, Verdict, Cites),
    decided_cites(Verdict, Cites).

decided_cites(eligible, [cite(_)]).
decided_cites(ineligible, [cite(_)]).
decided_cites(not_applicable, []).
decided_cites(indeterminate(_), []).
decided_cites(needs_legal_review(_, _), []).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_information_duties_items_and_further_processing_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

test(the_subject_set_is_not_empty) :-
    subject_set([_|_]).
test(totality_and_determinism_of_the_route) :-
    subject_set(SubjectSet),
    findall(Subject, single_route(Subject), Found),
    sort(Found, SubjectSet).
test(totality_and_determinism_of_the_owed_list) :-
    subject_set(SubjectSet),
    findall(Subject, single_owed(Subject), Found),
    sort(Found, SubjectSet).
test(totality_and_determinism_of_the_missing_list) :-
    subject_set(SubjectSet),
    findall(Subject, single_missing(Subject), Found),
    sort(Found, SubjectSet).
test(totality_and_determinism_of_the_further_verdict) :-
    subject_set(SubjectSet),
    findall(Subject, single_further(Subject), Found),
    sort(Found, SubjectSet).
test(an_owed_answer_is_never_the_empty_list) :-
    subject_set(SubjectSet),
    findall(Subject, owed_shape_ok(Subject), Found),
    sort(Found, SubjectSet).
test(a_missing_answer_is_never_the_empty_list) :-
    subject_set(SubjectSet),
    findall(Subject, missing_shape_ok(Subject), Found),
    sort(Found, SubjectSet).
test(a_decided_further_verdict_carries_one_citation) :-
    subject_set(SubjectSet),
    findall(Subject, cites_ok(Subject), Found),
    sort(Found, SubjectSet).

cp_test_names([the_subject_set_is_not_empty, totality_and_determinism_of_the_route, totality_and_determinism_of_the_owed_list, totality_and_determinism_of_the_missing_list, totality_and_determinism_of_the_further_verdict, an_owed_answer_is_never_the_empty_list, a_missing_answer_is_never_the_empty_list, a_decided_further_verdict_carries_one_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
