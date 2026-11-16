% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [working_time_weekly_limit_status/2, working_time_weekly_limit_status_values/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_profile_for/2]).

status_of(Subject, Status) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    working_time_weekly_limit_status(SubjectCase, Status).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    working_time_weekly_limit_status_values(StatusValues),
    member(within_weekly_limit, StatusValues),
    member(over_weekly_limit, StatusValues),
    member(weekly_limit_not_applied_by_agreement, StatusValues),
    member(reference_period_longer_than_allowed, StatusValues),
    member(no_countable_period, StatusValues).
test(at_the_limit_is_within) :-
    status_of(at_limit, within_weekly_limit).
test(one_minute_over_is_over) :-
    status_of(one_minute_over, over_weekly_limit).
test(a_day_of_leave_at_the_limit_is_within) :-
    status_of(leave_day_at_limit, within_weekly_limit).
test(a_day_of_leave_one_minute_over_is_over) :-
    status_of(leave_day_one_minute_over, over_weekly_limit).
test(the_agreed_option_does_not_apply_the_limit) :-
    status_of(opt_out_agreed, weekly_limit_not_applied_by_agreement).
test(without_prior_agreement_the_option_is_over) :-
    status_of(opt_out_without_agreement, over_weekly_limit).
test(over_with_the_option_absent_asks_for_it) :-
    status_of(option_absent_over, indeterminate([member_state_uses_article_22_option])).
test(a_false_agreement_makes_the_option_irrelevant) :-
    status_of(agreement_false_option_absent, over_weekly_limit).
test(four_months_by_the_month_rule_is_within) :-
    status_of(member_state_period_at_four_months, within_weekly_limit).
test(one_day_over_four_months_is_too_long) :-
    status_of(member_state_period_one_day_over, reference_period_longer_than_allowed).
test(beyond_four_months_without_a_basis_asks_for_it) :-
    status_of(basis_absent_one_day_over, indeterminate([reference_period_basis])).
test(six_months_under_a_derogation_is_within) :-
    status_of(derogation_period_at_six_months, within_weekly_limit).
test(one_day_over_six_months_under_a_derogation_is_too_long) :-
    status_of(derogation_period_one_day_over, reference_period_longer_than_allowed).
test(twelve_months_under_a_collective_agreement_is_within) :-
    status_of(collective_agreement_period_at_twelve_months, within_weekly_limit).
test(twelve_months_offshore_is_within) :-
    status_of(offshore_period_at_twelve_months, within_weekly_limit).
test(one_day_over_twelve_months_is_too_long) :-
    status_of(period_one_day_over_twelve_months, reference_period_longer_than_allowed).
test(a_whole_period_of_sick_leave_has_no_countable_period) :-
    status_of(all_sick_leave, no_countable_period).
test(one_minute_short_of_sick_leave_is_within) :-
    status_of(sick_leave_one_minute_short, within_weekly_limit).
test(an_absent_judgement_that_matters_is_asked_for) :-
    status_of(on_site_absent_matters, indeterminate([on_call_on_site_counts_as_working_time])).
test(an_absent_judgement_that_cannot_cross_is_within) :-
    status_of(on_site_absent_does_not_matter, within_weekly_limit).
test(the_standby_judgement_is_named_for_standby_time) :-
    status_of(standby_absent_matters, indeterminate([on_call_standby_counts_as_working_time])).
test(an_unsure_judgement_that_decides_is_referred) :-
    status_of(on_site_unsure_matters, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])])).
test(a_true_judgement_is_over) :-
    status_of(on_site_counted, over_weekly_limit).
test(a_false_judgement_is_within) :-
    status_of(on_site_not_counted, within_weekly_limit).
test(the_part_inside_at_the_limit_is_within) :-
    status_of(edge_shift_at_limit, within_weekly_limit).
test(the_part_inside_one_minute_over_is_over) :-
    status_of(edge_shift_one_minute_over, over_weekly_limit).
test(another_workers_rota_is_within) :-
    status_of(other_worker_ignored, within_weekly_limit).
test(the_same_rota_for_its_own_worker_is_over) :-
    status_of(same_rota_own_worker, over_weekly_limit).
test(a_bad_profile_is_refused) :-
    status_of(bad_profile, input_problems([wrong_type(reference_period_basis), unknown_key(foo)])).
test(the_good_profile_control_is_within) :-
    status_of(good_profile_control, within_weekly_limit).

test(at_the_limit_is_not_over, fail) :-
    status_of(at_limit, over_weekly_limit).
test(one_minute_over_is_not_within, fail) :-
    status_of(one_minute_over, within_weekly_limit).
test(a_day_of_leave_one_minute_over_is_not_within, fail) :-
    status_of(leave_day_one_minute_over, within_weekly_limit).
test(without_prior_agreement_the_limit_still_applies, fail) :-
    status_of(opt_out_without_agreement, weekly_limit_not_applied_by_agreement).
test(a_false_agreement_does_not_ask_for_the_option, fail) :-
    status_of(agreement_false_option_absent, indeterminate(_)).
test(four_months_by_the_month_rule_is_not_too_long, fail) :-
    status_of(member_state_period_at_four_months, reference_period_longer_than_allowed).
test(within_four_months_the_basis_is_not_asked, fail) :-
    status_of(member_state_period_at_four_months, indeterminate(_)).
test(one_day_over_six_months_under_a_derogation_is_not_within, fail) :-
    status_of(derogation_period_one_day_over, within_weekly_limit).
test(one_day_over_twelve_months_is_not_within, fail) :-
    status_of(period_one_day_over_twelve_months, within_weekly_limit).
test(one_minute_short_of_sick_leave_is_countable, fail) :-
    status_of(sick_leave_one_minute_short, no_countable_period).
test(an_absent_judgement_that_cannot_cross_is_not_asked_for, fail) :-
    status_of(on_site_absent_does_not_matter, indeterminate(_)).
test(the_on_site_judgement_is_not_named_for_standby_time, fail) :-
    status_of(standby_absent_matters, indeterminate([on_call_on_site_counts_as_working_time])).
test(a_true_judgement_is_not_referred, fail) :-
    status_of(on_site_counted, needs_legal_review(_, _)).
test(a_false_judgement_is_not_over, fail) :-
    status_of(on_site_not_counted, over_weekly_limit).
test(the_part_inside_at_the_limit_is_not_over, fail) :-
    status_of(edge_shift_at_limit, over_weekly_limit).
test(another_workers_rota_is_not_over, fail) :-
    status_of(other_worker_ignored, over_weekly_limit).
test(the_good_profile_control_is_not_refused, fail) :-
    status_of(good_profile_control, input_problems(_)).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, at_the_limit_is_within, one_minute_over_is_over, a_day_of_leave_at_the_limit_is_within, a_day_of_leave_one_minute_over_is_over, the_agreed_option_does_not_apply_the_limit, without_prior_agreement_the_option_is_over, over_with_the_option_absent_asks_for_it, a_false_agreement_makes_the_option_irrelevant, four_months_by_the_month_rule_is_within, one_day_over_four_months_is_too_long, beyond_four_months_without_a_basis_asks_for_it, six_months_under_a_derogation_is_within, one_day_over_six_months_under_a_derogation_is_too_long, twelve_months_under_a_collective_agreement_is_within, twelve_months_offshore_is_within, one_day_over_twelve_months_is_too_long, a_whole_period_of_sick_leave_has_no_countable_period, one_minute_short_of_sick_leave_is_within, an_absent_judgement_that_matters_is_asked_for, an_absent_judgement_that_cannot_cross_is_within, the_standby_judgement_is_named_for_standby_time, an_unsure_judgement_that_decides_is_referred, a_true_judgement_is_over, a_false_judgement_is_within, the_part_inside_at_the_limit_is_within, the_part_inside_one_minute_over_is_over, another_workers_rota_is_within, the_same_rota_for_its_own_worker_is_over, a_bad_profile_is_refused, the_good_profile_control_is_within]).
cp_test_fail_names([at_the_limit_is_not_over, one_minute_over_is_not_within, a_day_of_leave_one_minute_over_is_not_within, without_prior_agreement_the_limit_still_applies, a_false_agreement_does_not_ask_for_the_option, four_months_by_the_month_rule_is_not_too_long, within_four_months_the_basis_is_not_asked, one_day_over_six_months_under_a_derogation_is_not_within, one_day_over_twelve_months_is_not_within, one_minute_short_of_sick_leave_is_countable, an_absent_judgement_that_cannot_cross_is_not_asked_for, the_on_site_judgement_is_not_named_for_standby_time, a_true_judgement_is_not_referred, a_false_judgement_is_not_over, the_part_inside_at_the_limit_is_not_over, another_workers_rota_is_not_over, the_good_profile_control_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
