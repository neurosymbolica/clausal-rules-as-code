% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [nis2_incident_reporting_status/2, nis2_incident_reporting_status_values/1, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    nis2_incident_reporting_status_values(StatusValues),
    member(not_significant, StatusValues).
test(limb_a_is_significant) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_status(Profile, significant).
test(both_false_is_not_significant) :-
    nis2_incident_reporting_profile_for(both_limbs_false, Profile),
    nis2_incident_reporting_status(Profile, not_significant).
test(limb_b_alone_is_significant) :-
    nis2_incident_reporting_profile_for(limb_b_met, Profile),
    nis2_incident_reporting_status(Profile, significant).
test(early_warning_24_on_time) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, on_time).
test(early_warning_25_late) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 25, late(hour_limit)).
test(notification_30_standard_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 30, on_time).
test(notification_30_provider_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 30, late(hour_limit)).
test(notification_72_on_time_and_73_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, on_time),
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 73, late(hour_limit)).
test(undue_delay_true_on_time) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 5, on_time).
test(undue_delay_false_late) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, false)], early_warning, 5, late(without_undue_delay)).
test(ongoing_has_six_steps) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, true)], Steps),
    length(Steps, 6).
test(not_ongoing_has_four_steps) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, false)], Steps),
    length(Steps, 4).

test(both_false_is_not_significant_near_miss, fail) :-
    nis2_incident_reporting_profile_for(both_limbs_false, Profile),
    nis2_incident_reporting_status(Profile, significant).
test(limb_b_alone_is_not_not_significant, fail) :-
    nis2_incident_reporting_profile_for(limb_b_met, Profile),
    nis2_incident_reporting_status(Profile, not_significant).
test(early_warning_25_is_not_on_time, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 25, on_time).
test(notification_30_provider_not_on_time, fail) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 30, on_time).
test(undue_delay_false_not_on_time, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, false)], early_warning, 5, on_time).
test(not_ongoing_does_not_have_six_steps, fail) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, false)], Steps),
    length(Steps, 6).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, limb_a_is_significant, both_false_is_not_significant, limb_b_alone_is_significant, early_warning_24_on_time, early_warning_25_late, notification_30_standard_on_time, notification_30_provider_late, notification_72_on_time_and_73_late, undue_delay_true_on_time, undue_delay_false_late, ongoing_has_six_steps, not_ongoing_has_four_steps]).
cp_test_fail_names([both_false_is_not_significant_near_miss, limb_b_alone_is_not_not_significant, early_warning_25_is_not_on_time, notification_30_provider_not_on_time, undue_delay_false_not_on_time, not_ongoing_does_not_have_six_steps]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
