% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [decide_eprivacy_breach_traffic_location_marketing/2, eprivacy_breach_traffic_location_marketing_status/2, eprivacy_breach_traffic_location_marketing_checklist/2, personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_profile_for/2]).

test(empty_profile_breach_names_its_first_key) :-
    findall(Result - Citations, personal_data_breach_notification_status([], Result, Citations), Answers),
    Answers == [indeterminate([breach_provider_of_publicly_available_service]) - []].
test(empty_profile_traffic_names_its_first_key) :-
    findall(Result - Citations, traffic_data_processing_status([], Result, Citations), Answers),
    Answers == [indeterminate([traffic_provider_of_public_network_or_service]) - []].
test(empty_profile_location_names_its_first_key) :-
    findall(Result - Citations, location_data_processing_status([], Result, Citations), Answers),
    Answers == [indeterminate([location_data_other_than_traffic_data_in_scope]) - []].
test(empty_profile_marketing_names_its_first_key) :-
    findall(Result - Citations, direct_marketing_communication_status([], Result, Citations), Answers),
    Answers == [indeterminate([marketing_communication_for_direct_marketing]) - []].
test(empty_profile_email_practice_names_its_first_key) :-
    findall(Result - Citations, direct_marketing_email_practice_status([], Result, Citations), Answers),
    Answers == [indeterminate([marketing_communication_for_direct_marketing]) - []].
test(breach_demonstrated_protection_reads_out_authority_only) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_protection_demonstrated_control, Profile),
    findall(Result - Citations, personal_data_breach_notification_status(Profile, Result, Citations), Answers),
    Answers == [authority_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(traffic_transmission_reads_out_permitted) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_transmission_still_needed, Profile),
    findall(Result - Citations, traffic_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]].
test(traffic_no_longer_needed_reads_out_not_permitted) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_transmission_no_longer_needed, Profile),
    findall(Result - Citations, traffic_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_not_traffic_data_reads_out_not_applicable) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_not_traffic_data, Profile),
    findall(Result - Citations, traffic_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_6_1)]].
test(location_out_of_scope_reads_out_not_applicable) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_out_of_scope, Profile),
    findall(Result - Citations, location_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_9_1)]].
test(marketing_not_direct_marketing_reads_out_not_applicable) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_not_direct_marketing, Profile),
    findall(Result - Citations, direct_marketing_communication_status(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_1)]].
test(email_practice_for_fax_reads_out_not_applicable) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_fax_with_consent, Profile),
    findall(Result - Citations, direct_marketing_email_practice_status(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_4)]].
test(email_clean_practice_reads_out_not_prohibited) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_email_with_consent, Profile),
    findall(Result - Citations, direct_marketing_email_practice_status(Profile, Result, Citations), Answers),
    Answers == [practice_not_prohibited - [cite(eu_dir_2002_58_art_13_4)]].
test(breach_missing_likelihood_reads_out_the_missing_key) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_missing_likelihood, Profile),
    findall(Result - Citations, personal_data_breach_notification_status(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_likely_to_adversely_affect_subscriber_or_individual]) - []].
test(location_missing_anonymity_reads_out_the_missing_key) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_missing_anonymity, Profile),
    findall(Result - Citations, location_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [indeterminate([location_data_made_anonymous]) - []].
test(breach_unsure_likelihood_reads_out_a_referral) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_unsure_likelihood, Profile),
    findall(Result - Citations, personal_data_breach_notification_status(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(breach_likely_to_adversely_affect_subscriber_or_individual, cite(eu_dir_2002_58_art_4_3)), [inputs_relied_on([breach_provider_of_publicly_available_service - true, personal_data_breach_occurred - true, authority_required_individual_notification - false, breach_likely_to_adversely_affect_subscriber_or_individual - unsure, protection_measures_demonstrated_to_authority - false])]) - []].
test(traffic_unsure_consent_reads_out_a_referral) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_unsure_consent, Profile),
    findall(Result - Citations, traffic_data_processing_status(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(traffic_marketing_prior_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([traffic_provider_of_public_network_or_service - true, traffic_data_relating_to_subscribers_or_users - true, traffic_processing_purpose - marketing_or_value_added_service, traffic_marketing_provider_of_publicly_available_service - true, traffic_marketing_prior_consent_given - unsure, traffic_marketing_consent_withdrawn - false, traffic_marketing_processing_within_necessary_extent_and_duration - true])]) - []].
test(marketing_unsure_direct_marketing_reads_out_a_referral) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_unsure_direct_marketing, Profile),
    findall(Result - Citations, direct_marketing_communication_status(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(marketing_communication_for_direct_marketing, cite(eu_dir_2002_58_art_13_1)), [inputs_relied_on([marketing_communication_for_direct_marketing - unsure, marketing_subscriber_is_natural_person - true, marketing_communication_means - fax, marketing_prior_consent_given - true])]) - []].
test(email_practice_unsure_direct_marketing_with_fax_is_settled) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_unsure_direct_marketing, Profile),
    findall(Result - Citations, direct_marketing_email_practice_status(Profile, Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_4)]].
test(the_facade_yields_exactly_one_status) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_individual_notification_due, Profile),
    findall(Status, eprivacy_breach_traffic_location_marketing_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_final_verdict_carries_its_citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_individual_notification_due, Profile),
    decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(eligible, Citations)),
    member(cite(eu_dir_2002_58_art_4_3), Citations),
    member(cite(eu_dir_2002_58_art_6_1), Citations).
test(an_open_verdict_carries_no_citation) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_unsure_consent, Profile),
    decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(needs_legal_review(_, _), Citations)),
    Citations == [].
test(the_checklist_has_one_row_per_query) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_email_with_consent, Profile),
    eprivacy_breach_traffic_location_marketing_checklist(Profile, Items),
    length(Items, 5),
    member(item(direct_marketing_communication, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]), Items).
test(the_input_problem_verdict_reads_out) :-
    eprivacy_breach_traffic_location_marketing_profile_for(input_unknown_key, Profile),
    findall(Status, eprivacy_breach_traffic_location_marketing_status(Profile, Status), Statuses),
    Statuses == [input_problems([unknown_key(favourite_colour)])].

cp_test_names([empty_profile_breach_names_its_first_key, empty_profile_traffic_names_its_first_key, empty_profile_location_names_its_first_key, empty_profile_marketing_names_its_first_key, empty_profile_email_practice_names_its_first_key, breach_demonstrated_protection_reads_out_authority_only, traffic_transmission_reads_out_permitted, traffic_no_longer_needed_reads_out_not_permitted, traffic_not_traffic_data_reads_out_not_applicable, location_out_of_scope_reads_out_not_applicable, marketing_not_direct_marketing_reads_out_not_applicable, email_practice_for_fax_reads_out_not_applicable, email_clean_practice_reads_out_not_prohibited, breach_missing_likelihood_reads_out_the_missing_key, location_missing_anonymity_reads_out_the_missing_key, breach_unsure_likelihood_reads_out_a_referral, traffic_unsure_consent_reads_out_a_referral, marketing_unsure_direct_marketing_reads_out_a_referral, email_practice_unsure_direct_marketing_with_fax_is_settled, the_facade_yields_exactly_one_status, the_final_verdict_carries_its_citations, an_open_verdict_carries_no_citation, the_checklist_has_one_row_per_query, the_input_problem_verdict_reads_out]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
