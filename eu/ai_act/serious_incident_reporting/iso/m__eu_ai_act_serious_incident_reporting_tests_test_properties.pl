% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2, serious_incident_report_duty/4, serious_incident_report_timeliness/5]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_profile_for/2]).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

subject_classifies(Subject) :-
    serious_incident_reporting_subject(Subject),
    serious_incident_reporting_profile_for(Subject, Case),
    decide_serious_incident_reporting(Case, _Verdict).

subject_verdict(Subject, Case, Status, Citations) :-
    serious_incident_reporting_subject(Subject),
    serious_incident_reporting_profile_for(Subject, Case),
    decide_serious_incident_reporting(Case, serious_incident_reporting_verdict(Status, Citations)).

verdict_count(Subject, Count) :-
    serious_incident_reporting_profile_for(Subject, Case),
    findall(Verdict, decide_serious_incident_reporting(Case, Verdict), Verdicts),
    length(Verdicts, Count).

not_final(indeterminate(_)).
not_final(needs_legal_review(_, _)).
not_final(input_problems(_)).

passed_through(indeterminate(_)).
passed_through(not_applicable_on_date).
passed_through(not_a_high_risk_ai_system).
passed_through(not_covered_placed_before_application_date).
passed_through(not_a_serious_incident).
passed_through(not_a_reportable_incident).

case_awareness(duty(_, AwarenessDate), AwarenessDate).
case_awareness(timeliness(_, AwarenessDate, _), AwarenessDate).

test(totality_every_subject_classifies) :-
    findall(Subject, serious_incident_reporting_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Count, (serious_incident_reporting_subject(Subject), verdict_count(Subject, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(some_answer_is_not_final) :-
    subject_verdict(classification_absent, _, Status, _),
    not_final(Status).
test(some_answer_is_a_report) :-
    subject_verdict(awareness_on_first_application_date, _, report_due(_, _, _, _), [_|_]).
test(the_last_day_witness_holds) :-
    subject_verdict(death_in_leap_year, duty(_, AwarenessDate), report_due(_, Days, LastDay, _), _),
    days_between(LastDay, AwarenessDate, Elapsed),
    Elapsed =:= Days.
test(timeliness_passes_not_applicable_through) :-
    serious_incident_reporting_profile_for(report_before_first_application_date, timeliness(Profile, AwarenessDate, ReportDate)),
    serious_incident_report_duty(Profile, AwarenessDate, Duty, DutyCitations),
    serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Duty, Citations),
    Citations == DutyCitations.

test(a_not_final_answer_carries_no_citation, fail) :-
    subject_verdict(_, _, Status, [_|_]),
    not_final(Status).
test(a_final_report_always_carries_a_citation, fail) :-
    subject_verdict(_, _, report_due(_, _, _, _), []).
test(the_follow_up_is_always_the_fixed_list, fail) :-
    subject_verdict(_, _, report_due(_, _, _, FollowUp), _),
    follow_up_list(Fixed),
    dif(FollowUp, Fixed).
test(the_days_are_always_two_ten_or_fifteen, fail) :-
    subject_verdict(_, _, report_due(_, Days, _, _), _),
    memberd_t(Days, [2, 10, 15], false).
test(the_last_day_is_days_after_awareness, fail) :-
    subject_verdict(_, Case, report_due(_, Days, LastDay, _), _),
    case_awareness(Case, AwarenessDate),
    days_between(LastDay, AwarenessDate, Elapsed),
    dif(Elapsed, Days).
test(timeliness_never_changes_a_no_duty_answer, fail) :-
    serious_incident_reporting_subject(Subject),
    serious_incident_reporting_profile_for(Subject, timeliness(Profile, AwarenessDate, ReportDate)),
    serious_incident_report_duty(Profile, AwarenessDate, Duty, _),
    passed_through(Duty),
    serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, _),
    dif(Verdict, Duty).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, some_answer_is_not_final, some_answer_is_a_report, the_last_day_witness_holds, timeliness_passes_not_applicable_through]).
cp_test_fail_names([a_not_final_answer_carries_no_citation, a_final_report_always_carries_a_citation, the_follow_up_is_always_the_fixed_list, the_days_are_always_two_ten_or_fifteen, the_last_day_is_days_after_awareness, timeliness_never_changes_a_no_duty_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
