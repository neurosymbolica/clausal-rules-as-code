% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_2554_art_24_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(1), the digital operational resilience testing programme', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.001)', verbatim - 'For the purpose of assessing preparedness for handling ICT-related incidents, of identifying weaknesses, deficiencies and gaps in digital operational resilience, and of promptly implementing corrective measures, financial entities, other than microenterprises, shall, taking into account the criteria set out in Article 4(2), establish, maintain and review a sound and comprehensive digital operational resilience testing programme as an integral part of the ICT risk-management framework referred to in Article 6.']).
citation(eu_reg_2022_2554_art_24_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(2), the range of assessments, tests, methodologies, practices and tools of the programme', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.002)', verbatim - 'The digital operational resilience testing programme shall include a range of assessments, tests, methodologies, practices and tools to be applied in accordance with Articles 25 and 26.']).
citation(eu_reg_2022_2554_art_24_3, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(3), the risk-based approach to the testing programme', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.003)', verbatim - 'When conducting the digital operational resilience testing programme referred to in paragraph 1 of this Article, financial entities, other than microenterprises, shall follow a risk-based approach taking into account the criteria set out in Article 4(2) duly considering the evolving landscape of ICT risk, any specific risks to which the financial entity concerned is or might be exposed, the criticality of information assets and of services provided, as well as any other factor the financial entity deems appropriate.']).
citation(eu_reg_2022_2554_art_24_4, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(4), first sentence independent testers, second sentence resources and conflicts of interest of an internal tester', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.004)', verbatim - 'Financial entities, other than microenterprises, shall ensure that tests are undertaken by independent parties, whether internal or external. Where tests are undertaken by an internal tester, financial entities shall dedicate sufficient resources and ensure that conflicts of interest are avoided throughout the design and execution phases of the test.']).
citation(eu_reg_2022_2554_art_24_5, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(5), first limb procedures and policies to prioritise, classify and remedy issues, second limb internal validation methodologies', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.005)', verbatim - 'Financial entities, other than microenterprises, shall establish procedures and policies to prioritise, classify and remedy all issues revealed throughout the performance of the tests and shall establish internal validation methodologies to ascertain that all identified weaknesses, deficiencies or gaps are fully addressed.']).
citation(eu_reg_2022_2554_art_24_6, [label - 'Regulation (EU) 2022/2554 (DORA) Art 24(6), yearly tests of ICT systems and applications supporting critical or important functions', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_024.006)', verbatim - 'Financial entities, other than microenterprises, shall ensure, at least yearly, that appropriate tests are conducted on all ICT systems and applications supporting critical or important functions.']).
citation(eu_reg_2022_2554_art_25_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 25(1), the execution of appropriate tests the programme provides for', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_025.001)', verbatim - 'The digital operational resilience testing programme referred to in Article 24 shall provide, in accordance with the criteria set out in Article 4(2), for the execution of appropriate tests, such as vulnerability assessments and scans, open source analyses, network security assessments, gap analyses, physical security reviews, questionnaires and scanning software solutions, source code reviews where feasible, scenario-based tests, compatibility testing, performance testing, end-to-end testing and penetration testing.']).
citation(eu_reg_2022_2554_art_25_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 25(2), vulnerability assessments before deployment by central securities depositories and central counterparties', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_025.002)', verbatim - 'Central securities depositories and central counterparties shall perform vulnerability assessments before any deployment or redeployment of new or existing applications and infrastructure components, and ICT services supporting critical or important functions of the financial entity.']).
citation(eu_reg_2022_2554_art_25_3, [label - 'Regulation (EU) 2022/2554 (DORA) Art 25(3), risk-based and strategically planned testing by microenterprises', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022R2554 (unit 32022R2554#parag_025.003)', verbatim - 'Microenterprises shall perform the tests referred to in paragraph 1 by combining a risk-based approach with a strategic planning of ICT testing, by duly considering the need to maintain a balanced approach between the scale of resources and the time to be allocated to the ICT testing provided for in this Article, on the one hand, and the urgency, type of risk, criticality of information assets and of services provided, as well as any other relevant factor, including the financial entity\x2019\s ability to take calculated risks, on the other hand.']).

implements(Key) :-
    citation(Key, _).

test(every_paragraph_of_article_24_is_recorded) :-
    implements(eu_reg_2022_2554_art_24_1),
    implements(eu_reg_2022_2554_art_24_2),
    implements(eu_reg_2022_2554_art_24_3),
    implements(eu_reg_2022_2554_art_24_4),
    implements(eu_reg_2022_2554_art_24_5),
    implements(eu_reg_2022_2554_art_24_6).
test(every_paragraph_of_article_25_is_recorded) :-
    implements(eu_reg_2022_2554_art_25_1),
    implements(eu_reg_2022_2554_art_25_2),
    implements(eu_reg_2022_2554_art_25_3).
test(nine_keys_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 9).

test(the_placeholder_key_is_gone, fail) :-
    implements(eu_todo_primary_source).
test(article_26_is_not_recorded, fail) :-
    implements(eu_reg_2022_2554_art_26_1).
