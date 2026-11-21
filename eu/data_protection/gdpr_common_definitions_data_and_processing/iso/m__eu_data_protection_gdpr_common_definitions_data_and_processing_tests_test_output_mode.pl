% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status/2, gdpr_common_definitions_data_and_processing_checklist/2, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2, data_and_processing_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2]).

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

relation_names_in_order([personal_data, processing, restriction_of_processing, profiling, pseudonymisation, filing_system, receiving_body_is_recipient, receiving_body_is_third_party, consent_elements, personal_data_breach, information_society_service, international_organisation]).

single_answer(Profile, RelationName) :-
    findall(Answer, relation_answer(RelationName, Profile, Answer), Answers),
    length(Answers, 1).

subject_single_answers(Subject) :-
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    relation_names_in_order(RelationNames),
    maplist(single_answer(Profile), RelationNames).

subject_single_outside_facts(Subject) :-
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    findall(OutsideFacts, data_and_processing_outside_facts(Profile, OutsideFacts), Answers),
    length(Answers, 1).

subject_single_verdict(Subject) :-
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_common_definitions_data_and_processing(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

all_subjects(Subjects) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects).

test(every_relation_yields_exactly_one_answer_on_every_fixture) :-
    all_subjects(Subjects),
    maplist(subject_single_answers, Subjects).
test(the_outside_facts_yield_exactly_one_list_on_every_fixture) :-
    all_subjects(Subjects),
    maplist(subject_single_outside_facts, Subjects).
test(the_facade_yields_exactly_one_verdict_on_every_fixture) :-
    all_subjects(Subjects),
    maplist(subject_single_verdict, Subjects).
test(the_facade_reads_out_every_relation_in_order) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(classification(DefinitionRows), Citations)),
    findall(RelationName, member(definition(RelationName, _), DefinitionRows), RelationNames),
    relation_names_in_order(ExpectedNames),
    RelationNames == ExpectedNames,
    Citations == [cite(eu_reg_2016_679_art_4_1), cite(eu_reg_2016_679_art_4_2), cite(eu_reg_2016_679_art_4_3), cite(eu_reg_2016_679_art_4_4), cite(eu_reg_2016_679_art_4_5), cite(eu_reg_2016_679_art_4_6), cite(eu_reg_2016_679_art_4_9), cite(eu_reg_2016_679_art_4_10), cite(eu_reg_2016_679_art_4_11), cite(eu_reg_2016_679_art_4_12), cite(eu_reg_2016_679_art_4_25), cite(eu_reg_2016_679_art_4_26), cite(eu_dir_2015_1535_art_1_1_b)].
test(the_checklist_reads_out_one_cited_item_per_relation) :-
    gdpr_common_definitions_data_and_processing_profile_for(identified_customer_record, Profile),
    gdpr_common_definitions_data_and_processing_checklist(Profile, Items),
    length(Items, 12),
    member(item(personal_data, met, [cite(eu_reg_2016_679_art_4_1)]), Items),
    member(item(processing, indeterminate([operation_performed_on_the_data]), [cite(eu_reg_2016_679_art_4_2)]), Items),
    member(item(information_society_service, needs_legal_review(_, _), [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)]), Items).
test(consent_reads_out_the_elements_given_false) :-
    gdpr_common_definitions_data_and_processing_profile_for(default_ticked_box, Profile),
    consent_elements(Profile, Answer),
    Answer == definition_answer(not_met, unmet_elements([indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]), [cite(eu_reg_2016_679_art_4_11)]).
test(international_organisation_reads_out_the_agreement_ground) :-
    gdpr_common_definitions_data_and_processing_profile_for(treaty_body, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(met, set_up_by_agreement_between_countries, [cite(eu_reg_2016_679_art_4_26)]).
test(international_organisation_reads_out_the_public_international_law_ground) :-
    gdpr_common_definitions_data_and_processing_profile_for(attested_organisation, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(met, governed_by_public_international_law, [cite(eu_reg_2016_679_art_4_26)]).
test(a_cross_reference_reads_out_its_context) :-
    gdpr_common_definitions_data_and_processing_profile_for(body_not_treaty_unattested, Profile),
    international_organisation(Profile, Answer),
    Answer == definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), [resolution(cite(public_international_law_governing_organisation), not_attempted), inputs_relied_on([body_set_up_by_agreement_between_countries - false])]), none, [cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)]).
test(an_open_textured_referral_reads_out_its_pairs) :-
    gdpr_common_definitions_data_and_processing_profile_for(identifiability_unsure, Profile),
    profiling(Profile, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identified - false, natural_person_identifiable - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)]).
test(a_filing_system_referral_reads_out_its_one_pair) :-
    gdpr_common_definitions_data_and_processing_profile_for(loosely_sorted_bundle, Profile),
    filing_system(Profile, Answer),
    Answer == definition_answer(needs_legal_review(open_textured(structured_set_accessible_by_specific_criteria, cite(eu_reg_2016_679_art_4_6)), [inputs_relied_on([structured_set_accessible_by_specific_criteria - unsure])]), none, [cite(eu_reg_2016_679_art_4_6)]).
test(personal_data_breach_lists_every_missing_key_in_order) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    personal_data_breach(Profile, Answer),
    Answer == definition_answer(indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, breach_of_security, breach_led_to_listed_outcome]), none, [cite(eu_reg_2016_679_art_4_12)]).
test(recipient_lists_every_missing_key_in_order) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    receiving_body_is_recipient(Profile, Answer),
    Answer == definition_answer(indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry]), none, [cite(eu_reg_2016_679_art_4_9)]).
test(an_absent_outside_fact_is_read_out_as_absent) :-
    gdpr_common_definitions_data_and_processing_profile_for(empty_profile, Profile),
    data_and_processing_outside_facts(Profile, OutsideFacts),
    OutsideFacts == [outside_fact(service_is_information_society_service, absent), outside_fact(organisation_governed_by_public_international_law, absent)].
test(the_facade_reads_out_the_problems_of_a_bad_profile) :-
    gdpr_common_definitions_data_and_processing_profile_for(not_a_list_profile, Profile),
    gdpr_common_definitions_data_and_processing_status(Profile, Status),
    Status == input_problems([wrong_type(profile)]),
    decide_gdpr_common_definitions_data_and_processing(Profile, gdpr_common_definitions_data_and_processing_verdict(_, Citations)),
    Citations == [].

cp_test_names([every_relation_yields_exactly_one_answer_on_every_fixture, the_outside_facts_yield_exactly_one_list_on_every_fixture, the_facade_yields_exactly_one_verdict_on_every_fixture, the_facade_reads_out_every_relation_in_order, the_checklist_reads_out_one_cited_item_per_relation, consent_reads_out_the_elements_given_false, international_organisation_reads_out_the_agreement_ground, international_organisation_reads_out_the_public_international_law_ground, a_cross_reference_reads_out_its_context, an_open_textured_referral_reads_out_its_pairs, a_filing_system_referral_reads_out_its_one_pair, personal_data_breach_lists_every_missing_key_in_order, recipient_lists_every_missing_key_in_order, an_absent_outside_fact_is_read_out_as_absent, the_facade_reads_out_the_problems_of_a_bad_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
