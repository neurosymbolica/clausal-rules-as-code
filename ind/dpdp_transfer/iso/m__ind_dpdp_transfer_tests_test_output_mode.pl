% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4]).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [dpdp_transfer_checklist/2]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_profile_for/2]).

subject_answers(Subject, Answers) :-
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    findall(Result - Citations, restriction_status(Restriction, Profile, Result, Citations), Answers).

foreign_answers_on(ReferenceDate, Answers) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, ReferenceDate), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)], Result, Citations), Answers).

test(notified_step_6_restricted) :-
    subject_answers(notified_destination_restricted, Answers),
    Answers == [restricted_see_notification - [cite(in_dpdp_act_2023_s_16_1)]].
test(notified_step_3_not_restricted) :-
    subject_answers(notified_destination_no_notification, Answers),
    Answers == [not_restricted - [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]].
test(notified_step_1_not_in_force) :-
    subject_answers(notified_destination_section_16_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_16_1)]].
test(notified_step_2_section_16_named) :-
    subject_answers(notified_destination_section_16_unstated, Answers),
    Answers == [indeterminate([section_16_in_force_on_reference_date]) - []].
test(notified_step_4_notification_named) :-
    subject_answers(notified_destination_notification_unstated, Answers),
    Answers == [indeterminate([destination_restricted_by_notification]) - []].
test(notified_step_5_referred) :-
    subject_answers(notified_destination_notification_unclear, Answers),
    Answers == [needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification - unsure])]) - []].
test(foreign_step_10_on_commencement_day) :-
    subject_answers(foreign_state_requirements_apply_on_commencement_day, Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(foreign_step_2_day_before) :-
    subject_answers(foreign_state_day_before_commencement, Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(foreign_step_1_section_16_false) :-
    subject_answers(foreign_state_section_16_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(foreign_step_3_section_16_named) :-
    subject_answers(foreign_state_section_16_unstated, Answers),
    Answers == [indeterminate([section_16_in_force_on_reference_date]) - []].
test(foreign_step_2_settles_with_section_16_absent) :-
    subject_answers(foreign_state_section_16_unstated_day_before_commencement, Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(foreign_step_4_reference_date_named) :-
    subject_answers(foreign_state_reference_date_unstated, Answers),
    Answers == [indeterminate([reference_date]) - []].
test(foreign_step_5_recipient_not_foreign_state) :-
    subject_answers(foreign_state_recipient_not_foreign_state, Answers),
    Answers == [not_restricted - [cite(in_dpdp_rules_2025_r_15)]].
test(foreign_step_6_no_order) :-
    subject_answers(foreign_state_no_order_specified, Answers),
    Answers == [not_restricted - [cite(in_dpdp_rules_2025_r_15)]].
test(foreign_step_7_recipient_named) :-
    subject_answers(foreign_state_recipient_unstated, Answers),
    Answers == [indeterminate([recipient_is_foreign_state_or_its_entity]) - []].
test(foreign_step_8_order_named) :-
    subject_answers(foreign_state_order_unstated, Answers),
    Answers == [indeterminate([foreign_state_requirements_specified]) - []].
test(foreign_step_8_order_named_before_referral) :-
    subject_answers(foreign_state_order_unstated_recipient_unsure, Answers),
    Answers == [indeterminate([foreign_state_requirements_specified]) - []].
test(foreign_step_9_referred) :-
    subject_answers(foreign_state_recipient_unclear, Answers),
    Answers == [needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]) - []].
test(boundary_day_after_commencement_applies) :-
    foreign_answers_on(date(2027, 5, 14), Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(boundary_far_future_applies) :-
    foreign_answers_on(date(2100, 1, 1), Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(boundary_today_not_in_force) :-
    foreign_answers_on(date(2026, 11, 16), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(boundary_year_one_not_in_force) :-
    foreign_answers_on(date(1, 1, 1), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(boundary_previous_year_same_day_not_in_force) :-
    foreign_answers_on(date(2026, 5, 13), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(input_crisp_unsure) :-
    subject_answers(input_crisp_key_given_unsure, Answers),
    Answers == [input_problems([wrong_type(section_16_in_force_on_reference_date)]) - []].
test(input_duplicate) :-
    subject_answers(input_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(section_16_in_force_on_reference_date)]) - []].
test(input_unknown) :-
    subject_answers(input_unknown_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(input_not_real_day) :-
    subject_answers(input_not_a_real_day, Answers),
    Answers == [input_problems([wrong_type(reference_date)]) - []].
test(input_real_leap_day_decides) :-
    subject_answers(input_real_leap_day, Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(input_not_attribute_list) :-
    subject_answers(input_not_an_attribute_list, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(checklist_notified_restricted) :-
    dpdp_transfer_profile_for(notified_destination_restricted, Request),
    findall(Items, dpdp_transfer_checklist(Request, Items), Checklists),
    Checklists == [[item(section_16_in_force, met, cite(in_dpdp_act_2023_s_16_1)), item(destination_restricted_by_notification, met, cite(in_dpdp_act_2023_s_16_1))]].
test(checklist_foreign_on_commencement_day) :-
    dpdp_transfer_profile_for(foreign_state_requirements_apply_on_commencement_day, Request),
    findall(Items, dpdp_transfer_checklist(Request, Items), Checklists),
    Checklists == [[item(section_16_in_force, met, cite(in_dpdp_act_2023_s_16_1)), item(rule_15_in_force, met, cite(in_dpdp_rules_2025_r_1_4)), item(recipient_is_foreign_state_or_its_entity, met, cite(in_dpdp_rules_2025_r_15)), item(foreign_state_requirements_specified, met, cite(in_dpdp_rules_2025_r_15))]].

cp_test_names([notified_step_6_restricted, notified_step_3_not_restricted, notified_step_1_not_in_force, notified_step_2_section_16_named, notified_step_4_notification_named, notified_step_5_referred, foreign_step_10_on_commencement_day, foreign_step_2_day_before, foreign_step_1_section_16_false, foreign_step_3_section_16_named, foreign_step_2_settles_with_section_16_absent, foreign_step_4_reference_date_named, foreign_step_5_recipient_not_foreign_state, foreign_step_6_no_order, foreign_step_7_recipient_named, foreign_step_8_order_named, foreign_step_8_order_named_before_referral, foreign_step_9_referred, boundary_day_after_commencement_applies, boundary_far_future_applies, boundary_today_not_in_force, boundary_year_one_not_in_force, boundary_previous_year_same_day_not_in_force, input_crisp_unsure, input_duplicate, input_unknown, input_not_real_day, input_real_leap_day_decides, input_not_attribute_list, checklist_notified_restricted, checklist_foreign_on_commencement_day]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
