:- module(m__eu_state_aid_de_minimis_cumulation___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_ceiling/1, de_minimis_aid_in_window/3, de_minimis_verdict/3]).
:- use_module(m__eu_state_aid_de_minimis_cumulation_queries, [de_minimis_compare_refs/4, de_minimis_gap_to_ineligible/3, de_minimis_headroom/3, de_minimis_qualifying_grants/3, de_minimis_what_if/4]).
