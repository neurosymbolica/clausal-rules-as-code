% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_4_1, [label - 'Regulation (EU) 2016/679 Art 4(1) definition of personal data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_1)', verbatim - 'any information relating to an identified or identifiable natural person (data subject); an identifiable natural person is one who can be identified, directly or indirectly, in particular by reference to an identifier such as a name, an identification number, location data, an online identifier or to one or more factors specific to the physical, physiological, genetic, mental, economic, cultural or social identity of that natural person']).
citation(eu_reg_2016_679_art_4_2, [label - 'Regulation (EU) 2016/679 Art 4(2) definition of processing', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_2)', verbatim - 'any operation or set of operations which is performed on personal data or on sets of personal data, whether or not by automated means']).
citation(eu_reg_2016_679_art_4_3, [label - 'Regulation (EU) 2016/679 Art 4(3) definition of restriction of processing', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_3)', verbatim - 'the marking of stored personal data with the aim of limiting their processing in the future']).
citation(eu_reg_2016_679_art_4_4, [label - 'Regulation (EU) 2016/679 Art 4(4) definition of profiling', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_4)', verbatim - 'any form of automated processing of personal data consisting of the use of personal data to evaluate certain personal aspects relating to a natural person']).
citation(eu_reg_2016_679_art_4_5, [label - 'Regulation (EU) 2016/679 Art 4(5) definition of pseudonymisation', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_5)', verbatim - 'the processing of personal data in such a manner that the personal data can no longer be attributed to a specific data subject without the use of additional information, provided that such additional information is kept separately and is subject to technical and organisational measures to ensure that the personal data are not attributed to an identified or identifiable natural person']).
citation(eu_reg_2016_679_art_4_6, [label - 'Regulation (EU) 2016/679 Art 4(6) definition of filing system', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_6)', verbatim - 'any structured set of personal data which are accessible according to specific criteria, whether centralised, decentralised or dispersed on a functional or geographical basis']).
citation(eu_reg_2016_679_art_4_9, [label - 'Regulation (EU) 2016/679 Art 4(9) definition of recipient', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_9)', verbatim - 'a natural or legal person, public authority, agency or another body, to which the personal data are disclosed, whether a third party or not. However, public authorities which may receive personal data in the framework of a particular inquiry in accordance with Union or Member State law shall not be regarded as recipients']).
citation(eu_reg_2016_679_art_4_10, [label - 'Regulation (EU) 2016/679 Art 4(10) definition of third party', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_10)', verbatim - 'a natural or legal person, public authority, agency or body other than the data subject, controller, processor and persons who, under the direct authority of the controller or processor, are authorised to process personal data']).
citation(eu_reg_2016_679_art_4_11, [label - 'Regulation (EU) 2016/679 Art 4(11) definition of consent of the data subject', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_11)', verbatim - 'any freely given, specific, informed and unambiguous indication of the data subject\'s wishes by which he or she, by a statement or by a clear affirmative action, signifies agreement to the processing of personal data relating to him or her']).
citation(eu_reg_2016_679_art_4_12, [label - 'Regulation (EU) 2016/679 Art 4(12) definition of personal data breach', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_12)', verbatim - 'a breach of security leading to the accidental or unlawful destruction, loss, alteration, unauthorised disclosure of, or access to, personal data transmitted, stored or otherwise processed']).
citation(eu_reg_2016_679_art_4_25, [label - 'Regulation (EU) 2016/679 Art 4(25) definition of information society service', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_25)', verbatim - 'a service as defined in point (b) of Article 1(1) of Directive (EU) 2015/1535 of the European Parliament and of the Council']).
citation(eu_reg_2016_679_art_4_26, [label - 'Regulation (EU) 2016/679 Art 4(26) definition of international organisation', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_26)', verbatim - 'an organisation and its subordinate bodies governed by public international law, or any other body which is set up by, or on the basis of, an agreement between two or more countries']).
citation(eu_dir_2015_1535_art_1_1_b, [label - 'Directive (EU) 2015/1535 Art 1(1)(b) definition of service (information society service), target of Regulation (EU) 2016/679 Art 4(25)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32015L1535']).
citation(public_international_law_governing_organisation, [label - 'Public international law governing an organisation and its subordinate bodies, target of Regulation (EU) 2016/679 Art 4(26)', ref - 'Regulation (EU) 2016/679 Art 4(26) (outside fact organisation_governed_by_public_international_law; no pinned source)']).

implements(Key) :-
    citation(Key, _).

test(every_vocabulary_key_is_recorded) :-
    implements(eu_reg_2016_679_art_4_1),
    implements(eu_reg_2016_679_art_4_2),
    implements(eu_reg_2016_679_art_4_3),
    implements(eu_reg_2016_679_art_4_4),
    implements(eu_reg_2016_679_art_4_5),
    implements(eu_reg_2016_679_art_4_6),
    implements(eu_reg_2016_679_art_4_9),
    implements(eu_reg_2016_679_art_4_10),
    implements(eu_reg_2016_679_art_4_11),
    implements(eu_reg_2016_679_art_4_12),
    implements(eu_reg_2016_679_art_4_25),
    implements(eu_reg_2016_679_art_4_26).
test(the_targets_are_recorded) :-
    implements(eu_dir_2015_1535_art_1_1_b),
    implements(public_international_law_governing_organisation).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_reg_2016_679_art_4_7).
