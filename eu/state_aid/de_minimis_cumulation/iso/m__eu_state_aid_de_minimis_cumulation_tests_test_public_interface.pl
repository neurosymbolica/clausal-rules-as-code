:- module(m__eu_state_aid_de_minimis_cumulation_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_ceiling/1, de_minimis_aid_in_window/3, de_minimis_verdict/3]).

test('ceiling is 30000000 euro-cents') :-
    de_minimis_ceiling(C),
    C #= 30000000.
test('DET ceiling') :-
    findall(C, de_minimis_ceiling(C), L),
    length(L, 1).
test('aid sums only grants within 3-year window') :-
    de_minimis_aid_in_window([[date(2023, 1, 1), 5000000], [date(2022, 1, 1), 10000000], [date(2020, 1, 1), 20000000]], date(2024, 1, 1), Total),
    Total #= 15000000.
test('aid with empty grants list is zero') :-
    de_minimis_aid_in_window([], date(2024, 1, 1), Total),
    Total #= 0.
test('grant on ref date itself is included') :-
    de_minimis_aid_in_window([[date(2024, 1, 1), 7000000]], date(2024, 1, 1), Total),
    Total #= 7000000.
test('DET aid in window') :-
    findall(T, de_minimis_aid_in_window([[date(2023, 1, 1), 5000000]], date(2024, 1, 1), T), L),
    length(L, 1).
test('verdict eligible when total under limit') :-
    de_minimis_verdict([[date(2023, 1, 1), 5000000], [date(2022, 1, 1), 10000000]], date(2024, 1, 1), V),
    V = eligible.
test('verdict eligible when total equals ceiling') :-
    de_minimis_verdict([[date(2023, 1, 1), 30000000]], date(2024, 1, 1), V),
    V = eligible.
test('verdict ineligible when total over ceiling') :-
    de_minimis_verdict([[date(2023, 1, 1), 20000000], [date(2022, 6, 1), 15000000]], date(2024, 1, 1), V),
    V = ineligible.
test('DET verdict') :-
    findall(V, de_minimis_verdict([[date(2023, 1, 1), 5000000]], date(2024, 1, 1), V), L),
    length(L, 1).

cp_test_names(['ceiling is 30000000 euro-cents', 'DET ceiling', 'aid sums only grants within 3-year window', 'aid with empty grants list is zero', 'grant on ref date itself is included', 'DET aid in window', 'verdict eligible when total under limit', 'verdict eligible when total equals ceiling', 'verdict ineligible when total over ceiling', 'DET verdict']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
