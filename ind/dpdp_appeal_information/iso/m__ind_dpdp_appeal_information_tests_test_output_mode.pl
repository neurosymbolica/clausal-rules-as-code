% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_period/3, appeal_filing_requirements/3, appeal_disposal_target/3, information_call_status/3, non_disclosure_status/3, decide_dpdp_appeal_information/2, dpdp_appeal_information_status/2, dpdp_appeal_information_checklist/2]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_profile_for/2]).

answers(Query, Subject, Answers) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers).

item_carries_citation(item(_, _, cite(_))).

test(appeal_on_the_last_day) :-
    answers(appeal_period, appeal_filed_on_last_day, Answers),
    Answers == [in_time(date(2027, 3, 11)) - [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]].
test(appeal_the_day_after_the_last_day) :-
    answers(appeal_period, appeal_filed_day_after_last_day, Answers),
    Answers == [out_of_time_sufficient_cause_needed(date(2027, 3, 11)) - [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_act_2023_s_29_3)]].
test(appeal_across_the_year_on_the_last_day) :-
    answers(appeal_period, appeal_across_year_on_last_day, Answers),
    Answers == [in_time(date(2028, 1, 30)) - [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]].
test(appeal_across_the_year_the_day_after) :-
    answers(appeal_period, appeal_across_year_day_after_last_day, Answers),
    Answers == [out_of_time_sufficient_cause_needed(date(2028, 1, 30)) - [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_act_2023_s_29_3)]].
test(a_last_day_in_the_year_ten_thousand) :-
    answers(appeal_period, appeal_last_day_in_year_ten_thousand, Answers),
    Answers == [in_time(date(10000, 2, 29)) - [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]].
test(section_29_not_in_force) :-
    answers(appeal_period, section_29_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_29_1)]].
test(section_29_unstated) :-
    answers(appeal_period, section_29_unstated, Answers),
    Answers == [indeterminate([section_29_in_force_on_filing_date]) - []].
test(appellant_not_aggrieved) :-
    answers(appeal_period, appellant_not_aggrieved, Answers),
    Answers == [not_appealable - [cite(in_dpdp_act_2023_s_29_1)]].
test(board_order_unsure_is_referred) :-
    answers(appeal_period, board_order_unsure, Answers),
    Answers == [needs_legal_review(open_textured(appeal_against_board_order_or_direction, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - unsure, appellant_aggrieved - true])]) - []].
test(appellant_aggrieved_unsure_is_referred) :-
    answers(appeal_period, appellant_aggrieved_unsure, Answers),
    Answers == [needs_legal_review(open_textured(appellant_aggrieved, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - true, appellant_aggrieved - unsure])]) - []].
test(receipt_date_missing) :-
    answers(appeal_period, receipt_date_missing, Answers),
    Answers == [indeterminate([order_receipt_date]) - []].
test(filing_date_missing) :-
    answers(appeal_period, filing_date_missing, Answers),
    Answers == [indeterminate([appeal_filing_date]) - []].
test(filed_the_day_rule_22_starts) :-
    answers(appeal_filing_requirements, filed_on_day_rules_start, Answers),
    Answers == [filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]) - [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_22_1), cite(in_dpdp_rules_2025_r_22_2), cite(in_dpdp_rules_2025_r_1_4)]].
test(filed_the_day_before_rule_22_starts) :-
    answers(appeal_filing_requirements, filed_day_before_rules_start, Answers),
    Answers == [not_yet_prescribed - [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_1_4)]].
test(disposed_within_a_leap_february_target) :-
    answers(appeal_disposal_target, disposed_within_target_leap_february, Answers),
    Answers == [disposed_within_target(date(2028, 2, 29)) - [cite(in_dpdp_act_2023_s_29_6)]].
test(asked_on_the_target_day) :-
    answers(appeal_disposal_target, reference_on_target_day, Answers),
    Answers == [disposal_target_not_yet_passed(date(2027, 9, 11)) - [cite(in_dpdp_act_2023_s_29_6)]].
test(asked_the_day_after_the_target_day) :-
    answers(appeal_disposal_target, reference_day_after_target_day, Answers),
    Answers == [reasons_in_writing_required(date(2027, 9, 11)) - [cite(in_dpdp_act_2023_s_29_6), cite(in_dpdp_act_2023_s_29_7)]].
test(a_scheduled_call_the_day_rule_23_starts) :-
    answers(information_call_status, scheduled_call_on_day_rules_start, Answers),
    Answers == [required_to_furnish_within_specified_period - [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_sch_7_1), cite(in_dpdp_rules_2025_sch_7_2), cite(in_dpdp_rules_2025_sch_7_2_i), cite(in_dpdp_rules_2025_sch_7_2_ii), cite(in_dpdp_rules_2025_sch_7_3)]].
test(a_call_the_day_before_rule_23_starts) :-
    answers(information_call_status, call_day_before_rules_start, Answers),
    Answers == [required_to_furnish_under_section_36 - [cite(in_dpdp_act_2023_s_36)]].
test(a_call_to_the_board) :-
    answers(information_call_status, call_to_board, Answers),
    Answers == [required_to_furnish_under_section_36 - [cite(in_dpdp_act_2023_s_36)]].
test(section_36_not_in_force) :-
    answers(information_call_status, section_36_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_36)]].
test(a_call_not_through_the_authorised_person_is_referred) :-
    answers(information_call_status, call_not_through_authorised_person, Answers),
    Answers == [needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - true, called_through_authorised_person - false])]) - []].
test(an_unsure_schedule_purpose_is_referred) :-
    answers(information_call_status, schedule_purpose_unsure, Answers),
    Answers == [needs_legal_review(open_textured(call_for_seventh_schedule_purpose, cite(in_dpdp_rules_2025_r_23_1)), [inputs_relied_on([call_for_seventh_schedule_purpose - unsure, called_through_authorised_person - true])]) - []].
test(an_unsure_authorised_person_is_referred) :-
    answers(information_call_status, authorised_person_unsure, Answers),
    Answers == [needs_legal_review(open_textured(called_through_authorised_person, cite(in_dpdp_rules_2025_r_23_1)), [inputs_relied_on([call_for_seventh_schedule_purpose - true, called_through_authorised_person - unsure])]) - []].
test(disclosure_barred) :-
    answers(non_disclosure_status, disclosure_barred, Answers),
    Answers == [disclosure_barred_without_written_permission - [cite(in_dpdp_rules_2025_r_23_2)]].
test(non_disclosure_not_required) :-
    answers(non_disclosure_status, non_disclosure_not_required, Answers),
    Answers == [not_barred_by_rule_23 - [cite(in_dpdp_rules_2025_r_23_2)]].
test(non_disclosure_before_rule_23_starts) :-
    answers(non_disclosure_status, non_disclosure_call_before_rules, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)]].
test(a_malformed_profile_lists_its_problems_in_order) :-
    answers(appeal_period, malformed_profile, Answers),
    Answers == [input_problems([wrong_type(appellant_aggrieved), unknown_key(colour)]) - []].
test(a_duplicate_key_is_named_once) :-
    answers(non_disclosure_status, duplicate_call_date, Answers),
    Answers == [input_problems([duplicate_key(call_date)]) - []].
test(the_eligible_verdict_carries_its_citations) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    findall(Verdict, decide_dpdp_appeal_information(Profile, Verdict), Verdicts),
    Verdicts == [dpdp_appeal_information_verdict(eligible, [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)])].
test(a_late_appeal_is_ineligible_once) :-
    dpdp_appeal_information_profile_for(appeal_filed_day_after_last_day, Profile),
    findall(Status, dpdp_appeal_information_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(an_unsure_judgement_is_indeterminate_once) :-
    dpdp_appeal_information_profile_for(board_order_unsure, Profile),
    findall(Status, dpdp_appeal_information_status(Profile, Status), Statuses),
    Statuses == [indeterminate].
test(the_checklist_has_one_cited_item_per_requirement) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_checklist(Profile, Items),
    length(Items, 4),
    maplist(item_carries_citation, Items).

cp_test_names([appeal_on_the_last_day, appeal_the_day_after_the_last_day, appeal_across_the_year_on_the_last_day, appeal_across_the_year_the_day_after, a_last_day_in_the_year_ten_thousand, section_29_not_in_force, section_29_unstated, appellant_not_aggrieved, board_order_unsure_is_referred, appellant_aggrieved_unsure_is_referred, receipt_date_missing, filing_date_missing, filed_the_day_rule_22_starts, filed_the_day_before_rule_22_starts, disposed_within_a_leap_february_target, asked_on_the_target_day, asked_the_day_after_the_target_day, a_scheduled_call_the_day_rule_23_starts, a_call_the_day_before_rule_23_starts, a_call_to_the_board, section_36_not_in_force, a_call_not_through_the_authorised_person_is_referred, an_unsure_schedule_purpose_is_referred, an_unsure_authorised_person_is_referred, disclosure_barred, non_disclosure_not_required, non_disclosure_before_rule_23_starts, a_malformed_profile_lists_its_problems_in_order, a_duplicate_key_is_named_once, the_eligible_verdict_carries_its_citations, a_late_appeal_is_ineligible_once, an_unsure_judgement_is_indeterminate_once, the_checklist_has_one_cited_item_per_requirement]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
