% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_kernel, [post_market_monitoring_input_problems/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_citations, [citation/2, implements/1]).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [decide_post_market_monitoring/2, post_market_monitoring_checklist/2, post_market_monitoring_decision_resolvable/1, post_market_monitoring_duty_status/4, post_market_monitoring_integration_status/3, post_market_monitoring_status/2, post_market_monitoring_status_values/1]).
:- use_module(m__eu_ai_act_post_market_monitoring_queries, [compliance_required_by_2_august_2030/0, compliance_required_by_31_december_2030/0, duty_applies/0, existing_system_without_significant_changes_not_covered/0, integration_available/0, integration_not_available/0, not_a_high_risk_ai_system/0, not_a_provider/0, not_applicable_on_date/0, post_market_monitoring_profile_keys/1, post_market_monitoring_what_if/4]).
:- use_module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_assess/2, post_market_monitoring_profile_for/2, post_market_monitoring_subject/1]).

root_export(compliance_required_by_2_august_2030).
root_export(compliance_required_by_31_december_2030).
root_export(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027).
root_export(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i).
root_export(date).
root_export(duplicate_key).
root_export(duty_applies).
root_export(existing_system_without_significant_changes_not_covered).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(integration_achieves_an_equivalent_level_of_protection).
root_export(integration_available).
root_export(integration_not_available).
root_export(intended_to_be_used_by_public_authorities).
root_export(needs_legal_review).
root_export(not_a_high_risk_ai_system).
root_export(not_a_provider).
root_export(not_applicable_on_date).
root_export(open_textured).
root_export(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date).
root_export(point_5_annex_iii_system_of_a_financial_institution_under_union_financial_services_law).
root_export(post_market_monitoring_system_and_plan_already_established_under_that_legislation).
root_export(provenance).
root_export(provider_of_the_system).
root_export(significant_changes_in_design_as_from_the_chapter_iii_date).
root_export(system_is_a_high_risk_ai_system_listed_in_annex_iii).
root_export(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
