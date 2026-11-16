% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2003_88_art_2_1, [label - 'Directive 2003/88/EC Art 2(1) definition of working time', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#parag_002.001', verbatim - 'means any period during which the worker is working']).
citation(eu_dir_2003_88_art_6_b, [label - 'Directive 2003/88/EC Art 6(b) maximum average weekly working time', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#point_006_b', verbatim - 'the average working time for each seven-day period, including overtime, does not exceed 48 hours']).
citation(eu_dir_2003_88_art_16_b, [label - 'Directive 2003/88/EC Art 16(b) reference period for Article 6, with the sentence on paid annual leave and sick leave', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, units 32003L0088#point_016_b and 32003L0088#subpara_016_1', verbatim - 'for the application of Article 6 (maximum weekly working time), a reference period not exceeding four months']).
citation(eu_dir_2003_88_art_19_first_subpara, [label - 'Directive 2003/88/EC Art 19 first subparagraph limit on derogations from Article 16(b)', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#subpara_019_1', verbatim - 'may not result in the establishment of a reference period exceeding six months']).
citation(eu_dir_2003_88_art_19_second_subpara, [label - 'Directive 2003/88/EC Art 19 second subparagraph reference periods set by collective agreements', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#subpara_019_2', verbatim - 'collective agreements or agreements concluded between the two sides of industry to set reference periods in no event exceeding 12 months']).
citation(eu_dir_2003_88_art_20_2, [label - 'Directive 2003/88/EC Art 20(2) reference period for offshore work', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#parag_020.002', verbatim - 'extend the reference period referred to in Article 16(b) to 12 months in respect of workers who mainly perform offshore work']).
citation(eu_dir_2003_88_art_22_1, [label - 'Directive 2003/88/EC Art 22(1) option not to apply Article 6', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#parag_022.001', verbatim - 'A Member State shall have the option not to apply Article 6']).
citation(eu_dir_2003_88_art_22_1_a, [label - 'Directive 2003/88/EC Art 22(1)(a) prior agreement of the worker to work more than 48 hours', ref - 'OJ L 299, 18.11.2003; CELEX 32003L0088, unit 32003L0088#point_022.001_a', verbatim - 'no employer requires a worker to work more than 48 hours over a seven-day period, calculated as an average for the reference period referred to in Article 16(b)']).

implements(Key) :-
    citation(Key, _).

test(every_lexicon_key_is_recorded) :-
    implements(eu_dir_2003_88_art_2_1),
    implements(eu_dir_2003_88_art_6_b),
    implements(eu_dir_2003_88_art_16_b),
    implements(eu_dir_2003_88_art_19_first_subpara),
    implements(eu_dir_2003_88_art_19_second_subpara),
    implements(eu_dir_2003_88_art_20_2),
    implements(eu_dir_2003_88_art_22_1),
    implements(eu_dir_2003_88_art_22_1_a).
test(eight_records) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 8).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_dir_2003_88_art_6).
