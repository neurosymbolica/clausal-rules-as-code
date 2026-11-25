% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [decide_dora_rts_simplified_testing_continuity_and_report/2, simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_subject/1, dora_rts_simplified_testing_continuity_and_report_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, dora_rts_simplified_testing_continuity_and_report_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    dora_rts_simplified_testing_continuity_and_report_subject(Subject),
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    decide_dora_rts_simplified_testing_continuity_and_report(Profile, _Verdict).

subject_answers_once(Subject) :-
    dora_rts_simplified_testing_continuity_and_report_subject(Subject),
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1).

citations_fit(indeterminate(_), []).
citations_fit(needs_legal_review(_, _), []).
citations_fit(input_problems(_), []).
citations_fit(complete, [_|_]).
citations_fit(incomplete, [_|_]).
citations_fit(not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).

subject_citations_fit(Subject) :-
    dora_rts_simplified_testing_continuity_and_report_subject(Subject),
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations),
    citations_fit(Result, Citations).

subject_required_refers(Subject) :-
    dora_rts_simplified_testing_continuity_and_report_subject(Subject),
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, needs_legal_review(_, _), _).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_each_subject_once) :-
    subject_set(SubjectSet),
    findall(Subject, subject_answers_once(Subject), OnceSubjects),
    sort(OnceSubjects, SubjectSet).
test(statuses_carry_no_citations_and_final_answers_do) :-
    subject_set(SubjectSet),
    findall(Subject, subject_citations_fit(Subject), FittingSubjects),
    sort(FittingSubjects, SubjectSet).
test(complete_and_none_outstanding_agree) :-
    findall(Subject, (dora_rts_simplified_testing_continuity_and_report_subject(Subject), dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile), simplified_testing_continuity_and_report_duties_complete(Profile, complete, _)), CompleteSubjects),
    findall(Subject, (dora_rts_simplified_testing_continuity_and_report_subject(Subject), dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile), simplified_testing_continuity_and_report_duties_outstanding(Profile, none_outstanding, _)), NoneOutstandingSubjects),
    CompleteSubjects == NoneOutstandingSubjects,
    CompleteSubjects = [_|_].
test(required_answers_the_baseline_subject) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, required([_|_]), [_|_]).

test(required_never_refers, fail) :-
    subject_required_refers(_).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_each_subject_once, statuses_carry_no_citations_and_final_answers_do, complete_and_none_outstanding_agree, required_answers_the_baseline_subject]).
cp_test_fail_names([required_never_refers]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
