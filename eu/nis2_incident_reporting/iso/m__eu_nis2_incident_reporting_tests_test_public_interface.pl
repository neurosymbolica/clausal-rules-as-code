% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, nis2_incident_reporting_status/2, nis2_incident_reporting_checklist/2, nis2_incident_reporting_decision_resolvable/1, nis2_incident_reporting_status_values/1, incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_subject/1, nis2_incident_reporting_profile_for/2, nis2_incident_reporting_assess/2]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).

expected_status(severe_disruption_met, significant).
expected_status(neither_limb_met, not_significant).
expected_status(damage_met_disruption_unsure, significant).
expected_status(disruption_unsure_damage_not_met, needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])])).
expected_status(disruption_unanswered, indeterminate([severe_operational_disruption_or_financial_loss])).
expected_status(damage_unanswered_disruption_unsure, indeterminate([considerable_damage_to_other_persons])).
expected_status(trust_provider_ongoing_prompt, significant).
expected_status(ordinary_provider_settled_prompt, significant).
expected_status(damage_unsure_facts_complete, needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure])])).
expected_status(significant_ongoing_unanswered, significant).
expected_status(ordinary_provider_delayed, significant).
expected_status(ordinary_provider_delay_unsure, significant).
expected_status(trust_service_unanswered, significant).
expected_status(duplicate_and_unknown_keys, input_problems([duplicate_key(severe_operational_disruption_or_financial_loss), unknown_key(unrelated_key)])).
expected_status(crisp_key_given_unsure, input_problems([wrong_type(trust_service_provider_incident_affects_trust_services)])).

subjects_match_expected([]).
subjects_match_expected([Subject|Subjects]) :-
    expected_status(Subject, Expected),
    findall(Status, nis2_incident_reporting_assess(Subject, nis2_incident_reporting_verdict(Status, _Citations)), Statuses),
    Statuses == [Expected],
    subjects_match_expected(Subjects).

subjects_have_checklists([]).
subjects_have_checklists([Subject|Subjects]) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    findall(Checklist, nis2_incident_reporting_checklist(Profile, Checklist), Checklists),
    Checklists = [[_FirstItem|_OtherItems]],
    subjects_have_checklists(Subjects).

subject_profile(Subject, Profile) :-
    nis2_incident_reporting_profile_for(Subject, Profile).

test(every_subject_has_an_expectation) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    sort(Subjects, SortedSubjects),
    findall(Expected, expected_status(Expected, _), ExpectedSubjects),
    sort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    subjects_match_expected(Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, nis2_incident_reporting_subject(Subject), Subjects),
    subjects_have_checklists(Subjects).
test(every_status_is_in_the_status_vocabulary) :-
    nis2_incident_reporting_status_values(StatusValues),
    nis2_incident_reporting_assess(severe_disruption_met, nis2_incident_reporting_verdict(Status, _Citations)),
    member(Status, StatusValues).
test(the_decision_is_resolvable) :-
    subject_profile(neither_limb_met, Profile),
    nis2_incident_reporting_decision_resolvable(Profile).
test(limb_a_met_cites_point_a) :-
    subject_profile(severe_disruption_met, Profile),
    findall(Status - Citations, incident_significance(Profile, Status, Citations), Answers),
    Answers == [significant - [cite(eu_dir_2022_2555_art_23_3_a)]].
test(limb_a_near_miss_is_not_significant_citing_both) :-
    subject_profile(neither_limb_met, Profile),
    findall(Status - Citations, incident_significance(Profile, Status, Citations), Answers),
    Answers == [not_significant - [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]].
test(limb_b_met_beside_unsure_a_cites_point_b) :-
    subject_profile(damage_met_disruption_unsure, Profile),
    incident_significance(Profile, significant, [cite(eu_dir_2022_2555_art_23_3_b)]).
test(limb_b_near_miss_refers_the_unsure_limb) :-
    subject_profile(disruption_unsure_damage_not_met, Profile),
    incident_significance(Profile, needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])]), []).
test(an_absent_limb_is_named_before_an_unsure_one) :-
    subject_profile(damage_unanswered_disruption_unsure, Profile),
    incident_significance(Profile, indeterminate([considerable_damage_to_other_persons]), []).
test(facade_status_projects_the_verdict) :-
    subject_profile(disruption_unanswered, Profile),
    nis2_incident_reporting_status(Profile, indeterminate([severe_operational_disruption_or_financial_loss])).
test(facade_verdict_carries_the_citations) :-
    subject_profile(severe_disruption_met, Profile),
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_a)])).
test(checklist_rows_for_limb_a) :-
    subject_profile(severe_disruption_met, Profile),
    nis2_incident_reporting_checklist(Profile, [item(severe_operational_disruption_or_financial_loss, met, cite(eu_dir_2022_2555_art_23_3_a)), item(considerable_damage_to_other_persons, unknown([considerable_damage_to_other_persons]), cite(eu_dir_2022_2555_art_23_3_b))]).
test(significance_referral_context_takes_an_optional_provenance_element) :-
    subject_profile(damage_unsure_facts_complete, Profile),
    incident_significance(Profile, needs_legal_review(Reason, [inputs_relied_on(Pairs)|Rest]), []),
    Rest == [],
    Extended = [inputs_relied_on(Pairs), provenance(Reason, [cite(eu_dir_2022_2555_art_23_3_b)])],
    Extended = [inputs_relied_on(ReadPairs), provenance(Clause, Citations)],
    ReadPairs == [severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure],
    Clause == open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)),
    Citations == [cite(eu_dir_2022_2555_art_23_3_b)].
test(timeliness_referral_context_takes_an_optional_provenance_element) :-
    subject_profile(ordinary_provider_delay_unsure, Profile),
    reporting_step_timeliness(Profile, early_warning, 10, needs_legal_review(Reason, [inputs_relied_on(Pairs)|Rest])),
    Rest == [],
    Extended = [inputs_relied_on(Pairs), provenance(Reason, [cite(eu_dir_2022_2555_art_23_4_a)])],
    Extended = [inputs_relied_on(ReadPairs), provenance(Clause, Citations)],
    ReadPairs == [early_warning_without_undue_delay - unsure],
    Clause == open_textured(early_warning_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_a)),
    Citations == [cite(eu_dir_2022_2555_art_23_4_a)].
test(trust_provider_ongoing_gets_six_steps_with_24_hour_notification) :-
    subject_profile(trust_provider_ongoing_prompt, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)), step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]].
test(ordinary_provider_settled_gets_four_steps_with_72_hour_notification) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]].
test(not_significant_has_no_steps) :-
    subject_profile(neither_limb_met, Profile),
    findall(Steps, incident_reporting_steps(Profile, Steps), Answers),
    Answers == [[]].
test(absent_limb_steps_are_indeterminate) :-
    subject_profile(disruption_unanswered, Profile),
    incident_reporting_steps(Profile, indeterminate([severe_operational_disruption_or_financial_loss])).
test(unsure_limb_names_trust_service_key_first) :-
    subject_profile(disruption_unsure_damage_not_met, Profile),
    incident_reporting_steps(Profile, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(unsure_limb_with_complete_facts_refers) :-
    subject_profile(damage_unsure_facts_complete, Profile),
    incident_reporting_steps(Profile, needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure])])).
test(significant_with_ongoing_absent_names_it) :-
    subject_profile(significant_ongoing_unanswered, Profile),
    incident_reporting_steps(Profile, indeterminate([incident_ongoing_at_final_report_due])).
test(significant_with_trust_service_absent_names_it) :-
    subject_profile(trust_service_unanswered, Profile),
    incident_reporting_steps(Profile, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(input_problems_steps) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    incident_reporting_steps(Profile, input_problems([duplicate_key(severe_operational_disruption_or_financial_loss), unknown_key(unrelated_key)])).
test(early_warning_at_24_hours_on_time) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    findall(Result, reporting_step_timeliness(Profile, early_warning, 24, Result), Results),
    Results == [on_time].
test(early_warning_at_25_hours_late) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    findall(Result, reporting_step_timeliness(Profile, early_warning, 25, Result), Results),
    Results == [late(hour_limit)].
test(notification_at_72_hours_on_time) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    findall(Result, reporting_step_timeliness(Profile, incident_notification, 72, Result), Results),
    Results == [on_time].
test(notification_at_73_hours_late) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    findall(Result, reporting_step_timeliness(Profile, incident_notification, 73, Result), Results),
    Results == [late(hour_limit)].
test(trust_provider_notification_at_24_hours_on_time) :-
    subject_profile(trust_provider_ongoing_prompt, Profile),
    reporting_step_timeliness(Profile, incident_notification, 24, on_time).
test(trust_provider_notification_at_25_hours_late) :-
    subject_profile(trust_provider_ongoing_prompt, Profile),
    findall(Result, reporting_step_timeliness(Profile, incident_notification, 25, Result), Results),
    Results == [late(hour_limit)].
test(trust_provider_notification_at_72_hours_late) :-
    subject_profile(trust_provider_ongoing_prompt, Profile),
    reporting_step_timeliness(Profile, incident_notification, 72, late(hour_limit)).
test(delayed_early_warning_inside_limit_is_late) :-
    subject_profile(ordinary_provider_delayed, Profile),
    reporting_step_timeliness(Profile, early_warning, 24, late(without_undue_delay)).
test(delayed_notification_inside_limit_is_late) :-
    subject_profile(ordinary_provider_delayed, Profile),
    reporting_step_timeliness(Profile, incident_notification, 72, late(without_undue_delay)).
test(unsure_early_warning_delay_refers) :-
    subject_profile(ordinary_provider_delay_unsure, Profile),
    reporting_step_timeliness(Profile, early_warning, 10, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(unsure_notification_delay_refers) :-
    subject_profile(ordinary_provider_delay_unsure, Profile),
    reporting_step_timeliness(Profile, incident_notification, 10, needs_legal_review(open_textured(incident_notification_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_b)), [inputs_relied_on([incident_notification_without_undue_delay - unsure])])).
test(unsure_delay_past_the_limit_is_late_at_once) :-
    subject_profile(ordinary_provider_delay_unsure, Profile),
    reporting_step_timeliness(Profile, early_warning, 25, late(hour_limit)).
test(trust_service_unanswered_between_25_and_72_hours_is_asked_for) :-
    subject_profile(trust_service_unanswered, Profile),
    reporting_step_timeliness(Profile, incident_notification, 25, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(trust_service_unanswered_within_24_hours_is_not_read) :-
    subject_profile(trust_service_unanswered, Profile),
    reporting_step_timeliness(Profile, incident_notification, 24, on_time).
test(early_warning_judgement_absent_is_asked_for) :-
    subject_profile(trust_service_unanswered, Profile),
    reporting_step_timeliness(Profile, early_warning, 24, indeterminate([early_warning_without_undue_delay])).
test(bad_step_is_an_input_problem) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    reporting_step_timeliness(Profile, final_report, 10, input_problems([wrong_type(step)])).
test(profile_problems_come_before_argument_problems) :-
    subject_profile(crisp_key_given_unsure, Profile),
    reporting_step_timeliness(Profile, early_warning, -1, input_problems([wrong_type(trust_service_provider_incident_affects_trust_services), wrong_type(hours_elapsed)])).
test(well_formed_profile_has_no_problems) :-
    subject_profile(trust_provider_ongoing_prompt, Profile),
    findall(Problems, nis2_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(duplicate_and_unknown_keys_are_listed_in_order) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    nis2_incident_reporting_input_problems(Profile, [duplicate_key(severe_operational_disruption_or_financial_loss), unknown_key(unrelated_key)]).
test(crisp_key_given_unsure_is_wrong_type) :-
    subject_profile(crisp_key_given_unsure, Profile),
    nis2_incident_reporting_input_problems(Profile, [wrong_type(trust_service_provider_incident_affects_trust_services)]).
test(non_attribute_list_is_wrong_type_profile) :-
    nis2_incident_reporting_input_problems([severe_operational_disruption_or_financial_loss], [wrong_type(profile)]).

test(limb_a_near_miss_is_not_significant, fail) :-
    subject_profile(neither_limb_met, Profile),
    incident_significance(Profile, significant, _).
test(limb_b_near_miss_is_not_significant, fail) :-
    subject_profile(disruption_unsure_damage_not_met, Profile),
    incident_significance(Profile, significant, _).
test(a_final_answer_carries_no_provenance_context, fail) :-
    subject_profile(severe_disruption_met, Profile),
    incident_significance(Profile, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _).
test(early_warning_at_25_hours_not_on_time, fail) :-
    subject_profile(ordinary_provider_settled_prompt, Profile),
    reporting_step_timeliness(Profile, early_warning, 25, on_time).
test(delayed_notification_is_not_on_time, fail) :-
    subject_profile(ordinary_provider_delayed, Profile),
    reporting_step_timeliness(Profile, incident_notification, 72, on_time).

cp_test_names([every_subject_has_an_expectation, every_subject_resolves_to_its_expected_status_once, every_subject_has_a_non_empty_checklist, every_status_is_in_the_status_vocabulary, the_decision_is_resolvable, limb_a_met_cites_point_a, limb_a_near_miss_is_not_significant_citing_both, limb_b_met_beside_unsure_a_cites_point_b, limb_b_near_miss_refers_the_unsure_limb, an_absent_limb_is_named_before_an_unsure_one, facade_status_projects_the_verdict, facade_verdict_carries_the_citations, checklist_rows_for_limb_a, significance_referral_context_takes_an_optional_provenance_element, timeliness_referral_context_takes_an_optional_provenance_element, trust_provider_ongoing_gets_six_steps_with_24_hour_notification, ordinary_provider_settled_gets_four_steps_with_72_hour_notification, not_significant_has_no_steps, absent_limb_steps_are_indeterminate, unsure_limb_names_trust_service_key_first, unsure_limb_with_complete_facts_refers, significant_with_ongoing_absent_names_it, significant_with_trust_service_absent_names_it, input_problems_steps, early_warning_at_24_hours_on_time, early_warning_at_25_hours_late, notification_at_72_hours_on_time, notification_at_73_hours_late, trust_provider_notification_at_24_hours_on_time, trust_provider_notification_at_25_hours_late, trust_provider_notification_at_72_hours_late, delayed_early_warning_inside_limit_is_late, delayed_notification_inside_limit_is_late, unsure_early_warning_delay_refers, unsure_notification_delay_refers, unsure_delay_past_the_limit_is_late_at_once, trust_service_unanswered_between_25_and_72_hours_is_asked_for, trust_service_unanswered_within_24_hours_is_not_read, early_warning_judgement_absent_is_asked_for, bad_step_is_an_input_problem, profile_problems_come_before_argument_problems, well_formed_profile_has_no_problems, duplicate_and_unknown_keys_are_listed_in_order, crisp_key_given_unsure_is_wrong_type, non_attribute_list_is_wrong_type_profile]).
cp_test_fail_names([limb_a_near_miss_is_not_significant, limb_b_near_miss_is_not_significant, a_final_answer_carries_no_provenance_context, early_warning_at_25_hours_not_on_time, delayed_notification_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
