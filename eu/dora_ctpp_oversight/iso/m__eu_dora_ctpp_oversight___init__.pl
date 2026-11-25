% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(m__eu_dora_ctpp_oversight_citations, [citation/2, implements/1]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [ctpp_competent_authority_measure_condition/3, ctpp_lead_overseer_powers/3, ctpp_oversight_duties_required/3, ctpp_periodic_penalty_payment_limits/3, ctpp_periodic_penalty_payment_status/3, ctpp_response_window_status/3, decide_dora_ctpp_oversight/2, dora_ctpp_oversight_checklist/2, dora_ctpp_oversight_decision_resolvable/1, dora_ctpp_oversight_status/2, dora_ctpp_oversight_status_values/1]).
:- use_module(m__eu_dora_ctpp_oversight_queries, [dora_ctpp_oversight_profile_keys/1, dora_ctpp_oversight_what_if/4, lead_overseer_agreement_required/0, no_article_33_5_condition/0, no_penalty_ground_full_compliance/0, no_penalty_ground_recommendation/0, not_designated_as_critical/0, penalty_decision_required/0]).
:- use_module(m__eu_dora_ctpp_oversight_fixtures, [dora_ctpp_oversight_assess/2, dora_ctpp_oversight_profile_for/2, dora_ctpp_oversight_subject/1]).

root_export(amount).
root_export(annual_oversight_plan_adopted_and_notified).
root_export(assessment_date).
root_export(conduct_general_investigations_and_inspections).
root_export(cooperate_in_good_faith_with_lead_overseer).
root_export(date).
root_export(draft_oversight_plan_received_on).
root_export(duplicate_key).
root_export(envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country).
root_export(full).
root_export(general_investigation).
root_export(indeterminate).
root_export(information_request).
root_export(input_problems).
root_export(inspection).
root_export(issue_recommendations).
root_export(lead_overseer_agreement_required).
root_export(lead_overseer_deems_clear_and_serious_risk).
root_export(measure_compliance).
root_export(measure_notification_received_on).
root_export(measure_power).
root_export(no_article_33_5_condition).
root_export(no_penalty_ground_full_compliance).
root_export(no_penalty_ground_recommendation).
root_export(none).
root_export(not_designated_as_critical).
root_export(oversight_activities_completed).
root_export(oversight_plan_statement).
root_export(partial).
root_export(penalty_decision_notified_on).
root_export(penalty_decision_required).
root_export(penalty_limits).
root_export(penalty_waiting_period_running).
root_export(powers).
root_export(preceding_business_year_length_in_days).
root_export(preceding_business_year_worldwide_turnover).
root_export(provider_designated_as_critical).
root_export(provider_plans_further_subcontracting_arrangement).
root_export(recommend_refraining_from_further_subcontracting).
root_export(recommendation).
root_export(recommendation_information).
root_export(recommendation_information_opportunity_given_on).
root_export(remediation_report_request).
root_export(request_information_and_documentation).
root_export(request_remediation_reports).
root_export(required).
root_export(response_window).
root_export(subcontracting_concerns_critical_or_important_functions).
root_export(transmit_subcontracting_information_to_lead_overseer).
root_export(unknown_key).
root_export(window_closed).
root_export(window_not_yet_open).
root_export(window_open).
root_export(wrong_type).
