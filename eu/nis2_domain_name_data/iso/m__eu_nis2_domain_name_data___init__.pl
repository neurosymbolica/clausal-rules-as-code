% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_citations, [citation/2, implements/1]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [access_duty/3, access_reply_timeliness/3, decide_nis2_domain_name_data/2, nis2_domain_name_data_checklist/2, nis2_domain_name_data_decision_resolvable/1, nis2_domain_name_data_status/2, nis2_domain_name_data_status_values/1, provider_duties/2, publication_duty/3, required_registration_data/2]).
:- use_module(m__eu_nis2_domain_name_data_queries, [domain_name_registration_service_entity/0, duplicate_key/1, duty/2, field/2, indeterminate/1, input_problems/1, inputs_relied_on/1, late/1, must_provide_access/0, must_publish_without_undue_delay/0, needs_legal_review/2, nis2_domain_name_data_hours_elapsed/3, nis2_domain_name_data_profile_keys/1, nis2_domain_name_data_reply_deadline/2, nis2_domain_name_data_what_if/4, no_duty_to_provide_access/0, no_publication_duty/0, on_time/0, open_textured/2, other/0, point_of_contact_email_address_differs_from_registrant/0, point_of_contact_telephone_number_differs_from_registrant/0, provenance/2, provider_type/0, registration_data_is_personal_data/0, reply_without_undue_delay/0, request_is_lawful_and_duly_substantiated/0, requester_is_legitimate_access_seeker/0, tld_name_registry/0, unknown_key/1, unsure/0, wrong_type/1]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_assess/2, nis2_domain_name_data_hours_for/2, nis2_domain_name_data_profile_for/2, nis2_domain_name_data_subject/1]).

root_export(domain_name_registration_service_entity).
root_export(must_provide_access).
root_export(must_publish_without_undue_delay).
root_export(no_duty_to_provide_access).
root_export(no_publication_duty).
root_export(on_time).
root_export(other).
root_export(point_of_contact_email_address_differs_from_registrant).
root_export(point_of_contact_telephone_number_differs_from_registrant).
root_export(provider_type).
root_export(registration_data_is_personal_data).
root_export(reply_without_undue_delay).
root_export(request_is_lawful_and_duly_substantiated).
root_export(requester_is_legitimate_access_seeker).
root_export(tld_name_registry).
root_export(unsure).
