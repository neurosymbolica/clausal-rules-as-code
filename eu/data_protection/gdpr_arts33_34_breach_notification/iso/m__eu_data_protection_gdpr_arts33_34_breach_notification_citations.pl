% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_2016_679_art_33_1, [label - 'Regulation (EU) 2016/679 Art 33(1)', ref - 'CELEX 02016R0679-20160504, unit parag_033.001', verbatim - 'the controller shall without undue delay and, where feasible, not later than 72 hours after having become aware of it, notify the personal data breach to the supervisory authority competent in accordance with Article 55, unless the personal data breach is unlikely to result in a risk to the rights and freedoms of natural persons']).
citation(eu_reg_2016_679_art_33_2, [label - 'Regulation (EU) 2016/679 Art 33(2)', ref - 'CELEX 02016R0679-20160504, unit parag_033.002', verbatim - 'The processor shall notify the controller without undue delay after becoming aware of a personal data breach']).
citation(eu_reg_2016_679_art_33_3, [label - 'Regulation (EU) 2016/679 Art 33(3)', ref - 'CELEX 02016R0679-20160504, unit parag_033.003', verbatim - 'The notification referred to in paragraph 1 shall at least']).
citation(eu_reg_2016_679_art_33_3_a, [label - 'Regulation (EU) 2016/679 Art 33(3)(a)', ref - 'CELEX 02016R0679-20160504, unit parag_033.003, point (a)', verbatim - 'describe the nature of the personal data breach including where possible']).
citation(eu_reg_2016_679_art_33_3_b, [label - 'Regulation (EU) 2016/679 Art 33(3)(b)', ref - 'CELEX 02016R0679-20160504, unit parag_033.003, point (b)', verbatim - 'communicate the name and contact details of the data protection officer or other contact point where more information can be obtained']).
citation(eu_reg_2016_679_art_33_3_c, [label - 'Regulation (EU) 2016/679 Art 33(3)(c)', ref - 'CELEX 02016R0679-20160504, unit parag_033.003, point (c)', verbatim - 'describe the likely consequences of the personal data breach']).
citation(eu_reg_2016_679_art_33_3_d, [label - 'Regulation (EU) 2016/679 Art 33(3)(d)', ref - 'CELEX 02016R0679-20160504, unit parag_033.003, point (d)', verbatim - 'describe the measures taken or proposed to be taken by the controller to address the personal data breach, including, where appropriate, measures to mitigate its possible adverse effects']).
citation(eu_reg_2016_679_art_33_4, [label - 'Regulation (EU) 2016/679 Art 33(4)', ref - 'CELEX 02016R0679-20160504, unit parag_033.004', verbatim - 'it is not possible to provide the information at the same time, the information may be provided in phases without undue further delay']).
citation(eu_reg_2016_679_art_33_5, [label - 'Regulation (EU) 2016/679 Art 33(5)', ref - 'CELEX 02016R0679-20160504, unit parag_033.005', verbatim - 'The controller shall document any personal data breaches, comprising the facts relating to the personal data breach, its effects and the remedial action taken']).
citation(eu_reg_2016_679_art_34_1, [label - 'Regulation (EU) 2016/679 Art 34(1)', ref - 'CELEX 02016R0679-20160504, unit parag_034.001', verbatim - 'When the personal data breach is likely to result in a high risk to the rights and freedoms of natural persons, the controller shall communicate the personal data breach to the data subject without undue delay']).
citation(eu_reg_2016_679_art_34_2, [label - 'Regulation (EU) 2016/679 Art 34(2)', ref - 'CELEX 02016R0679-20160504, unit parag_034.002', verbatim - 'shall describe in clear and plain language the nature of the personal data breach']).
citation(eu_reg_2016_679_art_34_3, [label - 'Regulation (EU) 2016/679 Art 34(3)', ref - 'CELEX 02016R0679-20160504, unit parag_034.003', verbatim - 'shall not be required if any of the following conditions are met']).
citation(eu_reg_2016_679_art_34_3_a, [label - 'Regulation (EU) 2016/679 Art 34(3)(a)', ref - 'CELEX 02016R0679-20160504, unit point_034.003_a', verbatim - 'the controller has implemented appropriate technical and organisational protection measures, and those measures were applied to the personal data affected by the personal data breach']).
citation(eu_reg_2016_679_art_34_3_b, [label - 'Regulation (EU) 2016/679 Art 34(3)(b)', ref - 'CELEX 02016R0679-20160504, unit point_034.003_b', verbatim - 'the controller has taken subsequent measures which ensure that the high risk to the rights and freedoms of data subjects referred to in paragraph 1 is no longer likely to materialise']).
citation(eu_reg_2016_679_art_34_3_c, [label - 'Regulation (EU) 2016/679 Art 34(3)(c)', ref - 'CELEX 02016R0679-20160504, unit point_034.003_c', verbatim - 'there shall instead be a public communication or similar measure whereby the data subjects are informed in an equally effective manner']).
citation(eu_reg_2016_679_art_34_4, [label - 'Regulation (EU) 2016/679 Art 34(4)', ref - 'CELEX 02016R0679-20160504, unit parag_034.004', verbatim - 'may require it to do so or may decide that any of the conditions referred to in paragraph 3 are met']).
citation(eu_reg_1971_1182_art_3_1, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(1) first subparagraph', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, Art 3(1)', verbatim - 'Where a period expressed in hours is to be calculated from the moment at which an event occurs or an action takes place, the hour during which that event occurs or that action takes place shall not be considered as falling within the period in question']).
citation(eu_reg_1971_1182_art_3_2, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2) opening words', ref - 'CELEX 31971R1182, unit parag_003.002', verbatim - 'Subject to the provisions of paragraphs 1 and 4']).
citation(eu_reg_1971_1182_art_3_2_a, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2)(a)', ref - 'CELEX 31971R1182, unit point_003.002_a', verbatim - 'a period expressed in hours shall start at the beginning of the first hour and shall end with the expiry of the last hour of the period']).
citation(eu_reg_1971_1182_art_3_3, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(3)', ref - 'CELEX 31971R1182, unit parag_003.003', verbatim - 'The periods concerned shall include public holidays, Sundays and Saturdays']).
citation(eu_reg_1971_1182_art_3_4, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(4)', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, Art 3(4)', verbatim - 'Where the last day of a period expressed otherwise than in hours is a public holiday, Sunday or Saturday, the period shall end with the expiry of the last hour of the following working day']).

test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_33_1).
test(a_calendar_key_is_implemented) :-
    implements(eu_reg_1971_1182_art_3_2_a).
test(each_key_is_recorded_once) :-
    findall(Key, citation(Key, _), Keys),
    sort(Keys, DistinctKeys),
    length(Keys, Count),
    length(DistinctKeys, Count).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_33).
