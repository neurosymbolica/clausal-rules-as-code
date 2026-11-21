% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_4_1, [label - 'Regulation (EU) 2016/679 Art 4(1) definition of personal data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_004_1)', verbatim - 'any information relating to an identified or identifiable natural person']).
citation(eu_reg_2016_679_art_4_2, [label - 'Regulation (EU) 2016/679 Art 4(2) definition of processing', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_004_2)', verbatim - 'any operation or set of operations which is performed on personal data or on sets of personal data']).
citation(eu_reg_2016_679_art_4_7, [label - 'Regulation (EU) 2016/679 Art 4(7) definition of controller', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_004_7)', verbatim - 'which, alone or jointly with others, determines the purposes and means of the processing of personal data']).
citation(eu_reg_2016_679_art_4_8, [label - 'Regulation (EU) 2016/679 Art 4(8) definition of processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_004_8)', verbatim - 'a natural or legal person, public authority, agency or other body which processes personal data on behalf of the controller']).
citation(eu_reg_2016_679_art_28_1, [label - 'Regulation (EU) 2016/679 Art 28(1) sufficient guarantees of the processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.001)', verbatim - 'the controller shall use only processors providing sufficient guarantees to implement appropriate technical and organisational measures']).
citation(eu_reg_2016_679_art_28_2, [label - 'Regulation (EU) 2016/679 Art 28(2) prior written authorisation to engage another processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.002)', verbatim - 'The processor shall not engage another processor without prior specific or general written authorisation of the controller.']).
citation(eu_reg_2016_679_art_28_3, [label - 'Regulation (EU) 2016/679 Art 28(3) first subparagraph, first sentence (binding contract under Union or Member State law and its content elements)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.003)', verbatim - 'Processing by a processor shall be governed by a contract or other legal act under Union or Member State law, that is binding on the processor with regard to the controller']).
citation(eu_reg_2016_679_art_28_3_a, [label - 'Regulation (EU) 2016/679 Art 28(3)(a) processing only on documented instructions', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_a)', verbatim - 'processes the personal data only on documented instructions from the controller']).
citation(eu_reg_2016_679_art_28_3_b, [label - 'Regulation (EU) 2016/679 Art 28(3)(b) confidentiality of authorised persons', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_b)', verbatim - 'ensures that persons authorised to process the personal data have committed themselves to confidentiality']).
citation(eu_reg_2016_679_art_28_3_c, [label - 'Regulation (EU) 2016/679 Art 28(3)(c) measures required pursuant to Article 32', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_c)', verbatim - 'takes all measures required pursuant to Article 32']).
citation(eu_reg_2016_679_art_28_3_d, [label - 'Regulation (EU) 2016/679 Art 28(3)(d) conditions for engaging another processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_d)', verbatim - 'respects the conditions referred to in paragraphs 2 and 4 for engaging another processor']).
citation(eu_reg_2016_679_art_28_3_e, [label - 'Regulation (EU) 2016/679 Art 28(3)(e) assistance with data subject requests', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_e)', verbatim - 'assists the controller by appropriate technical and organisational measures, insofar as this is possible']).
citation(eu_reg_2016_679_art_28_3_f, [label - 'Regulation (EU) 2016/679 Art 28(3)(f) assistance with the obligations of Articles 32 to 36', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_f)', verbatim - 'assists the controller in ensuring compliance with the obligations pursuant to Articles 32 to 36']).
citation(eu_reg_2016_679_art_28_3_g, [label - 'Regulation (EU) 2016/679 Art 28(3)(g) deletion or return of personal data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_g)', verbatim - 'at the choice of the controller, deletes or returns all the personal data to the controller']).
citation(eu_reg_2016_679_art_28_3_h, [label - 'Regulation (EU) 2016/679 Art 28(3)(h) information and audits, including inspections', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#point_028.003_h)', verbatim - 'makes available to the controller all information necessary to demonstrate compliance with the obligations laid down in this Article']).
citation(eu_reg_2016_679_art_28_3_second_subpara, [label - 'Regulation (EU) 2016/679 Art 28(3) second subparagraph notice of an infringing instruction', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.003/2)', verbatim - 'the processor shall immediately inform the controller if, in its opinion, an instruction infringes this Regulation']).
citation(eu_reg_2016_679_art_28_4, [label - 'Regulation (EU) 2016/679 Art 28(4) first sentence same obligations imposed on another processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.004)', verbatim - 'the same data protection obligations as set out in the contract or other legal act between the controller and the processor as referred to in paragraph 3 shall be imposed on that other processor']).
citation(eu_reg_2016_679_art_28_6, [label - 'Regulation (EU) 2016/679 Art 28(6) contract based on standard contractual clauses', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.006)', verbatim - 'may be based, in whole or in part, on standard contractual clauses referred to in paragraphs 7 and 8 of this Article']).
citation(eu_reg_2016_679_art_28_7, [label - 'Regulation (EU) 2016/679 Art 28(7) standard contractual clauses laid down by the Commission', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.007)', verbatim - 'The Commission may lay down standard contractual clauses for the matters referred to in paragraph 3 and 4 of this Article']).
citation(eu_reg_2016_679_art_28_9, [label - 'Regulation (EU) 2016/679 Art 28(9) contract in writing, including in electronic form', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.009)', verbatim - 'shall be in writing, including in electronic form']).
citation(eu_reg_2016_679_art_28_10, [label - 'Regulation (EU) 2016/679 Art 28(10) processor determining purposes and means considered a controller', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (02016R0679-20160504#parag_028.010)', verbatim - 'the processor shall be considered to be a controller in respect of that processing']).

test(every_emitted_key_is_recorded) :-
    implements(eu_reg_2016_679_art_4_8),
    implements(eu_reg_2016_679_art_28_1),
    implements(eu_reg_2016_679_art_28_2),
    implements(eu_reg_2016_679_art_28_3),
    implements(eu_reg_2016_679_art_28_3_a),
    implements(eu_reg_2016_679_art_28_3_h),
    implements(eu_reg_2016_679_art_28_3_second_subpara),
    implements(eu_reg_2016_679_art_28_4),
    implements(eu_reg_2016_679_art_28_9),
    implements(eu_reg_2016_679_art_28_10).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_reg_2016_679_art_28).
