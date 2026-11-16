% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_subject/1, gdpr_chapter_v_transfers_profile_for/2, gdpr_chapter_v_transfers_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2]).

gdpr_chapter_v_transfers_subject(adequacy_attested_true).
gdpr_chapter_v_transfers_subject(adequacy_attested_true_with_unsure_safeguard).
gdpr_chapter_v_transfers_subject(adequacy_attested_false_alone).
gdpr_chapter_v_transfers_subject(safeguard_after_adequacy_refused).
gdpr_chapter_v_transfers_subject(safeguard_without_adequacy_fact).
gdpr_chapter_v_transfers_subject(no_safeguard_and_no_claim).
gdpr_chapter_v_transfers_subject(binding_corporate_rules_over_refused_safeguard).
gdpr_chapter_v_transfers_subject(binding_corporate_rules_refused).
gdpr_chapter_v_transfers_subject(binding_corporate_rules_alone).
gdpr_chapter_v_transfers_subject(empty_profile).
gdpr_chapter_v_transfers_subject(refused_safeguard_without_adequacy_fact).
gdpr_chapter_v_transfers_subject(explicit_consent_derogation).
gdpr_chapter_v_transfers_subject(explicit_consent_under_public_powers).
gdpr_chapter_v_transfers_subject(explicit_consent_not_stated).
gdpr_chapter_v_transfers_subject(contract_derogation).
gdpr_chapter_v_transfers_subject(contract_derogation_under_public_powers).
gdpr_chapter_v_transfers_subject(public_interest_unsure).
gdpr_chapter_v_transfers_subject(public_interest_under_public_powers).
gdpr_chapter_v_transfers_subject(public_interest_refused).
gdpr_chapter_v_transfers_subject(public_register_derogation).
gdpr_chapter_v_transfers_subject(public_register_refused_requester).
gdpr_chapter_v_transfers_subject(public_register_not_public).
gdpr_chapter_v_transfers_subject(second_subparagraph_after_public_interest).
gdpr_chapter_v_transfers_subject(second_subparagraph_with_unsure_contract).
gdpr_chapter_v_transfers_subject(second_subparagraph_derogation).
gdpr_chapter_v_transfers_subject(second_subparagraph_under_public_powers).
gdpr_chapter_v_transfers_subject(second_subparagraph_consent_not_stated).
gdpr_chapter_v_transfers_subject(unsure_safeguard_contract_not_stated).
gdpr_chapter_v_transfers_subject(unsure_safeguard_contract_stated).
gdpr_chapter_v_transfers_subject(recorded_facts_with_safeguard).
gdpr_chapter_v_transfers_subject(safeguard_given_wrong_atom).
gdpr_chapter_v_transfers_subject(duplicate_safeguard_and_unknown_key).
gdpr_chapter_v_transfers_subject(profile_not_a_list).
gdpr_chapter_v_transfers_subject(binding_corporate_rules_bare_atom).
gdpr_chapter_v_transfers_subject(adequacy_attested_unsure).

fixture_attested(Value, attested(Value, attestation(fixture_host, fixture_time, fixture_reason, none))).

gdpr_chapter_v_transfers_profile_for(adequacy_attested_true, [attribute(adequacy_decision_in_force, Adequacy)]) :-
    fixture_attested(true, Adequacy).
gdpr_chapter_v_transfers_profile_for(adequacy_attested_true_with_unsure_safeguard, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, unsure)]) :-
    fixture_attested(true, Adequacy).
gdpr_chapter_v_transfers_profile_for(adequacy_attested_false_alone, [attribute(adequacy_decision_in_force, Adequacy)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(safeguard_after_adequacy_refused, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(safeguard_without_adequacy_fact, [attribute(safeguard_in_place, true)]).
gdpr_chapter_v_transfers_profile_for(no_safeguard_and_no_claim, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_over_refused_safeguard, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(binding_corporate_rules_approved, Approval)]) :-
    fixture_attested(false, Adequacy),
    fixture_attested(true, Approval).
gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_refused, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(binding_corporate_rules_approved, Approval)]) :-
    fixture_attested(false, Adequacy),
    fixture_attested(false, Approval).
gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_alone, [attribute(binding_corporate_rules_approved, Approval)]) :-
    fixture_attested(true, Approval).
gdpr_chapter_v_transfers_profile_for(empty_profile, []).
gdpr_chapter_v_transfers_profile_for(refused_safeguard_without_adequacy_fact, [attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_b), attribute(contract_necessity, true)]).
gdpr_chapter_v_transfers_profile_for(explicit_consent_derogation, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(explicit_consent_under_public_powers, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(public_authority_public_powers, true), attribute(explicit_consent_obtained, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(explicit_consent_not_stated, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(contract_derogation, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_b), attribute(contract_necessity, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(contract_derogation_under_public_powers, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_b), attribute(public_authority_public_powers, true), attribute(contract_necessity, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_interest_unsure, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_d), attribute(important_public_interest, unsure)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_interest_under_public_powers, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_d), attribute(public_authority_public_powers, true), attribute(important_public_interest, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_interest_refused, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_d), attribute(public_authority_public_powers, true), attribute(important_public_interest, false)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_register_derogation, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_g), attribute(register_public_by_law, true), attribute(register_consultation_conditions_fulfilled, true), attribute(register_not_entire, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_register_refused_requester, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_g), attribute(register_public_by_law, true), attribute(register_consultation_conditions_fulfilled, true), attribute(register_not_entire, true), attribute(register_requester_condition_met, false)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(public_register_not_public, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_g), attribute(register_public_by_law, false)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(second_subparagraph_after_public_interest, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(important_public_interest, true), attribute(legitimate_interests_derogation, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(second_subparagraph_with_unsure_contract, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(explicit_consent_obtained, false), attribute(contract_necessity, unsure), attribute(data_subject_interest_contract_necessity, false), attribute(important_public_interest, false), attribute(legal_claims_necessity, false), attribute(vital_interests_necessity, false), attribute(register_public_by_law, false), attribute(legitimate_interests_derogation, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(second_subparagraph_derogation, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(explicit_consent_obtained, false), attribute(contract_necessity, false), attribute(data_subject_interest_contract_necessity, false), attribute(important_public_interest, false), attribute(legal_claims_necessity, false), attribute(vital_interests_necessity, false), attribute(register_public_by_law, false), attribute(legitimate_interests_derogation, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(second_subparagraph_under_public_powers, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(public_authority_public_powers, true), attribute(explicit_consent_obtained, false), attribute(contract_necessity, false), attribute(data_subject_interest_contract_necessity, false), attribute(important_public_interest, false), attribute(legal_claims_necessity, false), attribute(vital_interests_necessity, false), attribute(register_public_by_law, false), attribute(legitimate_interests_derogation, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(second_subparagraph_consent_not_stated, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(contract_necessity, false), attribute(data_subject_interest_contract_necessity, false), attribute(important_public_interest, false), attribute(legal_claims_necessity, false), attribute(vital_interests_necessity, false), attribute(register_public_by_law, false), attribute(legitimate_interests_derogation, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(unsure_safeguard_contract_not_stated, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, unsure), attribute(derogation_claimed, art49_1_b)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(unsure_safeguard_contract_stated, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, unsure), attribute(derogation_claimed, art49_1_b), attribute(contract_necessity, true)]) :-
    fixture_attested(false, Adequacy).
gdpr_chapter_v_transfers_profile_for(recorded_facts_with_safeguard, [attribute(adequacy_decision_in_force, Adequacy), attribute(safeguard_in_place, true), attribute(transfer_is_onward_transfer, Onward), attribute(third_country_judgment_or_decision_requires_transfer, Judgment), attribute(international_agreement_basis_for_judgment_or_decision, Agreement)]) :-
    fixture_attested(false, Adequacy),
    fixture_attested(true, Onward),
    fixture_attested(true, Judgment),
    fixture_attested(true, Agreement).
gdpr_chapter_v_transfers_profile_for(safeguard_given_wrong_atom, [attribute(safeguard_in_place, yes)]).
gdpr_chapter_v_transfers_profile_for(duplicate_safeguard_and_unknown_key, [attribute(foo, 1), attribute(safeguard_in_place, true), attribute(safeguard_in_place, true)]).
gdpr_chapter_v_transfers_profile_for(profile_not_a_list, not_a_list).
gdpr_chapter_v_transfers_profile_for(binding_corporate_rules_bare_atom, [attribute(binding_corporate_rules_approved, true)]).
gdpr_chapter_v_transfers_profile_for(adequacy_attested_unsure, [attribute(adequacy_decision_in_force, Adequacy)]) :-
    fixture_attested(unsure, Adequacy).

gdpr_chapter_v_transfers_assess(Subject, Result) :-
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    decide_transfer(Profile, Result).
