% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_queries, [gdpr_common_definitions_data_and_processing_profile_keys/1, gdpr_common_definitions_data_and_processing_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2]).

item_without_citation(Subject) :-
    gdpr_common_definitions_data_and_processing_subject(Subject),
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    gdpr_common_definitions_data_and_processing_input_problems(Profile, []),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    member(item(_, _, []), Items).

test(profile_keys_are_the_contract_keys) :-
    gdpr_common_definitions_data_and_processing_profile_keys(ProfileKeys),
    ProfileKeys == [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries].
test(the_re_exported_input_check_accepts_an_empty_profile) :-
    gdpr_common_definitions_data_and_processing_input_problems([], Problems),
    Problems == [].
test(status_classifies_a_well_formed_profile) :-
    gdpr_common_definitions_data_and_processing_profile_for(clear_affirmative_agreement, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, classification(DefinitionRows)),
    member(definition(consent_elements, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_11)])), DefinitionRows).
test(status_of_a_bad_profile_is_its_problems) :-
    gdpr_common_definitions_data_and_processing_profile_for(duplicate_key_profile, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, Status),
    Status == input_problems([duplicate_key(processing_automated)]).
test(checklist_items_carry_the_point_cited) :-
    gdpr_common_definitions_data_and_processing_profile_for(stolen_laptop_breach, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    member(item(personal_data_breach, met, [cite(eu_reg_2016_679_art_4_12)]), Items).
test(what_if_lifting_the_inquiry_exception_makes_a_recipient) :-
    gdpr_common_definitions_data_and_processing_profile_for(inquiry_authority, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, receiving_body_public_authority_in_particular_inquiry, false, classification(DefinitionRows)),
    member(definition(receiving_body_is_recipient, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_9)])), DefinitionRows).
test(what_if_automating_an_unsure_evaluation_refers_it) :-
    gdpr_common_definitions_data_and_processing_profile_for(manual_evaluation, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, processing_automated, true, classification(DefinitionRows)),
    member(definition(profiling, Answer), DefinitionRows),
    Answer == definition_answer(needs_legal_review(open_textured(evaluates_personal_aspects_of_natural_person, cite(eu_reg_2016_679_art_4_4)), [inputs_relied_on([processing_automated - true, evaluates_personal_aspects_of_natural_person - unsure])]), none, [cite(eu_reg_2016_679_art_4_4)]).
test(what_if_attesting_the_outside_fact_settles_the_organisation) :-
    gdpr_common_definitions_data_and_processing_profile_for(body_not_treaty_unattested, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, organisation_governed_by_public_international_law, attested(true, attestation(host, moment, reason, none)), classification(DefinitionRows)),
    member(definition(international_organisation, definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)])), DefinitionRows).
test(what_if_with_the_same_value_changes_nothing) :-
    gdpr_common_definitions_data_and_processing_profile_for(partially_automated_profiling, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, OriginalStatus),
    gdpr_common_definitions_data_and_processing_what_if(Profile, processing_automated, true, NewStatus),
    NewStatus == OriginalStatus.
test(what_if_with_a_malformed_outside_fact_is_an_input_problem) :-
    gdpr_common_definitions_data_and_processing_what_if([], service_is_information_society_service, true, NewStatus),
    NewStatus == input_problems([wrong_type(service_is_information_society_service)]).
test(what_if_gives_exactly_one_answer_per_fixture) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    findall(NewStatus, gdpr_common_definitions_data_and_processing_what_if(Profile, body_set_up_by_agreement_between_countries, true, NewStatus), Answers),
    length(Answers, 1).

test(no_checklist_item_of_a_well_formed_profile_lacks_a_citation, fail) :-
    item_without_citation(_).
test(what_if_never_makes_the_inquiry_authority_a_recipient_unchanged, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(inquiry_authority, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, data_disclosed_to_receiving_body, true, classification(DefinitionRows)),
    member(definition(receiving_body_is_recipient, definition_answer(met, _, _)), DefinitionRows).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_accepts_an_empty_profile, status_classifies_a_well_formed_profile, status_of_a_bad_profile_is_its_problems, checklist_items_carry_the_point_cited, what_if_lifting_the_inquiry_exception_makes_a_recipient, what_if_automating_an_unsure_evaluation_refers_it, what_if_attesting_the_outside_fact_settles_the_organisation, what_if_with_the_same_value_changes_nothing, what_if_with_a_malformed_outside_fact_is_an_input_problem, what_if_gives_exactly_one_answer_per_fixture]).
cp_test_fail_names([no_checklist_item_of_a_well_formed_profile_lacks_a_citation, what_if_never_makes_the_inquiry_authority_a_recipient_unchanged]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
