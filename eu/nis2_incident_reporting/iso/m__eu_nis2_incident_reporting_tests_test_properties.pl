% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_subject/1, nis2_incident_reporting_profile_for/2]).

probe_hours([0, 1, 24, 25, 48, 72, 73, 200]).

allowed_citation(eu_dir_2022_2555_art_23_3_a).
allowed_citation(eu_dir_2022_2555_art_23_3_b).

cited_from_vocabulary(cite(Key)) :-
    allowed_citation(Key).

final_or_uncited(significant, [_]).
final_or_uncited(not_significant, [_, _]).
final_or_uncited(indeterminate([_]), []).
final_or_uncited(needs_legal_review(_, _), []).
final_or_uncited(input_problems([_|_]), []).

agrees(significant, [step_due(early_warning, _, _)|_]).
agrees(significant, indeterminate([_])).
agrees(not_significant, []).
agrees(indeterminate(Keys), indeterminate(Keys)).
agrees(needs_legal_review(_, _), indeterminate([_])).
agrees(needs_legal_review(Reason, _), needs_legal_review(Reason, _)).
agrees(input_problems(Problems), input_problems(Problems)).

all_subjects(Subjects) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects).

subject_classifies(Subject) :-
    nis2_incident_reporting_subject(Subject),
    nis2_incident_reporting_profile_for(Subject, Profile),
    decide_nis2_incident_reporting(Profile, _Verdict).

one_significance_answer(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Status - Citations, incident_significance(Profile, Status, Citations), [Answer]),
    ground(Answer).

one_steps_answer(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), [Answer]),
    ground(Answer).

one_timeliness_answer(Profile, Step, Hours) :-
    findall(Result, reporting_step_timeliness(Profile, Step, Hours, Result), [Answer]),
    ground(Answer).

timeliness_is_deterministic(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    probe_hours(HoursList),
    maplist(one_timeliness_answer(Profile, early_warning), HoursList),
    maplist(one_timeliness_answer(Profile, incident_notification), HoursList).

citations_are_well_formed(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    incident_significance(Profile, Status, Citations),
    final_or_uncited(Status, Citations),
    maplist(cited_from_vocabulary, Citations).

status_agrees_with_steps(Subject) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    incident_significance(Profile, Status, _Citations),
    incident_reporting_steps(Profile, Steps),
    agrees(Status, Steps).

late_early_warning(Hours) :-
    reporting_step_timeliness([], early_warning, Hours, late(hour_limit)).

late_notification(Hours) :-
    reporting_step_timeliness([], incident_notification, Hours, late(hour_limit)).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_of_significance) :-
    all_subjects(Subjects),
    maplist(one_significance_answer, Subjects).
test(determinism_of_steps) :-
    all_subjects(Subjects),
    maplist(one_steps_answer, Subjects).
test(determinism_of_timeliness) :-
    all_subjects(Subjects),
    maplist(timeliness_is_deterministic, Subjects).
test(determinism_of_timeliness_on_an_empty_profile) :-
    probe_hours(HoursList),
    maplist(one_timeliness_answer([], early_warning), HoursList),
    maplist(one_timeliness_answer([], incident_notification), HoursList).
test(citations_come_from_the_vocabulary_and_only_on_final_statuses) :-
    all_subjects(Subjects),
    maplist(citations_are_well_formed, Subjects).
test(significance_agrees_with_the_steps) :-
    all_subjects(Subjects),
    maplist(status_agrees_with_steps, Subjects).
test(early_warning_stays_late_after_24_hours) :-
    numlist(25, 120, HoursList),
    maplist(late_early_warning, HoursList).
test(notification_stays_late_after_72_hours) :-
    numlist(73, 150, HoursList),
    maplist(late_notification, HoursList).

test(early_warning_is_never_hour_late_within_24_hours, fail) :-
    between(0, 24, Hours),
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, Hours, late(hour_limit)).
test(notification_is_never_hour_late_within_72_hours_for_an_ordinary_provider, fail) :-
    between(0, 72, Hours),
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, Hours, late(hour_limit)).

cp_test_names([totality_every_subject_classifies, determinism_of_significance, determinism_of_steps, determinism_of_timeliness, determinism_of_timeliness_on_an_empty_profile, citations_come_from_the_vocabulary_and_only_on_final_statuses, significance_agrees_with_the_steps, early_warning_stays_late_after_24_hours, notification_stays_late_after_72_hours]).
cp_test_fail_names([early_warning_is_never_hour_late_within_24_hours, notification_is_never_hour_late_within_72_hours_for_an_ordinary_provider]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
