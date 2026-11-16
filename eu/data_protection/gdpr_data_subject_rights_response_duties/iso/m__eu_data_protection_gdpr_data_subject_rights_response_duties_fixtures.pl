% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_subject/1, gdpr_data_subject_rights_response_duties_profile_for/2, gdpr_data_subject_rights_response_duties_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2]).

gdpr_data_subject_rights_response_duties_subject(access_basic).
gdpr_data_subject_rights_response_duties_subject(access_excessive).
gdpr_data_subject_rights_response_duties_subject(access_not_excessive).
gdpr_data_subject_rights_response_duties_subject(access_unable_to_identify).
gdpr_data_subject_rights_response_duties_subject(access_identity_suspended).
gdpr_data_subject_rights_response_duties_subject(access_identity_confirmed).
gdpr_data_subject_rights_response_duties_subject(access_restricted_by_law).
gdpr_data_subject_rights_response_duties_subject(access_not_restricted_by_law).
gdpr_data_subject_rights_response_duties_subject(missing_request_type).
gdpr_data_subject_rights_response_duties_subject(objection_without_ground).
gdpr_data_subject_rights_response_duties_subject(request_type_invalid).
gdpr_data_subject_rights_response_duties_subject(unknown_key_profile).
gdpr_data_subject_rights_response_duties_subject(duplicate_key_profile).
gdpr_data_subject_rights_response_duties_subject(rectification_inaccurate).
gdpr_data_subject_rights_response_duties_subject(rectification_nothing_wrong).
gdpr_data_subject_rights_response_duties_subject(rectification_keys_absent).
gdpr_data_subject_rights_response_duties_subject(erasure_no_longer_necessary).
gdpr_data_subject_rights_response_duties_subject(erasure_legal_claims_exception).
gdpr_data_subject_rights_response_duties_subject(erasure_effort_excused).
gdpr_data_subject_rights_response_duties_subject(restriction_accuracy_contested).
gdpr_data_subject_rights_response_duties_subject(restriction_no_ground).
gdpr_data_subject_rights_response_duties_subject(portability_engaged).
gdpr_data_subject_rights_response_duties_subject(portability_not_automated).
gdpr_data_subject_rights_response_duties_subject(portability_public_task).
gdpr_data_subject_rights_response_duties_subject(objection_marketing).
gdpr_data_subject_rights_response_duties_subject(objection_not_marketing).
gdpr_data_subject_rights_response_duties_subject(objection_art21_1_compelling).
gdpr_data_subject_rights_response_duties_subject(automated_decision_consent).
gdpr_data_subject_rights_response_duties_subject(automated_decision_no_consent).
gdpr_data_subject_rights_response_duties_subject(automated_decision_special_bar).
gdpr_data_subject_rights_response_duties_subject(extension_necessary).
gdpr_data_subject_rights_response_duties_subject(extension_not_necessary).
gdpr_data_subject_rights_response_duties_subject(extension_unsure).
gdpr_data_subject_rights_response_duties_subject(holiday_shift).
gdpr_data_subject_rights_response_duties_subject(no_holiday_shift).
gdpr_data_subject_rights_response_duties_subject(leap_year).
gdpr_data_subject_rights_response_duties_subject(year_end).

gdpr_data_subject_rights_response_duties_profile_for(access_basic, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29))]).
gdpr_data_subject_rights_response_duties_profile_for(access_excessive, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(request_manifestly_unfounded_or_excessive, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_not_excessive, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(request_manifestly_unfounded_or_excessive, false)]).
gdpr_data_subject_rights_response_duties_profile_for(access_unable_to_identify, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(controller_demonstrates_unable_to_identify_data_subject, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_identity_suspended, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)]).
gdpr_data_subject_rights_response_duties_profile_for(access_identity_confirmed, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_restricted_by_law, [attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(host, fixture_time, fixture_reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(access_not_restricted_by_law, [attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(host, fixture_time, fixture_reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(missing_request_type, []).
gdpr_data_subject_rights_response_duties_profile_for(objection_without_ground, [attribute(request_type, objection)]).
gdpr_data_subject_rights_response_duties_profile_for(request_type_invalid, [attribute(request_type, other)]).
gdpr_data_subject_rights_response_duties_profile_for(unknown_key_profile, [attribute(request_type, access), attribute(bogus_key, true)]).
gdpr_data_subject_rights_response_duties_profile_for(duplicate_key_profile, [attribute(request_type, access), attribute(request_type, access)]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_inaccurate, [attribute(request_type, rectification), attribute(personal_data_inaccurate, true), attribute(personal_data_disclosed_to_recipients, false)]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_nothing_wrong, [attribute(request_type, rectification), attribute(personal_data_inaccurate, false), attribute(personal_data_incomplete_in_light_of_purposes, false)]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_keys_absent, [attribute(request_type, rectification)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_no_longer_necessary, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, false), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, false), attribute(data_subject_asks_who_the_recipients_are, true)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_claims_exception, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, true)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_effort_excused, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, true)]).
gdpr_data_subject_rights_response_duties_profile_for(restriction_accuracy_contested, [attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, true), attribute(personal_data_disclosed_to_recipients, false)]).
gdpr_data_subject_rights_response_duties_profile_for(restriction_no_ground, [attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, false), attribute(personal_data_unlawfully_processed, false), attribute(controller_no_longer_needs_data_for_processing_purposes, false), attribute(objection_under_art21_1_made, false)]).
gdpr_data_subject_rights_response_duties_profile_for(portability_engaged, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
gdpr_data_subject_rights_response_duties_profile_for(portability_not_automated, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, false)]).
gdpr_data_subject_rights_response_duties_profile_for(portability_public_task, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_marketing, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_not_marketing, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, false)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_art21_1_compelling, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)]).
gdpr_data_subject_rights_response_duties_profile_for(automated_decision_consent, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true)]).
gdpr_data_subject_rights_response_duties_profile_for(automated_decision_no_consent, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, false)]).
gdpr_data_subject_rights_response_duties_profile_for(automated_decision_special_bar, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)]).
gdpr_data_subject_rights_response_duties_profile_for(extension_necessary, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_duties_profile_for(extension_not_necessary, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, false)]).
gdpr_data_subject_rights_response_duties_profile_for(extension_unsure, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure)]).
gdpr_data_subject_rights_response_duties_profile_for(holiday_shift, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(host, fixture_time, fixture_reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(no_holiday_shift, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([], attestation(host, fixture_time, fixture_reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(leap_year, [attribute(request_type, access), attribute(request_received_on, date(2028, 1, 31))]).
gdpr_data_subject_rights_response_duties_profile_for(year_end, [attribute(request_type, access), attribute(request_received_on, date(2026, 12, 31))]).

gdpr_data_subject_rights_response_duties_assess(Subject, Result) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, Result).
