% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_kernel, [uk_subject_access_requests_input_problems/2]).
:- use_module(m__uk_uk_subject_access_requests_citations, [citation/2, implements/1]).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [article_12a_time_rules/0, clock_stop_applies/0, clock_stop_does_not_apply/0, compare_uk_eu_response_deadline/6, controller_asked_for_further_information/0, decide_uk_subject_access_requests/2, earlier_time_limits_saved/0, extension_necessary_for_complexity_or_number/0, extension_notice_given/0, extension_notice_given_before_end_of_first_month/0, extension_notice_states_reasons/0, fee_not_paid/0, further_information_reasonably_required/0, item_beyond_reasonable_and_proportionate_search/0, item_described_in_article_15_1/0, item_due/0, item_not_within_article_15_1/0, item_within_reasonable_and_proportionate_search/0, no_fee/0, not_comparable/0, not_requested/0, not_yet_started/0, one_month/0, request_made_under_article_15/0, requested_not_received/0, same/0, three_months/0, uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_earlier/0, uk_later/0, uk_paused_days/4, uk_relevant_time/5, uk_response_deadline/5, uk_subject_access_requests_checklist/2, uk_subject_access_requests_decision_resolvable/1, uk_subject_access_requests_status/2, uk_subject_access_requests_status_values/1, uk_time_rules_regime/3, unsure/0]).
:- use_module(m__uk_uk_subject_access_requests_queries, [uk_subject_access_requests_profile_keys/1, uk_subject_access_requests_what_if/4]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_assess/2, uk_subject_access_requests_date_fixture/2, uk_subject_access_requests_profile_for/2, uk_subject_access_requests_subject/1]).

root_export(article_12a_time_rules).
root_export(clock_stop_applies).
root_export(clock_stop_does_not_apply).
root_export(controller_asked_for_further_information).
root_export(duplicate_key).
root_export(earlier_time_limits_saved).
root_export(extension_necessary_for_complexity_or_number).
root_export(extension_notice_given).
root_export(extension_notice_given_before_end_of_first_month).
root_export(extension_notice_states_reasons).
root_export(fee_not_paid).
root_export(further_information_reasonably_required).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(item_beyond_reasonable_and_proportionate_search).
root_export(item_described_in_article_15_1).
root_export(item_due).
root_export(item_not_within_article_15_1).
root_export(item_within_reasonable_and_proportionate_search).
root_export(needs_legal_review).
root_export(no_fee).
root_export(not_comparable).
root_export(not_requested).
root_export(not_yet_started).
root_export(one_month).
root_export(open_textured).
root_export(provenance).
root_export(request_made_under_article_15).
root_export(requested_not_received).
root_export(same).
root_export(three_months).
root_export(uk_earlier).
root_export(uk_later).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
