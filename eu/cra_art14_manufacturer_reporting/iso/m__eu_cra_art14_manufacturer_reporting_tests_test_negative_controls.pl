% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_status_values/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

test(the_status_table_holds_both_final_atoms) :-
    cra_art14_manufacturer_reporting_status_values(StatusValues),
    StatusValues == [severe, not_severe].
test(protection_limb_true_is_severe) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(protection_limb_false_near_miss_is_not_severe) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, not_severe).
test(malicious_code_limb_true_is_severe) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(malicious_code_unsure_near_miss_refers) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_false_malicious_code_unsure, Profile),
    cra_art14_manufacturer_reporting_status(Profile, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, _Citation), _Context)).
test(no_judgement_names_the_protection_limb) :-
    severe_incident_status([], indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(protection_false_near_miss_names_malicious_code) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], indeterminate([leads_to_malicious_code_in_product_or_user_systems]), []).
test(unsure_protection_beside_false_refers) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), _Context)).
test(unsure_protection_beside_true_near_miss_is_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(both_limbs_false_is_not_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(awareness_the_day_before_application_has_no_step) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), []).
test(awareness_on_application_day_near_miss_has_four_steps) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), [_, _, _, _]).
test(awareness_before_application_reads_no_severity_key) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2025, 12, 31), []).
test(vulnerability_with_no_key_has_its_steps) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 3, 1), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), _, _, _]).
test(incident_with_no_key_near_miss_is_indeterminate) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2027, 3, 1), indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])).
test(severe_incident_has_the_final_report_one_month_after_notification) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), [_, _, step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), _]).
test(not_severe_incident_near_miss_has_no_step) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), []).
test(incident_unsure_beside_missing_is_indeterminate) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_missing, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), indeterminate([leads_to_malicious_code_in_product_or_user_systems])).
test(incident_unsure_beside_false_near_miss_refers) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])])).
test(early_warning_at_25_hours_is_late_whatever_the_judgement) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 25, late(hour_limit)).
test(early_warning_at_24_hours_near_miss_is_on_time) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, on_time).
test(notification_at_73_hours_is_late_even_if_unsure) :-
    cra_art14_manufacturer_reporting_profile_for(notification_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 73, late(hour_limit)).
test(notification_at_72_hours_near_miss_refers) :-
    cra_art14_manufacturer_reporting_profile_for(notification_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 72, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_b)), _Context)).
test(notification_at_25_hours_is_within_its_own_limit) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 25, on_time).
test(early_warning_without_delay_is_on_time) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 5, on_time).
test(early_warning_with_delay_near_miss_is_late) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 5, late(without_undue_delay)).
test(notification_with_only_early_warning_key_is_indeterminate) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 30, indeterminate([notification_without_undue_delay])).
test(notification_key_given_near_miss_is_on_time) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 30, on_time).
test(vulnerability_referral_cites_paragraph_2) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 2, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_a)), _Context)).
test(timeliness_reads_no_severity_key) :-
    manufacturer_reporting_step_timeliness([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(early_warning_without_undue_delay, true)], incident_impacting_product_security, early_warning, 5, on_time).
test(a_repeated_key_is_a_duplicate_key_only) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, yes)], [duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)]).
test(a_single_key_near_miss_has_no_problem) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], []).
test(a_problem_profile_gets_its_input_problems) :-
    manufacturer_reporting_steps([attribute(colour, red)], actively_exploited_vulnerability, date(2027, 3, 1), input_problems([unknown_key(colour)])).

test(protection_limb_false_near_miss_is_not_severe_as_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(malicious_code_unsure_near_miss_is_not_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_false_malicious_code_unsure, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(protection_false_near_miss_does_not_name_protection, fail) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), _Citations).
test(unsure_protection_beside_true_near_miss_does_not_refer, fail) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], needs_legal_review(_Reason, _Context), _Citations).
test(malicious_code_true_near_miss_is_not_not_severe, fail) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], not_severe, _Citations).
test(awareness_on_application_day_near_miss_has_steps_not_none, fail) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), []).
test(incident_with_no_key_near_miss_has_no_list_of_steps, fail) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2027, 3, 1), [_|_]).
test(not_severe_incident_near_miss_has_no_step_list, fail) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), [_|_]).
test(incident_unsure_beside_false_near_miss_is_not_indeterminate, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 3, 1), indeterminate(_Keys)).
test(early_warning_at_24_hours_near_miss_is_not_late_by_hours, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, late(hour_limit)).
test(notification_at_72_hours_near_miss_is_not_late_by_hours, fail) :-
    cra_art14_manufacturer_reporting_profile_for(notification_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 72, late(hour_limit)).
test(early_warning_with_delay_near_miss_is_not_on_time, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 5, on_time).
test(notification_key_given_near_miss_is_not_indeterminate, fail) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 30, indeterminate(_Keys)).
test(incident_referral_near_miss_does_not_cite_paragraph_2, fail) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 2, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_a)), _Context)).
test(a_repeated_key_is_not_also_wrong_type, fail) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, yes)], [duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions), wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]).
test(a_problem_profile_gets_no_severity_verdict, fail) :-
    cra_art14_manufacturer_reporting_profile_for(wrong_type_protection_value, Profile),
    severe_incident_status(Profile, severe, _Citations).
test(a_problem_profile_gets_no_steps, fail) :-
    manufacturer_reporting_steps([attribute(colour, red)], actively_exploited_vulnerability, date(2027, 3, 1), [_|_]).

cp_test_names([the_status_table_holds_both_final_atoms, protection_limb_true_is_severe, protection_limb_false_near_miss_is_not_severe, malicious_code_limb_true_is_severe, malicious_code_unsure_near_miss_refers, no_judgement_names_the_protection_limb, protection_false_near_miss_names_malicious_code, unsure_protection_beside_false_refers, unsure_protection_beside_true_near_miss_is_severe, both_limbs_false_is_not_severe, awareness_the_day_before_application_has_no_step, awareness_on_application_day_near_miss_has_four_steps, awareness_before_application_reads_no_severity_key, vulnerability_with_no_key_has_its_steps, incident_with_no_key_near_miss_is_indeterminate, severe_incident_has_the_final_report_one_month_after_notification, not_severe_incident_near_miss_has_no_step, incident_unsure_beside_missing_is_indeterminate, incident_unsure_beside_false_near_miss_refers, early_warning_at_25_hours_is_late_whatever_the_judgement, early_warning_at_24_hours_near_miss_is_on_time, notification_at_73_hours_is_late_even_if_unsure, notification_at_72_hours_near_miss_refers, notification_at_25_hours_is_within_its_own_limit, early_warning_without_delay_is_on_time, early_warning_with_delay_near_miss_is_late, notification_with_only_early_warning_key_is_indeterminate, notification_key_given_near_miss_is_on_time, vulnerability_referral_cites_paragraph_2, timeliness_reads_no_severity_key, a_repeated_key_is_a_duplicate_key_only, a_single_key_near_miss_has_no_problem, a_problem_profile_gets_its_input_problems]).
cp_test_fail_names([protection_limb_false_near_miss_is_not_severe_as_severe, malicious_code_unsure_near_miss_is_not_severe, protection_false_near_miss_does_not_name_protection, unsure_protection_beside_true_near_miss_does_not_refer, malicious_code_true_near_miss_is_not_not_severe, awareness_on_application_day_near_miss_has_steps_not_none, incident_with_no_key_near_miss_has_no_list_of_steps, not_severe_incident_near_miss_has_no_step_list, incident_unsure_beside_false_near_miss_is_not_indeterminate, early_warning_at_24_hours_near_miss_is_not_late_by_hours, notification_at_72_hours_near_miss_is_not_late_by_hours, early_warning_with_delay_near_miss_is_not_on_time, notification_key_given_near_miss_is_not_indeterminate, incident_referral_near_miss_does_not_cite_paragraph_2, a_repeated_key_is_not_also_wrong_type, a_problem_profile_gets_no_severity_verdict, a_problem_profile_gets_no_steps]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
