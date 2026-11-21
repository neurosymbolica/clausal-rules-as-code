% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_2554_art_26_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 26(1): the TLPT duty, its carve-outs (Article 16(1) entities, microenterprises) and its frequency', ref - 'https://eur-lex.europa.eu/eli/reg/2022/2554/oj', verbatim - 'shall carry out at least every 3 years advanced testing by means of TLPT']).
citation(eu_reg_2022_2554_art_26_8, [label - 'Regulation (EU) 2022/2554 (DORA) Art 26(8), third subparagraph, points (a) to (c): identification by the competent authorities', ref - 'https://eur-lex.europa.eu/eli/reg/2022/2554/oj', verbatim - 'Competent authorities shall identify financial entities that are required to perform TLPT']).
citation(eu_reg_2025_1190_art_2_1, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(1): the criteria of the TLPT authority\'s assessment', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'TLPT authorities shall assess whether any financial entity is required to perform TLPT']).
citation(eu_reg_2025_1190_art_2_2, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2), lead words and closing subparagraphs: the entities the TLPT authority shall require to perform TLPT', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'TLPT authorities shall require all of the following financial entities to perform TLPT']).
citation(eu_reg_2025_1190_art_2_2_a, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(a)(i) to (iii): credit institutions that are or are part of a G-SII or an O-SII', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'credit institutions that meet any of the following conditions']).
citation(eu_reg_2025_1190_art_2_2_b, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(b): payment institutions over the payment transactions threshold in each of the 2 preceding calendar years', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'payment institutions that exceeded in each of the']).
citation(eu_reg_2025_1190_art_2_2_c, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(c): electronic money institutions over the payment transactions or outstanding electronic money threshold in each of the 2 preceding calendar years', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'electronic money institutions that exceeded in each of the']).
citation(eu_reg_2025_1190_art_2_2_d, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(d): central securities depositories', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'central securities depositories']).
citation(eu_reg_2025_1190_art_2_2_e, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(e): central counterparties', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'central counterparties']).
citation(eu_reg_2025_1190_art_2_2_f, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(f)(i) and (ii) and the closing subparagraph on point (f)(ii): trading venues with an electronic trading system', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'trading venues with an electronic trading system that meet any of the following criteria']).
citation(eu_reg_2025_1190_art_2_2_g, [label - 'Delegated Regulation (EU) 2025/1190 (TLPT RTS) Art 2(2)(g)(i) to (iii), the closing subparagraph on point (g) and its three further criteria: insurance and reinsurance undertakings', ref - 'https://eur-lex.europa.eu/eli/reg_del/2025/1190/oj', verbatim - 'insurance and reinsurance undertakings that meet all the following criteria']).

implements(Key) :-
    citation(Key, _).
