% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_subject/1, gdpr_joint_controllers_profile_for/2, gdpr_joint_controllers_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2]).

gdpr_joint_controllers_subject(joint_processor_entitled_to_claim_back).
gdpr_joint_controllers_subject(partial_payment_near_miss).
gdpr_joint_controllers_subject(sole_responsible_party_near_miss).
gdpr_joint_controllers_subject(not_responsible_near_miss).
gdpr_joint_controllers_subject(payment_judgement_unsure).
gdpr_joint_controllers_subject(payment_not_yet_stated).
gdpr_joint_controllers_subject(other_parties_not_yet_known).
gdpr_joint_controllers_subject(statement_absent_referred).
gdpr_joint_controllers_subject(statement_absent_no_other_party).
gdpr_joint_controllers_subject(malformed_bare_statement).
gdpr_joint_controllers_subject(malformed_party_identifier).
gdpr_joint_controllers_subject(malformed_duplicate_payment).

gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, url(statement_location, retrieved_moment)))), attribute(other_responsible_parties, [controller_b, processor_c]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(partial_payment_near_miss, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, url(statement_location, retrieved_moment)))), attribute(other_responsible_parties, [controller_b, processor_c]), attribute(full_compensation_paid, false)]).
gdpr_joint_controllers_profile_for(sole_responsible_party_near_miss, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, url(statement_location, retrieved_moment)))), attribute(other_responsible_parties, []), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(not_responsible_near_miss, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, attested(false, attestation(compensation_order_host, determination_moment, exempt_from_liability, document(statement_upload, statement_digest)))), attribute(other_responsible_parties, [controller_b, processor_c]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(payment_judgement_unsure, [attribute(controllers_jointly_determine_purposes_and_means, unsure), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, none))), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)]).
gdpr_joint_controllers_profile_for(payment_not_yet_stated, [attribute(controllers_jointly_determine_purposes_and_means, false), attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, none))), attribute(other_responsible_parties, [controller_b])]).
gdpr_joint_controllers_profile_for(other_parties_not_yet_known, [attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, none))), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(statement_absent_referred, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(statement_absent_no_other_party, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(other_responsible_parties, []), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(malformed_bare_statement, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, true), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(malformed_party_identifier, [attribute(responsible_under_article_82_2_and_3, attested(true, attestation(compensation_order_host, determination_moment, liable_for_damage, none))), attribute(other_responsible_parties, [controller_b, 42]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(malformed_duplicate_payment, [attribute(full_compensation_paid, true), attribute(arrangement_names_contact_point, true), attribute(full_compensation_paid, false)]).

gdpr_joint_controllers_assess(Subject, Result) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    decide_gdpr_joint_controllers(Profile, Result).
