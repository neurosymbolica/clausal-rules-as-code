% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4, decide_nis2_incident_reporting/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

subject_timeliness(Subject, Step, Hours, Results) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Result, reporting_step_timeliness(Profile, Step, Hours, Result), Results).

subject_steps(Subject, Answers) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), Answers).

test(limb_b_gives_one_answer_citing_b) :-
    nis2_incident_reporting_profile_for(damage_met_disruption_unsure, Profile),
    findall(Status - Citations, incident_significance(Profile, Status, Citations), Answers),
    Answers == [significant - [cite(eu_dir_2022_2555_art_23_3_b)]].
test(neither_limb_gives_one_answer) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    findall(Status - Citations, incident_significance(Profile, Status, Citations), Answers),
    Answers == [not_significant - [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]].
test(steps_for_an_ongoing_trust_provider_incident) :-
    subject_steps(trust_provider_ongoing_prompt, Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)), step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]].
test(steps_refer_when_the_facts_are_complete) :-
    subject_steps(damage_unsure_facts_complete, Answers),
    Answers == [needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure])])].
test(steps_name_the_trust_key_before_the_referral) :-
    subject_steps(disruption_unsure_damage_not_met, Answers),
    Answers == [indeterminate([trust_service_provider_incident_affects_trust_services])].
test(steps_for_a_not_significant_incident_are_empty) :-
    subject_steps(neither_limb_met, Answers),
    Answers == [[]].
test(step_names_enumerate_in_order) :-
    nis2_incident_reporting_profile_for(trust_provider_ongoing_prompt, Profile),
    findall(Step, (incident_reporting_steps(Profile, Steps), member(step_due(Step, _, _), Steps)), StepNames),
    StepNames == [early_warning, incident_notification, intermediate_report, final_report, progress_report, final_report_after_handling].
test(early_warning_at_24_hours_is_on_time) :-
    subject_timeliness(ordinary_provider_settled_prompt, early_warning, 24, Results),
    Results == [on_time].
test(early_warning_at_25_hours_is_late) :-
    subject_timeliness(ordinary_provider_settled_prompt, early_warning, 25, Results),
    Results == [late(hour_limit)].
test(notification_at_72_hours_is_on_time_for_an_ordinary_provider) :-
    subject_timeliness(ordinary_provider_settled_prompt, incident_notification, 72, Results),
    Results == [on_time].
test(notification_at_73_hours_is_late) :-
    subject_timeliness(ordinary_provider_settled_prompt, incident_notification, 73, Results),
    Results == [late(hour_limit)].
test(notification_at_25_hours_is_late_for_a_trust_provider) :-
    subject_timeliness(trust_provider_ongoing_prompt, incident_notification, 25, Results),
    Results == [late(hour_limit)].
test(notification_at_24_hours_is_on_time_for_a_trust_provider) :-
    subject_timeliness(trust_provider_ongoing_prompt, incident_notification, 24, Results),
    Results == [on_time].
test(notification_at_30_hours_asks_for_the_trust_key) :-
    subject_timeliness(trust_service_unanswered, incident_notification, 30, Results),
    Results == [indeterminate([trust_service_provider_incident_affects_trust_services])].
test(notification_at_24_hours_does_not_read_the_trust_key) :-
    subject_timeliness(trust_service_unanswered, incident_notification, 24, Results),
    Results == [on_time].
test(notification_unsure_delay_refers) :-
    subject_timeliness(ordinary_provider_delay_unsure, incident_notification, 48, Results),
    Results == [needs_legal_review(open_textured(incident_notification_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_b)), [inputs_relied_on([incident_notification_without_undue_delay - unsure])])].
test(early_warning_unsure_delay_refers) :-
    subject_timeliness(ordinary_provider_delay_unsure, early_warning, 5, Results),
    Results == [needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])].
test(the_verdict_carries_a_citation) :-
    nis2_incident_reporting_profile_for(severe_disruption_met, Profile),
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(significant, [_FirstCitation|_OtherCitations])).

cp_test_names([limb_b_gives_one_answer_citing_b, neither_limb_gives_one_answer, steps_for_an_ongoing_trust_provider_incident, steps_refer_when_the_facts_are_complete, steps_name_the_trust_key_before_the_referral, steps_for_a_not_significant_incident_are_empty, step_names_enumerate_in_order, early_warning_at_24_hours_is_on_time, early_warning_at_25_hours_is_late, notification_at_72_hours_is_on_time_for_an_ordinary_provider, notification_at_73_hours_is_late, notification_at_25_hours_is_late_for_a_trust_provider, notification_at_24_hours_is_on_time_for_a_trust_provider, notification_at_30_hours_asks_for_the_trust_key, notification_at_24_hours_does_not_read_the_trust_key, notification_unsure_delay_refers, early_warning_unsure_delay_refers, the_verdict_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
