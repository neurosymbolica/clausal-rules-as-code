% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_queries, [dora_ict_risk_learning_and_evolving_profile_keys/1, dora_ict_risk_learning_and_evolving_what_if/4, dora_ict_risk_learning_and_evolving_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, unsure/0, financial_entity_is_article_16_1_entity/0, financial_entity_is_microenterprise/0, major_ict_related_incident_disrupted_core_activities/0, competent_authority_requested_post_incident_review_changes/0, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information/0, post_ict_related_incident_reviews_put_in_place/0, post_incident_review_changes_communicated_to_competent_authorities/0, post_incident_reviews_determine_procedures_followed_and_actions_effective/0, post_incident_reviews_cover_promptness_of_response_and_impact_determination/0, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis/0, post_incident_reviews_cover_effectiveness_of_incident_escalation/0, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication/0, lessons_incorporated_into_ict_risk_assessment_process/0, findings_form_basis_for_reviews_of_ict_risk_management_framework/0, effectiveness_of_resilience_strategy_implementation_monitored/0, evolution_of_ict_risk_mapped_over_time/0, frequency_types_magnitude_and_evolution_of_incidents_analysed/0, cyber_maturity_and_preparedness_enhanced/0, senior_ict_staff_report_findings_and_recommendations_at_least_yearly/0, awareness_programmes_and_resilience_training_compulsory_in_staff_training/0, programmes_and_training_apply_to_all_staff_at_commensurate_complexity/0, ict_third_party_service_providers_included_in_training_where_appropriate/0, relevant_technological_developments_monitored_continuously/0, kept_up_to_date_with_latest_ict_risk_management_processes/0, threat_and_incident_information_capability/0, post_incident_reviews/0, communication_of_post_incident_changes/0, review_of_procedures_and_actions/0, review_of_response_promptness/0, review_of_forensic_analysis/0, review_of_incident_escalation/0, review_of_internal_and_external_communication/0, lessons_incorporated_into_ict_risk_assessment/0, findings_basis_for_framework_reviews/0, monitoring_of_resilience_strategy_effectiveness/0, mapping_of_ict_risk_evolution/0, analysis_of_ict_related_incidents/0, enhancement_of_cyber_maturity/0, yearly_report_to_management_body/0, compulsory_awareness_and_training_modules/0, training_for_all_staff_commensurate_to_remit/0, third_party_providers_in_training/0, monitoring_of_technological_developments/0, up_to_date_ict_risk_management_processes/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, dora_ict_risk_learning_and_evolving_status/2, dora_ict_risk_learning_and_evolving_checklist/2]).

dora_ict_risk_learning_and_evolving_profile_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, major_ict_related_incident_disrupted_core_activities, competent_authority_requested_post_incident_review_changes, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, post_ict_related_incident_reviews_put_in_place, post_incident_review_changes_communicated_to_competent_authorities, post_incident_reviews_determine_procedures_followed_and_actions_effective, post_incident_reviews_cover_promptness_of_response_and_impact_determination, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, post_incident_reviews_cover_effectiveness_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment_process, findings_form_basis_for_reviews_of_ict_risk_management_framework, effectiveness_of_resilience_strategy_implementation_monitored, evolution_of_ict_risk_mapped_over_time, frequency_types_magnitude_and_evolution_of_incidents_analysed, cyber_maturity_and_preparedness_enhanced, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, awareness_programmes_and_resilience_training_compulsory_in_staff_training, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, ict_third_party_service_providers_included_in_training_where_appropriate, relevant_technological_developments_monitored_continuously, kept_up_to_date_with_latest_ict_risk_management_processes]).

dora_ict_risk_learning_and_evolving_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems),
    what_if_for_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_for_problems(Problems, Profile, _, _, NewStatus) :-
    Problems == [wrong_type(profile)],
    dora_ict_risk_learning_and_evolving_status(Profile, NewStatus).
what_if_for_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    Problems \== [wrong_type(profile)],
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ict_risk_learning_and_evolving_status(Hypothesis, NewStatus).

attribute_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Hypothesis).
attribute_override([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Hypothesis).

dora_ict_risk_learning_and_evolving_compliance_check(Profile, Duty, Verdict) :-
    compliance_duty(Duty),
    dora_ict_risk_learning_and_evolving_checklist(Profile, Items),
    compliance_from_items(Items, Profile, Duty, DerivedVerdict),
    Verdict = DerivedVerdict.

compliance_duty(Duty) :-
    every_duty_applies_profile(RosterProfile),
    ict_risk_learning_and_evolving_duties_required(RosterProfile, required(Duties), _),
    member(Duty, Duties).

every_duty_applies_profile([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(major_ict_related_incident_disrupted_core_activities, true), attribute(competent_authority_requested_post_incident_review_changes, true)]).

compliance_from_items([item(input_check, unmet(input_problems(Problems)), _)], _, _, input_problems(Problems)).
compliance_from_items([item(article_16_1_entity, inapplicable, _)], _, _, simplified_framework_entity).
compliance_from_items([item(article_16_1_entity, unknown(MissingKeys), _)], _, _, indeterminate(MissingKeys)).
compliance_from_items([FirstItem, SecondItem|OtherItems], Profile, Duty, Verdict) :-
    member(item(Duty, ItemStatus, Citation), [FirstItem, SecondItem|OtherItems]),
    compliance_from_status(ItemStatus, Citation, Profile, Verdict).

compliance_from_status(inapplicable, _, _, not_applicable).
compliance_from_status(met, _, _, compliant).
compliance_from_status(unmet(not_performed), _, _, non_compliant).
compliance_from_status(unknown([OpenKey|_]), _, Profile, indeterminate([OpenKey])) :-
    profile_lacks(Profile, OpenKey).
compliance_from_status(unknown([OpenKey|_]), Citation, Profile, needs_legal_review(open_textured(OpenKey, Citation), [inputs_relied_on(Pairs)])) :-
    profile_get(Profile, OpenKey, unsure),
    present_pairs(Profile, Pairs).

present_pairs(Profile, Pairs) :-
    dora_ict_risk_learning_and_evolving_profile_keys(ContractKeys),
    findall(ProfileKey - Value, present_value(Profile, ContractKeys, ProfileKey, Value), Pairs).

present_value(Profile, ContractKeys, ProfileKey, Value) :-
    member(ProfileKey, ContractKeys),
    profile_get(Profile, ProfileKey, Value).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

unsure.

financial_entity_is_article_16_1_entity.

financial_entity_is_microenterprise.

major_ict_related_incident_disrupted_core_activities.

competent_authority_requested_post_incident_review_changes.

capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information.

post_ict_related_incident_reviews_put_in_place.

post_incident_review_changes_communicated_to_competent_authorities.

post_incident_reviews_determine_procedures_followed_and_actions_effective.

post_incident_reviews_cover_promptness_of_response_and_impact_determination.

post_incident_reviews_cover_quality_and_speed_of_forensic_analysis.

post_incident_reviews_cover_effectiveness_of_incident_escalation.

post_incident_reviews_cover_effectiveness_of_internal_and_external_communication.

lessons_incorporated_into_ict_risk_assessment_process.

findings_form_basis_for_reviews_of_ict_risk_management_framework.

effectiveness_of_resilience_strategy_implementation_monitored.

evolution_of_ict_risk_mapped_over_time.

frequency_types_magnitude_and_evolution_of_incidents_analysed.

cyber_maturity_and_preparedness_enhanced.

senior_ict_staff_report_findings_and_recommendations_at_least_yearly.

awareness_programmes_and_resilience_training_compulsory_in_staff_training.

programmes_and_training_apply_to_all_staff_at_commensurate_complexity.

ict_third_party_service_providers_included_in_training_where_appropriate.

relevant_technological_developments_monitored_continuously.

kept_up_to_date_with_latest_ict_risk_management_processes.

threat_and_incident_information_capability.

post_incident_reviews.

communication_of_post_incident_changes.

review_of_procedures_and_actions.

review_of_response_promptness.

review_of_forensic_analysis.

review_of_incident_escalation.

review_of_internal_and_external_communication.

lessons_incorporated_into_ict_risk_assessment.

findings_basis_for_framework_reviews.

monitoring_of_resilience_strategy_effectiveness.

mapping_of_ict_risk_evolution.

analysis_of_ict_related_incidents.

enhancement_of_cyber_maturity.

yearly_report_to_management_body.

compulsory_awareness_and_training_modules.

training_for_all_staff_commensurate_to_remit.

third_party_providers_in_training.

monitoring_of_technological_developments.

up_to_date_ict_risk_management_processes.
