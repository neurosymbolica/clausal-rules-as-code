% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_21_4, [label - 'Regulation (EU) 2016/679 (GDPR) Art 21(4) -- notice of the right to object, explicitly, at the latest at the first communication, clearly and separately', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_021.004)', verbatim - 'At the latest at the time of the first communication with the data subject, the right referred to in paragraphs 1 and 2 shall be explicitly brought to the attention of the data subject and shall be presented clearly and separately from any other information.']).
citation(eu_reg_2016_679_art_17_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 17(2) -- controller that made personal data public and is obliged to erase shall take reasonable steps to inform other controllers', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_017.002)', verbatim - 'Where the controller has made the personal data public and is obliged pursuant to paragraph 1 to erase the personal data, the controller, taking account of available technology and the cost of implementation, shall take reasonable steps, including technical measures, to inform controllers which are processing the personal data that the data subject has requested the erasure by such controllers of any links to, or copy or replication of, those personal data.']).
citation(article_21_right_to_object_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 21(1) and Art 21(2) -- statement that the data subject has a right to object (deferred; outside fact right_to_object_applies)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (units 02016R0679-20160504#parag_021.001, 02016R0679-20160504#parag_021.002)', verbatim - 'shall have the right to object']).
citation(article_17_1_erasure_obligation_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 17(1) with Art 17(3) -- statement that the controller is obliged to erase the personal data (deferred; outside fact controller_obliged_to_erase_under_article_17_1)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (units 02016R0679-20160504#parag_017.001, 02016R0679-20160504#parag_017.003)', verbatim - 'the controller shall have the obligation to erase personal data without undue delay where one of the following grounds applies:']).

implements(Key) :-
    citation(Key, _).
