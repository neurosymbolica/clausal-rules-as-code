% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2]).

gdpr_arts33_34_breach_notification_subject(timely_notification_eligible).
gdpr_arts33_34_breach_notification_subject(one_hour_late_without_reasons).
gdpr_arts33_34_breach_notification_subject(inside_period_unduly_delayed).
gdpr_arts33_34_breach_notification_subject(unlikely_risk_ineligible).
gdpr_arts33_34_breach_notification_subject(risk_not_unlikely_control).
gdpr_arts33_34_breach_notification_subject(late_with_justified_reasons_eligible).
gdpr_arts33_34_breach_notification_subject(late_with_unjustified_reasons_referral).
gdpr_arts33_34_breach_notification_subject(risk_judgement_missing).
gdpr_arts33_34_breach_notification_subject(risk_judgement_stated_control).
gdpr_arts33_34_breach_notification_subject(unsure_risk_referral).
gdpr_arts33_34_breach_notification_subject(contradictory_risk_inputs).
gdpr_arts33_34_breach_notification_subject(consistent_risk_inputs_control).
gdpr_arts33_34_breach_notification_subject(negative_hours_input_problem).
gdpr_arts33_34_breach_notification_subject(zero_hours_eligible).

gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72)).
gdpr_arts33_34_breach_notification_profile_for(one_hour_late_without_reasons, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], 73)).
gdpr_arts33_34_breach_notification_profile_for(inside_period_unduly_delayed, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, false)], 72)).
gdpr_arts33_34_breach_notification_profile_for(unlikely_risk_ineligible, case([attribute(breach_unlikely_to_result_in_risk, true), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 100)).
gdpr_arts33_34_breach_notification_profile_for(risk_not_unlikely_control, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 100)).
gdpr_arts33_34_breach_notification_profile_for(late_with_justified_reasons_eligible, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 73)).
gdpr_arts33_34_breach_notification_profile_for(late_with_unjustified_reasons_referral, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 73)).
gdpr_arts33_34_breach_notification_profile_for(risk_judgement_missing, case([], 10)).
gdpr_arts33_34_breach_notification_profile_for(risk_judgement_stated_control, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(unsure_risk_referral, case([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(contradictory_risk_inputs, case([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(consistent_risk_inputs_control, case([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, unsure)], 10)).
gdpr_arts33_34_breach_notification_profile_for(negative_hours_input_problem, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], -1)).
gdpr_arts33_34_breach_notification_profile_for(zero_hours_eligible, case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 0)).

gdpr_arts33_34_breach_notification_assess(Subject, Result) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    decide_breach_notification_verdict(Request, Result).
