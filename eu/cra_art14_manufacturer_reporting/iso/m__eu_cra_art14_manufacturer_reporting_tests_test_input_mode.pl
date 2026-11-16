% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, cra_art14_manufacturer_reporting_status/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

test(severe_by_protection_holds_with_status_and_citations_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    severe_incident_status(Profile, severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(severe_by_malicious_code_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(not_severe_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    severe_incident_status(Profile, not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(missing_protection_limb_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severity_both_limbs_missing, Profile),
    severe_incident_status(Profile, indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(unsure_beside_missing_names_the_missing_key_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_missing, Profile),
    severe_incident_status(Profile, indeterminate([leads_to_malicious_code_in_product_or_user_systems]), []).
test(missing_protection_beside_false_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_missing_malicious_code_false, Profile),
    severe_incident_status(Profile, indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(referral_on_protection_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_unsure_malicious_code_false, Profile),
    severe_incident_status(Profile, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])]), []).
test(referral_on_malicious_code_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_false_malicious_code_unsure, Profile),
    severe_incident_status(Profile, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])]), []).
test(vulnerability_steps_hold_bound_on_application_day) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).
test(steps_before_application_hold_bound) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), []).
test(severe_incident_steps_hold_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2030, 12, 31), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).
test(not_severe_incident_steps_hold_bound) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 1), []).
test(on_time_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 24, on_time).
test(late_hour_limit_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, notification, 73, late(hour_limit)).
test(late_without_undue_delay_holds_bound) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_with_delay, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 1, late(without_undue_delay)).
test(early_warning_referral_on_vulnerability_cites_point_a_of_paragraph_2) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, early_warning, 20, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(early_warning_referral_on_incident_cites_point_a_of_paragraph_4) :-
    cra_art14_manufacturer_reporting_profile_for(early_warning_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, incident_impacting_product_security, early_warning, 20, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(notification_referral_on_vulnerability_cites_point_b_of_paragraph_2) :-
    cra_art14_manufacturer_reporting_profile_for(notification_unsure, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 50, needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])])).
test(unbound_profile_is_wrong_type) :-
    findall(Status - Citations, severe_incident_status(_UnboundProfile, Status, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(partial_list_profile_is_wrong_type) :-
    findall(Status - Citations, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)|_Rest], Status, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(unbound_element_profile_is_wrong_type) :-
    findall(Status - Citations, severe_incident_status([_Element], Status, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(unbound_value_is_wrong_type) :-
    findall(Status - Citations, severe_incident_status([attribute(early_warning_without_undue_delay, _Unbound)], Status, Citations), Answers),
    Answers == [input_problems([wrong_type(early_warning_without_undue_delay)]) - []].
test(non_atom_key_is_an_unknown_key) :-
    severe_incident_status([attribute(7, true)], input_problems([unknown_key(7)]), []).
test(string_value_is_wrong_type) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, "true")], input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(duplicate_key_fixture_is_a_duplicate_key) :-
    cra_art14_manufacturer_reporting_profile_for(duplicate_protection_key, Profile),
    severe_incident_status(Profile, input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(wrong_type_fixture_is_a_wrong_type) :-
    cra_art14_manufacturer_reporting_profile_for(wrong_type_protection_value, Profile),
    severe_incident_status(Profile, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(unknown_key_fixture_is_an_unknown_key) :-
    cra_art14_manufacturer_reporting_profile_for(unknown_extra_key, Profile),
    severe_incident_status(Profile, input_problems([unknown_key(severity_score)]), []).
test(not_an_attribute_list_fixture_is_wrong_type) :-
    cra_art14_manufacturer_reporting_profile_for(not_an_attribute_list, Profile),
    severe_incident_status(Profile, input_problems([wrong_type(profile)]), []).
test(unbound_event_is_wrong_type) :-
    findall(Steps, manufacturer_reporting_steps([], _UnboundEvent, date(2027, 1, 1), Steps), Answers),
    Answers == [input_problems([wrong_type(event)])].
test(day_outside_the_month_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 4, 31), input_problems([wrong_type(awareness_date)])).
test(february_29_of_a_century_year_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2100, 2, 29), input_problems([wrong_type(awareness_date)])).
test(february_29_of_a_year_divisible_by_400_is_a_day) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2000, 2, 29), []).
test(iso_string_date_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, '2027-01-01', input_problems([wrong_type(awareness_date)])).
test(unbound_date_is_wrong_type) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, _UnboundDate, Steps), Answers),
    Answers == [input_problems([wrong_type(awareness_date)])].
test(unbound_step_and_hours_are_wrong_type) :-
    findall(Result, manufacturer_reporting_step_timeliness([], incident_impacting_product_security, _UnboundStep, _UnboundHours, Result), Results),
    Results == [input_problems([wrong_type(step), wrong_type(hours_elapsed)])].
test(fractional_hours_are_wrong_type) :-
    manufacturer_reporting_step_timeliness([], incident_impacting_product_security, early_warning, 24.5, input_problems([wrong_type(hours_elapsed)])).
test(profile_problems_come_before_argument_problems) :-
    manufacturer_reporting_step_timeliness([foo], breach, final_report, -2, input_problems([wrong_type(profile), wrong_type(event), wrong_type(step), wrong_type(hours_elapsed)])).

test(not_severe_rejects_a_bound_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(severe_incident_rejects_a_bound_empty_list, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2030, 12, 31), []).

cp_test_names([severe_by_protection_holds_with_status_and_citations_bound, severe_by_malicious_code_holds_bound, not_severe_holds_bound, missing_protection_limb_holds_bound, unsure_beside_missing_names_the_missing_key_bound, missing_protection_beside_false_holds_bound, referral_on_protection_holds_bound, referral_on_malicious_code_holds_bound, vulnerability_steps_hold_bound_on_application_day, steps_before_application_hold_bound, severe_incident_steps_hold_bound, not_severe_incident_steps_hold_bound, on_time_holds_bound, late_hour_limit_holds_bound, late_without_undue_delay_holds_bound, early_warning_referral_on_vulnerability_cites_point_a_of_paragraph_2, early_warning_referral_on_incident_cites_point_a_of_paragraph_4, notification_referral_on_vulnerability_cites_point_b_of_paragraph_2, unbound_profile_is_wrong_type, partial_list_profile_is_wrong_type, unbound_element_profile_is_wrong_type, unbound_value_is_wrong_type, non_atom_key_is_an_unknown_key, string_value_is_wrong_type, duplicate_key_fixture_is_a_duplicate_key, wrong_type_fixture_is_a_wrong_type, unknown_key_fixture_is_an_unknown_key, not_an_attribute_list_fixture_is_wrong_type, unbound_event_is_wrong_type, day_outside_the_month_is_wrong_type, february_29_of_a_century_year_is_wrong_type, february_29_of_a_year_divisible_by_400_is_a_day, iso_string_date_is_wrong_type, unbound_date_is_wrong_type, unbound_step_and_hours_are_wrong_type, fractional_hours_are_wrong_type, profile_problems_come_before_argument_problems]).
cp_test_fail_names([not_severe_rejects_a_bound_severe, severe_incident_rejects_a_bound_empty_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
