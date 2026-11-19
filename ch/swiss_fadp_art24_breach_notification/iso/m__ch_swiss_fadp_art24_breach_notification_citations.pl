% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(ch_fadp_art_5_h, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 5 Bst h, definition of Verletzung der Datensicherheit (breach of data security)', ref - 'ch-fadp-sr-235-1-2025-07-07#art_5/para/lbl_h (fedlex consolidation Stand 7 July 2025)', verbatim - 'eine Verletzung der Sicherheit, die dazu f\xFC\hrt, dass Personendaten unbeabsichtigt oder widerrechtlich verlorengehen, gel\xF6\scht, vernichtet oder ver\xE4\ndert werden oder Unbefugten offengelegt oder zug\xE4\nglich gemacht werden']).
citation(ch_fadp_art_24_1, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 1, report of a breach of data security likely to lead to a high risk to the ED\xD6\B', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_1 (fedlex consolidation Stand 7 July 2025)', verbatim - 'Der Verantwortliche meldet dem ED\xD6\B so rasch als m\xF6\glich eine Verletzung der Datensicherheit, die voraussichtlich zu einem hohen Risiko f\xFC\r die Pers\xF6\nlichkeit oder die Grundrechte der betroffenen Person f\xFC\hrt.']).
citation(ch_fadp_art_24_3, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 3, report of a breach of data security by the processor to the controller', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_3 (fedlex consolidation Stand 7 July 2025)', verbatim - 'Der Auftragsbearbeiter meldet dem Verantwortlichen so rasch als m\xF6\glich eine Verletzung der Datensicherheit.']).
citation(ch_fadp_art_24_4, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 4, information of the data subject (necessary for protection or requested by the ED\xD6\B)', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_4 (fedlex consolidation Stand 7 July 2025)', verbatim - 'Der Verantwortliche informiert die betroffene Person, wenn es zu ihrem Schutz erforderlich ist oder der ED\xD6\B es verlangt.']).
citation(ch_fadp_art_24_5, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 5 lead-in, permission to restrict, defer or dispense with the information of the data subject', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_5/listintro (fedlex consolidation Stand 7 July 2025)', verbatim - 'Er kann die Information an die betroffene Person einschr\xE4\nken, aufschieben oder darauf verzichten, wenn:']).
citation(ch_fadp_art_24_5_a, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 5 Bst a, ground under Art 26 Abs 1 Bst b or Abs 2 Bst b or a statutory duty of secrecy', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_5/lbl_a (fedlex consolidation Stand 7 July 2025)', verbatim - 'ein Grund nach Artikel 26 Absatz 1 Buchstabe b oder Absatz 2 Buchstabe b vorliegt oder eine gesetzliche Geheimhaltungspflicht dies verbietet']).
citation(ch_fadp_art_24_5_b, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 5 Bst b, information impossible or requiring disproportionate effort', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_5/lbl_b (fedlex consolidation Stand 7 July 2025)', verbatim - 'die Information unm\xF6\glich ist oder einen unverh\xE4\ltnism\xE4\ssigen Aufwand erfordert']).
citation(ch_fadp_art_24_5_c, [label - 'Bundesgesetz \xFC\ber den Datenschutz (DSG), SR 235.1, Art 24 Abs 5 Bst c, information ensured in a comparable way by a public announcement', ref - 'ch-fadp-sr-235-1-2025-07-07#art_24/para_5/lbl_c (fedlex consolidation Stand 7 July 2025)', verbatim - 'die Information der betroffenen Person durch eine \xF6\ffentliche Bekanntmachung in vergleichbarer Weise sichergestellt ist']).
citation(eu_reg_2016_679_art_33_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 33(1), notification of a personal data breach to the supervisory authority', ref - '02016R0679-20160504#parag_033.001 (Formex consolidation of 2016-05-04, Article 33 extract)', verbatim - 'In the case of a personal data breach, the controller shall without undue delay and, where feasible, not later than 72 hours after having become aware of it, notify the personal data breach to the supervisory authority competent in accordance with Article 55, unless the personal data breach is unlikely to result in a risk to the rights and freedoms of natural persons.']).

implements(Key) :-
    citation(Key, _).

test(a_recorded_key_is_implemented) :-
    implements(ch_fadp_art_24_1).
test(the_eu_key_is_implemented) :-
    implements(eu_reg_2016_679_art_33_1).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(ch_fadp_art_24_2).
