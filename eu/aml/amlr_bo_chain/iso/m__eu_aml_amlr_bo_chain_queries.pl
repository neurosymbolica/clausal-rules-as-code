:- module(m__eu_aml_amlr_bo_chain_queries, [bo_chain_direct_boundary/1, bo_chain_direct_vs_effective/5, bo_chain_edge_sensitivity/6, bo_chain_gap_to_threshold/4, bo_chain_justification/5, bo_chain_qualifying_holders/3, bo_chain_qualifying_holders_at/4, bo_chain_set_holding/5, bo_chain_what_if_holding/7, bad_link/1, over_issued/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_bo_chain_ownership_interest, [effective_ownership/4, ubo_status/4, ubo_threshold_bps/1, bo_chain_input_complete/3, holding_whole_basis_points/2, holding_difference/3]).
:- use_module(m__eu_aml_amlr_bo_chain_parameters, [parameter_source/2]).
:- use_module(query_combinators, [bisect_flip/4, override_where/4]).
:- use_module(formalize_lib, [sum_list/2]).

bo_chain_set_holding(Holdings, Holder, Held, NewBps, NewHoldings) :-
    bo_chain_input_complete(Holdings, Holder, Held),
    override_where(Holdings, holding_edge(Holder, Held), [Holder, Held, NewBps], NewHoldings),
    bo_chain_input_complete(NewHoldings, Holder, Held).

holding_edge(Holder, Held, Edge) :-
    Edge = [Holder, Held, _].

bo_chain_what_if_holding(Holdings, Holder, Held, NewBps, Person, Entity, Verdict) :-
    bo_chain_set_holding(Holdings, Holder, Held, NewBps, Hyp),
    ubo_status(Hyp, Person, Entity, Verdict).

bo_chain_direct_boundary(BoundaryBps) :-
    bisect_flip(0, 10000, direct_probe_verdict, BoundaryBps).

direct_probe_verdict(X, V) :-
    ubo_status([["probe_holder", "probe_entity", X]], "probe_holder", "probe_entity", V).

bo_chain_gap_to_threshold(Holdings, Person, Entity, 0) :-
    ubo_status(Holdings, Person, Entity, eligible).
bo_chain_gap_to_threshold(Holdings, Person, Entity, GapBps) :-
    ubo_status(Holdings, Person, Entity, ineligible),
    bisect_flip(0, 10000, gap_probe_verdict(Holdings, Person, Entity), GapBps).

gap_probe_verdict(Holdings, Person, Entity, X, V) :-
    ubo_status([[Person, Entity, X]|Holdings], Person, Entity, V).

bo_chain_edge_sensitivity(Holdings, Holder, Held, Person, Entity, SwingBps) :-
    bo_chain_set_holding(Holdings, Holder, Held, 0, HZero),
    effective_ownership(HZero, Person, Entity, EffZero),
    bo_chain_set_holding(Holdings, Holder, Held, 10000, HFull),
    effective_ownership(HFull, Person, Entity, EffFull),
    holding_difference(EffFull, EffZero, SwingBps).

bo_chain_direct_vs_effective(Holdings, Person, Entity, DirectBps, EffBps) :-
    bo_chain_input_complete(Holdings, Person, Entity),
    findall(P, member([Person, Entity, P], Holdings), DirectStakes),
    sum_list(DirectStakes, DirectBps),
    effective_ownership(Holdings, Person, Entity, EffBps).

bo_chain_qualifying_holders(Holdings, Entity, Qualifying) :-
    bo_chain_input_complete(Holdings, Entity, Entity),
    graph_holders(Holdings, Holders),
    findall(P, (member(P, Holders), dif(P, Entity), ubo_status(Holdings, P, Entity, eligible)), Qs),
    sort(Qs, Qualifying).

bo_chain_qualifying_holders_at(Holdings, Entity, ThresholdBps, Qualifying) :-
    bo_chain_input_complete(Holdings, Entity, Entity),
    integer(ThresholdBps),
    graph_holders(Holdings, Holders),
    findall(P, (member(P, Holders), dif(P, Entity), effective_ownership(Holdings, P, Entity, Eff), holding_whole_basis_points(Eff, WholeEff), WholeEff #>= ThresholdBps), Qs),
    sort(Qs, Qualifying).

graph_holders(Holdings, Holders) :-
    findall(H, member([H, _, _], Holdings), Hs),
    sort(Hs, Holders).

bad_link(Holdings) :-
    member([_, _, Pct], Holdings),
    Pct #< 0.
bad_link(Holdings) :-
    member([_, _, Pct], Holdings),
    Pct #> 10000.
bad_link(Holdings) :-
    member([X, X, _], Holdings).

over_issued(Holdings) :-
    member([_, Held, _], Holdings),
    findall(Pct, member([_, Held, Pct], Holdings), Stakes),
    sum_list(Stakes, Total),
    Total #> 10000.

bo_chain_justification(Holdings, Person, Entity, Verdict, Basis) :-
    effective_ownership(Holdings, Person, Entity, EffBps),
    ubo_threshold_bps(ThresholdBps),
    ubo_status(Holdings, Person, Entity, Verdict),
    parameter_source(ubo_threshold, Pairs),
    dict_pairs(Meta, Pairs),
    Basis = [EffBps, ThresholdBps, Meta].
