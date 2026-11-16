% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [working_time_weekly_limit_status/2, weekly_limit_status/7, weekly_working_time_average/6, required_reduction_minutes/6]).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    working_time_weekly_limit_profile_for(at_limit, SubjectCase),
    working_time_weekly_limit_status(SubjectCase, within_weekly_limit).
test(the_bound_citations_of_a_breach_hold) :-
    working_time_weekly_limit_profile_for(one_minute_over, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
test(the_bound_citations_of_the_option_route_hold) :-
    working_time_weekly_limit_profile_for(opt_out_without_agreement, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]).
test(the_bound_reduction_holds) :-
    working_time_weekly_limit_profile_for(one_minute_over, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, 1).
test(the_bound_average_in_lowest_terms_holds) :-
    working_time_weekly_limit_profile_for(at_limit, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, minutes_per_seven_days(2880, 1)).
test(the_order_of_the_attributes_does_not_matter) :-
    weekly_limit_status([attribute(worker_agreement_to_exceed_obtained_first, true), attribute(member_state_uses_article_22_option, true)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8), weekly_limit_not_applied_by_agreement, [cite(eu_dir_2003_88_art_22_1), cite(eu_dir_2003_88_art_22_1_a)]).
test(an_integer_worker_is_a_worker) :-
    working_time_weekly_limit_profile_for(same_rota_own_worker, SubjectCase),
    working_time_weekly_limit_status(SubjectCase, over_weekly_limit).
test(a_float_worker_is_named) :-
    weekly_limit_status([], 1.5, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(worker)]), []).
test(shifts_that_are_not_a_list_are_named) :-
    weekly_limit_status([], w1, not_a_list, date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(shifts)]), []).
test(a_shift_list_with_a_foreign_element_is_named) :-
    weekly_working_time_average([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), not_a_shift], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(shifts)])).
test(an_unknown_shift_kind_is_named) :-
    required_reduction_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), overtime)], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(shifts)])).
test(an_hour_of_twenty_four_is_named) :-
    weekly_limit_status([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 24, 0), work)], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(shifts)]), []).
test(a_profile_that_is_not_a_list_is_named) :-
    weekly_limit_status(foo, w1, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(profile)]), []).
test(a_repeated_judgement_key_is_a_duplicate_whatever_its_values) :-
    weekly_limit_status([attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_on_site_counts_as_working_time, true)], w1, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([duplicate_key(on_call_on_site_counts_as_working_time)]), []).
test(a_basis_value_outside_its_type_is_wrong_type) :-
    weekly_limit_status([attribute(reference_period_basis, four_months)], w1, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(reference_period_basis)]), []).
test(an_impossible_month_is_named) :-
    weekly_limit_status([], w1, [], date(2026, 13, 1), date(2026, 3, 8), input_problems([wrong_type(period_start)]), []).
test(an_end_before_the_start_is_named) :-
    required_reduction_minutes([], w1, [], date(2026, 3, 8), date(2026, 3, 2), input_problems([wrong_type(period_end)])).
test(every_problem_is_named_in_order) :-
    weekly_limit_status([attribute(foo, 1)], worker_number(15), foo, date(2026, 2, 30), nothing, input_problems([unknown_key(foo), wrong_type(worker), wrong_type(shifts), wrong_type(period_start), wrong_type(period_end)]), []).
test(the_kernel_check_reads_the_profile_alone) :-
    working_time_weekly_limit_input_problems([attribute(member_state_uses_article_22_option, yes), attribute(bar, 2)], [wrong_type(member_state_uses_article_22_option), unknown_key(bar)]).
test(an_absent_key_is_never_a_problem) :-
    working_time_weekly_limit_input_problems([attribute(on_call_standby_counts_as_working_time, unsure)], []).

test(the_wrong_bound_status_is_rejected, fail) :-
    working_time_weekly_limit_profile_for(at_limit, SubjectCase),
    working_time_weekly_limit_status(SubjectCase, over_weekly_limit).
test(a_wrong_bound_reduction_is_rejected, fail) :-
    working_time_weekly_limit_profile_for(one_minute_over, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, 2).
test(an_average_not_in_lowest_terms_is_rejected, fail) :-
    working_time_weekly_limit_profile_for(at_limit, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, minutes_per_seven_days(5760, 2)).

cp_test_names([status_holds_with_the_verdict_bound, the_bound_citations_of_a_breach_hold, the_bound_citations_of_the_option_route_hold, the_bound_reduction_holds, the_bound_average_in_lowest_terms_holds, the_order_of_the_attributes_does_not_matter, an_integer_worker_is_a_worker, a_float_worker_is_named, shifts_that_are_not_a_list_are_named, a_shift_list_with_a_foreign_element_is_named, an_unknown_shift_kind_is_named, an_hour_of_twenty_four_is_named, a_profile_that_is_not_a_list_is_named, a_repeated_judgement_key_is_a_duplicate_whatever_its_values, a_basis_value_outside_its_type_is_wrong_type, an_impossible_month_is_named, an_end_before_the_start_is_named, every_problem_is_named_in_order, the_kernel_check_reads_the_profile_alone, an_absent_key_is_never_a_problem]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, a_wrong_bound_reduction_is_rejected, an_average_not_in_lowest_terms_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
