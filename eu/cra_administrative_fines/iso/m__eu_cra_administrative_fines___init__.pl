% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_calendar_day_t/2, cra_administrative_fines_contract_keys/1, cra_administrative_fines_input_problems/2]).
:- use_module(m__eu_cra_administrative_fines_citations, [citation/2, implements/1]).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, cra_administrative_fines_checklist/2, cra_administrative_fines_decision_resolvable/1, cra_administrative_fines_status/2, cra_administrative_fines_status_values/1, decide_cra_administrative_fines/2]).
:- use_module(m__eu_cra_administrative_fines_queries, [annex_i_essential_cybersecurity_requirements/0, article_13/0, article_14/0, article_18/0, article_19/0, article_20/0, article_21/0, article_22/0, article_23/0, article_28/0, article_30_paragraphs_1_to_4/0, article_31_paragraphs_1_to_4/0, article_32_paragraphs_1_to_3/0, article_33_paragraph_5/0, article_39/0, article_41/0, article_47/0, article_49/0, article_53/0, cra_administrative_fines_profile_keys/1, cra_administrative_fines_what_if/4, date/3, incorrect_incomplete_or_misleading_information_in_reply_to_request/0, infringed_provision/0, not_listed_in_article_64/0, not_yet_applicable/0, offender_is_open_source_software_steward/0, offender_is_undertaking/0, other_provision/0, total_worldwide_annual_turnover_in_euros/0, unsure/0]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_assess/2, cra_administrative_fines_profile_for/2, cra_administrative_fines_subject/1]).

root_export(annex_i_essential_cybersecurity_requirements).
root_export(article_13).
root_export(article_14).
root_export(article_18).
root_export(article_19).
root_export(article_20).
root_export(article_21).
root_export(article_22).
root_export(article_23).
root_export(article_28).
root_export(article_30_paragraphs_1_to_4).
root_export(article_31_paragraphs_1_to_4).
root_export(article_32_paragraphs_1_to_3).
root_export(article_33_paragraph_5).
root_export(article_39).
root_export(article_41).
root_export(article_47).
root_export(article_49).
root_export(article_53).
root_export(duplicate_key).
root_export(fine_excluded).
root_export(fine_maximum).
root_export(incorrect_incomplete_or_misleading_information_in_reply_to_request).
root_export(indeterminate).
root_export(infringed_provision).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(not_listed_in_article_64).
root_export(not_yet_applicable).
root_export(offender_is_open_source_software_steward).
root_export(offender_is_undertaking).
root_export(open_textured).
root_export(other_provision).
root_export(provenance).
root_export(total_worldwide_annual_turnover_in_euros).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
