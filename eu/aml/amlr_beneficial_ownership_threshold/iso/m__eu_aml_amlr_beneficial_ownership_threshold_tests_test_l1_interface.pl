:- module(m__eu_aml_amlr_beneficial_ownership_threshold_tests_test_l1_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [assess_amlr_bo/3, amlr_bo_decision/2, requirement/4, amlr_bo_checklist/2, amlr_bo_requirement_ids/1, amlr_bo_minimum_holding_bps/1, amlr_bo_effective_holding_bps/2]).

q_bo(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[3000]]]).

q_below(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[5000, 4999]]]).

q_missing(Profile) :-
    dict_pairs(Profile, []).

q_boundary(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[5000, 5000]]]).

test('PI direct 30pct -> eligible (beneficial owner)') :-
    q_bo(P),
    amlr_bo_decision(P, eligible).
test('PI product 50x50 = 25pct boundary -> eligible (beneficial owner)') :-
    q_boundary(P),
    amlr_bo_decision(P, eligible).
test('PI 50x49.99 below -> ineligible (not a beneficial owner)') :-
    q_below(P),
    amlr_bo_decision(P, ineligible).
test('PI missing chains -> indeterminate') :-
    q_missing(P),
    amlr_bo_decision(P, indeterminate).
test('DET eligible') :-
    q_bo(P),
    findall(X, amlr_bo_decision(P, X), L),
    length(L, 1).
test('DET ineligible') :-
    q_below(P),
    findall(X, amlr_bo_decision(P, X), L),
    length(L, 1).
test('DET indeterminate') :-
    q_missing(P),
    findall(X, amlr_bo_decision(P, X), L),
    length(L, 1).
test('checklist has 1 item') :-
    q_bo(P),
    amlr_bo_checklist(P, Checklist),
    length(Checklist, 1).
test('threshold item met + cited to Art 52(1)') :-
    q_bo(P),
    requirement(required_ownership_threshold, P, met, cite(eu_reg_2024_1624_art_52_1)).
test('item unmet(REASON) when below threshold') :-
    q_below(P),
    requirement(required_ownership_threshold, P, unmet(effective_holding_below_25_percent_threshold), _).
test('item unknown(KEYS) names the missing chains key') :-
    q_missing(P),
    requirement(required_ownership_threshold, P, unknown([ownership_chains]), cite(eu_reg_2024_1624_art_52_1)).
test('Art 52 minimum is 2500 basis points') :-
    amlr_bo_minimum_holding_bps(B),
    B #= 2500.
test('effective holding of 50x50 chain is 2500 basis points') :-
    amlr_bo_effective_holding_bps([[5000, 5000]], B),
    B #= 2500.
test('requirement ids is the singleton threshold set') :-
    amlr_bo_requirement_ids([required_ownership_threshold]).
test('assess yields assessment(subject, eligible, checklist)') :-
    q_bo(P),
    assess_amlr_bo("s", P, assessment("s", eligible, Checklist)),
    length(Checklist, 1).

cp_test_names(['PI direct 30pct -> eligible (beneficial owner)', 'PI product 50x50 = 25pct boundary -> eligible (beneficial owner)', 'PI 50x49.99 below -> ineligible (not a beneficial owner)', 'PI missing chains -> indeterminate', 'DET eligible', 'DET ineligible', 'DET indeterminate', 'checklist has 1 item', 'threshold item met + cited to Art 52(1)', 'item unmet(REASON) when below threshold', 'item unknown(KEYS) names the missing chains key', 'Art 52 minimum is 2500 basis points', 'effective holding of 50x50 chain is 2500 basis points', 'requirement ids is the singleton threshold set', 'assess yields assessment(subject, eligible, checklist)']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
