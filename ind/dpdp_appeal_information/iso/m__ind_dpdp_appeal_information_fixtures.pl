% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_subject/1, dpdp_appeal_information_profile_for/2, dpdp_appeal_information_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [decide_dpdp_appeal_information/2]).

dpdp_appeal_information_subject(appeal_filed_on_last_day).
dpdp_appeal_information_subject(appeal_filed_day_after_last_day).
dpdp_appeal_information_subject(appeal_across_year_on_last_day).
dpdp_appeal_information_subject(appeal_across_year_day_after_last_day).
dpdp_appeal_information_subject(appeal_last_day_in_year_ten_thousand).
dpdp_appeal_information_subject(section_29_not_in_force).
dpdp_appeal_information_subject(section_29_unstated).
dpdp_appeal_information_subject(order_not_of_board).
dpdp_appeal_information_subject(appellant_not_aggrieved).
dpdp_appeal_information_subject(board_order_unsure).
dpdp_appeal_information_subject(appellant_aggrieved_unsure).
dpdp_appeal_information_subject(receipt_date_missing).
dpdp_appeal_information_subject(filing_date_missing).
dpdp_appeal_information_subject(filed_on_day_rules_start).
dpdp_appeal_information_subject(filed_day_before_rules_start).
dpdp_appeal_information_subject(disposed_within_target_leap_february).
dpdp_appeal_information_subject(reference_on_target_day).
dpdp_appeal_information_subject(reference_day_after_target_day).
dpdp_appeal_information_subject(scheduled_call_on_day_rules_start).
dpdp_appeal_information_subject(call_day_before_rules_start).
dpdp_appeal_information_subject(call_to_board).
dpdp_appeal_information_subject(call_to_other_recipient).
dpdp_appeal_information_subject(section_36_not_in_force).
dpdp_appeal_information_subject(call_outside_schedule).
dpdp_appeal_information_subject(call_not_through_authorised_person).
dpdp_appeal_information_subject(schedule_purpose_unsure).
dpdp_appeal_information_subject(authorised_person_unsure).
dpdp_appeal_information_subject(disclosure_barred).
dpdp_appeal_information_subject(disclosure_permitted).
dpdp_appeal_information_subject(non_disclosure_not_required).
dpdp_appeal_information_subject(non_disclosure_call_before_rules).
dpdp_appeal_information_subject(malformed_profile).
dpdp_appeal_information_subject(duplicate_call_date).

dpdp_appeal_information_profile_for(appeal_filed_on_last_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(appeal_filed_day_after_last_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 12))]).
dpdp_appeal_information_profile_for(appeal_across_year_on_last_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 12, 1)), attribute(appeal_filing_date, date(2028, 1, 30))]).
dpdp_appeal_information_profile_for(appeal_across_year_day_after_last_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 12, 1)), attribute(appeal_filing_date, date(2028, 1, 31))]).
dpdp_appeal_information_profile_for(appeal_last_day_in_year_ten_thousand, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(9999, 12, 31)), attribute(appeal_filing_date, date(9999, 12, 31))]).
dpdp_appeal_information_profile_for(section_29_not_in_force, [attribute(section_29_in_force_on_filing_date, false), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(section_29_unstated, [attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(order_not_of_board, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, false), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(appellant_not_aggrieved, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, false), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(board_order_unsure, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, unsure), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(appellant_aggrieved_unsure, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, unsure), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(receipt_date_missing, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(appeal_filing_date, date(2027, 3, 11))]).
dpdp_appeal_information_profile_for(filing_date_missing, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10))]).
dpdp_appeal_information_profile_for(filed_on_day_rules_start, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 4, 1)), attribute(appeal_filing_date, date(2027, 5, 13))]).
dpdp_appeal_information_profile_for(filed_day_before_rules_start, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 4, 1)), attribute(appeal_filing_date, date(2027, 5, 12))]).
dpdp_appeal_information_profile_for(disposed_within_target_leap_february, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 8, 31)), attribute(appeal_disposed_of_within_six_months, true)]).
dpdp_appeal_information_profile_for(reference_on_target_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 3, 11)), attribute(appeal_disposed_of_within_six_months, false), attribute(reference_date, date(2027, 9, 11))]).
dpdp_appeal_information_profile_for(reference_day_after_target_day, [attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 3, 11)), attribute(appeal_disposed_of_within_six_months, false), attribute(reference_date, date(2027, 9, 12))]).
dpdp_appeal_information_profile_for(scheduled_call_on_day_rules_start, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, true)]).
dpdp_appeal_information_profile_for(call_day_before_rules_start, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 12)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, true)]).
dpdp_appeal_information_profile_for(call_to_board, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, board)]).
dpdp_appeal_information_profile_for(call_to_other_recipient, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, other_recipient)]).
dpdp_appeal_information_profile_for(section_36_not_in_force, [attribute(section_36_in_force_on_call_date, false), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, true)]).
dpdp_appeal_information_profile_for(call_outside_schedule, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, false), attribute(called_through_authorised_person, true)]).
dpdp_appeal_information_profile_for(call_not_through_authorised_person, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, false)]).
dpdp_appeal_information_profile_for(schedule_purpose_unsure, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, unsure), attribute(called_through_authorised_person, true)]).
dpdp_appeal_information_profile_for(authorised_person_unsure, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, unsure)]).
dpdp_appeal_information_profile_for(disclosure_barred, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, true), attribute(written_permission_to_disclose, false)]).
dpdp_appeal_information_profile_for(disclosure_permitted, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, true), attribute(written_permission_to_disclose, true)]).
dpdp_appeal_information_profile_for(non_disclosure_not_required, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 13)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, false)]).
dpdp_appeal_information_profile_for(non_disclosure_call_before_rules, [attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 5, 12)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, true), attribute(written_permission_to_disclose, false)]).
dpdp_appeal_information_profile_for(malformed_profile, [attribute(appellant_aggrieved, maybe), attribute(colour, red)]).
dpdp_appeal_information_profile_for(duplicate_call_date, [attribute(call_date, date(2027, 6, 1)), attribute(call_date, date(2027, 6, 2))]).

dpdp_appeal_information_assess(Subject, Result) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    decide_dpdp_appeal_information(Profile, Result).
