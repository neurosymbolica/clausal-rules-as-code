% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_89_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 89(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).

implements(Key) :-
    citation(Key, _).
