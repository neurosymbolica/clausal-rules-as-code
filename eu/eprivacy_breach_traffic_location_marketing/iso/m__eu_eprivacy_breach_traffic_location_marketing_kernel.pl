% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [breach_provider_of_publicly_available_service, personal_data_breach_occurred, authority_required_individual_notification, breach_likely_to_adversely_affect_subscriber_or_individual, protection_measures_demonstrated_to_authority, traffic_provider_of_public_network_or_service, traffic_data_relating_to_subscribers_or_users, traffic_processing_purpose, traffic_data_still_needed_for_transmission, traffic_data_necessary_for_billing_or_interconnection, traffic_billing_challenge_or_payment_period_running, traffic_marketing_provider_of_publicly_available_service, traffic_marketing_prior_consent_given, traffic_marketing_consent_withdrawn, traffic_marketing_processing_within_necessary_extent_and_duration, location_data_other_than_traffic_data_in_scope, location_data_made_anonymous, location_consent_given, location_consent_withdrawn, location_processing_within_necessary_extent_and_duration_for_value_added_service, location_processing_temporarily_refused, marketing_communication_for_direct_marketing, marketing_subscriber_is_natural_person, marketing_communication_means, marketing_prior_consent_given, marketing_contact_details_obtained_from_customer_in_sale, marketing_sender_obtained_the_contact_details, marketing_own_similar_products_or_services, marketing_objection_offered_at_collection, marketing_objection_offered_in_each_message, marketing_customer_refused_or_objected, email_sender_identity_disguised_or_concealed, email_contravenes_electronic_commerce_directive_article_6, email_valid_cessation_address_provided, email_encourages_visiting_contravening_websites],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(breach_provider_of_publicly_available_service, judgement).
key_type(personal_data_breach_occurred, judgement).
key_type(authority_required_individual_notification, boolean).
key_type(breach_likely_to_adversely_affect_subscriber_or_individual, judgement).
key_type(protection_measures_demonstrated_to_authority, boolean).
key_type(traffic_provider_of_public_network_or_service, judgement).
key_type(traffic_data_relating_to_subscribers_or_users, judgement).
key_type(traffic_processing_purpose, traffic_processing_purpose).
key_type(traffic_data_still_needed_for_transmission, judgement).
key_type(traffic_data_necessary_for_billing_or_interconnection, judgement).
key_type(traffic_billing_challenge_or_payment_period_running, judgement).
key_type(traffic_marketing_provider_of_publicly_available_service, judgement).
key_type(traffic_marketing_prior_consent_given, judgement).
key_type(traffic_marketing_consent_withdrawn, boolean).
key_type(traffic_marketing_processing_within_necessary_extent_and_duration, judgement).
key_type(location_data_other_than_traffic_data_in_scope, judgement).
key_type(location_data_made_anonymous, judgement).
key_type(location_consent_given, judgement).
key_type(location_consent_withdrawn, boolean).
key_type(location_processing_within_necessary_extent_and_duration_for_value_added_service, judgement).
key_type(location_processing_temporarily_refused, boolean).
key_type(marketing_communication_for_direct_marketing, judgement).
key_type(marketing_subscriber_is_natural_person, boolean).
key_type(marketing_communication_means, marketing_communication_means).
key_type(marketing_prior_consent_given, judgement).
key_type(marketing_contact_details_obtained_from_customer_in_sale, judgement).
key_type(marketing_sender_obtained_the_contact_details, boolean).
key_type(marketing_own_similar_products_or_services, judgement).
key_type(marketing_objection_offered_at_collection, judgement).
key_type(marketing_objection_offered_in_each_message, judgement).
key_type(marketing_customer_refused_or_objected, boolean).
key_type(email_sender_identity_disguised_or_concealed, judgement).
key_type(email_contravenes_electronic_commerce_directive_article_6, judgement).
key_type(email_valid_cessation_address_provided, judgement).
key_type(email_encourages_visiting_contravening_websites, judgement).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(traffic_processing_purpose, Value, T) :-
    in_type_t(enum([transmission_of_communication, subscriber_billing_or_interconnection_payments, marketing_or_value_added_service, other_purpose]), Value, T).
in_type_t(marketing_communication_means, Value, T) :-
    in_type_t(enum([automatic_calling_machine, fax, electronic_mail, other_means]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).
