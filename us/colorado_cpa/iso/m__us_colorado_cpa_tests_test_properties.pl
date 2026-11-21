% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_colorado_cpa, [decide_colorado_cpa/2, applicability_status/3, minors_duties_applicability/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, extended_appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, universal_opt_out_recognition_date/4]).
:- use_module(m__us_colorado_cpa_fixtures, [colorado_cpa_subject/1, colorado_cpa_profile_for/2]).

answer_count(Template, Goal, Count) :-
    findall(Template, Goal, Answers),
    length(Answers, Count).

subject_has_one_verdict(Subject) :-
    colorado_cpa_profile_for(Subject, Profile),
    answer_count(Verdict, decide_colorado_cpa(Profile, Verdict), 1).

every_query_answers_once(Subject) :-
    colorado_cpa_profile_for(Subject, Profile),
    answer_count(Result - Citations, applicability_status(Profile, Result, Citations), 1),
    answer_count(Result - Citations, minors_duties_applicability(Profile, Result, Citations), 1),
    answer_count(Deadline - Citations, response_deadline(Profile, date(2026, 1, 1), Deadline, Citations), 1),
    answer_count(Deadline - Citations, extended_response_deadline(Profile, date(2026, 1, 1), Deadline, Citations), 1),
    answer_count(Deadline - Citations, appeal_response_deadline(Profile, date(2026, 3, 1), Deadline, Citations), 1),
    answer_count(Deadline - Citations, extended_appeal_response_deadline(Profile, date(2026, 3, 1), Deadline, Citations), 1),
    answer_count(LastDay - Citations, cure_period_last_day(Profile, date(2026, 3, 1), LastDay, Citations), 1),
    answer_count(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), Result, Citations), 1),
    answer_count(FirstDay - Citations, universal_opt_out_recognition_date(Profile, date(2025, 1, 15), FirstDay, Citations), 1).

verdict_citations_consistent(colorado_cpa_verdict(Status, [_|_])) :-
    atom(Status).
verdict_citations_consistent(colorado_cpa_verdict(Status, [])) :-
    compound(Status).

subject_verdict_consistent(Subject) :-
    colorado_cpa_profile_for(Subject, Profile),
    decide_colorado_cpa(Profile, Verdict),
    verdict_citations_consistent(Verdict).

status_for_count(Revenue, Count, Status) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, Count), attribute(revenue_or_discount_from_sale, Revenue), attribute(processes_biometric_data, false)], Status, _).

cure_last_day_for(NoticeReceived, LastDay) :-
    cure_period_last_day([], NoticeReceived, LastDay, _).

action_status_for(ReferenceDate, Result) :-
    attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true), attribute(cured_within_cure_period, false)], date(2026, 3, 1), ReferenceDate, Result, _).

test(totality_and_determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, colorado_cpa_subject(Subject), Subjects),
    findall(Subject, (colorado_cpa_subject(Subject), subject_has_one_verdict(Subject)), SingleSubjects),
    SingleSubjects == Subjects.
test(every_query_yields_exactly_one_solution_for_every_subject) :-
    findall(Subject, colorado_cpa_subject(Subject), Subjects),
    findall(Subject, (colorado_cpa_subject(Subject), every_query_answers_once(Subject)), SingleSubjects),
    SingleSubjects == Subjects.
test(final_answers_cite_and_open_answers_do_not) :-
    findall(Subject, colorado_cpa_subject(Subject), Subjects),
    findall(Subject, (colorado_cpa_subject(Subject), subject_verdict_consistent(Subject)), ConsistentSubjects),
    ConsistentSubjects == Subjects.
test(the_sale_threshold_is_monotone_in_the_count) :-
    maplist(status_for_count(true), [0, 24999, 25000, 99999, 100000, 1000000], Statuses),
    Statuses == [out_of_scope, out_of_scope, in_scope, in_scope, in_scope, in_scope].
test(the_general_threshold_is_monotone_in_the_count) :-
    maplist(status_for_count(false), [0, 24999, 25000, 99999, 100000, 1000000], Statuses),
    Statuses == [out_of_scope, out_of_scope, out_of_scope, out_of_scope, in_scope, in_scope].
test(the_cure_provision_window_has_its_edges) :-
    maplist(cure_last_day_for, [date(2025, 9, 30), date(2025, 10, 1), date(2026, 12, 30), date(2026, 12, 31)], LastDays),
    LastDays == [cure_provision_not_in_force, date(2025, 11, 30), date(2027, 2, 28), cure_provision_not_in_force].
test(the_action_status_moves_through_its_phases) :-
    maplist(action_status_for, [date(2025, 9, 30), date(2026, 2, 28), date(2026, 3, 1), date(2026, 4, 30), date(2026, 5, 1), date(2026, 12, 30), date(2026, 12, 31)], Results),
    Results == [cure_provision_not_in_force, notice_not_yet_received, cure_period_running, cure_period_running, action_may_be_brought, action_may_be_brought, cure_provision_not_in_force].

cp_test_names([totality_and_determinism_every_subject_has_exactly_one_verdict, every_query_yields_exactly_one_solution_for_every_subject, final_answers_cite_and_open_answers_do_not, the_sale_threshold_is_monotone_in_the_count, the_general_threshold_is_monotone_in_the_count, the_cure_provision_window_has_its_edges, the_action_status_moves_through_its_phases]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
