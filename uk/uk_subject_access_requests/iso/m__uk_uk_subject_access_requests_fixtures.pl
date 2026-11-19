% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_subject/1, uk_subject_access_requests_profile_for/2, uk_subject_access_requests_assess/2, uk_subject_access_requests_date_fixture/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [decide_uk_subject_access_requests/2]).

uk_subject_access_requests_subject(access_item_due).
uk_subject_access_requests_subject(access_search_false).
uk_subject_access_requests_subject(access_not_described).
uk_subject_access_requests_subject(access_described_missing).
uk_subject_access_requests_subject(access_search_missing).
uk_subject_access_requests_subject(access_search_unsure).
uk_subject_access_requests_subject(access_wrong_type).
uk_subject_access_requests_subject(access_duplicate_key).
uk_subject_access_requests_subject(access_unknown_key).
uk_subject_access_requests_subject(period_three_months).
uk_subject_access_requests_subject(period_late_notice).
uk_subject_access_requests_subject(period_no_notice).
uk_subject_access_requests_subject(period_notice_missing).
uk_subject_access_requests_subject(period_reasons_missing).
uk_subject_access_requests_subject(period_necessity_unsure).
uk_subject_access_requests_subject(clock_stop_applies).
uk_subject_access_requests_subject(clock_not_access_request).
uk_subject_access_requests_subject(clock_asked_missing).
uk_subject_access_requests_subject(clock_further_unsure).

uk_subject_access_requests_profile_for(access_item_due, [attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, true)]).
uk_subject_access_requests_profile_for(access_search_false, [attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, false)]).
uk_subject_access_requests_profile_for(access_not_described, [attribute(item_described_in_article_15_1, false), attribute(item_within_reasonable_and_proportionate_search, true)]).
uk_subject_access_requests_profile_for(access_described_missing, [attribute(item_within_reasonable_and_proportionate_search, true)]).
uk_subject_access_requests_profile_for(access_search_missing, [attribute(item_described_in_article_15_1, true)]).
uk_subject_access_requests_profile_for(access_search_unsure, [attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, unsure)]).
uk_subject_access_requests_profile_for(access_wrong_type, [attribute(item_described_in_article_15_1, unsure), attribute(item_within_reasonable_and_proportionate_search, true)]).
uk_subject_access_requests_profile_for(access_duplicate_key, [attribute(item_described_in_article_15_1, true), attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, true)]).
uk_subject_access_requests_profile_for(access_unknown_key, [attribute(item_described_in_article_15_1, true), attribute(item_within_reasonable_and_proportionate_search, true), attribute(subject_name, true)]).
uk_subject_access_requests_profile_for(period_three_months, [attribute(extension_notice_given, true), attribute(extension_notice_given_before_end_of_first_month, true), attribute(extension_notice_states_reasons, true), attribute(extension_necessary_for_complexity_or_number, true)]).
uk_subject_access_requests_profile_for(period_late_notice, [attribute(extension_notice_given, true), attribute(extension_notice_given_before_end_of_first_month, false), attribute(extension_notice_states_reasons, true), attribute(extension_necessary_for_complexity_or_number, true)]).
uk_subject_access_requests_profile_for(period_no_notice, [attribute(extension_notice_given, false)]).
uk_subject_access_requests_profile_for(period_notice_missing, [attribute(extension_notice_given_before_end_of_first_month, true), attribute(extension_notice_states_reasons, true), attribute(extension_necessary_for_complexity_or_number, true)]).
uk_subject_access_requests_profile_for(period_reasons_missing, [attribute(extension_notice_given, true), attribute(extension_notice_given_before_end_of_first_month, true), attribute(extension_necessary_for_complexity_or_number, true)]).
uk_subject_access_requests_profile_for(period_necessity_unsure, [attribute(extension_notice_given, true), attribute(extension_notice_given_before_end_of_first_month, true), attribute(extension_notice_states_reasons, true), attribute(extension_necessary_for_complexity_or_number, unsure)]).
uk_subject_access_requests_profile_for(clock_stop_applies, [attribute(request_made_under_article_15, true), attribute(controller_asked_for_further_information, true), attribute(further_information_reasonably_required, true)]).
uk_subject_access_requests_profile_for(clock_not_access_request, [attribute(request_made_under_article_15, false), attribute(controller_asked_for_further_information, true), attribute(further_information_reasonably_required, true)]).
uk_subject_access_requests_profile_for(clock_asked_missing, [attribute(request_made_under_article_15, true), attribute(further_information_reasonably_required, true)]).
uk_subject_access_requests_profile_for(clock_further_unsure, [attribute(request_made_under_article_15, true), attribute(controller_asked_for_further_information, true), attribute(further_information_reasonably_required, unsure)]).

uk_subject_access_requests_date_fixture(regime_on_commencement_day, regime_case(date(2026, 2, 5))).
uk_subject_access_requests_date_fixture(regime_day_before_commencement, regime_case(date(2026, 2, 4))).
uk_subject_access_requests_date_fixture(regime_impossible_date, regime_case(date(2026, 2, 30))).
uk_subject_access_requests_date_fixture(relevant_plain_request, relevant_time_case(date(2026, 3, 1), not_requested, no_fee)).
uk_subject_access_requests_date_fixture(relevant_identity_received_latest, relevant_time_case(date(2026, 3, 1), date(2026, 3, 10), date(2026, 3, 5))).
uk_subject_access_requests_date_fixture(relevant_identity_outstanding, relevant_time_case(date(2026, 3, 1), requested_not_received, date(2026, 3, 5))).
uk_subject_access_requests_date_fixture(relevant_fee_paid, relevant_time_case(date(2026, 3, 1), not_requested, date(2026, 3, 5))).
uk_subject_access_requests_date_fixture(relevant_fee_outstanding, relevant_time_case(date(2026, 3, 1), not_requested, fee_not_paid)).
uk_subject_access_requests_date_fixture(relevant_argument_problems, relevant_time_case(receipt_unknown, not_requested, unpaid)).
uk_subject_access_requests_date_fixture(paused_same_day, paused_days_case(date(2026, 3, 10), date(2026, 3, 10))).
uk_subject_access_requests_date_fixture(paused_received_day_before_asked, paused_days_case(date(2026, 3, 10), date(2026, 3, 9))).
uk_subject_access_requests_date_fixture(paused_ten_days, paused_days_case(date(2026, 3, 1), date(2026, 3, 10))).
uk_subject_access_requests_date_fixture(deadline_5_february_2026, deadline_case(date(2026, 2, 5), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_1_march_2026, deadline_case(date(2026, 3, 1), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_31_january_2027, deadline_case(date(2027, 1, 31), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_29_january_2028, deadline_case(date(2028, 1, 29), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_30_january_2028, deadline_case(date(2028, 1, 30), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_29_january_2027, deadline_case(date(2027, 1, 29), one_month, 0)).
uk_subject_access_requests_date_fixture(deadline_three_months_30_november_2026, deadline_case(date(2026, 11, 30), three_months, 0)).
uk_subject_access_requests_date_fixture(deadline_paused_three_days, deadline_case(date(2026, 2, 5), one_month, 3)).
uk_subject_access_requests_date_fixture(deadline_wrong_period, deadline_case(date(2026, 2, 5), two_months, 0)).
uk_subject_access_requests_date_fixture(compare_5_february_2026, comparison_case(date(2026, 2, 5), one_month)).
uk_subject_access_requests_date_fixture(compare_30_november_2026_three_months, comparison_case(date(2026, 11, 30), three_months)).
uk_subject_access_requests_date_fixture(compare_31_march_2026_same_day, comparison_case(date(2026, 3, 31), one_month)).
uk_subject_access_requests_date_fixture(compare_saved_receipt, comparison_case(date(2026, 2, 4), one_month)).
uk_subject_access_requests_date_fixture(compare_argument_problem, comparison_case(date(2026, 13, 1), one_month)).

uk_subject_access_requests_assess(Subject, Result) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    decide_uk_subject_access_requests(Profile, Result).
