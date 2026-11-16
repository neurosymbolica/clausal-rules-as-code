% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [access_answer_items/4, access_answer_items_missing/4, copy_fee/3, copy_scope/3, decide_gdpr_art15_access_copy/2, gdpr_art15_access_copy_checklist/2, gdpr_art15_access_copy_decision_resolvable/1, gdpr_art15_access_copy_status/2, gdpr_art15_access_copy_status_values/1, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_queries, [access_to_personal_data/0, automated_decision_making_information/0, categories_of_personal_data/0, commonly_used_electronic_form/0, confirmation_of_processing/0, copy_limited_by_rights_and_freedoms_of_others/0, copy_of_personal_data/0, full_copy/0, gdpr_art15_access_copy_compliance/4, gdpr_art15_access_copy_deadline/3, gdpr_art15_access_copy_profile_keys/1, gdpr_art15_access_copy_what_if/4, no_electronic_request/0, no_fee_under_article_15_3/0, no_item_missing/0, no_personal_data_to_copy/0, other_form_requested/0, purposes_of_processing/0, reasonable_fee_permitted/0, recipients_or_categories_of_recipients/0, right_to_lodge_complaint/0, rights_to_rectification_erasure_restriction_and_objection/0, source_of_personal_data/0, storage_period_or_criteria/0, transfer_safeguards_information/0]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_assess/2, gdpr_art15_access_copy_profile_for/2, gdpr_art15_access_copy_subject/1]).

root_export(absent).
root_export(access_to_personal_data).
root_export(attestation).
root_export(attested).
root_export(automated_decision_making_information).
root_export(automated_decision_making_referred_to_in_article_22).
root_export(categories_of_personal_data).
root_export(commonly_used_electronic_form).
root_export(confirmation_of_processing).
root_export(copy_limited_by_rights_and_freedoms_of_others).
root_export(copy_of_personal_data).
root_export(copy_would_adversely_affect_rights_and_freedoms_of_others).
root_export(cross_reference_unresolved).
root_export(disclosure_to_recipients_made_or_envisaged).
root_export(document).
root_export(duplicate_key).
root_export(full_copy).
root_export(further_copy_requested).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(items_provided).
root_export(needs_legal_review).
root_export(no_electronic_request).
root_export(no_fee_under_article_15_3).
root_export(no_item_missing).
root_export(no_personal_data_to_copy).
root_export(not_attempted).
root_export(open_textured).
root_export(other_form_requested).
root_export(other_form_requested_by_data_subject).
root_export(outside_fact).
root_export(personal_data_concerning_data_subject_processed).
root_export(purposes_of_processing).
root_export(reasonable_fee_permitted).
root_export(recipients_or_categories_of_recipients).
root_export(request_made_by_electronic_means).
root_export(resolution).
root_export(right_to_lodge_complaint).
root_export(rights_to_rectification_erasure_restriction_and_objection).
root_export(some_personal_data_not_collected_from_data_subject).
root_export(source_information_available).
root_export(source_of_personal_data).
root_export(storage_period_or_criteria).
root_export(transfer_safeguards_information).
root_export(transfer_subject_to_article_46_safeguards).
root_export(transfer_to_third_country_or_international_organisation).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
