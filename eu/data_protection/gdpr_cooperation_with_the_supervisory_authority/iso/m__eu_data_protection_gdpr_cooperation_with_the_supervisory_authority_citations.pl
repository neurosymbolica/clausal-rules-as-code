% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_31, [label - 'Regulation (EU) 2016/679 (General Data Protection Regulation) Art 31 (cooperation with the supervisory authority)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller and the processor and, where applicable, their representatives, shall cooperate, on request, with the supervisory authority in the performance of its tasks.']).
citation(cooperation_statement, [label - 'Attested statement of cooperation with the request of the supervisory authority (outside fact cooperation_given, Regulation (EU) 2016/679 Art 31)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).

implements(Key) :-
    citation(Key, _).
