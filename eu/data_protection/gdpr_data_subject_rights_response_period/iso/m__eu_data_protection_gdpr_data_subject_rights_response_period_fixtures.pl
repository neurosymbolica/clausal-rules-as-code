% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_subject/1, gdpr_data_subject_rights_response_period_profile_for/2, gdpr_data_subject_rights_response_period_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [decide_gdpr_data_subject_rights_response_period/2]).

gdpr_data_subject_rights_response_period_subject(no_extension_claimed).
gdpr_data_subject_rights_response_period_subject(claim_withdrawn_but_necessary).
gdpr_data_subject_rights_response_period_subject(necessity_without_claim).
gdpr_data_subject_rights_response_period_subject(claimed_and_necessary).
gdpr_data_subject_rights_response_period_subject(claimed_not_necessary).
gdpr_data_subject_rights_response_period_subject(claimed_without_judgement).
gdpr_data_subject_rights_response_period_subject(claimed_and_unsure).
gdpr_data_subject_rights_response_period_subject(unread_keys_present).
gdpr_data_subject_rights_response_period_subject(unknown_key_given).
gdpr_data_subject_rights_response_period_subject(duplicate_claim_given).
gdpr_data_subject_rights_response_period_subject(claim_given_unsure).
gdpr_data_subject_rights_response_period_subject(profile_not_a_list).

gdpr_data_subject_rights_response_period_profile_for(no_extension_claimed, []).
gdpr_data_subject_rights_response_period_profile_for(claim_withdrawn_but_necessary, [attribute(extension_claimed, false), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_period_profile_for(necessity_without_claim, [attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, [attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_period_profile_for(claimed_not_necessary, [attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, false)]).
gdpr_data_subject_rights_response_period_profile_for(claimed_without_judgement, [attribute(extension_claimed, true)]).
gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, [attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure)]).
gdpr_data_subject_rights_response_period_profile_for(unread_keys_present, [attribute(request_type, erasure), attribute(request_received_on, date(2026, 10, 29)), attribute(consent_withdrawn, true), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true), attribute(request_manifestly_unfounded_or_excessive, unsure), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_period_profile_for(unknown_key_given, [attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true), attribute(colour, blue)]).
gdpr_data_subject_rights_response_period_profile_for(duplicate_claim_given, [attribute(extension_claimed, true), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_period_profile_for(claim_given_unsure, [attribute(extension_claimed, unsure), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_period_profile_for(profile_not_a_list, not_an_attribute_list).

gdpr_data_subject_rights_response_period_assess(Subject, Result) :-
    gdpr_data_subject_rights_response_period_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_period(Profile, Result).
