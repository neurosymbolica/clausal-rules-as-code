:- module(m__eu_aml_amlr_beneficial_ownership_threshold_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_threshold/1, amlr_bo_effective_holding/2, amlr_bo_status/2]).

test('threshold value is 2500 basis points') :-
    amlr_bo_threshold(T),
    T #= 2500.
test('DET bo_threshold') :-
    findall(T, amlr_bo_threshold(T), L),
    length(L, 1).
test('direct 25pct holding equals 2500 BP') :-
    amlr_bo_effective_holding([[2500]], Total),
    Total #= 2500.
test('direct 30pct holding equals 3000 BP') :-
    amlr_bo_effective_holding([[3000]], Total),
    Total #= 3000.
test('indirect chain 60pct times 50pct equals 3000 BP') :-
    amlr_bo_effective_holding([[6000, 5000]], Total),
    Total #= 3000.
test('parallel chains 10pct plus 20pct equals 3000 BP') :-
    amlr_bo_effective_holding([[1000], [2000]], Total),
    Total #= 3000.
test('three-level chain 80pct times 50pct times 80pct equals 3200 BP') :-
    amlr_bo_effective_holding([[8000, 5000, 8000]], Total),
    Total #= 3200.
test('indirect chain 30pct times 8pct equals 240 BP') :-
    amlr_bo_effective_holding([[3000, 800]], Total),
    Total #= 240.
test('DET bo_effective_holding single direct chain') :-
    findall(T, amlr_bo_effective_holding([[2500]], T), L),
    length(L, 1).
test('DET bo_effective_holding indirect chain') :-
    findall(T, amlr_bo_effective_holding([[6000, 5000]], T), L),
    length(L, 1).
test('DET bo_effective_holding parallel chains') :-
    findall(T, amlr_bo_effective_holding([[1000], [2000]], T), L),
    length(L, 1).
test('direct holding above threshold is eligible') :-
    amlr_bo_status([[3000]], S),
    S = eligible.
test('direct holding at exact threshold is eligible') :-
    amlr_bo_status([[2500]], S),
    S = eligible.
test('direct holding below threshold is ineligible') :-
    amlr_bo_status([[2000]], S),
    S = ineligible.
test('parallel chains summing to 30pct is eligible') :-
    amlr_bo_status([[1000], [2000]], S),
    S = eligible.
test('indirect chain below threshold is ineligible') :-
    amlr_bo_status([[3000, 800]], S),
    S = ineligible.
test('indirect chain above threshold is eligible') :-
    amlr_bo_status([[6000, 5000]], S),
    S = eligible.
test('DET bo_status above threshold') :-
    findall(S, amlr_bo_status([[3000]], S), L),
    length(L, 1).
test('DET bo_status below threshold') :-
    findall(S, amlr_bo_status([[2000]], S), L),
    length(L, 1).
test('DET bo_status at threshold') :-
    findall(S, amlr_bo_status([[2500]], S), L),
    length(L, 1).

cp_test_names(['threshold value is 2500 basis points', 'DET bo_threshold', 'direct 25pct holding equals 2500 BP', 'direct 30pct holding equals 3000 BP', 'indirect chain 60pct times 50pct equals 3000 BP', 'parallel chains 10pct plus 20pct equals 3000 BP', 'three-level chain 80pct times 50pct times 80pct equals 3200 BP', 'indirect chain 30pct times 8pct equals 240 BP', 'DET bo_effective_holding single direct chain', 'DET bo_effective_holding indirect chain', 'DET bo_effective_holding parallel chains', 'direct holding above threshold is eligible', 'direct holding at exact threshold is eligible', 'direct holding below threshold is ineligible', 'parallel chains summing to 30pct is eligible', 'indirect chain below threshold is ineligible', 'indirect chain above threshold is eligible', 'DET bo_status above threshold', 'DET bo_status below threshold', 'DET bo_status at threshold']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
