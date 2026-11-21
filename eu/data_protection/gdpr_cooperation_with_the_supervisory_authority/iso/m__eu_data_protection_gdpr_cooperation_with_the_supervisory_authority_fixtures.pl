% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2, gdpr_cooperation_with_the_supervisory_authority_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [decide_gdpr_cooperation_with_the_supervisory_authority/2]).

gdpr_cooperation_with_the_supervisory_authority_subject(controller_cooperated).
gdpr_cooperation_with_the_supervisory_authority_subject(controller_refused).
gdpr_cooperation_with_the_supervisory_authority_subject(representative_cooperated).
gdpr_cooperation_with_the_supervisory_authority_subject(not_bound).
gdpr_cooperation_with_the_supervisory_authority_subject(no_request).
gdpr_cooperation_with_the_supervisory_authority_subject(no_request_roles_absent).
gdpr_cooperation_with_the_supervisory_authority_subject(request_inside_tasks).
gdpr_cooperation_with_the_supervisory_authority_subject(request_outside_tasks).
gdpr_cooperation_with_the_supervisory_authority_subject(role_unknown).
gdpr_cooperation_with_the_supervisory_authority_subject(role_stated_false).
gdpr_cooperation_with_the_supervisory_authority_subject(two_keys_missing).
gdpr_cooperation_with_the_supervisory_authority_subject(statement_missing_true).
gdpr_cooperation_with_the_supervisory_authority_subject(statement_missing_unsure).
gdpr_cooperation_with_the_supervisory_authority_subject(judgement_unsure).
gdpr_cooperation_with_the_supervisory_authority_subject(duplicate_and_unknown).
gdpr_cooperation_with_the_supervisory_authority_subject(wrong_types).

gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(false, attestation(compliance_officer, recorded_on_twelfth_november, no_response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(representative_cooperated, Profile) :-
    Profile = [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(union_representative, recorded_on_twelfth_november, documents_supplied, document(upload_identifier_one, digest_value_one))))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(not_bound, Profile) :-
    Profile = [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(union_representative, recorded_on_twelfth_november, documents_supplied, document(upload_identifier_one, digest_value_one))))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, false), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request_roles_absent, Profile) :-
    Profile = [attribute(authority_request_made, false)].
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_inside_tasks, Profile) :-
    Profile = [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(processor_officer, recorded_on_twelfth_november, access_granted, url(address_of_record, retrieved_on_twelfth_november))))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_outside_tasks, Profile) :-
    Profile = [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, false), attribute(cooperation_given, attested(true, attestation(processor_officer, recorded_on_twelfth_november, access_granted, url(address_of_record, retrieved_on_twelfth_november))))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(role_unknown, Profile) :-
    Profile = [attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(role_stated_false, Profile) :-
    Profile = [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(two_keys_missing, Profile) :-
    Profile = [attribute(acts_as_controller, true)].
gdpr_cooperation_with_the_supervisory_authority_profile_for(statement_missing_true, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)].
gdpr_cooperation_with_the_supervisory_authority_profile_for(statement_missing_unsure, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure)].
gdpr_cooperation_with_the_supervisory_authority_profile_for(judgement_unsure, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)))].
gdpr_cooperation_with_the_supervisory_authority_profile_for(duplicate_and_unknown, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(colour, blue)].
gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_types, Profile) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, unsure), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, yes)].

gdpr_cooperation_with_the_supervisory_authority_assess(Subject, Result) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, Result).
