% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [processor_contract_status/2, contract_missing_stipulations/2, processor_contract_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_queries, [gdpr_processor_contract_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_profile_for/2]).

test(the_bare_status_atoms_are_the_pinned_ones) :-
    processor_contract_status_status_values(StatusValues),
    StatusValues == [eligible, ineligible, not_applicable].
test(role_false_is_not_applicable) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    processor_contract_status(Profile, not_applicable).
test(flipping_the_role_flips_the_verdict) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, processing_on_behalf_of_controller, false, not_applicable).
test(not_applicable_with_a_missing_clause_still_holds) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, false, not_applicable).
test(role_absent_is_indeterminate) :-
    gdpr_processor_contract_profile_for(role_unestablished, Profile),
    processor_contract_status(Profile, indeterminate([processing_on_behalf_of_controller])).
test(role_present_true_is_eligible_not_indeterminate) :-
    gdpr_processor_contract_profile_for(role_unestablished, Profile),
    gdpr_processor_contract_what_if(Profile, processing_on_behalf_of_controller, true, eligible).
test(role_unsure_refers) :-
    gdpr_processor_contract_profile_for(role_unsure, Profile),
    processor_contract_status(Profile, needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), _)).
test(settling_the_role_removes_the_referral) :-
    gdpr_processor_contract_profile_for(role_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, processing_on_behalf_of_controller, true, eligible).
test(determining_purposes_refers_as_deferred) :-
    gdpr_processor_contract_profile_for(processor_determines_purposes, Profile),
    processor_contract_status(Profile, needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), _)).
test(not_determining_purposes_is_eligible) :-
    gdpr_processor_contract_profile_for(processor_determines_purposes, Profile),
    gdpr_processor_contract_what_if(Profile, processor_determines_purposes_and_means, false, eligible).
test(the_gate_beats_a_missing_clause) :-
    gdpr_processor_contract_profile_for(controller_with_missing_clause, Profile),
    processor_contract_status(Profile, needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), _)).
test(purposes_unsure_refers_as_open_textured) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, processor_determines_purposes_and_means, unsure, needs_legal_review(open_textured(processor_determines_purposes_and_means, cite(eu_reg_2016_679_art_28_10)), _)).
test(purposes_absent_is_indeterminate) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    processor_contract_status(Profile, eligible),
    gdpr_processor_contract_profile_for(role_unestablished, OtherProfile),
    gdpr_processor_contract_what_if(OtherProfile, processing_on_behalf_of_controller, true, eligible).
test(a_missing_audit_clause_is_ineligible) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    processor_contract_status(Profile, ineligible),
    contract_missing_stipulations(Profile, [stipulates_information_and_audit_rights]).
test(supplying_the_audit_clause_makes_it_eligible) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, true, eligible).
test(two_missing_clauses_are_both_named) :-
    gdpr_processor_contract_profile_for(confidentiality_and_security_missing, Profile),
    contract_missing_stipulations(Profile, [stipulates_confidentiality_commitment, stipulates_security_measures]).
test(supplying_one_of_two_leaves_the_other) :-
    gdpr_processor_contract_profile_for(confidentiality_and_security_missing, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_security_measures, true, ineligible).
test(the_notice_of_infringing_instruction_is_load_bearing) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_notice_of_infringing_instruction, false, ineligible).
test(a_contract_under_third_country_law_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_governed_by_union_or_member_state_law, false, ineligible).
test(an_oral_contract_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, false, ineligible).
test(a_missing_content_element_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_sets_out_duration, false, ineligible).
test(insufficient_guarantees_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, processor_provides_sufficient_guarantees, false, ineligible).
test(a_non_binding_contract_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_binding_on_processor, false, ineligible).
test(an_absent_writing_flag_is_indeterminate) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    processor_contract_status(Profile, indeterminate([contract_in_writing])).
test(setting_the_absent_flag_true_is_eligible) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, true, eligible).
test(setting_the_absent_flag_false_is_ineligible) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, false, ineligible).
test(unmet_dominates_absent) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_security_measures, false, ineligible).
test(unsure_guarantees_refers) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    processor_contract_status(Profile, needs_legal_review(open_textured(processor_provides_sufficient_guarantees, cite(eu_reg_2016_679_art_28_1)), _)).
test(settled_true_guarantees_is_eligible) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, processor_provides_sufficient_guarantees, true, eligible).
test(settled_false_guarantees_is_ineligible) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, processor_provides_sufficient_guarantees, false, ineligible).
test(unmet_dominates_unsure) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, false, ineligible).
test(absence_precedes_judgement) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, unsure, input_problems([wrong_type(contract_in_writing)])).
test(late_specific_authorisation_is_ineligible) :-
    gdpr_processor_contract_profile_for(specific_authorisation_given_late, Profile),
    contract_missing_stipulations(Profile, [subprocessor_authorisation_given_before_engagement]).
test(timely_specific_authorisation_is_eligible) :-
    gdpr_processor_contract_profile_for(specific_authorisation_given_late, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_authorisation_given_before_engagement, true, eligible).
test(no_opportunity_to_object_is_ineligible) :-
    gdpr_processor_contract_profile_for(general_authorisation_without_opportunity_to_object, Profile),
    contract_missing_stipulations(Profile, [controller_given_opportunity_to_object]).
test(an_opportunity_to_object_is_eligible) :-
    gdpr_processor_contract_profile_for(general_authorisation_without_opportunity_to_object, Profile),
    gdpr_processor_contract_what_if(Profile, controller_given_opportunity_to_object, true, eligible).
test(no_authorisation_is_ineligible) :-
    gdpr_processor_contract_profile_for(subprocessor_engaged_without_authorisation, Profile),
    contract_missing_stipulations(Profile, [subprocessor_authorisation]).
test(specific_authorisation_without_timing_is_indeterminate) :-
    gdpr_processor_contract_profile_for(subprocessor_engaged_without_authorisation, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_authorisation, specific_written, indeterminate([subprocessor_authorisation_given_before_engagement])).
test(an_engaged_flag_false_switches_the_subprocessor_limbs_off) :-
    gdpr_processor_contract_profile_for(subprocessor_engaged_without_authorisation, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_engaged, false, eligible).
test(an_absent_engaged_flag_is_indeterminate) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_security_measures, true, eligible),
    gdpr_processor_contract_profile_for(in_writing_unestablished, OtherProfile),
    gdpr_processor_contract_what_if(OtherProfile, contract_in_writing, true, eligible).
test(unsure_subprocessor_obligations_refers) :-
    gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile),
    processor_contract_status(Profile, needs_legal_review(open_textured(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4)), _)).
test(settled_subprocessor_obligations_are_eligible) :-
    gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_obligations_same, true, eligible).
test(different_subprocessor_obligations_are_ineligible) :-
    gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_obligations_same, false, ineligible).
test(a_subprocessor_contract_under_third_country_law_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_with_specific_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_contract_governed_by_union_or_member_state_law, false, ineligible).
test(an_unwritten_subprocessor_contract_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_with_specific_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_contract_in_writing, false, ineligible).
test(a_subprocessor_without_sufficient_guarantees_is_ineligible) :-
    gdpr_processor_contract_profile_for(compliant_with_specific_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_provides_sufficient_guarantees, false, ineligible).
test(attested_standard_clauses_do_not_cure_a_missing_clause) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    gdpr_processor_contract_what_if(Profile, standard_clauses_adopted, attested(true, attestation(decision_layer, recorded_at_review, user_confirmed, none)), ineligible).
test(attested_false_standard_clauses_do_not_block) :-
    gdpr_processor_contract_profile_for(standard_clauses_attested, Profile),
    processor_contract_status(Profile, eligible),
    gdpr_processor_contract_what_if(Profile, standard_clauses_adopted, attested(false, attestation(decision_layer, recorded_at_review, user_confirmed, none)), eligible).
test(an_unknown_key_is_an_input_problem) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, bogus_key, true, input_problems([unknown_key(bogus_key)])).
test(input_problems_come_before_the_role_gate) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, unsure, input_problems([wrong_type(contract_in_writing)])).
test(a_crisp_unsure_is_an_input_problem) :-
    gdpr_processor_contract_profile_for(input_problem_in_writing_unsure, Profile),
    processor_contract_status(Profile, input_problems([wrong_type(contract_in_writing)])).

test(role_true_is_not_not_applicable, fail) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    processor_contract_status(Profile, not_applicable).
test(not_applicable_is_not_ineligible_even_with_a_missing_clause, fail) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, false, ineligible).
test(role_absent_is_not_not_applicable, fail) :-
    gdpr_processor_contract_profile_for(role_unestablished, Profile),
    processor_contract_status(Profile, not_applicable).
test(role_unsure_is_not_eligible, fail) :-
    gdpr_processor_contract_profile_for(role_unsure, Profile),
    processor_contract_status(Profile, eligible).
test(determining_purposes_is_not_eligible, fail) :-
    gdpr_processor_contract_profile_for(processor_determines_purposes, Profile),
    processor_contract_status(Profile, eligible).
test(the_gate_beating_a_missing_clause_is_not_ineligible, fail) :-
    gdpr_processor_contract_profile_for(controller_with_missing_clause, Profile),
    processor_contract_status(Profile, ineligible).
test(a_missing_audit_clause_is_not_eligible, fail) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    processor_contract_status(Profile, eligible).
test(an_absent_flag_is_not_ineligible, fail) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    processor_contract_status(Profile, ineligible).
test(unsure_guarantees_is_not_eligible, fail) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    processor_contract_status(Profile, eligible).
test(attested_standard_clauses_do_not_make_it_eligible, fail) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    gdpr_processor_contract_what_if(Profile, standard_clauses_adopted, attested(true, attestation(decision_layer, recorded_at_review, user_confirmed, none)), eligible).
test(an_unknown_key_does_not_give_a_verdict, fail) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, bogus_key, true, eligible).
test(a_judgement_unsure_in_a_crisp_key_is_not_a_referral, fail) :-
    gdpr_processor_contract_profile_for(input_problem_in_writing_unsure, Profile),
    processor_contract_status(Profile, needs_legal_review(_, _)).

cp_test_names([the_bare_status_atoms_are_the_pinned_ones, role_false_is_not_applicable, flipping_the_role_flips_the_verdict, not_applicable_with_a_missing_clause_still_holds, role_absent_is_indeterminate, role_present_true_is_eligible_not_indeterminate, role_unsure_refers, settling_the_role_removes_the_referral, determining_purposes_refers_as_deferred, not_determining_purposes_is_eligible, the_gate_beats_a_missing_clause, purposes_unsure_refers_as_open_textured, purposes_absent_is_indeterminate, a_missing_audit_clause_is_ineligible, supplying_the_audit_clause_makes_it_eligible, two_missing_clauses_are_both_named, supplying_one_of_two_leaves_the_other, the_notice_of_infringing_instruction_is_load_bearing, a_contract_under_third_country_law_is_ineligible, an_oral_contract_is_ineligible, a_missing_content_element_is_ineligible, insufficient_guarantees_is_ineligible, a_non_binding_contract_is_ineligible, an_absent_writing_flag_is_indeterminate, setting_the_absent_flag_true_is_eligible, setting_the_absent_flag_false_is_ineligible, unmet_dominates_absent, unsure_guarantees_refers, settled_true_guarantees_is_eligible, settled_false_guarantees_is_ineligible, unmet_dominates_unsure, absence_precedes_judgement, late_specific_authorisation_is_ineligible, timely_specific_authorisation_is_eligible, no_opportunity_to_object_is_ineligible, an_opportunity_to_object_is_eligible, no_authorisation_is_ineligible, specific_authorisation_without_timing_is_indeterminate, an_engaged_flag_false_switches_the_subprocessor_limbs_off, an_absent_engaged_flag_is_indeterminate, unsure_subprocessor_obligations_refers, settled_subprocessor_obligations_are_eligible, different_subprocessor_obligations_are_ineligible, a_subprocessor_contract_under_third_country_law_is_ineligible, an_unwritten_subprocessor_contract_is_ineligible, a_subprocessor_without_sufficient_guarantees_is_ineligible, attested_standard_clauses_do_not_cure_a_missing_clause, attested_false_standard_clauses_do_not_block, an_unknown_key_is_an_input_problem, input_problems_come_before_the_role_gate, a_crisp_unsure_is_an_input_problem]).
cp_test_fail_names([role_true_is_not_not_applicable, not_applicable_is_not_ineligible_even_with_a_missing_clause, role_absent_is_not_not_applicable, role_unsure_is_not_eligible, determining_purposes_is_not_eligible, the_gate_beating_a_missing_clause_is_not_ineligible, a_missing_audit_clause_is_not_eligible, an_absent_flag_is_not_ineligible, unsure_guarantees_is_not_eligible, attested_standard_clauses_do_not_make_it_eligible, an_unknown_key_does_not_give_a_verdict, a_judgement_unsure_in_a_crisp_key_is_not_a_referral]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
