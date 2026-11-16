% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_queries, [gdpr_data_subject_rights_response_period_profile_keys/1, gdpr_data_subject_rights_response_period_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [gdpr_data_subject_rights_response_period_status/2]).

gdpr_data_subject_rights_response_period_profile_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

gdpr_data_subject_rights_response_period_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_data_subject_rights_response_period_input_problems(Profile, Problems),
    what_if_on(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_on([wrong_type(profile)], Profile, _, _, NewStatus) :-
    gdpr_data_subject_rights_response_period_status(Profile, NewStatus).
what_if_on(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_data_subject_rights_response_period_status(Hypothesis, NewStatus).

replace_attribute([], Key, Value, [attribute(Key, Value)]).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|NewElements]) :-
    ElementKey \== Key,
    replace_attribute(Elements, Key, Value, NewElements).
replace_attribute([attribute(ElementKey, _)|Elements], Key, Value, NewElements) :-
    ElementKey == Key,
    replace_attribute(Elements, Key, Value, NewElements).

test(what_if_setting_necessity_extends_a_claimed_profile) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([attribute(extension_claimed, true)], extension_necessary_for_complexity_and_number, true, Status), Statuses),
    Statuses == [extended_period].
test(what_if_replaces_rather_than_duplicates) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)], extension_claimed, false, Status), Statuses),
    Statuses == [first_period].
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if(not_a_list, extension_claimed, true, Status), Statuses),
    Statuses == [input_problems].
test(profile_keys_are_the_fifty_four_contract_keys) :-
    gdpr_data_subject_rights_response_period_profile_keys(Keys),
    length(Keys, 54).
test(constructor_terms_destructure) :-
    Term = attestation(by, at, reason, document(upload, hash)),
    Term = attestation(_, _, _, document(UploadIdentifier, DocumentHash)),
    UploadIdentifier == upload,
    DocumentHash == hash.
