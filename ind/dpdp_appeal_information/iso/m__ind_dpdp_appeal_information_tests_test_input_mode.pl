% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_period/3, appeal_filing_requirements/3, appeal_disposal_target/3, information_call_status/3, non_disclosure_status/3, dpdp_appeal_information_status/2]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_profile_for/2]).

test(in_time_holds_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    appeal_period(Profile, in_time(date(2027, 3, 11)), [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]).
test(out_of_time_holds_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(appeal_filed_day_after_last_day, Profile),
    appeal_period(Profile, out_of_time_sufficient_cause_needed(date(2027, 3, 11)), [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_act_2023_s_29_3)]).
test(not_appealable_holds_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(order_not_of_board, Profile),
    appeal_period(Profile, not_appealable, [cite(in_dpdp_act_2023_s_29_1)]).
test(filing_requirements_hold_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(filed_on_day_rules_start, Profile),
    appeal_filing_requirements(Profile, filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]), [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_22_1), cite(in_dpdp_rules_2025_r_22_2), cite(in_dpdp_rules_2025_r_1_4)]).
test(reasons_in_writing_hold_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(reference_day_after_target_day, Profile),
    appeal_disposal_target(Profile, reasons_in_writing_required(date(2027, 9, 11)), [cite(in_dpdp_act_2023_s_29_6), cite(in_dpdp_act_2023_s_29_7)]).
test(not_covered_holds_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(call_to_other_recipient, Profile),
    information_call_status(Profile, not_covered, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1)]).
test(disclosure_permitted_holds_with_the_answer_bound) :-
    dpdp_appeal_information_profile_for(disclosure_permitted, Profile),
    non_disclosure_status(Profile, disclosure_permitted_by_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]).
test(eligible_status_holds_with_the_verdict_bound) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_status(Profile, eligible).
test(the_order_of_the_attributes_does_not_matter) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    reverse(Profile, ReversedProfile),
    appeal_period(ReversedProfile, in_time(date(2027, 3, 11)), _).
test(a_non_list_profile_is_a_wrong_type) :-
    information_call_status(profile, input_problems([wrong_type(profile)]), []).
test(an_element_that_is_not_an_attribute_is_a_wrong_type) :-
    non_disclosure_status([attribute(call_date, date(2027, 6, 1)), call_date], input_problems([wrong_type(profile)]), []).
test(a_string_date_is_a_wrong_type) :-
    appeal_disposal_target([attribute(reference_date, "2027-09-11")], input_problems([wrong_type(reference_date)]), []).
test(a_number_key_is_an_unknown_key) :-
    appeal_period([attribute(42, true)], input_problems([unknown_key(42)]), []).
test(a_string_boolean_is_a_wrong_type) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, "true")], input_problems([wrong_type(section_29_in_force_on_filing_date)]), []).
test(an_impossible_day_is_a_wrong_type) :-
    appeal_filing_requirements([attribute(appeal_filing_date, date(2027, 2, 29))], input_problems([wrong_type(appeal_filing_date)]), []).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    non_disclosure_status([attribute(non_disclosure_required, unsure)], input_problems([wrong_type(non_disclosure_required)]), []).
test(an_absent_key_is_not_a_problem) :-
    appeal_period([], indeterminate([section_29_in_force_on_filing_date]), []).

test(a_wrong_last_day_bound_is_rejected, fail) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    appeal_period(Profile, in_time(date(2027, 3, 12)), _).
test(filing_items_in_another_order_are_rejected, fail) :-
    dpdp_appeal_information_profile_for(filed_on_day_rules_start, Profile),
    appeal_filing_requirements(Profile, filing_requirements([fee_as_for_trai_act_appeal_unless_reduced_or_waived, digital_form, fee_paid_by_upi_or_rbi_authorised_payment_system]), _).
test(ineligible_status_is_rejected_for_an_in_time_appeal, fail) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_status(Profile, ineligible).
test(indeterminate_status_is_rejected_for_an_in_time_appeal, fail) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_status(Profile, indeterminate).

cp_test_names([in_time_holds_with_the_answer_bound, out_of_time_holds_with_the_answer_bound, not_appealable_holds_with_the_answer_bound, filing_requirements_hold_with_the_answer_bound, reasons_in_writing_hold_with_the_answer_bound, not_covered_holds_with_the_answer_bound, disclosure_permitted_holds_with_the_answer_bound, eligible_status_holds_with_the_verdict_bound, the_order_of_the_attributes_does_not_matter, a_non_list_profile_is_a_wrong_type, an_element_that_is_not_an_attribute_is_a_wrong_type, a_string_date_is_a_wrong_type, a_number_key_is_an_unknown_key, a_string_boolean_is_a_wrong_type, an_impossible_day_is_a_wrong_type, a_crisp_key_given_unsure_is_a_wrong_type, an_absent_key_is_not_a_problem]).
cp_test_fail_names([a_wrong_last_day_bound_is_rejected, filing_items_in_another_order_are_rejected, ineligible_status_is_rejected_for_an_in_time_appeal, indeterminate_status_is_rejected_for_an_in_time_appeal]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
