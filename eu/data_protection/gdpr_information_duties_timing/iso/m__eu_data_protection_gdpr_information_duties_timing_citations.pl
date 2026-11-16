% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_13_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 13(1), chapeau (information at the time when personal data are obtained)', ref - 'CELEX 02016R0679-20160504, unit parag_013.001, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Where personal data relating to a data subject are collected from the data subject, the controller shall, at the time when personal data are obtained, provide the data subject with all of the following information:']).
citation(eu_reg_2016_679_art_14_3_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(a) (within a reasonable period, at the latest within one month)', ref - 'CELEX 02016R0679-20160504, unit point_014.003_a, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'within a reasonable period after obtaining the personal data, but at the latest within one month, having regard to the specific circumstances in which the personal data are processed']).
citation(eu_reg_2016_679_art_14_3_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(b) (at the latest at the first communication to the data subject)', ref - 'CELEX 02016R0679-20160504, unit point_014.003_b, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'if the personal data are to be used for communication with the data subject, at the latest at the time of the first communication to that data subject']).
citation(eu_reg_2016_679_art_14_3_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(c) (at the latest when the personal data are first disclosed to another recipient)', ref - 'CELEX 02016R0679-20160504, unit point_014.003_c, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'if a disclosure to another recipient is envisaged, at the latest when the personal data are first disclosed']).
citation(eu_reg_2016_679_art_14_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(1), chapeau (personal data not obtained from the data subject: the Art 14 route)', ref - 'CELEX 02016R0679-20160504, unit parag_014.001, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Where personal data have not been obtained from the data subject']).
citation(eu_reg_2016_679_art_14_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3), chapeau (the limbs (a)-(c) read cumulatively, the earliest applicable date binding; Q1 ruled 2026-11-01)', ref - 'CELEX 02016R0679-20160504, unit parag_014.003, https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller shall provide the information referred to in paragraphs 1 and 2']).
citation(eu_reg_1971_1182_art_3, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3 (periods; the public holidays of Art 3(4), outside fact public_holidays), applied to the GDPR by the G4 order', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, https://publications.europa.eu/resource/celex/31971R1182', verbatim - 'Where the last day of a period expressed otherwise than in hours is a public holiday, Sunday or Saturday, the period shall end with the expiry of the last hour of the following working day.']).
citation(eu_reg_1971_1182_art_3_1, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(1), second subparagraph (the day of the event is not counted)', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, https://publications.europa.eu/resource/celex/31971R1182', verbatim - 'the day during which that event occurs or that action takes place shall not be considered as falling within the period in question.']).
citation(eu_reg_1971_1182_art_3_2_c, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2)(c) (a period in months ends on the same date, else the last day of that month)', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, https://publications.europa.eu/resource/celex/31971R1182', verbatim - 'a period expressed in weeks, months or years shall start at the beginning of the first hour of the first day of the period, and shall end with the expiry of the last hour of whichever day in the last week, month or year is the same day of the week, or falls on the same date, as the day from which the period runs. If, in a period expressed in months or in years, the day on which it should expire does not occur in the last month, the period shall end with the expiry of the last hour of the last day of that month']).
citation(eu_reg_1971_1182_art_3_4, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(4) (a last day on a Saturday, Sunday or public holiday moves to the following working day)', ref - 'CELEX 31971R1182, OJ L 124, 8.6.1971, https://publications.europa.eu/resource/celex/31971R1182', verbatim - 'Where the last day of a period expressed otherwise than in hours is a public holiday, Sunday or Saturday, the period shall end with the expiry of the last hour of the following working day.']).

implements(Key) :-
    citation(Key, _).

test(every_answer_citation_is_recorded) :-
    implements(eu_reg_2016_679_art_13_1),
    implements(eu_reg_2016_679_art_14_3_a),
    implements(eu_reg_2016_679_art_14_3_b),
    implements(eu_reg_2016_679_art_14_3_c).
test(every_period_rule_marker_is_recorded) :-
    implements(eu_reg_1971_1182_art_3),
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2_c),
    implements(eu_reg_1971_1182_art_3_4).
test(every_route_marker_is_recorded) :-
    implements(eu_reg_2016_679_art_14_1),
    implements(eu_reg_2016_679_art_14_3).
test(each_key_has_exactly_one_record) :-
    findall(Key, citation(Key, _), Keys),
    sort(Keys, DistinctKeys),
    length(Keys, Count),
    length(DistinctKeys, DistinctCount),
    Count =:= DistinctCount.

test(the_placeholder_key_is_gone, fail) :-
    implements(eu_todo_primary_source).
test(a_shortened_key_is_not_recorded, fail) :-
    implements(gdpr_art_13_1).
