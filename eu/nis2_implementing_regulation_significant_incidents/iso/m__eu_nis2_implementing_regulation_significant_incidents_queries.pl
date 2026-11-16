% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_queries, [nis2_implementing_regulation_significant_incidents_profile_keys/1, nis2_implementing_regulation_significant_incidents_what_if/4, scheduled_interruption_or_maintenance/0, relevant_entity_type/0, direct_financial_loss_euro_cents/0, annual_turnover_preceding_financial_year_euro_cents/0, trade_secret_exfiltration/0, death_of_natural_person/0, considerable_damage_to_natural_person_health/0, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption/0, recurring_incidents_within_six_months/0, same_apparent_root_cause/0, recurring_collective_direct_financial_loss_euro_cents/0, complete_unavailability_seconds/0, average_response_time_above_ten_seconds_seconds/0, limited_availability_seconds/0, weekly_unavailability_seconds/0, complete_unavailability_users/0, limited_availability_users/0, data_compromise_users/0, service_users_in_union/0, data_compromised/0, data_compromise_suspectedly_malicious/0, physical_access_compromised/0, incorrect_data_only_by_misconfiguration/0, incorrect_domain_names/0, managed_domain_names/0, dns_service_provider/0, tld_name_registry/0, cloud_computing_service_provider/0, data_centre_service_provider/0, content_delivery_network_provider/0, managed_service_provider/0, managed_security_service_provider/0, online_marketplace_provider/0, online_search_engine_provider/0, social_networking_services_platform_provider/0, trust_service_provider/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [nis2_implementing_regulation_significant_incidents_input_problems/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [nis2_implementing_regulation_significant_incidents_status/2]).

scheduled_interruption_or_maintenance.

relevant_entity_type.

direct_financial_loss_euro_cents.

annual_turnover_preceding_financial_year_euro_cents.

trade_secret_exfiltration.

death_of_natural_person.

considerable_damage_to_natural_person_health.

suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption.

recurring_incidents_within_six_months.

same_apparent_root_cause.

recurring_collective_direct_financial_loss_euro_cents.

complete_unavailability_seconds.

average_response_time_above_ten_seconds_seconds.

limited_availability_seconds.

weekly_unavailability_seconds.

complete_unavailability_users.

limited_availability_users.

data_compromise_users.

service_users_in_union.

data_compromised.

data_compromise_suspectedly_malicious.

physical_access_compromised.

incorrect_data_only_by_misconfiguration.

incorrect_domain_names.

managed_domain_names.

dns_service_provider.

tld_name_registry.

cloud_computing_service_provider.

data_centre_service_provider.

content_delivery_network_provider.

managed_service_provider.

managed_security_service_provider.

online_marketplace_provider.

online_search_engine_provider.

social_networking_services_platform_provider.

trust_service_provider.

unsure.

nis2_implementing_regulation_significant_incidents_profile_keys([scheduled_interruption_or_maintenance, relevant_entity_type, direct_financial_loss_euro_cents, annual_turnover_preceding_financial_year_euro_cents, trade_secret_exfiltration, death_of_natural_person, considerable_damage_to_natural_person_health, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, recurring_incidents_within_six_months, same_apparent_root_cause, recurring_collective_direct_financial_loss_euro_cents, complete_unavailability_seconds, average_response_time_above_ten_seconds_seconds, limited_availability_seconds, weekly_unavailability_seconds, complete_unavailability_users, limited_availability_users, data_compromise_users, service_users_in_union, data_compromised, data_compromise_suspectedly_malicious, physical_access_compromised, incorrect_data_only_by_misconfiguration, incorrect_domain_names, managed_domain_names]).

nis2_implementing_regulation_significant_incidents_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_implementing_regulation_significant_incidents_status(Hypothesis, NewStatus).

override_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    proper_list_t(Profile, IsList),
    override_by_shape(IsList, Profile, OverriddenKey, NewValue, Hypothesis).

override_by_shape(false, Profile, _, _, Profile).
override_by_shape(true, Profile, OverriddenKey, NewValue, Hypothesis) :-
    drop_attribute(Profile, OverriddenKey, KeptElements),
    append(KeptElements, [attribute(OverriddenKey, NewValue)], Hypothesis).

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Tail],
    proper_list_t(Tail, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

drop_attribute([], _, []).
drop_attribute([Element|Elements], OverriddenKey, KeptElements) :-
    element_has_key_t(Element, OverriddenKey, HasKey),
    keep_element(HasKey, Element, Elements, OverriddenKey, KeptElements).

keep_element(true, _, Elements, OverriddenKey, KeptElements) :-
    drop_attribute(Elements, OverriddenKey, KeptElements).
keep_element(false, Element, Elements, OverriddenKey, [Element|KeptElements]) :-
    drop_attribute(Elements, OverriddenKey, KeptElements).

element_has_key_t(Element, _, false) :-
    var(Element).
element_has_key_t(Element, OverriddenKey, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_has_key_t(Element, OverriddenKey, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_has_key_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).
