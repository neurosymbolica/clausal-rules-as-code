% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [decide_uk_subject_access_requests/2, uk_subject_access_requests_status/2, uk_subject_access_requests_checklist/2, uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_time_rules_regime/3, uk_relevant_time/5, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_profile_for/2]).

same_citations(Actual, Expected) :-
    sort(Actual, SortedCitations),
    sort(Expected, SortedCitations).

access_answers(Subject, Answers) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    findall(Result - Citations, uk_access_entitlement(Profile, Result, Citations), Answers).

period_answers(Subject, Answers) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    findall(Period - Citations, uk_applicable_time_period(Profile, Period, Citations), Answers).

clock_answers(Subject, Answers) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    findall(Result - Citations, uk_clock_stop(Profile, Result, Citations), Answers).

test(access_item_due_output) :-
    access_answers(access_item_due, [item_due - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_15_1), cite(uk_gdpr_art_15_1a)]).
test(access_beyond_search_output) :-
    access_answers(access_search_false, [item_beyond_reasonable_and_proportionate_search - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_15_1), cite(uk_gdpr_art_15_1a)]).
test(access_not_described_output) :-
    access_answers(access_not_described, Answers),
    Answers == [item_not_within_article_15_1 - [cite(uk_gdpr_art_15_1)]].
test(access_described_missing_output) :-
    access_answers(access_described_missing, Answers),
    Answers == [indeterminate([item_described_in_article_15_1]) - []].
test(access_search_missing_output) :-
    access_answers(access_search_missing, Answers),
    Answers == [indeterminate([item_within_reasonable_and_proportionate_search]) - []].
test(access_search_unsure_output) :-
    access_answers(access_search_unsure, Answers),
    Answers == [needs_legal_review(open_textured(item_within_reasonable_and_proportionate_search, cite(uk_gdpr_art_15_1a)), [inputs_relied_on([item_described_in_article_15_1 - true, item_within_reasonable_and_proportionate_search - unsure])]) - []].
test(access_wrong_type_output) :-
    access_answers(access_wrong_type, Answers),
    Answers == [input_problems([wrong_type(item_described_in_article_15_1)]) - []].
test(access_duplicate_key_output) :-
    access_answers(access_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(item_described_in_article_15_1)]) - []].
test(access_unknown_key_output) :-
    access_answers(access_unknown_key, Answers),
    Answers == [input_problems([unknown_key(subject_name)]) - []].
test(period_three_months_output) :-
    period_answers(period_three_months, [three_months - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_3_a), cite(uk_gdpr_art_12a_3_b), cite(uk_gdpr_art_12a_4), cite(uk_gdpr_art_12a_4_a), cite(uk_gdpr_art_12a_4_b)]).
test(period_late_notice_output) :-
    period_answers(period_late_notice, [one_month - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_4)]).
test(period_no_notice_output) :-
    period_answers(period_no_notice, [one_month - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_4)]).
test(period_notice_missing_output) :-
    period_answers(period_notice_missing, Answers),
    Answers == [indeterminate([extension_notice_given]) - []].
test(period_reasons_missing_output) :-
    period_answers(period_reasons_missing, Answers),
    Answers == [indeterminate([extension_notice_states_reasons]) - []].
test(period_necessity_unsure_output) :-
    period_answers(period_necessity_unsure, Answers),
    Answers == [needs_legal_review(open_textured(extension_necessary_for_complexity_or_number, cite(uk_gdpr_art_12a_3)), [inputs_relied_on([extension_notice_given - true, extension_notice_given_before_end_of_first_month - true, extension_notice_states_reasons - true, extension_necessary_for_complexity_or_number - unsure])]) - []].
test(clock_stop_applies_output) :-
    clock_answers(clock_stop_applies, [clock_stop_applies - Citations]),
    same_citations(Citations, [cite(uk_gdpr_art_12a_5), cite(uk_gdpr_art_12a_5_a), cite(uk_gdpr_art_12a_5_b), cite(uk_gdpr_art_12a_5_b_i), cite(uk_gdpr_art_12a_5_b_ii)]).
test(clock_not_access_request_output) :-
    clock_answers(clock_not_access_request, Answers),
    Answers == [clock_stop_does_not_apply - [cite(uk_gdpr_art_12a_5)]].
test(clock_asked_missing_output) :-
    clock_answers(clock_asked_missing, Answers),
    Answers == [indeterminate([controller_asked_for_further_information]) - []].
test(clock_further_unsure_output) :-
    clock_answers(clock_further_unsure, Answers),
    Answers == [needs_legal_review(open_textured(further_information_reasonably_required, cite(uk_gdpr_art_12a_5)), [inputs_relied_on([request_made_under_article_15 - true, controller_asked_for_further_information - true, further_information_reasonably_required - unsure])]) - []].
test(regime_output_on_commencement) :-
    findall(Regime - Citations, uk_time_rules_regime(date(2026, 2, 5), Regime, Citations), [article_12a_time_rules - Citations]),
    same_citations(Citations, [cite(uk_si_2026_82_reg_2), cite(uk_si_2026_82_reg_2_h), cite(uk_gdpr_art_12_3), cite(uk_gdpr_art_12_4), cite(uk_gdpr_art_12a_1)]).
test(regime_output_day_before) :-
    findall(Regime - Citations, uk_time_rules_regime(date(2026, 2, 4), Regime, Citations), [earlier_time_limits_saved - Citations]),
    same_citations(Citations, [cite(uk_si_2026_82_reg_4), cite(uk_si_2026_82_reg_4_a)]).
test(relevant_time_output_identity_outstanding) :-
    findall(Relevant, uk_relevant_time(date(2026, 3, 1), requested_not_received, date(2026, 3, 5), Relevant, _Citations), Answers),
    Answers == [not_yet_started].
test(relevant_time_output_fee_paid_latest) :-
    findall(Relevant - Citations, uk_relevant_time(date(2026, 3, 1), not_requested, date(2026, 3, 5), Relevant, Citations), [Relevant - Citations]),
    Relevant == date(2026, 3, 5),
    same_citations(Citations, [cite(uk_gdpr_art_12a_2), cite(uk_gdpr_art_12a_2_a), cite(uk_gdpr_art_12a_2_b), cite(uk_gdpr_art_12a_2_c)]).
test(paused_days_output) :-
    findall(Days - Citations, uk_paused_days(date(2026, 1, 28), date(2026, 2, 3), Days, Citations), Answers),
    Answers == [7 - [cite(uk_gdpr_art_12a_5_b)]].
test(deadline_output_three_months_paused) :-
    findall(Deadline - Citations, uk_response_deadline(date(2026, 11, 30), three_months, 2, Deadline, Citations), [Deadline - Citations]),
    Deadline == date(2027, 3, 2),
    same_citations(Citations, [cite(uk_gdpr_art_12_3), cite(uk_gdpr_art_12_4), cite(uk_gdpr_art_12a_1), cite(uk_gdpr_art_12a_3), cite(uk_gdpr_art_12a_5_b)]).
test(deadline_output_30_january_2028) :-
    findall(Deadline, uk_response_deadline(date(2028, 1, 30), one_month, 0, Deadline, _Citations), Answers),
    Answers == [date(2028, 2, 29)].
test(compare_output_one_month) :-
    findall(answer(UkDeadline, EuDeadline, Difference), compare_uk_eu_response_deadline(date(2026, 2, 5), one_month, UkDeadline, EuDeadline, Difference, _Citations), Answers),
    Answers == [answer(date(2026, 3, 4), date(2026, 3, 5), uk_earlier)].
test(compare_output_citations_one_month) :-
    compare_uk_eu_response_deadline(date(2026, 2, 5), one_month, _UkDeadline, _EuDeadline, _Difference, Citations),
    same_citations(Citations, [cite(uk_gdpr_art_12a_1), cite(eu_reg_2016_679_art_12_3), cite(eu_reg_1971_1182_art_3_1), cite(eu_reg_1971_1182_art_3_2_c), cite(eu_reg_1971_1182_art_3_4)]).
test(compare_output_same_day) :-
    findall(answer(UkDeadline, EuDeadline, Difference), compare_uk_eu_response_deadline(date(2026, 3, 31), one_month, UkDeadline, EuDeadline, Difference, _Citations), Answers),
    Answers == [answer(date(2026, 4, 30), date(2026, 4, 30), same)].
test(compare_output_saved_receipt) :-
    findall(answer(UkDeadline, EuDeadline, Difference), compare_uk_eu_response_deadline(date(2026, 2, 4), one_month, UkDeadline, EuDeadline, Difference, _Citations), Answers),
    Answers == [answer(earlier_time_limits_saved, date(2026, 3, 4), not_comparable)].
test(facade_verdict_output) :-
    uk_subject_access_requests_profile_for(access_not_described, Profile),
    findall(Verdict, decide_uk_subject_access_requests(Profile, Verdict), Verdicts),
    Verdicts == [uk_subject_access_requests_verdict(item_not_within_article_15_1, [cite(uk_gdpr_art_15_1)])].
test(facade_status_output) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    findall(Status, uk_subject_access_requests_status(Profile, Status), Statuses),
    Statuses == [item_due].
test(checklist_output_rows_carry_citations) :-
    uk_subject_access_requests_profile_for(period_three_months, Profile),
    findall(Items, uk_subject_access_requests_checklist(Profile, Items), [Items]),
    findall(Key, member(item(Key, _Status, cite(_CitationKey)), Items), Keys),
    length(Keys, 9).

cp_test_names([access_item_due_output, access_beyond_search_output, access_not_described_output, access_described_missing_output, access_search_missing_output, access_search_unsure_output, access_wrong_type_output, access_duplicate_key_output, access_unknown_key_output, period_three_months_output, period_late_notice_output, period_no_notice_output, period_notice_missing_output, period_reasons_missing_output, period_necessity_unsure_output, clock_stop_applies_output, clock_not_access_request_output, clock_asked_missing_output, clock_further_unsure_output, regime_output_on_commencement, regime_output_day_before, relevant_time_output_identity_outstanding, relevant_time_output_fee_paid_latest, paused_days_output, deadline_output_three_months_paused, deadline_output_30_january_2028, compare_output_one_month, compare_output_citations_one_month, compare_output_same_day, compare_output_saved_receipt, facade_verdict_output, facade_status_output, checklist_output_rows_carry_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
