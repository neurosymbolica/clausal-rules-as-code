% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status_values/1, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2]).

person_base([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true)]).

with_person(Extra, Profile) :-
    person_base(Base),
    append(Base, Extra, Profile).

attested_value(Value, attested(Value, attestation(host, clock, reason, none))).

test(not_met_is_a_real_status_value) :-
    gdpr_common_definitions_data_and_processing_status_values(StatusValues),
    member(not_met, StatusValues).
test(personal_data_about_a_person_is_met) :-
    personal_data([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true)], definition_answer(met, _, _)).
test(personal_data_not_about_a_person_is_not_met) :-
    personal_data([attribute(information_relates_to_natural_person, false), attribute(natural_person_identified, true)], definition_answer(not_met, _, _)).
test(personal_data_identifiable_alone_is_met) :-
    personal_data([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false), attribute(natural_person_identifiable, true)], definition_answer(met, _, _)).
test(personal_data_neither_identified_nor_identifiable_is_not_met) :-
    personal_data([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false), attribute(natural_person_identifiable, false)], definition_answer(not_met, _, _)).
test(processing_with_operation_is_met) :-
    with_person([attribute(operation_performed_on_the_data, true)], Profile),
    processing(Profile, definition_answer(met, _, _)).
test(processing_without_operation_is_not_met) :-
    with_person([attribute(operation_performed_on_the_data, false)], Profile),
    processing(Profile, definition_answer(not_met, _, _)).
test(restriction_marked_is_met) :-
    with_person([attribute(stored_data_marked_to_limit_future_processing, true)], Profile),
    restriction_of_processing(Profile, definition_answer(met, _, _)).
test(restriction_unmarked_is_not_met) :-
    with_person([attribute(stored_data_marked_to_limit_future_processing, false)], Profile),
    restriction_of_processing(Profile, definition_answer(not_met, _, _)).
test(profiling_automated_is_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(processing_automated, true), attribute(evaluates_personal_aspects_of_natural_person, true)], Profile),
    profiling(Profile, definition_answer(met, _, _)).
test(profiling_not_automated_is_not_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(processing_automated, false), attribute(evaluates_personal_aspects_of_natural_person, true)], Profile),
    profiling(Profile, definition_answer(not_met, _, _)).
test(profiling_not_evaluating_is_not_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(processing_automated, true), attribute(evaluates_personal_aspects_of_natural_person, false)], Profile),
    profiling(Profile, definition_answer(not_met, _, _)).
test(profiling_unsure_evaluation_refers) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(processing_automated, true), attribute(evaluates_personal_aspects_of_natural_person, unsure)], Profile),
    profiling(Profile, definition_answer(needs_legal_review(open_textured(evaluates_personal_aspects_of_natural_person, cite(eu_reg_2016_679_art_4_4)), [inputs_relied_on([processing_automated - true, evaluates_personal_aspects_of_natural_person - unsure])]), none, [cite(eu_reg_2016_679_art_4_4)])).
test(pseudonymisation_with_measures_is_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, true), attribute(measures_prevent_attribution, true)], Profile),
    pseudonymisation(Profile, definition_answer(met, _, _)).
test(pseudonymisation_information_not_kept_separately_is_not_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, false), attribute(measures_prevent_attribution, true)], Profile),
    pseudonymisation(Profile, definition_answer(not_met, _, _)).
test(pseudonymisation_unsure_measures_refers_citing_point_five) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(attribution_needs_additional_information, true), attribute(additional_information_kept_separately, true), attribute(measures_prevent_attribution, unsure)], Profile),
    pseudonymisation(Profile, definition_answer(needs_legal_review(open_textured(measures_prevent_attribution, cite(eu_reg_2016_679_art_4_5)), _), none, [cite(eu_reg_2016_679_art_4_5)])).
test(filing_system_structured_is_met) :-
    with_person([attribute(structured_set_accessible_by_specific_criteria, true)], Profile),
    filing_system(Profile, definition_answer(met, _, _)).
test(filing_system_unstructured_is_not_met) :-
    with_person([attribute(structured_set_accessible_by_specific_criteria, false)], Profile),
    filing_system(Profile, definition_answer(not_met, _, _)).
test(filing_system_unsure_refers_citing_point_six) :-
    with_person([attribute(structured_set_accessible_by_specific_criteria, unsure)], Profile),
    filing_system(Profile, definition_answer(needs_legal_review(open_textured(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6)), [inputs_relied_on([structured_set_accessible_by_specific_criteria - unsure])]), none, [cite(eu_reg_2016_679_art_4_6)])).
test(recipient_disclosed_is_met) :-
    with_person([attribute(data_disclosed_to_receiving_body, true), attribute(receiving_body_public_authority_in_particular_inquiry, false)], Profile),
    receiving_body_is_recipient(Profile, definition_answer(met, _, _)).
test(recipient_inquiry_authority_is_not_met) :-
    with_person([attribute(data_disclosed_to_receiving_body, true), attribute(receiving_body_public_authority_in_particular_inquiry, true)], Profile),
    receiving_body_is_recipient(Profile, definition_answer(not_met, _, _)).
test(recipient_not_disclosed_is_not_met) :-
    with_person([attribute(data_disclosed_to_receiving_body, false), attribute(receiving_body_public_authority_in_particular_inquiry, false)], Profile),
    receiving_body_is_recipient(Profile, definition_answer(not_met, _, _)).
test(third_party_outside_every_group_is_met) :-
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, false), attribute(receiving_body_is_controller_or_processor, false), attribute(receiving_body_authorised_under_direct_authority, false)], definition_answer(met, _, _)).
test(third_party_that_is_processor_is_not_met) :-
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, false), attribute(receiving_body_is_controller_or_processor, true), attribute(receiving_body_authorised_under_direct_authority, false)], definition_answer(not_met, _, _)).
test(third_party_that_is_data_subject_is_not_met) :-
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, true), attribute(receiving_body_is_controller_or_processor, false), attribute(receiving_body_authorised_under_direct_authority, false)], definition_answer(not_met, _, _)).
test(third_party_under_direct_authority_is_not_met) :-
    receiving_body_is_third_party([attribute(receiving_body_is_data_subject, false), attribute(receiving_body_is_controller_or_processor, false), attribute(receiving_body_authorised_under_direct_authority, true)], definition_answer(not_met, _, _)).
test(consent_all_elements_is_met) :-
    consent_elements([attribute(indication_freely_given, true), attribute(indication_specific, true), attribute(indication_informed, true), attribute(indication_unambiguous, true), attribute(agreement_by_statement_or_clear_affirmative_action, true)], definition_answer(met, none, _)).
test(consent_not_informed_is_not_met_and_named) :-
    consent_elements([attribute(indication_freely_given, true), attribute(indication_specific, true), attribute(indication_informed, false), attribute(indication_unambiguous, true), attribute(agreement_by_statement_or_clear_affirmative_action, true)], definition_answer(not_met, unmet_elements([indication_informed]), _)).
test(consent_unsure_element_is_not_listed_as_unmet) :-
    consent_elements([attribute(indication_freely_given, unsure), attribute(indication_specific, false), attribute(indication_informed, true), attribute(indication_unambiguous, true), attribute(agreement_by_statement_or_clear_affirmative_action, true)], definition_answer(not_met, unmet_elements([indication_specific]), _)).
test(consent_unsure_element_refers) :-
    consent_elements([attribute(indication_freely_given, unsure), attribute(indication_specific, true), attribute(indication_informed, true), attribute(indication_unambiguous, true), attribute(agreement_by_statement_or_clear_affirmative_action, true)], definition_answer(needs_legal_review(open_textured(indication_freely_given, cite(eu_reg_2016_679_art_4_11)), _), none, [cite(eu_reg_2016_679_art_4_11)])).
test(breach_with_outcome_is_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(breach_of_security, true), attribute(breach_led_to_listed_outcome, true)], Profile),
    personal_data_breach(Profile, definition_answer(met, _, _)).
test(breach_without_outcome_is_not_met) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(breach_of_security, true), attribute(breach_led_to_listed_outcome, false)], Profile),
    personal_data_breach(Profile, definition_answer(not_met, _, _)).
test(breach_unsure_security_refers_citing_point_twelve) :-
    with_person([attribute(operation_performed_on_the_data, true), attribute(breach_of_security, unsure), attribute(breach_led_to_listed_outcome, true)], Profile),
    personal_data_breach(Profile, definition_answer(needs_legal_review(open_textured(breach_of_security, cite(eu_reg_2016_679_art_4_12)), [inputs_relied_on([breach_of_security - unsure, breach_led_to_listed_outcome - true])]), none, [cite(eu_reg_2016_679_art_4_12)])).
test(information_society_service_attested_true_is_met) :-
    attested_value(true, Fact),
    information_society_service([attribute(service_is_information_society_service, Fact)], definition_answer(met, none, [cite(eu_reg_2016_679_art_4_25)])).
test(information_society_service_attested_false_is_not_met) :-
    attested_value(false, Fact),
    information_society_service([attribute(service_is_information_society_service, Fact)], definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_25)])).
test(information_society_service_absent_refers) :-
    information_society_service([], definition_answer(needs_legal_review(cross_reference_unresolved(_, _), _), none, [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)])).
test(information_society_service_bare_true_is_input_problem) :-
    information_society_service([attribute(service_is_information_society_service, true)], definition_answer(input_problems([wrong_type(service_is_information_society_service)]), none, [])).
test(international_organisation_governed_is_met) :-
    attested_value(true, Fact),
    international_organisation([attribute(organisation_governed_by_public_international_law, Fact), attribute(body_set_up_by_agreement_between_countries, false)], definition_answer(met, governed_by_public_international_law, _)).
test(international_organisation_by_agreement_is_met) :-
    attested_value(false, Fact),
    international_organisation([attribute(organisation_governed_by_public_international_law, Fact), attribute(body_set_up_by_agreement_between_countries, true)], definition_answer(met, set_up_by_agreement_between_countries, _)).
test(international_organisation_neither_is_not_met) :-
    attested_value(false, Fact),
    international_organisation([attribute(organisation_governed_by_public_international_law, Fact), attribute(body_set_up_by_agreement_between_countries, false)], definition_answer(not_met, none, _)).
test(international_organisation_absent_fact_and_no_agreement_refers) :-
    international_organisation([attribute(body_set_up_by_agreement_between_countries, false)], definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), _), _), none, _)).
test(international_organisation_absent_body_key_is_indeterminate) :-
    international_organisation([], definition_answer(indeterminate([body_set_up_by_agreement_between_countries]), none, [cite(eu_reg_2016_679_art_4_26)])).

test(personal_data_not_met_is_not_met_when_false, fail) :-
    personal_data([attribute(information_relates_to_natural_person, false)], definition_answer(met, _, _)).
test(processing_without_operation_is_not_met_fail, fail) :-
    with_person([attribute(operation_performed_on_the_data, false)], Profile),
    processing(Profile, definition_answer(met, _, _)).
test(recipient_inquiry_authority_is_not_met_fail, fail) :-
    with_person([attribute(data_disclosed_to_receiving_body, true), attribute(receiving_body_public_authority_in_particular_inquiry, true)], Profile),
    receiving_body_is_recipient(Profile, definition_answer(met, _, _)).
test(international_organisation_neither_is_not_met_fail, fail) :-
    attested_value(false, Fact),
    international_organisation([attribute(organisation_governed_by_public_international_law, Fact), attribute(body_set_up_by_agreement_between_countries, false)], definition_answer(met, _, _)).

cp_test_names([not_met_is_a_real_status_value, personal_data_about_a_person_is_met, personal_data_not_about_a_person_is_not_met, personal_data_identifiable_alone_is_met, personal_data_neither_identified_nor_identifiable_is_not_met, processing_with_operation_is_met, processing_without_operation_is_not_met, restriction_marked_is_met, restriction_unmarked_is_not_met, profiling_automated_is_met, profiling_not_automated_is_not_met, profiling_not_evaluating_is_not_met, profiling_unsure_evaluation_refers, pseudonymisation_with_measures_is_met, pseudonymisation_information_not_kept_separately_is_not_met, pseudonymisation_unsure_measures_refers_citing_point_five, filing_system_structured_is_met, filing_system_unstructured_is_not_met, filing_system_unsure_refers_citing_point_six, recipient_disclosed_is_met, recipient_inquiry_authority_is_not_met, recipient_not_disclosed_is_not_met, third_party_outside_every_group_is_met, third_party_that_is_processor_is_not_met, third_party_that_is_data_subject_is_not_met, third_party_under_direct_authority_is_not_met, consent_all_elements_is_met, consent_not_informed_is_not_met_and_named, consent_unsure_element_is_not_listed_as_unmet, consent_unsure_element_refers, breach_with_outcome_is_met, breach_without_outcome_is_not_met, breach_unsure_security_refers_citing_point_twelve, information_society_service_attested_true_is_met, information_society_service_attested_false_is_not_met, information_society_service_absent_refers, information_society_service_bare_true_is_input_problem, international_organisation_governed_is_met, international_organisation_by_agreement_is_met, international_organisation_neither_is_not_met, international_organisation_absent_fact_and_no_agreement_refers, international_organisation_absent_body_key_is_indeterminate]).
cp_test_fail_names([personal_data_not_met_is_not_met_when_false, processing_without_operation_is_not_met_fail, recipient_inquiry_authority_is_not_met_fail, international_organisation_neither_is_not_met_fail]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
