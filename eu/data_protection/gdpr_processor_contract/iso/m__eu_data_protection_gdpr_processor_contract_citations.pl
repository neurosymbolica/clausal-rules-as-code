% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_4_1, [label - 'GDPR Art 4(1) definition of personal data', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_2, [label - 'GDPR Art 4(2) definition of processing', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_7, [label - 'GDPR Art 4(7) definition of controller', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_4_8, [label - 'GDPR Art 4(8) definition of processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_1, [label - 'GDPR Art 28(1) sufficient guarantees', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_2, [label - 'GDPR Art 28(2) authorisation to engage another processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3, [label - 'GDPR Art 28(3) first subparagraph, binding contract and content elements', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_a, [label - 'GDPR Art 28(3)(a) documented instructions', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_b, [label - 'GDPR Art 28(3)(b) confidentiality', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_c, [label - 'GDPR Art 28(3)(c) Article 32 measures', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_d, [label - 'GDPR Art 28(3)(d) conditions for engaging another processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_e, [label - 'GDPR Art 28(3)(e) assistance with data subject requests', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_f, [label - 'GDPR Art 28(3)(f) assistance with Articles 32 to 36', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_g, [label - 'GDPR Art 28(3)(g) deletion or return of data', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_h, [label - 'GDPR Art 28(3)(h) information and audits', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_3_second_subpara, [label - 'GDPR Art 28(3) second subparagraph, notice of infringing instruction', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_4, [label - 'GDPR Art 28(4) obligations flowed down to another processor', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_5, [label - 'GDPR Art 28(5) codes of conduct and certification', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_6, [label - 'GDPR Art 28(6) standard contractual clauses as a basis', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_7, [label - 'GDPR Art 28(7) Commission standard contractual clauses', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_8, [label - 'GDPR Art 28(8) supervisory authority standard contractual clauses', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_9, [label - 'GDPR Art 28(9) in writing including electronic form', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_28_10, [label - 'GDPR Art 28(10) processor determining purposes and means', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
citation(eu_reg_2016_679_art_29, [label - 'GDPR Art 29 processing under the authority of the controller', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj']).
