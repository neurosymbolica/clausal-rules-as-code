% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [decide_uk_subject_access_requests/2, uk_subject_access_requests_status/2, uk_subject_access_requests_checklist/2, uk_subject_access_requests_decision_resolvable/1, uk_subject_access_requests_status_values/1]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_subject/1, uk_subject_access_requests_profile_for/2, uk_subject_access_requests_assess/2]).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_time_rules_regime/3, uk_relevant_time/5, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_date_fixture/2]).
:- use_module(m__uk_uk_subject_access_requests_queries, [uk_subject_access_requests_what_if/4]).
:- use_module(m__uk_uk_subject_access_requests_kernel, [uk_subject_access_requests_input_problems/2]).

expected_status(access_item_due, item_due).
expected_status(access_search_false, item_beyond_reasonable_and_proportionate_search).
expected_status(access_not_described, item_not_within_article_15_1).
expected_status(access_described_missing, indeterminate([item_described_in_article_15_1])).
expected_status(access_search_missing, indeterminate([item_within_reasonable_and_proportionate_search])).
expected_status(access_search_unsure, needs_legal_review(open_textured(item_within_reasonable_and_proportionate_search, cite(uk_gdpr_art_15_1a)), [inputs_relied_on([item_described_in_article_15_1 - true, item_within_reasonable_and_proportionate_search - unsure])])).
expected_status(access_wrong_type, input_problems([wrong_type(item_described_in_article_15_1)])).
expected_status(access_duplicate_key, input_problems([duplicate_key(item_described_in_article_15_1)])).
expected_status(access_unknown_key, input_problems([unknown_key(subject_name)])).
expected_status(period_three_months, indeterminate([item_described_in_article_15_1])).
expected_status(period_late_notice, indeterminate([item_described_in_article_15_1])).
expected_status(period_no_notice, indeterminate([item_described_in_article_15_1])).
expected_status(period_notice_missing, indeterminate([item_described_in_article_15_1])).
expected_status(period_reasons_missing, indeterminate([item_described_in_article_15_1])).
expected_status(period_necessity_unsure, indeterminate([item_described_in_article_15_1])).
expected_status(clock_stop_applies, indeterminate([item_described_in_article_15_1])).
expected_status(clock_not_access_request, indeterminate([item_described_in_article_15_1])).
expected_status(clock_asked_missing, indeterminate([item_described_in_article_15_1])).
expected_status(clock_further_unsure, indeterminate([item_described_in_article_15_1])).

subject_status(Subject, Status) :-
    uk_subject_access_requests_assess(Subject, uk_subject_access_requests_verdict(Status, _Citations)).

subject_has_one_verdict(Subject) :-
    findall(Verdict, uk_subject_access_requests_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_checklist(Subject) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    uk_subject_access_requests_checklist(Profile, [_FirstItem|_OtherItems]).

subject_meets_expectation(Subject) :-
    expected_status(Subject, Expected),
    subject_status(Subject, Status),
    Status == Expected.

subject_profile(Subject, Profile) :-
    uk_subject_access_requests_profile_for(Subject, Profile).

evaluate(regime_case(Receipt), regime_answer(Regime, Citations)) :-
    uk_time_rules_regime(Receipt, Regime, Citations).
evaluate(relevant_time_case(Receipt, Identity, Fee), relevant_answer(Relevant, Citations)) :-
    uk_relevant_time(Receipt, Identity, Fee, Relevant, Citations).
evaluate(paused_days_case(RequestDate, ReceivedDate), paused_answer(DayCount, Citations)) :-
    uk_paused_days(RequestDate, ReceivedDate, DayCount, Citations).
evaluate(deadline_case(Relevant, Period, PausedDays), deadline_answer(Deadline, Citations)) :-
    uk_response_deadline(Relevant, Period, PausedDays, Deadline, Citations).
evaluate(comparison_case(Receipt, Period), comparison_answer(UkDeadline, EuDeadline, Difference, Citations)) :-
    compare_uk_eu_response_deadline(Receipt, Period, UkDeadline, EuDeadline, Difference, Citations).

fixture_answer(Name, Answer) :-
    uk_subject_access_requests_date_fixture(Name, Case),
    evaluate(Case, Answer).

fixture_has_one_answer(Name) :-
    findall(Answer, fixture_answer(Name, Answer), Answers),
    length(Answers, 1).

test(every_subject_has_an_expectation_and_meets_it) :-
    findall(Subject, uk_subject_access_requests_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_meets_expectation, Subjects).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, uk_subject_access_requests_subject(Subject), Subjects),
    maplist(subject_has_one_verdict, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, uk_subject_access_requests_subject(Subject), Subjects),
    maplist(subject_has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Profile, (uk_subject_access_requests_subject(Subject), subject_profile(Subject, Profile)), Profiles),
    maplist(uk_subject_access_requests_decision_resolvable, Profiles).
test(every_date_fixture_has_exactly_one_answer) :-
    findall(Name, uk_subject_access_requests_date_fixture(Name, _Case), Names),
    Names = [_|_],
    maplist(fixture_has_one_answer, Names).
test(final_statuses_are_in_the_vocabulary) :-
    uk_subject_access_requests_status_values(StatusValues),
    subject_status(access_item_due, DueStatus),
    member(DueStatus, StatusValues),
    subject_status(access_search_false, BeyondStatus),
    member(BeyondStatus, StatusValues),
    subject_status(access_not_described, NotWithinStatus),
    member(NotWithinStatus, StatusValues).
test(provenance_constructor_builds_a_context_item) :-
    Item = provenance(uk_gdpr_art_12a_5, 'uk-eur-2016-679-revised-2026-09-30#article-12A.-5'),
    Item = provenance(SourceKey, _SourceDetail),
    SourceKey == uk_gdpr_art_12a_5.
test(access_item_due_verdict_and_citations) :-
    uk_subject_access_requests_assess(access_item_due, uk_subject_access_requests_verdict(Status, Citations)),
    Status == item_due,
    sort(Citations, [cite(uk_gdpr_art_15_1), cite(uk_gdpr_art_15_1a)]).
test(access_search_false_is_beyond) :-
    subject_status(access_search_false, item_beyond_reasonable_and_proportionate_search).
test(access_not_described_cites_article_15_1_only) :-
    uk_subject_access_requests_assess(access_not_described, uk_subject_access_requests_verdict(item_not_within_article_15_1, Citations)),
    Citations == [cite(uk_gdpr_art_15_1)].
test(access_unsure_has_no_citations) :-
    uk_subject_access_requests_assess(access_search_unsure, uk_subject_access_requests_verdict(_Status, Citations)),
    Citations == [].
test(access_status_projection_matches_verdict) :-
    subject_profile(access_search_false, Profile),
    uk_subject_access_requests_status(Profile, Status),
    Status == item_beyond_reasonable_and_proportionate_search.
test(access_entitlement_query_matches_facade) :-
    subject_profile(access_item_due, Profile),
    uk_access_entitlement(Profile, Result, _Citations),
    decide_uk_subject_access_requests(Profile, uk_subject_access_requests_verdict(Status, _VerdictCitations)),
    Result == Status.
test(access_checklist_rows_carry_citations) :-
    subject_profile(access_item_due, Profile),
    uk_subject_access_requests_checklist(Profile, Items),
    member(item(item_described_in_article_15_1, met, cite(uk_gdpr_art_15_1)), Items),
    member(item(item_within_reasonable_and_proportionate_search, met, cite(uk_gdpr_art_15_1a)), Items).
test(access_checklist_unsure_row_is_unknown) :-
    subject_profile(access_search_unsure, Profile),
    uk_subject_access_requests_checklist(Profile, Items),
    member(item(item_within_reasonable_and_proportionate_search, unknown([item_within_reasonable_and_proportionate_search]), cite(uk_gdpr_art_15_1a)), Items).
test(access_input_check_on_fixture) :-
    subject_profile(access_unknown_key, Profile),
    uk_subject_access_requests_input_problems(Profile, Problems),
    Problems == [unknown_key(subject_name)].
test(access_input_check_clean_fixture) :-
    subject_profile(access_item_due, Profile),
    uk_subject_access_requests_input_problems(Profile, []).
test(access_what_if_flips_near_miss_to_due) :-
    subject_profile(access_search_false, Profile),
    uk_subject_access_requests_what_if(Profile, item_within_reasonable_and_proportionate_search, true, Status),
    Status == item_due.
test(period_three_months_fixture) :-
    subject_profile(period_three_months, Profile),
    uk_applicable_time_period(Profile, Period, Citations),
    Period == three_months,
    length(Citations, 7).
test(period_late_notice_is_one_month) :-
    subject_profile(period_late_notice, Profile),
    findall(Period - Citations, uk_applicable_time_period(Profile, Period, Citations), Answers),
    Answers = [one_month - Citations],
    sort(Citations, [cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_4)]).
test(period_no_notice_is_one_month) :-
    subject_profile(period_no_notice, Profile),
    uk_applicable_time_period(Profile, one_month, _Citations).
test(period_notice_missing_named) :-
    subject_profile(period_notice_missing, Profile),
    uk_applicable_time_period(Profile, Period, Citations),
    Period == indeterminate([extension_notice_given]),
    Citations == [].
test(period_reasons_missing_named) :-
    subject_profile(period_reasons_missing, Profile),
    uk_applicable_time_period(Profile, Period, []),
    Period == indeterminate([extension_notice_states_reasons]).
test(period_necessity_unsure_goes_to_lawyer) :-
    subject_profile(period_necessity_unsure, Profile),
    uk_applicable_time_period(Profile, Period, []),
    Period == needs_legal_review(open_textured(extension_necessary_for_complexity_or_number, cite(uk_gdpr_art_12a_3)), [inputs_relied_on([extension_notice_given - true, extension_notice_given_before_end_of_first_month - true, extension_notice_states_reasons - true, extension_necessary_for_complexity_or_number - unsure])]).
test(clock_stop_applies_fixture) :-
    subject_profile(clock_stop_applies, Profile),
    uk_clock_stop(Profile, Result, Citations),
    Result == clock_stop_applies,
    length(Citations, 5).
test(clock_not_access_request_result) :-
    subject_profile(clock_not_access_request, Profile),
    uk_clock_stop(Profile, clock_stop_does_not_apply, Citations),
    Citations == [cite(uk_gdpr_art_12a_5)].
test(clock_asked_missing_named) :-
    subject_profile(clock_asked_missing, Profile),
    uk_clock_stop(Profile, Result, []),
    Result == indeterminate([controller_asked_for_further_information]).
test(clock_further_unsure_goes_to_lawyer) :-
    subject_profile(clock_further_unsure, Profile),
    uk_clock_stop(Profile, Result, []),
    Result == needs_legal_review(open_textured(further_information_reasonably_required, cite(uk_gdpr_art_12a_5)), [inputs_relied_on([request_made_under_article_15 - true, controller_asked_for_further_information - true, further_information_reasonably_required - unsure])]).
test(regime_on_commencement_day) :-
    fixture_answer(regime_on_commencement_day, regime_answer(Regime, Citations)),
    Regime == article_12a_time_rules,
    length(Citations, 5).
test(regime_day_before_is_saved) :-
    fixture_answer(regime_day_before_commencement, regime_answer(Regime, Citations)),
    Regime == earlier_time_limits_saved,
    sort(Citations, [cite(uk_si_2026_82_reg_4), cite(uk_si_2026_82_reg_4_a)]).
test(regime_impossible_date_is_a_problem) :-
    fixture_answer(regime_impossible_date, regime_answer(Regime, [])),
    Regime == input_problems([wrong_type(receipt_date)]).
test(relevant_plain_request_is_receipt) :-
    fixture_answer(relevant_plain_request, relevant_answer(Relevant, Citations)),
    Relevant == date(2026, 3, 1),
    length(Citations, 4).
test(relevant_identity_received_latest) :-
    fixture_answer(relevant_identity_received_latest, relevant_answer(Relevant, _Citations)),
    Relevant == date(2026, 3, 10).
test(relevant_identity_outstanding_not_started) :-
    fixture_answer(relevant_identity_outstanding, relevant_answer(Relevant, _Citations)),
    Relevant == not_yet_started.
test(relevant_fee_paid_is_fee_day) :-
    fixture_answer(relevant_fee_paid, relevant_answer(Relevant, _Citations)),
    Relevant == date(2026, 3, 5).
test(relevant_fee_outstanding_not_started) :-
    fixture_answer(relevant_fee_outstanding, relevant_answer(not_yet_started, _Citations)).
test(relevant_argument_problems_in_order) :-
    fixture_answer(relevant_argument_problems, relevant_answer(Relevant, [])),
    Relevant == input_problems([wrong_type(receipt_date), wrong_type(fee)]).
test(paused_same_day_is_one) :-
    fixture_answer(paused_same_day, paused_answer(DayCount, Citations)),
    DayCount =:= 1,
    Citations == [cite(uk_gdpr_art_12a_5_b)].
test(paused_received_day_before_is_a_problem) :-
    fixture_answer(paused_received_day_before_asked, paused_answer(DayCount, [])),
    DayCount == input_problems([wrong_type(information_received_date)]).
test(paused_ten_days_both_counted) :-
    fixture_answer(paused_ten_days, paused_answer(DayCount, _Citations)),
    DayCount =:= 10.
test(deadline_5_february_2026) :-
    fixture_answer(deadline_5_february_2026, deadline_answer(Deadline, Citations)),
    Deadline == date(2026, 3, 4),
    sort(Citations, [cite(uk_gdpr_art_12_3), cite(uk_gdpr_art_12_4), cite(uk_gdpr_art_12a_1)]).
test(deadline_1_march_2026) :-
    fixture_answer(deadline_1_march_2026, deadline_answer(Deadline, _Citations)),
    Deadline == date(2026, 3, 31).
test(deadline_31_january_2027) :-
    fixture_answer(deadline_31_january_2027, deadline_answer(Deadline, _Citations)),
    Deadline == date(2027, 2, 28).
test(deadline_29_january_2028_day_before_leap_day) :-
    fixture_answer(deadline_29_january_2028, deadline_answer(Deadline, _Citations)),
    Deadline == date(2028, 2, 28).
test(deadline_30_january_2028_last_day_of_february) :-
    fixture_answer(deadline_30_january_2028, deadline_answer(Deadline, _Citations)),
    Deadline == date(2028, 2, 29).
test(deadline_29_january_2027) :-
    fixture_answer(deadline_29_january_2027, deadline_answer(Deadline, _Citations)),
    Deadline == date(2027, 2, 28).
test(deadline_three_months) :-
    fixture_answer(deadline_three_months_30_november_2026, deadline_answer(Deadline, Citations)),
    Deadline == date(2027, 2, 28),
    sort(Citations, [cite(uk_gdpr_art_12_3), cite(uk_gdpr_art_12_4), cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3)]).
test(deadline_paused_days_added) :-
    fixture_answer(deadline_paused_three_days, deadline_answer(Deadline, Citations)),
    Deadline == date(2026, 3, 7),
    sort(Citations, [cite(uk_gdpr_art_12_3), cite(uk_gdpr_art_12_4), cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_5_b)]).
test(deadline_wrong_period_is_a_problem) :-
    fixture_answer(deadline_wrong_period, deadline_answer(Deadline, [])),
    Deadline == input_problems([wrong_type(response_period)]).
test(compare_5_february_2026_uk_earlier) :-
    fixture_answer(compare_5_february_2026, comparison_answer(UkDeadline, EuDeadline, Difference, Citations)),
    UkDeadline == date(2026, 3, 4),
    EuDeadline == date(2026, 3, 5),
    Difference == uk_earlier,
    length(Citations, 5).
test(compare_30_november_2026_weekend_shift) :-
    fixture_answer(compare_30_november_2026_three_months, comparison_answer(UkDeadline, EuDeadline, Difference, Citations)),
    UkDeadline == date(2027, 2, 28),
    EuDeadline == date(2027, 3, 1),
    Difference == uk_earlier,
    length(Citations, 6).
test(compare_31_march_2026_same_day) :-
    fixture_answer(compare_31_march_2026_same_day, comparison_answer(UkDeadline, EuDeadline, Difference, _Citations)),
    UkDeadline == date(2026, 4, 30),
    EuDeadline == date(2026, 4, 30),
    Difference == same.
test(compare_saved_receipt_not_comparable) :-
    fixture_answer(compare_saved_receipt, comparison_answer(UkDeadline, EuDeadline, Difference, Citations)),
    UkDeadline == earlier_time_limits_saved,
    EuDeadline == date(2026, 3, 4),
    Difference == not_comparable,
    length(Citations, 6).
test(compare_argument_problem) :-
    fixture_answer(compare_argument_problem, comparison_answer(UkDeadline, EuDeadline, Difference, [])),
    UkDeadline == input_problems([wrong_type(receipt_date)]),
    EuDeadline == input_problems([wrong_type(receipt_date)]),
    Difference == not_comparable.

test(access_search_false_is_not_due, fail) :-
    subject_status(access_search_false, item_due).
test(access_item_due_is_not_outside_article_15_1, fail) :-
    subject_status(access_item_due, item_not_within_article_15_1).
test(period_late_notice_is_not_three_months, fail) :-
    subject_profile(period_late_notice, Profile),
    uk_applicable_time_period(Profile, three_months, _Citations).
test(clock_not_access_request_does_not_stop, fail) :-
    subject_profile(clock_not_access_request, Profile),
    uk_clock_stop(Profile, clock_stop_applies, _Citations).
test(regime_day_before_is_not_new_rules, fail) :-
    fixture_answer(regime_day_before_commencement, regime_answer(article_12a_time_rules, _Citations)).
test(relevant_fee_paid_has_started, fail) :-
    fixture_answer(relevant_fee_paid, relevant_answer(not_yet_started, _Citations)).
test(paused_received_day_before_has_no_count, fail) :-
    fixture_answer(paused_received_day_before_asked, paused_answer(DayCount, _Citations)),
    integer(DayCount).
test(deadline_29_january_2028_is_not_leap_day, fail) :-
    fixture_answer(deadline_29_january_2028, deadline_answer(date(2028, 2, 29), _Citations)).
test(compare_31_march_2026_is_not_uk_earlier, fail) :-
    fixture_answer(compare_31_march_2026_same_day, comparison_answer(_UkDeadline, _EuDeadline, uk_earlier, _Citations)).

cp_test_names([every_subject_has_an_expectation_and_meets_it, every_subject_has_exactly_one_verdict, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_date_fixture_has_exactly_one_answer, final_statuses_are_in_the_vocabulary, provenance_constructor_builds_a_context_item, access_item_due_verdict_and_citations, access_search_false_is_beyond, access_not_described_cites_article_15_1_only, access_unsure_has_no_citations, access_status_projection_matches_verdict, access_entitlement_query_matches_facade, access_checklist_rows_carry_citations, access_checklist_unsure_row_is_unknown, access_input_check_on_fixture, access_input_check_clean_fixture, access_what_if_flips_near_miss_to_due, period_three_months_fixture, period_late_notice_is_one_month, period_no_notice_is_one_month, period_notice_missing_named, period_reasons_missing_named, period_necessity_unsure_goes_to_lawyer, clock_stop_applies_fixture, clock_not_access_request_result, clock_asked_missing_named, clock_further_unsure_goes_to_lawyer, regime_on_commencement_day, regime_day_before_is_saved, regime_impossible_date_is_a_problem, relevant_plain_request_is_receipt, relevant_identity_received_latest, relevant_identity_outstanding_not_started, relevant_fee_paid_is_fee_day, relevant_fee_outstanding_not_started, relevant_argument_problems_in_order, paused_same_day_is_one, paused_received_day_before_is_a_problem, paused_ten_days_both_counted, deadline_5_february_2026, deadline_1_march_2026, deadline_31_january_2027, deadline_29_january_2028_day_before_leap_day, deadline_30_january_2028_last_day_of_february, deadline_29_january_2027, deadline_three_months, deadline_paused_days_added, deadline_wrong_period_is_a_problem, compare_5_february_2026_uk_earlier, compare_30_november_2026_weekend_shift, compare_31_march_2026_same_day, compare_saved_receipt_not_comparable, compare_argument_problem]).
cp_test_fail_names([access_search_false_is_not_due, access_item_due_is_not_outside_article_15_1, period_late_notice_is_not_three_months, clock_not_access_request_does_not_stop, regime_day_before_is_not_new_rules, relevant_fee_paid_has_started, paused_received_day_before_has_no_count, deadline_29_january_2028_is_not_leap_day, compare_31_march_2026_is_not_uk_earlier]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
