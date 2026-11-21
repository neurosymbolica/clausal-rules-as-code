% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2, gdpr_art6_lawful_basis_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [decide_gdpr_art6_lawful_basis/2]).

gdpr_art6_lawful_basis_subject(claimed_consent_holds).
gdpr_art6_lawful_basis_subject(claimed_consent_refused).
gdpr_art6_lawful_basis_subject(claimed_consent_statement_absent).
gdpr_art6_lawful_basis_subject(claimed_contract_holds).
gdpr_art6_lawful_basis_subject(claimed_contract_not_necessary).
gdpr_art6_lawful_basis_subject(claimed_legal_obligation_holds).
gdpr_art6_lawful_basis_subject(claimed_legal_obligation_law_refused).
gdpr_art6_lawful_basis_subject(claimed_legal_obligation_necessity_absent).
gdpr_art6_lawful_basis_subject(claimed_legal_obligation_necessity_unsure_law_absent).
gdpr_art6_lawful_basis_subject(claimed_vital_interests_holds).
gdpr_art6_lawful_basis_subject(claimed_vital_interests_not_necessary).
gdpr_art6_lawful_basis_subject(claimed_public_interest_task_holds).
gdpr_art6_lawful_basis_subject(claimed_public_interest_task_law_absent).
gdpr_art6_lawful_basis_subject(claimed_legitimate_interests_holds).
gdpr_art6_lawful_basis_subject(claimed_legitimate_interests_overridden).
gdpr_art6_lawful_basis_subject(claimed_legitimate_interests_public_authority).
gdpr_art6_lawful_basis_subject(claimed_legitimate_interests_balance_absent).
gdpr_art6_lawful_basis_subject(claimed_legitimate_interests_balance_unsure_child).
gdpr_art6_lawful_basis_subject(legitimate_interests_holds_child_flagged).
gdpr_art6_lawful_basis_subject(consent_holds_special_category_flagged).
gdpr_art6_lawful_basis_subject(every_way_fails).
gdpr_art6_lawful_basis_subject(empty_profile).
gdpr_art6_lawful_basis_subject(unsure_contract_vital_interests_absent).
gdpr_art6_lawful_basis_subject(only_unsure_contract_left).
gdpr_art6_lawful_basis_subject(purpose_test_not_engaged).
gdpr_art6_lawful_basis_subject(purpose_compatible).
gdpr_art6_lawful_basis_subject(purpose_not_compatible).
gdpr_art6_lawful_basis_subject(purpose_factor_left_out).
gdpr_art6_lawful_basis_subject(purpose_factors_all_taken).
gdpr_art6_lawful_basis_subject(purpose_judgement_absent).
gdpr_art6_lawful_basis_subject(purpose_judgement_unsure).
gdpr_art6_lawful_basis_subject(input_duplicate_key).
gdpr_art6_lawful_basis_subject(input_attested_judgement).
gdpr_art6_lawful_basis_subject(input_bare_outside_fact).
gdpr_art6_lawful_basis_subject(input_attestation_argument_unbound).
gdpr_art6_lawful_basis_subject(input_unknown_number_key).
gdpr_art6_lawful_basis_subject(input_partial_list).

gdpr_art6_lawful_basis_profile_for(claimed_consent_holds, [attribute(basis_claimed, consent), attribute(consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(claimed_consent_refused, [attribute(basis_claimed, consent), attribute(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(claimed_consent_statement_absent, [attribute(basis_claimed, consent)]).
gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, [attribute(basis_claimed, contract), attribute(contract_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(claimed_contract_not_necessary, [attribute(basis_claimed, contract), attribute(contract_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_holds, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, attested(true, attestation(host_system, recorded_moment, stated_reason, url(statute_address, retrieved_moment))))]).
gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_law_refused, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, attested(false, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_necessity_absent, [attribute(basis_claimed, legal_obligation)]).
gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_necessity_unsure_law_absent, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, unsure)]).
gdpr_art6_lawful_basis_profile_for(claimed_vital_interests_holds, [attribute(basis_claimed, vital_interests), attribute(vital_interests_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(claimed_vital_interests_not_necessary, [attribute(basis_claimed, vital_interests), attribute(vital_interests_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(claimed_public_interest_task_holds, [attribute(basis_claimed, public_interest_task), attribute(public_interest_task_necessary, true), attribute(public_interest_task_laid_down_by_law, attested(true, attestation(host_system, recorded_moment, stated_reason, document(upload_identifier, content_digest))))]).
gdpr_art6_lawful_basis_profile_for(claimed_public_interest_task_law_absent, [attribute(basis_claimed, public_interest_task), attribute(public_interest_task_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_holds, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)]).
gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_overridden, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, true)]).
gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_public_authority, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, true), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)]).
gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_balance_absent, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true)]).
gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_balance_unsure_child, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, unsure), attribute(child_data_subject, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(legitimate_interests_holds_child_flagged, [attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false), attribute(child_data_subject, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(consent_holds_special_category_flagged, [attribute(consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_reason, none))), attribute(special_category, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(every_way_fails, [attribute(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none))), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)]).
gdpr_art6_lawful_basis_profile_for(empty_profile, []).
gdpr_art6_lawful_basis_profile_for(unsure_contract_vital_interests_absent, [attribute(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none))), attribute(contract_necessary, unsure), attribute(legal_obligation_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)]).
gdpr_art6_lawful_basis_profile_for(only_unsure_contract_left, [attribute(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none))), attribute(contract_necessary, unsure), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)]).
gdpr_art6_lawful_basis_profile_for(purpose_test_not_engaged, [attribute(new_purpose_processing, false)]).
gdpr_art6_lawful_basis_profile_for(purpose_compatible, [attribute(new_purpose_processing, true), attribute(compatible_purpose, true)]).
gdpr_art6_lawful_basis_profile_for(purpose_not_compatible, [attribute(new_purpose_processing, true), attribute(compatible_purpose, false)]).
gdpr_art6_lawful_basis_profile_for(purpose_factor_left_out, [attribute(new_purpose_processing, true), attribute(compatible_purpose, true), attribute(nature_of_data_taken_into_account, false)]).
gdpr_art6_lawful_basis_profile_for(purpose_factors_all_taken, [attribute(new_purpose_processing, true), attribute(compatible_purpose, true), attribute(link_between_purposes_taken_into_account, true), attribute(collection_context_taken_into_account, true), attribute(nature_of_data_taken_into_account, true), attribute(possible_consequences_taken_into_account, true), attribute(appropriate_safeguards_taken_into_account, true)]).
gdpr_art6_lawful_basis_profile_for(purpose_judgement_absent, [attribute(new_purpose_processing, true), attribute(link_between_purposes_taken_into_account, true)]).
gdpr_art6_lawful_basis_profile_for(purpose_judgement_unsure, [attribute(new_purpose_processing, true), attribute(compatible_purpose, unsure)]).
gdpr_art6_lawful_basis_profile_for(input_duplicate_key, [attribute(contract_necessary, true), attribute(contract_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(input_attested_judgement, [attribute(contract_necessary, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(input_bare_outside_fact, [attribute(consent_given_and_conditions_met, true)]).
gdpr_art6_lawful_basis_profile_for(input_attestation_argument_unbound, [attribute(special_category, attested(true, attestation(host_system, _, stated_reason, none)))]).
gdpr_art6_lawful_basis_profile_for(input_unknown_number_key, [attribute(42, true)]).
gdpr_art6_lawful_basis_profile_for(input_partial_list, [attribute(contract_necessary, true)|_]).

gdpr_art6_lawful_basis_assess(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    decide_gdpr_art6_lawful_basis(Profile, Result).
