% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_queries, [swiss_fadp_s4_criminal_provisions_profile_keys/1, swiss_fadp_s4_criminal_provisions_what_if/4, swiss_fadp_s4_criminal_provisions_business_threshold/1, swiss_prosecution_limitation_last_day/2, conduct_meets_offence_description/0, acted_wilfully/0, examined_offence/0, offender_is_private_person/0, criminal_complaint_filed/0, offence_committed_in_business/0, fine_in_consideration_in_francs/0, identifying_punishable_persons_requires_disproportionate_investigation/0, eu_infringement_established/0, eu_infringed_obligation_listed_in/0, article_60_1_a/0, article_60_1_b_1/0, article_60_1_b_2/0, article_60_2/0, article_61_a/0, article_61_b/0, article_61_c/0, article_62_1/0, article_62_2/0, article_63/0, listed_in_article_83_4/0, listed_in_article_83_5_or_83_6/0, not_listed_in_article_83_4_to_83_6/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_citations, [implements/1]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [swiss_fadp_s4_criminal_provisions_status/2, swiss_business_ordered_to_pay_fine/3, swiss_prosecution_limitation/5]).

conduct_meets_offence_description.

acted_wilfully.

examined_offence.

offender_is_private_person.

criminal_complaint_filed.

offence_committed_in_business.

fine_in_consideration_in_francs.

identifying_punishable_persons_requires_disproportionate_investigation.

eu_infringement_established.

eu_infringed_obligation_listed_in.

article_60_1_a.

article_60_1_b_1.

article_60_1_b_2.

article_60_2.

article_61_a.

article_61_b.

article_61_c.

article_62_1.

article_62_2.

article_63.

listed_in_article_83_4.

listed_in_article_83_5_or_83_6.

not_listed_in_article_83_4_to_83_6.

unsure.

swiss_fadp_s4_criminal_provisions_profile_keys([conduct_meets_offence_description, acted_wilfully, examined_offence, offender_is_private_person, criminal_complaint_filed, offence_committed_in_business, fine_in_consideration_in_francs, identifying_punishable_persons_requires_disproportionate_investigation, eu_infringement_established, eu_infringed_obligation_listed_in]).

swiss_fadp_s4_criminal_provisions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_fadp_s4_criminal_provisions_status(Hypothesis, NewStatus).

attribute_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_override([Element|Elements], OverriddenKey, NewValue, [Element|Rest]) :-
    var(Element),
    attribute_override(Elements, OverriddenKey, NewValue, Rest).
attribute_override([Element|Elements], OverriddenKey, NewValue, [Element|Rest]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    attribute_override(Elements, OverriddenKey, NewValue, Rest).
attribute_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Rest).
attribute_override([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Rest) :-
    ElementKey == OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Rest).

swiss_fadp_s4_criminal_provisions_business_threshold(threshold(fine_in_consideration_in_francs, MaximumFrancs, cite(ch_fadp_art_64_2))) :-
    implements(ch_fadp_art_64_2),
    business_answer_at(0, business_may_be_ordered_to_pay_fine),
    business_gallop(0, 1, MaximumFrancs).

business_answer_at(Francs, Answer) :-
    implements(ch_fadp_art_64_2),
    swiss_business_ordered_to_pay_fine([attribute(offence_committed_in_business, true), attribute(fine_in_consideration_in_francs, Francs), attribute(identifying_punishable_persons_requires_disproportionate_investigation, true)], Answer, _).

business_gallop(LowFrancs, HighFrancs, MaximumFrancs) :-
    business_answer_at(HighFrancs, Answer),
    business_gallop_step(Answer, LowFrancs, HighFrancs, MaximumFrancs).

business_gallop_step(business_may_be_ordered_to_pay_fine, _, HighFrancs, MaximumFrancs) :-
    NextHighFrancs #= HighFrancs * 2,
    business_gallop(HighFrancs, NextHighFrancs, MaximumFrancs).
business_gallop_step(business_substitution_not_available, LowFrancs, HighFrancs, MaximumFrancs) :-
    business_bisect(LowFrancs, HighFrancs, MaximumFrancs).

business_bisect(LowFrancs, HighFrancs, LowFrancs) :-
    HighFrancs - LowFrancs #= 1.
business_bisect(LowFrancs, HighFrancs, MaximumFrancs) :-
    HighFrancs - LowFrancs #> 1,
    MiddleFrancs #= (LowFrancs + HighFrancs) // 2,
    business_answer_at(MiddleFrancs, Answer),
    business_bisect_step(Answer, LowFrancs, MiddleFrancs, HighFrancs, MaximumFrancs).

business_bisect_step(business_may_be_ordered_to_pay_fine, _, MiddleFrancs, HighFrancs, MaximumFrancs) :-
    business_bisect(MiddleFrancs, HighFrancs, MaximumFrancs).
business_bisect_step(business_substitution_not_available, LowFrancs, MiddleFrancs, _, MaximumFrancs) :-
    business_bisect(LowFrancs, MiddleFrancs, MaximumFrancs).

swiss_prosecution_limitation_last_day(date(OffenceYear, OffenceMonth, OffenceDay), LastDay) :-
    implements(ch_fadp_art_66),
    integer(OffenceYear),
    integer(OffenceMonth),
    integer(OffenceDay),
    HorizonYear #= OffenceYear + 10,
    between(OffenceYear, HorizonYear, CandidateYear),
    month_last_day(CandidateYear, OffenceMonth, MonthLastDay),
    between(1, MonthLastDay, CandidateDay),
    LastDay = date(CandidateYear, OffenceMonth, CandidateDay),
    swiss_prosecution_limitation([], date(OffenceYear, OffenceMonth, OffenceDay), LastDay, five_year_limitation_period_not_expired, _),
    following_day(LastDay, NextDay),
    swiss_prosecution_limitation([], date(OffenceYear, OffenceMonth, OffenceDay), NextDay, five_year_limitation_period_expired, _).

following_day(date(DateYear, DateMonth, DayOfMonth), date(DateYear, DateMonth, NextDayOfMonth)) :-
    month_last_day(DateYear, DateMonth, MonthLastDay),
    DayOfMonth #< MonthLastDay,
    NextDayOfMonth #= DayOfMonth + 1.
following_day(date(DateYear, DateMonth, DayOfMonth), date(DateYear, NextMonth, 1)) :-
    month_last_day(DateYear, DateMonth, MonthLastDay),
    DayOfMonth #= MonthLastDay,
    DateMonth #< 12,
    NextMonth #= DateMonth + 1.
following_day(date(DateYear, 12, 31), date(NextYear, 1, 1)) :-
    NextYear #= DateYear + 1.

test(business_threshold_is_fifty_thousand_francs_inclusive) :-
    swiss_fadp_s4_criminal_provisions_business_threshold(threshold(fine_in_consideration_in_francs, MaximumFrancs, cite(ch_fadp_art_64_2))),
    MaximumFrancs =:= 50000.
test(last_day_is_the_fifth_anniversary) :-
    swiss_prosecution_limitation_last_day(date(2020, 3, 15), LastDay),
    LastDay == date(2025, 3, 15).
test(last_day_of_a_leap_day_offence_is_28_february) :-
    findall(LastDay, swiss_prosecution_limitation_last_day(date(2024, 2, 29), LastDay), LastDays),
    LastDays == [date(2029, 2, 28)].
test(what_if_wilful_turns_the_status) :-
    swiss_fadp_s4_criminal_provisions_what_if([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, false), attribute(examined_offence, article_63), attribute(offender_is_private_person, true)], acted_wilfully, true, Status),
    Status == punishable_by_fine_under_article_63.
test(root_atoms_are_served) :-
    unsure,
    examined_offence,
    article_62_2,
    listed_in_article_83_5_or_83_6.
