% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, cra_art14_manufacturer_reporting_status/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

test(severe_holds_with_status_and_citations_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    severe_incident_status(Profile, severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(not_severe_holds_with_status_bound) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, not_severe).
test(steps_hold_with_the_first_step_bound) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 1), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a))|_LaterSteps]).
test(timeliness_holds_with_the_result_bound) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 72, on_time).
test(key_order_in_the_profile_does_not_matter) :-
    severe_incident_status([attribute(leads_to_malicious_code_in_product_or_user_systems, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(an_empty_profile_is_well_formed) :-
    cra_art14_manufacturer_reporting_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)|_RestOfList], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    severe_incident_status(not_a_profile, input_problems([wrong_type(profile)]), []).
test(a_foreign_element_makes_it_not_an_attribute_list) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), stray_element], [wrong_type(profile)]).
test(an_unbound_element_makes_it_not_an_attribute_list) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([_UnboundElement], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(notification_without_undue_delay, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(notification_without_undue_delay)]].
test(a_string_value_is_wrong_type) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, "true")], [wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)]).
test(a_compound_key_is_unknown_as_given) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(flag(severity), true)], [unknown_key(flag(severity))]).
test(a_numeric_key_is_unknown_as_given) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unknown_key_beside_valid_keys_refuses) :-
    cra_art14_manufacturer_reporting_profile_for(unknown_key_problem, Profile),
    severe_incident_status(Profile, input_problems([unknown_key(product_category)]), []).
test(an_unbound_event_is_wrong_type) :-
    findall(Steps, manufacturer_reporting_steps([], _Event, date(2027, 1, 1), Steps), Solutions),
    Solutions == [input_problems([wrong_type(event)])].
test(a_day_that_does_not_exist_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 2, 29), input_problems([wrong_type(awareness_date)])).
test(month_thirteen_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 13, 1), input_problems([wrong_type(awareness_date)])).
test(day_zero_is_wrong_type) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 1, 0), input_problems([wrong_type(awareness_date)])).
test(an_iso_string_atom_is_not_a_date) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, '2027-01-01', input_problems([wrong_type(awareness_date)])).
test(the_leap_day_of_2000_is_a_real_date) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2000, 2, 29), []).
test(fractional_hours_are_wrong_type) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 24.5, input_problems([wrong_type(hours_elapsed)])).
test(unbound_hours_are_wrong_type) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, _HoursElapsed, Result), Results),
    Results == [input_problems([wrong_type(hours_elapsed)])].
test(an_unbound_step_is_wrong_type) :-
    findall(Result, manufacturer_reporting_step_timeliness([], incident_impacting_product_security, _ReportingStep, 3, Result), Results),
    Results == [input_problems([wrong_type(step)])].
test(zero_hours_is_a_valid_count) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 0, on_time).

test(severe_profile_rejects_bound_not_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    severe_incident_status(Profile, not_severe, _Citations).
test(not_severe_profile_rejects_bound_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_status(Profile, severe).
test(steps_reject_the_vulnerability_citation_for_an_incident, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 1, 1), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a))|_LaterSteps]).
test(timeliness_rejects_bound_late_within_the_limit, fail) :-
    cra_art14_manufacturer_reporting_profile_for(notification_without_undue_delay_given, Profile),
    manufacturer_reporting_step_timeliness(Profile, actively_exploited_vulnerability, notification, 72, late(_Requirement)).

cp_test_names([severe_holds_with_status_and_citations_bound, not_severe_holds_with_status_bound, steps_hold_with_the_first_step_bound, timeliness_holds_with_the_result_bound, key_order_in_the_profile_does_not_matter, an_empty_profile_is_well_formed, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, a_foreign_element_makes_it_not_an_attribute_list, an_unbound_element_makes_it_not_an_attribute_list, an_unbound_value_is_wrong_type, a_string_value_is_wrong_type, a_compound_key_is_unknown_as_given, a_numeric_key_is_unknown_as_given, an_unknown_key_beside_valid_keys_refuses, an_unbound_event_is_wrong_type, a_day_that_does_not_exist_is_wrong_type, month_thirteen_is_wrong_type, day_zero_is_wrong_type, an_iso_string_atom_is_not_a_date, the_leap_day_of_2000_is_a_real_date, fractional_hours_are_wrong_type, unbound_hours_are_wrong_type, an_unbound_step_is_wrong_type, zero_hours_is_a_valid_count]).
cp_test_fail_names([severe_profile_rejects_bound_not_severe, not_severe_profile_rejects_bound_severe, steps_reject_the_vulnerability_citation_for_an_incident, timeliness_rejects_bound_late_within_the_limit]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
