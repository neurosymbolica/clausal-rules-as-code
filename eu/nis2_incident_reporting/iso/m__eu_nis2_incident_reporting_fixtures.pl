% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_subject/1, nis2_incident_reporting_profile_for/2, nis2_incident_reporting_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2]).

nis2_incident_reporting_subject(limb_a_met).
nis2_incident_reporting_subject(limb_b_met).
nis2_incident_reporting_subject(both_limbs_false).
nis2_incident_reporting_subject(limb_a_false_limb_b_absent).
nis2_incident_reporting_subject(no_keys_given).
nis2_incident_reporting_subject(limb_a_unsure).
nis2_incident_reporting_subject(unknown_key_given).

nis2_incident_reporting_profile_for(limb_a_met, [attribute(severe_operational_disruption_or_financial_loss, true), attribute(considerable_damage_to_other_persons, false)]).
nis2_incident_reporting_profile_for(limb_b_met, [attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, true)]).
nis2_incident_reporting_profile_for(both_limbs_false, [attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)]).
nis2_incident_reporting_profile_for(limb_a_false_limb_b_absent, [attribute(severe_operational_disruption_or_financial_loss, false)]).
nis2_incident_reporting_profile_for(no_keys_given, []).
nis2_incident_reporting_profile_for(limb_a_unsure, [attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false)]).
nis2_incident_reporting_profile_for(unknown_key_given, [attribute(bogus, true)]).

nis2_incident_reporting_assess(Subject, Result) :-
    nis2_incident_reporting_profile_for(Subject, Profile),
    decide_nis2_incident_reporting(Profile, Result).
