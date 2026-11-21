% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2, gdpr_joint_controllers_checklist/2, gdpr_joint_controllers_decision_resolvable/1, gdpr_joint_controllers_status/2, gdpr_joint_controllers_status_values/1, liability_for_the_entire_damage/4, liable_for_the_entire_damage/0, no_other_responsible_party/0, not_entitled_to_claim_back/0, not_joint_controllers/0, not_responsible_for_the_damage/0, recourse_after_full_compensation/4, rights_against_each_joint_controller/3, rights_exercisable_against_this_controller/0]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_queries, [gdpr_joint_controllers_profile_keys/1, gdpr_joint_controllers_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_assess/2, gdpr_joint_controllers_profile_for/2, gdpr_joint_controllers_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(controllers_jointly_determine_purposes_and_means).
root_export(cross_reference_unresolved).
root_export(document).
root_export(duplicate_key).
root_export(entitled_to_claim_back).
root_export(full_compensation_paid).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(liable_for_the_entire_damage).
root_export(needs_legal_review).
root_export(no_other_responsible_party).
root_export(not_attempted).
root_export(not_entitled_to_claim_back).
root_export(not_joint_controllers).
root_export(not_responsible_for_the_damage).
root_export(open_textured).
root_export(other_responsible_parties).
root_export(outside_fact).
root_export(resolution).
root_export(responsible_under_article_82_2_and_3).
root_export(rights_exercisable_against_this_controller).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
