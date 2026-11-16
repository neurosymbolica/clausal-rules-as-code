% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, incident_reporting_steps/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_subject/1, nis2_incident_reporting_profile_for/2]).

subject_classifies(Subject) :-
    nis2_incident_reporting_subject(Subject),
    nis2_incident_reporting_profile_for(Subject, Profile),
    decide_nis2_incident_reporting(Profile, _Verdict).

subject_has_one_verdict(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_incident_reporting(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_steps_answer(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), StepAnswers),
    length(StepAnswers, 1).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    maplist(subject_has_one_verdict, Subjects).
test(determinism_every_subject_has_exactly_one_steps_answer) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    maplist(subject_has_one_steps_answer, Subjects).
test(final_verdicts_carry_citations) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(significant, [_|_])).
test(non_final_verdicts_carry_no_citations) :-
    nis2_incident_reporting_profile_for(no_keys_given, Profile),
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(indeterminate(_), [])).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_steps_answer, final_verdicts_carry_citations, non_final_verdicts_carry_no_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
