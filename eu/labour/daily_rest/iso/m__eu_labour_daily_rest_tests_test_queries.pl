% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_queries, [daily_rest_profile_keys/1, daily_rest_what_if/4, daily_rest_given/0, daily_rest_not_given/0, daily_rest_not_applied_to_worker/0, daily_rest_derogation_applies/0, no_work_start_in_period/0, no_window_without_daily_rest/0, date_time/5, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, on_call_on_site_counts_as_working_time/0, on_call_standby_counts_as_working_time/0, worker_category/0, derogation_from_article_3/0, other_worker/0, mobile_worker/0, seagoing_fishing_vessel_worker/0, no_derogation/0, derogation_under_article_17_1/0, derogation_under_article_17_3/0, derogation_under_article_17_4/0, derogation_under_article_18/0, work/0, on_call_on_site/0, on_call_standby/0, paid_annual_leave/0, sick_leave/0, unsure/0]).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2]).
:- use_module(m__eu_labour_daily_rest_daily_rest, [daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6, daily_rest_threshold/1]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    daily_rest_profile_keys(ProfileKeys),
    ProfileKeys == [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, worker_category, derogation_from_article_3].
test(a_fixture_profile_has_no_input_problem) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, _, _, _, _)),
    findall(Problems, daily_rest_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(the_malformed_fixture_profile_has_its_problems) :-
    daily_rest_profile_for(malformed_profile_worker, case(Profile, _, _, _, _)),
    daily_rest_input_problems(Profile, Problems),
    Problems == [wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)].
test(the_status_is_one_verdict_with_its_checklist_citations) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers),
    Answers == [daily_rest_not_given - [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]].
test(the_shortest_rest_is_computed_in_exact_minutes) :-
    daily_rest_profile_for(single_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Minutes, shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), Answers),
    Answers == [930].
test(the_threshold_is_eleven_hours_in_minutes) :-
    findall(Threshold, daily_rest_threshold(Threshold), Thresholds),
    Thresholds == [threshold(longest_unbroken_rest_minutes, 660, cite(eu_dir_2003_88_art_3))].
test(the_outcome_flips_one_minute_below_the_threshold) :-
    daily_rest_threshold(threshold(_, MinimumMinutes, _)),
    daily_rest_profile_for(eleven_hour_rest_worker, case(HeldProfile, HeldWorker, HeldShifts, HeldStart, HeldEnd)),
    shortest_daily_rest_minutes(HeldProfile, HeldWorker, HeldShifts, HeldStart, HeldEnd, HeldMinutes),
    HeldMinutes =:= MinimumMinutes,
    first_window_without_daily_rest(HeldProfile, HeldWorker, HeldShifts, HeldStart, HeldEnd, no_window_without_daily_rest),
    daily_rest_profile_for(one_minute_short_rest_worker, case(ShortProfile, ShortWorker, ShortShifts, ShortStart, ShortEnd)),
    shortest_daily_rest_minutes(ShortProfile, ShortWorker, ShortShifts, ShortStart, ShortEnd, ShortMinutes),
    ShortMinutes =:= MinimumMinutes - 1,
    first_window_without_daily_rest(ShortProfile, ShortWorker, ShortShifts, ShortStart, ShortEnd, date_time(2026, 3, 2, 8, 0)).
test(what_if_a_derogation_under_article_18_is_stated) :-
    daily_rest_profile_for(missing_derogation_short_rest, Case),
    findall(Verdict, daily_rest_what_if(Case, derogation_from_article_3, derogation_under_article_18, Verdict), Verdicts),
    Verdicts == [daily_rest_verdict(daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)])].
test(what_if_the_unsure_judgement_is_settled_as_working_time) :-
    daily_rest_profile_for(on_call_on_site_unsure, Case),
    daily_rest_what_if(Case, on_call_on_site_counts_as_working_time, true, daily_rest_verdict(daily_rest_not_given, _)).
test(what_if_the_unsure_judgement_is_settled_as_rest) :-
    daily_rest_profile_for(on_call_on_site_unsure, Case),
    daily_rest_what_if(Case, on_call_on_site_counts_as_working_time, false, daily_rest_verdict(daily_rest_given, _)).
test(what_if_a_mobile_worker_on_day_shifts_is_still_given_the_rest) :-
    daily_rest_profile_for(missing_category_day_shifts, Case),
    daily_rest_what_if(Case, worker_category, mobile_worker, daily_rest_verdict(daily_rest_given, _)).
test(what_if_a_value_outside_its_type_is_an_input_problem) :-
    daily_rest_profile_for(short_rest_worker, Case),
    daily_rest_what_if(Case, worker_category, pilot, daily_rest_verdict(input_problems([wrong_type(worker_category)]), [])).
test(a_real_minute_is_a_date_time) :-
    findall(Holds, (date_time(2028, 2, 29, 23, 59), Holds = true), Answers),
    Answers == [true].
test(a_leap_day_minute_is_a_date_time) :-
    date_time(2028, 2, 29, 23, 59).
test(an_indeterminate_names_one_contract_key) :-
    findall(Holds, (indeterminate([derogation_from_article_3]), Holds = true), Answers),
    Answers == [true].
test(an_indeterminate_on_the_derogation_key_is_well_shaped) :-
    indeterminate([derogation_from_article_3]).
test(an_open_texture_of_an_on_call_key_is_well_shaped) :-
    open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)).
test(the_inputs_relied_on_are_a_list_of_pairs) :-
    inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure]).
test(a_referral_is_well_shaped) :-
    findall(Holds, (needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_standby_counts_as_working_time - unsure])]), Holds = true), Answers),
    Answers == [true].
test(a_referral_with_a_provenance_marker_is_well_shaped) :-
    needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure]), provenance(daily_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)])]).
test(a_provenance_marker_is_well_shaped) :-
    provenance(daily_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)]).
test(an_input_problems_term_is_well_shaped) :-
    input_problems([wrong_type(worker), wrong_type(shifts)]).
test(an_unknown_key_is_outside_the_contract) :-
    unknown_key(colour).
test(a_wrong_type_names_a_checked_name) :-
    wrong_type(period_start),
    wrong_type(worker_category).
test(a_duplicate_key_is_a_contract_key) :-
    duplicate_key(on_call_standby_counts_as_working_time).
test(the_result_atoms_are_served) :-
    daily_rest_given,
    daily_rest_not_given,
    daily_rest_not_applied_to_worker,
    daily_rest_derogation_applies,
    no_work_start_in_period,
    no_window_without_daily_rest.
test(the_profile_key_atoms_are_served) :-
    on_call_on_site_counts_as_working_time,
    on_call_standby_counts_as_working_time,
    worker_category,
    derogation_from_article_3.
test(the_enumeration_atoms_are_served) :-
    other_worker,
    mobile_worker,
    seagoing_fishing_vessel_worker,
    no_derogation,
    derogation_under_article_17_1,
    derogation_under_article_17_3,
    derogation_under_article_17_4,
    derogation_under_article_18,
    unsure.
test(the_shift_kind_atoms_are_served) :-
    work,
    on_call_on_site,
    on_call_standby,
    paid_annual_leave,
    sick_leave.

test(what_if_a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, fail) :-
    daily_rest_profile_for(missing_category_day_shifts, Case),
    daily_rest_what_if(Case, worker_category, mobile_worker, daily_rest_verdict(daily_rest_not_applied_to_worker, _)).
test(an_unreal_day_is_not_a_date_time, fail) :-
    date_time(2026, 2, 30, 8, 0).
test(an_indeterminate_with_two_keys_is_not_well_shaped, fail) :-
    indeterminate([worker_category, derogation_from_article_3]).
test(an_open_texture_of_a_category_key_is_not_well_shaped, fail) :-
    open_textured(worker_category, cite(eu_dir_2003_88_art_2_1)).
test(inputs_relied_on_that_are_not_a_list_are_not_well_shaped, fail) :-
    inputs_relied_on(on_call_on_site_counts_as_working_time).
test(a_referral_under_another_citation_is_not_well_shaped, fail) :-
    needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_2)), [inputs_relied_on([])]).
test(an_empty_input_problems_term_is_not_well_shaped, fail) :-
    input_problems([]).
test(a_contract_key_is_not_unknown, fail) :-
    unknown_key(worker_category).
test(a_wrong_type_of_an_unchecked_name_is_not_well_shaped, fail) :-
    wrong_type(colour).
test(a_duplicate_of_an_unknown_key_is_not_well_shaped, fail) :-
    duplicate_key(colour).

cp_test_names([profile_keys_are_the_contract_keys, a_fixture_profile_has_no_input_problem, the_malformed_fixture_profile_has_its_problems, the_status_is_one_verdict_with_its_checklist_citations, the_shortest_rest_is_computed_in_exact_minutes, the_threshold_is_eleven_hours_in_minutes, the_outcome_flips_one_minute_below_the_threshold, what_if_a_derogation_under_article_18_is_stated, what_if_the_unsure_judgement_is_settled_as_working_time, what_if_the_unsure_judgement_is_settled_as_rest, what_if_a_mobile_worker_on_day_shifts_is_still_given_the_rest, what_if_a_value_outside_its_type_is_an_input_problem, a_real_minute_is_a_date_time, a_leap_day_minute_is_a_date_time, an_indeterminate_names_one_contract_key, an_indeterminate_on_the_derogation_key_is_well_shaped, an_open_texture_of_an_on_call_key_is_well_shaped, the_inputs_relied_on_are_a_list_of_pairs, a_referral_is_well_shaped, a_referral_with_a_provenance_marker_is_well_shaped, a_provenance_marker_is_well_shaped, an_input_problems_term_is_well_shaped, an_unknown_key_is_outside_the_contract, a_wrong_type_names_a_checked_name, a_duplicate_key_is_a_contract_key, the_result_atoms_are_served, the_profile_key_atoms_are_served, the_enumeration_atoms_are_served, the_shift_kind_atoms_are_served]).
cp_test_fail_names([what_if_a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, an_unreal_day_is_not_a_date_time, an_indeterminate_with_two_keys_is_not_well_shaped, an_open_texture_of_a_category_key_is_not_well_shaped, inputs_relied_on_that_are_not_a_list_are_not_well_shaped, a_referral_under_another_citation_is_not_well_shaped, an_empty_input_problems_term_is_not_well_shaped, a_contract_key_is_not_unknown, a_wrong_type_of_an_unchecked_name_is_not_well_shaped, a_duplicate_of_an_unknown_key_is_not_well_shaped]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
