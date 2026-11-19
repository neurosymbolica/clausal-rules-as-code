% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusion/3, decide_origin_exclusions/2]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_profile_for/2]).

answers_for(Subject, Answers) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers).

test(step_1_military_activities) :-
    answers_for(military_activities_yes, Answers),
    Answers == [excluded_military_activities - [cite(eu_reg_2023_956_art_2_3)]].
test(step_2_origin_norway) :-
    answers_for(origin_norway, Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(step_2_origin_switzerland) :-
    answers_for(origin_switzerland, Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(step_2_origin_busingen_before_electricity) :-
    answers_for(origin_busingen, Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(step_3_electricity_member_state_shelf) :-
    answers_for(electricity_member_state_shelf, Answers),
    Answers == [excluded_electricity_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)]].
test(step_4_electricity_iceland_shelf) :-
    answers_for(electricity_iceland_shelf, Answers),
    Answers == [excluded_electricity_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)]].
test(step_5_hydrogen_member_state_zone) :-
    answers_for(hydrogen_member_state_zone, Answers),
    Answers == [excluded_hydrogen_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)]].
test(step_6_hydrogen_liechtenstein_shelf) :-
    answers_for(hydrogen_liechtenstein_shelf, Answers),
    Answers == [excluded_hydrogen_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)]].
test(step_7_member_state_origin) :-
    answers_for(member_state_origin, Answers),
    Answers == [not_third_country_origin - [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_art_3_7)]].
test(step_8_military_activities_absent) :-
    answers_for(military_activities_absent, Answers),
    Answers == [indeterminate([military_activities]) - []].
test(step_8_military_activities_unsure) :-
    answers_for(military_activities_unsure, Answers),
    Answers == [indeterminate([military_activities]) - []].
test(step_9_origin_absent) :-
    answers_for(origin_absent, Answers),
    Answers == [indeterminate([non_preferential_origin]) - []].
test(step_10_goods_kind_absent) :-
    answers_for(goods_kind_absent_member_state_shelf, Answers),
    Answers == [indeterminate([goods_kind]) - []].
test(step_11_shelf_absent) :-
    answers_for(electricity_shelf_absent, Answers),
    Answers == [indeterminate([continental_shelf_or_eez_of]) - []].
test(step_12_no_origin_exclusion) :-
    answers_for(military_activities_no_control, Answers),
    Answers == [no_origin_exclusion - [cite(eu_reg_2023_956_art_2_3), cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_annex_3_1)]].
test(step_12_goods_kind_irrelevant_outside_zone) :-
    answers_for(goods_kind_absent_not_on_shelf_control, Answers),
    Answers == [no_origin_exclusion - [cite(eu_reg_2023_956_art_2_3), cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_annex_3_1)]].
test(q4_listed_origin_decides_with_military_absent) :-
    answers_for(norway_origin_military_absent, Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(q4_origin_before_hydrogen_shelf) :-
    answers_for(norway_hydrogen_norway_shelf, Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(step_0_unknown_key) :-
    answers_for(unknown_key_profile, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(step_0_duplicate_key) :-
    answers_for(duplicate_key_profile, Answers),
    Answers == [input_problems([duplicate_key(military_activities)]) - []].
test(step_0_wrong_type) :-
    answers_for(wrong_type_profile, Answers),
    Answers == [input_problems([wrong_type(military_activities)]) - []].
test(step_0_not_an_attribute_list) :-
    answers_for(not_an_attribute_list_profile, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(the_folded_verdict_carries_the_citations) :-
    origin_exclusions_profile_for(origin_norway, Profile),
    findall(Verdict, decide_origin_exclusions(Profile, Verdict), Verdicts),
    Verdicts == [origin_exclusions_verdict(excluded_origin_annex_iii_point_1, [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)])].

cp_test_names([step_1_military_activities, step_2_origin_norway, step_2_origin_switzerland, step_2_origin_busingen_before_electricity, step_3_electricity_member_state_shelf, step_4_electricity_iceland_shelf, step_5_hydrogen_member_state_zone, step_6_hydrogen_liechtenstein_shelf, step_7_member_state_origin, step_8_military_activities_absent, step_8_military_activities_unsure, step_9_origin_absent, step_10_goods_kind_absent, step_11_shelf_absent, step_12_no_origin_exclusion, step_12_goods_kind_irrelevant_outside_zone, q4_listed_origin_decides_with_military_absent, q4_origin_before_hydrogen_shelf, step_0_unknown_key, step_0_duplicate_key, step_0_wrong_type, step_0_not_an_attribute_list, the_folded_verdict_carries_the_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
