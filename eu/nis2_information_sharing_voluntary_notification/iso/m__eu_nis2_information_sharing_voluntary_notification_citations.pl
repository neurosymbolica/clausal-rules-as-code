% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2022_2555_art_29_1, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 29(1), voluntary exchange of relevant cybersecurity information', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit parag_029.001)', verbatim - 'are able to exchange on a voluntary basis relevant cybersecurity information among themselves']).
citation(eu_dir_2022_2555_art_29_1_a, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 29(1)(a), sharing aims to prevent, detect, respond to or recover from incidents or to mitigate their impact', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit point_029.001_a)', verbatim - 'aims to prevent, detect, respond to or recover from incidents or to mitigate their impact']).
citation(eu_dir_2022_2555_art_29_1_b, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 29(1)(b), sharing enhances the level of cybersecurity', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit point_029.001_b)', verbatim - 'enhances the level of cybersecurity']).
citation(eu_dir_2022_2555_art_29_2, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 29(2), cybersecurity information-sharing arrangements', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit parag_029.002)', verbatim - 'Such exchange shall be implemented through cybersecurity information-sharing arrangements in respect of the potentially sensitive nature of the information shared.']).
citation(eu_dir_2022_2555_art_29_4, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 29(4), notification of participation in or withdrawal from an information-sharing arrangement', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit parag_029.004)', verbatim - 'essential and important entities notify the competent authorities of their participation in the cybersecurity information-sharing arrangements referred to in paragraph 2']).
citation(eu_dir_2022_2555_art_30_1, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 30(1) chapeau, voluntary notification in addition to Article 23', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit parag_030.001)', verbatim - 'in addition to the notification obligation provided for in Article 23, notifications can be submitted to the CSIRTs or, where applicable, the competent authorities, on a voluntary basis']).
citation(eu_dir_2022_2555_art_30_1_a, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 30(1)(a), voluntary notification by essential and important entities', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit point_030.001_a)', verbatim - 'essential and important entities with regard to incidents, cyber threats and near misses']).
citation(eu_dir_2022_2555_art_30_1_b, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 30(1)(b), voluntary notification by other entities of significant incidents, cyber threats and near misses', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (CELEX 32022L2555, unit point_030.001_b)', verbatim - 'entities other than those referred to in point (a), regardless of whether they fall within the scope of this Directive, with regard to significant incidents, cyber threats and near misses']).

implements(Key) :-
    citation(Key, _).

test(every_returned_key_is_recorded) :-
    implements(eu_dir_2022_2555_art_29_1),
    implements(eu_dir_2022_2555_art_29_1_a),
    implements(eu_dir_2022_2555_art_29_1_b),
    implements(eu_dir_2022_2555_art_29_2),
    implements(eu_dir_2022_2555_art_29_4),
    implements(eu_dir_2022_2555_art_30_1_a),
    implements(eu_dir_2022_2555_art_30_1_b).

test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_dir_2022_2555_art_29_3).
