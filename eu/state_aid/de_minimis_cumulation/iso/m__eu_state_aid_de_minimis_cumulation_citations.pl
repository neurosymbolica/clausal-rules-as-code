:- module(m__eu_state_aid_de_minimis_cumulation_citations, [implements/1, citation/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2023_2831_art_3_1, [label - 'Regulation (EU) 2023/2831, Art. 3(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2023/2831/oj', verbatim - 'Aid measures shall be deemed not to meet all the criteria set out in Article 107(1) of the Treaty and shall therefore not be subject to the notification requirement in Article 108(3) of the Treaty if they fulfil the conditions laid down in this Regulation.', units - ['32023R2831#parag_003.001']]).
citation(eu_reg_2023_2831_art_3_2, [label - 'Regulation (EU) 2023/2831, Art. 3(2)', ref - 'https://eur-lex.europa.eu/eli/reg/2023/2831/oj', verbatim - 'The total amount of de minimis aid granted per Member State to a single undertaking shall not exceed EUR 300 000 over any period of 3 years.', units - ['32023R2831#parag_003.002']]).
citation(eu_reg_2023_2831_art_3_4, [label - 'Regulation (EU) 2023/2831, Art. 3(4)', ref - 'https://eur-lex.europa.eu/eli/reg/2023/2831/oj', verbatim - 'The ceiling laid down in paragraph 2 shall apply irrespective of the form of the de minimis aid or the objective pursued by it and irrespective of whether the aid granted by the Member State is financed entirely or partly by resources of Union origin.', units - ['32023R2831#parag_003.004']]).
citation(eu_reg_2023_2831_art_3_7, [label - 'Regulation (EU) 2023/2831, Art. 3(7)', ref - 'https://eur-lex.europa.eu/eli/reg/2023/2831/oj', verbatim - 'Where the ceiling laid down in paragraph 2 would be exceeded by the grant of new de minimis aid, that new aid shall not benefit from this Regulation.', units - ['32023R2831#parag_003.007']]).
