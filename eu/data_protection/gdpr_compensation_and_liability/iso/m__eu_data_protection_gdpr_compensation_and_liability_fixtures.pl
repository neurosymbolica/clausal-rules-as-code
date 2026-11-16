% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2, gdpr_compensation_and_liability_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [decide_gdpr_compensation_and_liability/2]).

gdpr_compensation_and_liability_subject(controller_liable).
gdpr_compensation_and_liability_subject(controller_exempt).
gdpr_compensation_and_liability_subject(controller_not_involved).
gdpr_compensation_and_liability_subject(controller_statement_absent).
gdpr_compensation_and_liability_subject(processor_liable_by_breach).
gdpr_compensation_and_liability_subject(processor_liable_by_instructions).
gdpr_compensation_and_liability_subject(processor_outside_both_false).
gdpr_compensation_and_liability_subject(damage_false_role_absent).
gdpr_compensation_and_liability_subject(infringement_false_outside_caller).
gdpr_compensation_and_liability_subject(causation_false).
gdpr_compensation_and_liability_subject(judgement_absent).
gdpr_compensation_and_liability_subject(role_absent).
gdpr_compensation_and_liability_subject(controller_involvement_absent).
gdpr_compensation_and_liability_subject(processor_keys_absent).
gdpr_compensation_and_liability_subject(processor_second_key_absent).
gdpr_compensation_and_liability_subject(outside_caller_unsure).
gdpr_compensation_and_liability_subject(inside_statement_absent_with_unsure).
gdpr_compensation_and_liability_subject(inside_unsure).
gdpr_compensation_and_liability_subject(input_wrong_type_crisp_unsure).
gdpr_compensation_and_liability_subject(input_duplicate_key).
gdpr_compensation_and_liability_subject(input_unknown_key).
gdpr_compensation_and_liability_subject(input_not_attribute_list).
gdpr_compensation_and_liability_subject(input_unbound_value).

gdpr_compensation_and_liability_profile_for(controller_liable, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(controller_exempt, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, reason_given, url(evidence_address, retrieved_at))))]).
gdpr_compensation_and_liability_profile_for(controller_not_involved, [attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(controller_statement_absent, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(processor_liable_by_breach, [attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, document(upload_identifier, content_hash))))]).
gdpr_compensation_and_liability_profile_for(processor_liable_by_instructions, [attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(processor_outside_both_false, [attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(damage_false_role_absent, [attribute(damage_suffered, false), attribute(infringement_of_the_regulation_occurred, unsure)]).
gdpr_compensation_and_liability_profile_for(infringement_false_outside_caller, [attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, false), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(causation_false, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, false), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(judgement_absent, [attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure)]).
gdpr_compensation_and_liability_profile_for(role_absent, [attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(controller_involvement_absent, [attribute(party_role, controller), attribute(processor_breached_obligations_directed_to_processors, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(processor_keys_absent, [attribute(party_role, processor), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(processor_second_key_absent, [attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(outside_caller_unsure, [attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, unsure), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(inside_statement_absent_with_unsure, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure), attribute(damage_resulted_from_the_infringement, true)]).
gdpr_compensation_and_liability_profile_for(inside_unsure, [attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, unsure), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))]).
gdpr_compensation_and_liability_profile_for(input_wrong_type_crisp_unsure, [attribute(party_role, controller), attribute(involved_in_the_processing, unsure), attribute(damage_suffered, true)]).
gdpr_compensation_and_liability_profile_for(input_duplicate_key, [attribute(damage_suffered, true), attribute(damage_suffered, true)]).
gdpr_compensation_and_liability_profile_for(input_unknown_key, [attribute(damage_suffered, true), attribute(colour, red)]).
gdpr_compensation_and_liability_profile_for(input_not_attribute_list, [damage_suffered - true]).
gdpr_compensation_and_liability_profile_for(input_unbound_value, [attribute(damage_suffered, _UnboundValue)]).

gdpr_compensation_and_liability_assess(Subject, Result) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    decide_gdpr_compensation_and_liability(Profile, Result).
