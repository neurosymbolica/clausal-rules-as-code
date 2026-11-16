% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2, gdpr_cooperation_with_the_supervisory_authority_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [decide_gdpr_cooperation_with_the_supervisory_authority/2]).

gdpr_cooperation_with_the_supervisory_authority_subject(wrong_type_role_key).
gdpr_cooperation_with_the_supervisory_authority_subject(wrong_type_control).
gdpr_cooperation_with_the_supervisory_authority_subject(duplicate_role_key).
gdpr_cooperation_with_the_supervisory_authority_subject(duplicate_control).
gdpr_cooperation_with_the_supervisory_authority_subject(unknown_key_given).
gdpr_cooperation_with_the_supervisory_authority_subject(unknown_key_control).
gdpr_cooperation_with_the_supervisory_authority_subject(no_request_made).
gdpr_cooperation_with_the_supervisory_authority_subject(request_made_and_cooperated).
gdpr_cooperation_with_the_supervisory_authority_subject(request_outside_authority_tasks).
gdpr_cooperation_with_the_supervisory_authority_subject(request_within_authority_tasks).
gdpr_cooperation_with_the_supervisory_authority_subject(caller_not_bound).
gdpr_cooperation_with_the_supervisory_authority_subject(representative_alone_bound).
gdpr_cooperation_with_the_supervisory_authority_subject(processor_key_missing).
gdpr_cooperation_with_the_supervisory_authority_subject(processor_key_given).
gdpr_cooperation_with_the_supervisory_authority_subject(request_key_missing).
gdpr_cooperation_with_the_supervisory_authority_subject(request_key_given).
gdpr_cooperation_with_the_supervisory_authority_subject(cooperation_statement_absent).
gdpr_cooperation_with_the_supervisory_authority_subject(cooperation_statement_attested_false).
gdpr_cooperation_with_the_supervisory_authority_subject(unsure_and_statement_absent).
gdpr_cooperation_with_the_supervisory_authority_subject(unsure_and_statement_given).
gdpr_cooperation_with_the_supervisory_authority_subject(tasks_judgement_unsure).
gdpr_cooperation_with_the_supervisory_authority_subject(tasks_judgement_true).

gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_type_role_key, [attribute(acts_as_controller, unsure), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_type_control, [attribute(acts_as_controller, true), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(duplicate_role_key, [attribute(acts_as_controller, true), attribute(acts_as_controller, true), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(duplicate_control, [attribute(acts_as_controller, true), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(unknown_key_given, [attribute(as_of_date, monday), attribute(acts_as_controller, true), attribute(as_of_date, tuesday), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(unknown_key_control, [attribute(acts_as_controller, true), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request_made, [attribute(acts_as_controller, true), attribute(authority_request_made, false), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_outside_authority_tasks, [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, false), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_within_authority_tasks, [attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(caller_not_bound, [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(representative_alone_bound, [attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(processor_key_missing, [attribute(acts_as_controller, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(processor_key_given, [attribute(acts_as_controller, false), attribute(acts_as_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_key_missing, [attribute(acts_as_controller, true)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(request_key_given, [attribute(acts_as_controller, true), attribute(authority_request_made, false)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_absent, [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_attested_false, [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(false, attestation(compliance_desk, received_2026_11_12, no_reply_sent, document(upload_seven, digest_seven))))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(unsure_and_statement_absent, [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure)]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(unsure_and_statement_given, [attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(tasks_judgement_unsure, [attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, url(address_seven, retrieved_2026_11_12))))]).
gdpr_cooperation_with_the_supervisory_authority_profile_for(tasks_judgement_true, [attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, url(address_seven, retrieved_2026_11_12))))]).

gdpr_cooperation_with_the_supervisory_authority_assess(Subject, Result) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, Result).
