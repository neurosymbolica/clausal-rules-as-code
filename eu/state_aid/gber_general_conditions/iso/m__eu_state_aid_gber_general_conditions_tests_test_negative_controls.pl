% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [gber_general_conditions_status/2, gber_general_conditions_status_values/1]).
:- use_module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_profile_for/2]).

subject_status(Subject, Status) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    gber_general_conditions_status(SubjectCase, Status).

status_in_table(Status) :-
    gber_general_conditions_status_values(StatusValues),
    member(Status, StatusValues).

test(met_is_a_table_status) :-
    status_in_table(tested_chapter_i_conditions_met).
test(not_met_is_a_table_status) :-
    status_in_table(chapter_i_conditions_not_met).
test(partly_untested_is_a_table_status) :-
    status_in_table(chapter_i_conditions_partly_untested).
test(threshold_at_the_figure_is_met) :-
    subject_status(threshold_at_figure, tested_chapter_i_conditions_met).
test(threshold_one_cent_over_is_not_met) :-
    subject_status(threshold_one_cent_over, chapter_i_conditions_not_met).
test(a_doubled_research_project_is_met) :-
    subject_status(doubled_industrial_research, tested_chapter_i_conditions_met).
test(the_same_project_undoubled_is_not_met) :-
    subject_status(undoubled_industrial_research, chapter_i_conditions_not_met).
test(twice_the_figure_is_met) :-
    subject_status(doubled_research_at_twice_figure, tested_chapter_i_conditions_met).
test(one_cent_over_twice_the_figure_is_not_met) :-
    subject_status(doubled_research_one_cent_over_twice, chapter_i_conditions_not_met).
test(de_minimis_at_the_intensity_is_met) :-
    subject_status(de_minimis_at_intensity, tested_chapter_i_conditions_met).
test(de_minimis_one_cent_over_is_not_met) :-
    subject_status(de_minimis_one_cent_over, chapter_i_conditions_not_met).
test(an_application_the_day_before_is_met) :-
    subject_status(application_day_before_start, tested_chapter_i_conditions_met).
test(an_application_on_the_same_day_is_not_met) :-
    subject_status(same_day_application, chapter_i_conditions_not_met).
test(a_verified_ad_hoc_large_enterprise_is_met) :-
    subject_status(ad_hoc_large_enterprise_verified, tested_chapter_i_conditions_met).
test(an_unverified_ad_hoc_large_enterprise_is_not_met) :-
    subject_status(ad_hoc_large_enterprise_unverified, chapter_i_conditions_not_met).
test(a_loan_meeting_its_condition_is_met) :-
    subject_status(transparent_loan, tested_chapter_i_conditions_met).
test(another_form_with_no_way_is_not_met) :-
    subject_status(non_transparent_other_form, chapter_i_conditions_not_met).
test(difficulty_with_the_derogation_is_met) :-
    subject_status(difficulty_with_derogation, tested_chapter_i_conditions_met).
test(difficulty_without_an_exception_is_not_met) :-
    subject_status(difficulty_without_exception, chapter_i_conditions_not_met).
test(a_recovery_order_is_not_met) :-
    subject_status(recovery_order_outstanding, chapter_i_conditions_not_met).
test(without_the_recovery_order_the_case_is_met) :-
    subject_status(compliant_sme_grant, tested_chapter_i_conditions_met).
test(an_unsure_difficulty_is_referred) :-
    subject_status(difficulty_unsure, needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), _)).
test(another_category_is_partly_untested) :-
    subject_status(other_category_row, chapter_i_conditions_partly_untested).
test(a_large_enterprise_under_a_scheme_is_met) :-
    subject_status(large_enterprise_scheme_aid, tested_chapter_i_conditions_met).
test(not_an_enterprise_is_an_input_problem) :-
    subject_status(not_an_enterprise_size, input_problems([wrong_type(size_class)])).
test(the_empty_profile_names_one_missing_key) :-
    subject_status(empty_profile, indeterminate([scheme_excluded_by_article_1_2_a_or_b])).

test(threshold_one_cent_over_is_never_met, fail) :-
    subject_status(threshold_one_cent_over, tested_chapter_i_conditions_met).
test(the_same_project_undoubled_is_never_met, fail) :-
    subject_status(undoubled_industrial_research, tested_chapter_i_conditions_met).
test(one_cent_over_twice_the_figure_is_never_met, fail) :-
    subject_status(doubled_research_one_cent_over_twice, tested_chapter_i_conditions_met).
test(de_minimis_one_cent_over_is_never_met, fail) :-
    subject_status(de_minimis_one_cent_over, tested_chapter_i_conditions_met).
test(an_application_on_the_same_day_is_never_met, fail) :-
    subject_status(same_day_application, tested_chapter_i_conditions_met).
test(an_unverified_ad_hoc_large_enterprise_is_never_met, fail) :-
    subject_status(ad_hoc_large_enterprise_unverified, tested_chapter_i_conditions_met).
test(another_form_with_no_way_is_never_met, fail) :-
    subject_status(non_transparent_other_form, tested_chapter_i_conditions_met).
test(difficulty_without_an_exception_is_never_met, fail) :-
    subject_status(difficulty_without_exception, tested_chapter_i_conditions_met).
test(a_recovery_order_is_never_met, fail) :-
    subject_status(recovery_order_outstanding, tested_chapter_i_conditions_met).
test(an_unsure_difficulty_is_never_settled_against, fail) :-
    subject_status(difficulty_unsure, chapter_i_conditions_not_met).
test(another_category_is_never_met, fail) :-
    subject_status(other_category_row, tested_chapter_i_conditions_met).
test(not_an_enterprise_is_never_met, fail) :-
    subject_status(not_an_enterprise_size, tested_chapter_i_conditions_met).
test(the_empty_profile_is_never_settled, fail) :-
    subject_status(empty_profile, chapter_i_conditions_not_met).

cp_test_names([met_is_a_table_status, not_met_is_a_table_status, partly_untested_is_a_table_status, threshold_at_the_figure_is_met, threshold_one_cent_over_is_not_met, a_doubled_research_project_is_met, the_same_project_undoubled_is_not_met, twice_the_figure_is_met, one_cent_over_twice_the_figure_is_not_met, de_minimis_at_the_intensity_is_met, de_minimis_one_cent_over_is_not_met, an_application_the_day_before_is_met, an_application_on_the_same_day_is_not_met, a_verified_ad_hoc_large_enterprise_is_met, an_unverified_ad_hoc_large_enterprise_is_not_met, a_loan_meeting_its_condition_is_met, another_form_with_no_way_is_not_met, difficulty_with_the_derogation_is_met, difficulty_without_an_exception_is_not_met, a_recovery_order_is_not_met, without_the_recovery_order_the_case_is_met, an_unsure_difficulty_is_referred, another_category_is_partly_untested, a_large_enterprise_under_a_scheme_is_met, not_an_enterprise_is_an_input_problem, the_empty_profile_names_one_missing_key]).
cp_test_fail_names([threshold_one_cent_over_is_never_met, the_same_project_undoubled_is_never_met, one_cent_over_twice_the_figure_is_never_met, de_minimis_one_cent_over_is_never_met, an_application_on_the_same_day_is_never_met, an_unverified_ad_hoc_large_enterprise_is_never_met, another_form_with_no_way_is_never_met, difficulty_without_an_exception_is_never_met, a_recovery_order_is_never_met, an_unsure_difficulty_is_never_settled_against, another_category_is_never_met, not_an_enterprise_is_never_met, the_empty_profile_is_never_settled]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
