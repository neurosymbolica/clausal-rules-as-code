% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_44, [label - 'Regulation (EU) 2016/679 (GDPR) Art 44, first sentence (general principle for transfers, including onward transfers)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'including for onward transfers of personal data from the third country or an international organisation to another third country or to another international organisation']).
citation(eu_reg_2016_679_art_48, [label - 'Regulation (EU) 2016/679 (GDPR) Art 48 (transfers or disclosures not authorised by Union law)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Any judgment of a court or tribunal and any decision of an administrative authority of a third country requiring a controller or processor to transfer or disclose personal data may only be recognised or enforceable in any manner if based on an international agreement, such as a mutual legal assistance treaty, in force between the requesting third country and the Union or a Member State, without prejudice to other grounds for transfer pursuant to this Chapter.']).
citation(eu_reg_2016_679_art_49_1_second_subpara, [label - 'Regulation (EU) 2016/679 (GDPR) Art 49(1), second subparagraph, second and third sentences (duties of the controller to inform the supervisory authority and the data subject)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller shall inform the supervisory authority of the transfer. The controller shall, in addition to providing the information referred to in Articles 13 and 14, inform the data subject of the transfer and on the compelling legitimate interests pursued.']).
citation(eu_reg_2016_679_art_49_6, [label - 'Regulation (EU) 2016/679 (GDPR) Art 49(6) (documentation of the assessment and the suitable safeguards in the Article 30 records)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller or processor shall document the assessment as well as the suitable safeguards referred to in the second subparagraph of paragraph 1 of this Article in the records referred to in Article 30.']).
citation(second_subparagraph_transfer_statement, [label - 'Referral target: attested statement that the transfer takes place under Regulation (EU) 2016/679 (GDPR) Art 49(1), second subparagraph (decided by gdpr-chapter-v-transfers or stated by a human)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(foreign_judgment_requires_transfer_statement, [label - 'Referral target: attested statement that a judgment or decision of a third country requires the transfer or disclosure, Regulation (EU) 2016/679 (GDPR) Art 48', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(international_agreement_basis_statement, [label - 'Referral target: attested statement that the judgment or decision is based on an international agreement in force between the requesting third country and the Union or a Member State, Regulation (EU) 2016/679 (GDPR) Art 48', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(onward_transfer_statement, [label - 'Referral target: attested statement that the transfer is an onward transfer, Regulation (EU) 2016/679 (GDPR) Art 44, first sentence', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(onward_transfer_chapter_v_basis_statement, [label - 'Referral target: attested Chapter V answer for the onward transfer on its own facts (a new call of gdpr-chapter-v-transfers), Regulation (EU) 2016/679 (GDPR) Art 44, first sentence', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).

implements(Key) :-
    citation(Key, _).

test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_49_6).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_49).
