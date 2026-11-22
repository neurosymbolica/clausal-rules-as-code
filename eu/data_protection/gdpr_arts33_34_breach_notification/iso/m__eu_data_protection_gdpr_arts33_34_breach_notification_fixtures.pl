% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2]).

breach_fixture(timely_at_the_period_end, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72).
breach_fixture(late_one_hour_past_without_reasons, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], 73).
breach_fixture(unlikely_risk_notified_late, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 100).
breach_fixture(risk_notified_late_with_justified_reasons, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 100).
breach_fixture(late_with_unjustified_reasons, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 100).
breach_fixture(notified_inside_the_period_without_undue_delay, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10).
breach_fixture(notified_inside_the_period_with_undue_delay, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, false)], 10).
breach_fixture(risk_judgement_missing, [attribute(party_role, controller), attribute(notification_made_without_undue_delay, true)], 10).
breach_fixture(risk_judgement_unsure, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_made_without_undue_delay, true)], 10).
breach_fixture(negative_hours_elapsed, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], -1).
breach_fixture(contradictory_risk_judgements, [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], 10).

gdpr_arts33_34_breach_notification_subject(Subject) :-
    breach_fixture(Subject, _, _).

gdpr_arts33_34_breach_notification_profile_for(Subject, Profile) :-
    breach_fixture(Subject, Profile, _).

gdpr_arts33_34_breach_notification_assess(Subject, Result) :-
    breach_fixture(Subject, Profile, HoursElapsed),
    decide_breach_notification_verdict(case(Profile, HoursElapsed), Result).
