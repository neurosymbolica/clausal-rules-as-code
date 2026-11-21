% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2003_88_art_2_1, [label - 'Directive 2003/88/EC Art 2(1) definition of working time', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - '"working time" means any period during which the worker is working, at the employer\'s disposal and carrying out his activity or duties, in accordance with national laws and/or practice']).
citation(eu_dir_2003_88_art_2_3, [label - 'Directive 2003/88/EC Art 2(3) definition of night time', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - '"night time" means any period of not less than seven hours, as defined by national law, and which must include, in any case, the period between midnight and 5.00']).
citation(eu_dir_2003_88_art_2_4, [label - 'Directive 2003/88/EC Art 2(4) definition of night worker (opening words)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - '"night worker" means:']).
citation(eu_dir_2003_88_art_2_7, [label - 'Directive 2003/88/EC Art 2(7) definition of mobile worker', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - '"mobile worker" means any worker employed as a member of travelling or flying personnel by an undertaking which operates transport services for passengers or goods by road, air or inland waterway']).
citation(eu_dir_2003_88_art_8, [label - 'Directive 2003/88/EC Art 8 Length of night work (opening words)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'Member States shall take the measures necessary to ensure that:']).
citation(eu_dir_2003_88_art_8_a, [label - 'Directive 2003/88/EC Art 8(a) average normal hours of night workers', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'normal hours of work for night workers do not exceed an average of eight hours in any 24-hour period']).
citation(eu_dir_2003_88_art_8_b, [label - 'Directive 2003/88/EC Art 8(b) night work involving special hazards or heavy strain', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'night workers whose work involves special hazards or heavy physical or mental strain do not work more than eight hours in any period of 24 hours during which they perform night work.']).
citation(eu_dir_2003_88_art_8_final_subpara, [label - 'Directive 2003/88/EC Art 8 last subparagraph definition of work involving special hazards or heavy strain', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'For the purposes of point (b), work involving special hazards or heavy physical or mental strain shall be defined by national legislation and/or practice or by collective agreements or agreements concluded between the two sides of industry, taking account of the specific effects and hazards of night work.']).
citation(eu_dir_2003_88_art_16_c, [label - 'Directive 2003/88/EC Art 16(c) reference period for Article 8', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'for the application of Article 8 (length of night work), a reference period defined after consultation of the two sides of industry or by collective agreements or agreements concluded between the two sides of industry at national or regional level.']).
citation(eu_dir_2003_88_art_16_final_subpara, [label - 'Directive 2003/88/EC Art 16 last sentence weekly rest left out of the average', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'If the minimum weekly rest period of 24 hours required by Article 5 falls within that reference period, it shall not be included in the calculation of the average.']).
citation(eu_dir_2003_88_art_17_1, [label - 'Directive 2003/88/EC Art 17(1) derogation where working time is not measured or predetermined (opening words)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'With due regard for the general principles of the protection of the safety and health of workers, Member States may derogate from Articles 3 to 6, 8 and 16 when, on account of the specific characteristics of the activity concerned, the duration of the working time is not measured and/or predetermined or can be determined by the workers themselves']).
citation(eu_dir_2003_88_art_17_3, [label - 'Directive 2003/88/EC Art 17(3) derogations under paragraph 2 (opening words)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'In accordance with paragraph 2 of this Article derogations may be made from Articles 3, 4, 5, 8 and 16:']).
citation(eu_dir_2003_88_art_18_first_subpara, [label - 'Directive 2003/88/EC Art 18 first subparagraph derogation by collective agreement', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'Derogations may be made from Articles 3, 4, 5, 8 and 16 by means of collective agreements or agreements concluded between the two sides of industry at national or regional level']).
citation(eu_dir_2003_88_art_18_second_subpara, [label - 'Directive 2003/88/EC Art 18 second subparagraph derogation by agreement at the appropriate collective level', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'may, in accordance with national legislation and/or practice, allow derogations from Articles 3, 4, 5, 8 and 16 by way of collective agreements or agreements concluded between the two sides of industry at the appropriate collective level.']).
citation(eu_dir_2003_88_art_20_1, [label - 'Directive 2003/88/EC Art 20(1) first subparagraph mobile workers', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'Articles 3, 4, 5 and 8 shall not apply to mobile workers.']).
citation(eu_dir_2003_88_art_21_1, [label - 'Directive 2003/88/EC Art 21(1) first subparagraph workers on board seagoing fishing vessels', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32003L0088', verbatim - 'Articles 3 to 6 and 8 shall not apply to any worker on board a seagoing fishing vessel flying the flag of a Member State.']).

implements(Key) :-
    citation(Key, _).

test(every_outcome_key_is_recorded) :-
    implements(eu_dir_2003_88_art_2_1),
    implements(eu_dir_2003_88_art_2_3),
    implements(eu_dir_2003_88_art_2_4),
    implements(eu_dir_2003_88_art_2_7),
    implements(eu_dir_2003_88_art_8),
    implements(eu_dir_2003_88_art_8_a),
    implements(eu_dir_2003_88_art_8_b),
    implements(eu_dir_2003_88_art_8_final_subpara),
    implements(eu_dir_2003_88_art_16_c),
    implements(eu_dir_2003_88_art_16_final_subpara),
    implements(eu_dir_2003_88_art_17_1),
    implements(eu_dir_2003_88_art_17_3),
    implements(eu_dir_2003_88_art_18_first_subpara),
    implements(eu_dir_2003_88_art_18_second_subpara),
    implements(eu_dir_2003_88_art_20_1),
    implements(eu_dir_2003_88_art_21_1).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(art_8_a).
