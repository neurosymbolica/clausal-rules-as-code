% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, breach_notification_verdict_decision_resolvable/1, breach_notification_verdict_status_values/1, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2, no_notification_required/1, notify_supervisory_authority/1, notify_controller/1, document_breach/1, communicate_to_data_subject/1, no_communication_required/1, public_communication_or_similar_measure/1, notification_requirement_not_met/1, period_end/2, requirements_not_met/1, information_to_follow_in_phases/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, contradictory_inputs/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [implements/1]).

authority_notification_period_hours(72, cite(eu_reg_2016_679_art_33_1)).

excluded_hour_of_awareness(1, cite(eu_reg_1971_1182_art_3_1)).

hours_in_a_calendar_day(24).

judgement_citation(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)).
judgement_citation(breach_likely_to_result_in_high_risk, cite(eu_reg_2016_679_art_34_1)).
judgement_citation(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)).
judgement_citation(notification_made_without_undue_delay, cite(eu_reg_2016_679_art_33_1)).
judgement_citation(appropriate_protection_measures_applied_to_affected_data, cite(eu_reg_2016_679_art_34_3_a)).
judgement_citation(subsequent_measures_ensure_high_risk_no_longer_likely, cite(eu_reg_2016_679_art_34_3_b)).
judgement_citation(communication_would_involve_disproportionate_effort, cite(eu_reg_2016_679_art_34_3_c)).
judgement_citation(categories_and_approximate_numbers_possible, cite(eu_reg_2016_679_art_33_3_a)).
judgement_citation(mitigation_measures_appropriate, cite(eu_reg_2016_679_art_33_3_d)).
judgement_citation(information_not_possible_to_provide_at_the_same_time, cite(eu_reg_2016_679_art_33_4)).
judgement_citation(communication_made_without_undue_delay, cite(eu_reg_2016_679_art_34_1)).
judgement_citation(communication_describes_nature_in_clear_and_plain_language, cite(eu_reg_2016_679_art_34_2)).

breach_notification_verdict_status_values([eligible, ineligible]).

input_problems(Problems) :-
    clausal_is_list(Problems).

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

contradictory_inputs(Keys) :-
    clausal_is_list(Keys).

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
    integer(EndHour),
    EndHour #>= 1,
    EndHour #< 25.

requirements_not_met(Items) :-
    clausal_is_list(Items).

information_to_follow_in_phases(Items) :-
    clausal_is_list(Items).

indeterminate(Keys) :-
    clausal_is_list(Keys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Key, cite(CitationKey)) :-
    atom(Key),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    clausal_is_list(Citations).

key_value(Profile, Key, State) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    values_state(Values, State).

values_state([], absent).
values_state([Value], present(Value)).

holds_t(Goal, Truth) :-
    findall(holds, call(Goal), Witnesses),
    sort(Witnesses, Distinct),
    witness_truth(Distinct, Truth).

witness_truth([], false).
witness_truth([holds], true).

argument_problems(true, _, []).
argument_problems(false, Name, [wrong_type(Name)]).

real_calendar_day(Aware) :-
    nonvar(Aware),
    Aware = date(Year, Month, Day),
    integer(Year),
    integer(Month),
    integer(Day),
    Year #>= 1,
    Year #< 10000,
    Month #>= 1,
    Month #< 13,
    month_last_day(Year, Month, LastDay),
    Day #>= 1,
    Day #=< LastDay.

clock_hour(AwarenessHour) :-
    integer(AwarenessHour),
    AwarenessHour #>= 0,
    AwarenessHour #< 24.

non_negative_integer(HoursElapsed) :-
    integer(HoursElapsed),
    HoursElapsed #>= 0.

hours_elapsed_problems(HoursElapsed, Problems) :-
    holds_t(non_negative_integer(HoursElapsed), IsCount),
    argument_problems(IsCount, hours_elapsed, Problems).

period_last_day(Aware, LastDay) :-
    implements(eu_reg_1971_1182_art_3_2_a),
    implements(eu_reg_1971_1182_art_3_3),
    implements(eu_reg_1971_1182_art_3_4),
    authority_notification_period_hours(PeriodHours, cite(eu_reg_2016_679_art_33_1)),
    hours_in_a_calendar_day(HoursPerDay),
    CalendarDays #= PeriodHours // HoursPerDay,
    timedelta(CalendarDays, 0, NotificationPeriod),
    date_add(Aware, NotificationPeriod, LastDay).

period_end_hour(AwarenessHour, EndHour) :-
    implements(eu_reg_1971_1182_art_3_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    excluded_hour_of_awareness(ExcludedHours, cite(eu_reg_1971_1182_art_3_1)),
    EndHour #= AwarenessHour + ExcludedHours.

notification_window(HoursElapsed, within_period) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    authority_notification_period_hours(PeriodHours, cite(eu_reg_2016_679_art_33_1)),
    HoursElapsed #=< PeriodHours.
notification_window(HoursElapsed, after_period) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_1971_1182_art_3_2_a),
    authority_notification_period_hours(PeriodHours, cite(eu_reg_2016_679_art_33_1)),
    HoursElapsed #> PeriodHours.

authority_notification_deadline(Aware, Deadline, Hours) :-
    implements(eu_reg_2016_679_art_33_1),
    authority_notification_period_hours(Hours, cite(eu_reg_2016_679_art_33_1)),
    holds_t(real_calendar_day(Aware), IsRealDay),
    deadline_answer(IsRealDay, Aware, Deadline).

deadline_answer(false, _, input_problems([wrong_type(awareness_date)])).
deadline_answer(true, Aware, Deadline) :-
    period_last_day(Aware, Deadline).

authority_notification_period_end(Aware, AwarenessHour, PeriodEnd) :-
    holds_t(real_calendar_day(Aware), IsRealDay),
    holds_t(clock_hour(AwarenessHour), IsClockHour),
    argument_problems(IsRealDay, awareness_date, DateProblems),
    argument_problems(IsClockHour, awareness_hour, HourProblems),
    append(DateProblems, HourProblems, Problems),
    period_end_answer(Problems, Aware, AwarenessHour, PeriodEnd).

period_end_answer([Problem|Problems], _, _, input_problems([Problem|Problems])).
period_end_answer([], Aware, AwarenessHour, period_end(LastDay, EndHour)) :-
    implements(eu_reg_1971_1182_art_3_2),
    period_last_day(Aware, LastDay),
    period_end_hour(AwarenessHour, EndHour).

notification_risk_referral(needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])).

high_risk_referral(needs_legal_review(open_textured(breach_likely_to_result_in_high_risk, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - unsure])])).

judgement_referral(Key, Relied, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Relied)])) :-
    judgement_citation(Key, Citation).

first_unsure([], _, none).
first_unsure([Key - unsure|_], Before, unsure(Key, Relied)) :-
    append(Before, [Key - unsure], Relied).
first_unsure([Key - Value|Pairs], Before, Outcome) :-
    sure_judgement(Value),
    append(Before, [Key - Value], Seen),
    first_unsure(Pairs, Seen, Outcome).

sure_judgement(true).
sure_judgement(false).

open_judgement(false).
open_judgement(unsure).

breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations) :-
    verdict_request_problems(Profile, HoursElapsed, Problems),
    verdict_for_problems(Problems, Profile, HoursElapsed, Verdict, Citations).

verdict_request_problems(Profile, HoursElapsed, Problems) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, ProfileProblems),
    hours_elapsed_problems(HoursElapsed, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems).

verdict_for_problems([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
verdict_for_problems([], Profile, HoursElapsed, Verdict, Citations) :-
    key_value(Profile, breach_unlikely_to_result_in_risk, RiskState),
    risk_route(RiskState, Profile, HoursElapsed, Verdict, Citations).

risk_route(absent, _, _, indeterminate([breach_unlikely_to_result_in_risk]), []).
risk_route(present(true), _, _, ineligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
risk_route(present(false), Profile, HoursElapsed, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    notification_window(HoursElapsed, Window),
    timing_route(Window, false, Profile, HoursElapsed, Verdict, Citations).
risk_route(present(unsure), Profile, HoursElapsed, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    notification_window(HoursElapsed, Window),
    timing_route(Window, unsure, Profile, HoursElapsed, Verdict, Citations).

timing_route(within_period, RiskJudgement, Profile, HoursElapsed, Verdict, Citations) :-
    key_value(Profile, notification_made_without_undue_delay, DelayState),
    undue_delay_route(DelayState, RiskJudgement, HoursElapsed, Verdict, Citations).
timing_route(after_period, RiskJudgement, Profile, HoursElapsed, Verdict, Citations) :-
    key_value(Profile, notification_accompanied_by_reasons_for_delay, ReasonsState),
    reasons_route(ReasonsState, RiskJudgement, Profile, HoursElapsed, Verdict, Citations).

undue_delay_route(absent, _, _, indeterminate([notification_made_without_undue_delay]), []).
undue_delay_route(present(_), unsure, _, Referral, []) :-
    notification_risk_referral(Referral).
undue_delay_route(present(true), false, _, eligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
undue_delay_route(present(false), false, _, notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
undue_delay_route(present(unsure), false, HoursElapsed, needs_legal_review(open_textured(notification_made_without_undue_delay, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - HoursElapsed, breach_unlikely_to_result_in_risk - false, notification_made_without_undue_delay - unsure])]), []) :-
    implements(eu_reg_2016_679_art_33_1).

reasons_route(absent, _, _, _, indeterminate([notification_accompanied_by_reasons_for_delay]), []).
reasons_route(present(false), unsure, _, _, Referral, []) :-
    notification_risk_referral(Referral).
reasons_route(present(false), false, _, _, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
reasons_route(present(true), RiskJudgement, Profile, HoursElapsed, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_33_1),
    key_value(Profile, delay_justified_by_reasons, JustifiedState),
    justified_delay_route(JustifiedState, RiskJudgement, HoursElapsed, Verdict, Citations).

justified_delay_route(absent, _, _, indeterminate([delay_justified_by_reasons]), []).
justified_delay_route(present(_), unsure, _, Referral, []) :-
    notification_risk_referral(Referral).
justified_delay_route(present(true), false, _, eligible, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
justified_delay_route(present(Justified), false, HoursElapsed, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - HoursElapsed, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - Justified])]), []) :-
    implements(eu_reg_2016_679_art_33_1),
    open_judgement(Justified).

notification_obligation(Profile, Obligation) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    obligation_for_problems(Problems, Profile, Obligation).

obligation_for_problems([Problem|Problems], _, input_problems([Problem|Problems])).
obligation_for_problems([], Profile, Obligation) :-
    key_value(Profile, party_role, RoleState),
    party_role_route(RoleState, Profile, Obligation).

party_role_route(absent, _, indeterminate([party_role])).
party_role_route(present(processor), _, [notify_controller(cite(eu_reg_2016_679_art_33_2))]) :-
    implements(eu_reg_2016_679_art_33_2).
party_role_route(present(controller), Profile, Obligation) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_2016_679_art_34_4),
    key_value(Profile, breach_unlikely_to_result_in_risk, RiskState),
    key_value(Profile, supervisory_authority_decision_on_communication, AuthorityState),
    missing_when_read(read, RiskState, breach_unlikely_to_result_in_risk, RiskMissing),
    missing_when_read(read, AuthorityState, supervisory_authority_decision_on_communication, AuthorityMissing),
    append(RiskMissing, AuthorityMissing, MissingKeys),
    controller_route(MissingKeys, RiskState, AuthorityState, Profile, Obligation).

controller_route([Missing|MoreMissing], _, _, _, indeterminate([Missing|MoreMissing])).
controller_route([], present(RiskJudgement), present(Authority), Profile, Obligation) :-
    authority_reading(Authority, Reading),
    controller_judgement_route(Reading, RiskJudgement, Profile, Obligation).

authority_reading(no_decision, own_judgements).
authority_reading(required_communication, decided(communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4)))) :-
    implements(eu_reg_2016_679_art_34_4).
authority_reading(decided_point_a_condition_met, decided(no_communication_required(cite(eu_reg_2016_679_art_34_4)))) :-
    implements(eu_reg_2016_679_art_34_4),
    implements(eu_reg_2016_679_art_34_3_a).
authority_reading(decided_point_b_condition_met, decided(no_communication_required(cite(eu_reg_2016_679_art_34_4)))) :-
    implements(eu_reg_2016_679_art_34_4),
    implements(eu_reg_2016_679_art_34_3_b).
authority_reading(decided_point_c_condition_met, decided(public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4)))) :-
    implements(eu_reg_2016_679_art_34_4),
    implements(eu_reg_2016_679_art_34_3_c).

article_33_duties(true, [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_2016_679_art_33_5).
article_33_duties(false, [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]) :-
    implements(eu_reg_2016_679_art_33_1),
    implements(eu_reg_2016_679_art_33_5).

article_33_answer(unsure, Referral) :-
    notification_risk_referral(Referral).
article_33_answer(false, Duties) :-
    article_33_duties(false, Duties).

controller_judgement_route(decided(_Term), unsure, _, Referral) :-
    notification_risk_referral(Referral).
controller_judgement_route(decided(Term), RiskJudgement, _, Obligation) :-
    article_33_duties(RiskJudgement, Duties),
    append(Duties, [Term], Obligation).
controller_judgement_route(own_judgements, true, _, Duties) :-
    article_33_duties(true, Duties).
controller_judgement_route(own_judgements, false, Profile, Obligation) :-
    high_risk_stage(false, Profile, Obligation).
controller_judgement_route(own_judgements, unsure, Profile, Obligation) :-
    high_risk_stage(unsure, Profile, Obligation).

high_risk_stage(RiskJudgement, Profile, Obligation) :-
    key_value(Profile, breach_likely_to_result_in_high_risk, HighRiskState),
    high_risk_route(HighRiskState, RiskJudgement, Profile, Obligation).

high_risk_route(absent, _, _, indeterminate([breach_likely_to_result_in_high_risk])).
high_risk_route(present(false), RiskJudgement, _, Obligation) :-
    implements(eu_reg_2016_679_art_34_1),
    article_33_answer(RiskJudgement, Obligation).
high_risk_route(present(HighRisk), RiskJudgement, Profile, Obligation) :-
    implements(eu_reg_2016_679_art_34_1),
    communication_risk_open(HighRisk),
    exemption_outcome(Profile, Outcome),
    exemption_answer(Outcome, RiskJudgement, HighRisk, Obligation).

communication_risk_open(true).
communication_risk_open(unsure).

exemption_outcome(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_34_3),
    key_value(Profile, appropriate_protection_measures_applied_to_affected_data, ProtectionState),
    key_value(Profile, subsequent_measures_ensure_high_risk_no_longer_likely, SubsequentState),
    key_value(Profile, communication_would_involve_disproportionate_effort, EffortState),
    exemption_from_states(ProtectionState, SubsequentState, EffortState, Outcome).

not_true_state(absent).
not_true_state(present(false)).
not_true_state(present(unsure)).

exemption_from_states(present(true), _, _, communication_term(no_communication_required(cite(eu_reg_2016_679_art_34_3_a)))) :-
    implements(eu_reg_2016_679_art_34_3_a).
exemption_from_states(ProtectionState, present(true), _, communication_term(no_communication_required(cite(eu_reg_2016_679_art_34_3_b)))) :-
    implements(eu_reg_2016_679_art_34_3_b),
    not_true_state(ProtectionState).
exemption_from_states(ProtectionState, SubsequentState, EffortState, Outcome) :-
    implements(eu_reg_2016_679_art_34_3),
    not_true_state(ProtectionState),
    not_true_state(SubsequentState),
    exemption_remaining(ProtectionState, SubsequentState, EffortState, Outcome).

exemption_remaining(absent, _, _, missing(appropriate_protection_measures_applied_to_affected_data)).
exemption_remaining(present(_), absent, _, missing(subsequent_measures_ensure_high_risk_no_longer_likely)).
exemption_remaining(present(_), present(_), absent, missing(communication_would_involve_disproportionate_effort)).
exemption_remaining(present(Protection), present(Subsequent), present(Effort), Outcome) :-
    exemption_judged(Protection, Subsequent, Effort, Outcome).

exemption_judged(unsure, _, _, unsure(appropriate_protection_measures_applied_to_affected_data, [appropriate_protection_measures_applied_to_affected_data - unsure])).
exemption_judged(false, unsure, _, unsure(subsequent_measures_ensure_high_risk_no_longer_likely, [appropriate_protection_measures_applied_to_affected_data - false, subsequent_measures_ensure_high_risk_no_longer_likely - unsure])).
exemption_judged(false, false, unsure, unsure(communication_would_involve_disproportionate_effort, [appropriate_protection_measures_applied_to_affected_data - false, subsequent_measures_ensure_high_risk_no_longer_likely - false, communication_would_involve_disproportionate_effort - unsure])).
exemption_judged(false, false, true, communication_term(public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c)))) :-
    implements(eu_reg_2016_679_art_34_3_c).
exemption_judged(false, false, false, communication_term(communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1)))) :-
    implements(eu_reg_2016_679_art_34_1).

exemption_answer(missing(Key), _, _, indeterminate([Key])).
exemption_answer(communication_term(_), unsure, _, Referral) :-
    notification_risk_referral(Referral).
exemption_answer(communication_term(_), false, unsure, Referral) :-
    high_risk_referral(Referral).
exemption_answer(communication_term(Term), false, true, Obligation) :-
    article_33_duties(false, Duties),
    append(Duties, [Term], Obligation).
exemption_answer(unsure(_, _), unsure, _, Referral) :-
    notification_risk_referral(Referral).
exemption_answer(unsure(_, _), false, unsure, Referral) :-
    high_risk_referral(Referral).
exemption_answer(unsure(Key, Pairs), false, true, Referral) :-
    append([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - true], Pairs, Relied),
    judgement_referral(Key, Relied, Referral).

crisp_key_read(present(false), not_read).
crisp_key_read(present(true), read).
crisp_key_read(present(unsure), read).
crisp_key_read(absent, read).

judgement_key_read(present(false), read).
judgement_key_read(present(true), not_read).
judgement_key_read(absent, not_read).

missing_when_read(not_read, _, _, []).
missing_when_read(read, absent, Key, [Key]).
missing_when_read(read, present(_), _, []).

judgement_pair_when(present(false), Key, present(Value), [Key - Value]).
judgement_pair_when(present(false), _, absent, []).
judgement_pair_when(present(true), _, _, []).
judgement_pair_when(absent, _, _, []).

item_when_false(present(false), Item, [Item]).
item_when_false(present(true), _, []).
item_when_false(present(unsure), _, []).
item_when_false(absent, _, []).

item_when_false_and_true(present(false), present(true), Item, [Item]).
item_when_false_and_true(present(false), present(false), _, []).
item_when_false_and_true(present(false), present(unsure), _, []).
item_when_false_and_true(present(false), absent, _, []).
item_when_false_and_true(present(true), _, _, []).
item_when_false_and_true(absent, _, _, []).

crisp_item_flags(absent, 1, 0).
crisp_item_flags(present(false), 1, 1).
crisp_item_flags(present(true), 0, 0).

judged_item_flags(present(true), _, 0, 0).
judged_item_flags(absent, present(false), 0, 0).
judged_item_flags(present(false), present(false), 0, 0).
judged_item_flags(absent, absent, 1, 0).
judged_item_flags(absent, present(true), 1, 0).
judged_item_flags(absent, present(unsure), 1, 0).
judged_item_flags(present(false), present(true), 1, 1).
judged_item_flags(present(false), present(unsure), 1, 0).
judged_item_flags(present(false), absent, 1, 0).

authority_notification_content_check(Profile, Result) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    notification_content_for_problems(Problems, Profile, Result).

notification_content_for_problems([Problem|Problems], _, input_problems([Problem|Problems])).
notification_content_for_problems([], Profile, Result) :-
    key_value(Profile, notification_describes_nature_of_breach, NatureState),
    key_value(Profile, notification_gives_categories_and_approximate_numbers, CategoriesState),
    key_value(Profile, categories_and_approximate_numbers_possible, PossibleState),
    key_value(Profile, notification_gives_contact_point, ContactState),
    key_value(Profile, notification_describes_likely_consequences, ConsequencesState),
    key_value(Profile, notification_describes_measures_taken_or_proposed, MeasuresState),
    key_value(Profile, notification_describes_mitigation_measures, MitigationState),
    key_value(Profile, mitigation_measures_appropriate, AppropriateState),
    key_value(Profile, information_not_possible_to_provide_at_the_same_time, PhasesState),
    notification_content(content(NatureState, CategoriesState, PossibleState, ContactState, ConsequencesState, MeasuresState, MitigationState, AppropriateState), PhasesState, Result).

notification_content(Content, PhasesState, Result) :-
    implements(eu_reg_2016_679_art_33_3),
    item_counts(Content, CouldCount, AlreadyCount),
    phases_read(CouldCount, AlreadyCount, PhasesRead),
    notification_missing_keys(Content, PhasesRead, PhasesState, MissingKeys),
    notification_content_route(MissingKeys, Content, CouldCount, PhasesState, Result).

item_counts(content(NatureState, CategoriesState, PossibleState, ContactState, ConsequencesState, MeasuresState, MitigationState, AppropriateState), CouldCount, AlreadyCount) :-
    crisp_item_flags(NatureState, NatureCould, NatureAlready),
    judged_item_flags(CategoriesState, PossibleState, CategoriesCould, CategoriesAlready),
    crisp_item_flags(ContactState, ContactCould, ContactAlready),
    crisp_item_flags(ConsequencesState, ConsequencesCould, ConsequencesAlready),
    crisp_item_flags(MeasuresState, MeasuresCould, MeasuresAlready),
    judged_item_flags(MitigationState, AppropriateState, MitigationCould, MitigationAlready),
    sum_list([NatureCould, CategoriesCould, ContactCould, ConsequencesCould, MeasuresCould, MitigationCould], CouldCount),
    sum_list([NatureAlready, CategoriesAlready, ContactAlready, ConsequencesAlready, MeasuresAlready, MitigationAlready], AlreadyCount).

phases_read(_, AlreadyCount, read) :-
    implements(eu_reg_2016_679_art_33_4),
    AlreadyCount #>= 1.
phases_read(CouldCount, 0, read) :-
    implements(eu_reg_2016_679_art_33_4),
    CouldCount #>= 2.
phases_read(CouldCount, 0, not_read) :-
    implements(eu_reg_2016_679_art_33_4),
    CouldCount #< 2.

notification_missing_keys(content(NatureState, CategoriesState, PossibleState, ContactState, ConsequencesState, MeasuresState, MitigationState, AppropriateState), PhasesRead, PhasesState, MissingKeys) :-
    crisp_key_read(PossibleState, CategoriesRead),
    judgement_key_read(CategoriesState, PossibleRead),
    crisp_key_read(AppropriateState, MitigationRead),
    judgement_key_read(MitigationState, AppropriateRead),
    missing_when_read(read, NatureState, notification_describes_nature_of_breach, NatureMissing),
    missing_when_read(CategoriesRead, CategoriesState, notification_gives_categories_and_approximate_numbers, CategoriesMissing),
    missing_when_read(PossibleRead, PossibleState, categories_and_approximate_numbers_possible, PossibleMissing),
    missing_when_read(read, ContactState, notification_gives_contact_point, ContactMissing),
    missing_when_read(read, ConsequencesState, notification_describes_likely_consequences, ConsequencesMissing),
    missing_when_read(read, MeasuresState, notification_describes_measures_taken_or_proposed, MeasuresMissing),
    missing_when_read(MitigationRead, MitigationState, notification_describes_mitigation_measures, MitigationMissing),
    missing_when_read(AppropriateRead, AppropriateState, mitigation_measures_appropriate, AppropriateMissing),
    missing_when_read(PhasesRead, PhasesState, information_not_possible_to_provide_at_the_same_time, PhasesMissing),
    append([NatureMissing, CategoriesMissing, PossibleMissing, ContactMissing, ConsequencesMissing, MeasuresMissing, MitigationMissing, AppropriateMissing, PhasesMissing], MissingKeys).

notification_content_route([Missing|MoreMissing], _, _, _, indeterminate([Missing|MoreMissing])).
notification_content_route([], Content, CouldCount, PhasesState, Result) :-
    phases_pending(PhasesState, CouldCount, Pending),
    pending_phases_route(Pending, Content, PhasesState, Result).

phases_pending(absent, CouldCount, pending) :-
    CouldCount #= 1.
phases_pending(absent, CouldCount, settled) :-
    CouldCount #< 1.
phases_pending(absent, CouldCount, settled) :-
    CouldCount #>= 2.
phases_pending(present(_), _, settled).

pending_phases_route(pending, _, _, indeterminate([information_not_possible_to_provide_at_the_same_time])) :-
    implements(eu_reg_2016_679_art_33_4).
pending_phases_route(settled, Content, PhasesState, Result) :-
    content_judgements(Content, Judged),
    first_unsure(Judged, [], Outcome),
    judged_content_route(Outcome, Content, Judged, PhasesState, Result).

content_judgements(content(_, CategoriesState, PossibleState, _, _, _, MitigationState, AppropriateState), Judged) :-
    judgement_pair_when(CategoriesState, categories_and_approximate_numbers_possible, PossibleState, PossiblePairs),
    judgement_pair_when(MitigationState, mitigation_measures_appropriate, AppropriateState, AppropriatePairs),
    append(PossiblePairs, AppropriatePairs, Judged).

judged_content_route(unsure(Key, Relied), _, _, _, Referral) :-
    judgement_referral(Key, Relied, Referral).
judged_content_route(none, Content, Judged, PhasesState, Result) :-
    notification_items(Content, Items),
    notification_items_route(Items, Judged, PhasesState, Result).

notification_items(content(NatureState, CategoriesState, PossibleState, ContactState, ConsequencesState, MeasuresState, MitigationState, AppropriateState), Items) :-
    implements(eu_reg_2016_679_art_33_3_a),
    implements(eu_reg_2016_679_art_33_3_b),
    implements(eu_reg_2016_679_art_33_3_c),
    implements(eu_reg_2016_679_art_33_3_d),
    item_when_false(NatureState, nature_of_breach, NatureItems),
    item_when_false_and_true(CategoriesState, PossibleState, categories_and_approximate_numbers, CategoriesItems),
    item_when_false(ContactState, contact_point, ContactItems),
    item_when_false(ConsequencesState, likely_consequences, ConsequencesItems),
    item_when_false(MeasuresState, measures_taken_or_proposed, MeasuresItems),
    item_when_false_and_true(MitigationState, AppropriateState, mitigation_measures, MitigationItems),
    append([NatureItems, CategoriesItems, ContactItems, ConsequencesItems, MeasuresItems, MitigationItems], Items).

notification_items_route([], _, _, all_requirements_met) :-
    implements(eu_reg_2016_679_art_33_3).
notification_items_route([Item|Items], Judged, PhasesState, Result) :-
    implements(eu_reg_2016_679_art_33_3),
    phases_route(PhasesState, [Item|Items], Judged, Result).

phases_route(present(unsure), _, Judged, Referral) :-
    implements(eu_reg_2016_679_art_33_4),
    append(Judged, [information_not_possible_to_provide_at_the_same_time - unsure], Relied),
    judgement_referral(information_not_possible_to_provide_at_the_same_time, Relied, Referral).
phases_route(present(true), Items, _, information_to_follow_in_phases(Items)) :-
    implements(eu_reg_2016_679_art_33_4).
phases_route(present(false), Items, _, requirements_not_met(Items)) :-
    implements(eu_reg_2016_679_art_33_4).

data_subject_communication_check(Profile, Result) :-
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    communication_for_problems(Problems, Profile, Result).

communication_for_problems([Problem|Problems], _, input_problems([Problem|Problems])).
communication_for_problems([], Profile, Result) :-
    key_value(Profile, mitigation_measures_appropriate, AppropriateState),
    key_value(Profile, communication_made_without_undue_delay, DelayState),
    key_value(Profile, communication_describes_nature_in_clear_and_plain_language, LanguageState),
    key_value(Profile, communication_gives_contact_point, ContactState),
    key_value(Profile, communication_describes_likely_consequences, ConsequencesState),
    key_value(Profile, communication_describes_measures_taken_or_proposed, MeasuresState),
    key_value(Profile, communication_describes_mitigation_measures, MitigationState),
    communication_content(communication(AppropriateState, DelayState, LanguageState, ContactState, ConsequencesState, MeasuresState, MitigationState), Result).

communication_content(Communication, Result) :-
    implements(eu_reg_2016_679_art_34_2),
    communication_missing_keys(Communication, MissingKeys),
    communication_route(MissingKeys, Communication, Result).

communication_missing_keys(communication(AppropriateState, DelayState, LanguageState, ContactState, ConsequencesState, MeasuresState, MitigationState), MissingKeys) :-
    crisp_key_read(AppropriateState, MitigationRead),
    judgement_key_read(MitigationState, AppropriateRead),
    missing_when_read(AppropriateRead, AppropriateState, mitigation_measures_appropriate, AppropriateMissing),
    missing_when_read(read, DelayState, communication_made_without_undue_delay, DelayMissing),
    missing_when_read(read, LanguageState, communication_describes_nature_in_clear_and_plain_language, LanguageMissing),
    missing_when_read(read, ContactState, communication_gives_contact_point, ContactMissing),
    missing_when_read(read, ConsequencesState, communication_describes_likely_consequences, ConsequencesMissing),
    missing_when_read(read, MeasuresState, communication_describes_measures_taken_or_proposed, MeasuresMissing),
    missing_when_read(MitigationRead, MitigationState, communication_describes_mitigation_measures, MitigationMissing),
    append([AppropriateMissing, DelayMissing, LanguageMissing, ContactMissing, ConsequencesMissing, MeasuresMissing, MitigationMissing], MissingKeys).

communication_route([Missing|MoreMissing], _, indeterminate([Missing|MoreMissing])).
communication_route([], Communication, Result) :-
    communication_judgements(Communication, Judged),
    first_unsure(Judged, [], Outcome),
    judged_communication_route(Outcome, Communication, Result).

communication_judgements(communication(AppropriateState, present(Delay), present(Language), _, _, _, MitigationState), Judged) :-
    judgement_pair_when(MitigationState, mitigation_measures_appropriate, AppropriateState, AppropriatePairs),
    append(AppropriatePairs, [communication_made_without_undue_delay - Delay, communication_describes_nature_in_clear_and_plain_language - Language], Judged).

judged_communication_route(unsure(Key, Relied), _, Referral) :-
    judgement_referral(Key, Relied, Referral).
judged_communication_route(none, Communication, Result) :-
    communication_items(Communication, Items),
    communication_items_route(Items, Result).

communication_items(communication(AppropriateState, DelayState, LanguageState, ContactState, ConsequencesState, MeasuresState, MitigationState), Items) :-
    implements(eu_reg_2016_679_art_34_1),
    implements(eu_reg_2016_679_art_34_2),
    implements(eu_reg_2016_679_art_33_3_d),
    item_when_false(DelayState, without_undue_delay, DelayItems),
    item_when_false(LanguageState, nature_of_breach_in_clear_and_plain_language, LanguageItems),
    item_when_false(ContactState, contact_point, ContactItems),
    item_when_false(ConsequencesState, likely_consequences, ConsequencesItems),
    item_when_false(MeasuresState, measures_taken_or_proposed, MeasuresItems),
    item_when_false_and_true(MitigationState, AppropriateState, mitigation_measures, MitigationItems),
    append([DelayItems, LanguageItems, ContactItems, ConsequencesItems, MeasuresItems, MitigationItems], Items).

communication_items_route([], all_requirements_met) :-
    implements(eu_reg_2016_679_art_34_2).
communication_items_route([Item|Items], requirements_not_met([Item|Items])) :-
    implements(eu_reg_2016_679_art_34_2).

decide_breach_notification_verdict(breach_notification_request(Profile, HoursElapsed), breach_notification_verdict_verdict(Status, Citations)) :-
    breach_notification_verdict(Profile, HoursElapsed, Status, Citations).

breach_notification_verdict_status(Request, Status) :-
    decide_breach_notification_verdict(Request, breach_notification_verdict_verdict(Status, _Citations)).

breach_notification_verdict_decision_resolvable(Request) :-
    decide_breach_notification_verdict(Request, _Verdict).

breach_notification_verdict_checklist(breach_notification_request(Profile, HoursElapsed), Items) :-
    verdict_request_problems(Profile, HoursElapsed, Problems),
    checklist_for_problems(Problems, Profile, HoursElapsed, Items).

checklist_for_problems([Problem|Problems], _, _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_33_1))]).
checklist_for_problems([], Profile, HoursElapsed, [item(notification_duty_arises, DutyStatus, cite(eu_reg_2016_679_art_33_1)), item(notified_within_the_period, WindowStatus, cite(eu_reg_2016_679_art_33_1)), item(timing_requirement_met, TimingStatus, cite(eu_reg_2016_679_art_33_1))]) :-
    key_value(Profile, breach_unlikely_to_result_in_risk, RiskState),
    duty_status(RiskState, DutyStatus),
    notification_window(HoursElapsed, Window),
    window_status(Window, WindowStatus),
    timing_status(Window, Profile, TimingStatus).

duty_status(absent, unknown([breach_unlikely_to_result_in_risk])).
duty_status(present(unsure), unknown([breach_unlikely_to_result_in_risk])).
duty_status(present(false), met) :-
    implements(eu_reg_2016_679_art_33_1).
duty_status(present(true), unmet(breach_unlikely_to_result_in_risk)) :-
    implements(eu_reg_2016_679_art_33_1).

window_status(within_period, met).
window_status(after_period, unmet(notified_after_the_period)).

timing_status(within_period, Profile, Status) :-
    implements(eu_reg_2016_679_art_33_1),
    key_value(Profile, notification_made_without_undue_delay, DelayState),
    undue_delay_status(DelayState, Status).
timing_status(after_period, Profile, Status) :-
    implements(eu_reg_2016_679_art_33_1),
    key_value(Profile, notification_accompanied_by_reasons_for_delay, ReasonsState),
    key_value(Profile, delay_justified_by_reasons, JustifiedState),
    reasons_status(ReasonsState, JustifiedState, Status).

undue_delay_status(present(true), met).
undue_delay_status(present(false), unmet(without_undue_delay)).
undue_delay_status(present(unsure), unknown([notification_made_without_undue_delay])).
undue_delay_status(absent, unknown([notification_made_without_undue_delay])).

reasons_status(absent, _, unknown([notification_accompanied_by_reasons_for_delay])).
reasons_status(present(false), _, unmet(reasons_for_delay)).
reasons_status(present(true), present(true), met).
reasons_status(present(true), present(false), unknown([delay_justified_by_reasons])).
reasons_status(present(true), present(unsure), unknown([delay_justified_by_reasons])).
reasons_status(present(true), absent, unknown([delay_justified_by_reasons])).

test(deadline_crosses_a_month_end) :-
    authority_notification_deadline(date(2025, 10, 31), date(Year, Month, Day), Hours),
    Year == 2025,
    Month == 11,
    Day == 3,
    Hours == 72.
test(deadline_reaches_a_leap_day) :-
    authority_notification_deadline(date(2032, 2, 26), date(Year, Month, Day), _),
    Year == 2032,
    Month == 2,
    Day == 29.
test(deadline_passes_a_leap_day) :-
    authority_notification_deadline(date(2032, 2, 27), date(Year, Month, Day), _),
    Year == 2032,
    Month == 3,
    Day == 1.
test(deadline_crosses_a_year_end) :-
    authority_notification_deadline(date(2025, 12, 30), date(Year, Month, Day), _),
    Year == 2026,
    Month == 1,
    Day == 2.
test(an_unreal_day_is_wrong_type_with_72_hours) :-
    authority_notification_deadline(date(2025, 2, 30), Deadline, Hours),
    Deadline == input_problems([wrong_type(awareness_date)]),
    Hours == 72.
test(the_deadline_has_one_solution) :-
    findall(Deadline - Hours, authority_notification_deadline(date(2025, 10, 31), Deadline, Hours), Answers),
    length(Answers, 1).
test(period_end_is_the_next_full_hour_three_days_later) :-
    authority_notification_period_end(date(2025, 10, 31), 10, period_end(date(Year, Month, Day), EndHour)),
    Year == 2025,
    Month == 11,
    Day == 3,
    EndHour == 11.
test(awareness_in_the_last_hour_ends_at_the_end_of_the_day) :-
    authority_notification_period_end(date(2025, 12, 30), 23, period_end(date(Year, Month, Day), EndHour)),
    Year == 2026,
    Month == 1,
    Day == 2,
    EndHour == 24.
test(period_end_names_both_bad_arguments) :-
    authority_notification_period_end(nothing, 24, PeriodEnd),
    PeriodEnd == input_problems([wrong_type(awareness_date), wrong_type(awareness_hour)]).
test(unlikely_risk_is_ineligible_whatever_the_hours) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 500, ineligible, [cite(eu_reg_2016_679_art_33_1)]).
test(an_absent_risk_judgement_is_indeterminate) :-
    breach_notification_verdict([], 10, indeterminate([breach_unlikely_to_result_in_risk]), []).
test(the_72nd_hour_without_undue_delay_is_eligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72, eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(undue_delay_inside_the_period_is_not_met) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, false)], 5, notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(no_reasons_after_the_period_is_not_met) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, false)], 73, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(unsure_justification_refers_with_the_timing_context) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, unsure)], 80, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 80, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - unsure])]),
    Citations == [].
test(an_unsure_risk_names_the_absent_timing_key) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, unsure)], 10, indeterminate([notification_made_without_undue_delay]), []).
test(a_negative_hour_count_is_an_input_problem) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], -1, input_problems([wrong_type(hours_elapsed)]), []).
test(the_verdict_has_one_solution) :-
    findall(Verdict - Citations, breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 3, Verdict, Citations), Answers),
    length(Answers, 1).
test(the_order_example_lists_the_public_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, true)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))].
test(the_processor_notifies_the_controller) :-
    notification_obligation([attribute(party_role, processor)], [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(an_absent_party_role_is_indeterminate) :-
    notification_obligation([], indeterminate([party_role])).
test(both_always_needed_keys_are_named) :-
    notification_obligation([attribute(party_role, controller)], indeterminate([breach_unlikely_to_result_in_risk, supervisory_authority_decision_on_communication])).
test(a_required_communication_governs) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, required_communication)], Obligation),
    Obligation == [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))].
test(a_true_point_b_decides_while_point_a_is_absent) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, true)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_b))].
test(an_absent_high_risk_judgement_is_named_alone) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure), attribute(supervisory_authority_decision_on_communication, no_decision)], indeterminate([breach_likely_to_result_in_high_risk])).
test(an_unsure_point_b_refers_with_its_pairs) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, unsure), attribute(communication_would_involve_disproportionate_effort, true)], Obligation),
    Obligation == needs_legal_review(open_textured(subsequent_measures_ensure_high_risk_no_longer_likely, cite(eu_reg_2016_679_art_34_3_b)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - true, appropriate_protection_measures_applied_to_affected_data - false, subsequent_measures_ensure_high_risk_no_longer_likely - unsure])]).
test(the_obligation_has_one_solution) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], Obligation), Answers),
    Answers == [[no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]].
test(a_complete_notification_meets_every_requirement) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], all_requirements_met).
test(an_empty_notification_profile_names_every_key_read) :-
    authority_notification_content_check([], indeterminate([notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, information_not_possible_to_provide_at_the_same_time])).
test(a_missing_nature_with_no_phases_is_not_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], requirements_not_met([nature_of_breach])).
test(a_missing_nature_may_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], information_to_follow_in_phases([nature_of_breach])).
test(one_pending_item_names_the_phases_key) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, unsure), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], indeterminate([information_not_possible_to_provide_at_the_same_time])).
test(an_unsure_possibility_refers) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, unsure), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], Result),
    Result == needs_legal_review(open_textured(categories_and_approximate_numbers_possible, cite(eu_reg_2016_679_art_33_3_a)), [inputs_relied_on([categories_and_approximate_numbers_possible - unsure])]).
test(a_complete_communication_meets_every_requirement) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], all_requirements_met).
test(an_unduly_delayed_communication_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, false), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], requirements_not_met([without_undue_delay])).
test(an_absent_appropriateness_behind_a_false_mitigation_is_named) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, false)], indeterminate([mitigation_measures_appropriate])).
test(an_unsure_communication_delay_refers_with_its_pairs) :-
    data_subject_communication_check([attribute(mitigation_measures_appropriate, true), attribute(communication_made_without_undue_delay, unsure), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, false)], Result),
    Result == needs_legal_review(open_textured(communication_made_without_undue_delay, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([mitigation_measures_appropriate - true, communication_made_without_undue_delay - unsure])]).
test(a_contradictory_profile_is_refused_by_the_content_check) :-
    data_subject_communication_check([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(the_facade_decides_through_the_request) :-
    decide_breach_notification_verdict(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true)], 1), breach_notification_verdict_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)])).
test(the_checklist_has_one_row_per_ground) :-
    breach_notification_verdict_checklist(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 12), Items),
    Items == [item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notified_within_the_period, met, cite(eu_reg_2016_679_art_33_1)), item(timing_requirement_met, met, cite(eu_reg_2016_679_art_33_1))].

test(unlikely_risk_is_not_eligible, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 500, eligible, _).
