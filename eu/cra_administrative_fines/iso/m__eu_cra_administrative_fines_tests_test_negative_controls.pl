% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [cra_administrative_fines_status_values/1]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_assess/2]).

verdict_of(Subject, Verdict) :-
    cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(Verdict, _Citations)).

test(the_status_table_names_every_verdict_form) :-
    cra_administrative_fines_status_values(StatusValues),
    member(fine_maximum/3, StatusValues),
    member(fine_excluded/1, StatusValues),
    member(not_listed_in_article_64/0, StatusValues),
    member(not_yet_applicable/0, StatusValues),
    member(indeterminate/1, StatusValues),
    member(needs_legal_review/2, StatusValues),
    member(input_problems/1, StatusValues).
test(f0_a_non_leap_day_is_an_input_problem) :-
    verdict_of(non_leap_day_2027, input_problems([wrong_type(infringement_date)])).
test(f0_near_miss_the_leap_day_is_read) :-
    verdict_of(leap_day_2028, not_listed_in_article_64).
test(f0_a_float_turnover_is_an_input_problem) :-
    verdict_of(float_turnover, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)])).
test(f0_near_miss_the_integer_turnover_is_read) :-
    verdict_of(highest_tier_tie, fine_maximum(highest_maximum_tier, fixed_amount, _)).
test(f1_the_day_before_is_not_yet_applicable) :-
    verdict_of(day_before_application_highest_tier, not_yet_applicable).
test(f1_near_miss_the_application_day_gives_the_maximum) :-
    verdict_of(application_day_highest_tier, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, _)).
test(f2_the_absent_provision_is_asked_for) :-
    verdict_of(provision_absent, indeterminate([infringed_provision])).
test(f3_other_provision_is_not_listed) :-
    verdict_of(unlisted_provision, not_listed_in_article_64).
test(f3_near_miss_a_listed_provision_gives_its_tier) :-
    verdict_of(listed_provision_middle_tier, fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, _)).
test(f4_a_steward_in_the_middle_tier_is_excluded) :-
    verdict_of(steward_middle_tier, fine_excluded(open_source_software_steward)).
test(f4_near_miss_a_non_steward_gets_the_maximum) :-
    verdict_of(non_steward_middle_tier, fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, _)).
test(f4_near_miss_a_steward_in_the_highest_tier_gets_the_maximum) :-
    verdict_of(steward_highest_tier_not_read, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, _)).
test(f4_a_missing_steward_is_asked_for_in_the_middle_tier) :-
    verdict_of(steward_absent_middle_tier, indeterminate([offender_is_open_source_software_steward])).
test(f4_near_miss_the_highest_tier_answers_without_the_steward) :-
    verdict_of(steward_absent_highest_tier, fine_maximum(highest_maximum_tier, fixed_amount, _)).
test(f5_a_missing_undertaking_is_asked_for) :-
    verdict_of(undertaking_absent_middle_tier, indeterminate([offender_is_undertaking])).
test(f5_a_missing_turnover_is_asked_for_an_undertaking) :-
    verdict_of(turnover_absent_undertaking, indeterminate([total_worldwide_annual_turnover_in_euros])).
test(f5_near_miss_a_non_undertaking_gets_the_fixed_amount) :-
    verdict_of(turnover_absent_non_undertaking, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, _)).
test(f6_an_unsure_steward_refers) :-
    verdict_of(unsure_steward_referral, needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), _)).
test(f6_near_miss_the_highest_tier_refers_on_the_undertaking) :-
    verdict_of(unsure_undertaking_highest_tier, needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_2)), [inputs_relied_on([offender_is_undertaking - unsure])])).
test(f6_an_unsure_undertaking_refers_in_the_middle_tier) :-
    verdict_of(unsure_undertaking_middle_tier, needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_3)), _)).
test(f7_the_highest_tie_names_the_fixed_amount) :-
    verdict_of(highest_tier_tie, fine_maximum(highest_maximum_tier, fixed_amount, CapInEuroCents)),
    CapInEuroCents =:= 1500000000.
test(f7_near_miss_one_euro_above_is_the_percentage) :-
    verdict_of(highest_tier_one_euro_above_tie, fine_maximum(highest_maximum_tier, percentage_of_turnover, CapInEuroCents)),
    CapInEuroCents =:= 1500000002.

test(f0_near_miss_the_leap_day_is_no_input_problem, fail) :-
    verdict_of(leap_day_2028, input_problems(_)).
test(f1_near_miss_the_application_day_is_not_not_yet_applicable, fail) :-
    verdict_of(application_day_highest_tier, not_yet_applicable).
test(f2_near_miss_a_present_provision_is_not_asked_for, fail) :-
    verdict_of(unlisted_provision, indeterminate(_)).
test(f3_near_miss_a_listed_provision_is_listed, fail) :-
    verdict_of(listed_provision_middle_tier, not_listed_in_article_64).
test(f4_near_miss_a_non_steward_is_not_excluded, fail) :-
    verdict_of(non_steward_middle_tier, fine_excluded(_)).
test(f4_near_miss_a_steward_in_the_highest_tier_is_not_excluded, fail) :-
    verdict_of(steward_highest_tier_not_read, fine_excluded(_)).
test(f4_near_miss_a_missing_steward_is_not_asked_for_in_the_highest_tier, fail) :-
    verdict_of(steward_absent_highest_tier, indeterminate(_)).
test(f5_near_miss_a_given_undertaking_is_not_asked_for, fail) :-
    verdict_of(non_steward_middle_tier, indeterminate(_)).
test(f5_near_miss_a_non_undertaking_needs_no_turnover, fail) :-
    verdict_of(turnover_absent_non_undertaking, indeterminate(_)).
test(f6_near_miss_an_unsure_steward_in_the_highest_tier_does_not_refer_on_the_steward, fail) :-
    verdict_of(unsure_undertaking_highest_tier, needs_legal_review(open_textured(offender_is_open_source_software_steward, _), _)).
test(f6_near_miss_a_settled_undertaking_does_not_refer, fail) :-
    verdict_of(middle_tier_tie, needs_legal_review(_, _)).
test(f7_the_tie_is_not_the_percentage, fail) :-
    verdict_of(highest_tier_tie, fine_maximum(_, percentage_of_turnover, _)).
test(f7_near_miss_one_euro_above_is_not_the_fixed_amount, fail) :-
    verdict_of(highest_tier_one_euro_above_tie, fine_maximum(_, fixed_amount, _)).

cp_test_names([the_status_table_names_every_verdict_form, f0_a_non_leap_day_is_an_input_problem, f0_near_miss_the_leap_day_is_read, f0_a_float_turnover_is_an_input_problem, f0_near_miss_the_integer_turnover_is_read, f1_the_day_before_is_not_yet_applicable, f1_near_miss_the_application_day_gives_the_maximum, f2_the_absent_provision_is_asked_for, f3_other_provision_is_not_listed, f3_near_miss_a_listed_provision_gives_its_tier, f4_a_steward_in_the_middle_tier_is_excluded, f4_near_miss_a_non_steward_gets_the_maximum, f4_near_miss_a_steward_in_the_highest_tier_gets_the_maximum, f4_a_missing_steward_is_asked_for_in_the_middle_tier, f4_near_miss_the_highest_tier_answers_without_the_steward, f5_a_missing_undertaking_is_asked_for, f5_a_missing_turnover_is_asked_for_an_undertaking, f5_near_miss_a_non_undertaking_gets_the_fixed_amount, f6_an_unsure_steward_refers, f6_near_miss_the_highest_tier_refers_on_the_undertaking, f6_an_unsure_undertaking_refers_in_the_middle_tier, f7_the_highest_tie_names_the_fixed_amount, f7_near_miss_one_euro_above_is_the_percentage]).
cp_test_fail_names([f0_near_miss_the_leap_day_is_no_input_problem, f1_near_miss_the_application_day_is_not_not_yet_applicable, f2_near_miss_a_present_provision_is_not_asked_for, f3_near_miss_a_listed_provision_is_listed, f4_near_miss_a_non_steward_is_not_excluded, f4_near_miss_a_steward_in_the_highest_tier_is_not_excluded, f4_near_miss_a_missing_steward_is_not_asked_for_in_the_highest_tier, f5_near_miss_a_given_undertaking_is_not_asked_for, f5_near_miss_a_non_undertaking_needs_no_turnover, f6_near_miss_an_unsure_steward_in_the_highest_tier_does_not_refer_on_the_steward, f6_near_miss_a_settled_undertaking_does_not_refer, f7_the_tie_is_not_the_percentage, f7_near_miss_one_euro_above_is_not_the_fixed_amount]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
