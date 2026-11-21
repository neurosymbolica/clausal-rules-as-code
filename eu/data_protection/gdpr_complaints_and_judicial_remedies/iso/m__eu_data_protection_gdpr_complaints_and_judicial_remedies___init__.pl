% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [authority_decision_remedy_right/3, authority_inaction_remedy_right/4, complaint_right/3, complaint_right_exists/0, controller_processor_forum/3, controller_processor_remedy_right/3, decide_gdpr_complaints_and_judicial_remedies/2, decision_remedy_right_exists/0, forum_establishment_or_habitual_residence_state/0, forum_establishment_state_only/0, gdpr_complaints_and_judicial_remedies_checklist/2, gdpr_complaints_and_judicial_remedies_decision_resolvable/1, gdpr_complaints_and_judicial_remedies_status/2, gdpr_complaints_and_judicial_remedies_status_values/1, inaction_remedy_right_exists/0, judicial_remedy_right_exists/0, no_complaint_right/0, no_decision_remedy_right/0, no_inaction_remedy_right/0, no_judicial_remedy_right/0]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_queries, [gdpr_complaints_and_judicial_remedies_profile_keys/1, gdpr_complaints_and_judicial_remedies_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_assess/2, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(authority_competent_under_articles_55_and_56).
root_export(authority_handled_the_complaint).
root_export(authority_informed_on_progress_or_outcome).
root_export(complaint_lodged_under_article_77).
root_export(complaint_right_exists).
root_export(cross_reference_unresolved).
root_export(data_subject_considers_processing_infringes_regulation).
root_export(data_subject_considers_rights_infringed_by_processing).
root_export(decision_concerns_the_caller).
root_export(decision_is_legally_binding).
root_export(decision_remedy_right_exists).
root_export(defendant_is_member_state_public_authority_acting_in_public_powers).
root_export(document).
root_export(duplicate_key).
root_export(forum_establishment_or_habitual_residence_state).
root_export(forum_establishment_state_only).
root_export(inaction_remedy_right_exists).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(is_data_subject).
root_export(judicial_remedy_right_exists).
root_export(needs_legal_review).
root_export(no_complaint_right).
root_export(no_decision_remedy_right).
root_export(no_inaction_remedy_right).
root_export(no_judicial_remedy_right).
root_export(not_attempted).
root_export(open_textured).
root_export(outside_fact).
root_export(provenance).
root_export(resolution).
root_export(three_months_from_the_complaint_have_passed).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
