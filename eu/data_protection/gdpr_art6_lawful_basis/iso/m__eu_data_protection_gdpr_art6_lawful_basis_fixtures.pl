% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2, gdpr_art6_lawful_basis_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [decide_gdpr_art6_lawful_basis/2]).

host_statement(Value, attested(Value, attestation(host_system, recorded_moment, stated_by_host, none))).

gdpr_art6_lawful_basis_subject(consent_claimed_attested_true).
gdpr_art6_lawful_basis_subject(consent_claimed_attested_false).
gdpr_art6_lawful_basis_subject(contract_claimed_necessary).
gdpr_art6_lawful_basis_subject(contract_claimed_not_necessary).
gdpr_art6_lawful_basis_subject(legal_obligation_laid_down_by_law_true).
gdpr_art6_lawful_basis_subject(legal_obligation_laid_down_by_law_false).
gdpr_art6_lawful_basis_subject(vital_interests_claimed_necessary).
gdpr_art6_lawful_basis_subject(vital_interests_claimed_not_necessary).
gdpr_art6_lawful_basis_subject(public_interest_task_laid_down_by_law_true).
gdpr_art6_lawful_basis_subject(public_interest_task_not_necessary).
gdpr_art6_lawful_basis_subject(legitimate_interests_balance_for_controller).
gdpr_art6_lawful_basis_subject(legitimate_interests_public_authority).
gdpr_art6_lawful_basis_subject(legitimate_interests_overridden).
gdpr_art6_lawful_basis_subject(two_ways_hold_with_special_category).
gdpr_art6_lawful_basis_subject(contract_alone_unclaimed).
gdpr_art6_lawful_basis_subject(empty_profile).
gdpr_art6_lawful_basis_subject(consent_statement_attested_for_last_open_way).
gdpr_art6_lawful_basis_subject(consent_statement_absent_for_last_open_way).
gdpr_art6_lawful_basis_subject(legal_obligation_law_statement_absent_one_step).
gdpr_art6_lawful_basis_subject(public_authority_question_missing_beside_unsure).
gdpr_art6_lawful_basis_subject(public_task_necessity_unsure_after_authority_stated).
gdpr_art6_lawful_basis_subject(legal_obligation_unsure_law_statement_absent).
gdpr_art6_lawful_basis_subject(legal_obligation_unsure_law_statement_attested).
gdpr_art6_lawful_basis_subject(legitimate_interests_balance_unsure).
gdpr_art6_lawful_basis_subject(duplicate_contract_key).
gdpr_art6_lawful_basis_subject(bare_outside_fact_value).
gdpr_art6_lawful_basis_subject(attested_judgement_value).
gdpr_art6_lawful_basis_subject(crisp_key_given_unsure).
gdpr_art6_lawful_basis_subject(basis_claimed_outside_its_list).
gdpr_art6_lawful_basis_subject(unknown_and_numeric_keys).
gdpr_art6_lawful_basis_subject(unbound_attestation_argument).
gdpr_art6_lawful_basis_subject(partial_list_profile).
gdpr_art6_lawful_basis_subject(new_purpose_not_engaged).
gdpr_art6_lawful_basis_subject(new_purpose_absent).
gdpr_art6_lawful_basis_subject(new_purpose_compatible).
gdpr_art6_lawful_basis_subject(new_purpose_not_compatible).
gdpr_art6_lawful_basis_subject(new_purpose_compatibility_absent).
gdpr_art6_lawful_basis_subject(new_purpose_compatibility_unsure).

gdpr_art6_lawful_basis_profile_for(consent_claimed_attested_true, [attribute(basis_claimed, consent), attribute(consent_given_and_conditions_met, Consent)]) :-
    host_statement(true, Consent).
gdpr_art6_lawful_basis_profile_for(consent_claimed_attested_false, [attribute(basis_claimed, consent), attribute(consent_given_and_conditions_met, Refused)]) :-
    host_statement(false, Refused).
gdpr_art6_lawful_basis_profile_for(contract_claimed_necessary, [attribute(basis_claimed, contract), attribute(contract_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(contract_claimed_not_necessary, [attribute(basis_claimed, contract), attribute(contract_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(legal_obligation_laid_down_by_law_true, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, LawStated)]) :-
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(legal_obligation_laid_down_by_law_false, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, LawRefused)]) :-
    host_statement(false, LawRefused).
gdpr_art6_lawful_basis_profile_for(vital_interests_claimed_necessary, [attribute(basis_claimed, vital_interests), attribute(vital_interests_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(vital_interests_claimed_not_necessary, [attribute(basis_claimed, vital_interests), attribute(vital_interests_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(public_interest_task_laid_down_by_law_true, [attribute(basis_claimed, public_interest_task), attribute(public_interest_task_necessary, true), attribute(public_interest_task_laid_down_by_law, LawStated)]) :-
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(public_interest_task_not_necessary, [attribute(basis_claimed, public_interest_task), attribute(public_interest_task_necessary, false), attribute(public_interest_task_laid_down_by_law, LawStated)]) :-
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_for_controller, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false), attribute(child_data_subject, Child), attribute(special_category, Special)]) :-
    host_statement(true, Child),
    host_statement(true, Special).
gdpr_art6_lawful_basis_profile_for(legitimate_interests_public_authority, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, true), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)]).
gdpr_art6_lawful_basis_profile_for(legitimate_interests_overridden, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, true)]).
gdpr_art6_lawful_basis_profile_for(two_ways_hold_with_special_category, [attribute(contract_necessary, true), attribute(vital_interests_necessary, true), attribute(child_data_subject, Child), attribute(special_category, Special)]) :-
    host_statement(true, Child),
    host_statement(true, Special).
gdpr_art6_lawful_basis_profile_for(contract_alone_unclaimed, [attribute(contract_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(empty_profile, []).
gdpr_art6_lawful_basis_profile_for(consent_statement_attested_for_last_open_way, [attribute(consent_given_and_conditions_met, Consent), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(processing_by_public_authority_in_its_tasks, true)]) :-
    host_statement(true, Consent).
gdpr_art6_lawful_basis_profile_for(consent_statement_absent_for_last_open_way, [attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(processing_by_public_authority_in_its_tasks, true)]).
gdpr_art6_lawful_basis_profile_for(legal_obligation_law_statement_absent_one_step, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(public_authority_question_missing_beside_unsure, [attribute(consent_given_and_conditions_met, Refused), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, unsure), attribute(public_interest_task_laid_down_by_law, LawStated)]) :-
    host_statement(false, Refused),
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(public_task_necessity_unsure_after_authority_stated, [attribute(consent_given_and_conditions_met, Refused), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, unsure), attribute(public_interest_task_laid_down_by_law, LawStated), attribute(processing_by_public_authority_in_its_tasks, true)]) :-
    host_statement(false, Refused),
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(legal_obligation_unsure_law_statement_absent, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, unsure)]).
gdpr_art6_lawful_basis_profile_for(legal_obligation_unsure_law_statement_attested, [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, unsure), attribute(legal_obligation_laid_down_by_law, LawStated)]) :-
    host_statement(true, LawStated).
gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, unsure), attribute(child_data_subject, Child)]) :-
    host_statement(true, Child).
gdpr_art6_lawful_basis_profile_for(duplicate_contract_key, [attribute(contract_necessary, true), attribute(contract_necessary, false)]).
gdpr_art6_lawful_basis_profile_for(bare_outside_fact_value, [attribute(consent_given_and_conditions_met, true)]).
gdpr_art6_lawful_basis_profile_for(attested_judgement_value, [attribute(contract_necessary, Stated)]) :-
    host_statement(true, Stated).
gdpr_art6_lawful_basis_profile_for(crisp_key_given_unsure, [attribute(processing_by_public_authority_in_its_tasks, unsure)]).
gdpr_art6_lawful_basis_profile_for(basis_claimed_outside_its_list, [attribute(basis_claimed, public_task), attribute(contract_necessary, true)]).
gdpr_art6_lawful_basis_profile_for(unknown_and_numeric_keys, [attribute(favourite_colour, blue), attribute(42, true), attribute(favourite_colour, green)]).
gdpr_art6_lawful_basis_profile_for(unbound_attestation_argument, [attribute(consent_given_and_conditions_met, attested(true, attestation(host_system, _UnstatedMoment, stated_by_host, none)))]).
gdpr_art6_lawful_basis_profile_for(partial_list_profile, [attribute(contract_necessary, true)|_UnfinishedTail]).
gdpr_art6_lawful_basis_profile_for(new_purpose_not_engaged, [attribute(new_purpose_processing, false), attribute(compatible_purpose, false)]).
gdpr_art6_lawful_basis_profile_for(new_purpose_absent, [attribute(compatible_purpose, true)]).
gdpr_art6_lawful_basis_profile_for(new_purpose_compatible, [attribute(new_purpose_processing, true), attribute(compatible_purpose, true)]).
gdpr_art6_lawful_basis_profile_for(new_purpose_not_compatible, [attribute(new_purpose_processing, true), attribute(compatible_purpose, false)]).
gdpr_art6_lawful_basis_profile_for(new_purpose_compatibility_absent, [attribute(new_purpose_processing, true)]).
gdpr_art6_lawful_basis_profile_for(new_purpose_compatibility_unsure, [attribute(new_purpose_processing, true), attribute(compatible_purpose, unsure)]).

gdpr_art6_lawful_basis_assess(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    decide_gdpr_art6_lawful_basis(Profile, Result).
