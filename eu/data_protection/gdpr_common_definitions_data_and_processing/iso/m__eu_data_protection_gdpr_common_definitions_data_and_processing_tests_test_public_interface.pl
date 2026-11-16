% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2, data_and_processing_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_queries, [gdpr_common_definitions_data_and_processing_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_profile_for/2, gdpr_common_definitions_data_and_processing_assess/2]).

test(personal_data_met_for_an_identified_person) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    personal_data(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(personal_data_not_met_when_not_about_a_person) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_about_a_person, Profile),
    personal_data(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(personal_data_has_exactly_one_solution) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    findall(Answer, personal_data(Profile, Answer), Answers),
    length(Answers, 1).
test(unsure_identifiability_refers_to_the_lawyer) :-
    gdpr_common_definitions_data_and_processing_profile_for(identifiability_unsure, Profile),
    personal_data(Profile, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identified - false, natural_person_identifiable - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(processing_met_for_an_identified_person) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    processing(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(processing_missing_the_operation_is_indeterminate) :-
    gdpr_common_definitions_data_and_processing_profile_for(operation_missing, Profile),
    processing(Profile, Answer),
    Answer == definition_answer(indeterminate([operation_performed_on_the_data]), none, [cite(eu_reg_2016_679_art_4_2)]).
test(restriction_met_and_not_met_when_not_personal_data) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    restriction_of_processing(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_3)]),
    gdpr_common_definitions_data_and_processing_profile_for(not_about_a_person, Control),
    restriction_of_processing(Control, ControlAnswer),
    ControlAnswer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(filing_system_met_for_a_structured_set) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    filing_system(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(profiling_met_for_automated_evaluation) :-
    gdpr_common_definitions_data_and_processing_profile_for(automated_evaluation, Profile),
    profiling(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(profiling_not_met_for_manual_evaluation) :-
    gdpr_common_definitions_data_and_processing_profile_for(manual_evaluation, Profile),
    profiling(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(pseudonymisation_met_with_measures) :-
    gdpr_common_definitions_data_and_processing_profile_for(pseudonymised_data, Profile),
    pseudonymisation(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(pseudonymisation_not_met_without_measures) :-
    gdpr_common_definitions_data_and_processing_profile_for(attribution_without_measures, Profile),
    pseudonymisation(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(recipient_met_when_disclosed_to_another_body) :-
    gdpr_common_definitions_data_and_processing_profile_for(disclosed_to_other_body, Profile),
    receiving_body_is_recipient(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(recipient_not_met_for_an_inquiry_authority) :-
    gdpr_common_definitions_data_and_processing_profile_for(inquiry_authority, Profile),
    receiving_body_is_recipient(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(third_party_met_for_an_unrelated_body) :-
    gdpr_common_definitions_data_and_processing_profile_for(disclosed_to_other_body, Profile),
    receiving_body_is_third_party(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(third_party_not_met_for_the_processor) :-
    gdpr_common_definitions_data_and_processing_profile_for(own_processor, Profile),
    receiving_body_is_third_party(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(consent_met_with_all_five_elements) :-
    gdpr_common_definitions_data_and_processing_profile_for(full_consent, Profile),
    consent_elements(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_11)]).
test(consent_names_every_element_given_false) :-
    gdpr_common_definitions_data_and_processing_profile_for(consent_without_specificity, Profile),
    consent_elements(Profile, Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_specific, indication_unambiguous]), [cite(eu_reg_2016_679_art_4_11)]).
test(breach_met_for_a_listed_outcome) :-
    gdpr_common_definitions_data_and_processing_profile_for(breach_of_personal_data, Profile),
    personal_data_breach(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(breach_control_without_a_breach_is_not_met) :-
    gdpr_common_definitions_data_and_processing_profile_for(breach_of_personal_data, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, information_relates_to_natural_person, false, Status),
    Status == not_met,
    personal_data_breach([attribute(information_relates_to_natural_person, false)|Profile], Answer),
    Answer == definition_answer(input_problems([duplicate_key(information_relates_to_natural_person)]), none, []).
test(information_society_service_met_when_attested) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_service, Profile),
    information_society_service(Profile, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(information_society_service_not_met_when_attested_false) :-
    gdpr_common_definitions_data_and_processing_profile_for(ordinary_service, Profile),
    information_society_service(Profile, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(information_society_service_refers_when_unattested) :-
    gdpr_common_definitions_data_and_processing_profile_for(unattested_service, Profile),
    information_society_service(Profile, Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([])]), none, [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)]).
test(international_organisation_met_by_public_international_law) :-
    gdpr_common_definitions_data_and_processing_profile_for(public_international_organisation, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_met_by_agreement) :-
    gdpr_common_definitions_data_and_processing_profile_for(set_up_by_agreement, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(met, set_up_by_agreement_between_countries, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_refers_when_unattested) :-
    gdpr_common_definitions_data_and_processing_profile_for(unattested_organisation, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), [resolution(cite(public_international_law_governing_organisation), not_attempted), inputs_relied_on([body_set_up_by_agreement_between_countries - false])]), none, [cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)]).
test(outside_facts_list_the_attested_term_or_absent) :-
    gdpr_common_definitions_data_and_processing_profile_for(public_international_organisation, Profile),
    data_and_processing_outside_facts(Profile, Facts),
    Facts == [outside_fact(service_is_information_society_service, absent), outside_fact(organisation_governed_by_public_international_law, attested(true, attestation(fixture_host, fixture_clock, fixture_reason, none)))].
test(a_malformed_profile_gives_input_problems) :-
    gdpr_common_definitions_data_and_processing_profile_for(malformed_profile, Profile),
    personal_data(Profile, Answer),
    Answer == definition_answer(input_problems([wrong_type(natural_person_identified)]), none, []),
    data_and_processing_outside_facts(Profile, Facts),
    Facts == input_problems([wrong_type(natural_person_identified)]).
test(the_decision_and_status_project_personal_data) :-
    gdpr_common_definitions_data_and_processing_assess(person_identified, Verdict),
    Verdict == gdpr_common_definitions_data_and_processing_verdict(met, [cite(eu_reg_2016_679_art_4_1)]),
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, Status),
    Status == met.
test(the_checklist_has_one_cited_row_per_relation) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    length(Items, 12),
    Items = [item(personal_data, met, [cite(eu_reg_2016_679_art_4_1)])|_].
test(what_if_flips_the_status) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_about_a_person, Profile),
    gdpr_common_definitions_data_and_processing_what_if(Profile, information_relates_to_natural_person, true, Status),
    Status == met.
test(the_input_check_is_exposed) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    Problems == [].

cp_test_names([personal_data_met_for_an_identified_person, personal_data_not_met_when_not_about_a_person, personal_data_has_exactly_one_solution, unsure_identifiability_refers_to_the_lawyer, processing_met_for_an_identified_person, processing_missing_the_operation_is_indeterminate, restriction_met_and_not_met_when_not_personal_data, filing_system_met_for_a_structured_set, profiling_met_for_automated_evaluation, profiling_not_met_for_manual_evaluation, pseudonymisation_met_with_measures, pseudonymisation_not_met_without_measures, recipient_met_when_disclosed_to_another_body, recipient_not_met_for_an_inquiry_authority, third_party_met_for_an_unrelated_body, third_party_not_met_for_the_processor, consent_met_with_all_five_elements, consent_names_every_element_given_false, breach_met_for_a_listed_outcome, breach_control_without_a_breach_is_not_met, information_society_service_met_when_attested, information_society_service_not_met_when_attested_false, information_society_service_refers_when_unattested, international_organisation_met_by_public_international_law, international_organisation_met_by_agreement, international_organisation_refers_when_unattested, outside_facts_list_the_attested_term_or_absent, a_malformed_profile_gives_input_problems, the_decision_and_status_project_personal_data, the_checklist_has_one_cited_row_per_relation, what_if_flips_the_status, the_input_check_is_exposed]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
