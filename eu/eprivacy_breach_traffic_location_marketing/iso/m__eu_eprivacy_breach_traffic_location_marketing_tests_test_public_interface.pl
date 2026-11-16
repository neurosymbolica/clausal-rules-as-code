% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [decide_eprivacy_breach_traffic_location_marketing/2, eprivacy_breach_traffic_location_marketing_status/2, eprivacy_breach_traffic_location_marketing_checklist/2, eprivacy_breach_traffic_location_marketing_decision_resolvable/1, eprivacy_breach_traffic_location_marketing_status_values/1, personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_subject/1, eprivacy_breach_traffic_location_marketing_profile_for/2, eprivacy_breach_traffic_location_marketing_assess/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_queries, [eprivacy_breach_traffic_location_marketing_what_if/4]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).

query_answer(breach, Profile, Result, Citations) :-
    personal_data_breach_notification_status(Profile, Result, Citations).
query_answer(traffic, Profile, Result, Citations) :-
    traffic_data_processing_status(Profile, Result, Citations).
query_answer(location, Profile, Result, Citations) :-
    location_data_processing_status(Profile, Result, Citations).
query_answer(marketing, Profile, Result, Citations) :-
    direct_marketing_communication_status(Profile, Result, Citations).
query_answer(practice, Profile, Result, Citations) :-
    direct_marketing_email_practice_status(Profile, Result, Citations).

answers(Subject, Query, Answers) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    findall(Result - Citations, query_answer(Query, Profile, Result, Citations), Answers).

subject_status(Subject, Status) :-
    eprivacy_breach_traffic_location_marketing_assess(Subject, eprivacy_breach_traffic_location_marketing_verdict(Status, _)).

expected_verdict(breach_individual_notification_due, eligible).
expected_verdict(breach_protection_demonstrated_control, eligible).
expected_verdict(breach_authority_required, eligible).
expected_verdict(breach_authority_not_required_control, eligible).
expected_verdict(breach_not_a_personal_data_breach, not_applicable).
expected_verdict(breach_personal_data_breach_control, eligible).
expected_verdict(breach_not_a_provider, not_applicable).
expected_verdict(breach_missing_likelihood, indeterminate([breach_likely_to_adversely_affect_subscriber_or_individual])).
expected_verdict(breach_unsure_likelihood, needs_legal_review(open_textured(breach_likely_to_adversely_affect_subscriber_or_individual, cite(eu_dir_2002_58_art_4_3)), [inputs_relied_on([breach_provider_of_publicly_available_service - true, personal_data_breach_occurred - true, authority_required_individual_notification - false, breach_likely_to_adversely_affect_subscriber_or_individual - unsure, protection_measures_demonstrated_to_authority - false])])).
expected_verdict(traffic_transmission_still_needed, eligible).
expected_verdict(traffic_transmission_no_longer_needed, ineligible).
expected_verdict(traffic_billing_within_period, eligible).
expected_verdict(traffic_billing_period_ended, ineligible).
expected_verdict(traffic_marketing_with_consent, eligible).
expected_verdict(traffic_marketing_consent_withdrawn, ineligible).
expected_verdict(traffic_marketing_network_only_provider, ineligible).
expected_verdict(traffic_other_purpose, ineligible).
expected_verdict(traffic_not_traffic_data, not_applicable).
expected_verdict(traffic_unsure_consent, needs_legal_review(open_textured(traffic_marketing_prior_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([traffic_provider_of_public_network_or_service - true, traffic_data_relating_to_subscribers_or_users - true, traffic_processing_purpose - marketing_or_value_added_service, traffic_marketing_provider_of_publicly_available_service - true, traffic_marketing_prior_consent_given - unsure, traffic_marketing_consent_withdrawn - false, traffic_marketing_processing_within_necessary_extent_and_duration - true])])).
expected_verdict(location_made_anonymous, eligible).
expected_verdict(location_not_anonymous_without_consent, ineligible).
expected_verdict(location_consent_route, eligible).
expected_verdict(location_temporarily_refused, ineligible).
expected_verdict(location_out_of_scope, not_applicable).
expected_verdict(location_missing_anonymity, indeterminate([location_data_made_anonymous])).
expected_verdict(marketing_email_with_consent, eligible).
expected_verdict(marketing_customer_exception, eligible).
expected_verdict(marketing_customer_objected_control, ineligible).
expected_verdict(marketing_other_sender_control, ineligible).
expected_verdict(marketing_fax_with_consent, eligible).
expected_verdict(marketing_fax_without_consent, ineligible).
expected_verdict(marketing_legal_person_subscriber, national_law_decides).
expected_verdict(marketing_other_means, national_law_decides).
expected_verdict(marketing_not_direct_marketing, not_applicable).
expected_verdict(email_disguised_sender, ineligible).
expected_verdict(email_no_cessation_address, ineligible).
expected_verdict(marketing_unsure_direct_marketing, needs_legal_review(open_textured(marketing_communication_for_direct_marketing, cite(eu_dir_2002_58_art_13_1)), [inputs_relied_on([marketing_communication_for_direct_marketing - unsure, marketing_subscriber_is_natural_person - true, marketing_communication_means - fax, marketing_prior_consent_given - true])])).
expected_verdict(input_unsure_boolean, input_problems([wrong_type(location_consent_withdrawn)])).
expected_verdict(input_unknown_key, input_problems([unknown_key(favourite_colour)])).
expected_verdict(input_duplicate_key, input_problems([duplicate_key(marketing_communication_means)])).

test(every_subject_has_an_expected_verdict) :-
    findall(Subject, eprivacy_breach_traffic_location_marketing_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _), ExpectedSubjects),
    Subjects == ExpectedSubjects.
test(every_subject_resolves_to_its_expected_verdict) :-
    findall(Subject - Status, expected_verdict(Subject, Status), Expected),
    findall(Subject - Status, (expected_verdict(Subject, _), subject_status(Subject, Status)), Actual),
    Actual == Expected.
test(every_subject_has_exactly_one_verdict) :-
    findall(Count, (eprivacy_breach_traffic_location_marketing_subject(Subject), findall(Verdict, eprivacy_breach_traffic_location_marketing_assess(Subject, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    sort(Counts, [1]).
test(every_final_verdict_is_cited) :-
    eprivacy_breach_traffic_location_marketing_status_values(StatusValues),
    findall(Length, (eprivacy_breach_traffic_location_marketing_subject(Subject), eprivacy_breach_traffic_location_marketing_assess(Subject, eprivacy_breach_traffic_location_marketing_verdict(Status, Citations)), member(Status, StatusValues), length(Citations, Length)), Lengths),
    min_list(Lengths, Minimum),
    Minimum >= 1.
test(the_status_values_are_the_facade_vocabulary) :-
    eprivacy_breach_traffic_location_marketing_status_values(StatusValues),
    StatusValues == [eligible, ineligible, national_law_decides, not_applicable].
test(the_eligible_email_verdict_cites_article_13) :-
    eprivacy_breach_traffic_location_marketing_assess(marketing_email_with_consent, eprivacy_breach_traffic_location_marketing_verdict(eligible, Citations)),
    member(cite(eu_dir_2002_58_art_13_1), Citations),
    member(cite(eu_dir_2002_58_art_13_4), Citations).
test(the_status_projection_agrees_with_the_verdict) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_legal_person_subscriber, Profile),
    eprivacy_breach_traffic_location_marketing_status(Profile, national_law_decides).
test(provenance_term_destructures) :-
    Term = provenance(limb_e_3, [cite(eu_dir_2002_58_art_13_4)]),
    Term = provenance(Clause, Citations),
    Clause == limb_e_3,
    Citations == [cite(eu_dir_2002_58_art_13_4)].
test(provenance_term_accepts_a_referral_clause) :-
    Term = provenance(open_textured_referral, []),
    Term = provenance(Clause, Citations),
    Clause == open_textured_referral,
    Citations == [].
test(checklist_has_five_cited_rows) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_email_with_consent, Profile),
    eprivacy_breach_traffic_location_marketing_decision_resolvable(Profile),
    eprivacy_breach_traffic_location_marketing_checklist(Profile, Items),
    length(Items, 5),
    Items = [item(personal_data_breach_notification, not_applicable, [_|_])|_],
    member(item(direct_marketing_communication, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]), Items),
    member(item(direct_marketing_email_practice, practice_not_prohibited, [cite(eu_dir_2002_58_art_13_4)]), Items).
test(what_if_consent_makes_the_fax_eligible) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_fax_without_consent, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, marketing_prior_consent_given, true, Status),
    Status == eligible.
test(what_if_no_consent_keeps_the_fax_ineligible) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_fax_without_consent, Profile),
    eprivacy_breach_traffic_location_marketing_what_if(Profile, marketing_prior_consent_given, false, ineligible).
test(a_well_formed_fixture_has_no_problem) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_customer_exception, Profile),
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, []).
test(an_unknown_key_is_named_once) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(favourite_colour, one), attribute(favourite_colour, two)], Problems),
    Problems == [unknown_key(favourite_colour)].
test(an_equal_duplicate_is_a_duplicate_key) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(location_consent_given, true), attribute(location_consent_given, true)], Problems),
    Problems == [duplicate_key(location_consent_given)].
test(an_attested_value_is_wrong_type) :-
    findall(Result - Citations, direct_marketing_communication_status([attribute(marketing_prior_consent_given, attested(true))], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(marketing_prior_consent_given)]) - []].
test(a_non_list_profile_is_wrong_type_profile) :-
    findall(Result - Citations, traffic_data_processing_status(nothing, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_non_attribute_element_is_wrong_type_profile) :-
    eprivacy_breach_traffic_location_marketing_input_problems([attribute(location_consent_given, true), location_consent_given], Problems),
    Problems == [wrong_type(profile)].
test(input_problem_fixtures_refuse_every_query) :-
    answers(input_unsure_boolean, location, Answers),
    Answers == [input_problems([wrong_type(location_consent_withdrawn)]) - []].
test(breach_individual_notification_due) :-
    answers(breach_individual_notification_due, breach, Answers),
    Answers == [authority_and_individual_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_protection_demonstrated_control_notifies_authority_only) :-
    answers(breach_protection_demonstrated_control, breach, Answers),
    Answers == [authority_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_authority_required_notifies_both) :-
    answers(breach_authority_required, breach, Answers),
    Answers == [authority_and_individual_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_authority_not_required_control_notifies_authority_only) :-
    answers(breach_authority_not_required_control, breach, Answers),
    Answers == [authority_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_not_a_personal_data_breach_is_not_applicable) :-
    answers(breach_not_a_personal_data_breach, breach, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_personal_data_breach_control_applies) :-
    answers(breach_personal_data_breach_control, breach, Answers),
    Answers == [authority_notification_due - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_not_a_provider_is_not_applicable) :-
    answers(breach_not_a_provider, breach, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_4_3)]].
test(breach_missing_likelihood_is_named) :-
    answers(breach_missing_likelihood, breach, Answers),
    Answers == [indeterminate([breach_likely_to_adversely_affect_subscriber_or_individual]) - []].
test(breach_unsure_likelihood_refers) :-
    answers(breach_unsure_likelihood, breach, [Result - Citations]),
    expected_verdict(breach_unsure_likelihood, Result),
    Citations == [].
test(traffic_transmission_still_needed_is_permitted) :-
    answers(traffic_transmission_still_needed, traffic, Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]].
test(traffic_transmission_no_longer_needed_is_not_permitted) :-
    answers(traffic_transmission_no_longer_needed, traffic, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_billing_within_period_is_permitted) :-
    answers(traffic_billing_within_period, traffic, Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]].
test(traffic_billing_period_ended_is_not_permitted) :-
    answers(traffic_billing_period_ended, traffic, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_marketing_with_consent_is_permitted) :-
    answers(traffic_marketing_with_consent, traffic, Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]].
test(traffic_marketing_consent_withdrawn_is_not_permitted) :-
    answers(traffic_marketing_consent_withdrawn, traffic, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_marketing_network_only_provider_is_not_permitted) :-
    answers(traffic_marketing_network_only_provider, traffic, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_other_purpose_is_not_permitted) :-
    answers(traffic_other_purpose, traffic, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_not_traffic_data_is_not_applicable) :-
    answers(traffic_not_traffic_data, traffic, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_6_1)]].
test(traffic_unsure_consent_refers) :-
    answers(traffic_unsure_consent, traffic, [Result - Citations]),
    expected_verdict(traffic_unsure_consent, Result),
    Citations == [].
test(location_made_anonymous_is_permitted) :-
    answers(location_made_anonymous, location, Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_9_1)]].
test(location_not_anonymous_without_consent_is_not_permitted) :-
    answers(location_not_anonymous_without_consent, location, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_9_1)]].
test(location_consent_route_is_permitted) :-
    answers(location_consent_route, location, Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_9_1)]].
test(location_temporarily_refused_is_not_permitted) :-
    answers(location_temporarily_refused, location, Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_9_1)]].
test(location_out_of_scope_is_not_applicable) :-
    answers(location_out_of_scope, location, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_9_1)]].
test(location_missing_anonymity_is_named) :-
    answers(location_missing_anonymity, location, Answers),
    Answers == [indeterminate([location_data_made_anonymous]) - []].
test(marketing_email_with_consent_is_permitted) :-
    answers(marketing_email_with_consent, marketing, Answers),
    Answers == [sending_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_customer_exception_is_permitted) :-
    answers(marketing_customer_exception, marketing, Answers),
    Answers == [sending_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_customer_objected_control_is_not_permitted) :-
    answers(marketing_customer_objected_control, marketing, Answers),
    Answers == [sending_not_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_other_sender_control_is_not_permitted) :-
    answers(marketing_other_sender_control, marketing, Answers),
    Answers == [sending_not_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_fax_with_consent_is_permitted) :-
    answers(marketing_fax_with_consent, marketing, Answers),
    Answers == [sending_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_fax_without_consent_is_not_permitted) :-
    answers(marketing_fax_without_consent, marketing, Answers),
    Answers == [sending_not_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(marketing_legal_person_subscriber_is_for_national_law) :-
    answers(marketing_legal_person_subscriber, marketing, Answers),
    Answers == [national_law_decides - [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]].
test(marketing_other_means_is_for_national_law) :-
    answers(marketing_other_means, marketing, Answers),
    Answers == [national_law_decides - [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]].
test(marketing_not_direct_marketing_is_not_applicable) :-
    answers(marketing_not_direct_marketing, marketing, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_1)]].
test(marketing_unsure_direct_marketing_refers) :-
    answers(marketing_unsure_direct_marketing, marketing, [Result - Citations]),
    expected_verdict(marketing_unsure_direct_marketing, Result),
    Citations == [].
test(email_clean_practice_is_not_prohibited) :-
    answers(marketing_email_with_consent, practice, Answers),
    Answers == [practice_not_prohibited - [cite(eu_dir_2002_58_art_13_4)]].
test(email_disguised_sender_is_prohibited) :-
    answers(email_disguised_sender, practice, Answers),
    Answers == [practice_prohibited - [cite(eu_dir_2002_58_art_13_4)]].
test(email_disguised_sender_still_has_sending_permitted) :-
    answers(email_disguised_sender, marketing, Answers),
    Answers == [sending_permitted - [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]].
test(email_no_cessation_address_is_prohibited) :-
    answers(email_no_cessation_address, practice, Answers),
    Answers == [practice_prohibited - [cite(eu_dir_2002_58_art_13_4)]].
test(email_practice_of_a_fax_is_not_applicable) :-
    answers(marketing_fax_with_consent, practice, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_4)]].
test(email_practice_unsure_direct_marketing_by_fax_is_settled) :-
    answers(marketing_unsure_direct_marketing, practice, Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_13_4)]].

test(an_eligible_subject_is_not_ineligible, fail) :-
    subject_status(marketing_fax_with_consent, ineligible).
test(an_ineligible_control_is_not_eligible, fail) :-
    subject_status(marketing_fax_without_consent, eligible).
test(breach_protection_demonstrated_control_is_not_both, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(breach_protection_demonstrated_control, Profile),
    personal_data_breach_notification_status(Profile, authority_and_individual_notification_due, _).
test(traffic_billing_period_ended_is_not_permitted_only, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(traffic_billing_period_ended, Profile),
    traffic_data_processing_status(Profile, permitted, _).
test(location_temporarily_refused_is_not_permitted_only, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(location_temporarily_refused, Profile),
    location_data_processing_status(Profile, permitted, _).
test(marketing_customer_objected_control_is_not_permitted_only, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(marketing_customer_objected_control, Profile),
    direct_marketing_communication_status(Profile, sending_permitted, _).
test(email_no_cessation_address_is_not_not_prohibited, fail) :-
    eprivacy_breach_traffic_location_marketing_profile_for(email_no_cessation_address, Profile),
    direct_marketing_email_practice_status(Profile, practice_not_prohibited, _).

cp_test_names([every_subject_has_an_expected_verdict, every_subject_resolves_to_its_expected_verdict, every_subject_has_exactly_one_verdict, every_final_verdict_is_cited, the_status_values_are_the_facade_vocabulary, the_eligible_email_verdict_cites_article_13, the_status_projection_agrees_with_the_verdict, provenance_term_destructures, provenance_term_accepts_a_referral_clause, checklist_has_five_cited_rows, what_if_consent_makes_the_fax_eligible, what_if_no_consent_keeps_the_fax_ineligible, a_well_formed_fixture_has_no_problem, an_unknown_key_is_named_once, an_equal_duplicate_is_a_duplicate_key, an_attested_value_is_wrong_type, a_non_list_profile_is_wrong_type_profile, a_non_attribute_element_is_wrong_type_profile, input_problem_fixtures_refuse_every_query, breach_individual_notification_due, breach_protection_demonstrated_control_notifies_authority_only, breach_authority_required_notifies_both, breach_authority_not_required_control_notifies_authority_only, breach_not_a_personal_data_breach_is_not_applicable, breach_personal_data_breach_control_applies, breach_not_a_provider_is_not_applicable, breach_missing_likelihood_is_named, breach_unsure_likelihood_refers, traffic_transmission_still_needed_is_permitted, traffic_transmission_no_longer_needed_is_not_permitted, traffic_billing_within_period_is_permitted, traffic_billing_period_ended_is_not_permitted, traffic_marketing_with_consent_is_permitted, traffic_marketing_consent_withdrawn_is_not_permitted, traffic_marketing_network_only_provider_is_not_permitted, traffic_other_purpose_is_not_permitted, traffic_not_traffic_data_is_not_applicable, traffic_unsure_consent_refers, location_made_anonymous_is_permitted, location_not_anonymous_without_consent_is_not_permitted, location_consent_route_is_permitted, location_temporarily_refused_is_not_permitted, location_out_of_scope_is_not_applicable, location_missing_anonymity_is_named, marketing_email_with_consent_is_permitted, marketing_customer_exception_is_permitted, marketing_customer_objected_control_is_not_permitted, marketing_other_sender_control_is_not_permitted, marketing_fax_with_consent_is_permitted, marketing_fax_without_consent_is_not_permitted, marketing_legal_person_subscriber_is_for_national_law, marketing_other_means_is_for_national_law, marketing_not_direct_marketing_is_not_applicable, marketing_unsure_direct_marketing_refers, email_clean_practice_is_not_prohibited, email_disguised_sender_is_prohibited, email_disguised_sender_still_has_sending_permitted, email_no_cessation_address_is_prohibited, email_practice_of_a_fax_is_not_applicable, email_practice_unsure_direct_marketing_by_fax_is_settled]).
cp_test_fail_names([an_eligible_subject_is_not_ineligible, an_ineligible_control_is_not_eligible, breach_protection_demonstrated_control_is_not_both, traffic_billing_period_ended_is_not_permitted_only, location_temporarily_refused_is_not_permitted_only, marketing_customer_objected_control_is_not_permitted_only, email_no_cessation_address_is_not_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
