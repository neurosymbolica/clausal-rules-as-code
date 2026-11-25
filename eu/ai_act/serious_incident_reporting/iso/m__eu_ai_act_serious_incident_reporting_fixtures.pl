% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2]).

serious_incident_reporting_subject(awareness_before_first_application_date).
serious_incident_reporting_subject(awareness_on_first_application_date).
serious_incident_reporting_subject(annex_i_awareness_before_application_date).
serious_incident_reporting_subject(annex_i_awareness_on_application_date).
serious_incident_reporting_subject(system_not_high_risk).
serious_incident_reporting_subject(classification_absent).
serious_incident_reporting_subject(placed_early_without_significant_change).
serious_incident_reporting_subject(placed_early_with_significant_change).
serious_incident_reporting_subject(public_authority_system_on_compliance_date).
serious_incident_reporting_subject(public_authority_system_before_compliance_date).
serious_incident_reporting_subject(public_authority_use_unsure).
serious_incident_reporting_subject(public_authority_use_confirmed).
serious_incident_reporting_subject(placement_absent).
serious_incident_reporting_subject(device_status_absent).
serious_incident_reporting_subject(equivalent_obligations_absent_without_fundamental_rights).
serious_incident_reporting_subject(equivalent_obligations_absent_with_fundamental_rights).
serious_incident_reporting_subject(equivalent_obligations_without_fundamental_rights).
serious_incident_reporting_subject(equivalent_obligations_with_fundamental_rights).
serious_incident_reporting_subject(device_without_fundamental_rights).
serious_incident_reporting_subject(device_with_fundamental_rights).
serious_incident_reporting_subject(device_under_ai_office).
serious_incident_reporting_subject(device_not_under_ai_office).
serious_incident_reporting_subject(no_listed_harm).
serious_incident_reporting_subject(property_harm_only).
serious_incident_reporting_subject(critical_infrastructure_absent_without_other_harm).
serious_incident_reporting_subject(critical_infrastructure_disrupted_in_leap_year).
serious_incident_reporting_subject(death_in_leap_year).
serious_incident_reporting_subject(widespread_infringement_with_health_harm).
serious_incident_reporting_subject(health_harm_without_widespread_infringement).
serious_incident_reporting_subject(widespread_infringement_unsure).
serious_incident_reporting_subject(widespread_infringement_absent).
serious_incident_reporting_subject(report_on_last_day_made_immediately).
serious_incident_reporting_subject(report_day_after_last_day).
serious_incident_reporting_subject(report_in_time_not_immediate).
serious_incident_reporting_subject(report_immediacy_absent).
serious_incident_reporting_subject(report_before_first_application_date).
serious_incident_reporting_subject(report_immediacy_unsure).
serious_incident_reporting_subject(late_report_immediacy_unsure).
serious_incident_reporting_subject(awareness_date_not_a_calendar_day).
serious_incident_reporting_subject(awareness_on_leap_day).
serious_incident_reporting_subject(duplicate_harm_key).
serious_incident_reporting_subject(profile_not_a_list).
serious_incident_reporting_subject(unknown_profile_key).
serious_incident_reporting_subject(report_date_not_a_calendar_day).

base_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

edited_profile(Edits, Profile) :-
    base_profile(Base),
    foldl(apply_edit, Edits, Base, Profile).

apply_edit(set(Key, Value), ProfileIn, ProfileOut) :-
    exclude(has_key(Key), ProfileIn, Others),
    append(Others, [attribute(Key, Value)], ProfileOut).
apply_edit(drop(Key), ProfileIn, ProfileOut) :-
    exclude(has_key(Key), ProfileIn, ProfileOut).

has_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

serious_incident_reporting_profile_for(awareness_before_first_application_date, duty(Profile, date(2027, 12, 1))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(awareness_on_first_application_date, duty(Profile, date(2027, 12, 2))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(annex_i_awareness_before_application_date, duty(Profile, date(2028, 8, 1))) :-
    edited_profile([set(high_risk_classification, annex_i_high_risk)], Profile).
serious_incident_reporting_profile_for(annex_i_awareness_on_application_date, duty(Profile, date(2028, 8, 2))) :-
    edited_profile([set(high_risk_classification, annex_i_high_risk)], Profile).
serious_incident_reporting_profile_for(system_not_high_risk, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(high_risk_classification, not_high_risk)], Profile).
serious_incident_reporting_profile_for(classification_absent, duty([], date(2028, 1, 10))).
serious_incident_reporting_profile_for(placed_early_without_significant_change, duty(Profile, date(2029, 1, 1))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, false)], Profile).
serious_incident_reporting_profile_for(placed_early_with_significant_change, duty(Profile, date(2029, 1, 1))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, true)], Profile).
serious_incident_reporting_profile_for(public_authority_system_on_compliance_date, duty(Profile, date(2030, 8, 2))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, false), set(intended_to_be_used_by_public_authorities, true)], Profile).
serious_incident_reporting_profile_for(public_authority_system_before_compliance_date, duty(Profile, date(2030, 8, 1))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, false), set(intended_to_be_used_by_public_authorities, true)], Profile).
serious_incident_reporting_profile_for(public_authority_use_unsure, duty(Profile, date(2031, 1, 1))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, false), set(intended_to_be_used_by_public_authorities, unsure)], Profile).
serious_incident_reporting_profile_for(public_authority_use_confirmed, duty(Profile, date(2031, 1, 1))) :-
    edited_profile([set(placed_before_chapter_iii_application_date, true), set(significant_change_in_design_since_that_date, false), set(intended_to_be_used_by_public_authorities, true)], Profile).
serious_incident_reporting_profile_for(placement_absent, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([drop(placed_before_chapter_iii_application_date)], Profile).
serious_incident_reporting_profile_for(device_status_absent, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([drop(medical_device_or_safety_component_of_one)], Profile).
serious_incident_reporting_profile_for(equivalent_obligations_absent_without_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([drop(provider_subject_to_equivalent_union_reporting_obligations)], Profile).
serious_incident_reporting_profile_for(equivalent_obligations_absent_with_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([drop(provider_subject_to_equivalent_union_reporting_obligations), set(fundamental_rights_obligations_infringed, true)], Profile).
serious_incident_reporting_profile_for(equivalent_obligations_without_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(provider_subject_to_equivalent_union_reporting_obligations, true)], Profile).
serious_incident_reporting_profile_for(equivalent_obligations_with_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(provider_subject_to_equivalent_union_reporting_obligations, true), set(fundamental_rights_obligations_infringed, true)], Profile).
serious_incident_reporting_profile_for(device_without_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(medical_device_or_safety_component_of_one, true)], Profile).
serious_incident_reporting_profile_for(device_with_fundamental_rights, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(medical_device_or_safety_component_of_one, true), set(fundamental_rights_obligations_infringed, true)], Profile).
serious_incident_reporting_profile_for(device_under_ai_office, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(medical_device_or_safety_component_of_one, true), set(fundamental_rights_obligations_infringed, true), set(system_under_the_exclusive_competence_of_the_ai_office, attested(true, attestation(host, recorded_at, attested_by_caller, none)))], Profile).
serious_incident_reporting_profile_for(device_not_under_ai_office, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(medical_device_or_safety_component_of_one, true), set(fundamental_rights_obligations_infringed, true), set(system_under_the_exclusive_competence_of_the_ai_office, attested(false, attestation(host, recorded_at, attested_by_caller, none)))], Profile).
serious_incident_reporting_profile_for(no_listed_harm, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(harm_to_health, no_death_or_serious_harm_to_health)], Profile).
serious_incident_reporting_profile_for(property_harm_only, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(harm_to_health, no_death_or_serious_harm_to_health), set(serious_harm_to_property_or_environment, true)], Profile).
serious_incident_reporting_profile_for(critical_infrastructure_absent_without_other_harm, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(harm_to_health, no_death_or_serious_harm_to_health), drop(critical_infrastructure_disruption)], Profile).
serious_incident_reporting_profile_for(critical_infrastructure_disrupted_in_leap_year, duty(Profile, date(2028, 2, 28))) :-
    edited_profile([set(critical_infrastructure_disruption, true)], Profile).
serious_incident_reporting_profile_for(death_in_leap_year, duty(Profile, date(2028, 2, 28))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(widespread_infringement_with_health_harm, duty(Profile, date(2027, 12, 20))) :-
    edited_profile([set(harm_to_health, serious_harm_to_health_without_death), set(widespread_infringement, true)], Profile).
serious_incident_reporting_profile_for(health_harm_without_widespread_infringement, duty(Profile, date(2027, 12, 20))) :-
    edited_profile([set(harm_to_health, serious_harm_to_health_without_death)], Profile).
serious_incident_reporting_profile_for(widespread_infringement_unsure, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([set(harm_to_health, serious_harm_to_health_without_death), set(widespread_infringement, unsure)], Profile).
serious_incident_reporting_profile_for(widespread_infringement_absent, duty(Profile, date(2028, 1, 10))) :-
    edited_profile([drop(widespread_infringement)], Profile).
serious_incident_reporting_profile_for(report_on_last_day_made_immediately, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 20))) :-
    edited_profile([set(report_made_immediately, true)], Profile).
serious_incident_reporting_profile_for(report_day_after_last_day, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 21))) :-
    edited_profile([set(report_made_immediately, true)], Profile).
serious_incident_reporting_profile_for(report_in_time_not_immediate, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 15))) :-
    edited_profile([set(report_made_immediately, false)], Profile).
serious_incident_reporting_profile_for(report_immediacy_absent, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 15))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(report_before_first_application_date, timeliness(Profile, date(2027, 12, 1), date(2027, 12, 3))) :-
    edited_profile([set(report_made_immediately, true)], Profile).
serious_incident_reporting_profile_for(report_immediacy_unsure, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 15))) :-
    edited_profile([set(report_made_immediately, unsure)], Profile).
serious_incident_reporting_profile_for(late_report_immediacy_unsure, timeliness(Profile, date(2028, 1, 10), date(2028, 1, 21))) :-
    edited_profile([set(report_made_immediately, unsure)], Profile).
serious_incident_reporting_profile_for(awareness_date_not_a_calendar_day, duty(Profile, date(2027, 2, 29))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(awareness_on_leap_day, duty(Profile, date(2028, 2, 29))) :-
    edited_profile([], Profile).
serious_incident_reporting_profile_for(duplicate_harm_key, duty(Profile, date(2028, 1, 10))) :-
    base_profile(Base),
    append(Base, [attribute(harm_to_health, death_of_a_person)], Profile).
serious_incident_reporting_profile_for(profile_not_a_list, duty(foo, date(2028, 1, 10))).
serious_incident_reporting_profile_for(unknown_profile_key, duty([attribute(colour, blue)], date(2028, 1, 10))).
serious_incident_reporting_profile_for(report_date_not_a_calendar_day, timeliness(Profile, date(2028, 1, 10), date(2028, 13, 1))) :-
    edited_profile([set(report_made_immediately, true)], Profile).

serious_incident_reporting_assess(Subject, Result) :-
    serious_incident_reporting_profile_for(Subject, Case),
    decide_serious_incident_reporting(Case, Result).
