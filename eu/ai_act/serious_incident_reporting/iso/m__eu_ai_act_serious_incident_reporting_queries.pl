% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_reporting_profile_keys/1, serious_incident_reporting_what_if/4, not_applicable_on_date/0, not_a_high_risk_ai_system/0, not_covered_placed_before_application_date/0, not_a_serious_incident/0, not_a_reportable_incident/0, report_in_time/0, report_after_time_limit/0, report_not_immediate/0, market_surveillance_authority_of_member_state_where_incident_occurred/0, national_competent_authority_chosen_by_member_state_where_incident_occurred/0, ai_office/0, perform_necessary_investigations_without_delay/0, risk_assessment_of_the_incident/0, corrective_action/0, cooperate_with_competent_authorities/0, inform_authorities_before_altering_the_system/0, high_risk_classification/0, placed_before_chapter_iii_application_date/0, significant_change_in_design_since_that_date/0, intended_to_be_used_by_public_authorities/0, medical_device_or_safety_component_of_one/0, provider_subject_to_equivalent_union_reporting_obligations/0, harm_to_health/0, critical_infrastructure_disruption/0, fundamental_rights_obligations_infringed/0, serious_harm_to_property_or_environment/0, widespread_infringement/0, report_made_immediately/0, system_under_the_exclusive_competence_of_the_ai_office/0, annex_iii_high_risk/0, annex_i_high_risk/0, not_high_risk/0, death_of_a_person/0, serious_harm_to_health_without_death/0, no_death_or_serious_harm_to_health/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2]).

serious_incident_reporting_profile_keys([high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately, system_under_the_exclusive_competence_of_the_ai_office]).

serious_incident_reporting_what_if(duty(Profile, AwarenessDate), OverriddenKey, NewValue, Result) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_serious_incident_reporting(duty(Hypothesis, AwarenessDate), Result).
serious_incident_reporting_what_if(timeliness(Profile, AwarenessDate, ReportDate), OverriddenKey, NewValue, Result) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_serious_incident_reporting(timeliness(Hypothesis, AwarenessDate, ReportDate), Result).

replace_attribute(Profile, Key, Value, Hypothesis) :-
    exclude(attribute_with_key(Key), Profile, Others),
    append(Others, [attribute(Key, Value)], Hypothesis).

attribute_with_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

not_applicable_on_date.

not_a_high_risk_ai_system.

not_covered_placed_before_application_date.

not_a_serious_incident.

not_a_reportable_incident.

report_in_time.

report_after_time_limit.

report_not_immediate.

market_surveillance_authority_of_member_state_where_incident_occurred.

national_competent_authority_chosen_by_member_state_where_incident_occurred.

ai_office.

perform_necessary_investigations_without_delay.

risk_assessment_of_the_incident.

corrective_action.

cooperate_with_competent_authorities.

inform_authorities_before_altering_the_system.

high_risk_classification.

placed_before_chapter_iii_application_date.

significant_change_in_design_since_that_date.

intended_to_be_used_by_public_authorities.

medical_device_or_safety_component_of_one.

provider_subject_to_equivalent_union_reporting_obligations.

harm_to_health.

critical_infrastructure_disruption.

fundamental_rights_obligations_infringed.

serious_harm_to_property_or_environment.

widespread_infringement.

report_made_immediately.

system_under_the_exclusive_competence_of_the_ai_office.

annex_iii_high_risk.

annex_i_high_risk.

not_high_risk.

death_of_a_person.

serious_harm_to_health_without_death.

no_death_or_serious_harm_to_health.

unsure.

query_base_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

test(the_schema_has_thirteen_keys) :-
    serious_incident_reporting_profile_keys(Keys),
    length(Keys, 13).
test(what_if_without_any_harm_is_not_a_serious_incident) :-
    query_base_profile(Profile),
    serious_incident_reporting_what_if(duty(Profile, date(2028, 1, 10)), harm_to_health, no_death_or_serious_harm_to_health, serious_incident_reporting_verdict(not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)])).
test(what_if_with_a_death_is_still_a_report) :-
    query_base_profile(Profile),
    serious_incident_reporting_what_if(duty(Profile, date(2028, 1, 10)), harm_to_health, death_of_a_person, serious_incident_reporting_verdict(report_due(_, 10, _, _), _)).
test(what_if_critical_infrastructure_shortens_to_two_days) :-
    query_base_profile(Profile),
    serious_incident_reporting_what_if(duty(Profile, date(2028, 1, 10)), critical_infrastructure_disruption, true, serious_incident_reporting_verdict(report_due(_, 2, _, _), _)).
test(what_if_immediacy_makes_a_report_in_time) :-
    query_base_profile(Profile),
    serious_incident_reporting_what_if(timeliness(Profile, date(2028, 1, 10), date(2028, 1, 20)), report_made_immediately, true, serious_incident_reporting_verdict(report_in_time, _)).
test(the_vocabulary_is_served) :-
    not_applicable_on_date,
    report_in_time,
    ai_office,
    unsure,
    annex_iii_high_risk,
    harm_to_health.

test(what_if_critical_infrastructure_is_not_ten_days, fail) :-
    query_base_profile(Profile),
    serious_incident_reporting_what_if(duty(Profile, date(2028, 1, 10)), critical_infrastructure_disruption, true, serious_incident_reporting_verdict(report_due(_, 10, _, _), _)).
