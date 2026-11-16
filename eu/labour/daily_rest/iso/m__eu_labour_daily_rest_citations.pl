% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2003_88_art_3, [label - 'Directive 2003/88/EC Art 3 (daily rest), the whole article, its one subparagraph', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 3 [32003L0088#art_003, 32003L0088#subpara_003_1]', verbatim - 'Member States shall take the measures necessary to ensure that every worker is entitled to a minimum daily rest period of 11 consecutive hours per 24-hour period.']).
citation(eu_dir_2003_88_art_2_1, [label - 'Directive 2003/88/EC Art 2(1) definition of working time', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 2(1) [32003L0088#parag_002.001]', verbatim - 'any period during which the worker is working, at the employer\'s disposal and carrying out his activity or duties, in accordance with national laws and/or practice']).
citation(eu_dir_2003_88_art_2_2, [label - 'Directive 2003/88/EC Art 2(2) definition of rest period', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 2(2) [32003L0088#parag_002.002]', verbatim - 'any period which is not working time']).
citation(eu_dir_2003_88_art_2_7, [label - 'Directive 2003/88/EC Art 2(7) definition of mobile worker', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 2(7) [32003L0088#parag_002.007]', verbatim - 'any worker employed as a member of travelling or flying personnel by an undertaking which operates transport services for passengers or goods by road, air or inland waterway']).
citation(eu_dir_2003_88_art_17_1, [label - 'Directive 2003/88/EC Art 17(1), opening words (derogation from Articles 3 to 6, 8 and 16)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 17(1) [32003L0088#parag_017.001]', verbatim - 'Member States may derogate from Articles 3 to 6, 8 and 16 when, on account of the specific characteristics of the activity concerned, the duration of the working time is not measured and/or predetermined or can be determined by the workers themselves']).
citation(eu_dir_2003_88_art_17_3, [label - 'Directive 2003/88/EC Art 17(3), opening words (derogations from Articles 3, 4, 5, 8 and 16)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 17(3) [32003L0088#parag_017.003]', verbatim - 'In accordance with paragraph 2 of this Article derogations may be made from Articles 3, 4, 5, 8 and 16']).
citation(eu_dir_2003_88_art_17_4, [label - 'Directive 2003/88/EC Art 17(4), opening words (derogations from Articles 3 and 5)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 17(4) [32003L0088#parag_017.004]', verbatim - 'In accordance with paragraph 2 of this Article derogations may be made from Articles 3 and 5']).
citation(eu_dir_2003_88_art_18_first_subpara, [label - 'Directive 2003/88/EC Art 18, first subparagraph (derogation by collective agreements)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 18 first subparagraph [32003L0088#subpara_018_1]', verbatim - 'Derogations may be made from Articles 3, 4, 5, 8 and 16 by means of collective agreements or agreements concluded between the two sides of industry at national or regional level or, in conformity with the rules laid down by them, by means of collective agreements or agreements concluded between the two sides of industry at a lower level.']).
citation(eu_dir_2003_88_art_18_second_subpara, [label - 'Directive 2003/88/EC Art 18, second subparagraph (derogation by agreements at the appropriate collective level)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 18 second subparagraph [32003L0088#subpara_018_2]', verbatim - 'Member States in which there is no statutory system ensuring the conclusion of collective agreements or agreements concluded between the two sides of industry at national or regional level, on the matters covered by this Directive, or those Member States in which there is a specific legislative framework for this purpose and within the limits thereof, may, in accordance with national legislation and/or practice, allow derogations from Articles 3, 4, 5, 8 and 16 by way of collective agreements or agreements concluded between the two sides of industry at the appropriate collective level.']).
citation(eu_dir_2003_88_art_20_1, [label - 'Directive 2003/88/EC Art 20(1), first subparagraph (mobile workers)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 20(1) first subparagraph [32003L0088#parag_020.001]', verbatim - 'Articles 3, 4, 5 and 8 shall not apply to mobile workers.']).
citation(eu_dir_2003_88_art_21_1, [label - 'Directive 2003/88/EC Art 21(1), first subparagraph (workers on board seagoing fishing vessels)', ref - 'CELEX 32003L0088, OJ L 299, 18.11.2003, Art 21(1) first subparagraph [32003L0088#parag_021.001]', verbatim - 'Articles 3 to 6 and 8 shall not apply to any worker on board a seagoing fishing vessel flying the flag of a Member State.']).

implements(Key) :-
    citation(Key, _).

test(article_3_is_recorded) :-
    implements(eu_dir_2003_88_art_3).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(art_3).
