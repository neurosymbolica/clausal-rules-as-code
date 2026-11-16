% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [decide_gdpr_data_subject_rights_response_period/2, gdpr_data_subject_rights_response_period_status/2, gdpr_data_subject_rights_response_period_checklist/2, gdpr_data_subject_rights_response_period_decision_resolvable/1, gdpr_data_subject_rights_response_period_status_values/1, applicable_response_period/2, response_deadline/3, request_outside_facts/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_citations, [implements/1]).

gdpr_data_subject_rights_response_period_status_values([first_period, extended_period, indeterminate, needs_legal_review, input_problems]).

response_period_months(first_period, 1, cite(eu_reg_2016_679_art_12_3)).
response_period_months(extended_period, 3, cite(eu_reg_2016_679_art_12_3)).

outside_fact_row(erasure_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_1_e), union_or_member_state_law_requiring_erasure, enabling).
outside_fact_row(processing_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_3_b), union_or_member_state_law_requiring_processing, blocking).
outside_fact_row(decision_authorised_by_union_or_member_state_law, cite(eu_reg_2016_679_art_22_2_b), union_or_member_state_law_authorising_automated_decision, blocking).
outside_fact_row(legislative_restriction_applies_to_the_right, cite(eu_reg_2016_679_art_23_1), union_or_member_state_law_restricting_the_right, blocking).
outside_fact_row(public_holidays, cite(eu_reg_1971_1182_art_3), public_holidays_applicable_to_the_period, no_shift_when_absent).

weekday_kind(0, weekend_day).
weekday_kind(1, working_day).
weekday_kind(2, working_day).
weekday_kind(3, working_day).
weekday_kind(4, working_day).
weekday_kind(5, working_day).
weekday_kind(6, weekend_day).

month_weekday_offset(1, 0).
month_weekday_offset(2, 3).
month_weekday_offset(3, 2).
month_weekday_offset(4, 5).
month_weekday_offset(5, 0).
month_weekday_offset(6, 3).
month_weekday_offset(7, 5).
month_weekday_offset(8, 1).
month_weekday_offset(9, 4).
month_weekday_offset(10, 6).
month_weekday_offset(11, 2).
month_weekday_offset(12, 4).

applicable_response_period(Profile, Period) :-
    gdpr_data_subject_rights_response_period_input_problems(Profile, Problems),
    period_answer(Problems, Profile, Period).

period_answer([Problem|Problems], _, input_problems([Problem|Problems])).
period_answer([], Profile, Period) :-
    extension_claim(Profile, Claim),
    claimed_period(Claim, Profile, Period).

extension_claim(Profile, not_claimed) :-
    implements(eu_reg_2016_679_art_12_3),
    profile_lacks(Profile, extension_claimed).
extension_claim(Profile, claimed) :-
    implements(eu_reg_2016_679_art_12_3),
    profile_has(Profile, extension_claimed),
    profile_get(Profile, extension_claimed, true).
extension_claim(Profile, not_claimed) :-
    implements(eu_reg_2016_679_art_12_3),
    profile_has(Profile, extension_claimed),
    profile_get(Profile, extension_claimed, false).

claimed_period(not_claimed, _, first_period) :-
    implements(eu_reg_2016_679_art_12_3).
claimed_period(claimed, Profile, Period) :-
    implements(eu_reg_2016_679_art_12_3),
    necessity_judgement(Profile, Judgement),
    period_for_judgement(Judgement, Period).

necessity_judgement(Profile, absent) :-
    profile_lacks(Profile, extension_necessary_for_complexity_and_number).
necessity_judgement(Profile, given(Value)) :-
    profile_has(Profile, extension_necessary_for_complexity_and_number),
    profile_get(Profile, extension_necessary_for_complexity_and_number, Value).

period_for_judgement(absent, indeterminate([extension_necessary_for_complexity_and_number])) :-
    implements(eu_reg_2016_679_art_12_3).
period_for_judgement(given(true), extended_period) :-
    implements(eu_reg_2016_679_art_12_3).
period_for_judgement(given(false), first_period) :-
    implements(eu_reg_2016_679_art_12_3).
period_for_judgement(given(unsure), needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])) :-
    implements(eu_reg_2016_679_art_12_3).

response_deadline(Receipt, Period, Deadline) :-
    receipt_validity(Receipt, ReceiptValidity),
    period_validity(Period, PeriodValidity),
    deadline_for(ReceiptValidity, PeriodValidity, Receipt, Period, Deadline).

deadline_for(valid, valid, Receipt, Period, Deadline) :-
    period_deadline(Receipt, Period, Deadline).
deadline_for(invalid, valid, _, _, input_problems([wrong_type(receipt_date)])).
deadline_for(valid, invalid, _, _, input_problems([wrong_type(response_period)])).
deadline_for(invalid, invalid, _, _, input_problems([wrong_type(receipt_date), wrong_type(response_period)])).

receipt_validity(Receipt, Validity) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(request_received_on, Receipt)], Problems),
    receipt_problems_validity(Problems, Validity).

receipt_problems_validity([], valid).
receipt_problems_validity([_|_], invalid).

period_validity(Period, invalid) :-
    var(Period).
period_validity(Period, Validity) :-
    nonvar(Period),
    memberd_t(Period, [first_period, extended_period], IsPeriod),
    truth_validity(IsPeriod, Validity).

truth_validity(true, valid).
truth_validity(false, invalid).

period_deadline(Receipt, Period, Deadline) :-
    implements(eu_reg_2016_679_art_12_3),
    response_period_months(Period, Months, _Citation),
    period_last_day(Receipt, Months, LastDay),
    working_day_shift(LastDay, Deadline).

period_last_day(date(Year, Month, Day), Months, date(TargetYear, TargetMonth, TargetDay)) :-
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2_c),
    MonthIndex #= Year * 12 + Month - 1 + Months,
    TargetYear #= MonthIndex div 12,
    TargetMonth #= MonthIndex mod 12 + 1,
    month_length(TargetYear, TargetMonth, Length),
    clipped_day(Day, Length, TargetDay).

clipped_day(Day, Length, Day) :-
    implements(eu_reg_1971_1182_art_3_2_c),
    Day #=< Length.
clipped_day(Day, Length, Length) :-
    implements(eu_reg_1971_1182_art_3_2_c),
    Day #> Length.

working_day_shift(Date, Deadline) :-
    implements(eu_reg_1971_1182_art_3_4),
    weekday_number(Date, WeekdayNumber),
    weekday_kind(WeekdayNumber, Kind),
    shift_by_kind(Kind, Date, Deadline).

shift_by_kind(working_day, Date, Date) :-
    implements(eu_reg_1971_1182_art_3_4).
shift_by_kind(weekend_day, Date, Deadline) :-
    implements(eu_reg_1971_1182_art_3_4),
    next_calendar_day(Date, NextDate),
    working_day_shift(NextDate, Deadline).

weekday_number(date(Year, Month, Day), WeekdayNumber) :-
    weekday_year(Year, Month, WeekdayYear),
    month_weekday_offset(Month, Offset),
    WeekdayNumber #= (WeekdayYear + WeekdayYear div 4 - WeekdayYear div 100 + WeekdayYear div 400 + Offset + Day) mod 7.

weekday_year(Year, Month, Year) :-
    Month #>= 3.
weekday_year(Year, Month, PreviousYear) :-
    Month #< 3,
    PreviousYear #= Year - 1.

next_calendar_day(date(Year, Month, Day), date(Year, Month, NextDay)) :-
    month_length(Year, Month, Length),
    Day #< Length,
    NextDay #= Day + 1.
next_calendar_day(date(Year, Month, Day), date(Year, NextMonth, 1)) :-
    month_length(Year, Month, Length),
    Day #= Length,
    Month #< 12,
    NextMonth #= Month + 1.
next_calendar_day(date(Year, 12, 31), date(NextYear, 1, 1)) :-
    NextYear #= Year + 1.

month_length(_, 1, 31).
month_length(Year, 2, Length) :-
    leap_year_status(Year, LeapStatus),
    february_length(LeapStatus, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(leap, 29).
february_length(common, 28).

leap_year_status(Year, LeapStatus) :-
    FourYearRemainder #= Year mod 4,
    CenturyRemainder #= Year mod 100,
    FourCenturyRemainder #= Year mod 400,
    gregorian_leap_status(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, LeapStatus).

gregorian_leap_status(_, _, 0, leap).
gregorian_leap_status(0, CenturyRemainder, _, leap) :-
    CenturyRemainder #\= 0.
gregorian_leap_status(_, 0, FourCenturyRemainder, common) :-
    FourCenturyRemainder #\= 0.
gregorian_leap_status(FourYearRemainder, _, _, common) :-
    FourYearRemainder #\= 0.

request_outside_facts(Profile, OutsideFacts) :-
    gdpr_data_subject_rights_response_period_input_problems(Profile, Problems),
    outside_facts_answer(Problems, Profile, OutsideFacts).

outside_facts_answer([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_answer([], Profile, OutsideFacts) :-
    findall(Key, outside_fact_row(Key, _, _, _), Keys),
    maplist(outside_fact_record(Profile), Keys, OutsideFacts).

outside_fact_record(Profile, Key, outside_fact(Key, absent)) :-
    profile_lacks(Profile, Key).
outside_fact_record(Profile, Key, outside_fact(Key, Attested)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Attested).

decide_gdpr_data_subject_rights_response_period(Profile, gdpr_data_subject_rights_response_period_verdict(Status, Citations)) :-
    applicable_response_period(Profile, Period),
    period_status(Period, Status, Citations).

period_status(first_period, first_period, [cite(eu_reg_2016_679_art_12_3)]).
period_status(extended_period, extended_period, [cite(eu_reg_2016_679_art_12_3)]).
period_status(indeterminate(_), indeterminate, [cite(eu_reg_2016_679_art_12_3)]).
period_status(needs_legal_review(_, _), needs_legal_review, [cite(eu_reg_2016_679_art_12_3)]).
period_status(input_problems(_), input_problems, []).

gdpr_data_subject_rights_response_period_status(Profile, Status) :-
    decide_gdpr_data_subject_rights_response_period(Profile, gdpr_data_subject_rights_response_period_verdict(Status, _Citations)).

gdpr_data_subject_rights_response_period_checklist(Profile, Checklist) :-
    gdpr_data_subject_rights_response_period_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Checklist).

checklist_for([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_12_3))]).
checklist_for([], Profile, [item(extension_claimed, ClaimStatus, cite(eu_reg_2016_679_art_12_3)), item(extension_necessary_for_complexity_and_number, NecessityStatus, cite(eu_reg_2016_679_art_12_3))]) :-
    extension_claim(Profile, Claim),
    claim_status(Claim, ClaimStatus),
    necessity_row(Claim, Profile, NecessityStatus).

claim_status(claimed, met).
claim_status(not_claimed, unmet(extension_not_claimed)).

necessity_row(not_claimed, _, inapplicable).
necessity_row(claimed, Profile, NecessityStatus) :-
    necessity_judgement(Profile, Judgement),
    necessity_status(Judgement, NecessityStatus).

necessity_status(absent, unknown([extension_necessary_for_complexity_and_number])).
necessity_status(given(true), met).
necessity_status(given(false), unmet(extension_not_necessary)).
necessity_status(given(unsure), unknown([extension_necessary_for_complexity_and_number])).

gdpr_data_subject_rights_response_period_decision_resolvable(Profile) :-
    decide_gdpr_data_subject_rights_response_period(Profile, _Verdict).

test(received_29_october_ends_monday_30_november) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 30)).
test(received_31_january_ends_monday_2_march) :-
    response_deadline(date(2026, 1, 31), first_period, date(2026, 3, 2)).
test(leap_year_ends_29_february) :-
    response_deadline(date(2028, 1, 31), first_period, date(2028, 2, 29)).
test(year_end_ends_monday_1_february) :-
    response_deadline(date(2026, 12, 31), first_period, date(2027, 2, 1)).
test(extended_from_receipt_ends_30_april) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 30)).
test(extended_sunday_moves_to_monday_1_march) :-
    response_deadline(date(2026, 11, 30), extended_period, date(2027, 3, 1)).
test(deadline_has_exactly_one_solution) :-
    findall(Deadline, response_deadline(date(2026, 10, 29), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 30)].
test(impossible_receipt_is_wrong_type) :-
    response_deadline(date(2026, 2, 30), first_period, input_problems([wrong_type(receipt_date)])).
test(unknown_period_is_wrong_type) :-
    response_deadline(date(2026, 2, 3), second_period, input_problems([wrong_type(response_period)])).
test(both_arguments_wrong) :-
    findall(Deadline, response_deadline(receipt, Period, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date), wrong_type(response_period)])],
    var(Period).
test(empty_profile_is_first_period) :-
    findall(Period, applicable_response_period([], Period), Periods),
    Periods == [first_period].
test(claimed_and_necessary_is_extended) :-
    applicable_response_period([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)], extended_period).
test(claimed_not_necessary_is_first_period) :-
    applicable_response_period([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, false)], first_period).
test(claimed_without_judgement_is_indeterminate) :-
    applicable_response_period([attribute(extension_claimed, true)], indeterminate([extension_necessary_for_complexity_and_number])).
test(claimed_and_unsure_is_referred) :-
    applicable_response_period([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure)], needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])).
test(not_claimed_ignores_the_judgement) :-
    findall(Period, applicable_response_period([attribute(extension_claimed, false), attribute(extension_necessary_for_complexity_and_number, unsure)], Period), Periods),
    Periods == [first_period].
test(unknown_key_is_an_input_problem) :-
    applicable_response_period([attribute(colour, blue)], input_problems([unknown_key(colour)])).
test(not_a_list_is_wrong_type_profile) :-
    applicable_response_period(profile, input_problems([wrong_type(profile)])).
test(outside_facts_all_absent) :-
    request_outside_facts([], [outside_fact(erasure_required_by_union_or_member_state_law, absent), outside_fact(processing_required_by_union_or_member_state_law, absent), outside_fact(decision_authorised_by_union_or_member_state_law, absent), outside_fact(legislative_restriction_applies_to_the_right, absent), outside_fact(public_holidays, absent)]).
test(outside_fact_attested_is_copied) :-
    request_outside_facts([attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))], OutsideFacts),
    member(outside_fact(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none))), OutsideFacts).
test(verdict_status_projection) :-
    gdpr_data_subject_rights_response_period_status([attribute(extension_claimed, true)], indeterminate).

test(received_29_october_does_not_end_on_the_sunday, fail) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 29)).
test(extended_is_not_step_by_step, fail) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 28)).
test(empty_profile_is_not_extended, fail) :-
    applicable_response_period([], extended_period).
