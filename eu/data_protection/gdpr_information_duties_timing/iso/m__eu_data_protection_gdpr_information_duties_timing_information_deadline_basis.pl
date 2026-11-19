% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [decide_information_deadline_basis/2, information_deadline_basis_status/2, information_deadline_basis_checklist/2, information_deadline_basis_decision_resolvable/1, information_deadline_basis_status_values/1, decide_information_deadline/2, deadline_resolution/2, earliest_event_limb/2, limb_a_date/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2, profile_key_status/3, keys_in_contract_order/2, calendar_date_relation/3, public_holidays_referral/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_citations, [implements/1]).

deadline_limb(art13_1, obtaining_day, cite(eu_reg_2016_679_art_13_1)).
deadline_limb(art14_3_a, one_month_after_obtaining, cite(eu_reg_2016_679_art_14_3_a)).
deadline_limb(art14_3_b, first_communication_day, cite(eu_reg_2016_679_art_14_3_b)).
deadline_limb(art14_3_c, first_disclosure_day, cite(eu_reg_2016_679_art_14_3_c)).

information_deadline_basis_status_values([art13_1, art14_3_a, art14_3_b, art14_3_c]).

month_week_offset(1, 0).
month_week_offset(2, 3).
month_week_offset(3, 2).
month_week_offset(4, 5).
month_week_offset(5, 0).
month_week_offset(6, 3).
month_week_offset(7, 5).
month_week_offset(8, 1).
month_week_offset(9, 4).
month_week_offset(10, 6).
month_week_offset(11, 2).
month_week_offset(12, 4).

week_day_year(Year, Month, WeekDayYear) :-
    Month #< 3,
    WeekDayYear #= Year - 1.
week_day_year(Year, Month, Year) :-
    Month #>= 3.

week_day_number(date(Year, Month, DayNumber), WeekDayNumber) :-
    week_day_year(Year, Month, WeekDayYear),
    month_week_offset(Month, Offset),
    WeekDayNumber #= (WeekDayYear + WeekDayYear // 4 - WeekDayYear // 100 + WeekDayYear // 400 + Offset + DayNumber) mod 7.

weekend_day(0, true).
weekend_day(1, false).
weekend_day(2, false).
weekend_day(3, false).
weekend_day(4, false).
weekend_day(5, false).
weekend_day(6, true).

following_day(date(Year, Month, DayNumber), date(Year, Month, NextDayNumber)) :-
    month_last_day(Year, Month, LastDayNumber),
    DayNumber #< LastDayNumber,
    NextDayNumber #= DayNumber + 1.
following_day(date(Year, Month, DayNumber), date(Year, NextMonth, 1)) :-
    month_last_day(Year, Month, LastDayNumber),
    DayNumber #= LastDayNumber,
    Month #< 12,
    NextMonth #= Month + 1.
following_day(date(Year, Month, DayNumber), date(NextYear, 1, 1)) :-
    month_last_day(Year, Month, LastDayNumber),
    DayNumber #= LastDayNumber,
    Month #= 12,
    NextYear #= Year + 1.

closed_day_t(Day, Holidays, Truth) :-
    implements(eu_reg_1971_1182_art_2_2),
    week_day_number(Day, WeekDayNumber),
    weekend_day(WeekDayNumber, Weekend),
    public_holiday_t(Weekend, Day, Holidays, Truth).

public_holiday_t(true, _, _, true).
public_holiday_t(false, Day, Holidays, Truth) :-
    memberd_t(Day, Holidays, Truth).

capped_day(DayNumber, LastDayNumber, DayNumber) :-
    DayNumber #=< LastDayNumber.
capped_day(DayNumber, LastDayNumber, LastDayNumber) :-
    DayNumber #> LastDayNumber.

month_period_end(date(Year, Month, DayNumber), date(EndYear, EndMonth, EndDayNumber)) :-
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2_c),
    MonthsFromJanuary #= Month - 1 + 1,
    EndYear #= Year + MonthsFromJanuary // 12,
    EndMonth #= MonthsFromJanuary mod 12 + 1,
    month_last_day(EndYear, EndMonth, LastDayNumber),
    capped_day(DayNumber, LastDayNumber, EndDayNumber).

period_last_day(Candidate, Holidays, LastDay) :-
    closed_day_t(Candidate, Holidays, Closed),
    move_closed_day(Closed, Candidate, Holidays, LastDay).

move_closed_day(false, Day, _, Day).
move_closed_day(true, Day, Holidays, LastDay) :-
    implements(eu_reg_1971_1182_art_3_4),
    following_day(Day, NextDay),
    period_last_day(NextDay, Holidays, LastDay).

limb_a_date(ObtainingDate, Holidays, LastDay) :-
    implements(eu_reg_2016_679_art_14_3_a),
    implements(eu_reg_1971_1182_art_3),
    month_period_end(ObtainingDate, NominalDay),
    period_last_day(NominalDay, Holidays, LastDay).

communication_limb(Profile, Status) :-
    profile_key_status(Profile, data_used_for_communication_with_data_subject, FlagStatus),
    communication_flag_limb(FlagStatus, Profile, Status).

communication_flag_limb(absent, _, missing([data_used_for_communication_with_data_subject])).
communication_flag_limb(present(false), _, known(no_event)).
communication_flag_limb(present(true), Profile, Status) :-
    implements(eu_reg_2016_679_art_14_3_b),
    profile_key_status(Profile, first_communication_date, DateStatus),
    communication_date_limb(DateStatus, Status).

communication_date_limb(present(EventDate), known(event(EventDate, art14_3_b))).
communication_date_limb(absent, missing([first_communication_date])).

disclosure_limb(Profile, Status) :-
    profile_key_status(Profile, disclosure_to_another_recipient_envisaged, FlagStatus),
    disclosure_flag_limb(FlagStatus, Profile, Status).

disclosure_flag_limb(absent, _, missing([disclosure_to_another_recipient_envisaged])).
disclosure_flag_limb(present(false), _, known(no_event)).
disclosure_flag_limb(present(true), Profile, Status) :-
    implements(eu_reg_2016_679_art_14_3_c),
    implements(eu_reg_2016_679_art_4_9),
    profile_key_status(Profile, first_disclosure_date, DateStatus),
    disclosure_date_limb(DateStatus, Status).

disclosure_date_limb(present(EventDate), known(event(EventDate, art14_3_c))).
disclosure_date_limb(absent, missing([first_disclosure_date])).

earliest_event_limb(Profile, Status) :-
    communication_limb(Profile, CommunicationStatus),
    disclosure_limb(Profile, DisclosureStatus),
    combine_event_limbs(CommunicationStatus, DisclosureStatus, Status).

combine_event_limbs(known(CommunicationEvent), known(DisclosureEvent), known(Event)) :-
    earlier_event(CommunicationEvent, DisclosureEvent, Event).
combine_event_limbs(known(_), missing(MissingKeys), missing(MissingKeys)).
combine_event_limbs(missing(MissingKeys), known(_), missing(MissingKeys)).
combine_event_limbs(missing(CommunicationKeys), missing(DisclosureKeys), missing(MissingKeys)) :-
    append(CommunicationKeys, DisclosureKeys, MissingKeys).

earlier_event(no_event, Event, Event).
earlier_event(event(EventDate, Limb), no_event, event(EventDate, Limb)).
earlier_event(event(FirstDate, FirstLimb), event(SecondDate, SecondLimb), Event) :-
    calendar_date_relation(FirstDate, SecondDate, Relation),
    earlier_of(Relation, event(FirstDate, FirstLimb), event(SecondDate, SecondLimb), Event).

earlier_of(before, First, _, First).
earlier_of(same, First, _, First).
earlier_of(after, _, Second, Second).

deadline_resolution(Profile, Resolution) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    resolution_for_problems(Problems, Profile, Resolution).

resolution_for_problems([Problem|Problems], _, problems([Problem|Problems])).
resolution_for_problems([], Profile, Resolution) :-
    profile_key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    route_resolution(RouteStatus, Profile, Resolution).

route_resolution(present(true), Profile, Resolution) :-
    implements(eu_reg_2016_679_art_13_1),
    implements(eu_reg_2016_679_art_4_1),
    implements(eu_reg_2016_679_art_4_7),
    profile_key_status(Profile, obtaining_date, ObtainingStatus),
    article_13_resolution(ObtainingStatus, Resolution).
route_resolution(present(false), Profile, Resolution) :-
    implements(eu_reg_2016_679_art_14_1),
    implements(eu_reg_2016_679_art_4_1),
    implements(eu_reg_2016_679_art_4_7),
    profile_key_status(Profile, obtaining_date, ObtainingStatus),
    earliest_event_limb(Profile, EventStatus),
    article_14_resolution(ObtainingStatus, EventStatus, Profile, Resolution).
route_resolution(absent, Profile, Resolution) :-
    profile_key_status(Profile, obtaining_date, ObtainingStatus),
    earliest_event_limb(Profile, EventStatus),
    route_unknown_resolution(ObtainingStatus, EventStatus, Resolution).

article_13_resolution(present(ObtainingDate), fixed(ObtainingDate, art13_1)).
article_13_resolution(absent, missing([obtaining_date])).

article_14_resolution(present(ObtainingDate), known(Event), Profile, Resolution) :-
    profile_key_status(Profile, public_holidays, HolidaysStatus),
    limb_a_resolution(HolidaysStatus, ObtainingDate, Event, Resolution).
article_14_resolution(absent, known(_), _, missing([obtaining_date])).
article_14_resolution(present(_), missing(MissingKeys), _, missing(OrderedKeys)) :-
    keys_in_contract_order(MissingKeys, OrderedKeys).
article_14_resolution(absent, missing(MissingKeys), _, missing(OrderedKeys)) :-
    keys_in_contract_order([obtaining_date|MissingKeys], OrderedKeys).

limb_a_resolution(present(attested(Holidays, _)), ObtainingDate, Event, Resolution) :-
    limb_a_date(ObtainingDate, Holidays, LimbADate),
    attested_deadline(LimbADate, Event, Resolution).
limb_a_resolution(absent, ObtainingDate, Event, Resolution) :-
    implements(eu_reg_1971_1182_art_3_4),
    limb_a_date(ObtainingDate, [], LimbADateWithoutHolidays),
    unattested_resolution(LimbADateWithoutHolidays, Event, Resolution).

attested_deadline(LimbADate, no_event, fixed(LimbADate, art14_3_a)) :-
    implements(eu_reg_2016_679_art_14_3_a).
attested_deadline(LimbADate, event(EventDate, Limb), Resolution) :-
    calendar_date_relation(EventDate, LimbADate, Relation),
    attested_choice(Relation, LimbADate, EventDate, Limb, Resolution).

attested_choice(before, _, EventDate, Limb, fixed(EventDate, Limb)).
attested_choice(same, LimbADate, _, _, fixed(LimbADate, art14_3_a)) :-
    implements(eu_reg_2016_679_art_14_3_a).
attested_choice(after, LimbADate, _, _, fixed(LimbADate, art14_3_a)) :-
    implements(eu_reg_2016_679_art_14_3_a).

unattested_resolution(LimbADateWithoutHolidays, no_event, holidays_unattested(LimbADateWithoutHolidays, no_event)).
unattested_resolution(LimbADateWithoutHolidays, event(EventDate, Limb), Resolution) :-
    calendar_date_relation(EventDate, LimbADateWithoutHolidays, Relation),
    unattested_event_resolution(Relation, LimbADateWithoutHolidays, EventDate, Limb, Resolution).

unattested_event_resolution(before, _, EventDate, Limb, fixed(EventDate, Limb)) :-
    implements(eu_reg_1971_1182_art_3_4).
unattested_event_resolution(same, LimbADateWithoutHolidays, EventDate, Limb, holidays_unattested(LimbADateWithoutHolidays, event(EventDate, Limb))).
unattested_event_resolution(after, LimbADateWithoutHolidays, EventDate, Limb, holidays_unattested(LimbADateWithoutHolidays, event(EventDate, Limb))).

route_unknown_resolution(present(ObtainingDate), known(event(EventDate, _)), Resolution) :-
    calendar_date_relation(EventDate, ObtainingDate, Relation),
    route_unknown_on_event(Relation, ObtainingDate, Resolution).
route_unknown_resolution(present(_), known(no_event), missing([personal_data_collected_from_data_subject])).
route_unknown_resolution(present(_), missing(_), missing([personal_data_collected_from_data_subject])).
route_unknown_resolution(absent, _, missing([personal_data_collected_from_data_subject, obtaining_date])).

route_unknown_on_event(same, ObtainingDate, fixed_route_unknown(ObtainingDate)) :-
    implements(eu_reg_2016_679_art_13_1).
route_unknown_on_event(before, _, missing([personal_data_collected_from_data_subject])).
route_unknown_on_event(after, _, missing([personal_data_collected_from_data_subject])).

decide_information_deadline(Profile, Deadline) :-
    deadline_resolution(Profile, Resolution),
    deadline_answer(Resolution, Deadline).

deadline_answer(problems(Problems), input_problems(Problems)).
deadline_answer(missing(MissingKeys), indeterminate(MissingKeys)).
deadline_answer(fixed(DeadlineDate, _), DeadlineDate).
deadline_answer(fixed_route_unknown(DeadlineDate), DeadlineDate).
deadline_answer(holidays_unattested(_, no_event), Referral) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([], Referral).
deadline_answer(holidays_unattested(LimbADateWithoutHolidays, event(EventDate, _)), Deadline) :-
    calendar_date_relation(EventDate, LimbADateWithoutHolidays, Relation),
    unattested_deadline(Relation, EventDate, Deadline).

unattested_deadline(before, EventDate, EventDate).
unattested_deadline(same, EventDate, EventDate).
unattested_deadline(after, _, Referral) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([], Referral).

decide_information_deadline_basis(Profile, Verdict) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    basis_for_problems(Problems, Profile, Verdict).

basis_for_problems([Problem|Problems], _, information_deadline_basis_verdict(input_problems([Problem|Problems]), [])).
basis_for_problems([], Profile, Verdict) :-
    profile_key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    basis_for_route(RouteStatus, Profile, Verdict).

basis_for_route(absent, _, information_deadline_basis_verdict(indeterminate([personal_data_collected_from_data_subject]), [])).
basis_for_route(present(true), _, information_deadline_basis_verdict(art13_1, [cite(eu_reg_2016_679_art_13_1)])) :-
    implements(eu_reg_2016_679_art_13_1).
basis_for_route(present(false), Profile, Verdict) :-
    implements(eu_reg_2016_679_art_14_1),
    profile_key_status(Profile, data_used_for_communication_with_data_subject, CommunicationStatus),
    profile_key_status(Profile, disclosure_to_another_recipient_envisaged, DisclosureStatus),
    both_event_flags_false_t(CommunicationStatus, DisclosureStatus, BothFalse),
    article_14_basis(BothFalse, Profile, Verdict).

both_event_flags_false_t(present(false), present(false), true).
both_event_flags_false_t(present(false), present(true), false).
both_event_flags_false_t(present(false), absent, false).
both_event_flags_false_t(present(true), _, false).
both_event_flags_false_t(absent, _, false).

article_14_basis(true, _, information_deadline_basis_verdict(art14_3_a, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
article_14_basis(false, Profile, Verdict) :-
    deadline_resolution(Profile, Resolution),
    basis_from_resolution(Resolution, Verdict).

basis_from_resolution(fixed(_, Basis), information_deadline_basis_verdict(Basis, [Citation])) :-
    deadline_limb(Basis, _, Citation).
basis_from_resolution(missing(MissingKeys), information_deadline_basis_verdict(indeterminate(MissingKeys), [])).
basis_from_resolution(holidays_unattested(_, no_event), information_deadline_basis_verdict(art14_3_a, [cite(eu_reg_2016_679_art_14_3_a)])) :-
    implements(eu_reg_2016_679_art_14_3_a).
basis_from_resolution(holidays_unattested(_, event(_, _)), information_deadline_basis_verdict(Referral, [])) :-
    implements(eu_reg_1971_1182_art_3_4),
    public_holidays_referral([], Referral).

information_deadline_basis_status(Profile, Status) :-
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(Status, _Citations)).

information_deadline_basis_checklist(Profile, Items) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([Problem|Problems], _, [item(deadline_basis, input_problems([Problem|Problems]), [])]).
checklist_for_problems([], Profile, [item(article_13_route, RouteItemStatus, cite(eu_reg_2016_679_art_13_1)), item(article_14_3_b_first_communication, CommunicationItemStatus, cite(eu_reg_2016_679_art_14_3_b)), item(article_14_3_c_first_disclosure, DisclosureItemStatus, cite(eu_reg_2016_679_art_14_3_c)), item(deadline_basis, Basis, Citations)]) :-
    profile_key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    flag_item_status(RouteStatus, personal_data_collected_from_data_subject, not_collected_from_data_subject, RouteItemStatus),
    profile_key_status(Profile, data_used_for_communication_with_data_subject, CommunicationStatus),
    flag_item_status(CommunicationStatus, data_used_for_communication_with_data_subject, no_communication_with_data_subject, CommunicationItemStatus),
    profile_key_status(Profile, disclosure_to_another_recipient_envisaged, DisclosureStatus),
    flag_item_status(DisclosureStatus, disclosure_to_another_recipient_envisaged, no_disclosure_envisaged, DisclosureItemStatus),
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(Basis, Citations)).

flag_item_status(present(true), _, _, met).
flag_item_status(present(false), _, Reason, unmet(Reason)).
flag_item_status(absent, Key, _, unknown([Key])).

information_deadline_basis_decision_resolvable(Profile) :-
    decide_information_deadline_basis(Profile, _Verdict).

test(limb_a_sunday_moves_to_monday) :-
    limb_a_date(date(2026, 1, 15), [], LastDay),
    LastDay == date(2026, 2, 16).
test(limb_a_saturday_moves_over_the_weekend) :-
    limb_a_date(date(2026, 1, 31), [], LastDay),
    LastDay == date(2026, 3, 2).
test(limb_a_leap_day) :-
    limb_a_date(date(2028, 1, 31), [], LastDay),
    LastDay == date(2028, 2, 29).
test(limb_a_capped_at_the_last_day_of_the_month) :-
    limb_a_date(date(2026, 3, 31), [], LastDay),
    LastDay == date(2026, 4, 30).
test(limb_a_crosses_the_year) :-
    limb_a_date(date(2026, 12, 15), [], LastDay),
    LastDay == date(2027, 1, 15).
test(limb_a_year_end_sunday) :-
    limb_a_date(date(2026, 12, 31), [], LastDay),
    LastDay == date(2027, 2, 1).
test(limb_a_same_date_next_month) :-
    limb_a_date(date(2026, 5, 30), [], LastDay),
    LastDay == date(2026, 6, 30).
test(limb_a_public_holiday_moves_to_the_next_working_day) :-
    limb_a_date(date(2026, 12, 31), [date(2027, 2, 1)], LastDay),
    LastDay == date(2027, 2, 2).
test(article_13_deadline_is_the_obtaining_day) :-
    findall(Deadline, decide_information_deadline([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], Deadline), Deadlines),
    Deadlines == [date(2026, 3, 10)].
test(article_13_basis) :-
    findall(Basis, information_deadline_basis_status([attribute(personal_data_collected_from_data_subject, true)], Basis), Bases),
    Bases == [art13_1].
test(article_14_limb_a_with_attested_holidays) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    findall(Deadline, decide_information_deadline(Profile, Deadline), Deadlines),
    Deadlines == [date(2026, 2, 16)],
    findall(Verdict, decide_information_deadline_basis(Profile, Verdict), Verdicts),
    Verdicts == [information_deadline_basis_verdict(art14_3_a, [cite(eu_reg_2016_679_art_14_3_a)])].
test(article_14_first_communication_binds) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    decide_information_deadline(Profile, date(2026, 1, 20)),
    information_deadline_basis_status(Profile, art14_3_b).
test(a_tie_of_b_and_c_names_b) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 1, 20)), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    findall(Basis, information_deadline_basis_status(Profile, Basis), Bases),
    Bases == [art14_3_b].
test(a_tie_with_limb_a_names_a) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 2, 16)), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    information_deadline_basis_status(Profile, art14_3_a).
test(no_x_and_no_holidays_refers_the_deadline_but_not_the_basis) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)],
    findall(Deadline, decide_information_deadline(Profile, Deadline), Deadlines),
    Deadlines == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([])])],
    information_deadline_basis_status(Profile, art14_3_a).
test(x_equal_to_a0_without_holidays_fixes_the_deadline_and_refers_the_basis) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 2, 16)), attribute(disclosure_to_another_recipient_envisaged, false)],
    decide_information_deadline(Profile, date(2026, 2, 16)),
    information_deadline_basis_status(Profile, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(x_before_a0_without_holidays_is_fixed) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 2, 1))],
    decide_information_deadline(Profile, date(2026, 2, 1)),
    information_deadline_basis_status(Profile, art14_3_c).
test(route_unknown_names_the_route_for_the_basis) :-
    findall(Basis, information_deadline_basis_status([attribute(obtaining_date, date(2026, 1, 15))], Basis), Bases),
    Bases == [indeterminate([personal_data_collected_from_data_subject])].
test(route_unknown_names_the_keys_of_both_routes) :-
    decide_information_deadline([attribute(data_used_for_communication_with_data_subject, true)], Deadline),
    Deadline == indeterminate([personal_data_collected_from_data_subject, obtaining_date]).
test(route_unknown_settled_by_an_x_on_the_obtaining_day) :-
    Profile = [attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 15)), attribute(disclosure_to_another_recipient_envisaged, false)],
    findall(Deadline, decide_information_deadline(Profile, Deadline), Deadlines),
    Deadlines == [date(2026, 1, 15)].
test(article_14_missing_keys_in_contract_order) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(data_used_for_communication_with_data_subject, true)],
    decide_information_deadline(Profile, Deadline),
    Deadline == indeterminate([obtaining_date, first_communication_date, disclosure_to_another_recipient_envisaged]).
test(both_flags_false_settle_the_basis_without_the_obtaining_day) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)],
    information_deadline_basis_status(Profile, art14_3_a).
test(an_unknown_key_is_an_input_problem) :-
    decide_information_deadline([attribute(colour, blue)], input_problems([unknown_key(colour)])),
    information_deadline_basis_status([attribute(colour, blue)], input_problems([unknown_key(colour)])).
test(the_checklist_has_one_row_per_ground) :-
    information_deadline_basis_checklist([attribute(personal_data_collected_from_data_subject, true)], Items),
    length(Items, 4).

test(limb_a_is_not_the_sunday, fail) :-
    limb_a_date(date(2026, 1, 15), [], date(2026, 2, 15)).
test(article_14_first_communication_is_not_limb_a, fail) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(by, at, reason, none)))],
    information_deadline_basis_status(Profile, art14_3_a).
