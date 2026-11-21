% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, decide_gdpr_art36_3_consultation_request/2, gdpr_art36_3_consultation_request_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_subject/1, gdpr_art36_3_consultation_request_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_art36_3_consultation_request_subject(Subject),
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    decide_gdpr_art36_3_consultation_request(Profile, _Verdict).

status_answer_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Result, consultation_request_status(Profile, Result, _Basis, _Citations), Results),
    length(Results, Count).

items_answer_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Items, missing_consultation_request_items(Profile, Items, _Basis, _Citations), Answers),
    length(Answers, Count).

input_check_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Problems, gdpr_art36_3_consultation_request_input_problems(Profile, Problems), Answers),
    length(Answers, Count).

checklist_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Items, gdpr_art36_3_consultation_request_checklist(Profile, Items), Answers),
    length(Answers, Count).

all_subjects(Subjects) :-
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_status) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), status_answer_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(determinism_every_subject_has_one_items_answer) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), items_answer_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(determinism_every_subject_has_one_input_check) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), input_check_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(determinism_every_subject_has_one_checklist) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), checklist_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(citations_are_none_one_or_seven) :-
    findall(Count, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, _, _, Citations), length(Citations, Count)), Counts),
    sort(Counts, DistinctCounts),
    subtract(DistinctCounts, [0, 1, 7], OtherCounts),
    OtherCounts == [].
test(an_open_status_carries_no_basis_and_no_citation) :-
    findall(Basis - Citations, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, indeterminate(_), Basis, Citations)), Shapes),
    sort(Shapes, DistinctShapes),
    DistinctShapes == [[] - []].
test(a_referral_carries_no_basis_and_no_citation) :-
    findall(Basis - Citations, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, needs_legal_review(_, _), Basis, Citations)), Shapes),
    sort(Shapes, DistinctShapes),
    DistinctShapes == [[] - []].
test(an_input_problem_carries_no_basis_and_no_citation) :-
    findall(Basis - Citations, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), missing_consultation_request_items(Profile, input_problems(_), Basis, Citations)), Shapes),
    sort(Shapes, DistinctShapes),
    DistinctShapes == [[] - []].
test(a_listed_missing_item_means_incomplete) :-
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), missing_consultation_request_items(Profile, [_|_], _, _)), ListedSubjects),
    findall(Subject, (member(Subject, ListedSubjects), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, consultation_request_incomplete, _, _)), IncompleteSubjects),
    ListedSubjects = [_|_],
    IncompleteSubjects == ListedSubjects.
test(an_empty_missing_list_means_complete) :-
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), missing_consultation_request_items(Profile, [], _, _)), EmptySubjects),
    findall(Subject, (member(Subject, EmptySubjects), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, consultation_request_complete, _, _)), CompleteSubjects),
    EmptySubjects = [_|_],
    CompleteSubjects == EmptySubjects.
test(an_unread_outside_fact_changes_no_answer) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    select(attribute(joint_controllers_or_processors_involved, _), Profile, OtherAttributes),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), WithFact),
    findall(Result - Basis - Citations, consultation_request_status(OtherAttributes, Result, Basis, Citations), WithoutFact),
    WithFact == WithoutFact.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_status, determinism_every_subject_has_one_items_answer, determinism_every_subject_has_one_input_check, determinism_every_subject_has_one_checklist, citations_are_none_one_or_seven, an_open_status_carries_no_basis_and_no_citation, a_referral_carries_no_basis_and_no_citation, an_input_problem_carries_no_basis_and_no_citation, a_listed_missing_item_means_incomplete, an_empty_missing_list_means_complete, an_unread_outside_fact_changes_no_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
