% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [uk_subject_access_requests_status_values/1, uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_time_rules_regime/3, uk_relevant_time/5, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_profile_for/2, uk_subject_access_requests_date_fixture/2]).

access_of(Subject, Result) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    uk_access_entitlement(Profile, Result, _Citations).

period_of(Subject, Period) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    uk_applicable_time_period(Profile, Period, _Citations).

clock_of(Subject, Result) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    uk_clock_stop(Profile, Result, _Citations).

test(status_table_holds_the_near_miss_atoms) :-
    uk_subject_access_requests_status_values(StatusValues),
    member(item_due, StatusValues),
    member(item_not_within_article_15_1, StatusValues),
    member(item_beyond_reasonable_and_proportionate_search, StatusValues).
test(access_due_positive) :-
    access_of(access_item_due, item_due).
test(access_beyond_positive) :-
    access_of(access_search_false, item_beyond_reasonable_and_proportionate_search).
test(access_not_within_positive) :-
    access_of(access_not_described, item_not_within_article_15_1).
test(access_missing_positive) :-
    access_of(access_described_missing, indeterminate([item_described_in_article_15_1])).
test(access_referral_positive) :-
    access_of(access_search_unsure, needs_legal_review(open_textured(item_within_reasonable_and_proportionate_search, cite(uk_gdpr_art_15_1a)), _Context)).
test(access_search_missing_is_indeterminate) :-
    access_of(access_search_missing, indeterminate([item_within_reasonable_and_proportionate_search])).
test(access_input_problem_positive) :-
    access_of(access_unknown_key, input_problems([unknown_key(subject_name)])).
test(period_three_months_positive) :-
    period_of(period_three_months, three_months).
test(period_late_notice_is_one_month) :-
    period_of(period_late_notice, one_month).
test(period_one_month_positive) :-
    period_of(period_no_notice, one_month).
test(period_notice_absent_is_indeterminate) :-
    period_of(period_notice_missing, indeterminate([extension_notice_given])).
test(period_reasons_missing_positive) :-
    period_of(period_reasons_missing, indeterminate([extension_notice_states_reasons])).
test(period_referral_positive) :-
    period_of(period_necessity_unsure, needs_legal_review(open_textured(extension_necessary_for_complexity_or_number, cite(uk_gdpr_art_12a_3)), _Context)).
test(clock_applies_positive) :-
    clock_of(clock_stop_applies, clock_stop_applies).
test(clock_does_not_apply_positive) :-
    clock_of(clock_not_access_request, clock_stop_does_not_apply).
test(clock_missing_positive) :-
    clock_of(clock_asked_missing, indeterminate([controller_asked_for_further_information])).
test(clock_referral_positive) :-
    clock_of(clock_further_unsure, needs_legal_review(open_textured(further_information_reasonably_required, cite(uk_gdpr_art_12a_5)), _Context)).
test(regime_new_rules_positive) :-
    uk_subject_access_requests_date_fixture(regime_on_commencement_day, regime_case(Receipt)),
    uk_time_rules_regime(Receipt, article_12a_time_rules, _Citations).
test(regime_day_before_is_saved) :-
    uk_subject_access_requests_date_fixture(regime_day_before_commencement, regime_case(Receipt)),
    uk_time_rules_regime(Receipt, earlier_time_limits_saved, _Citations).
test(relevant_fee_paid_positive) :-
    uk_subject_access_requests_date_fixture(relevant_fee_paid, relevant_time_case(Receipt, Identity, Fee)),
    uk_relevant_time(Receipt, Identity, Fee, date(2026, 3, 5), _Citations).
test(relevant_fee_outstanding_not_yet_started) :-
    uk_subject_access_requests_date_fixture(relevant_fee_outstanding, relevant_time_case(Receipt, Identity, Fee)),
    uk_relevant_time(Receipt, Identity, Fee, not_yet_started, _Citations).
test(relevant_identity_outstanding_not_yet_started) :-
    uk_subject_access_requests_date_fixture(relevant_identity_outstanding, relevant_time_case(Receipt, Identity, Fee)),
    uk_relevant_time(Receipt, Identity, Fee, not_yet_started, _Citations).
test(paused_same_day_positive) :-
    uk_subject_access_requests_date_fixture(paused_same_day, paused_days_case(RequestDate, ReceivedDate)),
    uk_paused_days(RequestDate, ReceivedDate, 1, _Citations).
test(paused_received_day_before_is_a_problem) :-
    uk_subject_access_requests_date_fixture(paused_received_day_before_asked, paused_days_case(RequestDate, ReceivedDate)),
    uk_paused_days(RequestDate, ReceivedDate, input_problems([wrong_type(information_received_date)]), []).
test(deadline_day_before_positive) :-
    uk_subject_access_requests_date_fixture(deadline_29_january_2028, deadline_case(Relevant, Period, PausedDays)),
    uk_response_deadline(Relevant, Period, PausedDays, date(2028, 2, 28), _Citations).
test(deadline_30_january_2028_last_day) :-
    uk_subject_access_requests_date_fixture(deadline_30_january_2028, deadline_case(Relevant, Period, PausedDays)),
    uk_response_deadline(Relevant, Period, PausedDays, date(2028, 2, 29), _Citations).
test(deadline_paused_positive) :-
    uk_subject_access_requests_date_fixture(deadline_paused_three_days, deadline_case(Relevant, Period, PausedDays)),
    uk_response_deadline(Relevant, Period, PausedDays, date(2026, 3, 7), _Citations).
test(compare_uk_earlier_positive) :-
    uk_subject_access_requests_date_fixture(compare_5_february_2026, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, _UkDeadline, _EuDeadline, uk_earlier, _Citations).
test(compare_month_end_is_same) :-
    uk_subject_access_requests_date_fixture(compare_31_march_2026_same_day, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, _UkDeadline, _EuDeadline, same, _Citations).
test(compare_saved_is_not_comparable) :-
    uk_subject_access_requests_date_fixture(compare_saved_receipt, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, earlier_time_limits_saved, _EuDeadline, not_comparable, _Citations).
test(compare_weekend_shift_positive) :-
    uk_subject_access_requests_date_fixture(compare_30_november_2026_three_months, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, date(2027, 2, 28), date(2027, 3, 1), uk_earlier, _Citations).

test(access_due_near_miss_search_false, fail) :-
    access_of(access_search_false, item_due).
test(access_beyond_near_miss_search_true, fail) :-
    access_of(access_item_due, item_beyond_reasonable_and_proportionate_search).
test(access_not_within_near_miss_described, fail) :-
    access_of(access_item_due, item_not_within_article_15_1).
test(access_missing_near_miss_given_false, fail) :-
    access_of(access_not_described, indeterminate(_MissingKeys)).
test(access_referral_near_miss_search_missing, fail) :-
    access_of(access_search_missing, needs_legal_review(_Reason, _Context)).
test(access_input_problem_near_miss_clean_profile, fail) :-
    access_of(access_item_due, input_problems(_Problems)).
test(period_three_months_near_miss_late_notice, fail) :-
    period_of(period_late_notice, three_months).
test(period_one_month_near_miss_notice_absent, fail) :-
    period_of(period_notice_missing, one_month).
test(period_reasons_missing_near_miss_all_given, fail) :-
    period_of(period_three_months, indeterminate(_MissingKeys)).
test(period_referral_near_miss_necessity_true, fail) :-
    period_of(period_three_months, needs_legal_review(_Reason, _Context)).
test(clock_applies_near_miss_not_access_request, fail) :-
    clock_of(clock_not_access_request, clock_stop_applies).
test(clock_does_not_apply_near_miss_all_true, fail) :-
    clock_of(clock_stop_applies, clock_stop_does_not_apply).
test(clock_referral_near_miss_asked_missing, fail) :-
    clock_of(clock_asked_missing, needs_legal_review(_Reason, _Context)).
test(regime_new_rules_near_miss_day_before, fail) :-
    uk_subject_access_requests_date_fixture(regime_day_before_commencement, regime_case(Receipt)),
    uk_time_rules_regime(Receipt, article_12a_time_rules, _Citations).
test(relevant_fee_paid_near_miss_fee_outstanding, fail) :-
    uk_subject_access_requests_date_fixture(relevant_fee_outstanding, relevant_time_case(Receipt, Identity, Fee)),
    uk_relevant_time(Receipt, Identity, Fee, date(_Year, _Month, _Day), _Citations).
test(relevant_identity_received_near_miss, fail) :-
    uk_subject_access_requests_date_fixture(relevant_identity_received_latest, relevant_time_case(Receipt, Identity, Fee)),
    uk_relevant_time(Receipt, Identity, Fee, not_yet_started, _Citations).
test(paused_near_miss_received_day_before, fail) :-
    uk_subject_access_requests_date_fixture(paused_received_day_before_asked, paused_days_case(RequestDate, ReceivedDate)),
    uk_paused_days(RequestDate, ReceivedDate, Days, _Citations),
    integer(Days).
test(deadline_near_miss_last_day_of_month, fail) :-
    uk_subject_access_requests_date_fixture(deadline_30_january_2028, deadline_case(Relevant, Period, PausedDays)),
    uk_response_deadline(Relevant, Period, PausedDays, date(2028, 2, 28), _Citations).
test(deadline_paused_near_miss_unpaused_day, fail) :-
    uk_subject_access_requests_date_fixture(deadline_paused_three_days, deadline_case(Relevant, Period, PausedDays)),
    uk_response_deadline(Relevant, Period, PausedDays, date(2026, 3, 4), _Citations).
test(compare_uk_earlier_near_miss_month_end, fail) :-
    uk_subject_access_requests_date_fixture(compare_31_march_2026_same_day, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, _UkDeadline, _EuDeadline, uk_earlier, _Citations).
test(compare_saved_near_miss_has_no_uk_date, fail) :-
    uk_subject_access_requests_date_fixture(compare_saved_receipt, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, date(_Year, _Month, _Day), _EuDeadline, _Difference, _Citations).
test(compare_weekend_shift_near_miss_unshifted, fail) :-
    uk_subject_access_requests_date_fixture(compare_30_november_2026_three_months, comparison_case(Receipt, Period)),
    compare_uk_eu_response_deadline(Receipt, Period, _UkDeadline, date(2027, 2, 28), _Difference, _Citations).

cp_test_names([status_table_holds_the_near_miss_atoms, access_due_positive, access_beyond_positive, access_not_within_positive, access_missing_positive, access_referral_positive, access_search_missing_is_indeterminate, access_input_problem_positive, period_three_months_positive, period_late_notice_is_one_month, period_one_month_positive, period_notice_absent_is_indeterminate, period_reasons_missing_positive, period_referral_positive, clock_applies_positive, clock_does_not_apply_positive, clock_missing_positive, clock_referral_positive, regime_new_rules_positive, regime_day_before_is_saved, relevant_fee_paid_positive, relevant_fee_outstanding_not_yet_started, relevant_identity_outstanding_not_yet_started, paused_same_day_positive, paused_received_day_before_is_a_problem, deadline_day_before_positive, deadline_30_january_2028_last_day, deadline_paused_positive, compare_uk_earlier_positive, compare_month_end_is_same, compare_saved_is_not_comparable, compare_weekend_shift_positive]).
cp_test_fail_names([access_due_near_miss_search_false, access_beyond_near_miss_search_true, access_not_within_near_miss_described, access_missing_near_miss_given_false, access_referral_near_miss_search_missing, access_input_problem_near_miss_clean_profile, period_three_months_near_miss_late_notice, period_one_month_near_miss_notice_absent, period_reasons_missing_near_miss_all_given, period_referral_near_miss_necessity_true, clock_applies_near_miss_not_access_request, clock_does_not_apply_near_miss_all_true, clock_referral_near_miss_asked_missing, regime_new_rules_near_miss_day_before, relevant_fee_paid_near_miss_fee_outstanding, relevant_identity_received_near_miss, paused_near_miss_received_day_before, deadline_near_miss_last_day_of_month, deadline_paused_near_miss_unpaused_day, compare_uk_earlier_near_miss_month_end, compare_saved_near_miss_has_no_uk_date, compare_weekend_shift_near_miss_unshifted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
