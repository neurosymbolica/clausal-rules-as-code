% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2, gdpr_common_definitions_data_and_processing_decision_resolvable/1, gdpr_common_definitions_data_and_processing_status_values/1, data_and_processing_outside_facts/2, provenance/2, url/2, document/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2, gdpr_common_definitions_data_and_processing_assess/2]).

answer_of(Subject, Relation, Answer) :-
    gdpr_common_definitions_data_and_processing_assess(Subject, gdpr_common_definitions_data_and_processing_verdict(classification(DefinitionRows), _Citations)),
    member(definition(Relation, Answer), DefinitionRows).

problems_of(Subject, Problems, Citations) :-
    gdpr_common_definitions_data_and_processing_assess(Subject, gdpr_common_definitions_data_and_processing_verdict(input_problems(Problems), Citations)).

item_carries_citation(item(input_check, _, [])).
item_carries_citation(item(RelationName, _, [_|_])) :-
    dif(RelationName, input_check).

status_is_known(StatusValues, item(_, Status, _)) :-
    functor(Status, StatusName, _),
    member(StatusName, StatusValues).

test(the_public_interface_resolves_on_the_baseline_fixture) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(classification(DefinitionRows), [_|_])),
    length(DefinitionRows, 12).
test(checklist_and_resolvable_hold_on_the_baseline_fixture) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    gdpr_common_definitions_data_and_processing_decision_resolvable(Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, [_|_]).
test(every_subject_gets_exactly_one_verdict) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects),
    length(Subjects, 35),
    maplist(single_verdict, Subjects).
test(every_subject_has_a_cited_checklist_of_known_statuses) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects),
    gdpr_common_definitions_data_and_processing_status_values(StatusValues),
    maplist(cited_checklist(StatusValues), Subjects).
test(a_good_profile_has_twelve_checklist_items) :-
    gdpr_common_definitions_data_and_processing_profile_for(stolen_laptop_breach, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    length(Items, 12),
    member(item(personal_data_breach, met, [cite(eu_reg_2016_679_art_4_12)]), Items).
test(status_projects_the_classification) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, classification(DefinitionRows)),
    length(DefinitionRows, 12).
test(status_projects_input_problems) :-
    gdpr_common_definitions_data_and_processing_profile_for(wrong_type_profile, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, Status),
    Status == input_problems([wrong_type(natural_person_identified)]).
test(identified_customer_record_is_personal_data) :-
    answer_of(identified_customer_record, personal_data, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(unrelated_statistics_is_not_personal_data) :-
    answer_of(unrelated_statistics, personal_data, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(pseudonymous_device_identifier_is_personal_data) :-
    answer_of(pseudonymous_device_identifier, personal_data, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(anonymous_aggregate_is_not_personal_data) :-
    answer_of(anonymous_aggregate, personal_data, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_1)]).
test(unsure_identifiability_refers_personal_data) :-
    answer_of(identifiability_unsure, personal_data, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identified - false, natural_person_identifiable - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(unsure_identifiability_refers_profiling_to_point_one) :-
    answer_of(identifiability_unsure, profiling, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identified - false, natural_person_identifiable - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(empty_profile_lists_every_missing_personal_data_key) :-
    answer_of(empty_profile, personal_data, Answer),
    Answer == definition_answer(indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(customer_record_consulted_is_processing) :-
    answer_of(customer_record_consulted, processing, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(customer_record_untouched_is_not_processing) :-
    answer_of(customer_record_untouched, processing, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_2)]).
test(restricted_stored_record_is_restriction) :-
    answer_of(restricted_stored_record, restriction_of_processing, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(unmarked_stored_record_is_not_restriction) :-
    answer_of(unmarked_stored_record, restriction_of_processing, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_3)]).
test(partially_automated_profiling_is_profiling) :-
    answer_of(partially_automated_profiling, profiling, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(manual_evaluation_is_not_profiling_despite_unsure_evaluation) :-
    answer_of(manual_evaluation, profiling, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_4)]).
test(pseudonymised_research_set_is_pseudonymisation) :-
    answer_of(pseudonymised_research_set, pseudonymisation, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(research_set_key_held_together_is_not_pseudonymisation) :-
    answer_of(research_set_key_held_together, pseudonymisation, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_5)]).
test(paper_card_index_is_filing_system) :-
    answer_of(paper_card_index, filing_system, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(loose_correspondence_is_not_filing_system) :-
    answer_of(loose_correspondence, filing_system, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_6)]).
test(loosely_sorted_bundle_refers_filing_system) :-
    answer_of(loosely_sorted_bundle, filing_system, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6)), [inputs_relied_on([structured_set_accessible_by_specific_criteria - unsure])]), none, [cite(eu_reg_2016_679_art_4_6)]).
test(disclosure_to_service_provider_is_recipient) :-
    answer_of(disclosure_to_service_provider, receiving_body_is_recipient, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(inquiry_authority_is_not_recipient) :-
    answer_of(inquiry_authority, receiving_body_is_recipient, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_9)]).
test(independent_marketing_partner_is_third_party) :-
    answer_of(independent_marketing_partner, receiving_body_is_third_party, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(processor_receiving_body_is_not_third_party) :-
    answer_of(processor_receiving_body, receiving_body_is_third_party, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_10)]).
test(empty_profile_lists_every_missing_exclusion) :-
    answer_of(empty_profile, receiving_body_is_third_party, Answer),
    Answer == definition_answer(indeterminate([receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority]), none, [cite(eu_reg_2016_679_art_4_10)]).
test(clear_affirmative_agreement_meets_consent_elements) :-
    answer_of(clear_affirmative_agreement, consent_elements, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_11)]).
test(default_ticked_box_names_the_unmet_elements) :-
    answer_of(default_ticked_box, consent_elements, Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]), [cite(eu_reg_2016_679_art_4_11)]).
test(stolen_laptop_breach_is_personal_data_breach) :-
    answer_of(stolen_laptop_breach, personal_data_breach, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(blocked_intrusion_attempt_is_not_personal_data_breach) :-
    answer_of(blocked_intrusion_attempt, personal_data_breach, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_12)]).
test(attested_online_marketplace_is_information_society_service) :-
    answer_of(attested_online_marketplace, information_society_service, Answer),
    Answer == definition_answer(met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(attested_in_person_service_is_not_information_society_service) :-
    answer_of(attested_in_person_service, information_society_service, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_25)]).
test(empty_profile_refers_information_society_service) :-
    answer_of(empty_profile, information_society_service, Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([])]), none, [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)]).
test(treaty_body_is_international_organisation_by_agreement) :-
    answer_of(treaty_body, international_organisation, Answer),
    Answer == definition_answer(met, set_up_by_agreement_between_countries, [cite(eu_reg_2016_679_art_4_26)]).
test(attested_organisation_is_governed_by_public_international_law) :-
    answer_of(attested_organisation, international_organisation, Answer),
    Answer == definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)]).
test(organisation_attested_not_governed_is_not_international) :-
    answer_of(organisation_attested_not_governed, international_organisation, Answer),
    Answer == definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_26)]).
test(body_not_treaty_unattested_refers) :-
    answer_of(body_not_treaty_unattested, international_organisation, Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), [resolution(cite(public_international_law_governing_organisation), not_attempted), inputs_relied_on([body_set_up_by_agreement_between_countries - false])]), none, [cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)]).
test(empty_profile_names_the_missing_agreement_key_first) :-
    answer_of(empty_profile, international_organisation, Answer),
    Answer == definition_answer(indeterminate([body_set_up_by_agreement_between_countries]), none, [cite(eu_reg_2016_679_art_4_26)]).
test(outside_facts_list_the_attested_term_and_mark_the_absent_one) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_organisation, Profile),
    data_and_processing_outside_facts(Profile, OutsideFacts),
    OutsideFacts == [outside_fact(service_is_information_society_service, absent), outside_fact(organisation_governed_by_public_international_law, attested(true, attestation(host, moment, reason, none)))].
test(outside_facts_of_an_empty_profile_are_both_absent) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    data_and_processing_outside_facts(Profile, OutsideFacts),
    OutsideFacts == [outside_fact(service_is_information_society_service, absent), outside_fact(organisation_governed_by_public_international_law, absent)].
test(outside_facts_of_a_bad_profile_are_input_problems) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_a_list_profile, Profile),
    data_and_processing_outside_facts(Profile, OutsideFacts),
    OutsideFacts == input_problems([wrong_type(profile)]).
test(outside_facts_give_exactly_one_answer) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_online_marketplace, Profile),
    findall(OutsideFacts, data_and_processing_outside_facts(Profile, OutsideFacts), Answers),
    length(Answers, 1).
test(provenance_recognises_a_clause_and_its_citations) :-
    provenance(deciding_clause, [cite(eu_reg_2016_679_art_4_1)]).
test(url_recognises_an_address_and_retrieval_moment) :-
    url('https://eur-lex.europa.eu/', retrieved_moment).
test(document_recognises_an_upload_and_digest) :-
    document(upload_identifier, digest_value).
test(empty_profile_verdict_cites_in_vocabulary_order_target_last) :-
    gdpr_common_definitions_data_and_processing_assess(empty_profile, gdpr_common_definitions_data_and_processing_verdict(classification(_DefinitionRows), Citations)),
    Citations = [cite(eu_reg_2016_679_art_4_1)|_],
    last(Citations, cite(eu_dir_2015_1535_art_1_1_b)).
test(duplicate_key_profile_is_an_input_problem) :-
    problems_of(duplicate_key_profile, Problems, Citations),
    Problems == [duplicate_key(processing_automated)],
    Citations == [].
test(wrong_type_profile_is_an_input_problem) :-
    problems_of(wrong_type_profile, Problems, Citations),
    Problems == [wrong_type(natural_person_identified)],
    Citations == [].
test(unknown_and_unbound_keys_are_named_in_order) :-
    problems_of(unknown_and_unbound_key_profile, Problems, _Citations),
    Problems = [unknown_key(customer_loyalty_tier), unknown_key(UnboundKey)],
    var(UnboundKey).
test(not_a_list_profile_is_wrong_type_profile) :-
    problems_of(not_a_list_profile, Problems, _Citations),
    Problems == [wrong_type(profile)].
test(a_problem_profile_checklist_is_the_input_check) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_a_list_profile, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    Items == [item(input_check, input_problems([wrong_type(profile)]), [])].

single_verdict(Subject) :-
    findall(Verdict, gdpr_common_definitions_data_and_processing_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

cited_checklist(StatusValues, Subject) :-
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    gdpr_common_definitions_data_and_processing_decision_resolvable(Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_carries_citation, [FirstItem|OtherItems]),
    maplist(status_is_known(StatusValues), [FirstItem|OtherItems]).

test(unrelated_statistics_is_not_personal_data_met, fail) :-
    answer_of(unrelated_statistics, personal_data, definition_answer(met, _, _)).
test(anonymous_aggregate_is_not_personal_data_met, fail) :-
    answer_of(anonymous_aggregate, personal_data, definition_answer(met, _, _)).
test(customer_record_untouched_is_not_processing_met, fail) :-
    answer_of(customer_record_untouched, processing, definition_answer(met, _, _)).
test(unmarked_stored_record_is_not_restriction_met, fail) :-
    answer_of(unmarked_stored_record, restriction_of_processing, definition_answer(met, _, _)).
test(manual_evaluation_is_not_profiling_met, fail) :-
    answer_of(manual_evaluation, profiling, definition_answer(met, _, _)).
test(research_set_key_held_together_is_not_pseudonymisation_met, fail) :-
    answer_of(research_set_key_held_together, pseudonymisation, definition_answer(met, _, _)).
test(loose_correspondence_is_not_filing_system_met, fail) :-
    answer_of(loose_correspondence, filing_system, definition_answer(met, _, _)).
test(inquiry_authority_is_not_recipient_met, fail) :-
    answer_of(inquiry_authority, receiving_body_is_recipient, definition_answer(met, _, _)).
test(processor_receiving_body_is_not_third_party_met, fail) :-
    answer_of(processor_receiving_body, receiving_body_is_third_party, definition_answer(met, _, _)).
test(default_ticked_box_is_not_consent_met, fail) :-
    answer_of(default_ticked_box, consent_elements, definition_answer(met, _, _)).
test(blocked_intrusion_attempt_is_not_breach_met, fail) :-
    answer_of(blocked_intrusion_attempt, personal_data_breach, definition_answer(met, _, _)).
test(attested_in_person_service_is_not_service_met, fail) :-
    answer_of(attested_in_person_service, information_society_service, definition_answer(met, _, _)).
test(organisation_attested_not_governed_is_not_met, fail) :-
    answer_of(organisation_attested_not_governed, international_organisation, definition_answer(met, _, _)).
test(outside_facts_of_a_bad_profile_are_not_a_list, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_a_list_profile, Profile),
    data_and_processing_outside_facts(Profile, [_|_]).
test(provenance_without_a_clause_is_not_recognised, fail) :-
    provenance(_, [cite(eu_reg_2016_679_art_4_1)]).
test(url_without_an_address_is_not_recognised, fail) :-
    url(_, retrieved_moment).
test(document_without_an_upload_is_not_recognised, fail) :-
    document(_, digest_value).
test(a_problem_profile_gets_no_classification, fail) :-
    gdpr_common_definitions_data_and_processing_assess(wrong_type_profile, gdpr_common_definitions_data_and_processing_verdict(classification(_), _)).

cp_test_names([the_public_interface_resolves_on_the_baseline_fixture, checklist_and_resolvable_hold_on_the_baseline_fixture, every_subject_gets_exactly_one_verdict, every_subject_has_a_cited_checklist_of_known_statuses, a_good_profile_has_twelve_checklist_items, status_projects_the_classification, status_projects_input_problems, identified_customer_record_is_personal_data, unrelated_statistics_is_not_personal_data, pseudonymous_device_identifier_is_personal_data, anonymous_aggregate_is_not_personal_data, unsure_identifiability_refers_personal_data, unsure_identifiability_refers_profiling_to_point_one, empty_profile_lists_every_missing_personal_data_key, customer_record_consulted_is_processing, customer_record_untouched_is_not_processing, restricted_stored_record_is_restriction, unmarked_stored_record_is_not_restriction, partially_automated_profiling_is_profiling, manual_evaluation_is_not_profiling_despite_unsure_evaluation, pseudonymised_research_set_is_pseudonymisation, research_set_key_held_together_is_not_pseudonymisation, paper_card_index_is_filing_system, loose_correspondence_is_not_filing_system, loosely_sorted_bundle_refers_filing_system, disclosure_to_service_provider_is_recipient, inquiry_authority_is_not_recipient, independent_marketing_partner_is_third_party, processor_receiving_body_is_not_third_party, empty_profile_lists_every_missing_exclusion, clear_affirmative_agreement_meets_consent_elements, default_ticked_box_names_the_unmet_elements, stolen_laptop_breach_is_personal_data_breach, blocked_intrusion_attempt_is_not_personal_data_breach, attested_online_marketplace_is_information_society_service, attested_in_person_service_is_not_information_society_service, empty_profile_refers_information_society_service, treaty_body_is_international_organisation_by_agreement, attested_organisation_is_governed_by_public_international_law, organisation_attested_not_governed_is_not_international, body_not_treaty_unattested_refers, empty_profile_names_the_missing_agreement_key_first, outside_facts_list_the_attested_term_and_mark_the_absent_one, outside_facts_of_an_empty_profile_are_both_absent, outside_facts_of_a_bad_profile_are_input_problems, outside_facts_give_exactly_one_answer, provenance_recognises_a_clause_and_its_citations, url_recognises_an_address_and_retrieval_moment, document_recognises_an_upload_and_digest, empty_profile_verdict_cites_in_vocabulary_order_target_last, duplicate_key_profile_is_an_input_problem, wrong_type_profile_is_an_input_problem, unknown_and_unbound_keys_are_named_in_order, not_a_list_profile_is_wrong_type_profile, a_problem_profile_checklist_is_the_input_check]).
cp_test_fail_names([unrelated_statistics_is_not_personal_data_met, anonymous_aggregate_is_not_personal_data_met, customer_record_untouched_is_not_processing_met, unmarked_stored_record_is_not_restriction_met, manual_evaluation_is_not_profiling_met, research_set_key_held_together_is_not_pseudonymisation_met, loose_correspondence_is_not_filing_system_met, inquiry_authority_is_not_recipient_met, processor_receiving_body_is_not_third_party_met, default_ticked_box_is_not_consent_met, blocked_intrusion_attempt_is_not_breach_met, attested_in_person_service_is_not_service_met, organisation_attested_not_governed_is_not_met, outside_facts_of_a_bad_profile_are_not_a_list, provenance_without_a_clause_is_not_recognised, url_without_an_address_is_not_recognised, document_without_an_upload_is_not_recognised, a_problem_profile_gets_no_classification]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
