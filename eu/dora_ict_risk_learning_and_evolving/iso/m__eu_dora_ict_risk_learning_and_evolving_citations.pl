% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_2554_art_13_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(1): capabilities and staff to gather information on vulnerabilities, cyber threats and ICT-related incidents and analyse their likely impact', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.001)', verbatim - 'Financial entities shall have in place capabilities and staff to gather information on vulnerabilities and cyber threats, ICT-related incidents, in particular cyber-attacks, and analyse the impact they are likely to have on their digital operational resilience.']).
citation(eu_reg_2022_2554_art_13_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(2), first to third subparagraphs: post ICT-related incident reviews after a major ICT-related incident disrupts core activities, communication of the changes upon request (other than microenterprises), and what the reviews determine', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.002)', verbatim - 'Financial entities shall put in place post ICT-related incident reviews after a major ICT-related incident disrupts their core activities, analysing the causes of disruption and identifying required improvements to the ICT operations or within the ICT business continuity policy referred to in Article 11.']).
citation(eu_reg_2022_2554_art_13_2_a, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(2), third subparagraph, point (a): promptness in responding to security alerts and determining impact and severity', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_013.002_a)', verbatim - 'the promptness in responding to security alerts and determining the impact of ICT-related incidents and their severity']).
citation(eu_reg_2022_2554_art_13_2_b, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(2), third subparagraph, point (b): quality and speed of performing a forensic analysis, where deemed appropriate', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_013.002_b)', verbatim - 'the quality and speed of performing a forensic analysis, where deemed appropriate']).
citation(eu_reg_2022_2554_art_13_2_c, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(2), third subparagraph, point (c): effectiveness of incident escalation within the financial entity', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_013.002_c)', verbatim - 'the effectiveness of incident escalation within the financial entity']).
citation(eu_reg_2022_2554_art_13_2_d, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(2), third subparagraph, point (d): effectiveness of internal and external communication', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#point_013.002_d)', verbatim - 'the effectiveness of internal and external communication']).
citation(eu_reg_2022_2554_art_13_3, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(3): lessons incorporated on a continuous basis into the ICT risk assessment process; findings as the basis for reviews of the ICT risk management framework', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.003)', verbatim - 'Those findings shall form the basis for appropriate reviews of relevant components of the ICT risk management framework referred to in Article 6(1).']).
citation(eu_reg_2022_2554_art_13_4, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(4): monitoring the digital operational resilience strategy; mapping ICT risk; analysing ICT-related incidents; enhancing cyber maturity and preparedness', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.004)', verbatim - 'Financial entities shall monitor the effectiveness of the implementation of their digital operational resilience strategy set out in Article 6(8).']).
citation(eu_reg_2022_2554_art_13_5, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(5): senior ICT staff report at least yearly to the management body, with recommendations', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.005)', verbatim - 'Senior ICT staff shall report at least yearly to the management body on the findings referred to in paragraph 3 and put forward recommendations.']).
citation(eu_reg_2022_2554_art_13_6, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(6): ICT security awareness programmes and digital operational resilience training as compulsory modules, for all staff, and for ICT third-party service providers where appropriate', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.006)', verbatim - 'Financial entities shall develop ICT security awareness programmes and digital operational resilience training as compulsory modules in their staff training schemes.']).
citation(eu_reg_2022_2554_art_13_7, [label - 'Regulation (EU) 2022/2554 (DORA) Art 13(7): financial entities other than microenterprises monitor technological developments and keep up to date with ICT risk management processes', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_013.007)', verbatim - 'Financial entities, other than microenterprises, shall monitor relevant technological developments on a continuous basis']).
citation(eu_reg_2022_2554_art_16_1, [label - 'Regulation (EU) 2022/2554 (DORA) Art 16(1), first subparagraph: Articles 5 to 15 do not apply to the entities listed', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2554 (unit 32022R2554#parag_016.001)', verbatim - 'Articles 5 to 15 of this Regulation shall not apply to small and non-interconnected investment firms']).

implements(Key) :-
    citation(Key, _).

test(every_fixed_paragraph_key_is_recorded) :-
    implements(eu_reg_2022_2554_art_13_1),
    implements(eu_reg_2022_2554_art_13_2),
    implements(eu_reg_2022_2554_art_13_3),
    implements(eu_reg_2022_2554_art_13_4),
    implements(eu_reg_2022_2554_art_13_5),
    implements(eu_reg_2022_2554_art_13_6),
    implements(eu_reg_2022_2554_art_13_7).
test(point_and_gate_keys_are_recorded) :-
    implements(eu_reg_2022_2554_art_13_2_a),
    implements(eu_reg_2022_2554_art_13_2_b),
    implements(eu_reg_2022_2554_art_13_2_c),
    implements(eu_reg_2022_2554_art_13_2_d),
    implements(eu_reg_2022_2554_art_16_1).

test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_reg_2022_2554_art_13_8).
