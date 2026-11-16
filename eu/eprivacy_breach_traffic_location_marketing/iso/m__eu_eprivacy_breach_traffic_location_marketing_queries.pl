% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_queries, [eprivacy_breach_traffic_location_marketing_profile_keys/1, eprivacy_breach_traffic_location_marketing_what_if/4, input_problems/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [eprivacy_breach_traffic_location_marketing_status/2]).

eprivacy_breach_traffic_location_marketing_profile_keys([breach_provider_of_publicly_available_service, personal_data_breach_occurred, authority_required_individual_notification, breach_likely_to_adversely_affect_subscriber_or_individual, protection_measures_demonstrated_to_authority, traffic_provider_of_public_network_or_service, traffic_data_relating_to_subscribers_or_users, traffic_processing_purpose, traffic_data_still_needed_for_transmission, traffic_data_necessary_for_billing_or_interconnection, traffic_billing_challenge_or_payment_period_running, traffic_marketing_provider_of_publicly_available_service, traffic_marketing_prior_consent_given, traffic_marketing_consent_withdrawn, traffic_marketing_processing_within_necessary_extent_and_duration, location_data_other_than_traffic_data_in_scope, location_data_made_anonymous, location_consent_given, location_consent_withdrawn, location_processing_within_necessary_extent_and_duration_for_value_added_service, location_processing_temporarily_refused, marketing_communication_for_direct_marketing, marketing_subscriber_is_natural_person, marketing_communication_means, marketing_prior_consent_given, marketing_contact_details_obtained_from_customer_in_sale, marketing_sender_obtained_the_contact_details, marketing_own_similar_products_or_services, marketing_objection_offered_at_collection, marketing_objection_offered_in_each_message, marketing_customer_refused_or_objected, email_sender_identity_disguised_or_concealed, email_contravenes_electronic_commerce_directive_article_6, email_valid_cessation_address_provided, email_encourages_visiting_contravening_websites]).

eprivacy_breach_traffic_location_marketing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    eprivacy_breach_traffic_location_marketing_status(Hypothesis, NewStatus).

replace_attribute([], Key, Value, [attribute(Key, Value)]).
replace_attribute([attribute(Key, _)|Elements], Key, Value, Hypothesis) :-
    replace_attribute(Elements, Key, Value, Hypothesis).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    dif(ElementKey, Key),
    replace_attribute(Elements, Key, Value, Hypothesis).

input_problems([_|_]).

indeterminate([_]).

needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]).

open_textured(_, cite(_)).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

test(the_schema_has_thirty_five_keys) :-
    eprivacy_breach_traffic_location_marketing_profile_keys(Keys),
    length(Keys, 35).
test(what_if_replaces_a_key) :-
    replace_attribute([attribute(a_key, false), attribute(other_key, true)], a_key, true, Hypothesis),
    Hypothesis == [attribute(other_key, true), attribute(a_key, true)].
