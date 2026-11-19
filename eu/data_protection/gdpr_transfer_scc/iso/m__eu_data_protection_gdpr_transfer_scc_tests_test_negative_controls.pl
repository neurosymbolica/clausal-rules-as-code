% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [standard_contractual_clauses_module/3, standard_contractual_clauses_availability/4, standard_contractual_clauses_appendix/3, gdpr_transfer_scc_status/2, gdpr_transfer_scc_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_queries, [gdpr_transfer_scc_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_profile_for/2]).

attested_value(Value, attested(Value, attestation(host_service, received_at, reason, none))).

subject_status(Subject, Status) :-
    gdpr_transfer_scc_profile_for(Subject, Profile),
    gdpr_transfer_scc_status(Profile, Status).

all_met_what_if(OverriddenKey, NewValue, Status) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, Profile),
    gdpr_transfer_scc_what_if(Profile, OverriddenKey, NewValue, Status).

test(the_status_table_holds_both_verdict_atoms) :-
    gdpr_transfer_scc_status_values(StatusValues),
    StatusValues == [appropriate_safeguards_provided, appropriate_safeguards_not_provided].
test(all_met_provides_the_safeguard) :-
    subject_status(module_two_all_met, appropriate_safeguards_provided).
test(controller_to_processor_is_module_two) :-
    standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, processor)], module_two, _Citations).
test(controller_to_controller_is_module_one) :-
    standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, controller)], module_one, _Citations).
test(all_met_clauses_are_available) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, Profile),
    standard_contractual_clauses_availability(Profile, clauses_available, _Basis, _Citations).
test(importer_subject_clauses_are_not_available) :-
    gdpr_transfer_scc_profile_for(importer_subject_to_gdpr, Profile),
    standard_contractual_clauses_availability(Profile, clauses_not_available, _Basis, _Citations).
test(decision_not_in_force_clauses_are_not_available) :-
    gdpr_transfer_scc_profile_for(decision_in_force_attested_false, Profile),
    standard_contractual_clauses_availability(Profile, clauses_not_available, _Basis, _Citations).
test(importer_subject_refuses_the_safeguard) :-
    subject_status(importer_subject_to_gdpr, appropriate_safeguards_not_provided).
test(decision_not_in_force_refuses_the_safeguard) :-
    subject_status(decision_in_force_attested_false, appropriate_safeguards_not_provided).
test(exporter_outside_the_regulation_refuses_the_safeguard) :-
    attested_value(false, ExporterSubject),
    all_met_what_if(exporter_processing_subject_to_gdpr, ExporterSubject, appropriate_safeguards_not_provided).
test(clauses_not_concluded_refuse_the_safeguard) :-
    all_met_what_if(standard_contractual_clauses_concluded, false, appropriate_safeguards_not_provided).
test(a_wrong_module_selected_refuses_the_safeguard) :-
    subject_status(module_selected_wrong, appropriate_safeguards_not_provided).
test(an_absent_module_selected_is_named) :-
    subject_status(module_selected_absent, indeterminate([module_selected])).
test(modified_clauses_refuse_the_safeguard) :-
    all_met_what_if(clauses_modified, true, appropriate_safeguards_not_provided).
test(contradicting_added_clauses_refuse_the_safeguard) :-
    all_met_what_if(added_clauses_contradict_clauses, true, appropriate_safeguards_not_provided).
test(unsure_added_clauses_go_to_a_lawyer) :-
    subject_status(added_clauses_unsure_decisive, needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])])).
test(unsure_added_clauses_with_modified_text_are_settled) :-
    subject_status(added_clauses_unsure_settled_elsewhere, appropriate_safeguards_not_provided).
test(a_clause_14_reason_to_believe_refuses_the_safeguard) :-
    attested_value(false, NoReason),
    all_met_what_if(no_reason_to_believe_local_laws_prevent_compliance, NoReason, appropriate_safeguards_not_provided).
test(an_undocumented_assessment_refuses_the_safeguard) :-
    subject_status(module_two_documentation_missing, appropriate_safeguards_not_provided).
test(module_four_without_combination_provides) :-
    subject_status(module_four_no_combination, appropriate_safeguards_provided).
test(module_four_with_combination_undocumented_refuses) :-
    subject_status(module_four_with_combination_undocumented, appropriate_safeguards_not_provided).
test(an_absent_decision_in_force_is_referred) :-
    subject_status(decision_in_force_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])])).
test(a_bare_boolean_outside_fact_is_an_input_problem) :-
    subject_status(bare_boolean_outside_fact, input_problems([wrong_type(standard_contractual_clauses_decision_in_force)])).
test(all_met_appendix_is_complete) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(an_incomplete_list_of_parties_is_incomplete) :-
    gdpr_transfer_scc_profile_for(module_two_list_of_parties_incomplete, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_incomplete, _Citations).
test(the_specific_option_without_annex_iii_is_incomplete) :-
    gdpr_transfer_scc_profile_for(module_three_specific_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_incomplete, _Citations).
test(the_general_option_without_annex_iii_is_complete) :-
    gdpr_transfer_scc_profile_for(module_three_general_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(module_two_without_the_authority_is_incomplete) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, controller), attribute(importer_role, processor), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, false)], appendix_incomplete, _Citations).
test(module_four_without_the_authority_is_complete) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, processor), attribute(importer_role, controller), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, false)], appendix_complete, _Citations).
test(an_unsure_annex_ii_goes_to_a_lawyer) :-
    gdpr_transfer_scc_profile_for(annex_ii_unsure, Profile),
    standard_contractual_clauses_appendix(Profile, needs_legal_review(open_textured(annex_ii_measures_described_in_specific_terms, cite(eu_dec_2021_914_annex_ii)), [inputs_relied_on([annex_ii_measures_described_in_specific_terms - unsure])]), []).

test(all_met_is_not_refused_the_safeguard, fail) :-
    subject_status(module_two_all_met, appropriate_safeguards_not_provided).
test(controller_to_controller_is_not_module_two, fail) :-
    standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, controller)], module_two, _Citations).
test(importer_subject_clauses_are_not_available_as_available, fail) :-
    gdpr_transfer_scc_profile_for(importer_subject_to_gdpr, Profile),
    standard_contractual_clauses_availability(Profile, clauses_available, _Basis, _Citations).
test(decision_not_in_force_is_not_available_as_available, fail) :-
    gdpr_transfer_scc_profile_for(decision_in_force_attested_false, Profile),
    standard_contractual_clauses_availability(Profile, clauses_available, _Basis, _Citations).
test(importer_subject_does_not_provide, fail) :-
    subject_status(importer_subject_to_gdpr, appropriate_safeguards_provided).
test(decision_not_in_force_does_not_provide, fail) :-
    subject_status(decision_in_force_attested_false, appropriate_safeguards_provided).
test(exporter_outside_the_regulation_does_not_provide, fail) :-
    attested_value(false, ExporterSubject),
    all_met_what_if(exporter_processing_subject_to_gdpr, ExporterSubject, appropriate_safeguards_provided).
test(clauses_not_concluded_do_not_provide, fail) :-
    all_met_what_if(standard_contractual_clauses_concluded, false, appropriate_safeguards_provided).
test(a_wrong_module_selected_does_not_provide, fail) :-
    subject_status(module_selected_wrong, appropriate_safeguards_provided).
test(an_absent_module_selected_does_not_provide, fail) :-
    subject_status(module_selected_absent, appropriate_safeguards_provided).
test(modified_clauses_do_not_provide, fail) :-
    all_met_what_if(clauses_modified, true, appropriate_safeguards_provided).
test(contradicting_added_clauses_do_not_provide, fail) :-
    all_met_what_if(added_clauses_contradict_clauses, true, appropriate_safeguards_provided).
test(unsure_added_clauses_with_modified_text_are_not_referred, fail) :-
    subject_status(added_clauses_unsure_settled_elsewhere, needs_legal_review(_Reason, _Context)).
test(a_clause_14_reason_to_believe_does_not_provide, fail) :-
    attested_value(false, NoReason),
    all_met_what_if(no_reason_to_believe_local_laws_prevent_compliance, NoReason, appropriate_safeguards_provided).
test(an_undocumented_assessment_does_not_provide, fail) :-
    subject_status(module_two_documentation_missing, appropriate_safeguards_provided).
test(module_four_with_combination_undocumented_does_not_provide, fail) :-
    subject_status(module_four_with_combination_undocumented, appropriate_safeguards_provided).
test(an_absent_decision_in_force_does_not_provide, fail) :-
    subject_status(decision_in_force_absent, appropriate_safeguards_provided).
test(a_bare_boolean_outside_fact_does_not_provide, fail) :-
    subject_status(bare_boolean_outside_fact, appropriate_safeguards_provided).
test(an_incomplete_list_of_parties_is_not_complete, fail) :-
    gdpr_transfer_scc_profile_for(module_two_list_of_parties_incomplete, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(the_specific_option_without_annex_iii_is_not_complete, fail) :-
    gdpr_transfer_scc_profile_for(module_three_specific_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(module_four_without_the_authority_is_not_incomplete, fail) :-
    standard_contractual_clauses_appendix([attribute(exporter_role, processor), attribute(importer_role, controller), attribute(annex_i_a_list_of_parties_completed, true), attribute(annex_i_b_description_of_transfer_completed, true), attribute(annex_i_c_competent_supervisory_authority_identified, false)], appendix_incomplete, _Citations).
test(an_unsure_annex_ii_is_not_complete, fail) :-
    gdpr_transfer_scc_profile_for(annex_ii_unsure, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).

cp_test_names([the_status_table_holds_both_verdict_atoms, all_met_provides_the_safeguard, controller_to_processor_is_module_two, controller_to_controller_is_module_one, all_met_clauses_are_available, importer_subject_clauses_are_not_available, decision_not_in_force_clauses_are_not_available, importer_subject_refuses_the_safeguard, decision_not_in_force_refuses_the_safeguard, exporter_outside_the_regulation_refuses_the_safeguard, clauses_not_concluded_refuse_the_safeguard, a_wrong_module_selected_refuses_the_safeguard, an_absent_module_selected_is_named, modified_clauses_refuse_the_safeguard, contradicting_added_clauses_refuse_the_safeguard, unsure_added_clauses_go_to_a_lawyer, unsure_added_clauses_with_modified_text_are_settled, a_clause_14_reason_to_believe_refuses_the_safeguard, an_undocumented_assessment_refuses_the_safeguard, module_four_without_combination_provides, module_four_with_combination_undocumented_refuses, an_absent_decision_in_force_is_referred, a_bare_boolean_outside_fact_is_an_input_problem, all_met_appendix_is_complete, an_incomplete_list_of_parties_is_incomplete, the_specific_option_without_annex_iii_is_incomplete, the_general_option_without_annex_iii_is_complete, module_two_without_the_authority_is_incomplete, module_four_without_the_authority_is_complete, an_unsure_annex_ii_goes_to_a_lawyer]).
cp_test_fail_names([all_met_is_not_refused_the_safeguard, controller_to_controller_is_not_module_two, importer_subject_clauses_are_not_available_as_available, decision_not_in_force_is_not_available_as_available, importer_subject_does_not_provide, decision_not_in_force_does_not_provide, exporter_outside_the_regulation_does_not_provide, clauses_not_concluded_do_not_provide, a_wrong_module_selected_does_not_provide, an_absent_module_selected_does_not_provide, modified_clauses_do_not_provide, contradicting_added_clauses_do_not_provide, unsure_added_clauses_with_modified_text_are_not_referred, a_clause_14_reason_to_believe_does_not_provide, an_undocumented_assessment_does_not_provide, module_four_with_combination_undocumented_does_not_provide, an_absent_decision_in_force_does_not_provide, a_bare_boolean_outside_fact_does_not_provide, an_incomplete_list_of_parties_is_not_complete, the_specific_option_without_annex_iii_is_not_complete, module_four_without_the_authority_is_not_incomplete, an_unsure_annex_ii_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
