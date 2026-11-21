% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2, foreign_judgment_or_decision_recognition/4, gdpr_chapter_v_extras_checklist/2, gdpr_chapter_v_extras_decision_resolvable/1, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_status_values/1, onward_transfer_condition/4, second_subparagraph_duty/5]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_queries, [article_48_not_engaged/0, document_assessment_and_safeguards/0, duty_met/0, duty_not_met/0, gdpr_chapter_v_extras_profile_keys/1, gdpr_chapter_v_extras_what_if/4, inform_data_subject/0, inform_supervisory_authority/0, no_second_subparagraph_transfer/0, not_a_processor_duty/0, not_an_onward_transfer/0, not_barred_by_article_48/0, not_recognisable_or_enforceable/0, onward_transfer_may_not_take_place/0, onward_transfer_may_take_place/0]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_assess/2, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_subject/1]).

root_export(absent).
root_export(article_48_not_engaged).
root_export(assessment_documented_in_records).
root_export(attestation).
root_export(attested).
root_export(controller).
root_export(cross_reference_unresolved).
root_export(data_subject_informed_of_compelling_legitimate_interests).
root_export(data_subject_informed_of_transfer).
root_export(document).
root_export(document_assessment_and_safeguards).
root_export(duplicate_key).
root_export(duty_met).
root_export(duty_not_met).
root_export(indeterminate).
root_export(inform_data_subject).
root_export(inform_supervisory_authority).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(international_agreement_basis_for_judgment_or_decision).
root_export(needs_legal_review).
root_export(no_second_subparagraph_transfer).
root_export(not_a_processor_duty).
root_export(not_an_onward_transfer).
root_export(not_attempted).
root_export(not_barred_by_article_48).
root_export(not_recognisable_or_enforceable).
root_export(onward_transfer_has_chapter_v_basis).
root_export(onward_transfer_may_not_take_place).
root_export(onward_transfer_may_take_place).
root_export(outside_fact).
root_export(party_role).
root_export(processor).
root_export(resolution).
root_export(suitable_safeguards_documented_in_records).
root_export(supervisory_authority_informed_of_transfer).
root_export(third_country_judgment_or_decision_requires_transfer).
root_export(transfer_is_onward_transfer).
root_export(transfer_relies_on_article_49_1_second_subparagraph).
root_export(unknown_key).
root_export(url).
root_export(wrong_type).
