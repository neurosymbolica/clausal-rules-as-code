% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_subject/1, gdpr_data_subject_rights_response_duties_profile_for/2, gdpr_data_subject_rights_response_duties_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2]).

gdpr_data_subject_rights_response_duties_subject(access_plain_must_comply).
gdpr_data_subject_rights_response_duties_subject(access_manifestly_excessive_refused).
gdpr_data_subject_rights_response_duties_subject(access_public_holiday_shift).
gdpr_data_subject_rights_response_duties_subject(access_holiday_elsewhere_no_shift).
gdpr_data_subject_rights_response_duties_subject(access_extension_necessary).
gdpr_data_subject_rights_response_duties_subject(access_extension_not_necessary).
gdpr_data_subject_rights_response_duties_subject(access_extension_unsure).
gdpr_data_subject_rights_response_duties_subject(access_identity_doubts_suspended).
gdpr_data_subject_rights_response_duties_subject(access_identity_confirmed_complies).
gdpr_data_subject_rights_response_duties_subject(access_legislative_restriction_attested).
gdpr_data_subject_rights_response_duties_subject(access_legislative_restriction_denied).
gdpr_data_subject_rights_response_duties_subject(access_unable_to_identify_refused).
gdpr_data_subject_rights_response_duties_subject(erasure_legal_claims_exception).
gdpr_data_subject_rights_response_duties_subject(erasure_without_exception_complies).
gdpr_data_subject_rights_response_duties_subject(erasure_legal_obligation_not_attested).
gdpr_data_subject_rights_response_duties_subject(erasure_legal_obligation_attested).
gdpr_data_subject_rights_response_duties_subject(rectification_recipients_informed).
gdpr_data_subject_rights_response_duties_subject(rectification_recipients_excused).
gdpr_data_subject_rights_response_duties_subject(rectification_grounds_missing).
gdpr_data_subject_rights_response_duties_subject(judgement_given_unsure_refers).
gdpr_data_subject_rights_response_duties_subject(crisp_key_given_unsure).
gdpr_data_subject_rights_response_duties_subject(restriction_accuracy_contested).
gdpr_data_subject_rights_response_duties_subject(restriction_not_engaged).
gdpr_data_subject_rights_response_duties_subject(portability_engaged).
gdpr_data_subject_rights_response_duties_subject(portability_rights_of_others).
gdpr_data_subject_rights_response_duties_subject(objection_direct_marketing).
gdpr_data_subject_rights_response_duties_subject(objection_not_direct_marketing).
gdpr_data_subject_rights_response_duties_subject(objection_ground_missing).
gdpr_data_subject_rights_response_duties_subject(automated_decision_explicit_consent).
gdpr_data_subject_rights_response_duties_subject(automated_decision_special_category_bar).
gdpr_data_subject_rights_response_duties_subject(request_type_absent_manifestly_excessive).
gdpr_data_subject_rights_response_duties_subject(request_type_absent_not_excessive).
gdpr_data_subject_rights_response_duties_subject(duplicate_request_type).
gdpr_data_subject_rights_response_duties_subject(unknown_key_given).
gdpr_data_subject_rights_response_duties_subject(profile_not_a_list).

gdpr_data_subject_rights_response_duties_profile_for(access_plain_must_comply, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29))]).
gdpr_data_subject_rights_response_duties_profile_for(access_manifestly_excessive_refused, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(request_manifestly_unfounded_or_excessive, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_public_holiday_shift, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(access_holiday_elsewhere_no_shift, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(access_extension_necessary, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_extension_not_necessary, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, false)]).
gdpr_data_subject_rights_response_duties_profile_for(access_extension_unsure, [attribute(request_type, access), attribute(request_received_on, date(2026, 1, 31)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure)]).
gdpr_data_subject_rights_response_duties_profile_for(access_identity_doubts_suspended, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)]).
gdpr_data_subject_rights_response_duties_profile_for(access_identity_confirmed_complies, [attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, true)]).
gdpr_data_subject_rights_response_duties_profile_for(access_legislative_restriction_attested, [attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(access_legislative_restriction_denied, [attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(access_unable_to_identify_refused, [attribute(request_type, access), attribute(controller_demonstrates_unable_to_identify_data_subject, true)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_claims_exception, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, true), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, false), attribute(data_subject_asks_who_the_recipients_are, false)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_without_exception_complies, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, false), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, false), attribute(data_subject_asks_who_the_recipients_are, false)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_obligation_not_attested, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, false), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(personal_data_unlawfully_processed, false), attribute(collected_in_relation_to_information_society_services_offer, false)]).
gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_obligation_attested, [attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, false), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(personal_data_unlawfully_processed, false), attribute(collected_in_relation_to_information_society_services_offer, false), attribute(erasure_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, none)))]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_recipients_informed, [attribute(request_type, rectification), attribute(personal_data_inaccurate, true), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, false), attribute(data_subject_asks_who_the_recipients_are, true)]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_recipients_excused, [attribute(request_type, rectification), attribute(personal_data_inaccurate, true), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, true), attribute(data_subject_asks_who_the_recipients_are, true)]).
gdpr_data_subject_rights_response_duties_profile_for(rectification_grounds_missing, [attribute(request_type, rectification)]).
gdpr_data_subject_rights_response_duties_profile_for(judgement_given_unsure_refers, [attribute(request_type, rectification), attribute(personal_data_inaccurate, false), attribute(personal_data_incomplete_in_light_of_purposes, unsure)]).
gdpr_data_subject_rights_response_duties_profile_for(crisp_key_given_unsure, [attribute(request_type, rectification), attribute(personal_data_inaccurate, unsure)]).
gdpr_data_subject_rights_response_duties_profile_for(restriction_accuracy_contested, [attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, true), attribute(personal_data_disclosed_to_recipients, false)]).
gdpr_data_subject_rights_response_duties_profile_for(restriction_not_engaged, [attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, false), attribute(data_subject_opposes_erasure, false), attribute(data_required_by_data_subject_for_legal_claims, false), attribute(objection_under_art21_1_made, false)]).
gdpr_data_subject_rights_response_duties_profile_for(portability_engaged, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
gdpr_data_subject_rights_response_duties_profile_for(portability_rights_of_others, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, true)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_direct_marketing, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_not_direct_marketing, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, false)]).
gdpr_data_subject_rights_response_duties_profile_for(objection_ground_missing, [attribute(request_type, objection)]).
gdpr_data_subject_rights_response_duties_profile_for(automated_decision_explicit_consent, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true)]).
gdpr_data_subject_rights_response_duties_profile_for(automated_decision_special_category_bar, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)]).
gdpr_data_subject_rights_response_duties_profile_for(request_type_absent_manifestly_excessive, [attribute(request_received_on, date(2026, 10, 29)), attribute(request_manifestly_unfounded_or_excessive, true)]).
gdpr_data_subject_rights_response_duties_profile_for(request_type_absent_not_excessive, [attribute(request_manifestly_unfounded_or_excessive, false)]).
gdpr_data_subject_rights_response_duties_profile_for(duplicate_request_type, [attribute(request_type, access), attribute(request_type, erasure)]).
gdpr_data_subject_rights_response_duties_profile_for(unknown_key_given, [attribute(request_type, access), attribute(favourite_colour, blue)]).
gdpr_data_subject_rights_response_duties_profile_for(profile_not_a_list, not_an_attribute_list).

gdpr_data_subject_rights_response_duties_assess(Subject, Result) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, Result).
