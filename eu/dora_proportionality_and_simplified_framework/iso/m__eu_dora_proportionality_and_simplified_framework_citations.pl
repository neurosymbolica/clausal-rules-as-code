% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2022_2554_art_2_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 2(1), lead words (the entities to which the Regulation applies)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_002.001)', verbatim - 'Without prejudice to paragraphs 3 and 4, this Regulation applies to the following entities:']).
citation(eu_reg_2022_2554_art_2_1_u, [label - 'Regulation (EU) 2022/2554 (DORA) Art 2(1), point (u) (ICT third-party service providers)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_002.001_u)', verbatim - '(u) ICT third-party service providers']).
citation(eu_reg_2022_2554_art_2_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 2(2) (financial entities: the entities of Art 2(1), points (a) to (t))', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_002.002)', verbatim - 'entities referred to in paragraph 1, points (a) to (t), shall collectively be referred to as']).
citation(eu_reg_2022_2554_art_2_3_c, [label - 'Regulation (EU) 2022/2554 (DORA) Art 2(3), point (c) (exclusion of institutions for occupational retirement provision with not more than 15 members in total)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_002.003_c)', verbatim - 'institutions for occupational retirement provision which operate pension schemes which together do not have more than 15 members in total']).
citation(eu_reg_2022_2554_art_2_4, [label - 'Regulation (EU) 2022/2554 (DORA) Art 2(4), first sentence (option of the Member States to exclude institutions of Art 2(5), points (4) to (23), of Directive 2013/36/EU)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_002.004)', verbatim - 'Member States may exclude from the scope of this Regulation entities referred to in Article 2(5), points (4) to (23), of Directive 2013/36/EU that are located within their respective territories.']).
citation(eu_reg_2022_2554_art_3_32, [label - 'Regulation (EU) 2022/2554 (DORA) Art 3, point (32), definition of institution exempted pursuant to Directive 2013/36/EU', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_003_32)', verbatim - 'means an entity as referred to in Article 2(5), points (4) to (23), of Directive 2013/36/EU']).
citation(eu_reg_2022_2554_art_3_34, [label - 'Regulation (EU) 2022/2554 (DORA) Art 3, point (34), definition of small and non-interconnected investment firm', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_003_34)', verbatim - 'means an investment firm that meets the conditions laid out in Article 12(1) of Regulation (EU) 2019/2033']).
citation(eu_reg_2022_2554_art_3_36, [label - 'Regulation (EU) 2022/2554 (DORA) Art 3, point (36), definition of payment institution exempted pursuant to Directive (EU) 2015/2366', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_003_36)', verbatim - 'means a payment institution exempted pursuant to Article 32(1) of Directive (EU) 2015/2366']).
citation(eu_reg_2022_2554_art_3_39, [label - 'Regulation (EU) 2022/2554 (DORA) Art 3, point (39), definition of electronic money institution exempted pursuant to Directive 2009/110/EC', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_003_39)', verbatim - 'means an electronic money institution benefitting from a waiver as referred to in Article 9(1) of Directive 2009/110/EC']).
citation(eu_reg_2022_2554_art_3_53, [label - 'Regulation (EU) 2022/2554 (DORA) Art 3, point (53), definition of small institution for occupational retirement provision', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_003_53)', verbatim - 'means an institution for occupational retirement provision which operates pension schemes which together have less than 100 members in total']).
citation(eu_reg_2022_2554_art_4_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 4(1) (principle of proportionality for the rules of Chapter II)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_004.001)', verbatim - 'Financial entities shall implement the rules laid down in Chapter II in accordance with the principle of proportionality, taking into account their size and overall risk profile, and the nature, scale and complexity of their services, activities and operations.']).
citation(eu_reg_2022_2554_art_16_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), first subparagraph (the entities to which Articles 5 to 15 do not apply)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_016.001)', verbatim - 'Articles 5 to 15 of this Regulation shall not apply to small and non-interconnected investment firms, payment institutions exempted pursuant to Directive (EU) 2015/2366;']).
citation(eu_reg_2022_2554_art_16_1_a, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (a) (sound and documented ICT risk management framework)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_a)', verbatim - 'put in place and maintain a sound and documented ICT risk management framework']).
citation(eu_reg_2022_2554_art_16_1_b, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (b) (continuous monitoring of ICT systems)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_b)', verbatim - 'continuously monitor the security and functioning of all ICT systems']).
citation(eu_reg_2022_2554_art_16_1_c, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (c) (minimising the impact of ICT risk)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_c)', verbatim - 'minimise the impact of ICT risk through the use of sound, resilient and updated ICT systems, protocols and tools']).
citation(eu_reg_2022_2554_art_16_1_d, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (d) (detection of ICT risk sources and anomalies and handling of ICT-related incidents)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_d)', verbatim - 'allow sources of ICT risk and anomalies in the network and information systems to be promptly identified and detected and ICT-related incidents to be swiftly handled']).
citation(eu_reg_2022_2554_art_16_1_e, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (e) (key dependencies on ICT third-party service providers)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_e)', verbatim - 'identify key dependencies on ICT third-party service providers']).
citation(eu_reg_2022_2554_art_16_1_f, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (f) (continuity of critical or important functions)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_f)', verbatim - 'ensure the continuity of critical or important functions, through business continuity plans and response and recovery measures, which include, at least, back-up and restoration measures']).
citation(eu_reg_2022_2554_art_16_1_g, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (g) (regular testing of plans, measures and controls)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_g)', verbatim - 'test, on a regular basis, the plans and measures referred to in point (f), as well as the effectiveness of the controls implemented in accordance with points (a) and (c)']).
citation(eu_reg_2022_2554_art_16_1_h, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), second subparagraph, point (h) (operational conclusions implemented; awareness programmes and training developed)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_016.001_h)', verbatim - 'implement, as appropriate, relevant operational conclusions resulting from the tests referred to in point (g) and from post-incident analysis into the ICT risk assessment process']).
citation(eu_reg_2022_2554_art_16_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(2) (documentation, review, continuous improvement and review report of the simplified framework)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_016.002)', verbatim - 'The ICT risk management framework referred to in paragraph 1, second subparagraph, point (a), shall be documented and reviewed periodically and upon the occurrence of major ICT-related incidents in compliance with supervisory instructions.']).

test(every_vocabulary_key_is_recorded) :-
    implements(eu_reg_2022_2554_art_2_1),
    implements(eu_reg_2022_2554_art_2_1_u),
    implements(eu_reg_2022_2554_art_2_2),
    implements(eu_reg_2022_2554_art_2_3_c),
    implements(eu_reg_2022_2554_art_2_4),
    implements(eu_reg_2022_2554_art_3_32),
    implements(eu_reg_2022_2554_art_3_34),
    implements(eu_reg_2022_2554_art_3_36),
    implements(eu_reg_2022_2554_art_3_39),
    implements(eu_reg_2022_2554_art_3_53),
    implements(eu_reg_2022_2554_art_4_1),
    implements(eu_reg_2022_2554_art_16_1),
    implements(eu_reg_2022_2554_art_16_1_a),
    implements(eu_reg_2022_2554_art_16_1_b),
    implements(eu_reg_2022_2554_art_16_1_c),
    implements(eu_reg_2022_2554_art_16_1_d),
    implements(eu_reg_2022_2554_art_16_1_e),
    implements(eu_reg_2022_2554_art_16_1_f),
    implements(eu_reg_2022_2554_art_16_1_g),
    implements(eu_reg_2022_2554_art_16_1_h),
    implements(eu_reg_2022_2554_art_16_2).

test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_todo_primary_source).
