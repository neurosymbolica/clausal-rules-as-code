% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [decide_cra_art14_manufacturer_reporting/2, severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

expected_vulnerability_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

expected_incident_steps([step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).

test(both_limbs_true_yield_severe_once) :-
    findall(Status - Citations, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], Status, Citations), Answers),
    Answers == [severe - [cite(eu_reg_2024_2847_art_14_5)]].
test(the_severe_citation_does_not_change_when_the_other_key_is_filled) :-
    findall(Citations, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], severe, Citations), Before),
    findall(Citations, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], severe, Citations), After),
    Before == After.
test(not_severe_cites_both_limbs_once) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Status - Citations, severe_incident_status(Profile, Status, Citations), Answers),
    Answers == [not_severe - [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]].
test(an_empty_profile_names_the_first_limb_with_no_citation) :-
    findall(Status - Citations, severe_incident_status([], Status, Citations), Answers),
    Answers == [indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]) - []].
test(a_referral_context_opens_with_the_inputs_relied_on) :-
    cra_art14_manufacturer_reporting_profile_for(malicious_code_limb_unsure_referral, Profile),
    findall(Status, severe_incident_status(Profile, Status, _Citations), Answers),
    Answers == [needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])].
test(the_facade_verdict_carries_the_status_and_its_citations) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_malicious_code_limb, Profile),
    findall(Verdict, decide_cra_art14_manufacturer_reporting(Profile, Verdict), Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(severe, [cite(eu_reg_2024_2847_art_14_5)])].
test(the_day_before_application_enumerates_to_the_empty_list) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), Steps), Solutions),
    Solutions == [[]].
test(the_application_day_enumerates_to_the_vulnerability_steps) :-
    expected_vulnerability_steps(Expected),
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), Steps), Solutions),
    Solutions == [Expected].
test(a_severe_incident_enumerates_to_the_incident_steps) :-
    expected_incident_steps(Expected),
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    findall(Steps, manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2026, 9, 11), Steps), Solutions),
    Solutions == [Expected].
test(an_open_severity_is_a_bare_status_compound) :-
    findall(Steps, manufacturer_reporting_steps([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure)], incident_impacting_product_security, date(2027, 1, 1), Steps), Solutions),
    Solutions == [indeterminate([leads_to_malicious_code_in_product_or_user_systems])].
test(argument_problems_follow_the_profile_problem) :-
    findall(Steps, manufacturer_reporting_steps(not_a_profile, breach, date(2026, 2, 30), Steps), Solutions),
    Solutions == [input_problems([wrong_type(profile), wrong_type(event), wrong_type(awareness_date)])].
test(early_warning_hours_around_the_24_hour_limit) :-
    findall(Hours - Result, (member(Hours, [0, 24, 25]), manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, Hours, Result)), Answers),
    Answers == [0 - on_time, 24 - on_time, 25 - late(hour_limit)].
test(notification_hours_around_the_72_hour_limit) :-
    findall(Hours - Result, (member(Hours, [71, 72, 73]), manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, true)], incident_impacting_product_security, notification, Hours, Result)), Answers),
    Answers == [71 - on_time, 72 - on_time, 73 - late(hour_limit)].
test(after_the_limit_no_key_is_read) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 25, Result), Answers),
    Answers == [late(hour_limit)].
test(timeliness_argument_problems_in_argument_order) :-
    findall(Result, manufacturer_reporting_step_timeliness(not_a_profile, breach, final_report, -3, Result), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(event), wrong_type(step), wrong_type(hours_elapsed)])].
test(input_problems_in_contract_order_then_unknown_keys) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(zeta_flag, 1), attribute(notification_without_undue_delay, maybe), attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(zeta_flag, 2), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], Problems), Solutions),
    Solutions == [[duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions), wrong_type(notification_without_undue_delay), unknown_key(zeta_flag)]].
test(a_non_list_profile_has_exactly_one_problem_list) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(not_a_profile, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].

cp_test_names([both_limbs_true_yield_severe_once, the_severe_citation_does_not_change_when_the_other_key_is_filled, not_severe_cites_both_limbs_once, an_empty_profile_names_the_first_limb_with_no_citation, a_referral_context_opens_with_the_inputs_relied_on, the_facade_verdict_carries_the_status_and_its_citations, the_day_before_application_enumerates_to_the_empty_list, the_application_day_enumerates_to_the_vulnerability_steps, a_severe_incident_enumerates_to_the_incident_steps, an_open_severity_is_a_bare_status_compound, argument_problems_follow_the_profile_problem, early_warning_hours_around_the_24_hour_limit, notification_hours_around_the_72_hour_limit, after_the_limit_no_key_is_read, timeliness_argument_problems_in_argument_order, input_problems_in_contract_order_then_unknown_keys, a_non_list_profile_has_exactly_one_problem_list]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
