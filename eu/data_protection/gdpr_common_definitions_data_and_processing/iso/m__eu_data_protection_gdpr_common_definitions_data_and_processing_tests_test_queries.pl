% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_queries, [gdpr_common_definitions_data_and_processing_profile_keys/1, gdpr_common_definitions_data_and_processing_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_common_definitions_data_and_processing_profile_keys(ProfileKeys),
    ProfileKeys == [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries].
test(there_are_twenty_six_profile_keys) :-
    gdpr_common_definitions_data_and_processing_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
test(status_met) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, met).
test(status_not_met) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_about_a_person, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, not_met).
test(status_needs_legal_review) :-
    gdpr_common_definitions_data_and_processing_profile_for(identifiability_unsure, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, needs_legal_review(open_textured(natural_person_identifiable, _), _)).
test(status_input_problems) :-
    gdpr_common_definitions_data_and_processing_profile_for(malformed_profile, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, input_problems([wrong_type(natural_person_identified)])).
test(checklist_rows_carry_cite_terms_in_relation_order) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    length(Items, 12),
    Items = [item(personal_data, met, [cite(eu_reg_2016_679_art_4_1)]), item(processing, met, [cite(eu_reg_2016_679_art_4_2)]), item(restriction_of_processing, met, [cite(eu_reg_2016_679_art_4_3)])|_].
test(checklist_of_a_malformed_profile_has_input_problem_rows) :-
    gdpr_common_definitions_data_and_processing_profile_for(malformed_profile, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, [item(personal_data, input_problems([wrong_type(natural_person_identified)]), [])|_]).
test(what_if_false_relation_flips_to_not_met) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, information_relates_to_natural_person, false, not_met).
test(what_if_resolves_the_unsure_judgement) :-
    gdpr_common_definitions_data_and_processing_profile_for(identifiability_unsure, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, natural_person_identifiable, true, met).
test(what_if_resolves_the_unsure_judgement_to_not_met) :-
    gdpr_common_definitions_data_and_processing_profile_for(identifiability_unsure, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, natural_person_identifiable, false, not_met).
test(what_if_adds_a_key_that_was_absent) :-
    gdpr_common_definitions_data_and_processing_what_if([attribute(natural_person_identified, true)], information_relates_to_natural_person, true, met).
test(what_if_with_an_unknown_key_is_an_input_problem) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, no_such_key, true, input_problems([unknown_key(no_such_key)])).
test(input_problems_empty_for_fixture) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_input_problems(Profile, []).

test(what_if_leaves_the_original_status, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, information_relates_to_natural_person, false, met).

cp_test_names([profile_keys_are_the_contract_keys, there_are_twenty_six_profile_keys, status_met, status_not_met, status_needs_legal_review, status_input_problems, checklist_rows_carry_cite_terms_in_relation_order, checklist_of_a_malformed_profile_has_input_problem_rows, what_if_false_relation_flips_to_not_met, what_if_resolves_the_unsure_judgement, what_if_resolves_the_unsure_judgement_to_not_met, what_if_adds_a_key_that_was_absent, what_if_with_an_unknown_key_is_an_input_problem, input_problems_empty_for_fixture]).
cp_test_fail_names([what_if_leaves_the_original_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
