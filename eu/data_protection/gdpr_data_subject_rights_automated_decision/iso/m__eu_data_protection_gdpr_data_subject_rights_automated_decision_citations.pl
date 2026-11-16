% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_12_2, [label - 'Regulation (EU) 2016/679 Art 12(2)', ref - 'CELEX 02016R0679-20160504, Art 12(2)']).
citation(eu_reg_2016_679_art_12_3, [label - 'Regulation (EU) 2016/679 Art 12(3)', ref - 'CELEX 02016R0679-20160504, Art 12(3)']).
citation(eu_reg_2016_679_art_12_4, [label - 'Regulation (EU) 2016/679 Art 12(4)', ref - 'CELEX 02016R0679-20160504, Art 12(4)']).
citation(eu_reg_2016_679_art_12_5, [label - 'Regulation (EU) 2016/679 Art 12(5)', ref - 'CELEX 02016R0679-20160504, Art 12(5)']).
citation(eu_reg_2016_679_art_12_6, [label - 'Regulation (EU) 2016/679 Art 12(6)', ref - 'CELEX 02016R0679-20160504, Art 12(6)']).
citation(eu_reg_2016_679_art_22_1, [label - 'Regulation (EU) 2016/679 Art 22(1)', ref - 'CELEX 02016R0679-20160504, Art 22(1)']).
citation(eu_reg_2016_679_art_22_2, [label - 'Regulation (EU) 2016/679 Art 22(2)', ref - 'CELEX 02016R0679-20160504, Art 22(2)']).
citation(eu_reg_2016_679_art_22_2_a, [label - 'Regulation (EU) 2016/679 Art 22(2)(a)', ref - 'CELEX 02016R0679-20160504, Art 22(2)(a)']).
citation(eu_reg_2016_679_art_22_2_b, [label - 'Regulation (EU) 2016/679 Art 22(2)(b)', ref - 'CELEX 02016R0679-20160504, Art 22(2)(b)']).
citation(eu_reg_2016_679_art_22_2_c, [label - 'Regulation (EU) 2016/679 Art 22(2)(c)', ref - 'CELEX 02016R0679-20160504, Art 22(2)(c)']).
citation(eu_reg_2016_679_art_22_3, [label - 'Regulation (EU) 2016/679 Art 22(3)', ref - 'CELEX 02016R0679-20160504, Art 22(3)']).
citation(eu_reg_2016_679_art_22_4, [label - 'Regulation (EU) 2016/679 Art 22(4)', ref - 'CELEX 02016R0679-20160504, Art 22(4)']).
citation(eu_reg_2016_679_art_23_1, [label - 'Regulation (EU) 2016/679 Art 23(1)', ref - 'CELEX 02016R0679-20160504, Art 23(1)']).

implements(Key) :-
    citation(Key, _).
