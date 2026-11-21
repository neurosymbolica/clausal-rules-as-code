% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status_values/1, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_profile_for/2]).

relation_answer(personal_data, Profile, Answer) :-
    personal_data(Profile, Answer).
relation_answer(processing, Profile, Answer) :-
    processing(Profile, Answer).
relation_answer(restriction_of_processing, Profile, Answer) :-
    restriction_of_processing(Profile, Answer).
relation_answer(profiling, Profile, Answer) :-
    profiling(Profile, Answer).
relation_answer(pseudonymisation, Profile, Answer) :-
    pseudonymisation(Profile, Answer).
relation_answer(filing_system, Profile, Answer) :-
    filing_system(Profile, Answer).
relation_answer(receiving_body_is_recipient, Profile, Answer) :-
    receiving_body_is_recipient(Profile, Answer).
relation_answer(receiving_body_is_third_party, Profile, Answer) :-
    receiving_body_is_third_party(Profile, Answer).
relation_answer(consent_elements, Profile, Answer) :-
    consent_elements(Profile, Answer).
relation_answer(personal_data_breach, Profile, Answer) :-
    personal_data_breach(Profile, Answer).
relation_answer(information_society_service, Profile, Answer) :-
    information_society_service(Profile, Answer).
relation_answer(international_organisation, Profile, Answer) :-
    international_organisation(Profile, Answer).

answer_of(Subject, RelationName, Answer) :-
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    relation_answer(RelationName, Profile, Answer).

test(met_and_not_met_are_status_atoms) :-
    gdpr_common_definitions_data_and_processing_status_values(StatusValues),
    member(met, StatusValues),
    member(not_met, StatusValues).
test(identified_customer_record_is_personal_data) :-
    answer_of(identified_customer_record, personal_data, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(unrelated_statistics_are_not_personal_data) :-
    answer_of(unrelated_statistics, personal_data, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(pseudonymous_device_identifier_is_personal_data) :-
    answer_of(pseudonymous_device_identifier, personal_data, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(anonymous_aggregate_is_not_personal_data) :-
    answer_of(anonymous_aggregate, personal_data, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(consulted_record_is_processed) :-
    answer_of(customer_record_consulted, processing, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(untouched_record_is_not_processed) :-
    answer_of(customer_record_untouched, processing, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(marked_record_is_restricted) :-
    answer_of(restricted_stored_record, restriction_of_processing, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(unmarked_record_is_not_restricted) :-
    answer_of(unmarked_stored_record, restriction_of_processing, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(partly_automated_evaluation_is_profiling) :-
    answer_of(partially_automated_profiling, profiling, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(manual_evaluation_is_not_profiling) :-
    answer_of(manual_evaluation, profiling, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(separately_keyed_set_is_pseudonymised) :-
    answer_of(pseudonymised_research_set, pseudonymisation, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(key_held_together_is_not_pseudonymised) :-
    answer_of(research_set_key_held_together, pseudonymisation, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(card_index_is_a_filing_system) :-
    answer_of(paper_card_index, filing_system, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(loose_correspondence_is_not_a_filing_system) :-
    answer_of(loose_correspondence, filing_system, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(loosely_sorted_bundle_is_referred) :-
    answer_of(loosely_sorted_bundle, filing_system, definition_answer(needs_legal_review(open_textured(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6)), _), none, [cite(eu_reg_2016_679_art_4_6)])).
test(service_provider_is_a_recipient) :-
    answer_of(disclosure_to_service_provider, receiving_body_is_recipient, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(inquiry_authority_is_not_a_recipient) :-
    answer_of(inquiry_authority, receiving_body_is_recipient, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(independent_partner_is_a_third_party) :-
    answer_of(independent_marketing_partner, receiving_body_is_third_party, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(processor_is_not_a_third_party) :-
    answer_of(processor_receiving_body, receiving_body_is_third_party, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(clear_affirmative_agreement_is_consent) :-
    answer_of(clear_affirmative_agreement, consent_elements, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_11)]).
test(default_ticked_box_is_not_consent) :-
    answer_of(default_ticked_box, consent_elements, Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]), [cite(eu_reg_2016_679_art_4_11)]).
test(stolen_laptop_is_a_breach) :-
    answer_of(stolen_laptop_breach, personal_data_breach, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(blocked_intrusion_is_not_a_breach) :-
    answer_of(blocked_intrusion_attempt, personal_data_breach, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(attested_marketplace_is_an_information_society_service) :-
    answer_of(attested_online_marketplace, information_society_service, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(attested_in_person_service_is_not_one) :-
    answer_of(attested_in_person_service, information_society_service, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(an_unattested_service_is_referred) :-
    answer_of(empty_profile, information_society_service, definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), _), none, _)).
test(treaty_body_is_an_international_organisation) :-
    answer_of(treaty_body, international_organisation, Answer),
    Answer == definition_answer(met, set_up_by_agreement_between_countries, [cite(eu_reg_2016_679_art_4_26)]).
test(attested_organisation_is_an_international_organisation) :-
    answer_of(attested_organisation, international_organisation, Answer),
    Answer == definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)]).
test(attested_not_governed_body_is_not_one) :-
    answer_of(organisation_attested_not_governed, international_organisation, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_26)]).
test(unattested_non_treaty_body_is_referred) :-
    answer_of(body_not_treaty_unattested, international_organisation, definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), _), none, _)).
test(unsure_identifiability_is_referred_to_point_one) :-
    answer_of(identifiability_unsure, personal_data, definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), _), none, [cite(eu_reg_2016_679_art_4_1)])).
test(missing_keys_before_unsure) :-
    personal_data([attribute(information_relates_to_natural_person, unsure)], Answer),
    Answer == definition_answer(indeterminate([natural_person_identified, natural_person_identifiable]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(once_supplied_the_unsure_judgement_is_referred) :-
    personal_data([attribute(information_relates_to_natural_person, unsure), attribute(natural_person_identified, true)], definition_answer(needs_legal_review(open_textured(information_relates_to_natural_person, cite(eu_reg_2016_679_art_4_1)), _), none, _)).
test(a_repeated_key_blocks_the_answer) :-
    answer_of(duplicate_key_profile, profiling, Answer),
    Answer == definition_answer(input_problems([duplicate_key(processing_automated)]), none, []).
test(the_same_key_once_is_answered) :-
    profiling([attribute(processing_automated, true)], definition_answer(indeterminate(_), none, [cite(eu_reg_2016_679_art_4_4)])).

test(unrelated_statistics_are_never_met, fail) :-
    answer_of(unrelated_statistics, personal_data, definition_answer(met, _, _)).
test(anonymous_aggregate_is_never_met, fail) :-
    answer_of(anonymous_aggregate, personal_data, definition_answer(met, _, _)).
test(untouched_record_is_never_processed, fail) :-
    answer_of(customer_record_untouched, processing, definition_answer(met, _, _)).
test(unmarked_record_is_never_restricted, fail) :-
    answer_of(unmarked_stored_record, restriction_of_processing, definition_answer(met, _, _)).
test(manual_evaluation_is_never_profiling, fail) :-
    answer_of(manual_evaluation, profiling, definition_answer(met, _, _)).
test(manual_evaluation_is_not_referred, fail) :-
    answer_of(manual_evaluation, profiling, definition_answer(needs_legal_review(_, _), _, _)).
test(key_held_together_is_never_pseudonymised, fail) :-
    answer_of(research_set_key_held_together, pseudonymisation, definition_answer(met, _, _)).
test(loose_correspondence_is_never_a_filing_system, fail) :-
    answer_of(loose_correspondence, filing_system, definition_answer(met, _, _)).
test(card_index_is_not_referred, fail) :-
    answer_of(paper_card_index, filing_system, definition_answer(needs_legal_review(_, _), _, _)).
test(inquiry_authority_is_never_a_recipient, fail) :-
    answer_of(inquiry_authority, receiving_body_is_recipient, definition_answer(met, _, _)).
test(processor_is_never_a_third_party, fail) :-
    answer_of(processor_receiving_body, receiving_body_is_third_party, definition_answer(met, _, _)).
test(default_ticked_box_is_never_consent, fail) :-
    answer_of(default_ticked_box, consent_elements, definition_answer(met, _, _)).
test(default_ticked_box_ground_is_not_none, fail) :-
    answer_of(default_ticked_box, consent_elements, definition_answer(_, none, _)).
test(blocked_intrusion_is_never_a_breach, fail) :-
    answer_of(blocked_intrusion_attempt, personal_data_breach, definition_answer(met, _, _)).
test(attested_in_person_service_is_never_one, fail) :-
    answer_of(attested_in_person_service, information_society_service, definition_answer(met, _, _)).
test(an_attested_service_is_not_referred, fail) :-
    answer_of(attested_online_marketplace, information_society_service, definition_answer(needs_legal_review(_, _), _, _)).
test(attested_not_governed_body_is_never_one, fail) :-
    answer_of(organisation_attested_not_governed, international_organisation, definition_answer(met, _, _)).
test(unattested_non_treaty_body_is_never_settled, fail) :-
    answer_of(body_not_treaty_unattested, international_organisation, definition_answer(not_met, _, _)).
test(a_settled_identifiability_is_not_referred, fail) :-
    answer_of(pseudonymous_device_identifier, personal_data, definition_answer(needs_legal_review(_, _), _, _)).
test(missing_keys_are_not_referred, fail) :-
    personal_data([attribute(information_relates_to_natural_person, unsure)], definition_answer(needs_legal_review(_, _), _, _)).
test(the_same_key_once_has_no_input_problems, fail) :-
    profiling([attribute(processing_automated, true)], definition_answer(input_problems(_), _, _)).

cp_test_names([met_and_not_met_are_status_atoms, identified_customer_record_is_personal_data, unrelated_statistics_are_not_personal_data, pseudonymous_device_identifier_is_personal_data, anonymous_aggregate_is_not_personal_data, consulted_record_is_processed, untouched_record_is_not_processed, marked_record_is_restricted, unmarked_record_is_not_restricted, partly_automated_evaluation_is_profiling, manual_evaluation_is_not_profiling, separately_keyed_set_is_pseudonymised, key_held_together_is_not_pseudonymised, card_index_is_a_filing_system, loose_correspondence_is_not_a_filing_system, loosely_sorted_bundle_is_referred, service_provider_is_a_recipient, inquiry_authority_is_not_a_recipient, independent_partner_is_a_third_party, processor_is_not_a_third_party, clear_affirmative_agreement_is_consent, default_ticked_box_is_not_consent, stolen_laptop_is_a_breach, blocked_intrusion_is_not_a_breach, attested_marketplace_is_an_information_society_service, attested_in_person_service_is_not_one, an_unattested_service_is_referred, treaty_body_is_an_international_organisation, attested_organisation_is_an_international_organisation, attested_not_governed_body_is_not_one, unattested_non_treaty_body_is_referred, unsure_identifiability_is_referred_to_point_one, missing_keys_before_unsure, once_supplied_the_unsure_judgement_is_referred, a_repeated_key_blocks_the_answer, the_same_key_once_is_answered]).
cp_test_fail_names([unrelated_statistics_are_never_met, anonymous_aggregate_is_never_met, untouched_record_is_never_processed, unmarked_record_is_never_restricted, manual_evaluation_is_never_profiling, manual_evaluation_is_not_referred, key_held_together_is_never_pseudonymised, loose_correspondence_is_never_a_filing_system, card_index_is_not_referred, inquiry_authority_is_never_a_recipient, processor_is_never_a_third_party, default_ticked_box_is_never_consent, default_ticked_box_ground_is_not_none, blocked_intrusion_is_never_a_breach, attested_in_person_service_is_never_one, an_attested_service_is_not_referred, attested_not_governed_body_is_never_one, unattested_non_treaty_body_is_never_settled, a_settled_identifiability_is_not_referred, missing_keys_are_not_referred, the_same_key_once_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
