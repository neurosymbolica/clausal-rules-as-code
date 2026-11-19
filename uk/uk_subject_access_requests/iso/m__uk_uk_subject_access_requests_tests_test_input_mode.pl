% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [uk_subject_access_requests_status/2, uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_time_rules_regime/3, uk_relevant_time/5, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_kernel, [uk_subject_access_requests_input_problems/2]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_profile_for/2]).

test(access_item_due_holds_bound) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    uk_access_entitlement(Profile, item_due, [cite(uk_gdpr_art_15_1), cite(uk_gdpr_art_15_1a)]).
test(status_holds_bound) :-
    uk_subject_access_requests_profile_for(access_search_false, Profile),
    uk_subject_access_requests_status(Profile, item_beyond_reasonable_and_proportionate_search).
test(period_three_months_holds_bound) :-
    uk_subject_access_requests_profile_for(period_three_months, Profile),
    uk_applicable_time_period(Profile, three_months, _Citations).
test(period_no_notice_holds_bound_with_citations) :-
    uk_subject_access_requests_profile_for(period_no_notice, Profile),
    uk_applicable_time_period(Profile, one_month, [cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_4)]).
test(clock_does_not_apply_holds_bound) :-
    uk_subject_access_requests_profile_for(clock_not_access_request, Profile),
    uk_clock_stop(Profile, clock_stop_does_not_apply, [cite(uk_gdpr_art_12a_5)]).
test(regime_holds_bound) :-
    uk_time_rules_regime(date(2026, 2, 5), article_12a_time_rules, _Citations).
test(relevant_time_holds_bound) :-
    uk_relevant_time(date(2026, 3, 1), date(2026, 3, 10), date(2026, 3, 5), date(2026, 3, 10), _Citations).
test(paused_days_holds_bound) :-
    uk_paused_days(date(2026, 3, 1), date(2026, 3, 10), 10, [cite(uk_gdpr_art_12a_5_b)]).
test(deadline_holds_bound) :-
    uk_response_deadline(date(2026, 3, 1), one_month, 0, date(2026, 3, 31), _Citations).
test(compare_holds_bound) :-
    compare_uk_eu_response_deadline(date(2026, 2, 5), one_month, date(2026, 3, 4), date(2026, 3, 5), uk_earlier, _Citations).
test(empty_profile_has_no_problem) :-
    uk_subject_access_requests_input_problems([], Problems),
    Problems == [].
test(improper_list_is_wrong_type) :-
    uk_subject_access_requests_input_problems([attribute(extension_notice_given, true)|not_a_tail], Problems),
    Problems == [wrong_type(profile)].
test(non_attribute_element_is_wrong_type_alone) :-
    uk_subject_access_requests_input_problems([attribute(stray_key, true), loose_element], Problems),
    Problems == [wrong_type(profile)].
test(atom_profile_is_wrong_type) :-
    uk_subject_access_requests_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(number_key_is_unknown) :-
    uk_subject_access_requests_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(compound_key_is_unknown_as_given) :-
    uk_subject_access_requests_input_problems([attribute(key_term(1), true)], Problems),
    Problems == [unknown_key(key_term(1))].
test(compound_value_is_wrong_type) :-
    uk_subject_access_requests_input_problems([attribute(item_described_in_article_15_1, value_term(1))], Problems),
    Problems == [wrong_type(item_described_in_article_15_1)].
test(crisp_key_rejects_unsure) :-
    uk_subject_access_requests_input_problems([attribute(extension_notice_given, unsure)], Problems),
    Problems == [wrong_type(extension_notice_given)].
test(judgement_key_accepts_unsure) :-
    uk_subject_access_requests_input_problems([attribute(item_within_reasonable_and_proportionate_search, unsure)], Problems),
    Problems == [].
test(duplicate_key_reads_no_value) :-
    uk_subject_access_requests_input_problems([attribute(extension_notice_given, true), attribute(extension_notice_given, maybe)], Problems),
    Problems == [duplicate_key(extension_notice_given)].
test(problems_in_contract_order_then_unknown_keys) :-
    uk_subject_access_requests_input_problems([attribute(zeta_key, 1), attribute(further_information_reasonably_required, yes), attribute(item_described_in_article_15_1, unsure), attribute(zeta_key, 2), attribute(alpha_key, true)], Problems),
    Problems == [wrong_type(item_described_in_article_15_1), wrong_type(further_information_reasonably_required), unknown_key(zeta_key), unknown_key(alpha_key)].
test(input_problems_come_first_in_the_period_query) :-
    uk_applicable_time_period([attribute(extension_notice_given, false), attribute(stray_key, true)], Period, Citations),
    Period == input_problems([unknown_key(stray_key)]),
    Citations == [].
test(input_problems_come_first_in_the_clock_query) :-
    uk_clock_stop([attribute(request_made_under_article_15, maybe)], Result, Citations),
    Result == input_problems([wrong_type(request_made_under_article_15)]),
    Citations == [].
test(year_1899_is_wrong_type) :-
    uk_time_rules_regime(date(1899, 12, 31), Regime, []),
    Regime == input_problems([wrong_type(receipt_date)]).
test(year_2199_is_accepted) :-
    uk_time_rules_regime(date(2199, 12, 31), Regime, _Citations),
    Regime == article_12a_time_rules.
test(year_1900_is_accepted) :-
    uk_time_rules_regime(date(1900, 1, 1), Regime, _Citations),
    Regime == earlier_time_limits_saved.
test(february_29_2100_is_not_a_day) :-
    uk_response_deadline(date(2100, 2, 29), one_month, 0, Deadline, []),
    Deadline == input_problems([wrong_type(relevant_time_date)]).
test(february_29_2000_is_a_day) :-
    uk_response_deadline(date(2000, 2, 29), one_month, 0, Deadline, _Citations),
    Deadline == date(2000, 3, 28).
test(all_deadline_arguments_wrong) :-
    uk_response_deadline(not_a_date, two_weeks, minus_one, Deadline, []),
    Deadline == input_problems([wrong_type(relevant_time_date), wrong_type(response_period), wrong_type(paused_days)]).
test(fractional_paused_days_is_wrong_type) :-
    uk_response_deadline(date(2026, 3, 1), one_month, 1.5, Deadline, []),
    Deadline == input_problems([wrong_type(paused_days)]).
test(identity_atom_outside_type) :-
    uk_relevant_time(date(2026, 3, 1), maybe_later, no_fee, Relevant, []),
    Relevant == input_problems([wrong_type(identity_information)]).
test(paused_both_arguments_wrong) :-
    uk_paused_days(yesterday, today, Days, []),
    Days == input_problems([wrong_type(request_for_information_date), wrong_type(information_received_date)]).
test(compare_period_wrong_type) :-
    compare_uk_eu_response_deadline(date(2026, 3, 1), six_weeks, UkDeadline, EuDeadline, Difference, []),
    UkDeadline == input_problems([wrong_type(response_period)]),
    EuDeadline == input_problems([wrong_type(response_period)]),
    Difference == not_comparable.

test(access_item_due_rejects_other_bound_answer, fail) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    uk_access_entitlement(Profile, item_not_within_article_15_1, _Citations).
test(status_rejects_other_bound_answer, fail) :-
    uk_subject_access_requests_profile_for(access_search_false, Profile),
    uk_subject_access_requests_status(Profile, item_due).
test(clock_does_not_apply_rejects_applies, fail) :-
    uk_subject_access_requests_profile_for(clock_not_access_request, Profile),
    uk_clock_stop(Profile, clock_stop_applies, _Citations).
test(relevant_time_rejects_earlier_day, fail) :-
    uk_relevant_time(date(2026, 3, 1), date(2026, 3, 10), date(2026, 3, 5), date(2026, 3, 5), _Citations).
test(paused_days_rejects_exclusive_count, fail) :-
    uk_paused_days(date(2026, 3, 1), date(2026, 3, 10), 9, _Citations).
test(deadline_rejects_same_day_next_month, fail) :-
    uk_response_deadline(date(2026, 3, 1), one_month, 0, date(2026, 4, 1), _Citations).

cp_test_names([access_item_due_holds_bound, status_holds_bound, period_three_months_holds_bound, period_no_notice_holds_bound_with_citations, clock_does_not_apply_holds_bound, regime_holds_bound, relevant_time_holds_bound, paused_days_holds_bound, deadline_holds_bound, compare_holds_bound, empty_profile_has_no_problem, improper_list_is_wrong_type, non_attribute_element_is_wrong_type_alone, atom_profile_is_wrong_type, number_key_is_unknown, compound_key_is_unknown_as_given, compound_value_is_wrong_type, crisp_key_rejects_unsure, judgement_key_accepts_unsure, duplicate_key_reads_no_value, problems_in_contract_order_then_unknown_keys, input_problems_come_first_in_the_period_query, input_problems_come_first_in_the_clock_query, year_1899_is_wrong_type, year_2199_is_accepted, year_1900_is_accepted, february_29_2100_is_not_a_day, february_29_2000_is_a_day, all_deadline_arguments_wrong, fractional_paused_days_is_wrong_type, identity_atom_outside_type, paused_both_arguments_wrong, compare_period_wrong_type]).
cp_test_fail_names([access_item_due_rejects_other_bound_answer, status_rejects_other_bound_answer, clock_does_not_apply_rejects_applies, relevant_time_rejects_earlier_day, paused_days_rejects_exclusive_count, deadline_rejects_same_day_next_month]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
