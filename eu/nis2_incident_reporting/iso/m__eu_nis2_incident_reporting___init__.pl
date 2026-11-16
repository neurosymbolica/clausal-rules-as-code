% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_citations, [citation/2, implements/1]).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, incident_reporting_steps/2, incident_significance/3, nis2_incident_reporting_checklist/2, nis2_incident_reporting_decision_resolvable/1, nis2_incident_reporting_status/2, nis2_incident_reporting_status_values/1, not_significant/0, on_time/0, reporting_step_timeliness/4, significant/0]).
:- use_module(m__eu_nis2_incident_reporting_queries, [considerable_damage_to_other_persons/0, early_warning/0, early_warning_without_undue_delay/0, incident_notification/0, incident_notification_without_undue_delay/0, incident_ongoing_at_final_report_due/0, nis2_incident_reporting_profile_keys/1, nis2_incident_reporting_what_if/4, severe_operational_disruption_or_financial_loss/0, trust_service_provider_incident_affects_trust_services/0, unsure/0]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_assess/2, nis2_incident_reporting_profile_for/2, nis2_incident_reporting_subject/1]).

root_export(considerable_damage_to_other_persons).
root_export(duplicate_key).
root_export(early_warning).
root_export(early_warning_without_undue_delay).
root_export(hours_after_awareness).
root_export(incident_notification).
root_export(incident_notification_without_undue_delay).
root_export(incident_ongoing_at_final_report_due).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(late).
root_export(months_after_handling).
root_export(months_after_notification).
root_export(needs_legal_review).
root_export(not_significant).
root_export(on_time).
root_export(open_textured).
root_export(provenance).
root_export(severe_operational_disruption_or_financial_loss).
root_export(significant).
root_export(step_due).
root_export(trust_service_provider_incident_affects_trust_services).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
