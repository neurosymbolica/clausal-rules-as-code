% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_subject/1, gdpr_joint_controllers_profile_for/2, gdpr_joint_controllers_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2]).

gdpr_joint_controllers_subject(claim_back_after_full_payment).
gdpr_joint_controllers_subject(claim_back_after_partial_payment).
gdpr_joint_controllers_subject(claim_back_payment_unsure).
gdpr_joint_controllers_subject(claim_back_payment_not_stated).
gdpr_joint_controllers_subject(sole_responsible_party).
gdpr_joint_controllers_subject(party_not_responsible).
gdpr_joint_controllers_subject(responsibility_statement_absent).
gdpr_joint_controllers_subject(other_parties_not_stated).
gdpr_joint_controllers_subject(duplicate_payment_key).
gdpr_joint_controllers_subject(arrangement_key_supplied).

stated_responsibility(true, attested(true, attestation(host_service, attested_moment, stated_reason, none))).
stated_responsibility(false, attested(false, attestation(host_service, attested_moment, stated_reason, document(upload_identifier, content_hash)))).

gdpr_joint_controllers_profile_for(claim_back_after_full_payment, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, true)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, false)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(claim_back_payment_unsure, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, unsure)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(claim_back_payment_not_stated, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha])]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(sole_responsible_party, [attribute(controllers_jointly_determine_purposes_and_means, false), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, []), attribute(full_compensation_paid, true)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(party_not_responsible, [attribute(controllers_jointly_determine_purposes_and_means, unsure), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, true)]) :-
    stated_responsibility(false, Attested).
gdpr_joint_controllers_profile_for(responsibility_statement_absent, [attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, true)]).
gdpr_joint_controllers_profile_for(other_parties_not_stated, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, true)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(duplicate_payment_key, [attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta]), attribute(full_compensation_paid, true), attribute(full_compensation_paid, true)]) :-
    stated_responsibility(true, Attested).
gdpr_joint_controllers_profile_for(arrangement_key_supplied, [attribute(controllers_jointly_determine_purposes_and_means, true), attribute(arrangement_terms, allocated)]).

gdpr_joint_controllers_assess(Subject, Result) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    decide_gdpr_joint_controllers(Profile, Result).
