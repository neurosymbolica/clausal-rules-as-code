% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_night_work, [night_work_average_status/7, hazardous_night_work_status/7, decide_night_work/2, night_work_status/2, night_work_checklist/2, night_work_decision_resolvable/1, night_work_status_values/1]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_subject/1, night_work_profile_for/2, night_work_assess/2]).

expected_status(average_at_the_limit_kept, average_night_hours_kept).
expected_status(average_one_minute_over_exceeded, average_night_hours_exceeded).
expected_status(average_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker).
expected_status(average_mobile_worker_at_the_limit_kept, average_night_hours_kept).
expected_status(average_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker).
expected_status(average_not_a_night_worker, not_a_night_worker).
expected_status(average_derogation_under_article_17_1, night_work_derogation_applies).
expected_status(average_derogation_under_article_17_3, night_work_derogation_applies).
expected_status(average_derogation_under_article_18, night_work_derogation_applies).
expected_status(average_absent_reference_period_asked, indeterminate([night_work_reference_period_days])).
expected_status(average_one_day_reference_period_kept, average_night_hours_kept).
expected_status(average_category_named_before_derogation, indeterminate([worker_category])).
expected_status(average_derogation_named_once_category_stated, indeterminate([derogation_from_article_8])).
expected_status(average_unsure_night_worker_referred, needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - false, night_worker - unsure])])).
expected_status(average_absent_on_site_key_asked, indeterminate([on_call_on_site_counts_as_working_time])).
expected_status(average_on_site_counted_exceeded, average_night_hours_exceeded).
expected_status(average_on_site_not_counted_kept, average_night_hours_kept).
expected_status(average_leave_not_counted_kept, average_night_hours_kept).
expected_status(average_same_hours_worked_exceeded, average_night_hours_exceeded).
expected_status(average_cut_last_block_exceeded, average_night_hours_exceeded).
expected_status(average_cut_last_block_at_the_limit_kept, average_night_hours_kept).
expected_status(average_unknown_key_problem, input_problems([unknown_key(colour)])).
expected_status(average_period_end_before_start_problem, input_problems([wrong_type(period_end)])).
expected_status(hazardous_eight_hours_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_no_special_hazards, no_special_hazards_or_heavy_strain).
expected_status(hazardous_not_a_night_worker, not_a_night_worker).
expected_status(hazardous_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker).
expected_status(hazardous_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker).
expected_status(hazardous_derogation_under_article_18, night_work_derogation_applies).
expected_status(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_day_shift_one_night_minute_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_shift_from_night_end_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_shift_one_minute_before_night_end_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_window_past_period_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_touching_rows_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_touching_rows_at_the_limit_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_absent_night_time_asked, indeterminate([night_time_start])).
expected_status(hazardous_stated_night_time_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_unsure_standby_referred, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - unsure, night_worker - true, special_hazards_or_heavy_strain - true])])).
expected_status(hazardous_standby_counted_exceeded, hazardous_night_work_hours_exceeded).
expected_status(hazardous_standby_not_counted_kept, hazardous_night_work_hours_kept).
expected_status(hazardous_float_worker_problem, input_problems([wrong_type(worker)])).

status_of(Subject, Status) :-
    night_work_assess(Subject, night_work_verdict(Status, _)).

same_citations(Subject, Expected) :-
    night_work_assess(Subject, night_work_verdict(_, Citations)),
    sort(Citations, Actual),
    sort(Expected, SortedExpected),
    Actual == SortedExpected.

single_answer(Subject) :-
    findall(Verdict, night_work_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

has_checklist(Subject) :-
    night_work_profile_for(Subject, Case),
    night_work_checklist(Case, [_|_]).

resolvable(Subject) :-
    night_work_profile_for(Subject, Case),
    night_work_decision_resolvable(Case).

direct_average(Subject, Answers) :-
    night_work_profile_for(Subject, average_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, night_work_average_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers).

direct_hazardous(Subject, Answers) :-
    night_work_profile_for(Subject, hazardous_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, hazardous_night_work_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers).

final_status(average_night_hours_kept).
final_status(average_night_hours_exceeded).
final_status(hazardous_night_work_hours_kept).
final_status(hazardous_night_work_hours_exceeded).
final_status(night_work_limits_not_applied_to_worker).
final_status(not_a_night_worker).
final_status(no_special_hazards_or_heavy_strain).
final_status(night_work_derogation_applies).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (night_work_subject(Subject), status_of(Subject, Status)), Actual),
    findall(Subject - Status, (night_work_subject(Subject), expected_status(Subject, Status)), Expected),
    Actual == Expected.
test(every_subject_yields_exactly_one_answer) :-
    findall(Subject, night_work_subject(Subject), Subjects),
    maplist(single_answer, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, night_work_subject(Subject), Subjects),
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, night_work_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(every_final_status_is_a_published_status_value) :-
    night_work_status_values(Values),
    findall(Status, (expected_status(_, Status), final_status(Status)), Statuses),
    sort(Statuses, Distinct),
    findall(Status, (member(Status, Distinct), member(Status, Values)), Published),
    Published == Distinct.
test(the_status_projection_agrees_with_the_verdict) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    night_work_status(Case, average_night_hours_exceeded),
    decide_night_work(Case, night_work_verdict(average_night_hours_exceeded, [_|_])).
test(night_work_average_status_kept_with_literal_date_terms) :-
    PeriodStart = date(2026, 3, 2),
    PeriodEnd = date(2026, 3, 8),
    PeriodStart = date(Year, Month, Day),
    Year == 2026,
    Month == 3,
    Day == 2,
    findall(Result, night_work_average_status([], worker_1, [], PeriodStart, PeriodEnd, Result, _), Results),
    Results == [average_night_hours_kept].
test(night_work_average_status_kept) :-
    direct_average(average_at_the_limit_kept, [average_night_hours_kept - [_|_]]).
test(night_work_average_status_exceeded) :-
    direct_average(average_one_minute_over_exceeded, [average_night_hours_exceeded - [_|_]]).
test(night_work_average_status_limits_not_applied) :-
    direct_average(average_mobile_worker_outside_article_8, [night_work_limits_not_applied_to_worker - Citations]),
    Citations == [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)].
test(night_work_average_status_not_a_night_worker) :-
    direct_average(average_not_a_night_worker, [not_a_night_worker - _]).
test(night_work_average_status_derogation) :-
    direct_average(average_derogation_under_article_17_1, [night_work_derogation_applies - _]).
test(night_work_average_status_indeterminate) :-
    direct_average(average_absent_reference_period_asked, [indeterminate([night_work_reference_period_days]) - []]).
test(night_work_average_status_needs_legal_review) :-
    direct_average(average_unsure_night_worker_referred, [needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), [inputs_relied_on(_)]) - []]).
test(night_work_average_status_input_problems) :-
    direct_average(average_period_end_before_start_problem, [input_problems([wrong_type(period_end)]) - []]).
test(hazardous_night_work_status_kept_with_literal_date_terms) :-
    findall(Result, hazardous_night_work_status([], worker_1, [], date(2026, 3, 2), date(2026, 3, 2), Result, _), Results),
    Results == [hazardous_night_work_hours_kept].
test(hazardous_night_work_status_kept) :-
    direct_hazardous(hazardous_eight_hours_kept, [hazardous_night_work_hours_kept - [_|_]]).
test(hazardous_night_work_status_exceeded) :-
    direct_hazardous(hazardous_one_minute_over_exceeded, [hazardous_night_work_hours_exceeded - [_|_]]).
test(hazardous_night_work_status_limits_not_applied) :-
    direct_hazardous(hazardous_fishing_vessel_worker_outside_article_8, [night_work_limits_not_applied_to_worker - Citations]),
    Citations == [cite(eu_dir_2003_88_art_21_1)].
test(hazardous_night_work_status_not_a_night_worker) :-
    direct_hazardous(hazardous_not_a_night_worker, [not_a_night_worker - _]).
test(hazardous_night_work_status_no_special_hazards) :-
    direct_hazardous(hazardous_no_special_hazards, [no_special_hazards_or_heavy_strain - _]).
test(hazardous_night_work_status_derogation) :-
    direct_hazardous(hazardous_derogation_under_article_18, [night_work_derogation_applies - _]).
test(hazardous_night_work_status_indeterminate) :-
    direct_hazardous(hazardous_absent_night_time_asked, [indeterminate([night_time_start]) - []]).
test(hazardous_night_work_status_needs_legal_review) :-
    direct_hazardous(hazardous_unsure_standby_referred, [needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(_)]) - []]).
test(hazardous_night_work_status_input_problems) :-
    direct_hazardous(hazardous_float_worker_problem, [input_problems([wrong_type(worker)]) - []]).
test(the_date_constructor_names_the_period) :-
    night_work_profile_for(average_at_the_limit_kept, average_case(_, _, _, PeriodStart, PeriodEnd)),
    PeriodStart == date(2026, 3, 2),
    PeriodEnd == date(2026, 3, 8).
test(the_optional_provenance_element_builds_and_destructures) :-
    Context = [inputs_relied_on([night_worker - unsure]), provenance(step_3, [cite(eu_dir_2003_88_art_2_4)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, Citations)],
    Pairs == [night_worker - unsure],
    Clause == step_3,
    Citations == [cite(eu_dir_2003_88_art_2_4)].
test(the_referral_context_scored_part_is_inputs_relied_on) :-
    direct_average(average_unsure_night_worker_referred, [needs_legal_review(_, [First|_]) - []]),
    First = inputs_relied_on(_).
test(average_at_the_limit_kept) :-
    status_of(average_at_the_limit_kept, average_night_hours_kept).
test(average_one_minute_over_exceeded) :-
    status_of(average_one_minute_over_exceeded, average_night_hours_exceeded).
test(average_kept_citations) :-
    same_citations(average_at_the_limit_kept, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)]).
test(average_exceeded_citations) :-
    same_citations(average_one_minute_over_exceeded, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)]).
test(average_mobile_worker_outside_article_8) :-
    status_of(average_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker),
    same_citations(average_mobile_worker_outside_article_8, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(average_mobile_worker_at_the_limit_kept) :-
    status_of(average_mobile_worker_at_the_limit_kept, average_night_hours_kept).
test(average_fishing_vessel_worker_outside_article_8) :-
    status_of(average_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker),
    same_citations(average_fishing_vessel_worker_outside_article_8, [cite(eu_dir_2003_88_art_21_1)]).
test(average_not_a_night_worker) :-
    status_of(average_not_a_night_worker, not_a_night_worker),
    same_citations(average_not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_a)]).
test(average_derogation_under_article_17_1) :-
    status_of(average_derogation_under_article_17_1, night_work_derogation_applies),
    same_citations(average_derogation_under_article_17_1, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_1)]).
test(average_derogation_under_article_17_3) :-
    status_of(average_derogation_under_article_17_3, night_work_derogation_applies),
    same_citations(average_derogation_under_article_17_3, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_3)]).
test(average_derogation_under_article_18) :-
    status_of(average_derogation_under_article_18, night_work_derogation_applies),
    same_citations(average_derogation_under_article_18, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
test(average_absent_reference_period_asked) :-
    status_of(average_absent_reference_period_asked, indeterminate([night_work_reference_period_days])),
    same_citations(average_absent_reference_period_asked, []).
test(average_one_day_reference_period_kept) :-
    status_of(average_one_day_reference_period_kept, average_night_hours_kept).
test(average_category_named_before_derogation) :-
    status_of(average_category_named_before_derogation, indeterminate([worker_category])).
test(average_derogation_named_once_category_stated) :-
    status_of(average_derogation_named_once_category_stated, indeterminate([derogation_from_article_8])).
test(average_unsure_night_worker_referred) :-
    expected_status(average_unsure_night_worker_referred, Expected),
    status_of(average_unsure_night_worker_referred, Actual),
    Actual == Expected,
    same_citations(average_unsure_night_worker_referred, []).
test(average_absent_on_site_key_asked) :-
    status_of(average_absent_on_site_key_asked, indeterminate([on_call_on_site_counts_as_working_time])).
test(average_on_site_counted_exceeded) :-
    status_of(average_on_site_counted_exceeded, average_night_hours_exceeded).
test(average_on_site_not_counted_kept) :-
    status_of(average_on_site_not_counted_kept, average_night_hours_kept).
test(average_leave_not_counted_kept) :-
    status_of(average_leave_not_counted_kept, average_night_hours_kept).
test(average_same_hours_worked_exceeded) :-
    status_of(average_same_hours_worked_exceeded, average_night_hours_exceeded).
test(average_cut_last_block_exceeded) :-
    status_of(average_cut_last_block_exceeded, average_night_hours_exceeded).
test(average_cut_last_block_at_the_limit_kept) :-
    status_of(average_cut_last_block_at_the_limit_kept, average_night_hours_kept).
test(average_unknown_key_problem) :-
    status_of(average_unknown_key_problem, input_problems([unknown_key(colour)])),
    same_citations(average_unknown_key_problem, []).
test(average_period_end_before_start_problem) :-
    status_of(average_period_end_before_start_problem, input_problems([wrong_type(period_end)])).
test(hazardous_eight_hours_kept) :-
    status_of(hazardous_eight_hours_kept, hazardous_night_work_hours_kept),
    same_citations(hazardous_eight_hours_kept, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]).
test(hazardous_one_minute_over_exceeded) :-
    status_of(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_exceeded),
    same_citations(hazardous_one_minute_over_exceeded, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]).
test(hazardous_no_special_hazards) :-
    status_of(hazardous_no_special_hazards, no_special_hazards_or_heavy_strain),
    same_citations(hazardous_no_special_hazards, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]).
test(hazardous_not_a_night_worker) :-
    status_of(hazardous_not_a_night_worker, not_a_night_worker),
    same_citations(hazardous_not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_b)]).
test(hazardous_mobile_worker_outside_article_8) :-
    status_of(hazardous_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker),
    same_citations(hazardous_mobile_worker_outside_article_8, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(hazardous_fishing_vessel_worker_outside_article_8) :-
    status_of(hazardous_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker),
    same_citations(hazardous_fishing_vessel_worker_outside_article_8, [cite(eu_dir_2003_88_art_21_1)]).
test(hazardous_derogation_under_article_18) :-
    status_of(hazardous_derogation_under_article_18, night_work_derogation_applies),
    same_citations(hazardous_derogation_under_article_18, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
test(hazardous_day_shift_ending_at_night_start_kept) :-
    status_of(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_kept).
test(hazardous_day_shift_one_night_minute_exceeded) :-
    status_of(hazardous_day_shift_one_night_minute_exceeded, hazardous_night_work_hours_exceeded).
test(hazardous_shift_from_night_end_kept) :-
    status_of(hazardous_shift_from_night_end_kept, hazardous_night_work_hours_kept).
test(hazardous_shift_one_minute_before_night_end_exceeded) :-
    status_of(hazardous_shift_one_minute_before_night_end_exceeded, hazardous_night_work_hours_exceeded).
test(hazardous_window_past_period_exceeded) :-
    status_of(hazardous_window_past_period_exceeded, hazardous_night_work_hours_exceeded).
test(hazardous_window_past_period_at_the_limit_kept) :-
    status_of(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_kept).
test(hazardous_touching_rows_exceeded) :-
    status_of(hazardous_touching_rows_exceeded, hazardous_night_work_hours_exceeded).
test(hazardous_touching_rows_at_the_limit_kept) :-
    status_of(hazardous_touching_rows_at_the_limit_kept, hazardous_night_work_hours_kept).
test(hazardous_absent_night_time_asked) :-
    status_of(hazardous_absent_night_time_asked, indeterminate([night_time_start])),
    same_citations(hazardous_absent_night_time_asked, []).
test(hazardous_stated_night_time_kept) :-
    status_of(hazardous_stated_night_time_kept, hazardous_night_work_hours_kept).
test(hazardous_unsure_standby_referred) :-
    expected_status(hazardous_unsure_standby_referred, Expected),
    status_of(hazardous_unsure_standby_referred, Actual),
    Actual == Expected,
    same_citations(hazardous_unsure_standby_referred, []).
test(hazardous_standby_counted_exceeded) :-
    status_of(hazardous_standby_counted_exceeded, hazardous_night_work_hours_exceeded).
test(hazardous_standby_not_counted_kept) :-
    status_of(hazardous_standby_not_counted_kept, hazardous_night_work_hours_kept).
test(hazardous_float_worker_problem) :-
    status_of(hazardous_float_worker_problem, input_problems([wrong_type(worker)])),
    same_citations(hazardous_float_worker_problem, []).

test(night_work_average_status_kept_is_not_exceeded, fail) :-
    direct_average(average_at_the_limit_kept, [average_night_hours_exceeded - _]).
test(hazardous_night_work_status_kept_is_not_exceeded, fail) :-
    direct_hazardous(hazardous_eight_hours_kept, [hazardous_night_work_hours_exceeded - _]).
test(average_at_the_limit_is_not_exceeded, fail) :-
    status_of(average_at_the_limit_kept, average_night_hours_exceeded).
test(average_one_minute_over_is_not_kept, fail) :-
    status_of(average_one_minute_over_exceeded, average_night_hours_kept).
test(average_mobile_worker_at_the_limit_is_not_outside, fail) :-
    status_of(average_mobile_worker_at_the_limit_kept, night_work_limits_not_applied_to_worker).
test(average_not_a_night_worker_is_not_exceeded, fail) :-
    status_of(average_not_a_night_worker, average_night_hours_exceeded).
test(average_derogation_is_not_exceeded, fail) :-
    status_of(average_derogation_under_article_18, average_night_hours_exceeded).
test(average_one_day_reference_period_is_not_asked, fail) :-
    status_of(average_one_day_reference_period_kept, indeterminate(_)).
test(average_derogation_behind_the_category_is_not_named, fail) :-
    status_of(average_category_named_before_derogation, indeterminate([derogation_from_article_8])).
test(average_on_site_not_counted_is_not_exceeded, fail) :-
    status_of(average_on_site_not_counted_kept, average_night_hours_exceeded).
test(average_leave_is_not_exceeded, fail) :-
    status_of(average_leave_not_counted_kept, average_night_hours_exceeded).
test(average_cut_last_block_at_the_limit_is_not_exceeded, fail) :-
    status_of(average_cut_last_block_at_the_limit_kept, average_night_hours_exceeded).
test(average_period_end_before_start_is_not_kept, fail) :-
    status_of(average_period_end_before_start_problem, average_night_hours_kept).
test(hazardous_eight_hours_is_not_exceeded, fail) :-
    status_of(hazardous_eight_hours_kept, hazardous_night_work_hours_exceeded).
test(hazardous_one_minute_over_is_not_kept, fail) :-
    status_of(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_kept).
test(hazardous_no_special_hazards_is_not_exceeded, fail) :-
    status_of(hazardous_no_special_hazards, hazardous_night_work_hours_exceeded).
test(hazardous_day_shift_ending_at_night_start_is_not_exceeded, fail) :-
    status_of(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_exceeded).
test(hazardous_shift_from_night_end_is_not_exceeded, fail) :-
    status_of(hazardous_shift_from_night_end_kept, hazardous_night_work_hours_exceeded).
test(hazardous_window_past_period_at_the_limit_is_not_exceeded, fail) :-
    status_of(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_exceeded).
test(hazardous_touching_rows_are_not_an_input_problem, fail) :-
    status_of(hazardous_touching_rows_exceeded, input_problems(_)).
test(hazardous_stated_night_time_is_not_asked, fail) :-
    status_of(hazardous_stated_night_time_kept, indeterminate(_)).
test(hazardous_standby_not_counted_is_not_exceeded, fail) :-
    status_of(hazardous_standby_not_counted_kept, hazardous_night_work_hours_exceeded).
test(hazardous_float_worker_is_not_exceeded, fail) :-
    status_of(hazardous_float_worker_problem, hazardous_night_work_hours_exceeded).

cp_test_names([every_subject_resolves_to_its_expected_status, every_subject_yields_exactly_one_answer, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_final_status_is_a_published_status_value, the_status_projection_agrees_with_the_verdict, night_work_average_status_kept_with_literal_date_terms, night_work_average_status_kept, night_work_average_status_exceeded, night_work_average_status_limits_not_applied, night_work_average_status_not_a_night_worker, night_work_average_status_derogation, night_work_average_status_indeterminate, night_work_average_status_needs_legal_review, night_work_average_status_input_problems, hazardous_night_work_status_kept_with_literal_date_terms, hazardous_night_work_status_kept, hazardous_night_work_status_exceeded, hazardous_night_work_status_limits_not_applied, hazardous_night_work_status_not_a_night_worker, hazardous_night_work_status_no_special_hazards, hazardous_night_work_status_derogation, hazardous_night_work_status_indeterminate, hazardous_night_work_status_needs_legal_review, hazardous_night_work_status_input_problems, the_date_constructor_names_the_period, the_optional_provenance_element_builds_and_destructures, the_referral_context_scored_part_is_inputs_relied_on, average_at_the_limit_kept, average_one_minute_over_exceeded, average_kept_citations, average_exceeded_citations, average_mobile_worker_outside_article_8, average_mobile_worker_at_the_limit_kept, average_fishing_vessel_worker_outside_article_8, average_not_a_night_worker, average_derogation_under_article_17_1, average_derogation_under_article_17_3, average_derogation_under_article_18, average_absent_reference_period_asked, average_one_day_reference_period_kept, average_category_named_before_derogation, average_derogation_named_once_category_stated, average_unsure_night_worker_referred, average_absent_on_site_key_asked, average_on_site_counted_exceeded, average_on_site_not_counted_kept, average_leave_not_counted_kept, average_same_hours_worked_exceeded, average_cut_last_block_exceeded, average_cut_last_block_at_the_limit_kept, average_unknown_key_problem, average_period_end_before_start_problem, hazardous_eight_hours_kept, hazardous_one_minute_over_exceeded, hazardous_no_special_hazards, hazardous_not_a_night_worker, hazardous_mobile_worker_outside_article_8, hazardous_fishing_vessel_worker_outside_article_8, hazardous_derogation_under_article_18, hazardous_day_shift_ending_at_night_start_kept, hazardous_day_shift_one_night_minute_exceeded, hazardous_shift_from_night_end_kept, hazardous_shift_one_minute_before_night_end_exceeded, hazardous_window_past_period_exceeded, hazardous_window_past_period_at_the_limit_kept, hazardous_touching_rows_exceeded, hazardous_touching_rows_at_the_limit_kept, hazardous_absent_night_time_asked, hazardous_stated_night_time_kept, hazardous_unsure_standby_referred, hazardous_standby_counted_exceeded, hazardous_standby_not_counted_kept, hazardous_float_worker_problem]).
cp_test_fail_names([night_work_average_status_kept_is_not_exceeded, hazardous_night_work_status_kept_is_not_exceeded, average_at_the_limit_is_not_exceeded, average_one_minute_over_is_not_kept, average_mobile_worker_at_the_limit_is_not_outside, average_not_a_night_worker_is_not_exceeded, average_derogation_is_not_exceeded, average_one_day_reference_period_is_not_asked, average_derogation_behind_the_category_is_not_named, average_on_site_not_counted_is_not_exceeded, average_leave_is_not_exceeded, average_cut_last_block_at_the_limit_is_not_exceeded, average_period_end_before_start_is_not_kept, hazardous_eight_hours_is_not_exceeded, hazardous_one_minute_over_is_not_kept, hazardous_no_special_hazards_is_not_exceeded, hazardous_day_shift_ending_at_night_start_is_not_exceeded, hazardous_shift_from_night_end_is_not_exceeded, hazardous_window_past_period_at_the_limit_is_not_exceeded, hazardous_touching_rows_are_not_an_input_problem, hazardous_stated_night_time_is_not_asked, hazardous_standby_not_counted_is_not_exceeded, hazardous_float_worker_is_not_exceeded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
