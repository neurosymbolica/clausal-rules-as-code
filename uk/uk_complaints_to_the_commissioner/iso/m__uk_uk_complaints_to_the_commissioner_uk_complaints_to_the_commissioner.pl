% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [decide_uk_complaints_to_the_commissioner/2, uk_complaints_to_the_commissioner_status/2, uk_complaints_to_the_commissioner_checklist/2, uk_complaints_to_the_commissioner_decision_resolvable/1, uk_complaints_to_the_commissioner_status_values/1, controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_citations, [implements/1]).

uk_complaints_to_the_commissioner_status_values([complaint_under_section_164a, not_a_complaint_under_section_164a]).

statutory_period_days(acknowledgement_of_receipt, 30, cite(uk_dpa_2018_s_164a_3)).

commencement_day(date(2026, 6, 19), cite(uk_si_2026_82_reg_7)).

infringement_classification(section_164a_1, uk_gdpr, named, cite(uk_dpa_2018_s_164a_1)).
infringement_classification(section_164a_1, dpa_2018_part_3, named, cite(uk_dpa_2018_s_164a_1)).
infringement_classification(section_164a_1, dpa_2018_part_4, not_named, cite(uk_dpa_2018_s_164a_1)).
infringement_classification(section_164a_1, none_of_the_three, not_named, cite(uk_dpa_2018_s_164a_1)).
infringement_classification(section_165_2, uk_gdpr, named, cite(uk_dpa_2018_s_165_2)).
infringement_classification(section_165_2, dpa_2018_part_3, named, cite(uk_dpa_2018_s_165_2)).
infringement_classification(section_165_2, dpa_2018_part_4, named, cite(uk_dpa_2018_s_165_2)).
infringement_classification(section_165_2, none_of_the_three, not_named, cite(uk_dpa_2018_s_165_2)).

input_year_bounds(1900, 2199).

key_state(Profile, ProfileKey, present(Value)) :-
    profile_get(Profile, ProfileKey, Value).
key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

crisp_condition(Profile, ProfileKey, Condition) :-
    key_state(Profile, ProfileKey, State),
    crisp_state_condition(State, ProfileKey, Condition).

crisp_state_condition(present(true), _, yes).
crisp_state_condition(present(false), _, no).
crisp_state_condition(absent, ProfileKey, missing(ProfileKey)).

infringement_condition(Section, Profile, Condition) :-
    key_state(Profile, infringement_considered, State),
    infringement_state_condition(State, Section, Condition).

infringement_state_condition(absent, _, missing(infringement_considered)).
infringement_state_condition(present(Value), Section, Condition) :-
    infringement_classification(Section, Value, Classification, _),
    classification_condition(Classification, Condition).

classification_condition(named, yes).
classification_condition(not_named, no).

controller_conditions(Profile, [SubjectCondition, InfringementCondition, ControllerCondition]) :-
    implements(uk_dpa_2018_s_164a_1),
    crisp_condition(Profile, complaint_by_data_subject_about_own_personal_data, SubjectCondition),
    infringement_condition(section_164a_1, Profile, InfringementCondition),
    crisp_condition(Profile, complaint_made_to_the_controller, ControllerCondition).

commission_conditions(Profile, [SubjectCondition, InfringementCondition]) :-
    implements(uk_dpa_2018_s_165_2),
    crisp_condition(Profile, complaint_by_data_subject_about_own_personal_data, SubjectCondition),
    infringement_condition(section_165_2, Profile, InfringementCondition).

conditions_outcome(Conditions, negative) :-
    memberd_t(no, Conditions, true).
conditions_outcome(Conditions, Outcome) :-
    memberd_t(no, Conditions, false),
    first_gap(Conditions, Gap),
    gap_outcome(Gap, Outcome).

first_gap([], none).
first_gap([yes|Conditions], Gap) :-
    first_gap(Conditions, Gap).
first_gap([missing(MissingKey)|_], key(MissingKey)).

gap_outcome(none, positive).
gap_outcome(key(MissingKey), missing(MissingKey)).

controller_complaint_right(Profile, input_problems([Problem|Problems]), []) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, [Problem|Problems]).
controller_complaint_right(Profile, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]) :-
    implements(uk_dpa_2018_s_164a_1),
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    controller_conditions(Profile, Conditions),
    conditions_outcome(Conditions, negative).
controller_complaint_right(Profile, indeterminate([MissingKey]), []) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    controller_conditions(Profile, Conditions),
    conditions_outcome(Conditions, missing(MissingKey)).
controller_complaint_right(Profile, complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]) :-
    implements(uk_dpa_2018_s_164a_1),
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    controller_conditions(Profile, Conditions),
    conditions_outcome(Conditions, positive).

commission_complaint_right(Profile, input_problems([Problem|Problems]), []) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, [Problem|Problems]).
commission_complaint_right(Profile, not_a_complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]) :-
    implements(uk_dpa_2018_s_165_2),
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    commission_conditions(Profile, Conditions),
    conditions_outcome(Conditions, negative).
commission_complaint_right(Profile, indeterminate([MissingKey]), []) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    commission_conditions(Profile, Conditions),
    conditions_outcome(Conditions, missing(MissingKey)).
commission_complaint_right(Profile, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]) :-
    implements(uk_dpa_2018_s_165_2),
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    commission_conditions(Profile, Conditions),
    conditions_outcome(Conditions, positive).

receipt_validity(Term, invalid) :-
    var(Term).
receipt_validity(Term, Validity) :-
    nonvar(Term),
    Term = date(ReceiptYear, ReceiptMonth, ReceiptDay),
    date_fields_validity(ReceiptYear, ReceiptMonth, ReceiptDay, Validity).
receipt_validity(Term, invalid) :-
    nonvar(Term),
    Term \= date(_, _, _).

date_fields_validity(ReceiptYear, ReceiptMonth, ReceiptDay, Validity) :-
    all_integers_t([ReceiptYear, ReceiptMonth, ReceiptDay], AreIntegers),
    integer_fields_validity(AreIntegers, ReceiptYear, ReceiptMonth, ReceiptDay, Validity).

integer_fields_validity(false, _, _, _, invalid).
integer_fields_validity(true, ReceiptYear, ReceiptMonth, ReceiptDay, Validity) :-
    input_year_bounds(LowestYear, HighestYear),
    InRange #<==> ReceiptYear #>= LowestYear #/\ ReceiptYear #=< HighestYear #/\ ReceiptMonth #>= 1 #/\ ReceiptMonth #=< 12,
    year_month_validity(InRange, ReceiptYear, ReceiptMonth, ReceiptDay, Validity).

year_month_validity(0, _, _, _, invalid).
year_month_validity(1, ReceiptYear, ReceiptMonth, ReceiptDay, Validity) :-
    month_last_day(ReceiptYear, ReceiptMonth, LastDayOfMonth),
    DayInRange #<==> ReceiptDay #>= 1 #/\ ReceiptDay #=< LastDayOfMonth,
    day_validity(DayInRange, Validity).

day_validity(1, valid).
day_validity(0, invalid).

all_integers_t([], true).
all_integers_t([Element|Elements], Truth) :-
    integer_t(Element, ElementTruth),
    all_integers_t(Elements, RestTruth),
    truth_and(ElementTruth, RestTruth, Truth).

integer_t(Term, Truth) :-
    catch(integer_checked(Term, Truth), error(_, _), Truth = false).

integer_checked(Term, true) :-
    must_be(integer, Term).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

date_position(date(PositionYear, PositionMonth, PositionDay), Position) :-
    Position #= PositionYear * 10000 + PositionMonth * 100 + PositionDay.

receipt_commencement(Receipt, before_commencement) :-
    implements(uk_si_2026_82_reg_7),
    commencement_day(Commencement, cite(uk_si_2026_82_reg_7)),
    date_position(Receipt, ReceiptPosition),
    date_position(Commencement, CommencementPosition),
    ReceiptPosition #< CommencementPosition.
receipt_commencement(Receipt, on_or_after_commencement) :-
    implements(uk_si_2026_82_reg_7),
    commencement_day(Commencement, cite(uk_si_2026_82_reg_7)),
    date_position(Receipt, ReceiptPosition),
    date_position(Commencement, CommencementPosition),
    ReceiptPosition #>= CommencementPosition.

acknowledgement_last_day_date(Receipt, LastDay) :-
    implements(uk_dpa_2018_s_164a_3),
    statutory_period_days(acknowledgement_of_receipt, PeriodDays, cite(uk_dpa_2018_s_164a_3)),
    OffsetDays #= PeriodDays - 1,
    add_calendar_days(Receipt, OffsetDays, LastDay).

add_calendar_days(date(StartYear, StartMonth, StartDay), OffsetDays, LastDay) :-
    implements(uk_dpa_2018_s_164a_3),
    TotalDays #= StartDay + OffsetDays,
    month_last_day(StartYear, StartMonth, LastDayOfMonth),
    carry_days(TotalDays, LastDayOfMonth, StartYear, StartMonth, LastDay).

carry_days(TotalDays, LastDayOfMonth, CarryYear, CarryMonth, date(CarryYear, CarryMonth, TotalDays)) :-
    TotalDays #=< LastDayOfMonth.
carry_days(TotalDays, LastDayOfMonth, CarryYear, CarryMonth, LastDay) :-
    TotalDays #> LastDayOfMonth,
    RemainingDays #= TotalDays - LastDayOfMonth,
    following_month(CarryYear, CarryMonth, NextYear, NextMonth),
    month_last_day(NextYear, NextMonth, NextLastDayOfMonth),
    carry_days(RemainingDays, NextLastDayOfMonth, NextYear, NextMonth, LastDay).

following_month(CarryYear, CarryMonth, CarryYear, NextMonth) :-
    CarryMonth #< 12,
    NextMonth #= CarryMonth + 1.
following_month(CarryYear, 12, NextYear, 1) :-
    NextYear #= CarryYear + 1.

acknowledgement_last_day(Receipt, input_problems([wrong_type(receipt_date)]), []) :-
    receipt_validity(Receipt, invalid).
acknowledgement_last_day(Receipt, acknowledgement_duty_does_not_apply, [cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]) :-
    implements(uk_si_2026_82_reg_7),
    receipt_validity(Receipt, valid),
    receipt_commencement(Receipt, before_commencement).
acknowledgement_last_day(Receipt, LastDay, [cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]) :-
    implements(uk_dpa_2018_s_164a_3),
    receipt_validity(Receipt, valid),
    receipt_commencement(Receipt, on_or_after_commencement),
    acknowledgement_last_day_date(Receipt, LastDay).

decide_uk_complaints_to_the_commissioner(Profile, uk_complaints_to_the_commissioner_verdict(Status, Citations)) :-
    controller_complaint_right(Profile, Status, Citations).

uk_complaints_to_the_commissioner_status(Profile, Status) :-
    decide_uk_complaints_to_the_commissioner(Profile, uk_complaints_to_the_commissioner_verdict(Status, _Citations)).

uk_complaints_to_the_commissioner_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(uk_dpa_2018_s_164a_1))]) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, [Problem|Problems]).
uk_complaints_to_the_commissioner_checklist(Profile, [item(data_subject_about_own_personal_data, SubjectStatus, cite(uk_dpa_2018_s_164a_1)), item(infringement_of_uk_gdpr_or_part_3_considered, InfringementStatus, cite(uk_dpa_2018_s_164a_1)), item(complaint_made_to_the_controller, ControllerStatus, cite(uk_dpa_2018_s_164a_1))]) :-
    implements(uk_dpa_2018_s_164a_1),
    uk_complaints_to_the_commissioner_input_problems(Profile, []),
    controller_conditions(Profile, [SubjectCondition, InfringementCondition, ControllerCondition]),
    condition_item_status(SubjectCondition, not_a_data_subject_complaint_about_own_personal_data, SubjectStatus),
    condition_item_status(InfringementCondition, infringement_considered_not_named_in_section_164a_1, InfringementStatus),
    condition_item_status(ControllerCondition, complaint_not_made_to_the_controller, ControllerStatus).

condition_item_status(yes, _, met).
condition_item_status(no, Reason, unmet(Reason)).
condition_item_status(missing(MissingKey), _, unknown([MissingKey])).

uk_complaints_to_the_commissioner_decision_resolvable(Profile) :-
    decide_uk_complaints_to_the_commissioner(Profile, _Verdict).

test(controller_full_positive) :-
    findall(Result - Citations, controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, true)], Result, Citations), Answers),
    Answers == [complaint_under_section_164a - [cite(uk_dpa_2018_s_164a_1)]].
test(controller_part_3_positive) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_3), attribute(complaint_made_to_the_controller, true)], complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
test(controller_part_4_negative) :-
    findall(Result, controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4), attribute(complaint_made_to_the_controller, true)], Result, _), Results),
    Results == [not_a_complaint_under_section_164a].
test(controller_deciding_false_settles_before_missing) :-
    findall(Result - Citations, controller_complaint_right([attribute(complaint_made_to_the_controller, false)], Result, Citations), Answers),
    Answers == [not_a_complaint_under_section_164a - [cite(uk_dpa_2018_s_164a_1)]].
test(controller_empty_profile_names_first_key) :-
    findall(Result - Citations, controller_complaint_right([], Result, Citations), Answers),
    Answers == [indeterminate([complaint_by_data_subject_about_own_personal_data]) - []].
test(controller_names_second_missing_key) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(complaint_made_to_the_controller, true)], indeterminate([infringement_considered]), []).
test(controller_input_problems_first) :-
    findall(Result - Citations, controller_complaint_right([attribute(complaint_made_to_the_controller, maybe), attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(complaint_made_to_the_controller), unknown_key(colour)]) - []].
test(controller_duplicate_key) :-
    controller_complaint_right([attribute(infringement_considered, uk_gdpr), attribute(infringement_considered, uk_gdpr)], input_problems([duplicate_key(infringement_considered)]), []).
test(controller_not_a_list) :-
    controller_complaint_right(nothing, input_problems([wrong_type(profile)]), []).
test(commission_part_4_positive) :-
    findall(Result - Citations, commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4)], Result, Citations), Answers),
    Answers == [complaint_under_section_165_2 - [cite(uk_dpa_2018_s_165_2)]].
test(commission_ignores_controller_key) :-
    commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, false)], complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
test(commission_none_negative) :-
    findall(Result, commission_complaint_right([attribute(infringement_considered, none_of_the_three)], Result, _), Results),
    Results == [not_a_complaint_under_section_165_2].
test(commission_missing_infringement) :-
    commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true)], indeterminate([infringement_considered]), []).
test(acknowledgement_on_commencement_day) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2026, 6, 19), LastDay, Citations), Answers),
    Answers == [date(2026, 7, 18) - [cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(acknowledgement_crosses_year) :-
    acknowledgement_last_day(date(2026, 12, 15), date(2027, 1, 13), _).
test(acknowledgement_leap_year) :-
    acknowledgement_last_day(date(2028, 2, 10), date(2028, 3, 10), _).
test(acknowledgement_common_year) :-
    acknowledgement_last_day(date(2027, 2, 10), date(2027, 3, 11), _).
test(acknowledgement_end_of_january) :-
    acknowledgement_last_day(date(2027, 1, 31), date(2027, 3, 1), _).
test(acknowledgement_before_commencement) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2026, 6, 18), LastDay, Citations), Answers),
    Answers == [acknowledgement_duty_does_not_apply - [cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(acknowledgement_invalid_day) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2027, 2, 29), LastDay, Citations), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - []].
test(acknowledgement_year_out_of_range) :-
    acknowledgement_last_day(date(2200, 1, 1), input_problems([wrong_type(receipt_date)]), []).
test(acknowledgement_unbound) :-
    findall(LastDay, acknowledgement_last_day(_, LastDay, _), Answers),
    Answers == [input_problems([wrong_type(receipt_date)])].
test(acknowledgement_not_a_date) :-
    acknowledgement_last_day(nineteenth_june, input_problems([wrong_type(receipt_date)]), []).
test(acknowledgement_non_integer_month) :-
    acknowledgement_last_day(date(2026, june, 19), input_problems([wrong_type(receipt_date)]), []).
test(checklist_carries_citations) :-
    uk_complaints_to_the_commissioner_checklist([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4)], Items),
    Items == [item(data_subject_about_own_personal_data, met, cite(uk_dpa_2018_s_164a_1)), item(infringement_of_uk_gdpr_or_part_3_considered, unmet(infringement_considered_not_named_in_section_164a_1), cite(uk_dpa_2018_s_164a_1)), item(complaint_made_to_the_controller, unknown([complaint_made_to_the_controller]), cite(uk_dpa_2018_s_164a_1))].
test(facade_status) :-
    uk_complaints_to_the_commissioner_status([attribute(complaint_by_data_subject_about_own_personal_data, false)], not_a_complaint_under_section_164a).

test(controller_part_4_not_positive, fail) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4), attribute(complaint_made_to_the_controller, true)], complaint_under_section_164a, _).
test(commission_none_not_positive, fail) :-
    commission_complaint_right([attribute(infringement_considered, none_of_the_three)], complaint_under_section_165_2, _).
test(acknowledgement_before_commencement_no_date, fail) :-
    acknowledgement_last_day(date(2026, 6, 18), date(_, _, _), _).
