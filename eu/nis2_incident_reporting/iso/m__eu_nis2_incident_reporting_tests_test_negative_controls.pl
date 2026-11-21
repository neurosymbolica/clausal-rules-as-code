% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(route_limb_a_positive) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, true), attribute(considerable_damage_to_other_persons, false)], significant, [cite(eu_dir_2022_2555_art_23_3_a)]).
test(route_limb_a_near_miss_answer) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], not_significant, _).
test(route_limb_b_positive) :-
    nis2_incident_reporting_profile_for(damage_met_disruption_unsure, Profile),
    incident_significance(Profile, significant, [cite(eu_dir_2022_2555_art_23_3_b)]).
test(route_limb_b_near_miss_answer) :-
    nis2_incident_reporting_profile_for(disruption_unsure_damage_not_met, Profile),
    incident_significance(Profile, needs_legal_review(_, _), []).
test(route_absent_limb_positive) :-
    nis2_incident_reporting_profile_for(disruption_unanswered, Profile),
    incident_significance(Profile, indeterminate([severe_operational_disruption_or_financial_loss]), []).
test(route_unsure_limb_positive) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, unsure)], needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure])]), []).
test(route_unsure_limb_near_miss_answer) :-
    incident_significance([attribute(considerable_damage_to_other_persons, unsure)], indeterminate([severe_operational_disruption_or_financial_loss]), []).
test(route_no_steps_positive) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    incident_reporting_steps(Profile, []).
test(route_referral_steps_positive) :-
    nis2_incident_reporting_profile_for(damage_unsure_facts_complete, Profile),
    incident_reporting_steps(Profile, needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), _)).
test(route_referral_steps_near_miss_answer) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, unsure), attribute(incident_ongoing_at_final_report_due, false)], indeterminate([trust_service_provider_incident_affects_trust_services])).
test(route_ongoing_missing_positive) :-
    nis2_incident_reporting_profile_for(significant_ongoing_unanswered, Profile),
    incident_reporting_steps(Profile, indeterminate([incident_ongoing_at_final_report_due])).
test(route_trust_limit_positive) :-
    nis2_incident_reporting_profile_for(trust_provider_ongoing_prompt, Profile),
    incident_reporting_steps(Profile, [_, step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4))|_]).
test(route_ongoing_steps_positive) :-
    nis2_incident_reporting_profile_for(trust_provider_ongoing_prompt, Profile),
    incident_reporting_steps(Profile, Steps),
    length(Steps, 6).
test(route_early_warning_late_positive) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 25, late(hour_limit)).
test(route_early_warning_late_near_miss_answer) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, on_time).
test(route_undue_delay_positive) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, false)], early_warning, 3, late(without_undue_delay)).
test(route_undue_delay_absent_is_asked_for) :-
    reporting_step_timeliness([], early_warning, 3, indeterminate([early_warning_without_undue_delay])).
test(route_notification_late_positive) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 73, late(hour_limit)).
test(route_trust_window_positive) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 25, late(hour_limit)).
test(route_trust_window_absent_is_asked_for) :-
    nis2_incident_reporting_profile_for(trust_service_unanswered, Profile),
    reporting_step_timeliness(Profile, incident_notification, 25, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(route_input_problems_positive) :-
    nis2_incident_reporting_profile_for(crisp_key_given_unsure, Profile),
    incident_significance(Profile, input_problems([wrong_type(trust_service_provider_incident_affects_trust_services)]), []).
test(route_input_problems_near_miss_clean) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false)], []).
test(route_duplicate_key_answer) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, maybe), attribute(severe_operational_disruption_or_financial_loss, true)], [duplicate_key(severe_operational_disruption_or_financial_loss)]).

test(route_limb_a_near_miss_is_not_significant, fail) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], significant, _).
test(route_limb_b_near_miss_is_not_significant, fail) :-
    nis2_incident_reporting_profile_for(disruption_unsure_damage_not_met, Profile),
    incident_significance(Profile, significant, _).
test(route_absent_limb_near_miss_is_not_indeterminate, fail) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], indeterminate(_), _).
test(route_unsure_limb_near_miss_absent_names_the_key, fail) :-
    incident_significance([attribute(considerable_damage_to_other_persons, unsure)], needs_legal_review(_, _), _).
test(route_no_steps_near_miss, fail) :-
    nis2_incident_reporting_profile_for(ordinary_provider_settled_prompt, Profile),
    incident_reporting_steps(Profile, []).
test(route_referral_steps_near_miss_without_tsp, fail) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, unsure), attribute(incident_ongoing_at_final_report_due, false)], needs_legal_review(_, _)).
test(route_ongoing_missing_near_miss, fail) :-
    incident_reporting_steps([attribute(considerable_damage_to_other_persons, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, false)], indeterminate(_)).
test(route_trust_limit_near_miss, fail) :-
    nis2_incident_reporting_profile_for(ordinary_provider_settled_prompt, Profile),
    incident_reporting_steps(Profile, [_, step_due(incident_notification, hours_after_awareness(24), _)|_]).
test(route_ongoing_steps_near_miss, fail) :-
    nis2_incident_reporting_profile_for(ordinary_provider_settled_prompt, Profile),
    incident_reporting_steps(Profile, Steps),
    member(step_due(progress_report, _, _), Steps).
test(route_early_warning_late_near_miss, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, late(_)).
test(route_undue_delay_near_miss, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 3, late(without_undue_delay)).
test(route_notification_late_near_miss, fail) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, late(_)).
test(route_trust_window_near_miss, fail) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 25, late(_)).
test(route_input_problems_near_miss, fail) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false)], input_problems(_), _).
test(route_duplicate_key_is_not_wrong_type, fail) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, maybe), attribute(severe_operational_disruption_or_financial_loss, true)], [wrong_type(_)|_]).

cp_test_names([route_limb_a_positive, route_limb_a_near_miss_answer, route_limb_b_positive, route_limb_b_near_miss_answer, route_absent_limb_positive, route_unsure_limb_positive, route_unsure_limb_near_miss_answer, route_no_steps_positive, route_referral_steps_positive, route_referral_steps_near_miss_answer, route_ongoing_missing_positive, route_trust_limit_positive, route_ongoing_steps_positive, route_early_warning_late_positive, route_early_warning_late_near_miss_answer, route_undue_delay_positive, route_undue_delay_absent_is_asked_for, route_notification_late_positive, route_trust_window_positive, route_trust_window_absent_is_asked_for, route_input_problems_positive, route_input_problems_near_miss_clean, route_duplicate_key_answer]).
cp_test_fail_names([route_limb_a_near_miss_is_not_significant, route_limb_b_near_miss_is_not_significant, route_absent_limb_near_miss_is_not_indeterminate, route_unsure_limb_near_miss_absent_names_the_key, route_no_steps_near_miss, route_referral_steps_near_miss_without_tsp, route_ongoing_missing_near_miss, route_trust_limit_near_miss, route_ongoing_steps_near_miss, route_early_warning_late_near_miss, route_undue_delay_near_miss, route_notification_late_near_miss, route_trust_window_near_miss, route_input_problems_near_miss, route_duplicate_key_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
