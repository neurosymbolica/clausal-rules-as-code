% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [decide_cra_art14_manufacturer_reporting/2, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status_values/1, severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_subject/1, cra_art14_manufacturer_reporting_profile_for/2, cra_art14_manufacturer_reporting_assess/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_what_if/4]).

subject_answers_once(Subject) :-
    findall(Result, cra_art14_manufacturer_reporting_assess(Subject, Result), Results),
    length(Results, 1).

subject_checklist_is_not_empty(Subject) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile),
    cra_art14_manufacturer_reporting_decision_resolvable(Profile),
    cra_art14_manufacturer_reporting_checklist(Profile, [_FirstItem|_OtherItems]).

subject_status(Subject, Status) :-
    cra_art14_manufacturer_reporting_assess(Subject, cra_art14_manufacturer_reporting_verdict(Status, _Citations)).

subject_citations(Subject, Citations) :-
    cra_art14_manufacturer_reporting_assess(Subject, cra_art14_manufacturer_reporting_verdict(_Status, Citations)).

vulnerability_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

incident_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

test(every_subject_answers_exactly_once) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    length(Subjects, 16),
    maplist(subject_answers_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, cra_art14_manufacturer_reporting_subject(Subject), Subjects),
    maplist(subject_checklist_is_not_empty, Subjects).
test(severe_by_protection_limb_is_severe) :-
    subject_status(severe_by_protection_limb, severe),
    subject_citations(severe_by_protection_limb, [cite(eu_reg_2024_2847_art_14_5)]),
    cra_art14_manufacturer_reporting_status_values(StatusValues),
    member(severe, StatusValues).
test(severe_by_malicious_code_limb_is_severe) :-
    subject_status(severe_by_malicious_code_limb, severe),
    subject_citations(severe_by_malicious_code_limb, [cite(eu_reg_2024_2847_art_14_5)]).
test(not_severe_control_is_not_severe) :-
    subject_status(not_severe_both_limbs_false, not_severe),
    subject_citations(not_severe_both_limbs_false, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(protection_limb_missing_names_limb_a) :-
    subject_status(protection_limb_missing, indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])),
    subject_citations(protection_limb_missing, []).
test(malicious_code_limb_missing_names_limb_b) :-
    subject_status(malicious_code_limb_missing, indeterminate([leads_to_malicious_code_in_product_or_user_systems])),
    subject_citations(malicious_code_limb_missing, []).
test(protection_limb_unsure_refers_to_a_lawyer) :-
    subject_status(protection_limb_unsure_referral, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])])),
    subject_citations(protection_limb_unsure_referral, []).
test(malicious_code_limb_unsure_refers_to_a_lawyer) :-
    subject_status(malicious_code_limb_unsure_referral, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])).
test(provenance_term_holds_a_clause_and_its_citations) :-
    Term = provenance(severity_route, [cite(eu_reg_2024_2847_art_14_5_a)]),
    Term = provenance(Clause, Citations),
    Clause == severity_route,
    Citations == [cite(eu_reg_2024_2847_art_14_5_a)].
test(provenance_may_follow_inputs_relied_on_in_a_context) :-
    subject_status(protection_limb_unsure_referral, needs_legal_review(_Reason, [inputs_relied_on(Pairs)])),
    Context = [inputs_relied_on(Pairs), provenance(severity_route, [cite(eu_reg_2024_2847_art_14_5_a)])],
    Context = [_FirstItem, provenance(Clause, _Citations)],
    Clause == severity_route.
test(duplicate_key_is_refused) :-
    subject_status(duplicate_key_problem, input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)])),
    subject_citations(duplicate_key_problem, []).
test(wrong_type_is_refused) :-
    subject_status(wrong_type_problem, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)])).
test(unknown_key_is_refused) :-
    subject_status(unknown_key_problem, input_problems([unknown_key(product_category)])).
test(well_formed_profile_has_no_problem) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_input_problems(Profile, []).
test(non_list_profile_is_wrong_type) :-
    cra_art14_manufacturer_reporting_input_problems(not_a_profile, [wrong_type(profile)]).
test(unbound_profile_is_wrong_type) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(_Profile, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(status_projection_matches_the_query) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, not_severe),
    severe_incident_status(Profile, not_severe, _Citations),
    decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(not_severe, _VerdictCitations)).
test(what_if_limb_b_true_makes_the_control_severe) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, leads_to_malicious_code_in_product_or_user_systems, true, severe).
test(vulnerability_day_before_application_lists_no_step) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), Steps), Solutions),
    Solutions == [[]].
test(vulnerability_on_application_day_lists_four_steps) :-
    vulnerability_steps(Expected),
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), Steps), Solutions),
    Solutions == [Expected].
test(severe_incident_lists_incident_steps) :-
    incident_steps(Expected),
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    findall(Steps, manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 5), Steps), Solutions),
    Solutions == [Expected].
test(severe_incident_before_application_lists_no_step) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2026, 9, 10), []).
test(not_severe_incident_lists_no_step) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Steps, manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 5), Steps), Solutions),
    Solutions == [[]].
test(missing_severity_key_is_passed_on) :-
    cra_art14_manufacturer_reporting_profile_for(protection_limb_missing, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 5), indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])).
test(unsure_severity_referral_is_passed_on) :-
    cra_art14_manufacturer_reporting_profile_for(malicious_code_limb_unsure_referral, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 5), needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])).
test(vulnerability_reads_no_severity_key) :-
    vulnerability_steps(Expected),
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, actively_exploited_vulnerability, date(2027, 1, 5), Expected).
test(bad_event_and_impossible_date_are_refused) :-
    manufacturer_reporting_steps([], data_breach, date(2027, 2, 29), input_problems([wrong_type(event), wrong_type(awareness_date)])).
test(leap_day_2028_is_a_real_date) :-
    vulnerability_steps(Expected),
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2028, 2, 29), Expected).
test(profile_problem_comes_before_argument_problem) :-
    cra_art14_manufacturer_reporting_profile_for(unknown_key_problem, Profile),
    manufacturer_reporting_steps(Profile, data_breach, date(2027, 1, 5), input_problems([unknown_key(product_category), wrong_type(event)])).
test(early_warning_at_24_hours_is_on_time) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_undue_delay_given, Profile),
    findall(Result, manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, Result), Results),
    Results == [on_time].
test(early_warning_at_25_hours_is_late) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_undue_delay_given, Profile),
    findall(Result, manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 25, Result), Results),
    Results == [late(hour_limit)].
test(notification_at_72_hours_is_on_time) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 72, on_time).
test(notification_at_73_hours_is_late) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 73, late(hour_limit)).
test(late_after_the_limit_even_when_the_key_is_unsure) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 30, late(hour_limit)).
test(early_warning_with_undue_delay_is_late) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_undue_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 20, late(without_undue_delay)).
test(notification_with_undue_delay_is_late) :-
    cra_art14_manufacturer_reporting_profile_for(notification_with_undue_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 72, late(without_undue_delay)).
test(early_warning_unsure_refers_with_vulnerability_citation) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 5, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(early_warning_unsure_refers_with_incident_citation) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 5, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(notification_unsure_refers_with_vulnerability_citation) :-
    cra_art14_manufacturer_reporting_profile_for(notification_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 40, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])).
test(notification_unsure_refers_with_incident_citation) :-
    cra_art14_manufacturer_reporting_profile_for(notification_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 40, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])).
test(the_other_step_key_is_not_read) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 10, indeterminate([notification_without_undue_delay])).
test(timeliness_arguments_are_checked_in_order) :-
    manufacturer_reporting_step_timeliness([], data_breach, final_report, -1, input_problems([wrong_type(event), wrong_type(step), wrong_type(hours_elapsed)])).
test(unbound_hours_is_wrong_type) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, _HoursElapsed, Result), Results),
    Results == [input_problems([wrong_type(hours_elapsed)])].

test(severe_by_protection_limb_is_not_not_severe, fail) :-
    subject_status(severe_by_protection_limb, not_severe).
test(not_severe_control_is_not_severe_as_severe, fail) :-
    subject_status(not_severe_both_limbs_false, severe).
test(malicious_code_limb_missing_does_not_refer, fail) :-
    subject_status(malicious_code_limb_missing, needs_legal_review(_Reason, _Context)).
test(malicious_code_limb_unsure_is_not_not_severe, fail) :-
    subject_status(malicious_code_limb_unsure_referral, not_severe).
test(early_warning_at_25_hours_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 25, on_time).
test(early_warning_with_undue_delay_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_undue_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 20, on_time).

cp_test_names([every_subject_answers_exactly_once, every_subject_has_a_non_empty_checklist, severe_by_protection_limb_is_severe, severe_by_malicious_code_limb_is_severe, not_severe_control_is_not_severe, protection_limb_missing_names_limb_a, malicious_code_limb_missing_names_limb_b, protection_limb_unsure_refers_to_a_lawyer, malicious_code_limb_unsure_refers_to_a_lawyer, provenance_term_holds_a_clause_and_its_citations, provenance_may_follow_inputs_relied_on_in_a_context, duplicate_key_is_refused, wrong_type_is_refused, unknown_key_is_refused, well_formed_profile_has_no_problem, non_list_profile_is_wrong_type, unbound_profile_is_wrong_type, status_projection_matches_the_query, what_if_limb_b_true_makes_the_control_severe, vulnerability_day_before_application_lists_no_step, vulnerability_on_application_day_lists_four_steps, severe_incident_lists_incident_steps, severe_incident_before_application_lists_no_step, not_severe_incident_lists_no_step, missing_severity_key_is_passed_on, unsure_severity_referral_is_passed_on, vulnerability_reads_no_severity_key, bad_event_and_impossible_date_are_refused, leap_day_2028_is_a_real_date, profile_problem_comes_before_argument_problem, early_warning_at_24_hours_is_on_time, early_warning_at_25_hours_is_late, notification_at_72_hours_is_on_time, notification_at_73_hours_is_late, late_after_the_limit_even_when_the_key_is_unsure, early_warning_with_undue_delay_is_late, notification_with_undue_delay_is_late, early_warning_unsure_refers_with_vulnerability_citation, early_warning_unsure_refers_with_incident_citation, notification_unsure_refers_with_vulnerability_citation, notification_unsure_refers_with_incident_citation, the_other_step_key_is_not_read, timeliness_arguments_are_checked_in_order, unbound_hours_is_wrong_type]).
cp_test_fail_names([severe_by_protection_limb_is_not_not_severe, not_severe_control_is_not_severe_as_severe, malicious_code_limb_missing_does_not_refer, malicious_code_limb_unsure_is_not_not_severe, early_warning_at_25_hours_is_not_on_time, early_warning_with_undue_delay_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
