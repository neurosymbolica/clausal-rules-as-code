% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3, eprivacy_breach_traffic_location_marketing_status/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_profile_for/2]).

test(breach_both_notifications_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_individual_notification_due, Profile),
    personal_data_breach_notification_status(Profile, authority_and_individual_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
test(traffic_billing_permitted_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_within_period, Profile),
    traffic_data_processing_status(Profile, permitted, [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]).
test(location_consent_permitted_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_consent_route, Profile),
    location_data_processing_status(Profile, permitted, [cite(eu_dir_2002_58_art_9_1)]).
test(marketing_customer_exception_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_customer_exception, Profile),
    direct_marketing_communication_status(Profile, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
test(marketing_legal_person_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_legal_person_subscriber, Profile),
    direct_marketing_communication_status(Profile, national_law_decides, [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]).
test(email_practice_prohibited_with_the_result_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(email_no_cessation_address, Profile),
    direct_marketing_email_practice_status(Profile, practice_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
test(facade_status_ineligible_with_the_status_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    eprivacy_breach_traffic_location_marketing_status(Profile, ineligible).
test(facade_status_national_law_with_the_status_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_other_means, Profile),
    eprivacy_breach_traffic_location_marketing_status(Profile, national_law_decides).
test(input_check_with_the_problems_bound) :-
    eprivacy_breach_traffic_location_marketing_profile_for(input_duplicate_key, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, [duplicate_key(marketing_communication_means)]).
test(a_non_attribute_element_is_wrong_type_profile_alone) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(favourite_colour, blue), personal_data_breach_occurred - true], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_profile_is_wrong_type_profile) :-
    eprivacy_breach_traffic_location_marketing_input_problems(nothing, Problems),
    Problems == [wrong_type(profile)].
test(a_number_key_is_an_unknown_key) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_compound_key_is_an_unknown_key) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(some(thing), true)], Problems),
    Problems == [unknown_key(some(thing))].
test(an_attested_value_is_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(personal_data_breach_occurred, attested(true))], Problems),
    Problems == [wrong_type(personal_data_breach_occurred)].
test(an_unsure_boolean_is_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(authority_required_individual_notification, unsure)], Problems),
    Problems == [wrong_type(authority_required_individual_notification)].
test(a_quoted_string_value_is_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(location_consent_withdrawn, "true")], Problems),
    Problems == [wrong_type(location_consent_withdrawn)].
test(an_unlisted_enum_atom_is_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(traffic_processing_purpose, profiling)], Problems),
    Problems == [wrong_type(traffic_processing_purpose)].
test(an_unsure_judgement_is_well_formed) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(personal_data_breach_occurred, unsure)], Problems),
    Problems == [].
test(an_empty_profile_is_well_formed) :-
    eprivacy_breach_traffic_location_marketing_input_problems([], Problems),
    Problems == [].
test(a_duplicate_with_equal_values_is_only_a_duplicate) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(location_consent_given, true), attribute(location_consent_given, true)], Problems),
    Problems == [duplicate_key(location_consent_given)].
test(a_duplicate_with_bad_values_is_not_also_wrong_type) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(location_consent_given, maybe), attribute(location_consent_given, perhaps)], Problems),
    Problems == [duplicate_key(location_consent_given)].
test(problems_follow_contract_order_then_unknown_keys) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(zeta_key, true), attribute(email_valid_cessation_address_provided, maybe), attribute(breach_provider_of_publicly_available_service, 7)], Problems),
    Problems == [wrong_type(breach_provider_of_publicly_available_service), wrong_type(email_valid_cessation_address_provided), unknown_key(zeta_key)].
test(a_repeated_unknown_key_is_named_once) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(zeta_key, true), attribute(alpha_key, true), attribute(zeta_key, false)], Problems),
    Problems == [unknown_key(zeta_key), unknown_key(alpha_key)].
test(the_input_check_has_exactly_one_solution) :-
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems([attribute(zeta_key, true), attribute(fax_number, 1)], Problems), Solutions),
    Solutions == [[unknown_key(zeta_key), unknown_key(fax_number)]].
test(a_profile_with_a_problem_gets_input_problems) :-
    location_data_processing_status([attribute(location_consent_withdrawn, unsure), attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, true)], input_problems([wrong_type(location_consent_withdrawn)]), []).
test(a_key_of_another_query_is_checked_by_every_query) :-
    direct_marketing_email_practice_status([attribute(traffic_processing_purpose, profiling)], input_problems([wrong_type(traffic_processing_purpose)]), []).

test(breach_both_notifications_rejects_authority_only, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_individual_notification_due, Profile),
    personal_data_breach_notification_status(Profile, authority_notification_due, _).
test(traffic_billing_permitted_rejects_a_short_citation_list, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_within_period, Profile),
    traffic_data_processing_status(Profile, permitted, [cite(eu_dir_2002_58_art_6_2)]).
test(facade_status_ineligible_rejects_eligible, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    eprivacy_breach_traffic_location_marketing_status(Profile, eligible).
test(a_profile_with_a_problem_gets_no_final_answer, fail) :-
    location_data_processing_status([attribute(location_consent_withdrawn, unsure), attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, true)], permitted, _).

cp_test_names([breach_both_notifications_with_the_result_bound, traffic_billing_permitted_with_the_result_bound, location_consent_permitted_with_the_result_bound, marketing_customer_exception_with_the_result_bound, marketing_legal_person_with_the_result_bound, email_practice_prohibited_with_the_result_bound, facade_status_ineligible_with_the_status_bound, facade_status_national_law_with_the_status_bound, input_check_with_the_problems_bound, a_non_attribute_element_is_wrong_type_profile_alone, an_atom_profile_is_wrong_type_profile, a_number_key_is_an_unknown_key, a_compound_key_is_an_unknown_key, an_attested_value_is_wrong_type, an_unsure_boolean_is_wrong_type, a_quoted_string_value_is_wrong_type, an_unlisted_enum_atom_is_wrong_type, an_unsure_judgement_is_well_formed, an_empty_profile_is_well_formed, a_duplicate_with_equal_values_is_only_a_duplicate, a_duplicate_with_bad_values_is_not_also_wrong_type, problems_follow_contract_order_then_unknown_keys, a_repeated_unknown_key_is_named_once, the_input_check_has_exactly_one_solution, a_profile_with_a_problem_gets_input_problems, a_key_of_another_query_is_checked_by_every_query]).
cp_test_fail_names([breach_both_notifications_rejects_authority_only, traffic_billing_permitted_rejects_a_short_citation_list, facade_status_ineligible_rejects_eligible, a_profile_with_a_problem_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
