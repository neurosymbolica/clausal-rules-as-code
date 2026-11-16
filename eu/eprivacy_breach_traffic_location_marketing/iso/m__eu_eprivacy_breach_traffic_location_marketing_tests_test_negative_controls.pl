% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3, eprivacy_breach_traffic_location_marketing_status_values/1]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_profile_for/2]).

focus_answer(Subject, personal_data_breach_notification, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    personal_data_breach_notification_status(Profile, Result, Citations).
focus_answer(Subject, traffic_data_processing, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    traffic_data_processing_status(Profile, Result, Citations).
focus_answer(Subject, location_data_processing, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    location_data_processing_status(Profile, Result, Citations).
focus_answer(Subject, direct_marketing_communication, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    direct_marketing_communication_status(Profile, Result, Citations).
focus_answer(Subject, direct_marketing_email_practice, Result, Citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    direct_marketing_email_practice_status(Profile, Result, Citations).

test(the_status_table_holds_the_facade_atoms) :-
    eprivacy_breach_traffic_location_marketing_status_values(StatusValues),
    StatusValues == [eligible, ineligible, national_law_decides, not_applicable].
test(scope_not_a_provider_is_not_applicable) :-
    focus_answer(breach_not_a_provider, personal_data_breach_notification, not_applicable, [cite(eu_dir_2002_58_art_4_3)]).
test(scope_not_a_personal_data_breach_is_not_applicable) :-
    focus_answer(breach_not_a_personal_data_breach, personal_data_breach_notification, not_applicable, [cite(eu_dir_2002_58_art_4_3)]).
test(scope_near_miss_provider_and_breach_notify_the_authority) :-
    focus_answer(breach_personal_data_breach_control, personal_data_breach_notification, authority_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
test(authority_requirement_notifies_both) :-
    focus_answer(breach_authority_required, personal_data_breach_notification, authority_and_individual_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
test(authority_requirement_near_miss_notifies_the_authority_only) :-
    focus_answer(breach_authority_not_required_control, personal_data_breach_notification, authority_notification_due, _).
test(likely_adverse_effect_without_protection_notifies_both) :-
    focus_answer(breach_individual_notification_due, personal_data_breach_notification, authority_and_individual_notification_due, _).
test(demonstrated_protection_near_miss_notifies_the_authority_only) :-
    focus_answer(breach_protection_demonstrated_control, personal_data_breach_notification, authority_notification_due, _).
test(traffic_scope_not_traffic_data_is_not_applicable) :-
    focus_answer(traffic_not_traffic_data, traffic_data_processing, not_applicable, [cite(eu_dir_2002_58_art_6_1)]).
test(traffic_scope_near_miss_traffic_data_is_in_scope) :-
    focus_answer(traffic_other_purpose, traffic_data_processing, not_permitted, _).
test(transmission_still_needed_is_permitted) :-
    focus_answer(traffic_transmission_still_needed, traffic_data_processing, permitted, [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]).
test(transmission_near_miss_no_longer_needed_is_not_permitted) :-
    focus_answer(traffic_transmission_no_longer_needed, traffic_data_processing, not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
test(billing_within_the_period_is_permitted) :-
    focus_answer(traffic_billing_within_period, traffic_data_processing, permitted, _).
test(billing_near_miss_period_ended_is_not_permitted) :-
    focus_answer(traffic_billing_period_ended, traffic_data_processing, not_permitted, _).
test(marketing_with_consent_is_permitted) :-
    focus_answer(traffic_marketing_with_consent, traffic_data_processing, permitted, _).
test(marketing_near_miss_consent_withdrawn_is_not_permitted) :-
    focus_answer(traffic_marketing_consent_withdrawn, traffic_data_processing, not_permitted, _).
test(marketing_near_miss_network_only_provider_is_not_permitted) :-
    focus_answer(traffic_marketing_network_only_provider, traffic_data_processing, not_permitted, _).
test(other_purpose_is_not_permitted) :-
    focus_answer(traffic_other_purpose, traffic_data_processing, not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
test(location_scope_out_of_scope_is_not_applicable) :-
    focus_answer(location_out_of_scope, location_data_processing, not_applicable, [cite(eu_dir_2002_58_art_9_1)]).
test(location_scope_near_miss_in_scope_anonymous_is_permitted) :-
    focus_answer(location_made_anonymous, location_data_processing, permitted, _).
test(anonymous_location_data_is_permitted) :-
    focus_answer(location_made_anonymous, location_data_processing, permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(anonymity_near_miss_without_consent_is_not_permitted) :-
    focus_answer(location_not_anonymous_without_consent, location_data_processing, not_permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(location_consent_route_is_permitted) :-
    focus_answer(location_consent_route, location_data_processing, permitted, _).
test(location_consent_near_miss_refused_is_not_permitted) :-
    focus_answer(location_temporarily_refused, location_data_processing, not_permitted, _).
test(marketing_scope_not_direct_marketing_is_not_applicable) :-
    focus_answer(marketing_not_direct_marketing, direct_marketing_communication, not_applicable, [cite(eu_dir_2002_58_art_13_1)]).
test(marketing_scope_near_miss_direct_marketing_email_with_consent) :-
    focus_answer(marketing_email_with_consent, direct_marketing_communication, sending_permitted, _).
test(other_means_national_law_decides) :-
    focus_answer(marketing_other_means, direct_marketing_communication, national_law_decides, [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]).
test(other_means_near_miss_fax_with_consent_is_permitted) :-
    focus_answer(marketing_fax_with_consent, direct_marketing_communication, sending_permitted, _).
test(legal_person_subscriber_national_law_decides) :-
    focus_answer(marketing_legal_person_subscriber, direct_marketing_communication, national_law_decides, _).
test(legal_person_near_miss_natural_person_fax_without_consent) :-
    focus_answer(marketing_fax_without_consent, direct_marketing_communication, sending_not_permitted, _).
test(fax_with_consent_is_permitted) :-
    focus_answer(marketing_fax_with_consent, direct_marketing_communication, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
test(fax_near_miss_without_consent_is_not_permitted) :-
    focus_answer(marketing_fax_without_consent, direct_marketing_communication, sending_not_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
test(customer_exception_permits_email) :-
    focus_answer(marketing_customer_exception, direct_marketing_communication, sending_permitted, _).
test(customer_exception_near_miss_objected_is_not_permitted) :-
    focus_answer(marketing_customer_objected_control, direct_marketing_communication, sending_not_permitted, _).
test(customer_exception_near_miss_other_sender_is_not_permitted) :-
    focus_answer(marketing_other_sender_control, direct_marketing_communication, sending_not_permitted, _).
test(email_practice_fax_is_not_applicable) :-
    focus_answer(marketing_fax_with_consent, direct_marketing_email_practice, not_applicable, [cite(eu_dir_2002_58_art_13_4)]).
test(email_practice_near_miss_clean_email_is_not_prohibited) :-
    focus_answer(marketing_email_with_consent, direct_marketing_email_practice, practice_not_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
test(email_disguised_sender_is_prohibited) :-
    focus_answer(email_disguised_sender, direct_marketing_email_practice, practice_prohibited, _).
test(email_no_cessation_address_is_prohibited) :-
    focus_answer(email_no_cessation_address, direct_marketing_email_practice, practice_prohibited, _).
test(input_unknown_key_is_named) :-
    eprivacy_breach_traffic_location_marketing_profile_for(input_unknown_key, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [unknown_key(favourite_colour)]).
test(input_near_miss_a_contract_profile_has_no_problem) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_email_with_consent, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, []).
test(input_unsure_boolean_is_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_profile_for(input_unsure_boolean, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [wrong_type(location_consent_withdrawn)]).

test(scope_near_miss_is_not_not_applicable, fail) :-
    focus_answer(breach_personal_data_breach_control, personal_data_breach_notification, not_applicable, _).
test(authority_requirement_near_miss_does_not_notify_both, fail) :-
    focus_answer(breach_authority_not_required_control, personal_data_breach_notification, authority_and_individual_notification_due, _).
test(demonstrated_protection_near_miss_does_not_notify_both, fail) :-
    focus_answer(breach_protection_demonstrated_control, personal_data_breach_notification, authority_and_individual_notification_due, _).
test(traffic_scope_near_miss_is_not_not_applicable, fail) :-
    focus_answer(traffic_other_purpose, traffic_data_processing, not_applicable, _).
test(transmission_near_miss_is_not_permitted, fail) :-
    focus_answer(traffic_transmission_no_longer_needed, traffic_data_processing, permitted, _).
test(billing_near_miss_is_not_permitted, fail) :-
    focus_answer(traffic_billing_period_ended, traffic_data_processing, permitted, _).
test(marketing_near_miss_consent_withdrawn_is_not_permitted_only, fail) :-
    focus_answer(traffic_marketing_consent_withdrawn, traffic_data_processing, permitted, _).
test(marketing_near_miss_network_only_provider_is_not_permitted_only, fail) :-
    focus_answer(traffic_marketing_network_only_provider, traffic_data_processing, permitted, _).
test(other_purpose_is_never_permitted, fail) :-
    focus_answer(traffic_other_purpose, traffic_data_processing, permitted, _).
test(location_scope_near_miss_is_not_not_applicable, fail) :-
    focus_answer(location_made_anonymous, location_data_processing, not_applicable, _).
test(anonymity_near_miss_is_not_permitted, fail) :-
    focus_answer(location_not_anonymous_without_consent, location_data_processing, permitted, _).
test(location_consent_near_miss_refused_is_not_permitted_only, fail) :-
    focus_answer(location_temporarily_refused, location_data_processing, permitted, _).
test(marketing_scope_near_miss_is_not_not_applicable, fail) :-
    focus_answer(marketing_email_with_consent, direct_marketing_communication, not_applicable, _).
test(other_means_near_miss_is_not_national_law, fail) :-
    focus_answer(marketing_fax_with_consent, direct_marketing_communication, national_law_decides, _).
test(legal_person_near_miss_is_not_national_law, fail) :-
    focus_answer(marketing_fax_without_consent, direct_marketing_communication, national_law_decides, _).
test(fax_near_miss_without_consent_is_not_permitted_only, fail) :-
    focus_answer(marketing_fax_without_consent, direct_marketing_communication, sending_permitted, _).
test(customer_exception_near_miss_objected_is_not_permitted_only, fail) :-
    focus_answer(marketing_customer_objected_control, direct_marketing_communication, sending_permitted, _).
test(customer_exception_near_miss_other_sender_is_not_permitted_only, fail) :-
    focus_answer(marketing_other_sender_control, direct_marketing_communication, sending_permitted, _).
test(email_practice_near_miss_clean_email_is_not_not_applicable, fail) :-
    focus_answer(marketing_email_with_consent, direct_marketing_email_practice, not_applicable, _).
test(email_no_cessation_address_is_not_cleared, fail) :-
    focus_answer(email_no_cessation_address, direct_marketing_email_practice, practice_not_prohibited, _).
test(clean_email_is_not_prohibited, fail) :-
    focus_answer(marketing_email_with_consent, direct_marketing_email_practice, practice_prohibited, _).
test(input_near_miss_a_contract_profile_is_not_refused, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_email_with_consent, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [_|_]).

cp_test_names([the_status_table_holds_the_facade_atoms, scope_not_a_provider_is_not_applicable, scope_not_a_personal_data_breach_is_not_applicable, scope_near_miss_provider_and_breach_notify_the_authority, authority_requirement_notifies_both, authority_requirement_near_miss_notifies_the_authority_only, likely_adverse_effect_without_protection_notifies_both, demonstrated_protection_near_miss_notifies_the_authority_only, traffic_scope_not_traffic_data_is_not_applicable, traffic_scope_near_miss_traffic_data_is_in_scope, transmission_still_needed_is_permitted, transmission_near_miss_no_longer_needed_is_not_permitted, billing_within_the_period_is_permitted, billing_near_miss_period_ended_is_not_permitted, marketing_with_consent_is_permitted, marketing_near_miss_consent_withdrawn_is_not_permitted, marketing_near_miss_network_only_provider_is_not_permitted, other_purpose_is_not_permitted, location_scope_out_of_scope_is_not_applicable, location_scope_near_miss_in_scope_anonymous_is_permitted, anonymous_location_data_is_permitted, anonymity_near_miss_without_consent_is_not_permitted, location_consent_route_is_permitted, location_consent_near_miss_refused_is_not_permitted, marketing_scope_not_direct_marketing_is_not_applicable, marketing_scope_near_miss_direct_marketing_email_with_consent, other_means_national_law_decides, other_means_near_miss_fax_with_consent_is_permitted, legal_person_subscriber_national_law_decides, legal_person_near_miss_natural_person_fax_without_consent, fax_with_consent_is_permitted, fax_near_miss_without_consent_is_not_permitted, customer_exception_permits_email, customer_exception_near_miss_objected_is_not_permitted, customer_exception_near_miss_other_sender_is_not_permitted, email_practice_fax_is_not_applicable, email_practice_near_miss_clean_email_is_not_prohibited, email_disguised_sender_is_prohibited, email_no_cessation_address_is_prohibited, input_unknown_key_is_named, input_near_miss_a_contract_profile_has_no_problem, input_unsure_boolean_is_wrong_type]).
cp_test_fail_names([scope_near_miss_is_not_not_applicable, authority_requirement_near_miss_does_not_notify_both, demonstrated_protection_near_miss_does_not_notify_both, traffic_scope_near_miss_is_not_not_applicable, transmission_near_miss_is_not_permitted, billing_near_miss_is_not_permitted, marketing_near_miss_consent_withdrawn_is_not_permitted_only, marketing_near_miss_network_only_provider_is_not_permitted_only, other_purpose_is_never_permitted, location_scope_near_miss_is_not_not_applicable, anonymity_near_miss_is_not_permitted, location_consent_near_miss_refused_is_not_permitted_only, marketing_scope_near_miss_is_not_not_applicable, other_means_near_miss_is_not_national_law, legal_person_near_miss_is_not_national_law, fax_near_miss_without_consent_is_not_permitted_only, customer_exception_near_miss_objected_is_not_permitted_only, customer_exception_near_miss_other_sender_is_not_permitted_only, email_practice_near_miss_clean_email_is_not_not_applicable, email_no_cessation_address_is_not_cleared, clean_email_is_not_prohibited, input_near_miss_a_contract_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
