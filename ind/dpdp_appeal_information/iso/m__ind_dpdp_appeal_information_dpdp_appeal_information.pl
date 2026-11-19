% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_period/3, appeal_filing_requirements/3, appeal_disposal_target/3, information_call_status/3, non_disclosure_status/3, decide_dpdp_appeal_information/2, dpdp_appeal_information_status/2, dpdp_appeal_information_checklist/2, dpdp_appeal_information_decision_resolvable/1, dpdp_appeal_information_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2, eval_requirements/4]).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_citations, [implements/1]).

appeal_period_days(60, cite(in_dpdp_act_2023_s_29_2)).

disposal_target_months(6, cite(in_dpdp_act_2023_s_29_6)).

rules_22_and_23_start_day(date(2027, 5, 13), cite(in_dpdp_rules_2025_r_1_4)).

filing_requirement_item(digital_form, cite(in_dpdp_rules_2025_r_22_1)).
filing_requirement_item(fee_as_for_trai_act_appeal_unless_reduced_or_waived, cite(in_dpdp_rules_2025_r_22_2)).
filing_requirement_item(fee_paid_by_upi_or_rbi_authorised_payment_system, cite(in_dpdp_rules_2025_r_22_2)).

seventh_schedule_row(row_one, cite(in_dpdp_rules_2025_sch_7_1)).
seventh_schedule_row(row_two, cite(in_dpdp_rules_2025_sch_7_2)).
seventh_schedule_row(row_two_first_purpose, cite(in_dpdp_rules_2025_sch_7_2_i)).
seventh_schedule_row(row_two_second_purpose, cite(in_dpdp_rules_2025_sch_7_2_ii)).
seventh_schedule_row(row_three, cite(in_dpdp_rules_2025_sch_7_3)).

referral_row(appeal_against_board_order_or_direction_unclear, open_textured(appeal_against_board_order_or_direction, cite(in_dpdp_act_2023_s_29_1)), [appeal_against_board_order_or_direction, appellant_aggrieved]).
referral_row(appellant_aggrieved_unclear, open_textured(appellant_aggrieved, cite(in_dpdp_act_2023_s_29_1)), [appeal_against_board_order_or_direction, appellant_aggrieved]).
referral_row(call_for_seventh_schedule_purpose_unclear, open_textured(call_for_seventh_schedule_purpose, cite(in_dpdp_rules_2025_r_23_1)), [call_for_seventh_schedule_purpose, called_through_authorised_person]).
referral_row(called_through_authorised_person_unclear, open_textured(called_through_authorised_person, cite(in_dpdp_rules_2025_r_23_1)), [call_for_seventh_schedule_purpose, called_through_authorised_person]).
referral_row(call_outside_seventh_schedule, not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [call_for_seventh_schedule_purpose, called_through_authorised_person]).

dpdp_appeal_information_status_values([eligible, ineligible, indeterminate]).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, value(Value)) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

relied_pairs(_, [], []).
relied_pairs(Profile, [ProfileKey|InputKeys], Pairs) :-
    key_state(Profile, ProfileKey, State),
    relied_pairs(Profile, InputKeys, LaterPairs),
    add_relied_pair(State, ProfileKey, LaterPairs, Pairs).

add_relied_pair(absent, _, Pairs, Pairs).
add_relied_pair(value(Value), ProfileKey, Pairs, [ProfileKey - Value|Pairs]).

referral(Profile, Situation, needs_legal_review(Reason, [inputs_relied_on(Pairs)])) :-
    referral_row(Situation, Reason, InputKeys),
    relied_pairs(Profile, InputKeys, Pairs).

judgement_pair_outcome(value(false), _, first_false).
judgement_pair_outcome(absent, value(false), second_false).
judgement_pair_outcome(value(true), value(false), second_false).
judgement_pair_outcome(value(unsure), value(false), second_false).
judgement_pair_outcome(absent, absent, first_missing).
judgement_pair_outcome(absent, value(true), first_missing).
judgement_pair_outcome(absent, value(unsure), first_missing).
judgement_pair_outcome(value(true), absent, second_missing).
judgement_pair_outcome(value(unsure), absent, second_missing).
judgement_pair_outcome(value(unsure), value(true), first_unsure).
judgement_pair_outcome(value(unsure), value(unsure), first_unsure).
judgement_pair_outcome(value(true), value(unsure), second_unsure).
judgement_pair_outcome(value(true), value(true), both_true).

calendar_month_days(YearNumber, 2, MonthDays) :-
    leap_year_t(YearNumber, IsLeapYear),
    february_days(IsLeapYear, MonthDays).
calendar_month_days(_, MonthNumber, 31) :-
    member(MonthNumber, [1, 3, 5, 7, 8, 10, 12]).
calendar_month_days(_, MonthNumber, 30) :-
    member(MonthNumber, [4, 6, 9, 11]).

february_days(true, 29).
february_days(false, 28).

leap_year_t(YearNumber, IsLeapYear) :-
    FourYearRemainder is YearNumber mod 4,
    CenturyRemainder is YearNumber mod 100,
    FourCenturyRemainder is YearNumber mod 400,
    gregorian_leap_year_t(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_year_t(_, _, 0, true).
gregorian_leap_year_t(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_year_t(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_year_t(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

days_after(date(YearNumber, MonthNumber, DayNumber), Count, Later) :-
    calendar_month_days(YearNumber, MonthNumber, MonthDays),
    RemainingDays is MonthDays - DayNumber,
    days_after_step(YearNumber, MonthNumber, DayNumber, Count, RemainingDays, Later).

days_after_step(YearNumber, MonthNumber, DayNumber, Count, RemainingDays, date(YearNumber, MonthNumber, LaterDayNumber)) :-
    Count =< RemainingDays,
    LaterDayNumber is DayNumber + Count.
days_after_step(YearNumber, MonthNumber, _, Count, RemainingDays, Later) :-
    Count > RemainingDays,
    following_month(YearNumber, MonthNumber, NextYearNumber, NextMonthNumber),
    NextCount is Count - RemainingDays - 1,
    days_after(date(NextYearNumber, NextMonthNumber, 1), NextCount, Later).

following_month(YearNumber, 12, NextYearNumber, 1) :-
    NextYearNumber is YearNumber + 1.
following_month(YearNumber, MonthNumber, YearNumber, NextMonthNumber) :-
    MonthNumber < 12,
    NextMonthNumber is MonthNumber + 1.

months_after(date(YearNumber, MonthNumber, DayNumber), Months, date(TargetYearNumber, TargetMonthNumber, TargetDayNumber)) :-
    MonthIndex is YearNumber * 12 + MonthNumber - 1 + Months,
    TargetYearNumber is MonthIndex // 12,
    TargetMonthNumber is MonthIndex mod 12 + 1,
    calendar_month_days(TargetYearNumber, TargetMonthNumber, TargetMonthDays),
    clamped_day(DayNumber, TargetMonthDays, TargetDayNumber).

clamped_day(DayNumber, LastDayNumber, DayNumber) :-
    DayNumber =< LastDayNumber.
clamped_day(DayNumber, LastDayNumber, LastDayNumber) :-
    DayNumber > LastDayNumber.

day_number(date(YearNumber, MonthNumber, DayNumber), Number) :-
    Number is YearNumber * 10000 + MonthNumber * 100 + DayNumber.

calendar_day_before(Earlier, Later) :-
    day_number(Earlier, EarlierNumber),
    day_number(Later, LaterNumber),
    EarlierNumber < LaterNumber.

calendar_day_on_or_before(Earlier, Later) :-
    day_number(Earlier, EarlierNumber),
    day_number(Later, LaterNumber),
    EarlierNumber =< LaterNumber.

calendar_day_after(Later, Earlier) :-
    day_number(Later, LaterNumber),
    day_number(Earlier, EarlierNumber),
    LaterNumber > EarlierNumber.

calendar_day_on_or_after(Later, Earlier) :-
    day_number(Later, LaterNumber),
    day_number(Earlier, EarlierNumber),
    LaterNumber >= EarlierNumber.

appeal_last_day(ReceiptDate, LastDay) :-
    implements(in_dpdp_act_2023_s_29_2),
    appeal_period_days(PeriodDays, cite(in_dpdp_act_2023_s_29_2)),
    days_after(ReceiptDate, PeriodDays, LastDay).

disposal_target_day(FilingDate, TargetDay) :-
    implements(in_dpdp_act_2023_s_29_6),
    disposal_target_months(Months, cite(in_dpdp_act_2023_s_29_6)),
    months_after(FilingDate, Months, TargetDay).

call_date_phase(absent, absent).
call_date_phase(value(CallDate), before_rules) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rules_22_and_23_start_day(StartDay, cite(in_dpdp_rules_2025_r_1_4)),
    calendar_day_before(CallDate, StartDay).
call_date_phase(value(CallDate), from_rules) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rules_22_and_23_start_day(StartDay, cite(in_dpdp_rules_2025_r_1_4)),
    calendar_day_on_or_after(CallDate, StartDay).

appeal_period(Profile, Result, Citations) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    appeal_period_checked(Problems, Profile, Result, Citations).

appeal_period_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
appeal_period_checked([], Profile, Result, Citations) :-
    key_state(Profile, section_29_in_force_on_filing_date, SectionState),
    appeal_period_in_force(SectionState, Profile, Result, Citations).

appeal_period_in_force(value(false), _, not_in_force, [cite(in_dpdp_act_2023_s_29_1)]) :-
    implements(in_dpdp_act_2023_s_29_1).
appeal_period_in_force(absent, _, indeterminate([section_29_in_force_on_filing_date]), []).
appeal_period_in_force(value(true), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_29_1),
    implements(in_dpdp_act_2023_s_2_a),
    key_state(Profile, appeal_against_board_order_or_direction, OrderState),
    key_state(Profile, appellant_aggrieved, AggrievedState),
    judgement_pair_outcome(OrderState, AggrievedState, Outcome),
    appeal_period_standing(Outcome, Profile, Result, Citations).

appeal_period_standing(first_false, _, not_appealable, [cite(in_dpdp_act_2023_s_29_1)]) :-
    implements(in_dpdp_act_2023_s_2_c),
    implements(in_dpdp_act_2023_s_28_4),
    implements(in_dpdp_act_2023_s_28_10),
    implements(in_dpdp_act_2023_s_28_11),
    implements(in_dpdp_act_2023_s_28_12).
appeal_period_standing(second_false, _, not_appealable, [cite(in_dpdp_act_2023_s_29_1)]) :-
    implements(in_dpdp_act_2023_s_2_s),
    implements(in_dpdp_act_2023_s_2_s_i),
    implements(in_dpdp_act_2023_s_2_s_ii),
    implements(in_dpdp_act_2023_s_2_s_iii),
    implements(in_dpdp_act_2023_s_2_s_iv),
    implements(in_dpdp_act_2023_s_2_s_v),
    implements(in_dpdp_act_2023_s_2_s_vi),
    implements(in_dpdp_act_2023_s_2_s_vii).
appeal_period_standing(first_missing, _, indeterminate([appeal_against_board_order_or_direction]), []).
appeal_period_standing(second_missing, _, indeterminate([appellant_aggrieved]), []).
appeal_period_standing(Outcome, Profile, Result, Citations) :-
    standing_open(Outcome),
    key_state(Profile, order_receipt_date, ReceiptState),
    key_state(Profile, appeal_filing_date, FilingState),
    appeal_period_dates(ReceiptState, FilingState, Outcome, Profile, Result, Citations).

standing_open(first_unsure).
standing_open(second_unsure).
standing_open(both_true).

appeal_period_dates(absent, _, _, _, indeterminate([order_receipt_date]), []).
appeal_period_dates(value(_), absent, _, _, indeterminate([appeal_filing_date]), []).
appeal_period_dates(value(ReceiptDate), value(FilingDate), Outcome, Profile, Result, Citations) :-
    appeal_period_decided(Outcome, ReceiptDate, FilingDate, Profile, Result, Citations).

appeal_period_decided(first_unsure, _, _, Profile, Review, []) :-
    implements(in_dpdp_act_2023_s_29_1),
    referral(Profile, appeal_against_board_order_or_direction_unclear, Review).
appeal_period_decided(second_unsure, _, _, Profile, Review, []) :-
    implements(in_dpdp_act_2023_s_29_1),
    referral(Profile, appellant_aggrieved_unclear, Review).
appeal_period_decided(both_true, ReceiptDate, FilingDate, _, Result, Citations) :-
    appeal_period_timing(ReceiptDate, FilingDate, Result, Citations).

appeal_period_timing(ReceiptDate, FilingDate, in_time(LastDay), [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]) :-
    implements(in_dpdp_act_2023_s_29_2),
    appeal_last_day(ReceiptDate, LastDay),
    calendar_day_on_or_before(FilingDate, LastDay).
appeal_period_timing(ReceiptDate, FilingDate, out_of_time_sufficient_cause_needed(LastDay), [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_act_2023_s_29_3)]) :-
    implements(in_dpdp_act_2023_s_29_3),
    appeal_last_day(ReceiptDate, LastDay),
    calendar_day_after(FilingDate, LastDay).

appeal_filing_requirements(Profile, Result, Citations) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    filing_requirements_checked(Problems, Profile, Result, Citations).

filing_requirements_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
filing_requirements_checked([], Profile, Result, Citations) :-
    key_state(Profile, section_29_in_force_on_filing_date, SectionState),
    filing_requirements_in_force(SectionState, Profile, Result, Citations).

filing_requirements_in_force(value(false), _, not_in_force, [cite(in_dpdp_act_2023_s_29_2)]) :-
    implements(in_dpdp_act_2023_s_29_2).
filing_requirements_in_force(absent, _, indeterminate([section_29_in_force_on_filing_date]), []).
filing_requirements_in_force(value(true), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_29_2),
    key_state(Profile, appeal_filing_date, FilingState),
    filing_requirements_dated(FilingState, Result, Citations).

filing_requirements_dated(absent, indeterminate([appeal_filing_date]), []).
filing_requirements_dated(value(FilingDate), not_yet_prescribed, [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_act_2023_s_2_v),
    rules_22_and_23_start_day(StartDay, cite(in_dpdp_rules_2025_r_1_4)),
    calendar_day_before(FilingDate, StartDay).
filing_requirements_dated(value(FilingDate), filing_requirements(Items), [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_22_1), cite(in_dpdp_rules_2025_r_22_2), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_rules_2025_r_22),
    implements(in_dpdp_rules_2025_r_22_1),
    rules_22_and_23_start_day(StartDay, cite(in_dpdp_rules_2025_r_1_4)),
    calendar_day_on_or_after(FilingDate, StartDay),
    findall(Item, filing_requirement_item(Item, _), Items).

appeal_disposal_target(Profile, Result, Citations) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    disposal_target_checked(Problems, Profile, Result, Citations).

disposal_target_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
disposal_target_checked([], Profile, Result, Citations) :-
    key_state(Profile, section_29_in_force_on_filing_date, SectionState),
    disposal_target_in_force(SectionState, Profile, Result, Citations).

disposal_target_in_force(value(false), _, not_in_force, [cite(in_dpdp_act_2023_s_29_6)]) :-
    implements(in_dpdp_act_2023_s_29_6).
disposal_target_in_force(absent, _, indeterminate([section_29_in_force_on_filing_date]), []).
disposal_target_in_force(value(true), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_29_6),
    key_state(Profile, appeal_filing_date, FilingState),
    disposal_target_filed(FilingState, Profile, Result, Citations).

disposal_target_filed(absent, _, indeterminate([appeal_filing_date]), []).
disposal_target_filed(value(FilingDate), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_29_6),
    disposal_target_day(FilingDate, TargetDay),
    key_state(Profile, appeal_disposed_of_within_six_months, DisposedState),
    disposal_target_outcome(DisposedState, TargetDay, Profile, Result, Citations).

disposal_target_outcome(value(true), TargetDay, _, disposed_within_target(TargetDay), [cite(in_dpdp_act_2023_s_29_6)]) :-
    implements(in_dpdp_act_2023_s_29_6).
disposal_target_outcome(absent, _, _, indeterminate([appeal_disposed_of_within_six_months]), []).
disposal_target_outcome(value(false), TargetDay, Profile, Result, Citations) :-
    key_state(Profile, reference_date, ReferenceState),
    disposal_target_reference(ReferenceState, TargetDay, Result, Citations).

disposal_target_reference(absent, _, indeterminate([reference_date]), []).
disposal_target_reference(value(ReferenceDate), TargetDay, disposal_target_not_yet_passed(TargetDay), [cite(in_dpdp_act_2023_s_29_6)]) :-
    implements(in_dpdp_act_2023_s_29_6),
    calendar_day_on_or_before(ReferenceDate, TargetDay).
disposal_target_reference(value(ReferenceDate), TargetDay, reasons_in_writing_required(TargetDay), [cite(in_dpdp_act_2023_s_29_6), cite(in_dpdp_act_2023_s_29_7)]) :-
    implements(in_dpdp_act_2023_s_29_7),
    calendar_day_after(ReferenceDate, TargetDay).

information_call_status(Profile, Result, Citations) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    information_call_checked(Problems, Profile, Result, Citations).

information_call_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
information_call_checked([], Profile, Result, Citations) :-
    key_state(Profile, section_36_in_force_on_call_date, SectionState),
    information_call_in_force(SectionState, Profile, Result, Citations).

information_call_in_force(value(false), _, not_in_force, [cite(in_dpdp_act_2023_s_36)]) :-
    implements(in_dpdp_act_2023_s_36).
information_call_in_force(absent, _, indeterminate([section_36_in_force_on_call_date]), []).
information_call_in_force(value(true), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_36),
    key_state(Profile, recipient_kind, RecipientState),
    information_call_recipient(RecipientState, Profile, Result, Citations).

information_call_recipient(value(other_recipient), _, not_covered, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1)]) :-
    implements(in_dpdp_rules_2025_r_23_1).
information_call_recipient(absent, _, indeterminate([recipient_kind]), []).
information_call_recipient(value(board), _, required_to_furnish_under_section_36, [cite(in_dpdp_act_2023_s_36)]) :-
    implements(in_dpdp_act_2023_s_2_c).
information_call_recipient(value(data_fiduciary_or_intermediary), Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_2_i),
    implements(in_dpdp_rules_2025_r_23_3),
    key_state(Profile, call_date, CallState),
    call_date_phase(CallState, Phase),
    information_call_phase(Phase, Profile, Result, Citations).

information_call_phase(absent, _, indeterminate([call_date]), []).
information_call_phase(before_rules, _, required_to_furnish_under_section_36, [cite(in_dpdp_act_2023_s_36)]) :-
    implements(in_dpdp_act_2023_s_36).
information_call_phase(from_rules, Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_r_23),
    implements(in_dpdp_rules_2025_r_23_1),
    key_state(Profile, call_for_seventh_schedule_purpose, PurposeState),
    key_state(Profile, called_through_authorised_person, AuthorisedState),
    judgement_pair_outcome(PurposeState, AuthorisedState, Outcome),
    information_call_schedule(Outcome, Profile, Result, Citations).

information_call_schedule(first_false, Profile, Review, []) :-
    implements(in_dpdp_rules_2025_r_23_1),
    referral(Profile, call_outside_seventh_schedule, Review).
information_call_schedule(second_false, Profile, Review, []) :-
    implements(in_dpdp_rules_2025_r_23_1),
    referral(Profile, call_outside_seventh_schedule, Review).
information_call_schedule(first_missing, _, indeterminate([call_for_seventh_schedule_purpose]), []).
information_call_schedule(second_missing, _, indeterminate([called_through_authorised_person]), []).
information_call_schedule(first_unsure, Profile, Review, []) :-
    implements(in_dpdp_rules_2025_r_23_1),
    referral(Profile, call_for_seventh_schedule_purpose_unclear, Review).
information_call_schedule(second_unsure, Profile, Review, []) :-
    implements(in_dpdp_rules_2025_r_23_1),
    referral(Profile, called_through_authorised_person_unclear, Review).
information_call_schedule(both_true, _, required_to_furnish_within_specified_period, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_rules_2025_r_1_4)|RowCitations]) :-
    implements(in_dpdp_rules_2025_sch_7),
    implements(in_dpdp_act_2023_s_2_z),
    findall(RowCitation, seventh_schedule_row(_, RowCitation), RowCitations).

non_disclosure_status(Profile, Result, Citations) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    non_disclosure_checked(Problems, Profile, Result, Citations).

non_disclosure_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
non_disclosure_checked([], Profile, Result, Citations) :-
    key_state(Profile, section_36_in_force_on_call_date, SectionState),
    key_state(Profile, call_date, CallState),
    call_date_phase(CallState, Phase),
    non_disclosure_timing(SectionState, Phase, Profile, Result, Citations).

non_disclosure_timing(value(false), _, _, not_in_force, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_act_2023_s_36).
non_disclosure_timing(absent, before_rules, _, not_in_force, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_rules_2025_r_1_4).
non_disclosure_timing(value(true), before_rules, _, not_in_force, [cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_rules_2025_r_1_4).
non_disclosure_timing(absent, absent, _, indeterminate([section_36_in_force_on_call_date]), []).
non_disclosure_timing(absent, from_rules, _, indeterminate([section_36_in_force_on_call_date]), []).
non_disclosure_timing(value(true), absent, _, indeterminate([call_date]), []).
non_disclosure_timing(value(true), from_rules, Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_r_23_2),
    key_state(Profile, recipient_kind, RecipientState),
    recipient_scope(RecipientState, Scope),
    key_state(Profile, non_disclosure_required, RequiredState),
    non_disclosure_requirement(Scope, RequiredState, Profile, Result, Citations).

recipient_scope(absent, absent).
recipient_scope(value(board), outside).
recipient_scope(value(other_recipient), outside).
recipient_scope(value(data_fiduciary_or_intermediary), covered).

non_disclosure_requirement(outside, _, _, not_barred_by_rule_23, [cite(in_dpdp_rules_2025_r_23_2)]) :-
    implements(in_dpdp_rules_2025_r_23_2).
non_disclosure_requirement(absent, value(false), _, not_barred_by_rule_23, [cite(in_dpdp_rules_2025_r_23_2)]) :-
    implements(in_dpdp_rules_2025_r_23_2).
non_disclosure_requirement(covered, value(false), _, not_barred_by_rule_23, [cite(in_dpdp_rules_2025_r_23_2)]) :-
    implements(in_dpdp_rules_2025_r_23_2).
non_disclosure_requirement(absent, absent, _, indeterminate([recipient_kind]), []).
non_disclosure_requirement(absent, value(true), _, indeterminate([recipient_kind]), []).
non_disclosure_requirement(covered, absent, _, indeterminate([non_disclosure_required]), []).
non_disclosure_requirement(covered, value(true), Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_r_23_2),
    key_state(Profile, written_permission_to_disclose, PermissionState),
    non_disclosure_permission(PermissionState, Result, Citations).

non_disclosure_permission(value(true), disclosure_permitted_by_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]) :-
    implements(in_dpdp_rules_2025_r_23_2).
non_disclosure_permission(absent, indeterminate([written_permission_to_disclose]), []).
non_disclosure_permission(value(false), disclosure_barred_without_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]) :-
    implements(in_dpdp_rules_2025_r_23_2).

decide_dpdp_appeal_information(Profile, dpdp_appeal_information_verdict(eligible, Citations)) :-
    appeal_period(Profile, Result, Citations),
    verdict_status(Result, eligible).
decide_dpdp_appeal_information(Profile, dpdp_appeal_information_verdict(ineligible, Citations)) :-
    appeal_period(Profile, Result, Citations),
    verdict_status(Result, ineligible).
decide_dpdp_appeal_information(Profile, dpdp_appeal_information_verdict(indeterminate, Citations)) :-
    appeal_period(Profile, Result, Citations),
    verdict_status(Result, indeterminate).

verdict_status(in_time(_), eligible).
verdict_status(out_of_time_sufficient_cause_needed(_), ineligible).
verdict_status(not_appealable, ineligible).
verdict_status(not_in_force, ineligible).
verdict_status(indeterminate(_), indeterminate).
verdict_status(needs_legal_review(_, _), indeterminate).
verdict_status(input_problems(_), indeterminate).

dpdp_appeal_information_status(Profile, Status) :-
    decide_dpdp_appeal_information(Profile, dpdp_appeal_information_verdict(Status, _)).

dpdp_appeal_information_checklist(Profile, Items) :-
    dpdp_appeal_information_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([_|_], _, []).
checklist_for([], Profile, Items) :-
    eval_requirements([section_29_in_force, board_order_or_direction, person_aggrieved, filed_within_sixty_days], Profile, appeal_requirement, Items).

appeal_requirement(section_29_in_force, Profile, Status, cite(in_dpdp_act_2023_s_29_1)) :-
    implements(in_dpdp_act_2023_s_29),
    key_state(Profile, section_29_in_force_on_filing_date, State),
    stated_item_status(State, section_29_in_force_on_filing_date, section_29_not_in_force, Status).
appeal_requirement(board_order_or_direction, Profile, Status, cite(in_dpdp_act_2023_s_29_1)) :-
    implements(in_dpdp_act_2023_s_2_c),
    key_state(Profile, appeal_against_board_order_or_direction, State),
    stated_item_status(State, appeal_against_board_order_or_direction, not_order_or_direction_of_board, Status).
appeal_requirement(person_aggrieved, Profile, Status, cite(in_dpdp_act_2023_s_29_1)) :-
    implements(in_dpdp_act_2023_s_2_s),
    key_state(Profile, appellant_aggrieved, State),
    stated_item_status(State, appellant_aggrieved, appellant_not_aggrieved, Status).
appeal_requirement(filed_within_sixty_days, Profile, Status, cite(in_dpdp_act_2023_s_29_2)) :-
    implements(in_dpdp_act_2023_s_29_2),
    key_state(Profile, order_receipt_date, ReceiptState),
    key_state(Profile, appeal_filing_date, FilingState),
    timing_item_status(ReceiptState, FilingState, Status).

stated_item_status(absent, ProfileKey, _, unknown([ProfileKey])).
stated_item_status(value(true), _, _, met).
stated_item_status(value(false), _, Reason, unmet(Reason)).
stated_item_status(value(unsure), ProfileKey, _, unknown([ProfileKey])).

timing_item_status(absent, _, unknown([order_receipt_date])).
timing_item_status(value(_), absent, unknown([appeal_filing_date])).
timing_item_status(value(ReceiptDate), value(FilingDate), Status) :-
    appeal_last_day(ReceiptDate, LastDay),
    filing_item_status(FilingDate, LastDay, Status).

filing_item_status(FilingDate, LastDay, met) :-
    calendar_day_on_or_before(FilingDate, LastDay).
filing_item_status(FilingDate, LastDay, unmet(filed_after_last_day)) :-
    calendar_day_after(FilingDate, LastDay).

dpdp_appeal_information_decision_resolvable(Profile) :-
    decide_dpdp_appeal_information(Profile, _).

test(sixty_days_from_tenth_january_end_on_eleventh_march) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 11))], in_time(date(2027, 3, 11)), [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]).
test(a_day_late_needs_sufficient_cause) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 12))], out_of_time_sufficient_cause_needed(date(2027, 3, 11)), _).
test(sixty_days_cross_the_year) :-
    appeal_last_day(date(2027, 12, 1), date(2028, 1, 30)).
test(sixty_days_reach_the_year_ten_thousand) :-
    appeal_last_day(date(9999, 12, 31), date(10000, 2, 29)).
test(appeal_period_yields_one_solution) :-
    findall(Result - Citations, appeal_period([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, unsure), attribute(appellant_aggrieved, unsure), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 2, 1))], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(appeal_against_board_order_or_direction, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - unsure, appellant_aggrieved - unsure])]) - []].
test(a_missing_date_is_named_before_an_unsure_judgement) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, unsure), attribute(appellant_aggrieved, true)], indeterminate([order_receipt_date]), []).
test(a_section_not_in_force_settles_first) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, false), attribute(appellant_aggrieved, false)], not_in_force, [cite(in_dpdp_act_2023_s_29_1)]).
test(filing_requirements_are_listed_in_order) :-
    appeal_filing_requirements([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 5, 13))], filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]), _).
test(nothing_prescribed_the_day_before_rule_22) :-
    appeal_filing_requirements([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 5, 12))], not_yet_prescribed, _).
test(six_months_from_the_end_of_august_reach_a_leap_february) :-
    appeal_disposal_target([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2027, 8, 31)), attribute(appeal_disposed_of_within_six_months, true)], disposed_within_target(date(2028, 2, 29)), [cite(in_dpdp_act_2023_s_29_6)]).
test(reasons_in_writing_after_the_target) :-
    appeal_disposal_target([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_filing_date, date(2028, 8, 31)), attribute(appeal_disposed_of_within_six_months, false), attribute(reference_date, date(2029, 3, 1))], reasons_in_writing_required(date(2029, 2, 28)), _).
test(a_call_outside_the_schedule_is_referred) :-
    information_call_status([attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, false), attribute(called_through_authorised_person, true)], needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - false, called_through_authorised_person - true])]), []).
test(a_scheduled_call_must_be_answered_in_the_specified_period) :-
    information_call_status([attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(call_for_seventh_schedule_purpose, true), attribute(called_through_authorised_person, true)], required_to_furnish_within_specified_period, _).
test(the_board_furnishes_under_section_36) :-
    information_call_status([attribute(section_36_in_force_on_call_date, true), attribute(recipient_kind, board)], required_to_furnish_under_section_36, [cite(in_dpdp_act_2023_s_36)]).
test(disclosure_is_barred_without_permission) :-
    non_disclosure_status([attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, true), attribute(written_permission_to_disclose, false)], disclosure_barred_without_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]).
test(an_early_call_date_settles_not_in_force_before_section_36_is_named) :-
    non_disclosure_status([attribute(call_date, date(2027, 1, 1))], not_in_force, _).
test(an_unknown_key_is_an_input_problem) :-
    appeal_period([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(an_in_time_appeal_is_eligible) :-
    decide_dpdp_appeal_information([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 2, 1))], dpdp_appeal_information_verdict(eligible, _)).
test(the_checklist_cites_every_row) :-
    dpdp_appeal_information_checklist([attribute(section_29_in_force_on_filing_date, true)], Items),
    length(Items, 4).

test(a_day_late_is_not_in_time, fail) :-
    appeal_period([attribute(section_29_in_force_on_filing_date, true), attribute(appeal_against_board_order_or_direction, true), attribute(appellant_aggrieved, true), attribute(order_receipt_date, date(2027, 1, 10)), attribute(appeal_filing_date, date(2027, 3, 12))], in_time(_), _).
test(disclosure_barred_is_not_permitted, fail) :-
    non_disclosure_status([attribute(section_36_in_force_on_call_date, true), attribute(call_date, date(2027, 6, 1)), attribute(recipient_kind, data_fiduciary_or_intermediary), attribute(non_disclosure_required, true), attribute(written_permission_to_disclose, false)], disclosure_permitted_by_written_permission, _).
