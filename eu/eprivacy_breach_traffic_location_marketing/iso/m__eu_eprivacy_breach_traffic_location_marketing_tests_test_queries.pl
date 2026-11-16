% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_queries, [eprivacy_breach_traffic_location_marketing_profile_keys/1, eprivacy_breach_traffic_location_marketing_what_if/4, input_problems/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [decide_eprivacy_breach_traffic_location_marketing/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    eprivacy_breach_traffic_location_marketing_profile_keys(ProfileKeys),
    ProfileKeys == [breach_provider_of_publicly_available_service, personal_data_breach_occurred, authority_required_individual_notification, breach_likely_to_adversely_affect_subscriber_or_individual, protection_measures_demonstrated_to_authority, traffic_provider_of_public_network_or_service, traffic_data_relating_to_subscribers_or_users, traffic_processing_purpose, traffic_data_still_needed_for_transmission, traffic_data_necessary_for_billing_or_interconnection, traffic_billing_challenge_or_payment_period_running, traffic_marketing_provider_of_publicly_available_service, traffic_marketing_prior_consent_given, traffic_marketing_consent_withdrawn, traffic_marketing_processing_within_necessary_extent_and_duration, location_data_other_than_traffic_data_in_scope, location_data_made_anonymous, location_consent_given, location_consent_withdrawn, location_processing_within_necessary_extent_and_duration_for_value_added_service, location_processing_temporarily_refused, marketing_communication_for_direct_marketing, marketing_subscriber_is_natural_person, marketing_communication_means, marketing_prior_consent_given, marketing_contact_details_obtained_from_customer_in_sale, marketing_sender_obtained_the_contact_details, marketing_own_similar_products_or_services, marketing_objection_offered_at_collection, marketing_objection_offered_in_each_message, marketing_customer_refused_or_objected, email_sender_identity_disguised_or_concealed, email_contravenes_electronic_commerce_directive_article_6, email_valid_cessation_address_provided, email_encourages_visiting_contravening_websites].
test(what_if_keeps_the_baseline_when_the_value_is_unchanged) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    findall(Status, eprivacy_breach_traffic_location_marketing_what_if(Profile, traffic_billing_challenge_or_payment_period_running, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_a_running_period_flips_to_eligible) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    findall(Status, eprivacy_breach_traffic_location_marketing_what_if(Profile, traffic_billing_challenge_or_payment_period_running, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_adds_an_absent_key) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_missing_likelihood, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, breach_likely_to_adversely_affect_subscriber_or_individual, false, Status),
    Status == eligible.
test(what_if_names_the_next_missing_key) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_missing_likelihood, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, breach_likely_to_adversely_affect_subscriber_or_individual, true, Status),
    Status == indeterminate([protection_measures_demonstrated_to_authority]).
test(what_if_a_bad_value_is_an_input_problem) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_consent_route, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, location_consent_withdrawn, unsure, Status),
    Status == input_problems([wrong_type(location_consent_withdrawn)]).
test(eligibility_verdict_with_citations) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_consent_route, Profile),
    findall(Verdict, decide_eprivacy_breach_traffic_location_marketing(Profile, Verdict), Verdicts),
    Verdicts = [eprivacy_breach_traffic_location_marketing_verdict(eligible, Citations)],
    member(cite(eu_dir_2002_58_art_9_1), Citations).
test(eligibility_verdict_ineligible_for_a_prohibited_practice) :-
    eprivacy_breach_traffic_location_marketing_profile_for(email_disguised_sender, Profile),
    decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(ineligible, _)).
test(the_reexported_input_check_answers) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(favourite_colour, blue)], Problems),
    Problems == [unknown_key(favourite_colour)].
test(constructor_input_problems) :-
    input_problems([wrong_type(profile)]).
test(constructor_problem_items_destructure) :-
    Problems = [unknown_key(favourite_colour), wrong_type(profile), duplicate_key(marketing_communication_means)],
    Problems = [unknown_key(UnknownKey), wrong_type(WrongTypeKey), duplicate_key(DuplicateKey)],
    UnknownKey == favourite_colour,
    WrongTypeKey == profile,
    DuplicateKey == marketing_communication_means.
test(constructor_indeterminate_names_one_key) :-
    indeterminate([traffic_processing_purpose]).
test(constructor_needs_legal_review) :-
    needs_legal_review(open_textured(location_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([location_consent_given - unsure])]).
test(constructor_open_textured) :-
    open_textured(personal_data_breach_occurred, cite(eu_dir_2002_58_art_2_i)).
test(constructor_inputs_relied_on) :-
    inputs_relied_on([marketing_communication_means - fax]).
test(constructor_provenance_destructures) :-
    Term = provenance(limb_a_two, [cite(eu_dir_2002_58_art_4_3)]),
    Term = provenance(Clause, Citations),
    Clause == limb_a_two,
    Citations == [cite(eu_dir_2002_58_art_4_3)].

test(what_if_the_flip_is_not_ineligible, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, traffic_billing_challenge_or_payment_period_running, true, ineligible).
test(constructor_input_problems_is_never_empty, fail) :-
    input_problems([]).
test(constructor_indeterminate_is_never_empty, fail) :-
    indeterminate([]).

cp_test_names([profile_keys_are_the_contract_keys, what_if_keeps_the_baseline_when_the_value_is_unchanged, what_if_a_running_period_flips_to_eligible, what_if_adds_an_absent_key, what_if_names_the_next_missing_key, what_if_a_bad_value_is_an_input_problem, eligibility_verdict_with_citations, eligibility_verdict_ineligible_for_a_prohibited_practice, the_reexported_input_check_answers, constructor_input_problems, constructor_problem_items_destructure, constructor_indeterminate_names_one_key, constructor_needs_legal_review, constructor_open_textured, constructor_inputs_relied_on, constructor_provenance_destructures]).
cp_test_fail_names([what_if_the_flip_is_not_ineligible, constructor_input_problems_is_never_empty, constructor_indeterminate_is_never_empty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
