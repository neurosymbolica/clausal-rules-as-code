:- module(m__eu_aml_amlr_beneficial_ownership_threshold_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2024_1624_art_52_1, [label - 'AMLR (Reg (EU) 2024/1624) Art. 52(1)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=OJ:L_202401624', verbatim - '1.   For the purpose of Article 51, first paragraph, point (a), ‘an ownership interest in the corporate entity’ shall mean direct or indirect ownership of 25 % or more of the shares or voting rights or other ownership interest in the corporate entity, including rights to a share of profits, other internal resources or liquidation balance. The indirect ownership shall be calculated by multiplying the shares or voting rights or other ownership interests held by the intermediate entities in the chain of entities in which the beneficial owner holds shares or voting rights and by adding together the results from those various chains, unless Article 54 applies.\nFor the purposes of assessing whether an ownership interest exists in the corporate entity, all shareholdings on every level of ownership shall be taken into account.', units - ['32024R1624#parag_052.001']]).
citation(eu_reg_2024_1624_art_51_chapeau, [label - 'AMLR (Reg (EU) 2024/1624) Art. 51, first paragraph', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=OJ:L_202401624', verbatim - 'Beneficial owners of legal entities shall be the natural persons who:', units - ['32024R1624#art_051/1']]).
citation(eu_reg_2024_1624_art_51_a, [label - 'AMLR (Reg (EU) 2024/1624) Art. 51, first paragraph, point (a)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=OJ:L_202401624', verbatim - 'have, directly or indirectly, an ownership interest in the corporate entity', units - ['32024R1624#point_051_a']]).
