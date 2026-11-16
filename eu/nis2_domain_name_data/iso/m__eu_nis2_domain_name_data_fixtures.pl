% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_subject/1, nis2_domain_name_data_profile_for/2, nis2_domain_name_data_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2]).

nis2_domain_name_data_subject(registry_addressed).
nis2_domain_name_data_subject(registrar_addressed).
nis2_domain_name_data_subject(other_provider).
nis2_domain_name_data_subject(no_provider_type).
nis2_domain_name_data_subject(invalid_provider_type).

nis2_domain_name_data_profile_for(registry_addressed, [attribute(provider_type, tld_name_registry), attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, false), attribute(registration_data_is_personal_data, false), attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true), attribute(reply_without_undue_delay, true)]).
nis2_domain_name_data_profile_for(registrar_addressed, [attribute(provider_type, domain_name_registration_service_entity), attribute(point_of_contact_email_address_differs_from_registrant, false), attribute(point_of_contact_telephone_number_differs_from_registrant, false), attribute(registration_data_is_personal_data, true), attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, false), attribute(reply_without_undue_delay, false)]).
nis2_domain_name_data_profile_for(other_provider, [attribute(provider_type, other), attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, false), attribute(registration_data_is_personal_data, false), attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true), attribute(reply_without_undue_delay, true)]).
nis2_domain_name_data_profile_for(no_provider_type, []).
nis2_domain_name_data_profile_for(invalid_provider_type, [attribute(provider_type, bogus)]).

nis2_domain_name_data_assess(Subject, Result) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    decide_nis2_domain_name_data(Profile, Result).
