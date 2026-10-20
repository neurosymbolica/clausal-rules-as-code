:- module(m__eu_aml_amlr_bo_chain___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_aml_amlr_bo_chain_ownership_interest, [effective_ownership/4, ubo_status/4, ubo_threshold_bps/1]).
:- use_module(m__eu_aml_amlr_bo_chain_queries, [bo_chain_direct_boundary/1, bo_chain_direct_vs_effective/5, bo_chain_edge_sensitivity/6, bo_chain_gap_to_threshold/4, bo_chain_justification/5, bo_chain_qualifying_holders/3, bo_chain_qualifying_holders_at/4, bo_chain_set_holding/5, bo_chain_what_if_holding/7]).
