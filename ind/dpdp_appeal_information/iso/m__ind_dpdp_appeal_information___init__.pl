% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_citations, [citation/2, implements/1]).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_disposal_target/3, appeal_filing_requirements/3, appeal_period/3, decide_dpdp_appeal_information/2, dpdp_appeal_information_checklist/2, dpdp_appeal_information_decision_resolvable/1, dpdp_appeal_information_status/2, dpdp_appeal_information_status_values/1, information_call_status/3, non_disclosure_status/3]).
:- use_module(m__ind_dpdp_appeal_information_queries, [disclosure_barred_without_written_permission/0, disclosure_permitted_by_written_permission/0, disposal_target_not_yet_passed/1, disposed_within_target/1, dpdp_appeal_information_profile_keys/1, dpdp_appeal_information_what_if/4, filing_requirements/1, in_time/1, indeterminate/1, input_problems/1, needs_legal_review/2, not_appealable/0, not_barred_by_rule_23/0, not_covered/0, not_governed_here/1, not_in_force/0, not_yet_prescribed/0, open_textured/2, out_of_time_sufficient_cause_needed/1, reasons_in_writing_required/1, required_to_furnish_under_section_36/0, required_to_furnish_within_specified_period/0]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_assess/2, dpdp_appeal_information_profile_for/2, dpdp_appeal_information_subject/1]).

root_export(appeal_against_board_order_or_direction).
root_export(appeal_disposed_of_within_six_months).
root_export(appeal_filing_date).
root_export(appellant_aggrieved).
root_export(board).
root_export(call_date).
root_export(call_for_seventh_schedule_purpose).
root_export(called_through_authorised_person).
root_export(data_fiduciary_or_intermediary).
root_export(digital_form).
root_export(disclosure_barred_without_written_permission).
root_export(disclosure_permitted_by_written_permission).
root_export(duplicate_key).
root_export(fee_as_for_trai_act_appeal_unless_reduced_or_waived).
root_export(fee_paid_by_upi_or_rbi_authorised_payment_system).
root_export(inputs_relied_on).
root_export(non_disclosure_required).
root_export(not_appealable).
root_export(not_barred_by_rule_23).
root_export(not_covered).
root_export(not_in_force).
root_export(not_yet_prescribed).
root_export(order_receipt_date).
root_export(other_recipient).
root_export(provenance).
root_export(recipient_kind).
root_export(reference_date).
root_export(required_to_furnish_under_section_36).
root_export(required_to_furnish_within_specified_period).
root_export(section_29_in_force_on_filing_date).
root_export(section_36_in_force_on_call_date).
root_export(unknown_key).
root_export(unsure).
root_export(written_permission_to_disclose).
root_export(wrong_type).
