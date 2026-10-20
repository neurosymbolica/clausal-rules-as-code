:- module(m__eu_aml_amlr_beneficial_ownership_threshold_queries, [amlr_bo_diff/3, amlr_bo_what_if/3, amlr_bo_direct_boundary/1, amlr_bo_gap_to_threshold/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_checklist/2, amlr_bo_status/2]).
:- use_module(query_combinators, [diff_checklists/3, changed_deltas/2, flip_scan/4, override_key/4]).

amlr_bo_diff(ProfileA, ProfileB, Changed) :-
    amlr_bo_checklist(ProfileA, ClA),
    amlr_bo_checklist(ProfileB, ClB),
    diff_checklists(ClA, ClB, Deltas),
    changed_deltas(Deltas, Changed).

amlr_bo_what_if(Profile, HypChains, Changed) :-
    ground(Profile),
    dict_keys(Profile, _),
    override_key(Profile, ownership_chains, HypChains, Hypothesis),
    amlr_bo_diff(Profile, Hypothesis, Changed).

amlr_bo_direct_boundary(BoundaryBps) :-
    flip_scan(0, 100, direct_holding_units_probe, CoarseUnits),
    FineLo #= (CoarseUnits - 1) * 100,
    FineHi #= CoarseUnits * 100,
    flip_scan(FineLo, FineHi, direct_holding_probe, BoundaryBps).

amlr_bo_gap_to_threshold(Chains, 0) :-
    amlr_bo_status(Chains, eligible).
amlr_bo_gap_to_threshold(Chains, GapBps) :-
    amlr_bo_status(Chains, ineligible),
    flip_scan(0, 100, top_up_units_probe(Chains), CoarseUnits),
    FineLo #= (CoarseUnits - 1) * 100,
    FineHi #= CoarseUnits * 100,
    flip_scan(FineLo, FineHi, top_up_probe(Chains), GapBps).

direct_holding_units_probe(U, V) :-
    Bps #= U * 100,
    amlr_bo_status([[Bps]], V).

direct_holding_probe(B, V) :-
    amlr_bo_status([[B]], V).

top_up_units_probe(Chains, U, V) :-
    Top #= U * 100,
    amlr_bo_status([[Top]|Chains], V).

top_up_probe(Chains, B, V) :-
    amlr_bo_status([[B]|Chains], V).
