:- module(m__eu_procurement_time_limits_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_status/2, minimum_days/2]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

minimum_days_never(Profile, Days) :-
    findall(Found, minimum_days(Profile, Found), FoundDays),
    not_member(Days, FoundDays).

time_limits_status_never(Profile, Status) :-
    findall(Found, time_limits_status(Profile, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

test('input mode: open baseline holds with days bound to 35') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    minimum_days(Profile, 35),
    time_limits_status(Profile, minimum_days_prescribed).
test('input mode: open baseline rejects a wrong bound day count') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    minimum_days_never(Profile, 30),
    minimum_days_never(Profile, 15).
test('input mode: restricted urgency tenders hold with days bound to 10') :-
    time_limits_profile_for("restricted_tenders_urgency", Profile),
    minimum_days(Profile, 10).
test('input mode: restricted urgency tenders reject the unreduced 30') :-
    time_limits_profile_for("restricted_tenders_urgency", Profile),
    minimum_days_never(Profile, 30).
test('input mode: dialogue tenders reject minimum_days_prescribed status') :-
    time_limits_profile_for("dialogue_tenders", Profile),
    time_limits_status(Profile, no_minimum_prescribed),
    time_limits_status_never(Profile, minimum_days_prescribed).
test('input mode: open request-stage rejects both day-table statuses') :-
    time_limits_profile_for("open_participation_requests", Profile),
    time_limits_status(Profile, stage_not_applicable),
    time_limits_status_never(Profile, minimum_days_prescribed),
    time_limits_status_never(Profile, no_minimum_prescribed).

cp_test_names(['input mode: open baseline holds with days bound to 35', 'input mode: open baseline rejects a wrong bound day count', 'input mode: restricted urgency tenders hold with days bound to 10', 'input mode: restricted urgency tenders reject the unreduced 30', 'input mode: dialogue tenders reject minimum_days_prescribed status', 'input mode: open request-stage rejects both day-table statuses']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
