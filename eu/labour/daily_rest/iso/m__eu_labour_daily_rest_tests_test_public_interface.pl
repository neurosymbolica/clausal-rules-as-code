% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_labour_daily_rest_daily_rest, [daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6, daily_rest_checklist/6, daily_rest_decision_resolvable/5, daily_rest_status_values/1]).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_subject/1, daily_rest_profile_for/2, daily_rest_assess/2]).

expected_answer(day_shift_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(short_rest_worker, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(eleven_hour_rest_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 660, no_window_without_daily_rest).
expected_answer(one_minute_short_rest_worker, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 659, date_time(2026, 3, 2, 8, 0)).
expected_answer(mobile_worker_short_rest, daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(mobile_worker_day_shifts, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(fishing_vessel_worker_short_rest, daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_21_1)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(fishing_vessel_worker_day_shifts, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(derogation_article_17_1_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_1)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(derogation_article_17_3_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_3)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(derogation_article_17_4_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_4)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(derogation_article_18_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(derogation_article_17_4_day_shifts, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(missing_category_short_rest, indeterminate([worker_category]), [], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(missing_category_day_shifts, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(missing_derogation_short_rest, indeterminate([derogation_from_article_3]), [], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(on_call_on_site_absent, indeterminate([on_call_on_site_counts_as_working_time]), [], indeterminate([on_call_on_site_counts_as_working_time]), indeterminate([on_call_on_site_counts_as_working_time])).
expected_answer(on_call_on_site_counted, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 600, date_time(2026, 3, 2, 8, 0)).
expected_answer(on_call_on_site_not_counted, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(on_call_on_site_unsure, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), [], needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])])).
expected_answer(on_call_on_site_unsure_missing_category, indeterminate([worker_category]), [], needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])])).
expected_answer(on_call_standby_unsure, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])]), [], needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])]), needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])])).
expected_answer(standby_behind_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], indeterminate([on_call_standby_counts_as_working_time]), no_window_without_daily_rest).
expected_answer(standby_behind_short_worker, indeterminate([on_call_on_site_counts_as_working_time]), [], indeterminate([on_call_standby_counts_as_working_time]), indeterminate([on_call_on_site_counts_as_working_time])).
expected_answer(no_work_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], no_work_start_in_period, no_window_without_daily_rest).
expected_answer(single_shift_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 930, no_window_without_daily_rest).
expected_answer(period_cut_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 1080, no_window_without_daily_rest).
expected_answer(period_cut_short_worker, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 600, date_time(2026, 3, 2, 0, 0)).
expected_answer(leave_as_rest_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 960, no_window_without_daily_rest).
expected_answer(leave_replaced_by_work_worker, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)], 480, date_time(2026, 3, 2, 8, 0)).
expected_answer(malformed_profile_worker, input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]), [], input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]), input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)])).
expected_answer(reversed_period_worker, input_problems([wrong_type(period_end)]), [], input_problems([wrong_type(period_end)]), input_problems([wrong_type(period_end)])).

subject_status(Subject, Result - Citations) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

subject_shortest(Subject, Minutes) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

subject_first_window(Subject, Start) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Start).

subject_checklist(Subject, Items) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_checklist(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Items).

subject_resolvable(Subject) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_decision_resolvable(Profile, Worker, Shifts, PeriodStart, PeriodEnd).

status_as_expected(Subject) :-
    expected_answer(Subject, Result, Citations, _, _),
    findall(Answer, subject_status(Subject, Answer), Answers),
    Answers == [Result - Citations].

shortest_as_expected(Subject) :-
    expected_answer(Subject, _, _, Minutes, _),
    findall(Answer, subject_shortest(Subject, Answer), Answers),
    Answers == [Minutes].

first_window_as_expected(Subject) :-
    expected_answer(Subject, _, _, _, Start),
    findall(Answer, subject_first_window(Subject, Answer), Answers),
    Answers == [Start].

assessment_as_expected(Subject) :-
    expected_answer(Subject, Result, Citations, _, _),
    findall(Verdict, daily_rest_assess(Subject, Verdict), Verdicts),
    Verdicts == [daily_rest_verdict(Result, Citations)].

all_subjects(Subjects) :-
    findall(Subject, daily_rest_subject(Subject), Subjects).

test(every_subject_has_one_case) :-
    all_subjects(Subjects),
    maplist(one_case, Subjects).
test(every_subject_resolves_to_its_expected_status) :-
    all_subjects(Subjects),
    maplist(status_as_expected, Subjects).
test(every_subject_resolves_to_its_expected_shortest_rest) :-
    all_subjects(Subjects),
    maplist(shortest_as_expected, Subjects).
test(every_subject_resolves_to_its_expected_first_short_window) :-
    all_subjects(Subjects),
    maplist(first_window_as_expected, Subjects).
test(every_subject_assesses_to_its_expected_verdict) :-
    all_subjects(Subjects),
    maplist(assessment_as_expected, Subjects).
test(day_shifts_give_the_daily_rest) :-
    subject_status(day_shift_worker, daily_rest_given - _).
test(a_short_rest_is_not_given) :-
    subject_status(short_rest_worker, daily_rest_not_given - _).
test(exactly_eleven_hours_hold_the_daily_rest) :-
    subject_status(eleven_hour_rest_worker, daily_rest_given - _),
    subject_shortest(eleven_hour_rest_worker, 660).
test(one_minute_under_eleven_hours_is_short) :-
    subject_status(one_minute_short_rest_worker, daily_rest_not_given - _),
    subject_shortest(one_minute_short_rest_worker, 659),
    subject_first_window(one_minute_short_rest_worker, date_time(2026, 3, 2, 8, 0)).
test(the_boundary_has_no_short_window) :-
    subject_first_window(eleven_hour_rest_worker, no_window_without_daily_rest).
test(a_mobile_worker_with_a_short_rest_is_not_applied) :-
    subject_status(mobile_worker_short_rest, daily_rest_not_applied_to_worker - [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(a_mobile_worker_on_day_shifts_is_given_the_rest) :-
    subject_status(mobile_worker_day_shifts, daily_rest_given - _).
test(a_fishing_vessel_worker_with_a_short_rest_is_not_applied) :-
    subject_status(fishing_vessel_worker_short_rest, daily_rest_not_applied_to_worker - [cite(eu_dir_2003_88_art_21_1)]).
test(a_fishing_vessel_worker_on_day_shifts_is_given_the_rest) :-
    subject_status(fishing_vessel_worker_day_shifts, daily_rest_given - _).
test(a_derogation_under_article_18_cites_both_subparagraphs) :-
    subject_status(derogation_article_18_short_rest, daily_rest_derogation_applies - [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
test(a_derogation_on_day_shifts_is_given_the_rest) :-
    subject_status(derogation_article_17_4_day_shifts, daily_rest_given - _).
test(a_missing_category_is_asked_for_when_the_rest_is_short) :-
    subject_status(missing_category_short_rest, indeterminate([worker_category]) - []).
test(a_missing_category_is_not_asked_for_when_the_rest_is_given) :-
    subject_status(missing_category_day_shifts, daily_rest_given - _).
test(a_missing_derogation_is_asked_for_an_ordinary_worker) :-
    subject_status(missing_derogation_short_rest, indeterminate([derogation_from_article_3]) - []).
test(a_mobile_worker_needs_no_derogation_answer) :-
    subject_status(mobile_worker_short_rest, daily_rest_not_applied_to_worker - _).
test(an_absent_on_site_key_is_named_by_every_query) :-
    subject_status(on_call_on_site_absent, indeterminate([on_call_on_site_counts_as_working_time]) - []),
    subject_shortest(on_call_on_site_absent, indeterminate([on_call_on_site_counts_as_working_time])),
    subject_first_window(on_call_on_site_absent, indeterminate([on_call_on_site_counts_as_working_time])).
test(counted_on_site_time_shortens_the_rest) :-
    subject_status(on_call_on_site_counted, daily_rest_not_given - _),
    subject_shortest(on_call_on_site_counted, 600).
test(on_site_time_not_counted_is_rest) :-
    subject_status(on_call_on_site_not_counted, daily_rest_given - _),
    subject_shortest(on_call_on_site_not_counted, 960).
test(an_unsure_on_site_judgement_goes_to_a_lawyer) :-
    subject_status(on_call_on_site_unsure, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]) - []).
test(a_referral_may_carry_a_trailing_provenance_marker) :-
    subject_status(on_call_on_site_unsure, Review - []),
    Review = needs_legal_review(Reason, [ReliedItem]),
    Marked = needs_legal_review(Reason, [ReliedItem, provenance(daily_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)])]),
    Marked = needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs), provenance(Clause, Citations)]),
    InputKey == on_call_on_site_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    Pairs == [on_call_on_site_counts_as_working_time - unsure],
    Clause == daily_rest_status_step_2c,
    Citations == [cite(eu_dir_2003_88_art_2_1)].
test(an_unsure_judgement_still_asks_for_a_missing_category) :-
    subject_status(on_call_on_site_unsure_missing_category, indeterminate([worker_category]) - []).
test(an_unsure_standby_judgement_relies_on_both_present_keys) :-
    subject_shortest(on_call_standby_unsure, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])])).
test(the_measuring_query_names_the_standby_key_first) :-
    subject_shortest(standby_behind_worker, indeterminate([on_call_standby_counts_as_working_time])).
test(the_status_is_given_whatever_the_on_call_keys) :-
    subject_status(standby_behind_worker, daily_rest_given - _).
test(the_status_names_the_on_site_key_first) :-
    subject_status(standby_behind_short_worker, indeterminate([on_call_on_site_counts_as_working_time]) - []).
test(no_work_start_in_the_period) :-
    subject_shortest(no_work_worker, no_work_start_in_period),
    subject_status(no_work_worker, daily_rest_given - _).
test(a_single_shift_has_a_window) :-
    subject_shortest(single_shift_worker, 930).
test(a_period_start_that_cuts_a_shift_opens_a_window) :-
    subject_shortest(period_cut_worker, 1080).
test(the_window_at_the_period_start_can_be_short) :-
    subject_first_window(period_cut_short_worker, date_time(2026, 3, 2, 0, 0)).
test(leave_counts_as_rest) :-
    subject_status(leave_as_rest_worker, daily_rest_given - _).
test(leave_replaced_by_work_is_short) :-
    subject_status(leave_replaced_by_work_worker, daily_rest_not_given - _).
test(a_malformed_profile_gives_its_problems_first) :-
    subject_status(malformed_profile_worker, input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]) - []).
test(a_reversed_period_is_a_problem) :-
    subject_status(reversed_period_worker, input_problems([wrong_type(period_end)]) - []).
test(a_well_formed_profile_has_no_problem) :-
    daily_rest_input_problems([attribute(worker_category, other_worker), attribute(derogation_from_article_3, no_derogation)], Problems),
    Problems == [].
test(a_list_of_non_attributes_is_not_an_attribute_list) :-
    daily_rest_input_problems([colour], Problems),
    Problems == [wrong_type(profile)].
test(a_number_key_is_an_unknown_key) :-
    daily_rest_input_problems([attribute(1, red)], Problems),
    Problems == [unknown_key(1)].
test(an_unbound_worker_is_an_input_problem) :-
    findall(Result - Citations, daily_rest_status([], _, [], date(2026, 3, 2), date(2026, 3, 2), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(worker)]) - []].
test(the_status_values_are_the_four_final_atoms) :-
    daily_rest_status_values(Values),
    msort(Values, Sorted),
    Sorted == [daily_rest_derogation_applies, daily_rest_given, daily_rest_not_applied_to_worker, daily_rest_not_given].
test(the_checklist_is_not_empty) :-
    subject_checklist(day_shift_worker, [_FirstItem|_OtherItems]).
test(the_checklist_of_a_short_rest_is_not_empty) :-
    subject_checklist(short_rest_worker, [_FirstItem|_OtherItems]).
test(a_final_answer_is_resolvable) :-
    subject_resolvable(day_shift_worker).

one_case(Subject) :-
    findall(Case, daily_rest_profile_for(Subject, Case), Cases),
    length(Cases, 1).

test(day_shifts_are_not_short, fail) :-
    subject_status(day_shift_worker, daily_rest_not_given - _).
test(a_short_rest_is_not_given_rest, fail) :-
    subject_status(short_rest_worker, daily_rest_given - _).
test(exactly_eleven_hours_are_not_short, fail) :-
    subject_status(eleven_hour_rest_worker, daily_rest_not_given - _).
test(one_minute_under_eleven_hours_is_not_given, fail) :-
    subject_status(one_minute_short_rest_worker, daily_rest_given - _).
test(a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, fail) :-
    subject_status(mobile_worker_day_shifts, daily_rest_not_applied_to_worker - _).
test(a_derogation_on_day_shifts_is_not_applied, fail) :-
    subject_status(derogation_article_17_4_day_shifts, daily_rest_derogation_applies - _).
test(a_missing_category_on_day_shifts_is_not_indeterminate, fail) :-
    subject_status(missing_category_day_shifts, indeterminate(_) - _).
test(on_site_time_not_counted_is_not_short, fail) :-
    subject_status(on_call_on_site_not_counted, daily_rest_not_given - _).
test(a_provenance_marker_has_two_arguments, fail) :-
    provenance_marker_with_one_argument(provenance(daily_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)])).
test(the_measuring_query_does_not_name_the_on_site_key, fail) :-
    subject_shortest(standby_behind_worker, indeterminate([on_call_on_site_counts_as_working_time])).
test(a_single_shift_has_work_in_the_period, fail) :-
    subject_shortest(single_shift_worker, no_work_start_in_period).
test(leave_replaced_by_work_is_not_given, fail) :-
    subject_status(leave_replaced_by_work_worker, daily_rest_given - _).
test(an_indeterminate_answer_is_not_resolvable, fail) :-
    subject_resolvable(missing_category_short_rest).

provenance_marker_with_one_argument(Marker) :-
    functor(Marker, provenance, 1).

cp_test_names([every_subject_has_one_case, every_subject_resolves_to_its_expected_status, every_subject_resolves_to_its_expected_shortest_rest, every_subject_resolves_to_its_expected_first_short_window, every_subject_assesses_to_its_expected_verdict, day_shifts_give_the_daily_rest, a_short_rest_is_not_given, exactly_eleven_hours_hold_the_daily_rest, one_minute_under_eleven_hours_is_short, the_boundary_has_no_short_window, a_mobile_worker_with_a_short_rest_is_not_applied, a_mobile_worker_on_day_shifts_is_given_the_rest, a_fishing_vessel_worker_with_a_short_rest_is_not_applied, a_fishing_vessel_worker_on_day_shifts_is_given_the_rest, a_derogation_under_article_18_cites_both_subparagraphs, a_derogation_on_day_shifts_is_given_the_rest, a_missing_category_is_asked_for_when_the_rest_is_short, a_missing_category_is_not_asked_for_when_the_rest_is_given, a_missing_derogation_is_asked_for_an_ordinary_worker, a_mobile_worker_needs_no_derogation_answer, an_absent_on_site_key_is_named_by_every_query, counted_on_site_time_shortens_the_rest, on_site_time_not_counted_is_rest, an_unsure_on_site_judgement_goes_to_a_lawyer, a_referral_may_carry_a_trailing_provenance_marker, an_unsure_judgement_still_asks_for_a_missing_category, an_unsure_standby_judgement_relies_on_both_present_keys, the_measuring_query_names_the_standby_key_first, the_status_is_given_whatever_the_on_call_keys, the_status_names_the_on_site_key_first, no_work_start_in_the_period, a_single_shift_has_a_window, a_period_start_that_cuts_a_shift_opens_a_window, the_window_at_the_period_start_can_be_short, leave_counts_as_rest, leave_replaced_by_work_is_short, a_malformed_profile_gives_its_problems_first, a_reversed_period_is_a_problem, a_well_formed_profile_has_no_problem, a_list_of_non_attributes_is_not_an_attribute_list, a_number_key_is_an_unknown_key, an_unbound_worker_is_an_input_problem, the_status_values_are_the_four_final_atoms, the_checklist_is_not_empty, the_checklist_of_a_short_rest_is_not_empty, a_final_answer_is_resolvable]).
cp_test_fail_names([day_shifts_are_not_short, a_short_rest_is_not_given_rest, exactly_eleven_hours_are_not_short, one_minute_under_eleven_hours_is_not_given, a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, a_derogation_on_day_shifts_is_not_applied, a_missing_category_on_day_shifts_is_not_indeterminate, on_site_time_not_counted_is_not_short, a_provenance_marker_has_two_arguments, the_measuring_query_does_not_name_the_on_site_key, a_single_shift_has_work_in_the_period, leave_replaced_by_work_is_not_given, an_indeterminate_answer_is_not_resolvable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
