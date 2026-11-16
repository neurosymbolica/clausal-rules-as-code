% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_83_3, [label - 'Regulation (EU) 2016/679 Art 83(3)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_4, [label - 'Regulation (EU) 2016/679 Art 83(4)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_4_a, [label - 'Regulation (EU) 2016/679 Art 83(4)(a)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_4_b, [label - 'Regulation (EU) 2016/679 Art 83(4)(b)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_4_c, [label - 'Regulation (EU) 2016/679 Art 83(4)(c)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5, [label - 'Regulation (EU) 2016/679 Art 83(5)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5_a, [label - 'Regulation (EU) 2016/679 Art 83(5)(a)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5_b, [label - 'Regulation (EU) 2016/679 Art 83(5)(b)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5_c, [label - 'Regulation (EU) 2016/679 Art 83(5)(c)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5_d, [label - 'Regulation (EU) 2016/679 Art 83(5)(d)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_5_e, [label - 'Regulation (EU) 2016/679 Art 83(5)(e)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_6, [label - 'Regulation (EU) 2016/679 Art 83(6)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_83_7, [label - 'Regulation (EU) 2016/679 Art 83(7) (deferred, not applied)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_18, [label - 'Regulation (EU) 2016/679 Art 4(18) definition of enterprise', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_19, [label - 'Regulation (EU) 2016/679 Art 4(19) definition of group of undertakings', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
