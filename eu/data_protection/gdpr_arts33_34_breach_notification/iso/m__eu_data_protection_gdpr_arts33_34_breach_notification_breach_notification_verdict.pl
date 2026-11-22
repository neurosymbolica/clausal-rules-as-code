% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, breach_notification_verdict_decision_resolvable/1, breach_notification_verdict_status_values/1, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2, no_notification_required/1, notify_supervisory_authority/1, notify_controller/1, document_breach/1, communicate_to_data_subject/1, no_communication_required/1, public_communication_or_similar_measure/1, notification_requirement_not_met/1, period_end/2, requirements_not_met/1, information_to_follow_in_phases/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, wrong_type/1, duplicate_key/1, contradictory_inputs/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [implements/1]).

breach_notification_period_source(notification_period_hours, cite(eu_reg_2016_679_art_33_1)).
breach_notification_period_source(hours_per_day, cite(eu_reg_1971_1182_art_3_2_a)).
breach_notification_period_source(first_clock_hour, cite(eu_reg_1971_1182_art_3_1)).
breach_notification_period_source(last_clock_hour, cite(eu_reg_1971_1182_art_3_1)).

breach_notification_verdict_status_values([eligible, ineligible]).

article_33_1_term(true, no_notification_required(cite(eu_reg_2016_679_art_33_1))).
article_33_1_term(false, notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1))).

authority_decision_term(required_communication, communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))).
authority_decision_term(decided_point_a_condition_met, no_communication_required(cite(eu_reg_2016_679_art_34_4))).
authority_decision_term(decided_point_b_condition_met, no_communication_required(cite(eu_reg_2016_679_art_34_4))).
authority_decision_term(decided_point_c_condition_met, public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4))).

authority_content_row(nature_of_breach, crisp(notification_describes_nature_of_breach), cite(eu_reg_2016_679_art_33_3_a)).
authority_content_row(categories_and_approximate_numbers, qualified(notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible), cite(eu_reg_2016_679_art_33_3_a)).
authority_content_row(contact_point, crisp(notification_gives_contact_point), cite(eu_reg_2016_679_art_33_3_b)).
authority_content_row(likely_consequences, crisp(notification_describes_likely_consequences), cite(eu_reg_2016_679_art_33_3_c)).
authority_content_row(measures_taken_or_proposed, crisp(notification_describes_measures_taken_or_proposed), cite(eu_reg_2016_679_art_33_3_d)).
authority_content_row(mitigation_measures, qualified(notification_describes_mitigation_measures, mitigation_measures_appropriate), cite(eu_reg_2016_679_art_33_3_d)).

no_notification_required(cite(Key)) :-
    atom(Key).

notify_supervisory_authority(cite(Key)) :-
    atom(Key).

notify_controller(cite(Key)) :-
    atom(Key).

document_breach(cite(Key)) :-
    atom(Key).

communicate_to_data_subject(cite(Key)) :-
    atom(Key).

no_communication_required(cite(Key)) :-
    atom(Key).

public_communication_or_similar_measure(cite(Key)) :-
    atom(Key).

notification_requirement_not_met(without_undue_delay).
notification_requirement_not_met(reasons_for_delay).

period_end(date(Year, Month, Day), EndHour) :-
    integer(Year),
    integer(Month),
    integer(Day),
    integer(EndHour).

requirements_not_met([_|_]).

information_to_follow_in_phases([_|_]).

indeterminate([_|_]).

needs_legal_review(open_textured(_, _), Context) :-
    clausal_is_list(Context).

open_textured(Key, cite(CitationKey)) :-
    atom(Key),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    clausal_is_list(Citations).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

contradictory_inputs([FirstKey, SecondKey]) :-
    atom(FirstKey),
    atom(SecondKey).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, value(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

open_risk_value(false).
open_risk_value(unsure).

open_high_risk(true).
open_high_risk(unsure).

settled_judgement(true).
settled_judgement(false).

not_true_state(absent).
not_true_state(value(false)).
not_true_state(value(unsure)).

present_not_true_state(value(false)).
present_not_true_state(value(unsure)).

integer_t(Term, Truth) :-
    findall(Term, integer(Term), Integers),
    integer_found(Integers, Truth).

integer_found([], false).
integer_found([_|_], true).

awareness_day_t(Aware, false) :-
    var(Aware).
awareness_day_t(Aware, false) :-
    nonvar(Aware),
    functor(Aware, Name, Arity),
    dif(Name/Arity, date/3).
awareness_day_t(Aware, Truth) :-
    nonvar(Aware),
    functor(Aware, date, 3),
    arg(1, Aware, Year),
    arg(2, Aware, Month),
    arg(3, Aware, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    date_parts_t(YearIsInteger, MonthIsInteger, DayIsInteger, Year, Month, Day, Truth).

date_parts_t(false, _, _, _, _, _, false).
date_parts_t(true, false, _, _, _, _, false).
date_parts_t(true, true, false, _, _, _, false).
date_parts_t(true, true, true, Year, Month, Day, Truth) :-
    calendar_day_t(Year, Month, Day, Truth).

calendar_day_t(Year, _, _, false) :-
    Year #< 1.
calendar_day_t(Year, _, _, false) :-
    Year #> 9999.
calendar_day_t(Year, Month, _, false) :-
    Year #>= 1,
    Year #< 10000,
    Month #< 1.
calendar_day_t(Year, Month, _, false) :-
    Year #>= 1,
    Year #< 10000,
    Month #> 12.
calendar_day_t(Year, Month, Day, Truth) :-
    Year #>= 1,
    Year #< 10000,
    Month #>= 1,
    Month #< 13,
    month_last_day(Year, Month, LastDay),
    day_of_month_t(Day, LastDay, DayTruth),
    period_fits_t(DayTruth, Year, Month, Day, Truth).

day_of_month_t(Day, _, false) :-
    Day #< 1.
day_of_month_t(Day, LastDay, false) :-
    Day #> LastDay.
day_of_month_t(Day, LastDay, true) :-
    Day #>= 1,
    Day #=< LastDay.

period_fits_t(false, _, _, _, false).
period_fits_t(true, Year, Month, Day, true) :-
    Year * 10000 + Month * 100 + Day #=< 99991228.
period_fits_t(true, Year, Month, Day, false) :-
    Year * 10000 + Month * 100 + Day #> 99991228.

awareness_date_problems(Aware, Problems) :-
    implements(eu_reg_1971_1182_art_3_2_a),
    awareness_day_t(Aware, Truth),
    date_problems(Truth, Problems).

date_problems(true, []).
date_problems(false, [wrong_type(awareness_date)]).

awareness_hour_problems(AwarenessHour, Problems) :-
    implements(eu_reg_1971_1182_art_3_1),
    integer_t(AwarenessHour, IsInteger),
    hour_problems(IsInteger, AwarenessHour, Problems).

hour_problems(false, _, [wrong_type(awareness_hour)]).
hour_problems(true, Hour, []) :-
    Hour #>= 0,
    Hour #< 24.
hour_problems(true, Hour, [wrong_type(awareness_hour)]) :-
    Hour #< 0.
hour_problems(true, Hour, [wrong_type(awareness_hour)]) :-
    Hour #> 23.

hours_elapsed_problems(HoursElapsed, Problems) :-
    implements(eu_reg_1971_1182_art_3_1),
    integer_t(HoursElapsed, IsInteger),
    elapsed_problems(IsInteger, HoursElapsed, Problems).

elapsed_problems(false, _, [wrong_type(hours_elapsed)]).
elapsed_problems(true, Hours, []) :-
    Hours #>= 0.
elapsed_problems(true, Hours, [wrong_type(hours_elapsed)]) :-
    Hours #< 0.

authority_notification_hours(Hours) :-
    implements(eu_reg_2016_679_art_33_1),
    Hours #= 72.

period_last_day(Aware, LastDay) :-
    implements(eu_reg_1971_1182_art_1),
    implements(eu_reg_1971_1182_art_3_2),
    implements(eu_reg_1971_1182_art_3_2_a),
    implements(eu_reg_1971_1182_art_3_3),
    implements(eu_reg_1971_1182_art_3_4),
    implements(eu_reg_1971_1182_art_3_5),
    PeriodDays #= 72 // 24,
    timedelta(PeriodDays, 0, NotificationPeriod),
    date_add(Aware, NotificationPeriod, LastDay).

period_end_hour(AwarenessHour, EndHour) :-
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    EndHour #= AwarenessHour + 1.

authority_notification_deadline(Aware, Deadline, Hours) :-
    authority_notification_hours(Hours),
    awareness_day_t(Aware, Truth),
    deadline_answer(Truth, Aware, Deadline).

deadline_answer(false, _, input_problems([wrong_type(awareness_date)])).
deadline_answer(true, Aware, Deadline) :-
    period_last_day(Aware, Deadline).

authority_notification_period_end(Aware, AwarenessHour, PeriodEnd) :-
    awareness_date_problems(Aware, DateProblems),
    awareness_hour_problems(AwarenessHour, HourProblems),
    append(DateProblems, HourProblems, Problems),
    period_end_answer(Problems, Aware, AwarenessHour, PeriodEnd).

period_end_answer([Problem|Problems], _, _, input_problems([Problem|Problems])).
period_end_answer([], Aware, AwarenessHour, period_end(LastDay, EndHour)) :-
    period_last_day(Aware, LastDay),
    period_end_hour(AwarenessHour, EndHour).

breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, ProfileProblems),
    hours_elapsed_problems(HoursElapsed, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    checked_verdict(Problems, Profile, HoursElapsed, Verdict, Citations).

checked_verdict([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
checked_verdict([], Profile, HoursElapsed, Verdict, Citations) :-
    key_state(Profile, breach_unlikely_to_result_in_risk, RiskState),
    risk_verdict(RiskState, Profile, HoursElapsed, Verdict, Citations).

risk_verdict(absent, _, _, indeterminate([breach_unlikely_to_result_in_risk]), []).
risk_verdict(value(true), _, _, ineligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
risk_verdict(value(Risk), Profile, HoursElapsed, Verdict, Citations) :-
    open_risk_value(Risk),
    timing_verdict(Risk, HoursElapsed, Profile, Verdict, Citations).

timing_verdict(Risk, HoursElapsed, Profile, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    HoursElapsed #< 73,
    key_state(Profile, notification_made_without_undue_delay, DelayState),
    within_verdict(DelayState, Risk, HoursElapsed, Verdict, Citations).
timing_verdict(Risk, HoursElapsed, Profile, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    HoursElapsed #> 72,
    key_state(Profile, notification_accompanied_by_reasons_for_delay, ReasonsState),
    beyond_verdict(ReasonsState, Risk, HoursElapsed, Profile, Verdict, Citations).

risk_referral_verdict(needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])).

within_verdict(absent, _, _, indeterminate([notification_made_without_undue_delay]), []).
within_verdict(value(_), unsure, _, Verdict, []) :-
    risk_referral_verdict(Verdict).
within_verdict(value(unsure), false, HoursElapsed, needs_legal_review(open_textured(notification_made_without_undue_delay, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - HoursElapsed, breach_unlikely_to_result_in_risk - false, notification_made_without_undue_delay - unsure])]), []) :-
    implements(eu_reg_2016_679_art_33_1).
within_verdict(value(true), false, _, eligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
within_verdict(value(false), false, _, notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).

beyond_verdict(absent, _, _, _, indeterminate([notification_accompanied_by_reasons_for_delay]), []).
beyond_verdict(value(false), unsure, _, _, Verdict, []) :-
    risk_referral_verdict(Verdict).
beyond_verdict(value(false), false, _, _, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
beyond_verdict(value(true), Risk, HoursElapsed, Profile, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    key_state(Profile, delay_justified_by_reasons, JustifiedState),
    justified_verdict(JustifiedState, Risk, HoursElapsed, Verdict, Citations).

justified_verdict(absent, _, _, indeterminate([delay_justified_by_reasons]), []).
justified_verdict(value(_), unsure, _, Verdict, []) :-
    risk_referral_verdict(Verdict).
justified_verdict(value(true), false, _, eligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
justified_verdict(value(false), false, HoursElapsed, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - HoursElapsed, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]), []) :-
    implements(eu_reg_2016_679_art_33_1).
justified_verdict(value(unsure), false, HoursElapsed, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - HoursElapsed, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - unsure])]), []) :-
    implements(eu_reg_2016_679_art_33_1).

notification_obligation(Profile, Obligation) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    checked_obligation(Problems, Profile, Obligation).

checked_obligation([Problem|Problems], _, input_problems([Problem|Problems])).
checked_obligation([], Profile, Obligation) :-
    key_state(Profile, party_role, RoleState),
    role_obligation(RoleState, Profile, Obligation).

role_obligation(absent, _, indeterminate([party_role])).
role_obligation(value(processor), _, [notify_controller(cite(eu_reg_2016_679_art_33_2))]) :-
    implements(eu_reg_2016_679_art_33_2).
role_obligation(value(controller), Profile, Obligation) :-
    implements(eu_reg_2016_679_art_33_1),
    key_state(Profile, breach_unlikely_to_result_in_risk, RiskState),
    key_state(Profile, supervisory_authority_decision_on_communication, AuthorityState),
    authority_reading(AuthorityState, Authority),
    controller_obligation(RiskState, Authority, Profile, Obligation).

authority_reading(absent, authority(no_decision, defaulted)) :-
    implements(eu_reg_2016_679_art_34_4).
authority_reading(value(Decision), authority(Decision, stated)) :-
    implements(eu_reg_2016_679_art_34_4).

shown_default_tail(defaulted, [inputs_relied_on([supervisory_authority_decision_on_communication - no_decision])]).
shown_default_tail(stated, []).

default_pairs(defaulted, [supervisory_authority_decision_on_communication - no_decision]).
default_pairs(stated, []).

risk_referral(Shown, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure|DefaultPairs])])) :-
    default_pairs(Shown, DefaultPairs).

final_obligation(Risk, Article34Term, Shown, [Article33Term, document_breach(cite(eu_reg_2016_679_art_33_5)), Article34Term|Tail]) :-
    implements(eu_reg_2016_679_art_33_5),
    article_33_1_term(Risk, Article33Term),
    shown_default_tail(Shown, Tail).

controller_obligation(absent, _, _, indeterminate([breach_unlikely_to_result_in_risk])).
controller_obligation(value(Risk), authority(Decision, Shown), Profile, Obligation) :-
    decision_kind(Decision, Kind),
    controller_kind_obligation(Kind, Risk, Shown, Profile, Obligation).

decision_kind(no_decision, own_assessment).
decision_kind(Decision, decided(Term)) :-
    implements(eu_reg_2016_679_art_34_4),
    authority_decision_term(Decision, Term).

controller_kind_obligation(decided(_), unsure, Shown, _, Referral) :-
    risk_referral(Shown, Referral).
controller_kind_obligation(decided(Term), Risk, Shown, _, Obligation) :-
    implements(eu_reg_2016_679_art_34_4),
    final_obligation(Risk, Term, Shown, Obligation).
controller_kind_obligation(own_assessment, true, Shown, _, Obligation) :-
    implements(eu_reg_2016_679_art_34_1),
    final_obligation(true, no_communication_required(cite(eu_reg_2016_679_art_34_1)), Shown, Obligation).
controller_kind_obligation(own_assessment, Risk, Shown, Profile, Obligation) :-
    implements(eu_reg_2016_679_art_34_1),
    open_risk_value(Risk),
    key_state(Profile, breach_likely_to_result_in_high_risk, HighRiskState),
    high_risk_obligation(HighRiskState, Risk, Shown, Profile, Obligation).

high_risk_obligation(absent, _, _, _, indeterminate([breach_likely_to_result_in_high_risk])).
high_risk_obligation(value(false), unsure, Shown, _, Referral) :-
    risk_referral(Shown, Referral).
high_risk_obligation(value(false), false, Shown, _, Obligation) :-
    implements(eu_reg_2016_679_art_34_1),
    final_obligation(false, no_communication_required(cite(eu_reg_2016_679_art_34_1)), Shown, Obligation).
high_risk_obligation(value(HighRisk), Risk, Shown, Profile, Obligation) :-
    implements(eu_reg_2016_679_art_34_3),
    open_high_risk(HighRisk),
    key_state(Profile, appropriate_protection_measures_applied_to_affected_data, ProtectionState),
    key_state(Profile, subsequent_measures_ensure_high_risk_no_longer_likely, SubsequentState),
    key_state(Profile, communication_would_involve_disproportionate_effort, EffortState),
    exemption_outcome(ProtectionState, SubsequentState, EffortState, Outcome),
    exemption_obligation(Outcome, Risk, HighRisk, Shown, Obligation).

exemption_outcome(value(true), _, _, term(no_communication_required(cite(eu_reg_2016_679_art_34_3_a)))) :-
    implements(eu_reg_2016_679_art_34_3_a).
exemption_outcome(ProtectionState, value(true), _, term(no_communication_required(cite(eu_reg_2016_679_art_34_3_b)))) :-
    implements(eu_reg_2016_679_art_34_3_b),
    not_true_state(ProtectionState).
exemption_outcome(absent, SubsequentState, _, missing(appropriate_protection_measures_applied_to_affected_data)) :-
    implements(eu_reg_2016_679_art_34_3),
    not_true_state(SubsequentState).
exemption_outcome(ProtectionState, absent, _, missing(subsequent_measures_ensure_high_risk_no_longer_likely)) :-
    implements(eu_reg_2016_679_art_34_3),
    present_not_true_state(ProtectionState).
exemption_outcome(ProtectionState, SubsequentState, absent, missing(communication_would_involve_disproportionate_effort)) :-
    implements(eu_reg_2016_679_art_34_3),
    present_not_true_state(ProtectionState),
    present_not_true_state(SubsequentState).
exemption_outcome(value(unsure), SubsequentState, value(_), unsure(appropriate_protection_measures_applied_to_affected_data, cite(eu_reg_2016_679_art_34_3_a), [appropriate_protection_measures_applied_to_affected_data - unsure])) :-
    implements(eu_reg_2016_679_art_34_3_a),
    present_not_true_state(SubsequentState).
exemption_outcome(value(false), value(unsure), value(_), unsure(subsequent_measures_ensure_high_risk_no_longer_likely, cite(eu_reg_2016_679_art_34_3_b), [appropriate_protection_measures_applied_to_affected_data - false, subsequent_measures_ensure_high_risk_no_longer_likely - unsure])) :-
    implements(eu_reg_2016_679_art_34_3_b).
exemption_outcome(value(false), value(false), value(unsure), unsure(communication_would_involve_disproportionate_effort, cite(eu_reg_2016_679_art_34_3_c), [appropriate_protection_measures_applied_to_affected_data - false, subsequent_measures_ensure_high_risk_no_longer_likely - false, communication_would_involve_disproportionate_effort - unsure])) :-
    implements(eu_reg_2016_679_art_34_3_c).
exemption_outcome(value(false), value(false), value(true), term(public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c)))) :-
    implements(eu_reg_2016_679_art_34_3_c).
exemption_outcome(value(false), value(false), value(false), term(communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1)))) :-
    implements(eu_reg_2016_679_art_34_1).

settled_outcome(term(_)).
settled_outcome(unsure(_, _, _)).

exemption_obligation(missing(Key), _, _, _, indeterminate([Key])).
exemption_obligation(Outcome, unsure, _, Shown, Referral) :-
    settled_outcome(Outcome),
    risk_referral(Shown, Referral).
exemption_obligation(Outcome, false, unsure, Shown, needs_legal_review(open_textured(breach_likely_to_result_in_high_risk, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - unsure|DefaultPairs])])) :-
    implements(eu_reg_2016_679_art_34_1),
    settled_outcome(Outcome),
    default_pairs(Shown, DefaultPairs).
exemption_obligation(term(Term), false, true, Shown, Obligation) :-
    final_obligation(false, Term, Shown, Obligation).
exemption_obligation(unsure(Key, Citation, ExemptionPairs), false, true, Shown, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_34_3),
    default_pairs(Shown, DefaultPairs),
    append([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - true|DefaultPairs], ExemptionPairs, Pairs).

simple_item_flags(absent, true, false).
simple_item_flags(value(false), true, true).
simple_item_flags(value(true), false, false).

qualified_item_flags(_, value(false), false, false).
qualified_item_flags(value(true), value(true), false, false).
qualified_item_flags(value(true), value(unsure), false, false).
qualified_item_flags(value(true), absent, false, false).
qualified_item_flags(absent, value(true), true, false).
qualified_item_flags(absent, value(unsure), true, false).
qualified_item_flags(absent, absent, true, false).
qualified_item_flags(value(false), value(true), true, true).
qualified_item_flags(value(false), absent, true, false).
qualified_item_flags(value(false), value(unsure), true, false).

needed_unless_false(value(false), false).
needed_unless_false(value(true), true).
needed_unless_false(value(unsure), true).
needed_unless_false(absent, true).

needed_when_false(value(false), true).
needed_when_false(value(true), false).
needed_when_false(absent, false).

qualifier_pairs(_, value(false), Key, [Key - false]).
qualifier_pairs(value(false), value(true), Key, [Key - true]).
qualifier_pairs(value(false), value(unsure), Key, [Key - unsure]).
qualifier_pairs(_, absent, _, []).
qualifier_pairs(value(true), value(true), _, []).
qualifier_pairs(value(true), value(unsure), _, []).
qualifier_pairs(absent, value(true), _, []).
qualifier_pairs(absent, value(unsure), _, []).

pending_judgement(value(false), value(unsure), Key, Citation, pending(Key, Citation)).
pending_judgement(value(false), value(true), _, _, none).
pending_judgement(value(false), value(false), _, _, none).
pending_judgement(value(false), absent, _, _, none).
pending_judgement(value(true), _, _, _, none).
pending_judgement(absent, _, _, _, none).

absent_needed_keys([], []).
absent_needed_keys([entry(Key, absent, true)|Entries], [Key|Missing]) :-
    absent_needed_keys(Entries, Missing).
absent_needed_keys([entry(_, value(_), true)|Entries], Missing) :-
    absent_needed_keys(Entries, Missing).
absent_needed_keys([entry(_, _, false)|Entries], Missing) :-
    absent_needed_keys(Entries, Missing).

true_count([], 0).
true_count([true|Flags], Count) :-
    true_count(Flags, RestCount),
    Count #= RestCount + 1.
true_count([false|Flags], Count) :-
    true_count(Flags, Count).

flagged_items([], []).
flagged_items([Item - true|Flags], [Item|Items]) :-
    flagged_items(Flags, Items).
flagged_items([_ - false|Flags], Items) :-
    flagged_items(Flags, Items).

authority_notification_content_check(Profile, Result) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    checked_authority_content(Problems, Profile, Result).

checked_authority_content([Problem|Problems], _, input_problems([Problem|Problems])).
checked_authority_content([], Profile, Result) :-
    implements(eu_reg_2016_679_art_33_3),
    findall(Reading, authority_content_reading(Profile, Reading), Readings),
    maplist(reading_could, Readings, CouldFlags),
    maplist(reading_included, Readings, IncludedFlags),
    maplist(reading_entries, Readings, EntryLists),
    maplist(reading_pairs, Readings, PairLists),
    true_count(CouldFlags, CouldCount),
    true_count(IncludedFlags, IncludedCount),
    append(EntryLists, Entries),
    append(PairLists, QualifierPairs),
    key_state(Profile, information_not_possible_to_provide_at_the_same_time, PhasesState),
    phases_needed(IncludedCount, CouldCount, PhasesNeeded),
    append(Entries, [entry(information_not_possible_to_provide_at_the_same_time, PhasesState, PhasesNeeded)], AllEntries),
    absent_needed_keys(AllEntries, Missing),
    first_pending(Readings, [], Pending),
    pending_waits(Pending, Waits),
    step_two_t(PhasesState, CouldCount, Waits, StepTwo),
    included_items(Readings, Items),
    authority_content_answer(Missing, StepTwo, Pending, Items, PhasesState, QualifierPairs, Result).

authority_content_reading(Profile, Reading) :-
    authority_content_row(Item, Rule, Citation),
    row_reading(Profile, Rule, Item, Citation, Reading).

row_reading(Profile, crisp(Key), Item, _, reading(Item, Could, Included, [entry(Key, State, true)], [], none)) :-
    implements(eu_reg_2016_679_art_33_3),
    key_state(Profile, Key, State),
    simple_item_flags(State, Could, Included).
row_reading(Profile, qualified(CrispKey, JudgementKey), Item, Citation, reading(Item, Could, Included, [entry(CrispKey, CrispState, CrispNeeded), entry(JudgementKey, JudgementState, JudgementNeeded)], Pairs, Pending)) :-
    implements(eu_reg_2016_679_art_33_3),
    key_state(Profile, CrispKey, CrispState),
    key_state(Profile, JudgementKey, JudgementState),
    qualified_item_flags(CrispState, JudgementState, Could, Included),
    needed_unless_false(JudgementState, CrispNeeded),
    needed_when_false(CrispState, JudgementNeeded),
    qualifier_pairs(CrispState, JudgementState, JudgementKey, Pairs),
    pending_judgement(CrispState, JudgementState, JudgementKey, Citation, Pending).

reading_could(reading(_, Could, _, _, _, _), Could).

reading_included(reading(_, _, Included, _, _, _), Included).

reading_entries(reading(_, _, _, Entries, _, _), Entries).

reading_pairs(reading(_, _, _, _, Pairs, _), Pairs).

included_items([], []).
included_items([reading(Item, _, true, _, _, _)|Readings], [Item|Items]) :-
    included_items(Readings, Items).
included_items([reading(_, _, false, _, _, _)|Readings], Items) :-
    included_items(Readings, Items).

first_pending([], _, settled).
first_pending([reading(_, _, _, _, Pairs, pending(Key, Citation))|_], PairsBefore, referral(Key, Citation, AllPairs)) :-
    append(PairsBefore, Pairs, AllPairs).
first_pending([reading(_, _, _, _, Pairs, none)|Readings], PairsBefore, Pending) :-
    append(PairsBefore, Pairs, NextPairs),
    first_pending(Readings, NextPairs, Pending).

pending_waits(settled, false).
pending_waits(referral(_, _, _), true).

phases_needed(IncludedCount, _, true) :-
    implements(eu_reg_2016_679_art_33_4),
    IncludedCount #>= 1.
phases_needed(0, CouldCount, true) :-
    implements(eu_reg_2016_679_art_33_4),
    CouldCount #>= 2.
phases_needed(0, CouldCount, false) :-
    implements(eu_reg_2016_679_art_33_4),
    CouldCount #< 2.

step_two_t(value(_), _, _, false).
step_two_t(absent, CouldCount, _, false) :-
    CouldCount #= 0.
step_two_t(absent, CouldCount, _, false) :-
    CouldCount #>= 2.
step_two_t(absent, 1, Waits, Waits).

authority_content_answer([Key|Keys], _, _, _, _, _, indeterminate([Key|Keys])).
authority_content_answer([], true, _, _, _, _, indeterminate([information_not_possible_to_provide_at_the_same_time])) :-
    implements(eu_reg_2016_679_art_33_4).
authority_content_answer([], false, referral(Key, Citation, Pairs), _, _, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_33_3).
authority_content_answer([], false, settled, [], _, _, all_requirements_met) :-
    implements(eu_reg_2016_679_art_33_3).
authority_content_answer([], false, settled, [Item|Items], PhasesState, QualifierPairs, Result) :-
    implements(eu_reg_2016_679_art_33_4),
    phases_answer(PhasesState, [Item|Items], QualifierPairs, Result).

phases_answer(value(unsure), _, QualifierPairs, needs_legal_review(open_textured(information_not_possible_to_provide_at_the_same_time, cite(eu_reg_2016_679_art_33_4)), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_33_4),
    append(QualifierPairs, [information_not_possible_to_provide_at_the_same_time - unsure], Pairs).
phases_answer(value(true), Items, _, information_to_follow_in_phases(Items)) :-
    implements(eu_reg_2016_679_art_33_4).
phases_answer(value(false), Items, _, requirements_not_met(Items)) :-
    implements(eu_reg_2016_679_art_33_3).

data_subject_communication_check(Profile, Result) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    checked_communication(Problems, Profile, Result).

checked_communication([Problem|Problems], _, input_problems([Problem|Problems])).
checked_communication([], Profile, Result) :-
    implements(eu_reg_2016_679_art_34_2),
    key_state(Profile, mitigation_measures_appropriate, AppropriateState),
    key_state(Profile, communication_made_without_undue_delay, DelayState),
    key_state(Profile, communication_describes_nature_in_clear_and_plain_language, LanguageState),
    key_state(Profile, communication_gives_contact_point, ContactState),
    key_state(Profile, communication_describes_likely_consequences, ConsequencesState),
    key_state(Profile, communication_describes_measures_taken_or_proposed, MeasuresState),
    key_state(Profile, communication_describes_mitigation_measures, MitigationState),
    needed_when_false(MitigationState, AppropriateNeeded),
    needed_unless_false(AppropriateState, MitigationNeeded),
    absent_needed_keys([entry(mitigation_measures_appropriate, AppropriateState, AppropriateNeeded), entry(communication_made_without_undue_delay, DelayState, true), entry(communication_describes_nature_in_clear_and_plain_language, LanguageState, true), entry(communication_gives_contact_point, ContactState, true), entry(communication_describes_likely_consequences, ConsequencesState, true), entry(communication_describes_measures_taken_or_proposed, MeasuresState, true), entry(communication_describes_mitigation_measures, MitigationState, MitigationNeeded)], Missing),
    qualifier_pairs(MitigationState, AppropriateState, mitigation_measures_appropriate, AppropriatePairs),
    pending_judgement(MitigationState, AppropriateState, mitigation_measures_appropriate, cite(eu_reg_2016_679_art_33_3_d), AppropriatePending),
    judgement_item_flag(DelayState, DelayFlag),
    judgement_item_flag(LanguageState, LanguageFlag),
    simple_item_flags(ContactState, _, ContactFlag),
    simple_item_flags(ConsequencesState, _, ConsequencesFlag),
    simple_item_flags(MeasuresState, _, MeasuresFlag),
    qualified_item_flags(MitigationState, AppropriateState, _, MitigationFlag),
    flagged_items([without_undue_delay - DelayFlag, nature_of_breach_in_clear_and_plain_language - LanguageFlag, contact_point - ContactFlag, likely_consequences - ConsequencesFlag, measures_taken_or_proposed - MeasuresFlag, mitigation_measures - MitigationFlag], Items),
    communication_answer(Missing, AppropriatePending, AppropriatePairs, DelayState, LanguageState, Items, Result).

judgement_item_flag(value(false), true).
judgement_item_flag(value(true), false).
judgement_item_flag(value(unsure), false).
judgement_item_flag(absent, false).

communication_answer([Key|Keys], _, _, _, _, _, indeterminate([Key|Keys])).
communication_answer([], pending(Key, Citation), Pairs, _, _, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_33_3_d).
communication_answer([], none, AppropriatePairs, value(unsure), _, _, needs_legal_review(open_textured(communication_made_without_undue_delay, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_34_1),
    append(AppropriatePairs, [communication_made_without_undue_delay - unsure], Pairs).
communication_answer([], none, AppropriatePairs, value(Delay), value(unsure), _, needs_legal_review(open_textured(communication_describes_nature_in_clear_and_plain_language, cite(eu_reg_2016_679_art_34_2)), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_34_2),
    settled_judgement(Delay),
    append(AppropriatePairs, [communication_made_without_undue_delay - Delay, communication_describes_nature_in_clear_and_plain_language - unsure], Pairs).
communication_answer([], none, _, value(Delay), value(Language), [], all_requirements_met) :-
    implements(eu_reg_2016_679_art_34_2),
    settled_judgement(Delay),
    settled_judgement(Language).
communication_answer([], none, _, value(Delay), value(Language), [Item|Items], requirements_not_met([Item|Items])) :-
    implements(eu_reg_2016_679_art_34_2),
    settled_judgement(Delay),
    settled_judgement(Language).

decide_breach_notification_verdict(case(Profile, HoursElapsed), breach_notification_verdict_verdict(Status, Citations)) :-
    breach_notification_verdict(Profile, HoursElapsed, Status, Citations).

breach_notification_verdict_status(Case, Status) :-
    decide_breach_notification_verdict(Case, breach_notification_verdict_verdict(Status, _Citations)).

breach_notification_verdict_checklist(Case, [item(article_33_1_notification, Status, cite(eu_reg_2016_679_art_33_1))]) :-
    decide_breach_notification_verdict(Case, breach_notification_verdict_verdict(Verdict, _Citations)),
    checklist_status(Verdict, Status).

checklist_status(eligible, met).
checklist_status(ineligible, unmet(no_notification_duty)).
checklist_status(notification_requirement_not_met(Requirement), unmet(Requirement)).
checklist_status(indeterminate(Keys), unknown(Keys)).
checklist_status(needs_legal_review(open_textured(Key, _), _), unknown([Key])).
checklist_status(input_problems(Problems), unmet(input_problems(Problems))).

breach_notification_verdict_decision_resolvable(Case) :-
    decide_breach_notification_verdict(Case, _Verdict).

test(a_processor_notifies_the_controller) :-
    notification_obligation([attribute(party_role, processor)], Obligation),
    Obligation == [notify_controller(cite(eu_reg_2016_679_art_33_2))].
test(an_absent_role_is_named) :-
    notification_obligation([attribute(breach_unlikely_to_result_in_risk, true)], Obligation),
    Obligation == indeterminate([party_role]).
test(an_unlikely_risk_with_the_default_shown) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)], Obligation),
    Obligation == [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_1)), inputs_relied_on([supervisory_authority_decision_on_communication - no_decision])].
test(the_order_example_of_disproportionate_effort) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, true)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))].
test(the_example_is_not_a_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))].
test(an_unsure_risk_refers_with_the_default_pair) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure), attribute(breach_likely_to_result_in_high_risk, false)], Obligation),
    Obligation == needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure, supervisory_authority_decision_on_communication - no_decision])]).
test(an_absent_exemption_key_is_named_first) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, unsure)], Obligation),
    Obligation == indeterminate([subsequent_measures_ensure_high_risk_no_longer_likely]).
test(a_decision_of_the_authority_governs) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, required_communication)], Obligation),
    Obligation == [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))].
test(an_obligation_has_one_solution) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false)], Obligation), Obligations),
    length(Obligations, 1).
test(an_unlikely_risk_is_ineligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 100, Verdict, Citations),
    Verdict == ineligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(a_notification_at_72_hours_without_undue_delay_is_eligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72, Verdict, Citations),
    Verdict == eligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(a_late_notification_without_reasons) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, false)], 73, Verdict, _),
    Verdict == notification_requirement_not_met(reasons_for_delay).
test(a_late_notification_with_unjustified_reasons_refers) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 73, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]),
    Citations == [].
test(a_negative_hours_elapsed_is_wrong_type) :-
    breach_notification_verdict([], -1, Verdict, Citations),
    Verdict == input_problems([wrong_type(hours_elapsed)]),
    Citations == [].
test(the_deadline_crosses_a_month_end) :-
    authority_notification_deadline(date(2025, 10, 31), Deadline, Hours),
    Deadline = date(2025, 11, 3),
    Hours =:= 72.
test(the_deadline_crosses_a_leap_month_end) :-
    authority_notification_deadline(date(2032, 2, 27), Deadline, _),
    Deadline = date(2032, 3, 1).
test(a_day_that_does_not_exist_is_wrong_type) :-
    authority_notification_deadline(date(2025, 2, 30), Deadline, Hours),
    Deadline == input_problems([wrong_type(awareness_date)]),
    Hours =:= 72.
test(the_end_of_the_date_range_is_wrong_type) :-
    authority_notification_deadline(date(9999, 12, 29), Deadline, _),
    Deadline == input_problems([wrong_type(awareness_date)]).
test(the_period_ends_at_the_end_of_the_day) :-
    authority_notification_period_end(date(2025, 12, 30), 23, PeriodEnd),
    PeriodEnd = period_end(date(2026, 1, 2), EndHour),
    EndHour =:= 24.
test(both_bad_arguments_are_named) :-
    authority_notification_period_end(date(2025, 13, 1), 24, PeriodEnd),
    PeriodEnd == input_problems([wrong_type(awareness_date), wrong_type(awareness_hour)]).
test(a_complete_notification_meets_all_requirements) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], Result),
    Result == all_requirements_met.
test(absent_crisp_keys_name_the_phases_key) :-
    authority_notification_content_check([attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], Result),
    Result == indeterminate([notification_describes_nature_of_breach, notification_gives_contact_point, information_not_possible_to_provide_at_the_same_time]).
test(one_waiting_item_names_the_phases_key) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, unsure), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], Result),
    Result == indeterminate([information_not_possible_to_provide_at_the_same_time]).
test(an_unsure_possibility_refers) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, unsure), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], Result),
    Result == needs_legal_review(open_textured(categories_and_approximate_numbers_possible, cite(eu_reg_2016_679_art_33_3_a)), [inputs_relied_on([categories_and_approximate_numbers_possible - unsure])]).
test(missing_items_may_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], Result),
    Result == information_to_follow_in_phases([contact_point]).
test(a_complete_communication_meets_all_requirements) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result),
    Result == all_requirements_met.
test(a_late_communication_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, false), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result),
    Result == requirements_not_met([without_undue_delay]).
test(a_contradictory_profile_is_refused) :-
    data_subject_communication_check([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], Result),
    Result == input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(the_checklist_reads_the_verdict) :-
    breach_notification_verdict_checklist(case([attribute(breach_unlikely_to_result_in_risk, true)], 10), Items),
    Items == [item(article_33_1_notification, unmet(no_notification_duty), cite(eu_reg_2016_679_art_33_1))].
test(a_fraction_hours_elapsed_is_wrong_type) :-
    breach_notification_verdict([], 3/2, Verdict, Citations),
    Verdict == input_problems([wrong_type(hours_elapsed)]),
    Citations == [].

test(an_unlikely_risk_is_not_eligible, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 100, eligible, _).
