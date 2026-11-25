% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2022_2555_art_4_1, [label - 'Directive (EU) 2022/2555 (NIS 2 Directive) Art 4(1), first sentence (sector-specific Union legal acts: the relevant provisions shall not apply)', ref - 'CELEX 32022L2555, unit parag_004.001, OJ L 333, 27.12.2022, p. 80, https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the relevant provisions of this Directive, including the provisions on supervision and enforcement laid down in Chapter VII, shall not apply to such entities']).
citation(eu_dir_2022_2555_art_4_2, [label - 'Directive (EU) 2022/2555 (NIS 2 Directive) Art 4(2), lead words (when requirements are equivalent in effect)', ref - 'CELEX 32022L2555, unit parag_004.002, OJ L 333, 27.12.2022, p. 80, https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'shall be considered to be equivalent in effect to the obligations laid down in this Directive where']).
citation(eu_dir_2022_2555_art_4_2_a, [label - 'Directive (EU) 2022/2555 (NIS 2 Directive) Art 4(2)(a) (cybersecurity risk-management measures at least equivalent in effect to Article 21(1) and (2))', ref - 'CELEX 32022L2555, unit point_004.002_a, OJ L 333, 27.12.2022, p. 80, https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'cybersecurity risk-management measures are at least equivalent in effect to those laid down in Article 21(1) and (2)']).
citation(eu_dir_2022_2555_art_4_2_b, [label - 'Directive (EU) 2022/2555 (NIS 2 Directive) Art 4(2)(b) (immediate access to incident notifications and notification requirements at least equivalent in effect to Article 23(1) to (6))', ref - 'CELEX 32022L2555, unit point_004.002_b, OJ L 333, 27.12.2022, p. 80, https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'requirements to notify significant incidents are at least equivalent in effect to those laid down in Article 23(1) to (6) of this Directive']).
citation(eu_reg_2022_2554_art_1_2, [label - 'Regulation (EU) 2022/2554 (DORA) Art 1(2) (DORA as the sector-specific Union legal act for financial entities identified as essential or important entities)', ref - 'CELEX 32022R2554, unit parag_001.002, OJ L 333, 27.12.2022, p. 1, https://eur-lex.europa.eu/eli/reg/2022/2554/oj', verbatim - 'this Regulation shall be considered a sector-specific Union legal act for the purposes of Article 4 of that Directive']).

implements(Key) :-
    citation(Key, _).
