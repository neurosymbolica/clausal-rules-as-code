% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusion/3, origin_exclusions_status/2]).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_profile_for/2]).

bound_result_holds(Subject, Result) :-
    origin_exclusions_profile_for(Subject, Profile),
    origin_exclusion(Profile, Result, _).

test(step_1_military_bound) :-
    origin_exclusions_profile_for(military_activities_yes, Profile),
    origin_exclusion(Profile, excluded_military_activities, [cite(eu_reg_2023_956_art_2_3)]).
test(step_2_listed_origin_bound) :-
    origin_exclusions_profile_for(origin_norway, Profile),
    origin_exclusion(Profile, excluded_origin_annex_iii_point_1, [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]).
test(step_3_electricity_member_state_bound) :-
    bound_result_holds(electricity_member_state_shelf, excluded_electricity_continental_shelf_or_eez).
test(step_4_electricity_listed_bound) :-
    bound_result_holds(electricity_iceland_shelf, excluded_electricity_continental_shelf_or_eez).
test(step_5_hydrogen_member_state_bound) :-
    bound_result_holds(hydrogen_member_state_zone, excluded_hydrogen_continental_shelf_or_eez).
test(step_6_hydrogen_listed_bound) :-
    bound_result_holds(hydrogen_liechtenstein_shelf, excluded_hydrogen_continental_shelf_or_eez).
test(step_7_member_state_origin_bound) :-
    bound_result_holds(member_state_origin, not_third_country_origin).
test(step_8_military_missing_bound) :-
    origin_exclusions_profile_for(military_activities_unsure, Profile),
    origin_exclusion(Profile, indeterminate([military_activities]), []).
test(step_9_origin_missing_bound) :-
    bound_result_holds(origin_absent, indeterminate([non_preferential_origin])).
test(step_10_goods_kind_missing_bound) :-
    bound_result_holds(goods_kind_absent_member_state_shelf, indeterminate([goods_kind])).
test(step_11_shelf_missing_bound) :-
    bound_result_holds(electricity_shelf_absent, indeterminate([continental_shelf_or_eez_of])).
test(step_12_no_exclusion_bound) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    origin_exclusions_status(Profile, no_origin_exclusion).
test(step_0_input_problems_bound) :-
    origin_exclusions_profile_for(duplicate_key_profile, Profile),
    origin_exclusion(Profile, input_problems([duplicate_key(military_activities)]), []).
test(key_order_does_not_matter) :-
    origin_exclusion([attribute(continental_shelf_or_eez_of, iceland), attribute(goods_kind, electricity), attribute(non_preferential_origin, other_third_country), attribute(military_activities, no)], excluded_electricity_continental_shelf_or_eez, _).
test(empty_profile_has_no_problem) :-
    origin_exclusions_input_problems([], []).
test(absence_is_not_a_problem) :-
    origin_exclusions_input_problems([attribute(military_activities, no)], []).
test(bound_problem_list_for_duplicates) :-
    origin_exclusions_profile_for(duplicate_key_profile, Profile),
    origin_exclusions_input_problems(Profile, [duplicate_key(military_activities)]).
test(duplicate_values_are_never_read) :-
    findall(Problems, origin_exclusions_input_problems([attribute(goods_kind, steel), attribute(goods_kind, iron)], Problems), Answers),
    Answers == [[duplicate_key(goods_kind)]].
test(repeated_unknown_key_is_named_once) :-
    findall(Problems, origin_exclusions_input_problems([attribute(colour, red), attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(problems_come_in_the_stated_order) :-
    findall(Problems, origin_exclusions_input_problems([attribute(colour, red), attribute(goods_kind, steel), attribute(military_activities, yes), attribute(military_activities, no)], Problems), Answers),
    Answers == [[duplicate_key(military_activities), wrong_type(goods_kind), unknown_key(colour)]].
test(number_key_is_an_unknown_key) :-
    findall(Problems, origin_exclusions_input_problems([attribute(42, yes)], Problems), Answers),
    Answers == [[unknown_key(42)]].
test(unbound_key_is_an_unknown_key_as_given) :-
    findall(Problems, origin_exclusions_input_problems([attribute(_, yes)], Problems), Answers),
    Answers = [[unknown_key(GivenKey)]],
    var(GivenKey).
test(unbound_value_is_a_wrong_type) :-
    findall(Problems, origin_exclusions_input_problems([attribute(goods_kind, _)], Problems), Answers),
    Answers == [[wrong_type(goods_kind)]].
test(string_value_is_a_wrong_type) :-
    findall(Problems, origin_exclusions_input_problems([attribute(goods_kind, "electricity")], Problems), Answers),
    Answers == [[wrong_type(goods_kind)]].
test(unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, origin_exclusions_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(partial_list_is_not_an_attribute_list) :-
    findall(Problems, origin_exclusions_input_problems([attribute(military_activities, yes)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(stray_element_is_not_an_attribute_list) :-
    findall(Problems, origin_exclusions_input_problems([attribute(military_activities, yes), colour], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(query_on_unbound_profile_reports_input_problems) :-
    findall(Result - Citations, origin_exclusion(_, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].

test(step_1_rejects_no_origin_exclusion, fail) :-
    bound_result_holds(military_activities_yes, no_origin_exclusion).
test(step_2_rejects_not_third_country_origin, fail) :-
    bound_result_holds(origin_norway, not_third_country_origin).
test(step_3_rejects_hydrogen_label, fail) :-
    bound_result_holds(electricity_member_state_shelf, excluded_hydrogen_continental_shelf_or_eez).
test(step_4_rejects_no_origin_exclusion, fail) :-
    bound_result_holds(electricity_iceland_shelf, no_origin_exclusion).
test(step_5_rejects_electricity_label, fail) :-
    bound_result_holds(hydrogen_member_state_zone, excluded_electricity_continental_shelf_or_eez).
test(step_6_rejects_origin_label, fail) :-
    bound_result_holds(hydrogen_liechtenstein_shelf, excluded_origin_annex_iii_point_1).
test(step_7_rejects_no_origin_exclusion, fail) :-
    bound_result_holds(member_state_origin, no_origin_exclusion).
test(step_8_rejects_another_missing_key, fail) :-
    bound_result_holds(military_activities_unsure, indeterminate([non_preferential_origin])).
test(step_9_rejects_military_key, fail) :-
    bound_result_holds(origin_absent, indeterminate([military_activities])).
test(step_10_rejects_shelf_key, fail) :-
    bound_result_holds(goods_kind_absent_member_state_shelf, indeterminate([continental_shelf_or_eez_of])).
test(step_11_rejects_goods_kind_key, fail) :-
    bound_result_holds(electricity_shelf_absent, indeterminate([goods_kind])).
test(step_12_rejects_military_label, fail) :-
    bound_result_holds(military_activities_no_control, excluded_military_activities).
test(step_0_rejects_wrong_type_for_duplicate, fail) :-
    bound_result_holds(duplicate_key_profile, input_problems([wrong_type(military_activities)])).

cp_test_names([step_1_military_bound, step_2_listed_origin_bound, step_3_electricity_member_state_bound, step_4_electricity_listed_bound, step_5_hydrogen_member_state_bound, step_6_hydrogen_listed_bound, step_7_member_state_origin_bound, step_8_military_missing_bound, step_9_origin_missing_bound, step_10_goods_kind_missing_bound, step_11_shelf_missing_bound, step_12_no_exclusion_bound, step_0_input_problems_bound, key_order_does_not_matter, empty_profile_has_no_problem, absence_is_not_a_problem, bound_problem_list_for_duplicates, duplicate_values_are_never_read, repeated_unknown_key_is_named_once, problems_come_in_the_stated_order, number_key_is_an_unknown_key, unbound_key_is_an_unknown_key_as_given, unbound_value_is_a_wrong_type, string_value_is_a_wrong_type, unbound_profile_is_not_an_attribute_list, partial_list_is_not_an_attribute_list, stray_element_is_not_an_attribute_list, query_on_unbound_profile_reports_input_problems]).
cp_test_fail_names([step_1_rejects_no_origin_exclusion, step_2_rejects_not_third_country_origin, step_3_rejects_hydrogen_label, step_4_rejects_no_origin_exclusion, step_5_rejects_electricity_label, step_6_rejects_origin_label, step_7_rejects_no_origin_exclusion, step_8_rejects_another_missing_key, step_9_rejects_military_key, step_10_rejects_shelf_key, step_11_rejects_goods_kind_key, step_12_rejects_military_label, step_0_rejects_wrong_type_for_duplicate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
