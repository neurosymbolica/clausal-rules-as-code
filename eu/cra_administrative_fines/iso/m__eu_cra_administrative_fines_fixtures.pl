% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_subject/1, cra_administrative_fines_profile_for/2, cra_administrative_fines_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [decide_cra_administrative_fines/2]).

fixture_request(day_before_application_highest_tier, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2027, 12, 10)).
fixture_request(application_day_highest_tier, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2027, 12, 11)).
fixture_request(earlier_obligation_date_middle_tier, [attribute(infringed_provision, article_39), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2026, 7, 1)).
fixture_request(application_day_middle_tier, [attribute(infringed_provision, article_39), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2027, 12, 11)).
fixture_request(provision_absent, [], date(2028, 1, 1)).
fixture_request(unlisted_provision, [attribute(infringed_provision, other_provision)], date(2028, 1, 1)).
fixture_request(listed_provision_middle_tier, [attribute(infringed_provision, article_53), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(steward_middle_tier, [attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1)).
fixture_request(non_steward_middle_tier, [attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(steward_lowest_tier, [attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1)).
fixture_request(non_steward_lowest_tier, [attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(steward_highest_tier_not_read, [attribute(infringed_provision, article_13), attribute(offender_is_open_source_software_steward, true), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(steward_absent_middle_tier, [attribute(infringed_provision, article_18), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1)], date(2028, 1, 1)).
fixture_request(steward_absent_highest_tier, [attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1)], date(2028, 1, 1)).
fixture_request(undertaking_absent_middle_tier, [attribute(infringed_provision, article_18), attribute(offender_is_open_source_software_steward, false)], date(2028, 1, 1)).
fixture_request(turnover_absent_undertaking, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true)], date(2028, 1, 1)).
fixture_request(turnover_absent_unsure_undertaking, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, unsure)], date(2028, 1, 1)).
fixture_request(turnover_absent_non_undertaking, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(unsure_steward_referral, [attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, false)], date(2028, 1, 1)).
fixture_request(unsure_steward_and_undertaking_referral, [attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)], date(2028, 1, 1)).
fixture_request(unsure_undertaking_highest_tier, [attribute(infringed_provision, annex_i_essential_cybersecurity_requirements), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 5)], date(2028, 1, 1)).
fixture_request(unsure_undertaking_middle_tier, [attribute(infringed_provision, article_19), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 5)], date(2028, 1, 1)).
fixture_request(unsure_undertaking_lowest_tier, [attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 0)], date(2028, 1, 1)).
fixture_request(highest_tier_one_euro_below_tie, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 599999999)], date(2028, 1, 1)).
fixture_request(highest_tier_tie, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000000)], date(2028, 1, 1)).
fixture_request(highest_tier_one_euro_above_tie, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000001)], date(2028, 1, 1)).
fixture_request(highest_tier_two_euros_above_tie, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000002)], date(2028, 1, 1)).
fixture_request(middle_tier_tie, [attribute(infringed_provision, article_21), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], date(2028, 1, 1)).
fixture_request(middle_tier_one_euro_above_tie, [attribute(infringed_provision, article_21), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)], date(2028, 1, 1)).
fixture_request(lowest_tier_tie, [attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], date(2028, 1, 1)).
fixture_request(lowest_tier_one_euro_above_tie, [attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)], date(2028, 1, 1)).
fixture_request(leap_day_2028, [attribute(infringed_provision, other_provision)], date(2028, 2, 29)).
fixture_request(non_leap_day_2027, [attribute(infringed_provision, other_provision)], date(2027, 2, 29)).
fixture_request(float_turnover, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, FloatTurnover)], date(2028, 1, 1)) :-
    FloatTurnover is float(600000000).
fixture_request(negative_turnover, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, -1)], date(2028, 1, 1)).
fixture_request(duplicate_undertaking_key, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000000)], date(2028, 1, 1)).
fixture_request(unknown_profile_key, [attribute(infringed_provision, article_14), attribute(offender_is_undertaking, false), attribute(colour, red)], date(2028, 1, 1)).
fixture_request(provision_outside_closed_list, [attribute(infringed_provision, article_99)], date(2028, 1, 1)).
fixture_request(not_a_profile_nor_a_date, colour, tomorrow).

cra_administrative_fines_subject(Subject) :-
    fixture_request(Subject, _, _).

cra_administrative_fines_profile_for(Subject, infringement(Profile, InfringementDate)) :-
    fixture_request(Subject, Profile, InfringementDate).

cra_administrative_fines_assess(Subject, Result) :-
    cra_administrative_fines_profile_for(Subject, Request),
    decide_cra_administrative_fines(Request, Result).

test(each_subject_is_registered_once) :-
    findall(Subject, cra_administrative_fines_subject(Subject), Subjects),
    length(Subjects, Count),
    sort(Subjects, DistinctSubjects),
    length(DistinctSubjects, Count).
test(each_subject_has_one_request) :-
    findall(Request, cra_administrative_fines_profile_for(highest_tier_tie, Request), Requests),
    length(Requests, 1).
