% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_2554_art_16_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), first subparagraph (the entities to which Articles 5 to 15 do not apply; the gate)', ref - 'CELEX 32022R2554, OJ L 333, 27.12.2022, p. 1, unit parag_016.001', verbatim - 'Articles 5 to 15 of this Regulation shall not apply to small and non-interconnected investment firms']).
citation(eu_reg_2022_2554_art_16_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(2), third sentence (the report on the review, submitted upon the competent authority request; the trigger)', ref - 'CELEX 32022R2554, OJ L 333, 27.12.2022, p. 1, unit parag_016.002', verbatim - 'A report on the review of the ICT risk management framework shall be submitted to the competent authority upon its request.']).
citation(eu_reg_2024_1774_art_36_1, [label - 'Delegated Regulation (EU) 2024/1774 Art 36(1) (ICT security testing plan)', ref - 'CELEX 32024R1774, unit parag_036.001', verbatim - 'shall establish and implement an ICT security testing plan to validate the effectiveness of their ICT security measures']).
citation(eu_reg_2024_1774_art_36_2, [label - 'Delegated Regulation (EU) 2024/1774 Art 36(2) (review, assessment and testing of ICT security measures)', ref - 'CELEX 32024R1774, unit parag_036.002', verbatim - 'shall review, asses and test ICT security measures, taking into consideration the overall risk profile of the ICT assets of the financial entity.']).
citation(eu_reg_2024_1774_art_36_3, [label - 'Delegated Regulation (EU) 2024/1774 Art 36(3) (monitoring and evaluation of security test results)', ref - 'CELEX 32024R1774, unit parag_036.003', verbatim - 'shall monitor and evaluate the results of the security tests and update their security measures accordingly without undue delay']).
citation(eu_reg_2024_1774_art_37, [label - 'Delegated Regulation (EU) 2024/1774 Article 37, lead words and points (a) to (c) (ICT systems acquisition, development, and maintenance)', ref - 'CELEX 32024R1774, units art_037, point_037_a, point_037_b, point_037_c', verbatim - 'shall design and implement, where appropriate, a procedure governing the acquisition, development, and maintenance of ICT systems following a risk-based approach.']).
citation(eu_reg_2024_1774_art_38_1, [label - 'Delegated Regulation (EU) 2024/1774 Art 38(1) (ICT project management procedure)', ref - 'CELEX 32024R1774, unit parag_038.001', verbatim - 'shall develop, document, and implement an ICT project management procedure and shall specify the roles and responsibilities for its implementation.']).
citation(eu_reg_2024_1774_art_38_2, [label - 'Delegated Regulation (EU) 2024/1774 Art 38(2) (ICT change management procedure)', ref - 'CELEX 32024R1774, unit parag_038.002', verbatim - 'shall develop, document, and implement an ICT change management procedure']).
citation(eu_reg_2024_1774_art_39_1, [label - 'Delegated Regulation (EU) 2024/1774 Art 39(1) (ICT business continuity plans based on the analysis of severe business disruptions and scenarios)', ref - 'CELEX 32024R1774, unit parag_039.001', verbatim - 'shall develop their ICT business continuity plans considering the results of the analysis of their exposures to and potential impact of severe business disruptions']).
citation(eu_reg_2024_1774_art_39_2, [label - 'Delegated Regulation (EU) 2024/1774 Art 39(2), lead words, points (a) to (j) and closing sentence on point (f) (components of the ICT business continuity plans)', ref - 'CELEX 32024R1774, units parag_039.002, point_039.002_a to point_039.002_j', verbatim - 'For the purposes of point (f), the measures referred to in that point shall provide for the mitigation of failures of critical third-party providers.']).
citation(eu_reg_2024_1774_art_40_1, [label - 'Delegated Regulation (EU) 2024/1774 Art 40(1) (testing of business continuity plans)', ref - 'CELEX 32024R1774, unit parag_040.001', verbatim - 'at least once every year for the back-up and restore procedures, or upon every major change of the business continuity plan.']).
citation(eu_reg_2024_1774_art_40_2, [label - 'Delegated Regulation (EU) 2024/1774 Art 40(2) (what the testing of business continuity plans demonstrates)', ref - 'CELEX 32024R1774, unit parag_040.002', verbatim - 'are able to sustain the viability of their businesses until critical operations are re-established']).
citation(eu_reg_2024_1774_art_40_3, [label - 'Delegated Regulation (EU) 2024/1774 Art 40(3) (documentation of test results and reporting of deficiencies to the management body)', ref - 'CELEX 32024R1774, unit parag_040.003', verbatim - 'shall document the results of the testing of business continuity plans']).
citation(eu_reg_2024_1774_art_41_1, [label - 'Delegated Regulation (EU) 2024/1774 Art 41(1) (format of the report on the review: searchable electronic format)', ref - 'CELEX 32024R1774, unit parag_041.001', verbatim - 'shall submit the report on the review of the ICT risk management framework referred to in paragraph 2 of that Article in a searchable electronic format.']).
citation(eu_reg_2024_1774_art_41_2, [label - 'Delegated Regulation (EU) 2024/1774 Art 41(2), lead words and points (a) to (h), with points (a)(i) to (v) and (c)(i) and (ii) (content of the report on the review)', ref - 'CELEX 32024R1774, units parag_041.002 to point_041.002_h', verbatim - 'The report referred to in paragraph 1 shall contain all of the following information:']).

implements(Key) :-
    citation(Key, _).

test(the_gate_key_is_recorded) :-
    implements(eu_reg_2022_2554_art_16_1).
test(the_report_content_key_is_recorded) :-
    implements(eu_reg_2024_1774_art_41_2).
test(the_trigger_provision_is_recorded) :-
    implements(eu_reg_2022_2554_art_16_2).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2024_1774_art_42).
test(the_placeholder_key_is_gone, fail) :-
    implements(eu_todo_primary_source).
