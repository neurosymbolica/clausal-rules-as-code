% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_82_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(1) right to compensation for material or non-material damage suffered as a result of an infringement', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.001)', verbatim - 'Any person who has suffered material or non-material damage as a result of an infringement of this Regulation shall have the right to receive compensation from the controller or processor for the damage suffered.']).
citation(eu_reg_2016_679_art_82_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(2) liability of the controller involved in processing (first sentence) and of the processor (second sentence)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.002)', verbatim - 'Any controller involved in processing shall be liable for the damage caused by processing which infringes this Regulation. A processor shall be liable for the damage caused by processing only where it has not complied with obligations of this Regulation specifically directed to processors or where it has acted outside or contrary to lawful instructions of the controller.']).
citation(eu_reg_2016_679_art_82_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(3) exemption from liability on proof of not being in any way responsible for the event giving rise to the damage', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.003)', verbatim - 'A controller or processor shall be exempt from liability under paragraph 2 if it proves that it is not in any way responsible for the event giving rise to the damage.']).
citation(non_responsibility_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(3) attested statement that the controller or processor is not in any way responsible for the event giving rise to the damage (outside-fact target; no fetcher)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.003)']).
citation(eu_reg_2016_679_art_82_4, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(4) liability of each controller or processor for the entire damage (deferred, no limb)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.004)', verbatim - 'Where more than one controller or processor, or both a controller and a processor, are involved in the same processing and where they are, under paragraphs 2 and 3, responsible for any damage caused by processing, each controller or processor shall be held liable for the entire damage in order to ensure effective compensation of the data subject.']).
citation(eu_reg_2016_679_art_82_5, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(5) claim back from the other controllers or processors involved in the same processing (deferred, no limb)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.005)', verbatim - 'Where a controller or processor has, in accordance with paragraph 4, paid full compensation for the damage suffered, that controller or processor shall be entitled to claim back from the other controllers or processors involved in the same processing that part of the compensation corresponding to their part of responsibility for the damage, in accordance with the conditions set out in paragraph 2.']).
citation(eu_reg_2016_679_art_82_6, [label - 'Regulation (EU) 2016/679 (GDPR) Art 82(6) courts competent for proceedings for compensation (deferred, no limb)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_082.006)', verbatim - 'Court proceedings for exercising the right to receive compensation shall be brought before the courts competent under the law of the Member State referred to in Article 79(2).']).

implements(Key) :-
    citation(Key, _).

test(the_right_to_compensation_is_recorded) :-
    implements(eu_reg_2016_679_art_82_1).
test(the_liability_limbs_are_recorded) :-
    implements(eu_reg_2016_679_art_82_2).
test(the_exemption_is_recorded) :-
    implements(eu_reg_2016_679_art_82_3).
test(the_outside_fact_target_is_recorded) :-
    implements(non_responsibility_statement).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(gdpr_art_82).
