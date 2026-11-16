% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_4_25, [label - 'Regulation (EU) 2016/679 Art 4(25) definition of information society service', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj', verbatim - 'a service as defined in point (b) of Article 1(1) of Directive (EU) 2015/1535']).
citation(eu_reg_2016_679_art_8_1, [label - 'Regulation (EU) 2016/679 Art 8(1) first subparagraph (age of the child, parental consent below 16)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj', verbatim - 'the processing of the personal data of a child shall be lawful where the child is at least 16 years old']).
citation(eu_reg_2016_679_art_8_1_second_subpara, [label - 'Regulation (EU) 2016/679 Art 8(1) second subparagraph (lower age set by Member State law, not below 13)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj', verbatim - 'Member States may provide by law for a lower age for those purposes provided that such lower age is not below 13 years']).
citation(eu_reg_2016_679_art_8_2, [label - 'Regulation (EU) 2016/679 Art 8(2) (reasonable efforts to verify parental consent)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj', verbatim - 'The controller shall make reasonable efforts to verify in such cases that consent is given or authorised by the holder of parental responsibility over the child']).
citation(member_state_digital_consent_age_law, [label - 'Law of the Member State setting the age of digital consent (Art 8(1) second subparagraph)', ref - 'The national provision, supplied by the attester as an outside fact']).

implements(Key) :-
    citation(Key, _).
