% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2024_1689_art_113, [label - 'Regulation (EU) 2024/1689 Art 113, first paragraph (application from 2 August 2026) and lead words of the third paragraph', ref - 'CELEX 02024R1689-20260727, unit art_113']).
citation(eu_reg_2024_1689_art_113_a, [label - 'Regulation (EU) 2024/1689 Art 113, third paragraph, point (a) (Chapters I and II apply from 2 February 2025)', ref - 'CELEX 02024R1689-20260727, unit point_113_a']).
citation(eu_reg_2024_1689_art_4a_1, [label - 'Regulation (EU) 2024/1689 Art 4a(1), first sentence and lead words of the second sentence (providers of high-risk AI systems; strict necessity under Art 10(2)(f) and (g); appropriate safeguards)', ref - 'CELEX 02024R1689-20260727, unit parag_004A.001']).
citation(eu_reg_2024_1689_art_4a_1_a, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(a) (not effectively fulfilled by processing other data, including synthetic or anonymised data)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_a']).
citation(eu_reg_2024_1689_art_4a_1_b, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(b) (technical limitations on re-use; state-of-the-art security and privacy-preserving measures)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_b']).
citation(eu_reg_2024_1689_art_4a_1_c, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(c) (data secured and protected; strict controls and documentation of the access)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_c']).
citation(eu_reg_2024_1689_art_4a_1_d, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(d) (not transmitted, transferred or otherwise accessed by other parties)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_d']).
citation(eu_reg_2024_1689_art_4a_1_e, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(e) (deletion once the bias is corrected or the retention period ends, whichever comes first)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_e']).
citation(eu_reg_2024_1689_art_4a_1_f, [label - 'Regulation (EU) 2024/1689 Art 4a(1)(f) (records of processing activities include the reasons for the processing)', ref - 'CELEX 02024R1689-20260727, unit point_004A.001_f']).
citation(eu_reg_2024_1689_art_4a_2, [label - 'Regulation (EU) 2024/1689 Art 4a(2), lead words (providers and deployers of other AI systems and models, deployers of high-risk AI systems)', ref - 'CELEX 02024R1689-20260727, unit parag_004A.002']).
citation(eu_reg_2024_1689_art_4a_2_a, [label - 'Regulation (EU) 2024/1689 Art 4a(2)(a) (strictly necessary in view of biases likely to affect health, safety or fundamental rights)', ref - 'CELEX 02024R1689-20260727, unit point_004A.002_a']).
citation(eu_reg_2024_1689_art_4a_2_b, [label - 'Regulation (EU) 2024/1689 Art 4a(2)(b) (all the conditions and safeguards of paragraph 1 are applied)', ref - 'CELEX 02024R1689-20260727, unit point_004A.002_b']).
citation(eu_reg_2024_1689_art_59_1, [label - 'Regulation (EU) 2024/1689 Art 59(1), lead words with points (a) to (j) (cumulative conditions for further processing in the sandbox)', ref - 'CELEX 02024R1689-20260727, unit parag_059.001']).
citation(eu_reg_2024_1689_art_59_1_a, [label - 'Regulation (EU) 2024/1689 Art 59(1)(a) (substantial public interest in one or more of the listed areas, points (i) to (v))', ref - 'CELEX 02024R1689-20260727, unit point_059.001_a']).
citation(eu_reg_2024_1689_art_59_1_b, [label - 'Regulation (EU) 2024/1689 Art 59(1)(b) (data necessary for Chapter III, Section 2 requirements; non-personal data not effective)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_b']).
citation(eu_reg_2024_1689_art_59_1_c, [label - 'Regulation (EU) 2024/1689 Art 59(1)(c) (effective monitoring and response mechanisms)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_c']).
citation(eu_reg_2024_1689_art_59_1_g, [label - 'Regulation (EU) 2024/1689 Art 59(1)(g) (appropriate technical and organisational measures; deletion at the end of participation or retention period)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_g']).
citation(eu_reg_2024_1689_art_59_2, [label - 'Regulation (EU) 2024/1689 Art 59(2) (law enforcement processing based on a specific Union or national law and subject to the same cumulative conditions)', ref - 'CELEX 02024R1689-20260727, unit parag_059.002']).
citation(eu_reg_2024_1689_art_60_1, [label - 'Regulation (EU) 2024/1689 Art 60(1), first sentence (testing of Annex III and Annex I Section A high-risk AI systems outside sandboxes)', ref - 'CELEX 02024R1689-20260727, unit parag_060.001']).
citation(eu_reg_2024_1689_art_60_4, [label - 'Regulation (EU) 2024/1689 Art 60(4), lead words with points (a) to (k) (cumulative conditions for testing in real world conditions)', ref - 'CELEX 02024R1689-20260727, unit parag_060.004']).
citation(eu_reg_2024_1689_art_60_4_e, [label - 'Regulation (EU) 2024/1689 Art 60(4)(e) (third-country transfers only with appropriate and applicable safeguards)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_e']).
citation(eu_reg_2024_1689_art_60_4_f, [label - 'Regulation (EU) 2024/1689 Art 60(4)(f) (no longer than necessary; six months, extendable by six months on prior notification)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_f']).
citation(eu_reg_2024_1689_art_60_4_g, [label - 'Regulation (EU) 2024/1689 Art 60(4)(g) (vulnerable subjects appropriately protected)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_g']).
citation(eu_reg_2024_1689_art_60_4_j, [label - 'Regulation (EU) 2024/1689 Art 60(4)(j) (effective oversight by suitably qualified persons)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_j']).
citation(eu_reg_2024_1689_art_60_4_k, [label - 'Regulation (EU) 2024/1689 Art 60(4)(k) (predictions, recommendations or decisions can be effectively reversed and disregarded)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_k']).
citation(eu_reg_2024_1689_art_60a_1, [label - 'Regulation (EU) 2024/1689 Art 60a(1) (Member States may allow testing for AI-enabled products under Annex I Section B)', ref - 'CELEX 02024R1689-20260727, unit parag_060A.001']).
citation(eu_reg_2024_1689_art_60a_2, [label - 'Regulation (EU) 2024/1689 Art 60a(2) (Member States that allow testing adopt frameworks for real-world testing)', ref - 'CELEX 02024R1689-20260727, unit parag_060A.002']).
citation(eu_reg_2024_1689_art_60a_5, [label - 'Regulation (EU) 2024/1689 Art 60a(5), lead words (the frameworks lay down the requirements of the testing)', ref - 'CELEX 02024R1689-20260727, unit parag_060A.005']).
citation(eu_reg_2024_1689_art_61_1, [label - 'Regulation (EU) 2024/1689 Art 61(1), lead words (freely-given informed consent prior to participation after concise, clear, relevant and understandable information)', ref - 'CELEX 02024R1689-20260727, unit parag_061.001']).
citation(eu_reg_2024_1689_art_61_1_a, [label - 'Regulation (EU) 2024/1689 Art 61(1)(a) (nature, objectives and possible inconvenience)', ref - 'CELEX 02024R1689-20260727, unit point_061.001_a']).
citation(eu_reg_2024_1689_art_61_1_b, [label - 'Regulation (EU) 2024/1689 Art 61(1)(b) (conditions and expected duration of participation)', ref - 'CELEX 02024R1689-20260727, unit point_061.001_b']).
citation(eu_reg_2024_1689_art_61_1_c, [label - 'Regulation (EU) 2024/1689 Art 61(1)(c) (rights and guarantees, refusal and withdrawal)', ref - 'CELEX 02024R1689-20260727, unit point_061.001_c']).
citation(eu_reg_2024_1689_art_61_1_d, [label - 'Regulation (EU) 2024/1689 Art 61(1)(d) (arrangements for requesting reversal or disregarding)', ref - 'CELEX 02024R1689-20260727, unit point_061.001_d']).
citation(eu_reg_2024_1689_art_61_1_e, [label - 'Regulation (EU) 2024/1689 Art 61(1)(e) (Union-wide unique single identification number and contact details)', ref - 'CELEX 02024R1689-20260727, unit point_061.001_e']).
citation(eu_reg_2024_1689_art_61_2, [label - 'Regulation (EU) 2024/1689 Art 61(2) (consent dated and documented; copy given to the subject or legal representative)', ref - 'CELEX 02024R1689-20260727, unit parag_061.002']).
citation(eu_reg_2024_1689_art_63_1, [label - 'Regulation (EU) 2024/1689 Art 63(1), first sentence (SMEs without partner or linked enterprises may comply with QMS elements in a simplified manner)', ref - 'CELEX 02024R1689-20260727, unit parag_063.001']).
citation(eu_reg_2024_1689_art_63_2, [label - 'Regulation (EU) 2024/1689 Art 63(2) (no exemption from other requirements or obligations)', ref - 'CELEX 02024R1689-20260727, unit parag_063.002']).
citation(eu_reg_2024_1689_art_86_1, [label - 'Regulation (EU) 2024/1689 Art 86(1) (right to clear and meaningful explanations from the deployer)', ref - 'CELEX 02024R1689-20260727, unit parag_086.001']).
citation(eu_reg_2024_1689_art_86_2, [label - 'Regulation (EU) 2024/1689 Art 86(2) (exceptions or restrictions following from Union or national law)', ref - 'CELEX 02024R1689-20260727, unit parag_086.002']).
citation(eu_reg_2024_1689_art_86_3, [label - 'Regulation (EU) 2024/1689 Art 86(3) (only to the extent not otherwise provided for under Union law)', ref - 'CELEX 02024R1689-20260727, unit parag_086.003']).
citation(eu_reg_2024_1689_art_59_1_d, [label - 'Regulation (EU) 2024/1689 Art 59(1)(d) (functionally separate, isolated and protected data processing environment)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_d']).
citation(eu_reg_2024_1689_art_59_1_e, [label - 'Regulation (EU) 2024/1689 Art 59(1)(e) (sharing only in accordance with Union data protection law; no sharing outside the sandbox)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_e']).
citation(eu_reg_2024_1689_art_59_1_f, [label - 'Regulation (EU) 2024/1689 Art 59(1)(f) (no measures or decisions affecting the data subjects or their rights)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_f']).
citation(eu_reg_2024_1689_art_59_1_h, [label - 'Regulation (EU) 2024/1689 Art 59(1)(h) (logs kept for the duration of participation)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_h']).
citation(eu_reg_2024_1689_art_59_1_i, [label - 'Regulation (EU) 2024/1689 Art 59(1)(i) (description of process and rationale kept in the Annex IV technical documentation)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_i']).
citation(eu_reg_2024_1689_art_59_1_j, [label - 'Regulation (EU) 2024/1689 Art 59(1)(j) (short summary published on the competent authorities website)', ref - 'CELEX 02024R1689-20260727, unit point_059.001_j']).
citation(eu_reg_2024_1689_art_60_4_a, [label - 'Regulation (EU) 2024/1689 Art 60(4)(a) (real-world testing plan drawn up and submitted)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_a']).
citation(eu_reg_2024_1689_art_60_4_b, [label - 'Regulation (EU) 2024/1689 Art 60(4)(b) (approval, tacit approval after 30 days, or authorisation)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_b']).
citation(eu_reg_2024_1689_art_60_4_c, [label - 'Regulation (EU) 2024/1689 Art 60(4)(c) (registration of the testing)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_c']).
citation(eu_reg_2024_1689_art_60_4_d, [label - 'Regulation (EU) 2024/1689 Art 60(4)(d) (established in the Union or legal representative established in the Union)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_d']).
citation(eu_reg_2024_1689_art_60_4_h, [label - 'Regulation (EU) 2024/1689 Art 60(4)(h) (deployers informed, instructed and bound by an agreement)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_h']).
citation(eu_reg_2024_1689_art_60_4_i, [label - 'Regulation (EU) 2024/1689 Art 60(4)(i) (informed consent under Art 61, or the law enforcement alternative)', ref - 'CELEX 02024R1689-20260727, unit point_060.004_i']).

test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1689_art_4a_1).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).
