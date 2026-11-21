% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_queries, [nis2_incident_reporting_profile_keys/1, nis2_incident_reporting_what_if/4, severe_operational_disruption_or_financial_loss/0, considerable_damage_to_other_persons/0, trust_service_provider_incident_affects_trust_services/0, incident_ongoing_at_final_report_due/0, early_warning_without_undue_delay/0, incident_notification_without_undue_delay/0, early_warning/0, incident_notification/0, unsure/0, significant/0, not_significant/0, on_time/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [nis2_incident_reporting_status/2]).

nis2_incident_reporting_profile_keys([severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons, trust_service_provider_incident_affects_trust_services, incident_ongoing_at_final_report_due, early_warning_without_undue_delay, incident_notification_without_undue_delay]).

nis2_incident_reporting_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_incident_reporting_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    exclude(attribute_for_key(Key), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(Key, Value)], Hypothesis).

attribute_for_key(Key, attribute(AttributeKey, _Value)) :-
    AttributeKey == Key.

severe_operational_disruption_or_financial_loss.

considerable_damage_to_other_persons.

trust_service_provider_incident_affects_trust_services.

incident_ongoing_at_final_report_due.

early_warning_without_undue_delay.

incident_notification_without_undue_delay.

early_warning.

incident_notification.

unsure.

significant.

not_significant.

on_time.
