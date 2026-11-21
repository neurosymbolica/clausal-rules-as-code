% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_77_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 77(1), the right to lodge a complaint with a supervisory authority', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_077.001)', verbatim - 'Without prejudice to any other administrative or judicial remedy, every data subject shall have the right to lodge a complaint with a supervisory authority, in particular in the Member State of his or her habitual residence, place of work or place of the alleged infringement if the data subject considers that the processing of personal data relating to him or her infringes this Regulation.']).
citation(eu_reg_2016_679_art_78_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 78(1), the right to an effective judicial remedy against a legally binding decision of a supervisory authority', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_078.001)', verbatim - 'Without prejudice to any other administrative or non-judicial remedy, each natural or legal person shall have the right to an effective judicial remedy against a legally binding decision of a supervisory authority concerning them.']).
citation(eu_reg_2016_679_art_78_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 78(2), the right to an effective judicial remedy where the competent supervisory authority does not handle a complaint or does not inform within three months', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_078.002)', verbatim - 'Without prejudice to any other administrative or non-judicial remedy, each data subject shall have the right to a an effective judicial remedy where the supervisory authority which is competent pursuant to Articles 55 and 56 does not handle a complaint or does not inform the data subject within three months on the progress or outcome of the complaint lodged pursuant to Article 77.']).
citation(eu_reg_2016_679_art_79_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 79(1), the right to an effective judicial remedy against a controller or processor', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_079.001)', verbatim - 'Without prejudice to any available administrative or non-judicial remedy, including the right to lodge a complaint with a supervisory authority pursuant to Article 77, each data subject shall have the right to an effective judicial remedy where he or she considers that his or her rights under this Regulation have been infringed as a result of the processing of his or her personal data in non-compliance with this Regulation.']).
citation(eu_reg_2016_679_art_79_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 79(2), the courts before which proceedings against a controller or processor are brought, and the public-authority exception', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_079.002)', verbatim - 'Proceedings against a controller or a processor shall be brought before the courts of the Member State where the controller or processor has an establishment. Alternatively, such proceedings may be brought before the courts of the Member State where the data subject has his or her habitual residence, unless the controller or processor is a public authority of a Member State acting in the exercise of its public powers.']).
citation(competence_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Arts 55 and 56, the statement that the supervisory authority is competent (cross-reference target of Art 78(2); outside fact, not pinned, never decided)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (Articles 55 and 56, not pinned in this order)']).

implements(Key) :-
    citation(Key, _).

test(every_canonical_key_is_recorded) :-
    implements(eu_reg_2016_679_art_77_1),
    implements(eu_reg_2016_679_art_78_1),
    implements(eu_reg_2016_679_art_78_2),
    implements(eu_reg_2016_679_art_79_1),
    implements(eu_reg_2016_679_art_79_2),
    implements(competence_statement).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(gdpr_art_77).
