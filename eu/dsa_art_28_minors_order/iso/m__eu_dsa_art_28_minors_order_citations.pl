% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_2065_art_19_1, [label - 'Regulation (EU) 2022/2065 (Digital Services Act) Art 19(1), exclusion of micro and small enterprises from Section 3 of Chapter III', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2065 (32022R2065#parag_019.001)', verbatim - 'This Section, with the exception of Article 24(3) thereof, shall not apply to providers of online platforms that qualify as micro or small enterprises as defined in Recommendation 2003/361/EC.']).
citation(eu_reg_2022_2065_art_19_2, [label - 'Regulation (EU) 2022/2065 (Digital Services Act) Art 19(2), application of Section 3 of Chapter III to designated very large online platforms', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2065 (32022R2065#parag_019.002)', verbatim - 'By derogation from paragraph 1 of this Article, this Section shall apply to providers of online platforms that have been designated as very large online platforms in accordance with Article 33, irrespective of whether they qualify as micro or small enterprises.']).
citation(eu_reg_2022_2065_art_28_1, [label - 'Regulation (EU) 2022/2065 (Digital Services Act) Art 28(1), obligation of providers of online platforms accessible to minors to put in place appropriate and proportionate measures', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2065 (32022R2065#parag_028.001)', verbatim - 'Providers of online platforms accessible to minors shall put in place appropriate and proportionate measures to ensure a high level of privacy, safety, and security of minors, on their service.']).
citation(eu_reg_2022_2065_art_28_2, [label - 'Regulation (EU) 2022/2065 (Digital Services Act) Art 28(2), prohibition of advertisements based on profiling where the recipient is known with reasonable certainty to be a minor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R2065 (32022R2065#parag_028.002)', verbatim - 'Providers of online platform shall not present advertisements on their interface based on profiling as defined in Article 4, point (4), of Regulation (EU) 2016/679 using personal data of the recipient of the service when they are aware with reasonable certainty that the recipient of the service is a minor.']).
citation(commission_vlop_designation_decision, [label - 'Commission decision designating an online platform as a very large online platform under Regulation (EU) 2022/2065 Art 33 (cross-reference target of Art 19(2); outside fact)', ref - 'https://digital-strategy.ec.europa.eu/en/policies/list-designated-vlops-and-vloses']).

implements(Key) :-
    citation(Key, _).

test(every_result_key_is_recorded) :-
    implements(eu_reg_2022_2065_art_19_1),
    implements(eu_reg_2022_2065_art_19_2),
    implements(eu_reg_2022_2065_art_28_1),
    implements(eu_reg_2022_2065_art_28_2).
test(the_cross_reference_target_is_recorded) :-
    implements(commission_vlop_designation_decision).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(dsa_art_28_1).
