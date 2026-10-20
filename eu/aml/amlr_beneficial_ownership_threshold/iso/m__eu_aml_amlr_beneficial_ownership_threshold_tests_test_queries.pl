:- module(m__eu_aml_amlr_beneficial_ownership_threshold_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_queries, [amlr_bo_diff/3, amlr_bo_what_if/3, amlr_bo_direct_boundary/1, amlr_bo_gap_to_threshold/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_threshold/1, amlr_bo_status/2]).

q_above(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[3000]]]).

q_below(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[2000]]]).

q_subbp(Profile) :-
    dict_pairs(Profile, [ownership_chains - [[5000, 4999]]]).

q_missing(Profile) :-
    dict_pairs(Profile, []).

test('diff: a profile against itself changes nothing') :-
    q_above(P),
    amlr_bo_diff(P, P, Changed),
    Changed = [].
test('diff: below vs above flips exactly the threshold row') :-
    q_below(A),
    q_above(B),
    amlr_bo_diff(A, B, Changed),
    Changed = [delta(required_ownership_threshold, unmet(effective_holding_below_25_percent_threshold), met)].
test('DET diff') :-
    q_below(A),
    q_above(B),
    findall(C, amlr_bo_diff(A, B, C), L),
    length(L, 1).
test('what-if: dropping to 20pct flips met -> unmet') :-
    q_above(P),
    amlr_bo_what_if(P, [[2000]], Changed),
    Changed = [delta(required_ownership_threshold, met, unmet(effective_holding_below_25_percent_threshold))].
test('what-if: a same-verdict change reports no delta') :-
    q_above(P),
    amlr_bo_what_if(P, [[2600]], Changed),
    Changed = [].
test('what-if: supplying chains to a chains-less profile resolves unknown -> met') :-
    q_missing(P),
    amlr_bo_what_if(P, [[5000, 5000]], Changed),
    Changed = [delta(required_ownership_threshold, unknown([ownership_chains]), met)].
test('what-if: the stored profile is untouched (re-diff still flips)') :-
    q_above(P),
    amlr_bo_what_if(P, [[2000]], _),
    amlr_bo_what_if(P, [[2000]], Changed),
    Changed = [delta(required_ownership_threshold, met, unmet(effective_holding_below_25_percent_threshold))].
test('boundary: located direct-holding cliff == declared Art 52(1) constant') :-
    amlr_bo_direct_boundary(B),
    amlr_bo_threshold(T),
    B #= T.
test('boundary: flip is ON the threshold (inclusive \'25% or more\')') :-
    amlr_bo_direct_boundary(B),
    amlr_bo_status([[B]], eligible),
    Below #= B - 1,
    amlr_bo_status([[Below]], ineligible).
test('DET boundary') :-
    findall(B, amlr_bo_direct_boundary(B), L),
    length(L, 1).
test('gap: direct 20pct needs exactly +500 bp') :-
    amlr_bo_gap_to_threshold([[2000]], 500).
test('gap: 24.995pct exact-rational aggregate needs +1 bp (ceil, not floor)') :-
    amlr_bo_gap_to_threshold([[5000, 4999]], 1).
test('gap: an already-qualifying holder needs 0') :-
    amlr_bo_gap_to_threshold([[3000]], 0).
test('gap: evidenced zero holdings need the full 2500 bp') :-
    amlr_bo_gap_to_threshold([], 2500).
test('gap MINIMALITY: gap flips the verdict, gap-1 does not') :-
    amlr_bo_gap_to_threshold([[2000]], Gap),
    amlr_bo_status([[Gap], [2000]], eligible),
    Short #= Gap - 1,
    amlr_bo_status([[Short], [2000]], ineligible).
test('gap: mixed direct+indirect base (20% + 50%x9.99% = 24.995%) needs +1 bp') :-
    amlr_bo_gap_to_threshold([[2000], [5000, 999]], 1).
test('DET gap (ineligible base)') :-
    findall(G, amlr_bo_gap_to_threshold([[2000]], G), L),
    length(L, 1).
test('DET gap (eligible base)') :-
    findall(G, amlr_bo_gap_to_threshold([[3000]], G), L),
    length(L, 1).

cp_test_names(['diff: a profile against itself changes nothing', 'diff: below vs above flips exactly the threshold row', 'DET diff', 'what-if: dropping to 20pct flips met -> unmet', 'what-if: a same-verdict change reports no delta', 'what-if: supplying chains to a chains-less profile resolves unknown -> met', 'what-if: the stored profile is untouched (re-diff still flips)', 'boundary: located direct-holding cliff == declared Art 52(1) constant', 'boundary: flip is ON the threshold (inclusive \'25% or more\')', 'DET boundary', 'gap: direct 20pct needs exactly +500 bp', 'gap: 24.995pct exact-rational aggregate needs +1 bp (ceil, not floor)', 'gap: an already-qualifying holder needs 0', 'gap: evidenced zero holdings need the full 2500 bp', 'gap MINIMALITY: gap flips the verdict, gap-1 does not', 'gap: mixed direct+indirect base (20% + 50%x9.99% = 24.995%) needs +1 bp', 'DET gap (ineligible base)', 'DET gap (eligible base)']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
