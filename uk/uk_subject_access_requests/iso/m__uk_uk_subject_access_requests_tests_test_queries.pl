% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_queries, [uk_subject_access_requests_profile_keys/1, uk_subject_access_requests_what_if/4]).
:- use_module(m__uk_uk_subject_access_requests_kernel, [uk_subject_access_requests_input_problems/2]).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [uk_subject_access_requests_status/2, uk_subject_access_requests_checklist/2, uk_access_entitlement/3, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    uk_subject_access_requests_profile_keys(ProfileKeys),
    ProfileKeys == [item_described_in_article_15_1, item_within_reasonable_and_proportionate_search, extension_notice_given, extension_notice_given_before_end_of_first_month, extension_notice_states_reasons, extension_necessary_for_complexity_or_number, request_made_under_article_15, controller_asked_for_further_information, further_information_reasonably_required].
test(query_2_status) :-
    uk_subject_access_requests_profile_for(access_not_described, Profile),
    findall(Status, uk_subject_access_requests_status(Profile, Status), Statuses),
    Statuses == [item_not_within_article_15_1].
test(query_3_status_determination) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    findall(Result, uk_access_entitlement(Profile, Result, _Citations), Results),
    Results == [item_due].
test(query_5_comparison) :-
    findall(Difference, compare_uk_eu_response_deadline(date(2026, 11, 30), three_months, _UkDeadline, _EuDeadline, Difference, _Citations), Differences),
    Differences == [uk_earlier].
test(query_7_justification_rows_cite) :-
    uk_subject_access_requests_profile_for(clock_stop_applies, Profile),
    uk_subject_access_requests_checklist(Profile, Items),
    length(Items, 9),
    findall(Key, member(item(Key, _Status, cite(_CitationKey)), Items), CitedKeys),
    uk_subject_access_requests_profile_keys(ProfileKeys),
    CitedKeys == ProfileKeys.
test(query_7_justification_row_status) :-
    uk_subject_access_requests_profile_for(clock_stop_applies, Profile),
    uk_subject_access_requests_checklist(Profile, Items),
    member(item(request_made_under_article_15, met, cite(uk_gdpr_art_12a_5)), Items),
    member(item(item_described_in_article_15_1, unknown([item_described_in_article_15_1]), cite(uk_gdpr_art_15_1)), Items).
test(query_15_deadline) :-
    findall(Deadline, uk_response_deadline(date(2027, 1, 31), one_month, 0, Deadline, _Citations), Deadlines),
    Deadlines == [date(2027, 2, 28)].
test(query_23_calculation) :-
    findall(Days, uk_paused_days(date(2026, 2, 27), date(2026, 3, 2), Days, _Citations), DayCounts),
    DayCounts == [4].
test(what_if_search_false_to_true_flips_to_due) :-
    uk_subject_access_requests_profile_for(access_search_false, Profile),
    uk_subject_access_requests_what_if(Profile, item_within_reasonable_and_proportionate_search, true, Status),
    Status == item_due.
test(what_if_search_true_to_unsure_refers) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    uk_subject_access_requests_what_if(Profile, item_within_reasonable_and_proportionate_search, unsure, Status),
    Status = needs_legal_review(open_textured(item_within_reasonable_and_proportionate_search, cite(uk_gdpr_art_15_1a)), _Context).
test(what_if_described_false_overrides_search) :-
    uk_subject_access_requests_profile_for(access_search_unsure, Profile),
    uk_subject_access_requests_what_if(Profile, item_described_in_article_15_1, false, Status),
    Status == item_not_within_article_15_1.
test(what_if_bad_value_is_reported) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    uk_subject_access_requests_what_if(Profile, item_described_in_article_15_1, unsure, Status),
    Status == input_problems([wrong_type(item_described_in_article_15_1)]).
test(what_if_unchanged_value_keeps_status) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    findall(Status, uk_subject_access_requests_what_if(Profile, item_described_in_article_15_1, true, Status), Statuses),
    Statuses == [item_due].
test(input_problems_clean_profile) :-
    uk_subject_access_requests_profile_for(period_three_months, Profile),
    uk_subject_access_requests_input_problems(Profile, Problems),
    Problems == [].
test(input_problems_dirty_profile) :-
    uk_subject_access_requests_profile_for(access_duplicate_key, Profile),
    uk_subject_access_requests_input_problems(Profile, Problems),
    Problems == [duplicate_key(item_described_in_article_15_1)].

cp_test_names([profile_keys_are_the_contract_keys, query_2_status, query_3_status_determination, query_5_comparison, query_7_justification_rows_cite, query_7_justification_row_status, query_15_deadline, query_23_calculation, what_if_search_false_to_true_flips_to_due, what_if_search_true_to_unsure_refers, what_if_described_false_overrides_search, what_if_bad_value_is_reported, what_if_unchanged_value_keeps_status, input_problems_clean_profile, input_problems_dirty_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
