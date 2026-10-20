:- module(m__eu_procurement_time_limits_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_status/2, minimum_days/2]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_profile_for/2]).

expected_minimum_days("open_tenders_baseline", 35).
expected_minimum_days("open_tenders_prior_information_notice", 15).
expected_minimum_days("open_tenders_electronic_submission", 30).
expected_minimum_days("open_tenders_urgency", 15).
expected_minimum_days("open_tenders_prior_notice_and_electronic", 15).
expected_minimum_days("restricted_requests_baseline", 30).
expected_minimum_days("restricted_requests_urgency", 15).
expected_minimum_days("restricted_tenders_baseline", 30).
expected_minimum_days("restricted_tenders_prior_information_notice", 10).
expected_minimum_days("restricted_tenders_electronic_submission", 25).
expected_minimum_days("restricted_tenders_urgency", 10).
expected_minimum_days("negotiation_requests_urgency", 15).
expected_minimum_days("negotiation_tenders_electronic_submission", 25).
expected_minimum_days("dialogue_requests_baseline", 30).
expected_minimum_days("dialogue_requests_urgency_claimed", 30).
expected_minimum_days("partnership_requests_baseline", 30).
expected_minimum_days("open_tenders_baseline_allowing_20", 35).
expected_minimum_days("open_tenders_baseline_allowing_34", 35).
expected_minimum_days("open_tenders_baseline_allowing_35", 35).
expected_minimum_days("open_tenders_prior_notice_allowing_20", 15).

subject_matches_expected_days(Subject) :-
    expected_minimum_days(Subject, ExpectedDays),
    time_limits_profile_for(Subject, Profile),
    findall(Days, minimum_days(Profile, Days), DaysList),
    DaysList = [ExpectedDays].

test('every prescribed-minimum subject yields exactly its published day count') :-
    findall(Subject, expected_minimum_days(Subject, _), ExpectedSubjectList),
    length(ExpectedSubjectList, ExpectedSubjectCount),
    ExpectedSubjectCount #= 20,
    findall(Subject, subject_matches_expected_days(Subject), MatchingSubjectList),
    length(MatchingSubjectList, ExpectedSubjectCount).
test('open baseline verdict is minimum_days_prescribed with citations') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    findall(Status, time_limits_status(Profile, Status), StatusList),
    StatusList = [minimum_days_prescribed],
    decide_time_limits(Profile, time_limits_verdict(_, _, _, Citations)),
    dif(Citations, []).
test('competitive-dialogue tenders yield no_minimum_prescribed with n_a days') :-
    time_limits_profile_for("dialogue_tenders", Profile),
    findall(Status, time_limits_status(Profile, Status), StatusList),
    StatusList = [no_minimum_prescribed],
    decide_time_limits(Profile, time_limits_verdict(no_minimum_prescribed, DaySlot, _, Citations)),
    DaySlot = n_a,
    dif(Citations, []).
test('innovation-partnership tenders yield no_minimum_prescribed with n_a days') :-
    time_limits_profile_for("partnership_tenders", Profile),
    findall(Status, time_limits_status(Profile, Status), StatusList),
    StatusList = [no_minimum_prescribed].
test('open participation-requests stage yields stage_not_applicable') :-
    time_limits_profile_for("open_participation_requests", Profile),
    findall(Status, time_limits_status(Profile, Status), StatusList),
    StatusList = [stage_not_applicable],
    decide_time_limits(Profile, time_limits_verdict(stage_not_applicable, DaySlot, _, _)),
    DaySlot = n_a.

cp_test_names(['every prescribed-minimum subject yields exactly its published day count', 'open baseline verdict is minimum_days_prescribed with citations', 'competitive-dialogue tenders yield no_minimum_prescribed with n_a days', 'innovation-partnership tenders yield no_minimum_prescribed with n_a days', 'open participation-requests stage yields stage_not_applicable']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
