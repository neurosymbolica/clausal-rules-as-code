% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, nis2_incident_reporting_status/2, nis2_incident_reporting_checklist/2, nis2_incident_reporting_decision_resolvable/1, nis2_incident_reporting_status_values/1, incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_subject/1, nis2_incident_reporting_profile_for/2, nis2_incident_reporting_assess/2]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_queries, [nis2_incident_reporting_what_if/4]).

test(limb_a_met_is_significant) :-
    nis2_incident_reporting_assess(limb_a_met, nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_a)])).
test(limb_b_met_is_significant) :-
    nis2_incident_reporting_assess(limb_b_met, nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_b)])).
test(both_limbs_false_is_not_significant) :-
    nis2_incident_reporting_assess(both_limbs_false, nis2_incident_reporting_verdict(not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)])).
test(limb_a_false_limb_b_absent_is_indeterminate) :-
    nis2_incident_reporting_assess(limb_a_false_limb_b_absent, nis2_incident_reporting_verdict(indeterminate([considerable_damage_to_other_persons]), [])).
test(no_keys_is_indeterminate) :-
    nis2_incident_reporting_assess(no_keys_given, nis2_incident_reporting_verdict(indeterminate([severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons]), [])).
test(limb_a_unsure_refers) :-
    nis2_incident_reporting_assess(limb_a_unsure, nis2_incident_reporting_verdict(needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])]), [])).
test(unknown_key_is_an_input_problem) :-
    nis2_incident_reporting_assess(unknown_key_given, nis2_incident_reporting_verdict(input_problems([unknown_key(bogus)]), [])).
test(each_subject_has_one_answer) :-
    nis2_incident_reporting_subject(Subject),
    findall(Result, nis2_incident_reporting_assess(Subject, Result), Results),
    length(Results, 1).
test(checklist_is_non_empty) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_decision_resolvable(Profile),
    nis2_incident_reporting_checklist(Profile, [_FirstItem|_OtherItems]).
test(status_is_in_status_values) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_status(Profile, Status),
    nis2_incident_reporting_status_values(StatusValues),
    member(Status, StatusValues).
test(input_check_is_clean_for_a_fixture) :-
    nis2_incident_reporting_profile_for(limb_b_met, Profile),
    nis2_incident_reporting_input_problems(Profile, []).
test(what_if_flips_not_significant_to_significant) :-
    nis2_incident_reporting_profile_for(both_limbs_false, Profile),
    nis2_incident_reporting_what_if(Profile, considerable_damage_to_other_persons, true, significant).
test(steps_standard_not_ongoing) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, false)], [step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]).
test(steps_provider_gets_24_hours) :-
    incident_reporting_steps([attribute(considerable_damage_to_other_persons, true), attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_ongoing_at_final_report_due, false)], [step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]).
test(steps_ongoing_adds_two) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, true)], [step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)), step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]).
test(steps_empty_when_not_significant) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], []).
test(steps_need_provider_and_ongoing_keys) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true)], indeterminate([trust_service_provider_incident_affects_trust_services, incident_ongoing_at_final_report_due])).
test(steps_one_solution) :-
    findall(Steps, incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], Steps), StepLists),
    StepLists == [[]].
test(early_warning_at_24_is_on_time) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, on_time).
test(early_warning_at_25_is_late) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 25, late(hour_limit)).
test(early_warning_undue_delay_false_is_late) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, false)], early_warning, 10, late(without_undue_delay)).
test(early_warning_undue_delay_unsure_refers) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, unsure)], early_warning, 10, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(early_warning_undue_delay_absent_is_indeterminate) :-
    reporting_step_timeliness([], early_warning, 10, indeterminate([early_warning_without_undue_delay])).
test(notification_at_72_standard_is_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, on_time).
test(notification_at_73_is_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 73, late(hour_limit)).
test(provider_notification_at_24_is_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 24, on_time).
test(provider_notification_at_25_is_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 25, late(hour_limit)).
test(non_provider_notification_at_25_is_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 25, on_time).
test(notification_between_needs_provider_key) :-
    reporting_step_timeliness([], incident_notification, 30, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(notification_undue_delay_false_is_late) :-
    reporting_step_timeliness([attribute(incident_notification_without_undue_delay, false)], incident_notification, 10, late(without_undue_delay)).
test(notification_undue_delay_unsure_refers) :-
    reporting_step_timeliness([attribute(incident_notification_without_undue_delay, unsure)], incident_notification, 10, needs_legal_review(open_textured(incident_notification_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_b)), [inputs_relied_on([incident_notification_without_undue_delay - unsure])])).
test(bad_step_and_hours_are_input_problems) :-
    reporting_step_timeliness([], final_report, -1, input_problems([wrong_type(step), wrong_type(hours_elapsed)])).
test(timeliness_one_solution) :-
    findall(Result, reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, Result), Results),
    Results == [on_time].

test(near_miss_is_not_significant, fail) :-
    nis2_incident_reporting_assess(both_limbs_false, nis2_incident_reporting_verdict(significant, _Citations)).
test(what_if_keeps_not_significant, fail) :-
    nis2_incident_reporting_profile_for(both_limbs_false, Profile),
    nis2_incident_reporting_what_if(Profile, considerable_damage_to_other_persons, false, significant).
test(early_warning_at_24_is_not_late, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, late(hour_limit)).
test(notification_at_72_is_not_late, fail) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, late(hour_limit)).

cp_test_names([limb_a_met_is_significant, limb_b_met_is_significant, both_limbs_false_is_not_significant, limb_a_false_limb_b_absent_is_indeterminate, no_keys_is_indeterminate, limb_a_unsure_refers, unknown_key_is_an_input_problem, each_subject_has_one_answer, checklist_is_non_empty, status_is_in_status_values, input_check_is_clean_for_a_fixture, what_if_flips_not_significant_to_significant, steps_standard_not_ongoing, steps_provider_gets_24_hours, steps_ongoing_adds_two, steps_empty_when_not_significant, steps_need_provider_and_ongoing_keys, steps_one_solution, early_warning_at_24_is_on_time, early_warning_at_25_is_late, early_warning_undue_delay_false_is_late, early_warning_undue_delay_unsure_refers, early_warning_undue_delay_absent_is_indeterminate, notification_at_72_standard_is_on_time, notification_at_73_is_late, provider_notification_at_24_is_on_time, provider_notification_at_25_is_late, non_provider_notification_at_25_is_on_time, notification_between_needs_provider_key, notification_undue_delay_false_is_late, notification_undue_delay_unsure_refers, bad_step_and_hours_are_input_problems, timeliness_one_solution]).
cp_test_fail_names([near_miss_is_not_significant, what_if_keeps_not_significant, early_warning_at_24_is_not_late, notification_at_72_is_not_late]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
