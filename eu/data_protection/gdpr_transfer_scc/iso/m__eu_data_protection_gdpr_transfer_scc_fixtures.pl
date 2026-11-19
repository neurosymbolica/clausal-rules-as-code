% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_subject/1, gdpr_transfer_scc_profile_for/2, gdpr_transfer_scc_assess/2, gdpr_transfer_scc_expected/2, gdpr_transfer_scc_near_miss/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [decide_gdpr_transfer_scc/2]).

gdpr_transfer_scc_subject(module_two_all_met).
gdpr_transfer_scc_subject(module_two_documentation_missing).
gdpr_transfer_scc_subject(importer_subject_to_gdpr).
gdpr_transfer_scc_subject(decision_in_force_attested_false).
gdpr_transfer_scc_subject(decision_in_force_absent).
gdpr_transfer_scc_subject(module_selected_wrong).
gdpr_transfer_scc_subject(module_selected_absent).
gdpr_transfer_scc_subject(added_clauses_unsure_decisive).
gdpr_transfer_scc_subject(added_clauses_unsure_settled_elsewhere).
gdpr_transfer_scc_subject(bare_boolean_outside_fact).
gdpr_transfer_scc_subject(module_two_list_of_parties_incomplete).
gdpr_transfer_scc_subject(annex_ii_unsure).
gdpr_transfer_scc_subject(module_three_specific_authorisation_without_sub_processor_list).
gdpr_transfer_scc_subject(module_three_general_authorisation_without_sub_processor_list).
gdpr_transfer_scc_subject(module_four_no_combination).
gdpr_transfer_scc_subject(module_four_with_combination_undocumented).
gdpr_transfer_scc_subject(duplicate_and_unknown_keys).
gdpr_transfer_scc_subject(unbound_profile).

gdpr_transfer_scc_expected(module_two_all_met, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(module_two_documentation_missing, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(importer_subject_to_gdpr, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(decision_in_force_attested_false, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(decision_in_force_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])])).
gdpr_transfer_scc_expected(module_selected_wrong, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(module_selected_absent, indeterminate([module_selected])).
gdpr_transfer_scc_expected(added_clauses_unsure_decisive, needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])])).
gdpr_transfer_scc_expected(added_clauses_unsure_settled_elsewhere, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(bare_boolean_outside_fact, input_problems([wrong_type(standard_contractual_clauses_decision_in_force)])).
gdpr_transfer_scc_expected(module_two_list_of_parties_incomplete, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(annex_ii_unsure, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(module_three_specific_authorisation_without_sub_processor_list, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(module_three_general_authorisation_without_sub_processor_list, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(module_four_no_combination, appropriate_safeguards_provided).
gdpr_transfer_scc_expected(module_four_with_combination_undocumented, appropriate_safeguards_not_provided).
gdpr_transfer_scc_expected(duplicate_and_unknown_keys, input_problems([duplicate_key(exporter_role), unknown_key(colour)])).
gdpr_transfer_scc_expected(unbound_profile, input_problems([wrong_type(profile)])).

gdpr_transfer_scc_near_miss(module_two_all_met, module_two_documentation_missing).
gdpr_transfer_scc_near_miss(module_two_all_met, importer_subject_to_gdpr).
gdpr_transfer_scc_near_miss(module_two_all_met, decision_in_force_attested_false).
gdpr_transfer_scc_near_miss(module_two_all_met, decision_in_force_absent).
gdpr_transfer_scc_near_miss(module_two_all_met, module_selected_wrong).
gdpr_transfer_scc_near_miss(module_two_all_met, module_selected_absent).
gdpr_transfer_scc_near_miss(module_two_all_met, added_clauses_unsure_decisive).
gdpr_transfer_scc_near_miss(module_two_all_met, bare_boolean_outside_fact).
gdpr_transfer_scc_near_miss(added_clauses_unsure_decisive, added_clauses_unsure_settled_elsewhere).
gdpr_transfer_scc_near_miss(module_four_no_combination, module_four_with_combination_undocumented).

fixture_attested(Value, attested(Value, attestation(host_service, received_at, reason, none))).

gdpr_transfer_scc_profile_for(module_two_all_met, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_two_documentation_missing, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, false), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(importer_subject_to_gdpr, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(true, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(decision_in_force_attested_false, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(false, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(decision_in_force_absent, [attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_selected_wrong, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_one), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_selected_absent, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(added_clauses_unsure_decisive, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, unsure), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(added_clauses_unsure_settled_elsewhere, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, true), attribute(added_clauses_contradict_clauses, unsure), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(bare_boolean_outside_fact, [attribute(standard_contractual_clauses_decision_in_force, true), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_two_list_of_parties_incomplete, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, false), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(annex_ii_unsure, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_two), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, unsure), attribute(sub_processor_authorisation_option, general_written_authorisation), attribute(annex_iii_list_of_sub_processors_completed, false)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_three_specific_authorisation_without_sub_processor_list, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, processor), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_three), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, false)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_three_general_authorisation_without_sub_processor_list, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, processor), attribute(importer_role, processor), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_three), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, true), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, true), attribute(annex_ii_measures_described_in_specific_terms, true), attribute(sub_processor_authorisation_option, general_written_authorisation), attribute(annex_iii_list_of_sub_processors_completed, false)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(module_four_no_combination, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(exporter_role, processor), attribute(importer_role, controller), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_four), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, false), attribute(processor_combines_received_data_with_data_collected_in_union, false), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject).
gdpr_transfer_scc_profile_for(module_four_with_combination_undocumented, [attribute(standard_contractual_clauses_decision_in_force, InForce), attribute(exporter_processing_subject_to_gdpr, ExporterSubject), attribute(importer_processing_subject_to_gdpr, ImporterSubject), attribute(no_reason_to_believe_local_laws_prevent_compliance, NoReason), attribute(exporter_role, processor), attribute(importer_role, controller), attribute(standard_contractual_clauses_concluded, true), attribute(module_selected, module_four), attribute(clauses_modified, false), attribute(added_clauses_contradict_clauses, false), attribute(local_laws_assessment_documented, false), attribute(processor_combines_received_data_with_data_collected_in_union, true), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true)]) :-
    fixture_attested(true, InForce),
    fixture_attested(true, ExporterSubject),
    fixture_attested(false, ImporterSubject),
    fixture_attested(true, NoReason).
gdpr_transfer_scc_profile_for(duplicate_and_unknown_keys, [attribute(exporter_role, controller), attribute(exporter_role, processor), attribute(colour, red)]).
gdpr_transfer_scc_profile_for(unbound_profile, _UnboundProfile).

gdpr_transfer_scc_assess(Subject, Result) :-
    gdpr_transfer_scc_profile_for(Subject, Profile),
    decide_gdpr_transfer_scc(Profile, Result).
