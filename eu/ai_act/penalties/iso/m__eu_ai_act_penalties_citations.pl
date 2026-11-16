% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_citations, [citation/2, implements/1, citation_vocabulary/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2024_1689_art_99_1, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(1) (Member States lay down the rules on penalties; deferred)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.001']).
citation(eu_reg_2024_1689_art_99_3, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(3)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.003', verbatim - 'Non-compliance with the prohibition of the AI practices referred to in Article 5 shall be subject to administrative fines of up to EUR 35000000 or, if the offender is an undertaking, up to 7 % of its total worldwide annual turnover for the preceding financial year, whichever is higher.']).
citation(eu_reg_2024_1689_art_99_4, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), first subparagraph (lead)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.004', verbatim - 'Non-compliance with any of the following provisions related to operators or notified bodies, other than those laid down in Articles 5, shall be subject to administrative fines of up to EUR 15000000 or, if the offender is an undertaking, up to 3 % of its total worldwide annual turnover for the preceding financial year, whichever is higher']).
citation(eu_reg_2024_1689_art_99_4_a, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (a)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_a', verbatim - 'obligations of providers pursuant to Article 16']).
citation(eu_reg_2024_1689_art_99_4_b, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (b)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_b', verbatim - 'obligations of authorised representatives pursuant to Article 22']).
citation(eu_reg_2024_1689_art_99_4_c, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (c)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_c', verbatim - 'obligations of importers pursuant to Article 23']).
citation(eu_reg_2024_1689_art_99_4_d, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (d)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_d', verbatim - 'obligations of distributors pursuant to Article 24']).
citation(eu_reg_2024_1689_art_99_4_da, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (da)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_da', verbatim - 'obligations of providers and operators pursuant to Article 25(2) and (4)']).
citation(eu_reg_2024_1689_art_99_4_e, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (e)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_e', verbatim - 'obligations of deployers pursuant to Article 26']).
citation(eu_reg_2024_1689_art_99_4_f, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (f)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_f', verbatim - 'requirements and obligations of notified bodies pursuant to Article 31, Article 33(1), (3) and (4) or Article 34']).
citation(eu_reg_2024_1689_art_99_4_g, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(4), point (g)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_099.004_g', verbatim - 'transparency obligations for providers and deployers pursuant to Article 50']).
citation(eu_reg_2024_1689_art_99_5, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(5)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.005', verbatim - 'The supply of incorrect, incomplete or misleading information to notified bodies or national competent authorities in reply to a request shall be subject to administrative fines of up to EUR 7500000 or, if the offender is an undertaking, up to 1 % of its total worldwide annual turnover for the preceding financial year, whichever is higher.']).
citation(eu_reg_2024_1689_art_99_6, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(6) (SMEs, including start-ups)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.006', verbatim - 'In the case of SMEs, including start-ups, each fine referred to in this Article shall be up to the percentages or amount referred to in paragraphs 3, 4 and 5, whichever thereof is lower.']).
citation(eu_reg_2024_1689_art_99_6a, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(6a) (SMCs)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.006A', verbatim - 'In the case of SMCs, each fine referred to in paragraphs 4 and 5 shall be up to the percentages or amount referred therein, whichever is lower.']).
citation(eu_reg_2024_1689_art_99_8, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 99(8) (public authorities and bodies)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_099.008', verbatim - 'Each Member State shall lay down rules on to what extent administrative fines may be imposed on public authorities and bodies established in that Member State.']).
citation(eu_reg_2024_1689_art_100_1, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 100(1), first subparagraph', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_100.001', verbatim - 'The European Data Protection Supervisor may impose administrative fines on Union institutions, bodies, offices and agencies falling within the scope of this Regulation.']).
citation(eu_reg_2024_1689_art_100_2, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 100(2)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_100.002', verbatim - 'Non-compliance with the prohibition of the AI practices referred to in Article 5 shall be subject to administrative fines of up to EUR 1500000.']).
citation(eu_reg_2024_1689_art_100_3, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 100(3)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_100.003', verbatim - 'The non-compliance of the AI system with any requirements or obligations under this Regulation, other than those laid down in Article 5, shall be subject to administrative fines of up to EUR 750000.']).
citation(eu_reg_2024_1689_art_101_1, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 101(1), first subparagraph (lead)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit parag_101.001', verbatim - 'The Commission may impose on providers of general-purpose AI models fines not exceeding 3 % of their annual total worldwide turnover in the preceding financial year or EUR 15000000, whichever is higher.']).
citation(eu_reg_2024_1689_art_101_1_a, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 101(1), point (a)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_101.001_a', verbatim - 'infringed the relevant provisions of this Regulation']).
citation(eu_reg_2024_1689_art_101_1_b, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 101(1), point (b)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_101.001_b', verbatim - 'failed to comply with a request for a document or for information pursuant to Article 91, or supplied incorrect, incomplete or misleading information']).
citation(eu_reg_2024_1689_art_101_1_c, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 101(1), point (c)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_101.001_c', verbatim - 'failed to comply with a measure requested under Article 93']).
citation(eu_reg_2024_1689_art_101_1_d, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 101(1), point (d)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_101.001_d', verbatim - 'failed to make available to the Commission access to the general-purpose AI model or general-purpose AI model with systemic risk with a view to conducting an evaluation pursuant to Article 92']).
citation(eu_reg_2024_1689_art_113, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 113, second paragraph (general date of application)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit art_113', verbatim - 'It shall apply from 2 August 2026.']).
citation(eu_reg_2024_1689_art_113_a, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 113, third paragraph, point (a)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_113_a', verbatim - 'Chapters I and II shall apply from 2 February 2025, with the exception of Article 5(1), first subparagraph, points (ba) and (bb), and Article 5(1a) and (1b) which shall apply from 2 December 2026']).
citation(eu_reg_2024_1689_art_113_b, [label - 'Regulation (EU) 2024/1689 (Artificial Intelligence Act) Art 113, third paragraph, point (b)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 unit point_113_b', verbatim - 'Chapter III Section 4, Chapter V, Chapter VII and Chapter XII and Article 78 shall apply from 2 August 2025, with the exception of Article 101']).
citation(eu_reg_2026_1744, [label - 'Regulation (EU) 2026/1744 amending Regulation (EU) 2024/1689 (date of effect of the consolidated version 02024R1689-20260727, 27 July 2026; pin metadata, not a quoted unit)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727']).

citation_vocabulary(eu_reg_2024_1689_art_99_3, 'parag_099.003').
citation_vocabulary(eu_reg_2024_1689_art_99_4, 'parag_099.004').
citation_vocabulary(eu_reg_2024_1689_art_99_4_a, 'point_099.004_a').
citation_vocabulary(eu_reg_2024_1689_art_99_4_b, 'point_099.004_b').
citation_vocabulary(eu_reg_2024_1689_art_99_4_c, 'point_099.004_c').
citation_vocabulary(eu_reg_2024_1689_art_99_4_d, 'point_099.004_d').
citation_vocabulary(eu_reg_2024_1689_art_99_4_da, 'point_099.004_da').
citation_vocabulary(eu_reg_2024_1689_art_99_4_e, 'point_099.004_e').
citation_vocabulary(eu_reg_2024_1689_art_99_4_f, 'point_099.004_f').
citation_vocabulary(eu_reg_2024_1689_art_99_4_g, 'point_099.004_g').
citation_vocabulary(eu_reg_2024_1689_art_99_5, 'parag_099.005').
citation_vocabulary(eu_reg_2024_1689_art_99_6, 'parag_099.006').
citation_vocabulary(eu_reg_2024_1689_art_99_6a, 'parag_099.006A').
citation_vocabulary(eu_reg_2024_1689_art_99_8, 'parag_099.008').
citation_vocabulary(eu_reg_2024_1689_art_100_1, 'parag_100.001').
citation_vocabulary(eu_reg_2024_1689_art_100_2, 'parag_100.002').
citation_vocabulary(eu_reg_2024_1689_art_100_3, 'parag_100.003').
citation_vocabulary(eu_reg_2024_1689_art_101_1, 'parag_101.001').
citation_vocabulary(eu_reg_2024_1689_art_101_1_a, 'point_101.001_a').
citation_vocabulary(eu_reg_2024_1689_art_101_1_b, 'point_101.001_b').
citation_vocabulary(eu_reg_2024_1689_art_101_1_c, 'point_101.001_c').
citation_vocabulary(eu_reg_2024_1689_art_101_1_d, 'point_101.001_d').
citation_vocabulary(eu_reg_2024_1689_art_113, 'art_113').
citation_vocabulary(eu_reg_2024_1689_art_113_a, 'point_113_a').
citation_vocabulary(eu_reg_2024_1689_art_113_b, 'point_113_b').

test(every_vocabulary_key_is_recorded) :-
    findall(Key, citation_vocabulary(Key, _), Keys),
    length(Keys, 25),
    maplist(implements, Keys).
test(the_vocabulary_has_no_repeated_key) :-
    findall(Key, citation_vocabulary(Key, _), Keys),
    sort(Keys, DistinctKeys),
    length(DistinctKeys, 25).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1689_art_99_6a).
test(a_marker_key_is_recorded_but_not_returnable) :-
    implements(eu_reg_2026_1744).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2024_1689_art_99_6_a).
test(a_marker_key_is_not_in_the_vocabulary, fail) :-
    citation_vocabulary(eu_reg_2026_1744, _).
