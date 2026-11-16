% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_citations, [citation/2, implements/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_status_values/1, decide_cra_art14_manufacturer_reporting/2, manufacturer_reporting_step_timeliness/5, manufacturer_reporting_steps/4, severe_incident_status/3]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4, date/3, days_after_measure_available/1, duplicate_key/1, hours_after_awareness/1, indeterminate/1, input_problems/1, inputs_relied_on/1, late/1, months_after_notification/1, needs_legal_review/2, not_severe/0, on_time/0, open_textured/2, provenance/2, severe/0, step_due/3, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_assess/2, cra_art14_manufacturer_reporting_profile_for/2, cra_art14_manufacturer_reporting_subject/1]).

root_export(actively_exploited_vulnerability).
root_export(affects_protection_of_sensitive_or_important_data_or_functions).
root_export(early_warning).
root_export(early_warning_without_undue_delay).
root_export(incident_impacting_product_security).
root_export(leads_to_malicious_code_in_product_or_user_systems).
root_export(not_severe).
root_export(notification).
root_export(notification_without_undue_delay).
root_export(on_time).
root_export(severe).
root_export(unsure).
