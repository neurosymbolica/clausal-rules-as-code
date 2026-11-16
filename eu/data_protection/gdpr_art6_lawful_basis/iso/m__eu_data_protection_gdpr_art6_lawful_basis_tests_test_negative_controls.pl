% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

result_of(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, Result, _, _).

compatibility_of(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    purpose_compatibility(Profile, Result, _, _).

test(the_status_table_holds_both_final_atoms) :-
    gdpr_art6_lawful_basis_status_values(StatusValues),
    StatusValues == [eligible, ineligible].
test(point_a_consent_attested_true_is_eligible) :-
    result_of(consent_claimed_attested_true, eligible).
test(point_a_consent_attested_false_is_ineligible) :-
    result_of(consent_claimed_attested_false, ineligible).
test(point_b_contract_necessary_is_eligible) :-
    result_of(contract_claimed_necessary, eligible).
test(point_b_contract_not_necessary_is_ineligible) :-
    result_of(contract_claimed_not_necessary, ineligible).
test(point_c_law_attested_true_is_eligible) :-
    result_of(legal_obligation_laid_down_by_law_true, eligible).
test(point_c_law_attested_false_is_ineligible) :-
    result_of(legal_obligation_laid_down_by_law_false, ineligible).
test(point_d_vital_interests_necessary_is_eligible) :-
    result_of(vital_interests_claimed_necessary, eligible).
test(point_d_vital_interests_not_necessary_is_ineligible) :-
    result_of(vital_interests_claimed_not_necessary, ineligible).
test(point_e_public_task_with_law_is_eligible) :-
    result_of(public_interest_task_laid_down_by_law_true, eligible).
test(point_e_public_task_not_necessary_is_ineligible) :-
    result_of(public_interest_task_not_necessary, ineligible).
test(point_f_balance_for_the_controller_is_eligible) :-
    result_of(legitimate_interests_balance_for_controller, eligible).
test(point_f_public_authority_is_ineligible) :-
    result_of(legitimate_interests_public_authority, ineligible).
test(point_f_overridden_interests_are_ineligible) :-
    result_of(legitimate_interests_overridden, ineligible).
test(claimed_contract_failing_is_ineligible_beside_vital_interests) :-
    lawful_basis_status([attribute(basis_claimed, contract), attribute(contract_necessary, false), attribute(vital_interests_necessary, true)], ineligible, [], _).
test(unclaimed_vital_interests_make_it_eligible) :-
    lawful_basis_status([attribute(contract_necessary, false), attribute(vital_interests_necessary, true)], eligible, [], _).
test(step_3a_empty_profile_names_the_contract_key) :-
    result_of(empty_profile, indeterminate([contract_necessary])).
test(step_3a_contract_stated_is_eligible) :-
    result_of(contract_alone_unclaimed, eligible).
test(step_3b_absent_consent_is_referred) :-
    result_of(consent_statement_absent_for_last_open_way, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), _)).
test(step_3b_attested_consent_is_eligible) :-
    result_of(consent_statement_attested_for_last_open_way, eligible).
test(step_4_missing_public_authority_key_is_named) :-
    result_of(public_authority_question_missing_beside_unsure, indeterminate([processing_by_public_authority_in_its_tasks])).
test(step_4_stated_key_goes_to_a_lawyer) :-
    result_of(public_task_necessity_unsure_after_authority_stated, needs_legal_review(open_textured(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)), _)).
test(step_5_absent_law_statement_is_referred) :-
    result_of(legal_obligation_unsure_law_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), _)).
test(step_5_attested_law_statement_goes_to_open_texture) :-
    result_of(legal_obligation_unsure_law_statement_attested, needs_legal_review(open_textured(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)), _)).
test(step_6_unsure_balance_goes_to_a_lawyer) :-
    result_of(legitimate_interests_balance_unsure, needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), _)).
test(step_6_balance_stated_false_is_eligible) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)], eligible, _, _).
test(step_0_wrong_type_is_an_input_problem) :-
    result_of(attested_judgement_value, input_problems([wrong_type(contract_necessary)])).
test(step_0_bare_judgement_has_no_problem) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true)], []).
test(step_0_bare_outside_fact_is_refused) :-
    result_of(bare_outside_fact_value, input_problems([wrong_type(consent_given_and_conditions_met)])).
test(step_0_attested_outside_fact_is_accepted) :-
    result_of(consent_claimed_attested_true, eligible).
test(art_6_4_not_new_purpose_is_not_engaged) :-
    compatibility_of(new_purpose_not_engaged, compatibility_test_not_engaged).
test(art_6_4_compatible) :-
    compatibility_of(new_purpose_compatible, purpose_compatible).
test(art_6_4_not_compatible) :-
    compatibility_of(new_purpose_not_compatible, purpose_not_compatible).
test(art_6_4_absent_new_purpose_is_asked) :-
    compatibility_of(new_purpose_absent, indeterminate([new_purpose_processing])).
test(art_6_4_absent_judgement_is_asked) :-
    compatibility_of(new_purpose_compatibility_absent, indeterminate([compatible_purpose])).
test(art_6_4_unsure_judgement_goes_to_a_lawyer) :-
    compatibility_of(new_purpose_compatibility_unsure, needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), _)).

test(point_a_consent_attested_false_is_not_eligible, fail) :-
    result_of(consent_claimed_attested_false, eligible).
test(point_b_contract_not_necessary_is_not_eligible, fail) :-
    result_of(contract_claimed_not_necessary, eligible).
test(point_c_necessity_alone_is_not_eligible, fail) :-
    result_of(legal_obligation_laid_down_by_law_false, eligible).
test(point_d_vital_interests_not_necessary_is_not_eligible, fail) :-
    result_of(vital_interests_claimed_not_necessary, eligible).
test(point_e_public_task_not_necessary_is_not_eligible, fail) :-
    result_of(public_interest_task_not_necessary, eligible).
test(point_f_public_authority_is_not_eligible, fail) :-
    result_of(legitimate_interests_public_authority, eligible).
test(point_f_overridden_interests_are_not_eligible, fail) :-
    result_of(legitimate_interests_overridden, eligible).
test(claimed_contract_failing_is_not_eligible, fail) :-
    lawful_basis_status([attribute(basis_claimed, contract), attribute(contract_necessary, false), attribute(vital_interests_necessary, true)], eligible, _, _).
test(step_3a_contract_stated_is_not_indeterminate, fail) :-
    result_of(contract_alone_unclaimed, indeterminate(_)).
test(step_3b_attested_consent_is_not_referred, fail) :-
    result_of(consent_statement_attested_for_last_open_way, needs_legal_review(_, _)).
test(step_3b_absent_consent_is_never_named_missing, fail) :-
    result_of(consent_statement_absent_for_last_open_way, indeterminate(_)).
test(step_4_stated_key_is_not_indeterminate, fail) :-
    result_of(public_task_necessity_unsure_after_authority_stated, indeterminate(_)).
test(step_4_missing_key_is_not_sent_to_a_lawyer, fail) :-
    result_of(public_authority_question_missing_beside_unsure, needs_legal_review(_, _)).
test(step_5_attested_law_statement_is_not_a_cross_reference, fail) :-
    result_of(legal_obligation_unsure_law_statement_attested, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(step_6_balance_stated_false_is_not_referred, fail) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)], needs_legal_review(_, _), _, _).
test(step_0_wrong_type_is_not_eligible, fail) :-
    result_of(attested_judgement_value, eligible).
test(art_6_4_not_new_purpose_is_not_a_compatibility_answer, fail) :-
    compatibility_of(new_purpose_not_engaged, purpose_not_compatible).
test(art_6_4_not_compatible_is_not_compatible, fail) :-
    compatibility_of(new_purpose_not_compatible, purpose_compatible).
test(art_6_4_absent_new_purpose_is_not_compatible, fail) :-
    compatibility_of(new_purpose_absent, purpose_compatible).
test(art_6_4_unsure_judgement_is_not_indeterminate, fail) :-
    compatibility_of(new_purpose_compatibility_unsure, indeterminate(_)).

cp_test_names([the_status_table_holds_both_final_atoms, point_a_consent_attested_true_is_eligible, point_a_consent_attested_false_is_ineligible, point_b_contract_necessary_is_eligible, point_b_contract_not_necessary_is_ineligible, point_c_law_attested_true_is_eligible, point_c_law_attested_false_is_ineligible, point_d_vital_interests_necessary_is_eligible, point_d_vital_interests_not_necessary_is_ineligible, point_e_public_task_with_law_is_eligible, point_e_public_task_not_necessary_is_ineligible, point_f_balance_for_the_controller_is_eligible, point_f_public_authority_is_ineligible, point_f_overridden_interests_are_ineligible, claimed_contract_failing_is_ineligible_beside_vital_interests, unclaimed_vital_interests_make_it_eligible, step_3a_empty_profile_names_the_contract_key, step_3a_contract_stated_is_eligible, step_3b_absent_consent_is_referred, step_3b_attested_consent_is_eligible, step_4_missing_public_authority_key_is_named, step_4_stated_key_goes_to_a_lawyer, step_5_absent_law_statement_is_referred, step_5_attested_law_statement_goes_to_open_texture, step_6_unsure_balance_goes_to_a_lawyer, step_6_balance_stated_false_is_eligible, step_0_wrong_type_is_an_input_problem, step_0_bare_judgement_has_no_problem, step_0_bare_outside_fact_is_refused, step_0_attested_outside_fact_is_accepted, art_6_4_not_new_purpose_is_not_engaged, art_6_4_compatible, art_6_4_not_compatible, art_6_4_absent_new_purpose_is_asked, art_6_4_absent_judgement_is_asked, art_6_4_unsure_judgement_goes_to_a_lawyer]).
cp_test_fail_names([point_a_consent_attested_false_is_not_eligible, point_b_contract_not_necessary_is_not_eligible, point_c_necessity_alone_is_not_eligible, point_d_vital_interests_not_necessary_is_not_eligible, point_e_public_task_not_necessary_is_not_eligible, point_f_public_authority_is_not_eligible, point_f_overridden_interests_are_not_eligible, claimed_contract_failing_is_not_eligible, step_3a_contract_stated_is_not_indeterminate, step_3b_attested_consent_is_not_referred, step_3b_absent_consent_is_never_named_missing, step_4_stated_key_is_not_indeterminate, step_4_missing_key_is_not_sent_to_a_lawyer, step_5_attested_law_statement_is_not_a_cross_reference, step_6_balance_stated_false_is_not_referred, step_0_wrong_type_is_not_eligible, art_6_4_not_new_purpose_is_not_a_compatibility_answer, art_6_4_not_compatible_is_not_compatible, art_6_4_absent_new_purpose_is_not_compatible, art_6_4_unsure_judgement_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
