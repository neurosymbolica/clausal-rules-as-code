% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_subject/1, dora_ict_risk_learning_and_evolving_profile_for/2, dora_ict_risk_learning_and_evolving_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_hof, [include/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [decide_dora_ict_risk_learning_and_evolving/2]).

dora_ict_risk_learning_and_evolving_subject(article_16_1_entity_simplified_framework).
dora_ict_risk_learning_and_evolving_subject(gate_unanswered).
dora_ict_risk_learning_and_evolving_subject(non_microenterprise_incident_request_all_performed).
dora_ict_risk_learning_and_evolving_subject(communication_after_request_not_performed).
dora_ict_risk_learning_and_evolving_subject(microenterprise_communication_not_performed).
dora_ict_risk_learning_and_evolving_subject(incident_without_request_communication_unanswered).
dora_ict_risk_learning_and_evolving_subject(incident_with_request_communication_unanswered).
dora_ict_risk_learning_and_evolving_subject(microenterprise_without_incident_all_performed).
dora_ict_risk_learning_and_evolving_subject(microenterprise_yearly_report_not_performed).
dora_ict_risk_learning_and_evolving_subject(size_class_unanswered_all_performed).
dora_ict_risk_learning_and_evolving_subject(size_class_unanswered_technology_monitoring_not_performed).
dora_ict_risk_learning_and_evolving_subject(capabilities_judgement_unsure).
dora_ict_risk_learning_and_evolving_subject(capabilities_judgement_unsure_yearly_report_not_performed).
dora_ict_risk_learning_and_evolving_subject(unknown_key_given).
dora_ict_risk_learning_and_evolving_subject(fact_key_given_unsure).
dora_ict_risk_learning_and_evolving_subject(gate_key_given_twice).

dora_ict_risk_learning_and_evolving_profile_for(article_16_1_entity_simplified_framework, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - true, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(gate_unanswered, Profile) :-
    fixture_profile([financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [post_incident_review_changes_communicated_to_competent_authorities - false], Profile).
dora_ict_risk_learning_and_evolving_profile_for(microenterprise_communication_not_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [post_incident_review_changes_communicated_to_competent_authorities - false], Profile).
dora_ict_risk_learning_and_evolving_profile_for(incident_without_request_communication_unanswered, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - false], [post_incident_review_changes_communicated_to_competent_authorities - absent], Profile).
dora_ict_risk_learning_and_evolving_profile_for(incident_with_request_communication_unanswered, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [post_incident_review_changes_communicated_to_competent_authorities - absent], Profile).
dora_ict_risk_learning_and_evolving_profile_for(microenterprise_without_incident_all_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(microenterprise_yearly_report_not_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false], Profile).
dora_ict_risk_learning_and_evolving_profile_for(size_class_unanswered_all_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, major_ict_related_incident_disrupted_core_activities - false], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(size_class_unanswered_technology_monitoring_not_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, major_ict_related_incident_disrupted_core_activities - false], [relevant_technological_developments_monitored_continuously - false], Profile).
dora_ict_risk_learning_and_evolving_profile_for(capabilities_judgement_unsure, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - unsure], Profile).
dora_ict_risk_learning_and_evolving_profile_for(capabilities_judgement_unsure_yearly_report_not_performed, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - unsure, senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false], Profile).
dora_ict_risk_learning_and_evolving_profile_for(unknown_key_given, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false, colour - red], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(fact_key_given_unsure, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - unsure, major_ict_related_incident_disrupted_core_activities - false], [], Profile).
dora_ict_risk_learning_and_evolving_profile_for(gate_key_given_twice, Profile) :-
    fixture_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_article_16_1_entity - true, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile).

dora_ict_risk_learning_and_evolving_assess(Subject, Result) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    decide_dora_ict_risk_learning_and_evolving(Profile, Result).

fixture_profile(Facts, Overrides, Profile) :-
    duty_keys(DutyKeys),
    maplist(duty_pair(Overrides), DutyKeys, DutyPairs),
    append(Facts, DutyPairs, AllPairs),
    include(present_pair, AllPairs, Pairs),
    maplist(pair_attribute, Pairs, Profile).

duty_keys([capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, post_ict_related_incident_reviews_put_in_place, post_incident_review_changes_communicated_to_competent_authorities, post_incident_reviews_determine_procedures_followed_and_actions_effective, post_incident_reviews_cover_promptness_of_response_and_impact_determination, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, post_incident_reviews_cover_effectiveness_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment_process, findings_form_basis_for_reviews_of_ict_risk_management_framework, effectiveness_of_resilience_strategy_implementation_monitored, evolution_of_ict_risk_mapped_over_time, frequency_types_magnitude_and_evolution_of_incidents_analysed, cyber_maturity_and_preparedness_enhanced, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, awareness_programmes_and_resilience_training_compulsory_in_staff_training, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, ict_third_party_service_providers_included_in_training_where_appropriate, relevant_technological_developments_monitored_continuously, kept_up_to_date_with_latest_ict_risk_management_processes]).

duty_pair(Overrides, DutyKey, DutyKey - Value) :-
    pairs_keys(Overrides, OverrideKeys),
    memberd_t(DutyKey, OverrideKeys, Overridden),
    override_value(Overridden, Overrides, DutyKey, Value).

override_value(true, Overrides, DutyKey, Value) :-
    member(DutyKey - Value, Overrides).
override_value(false, _, _, true).

present_pair(_ - Value) :-
    dif(Value, absent).

pair_attribute(ProfileKey - Value, attribute(ProfileKey, Value)).
