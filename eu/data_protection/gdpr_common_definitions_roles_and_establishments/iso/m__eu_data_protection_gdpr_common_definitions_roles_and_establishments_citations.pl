% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_4_1, [label - 'Regulation (EU) 2016/679 Art 4(1) definition of personal data', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_7, [label - 'Regulation (EU) 2016/679 Art 4(7) definition of controller', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_8, [label - 'Regulation (EU) 2016/679 Art 4(8) definition of processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_13, [label - 'Regulation (EU) 2016/679 Art 4(13) definition of genetic data', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_14, [label - 'Regulation (EU) 2016/679 Art 4(14) definition of biometric data', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_15, [label - 'Regulation (EU) 2016/679 Art 4(15) definition of data concerning health', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_16, [label - 'Regulation (EU) 2016/679 Art 4(16) definition of main establishment', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_16_a, [label - 'Regulation (EU) 2016/679 Art 4(16)(a) main establishment of a controller', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_16_b, [label - 'Regulation (EU) 2016/679 Art 4(16)(b) main establishment of a processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_18, [label - 'Regulation (EU) 2016/679 Art 4(18) definition of enterprise', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_19, [label - 'Regulation (EU) 2016/679 Art 4(19) definition of group of undertakings', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_22, [label - 'Regulation (EU) 2016/679 Art 4(22) definition of supervisory authority concerned', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_22_a, [label - 'Regulation (EU) 2016/679 Art 4(22)(a) controller or processor established in the Member State', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_22_b, [label - 'Regulation (EU) 2016/679 Art 4(22)(b) data subjects substantially affected', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_22_c, [label - 'Regulation (EU) 2016/679 Art 4(22)(c) complaint lodged', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_23, [label - 'Regulation (EU) 2016/679 Art 4(23) definition of cross-border processing', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_23_a, [label - 'Regulation (EU) 2016/679 Art 4(23)(a) establishments in more than one Member State', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_23_b, [label - 'Regulation (EU) 2016/679 Art 4(23)(b) single establishment substantially affecting data subjects', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_24, [label - 'Regulation (EU) 2016/679 Art 4(24) definition of relevant and reasoned objection', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(union_or_member_state_law_providing_for_controller, [label - 'Union or Member State law providing for the controller (Regulation (EU) 2016/679 Art 4(7), second clause)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
