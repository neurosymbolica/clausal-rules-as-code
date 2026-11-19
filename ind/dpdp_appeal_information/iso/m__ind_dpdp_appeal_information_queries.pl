% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_queries, [dpdp_appeal_information_profile_keys/1, dpdp_appeal_information_what_if/4, in_time/1, out_of_time_sufficient_cause_needed/1, not_appealable/0, not_in_force/0, filing_requirements/1, not_yet_prescribed/0, disposed_within_target/1, disposal_target_not_yet_passed/1, reasons_in_writing_required/1, required_to_furnish_within_specified_period/0, required_to_furnish_under_section_36/0, not_covered/0, disclosure_barred_without_written_permission/0, disclosure_permitted_by_written_permission/0, not_barred_by_rule_23/0, indeterminate/1, needs_legal_review/2, open_textured/2, not_governed_here/1, input_problems/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [dpdp_appeal_information_status/2]).

dpdp_appeal_information_profile_keys([section_29_in_force_on_filing_date, appeal_against_board_order_or_direction, appellant_aggrieved, order_receipt_date, appeal_filing_date, appeal_disposed_of_within_six_months, reference_date, section_36_in_force_on_call_date, call_date, recipient_kind, call_for_seventh_schedule_purpose, called_through_authorised_person, non_disclosure_required, written_permission_to_disclose]).

dpdp_appeal_information_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dpdp_appeal_information_status(Hypothesis, NewStatus).

attribute_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    attributes_without_key(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, KeptAttributes) :-
    ElementKey == OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|KeptAttributes]) :-
    ElementKey \== OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).

in_time(date(_LastYearNumber, _LastMonthNumber, _LastDayNumber)).

out_of_time_sufficient_cause_needed(date(_LastYearNumber, _LastMonthNumber, _LastDayNumber)).

not_appealable.

not_in_force.

filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]).

not_yet_prescribed.

disposed_within_target(date(_TargetYearNumber, _TargetMonthNumber, _TargetDayNumber)).

disposal_target_not_yet_passed(date(_TargetYearNumber, _TargetMonthNumber, _TargetDayNumber)).

reasons_in_writing_required(date(_TargetYearNumber, _TargetMonthNumber, _TargetDayNumber)).

required_to_furnish_within_specified_period.

required_to_furnish_under_section_36.

not_covered.

disclosure_barred_without_written_permission.

disclosure_permitted_by_written_permission.

not_barred_by_rule_23.

indeterminate([_MissingKey]).

needs_legal_review(_ReviewReason, [inputs_relied_on(_RelyPairs)|_ProvenanceItems]).

open_textured(_UnsureKey, cite(_CitationKey)).

not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]).

input_problems([_FirstProblem|_OtherProblems]).
