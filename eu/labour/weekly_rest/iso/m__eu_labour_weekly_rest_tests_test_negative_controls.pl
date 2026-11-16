% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_weekly_rest_weekly_rest, [weekly_rest_status/2, weekly_rest_status_values/1]).
:- use_module(m__eu_labour_weekly_rest_fixtures, [weekly_rest_profile_for/2]).

status_of(Subject, Status) :-
    weekly_rest_profile_for(Subject, WeeklyRestCase),
    weekly_rest_status(WeeklyRestCase, Status).

test(every_near_miss_atom_is_a_real_verdict_atom) :-
    weekly_rest_status_values(StatusValues),
    member(weekly_rest_given, StatusValues),
    member(weekly_rest_not_given, StatusValues),
    member(weekly_rest_not_applied_to_worker, StatusValues),
    member(weekly_rest_derogation_applies, StatusValues).
test(rest_of_2100_minutes_is_given) :-
    status_of(rest_of_2100_minutes_given, weekly_rest_given).
test(rest_of_2099_minutes_is_not_given) :-
    status_of(rest_of_2099_minutes_not_given, weekly_rest_not_given).
test(reduced_rest_of_1440_minutes_is_given) :-
    status_of(reduced_rest_of_1440_minutes_given, weekly_rest_given).
test(reduced_rest_of_1439_minutes_is_not_given) :-
    status_of(reduced_rest_of_1439_minutes_not_given, weekly_rest_not_given).
test(fourteen_day_run_of_4200_is_given) :-
    status_of(fourteen_day_run_of_4200_minutes_given, weekly_rest_given).
test(fourteen_day_run_of_4199_is_not_given) :-
    status_of(fourteen_day_run_of_4199_minutes_not_given, weekly_rest_not_given).
test(mobile_worker_short_of_rest_is_not_applied) :-
    status_of(mobile_worker_short_rest_not_applied, weekly_rest_not_applied_to_worker).
test(mobile_worker_with_full_rest_is_given) :-
    status_of(mobile_worker_full_rest_given, weekly_rest_given).
test(fishing_vessel_worker_short_of_rest_is_not_applied) :-
    status_of(fishing_vessel_worker_short_rest_not_applied, weekly_rest_not_applied_to_worker).
test(fishing_vessel_worker_with_full_rest_is_given) :-
    status_of(fishing_vessel_worker_full_rest_given, weekly_rest_given).
test(each_stated_derogation_applies_to_a_short_rest) :-
    status_of(derogation_under_article_17_1_short_rest, weekly_rest_derogation_applies),
    status_of(derogation_under_article_17_3_short_rest, weekly_rest_derogation_applies),
    status_of(derogation_under_article_17_4_short_rest, weekly_rest_derogation_applies),
    status_of(derogation_under_article_18_short_rest, weekly_rest_derogation_applies).
test(a_derogation_with_full_rest_is_given) :-
    status_of(derogation_under_article_17_4_full_rest_given, weekly_rest_given).
test(a_short_rest_without_worker_category_asks_for_it) :-
    status_of(short_rest_without_worker_category, indeterminate([worker_category])).
test(a_short_rest_without_derogation_asks_for_it) :-
    status_of(short_rest_without_derogation, indeterminate([derogation_from_article_5])).
test(an_unsure_standby_goes_to_a_lawyer) :-
    status_of(unsure_standby_needs_legal_review, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_standby_counts_as_working_time - unsure])])).
test(standby_judged_not_working_time_is_given) :-
    status_of(standby_not_working_time_given, weekly_rest_given).
test(standby_judged_working_time_is_not_given) :-
    status_of(standby_working_time_not_given, weekly_rest_not_given).
test(an_absent_standby_is_asked_for) :-
    status_of(absent_standby_indeterminate, indeterminate([on_call_standby_counts_as_working_time])).
test(an_unknown_key_is_refused) :-
    status_of(unknown_key_input_problems, input_problems([unknown_key(audit_note)])).

test(rest_of_2099_minutes_is_not_given_as_given, fail) :-
    status_of(rest_of_2099_minutes_not_given, weekly_rest_given).
test(rest_of_2100_minutes_is_not_short, fail) :-
    status_of(rest_of_2100_minutes_given, weekly_rest_not_given).
test(reduced_rest_of_1439_minutes_is_not_given_as_given, fail) :-
    status_of(reduced_rest_of_1439_minutes_not_given, weekly_rest_given).
test(fourteen_day_run_of_4199_is_not_given_as_given, fail) :-
    status_of(fourteen_day_run_of_4199_minutes_not_given, weekly_rest_given).
test(mobile_worker_with_full_rest_is_not_reported_as_not_applied, fail) :-
    status_of(mobile_worker_full_rest_given, weekly_rest_not_applied_to_worker).
test(mobile_worker_short_of_rest_is_not_not_given, fail) :-
    status_of(mobile_worker_short_rest_not_applied, weekly_rest_not_given).
test(fishing_vessel_worker_with_full_rest_is_not_reported_as_not_applied, fail) :-
    status_of(fishing_vessel_worker_full_rest_given, weekly_rest_not_applied_to_worker).
test(a_derogation_with_full_rest_is_not_reported_as_a_derogation, fail) :-
    status_of(derogation_under_article_17_4_full_rest_given, weekly_rest_derogation_applies).
test(a_derogation_short_rest_is_not_not_given, fail) :-
    status_of(derogation_under_article_17_4_short_rest, weekly_rest_not_given).
test(a_full_rest_without_worker_category_does_not_ask, fail) :-
    status_of(rest_of_2100_minutes_given, indeterminate([worker_category])).
test(a_short_rest_without_worker_category_does_not_ask_for_the_derogation, fail) :-
    status_of(short_rest_without_worker_category, indeterminate([derogation_from_article_5])).
test(a_short_rest_with_no_derogation_stated_does_not_ask, fail) :-
    status_of(rest_of_2099_minutes_not_given, indeterminate([derogation_from_article_5])).
test(standby_judged_false_does_not_go_to_a_lawyer, fail) :-
    status_of(standby_not_working_time_given, needs_legal_review(_, _)).
test(an_unsure_standby_is_not_given_a_final_answer, fail) :-
    status_of(unsure_standby_needs_legal_review, weekly_rest_not_given).
test(an_absent_standby_does_not_go_to_a_lawyer, fail) :-
    status_of(absent_standby_indeterminate, needs_legal_review(_, _)).
test(an_unknown_key_gets_no_verdict, fail) :-
    status_of(unknown_key_input_problems, weekly_rest_given).
test(the_same_rota_without_the_unknown_key_is_not_refused, fail) :-
    status_of(rest_of_2100_minutes_given, input_problems(_)).

cp_test_names([every_near_miss_atom_is_a_real_verdict_atom, rest_of_2100_minutes_is_given, rest_of_2099_minutes_is_not_given, reduced_rest_of_1440_minutes_is_given, reduced_rest_of_1439_minutes_is_not_given, fourteen_day_run_of_4200_is_given, fourteen_day_run_of_4199_is_not_given, mobile_worker_short_of_rest_is_not_applied, mobile_worker_with_full_rest_is_given, fishing_vessel_worker_short_of_rest_is_not_applied, fishing_vessel_worker_with_full_rest_is_given, each_stated_derogation_applies_to_a_short_rest, a_derogation_with_full_rest_is_given, a_short_rest_without_worker_category_asks_for_it, a_short_rest_without_derogation_asks_for_it, an_unsure_standby_goes_to_a_lawyer, standby_judged_not_working_time_is_given, standby_judged_working_time_is_not_given, an_absent_standby_is_asked_for, an_unknown_key_is_refused]).
cp_test_fail_names([rest_of_2099_minutes_is_not_given_as_given, rest_of_2100_minutes_is_not_short, reduced_rest_of_1439_minutes_is_not_given_as_given, fourteen_day_run_of_4199_is_not_given_as_given, mobile_worker_with_full_rest_is_not_reported_as_not_applied, mobile_worker_short_of_rest_is_not_not_given, fishing_vessel_worker_with_full_rest_is_not_reported_as_not_applied, a_derogation_with_full_rest_is_not_reported_as_a_derogation, a_derogation_short_rest_is_not_not_given, a_full_rest_without_worker_category_does_not_ask, a_short_rest_without_worker_category_does_not_ask_for_the_derogation, a_short_rest_with_no_derogation_stated_does_not_ask, standby_judged_false_does_not_go_to_a_lawyer, an_unsure_standby_is_not_given_a_final_answer, an_absent_standby_does_not_go_to_a_lawyer, an_unknown_key_gets_no_verdict, the_same_rota_without_the_unknown_key_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
