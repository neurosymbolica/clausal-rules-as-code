% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [decide_cra_art14_manufacturer_reporting/2, cra_art14_manufacturer_reporting_status/2, severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

severity_read_out(Subject, Subject - Status) :-
    cra_art14_manufacturer_reporting_profile_for(Subject, Profile),
    cra_art14_manufacturer_reporting_status(Profile, Status).

test(the_severe_subject_yields_exactly_one_status) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    findall(Status, cra_art14_manufacturer_reporting_status(Profile, Status), Statuses),
    Statuses == [severe].
test(the_severe_verdict_carries_its_citation) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    findall(Verdict, decide_cra_art14_manufacturer_reporting(Profile, Verdict), Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(severe, [cite(eu_reg_2024_2847_art_14_5)])].
test(the_not_severe_verdict_cites_both_limbs) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Verdict, decide_cra_art14_manufacturer_reporting(Profile, Verdict), Verdicts),
    Verdicts == [cra_art14_manufacturer_reporting_verdict(not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)])].
test(every_severity_subject_reads_out_its_route) :-
    findall(Answer, (member(Subject, [severe_by_protection_limb, severe_by_malicious_code_limb, not_severe_both_limbs_false, severity_both_limbs_missing, severity_protection_unsure_malicious_code_missing, severity_protection_missing_malicious_code_false]), severity_read_out(Subject, Answer)), Answers),
    Answers == [severe_by_protection_limb - severe, severe_by_malicious_code_limb - severe, not_severe_both_limbs_false - not_severe, severity_both_limbs_missing - indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), severity_protection_unsure_malicious_code_missing - indeterminate([leads_to_malicious_code_in_product_or_user_systems]), severity_protection_missing_malicious_code_false - indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])].
test(the_referral_reads_out_once_with_empty_citations) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_false_malicious_code_unsure, Profile),
    findall(Status - Citations, severe_incident_status(Profile, Status, Citations), Answers),
    Answers == [needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])]) - []].
test(input_problems_read_out_in_contract_then_profile_order) :-
    findall(Status - Citations, severe_incident_status([attribute(colour, red), attribute(notification_without_undue_delay, maybe), attribute(colour, blue)], Status, Citations), Answers),
    Answers == [input_problems([wrong_type(notification_without_undue_delay), unknown_key(colour)]) - []].
test(early_warning_at_24_hours_reads_out_on_time) :-
    findall(Result, manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 24, Result), Results),
    Results == [on_time].
test(early_warning_at_25_hours_reads_out_late) :-
    findall(Result, manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 25, Result), Results),
    Results == [late(hour_limit)].
test(notification_at_72_hours_reads_out_on_time) :-
    findall(Result, manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, true)], incident_impacting_product_security, notification, 72, Result), Results),
    Results == [on_time].
test(notification_at_73_hours_reads_out_late) :-
    findall(Result, manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, true)], incident_impacting_product_security, notification, 73, Result), Results),
    Results == [late(hour_limit)].
test(zero_hours_is_a_valid_count) :-
    findall(Result, manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], incident_impacting_product_security, early_warning, 0, Result), Results),
    Results == [on_time].
test(an_absent_undue_delay_key_reads_out_indeterminate) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 3, Result), Results),
    Results == [indeterminate([early_warning_without_undue_delay])].
test(steps_read_out_the_day_before_application) :-
    findall(Steps, manufacturer_reporting_steps([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], incident_impacting_product_security, date(2026, 9, 10), Steps), Answers),
    Answers == [[]].
test(steps_read_out_on_application_day) :-
    findall(Steps, manufacturer_reporting_steps([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], incident_impacting_product_security, date(2026, 9, 11), Steps), Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]].
test(vulnerability_steps_read_out_in_order) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 2, 1), Steps),
    findall(Step, member(step_due(Step, _, _), Steps), StepNames),
    StepNames == [early_warning, notification, final_report, intermediate_report].
test(vulnerability_limits_read_out) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 2, 1), Steps),
    findall(Limit, member(step_due(_, Limit, _), Steps), Limits),
    Limits == [hours_after_awareness(24), hours_after_awareness(72), days_after_measure_available(14), on_request_of_coordinator_csirt].
test(indeterminate_incident_steps_read_out) :-
    findall(Steps, manufacturer_reporting_steps([], incident_impacting_product_security, date(2027, 2, 1), Steps), Answers),
    Answers == [indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])].
test(referral_incident_steps_read_out) :-
    cra_art14_manufacturer_reporting_profile_for(severity_protection_false_malicious_code_unsure, Profile),
    findall(Steps, manufacturer_reporting_steps(Profile, incident_impacting_product_security, date(2027, 2, 1), Steps), Answers),
    Answers == [needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])].

cp_test_names([the_severe_subject_yields_exactly_one_status, the_severe_verdict_carries_its_citation, the_not_severe_verdict_cites_both_limbs, every_severity_subject_reads_out_its_route, the_referral_reads_out_once_with_empty_citations, input_problems_read_out_in_contract_then_profile_order, early_warning_at_24_hours_reads_out_on_time, early_warning_at_25_hours_reads_out_late, notification_at_72_hours_reads_out_on_time, notification_at_73_hours_reads_out_late, zero_hours_is_a_valid_count, an_absent_undue_delay_key_reads_out_indeterminate, steps_read_out_the_day_before_application, steps_read_out_on_application_day, vulnerability_steps_read_out_in_order, vulnerability_limits_read_out, indeterminate_incident_steps_read_out, referral_incident_steps_read_out]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
