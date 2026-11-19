% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_queries, [gdpr_transfer_scc_profile_keys/1, gdpr_transfer_scc_what_if/4, gdpr_transfer_scc_reliance_check/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_profile_for/2]).

attested_value(Value, attested(Value, attestation(host_service, received_at, reason, none))).

subject_what_if(Subject, OverriddenKey, NewValue, Statuses) :-
    gdpr_transfer_scc_profile_for(Subject, Profile),
    findall(Status, gdpr_transfer_scc_what_if(Profile, OverriddenKey, NewValue, Status), Statuses).

subject_reliance(Subject, Verdicts) :-
    gdpr_transfer_scc_profile_for(Subject, Profile),
    findall(Verdict, gdpr_transfer_scc_reliance_check(Profile, Verdict), Verdicts).

test(profile_keys_are_the_contract_keys) :-
    gdpr_transfer_scc_profile_keys(ProfileKeys),
    ProfileKeys == [standard_contractual_clauses_decision_in_force, exporter_processing_subject_to_gdpr, importer_processing_subject_to_gdpr, no_reason_to_believe_local_laws_prevent_compliance, exporter_role, importer_role, standard_contractual_clauses_concluded, module_selected, clauses_modified, added_clauses_contradict_clauses, local_laws_assessment_documented, processor_combines_received_data_with_data_collected_in_union, annex_i_a_list_of_parties_completed, annex_i_b_description_of_transfer_completed, annex_i_c_competent_supervisory_authority_identified, annex_ii_measures_described_in_specific_terms, sub_processor_authorisation_option, annex_iii_list_of_sub_processors_completed].
test(profile_keys_are_eighteen_distinct_keys) :-
    gdpr_transfer_scc_profile_keys(ProfileKeys),
    length(ProfileKeys, 18),
    sort(ProfileKeys, DistinctKeys),
    length(DistinctKeys, 18).
test(the_reexported_input_check_accepts_a_fixture) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, Profile),
    gdpr_transfer_scc_input_problems(Profile, []).
test(the_reexported_input_check_names_a_bare_boolean) :-
    gdpr_transfer_scc_profile_for(bare_boolean_outside_fact, Profile),
    gdpr_transfer_scc_input_problems(Profile, [wrong_type(standard_contractual_clauses_decision_in_force)]).
test(what_if_flips_on_the_documented_assessment) :-
    subject_what_if(module_two_all_met, local_laws_assessment_documented, false, Statuses),
    Statuses == [appropriate_safeguards_not_provided].
test(what_if_keeping_a_value_keeps_the_status) :-
    subject_what_if(module_two_all_met, clauses_modified, false, Statuses),
    Statuses == [appropriate_safeguards_provided].
test(what_if_supplies_an_absent_outside_fact) :-
    attested_value(true, InForce),
    subject_what_if(decision_in_force_absent, standard_contractual_clauses_decision_in_force, InForce, Statuses),
    Statuses == [appropriate_safeguards_provided].
test(what_if_supplies_the_selected_module) :-
    subject_what_if(module_selected_absent, module_selected, module_two, Statuses),
    Statuses == [appropriate_safeguards_provided].
test(what_if_module_four_combination_brings_clause_14_in) :-
    subject_what_if(module_four_no_combination, processor_combines_received_data_with_data_collected_in_union, true, Statuses),
    Statuses == [appropriate_safeguards_not_provided].
test(what_if_an_unsure_judgement_goes_to_a_lawyer) :-
    subject_what_if(module_two_all_met, added_clauses_contradict_clauses, unsure, Statuses),
    Statuses == [needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])])].
test(what_if_keeps_the_input_problems) :-
    subject_what_if(bare_boolean_outside_fact, clauses_modified, false, Statuses),
    Statuses == [input_problems([wrong_type(standard_contractual_clauses_decision_in_force)])].
test(reliance_is_allowed_when_the_safeguard_is_provided) :-
    subject_reliance(module_two_all_met, Verdicts),
    Verdicts == [may_rely_on_clauses].
test(reliance_is_refused_when_the_safeguard_is_not_provided) :-
    subject_reliance(module_two_documentation_missing, Verdicts),
    Verdicts == [may_not_rely_on_clauses].
test(reliance_passes_a_referral_through) :-
    subject_reliance(decision_in_force_absent, Verdicts),
    Verdicts == [needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])])].
test(reliance_passes_a_missing_key_through) :-
    subject_reliance(module_selected_absent, Verdicts),
    Verdicts == [indeterminate([module_selected])].
test(reliance_passes_input_problems_through) :-
    subject_reliance(duplicate_and_unknown_keys, Verdicts),
    Verdicts == [input_problems([duplicate_key(exporter_role), unknown_key(colour)])].

test(reliance_is_not_allowed_on_an_undocumented_assessment, fail) :-
    gdpr_transfer_scc_profile_for(module_two_documentation_missing, Profile),
    gdpr_transfer_scc_reliance_check(Profile, may_rely_on_clauses).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_are_eighteen_distinct_keys, the_reexported_input_check_accepts_a_fixture, the_reexported_input_check_names_a_bare_boolean, what_if_flips_on_the_documented_assessment, what_if_keeping_a_value_keeps_the_status, what_if_supplies_an_absent_outside_fact, what_if_supplies_the_selected_module, what_if_module_four_combination_brings_clause_14_in, what_if_an_unsure_judgement_goes_to_a_lawyer, what_if_keeps_the_input_problems, reliance_is_allowed_when_the_safeguard_is_provided, reliance_is_refused_when_the_safeguard_is_not_provided, reliance_passes_a_referral_through, reliance_passes_a_missing_key_through, reliance_passes_input_problems_through]).
cp_test_fail_names([reliance_is_not_allowed_on_an_undocumented_assessment]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
