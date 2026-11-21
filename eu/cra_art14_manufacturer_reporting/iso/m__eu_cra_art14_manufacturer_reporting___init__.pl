% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_citations, [citation/2, implements/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [actively_exploited_vulnerability/0, affects_protection_of_sensitive_or_important_data_or_functions/0, cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_status_values/1, decide_cra_art14_manufacturer_reporting/2, early_warning/0, early_warning_without_undue_delay/0, incident_impacting_product_security/0, leads_to_malicious_code_in_product_or_user_systems/0, manufacturer_reporting_step_timeliness/5, manufacturer_reporting_steps/4, not_severe/0, notification/0, notification_without_undue_delay/0, on_time/0, severe/0, severe_incident_status/3, unsure/0]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_assess/2, cra_art14_manufacturer_reporting_profile_for/2, cra_art14_manufacturer_reporting_subject/1]).

root_export(actively_exploited_vulnerability).
root_export(affects_protection_of_sensitive_or_important_data_or_functions).
root_export(date).
root_export(days_after_measure_available).
root_export(duplicate_key).
root_export(early_warning).
root_export(early_warning_without_undue_delay).
root_export(hours_after_awareness).
root_export(incident_impacting_product_security).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(late).
root_export(leads_to_malicious_code_in_product_or_user_systems).
root_export(months_after_notification).
root_export(needs_legal_review).
root_export(not_severe).
root_export(notification).
root_export(notification_without_undue_delay).
root_export(on_time).
root_export(open_textured).
root_export(provenance).
root_export(severe).
root_export(step_due).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
