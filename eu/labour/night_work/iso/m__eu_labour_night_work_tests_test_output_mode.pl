% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_labour_night_work_night_work, [decide_night_work/2, night_work_status/2]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_subject/1, night_work_profile_for/2]).

answers(Subject, Answers) :-
    night_work_profile_for(Subject, Case),
    findall(Status - Citations, decide_night_work(Case, night_work_verdict(Status, Citations)), Answers).

same_citations(Found, Wanted) :-
    clausal_msort(Found, Sorted),
    clausal_msort(Wanted, Sorted).

average_citations([cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)]).

hazardous_citations([cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]).

mobile_citations([cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).

fishing_citations([cite(eu_dir_2003_88_art_21_1)]).

expected_answer(average_at_the_limit_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_one_minute_over_exceeded, average_night_hours_exceeded, Citations) :-
    average_citations(Citations).
expected_answer(average_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker, Citations) :-
    mobile_citations(Citations).
expected_answer(average_mobile_worker_at_the_limit_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker, Citations) :-
    fishing_citations(Citations).
expected_answer(average_not_a_night_worker, not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_a)]).
expected_answer(average_derogation_under_article_17_1, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_1)]).
expected_answer(average_derogation_under_article_17_3, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_3)]).
expected_answer(average_derogation_under_article_18, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
expected_answer(average_absent_reference_period_asked, indeterminate([night_work_reference_period_days]), []).
expected_answer(average_one_day_reference_period_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_category_named_before_derogation, indeterminate([worker_category]), []).
expected_answer(average_derogation_named_once_category_stated, indeterminate([derogation_from_article_8]), []).
expected_answer(average_unsure_night_worker_referred, needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - false, night_worker - unsure])]), []).
expected_answer(average_absent_on_site_key_asked, indeterminate([on_call_on_site_counts_as_working_time]), []).
expected_answer(average_on_site_counted_exceeded, average_night_hours_exceeded, Citations) :-
    average_citations(Citations).
expected_answer(average_on_site_not_counted_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_leave_not_counted_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_same_hours_worked_exceeded, average_night_hours_exceeded, Citations) :-
    average_citations(Citations).
expected_answer(average_cut_last_block_exceeded, average_night_hours_exceeded, Citations) :-
    average_citations(Citations).
expected_answer(average_cut_last_block_at_the_limit_kept, average_night_hours_kept, Citations) :-
    average_citations(Citations).
expected_answer(average_unknown_key_problem, input_problems([unknown_key(colour)]), []).
expected_answer(average_period_end_before_start_problem, input_problems([wrong_type(period_end)]), []).
expected_answer(hazardous_eight_hours_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_no_special_hazards, no_special_hazards_or_heavy_strain, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]).
expected_answer(hazardous_not_a_night_worker, not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_b)]).
expected_answer(hazardous_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker, Citations) :-
    mobile_citations(Citations).
expected_answer(hazardous_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker, Citations) :-
    fishing_citations(Citations).
expected_answer(hazardous_derogation_under_article_18, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
expected_answer(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_day_shift_one_night_minute_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_shift_from_night_end_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_shift_one_minute_before_night_end_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_window_past_period_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_touching_rows_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_touching_rows_at_the_limit_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_absent_night_time_asked, indeterminate([night_time_start]), []).
expected_answer(hazardous_stated_night_time_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_unsure_standby_referred, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - unsure, night_worker - true, special_hazards_or_heavy_strain - true])]), []).
expected_answer(hazardous_standby_counted_exceeded, hazardous_night_work_hours_exceeded, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_standby_not_counted_kept, hazardous_night_work_hours_kept, Citations) :-
    hazardous_citations(Citations).
expected_answer(hazardous_float_worker_problem, input_problems([wrong_type(worker)]), []).

answer_matches(Subject) :-
    expected_answer(Subject, Status, Citations),
    answers(Subject, [FoundStatus - FoundCitations]),
    FoundStatus == Status,
    same_citations(FoundCitations, Citations).

test(every_subject_has_an_expected_answer) :-
    findall(Subject, night_work_subject(Subject), Subjects),
    findall(Subject, expected_answer(Subject, _, _), Expected),
    clausal_msort(Subjects, Sorted),
    clausal_msort(Expected, Sorted).
test(every_expected_answer_is_read_out_exactly_once) :-
    findall(Subject, expected_answer(Subject, _, _), Expected),
    findall(Subject, answer_matches(Subject), Matched),
    Matched == Expected.
test(the_kept_average_reads_out_its_citations) :-
    answers(average_at_the_limit_kept, [Status - Citations]),
    Status == average_night_hours_kept,
    average_citations(Wanted),
    same_citations(Citations, Wanted).
test(the_exceeded_hazardous_limit_reads_out_its_citations) :-
    answers(hazardous_one_minute_over_exceeded, [Status - Citations]),
    Status == hazardous_night_work_hours_exceeded,
    hazardous_citations(Wanted),
    same_citations(Citations, Wanted).
test(an_indeterminate_answer_names_one_bare_key) :-
    answers(average_category_named_before_derogation, [indeterminate([Key]) - Citations]),
    atom(Key),
    Citations == [].
test(a_referral_reads_out_its_pairs_in_root_order) :-
    answers(hazardous_unsure_standby_referred, [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) - []]),
    Key == on_call_standby_counts_as_working_time,
    Citation == cite(eu_dir_2003_88_art_2_1),
    Pairs == [on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - unsure, night_worker - true, special_hazards_or_heavy_strain - true].
test(the_status_projection_reads_out_one_status) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    findall(Status, night_work_status(Case, Status), Statuses),
    Statuses == [average_night_hours_exceeded].

cp_test_names([every_subject_has_an_expected_answer, every_expected_answer_is_read_out_exactly_once, the_kept_average_reads_out_its_citations, the_exceeded_hazardous_limit_reads_out_its_citations, an_indeterminate_answer_names_one_bare_key, a_referral_reads_out_its_pairs_in_root_order, the_status_projection_reads_out_one_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
