% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_citations, [citation/2, implements/1, citation_vocabulary/1, outside_fact_entry/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_7_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(1) (controller able to demonstrate consent)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.001)', verbatim - 'the controller shall be able to demonstrate that the data subject has consented to processing of his or her personal data']).
citation(eu_reg_2016_679_art_7_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(2) (presentation of a consent request in a written declaration concerning other matters; infringing part not binding)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.002)', verbatim - 'the request for consent shall be presented in a manner which is clearly distinguishable from the other matters, in an intelligible and easily accessible form, using clear and plain language']).
citation(eu_reg_2016_679_art_7_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(3) third and fourth sentences (informed of the right to withdraw before consent; withdrawal as easy as giving consent)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.003)', verbatim - 'Prior to giving consent, the data subject shall be informed thereof. It shall be as easy to withdraw as to give consent.']).
citation(eu_reg_2016_679_art_7_4, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(4) (assessment whether consent is freely given; contract conditional on unneeded consent)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.004)', verbatim - 'When assessing whether consent is freely given, utmost account shall be taken of whether, inter alia, the performance of a contract, including the provision of a service, is conditional on consent to the processing of personal data that is not necessary for the performance of that contract.']).
citation(eu_reg_2016_679_art_11_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 11(1) (no obligation to acquire information to identify the data subject)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_011.001)', verbatim - 'the controller shall not be obliged to maintain, acquire or process additional information in order to identify the data subject for the sole purpose of complying with this Regulation']).
citation(eu_reg_2016_679_art_11_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 11(2) (informing the data subject if possible; Articles 15 to 20 disapplied unless identifying information provided)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_011.002)', verbatim - 'the controller shall inform the data subject accordingly, if possible. In such cases, Articles 15 to 20 shall not apply except where the data subject, for the purpose of exercising his or her rights under those articles, provides additional information enabling his or her identification.']).
citation(consent_demonstration_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(1) outside-fact statement: the controller is able to demonstrate that the data subject has consented', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.001)', verbatim - 'the controller shall be able to demonstrate that the data subject has consented']).
citation(consent_request_presentation_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(2) first sentence outside-fact statement: the request for consent is clearly distinguishable, intelligible, easily accessible and in clear and plain language', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.002)', verbatim - 'clearly distinguishable from the other matters, in an intelligible and easily accessible form, using clear and plain language']).
citation(withdrawal_ease_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(3) fourth sentence outside-fact statement: withdrawal as easy as giving consent', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.003)', verbatim - 'It shall be as easy to withdraw as to give consent.']).
citation(consent_freely_given_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 7(4) outside-fact statement: whether the consent is freely given', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_007.004)', verbatim - 'When assessing whether consent is freely given']).
citation(identification_not_required_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 11(1) outside-fact statement: the purposes do not or no longer require identification of the data subject', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_011.001)', verbatim - 'do not or do no longer require the identification of a data subject by the controller']).
citation(inability_to_identify_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 11(2) first sentence outside-fact statement: the controller is able to demonstrate that it is not in a position to identify the data subject', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_011.002)', verbatim - 'the controller is able to demonstrate that it is not in a position to identify the data subject']).
citation(informing_possible_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 11(2) first sentence outside-fact statement: informing the data subject is possible', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit parag_011.002)', verbatim - 'the controller shall inform the data subject accordingly, if possible']).

implements(Key) :-
    citation(Key, _).

citation_vocabulary([eu_reg_2016_679_art_7_1, eu_reg_2016_679_art_7_2, eu_reg_2016_679_art_7_3, eu_reg_2016_679_art_7_4, eu_reg_2016_679_art_11_1, eu_reg_2016_679_art_11_2]).

outside_fact_entry(consent_demonstrable, cite(eu_reg_2016_679_art_7_1), cite(consent_demonstration_statement)).
outside_fact_entry(request_clearly_distinguishable_and_intelligible, cite(eu_reg_2016_679_art_7_2), cite(consent_request_presentation_statement)).
outside_fact_entry(withdrawal_as_easy_as_giving_consent, cite(eu_reg_2016_679_art_7_3), cite(withdrawal_ease_statement)).
outside_fact_entry(consent_freely_given, cite(eu_reg_2016_679_art_7_4), cite(consent_freely_given_statement)).
outside_fact_entry(purposes_do_not_require_identification, cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)).
outside_fact_entry(able_to_demonstrate_not_in_position_to_identify, cite(eu_reg_2016_679_art_11_2), cite(inability_to_identify_statement)).
outside_fact_entry(informing_data_subject_possible, cite(eu_reg_2016_679_art_11_2), cite(informing_possible_statement)).

test(every_vocabulary_key_is_recorded) :-
    citation_vocabulary(Keys),
    maplist(implements, Keys).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_7_1).
test(seven_outside_fact_rows) :-
    findall(Key, outside_fact_entry(Key, _, _), Keys),
    length(Keys, 7).
test(every_outside_fact_citation_is_in_the_vocabulary) :-
    citation_vocabulary(Vocabulary),
    findall(Citation, outside_fact_entry(_, cite(Citation), _), Citations),
    maplist(citation_in_vocabulary(Vocabulary), Citations).
test(every_outside_fact_target_is_recorded) :-
    findall(Target, outside_fact_entry(_, _, cite(Target)), Targets),
    length(Targets, 7),
    maplist(implements, Targets).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_7).

citation_in_vocabulary(Vocabulary, Citation) :-
    member(Citation, Vocabulary).
