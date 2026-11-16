% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_1925_art_3_1, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(1), chapeau: designation as a gatekeeper', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.001', verbatim - 'An undertaking shall be designated as a gatekeeper if:']).
citation(eu_reg_2022_1925_art_3_1_a, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(1)(a): significant impact on the internal market', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.001_a', verbatim - 'it has a significant impact on the internal market']).
citation(eu_reg_2022_1925_art_3_1_b, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(1)(b): core platform service which is an important gateway', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.001_b', verbatim - 'it provides a core platform service which is an important gateway for business users to reach end users']).
citation(eu_reg_2022_1925_art_3_1_c, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(1)(c): entrenched and durable position', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.001_c', verbatim - 'it enjoys an entrenched and durable position, in its operations, or it is foreseeable that it will enjoy such a position in the near future']).
citation(eu_reg_2022_1925_art_3_2, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(2), chapeau: presumption of the requirements of paragraph 1', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.002', verbatim - 'An undertaking shall be presumed to satisfy the respective requirements in paragraph 1']).
citation(eu_reg_2022_1925_art_3_2_a, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(2)(a): turnover or market capitalisation threshold and three Member States', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.002_a', verbatim - 'and it provides the same core platform service in at least three Member States']).
citation(eu_reg_2022_1925_art_3_2_b, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(2)(b): monthly active end user and yearly active business user thresholds', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.002_b', verbatim - 'identified and calculated in accordance with the methodology and indicators set out in the Annex']).
citation(eu_reg_2022_1925_art_3_2_c, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(2)(c): point (b) thresholds met in each of the last three financial years', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#point_003.002_c', verbatim - 'where the thresholds in point (b) of this paragraph were met in each of the last three financial years']).
citation(eu_reg_2022_1925_art_3_5, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(5): rebuttal arguments presented with the notification', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.005', verbatim - 'sufficiently substantiated arguments to demonstrate that, exceptionally, although it meets all the thresholds in paragraph 2, due to the circumstances in which the relevant core platform service operates, it does not satisfy the requirements listed in paragraph 1']).
citation(eu_reg_2022_1925_art_3_9, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 3(9): core platform services listed in the designation decision', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.009', verbatim - 'the Commission shall list in the designation decision the relevant core platform services that are provided within that undertaking']).
citation(commission_rebuttal_conclusion, [label - 'Cross-reference target: the Commission conclusion on rebuttal arguments under Regulation (EU) 2022/1925 Art 3(5) (outside fact rebuttal_accepted_by_commission)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.005']).
citation(commission_designation_decision, [label - 'Cross-reference target: the Commission designation decision under Regulation (EU) 2022/1925 Art 3(9) (outside fact designated_as_gatekeeper_for_core_platform_service)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R1925 unit 32022R1925#parag_003.009']).

implements(Key) :-
    citation(Key, _).

test(every_vocabulary_key_is_recorded) :-
    implements(eu_reg_2022_1925_art_3_1),
    implements(eu_reg_2022_1925_art_3_1_a),
    implements(eu_reg_2022_1925_art_3_1_b),
    implements(eu_reg_2022_1925_art_3_1_c),
    implements(eu_reg_2022_1925_art_3_2),
    implements(eu_reg_2022_1925_art_3_2_a),
    implements(eu_reg_2022_1925_art_3_2_b),
    implements(eu_reg_2022_1925_art_3_2_c),
    implements(eu_reg_2022_1925_art_3_5),
    implements(eu_reg_2022_1925_art_3_9),
    implements(commission_rebuttal_conclusion),
    implements(commission_designation_decision).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_reg_2022_1925_art_3_8).
