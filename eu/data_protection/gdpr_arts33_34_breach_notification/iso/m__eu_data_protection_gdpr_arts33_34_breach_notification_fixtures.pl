% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2]).

gdpr_arts33_34_breach_notification_subject(timely_notification_eligible).
gdpr_arts33_34_breach_notification_subject(timely_notification_unduly_delayed).
gdpr_arts33_34_breach_notification_subject(seventy_two_hours_in_time).
gdpr_arts33_34_breach_notification_subject(seventy_three_hours_without_reasons).
gdpr_arts33_34_breach_notification_subject(seventy_three_hours_with_justified_reasons).
gdpr_arts33_34_breach_notification_subject(seventy_three_hours_with_unjustified_reasons).
gdpr_arts33_34_breach_notification_subject(unlikely_risk_ineligible).
gdpr_arts33_34_breach_notification_subject(likely_risk_eligible).
gdpr_arts33_34_breach_notification_subject(unlikely_risk_ineligible_after_the_period).
gdpr_arts33_34_breach_notification_subject(unsure_risk_referred).
gdpr_arts33_34_breach_notification_subject(unsure_risk_missing_undue_delay).
gdpr_arts33_34_breach_notification_subject(missing_risk_judgement).
gdpr_arts33_34_breach_notification_subject(consistent_risk_inputs).
gdpr_arts33_34_breach_notification_subject(contradictory_risk_inputs).
gdpr_arts33_34_breach_notification_subject(zero_hours_elapsed).
gdpr_arts33_34_breach_notification_subject(negative_hours_elapsed).
gdpr_arts33_34_breach_notification_subject(public_communication_substitute).
gdpr_arts33_34_breach_notification_subject(direct_communication_owed).
gdpr_arts33_34_breach_notification_subject(processor_notifies_controller).
gdpr_arts33_34_breach_notification_subject(authority_required_communication).
gdpr_arts33_34_breach_notification_subject(authority_no_decision_unlikely_risk).

gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 40)).
gdpr_arts33_34_breach_notification_profile_for(timely_notification_unduly_delayed, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, false)], 40)).
gdpr_arts33_34_breach_notification_profile_for(seventy_two_hours_in_time, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], 72)).
gdpr_arts33_34_breach_notification_profile_for(seventy_three_hours_without_reasons, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], 73)).
gdpr_arts33_34_breach_notification_profile_for(seventy_three_hours_with_justified_reasons, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, true)], 73)).
gdpr_arts33_34_breach_notification_profile_for(seventy_three_hours_with_unjustified_reasons, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(delay_justified_by_reasons, false), attribute(notification_accompanied_by_reasons_for_delay, true)], 73)).
gdpr_arts33_34_breach_notification_profile_for(unlikely_risk_ineligible, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(likely_risk_eligible, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(unlikely_risk_ineligible_after_the_period, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true)], 200)).
gdpr_arts33_34_breach_notification_profile_for(unsure_risk_referred, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(unsure_risk_missing_undue_delay, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, unsure)], 10)).
gdpr_arts33_34_breach_notification_profile_for(missing_risk_judgement, breach_notification_request([attribute(notification_made_without_undue_delay, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(consistent_risk_inputs, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, false)], 10)).
gdpr_arts33_34_breach_notification_profile_for(contradictory_risk_inputs, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], 10)).
gdpr_arts33_34_breach_notification_profile_for(zero_hours_elapsed, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 0)).
gdpr_arts33_34_breach_notification_profile_for(negative_hours_elapsed, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], -1)).
gdpr_arts33_34_breach_notification_profile_for(public_communication_substitute, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(party_role, controller), attribute(notification_made_without_undue_delay, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, true)], 20)).
gdpr_arts33_34_breach_notification_profile_for(direct_communication_owed, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(party_role, controller), attribute(notification_made_without_undue_delay, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], 20)).
gdpr_arts33_34_breach_notification_profile_for(processor_notifies_controller, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(party_role, processor), attribute(notification_made_without_undue_delay, true)], 5)).
gdpr_arts33_34_breach_notification_profile_for(authority_required_communication, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(party_role, controller), attribute(supervisory_authority_decision_on_communication, required_communication)], 5)).
gdpr_arts33_34_breach_notification_profile_for(authority_no_decision_unlikely_risk, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(party_role, controller), attribute(supervisory_authority_decision_on_communication, no_decision)], 5)).

gdpr_arts33_34_breach_notification_assess(Subject, Result) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    decide_breach_notification_verdict(Request, Result).

subject_has_one_request(Subject) :-
    findall(Request, gdpr_arts33_34_breach_notification_profile_for(Subject, Request), Requests),
    length(Requests, 1).

test(every_subject_has_exactly_one_request) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_has_one_request, Subjects).
test(every_subject_is_registered_once) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    sort(Subjects, Distinct),
    length(Subjects, Count),
    length(Distinct, Count).
test(the_boundary_pair_differs_by_one_hour_only) :-
    gdpr_arts33_34_breach_notification_profile_for(seventy_two_hours_in_time, breach_notification_request(InTimeProfile, InTimeHours)),
    gdpr_arts33_34_breach_notification_profile_for(seventy_three_hours_without_reasons, breach_notification_request(LateProfile, LateHours)),
    InTimeProfile == LateProfile,
    InTimeHours == 72,
    LateHours == 73.
test(the_boundary_subject_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(seventy_two_hours_in_time, breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).

test(the_boundary_subject_is_not_late, fail) :-
    gdpr_arts33_34_breach_notification_assess(seventy_two_hours_in_time, breach_notification_verdict_verdict(notification_requirement_not_met(_), _)).
