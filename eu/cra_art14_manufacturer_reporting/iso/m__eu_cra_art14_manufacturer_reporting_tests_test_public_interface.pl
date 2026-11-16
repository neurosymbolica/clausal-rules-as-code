% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, decide_cra_art14_manufacturer_reporting/2, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status_values/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_what_if/4]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_subject/1, cra_art14_manufacturer_reporting_profile_for/2, cra_art14_manufacturer_reporting_assess/2]).

vulnerability_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

incident_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

subject_verdicts(Subject, Verdicts) :-
    findall(Verdict, cra_art14_manufacturer_reporting_assess(Subject, Verdict), Verdicts).

subject_steps(Subject, Event, AwarenessDate, Answers) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile),
    findall(Steps, manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps), Answers).

subject_timeliness(Subject, Event, Step, HoursElapsed, Results) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile),
    findall(Result, manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result), Results).

subject_has_checklist(Subject) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile),
    cra_art14_manufacturer_reporting_checklist(Profile, [_FirstItem|_OtherItems]).

subject_resolves_once(Subject) :-
    subject_verdicts(Subject, Verdicts),
    length(Verdicts, 1).

test(every_subject_is_registered_once) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    length(Subjects, 18),
    sort(Subjects, Sorted),
    length(Sorted, 18).
test(every_subject_resolves_exactly_once) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    maplist(subject_resolves_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    maplist(subject_has_checklist, Subjects).
test(protection_limb_subject_is_severe) :-
    subject_verdicts(severe_by_protection_limb, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(severe, [cite(eu_reg_2024_2847_art_14_5)])].
test(malicious_code_limb_subject_is_severe) :-
    subject_verdicts(severe_by_malicious_code_limb, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(severe, [cite(eu_reg_2024_2847_art_14_5)])].
test(both_limbs_false_control_is_not_severe) :-
    subject_verdicts(not_severe_both_limbs_false, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)])].
test(final_statuses_are_in_the_vocabulary) :-
    cra_art14_manufacturer_reporting_status_values(StatusValues),
    cra_art14_manufacturer_reporting_assess(severe_by_protection_limb, cra_art14_manufacturer_reporting_verdict(SevereStatus, _)),
    cra_art14_manufacturer_reporting_assess(not_severe_both_limbs_false, cra_art14_manufacturer_reporting_verdict(NotSevereStatus, _)),
    member(SevereStatus, StatusValues),
    member(NotSevereStatus, StatusValues).
test(contract_query_matches_the_facade) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    findall(Status - Citations, severe_incident_status(Profile, Status, Citations), Answers),
    Answers == [severe - [cite(eu_reg_2024_2847_art_14_5)]].
test(status_projection_reads_the_verdict) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, not_severe).
test(no_key_names_the_protection_limb) :-
    subject_verdicts(severity_both_limbs_missing, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), [])].
test(unsure_protection_beside_absent_code_names_the_code_limb) :-
    subject_verdicts(severity_protection_unsure_malicious_code_missing, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(indeterminate([leads_to_malicious_code_in_product_or_user_systems]), [])].
test(absent_protection_beside_false_code_names_protection) :-
    subject_verdicts(severity_protection_missing_malicious_code_false, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), [])].
test(unsure_protection_refers_on_point_a) :-
    subject_verdicts(severity_protection_unsure_malicious_code_false, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])]), [])].
test(unsure_code_refers_on_point_b) :-
    subject_verdicts(severity_protection_false_malicious_code_unsure, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])]), [])].
test(referral_context_carries_no_provenance_item) :-
    subject_verdicts(severity_protection_unsure_malicious_code_false, [cra_art14_manufacturer_reporting_verdict(needs_legal_review(_Reason, Context), [])]),
    Context = [inputs_relied_on(_Pairs)].
test(referral_context_accepts_an_appended_provenance_item) :-
    subject_verdicts(severity_protection_unsure_malicious_code_false, [cra_art14_manufacturer_reporting_verdict(needs_legal_review(_Reason, Context), [])]),
    append(Context, [provenance(severe_incident_status, [cite(eu_reg_2024_2847_art_14_5_a)])], Extended),
    Extended = [inputs_relied_on(Pairs), provenance(Clause, Citations)],
    Pairs == [affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false],
    Clause == severe_incident_status,
    Citations == [cite(eu_reg_2024_2847_art_14_5_a)].
test(duplicate_key_subject_has_input_problems) :-
    subject_verdicts(duplicate_protection_key, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)]), [])].
test(wrong_type_subject_has_input_problems) :-
    subject_verdicts(wrong_type_protection_value, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]), [])].
test(unknown_key_subject_has_input_problems) :-
    subject_verdicts(unknown_extra_key, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(input_problems([unknown_key(severity_score)]), [])].
test(non_attribute_list_subject_has_input_problems) :-
    subject_verdicts(not_an_attribute_list, Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(input_problems([wrong_type(profile)]), [])].
test(well_formed_profile_has_no_problem) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(problems_follow_the_contract_key_order) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(colour, red), attribute(leads_to_malicious_code_in_product_or_user_systems, maybe), attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], Problems), Answers),
    Answers == [[duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions), wrong_type(leads_to_malicious_code_in_product_or_user_systems), unknown_key(colour)]].
test(non_atom_key_is_unknown_as_given) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(7, true)], [unknown_key(7)]).
test(unbound_value_is_wrong_type) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(notification_without_undue_delay, _Value)], Problems), Answers),
    Answers == [[wrong_type(notification_without_undue_delay)]].
test(unbound_profile_is_wrong_type) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(absent_key_is_not_a_problem) :-
    cra_art14_manufacturer_reporting_input_problems([], []).
test(vulnerability_on_application_day_has_four_steps) :-
    vulnerability_steps(Expected),
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2026, 9, 11), Answers),
    Answers == [Expected].
test(vulnerability_day_before_application_has_no_step) :-
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2026, 9, 10), Answers),
    Answers == [[]].
test(vulnerability_at_year_end_has_four_steps) :-
    vulnerability_steps(Expected),
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2026, 12, 31), Answers),
    Answers == [Expected].
test(vulnerability_year_before_has_no_step) :-
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2025, 12, 31), Answers),
    Answers == [[]].
test(severe_incident_on_application_day_has_four_steps) :-
    incident_steps(Expected),
    subject_steps(severe_by_protection_limb, incident_impacting_product_security, date(2026, 9, 11), Answers),
    Answers == [Expected].
test(severe_incident_day_before_application_has_no_step) :-
    subject_steps(severe_by_protection_limb, incident_impacting_product_security, date(2026, 9, 10), Answers),
    Answers == [[]].
test(malicious_code_incident_has_four_steps) :-
    incident_steps(Expected),
    subject_steps(severe_by_malicious_code_limb, incident_impacting_product_security, date(2027, 1, 5), Answers),
    Answers == [Expected].
test(not_severe_incident_has_no_step) :-
    subject_steps(not_severe_both_limbs_false, incident_impacting_product_security, date(2027, 1, 5), Answers),
    Answers == [[]].
test(not_severe_profile_still_has_vulnerability_steps) :-
    vulnerability_steps(Expected),
    subject_steps(not_severe_both_limbs_false, actively_exploited_vulnerability, date(2027, 1, 5), Answers),
    Answers == [Expected].
test(incident_with_missing_code_limb_is_indeterminate) :-
    subject_steps(severity_protection_unsure_malicious_code_missing, incident_impacting_product_security, date(2027, 1, 5), Answers),
    Answers == [indeterminate([leads_to_malicious_code_in_product_or_user_systems])].
test(incident_referral_is_copied_unchanged) :-
    subject_steps(severity_protection_false_malicious_code_unsure, incident_impacting_product_security, date(2027, 1, 5), Answers),
    Answers == [needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])].
test(february_29_in_a_common_year_is_wrong) :-
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2027, 2, 29), Answers),
    Answers == [input_problems([wrong_type(awareness_date)])].
test(february_29_in_a_leap_year_is_a_day) :-
    vulnerability_steps(Expected),
    subject_steps(severity_both_limbs_missing, actively_exploited_vulnerability, date(2028, 2, 29), Answers),
    Answers == [Expected].
test(unbound_event_is_wrong_type) :-
    findall(Steps, manufacturer_reporting_steps([], _Event, date(2026, 9, 11), Steps), Answers),
    Answers == [input_problems([wrong_type(event)])].
test(argument_problems_follow_profile_problems) :-
    subject_steps(not_an_attribute_list, breach, date(2027, 13, 1), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(event), wrong_type(awareness_date)])].
test(duplicate_key_refuses_the_steps) :-
    subject_steps(duplicate_protection_key, actively_exploited_vulnerability, date(2027, 1, 5), Answers),
    Answers == [input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)])].
test(early_warning_at_24_hours_without_delay_is_on_time) :-
    subject_timeliness(early_warning_without_delay, actively_exploited_vulnerability, early_warning, 24, Results),
    Results == [on_time].
test(early_warning_at_25_hours_is_late_by_the_hour_limit) :-
    subject_timeliness(early_warning_without_delay, actively_exploited_vulnerability, early_warning, 25, Results),
    Results == [late(hour_limit)].
test(early_warning_at_zero_hours_is_on_time) :-
    subject_timeliness(early_warning_without_delay, incident_impacting_product_security, early_warning, 0, Results),
    Results == [on_time].
test(early_warning_with_undue_delay_is_late) :-
    subject_timeliness(early_warning_with_delay, incident_impacting_product_security, early_warning, 24, Results),
    Results == [late(without_undue_delay)].
test(unsure_vulnerability_early_warning_refers_on_point_2_a) :-
    subject_timeliness(early_warning_unsure, actively_exploited_vulnerability, early_warning, 24, Results),
    Results == [needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])].
test(unsure_incident_early_warning_refers_on_point_4_a) :-
    subject_timeliness(early_warning_unsure, incident_impacting_product_security, early_warning, 1, Results),
    Results == [needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])].
test(unsure_early_warning_beyond_the_limit_is_late) :-
    subject_timeliness(early_warning_unsure, actively_exploited_vulnerability, early_warning, 25, Results),
    Results == [late(hour_limit)].
test(notification_at_72_hours_without_delay_is_on_time) :-
    subject_timeliness(notification_without_delay, actively_exploited_vulnerability, notification, 72, Results),
    Results == [on_time].
test(notification_at_73_hours_is_late_by_the_hour_limit) :-
    subject_timeliness(notification_without_delay, actively_exploited_vulnerability, notification, 73, Results),
    Results == [late(hour_limit)].
test(notification_with_undue_delay_is_late) :-
    subject_timeliness(notification_with_delay, incident_impacting_product_security, notification, 72, Results),
    Results == [late(without_undue_delay)].
test(unsure_vulnerability_notification_refers_on_point_2_b) :-
    subject_timeliness(notification_unsure, actively_exploited_vulnerability, notification, 72, Results),
    Results == [needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])].
test(unsure_incident_notification_refers_on_point_4_b) :-
    subject_timeliness(notification_unsure, incident_impacting_product_security, notification, 10, Results),
    Results == [needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])].
test(early_warning_key_does_not_answer_the_notification) :-
    subject_timeliness(early_warning_without_delay, actively_exploited_vulnerability, notification, 30, Results),
    Results == [indeterminate([notification_without_undue_delay])].
test(notification_key_does_not_answer_the_early_warning) :-
    subject_timeliness(notification_without_delay, actively_exploited_vulnerability, early_warning, 20, Results),
    Results == [indeterminate([early_warning_without_undue_delay])].
test(bad_step_and_negative_hours_are_problems) :-
    subject_timeliness(severity_both_limbs_missing, actively_exploited_vulnerability, final_report, -1, Results),
    Results == [input_problems([wrong_type(step), wrong_type(hours_elapsed)])].
test(unbound_hours_are_wrong_type) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, _HoursElapsed, Result), Results),
    Results == [input_problems([wrong_type(hours_elapsed)])].
test(timeliness_problems_follow_profile_problems) :-
    subject_timeliness(not_an_attribute_list, breach, early_warning, 5, Results),
    Results == [input_problems([wrong_type(profile), wrong_type(event)])].
test(checklist_has_one_cited_row_per_limb) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_checklist(Profile, [item(severity_protection_of_data_or_functions, met, cite(eu_reg_2024_2847_art_14_5_a)), item(severity_malicious_code, unknown([leads_to_malicious_code_in_product_or_user_systems]), cite(eu_reg_2024_2847_art_14_5_b))]).
test(decision_is_resolvable_on_a_fixture) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_decision_resolvable(Profile).
test(what_if_protection_true_flips_not_severe_to_severe) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Status, cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, Status), Statuses),
    Statuses == [severe].
test(what_if_protection_false_leaves_the_code_limb_missing) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, false, indeterminate([leads_to_malicious_code_in_product_or_user_systems])).
test(what_if_bad_value_gives_input_problems) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, yes, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)])).
test(what_if_repairs_a_duplicate_key) :-
    cra_art14_manufacturer_reporting_profile_for(duplicate_protection_key, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, severe).
test(what_if_on_a_non_attribute_list_keeps_the_problem) :-
    cra_art14_manufacturer_reporting_profile_for(not_an_attribute_list, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, input_problems([wrong_type(profile)])).
test(decide_and_assess_agree) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    decide_cra_art14_manufacturer_reporting(Profile, Verdict),
    cra_art14_manufacturer_reporting_assess(severe_by_malicious_code_limb, Verdict).

test(protection_limb_subject_is_not_not_severe, fail) :-
    cra_art14_manufacturer_reporting_assess(severe_by_protection_limb, cra_art14_manufacturer_reporting_verdict(not_severe, _)).
test(both_limbs_false_control_is_not_severe_as_severe, fail) :-
    cra_art14_manufacturer_reporting_assess(not_severe_both_limbs_false, cra_art14_manufacturer_reporting_verdict(severe, _)).
test(unsure_protection_beside_absent_code_does_not_refer, fail) :-
    cra_art14_manufacturer_reporting_assess(severity_protection_unsure_malicious_code_missing, cra_art14_manufacturer_reporting_verdict(needs_legal_review(_, _), _)).
test(unsure_code_is_not_not_severe, fail) :-
    cra_art14_manufacturer_reporting_assess(severity_protection_false_malicious_code_unsure, cra_art14_manufacturer_reporting_verdict(not_severe, _)).
test(referral_context_carries_no_provenance_item_as_second, fail) :-
    subject_verdicts(severity_protection_unsure_malicious_code_false, [cra_art14_manufacturer_reporting_verdict(needs_legal_review(_Reason, Context), [])]),
    Context = [inputs_relied_on(_Pairs), provenance(_Clause, _Citations)].
test(duplicate_key_subject_is_not_severe_as_severe, fail) :-
    cra_art14_manufacturer_reporting_assess(duplicate_protection_key, cra_art14_manufacturer_reporting_verdict(severe, _)).
test(unknown_key_subject_is_not_not_severe, fail) :-
    cra_art14_manufacturer_reporting_assess(unknown_extra_key, cra_art14_manufacturer_reporting_verdict(not_severe, _)).
test(early_warning_at_25_hours_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 25, on_time).
test(early_warning_with_undue_delay_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 24, on_time).
test(notification_at_73_hours_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 73, on_time).

cp_test_names([every_subject_is_registered_once, every_subject_resolves_exactly_once, every_subject_has_a_non_empty_checklist, protection_limb_subject_is_severe, malicious_code_limb_subject_is_severe, both_limbs_false_control_is_not_severe, final_statuses_are_in_the_vocabulary, contract_query_matches_the_facade, status_projection_reads_the_verdict, no_key_names_the_protection_limb, unsure_protection_beside_absent_code_names_the_code_limb, absent_protection_beside_false_code_names_protection, unsure_protection_refers_on_point_a, unsure_code_refers_on_point_b, referral_context_carries_no_provenance_item, referral_context_accepts_an_appended_provenance_item, duplicate_key_subject_has_input_problems, wrong_type_subject_has_input_problems, unknown_key_subject_has_input_problems, non_attribute_list_subject_has_input_problems, well_formed_profile_has_no_problem, problems_follow_the_contract_key_order, non_atom_key_is_unknown_as_given, unbound_value_is_wrong_type, unbound_profile_is_wrong_type, absent_key_is_not_a_problem, vulnerability_on_application_day_has_four_steps, vulnerability_day_before_application_has_no_step, vulnerability_at_year_end_has_four_steps, vulnerability_year_before_has_no_step, severe_incident_on_application_day_has_four_steps, severe_incident_day_before_application_has_no_step, malicious_code_incident_has_four_steps, not_severe_incident_has_no_step, not_severe_profile_still_has_vulnerability_steps, incident_with_missing_code_limb_is_indeterminate, incident_referral_is_copied_unchanged, february_29_in_a_common_year_is_wrong, february_29_in_a_leap_year_is_a_day, unbound_event_is_wrong_type, argument_problems_follow_profile_problems, duplicate_key_refuses_the_steps, early_warning_at_24_hours_without_delay_is_on_time, early_warning_at_25_hours_is_late_by_the_hour_limit, early_warning_at_zero_hours_is_on_time, early_warning_with_undue_delay_is_late, unsure_vulnerability_early_warning_refers_on_point_2_a, unsure_incident_early_warning_refers_on_point_4_a, unsure_early_warning_beyond_the_limit_is_late, notification_at_72_hours_without_delay_is_on_time, notification_at_73_hours_is_late_by_the_hour_limit, notification_with_undue_delay_is_late, unsure_vulnerability_notification_refers_on_point_2_b, unsure_incident_notification_refers_on_point_4_b, early_warning_key_does_not_answer_the_notification, notification_key_does_not_answer_the_early_warning, bad_step_and_negative_hours_are_problems, unbound_hours_are_wrong_type, timeliness_problems_follow_profile_problems, checklist_has_one_cited_row_per_limb, decision_is_resolvable_on_a_fixture, what_if_protection_true_flips_not_severe_to_severe, what_if_protection_false_leaves_the_code_limb_missing, what_if_bad_value_gives_input_problems, what_if_repairs_a_duplicate_key, what_if_on_a_non_attribute_list_keeps_the_problem, decide_and_assess_agree]).
cp_test_fail_names([protection_limb_subject_is_not_not_severe, both_limbs_false_control_is_not_severe_as_severe, unsure_protection_beside_absent_code_does_not_refer, unsure_code_is_not_not_severe, referral_context_carries_no_provenance_item_as_second, duplicate_key_subject_is_not_severe_as_severe, unknown_key_subject_is_not_not_severe, early_warning_at_25_hours_is_not_on_time, early_warning_with_undue_delay_is_not_on_time, notification_at_73_hours_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
