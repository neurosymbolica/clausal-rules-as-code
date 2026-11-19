% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_virginia_vcdpa_kernel, [date_argument_problems/2, query_problems/3, value_or_absent/3, virginia_vcdpa_input_problems/2]).
:- use_module(m__us_virginia_vcdpa_citations, [citation/2, implements/1]).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [action_may_be_initiated/0, appeal_response_deadline/4, applicability_status/3, attorney_general_action_status/5, civil_penalty_maximum/3, cure_period_last_day/4, cure_period_running/0, decide_virginia_vcdpa/2, exempt_entity/0, extended_response_deadline/4, in_scope/0, no_action_for_cured_violation/0, no_extension_available/0, notice_not_yet_provided/0, out_of_scope/0, response_deadline/4, virginia_vcdpa_checklist/2, virginia_vcdpa_decision_resolvable/1, virginia_vcdpa_status/2, virginia_vcdpa_status_values/1]).
:- use_module(m__us_virginia_vcdpa_queries, [conducts_business_in_or_targets_virginia/0, consumer_count/0, continued_violation_or_statement_breached/0, cured_with_express_written_statement/0, entity_category/0, extension_notice_given_within_initial_period/0, extension_reasonably_necessary/0, financial_institution_subject_to_glba/0, hipaa_covered_entity_or_business_associate/0, institution_of_higher_education/0, none_of_the_exempt_categories/0, nonprofit_organization/0, over_half_of_gross_revenue_from_sale/0, public_body_of_the_commonwealth/0, unsure/0, violation_count/0, virginia_vcdpa_applicability_threshold/3, virginia_vcdpa_consumer_count_boundary/2, virginia_vcdpa_profile_keys/1, virginia_vcdpa_what_if/4]).
:- use_module(m__us_virginia_vcdpa_fixtures, [virginia_vcdpa_assess/2, virginia_vcdpa_profile_for/2, virginia_vcdpa_subject/1]).

root_export(action_may_be_initiated).
root_export(conducts_business_in_or_targets_virginia).
root_export(consumer_count).
root_export(continued_violation_or_statement_breached).
root_export(cure_period_running).
root_export(cured_with_express_written_statement).
root_export(duplicate_key).
root_export(entity_category).
root_export(exempt_entity).
root_export(extension_notice_given_within_initial_period).
root_export(extension_reasonably_necessary).
root_export(financial_institution_subject_to_glba).
root_export(hipaa_covered_entity_or_business_associate).
root_export(in_scope).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(institution_of_higher_education).
root_export(needs_legal_review).
root_export(no_action_for_cured_violation).
root_export(no_extension_available).
root_export(none_of_the_exempt_categories).
root_export(nonprofit_organization).
root_export(notice_not_yet_provided).
root_export(open_textured).
root_export(out_of_scope).
root_export(over_half_of_gross_revenue_from_sale).
root_export(provenance).
root_export(public_body_of_the_commonwealth).
root_export(unknown_key).
root_export(unsure).
root_export(violation_count).
root_export(wrong_type).
