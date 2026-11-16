% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_subject/1, gpai_models_profile_for/2, gpai_models_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [decide_gpai_models/2]).

threshold_computation(10000000000000000000000000).

above_threshold_computation(10000000000000000000000001).

classification_profile(Model, Research, Computation, HighImpact, Designated, Accepted, [attribute(general_purpose_ai_model, Model), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, Research), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, HighImpact), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, Designated), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, Accepted)]).

notification_profile(Model, Computation, HighImpact, Placed, [attribute(general_purpose_ai_model, Model), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, HighImpact), attribute(placed_on_the_market_before_2_august_2025, Placed)]).

obligation_profile(model_facts(Model, Research, Computation, HighImpact, Designated, Accepted, Licence, Public, ThirdCountry, Placed), [attribute(general_purpose_ai_model, Model), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, Research), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, HighImpact), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, Designated), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, Accepted), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, Licence), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, Public), attribute(provider_established_in_a_third_country, ThirdCountry), attribute(placed_on_the_market_before_2_august_2025, Placed)]).

model_description(open_small, model_facts(true, false, 0, false, false, false, true, true, false, false)).
model_description(open_not_public, model_facts(true, false, 0, false, false, false, true, false, false, false)).
model_description(open_large, model_facts(true, false, 10000000000000000000000001, false, false, false, true, true, true, false)).
model_description(open_at_threshold, model_facts(true, false, 10000000000000000000000000, false, false, false, true, true, true, false)).
model_description(open_third_country, model_facts(true, false, 0, false, false, false, true, true, true, false)).
model_description(closed_union, model_facts(true, false, 0, false, false, false, false, false, false, false)).
model_description(closed_third_country, model_facts(true, false, 0, false, false, false, false, false, true, false)).
model_description(legacy_closed, model_facts(true, false, 0, false, false, false, false, false, true, true)).
model_description(research_model, model_facts(true, true, 0, false, false, false, false, false, false, false)).
model_description(unsure_licence, model_facts(true, false, 0, false, false, false, unsure, true, false, false)).

described_profile(Description, Profile) :-
    model_description(Description, Facts),
    obligation_profile(Facts, Profile).

profile_without_placed_key([attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, false), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, false), attribute(provider_established_in_a_third_country, false)]).

gpai_models_subject(classification_above_threshold).
gpai_models_subject(classification_at_threshold).
gpai_models_subject(classification_high_impact_judged).
gpai_models_subject(classification_designated_despite_accepted_arguments).
gpai_models_subject(classification_arguments_accepted).
gpai_models_subject(classification_research_model).
gpai_models_subject(classification_not_a_model_judged).
gpai_models_subject(classification_on_application_day).
gpai_models_subject(classification_day_before_application).
gpai_models_subject(classification_missing_model_key).
gpai_models_subject(classification_unsure_model).
gpai_models_subject(classification_model_judged_true).
gpai_models_subject(classification_bad_assessment_date).
gpai_models_subject(notification_on_two_week_day).
gpai_models_subject(notification_day_after_two_week_day).
gpai_models_subject(notification_early_trigger_last_day).
gpai_models_subject(notification_early_trigger_day_after).
gpai_models_subject(notification_legacy_model_on_transition_end).
gpai_models_subject(notification_legacy_model_day_after_transition_end).
gpai_models_subject(notification_at_threshold).
gpai_models_subject(notification_high_impact_judged).
gpai_models_subject(notification_not_a_model).
gpai_models_subject(notification_research_key_not_read).
gpai_models_subject(notification_before_trigger).
gpai_models_subject(obligation_open_source_technical_documentation).
gpai_models_subject(obligation_parameters_not_public_technical_documentation).
gpai_models_subject(obligation_open_source_with_systemic_risk_technical_documentation).
gpai_models_subject(obligation_open_source_downstream_information).
gpai_models_subject(obligation_parameters_not_public_downstream_information).
gpai_models_subject(obligation_open_source_copyright_policy).
gpai_models_subject(obligation_open_source_training_content_summary).
gpai_models_subject(obligation_open_source_cooperation).
gpai_models_subject(obligation_union_provider_representative).
gpai_models_subject(obligation_third_country_provider_representative).
gpai_models_subject(obligation_open_source_third_country_representative).
gpai_models_subject(obligation_systemic_third_country_representative).
gpai_models_subject(obligation_model_evaluation_with_systemic_risk).
gpai_models_subject(obligation_model_evaluation_at_threshold).
gpai_models_subject(obligation_risk_assessment_with_systemic_risk).
gpai_models_subject(obligation_incident_reporting_with_systemic_risk).
gpai_models_subject(obligation_cybersecurity_with_systemic_risk).
gpai_models_subject(obligation_cybersecurity_without_systemic_risk).
gpai_models_subject(obligation_legacy_day_before_transition_end).
gpai_models_subject(obligation_legacy_on_transition_end).
gpai_models_subject(obligation_day_before_application).
gpai_models_subject(obligation_on_application_day).
gpai_models_subject(obligation_research_model).
gpai_models_subject(obligation_unsure_licence_technical_documentation).
gpai_models_subject(obligation_unsure_licence_copyright_policy).
gpai_models_subject(obligation_missing_placed_key).
gpai_models_subject(obligation_missing_placed_key_after_transition).
gpai_models_subject(obligation_unknown_obligation).
gpai_models_subject(documentation_technical).
gpai_models_subject(documentation_additional).
gpai_models_subject(documentation_downstream).
gpai_models_subject(documentation_unknown).

gpai_models_profile_for(classification_above_threshold, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    above_threshold_computation(Computation),
    classification_profile(true, false, Computation, false, false, false, Profile).
gpai_models_profile_for(classification_at_threshold, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    threshold_computation(Computation),
    classification_profile(true, false, Computation, false, false, false, Profile).
gpai_models_profile_for(classification_high_impact_judged, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(true, false, 0, true, false, false, Profile).
gpai_models_profile_for(classification_designated_despite_accepted_arguments, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(true, false, 0, false, true, true, Profile).
gpai_models_profile_for(classification_arguments_accepted, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    above_threshold_computation(Computation),
    classification_profile(true, false, Computation, false, false, true, Profile).
gpai_models_profile_for(classification_research_model, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(true, true, 0, false, false, false, Profile).
gpai_models_profile_for(classification_not_a_model_judged, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(false, false, 0, false, false, false, Profile).
gpai_models_profile_for(classification_on_application_day, systemic_risk_classification(Profile, date(2025, 8, 2))) :-
    above_threshold_computation(Computation),
    classification_profile(true, false, Computation, false, false, false, Profile).
gpai_models_profile_for(classification_day_before_application, systemic_risk_classification(Profile, date(2025, 8, 1))) :-
    above_threshold_computation(Computation),
    classification_profile(true, false, Computation, false, false, false, Profile).
gpai_models_profile_for(classification_missing_model_key, systemic_risk_classification([], date(2026, 1, 15))).
gpai_models_profile_for(classification_unsure_model, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(unsure, false, 0, false, false, false, Profile).
gpai_models_profile_for(classification_model_judged_true, systemic_risk_classification(Profile, date(2026, 1, 15))) :-
    classification_profile(true, false, 0, false, false, false, Profile).
gpai_models_profile_for(classification_bad_assessment_date, systemic_risk_classification(Profile, date(2026, 2, 30))) :-
    classification_profile(true, false, 0, false, false, false, Profile).
gpai_models_profile_for(notification_on_two_week_day, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 15))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(notification_day_after_two_week_day, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 16))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(notification_early_trigger_last_day, systemic_risk_notification(Profile, date(2025, 7, 1), date(2025, 8, 16))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(notification_early_trigger_day_after, systemic_risk_notification(Profile, date(2025, 7, 1), date(2025, 8, 17))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(notification_legacy_model_on_transition_end, systemic_risk_notification(Profile, date(2026, 3, 1), date(2027, 8, 2))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, true, Profile).
gpai_models_profile_for(notification_legacy_model_day_after_transition_end, systemic_risk_notification(Profile, date(2026, 3, 1), date(2027, 8, 3))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, true, Profile).
gpai_models_profile_for(notification_at_threshold, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 2))) :-
    threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(notification_high_impact_judged, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 15))) :-
    notification_profile(true, 0, true, false, Profile).
gpai_models_profile_for(notification_not_a_model, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 2))) :-
    above_threshold_computation(Computation),
    notification_profile(false, Computation, false, false, Profile).
gpai_models_profile_for(notification_research_key_not_read, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 3, 15))) :-
    above_threshold_computation(Computation),
    obligation_profile(model_facts(true, true, Computation, false, false, false, false, false, false, false), Profile).
gpai_models_profile_for(notification_before_trigger, systemic_risk_notification(Profile, date(2026, 3, 1), date(2026, 2, 28))) :-
    above_threshold_computation(Computation),
    notification_profile(true, Computation, false, false, Profile).
gpai_models_profile_for(obligation_open_source_technical_documentation, provider_obligation(Profile, technical_documentation, date(2026, 1, 15))) :-
    described_profile(open_small, Profile).
gpai_models_profile_for(obligation_parameters_not_public_technical_documentation, provider_obligation(Profile, technical_documentation, date(2026, 1, 15))) :-
    described_profile(open_not_public, Profile).
gpai_models_profile_for(obligation_open_source_with_systemic_risk_technical_documentation, provider_obligation(Profile, technical_documentation, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_open_source_downstream_information, provider_obligation(Profile, information_for_downstream_providers, date(2026, 1, 15))) :-
    described_profile(open_small, Profile).
gpai_models_profile_for(obligation_parameters_not_public_downstream_information, provider_obligation(Profile, information_for_downstream_providers, date(2026, 1, 15))) :-
    described_profile(open_not_public, Profile).
gpai_models_profile_for(obligation_open_source_copyright_policy, provider_obligation(Profile, copyright_policy, date(2026, 1, 15))) :-
    described_profile(open_small, Profile).
gpai_models_profile_for(obligation_open_source_training_content_summary, provider_obligation(Profile, training_content_summary, date(2026, 1, 15))) :-
    described_profile(open_small, Profile).
gpai_models_profile_for(obligation_open_source_cooperation, provider_obligation(Profile, cooperation_with_authorities, date(2026, 1, 15))) :-
    described_profile(open_small, Profile).
gpai_models_profile_for(obligation_union_provider_representative, provider_obligation(Profile, authorised_representative, date(2026, 1, 15))) :-
    described_profile(closed_union, Profile).
gpai_models_profile_for(obligation_third_country_provider_representative, provider_obligation(Profile, authorised_representative, date(2026, 1, 15))) :-
    described_profile(closed_third_country, Profile).
gpai_models_profile_for(obligation_open_source_third_country_representative, provider_obligation(Profile, authorised_representative, date(2026, 1, 15))) :-
    described_profile(open_third_country, Profile).
gpai_models_profile_for(obligation_systemic_third_country_representative, provider_obligation(Profile, authorised_representative, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_model_evaluation_with_systemic_risk, provider_obligation(Profile, model_evaluation, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_model_evaluation_at_threshold, provider_obligation(Profile, model_evaluation, date(2026, 1, 15))) :-
    described_profile(open_at_threshold, Profile).
gpai_models_profile_for(obligation_risk_assessment_with_systemic_risk, provider_obligation(Profile, systemic_risk_assessment_and_mitigation, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_incident_reporting_with_systemic_risk, provider_obligation(Profile, serious_incident_reporting, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_cybersecurity_with_systemic_risk, provider_obligation(Profile, cybersecurity_protection, date(2026, 1, 15))) :-
    described_profile(open_large, Profile).
gpai_models_profile_for(obligation_cybersecurity_without_systemic_risk, provider_obligation(Profile, cybersecurity_protection, date(2026, 1, 15))) :-
    described_profile(open_at_threshold, Profile).
gpai_models_profile_for(obligation_legacy_day_before_transition_end, provider_obligation(Profile, copyright_policy, date(2027, 8, 1))) :-
    described_profile(legacy_closed, Profile).
gpai_models_profile_for(obligation_legacy_on_transition_end, provider_obligation(Profile, copyright_policy, date(2027, 8, 2))) :-
    described_profile(legacy_closed, Profile).
gpai_models_profile_for(obligation_day_before_application, provider_obligation(Profile, copyright_policy, date(2025, 8, 1))) :-
    described_profile(closed_union, Profile).
gpai_models_profile_for(obligation_on_application_day, provider_obligation(Profile, copyright_policy, date(2025, 8, 2))) :-
    described_profile(closed_union, Profile).
gpai_models_profile_for(obligation_research_model, provider_obligation(Profile, copyright_policy, date(2026, 1, 15))) :-
    described_profile(research_model, Profile).
gpai_models_profile_for(obligation_unsure_licence_technical_documentation, provider_obligation(Profile, technical_documentation, date(2026, 1, 15))) :-
    described_profile(unsure_licence, Profile).
gpai_models_profile_for(obligation_unsure_licence_copyright_policy, provider_obligation(Profile, copyright_policy, date(2026, 1, 15))) :-
    described_profile(unsure_licence, Profile).
gpai_models_profile_for(obligation_missing_placed_key, provider_obligation(Profile, copyright_policy, date(2026, 1, 15))) :-
    profile_without_placed_key(Profile).
gpai_models_profile_for(obligation_missing_placed_key_after_transition, provider_obligation(Profile, copyright_policy, date(2027, 8, 2))) :-
    profile_without_placed_key(Profile).
gpai_models_profile_for(obligation_unknown_obligation, provider_obligation(Profile, swimming_lessons, date(2026, 1, 15))) :-
    described_profile(closed_union, Profile).
gpai_models_profile_for(documentation_technical, documentation(technical_documentation)).
gpai_models_profile_for(documentation_additional, documentation(additional_technical_documentation_for_models_with_systemic_risk)).
gpai_models_profile_for(documentation_downstream, documentation(information_for_downstream_providers)).
gpai_models_profile_for(documentation_unknown, documentation(annual_report)).

gpai_models_assess(Subject, Result) :-
    gpai_models_profile_for(Subject, Request),
    decide_gpai_models(Request, Result).
