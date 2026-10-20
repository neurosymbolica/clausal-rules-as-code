:- module(m__eu_procurement_time_limits_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_kernel).
:- use_module(m__eu_procurement_time_limits_time_limits).

test('schema status atoms load and are distinct') :-
    dif(minimum_days_prescribed, no_minimum_prescribed),
    dif(minimum_days_prescribed, stage_not_applicable),
    dif(no_minimum_prescribed, stage_not_applicable).
test('stage atoms load and are distinct') :-
    dif(receipt_of_tenders, receipt_of_participation_requests).
test('reduction-condition atoms load and are distinct') :-
    dif(baseline_minimum, with_prior_information_notice),
    dif(with_prior_information_notice, with_electronic_submission),
    dif(with_electronic_submission, under_state_of_urgency),
    dif(baseline_minimum, under_state_of_urgency).
test('verdict constructor round-trips its four slots') :-
    Verdict = time_limits_verdict(minimum_days_prescribed, 35, meets_prescribed_minimum, []),
    Verdict = time_limits_verdict(Status, MinimumDays, Conformity, Citations),
    Status = minimum_days_prescribed,
    MinimumDays #= 35,
    Conformity = meets_prescribed_minimum,
    Citations = [].
test('n_a is a distinct day-slot marker') :-
    dif(n_a, minimum_days_prescribed),
    Verdict = time_limits_verdict(no_minimum_prescribed, n_a, no_prescribed_minimum_to_meet, []),
    Verdict = time_limits_verdict(_, DaySlot, _, _),
    DaySlot = n_a.
test('conformity atoms load and are pairwise distinct') :-
    dif(meets_prescribed_minimum, shorter_than_prescribed_minimum),
    dif(meets_prescribed_minimum, observed_days_not_supplied),
    dif(meets_prescribed_minimum, no_prescribed_minimum_to_meet),
    dif(shorter_than_prescribed_minimum, observed_days_not_supplied),
    dif(shorter_than_prescribed_minimum, no_prescribed_minimum_to_meet),
    dif(observed_days_not_supplied, no_prescribed_minimum_to_meet).
test('the conformity vocabulary is disjoint from the status vocabulary') :-
    dif(meets_prescribed_minimum, minimum_days_prescribed),
    dif(no_prescribed_minimum_to_meet, no_minimum_prescribed),
    dif(no_prescribed_minimum_to_meet, stage_not_applicable),
    dif(observed_days_not_supplied, n_a).

cp_test_names(['schema status atoms load and are distinct', 'stage atoms load and are distinct', 'reduction-condition atoms load and are distinct', 'verdict constructor round-trips its four slots', 'n_a is a distinct day-slot marker', 'conformity atoms load and are pairwise distinct', 'the conformity vocabulary is disjoint from the status vocabulary']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
