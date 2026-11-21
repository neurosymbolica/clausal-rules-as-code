% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, cra_art14_manufacturer_reporting_status_values/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

expected_vulnerability_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

expected_incident_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

fixture(Subject, Profile) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile).

test(the_status_table_holds_both_severity_atoms) :-
    cra_art14_manufacturer_reporting_status_values(StatusValues),
    StatusValues == [severe, not_severe].
test(s0_positive_duplicate_key_is_refused) :-
    fixture(duplicate_key_problem, Profile),
    severe_incident_status(Profile, input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(s0_near_miss_single_key_is_judged) :-
    fixture(severe_by_protection_limb, Profile),
    severe_incident_status(Profile, severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(s0_positive_wrong_value_is_refused) :-
    fixture(wrong_type_problem, Profile),
    severe_incident_status(Profile, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(s1_positive_protection_limb_true_is_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(s1_near_miss_protection_limb_false_is_not_severe) :-
    fixture(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, not_severe, _Citations).
test(s1_positive_malicious_code_limb_true_is_severe) :-
    fixture(severe_by_malicious_code_limb, Profile),
    severe_incident_status(Profile, severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(s1_near_miss_malicious_code_limb_unsure_refers) :-
    fixture(malicious_code_limb_unsure_referral, Profile),
    severe_incident_status(Profile, needs_legal_review(_Reason, _Context), []).
test(s2_positive_absent_protection_limb_is_named) :-
    fixture(protection_limb_missing, Profile),
    severe_incident_status(Profile, indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(s2_positive_absent_code_limb_beside_unsure_is_named) :-
    fixture(malicious_code_limb_missing, Profile),
    severe_incident_status(Profile, indeterminate([leads_to_malicious_code_in_product_or_user_systems]), []).
test(s2_near_miss_given_code_limb_refers_on_the_unsure_limb) :-
    fixture(protection_limb_unsure_referral, Profile),
    severe_incident_status(Profile, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])]), []).
test(s3_positive_unsure_code_limb_refers) :-
    fixture(malicious_code_limb_unsure_referral, Profile),
    severe_incident_status(Profile, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])]), []).
test(s4_positive_both_false_is_not_severe_citing_both_limbs) :-
    fixture(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(r1_positive_before_application_lists_no_step) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), []).
test(r1_near_miss_application_day_lists_the_steps) :-
    expected_vulnerability_steps(Expected),
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), Expected).
test(r1_positive_incident_before_application_reads_no_key) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2025, 12, 31), []).
test(r1_near_miss_incident_after_application_reads_the_key) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2026, 9, 11), indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])).
test(r2_positive_vulnerability_lists_steps_with_both_limbs_false) :-
    expected_vulnerability_steps(Expected),
    fixture(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, actively_exploited_vulnerability, date(2027, 3, 1), Expected).
test(r2_near_miss_incident_with_both_limbs_false_lists_no_step) :-
    fixture(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), []).
test(r3_positive_severe_incident_lists_incident_steps) :-
    expected_incident_steps(Expected),
    fixture(severe_by_protection_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2026, 9, 11), Expected).
test(r3_positive_open_severity_is_passed_on) :-
    fixture(malicious_code_limb_unsure_referral, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 1), needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])).
test(t1_positive_early_warning_after_24_hours_is_late) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 25, late(hour_limit)).
test(t1_near_miss_early_warning_at_24_hours_is_on_time) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, on_time).
test(t1_positive_notification_after_72_hours_is_late) :-
    fixture(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 73, late(hour_limit)).
test(t1_near_miss_notification_at_72_hours_is_on_time) :-
    fixture(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 72, on_time).
test(t2_positive_with_undue_delay_is_late) :-
    fixture(early_warning_with_undue_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 10, late(without_undue_delay)).
test(t2_positive_unsure_undue_delay_refers_with_the_vulnerability_citation) :-
    fixture(notification_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 50, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])).
test(t2_near_miss_unsure_undue_delay_refers_with_the_incident_citation) :-
    fixture(notification_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 50, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])).
test(t2_positive_absent_key_of_the_step_is_named) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 10, indeterminate([notification_without_undue_delay])).
test(t2_near_miss_the_step_with_its_key_is_on_time) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 10, on_time).
test(t2_positive_severity_keys_are_never_read) :-
    manufacturer_reporting_step_timeliness([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(early_warning_without_undue_delay, true)], incident_impacting_product_security, early_warning, 5, on_time).
test(arguments_positive_bad_step_is_refused) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, final_report, 3, input_problems([wrong_type(step)])).
test(arguments_near_miss_good_step_is_judged) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 3, indeterminate([early_warning_without_undue_delay])).
test(arguments_positive_bad_event_is_refused) :-
    manufacturer_reporting_steps([], data_breach, date(2027, 1, 1), input_problems([wrong_type(event)])).
test(arguments_near_miss_good_event_is_judged) :-
    expected_vulnerability_steps(Expected),
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 1, 1), Expected).

test(s0_near_miss_single_key_is_not_refused, fail) :-
    fixture(severe_by_protection_limb, Profile),
    severe_incident_status(Profile, input_problems(_Problems), _Citations).
test(s0_wrong_value_is_not_judged_severe, fail) :-
    fixture(wrong_type_problem, Profile),
    severe_incident_status(Profile, severe, _Citations).
test(s1_near_miss_protection_limb_false_is_never_severe, fail) :-
    fixture(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, severe, _Citations).
test(s1_near_miss_malicious_code_limb_unsure_is_not_severe, fail) :-
    fixture(malicious_code_limb_unsure_referral, Profile),
    severe_incident_status(Profile, severe, _Citations).
test(s2_near_miss_given_protection_limb_is_not_indeterminate, fail) :-
    fixture(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, indeterminate(_MissingKeys), _Citations).
test(s2_near_miss_given_code_limb_is_not_indeterminate, fail) :-
    fixture(protection_limb_unsure_referral, Profile),
    severe_incident_status(Profile, indeterminate(_MissingKeys), _Citations).
test(s3_near_miss_false_code_limb_does_not_refer, fail) :-
    fixture(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, needs_legal_review(_Reason, _Context), _Citations).
test(s4_near_miss_one_limb_true_is_not_not_severe, fail) :-
    fixture(severe_by_malicious_code_limb, Profile),
    severe_incident_status(Profile, not_severe, _Citations).
test(r1_near_miss_application_day_is_not_empty, fail) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), []).
test(r2_near_miss_incident_does_not_get_the_vulnerability_list, fail) :-
    expected_vulnerability_steps(Expected),
    fixture(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), Expected).
test(r3_near_miss_not_severe_incident_lists_no_incident_step, fail) :-
    expected_incident_steps(Expected),
    fixture(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2026, 9, 11), Expected).
test(r3_near_miss_open_severity_is_not_an_empty_list, fail) :-
    fixture(malicious_code_limb_unsure_referral, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 1), []).
test(t1_near_miss_at_24_hours_is_not_late_by_the_hour_limit, fail) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, late(hour_limit)).
test(t2_near_miss_with_undue_delay_is_not_on_time, fail) :-
    fixture(early_warning_with_undue_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 10, on_time).
test(t2_near_miss_incident_is_not_cited_to_the_vulnerability_point, fail) :-
    fixture(notification_undue_delay_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 50, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), _Context)).
test(t2_near_miss_the_other_step_key_is_not_borrowed, fail) :-
    fixture(early_warning_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 10, on_time).
test(arguments_near_miss_good_step_is_not_refused, fail) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 3, input_problems(_Problems)).

cp_test_names([the_status_table_holds_both_severity_atoms, s0_positive_duplicate_key_is_refused, s0_near_miss_single_key_is_judged, s0_positive_wrong_value_is_refused, s1_positive_protection_limb_true_is_severe, s1_near_miss_protection_limb_false_is_not_severe, s1_positive_malicious_code_limb_true_is_severe, s1_near_miss_malicious_code_limb_unsure_refers, s2_positive_absent_protection_limb_is_named, s2_positive_absent_code_limb_beside_unsure_is_named, s2_near_miss_given_code_limb_refers_on_the_unsure_limb, s3_positive_unsure_code_limb_refers, s4_positive_both_false_is_not_severe_citing_both_limbs, r1_positive_before_application_lists_no_step, r1_near_miss_application_day_lists_the_steps, r1_positive_incident_before_application_reads_no_key, r1_near_miss_incident_after_application_reads_the_key, r2_positive_vulnerability_lists_steps_with_both_limbs_false, r2_near_miss_incident_with_both_limbs_false_lists_no_step, r3_positive_severe_incident_lists_incident_steps, r3_positive_open_severity_is_passed_on, t1_positive_early_warning_after_24_hours_is_late, t1_near_miss_early_warning_at_24_hours_is_on_time, t1_positive_notification_after_72_hours_is_late, t1_near_miss_notification_at_72_hours_is_on_time, t2_positive_with_undue_delay_is_late, t2_positive_unsure_undue_delay_refers_with_the_vulnerability_citation, t2_near_miss_unsure_undue_delay_refers_with_the_incident_citation, t2_positive_absent_key_of_the_step_is_named, t2_near_miss_the_step_with_its_key_is_on_time, t2_positive_severity_keys_are_never_read, arguments_positive_bad_step_is_refused, arguments_near_miss_good_step_is_judged, arguments_positive_bad_event_is_refused, arguments_near_miss_good_event_is_judged]).
cp_test_fail_names([s0_near_miss_single_key_is_not_refused, s0_wrong_value_is_not_judged_severe, s1_near_miss_protection_limb_false_is_never_severe, s1_near_miss_malicious_code_limb_unsure_is_not_severe, s2_near_miss_given_protection_limb_is_not_indeterminate, s2_near_miss_given_code_limb_is_not_indeterminate, s3_near_miss_false_code_limb_does_not_refer, s4_near_miss_one_limb_true_is_not_not_severe, r1_near_miss_application_day_is_not_empty, r2_near_miss_incident_does_not_get_the_vulnerability_list, r3_near_miss_not_severe_incident_lists_no_incident_step, r3_near_miss_open_severity_is_not_an_empty_list, t1_near_miss_at_24_hours_is_not_late_by_the_hour_limit, t2_near_miss_with_undue_delay_is_not_on_time, t2_near_miss_incident_is_not_cited_to_the_vulnerability_point, t2_near_miss_the_other_step_key_is_not_borrowed, arguments_near_miss_good_step_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
