% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [decide_cra_art14_manufacturer_reporting/2, severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_subject/1, cra_art14_manufacturer_reporting_profile_for/2]).

event_atom(actively_exploited_vulnerability).
event_atom(incident_impacting_product_security).

probe_date(date(2025, 12, 31)).
probe_date(date(2026, 9, 10)).
probe_date(date(2026, 9, 11)).
probe_date(date(2030, 1, 1)).

step_atom(early_warning).
step_atom(notification).

probe_hours(0).
probe_hours(24).
probe_hours(25).
probe_hours(72).
probe_hours(73).

subject_profile(Subject, Profile) :-
    cra_art14_manufacturer_reporting_subject(Subject),
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile).

well_formed_subject_profile(Subject, Profile) :-
    subject_profile(Subject, Profile),
    cra_art14_manufacturer_reporting_input_problems(Profile, []).

non_final_status(indeterminate(_MissingKeys)).
non_final_status(needs_legal_review(_Reason, _Context)).
non_final_status(input_problems(_Problems)).

step_name(step_due(StepName, _Limit, _Citation), StepName).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_cra_art14_manufacturer_reporting(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_cra_art14_manufacturer_reporting(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

steps_solution_count(Subject, Event, AwarenessDate, Count) :-
    subject_profile(Subject, Profile),
    event_atom(Event),
    probe_date(AwarenessDate),
    findall(Steps, manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps), Solutions),
    length(Solutions, Count).

timeliness_solution_count(Subject, Event, ReportingStep, Hours, Count) :-
    subject_profile(Subject, Profile),
    event_atom(Event),
    step_atom(ReportingStep),
    probe_hours(Hours),
    findall(Result, manufacturer_reporting_step_timeliness(Profile, Event, ReportingStep, Hours, Result), Solutions),
    length(Solutions, Count).

test(totality_every_subject_classifies) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Count, subject_verdict_count(_Subject, Count), Counts),
    sort(Counts, [1]).
test(totality_and_determinism_of_the_steps) :-
    findall(Count, steps_solution_count(_Subject, _Event, _AwarenessDate, Count), Counts),
    sort(Counts, [1]).
test(totality_and_determinism_of_the_timeliness) :-
    findall(Count, timeliness_solution_count(_Subject, _Event, _ReportingStep, _Hours, Count), Counts),
    sort(Counts, [1]).
test(severity_citations_come_from_the_vocabulary) :-
    findall(CitationKey, (subject_profile(_Subject, Profile), severe_incident_status(Profile, _Status, Citations), member(cite(CitationKey), Citations)), CitationKeys),
    sort(CitationKeys, UsedKeys),
    subtract(UsedKeys, [eu_reg_2024_2847_art_14_5, eu_reg_2024_2847_art_14_5_a, eu_reg_2024_2847_art_14_5_b], ForeignKeys),
    ForeignKeys == [].
test(every_non_final_severity_status_has_no_citation) :-
    findall(Citations, (subject_profile(_Subject, Profile), severe_incident_status(Profile, Status, Citations), non_final_status(Status)), CitationLists),
    sort(CitationLists, DistinctLists),
    DistinctLists == [[]].
test(every_severe_answer_cites_paragraph_5_itself) :-
    findall(Citations, (subject_profile(_Subject, Profile), severe_incident_status(Profile, severe, Citations)), CitationLists),
    sort(CitationLists, DistinctLists),
    DistinctLists == [[cite(eu_reg_2024_2847_art_14_5)]].
test(step_citations_come_from_the_vocabulary) :-
    findall(CitationKey, (subject_profile(_Subject, Profile), event_atom(Event), probe_date(AwarenessDate), manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps), Steps = [_|_], member(step_due(_StepName, _Limit, cite(CitationKey)), Steps)), CitationKeys),
    sort(CitationKeys, UsedKeys),
    subtract(UsedKeys, [eu_reg_2024_2847_art_14_2_a, eu_reg_2024_2847_art_14_2_b, eu_reg_2024_2847_art_14_2_c, eu_reg_2024_2847_art_14_4_a, eu_reg_2024_2847_art_14_4_b, eu_reg_2024_2847_art_14_4_c, eu_reg_2024_2847_art_14_6], ForeignKeys),
    ForeignKeys == [],
    UsedKeys = [_|_].
test(vulnerability_steps_read_no_key) :-
    findall(Steps, (well_formed_subject_profile(_Subject, Profile), manufacturer_reporting_steps(Profile, actively_exploited_vulnerability, date(2027, 6, 1), Steps)), StepLists),
    sort(StepLists, DistinctLists),
    DistinctLists = [[_|_]].
test(every_step_list_keeps_the_fixed_order) :-
    findall(StepNames, (subject_profile(_Subject, Profile), event_atom(Event), probe_date(AwarenessDate), manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps), Steps = [_|_], maplist(step_name, Steps, StepNames)), NameLists),
    sort(NameLists, DistinctLists),
    DistinctLists == [[early_warning, notification, final_report, intermediate_report]].
test(before_application_no_step_whatever_the_profile) :-
    findall(Steps, (well_formed_subject_profile(_Subject, Profile), event_atom(Event), manufacturer_reporting_steps(Profile, Event, date(2026, 9, 10), Steps)), StepLists),
    sort(StepLists, DistinctLists),
    DistinctLists == [[]].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, totality_and_determinism_of_the_steps, totality_and_determinism_of_the_timeliness, severity_citations_come_from_the_vocabulary, every_non_final_severity_status_has_no_citation, every_severe_answer_cites_paragraph_5_itself, step_citations_come_from_the_vocabulary, vulnerability_steps_read_no_key, every_step_list_keeps_the_fixed_order, before_application_no_step_whatever_the_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
