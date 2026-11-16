% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_subject/1, gdpr_data_subject_rights_portability_and_objection_profile_for/2, gdpr_data_subject_rights_portability_and_objection_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis, [decide_request_basis/2]).

gdpr_data_subject_rights_portability_and_objection_subject(Subject) :-
    fixture(Subject, _).

gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile) :-
    fixture(Subject, Profile).

gdpr_data_subject_rights_portability_and_objection_assess(Subject, Result) :-
    fixture(Subject, Profile),
    decide_request_basis(Profile, Result).

fixture(portability_positive, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
fixture(portability_not_automated, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, false)]).
fixture(portability_public_task, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)]).
fixture(portability_public_task_false, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, false)]).
fixture(portability_rights_of_others, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, true)]).
fixture(portability_rights_of_others_false, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, false)]).
fixture(portability_suspended, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)]).
fixture(portability_identity_confirmed, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, true)]).
fixture(portability_missing_key, [attribute(request_type, portability), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
fixture(portability_public_task_unsure, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, unsure)]).
fixture(portability_unable_to_identify, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(controller_demonstrates_unable_to_identify_data_subject, true)]).
fixture(portability_restriction_attested, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(host, now, statute, none)))]).
fixture(portability_restriction_denied, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(host, now, statute, none)))]).
fixture(objection_art21_1_positive, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true)]).
fixture(objection_art21_1_not_art6_e_f, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, false), attribute(objection_grounds_relate_to_particular_situation, true)]).
fixture(objection_art21_1_compelling, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)]).
fixture(objection_art21_1_legal_claims, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_legal_claims, true)]).
fixture(objection_art21_1_compelling_false, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, false), attribute(processing_necessary_for_legal_claims, false)]).
fixture(objection_missing_ground, [attribute(request_type, objection)]).
fixture(objection_art21_2_positive, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true)]).
fixture(objection_art21_2_not_marketing, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, false)]).
fixture(objection_art21_2_excessive, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(request_manifestly_unfounded_or_excessive, true)]).
fixture(objection_art21_2_not_excessive, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(request_manifestly_unfounded_or_excessive, false)]).
fixture(objection_art21_6_positive, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_6), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, true), attribute(objection_grounds_relate_to_particular_situation, true)]).
fixture(objection_art21_6_not_research, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_6), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false), attribute(objection_grounds_relate_to_particular_situation, true)]).
fixture(objection_art21_6_public_task, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_6), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_public_task_or_official_authority, true)]).
fixture(absent_request_type, []).
fixture(unknown_key_problem, [attribute(no_such_key, true)]).
