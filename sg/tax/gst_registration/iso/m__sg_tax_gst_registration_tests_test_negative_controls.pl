% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_gst_registration, [gst_retrospective_liability/2, gst_prospective_liability/2]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_profile_for/2]).

test(already_registered_route_positive) :-
    gst_registration_profile_for(retrospective_already_registered_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(already_registered, _, _, _, _)).
test(not_liable_route_positive) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable, _, _, _, _)).
test(comptroller_satisfied_route_positive) :-
    gst_registration_profile_for(retrospective_comptroller_satisfied_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable_comptroller_satisfied, _, _, _, _)).
test(zero_rated_route_positive) :-
    gst_registration_profile_for(retrospective_zero_rated_exemption_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(exempted_zero_rated, _, _, _, _)).
test(liable_route_positive) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, _, _, _, _)).
test(prospective_not_liable_route_positive) :-
    gst_registration_profile_for(prospective_not_liable_at_threshold_pre_cutover, Profile),
    gst_prospective_liability(Profile, gst_prospective(not_liable, _, _, _, _)).
test(prospective_zero_rated_route_positive) :-
    gst_registration_profile_for(prospective_zero_rated_exemption_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(exempted_zero_rated, _, _, _, _)).
test(prospective_liable_route_positive) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, _, _, _, _)).
test(indeterminate_route_positive) :-
    gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(indeterminate, _, _, _, _)).
test(prospective_indeterminate_route_positive) :-
    gst_registration_profile_for(prospective_indeterminate_missing_forecast_start_date, Profile),
    gst_prospective_liability(Profile, gst_prospective(indeterminate, _, _, _, _)).

test(already_registered_near_miss_unregistered_is_not_already_registered, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(already_registered, _, _, _, _)).
test(not_liable_near_miss_one_cent_above_is_not_not_liable, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable, _, _, _, _)).
test(comptroller_satisfied_near_miss_no_relief_is_not_comptroller_satisfied, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(not_liable_comptroller_satisfied, _, _, _, _)).
test(zero_rated_near_miss_no_exemption_is_not_exempted, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(exempted_zero_rated, _, _, _, _)).
test(liable_near_miss_at_threshold_is_not_liable, fail) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, _, _, _, _)).
test(prospective_not_liable_near_miss_above_is_not_not_liable, fail) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(not_liable, _, _, _, _)).
test(prospective_zero_rated_near_miss_no_exemption_is_not_exempted, fail) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(exempted_zero_rated, _, _, _, _)).
test(prospective_liable_near_miss_at_threshold_is_not_liable, fail) :-
    gst_registration_profile_for(prospective_not_liable_at_threshold_pre_cutover, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, _, _, _, _)).
test(indeterminate_near_miss_present_is_not_indeterminate, fail) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(indeterminate, _, _, _, _)).
test(prospective_indeterminate_near_miss_present_is_not_indeterminate, fail) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(indeterminate, _, _, _, _)).

cp_test_names([already_registered_route_positive, not_liable_route_positive, comptroller_satisfied_route_positive, zero_rated_route_positive, liable_route_positive, prospective_not_liable_route_positive, prospective_zero_rated_route_positive, prospective_liable_route_positive, indeterminate_route_positive, prospective_indeterminate_route_positive]).
cp_test_fail_names([already_registered_near_miss_unregistered_is_not_already_registered, not_liable_near_miss_one_cent_above_is_not_not_liable, comptroller_satisfied_near_miss_no_relief_is_not_comptroller_satisfied, zero_rated_near_miss_no_exemption_is_not_exempted, liable_near_miss_at_threshold_is_not_liable, prospective_not_liable_near_miss_above_is_not_not_liable, prospective_zero_rated_near_miss_no_exemption_is_not_exempted, prospective_liable_near_miss_at_threshold_is_not_liable, indeterminate_near_miss_present_is_not_indeterminate, prospective_indeterminate_near_miss_present_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
