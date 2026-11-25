% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_citations, [citation/2, implements/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2, serious_incident_report_duty/4, serious_incident_report_timeliness/5, serious_incident_reporting_checklist/2, serious_incident_reporting_decision_resolvable/1, serious_incident_reporting_status/2, serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [ai_office/0, annex_i_high_risk/0, annex_iii_high_risk/0, cooperate_with_competent_authorities/0, corrective_action/0, critical_infrastructure_disruption/0, death_of_a_person/0, fundamental_rights_obligations_infringed/0, harm_to_health/0, high_risk_classification/0, inform_authorities_before_altering_the_system/0, intended_to_be_used_by_public_authorities/0, market_surveillance_authority_of_member_state_where_incident_occurred/0, medical_device_or_safety_component_of_one/0, national_competent_authority_chosen_by_member_state_where_incident_occurred/0, no_death_or_serious_harm_to_health/0, not_a_high_risk_ai_system/0, not_a_reportable_incident/0, not_a_serious_incident/0, not_applicable_on_date/0, not_covered_placed_before_application_date/0, not_high_risk/0, perform_necessary_investigations_without_delay/0, placed_before_chapter_iii_application_date/0, provider_subject_to_equivalent_union_reporting_obligations/0, report_after_time_limit/0, report_in_time/0, report_made_immediately/0, report_not_immediate/0, risk_assessment_of_the_incident/0, serious_harm_to_health_without_death/0, serious_harm_to_property_or_environment/0, serious_incident_reporting_profile_keys/1, serious_incident_reporting_what_if/4, significant_change_in_design_since_that_date/0, system_under_the_exclusive_competence_of_the_ai_office/0, unsure/0, widespread_infringement/0]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_assess/2, serious_incident_reporting_profile_for/2, serious_incident_reporting_subject/1]).

root_export(ai_office).
root_export(annex_i_high_risk).
root_export(annex_iii_high_risk).
root_export(cooperate_with_competent_authorities).
root_export(corrective_action).
root_export(critical_infrastructure_disruption).
root_export(death_of_a_person).
root_export(duplicate_key).
root_export(fundamental_rights_obligations_infringed).
root_export(harm_to_health).
root_export(high_risk_classification).
root_export(indeterminate).
root_export(inform_authorities_before_altering_the_system).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(intended_to_be_used_by_public_authorities).
root_export(market_surveillance_authority_of_member_state_where_incident_occurred).
root_export(medical_device_or_safety_component_of_one).
root_export(national_competent_authority_chosen_by_member_state_where_incident_occurred).
root_export(needs_legal_review).
root_export(no_death_or_serious_harm_to_health).
root_export(not_a_high_risk_ai_system).
root_export(not_a_reportable_incident).
root_export(not_a_serious_incident).
root_export(not_applicable_on_date).
root_export(not_covered_placed_before_application_date).
root_export(not_high_risk).
root_export(open_textured).
root_export(perform_necessary_investigations_without_delay).
root_export(placed_before_chapter_iii_application_date).
root_export(provenance).
root_export(provider_subject_to_equivalent_union_reporting_obligations).
root_export(report_after_time_limit).
root_export(report_due).
root_export(report_in_time).
root_export(report_made_immediately).
root_export(report_not_immediate).
root_export(risk_assessment_of_the_incident).
root_export(serious_harm_to_health_without_death).
root_export(serious_harm_to_property_or_environment).
root_export(significant_change_in_design_since_that_date).
root_export(system_under_the_exclusive_competence_of_the_ai_office).
root_export(unknown_key).
root_export(unsure).
root_export(widespread_infringement).
root_export(wrong_type).
