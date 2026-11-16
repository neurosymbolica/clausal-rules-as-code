% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_12_2, [label - 'GDPR Art 12(2), controller may refuse if unable to identify the data subject', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_12_5, [label - 'GDPR Art 12(5), manifestly unfounded or excessive requests', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_12_6, [label - 'GDPR Art 12(6), additional information to confirm identity', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_15_1, [label - 'GDPR Art 15(1), right of access, opening words', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_16, [label - 'GDPR Art 16, right to rectification', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_18_1, [label - 'GDPR Art 18(1), right to restriction of processing', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_18_1_a, [label - 'GDPR Art 18(1)(a), accuracy contested', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_18_1_b, [label - 'GDPR Art 18(1)(b), unlawful processing and opposition to erasure', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_18_1_c, [label - 'GDPR Art 18(1)(c), data needed for legal claims', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_18_1_d, [label - 'GDPR Art 18(1)(d), objection pending verification', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_23_1, [label - 'GDPR Art 23(1), legislative restrictions', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
