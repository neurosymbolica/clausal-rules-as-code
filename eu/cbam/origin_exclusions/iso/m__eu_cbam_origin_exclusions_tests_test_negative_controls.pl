% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusions_status/2, origin_exclusions_status_values/1]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_profile_for/2]).

status_of(Subject, Status) :-
    origin_exclusions_profile_for(Subject, Profile),
    origin_exclusions_status(Profile, Status).

status_atom(Status) :-
    origin_exclusions_status_values(StatusValues),
    member(Status, StatusValues).

test(near_miss_atoms_are_verdict_atoms) :-
    status_atom(excluded_military_activities),
    status_atom(excluded_origin_annex_iii_point_1),
    status_atom(excluded_electricity_continental_shelf_or_eez),
    status_atom(excluded_hydrogen_continental_shelf_or_eez),
    status_atom(not_third_country_origin),
    status_atom(no_origin_exclusion).
test(route_1_positive) :-
    status_of(military_activities_yes, excluded_military_activities).
test(route_1_control_status) :-
    status_of(military_activities_no_control, no_origin_exclusion).
test(route_2_positive) :-
    status_of(origin_norway, excluded_origin_annex_iii_point_1).
test(route_2_control_status) :-
    status_of(origin_other_third_country_control, no_origin_exclusion).
test(route_3_positive) :-
    status_of(electricity_member_state_shelf, excluded_electricity_continental_shelf_or_eez).
test(route_3_control_status) :-
    status_of(electricity_other_third_country_shelf_control, no_origin_exclusion).
test(route_4_positive) :-
    status_of(electricity_iceland_shelf, excluded_electricity_continental_shelf_or_eez).
test(route_4_control_status) :-
    status_of(electricity_not_on_shelf_control, no_origin_exclusion).
test(route_5_positive) :-
    status_of(hydrogen_member_state_zone, excluded_hydrogen_continental_shelf_or_eez).
test(route_5_control_status) :-
    status_of(hydrogen_other_third_country_zone_control, no_origin_exclusion).
test(route_6_positive) :-
    status_of(hydrogen_liechtenstein_shelf, excluded_hydrogen_continental_shelf_or_eez).
test(route_6_control_status) :-
    status_of(other_goods_liechtenstein_shelf_control, no_origin_exclusion).
test(route_7_positive) :-
    status_of(member_state_origin, not_third_country_origin).
test(route_7_control_status) :-
    status_of(origin_other_third_country_control, no_origin_exclusion).
test(route_8_positive_unsure) :-
    status_of(military_activities_unsure, indeterminate([military_activities])).
test(route_8_positive_absent) :-
    status_of(military_activities_absent, indeterminate([military_activities])).
test(route_8_control_status) :-
    status_of(military_activities_no_control, no_origin_exclusion).
test(route_9_positive) :-
    status_of(origin_absent, indeterminate([non_preferential_origin])).
test(route_9_control_status) :-
    status_of(origin_other_third_country_control, no_origin_exclusion).
test(route_10_positive) :-
    status_of(goods_kind_absent_member_state_shelf, indeterminate([goods_kind])).
test(route_10_control_status) :-
    status_of(goods_kind_absent_not_on_shelf_control, no_origin_exclusion).
test(route_11_positive) :-
    status_of(electricity_shelf_absent, indeterminate([continental_shelf_or_eez_of])).
test(route_11_control_status) :-
    status_of(other_goods_shelf_absent_control, no_origin_exclusion).
test(route_12_positive) :-
    status_of(military_activities_no_control, no_origin_exclusion).
test(route_12_control_status) :-
    status_of(military_activities_yes, excluded_military_activities).
test(route_0_positive_unknown_key) :-
    status_of(unknown_key_profile, input_problems([unknown_key(colour)])).
test(route_0_positive_wrong_type) :-
    status_of(wrong_type_profile, input_problems([wrong_type(military_activities)])).
test(route_0_control_status) :-
    status_of(military_activities_no_control, no_origin_exclusion).

test(route_1_control_is_not_excluded, fail) :-
    status_of(military_activities_no_control, excluded_military_activities).
test(route_2_control_is_not_excluded, fail) :-
    status_of(origin_other_third_country_control, excluded_origin_annex_iii_point_1).
test(route_3_control_is_not_excluded, fail) :-
    status_of(electricity_other_third_country_shelf_control, excluded_electricity_continental_shelf_or_eez).
test(route_4_control_is_not_excluded, fail) :-
    status_of(electricity_not_on_shelf_control, excluded_electricity_continental_shelf_or_eez).
test(route_5_control_is_not_excluded, fail) :-
    status_of(hydrogen_other_third_country_zone_control, excluded_hydrogen_continental_shelf_or_eez).
test(route_6_control_is_not_excluded, fail) :-
    status_of(other_goods_liechtenstein_shelf_control, excluded_hydrogen_continental_shelf_or_eez).
test(route_7_control_is_not_member_state_origin, fail) :-
    status_of(origin_other_third_country_control, not_third_country_origin).
test(route_8_control_is_not_indeterminate, fail) :-
    status_of(military_activities_no_control, indeterminate(_)).
test(route_9_control_is_not_indeterminate, fail) :-
    status_of(origin_other_third_country_control, indeterminate(_)).
test(route_10_control_is_not_indeterminate, fail) :-
    status_of(goods_kind_absent_not_on_shelf_control, indeterminate(_)).
test(route_11_control_is_not_indeterminate, fail) :-
    status_of(other_goods_shelf_absent_control, indeterminate(_)).
test(route_12_control_has_an_exclusion, fail) :-
    status_of(military_activities_yes, no_origin_exclusion).
test(route_0_control_has_no_input_problems, fail) :-
    status_of(military_activities_no_control, input_problems(_)).

cp_test_names([near_miss_atoms_are_verdict_atoms, route_1_positive, route_1_control_status, route_2_positive, route_2_control_status, route_3_positive, route_3_control_status, route_4_positive, route_4_control_status, route_5_positive, route_5_control_status, route_6_positive, route_6_control_status, route_7_positive, route_7_control_status, route_8_positive_unsure, route_8_positive_absent, route_8_control_status, route_9_positive, route_9_control_status, route_10_positive, route_10_control_status, route_11_positive, route_11_control_status, route_12_positive, route_12_control_status, route_0_positive_unknown_key, route_0_positive_wrong_type, route_0_control_status]).
cp_test_fail_names([route_1_control_is_not_excluded, route_2_control_is_not_excluded, route_3_control_is_not_excluded, route_4_control_is_not_excluded, route_5_control_is_not_excluded, route_6_control_is_not_excluded, route_7_control_is_not_member_state_origin, route_8_control_is_not_indeterminate, route_9_control_is_not_indeterminate, route_10_control_is_not_indeterminate, route_11_control_is_not_indeterminate, route_12_control_has_an_exclusion, route_0_control_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
