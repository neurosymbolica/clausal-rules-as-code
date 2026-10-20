:- module(m__eu_aml_amlr_bo_chain_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_bo_chain_queries, [bo_chain_direct_boundary/1, bo_chain_direct_vs_effective/5, bo_chain_edge_sensitivity/6, bo_chain_gap_to_threshold/4, bo_chain_justification/5, bo_chain_qualifying_holders/3, bo_chain_qualifying_holders_at/4, bo_chain_set_holding/5, bo_chain_what_if_holding/7]).
:- use_module(m__eu_aml_amlr_bo_chain_ownership_interest, [effective_ownership/4, ubo_status/4, ubo_threshold_bps/1]).

g_chain([["alice", "h1", 5000], ["h1", "target", 5000]]).

g_subbp([["alice", "h1", 5000], ["h1", "target", 4999]]).

g_parallel([["alice", "target", 1000], ["alice", "h1", 5000], ["h1", "target", 3000]]).

g_multi([["alice", "h1", 5000], ["h1", "target", 5000], ["bob", "target", 3000], ["carol", "target", 2000]]).

g_dup([["alice", "target", 2500], ["alice", "target", 2600]]).

test('set-holding: replaces exactly the named edge') :-
    g_chain(G),
    bo_chain_set_holding(G, "h1", "target", 4000, G2),
    G2 = [["alice", "h1", 5000], ["h1", "target", 4000]].
test('set-holding: fail-closed on a non-existent edge') :-
    g_chain(G),
    findall(X, bo_chain_set_holding(G, "zed", "target", 4000, X), L),
    length(L, 0).
test('set-holding: duplicate parallel edges -- only the FIRST is touched') :-
    g_dup(G),
    bo_chain_set_holding(G, "alice", "target", 0, G2),
    G2 = [["alice", "target", 0], ["alice", "target", 2600]].
test('DET set-holding') :-
    g_chain(G),
    findall(X, bo_chain_set_holding(G, "h1", "target", 4000, X), L),
    length(L, 1).
test('boundary: bisect-located direct cliff == declared Art 52(1) constant') :-
    bo_chain_direct_boundary(B),
    ubo_threshold_bps(T),
    B #= T.
test('boundary: flip is ON the threshold (inclusive \'25 % or more\')') :-
    bo_chain_direct_boundary(B),
    ubo_status([["p", "t", B]], "p", "t", eligible),
    Below #= B - 1,
    ubo_status([["p", "t", Below]], "p", "t", ineligible).
test('DET boundary') :-
    findall(B, bo_chain_direct_boundary(B), L),
    length(L, 1).
test('gap: 24.995pct exact-rational chain aggregate needs +1 bp (ceil)') :-
    g_subbp(G),
    bo_chain_gap_to_threshold(G, "alice", "target", 1).
test('gap: a 20pct direct holder needs exactly +500 bp') :-
    bo_chain_gap_to_threshold([["alice", "target", 2000]], "alice", "target", 500).
test('gap: an already-qualifying holder needs 0') :-
    g_chain(G),
    bo_chain_gap_to_threshold(G, "alice", "target", 0).
test('gap: an empty graph needs the full 2500 bp') :-
    bo_chain_gap_to_threshold([], "alice", "target", 2500).
test('gap MINIMALITY: gap flips the verdict, gap-1 does not') :-
    g_subbp(G),
    bo_chain_gap_to_threshold(G, "alice", "target", Gap),
    ubo_status([["alice", "target", Gap]|G], "alice", "target", eligible),
    Short #= Gap - 1,
    ubo_status([["alice", "target", Short]|G], "alice", "target", ineligible).
test('DET gap (ineligible base)') :-
    g_subbp(G),
    findall(X, bo_chain_gap_to_threshold(G, "alice", "target", X), L),
    length(L, 1).
test('DET gap (eligible base)') :-
    g_chain(G),
    findall(X, bo_chain_gap_to_threshold(G, "alice", "target", X), L),
    length(L, 1).
test('what-if: raising the weak link to 50% flips alice to BO') :-
    g_subbp(G),
    bo_chain_what_if_holding(G, "h1", "target", 5000, "alice", "target", eligible).
test('what-if: cutting the chain root drops alice below the line') :-
    g_chain(G),
    bo_chain_what_if_holding(G, "alice", "h1", 4000, "alice", "target", ineligible).
test('what-if: the stored graph is untouched (original verdict re-derivable)') :-
    g_chain(G),
    bo_chain_what_if_holding(G, "alice", "h1", 0, "alice", "target", ineligible),
    ubo_status(G, "alice", "target", eligible).
test('what-if: fail-closed on a hypothetical about a non-existent edge') :-
    g_chain(G),
    findall(V, bo_chain_what_if_holding(G, "zed", "target", 9000, "alice", "target", V), L),
    length(L, 0).
test('sensitivity: the h1->target link controls 50% of alice\'s effective stake') :-
    g_parallel(G),
    bo_chain_edge_sensitivity(G, "h1", "target", "alice", "target", 5000).
test('sensitivity: another holder\'s stake has zero leverage on alice') :-
    g_multi(G),
    bo_chain_edge_sensitivity(G, "bob", "target", "alice", "target", 0).
test('DET sensitivity') :-
    g_parallel(G),
    findall(S, bo_chain_edge_sensitivity(G, "h1", "target", "alice", "target", S), L),
    length(L, 1).
test('direct-vs-effective: a wholly-indirect UBO shows 0 direct vs 2500 effective') :-
    g_chain(G),
    bo_chain_direct_vs_effective(G, "alice", "target", 0, 2500).
test('direct-vs-effective: parallel graph splits 1000 direct / 2500 effective') :-
    g_parallel(G),
    bo_chain_direct_vs_effective(G, "alice", "target", 1000, 2500).
test('holders: qualifying holders sorted, intermediates included, sub-line excluded') :-
    g_multi(G),
    bo_chain_qualifying_holders(G, "target", ["alice", "bob", "h1"]).
test('holders: empty graph has no qualifying holders') :-
    bo_chain_qualifying_holders([], "target", []).
test('holders PIN: _at(statutory) == the ubo_status-derived enumeration') :-
    g_multi(G),
    ubo_threshold_bps(T),
    bo_chain_qualifying_holders_at(G, "target", T, QAt),
    bo_chain_qualifying_holders(G, "target", Q),
    QAt = Q.
test('justification: eligible verdict carries [EFF, THR, provenance] basis') :-
    g_chain(G),
    bo_chain_justification(G, "alice", "target", eligible, Basis),
    Basis = [Eff, Thr, Meta],
    Eff #= 2500,
    Thr #= 2500,
    get(Meta, ref, _),
    get(Meta, verbatim, _).
test('justification: near-miss verdict shows the exact-rational shortfall') :-
    g_subbp(G),
    bo_chain_justification(G, "alice", "target", ineligible, Basis),
    Basis = [Eff, Thr, _],
    Eff < Thr.
test('DET justification') :-
    g_chain(G),
    findall(B, bo_chain_justification(G, "alice", "target", _, B), L),
    length(L, 1).

cp_test_names(['set-holding: replaces exactly the named edge', 'set-holding: fail-closed on a non-existent edge', 'set-holding: duplicate parallel edges -- only the FIRST is touched', 'DET set-holding', 'boundary: bisect-located direct cliff == declared Art 52(1) constant', 'boundary: flip is ON the threshold (inclusive \'25 % or more\')', 'DET boundary', 'gap: 24.995pct exact-rational chain aggregate needs +1 bp (ceil)', 'gap: a 20pct direct holder needs exactly +500 bp', 'gap: an already-qualifying holder needs 0', 'gap: an empty graph needs the full 2500 bp', 'gap MINIMALITY: gap flips the verdict, gap-1 does not', 'DET gap (ineligible base)', 'DET gap (eligible base)', 'what-if: raising the weak link to 50% flips alice to BO', 'what-if: cutting the chain root drops alice below the line', 'what-if: the stored graph is untouched (original verdict re-derivable)', 'what-if: fail-closed on a hypothetical about a non-existent edge', 'sensitivity: the h1->target link controls 50% of alice\'s effective stake', 'sensitivity: another holder\'s stake has zero leverage on alice', 'DET sensitivity', 'direct-vs-effective: a wholly-indirect UBO shows 0 direct vs 2500 effective', 'direct-vs-effective: parallel graph splits 1000 direct / 2500 effective', 'holders: qualifying holders sorted, intermediates included, sub-line excluded', 'holders: empty graph has no qualifying holders', 'holders PIN: _at(statutory) == the ubo_status-derived enumeration', 'justification: eligible verdict carries [EFF, THR, provenance] basis', 'justification: near-miss verdict shows the exact-rational shortfall', 'DET justification']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
