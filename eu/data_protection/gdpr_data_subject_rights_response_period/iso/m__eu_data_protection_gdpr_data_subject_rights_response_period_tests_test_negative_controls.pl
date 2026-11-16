% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [gdpr_data_subject_rights_response_period_status/2, gdpr_data_subject_rights_response_period_status_values/1, response_deadline/3, request_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_profile_for/2]).

subject_status(Subject, Status) :-
    gdpr_data_subject_rights_response_period_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_period_status(Profile, Status).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    gdpr_data_subject_rights_response_period_status_values(StatusValues),
    member(first_period, StatusValues),
    member(extended_period, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(input_problems, StatusValues).
test(claimed_and_necessary_is_extended) :-
    subject_status(claimed_and_necessary, extended_period).
test(necessity_without_claim_is_first_period) :-
    subject_status(necessity_without_claim, first_period).
test(claim_withdrawn_but_necessary_is_first_period) :-
    subject_status(claim_withdrawn_but_necessary, first_period).
test(no_extension_claimed_is_first_period) :-
    subject_status(no_extension_claimed, first_period).
test(claimed_without_judgement_is_indeterminate) :-
    subject_status(claimed_without_judgement, indeterminate).
test(claimed_and_unsure_is_referred) :-
    subject_status(claimed_and_unsure, needs_legal_review).
test(unknown_key_given_is_input_problems) :-
    subject_status(unknown_key_given, input_problems).
test(duplicate_claim_given_is_input_problems) :-
    subject_status(duplicate_claim_given, input_problems).
test(claim_given_unsure_is_input_problems) :-
    subject_status(claim_given_unsure, input_problems).
test(profile_not_a_list_is_input_problems) :-
    subject_status(profile_not_a_list, input_problems).
test(unread_keys_present_is_extended) :-
    subject_status(unread_keys_present, extended_period).
test(sunday_last_day_moves_to_monday) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 30)).
test(friday_last_day_is_kept) :-
    response_deadline(date(2026, 10, 27), first_period, date(2026, 11, 27)).
test(leap_year_clip_is_twenty_ninth) :-
    response_deadline(date(2028, 1, 31), first_period, date(2028, 2, 29)).
test(extended_from_receipt_is_thirtieth_april) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 30)).
test(unknown_period_is_an_input_problem) :-
    response_deadline(date(2026, 1, 31), second_period, input_problems([wrong_type(response_period)])).
test(an_absent_holiday_list_is_recorded_absent) :-
    request_outside_facts([], OutsideFacts),
    member(outside_fact(public_holidays, absent), OutsideFacts).

test(claimed_not_necessary_is_not_extended, fail) :-
    subject_status(claimed_not_necessary, extended_period).
test(necessity_without_claim_is_not_extended, fail) :-
    subject_status(necessity_without_claim, extended_period).
test(claim_withdrawn_but_necessary_is_not_extended, fail) :-
    subject_status(claim_withdrawn_but_necessary, extended_period).
test(claimed_and_necessary_is_not_first_period, fail) :-
    subject_status(claimed_and_necessary, first_period).
test(claimed_and_necessary_is_not_indeterminate, fail) :-
    subject_status(claimed_and_necessary, indeterminate).
test(claimed_not_necessary_is_not_referred, fail) :-
    subject_status(claimed_not_necessary, needs_legal_review).
test(claimed_and_necessary_is_not_input_problems, fail) :-
    subject_status(claimed_and_necessary, input_problems).
test(unread_keys_present_is_not_input_problems, fail) :-
    subject_status(unread_keys_present, input_problems).
test(sunday_last_day_is_not_kept, fail) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 29)).
test(friday_last_day_is_not_moved, fail) :-
    response_deadline(date(2026, 10, 27), first_period, date(2026, 11, 30)).
test(leap_year_clip_is_not_twenty_eighth, fail) :-
    response_deadline(date(2028, 1, 31), first_period, date(2028, 2, 28)).
test(extended_is_not_step_by_step, fail) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 28)).
test(a_valid_period_is_not_an_input_problem, fail) :-
    response_deadline(date(2026, 1, 31), first_period, input_problems(_Problems)).
test(an_attested_holiday_list_is_not_recorded_absent, fail) :-
    request_outside_facts([attribute(public_holidays, attested([], attestation(by, at, reason, none)))], OutsideFacts),
    member(outside_fact(public_holidays, absent), OutsideFacts).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, claimed_and_necessary_is_extended, necessity_without_claim_is_first_period, claim_withdrawn_but_necessary_is_first_period, no_extension_claimed_is_first_period, claimed_without_judgement_is_indeterminate, claimed_and_unsure_is_referred, unknown_key_given_is_input_problems, duplicate_claim_given_is_input_problems, claim_given_unsure_is_input_problems, profile_not_a_list_is_input_problems, unread_keys_present_is_extended, sunday_last_day_moves_to_monday, friday_last_day_is_kept, leap_year_clip_is_twenty_ninth, extended_from_receipt_is_thirtieth_april, unknown_period_is_an_input_problem, an_absent_holiday_list_is_recorded_absent]).
cp_test_fail_names([claimed_not_necessary_is_not_extended, necessity_without_claim_is_not_extended, claim_withdrawn_but_necessary_is_not_extended, claimed_and_necessary_is_not_first_period, claimed_and_necessary_is_not_indeterminate, claimed_not_necessary_is_not_referred, claimed_and_necessary_is_not_input_problems, unread_keys_present_is_not_input_problems, sunday_last_day_is_not_kept, friday_last_day_is_not_moved, leap_year_clip_is_not_twenty_eighth, extended_is_not_step_by_step, a_valid_period_is_not_an_input_problem, an_attested_holiday_list_is_not_recorded_absent]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
