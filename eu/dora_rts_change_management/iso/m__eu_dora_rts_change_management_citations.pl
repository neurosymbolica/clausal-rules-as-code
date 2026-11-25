% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2024_1774_art_17_1, [label - 'Commission Delegated Regulation (EU) 2024/1774 Art 17(1), lead words and points (a) to (h) (elements of the ICT change management procedures)', ref - 'https://eur-lex.europa.eu/eli/reg_del/2024/1774/oj', verbatim - 'financial entities shall include in the ICT change management procedures referred to in Article 9(4), point (e), of Regulation (EU) 2022/2554']).
citation(eu_reg_2024_1774_art_17_2, [label - 'Commission Delegated Regulation (EU) 2024/1774 Art 17(2), first to third subparagraphs (stringent testing after significant changes by central counterparties and central securities depositories, and the involvement of parties)', ref - 'https://eur-lex.europa.eu/eli/reg_del/2024/1774/oj', verbatim - 'After having made significant changes to their ICT systems, central counterparties and central securities depositories shall submit their ICT systems to stringent testing by simulating stressed conditions.']).
citation(eu_reg_2022_2554_art_16_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), first subparagraph (entities to which Articles 5 to 15 do not apply)', ref - 'https://eur-lex.europa.eu/eli/reg/2022/2554/oj', verbatim - 'Articles 5 to 15 of this Regulation shall not apply to small and non-interconnected investment firms']).

implements(Key) :-
    citation(Key, _).
