% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [nis2_incident_reporting_status/2, incident_significance/3, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_status(Profile, significant).
test(not_significant_bound_for_both_false) :-
    nis2_incident_reporting_profile_for(both_limbs_false, Profile),
    incident_significance(Profile, not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]).
test(duplicate_key_is_named) :-
    nis2_incident_reporting_input_problems([attribute(early_warning_without_undue_delay, true), attribute(early_warning_without_undue_delay, false)], [duplicate_key(early_warning_without_undue_delay)]).
test(crisp_key_given_unsure_is_wrong_type) :-
    nis2_incident_reporting_input_problems([attribute(incident_ongoing_at_final_report_due, unsure)], [wrong_type(incident_ongoing_at_final_report_due)]).
test(non_list_profile_is_wrong_type) :-
    nis2_incident_reporting_input_problems(foo, [wrong_type(profile)]).
test(well_formed_profile_has_no_problem) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_input_problems(Profile, []).
test(absent_key_is_not_a_problem) :-
    nis2_incident_reporting_input_problems([], []).
test(bad_hours_is_an_argument_problem) :-
    reporting_step_timeliness([], early_warning, -3, input_problems([wrong_type(hours_elapsed)])).
test(timeliness_bound_late) :-
    reporting_step_timeliness([], early_warning, 25, late(hour_limit)).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_status(Profile, not_significant).

cp_test_names([status_holds_with_the_verdict_bound, not_significant_bound_for_both_false, duplicate_key_is_named, crisp_key_given_unsure_is_wrong_type, non_list_profile_is_wrong_type, well_formed_profile_has_no_problem, absent_key_is_not_a_problem, bad_hours_is_an_argument_problem, timeliness_bound_late]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
