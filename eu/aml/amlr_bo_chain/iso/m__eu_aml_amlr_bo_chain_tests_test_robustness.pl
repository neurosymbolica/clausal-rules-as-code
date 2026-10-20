:- module(m__eu_aml_amlr_bo_chain_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_aml_amlr_bo_chain_ownership_interest, [ubo_status/4, effective_ownership/4]).
:- use_module(m__eu_aml_amlr_bo_chain_queries, [bo_chain_justification/5, bo_chain_what_if_holding/7]).
:- use_module(m__eu_aml_amlr_bo_chain_ownership_interest, [bo_chain_input_problem/4]).
:- use_module(m__eu_aml_amlr_bo_chain_queries, [bo_chain_qualifying_holders/3, bo_chain_direct_vs_effective/5, bo_chain_set_holding/5]).
:- use_module(formalize_lib, [not_member/2]).

graph_chain([["alice", "h1", 5000], ["h1", "target", 5000]]).

graph_sub_basis_point([["alice", "h1", 5000], ["h1", "target", 4999]]).

graph_parallel([["alice", "target", 1000], ["alice", "h1", 5000], ["h1", "target", 3000]]).

graph_multiple_holders([["alice", "h1", 5000], ["h1", "target", 5000], ["bob", "target", 3000], ["carol", "target", 2000]]).

graph_duplicate_edges([["alice", "target", 2500], ["alice", "target", 2600]]).

no_definite_verdict(Holdings, Person, Entity) :-
    findall(V, ubo_status(Holdings, Person, Entity, V), Verdicts),
    not_member(eligible, Verdicts),
    not_member(ineligible, Verdicts).

exactly_one_verdict(Holdings, Person, Entity) :-
    findall(V, ubo_status(Holdings, Person, Entity, V), Verdicts),
    length(Verdicts, 1).

test('control: the 50 x 50 chain is eligible') :-
    graph_chain(G),
    ubo_status(G, "alice", "target", eligible).
test('control: the 50 x 49.99 chain is ineligible') :-
    graph_sub_basis_point(G),
    ubo_status(G, "alice", "target", ineligible).
test('CRASH: holdings left unbound raises a Python RecursionError instead of failing or refusing') :-
    no_definite_verdict(_, "alice", "target").
test('FAILS OPEN: person left unbound yields a definite verdict') :-
    graph_chain(G),
    no_definite_verdict(G, _, "target").
test('FAILS OPEN: entity left unbound yields a definite verdict') :-
    graph_chain(G),
    no_definite_verdict(G, "alice", _).
test('FAILS OPEN: holdings given as an atom yields ineligible') :-
    no_definite_verdict(holdings, "alice", "target").
test('FAILS OPEN: holdings given as a number yields ineligible') :-
    no_definite_verdict(5000, "alice", "target").
test('FAILS OPEN: holdings given as a string yields ineligible') :-
    no_definite_verdict("alice target 5000", "alice", "target").
test('FAILS OPEN: an edge given as an atom is silently skipped and yields ineligible') :-
    no_definite_verdict([edge], "alice", "target").
test('FAILS OPEN: an edge with two elements instead of three is silently skipped and yields ineligible') :-
    no_definite_verdict([["alice", "target"]], "alice", "target").
test('CRASH: a percentage given as a string raises a CLP domain error') :-
    no_definite_verdict([["alice", "target", "3000"]], "alice", "target").
test('CRASH: a percentage given as an atom raises a CLP domain error') :-
    no_definite_verdict([["alice", "target", thirty]], "alice", "target").
test('CRASH: a percentage given as a list raises a CLP domain error') :-
    no_definite_verdict([["alice", "target", [3000]]], "alice", "target").
test('CRASH: a percentage given as the boolean atom true raises a CLP domain error') :-
    no_definite_verdict([["alice", "target", true]], "alice", "target").
test('CRASH: a string percentage on the second level of a chain raises a CLP domain error') :-
    no_definite_verdict([["alice", "h1", 5000], ["h1", "target", "5000"]], "alice", "target").
test('FAILS OPEN: person given as a number yields ineligible') :-
    graph_chain(G),
    no_definite_verdict(G, 42, "target").
test('FAILS OPEN: entity given as a number yields ineligible') :-
    graph_chain(G),
    no_definite_verdict(G, "alice", 7).
test('FAILS OPEN: justification for holdings given as an atom gives a definite verdict') :-
    findall(V, bo_chain_justification(holdings, "alice", "target", V, _), Verdicts),
    not_member(eligible, Verdicts),
    not_member(ineligible, Verdicts).
test('CRASH: what-if with a string as the new percentage raises a CLP domain error') :-
    graph_chain(G),
    findall(V, bo_chain_what_if_holding(G, "h1", "target", "5000", "alice", "target", V), Verdicts),
    not_member(eligible, Verdicts),
    not_member(ineligible, Verdicts).
test('empty holdings (by design, NOTES section 3): ineligible, exactly once') :-
    ubo_status([], "alice", "target", ineligible),
    exactly_one_verdict([], "alice", "target").
test('empty holdings: effective ownership is 0') :-
    effective_ownership([], "alice", "target", 0).
test('exactly one verdict: chain graph, alice') :-
    graph_chain(G),
    exactly_one_verdict(G, "alice", "target").
test('exactly one verdict: sub-basis-point chain, alice') :-
    graph_sub_basis_point(G),
    exactly_one_verdict(G, "alice", "target").
test('exactly one verdict: parallel graph, alice') :-
    graph_parallel(G),
    exactly_one_verdict(G, "alice", "target").
test('exactly one verdict: parallel graph, intermediate h1') :-
    graph_parallel(G),
    exactly_one_verdict(G, "h1", "target").
test('exactly one verdict: multiple holders, alice') :-
    graph_multiple_holders(G),
    exactly_one_verdict(G, "alice", "target").
test('exactly one verdict: multiple holders, bob') :-
    graph_multiple_holders(G),
    exactly_one_verdict(G, "bob", "target").
test('exactly one verdict: multiple holders, carol') :-
    graph_multiple_holders(G),
    exactly_one_verdict(G, "carol", "target").
test('exactly one verdict: duplicate edges, alice') :-
    graph_duplicate_edges(G),
    exactly_one_verdict(G, "alice", "target").
test('exactly one verdict: a person absent from the graph') :-
    graph_chain(G),
    exactly_one_verdict(G, "zed", "target").
test('boundary: 2499 bp direct is ineligible') :-
    ubo_status([["alice", "target", 2499]], "alice", "target", ineligible).
test('boundary: 2500 bp direct is eligible') :-
    ubo_status([["alice", "target", 2500]], "alice", "target", eligible).
test('boundary: 2501 bp direct is eligible') :-
    ubo_status([["alice", "target", 2501]], "alice", "target", eligible).
test('boundary: 50% x 50.02% chain (2501 bp) is eligible') :-
    ubo_status([["alice", "h1", 5000], ["h1", "target", 5002]], "alice", "target", eligible).
test('input check: a valid graph has no problem') :-
    graph_chain(G),
    findall(P, bo_chain_input_problem(G, "alice", "target", P), []),
    graph_multiple_holders(G2),
    findall(P2, bo_chain_input_problem(G2, "bob", "target", P2), []).
test('input check: exactly one problem term is reported') :-
    findall(P, bo_chain_input_problem(holdings, 42, 7, P), Problems),
    length(Problems, 1).
test('input check reports not_ground for unbound holdings') :-
    bo_chain_input_problem(_, "alice", "target", not_ground).
test('input check reports not_ground for an unbound percentage inside an edge') :-
    bo_chain_input_problem([["alice", "target", _]], "alice", "target", not_ground).
test('input check reports not_a_list for holdings given as an atom') :-
    bo_chain_input_problem(holdings, "alice", "target", not_a_list(holdings)).
test('input check reports malformed_edge for a two-element edge') :-
    bo_chain_input_problem([["alice", "target"]], "alice", "target", malformed_edge(["alice", "target"])).
test('input check reports wrong_type expected_name for a numeric holder') :-
    bo_chain_input_problem([[1, "target", 3000]], "alice", "target", wrong_type([1, "target", 3000], expected_name)).
test('input check reports wrong_type expected_integer for a string percentage') :-
    bo_chain_input_problem([["alice", "target", "3000"]], "alice", "target", wrong_type(["alice", "target", "3000"], expected_integer)).
test('input check reports out_of_range for a negative percentage') :-
    bo_chain_input_problem([["alice", "target", -1]], "alice", "target", out_of_range(["alice", "target", -1])).
test('input check reports out_of_range above 10000 basis points') :-
    bo_chain_input_problem([["alice", "target", 10001]], "alice", "target", out_of_range(["alice", "target", 10001])).
test('input check accepts the range ends 0 and 10000 basis points') :-
    findall(P, bo_chain_input_problem([["alice", "h1", 0], ["h1", "target", 10000]], "alice", "target", P), []).
test('input check reports self_holding for an entity holding itself') :-
    bo_chain_input_problem([["h1", "h1", 5000]], "alice", "target", self_holding(["h1", "h1", 5000])).
test('input check reports cyclic_holdings for a two-entity cycle') :-
    bo_chain_input_problem([["h1", "h2", 5000], ["h2", "h1", 5000]], "alice", "target", cyclic_holdings(_)).
test('input check reports wrong_type for a numeric person') :-
    graph_chain(G),
    bo_chain_input_problem(G, 42, "target", wrong_type(person, expected_name)).
test('input check reports wrong_type for a numeric entity') :-
    graph_chain(G),
    bo_chain_input_problem(G, "alice", 7, wrong_type(entity, expected_name)).
test('a cyclic graph gives no verdict and terminates (formerly did not terminate)') :-
    no_definite_verdict([["alice", "h1", 5000], ["h1", "h2", 5000], ["h2", "h1", 5000], ["h1", "target", 5000]], "alice", "target").
test('an out-of-range percentage gives no verdict') :-
    no_definite_verdict([["alice", "target", 20000]], "alice", "target").
test('a negative percentage gives no verdict') :-
    no_definite_verdict([["alice", "target", -5000], ["alice", "target", 8000]], "alice", "target").
test('qualifying holders: holdings given as an atom gives no list') :-
    findall(Q, bo_chain_qualifying_holders(holdings, "target", Q), []).
test('direct vs effective: a string percentage gives no answer and no error') :-
    findall(D, bo_chain_direct_vs_effective([["alice", "target", "3000"]], "alice", "target", D, _), []).
test('set holding: an out-of-range new percentage gives no hypothetical graph') :-
    graph_chain(G),
    findall(X, bo_chain_set_holding(G, "h1", "target", 10001, X), []).

cp_test_names(['control: the 50 x 50 chain is eligible', 'control: the 50 x 49.99 chain is ineligible', 'CRASH: holdings left unbound raises a Python RecursionError instead of failing or refusing', 'FAILS OPEN: person left unbound yields a definite verdict', 'FAILS OPEN: entity left unbound yields a definite verdict', 'FAILS OPEN: holdings given as an atom yields ineligible', 'FAILS OPEN: holdings given as a number yields ineligible', 'FAILS OPEN: holdings given as a string yields ineligible', 'FAILS OPEN: an edge given as an atom is silently skipped and yields ineligible', 'FAILS OPEN: an edge with two elements instead of three is silently skipped and yields ineligible', 'CRASH: a percentage given as a string raises a CLP domain error', 'CRASH: a percentage given as an atom raises a CLP domain error', 'CRASH: a percentage given as a list raises a CLP domain error', 'CRASH: a percentage given as the boolean atom true raises a CLP domain error', 'CRASH: a string percentage on the second level of a chain raises a CLP domain error', 'FAILS OPEN: person given as a number yields ineligible', 'FAILS OPEN: entity given as a number yields ineligible', 'FAILS OPEN: justification for holdings given as an atom gives a definite verdict', 'CRASH: what-if with a string as the new percentage raises a CLP domain error', 'empty holdings (by design, NOTES section 3): ineligible, exactly once', 'empty holdings: effective ownership is 0', 'exactly one verdict: chain graph, alice', 'exactly one verdict: sub-basis-point chain, alice', 'exactly one verdict: parallel graph, alice', 'exactly one verdict: parallel graph, intermediate h1', 'exactly one verdict: multiple holders, alice', 'exactly one verdict: multiple holders, bob', 'exactly one verdict: multiple holders, carol', 'exactly one verdict: duplicate edges, alice', 'exactly one verdict: a person absent from the graph', 'boundary: 2499 bp direct is ineligible', 'boundary: 2500 bp direct is eligible', 'boundary: 2501 bp direct is eligible', 'boundary: 50% x 50.02% chain (2501 bp) is eligible', 'input check: a valid graph has no problem', 'input check: exactly one problem term is reported', 'input check reports not_ground for unbound holdings', 'input check reports not_ground for an unbound percentage inside an edge', 'input check reports not_a_list for holdings given as an atom', 'input check reports malformed_edge for a two-element edge', 'input check reports wrong_type expected_name for a numeric holder', 'input check reports wrong_type expected_integer for a string percentage', 'input check reports out_of_range for a negative percentage', 'input check reports out_of_range above 10000 basis points', 'input check accepts the range ends 0 and 10000 basis points', 'input check reports self_holding for an entity holding itself', 'input check reports cyclic_holdings for a two-entity cycle', 'input check reports wrong_type for a numeric person', 'input check reports wrong_type for a numeric entity', 'a cyclic graph gives no verdict and terminates (formerly did not terminate)', 'an out-of-range percentage gives no verdict', 'a negative percentage gives no verdict', 'qualifying holders: holdings given as an atom gives no list', 'direct vs effective: a string percentage gives no answer and no error', 'set holding: an out-of-range new percentage gives no hypothetical graph']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
