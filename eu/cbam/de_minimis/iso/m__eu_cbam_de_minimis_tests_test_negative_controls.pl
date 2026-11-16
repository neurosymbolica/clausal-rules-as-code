% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_exemption/3, de_minimis_goods_status/3, de_minimis_status_values/1]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_profile_for/2]).

exemption_of(Subject, Result) :-
    de_minimis_profile_for(Subject, Profile),
    de_minimis_exemption(Profile, Result, _Citations).

goods_of(Subject, Result) :-
    de_minimis_profile_for(Subject, Profile),
    de_minimis_goods_status(Profile, Result, _Citations).

test(both_verdict_atoms_are_real_verdict_atoms) :-
    de_minimis_status_values(StatusValues),
    member(de_minimis_exemption_applies, StatusValues),
    member(de_minimis_exemption_does_not_apply, StatusValues).
test(step_one_positive_at_the_limit) :-
    exemption_of(at_limit_by_acceptance, de_minimis_exemption_applies).
test(step_one_near_miss_does_not_apply) :-
    exemption_of(one_kilogram_above_by_acceptance, de_minimis_exemption_does_not_apply).
test(release_basis_positive_at_the_limit) :-
    exemption_of(at_limit_by_release, de_minimis_exemption_applies).
test(release_basis_near_miss_does_not_apply) :-
    exemption_of(one_kilogram_above_by_release, de_minimis_exemption_does_not_apply).
test(step_six_positive_goes_to_a_lawyer) :-
    exemption_of(unsure_figures_across_limit, needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])])).
test(step_six_near_miss_applies) :-
    exemption_of(unsure_both_at_limit, de_minimis_exemption_applies).
test(step_five_positive_names_the_date_basis) :-
    exemption_of(no_basis_figures_across_limit, indeterminate([year_date_basis])).
test(step_five_near_miss_applies) :-
    exemption_of(no_basis_both_at_limit, de_minimis_exemption_applies).
test(step_four_positive_names_the_threshold) :-
    exemption_of(one_kilogram_without_threshold, indeterminate([single_mass_based_threshold_tonnes])).
test(step_four_near_miss_applies) :-
    exemption_of(zero_figures_without_threshold, de_minimis_exemption_applies).
test(step_three_positive_names_the_acceptance_figure) :-
    exemption_of(acceptance_figure_absent, indeterminate([net_mass_kg_by_acceptance_date])).
test(step_zero_positive_gives_input_problems) :-
    exemption_of(fractional_threshold, input_problems([wrong_type(single_mass_based_threshold_tonnes)])).
test(step_zero_near_miss_applies) :-
    exemption_of(whole_threshold_control, de_minimis_exemption_applies).
test(step_seven_positive_electricity_is_outside) :-
    goods_of(electricity_import, outside_de_minimis_exemption).
test(step_seven_near_miss_is_counted) :-
    goods_of(other_annex_i_goods_import, counted_toward_threshold).
test(step_eight_positive_hydrogen_is_outside) :-
    goods_of(hydrogen_import, outside_de_minimis_exemption).
test(step_nine_near_miss_is_not_goods_of_this_regulation) :-
    goods_of(goods_not_listed_import, not_goods_of_this_regulation).
test(step_eleven_positive_names_goods_kind) :-
    goods_of(goods_kind_absent, indeterminate([goods_kind])).

test(step_one_near_miss_is_not_exempt, fail) :-
    exemption_of(one_kilogram_above_by_acceptance, de_minimis_exemption_applies).
test(step_two_near_miss_is_not_over_the_threshold, fail) :-
    exemption_of(at_limit_by_acceptance, de_minimis_exemption_does_not_apply).
test(release_basis_near_miss_is_not_exempt, fail) :-
    exemption_of(one_kilogram_above_by_release, de_minimis_exemption_applies).
test(step_six_near_miss_is_not_referred, fail) :-
    exemption_of(unsure_both_at_limit, needs_legal_review(_, _)).
test(step_five_near_miss_is_not_indeterminate, fail) :-
    exemption_of(no_basis_both_at_limit, indeterminate(_)).
test(step_four_near_miss_is_not_indeterminate, fail) :-
    exemption_of(zero_figures_without_threshold, indeterminate(_)).
test(step_three_does_not_name_the_threshold_first, fail) :-
    exemption_of(acceptance_figure_absent, indeterminate([single_mass_based_threshold_tonnes])).
test(step_zero_near_miss_has_no_input_problems, fail) :-
    exemption_of(whole_threshold_control, input_problems(_)).
test(step_seven_near_miss_is_not_outside, fail) :-
    goods_of(other_annex_i_goods_import, outside_de_minimis_exemption).
test(step_eight_hydrogen_is_not_counted, fail) :-
    goods_of(hydrogen_import, counted_toward_threshold).
test(step_nine_near_miss_is_not_counted, fail) :-
    goods_of(goods_not_listed_import, counted_toward_threshold).
test(step_ten_near_miss_is_goods_of_this_regulation, fail) :-
    goods_of(other_annex_i_goods_import, not_goods_of_this_regulation).
test(step_eleven_near_miss_is_not_indeterminate, fail) :-
    goods_of(electricity_import, indeterminate(_)).

cp_test_names([both_verdict_atoms_are_real_verdict_atoms, step_one_positive_at_the_limit, step_one_near_miss_does_not_apply, release_basis_positive_at_the_limit, release_basis_near_miss_does_not_apply, step_six_positive_goes_to_a_lawyer, step_six_near_miss_applies, step_five_positive_names_the_date_basis, step_five_near_miss_applies, step_four_positive_names_the_threshold, step_four_near_miss_applies, step_three_positive_names_the_acceptance_figure, step_zero_positive_gives_input_problems, step_zero_near_miss_applies, step_seven_positive_electricity_is_outside, step_seven_near_miss_is_counted, step_eight_positive_hydrogen_is_outside, step_nine_near_miss_is_not_goods_of_this_regulation, step_eleven_positive_names_goods_kind]).
cp_test_fail_names([step_one_near_miss_is_not_exempt, step_two_near_miss_is_not_over_the_threshold, release_basis_near_miss_is_not_exempt, step_six_near_miss_is_not_referred, step_five_near_miss_is_not_indeterminate, step_four_near_miss_is_not_indeterminate, step_three_does_not_name_the_threshold_first, step_zero_near_miss_has_no_input_problems, step_seven_near_miss_is_not_outside, step_eight_hydrogen_is_not_counted, step_nine_near_miss_is_not_counted, step_ten_near_miss_is_goods_of_this_regulation, step_eleven_near_miss_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
