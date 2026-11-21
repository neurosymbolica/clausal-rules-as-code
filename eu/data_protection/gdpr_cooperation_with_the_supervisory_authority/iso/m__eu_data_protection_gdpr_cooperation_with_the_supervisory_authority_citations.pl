% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_31, [label - 'Regulation (EU) 2016/679 (GDPR) Art 31 (cooperation with the supervisory authority)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller and the processor and, where applicable, their representatives, shall cooperate, on request, with the supervisory authority in the performance of its tasks.']).
citation(cooperation_statement, [label - 'Attested cooperation statement: outside fact cooperation_given, the statement that the caller cooperated on the request (target of the cross-reference from Regulation (EU) 2016/679 (GDPR) Art 31)', ref - 'outside_facts: cooperation_given (fetcher none; kinds attested, fetched)']).

implements(Key) :-
    citation(Key, _).
