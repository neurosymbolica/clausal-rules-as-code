:- module(m__eu_aml_amlr_beneficial_ownership_threshold_parameters, [parameter_source/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

parameter_source(bo_threshold, [label - 'AMLR (Reg (EU) 2024/1624) Art. 52(1) — 25% beneficial-ownership threshold', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:32024R1624', verbatim - 'direct or indirect ownership of 25 % or more of the shares or voting rights or other ownership interest in the corporate entity', units - ['32024R1624#parag_052.001']]).
