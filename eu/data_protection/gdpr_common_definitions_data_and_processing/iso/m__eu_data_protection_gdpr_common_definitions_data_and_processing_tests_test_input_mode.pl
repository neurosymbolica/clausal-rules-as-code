% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, receiving_body_is_third_party/2, consent_elements/2, information_society_service/2, international_organisation/2, data_and_processing_outside_facts/2, gdpr_common_definitions_data_and_processing_status/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_profile_for/2]).

test(a_bound_met_answer_holds) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    personal_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)])).
test(a_bound_consent_ground_holds) :-
    gdpr_common_definitions_data_and_processing_profile_for(default_ticked_box, Profile),
    consent_elements(Profile, definition_answer(not_met, unmet_elements([indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]), [cite(eu_reg_2016_679_art_4_11)])).
test(a_partly_bound_status_reads_the_missing_keys) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    personal_data(Profile, definition_answer(indeterminate(MissingKeys), none, _)),
    MissingKeys == [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable].
test(a_bound_international_organisation_ground_holds) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_organisation, Profile),
    international_organisation(Profile, definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)])).
test(a_bound_facade_status_holds) :-
    gdpr_common_definitions_data_and_processing_profile_for(wrong_type_profile, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, input_problems([wrong_type(natural_person_identified)])).
test(a_bound_outside_fact_list_holds) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_online_marketplace, Profile),
    data_and_processing_outside_facts(Profile, [outside_fact(service_is_information_society_service, attested(true, attestation(host, moment, reason, none))), outside_fact(organisation_governed_by_public_international_law, absent)]).
test(processing_of_a_consulted_record_is_met) :-
    processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(operation_performed_on_the_data, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(processing_of_an_untouched_record_is_not_met) :-
    processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(operation_performed_on_the_data, false)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(processing_of_an_empty_profile_lists_every_missing_key) :-
    processing([], Answer),
    Answer == definition_answer(indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data]), none, [cite(eu_reg_2016_679_art_4_2)]).
test(restriction_of_a_marked_record_is_met) :-
    restriction_of_processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(stored_data_marked_to_limit_future_processing, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(restriction_of_an_unmarked_record_is_not_met) :-
    restriction_of_processing([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(stored_data_marked_to_limit_future_processing, false)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(pseudonymisation_of_a_separately_keyed_set_is_met) :-
    pseudonymisation([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false), attribute(natural_person_identifiable, true), attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, true), attribute(measures_prevent_attribution, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(pseudonymisation_with_the_key_held_together_is_not_met) :-
    pseudonymisation([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false), attribute(natural_person_identifiable, true), attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, false), attribute(measures_prevent_attribution, true)], Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(pseudonymisation_with_unsure_measures_refers_to_point_five) :-
    pseudonymisation([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, true), attribute(measures_prevent_attribution, unsure)], Answer),
    Answer == definition_answer(needs_legal_review(open_textured(measures_prevent_attribution, cite(eu_reg_2016_679_art_4_5)), [inputs_relied_on([attribution_needs_additional_information - true, additional_information_kept_separately - true, measures_prevent_attribution - unsure])]), none, [cite(eu_reg_2016_679_art_4_5)]).
test(a_compound_that_is_not_a_list_is_an_input_problem) :-
    personal_data(profile_record(information_relates_to_natural_person, true), Answer),
    Answer == definition_answer(input_problems([wrong_type(profile)]), none, []).
test(an_item_that_is_not_an_attribute_makes_no_profile) :-
    consent_elements([attribute(indication_specific, true), indication_informed], Answer),
    Answer == definition_answer(input_problems([wrong_type(profile)]), none, []).
test(a_word_for_a_crisp_key_is_wrong_type) :-
    profiling([attribute(processing_automated, maybe)], Answer),
    Answer == definition_answer(input_problems([wrong_type(processing_automated)]), none, []).
test(an_integer_for_a_crisp_key_is_wrong_type) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(processing_automated, 1)], Problems),
    Problems == [wrong_type(processing_automated)].
test(a_judgement_key_accepts_unsure) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(breach_of_security, unsure)], Problems),
    Problems == [].
test(a_crisp_key_rejects_unsure) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(body_set_up_by_agreement_between_countries, unsure)], Problems),
    Problems == [wrong_type(body_set_up_by_agreement_between_countries)].
test(an_outside_fact_with_an_unsure_value_is_wrong_type) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(service_is_information_society_service, attested(unsure, attestation(host, moment, reason, none)))], Problems),
    Problems == [wrong_type(service_is_information_society_service)].
test(an_outside_fact_with_a_short_attestation_is_wrong_type) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(organisation_governed_by_public_international_law, attested(true, attestation(host, moment)))], Problems),
    Problems == [wrong_type(organisation_governed_by_public_international_law)].
test(an_outside_fact_with_url_evidence_is_well_formed) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(service_is_information_society_service, attested(false, attestation(host, moment, reason, url('https://example.org/service', moment))))], Problems),
    Problems == [].
test(problems_follow_contract_order_then_unknown_keys) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(extra_key, true), attribute(body_set_up_by_agreement_between_countries, maybe), attribute(information_relates_to_natural_person, yes)], Problems),
    Problems == [wrong_type(information_relates_to_natural_person), wrong_type(body_set_up_by_agreement_between_countries), unknown_key(extra_key)].
test(an_equal_repeated_key_is_a_duplicate) :-
    gdpr_common_definitions_data_and_processing_profile_for(duplicate_key_profile, Profile),
    consent_elements(Profile, Answer),
    Answer == definition_answer(input_problems([duplicate_key(processing_automated)]), none, []).
test(repeated_unknown_keys_are_named_once_in_first_occurrence_order) :-
    international_organisation([attribute(customer_loyalty_tier, true), attribute(marketing_segment, first), attribute(marketing_segment, second), attribute(customer_loyalty_tier, false)], Answer),
    Answer == definition_answer(input_problems([unknown_key(customer_loyalty_tier), unknown_key(marketing_segment)]), none, []).
test(attribute_order_does_not_change_the_answer) :-
    personal_data([attribute(natural_person_identified, true), attribute(information_relates_to_natural_person, true)], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(an_unread_well_formed_key_does_not_change_the_answer) :-
    personal_data([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true), attribute(breach_of_security, false), attribute(service_is_information_society_service, attested(false, attestation(host, moment, reason, none)))], Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(absent_is_not_false) :-
    receiving_body_is_third_party([], AbsentAnswer),
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, false), attribute(receiving_body_is_controller_or_processor, false), attribute(receiving_body_authorised_under_direct_authority, false)], FalseAnswer),
    AbsentAnswer == definition_answer(indeterminate([receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority]), none, [cite(eu_reg_2016_679_art_4_10)]),
    FalseAnswer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(an_unread_wrong_key_still_blocks_every_relation) :-
    information_society_service([attribute(service_is_information_society_service, attested(true, attestation(host, moment, reason, none))), attribute(indication_specific, maybe)], Answer),
    Answer == definition_answer(input_problems([wrong_type(indication_specific)]), none, []).

test(a_bound_not_met_answer_is_rejected, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    personal_data(Profile, definition_answer(not_met, _, _)).
test(a_bound_wrong_citation_is_rejected, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    personal_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)])).
test(a_bound_consent_ground_in_the_wrong_order_is_rejected, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(default_ticked_box, Profile),
    consent_elements(Profile, definition_answer(not_met, unmet_elements([agreement_by_statement_or_clear_affirmative_action, indication_unambiguous]), _)).
test(the_bare_atom_indeterminate_is_never_the_status, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    personal_data(Profile, definition_answer(indeterminate, _, _)).
test(a_bound_wrong_international_organisation_ground_is_rejected, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_organisation, Profile),
    international_organisation(Profile, definition_answer(met, set_up_by_agreement_between_countries, _)).

cp_test_names([a_bound_met_answer_holds, a_bound_consent_ground_holds, a_partly_bound_status_reads_the_missing_keys, a_bound_international_organisation_ground_holds, a_bound_facade_status_holds, a_bound_outside_fact_list_holds, processing_of_a_consulted_record_is_met, processing_of_an_untouched_record_is_not_met, processing_of_an_empty_profile_lists_every_missing_key, restriction_of_a_marked_record_is_met, restriction_of_an_unmarked_record_is_not_met, pseudonymisation_of_a_separately_keyed_set_is_met, pseudonymisation_with_the_key_held_together_is_not_met, pseudonymisation_with_unsure_measures_refers_to_point_five, a_compound_that_is_not_a_list_is_an_input_problem, an_item_that_is_not_an_attribute_makes_no_profile, a_word_for_a_crisp_key_is_wrong_type, an_integer_for_a_crisp_key_is_wrong_type, a_judgement_key_accepts_unsure, a_crisp_key_rejects_unsure, an_outside_fact_with_an_unsure_value_is_wrong_type, an_outside_fact_with_a_short_attestation_is_wrong_type, an_outside_fact_with_url_evidence_is_well_formed, problems_follow_contract_order_then_unknown_keys, an_equal_repeated_key_is_a_duplicate, repeated_unknown_keys_are_named_once_in_first_occurrence_order, attribute_order_does_not_change_the_answer, an_unread_well_formed_key_does_not_change_the_answer, absent_is_not_false, an_unread_wrong_key_still_blocks_every_relation]).
cp_test_fail_names([a_bound_not_met_answer_is_rejected, a_bound_wrong_citation_is_rejected, a_bound_consent_ground_in_the_wrong_order_is_rejected, the_bare_atom_indeterminate_is_never_the_status, a_bound_wrong_international_organisation_ground_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
