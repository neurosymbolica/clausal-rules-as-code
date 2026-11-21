% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5]).

test(profile_keys_are_the_contract_keys) :-
    cra_art14_manufacturer_reporting_profile_keys(ProfileKeys),
    ProfileKeys == [affects_protection_of_sensitive_or_important_data_or_functions, leads_to_malicious_code_in_product_or_user_systems, early_warning_without_undue_delay, notification_without_undue_delay].
test(a_profile_of_all_schema_keys_is_well_formed) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false), attribute(early_warning_without_undue_delay, true), attribute(notification_without_undue_delay, unsure)], []).
test(query_2_answers_once) :-
    findall(Status, severe_incident_status([attribute(leads_to_malicious_code_in_product_or_user_systems, true)], Status, _Citations), Answers),
    Answers == [severe].
test(query_15_lists_the_limits_of_a_vulnerability) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 5, 5), Steps),
    Steps = [step_due(early_warning, hours_after_awareness(24), _EarlyCitation), step_due(notification, hours_after_awareness(72), _NotificationCitation), step_due(final_report, days_after_measure_available(14), _FinalCitation), step_due(intermediate_report, on_request_of_coordinator_csirt, _IntermediateCitation)].
test(query_15_consequence_of_missing_the_limit) :-
    manufacturer_reporting_step_timeliness([], incident_impacting_product_security, notification, 73, late(hour_limit)).
test(what_if_turns_not_severe_into_severe) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], leads_to_malicious_code_in_product_or_user_systems, true, severe).
test(what_if_turns_not_severe_into_a_referral) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], affects_protection_of_sensitive_or_important_data_or_functions, unsure, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])])).
test(what_if_adds_a_key_to_an_empty_profile) :-
    cra_art14_manufacturer_reporting_what_if([], affects_protection_of_sensitive_or_important_data_or_functions, true, severe).
test(what_if_replaces_a_duplicated_key) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], affects_protection_of_sensitive_or_important_data_or_functions, true, severe).
test(what_if_on_an_undue_delay_key_keeps_the_severity) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], early_warning_without_undue_delay, true, not_severe).
test(what_if_with_a_value_outside_the_type_is_refused) :-
    cra_art14_manufacturer_reporting_what_if([], affects_protection_of_sensitive_or_important_data_or_functions, maybe, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)])).
test(what_if_with_a_key_outside_the_contract_is_refused) :-
    cra_art14_manufacturer_reporting_what_if([], product_category, router, input_problems([unknown_key(product_category)])).
test(what_if_never_answers_twice) :-
    findall(NewStatus, cra_art14_manufacturer_reporting_what_if([attribute(leads_to_malicious_code_in_product_or_user_systems, true)], affects_protection_of_sensitive_or_important_data_or_functions, true, NewStatus), Answers),
    Answers == [severe].

test(what_if_to_true_is_not_not_severe, fail) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], leads_to_malicious_code_in_product_or_user_systems, true, not_severe).

cp_test_names([profile_keys_are_the_contract_keys, a_profile_of_all_schema_keys_is_well_formed, query_2_answers_once, query_15_lists_the_limits_of_a_vulnerability, query_15_consequence_of_missing_the_limit, what_if_turns_not_severe_into_severe, what_if_turns_not_severe_into_a_referral, what_if_adds_a_key_to_an_empty_profile, what_if_replaces_a_duplicated_key, what_if_on_an_undue_delay_key_keeps_the_severity, what_if_with_a_value_outside_the_type_is_refused, what_if_with_a_key_outside_the_contract_is_refused, what_if_never_answers_twice]).
cp_test_fail_names([what_if_to_true_is_not_not_severe]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
