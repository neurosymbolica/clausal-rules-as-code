% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [dpdp_transfer_status_values/1]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_assess/2]).

test(the_status_table_is_the_result_vocabulary) :-
    dpdp_transfer_status_values(StatusValues),
    StatusValues == [restricted_see_notification, requirements_apply_see_order, not_restricted, not_in_force].
test(notified_restricted_positive) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_not_restricted_positive) :-
    dpdp_transfer_assess(notified_destination_no_notification, dpdp_transfer_verdict(not_restricted, _)).
test(notified_not_in_force_positive) :-
    dpdp_transfer_assess(notified_destination_section_16_not_in_force, dpdp_transfer_verdict(not_in_force, _)).
test(notified_section_16_named_positive) :-
    dpdp_transfer_assess(notified_destination_section_16_unstated, dpdp_transfer_verdict(indeterminate([section_16_in_force_on_reference_date]), [])).
test(notified_notification_named_positive) :-
    dpdp_transfer_assess(notified_destination_notification_unstated, dpdp_transfer_verdict(indeterminate([destination_restricted_by_notification]), [])).
test(notified_referral_positive) :-
    dpdp_transfer_assess(notified_destination_notification_unclear, dpdp_transfer_verdict(needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), _), [])).
test(foreign_requirements_positive) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_not_in_force_day_before_positive) :-
    dpdp_transfer_assess(foreign_state_day_before_commencement, dpdp_transfer_verdict(not_in_force, _)).
test(foreign_not_in_force_section_16_false_positive) :-
    dpdp_transfer_assess(foreign_state_section_16_not_in_force, dpdp_transfer_verdict(not_in_force, _)).
test(foreign_section_16_named_positive) :-
    dpdp_transfer_assess(foreign_state_section_16_unstated, dpdp_transfer_verdict(indeterminate([section_16_in_force_on_reference_date]), [])).
test(foreign_reference_date_named_positive) :-
    dpdp_transfer_assess(foreign_state_reference_date_unstated, dpdp_transfer_verdict(indeterminate([reference_date]), [])).
test(foreign_recipient_false_positive) :-
    dpdp_transfer_assess(foreign_state_recipient_not_foreign_state, dpdp_transfer_verdict(not_restricted, _)).
test(foreign_order_false_positive) :-
    dpdp_transfer_assess(foreign_state_no_order_specified, dpdp_transfer_verdict(not_restricted, _)).
test(foreign_recipient_named_positive) :-
    dpdp_transfer_assess(foreign_state_recipient_unstated, dpdp_transfer_verdict(indeterminate([recipient_is_foreign_state_or_its_entity]), [])).
test(foreign_order_named_positive) :-
    dpdp_transfer_assess(foreign_state_order_unstated_recipient_unsure, dpdp_transfer_verdict(indeterminate([foreign_state_requirements_specified]), [])).
test(foreign_referral_positive) :-
    dpdp_transfer_assess(foreign_state_recipient_unclear, dpdp_transfer_verdict(needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), _), [])).
test(input_problems_positive) :-
    dpdp_transfer_assess(input_not_a_real_day, dpdp_transfer_verdict(input_problems([wrong_type(reference_date)]), [])).
test(input_crisp_unsure_positive) :-
    dpdp_transfer_assess(input_crisp_key_given_unsure, dpdp_transfer_verdict(input_problems(_), [])).

test(notified_restricted_near_miss_notification_false, fail) :-
    dpdp_transfer_assess(notified_destination_no_notification, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_restricted_near_miss_section_16_false, fail) :-
    dpdp_transfer_assess(notified_destination_section_16_not_in_force, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_restricted_near_miss_section_16_absent, fail) :-
    dpdp_transfer_assess(notified_destination_section_16_unstated, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_restricted_near_miss_notification_absent, fail) :-
    dpdp_transfer_assess(notified_destination_notification_unstated, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_restricted_near_miss_notification_unsure, fail) :-
    dpdp_transfer_assess(notified_destination_notification_unclear, dpdp_transfer_verdict(restricted_see_notification, _)).
test(notified_not_restricted_near_miss, fail) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(not_restricted, _)).
test(notified_not_in_force_near_miss, fail) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(not_in_force, _)).
test(notified_section_16_named_near_miss, fail) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(indeterminate(_), _)).
test(notified_notification_named_near_miss, fail) :-
    dpdp_transfer_assess(notified_destination_no_notification, dpdp_transfer_verdict(indeterminate(_), _)).
test(notified_referral_near_miss, fail) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(needs_legal_review(_, _), _)).
test(foreign_requirements_near_miss_day_before, fail) :-
    dpdp_transfer_assess(foreign_state_day_before_commencement, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_requirements_near_miss_section_16_false, fail) :-
    dpdp_transfer_assess(foreign_state_section_16_not_in_force, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_requirements_near_miss_recipient_false, fail) :-
    dpdp_transfer_assess(foreign_state_recipient_not_foreign_state, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_requirements_near_miss_order_false, fail) :-
    dpdp_transfer_assess(foreign_state_no_order_specified, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_requirements_near_miss_recipient_unsure, fail) :-
    dpdp_transfer_assess(foreign_state_recipient_unclear, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(foreign_not_in_force_commencement_day_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(not_in_force, _)).
test(foreign_not_in_force_section_16_absent_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_section_16_unstated, dpdp_transfer_verdict(not_in_force, _)).
test(foreign_section_16_named_near_miss_day_before, fail) :-
    dpdp_transfer_assess(foreign_state_section_16_unstated_day_before_commencement, dpdp_transfer_verdict(indeterminate(_), _)).
test(foreign_reference_date_named_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(indeterminate(_), _)).
test(foreign_not_restricted_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(not_restricted, _)).
test(foreign_recipient_named_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_recipient_not_foreign_state, dpdp_transfer_verdict(indeterminate(_), _)).
test(foreign_order_named_near_miss_is_not_referred, fail) :-
    dpdp_transfer_assess(foreign_state_order_unstated_recipient_unsure, dpdp_transfer_verdict(needs_legal_review(_, _), _)).
test(foreign_referral_near_miss, fail) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(needs_legal_review(_, _), _)).
test(input_problems_near_miss_real_leap_day, fail) :-
    dpdp_transfer_assess(input_real_leap_day, dpdp_transfer_verdict(input_problems(_), _)).
test(input_crisp_near_miss_true, fail) :-
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(input_problems(_), _)).

cp_test_names([the_status_table_is_the_result_vocabulary, notified_restricted_positive, notified_not_restricted_positive, notified_not_in_force_positive, notified_section_16_named_positive, notified_notification_named_positive, notified_referral_positive, foreign_requirements_positive, foreign_not_in_force_day_before_positive, foreign_not_in_force_section_16_false_positive, foreign_section_16_named_positive, foreign_reference_date_named_positive, foreign_recipient_false_positive, foreign_order_false_positive, foreign_recipient_named_positive, foreign_order_named_positive, foreign_referral_positive, input_problems_positive, input_crisp_unsure_positive]).
cp_test_fail_names([notified_restricted_near_miss_notification_false, notified_restricted_near_miss_section_16_false, notified_restricted_near_miss_section_16_absent, notified_restricted_near_miss_notification_absent, notified_restricted_near_miss_notification_unsure, notified_not_restricted_near_miss, notified_not_in_force_near_miss, notified_section_16_named_near_miss, notified_notification_named_near_miss, notified_referral_near_miss, foreign_requirements_near_miss_day_before, foreign_requirements_near_miss_section_16_false, foreign_requirements_near_miss_recipient_false, foreign_requirements_near_miss_order_false, foreign_requirements_near_miss_recipient_unsure, foreign_not_in_force_commencement_day_near_miss, foreign_not_in_force_section_16_absent_near_miss, foreign_section_16_named_near_miss_day_before, foreign_reference_date_named_near_miss, foreign_not_restricted_near_miss, foreign_recipient_named_near_miss, foreign_order_named_near_miss_is_not_referred, foreign_referral_near_miss, input_problems_near_miss_real_leap_day, input_crisp_near_miss_true]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
