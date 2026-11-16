% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_2_1, [label - 'Regulation (EU) 2016/679 Art 2(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_2_2_a, [label - 'Regulation (EU) 2016/679 Art 2(2)(a)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_2_2_b, [label - 'Regulation (EU) 2016/679 Art 2(2)(b)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_2_2_c, [label - 'Regulation (EU) 2016/679 Art 2(2)(c)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_2_2_d, [label - 'Regulation (EU) 2016/679 Art 2(2)(d)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_2_3, [label - 'Regulation (EU) 2016/679 Art 2(3)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_3_1, [label - 'Regulation (EU) 2016/679 Art 3(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_3_2_a, [label - 'Regulation (EU) 2016/679 Art 3(2)(a)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_3_2_b, [label - 'Regulation (EU) 2016/679 Art 3(2)(b)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_3_3, [label - 'Regulation (EU) 2016/679 Art 3(3)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_27_1, [label - 'Regulation (EU) 2016/679 Art 27(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_27_2_a, [label - 'Regulation (EU) 2016/679 Art 27(2)(a)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_27_2_b, [label - 'Regulation (EU) 2016/679 Art 27(2)(b)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(public_international_law_member_state_law_applies, [label - 'Public international law: place where Member State law applies (Art 3(3) cross-reference target, not formalized)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).

implements(Key) :-
    citation(Key, _).
