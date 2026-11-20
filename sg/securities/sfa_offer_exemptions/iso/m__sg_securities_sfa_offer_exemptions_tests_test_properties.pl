% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [decide_sfa_offer_exemptions/2, sfa_offer_exemptions_status/2]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_subject/1, sfa_offer_exemptions_profile_for/2]).

subject_classifies(Subject) :-
    sfa_offer_exemptions_subject(Subject),
    sfa_offer_exemptions_profile_for(Subject, Profile),
    decide_sfa_offer_exemptions(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, sfa_offer_exemptions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Subject, sfa_offer_exemptions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_has_exactly_one_status(Subject), OneStatusSubjects),
    sort(OneStatusSubjects, SubjectSet).

subject_has_exactly_one_status(Subject) :-
    sfa_offer_exemptions_subject(Subject),
    sfa_offer_exemptions_profile_for(Subject, Profile),
    findall(Status, sfa_offer_exemptions_status(Profile, Status), Statuses),
    length(Statuses, 1).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
