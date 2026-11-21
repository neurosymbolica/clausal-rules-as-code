% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_citations, [citation/2, implements/1, gdpr_art6_lawful_basis_outside_fact_entry/3, gdpr_art6_lawful_basis_referable/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_6_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1) first subparagraph, first words (at least one of the following applies)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Processing shall be lawful only if and to the extent that at least one of the following applies:']).
citation(eu_reg_2016_679_art_6_1_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(a) (consent)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the data subject has given consent to the processing of his or her personal data for one or more specific purposes']).
citation(eu_reg_2016_679_art_6_1_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(b) (necessary for the performance of a contract)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'processing is necessary for the performance of a contract to which the data subject is party or in order to take steps at the request of the data subject prior to entering into a contract']).
citation(eu_reg_2016_679_art_6_1_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(c) (necessary for compliance with a legal obligation)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'processing is necessary for compliance with a legal obligation to which the controller is subject']).
citation(eu_reg_2016_679_art_6_1_d, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(d) (necessary to protect vital interests)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'processing is necessary in order to protect the vital interests of the data subject or of another natural person']).
citation(eu_reg_2016_679_art_6_1_e, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(e) (necessary for a task in the public interest or official authority)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'processing is necessary for the performance of a task carried out in the public interest or in the exercise of official authority vested in the controller']).
citation(eu_reg_2016_679_art_6_1_f, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1)(f) (legitimate interests, unless overridden; in particular a child)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'processing is necessary for the purposes of the legitimate interests pursued by the controller or by a third party, except where such interests are overridden by the interests or fundamental rights and freedoms of the data subject which require protection of personal data, in particular where the data subject is a child']).
citation(eu_reg_2016_679_art_6_1_second_subpara, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(1) second (last) subparagraph (point (f) not for public authorities in their tasks)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Point (f) of the first subparagraph shall not apply to processing carried out by public authorities in the performance of their tasks.']).
citation(eu_reg_2016_679_art_6_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(3) first sentence (basis of points (c) and (e) laid down by Union or Member State law)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The basis for the processing referred to in point (c) and (e) of paragraph 1 shall be laid down by:']).
citation(eu_reg_2016_679_art_6_4, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4) first words (compatibility of processing for another purpose)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'in order to ascertain whether processing for another purpose is compatible with the purpose for which the personal data are initially collected, take into account, inter alia:']).
citation(eu_reg_2016_679_art_6_4_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4)(a) (factor: link between the purposes)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'any link between the purposes for which the personal data have been collected and the purposes of the intended further processing']).
citation(eu_reg_2016_679_art_6_4_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4)(b) (factor: context of collection)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the context in which the personal data have been collected, in particular regarding the relationship between data subjects and the controller']).
citation(eu_reg_2016_679_art_6_4_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4)(c) (factor: nature of the personal data)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the nature of the personal data, in particular whether special categories of personal data are processed, pursuant to Article 9, or whether personal data related to criminal convictions and offences are processed, pursuant to Article 10']).
citation(eu_reg_2016_679_art_6_4_d, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4)(d) (factor: possible consequences for data subjects)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the possible consequences of the intended further processing for data subjects']).
citation(eu_reg_2016_679_art_6_4_e, [label - 'Regulation (EU) 2016/679 (GDPR) Art 6(4)(e) (factor: appropriate safeguards)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the existence of appropriate safeguards, which may include encryption or pseudonymisation']).
citation(eu_reg_2016_679_art_9_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 9(1) (special categories of personal data; flagged only, not decided)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Processing of personal data revealing racial or ethnic origin, political opinions, religious or philosophical beliefs, or trade union membership']).

implements(Key) :-
    citation(Key, _).

gdpr_art6_lawful_basis_outside_fact_entry(consent_given_and_conditions_met, cite(eu_reg_2016_679_art_6_1_a), consent_basis_statement).
gdpr_art6_lawful_basis_outside_fact_entry(legal_obligation_laid_down_by_law, cite(eu_reg_2016_679_art_6_3), legal_obligation_law_statement).
gdpr_art6_lawful_basis_outside_fact_entry(public_interest_task_laid_down_by_law, cite(eu_reg_2016_679_art_6_3), public_interest_task_law_statement).
gdpr_art6_lawful_basis_outside_fact_entry(child_data_subject, cite(eu_reg_2016_679_art_6_1_f), child_data_subject_statement).
gdpr_art6_lawful_basis_outside_fact_entry(special_category, cite(eu_reg_2016_679_art_9_1), special_category_statement).

gdpr_art6_lawful_basis_referable(consent_given_and_conditions_met).
gdpr_art6_lawful_basis_referable(legal_obligation_laid_down_by_law).
gdpr_art6_lawful_basis_referable(public_interest_task_laid_down_by_law).

test(every_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_6_1),
    implements(eu_reg_2016_679_art_6_4_e).
test(consent_entry_target) :-
    gdpr_art6_lawful_basis_outside_fact_entry(consent_given_and_conditions_met, cite(eu_reg_2016_679_art_6_1_a), consent_basis_statement).
test(legal_obligation_law_is_referable) :-
    gdpr_art6_lawful_basis_referable(legal_obligation_laid_down_by_law).

test(unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_6_2).
test(child_is_not_referable, fail) :-
    gdpr_art6_lawful_basis_referable(child_data_subject).
