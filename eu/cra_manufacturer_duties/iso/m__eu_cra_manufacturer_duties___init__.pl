% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2, date_earlier/2, date_later_of/3, date_not_earlier/2, real_calendar_day/1]).
:- use_module(m__eu_cra_manufacturer_duties_citations, [citation/2, implements/1]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [cra_manufacturer_duties_checklist/2, cra_manufacturer_duties_decision_resolvable/1, cra_manufacturer_duties_status/2, cra_manufacturer_duties_status_values/1, decide_cra_manufacturer_duties/2, requirements_applicability/4, retention_end_date/5, support_period_minimum/4]).
:- use_module(m__eu_cra_manufacturer_duties_queries, [article_14_only/0, cra_manufacturer_duties_profile_keys/1, cra_manufacturer_duties_what_if/4, expected_use_time_in_months/0, information_and_instructions_to_the_user/0, not_applicable_outside_support_period/0, not_yet_applicable/0, placing_on_market_date/0, security_update/0, security_update_issue_date/0, subject_to_requirements/0, substantially_modified_on_or_after_application_date/0, support_period_end_date/0, technical_documentation_and_declaration_of_conformity/0, unsure/0]).
:- use_module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_assess/2, cra_manufacturer_duties_profile_for/2, cra_manufacturer_duties_subject/1]).

root_export(article_14_only).
root_export(date).
root_export(duplicate_key).
root_export(expected_use_time_in_months).
root_export(indeterminate).
root_export(information_and_instructions_to_the_user).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(keep_until).
root_export(minimum_support_period).
root_export(needs_legal_review).
root_export(not_applicable_outside_support_period).
root_export(not_yet_applicable).
root_export(open_textured).
root_export(placing_on_market_date).
root_export(security_update).
root_export(security_update_issue_date).
root_export(subject_to_requirements).
root_export(substantially_modified_on_or_after_application_date).
root_export(support_period_end_date).
root_export(technical_documentation_and_declaration_of_conformity).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
