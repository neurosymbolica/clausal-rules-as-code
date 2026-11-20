% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_gst_registration, [gst_retrospective_liability/2, gst_prospective_liability/2]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_profile_for/2]).

test(retrospective_liable_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, 100000001, date(2023, 1, 30), date(2023, 3, 1), [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a])).
test(retrospective_not_liable_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable, 100000000, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii])).
test(retrospective_already_registered_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_already_registered_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(already_registered, 100000001, n_a, n_a, [sg_gsta_1993_sch1_para_1_1])).
test(retrospective_comptroller_satisfied_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_comptroller_satisfied_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable_comptroller_satisfied, 100000001, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_1_3_b])).
test(retrospective_zero_rated_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_zero_rated_exemption_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(exempted_zero_rated, 100000001, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_15_1])).
test(retrospective_indeterminate_bound_result_succeeds) :-
    gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(indeterminate, n_a, n_a, n_a, [])).
test(prospective_pre_cutover_liable_bound_result_succeeds) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, 100000001, date(2022, 2, 14), date(2022, 2, 15), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i])).
test(prospective_post_cutover_liable_bound_result_succeeds) :-
    gst_registration_profile_for(prospective_liable_post_cutover_at_boundary, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, 100000001, date(2025, 7, 31), date(2025, 9, 1), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_ii])).
test(prospective_not_liable_bound_result_succeeds) :-
    gst_registration_profile_for(prospective_not_liable_at_threshold_pre_cutover, Profile),
    gst_prospective_liability(Profile, gst_prospective(not_liable, 100000000, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b])).
test(prospective_zero_rated_bound_result_succeeds) :-
    gst_registration_profile_for(prospective_zero_rated_exemption_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(exempted_zero_rated, 100000001, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_15_1])).
test(prospective_indeterminate_bound_result_succeeds) :-
    gst_registration_profile_for(prospective_indeterminate_missing_forecast_start_date, Profile),
    gst_prospective_liability(Profile, gst_prospective(indeterminate, n_a, n_a, n_a, [])).

test(retrospective_liable_bound_not_liable_fails, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable, 100000001, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii])).
test(prospective_pre_cutover_bound_post_cutover_fails, fail) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, 100000001, date(2022, 2, 14), date(2022, 2, 15), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_ii])).

cp_test_names([retrospective_liable_bound_result_succeeds, retrospective_not_liable_bound_result_succeeds, retrospective_already_registered_bound_result_succeeds, retrospective_comptroller_satisfied_bound_result_succeeds, retrospective_zero_rated_bound_result_succeeds, retrospective_indeterminate_bound_result_succeeds, prospective_pre_cutover_liable_bound_result_succeeds, prospective_post_cutover_liable_bound_result_succeeds, prospective_not_liable_bound_result_succeeds, prospective_zero_rated_bound_result_succeeds, prospective_indeterminate_bound_result_succeeds]).
cp_test_fail_names([retrospective_liable_bound_not_liable_fails, prospective_pre_cutover_bound_post_cutover_fails]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
