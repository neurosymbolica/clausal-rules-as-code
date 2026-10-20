:- module(m__eu_state_aid_de_minimis_cumulation_parameters, [parameter_source/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

parameter_source(de_minimis_ceiling, [label - 'Reg (EU) 2023/2831 Art 3(2) — EUR 300 000 three-year de minimis aid ceiling', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:32023R2831', verbatim - 'The total amount of de minimis aid granted per Member State to a single undertaking shall not exceed EUR 300 000 over any period of 3 years.', units - ['32023R2831#parag_003.002']]).
parameter_source(lookback_years, [label - 'Reg (EU) 2023/2831 Art 3(2) — 3-year rolling lookback window', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:32023R2831', verbatim - 'The total amount of de minimis aid granted per Member State to a single undertaking shall not exceed EUR 300 000 over any period of 3 years.', units - ['32023R2831#parag_003.002']]).
