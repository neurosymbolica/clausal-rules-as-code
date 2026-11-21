% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2024_2847_art_71_2, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 71(2) date of application', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_071.002)', verbatim - '2. This Regulation shall apply from 11 December 2027. However, Article 14 shall apply from 11 September 2026 and Chapter IV (Articles 35 to 51) shall apply from 11 June 2026.']).
citation(eu_reg_2024_2847_art_64_1, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(1) Member States rules on penalties', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_064.001)', verbatim - '1. Member States shall lay down the rules on penalties applicable to infringements of this Regulation and shall take all measures necessary to ensure that they are implemented. The penalties provided for shall be effective, proportionate and dissuasive.']).
citation(eu_reg_2024_2847_art_64_2, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(2) highest tier of administrative fines (Annex I, Articles 13 and 14)', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_064.002)', verbatim - '2. Non-compliance with the essential cybersecurity requirements set out in Annex I and the obligations set out in Articles 13 and 14 shall be subject to administrative fines of up to EUR 15 000 000 or, if the offender is an undertaking, up to 2,5 % of the its total worldwide annual turnover for the preceding financial year, whichever is higher.']).
citation(eu_reg_2024_2847_art_64_3, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(3) middle tier of administrative fines', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_064.003)', verbatim - '3. Non-compliance with the obligations set out in Articles 18 to 23, Article 28, Article 30(1) to (4), Article 31(1) to (4), Article 32(1), (2) and (3), Article 33(5), and Articles 39, 41, 47, 49 and 53 shall be subject to administrative fines of up to EUR 10 000 000 or, if the offender is an undertaking, up to 2 % of its total worldwide annual turnover for the preceding financial year, whichever is higher.']).
citation(eu_reg_2024_2847_art_64_4, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(4) lowest tier of administrative fines (incorrect, incomplete or misleading information)', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_064.004)', verbatim - '4. The supply of incorrect, incomplete or misleading information to notified bodies and market surveillance authorities in reply to a request shall be subject to administrative fines of up to EUR 5 000 000 or, if the offender is an undertaking, up to 1 % of its total worldwide annual turnover for the preceding financial year, whichever is higher.']).
citation(eu_reg_2024_2847_art_64_10_b, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(10)(b) derogation for open-source software stewards', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#point_064.010_b)', verbatim - '(b) any infringement of this Regulation by open-source software stewards.']).
citation(eu_reg_2024_2847_art_64_10, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(10) lead words, reach of the derogation (paragraphs 3 to 9)', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#parag_064.010)', verbatim - '10. By way of derogation from paragraphs 3 to 9, the administrative fines referred to in those paragraphs shall not apply to the following:']).
citation(eu_reg_2024_2847_art_64_10_a, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 64(10)(a) microenterprises and small enterprises, Article 14 deadlines', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#point_064.010_a)', verbatim - '(a) manufacturers that qualify as microenterprises or small enterprises with regard to any failure to meet the deadline referred to in Article 14(2), point (a), or Article 14(4), point (a);']).
citation(eu_reg_2024_2847_art_3_14, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 3(14) definition of open-source software steward', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#point_003_14)', verbatim - '(14) \x2018\open-source software steward\x2019\ means a legal person, other than a manufacturer, that has the purpose or objective of systematically providing support on a sustained basis for the development of specific products with digital elements, qualifying as free and open-source software and intended for commercial activities, and that ensures the viability of those products;']).
citation(eu_reg_2024_2847_art_3_48, [label - 'Regulation (EU) 2024/2847 (Cyber Resilience Act) Art 3(48) definition of free and open-source software', ref - 'https://eur-lex.europa.eu/eli/reg/2024/2847/oj (32024R2847#point_003_48)', verbatim - '(48) \x2018\free and open-source software\x2019\ means software the source code of which is openly shared and which is made available under a free and open-source licence which provides for all rights to make it freely accessible, usable, modifiable and redistributable;']).

implements(Key) :-
    citation(Key, _).

test(every_returned_key_is_recorded) :-
    implements(eu_reg_2024_2847_art_71_2),
    implements(eu_reg_2024_2847_art_64_1),
    implements(eu_reg_2024_2847_art_64_2),
    implements(eu_reg_2024_2847_art_64_3),
    implements(eu_reg_2024_2847_art_64_4),
    implements(eu_reg_2024_2847_art_64_10_b).
test(every_marker_key_is_recorded) :-
    implements(eu_reg_2024_2847_art_64_10),
    implements(eu_reg_2024_2847_art_64_10_a),
    implements(eu_reg_2024_2847_art_3_14),
    implements(eu_reg_2024_2847_art_3_48).
test(each_key_is_recorded_once) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, Count),
    sort(Keys, DistinctKeys),
    length(DistinctKeys, Count).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(art_64_2).
