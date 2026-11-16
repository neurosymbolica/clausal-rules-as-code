% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_queries, [gdpr_common_definitions_data_and_processing_profile_keys/1, gdpr_common_definitions_data_and_processing_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status/2]).

gdpr_common_definitions_data_and_processing_profile_keys([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries]).

gdpr_common_definitions_data_and_processing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    remove_attribute(Profile, OverriddenKey, Remaining),
    gdpr_common_definitions_data_and_processing_status([attribute(OverriddenKey, NewValue)|Remaining], NewStatus).

remove_attribute([], _, []).
remove_attribute([attribute(Key, _)|Elements], Key, Remaining) :-
    remove_attribute(Elements, Key, Remaining).
remove_attribute([attribute(Other, Value)|Elements], Key, [attribute(Other, Value)|Remaining]) :-
    dif(Other, Key),
    remove_attribute(Elements, Key, Remaining).
