% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_4_25, [label - 'Regulation (EU) 2016/679 Art 4(25) definition of information society service', ref - 'CELEX 02016R0679-20160504, unit point_004_25', verbatim - 'information society service means a service as defined in point (b) of Article 1(1) of Directive (EU) 2015/1535 of the European Parliament and of the Council']).
citation(eu_reg_2016_679_art_8_1, [label - 'Regulation (EU) 2016/679 Art 8(1), first subparagraph', ref - 'CELEX 02016R0679-20160504, unit parag_008.001', verbatim - 'the processing of the personal data of a child shall be lawful where the child is at least 16 years old']).
citation(eu_reg_2016_679_art_8_1_second_subpara, [label - 'Regulation (EU) 2016/679 Art 8(1), second subparagraph (lower age set by Member State law)', ref - 'CELEX 02016R0679-20160504, unit parag_008.001', verbatim - 'Member States may provide by law for a lower age for those purposes provided that such lower age is not below 13 years.']).
citation(eu_reg_2016_679_art_8_2, [label - 'Regulation (EU) 2016/679 Art 8(2) reasonable efforts to verify parental consent', ref - 'CELEX 02016R0679-20160504, unit parag_008.002', verbatim - 'The controller shall make reasonable efforts to verify in such cases that consent is given or authorised by the holder of parental responsibility over the child, taking into consideration available technology.']).
citation(eu_reg_2016_679_art_8_3, [label - 'Regulation (EU) 2016/679 Art 8(3) general contract law of Member States (excluded)', ref - 'CELEX 02016R0679-20160504, unit parag_008.003', verbatim - 'Paragraph 1 shall not affect the general contract law of Member States such as the rules on the validity, formation or effect of a contract in relation to a child.']).
citation(member_state_digital_consent_age_law, [label - 'National law of the Member State setting the age of digital consent under Art 8(1), second subparagraph', ref - 'Attested per Member State; provision supplied by the attester']).

implements(Key) :-
    citation(Key, _).
