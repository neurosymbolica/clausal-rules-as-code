% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_36_3, [label - 'Regulation (EU) 2016/679 Art 36(3), opening words (information the controller provides when consulting under Art 36(1))', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit parag_036.003', verbatim - 'When consulting the supervisory authority pursuant to paragraph 1, the controller shall provide the supervisory authority with:']).
citation(eu_reg_2016_679_art_36_3_a, [label - 'Regulation (EU) 2016/679 Art 36(3)(a) (respective responsibilities of the controller, joint controllers and processors, where applicable)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_a', verbatim - 'where applicable, the respective responsibilities of the controller, joint controllers and processors involved in the processing, in particular for processing within a group of undertakings']).
citation(eu_reg_2016_679_art_36_3_b, [label - 'Regulation (EU) 2016/679 Art 36(3)(b) (purposes and means of the intended processing)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_b', verbatim - 'the purposes and means of the intended processing']).
citation(eu_reg_2016_679_art_36_3_c, [label - 'Regulation (EU) 2016/679 Art 36(3)(c) (measures and safeguards protecting the rights and freedoms of data subjects)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_c', verbatim - 'the measures and safeguards provided to protect the rights and freedoms of data subjects pursuant to this Regulation']).
citation(eu_reg_2016_679_art_36_3_d, [label - 'Regulation (EU) 2016/679 Art 36(3)(d) (contact details of the data protection officer, where applicable)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_d', verbatim - 'where applicable, the contact details of the data protection officer']).
citation(eu_reg_2016_679_art_36_3_e, [label - 'Regulation (EU) 2016/679 Art 36(3)(e) (the data protection impact assessment provided for in Article 35)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_e', verbatim - 'the data protection impact assessment provided for in Article 35']).
citation(eu_reg_2016_679_art_36_3_f, [label - 'Regulation (EU) 2016/679 Art 36(3)(f) (any other information requested by the supervisory authority)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit point_036.003_f', verbatim - 'any other information requested by the supervisory authority']).
citation(controller_and_processor_roles_statement, [label - 'Statement of controller, joint controller and processor roles under Regulation (EU) 2016/679 Art 4(7), Art 4(8), Art 26 and Art 28 (referral target of the outside fact joint_controllers_or_processors_involved; not pinned, not decided in this order)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(eu_reg_2016_679_art_36_1, [label - 'Regulation (EU) 2016/679 Art 36(1) (duty to consult the supervisory authority prior to high-risk processing; read only to fix which consultation Art 36(3) governs)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit parag_036.001', verbatim - 'The controller shall consult the supervisory authority prior to processing where a data protection impact assessment under Article 35 indicates that the processing would result in a high risk in the absence of measures taken by the controller to mitigate the risk.']).
citation(eu_reg_2016_679_art_36_5, [label - 'Regulation (EU) 2016/679 Art 36(5) (consultation and prior authorisation required by Member State law; read only for reading (1) and Q1)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 unit parag_036.005', verbatim - 'Notwithstanding paragraph 1, Member State law may require controllers to consult with, and obtain prior authorisation from, the supervisory authority in relation to processing by a controller for the performance of a task carried out by the controller in the public interest, including processing in relation to social protection and public health.']).

implements(Key) :-
    citation(Key, _).

test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_36_3_a).
test(every_point_is_recorded) :-
    implements(eu_reg_2016_679_art_36_3),
    implements(eu_reg_2016_679_art_36_3_b),
    implements(eu_reg_2016_679_art_36_3_c),
    implements(eu_reg_2016_679_art_36_3_d),
    implements(eu_reg_2016_679_art_36_3_e),
    implements(eu_reg_2016_679_art_36_3_f),
    implements(controller_and_processor_roles_statement).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_36_3_g).
