% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_33_1, [label - 'Regulation (EU) 2016/679 Art 33(1) (notification of a personal data breach to the supervisory authority; 72 hours; reasons for the delay)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'In the case of a personal data breach, the controller shall without undue delay and, where feasible, not later than 72 hours after having become aware of it, notify the personal data breach to the supervisory authority competent in accordance with Article 55, unless the personal data breach is unlikely to result in a risk to the rights and freedoms of natural persons. Where the notification to the supervisory authority is not made within 72 hours, it shall be accompanied by reasons for the delay.']).
citation(eu_reg_2016_679_art_33_2, [label - 'Regulation (EU) 2016/679 Art 33(2) (processor notifies the controller)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The processor shall notify the controller without undue delay after becoming aware of a personal data breach.']).
citation(eu_reg_2016_679_art_33_3, [label - 'Regulation (EU) 2016/679 Art 33(3) opening words (minimum content of the notification)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The notification referred to in paragraph 1 shall at least:']).
citation(eu_reg_2016_679_art_33_3_a, [label - 'Regulation (EU) 2016/679 Art 33(3)(a) (nature of the breach; categories and approximate numbers where possible)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'describe the nature of the personal data breach including where possible, the categories and approximate number of data subjects concerned and the categories and approximate number of personal data records concerned']).
citation(eu_reg_2016_679_art_33_3_b, [label - 'Regulation (EU) 2016/679 Art 33(3)(b) (data protection officer or other contact point)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'communicate the name and contact details of the data protection officer or other contact point where more information can be obtained']).
citation(eu_reg_2016_679_art_33_3_c, [label - 'Regulation (EU) 2016/679 Art 33(3)(c) (likely consequences of the breach)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'describe the likely consequences of the personal data breach']).
citation(eu_reg_2016_679_art_33_3_d, [label - 'Regulation (EU) 2016/679 Art 33(3)(d) (measures taken or proposed; mitigation where appropriate)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'describe the measures taken or proposed to be taken by the controller to address the personal data breach, including, where appropriate, measures to mitigate its possible adverse effects']).
citation(eu_reg_2016_679_art_33_4, [label - 'Regulation (EU) 2016/679 Art 33(4) (information provided in phases)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Where, and in so far as, it is not possible to provide the information at the same time, the information may be provided in phases without undue further delay.']).
citation(eu_reg_2016_679_art_33_5, [label - 'Regulation (EU) 2016/679 Art 33(5) (documentation of every personal data breach)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller shall document any personal data breaches, comprising the facts relating to the personal data breach, its effects and the remedial action taken. That documentation shall enable the supervisory authority to verify compliance with this Article.']).
citation(eu_reg_2016_679_art_34_1, [label - 'Regulation (EU) 2016/679 Art 34(1) (communication to the data subject where a high risk is likely)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'When the personal data breach is likely to result in a high risk to the rights and freedoms of natural persons, the controller shall communicate the personal data breach to the data subject without undue delay.']).
citation(eu_reg_2016_679_art_34_2, [label - 'Regulation (EU) 2016/679 Art 34(2) (content of the communication; clear and plain language)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The communication to the data subject referred to in paragraph 1 of this Article shall describe in clear and plain language the nature of the personal data breach and contain at least the information and measures referred to in points (b), (c) and (d) of Article 33(3).']).
citation(eu_reg_2016_679_art_34_3, [label - 'Regulation (EU) 2016/679 Art 34(3) opening words (conditions under which the communication is not required)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The communication to the data subject referred to in paragraph 1 shall not be required if any of the following conditions are met:']).
citation(eu_reg_2016_679_art_34_3_a, [label - 'Regulation (EU) 2016/679 Art 34(3)(a) (protection measures applied to the affected data, such as encryption)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the controller has implemented appropriate technical and organisational protection measures, and those measures were applied to the personal data affected by the personal data breach, in particular those that render the personal data unintelligible to any person who is not authorised to access it, such as encryption']).
citation(eu_reg_2016_679_art_34_3_b, [label - 'Regulation (EU) 2016/679 Art 34(3)(b) (subsequent measures: high risk no longer likely to materialise)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'the controller has taken subsequent measures which ensure that the high risk to the rights and freedoms of data subjects referred to in paragraph 1 is no longer likely to materialise']).
citation(eu_reg_2016_679_art_34_3_c, [label - 'Regulation (EU) 2016/679 Art 34(3)(c) (disproportionate effort; public communication or similar measure instead)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'it would involve disproportionate effort. In such a case, there shall instead be a public communication or similar measure whereby the data subjects are informed in an equally effective manner.']).
citation(eu_reg_2016_679_art_34_4, [label - 'Regulation (EU) 2016/679 Art 34(4) (decision of the supervisory authority on the communication)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'If the controller has not already communicated the personal data breach to the data subject, the supervisory authority, having considered the likelihood of the personal data breach resulting in a high risk, may require it to do so or may decide that any of the conditions referred to in paragraph 3 are met.']).
citation(eu_reg_1971_1182_art_3_1, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(1) first subparagraph (the hour of the event is not counted in a period in hours)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'Where a period expressed in hours is to be calculated from the moment at which an event occurs or an action takes place, the hour during which that event occurs or that action takes place shall not be considered as falling within the period in question.']).
citation(eu_reg_1971_1182_art_3_2, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2) opening words', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'Subject to the provisions of paragraphs 1 and 4:']).
citation(eu_reg_1971_1182_art_3_2_a, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2)(a) (start and end of a period expressed in hours)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'a period expressed in hours shall start at the beginning of the first hour and shall end with the expiry of the last hour of the period']).
citation(eu_reg_1971_1182_art_3_3, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(3) (periods include public holidays, Sundays and Saturdays)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'The periods concerned shall include public holidays, Sundays and Saturdays, save where these are expressly excepted or where the periods are expressed in working days.']).
citation(eu_reg_1971_1182_art_3_4, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(4) (shift past a non-working last day; periods not expressed in hours only)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'Where the last day of a period expressed otherwise than in hours is a public holiday, Sunday or Saturday, the period shall end with the expiry of the last hour of the following working day. This provision shall not apply to periods calculated retroactively from a given date or event.']).
citation(eu_reg_1971_1182_art_3_5, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(5) (two working days; deferred, reading (13))', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'Any period of two days or more shall include at least two working days.']).
citation(eu_reg_1971_1182_art_1, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 1 (scope: acts of the Council or Commission; deferred, Art 3 applied by analogy)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:31971R1182', verbatim - 'Save as otherwise provided, this Regulation shall apply to acts of the Council or Commission which have been or will be passed pursuant to the Treaty establishing the European Economic Community or the Treaty establishing the European Atomic Energy Community.']).

test(every_answer_key_is_recorded) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_2016_679_art_33_2),
    implements(eu_reg_2016_679_art_33_3_a),
    implements(eu_reg_2016_679_art_33_3_d),
    implements(eu_reg_2016_679_art_33_4),
    implements(eu_reg_2016_679_art_33_5),
    implements(eu_reg_2016_679_art_34_1),
    implements(eu_reg_2016_679_art_34_2),
    implements(eu_reg_2016_679_art_34_3_a),
    implements(eu_reg_2016_679_art_34_3_b),
    implements(eu_reg_2016_679_art_34_3_c),
    implements(eu_reg_2016_679_art_34_4).
test(every_marker_key_is_recorded) :-
    implements(eu_reg_2016_679_art_33_3),
    implements(eu_reg_2016_679_art_33_3_b),
    implements(eu_reg_2016_679_art_33_3_c),
    implements(eu_reg_2016_679_art_34_3),
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2),
    implements(eu_reg_1971_1182_art_3_2_a),
    implements(eu_reg_1971_1182_art_3_3),
    implements(eu_reg_1971_1182_art_3_4).

test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_todo_primary_source).
