% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_citations, [citation/2, implements/1, limb_citation/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_13_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 13(1) chapeau, information at the time when personal data are obtained', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_013.001)', verbatim - 'Where personal data relating to a data subject are collected from the data subject, the controller shall, at the time when personal data are obtained, provide the data subject with all of the following information:']).
citation(eu_reg_2016_679_art_14_3_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(a), within a reasonable period and at the latest within one month', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_014.003_a)', verbatim - 'within a reasonable period after obtaining the personal data, but at the latest within one month, having regard to the specific circumstances in which the personal data are processed']).
citation(eu_reg_2016_679_art_14_3_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(b), at the latest at the first communication to the data subject', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_014.003_b)', verbatim - 'if the personal data are to be used for communication with the data subject, at the latest at the time of the first communication to that data subject']).
citation(eu_reg_2016_679_art_14_3_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(3)(c), at the latest when the personal data are first disclosed to another recipient', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_014.003_c)', verbatim - 'if a disclosure to another recipient is envisaged, at the latest when the personal data are first disclosed']).
citation(eu_reg_2016_679_art_14_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 14(1) chapeau, personal data not obtained from the data subject (route; deferred set)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_014.001)']).
citation(eu_reg_2016_679_art_4_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 4(1) definition of personal data and of data subject', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_1)', verbatim - 'any information relating to an identified or identifiable natural person (data subject)']).
citation(eu_reg_2016_679_art_4_7, [label - 'Regulation (EU) 2016/679 (GDPR) Art 4(7) definition of controller', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_7)', verbatim - 'the natural or legal person, public authority, agency or other body which, alone or jointly with others, determines the purposes and means of the processing of personal data']).
citation(eu_reg_2016_679_art_4_9, [label - 'Regulation (EU) 2016/679 (GDPR) Art 4(9) definition of recipient', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#point_004_9)', verbatim - 'public authorities which may receive personal data in the framework of a particular inquiry in accordance with Union or Member State law shall not be regarded as recipients']).
citation(eu_reg_1971_1182_art_3, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3, periods (umbrella of the calendar rule applied to the GDPR by the PERIODS order)', ref - 'http://publications.europa.eu/resource/celex/31971R1182.ENG.fmx4 (CELEX 31971R1182, OJ L 124, 8.6.1971, Article 3)', verbatim - 'the day during which that event occurs or that action takes place shall not be considered as falling within the period in question']).
citation(eu_reg_1971_1182_art_3_1, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(1) second subparagraph, the day of the event is not counted', ref - 'http://publications.europa.eu/resource/celex/31971R1182.ENG.fmx4 (unit 31971R1182#parag_003.001)', verbatim - 'Where a period expressed in days, weeks, months or years is to be calculated from the moment at which an event occurs or an action takes place, the day during which that event occurs or that action takes place shall not be considered as falling within the period in question.']).
citation(eu_reg_1971_1182_art_3_2_c, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(2)(c), end of a period expressed in months', ref - 'http://publications.europa.eu/resource/celex/31971R1182.ENG.fmx4 (unit 31971R1182#point_003.002_c)', verbatim - 'a period expressed in weeks, months or years shall start at the beginning of the first hour of the first day of the period, and shall end with the expiry of the last hour of whichever day in the last week, month or year is the same day of the week, or falls on the same date, as the day from which the period runs. If, in a period expressed in months or in years, the day on which it should expire does not occur in the last month, the period shall end with the expiry of the last hour of the last day of that month']).
citation(eu_reg_1971_1182_art_3_4, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 3(4), a last day on a public holiday, Sunday or Saturday moves to the following working day', ref - 'http://publications.europa.eu/resource/celex/31971R1182.ENG.fmx4 (unit 31971R1182#parag_003.004)', verbatim - 'Where the last day of a period expressed otherwise than in hours is a public holiday, Sunday or Saturday, the period shall end with the expiry of the last hour of the following working day.']).
citation(eu_reg_1971_1182_art_2_2, [label - 'Regulation (EEC, Euratom) No 1182/71 Art 2(2) definition of working days', ref - 'http://publications.europa.eu/resource/celex/31971R1182.ENG.fmx4 (unit 31971R1182#parag_002.002)', verbatim - 'all days other than public holidays, Sundays and Saturdays']).
citation(public_holidays_applicable_to_the_period, [label - 'Public holidays applicable to the period under Regulation (EEC, Euratom) No 1182/71 Art 3(4) (outside fact public_holidays; no fetcher)', ref - 'Regulation (EEC, Euratom) No 1182/71 Art 2(1); Commission annual Official Journal C-series notice of public holidays']).

implements(Key) :-
    citation(Key, _).

limb_citation(art13_1, cite(eu_reg_2016_679_art_13_1)).
limb_citation(art14_3_a, cite(eu_reg_2016_679_art_14_3_a)).
limb_citation(art14_3_b, cite(eu_reg_2016_679_art_14_3_b)).
limb_citation(art14_3_c, cite(eu_reg_2016_679_art_14_3_c)).

test(every_limb_has_a_recorded_citation) :-
    findall(Key, (limb_citation(_, cite(Key)), implements(Key)), Keys),
    length(Keys, 4).
test(the_holiday_referral_key_is_recorded) :-
    implements(eu_reg_1971_1182_art_3_4).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_14_3).
