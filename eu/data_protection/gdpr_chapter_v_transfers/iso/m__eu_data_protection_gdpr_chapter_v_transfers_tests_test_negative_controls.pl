% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2, transfer_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [transfer_basis/2, transfer_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_profile_for/2]).

verdict_of(Subject, Verdict) :-
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, Verdict).

basis_of(Subject, Basis) :-
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    transfer_basis(Profile, Basis).

test(the_verdict_atoms_are_real) :-
    transfer_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues).
test(the_basis_atoms_are_real) :-
    transfer_basis_status_values(BasisValues),
    member(art45_adequacy, BasisValues),
    member(art46_safeguards, BasisValues),
    member(art49_derogation, BasisValues),
    member(none, BasisValues).
test(stage_one_positive) :-
    basis_of(adequacy_attested_true, art45_adequacy).
test(stage_one_near_miss_gets_the_missing_safeguard) :-
    verdict_of(adequacy_attested_false_alone, indeterminate([safeguard_in_place])).
test(stage_two_safeguard_positive) :-
    verdict_of(safeguard_after_adequacy_refused, eligible).
test(stage_two_safeguard_near_miss_gets_ineligible) :-
    verdict_of(no_safeguard_and_no_claim, ineligible).
test(binding_corporate_rules_positive) :-
    basis_of(binding_corporate_rules_over_refused_safeguard, art46_safeguards).
test(binding_corporate_rules_near_miss_gets_ineligible) :-
    verdict_of(binding_corporate_rules_refused, ineligible).
test(cross_reference_positive) :-
    verdict_of(refused_safeguard_without_adequacy_fact, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3)), _)).
test(cross_reference_near_miss_with_attested_false_is_eligible) :-
    verdict_of(contract_derogation, eligible).
test(point_a_positive) :-
    verdict_of(explicit_consent_derogation, eligible).
test(point_a_near_miss_gets_ineligible) :-
    verdict_of(explicit_consent_under_public_powers, ineligible).
test(point_a_absent_consent_gets_indeterminate) :-
    verdict_of(explicit_consent_not_stated, indeterminate([explicit_consent_obtained])).
test(point_b_positive) :-
    basis_of(contract_derogation, art49_derogation).
test(point_b_near_miss_gets_ineligible) :-
    verdict_of(contract_derogation_under_public_powers, ineligible).
test(point_d_positive_despite_public_powers) :-
    verdict_of(public_interest_under_public_powers, eligible).
test(point_d_near_miss_gets_ineligible) :-
    verdict_of(public_interest_refused, ineligible).
test(point_g_positive) :-
    verdict_of(public_register_derogation, eligible).
test(point_g_near_miss_gets_ineligible) :-
    verdict_of(public_register_refused_requester, ineligible).
test(second_subparagraph_positive) :-
    verdict_of(second_subparagraph_derogation, eligible).
test(second_subparagraph_near_miss_public_powers_gets_ineligible) :-
    verdict_of(second_subparagraph_under_public_powers, ineligible).
test(second_subparagraph_near_miss_met_point_gets_ineligible) :-
    verdict_of(second_subparagraph_after_public_interest, ineligible).
test(d180_positive_names_the_missing_key) :-
    verdict_of(unsure_safeguard_contract_not_stated, indeterminate([contract_necessity])).
test(d180_near_miss_refers_on_the_safeguard) :-
    verdict_of(unsure_safeguard_contract_stated, needs_legal_review(open_textured(safeguard_in_place, cite(eu_reg_2016_679_art_46)), _)).
test(input_contract_positive_reports_the_wrong_type) :-
    verdict_of(safeguard_given_wrong_atom, input_problems([wrong_type(safeguard_in_place)])).
test(input_contract_near_miss_with_true_is_eligible) :-
    verdict_of(safeguard_without_adequacy_fact, eligible).

test(stage_one_near_miss_is_not_eligible, fail) :-
    verdict_of(adequacy_attested_false_alone, eligible).
test(stage_two_safeguard_near_miss_is_not_eligible, fail) :-
    verdict_of(no_safeguard_and_no_claim, eligible).
test(binding_corporate_rules_near_miss_is_not_eligible, fail) :-
    verdict_of(binding_corporate_rules_refused, eligible).
test(cross_reference_near_miss_does_not_refer, fail) :-
    verdict_of(contract_derogation, needs_legal_review(_, _)).
test(point_a_near_miss_is_not_eligible, fail) :-
    verdict_of(explicit_consent_under_public_powers, eligible).
test(point_b_near_miss_has_no_basis, fail) :-
    basis_of(contract_derogation_under_public_powers, art49_derogation).
test(point_d_near_miss_is_not_eligible, fail) :-
    verdict_of(public_interest_refused, eligible).
test(point_g_near_miss_is_not_eligible, fail) :-
    verdict_of(public_register_refused_requester, eligible).
test(second_subparagraph_near_miss_public_powers_is_not_eligible, fail) :-
    verdict_of(second_subparagraph_under_public_powers, eligible).
test(second_subparagraph_near_miss_met_point_is_not_eligible, fail) :-
    verdict_of(second_subparagraph_after_public_interest, eligible).
test(d180_near_miss_is_not_indeterminate, fail) :-
    verdict_of(unsure_safeguard_contract_stated, indeterminate(_)).
test(input_contract_near_miss_has_no_problems, fail) :-
    verdict_of(safeguard_without_adequacy_fact, input_problems(_)).

cp_test_names([the_verdict_atoms_are_real, the_basis_atoms_are_real, stage_one_positive, stage_one_near_miss_gets_the_missing_safeguard, stage_two_safeguard_positive, stage_two_safeguard_near_miss_gets_ineligible, binding_corporate_rules_positive, binding_corporate_rules_near_miss_gets_ineligible, cross_reference_positive, cross_reference_near_miss_with_attested_false_is_eligible, point_a_positive, point_a_near_miss_gets_ineligible, point_a_absent_consent_gets_indeterminate, point_b_positive, point_b_near_miss_gets_ineligible, point_d_positive_despite_public_powers, point_d_near_miss_gets_ineligible, point_g_positive, point_g_near_miss_gets_ineligible, second_subparagraph_positive, second_subparagraph_near_miss_public_powers_gets_ineligible, second_subparagraph_near_miss_met_point_gets_ineligible, d180_positive_names_the_missing_key, d180_near_miss_refers_on_the_safeguard, input_contract_positive_reports_the_wrong_type, input_contract_near_miss_with_true_is_eligible]).
cp_test_fail_names([stage_one_near_miss_is_not_eligible, stage_two_safeguard_near_miss_is_not_eligible, binding_corporate_rules_near_miss_is_not_eligible, cross_reference_near_miss_does_not_refer, point_a_near_miss_is_not_eligible, point_b_near_miss_has_no_basis, point_d_near_miss_is_not_eligible, point_g_near_miss_is_not_eligible, second_subparagraph_near_miss_public_powers_is_not_eligible, second_subparagraph_near_miss_met_point_is_not_eligible, d180_near_miss_is_not_indeterminate, input_contract_near_miss_has_no_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
