% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_queries, [gpai_models_profile_keys/1, gpai_models_what_if/4, date/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, general_purpose_ai_model/0, used_for_research_development_or_prototyping_before_being_placed_on_the_market/0, cumulative_training_computation_in_floating_point_operations/0, high_impact_capabilities/0, designated_by_a_commission_decision_as_a_model_with_systemic_risk/0, commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks/0, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution/0, parameters_weights_architecture_and_usage_information_made_publicly_available/0, provider_established_in_a_third_country/0, placed_on_the_market_before_2_august_2025/0, technical_documentation/0, information_for_downstream_providers/0, copyright_policy/0, training_content_summary/0, cooperation_with_authorities/0, authorised_representative/0, model_evaluation/0, systemic_risk_assessment_and_mitigation/0, serious_incident_reporting/0, cybersecurity_protection/0, additional_technical_documentation_for_models_with_systemic_risk/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_ai_act_gpai_models_kernel, [gpai_models_input_problems/2]).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [gpai_models_status/2]).

gpai_models_profile_keys([general_purpose_ai_model, used_for_research_development_or_prototyping_before_being_placed_on_the_market, cumulative_training_computation_in_floating_point_operations, high_impact_capabilities, designated_by_a_commission_decision_as_a_model_with_systemic_risk, commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, parameters_weights_architecture_and_usage_information_made_publicly_available, provider_established_in_a_third_country, placed_on_the_market_before_2_august_2025]).

date(Year, Month, Day) :-
    integer(Year),
    integer(Month),
    integer(Day),
    Month >= 1,
    Month =< 12,
    Day >= 1,
    Day =< 31.

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]) :-
    atom(Judgement),
    atom(CitationKey),
    is_list(Pairs).
needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs), provenance(Clause, Citations)]) :-
    atom(Judgement),
    atom(CitationKey),
    is_list(Pairs),
    atom(Clause),
    is_list(Citations).

open_textured(Judgement, cite(CitationKey)) :-
    atom(Judgement),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(UnknownKey) :-
    nonvar(UnknownKey).

wrong_type(Name) :-
    atom(Name).

duplicate_key(DuplicatedKey) :-
    atom(DuplicatedKey).

general_purpose_ai_model.

used_for_research_development_or_prototyping_before_being_placed_on_the_market.

cumulative_training_computation_in_floating_point_operations.

high_impact_capabilities.

designated_by_a_commission_decision_as_a_model_with_systemic_risk.

commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks.

released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution.

parameters_weights_architecture_and_usage_information_made_publicly_available.

provider_established_in_a_third_country.

placed_on_the_market_before_2_august_2025.

technical_documentation.

information_for_downstream_providers.

copyright_policy.

training_content_summary.

cooperation_with_authorities.

authorised_representative.

model_evaluation.

systemic_risk_assessment_and_mitigation.

serious_incident_reporting.

cybersecurity_protection.

additional_technical_documentation_for_models_with_systemic_risk.

unsure.

gpai_models_what_if(Request, OverriddenKey, NewValue, NewStatus) :-
    request_with_override(Request, OverriddenKey, NewValue, Hypothesis),
    gpai_models_status(Hypothesis, NewStatus).

request_with_override(systemic_risk_classification(Profile, AssessmentDate), OverriddenKey, NewValue, systemic_risk_classification(NewProfile, AssessmentDate)) :-
    profile_with_override(Profile, OverriddenKey, NewValue, NewProfile).
request_with_override(systemic_risk_notification(Profile, TriggerDate, NotificationDate), OverriddenKey, NewValue, systemic_risk_notification(NewProfile, TriggerDate, NotificationDate)) :-
    profile_with_override(Profile, OverriddenKey, NewValue, NewProfile).
request_with_override(provider_obligation(Profile, Obligation, AssessmentDate), OverriddenKey, NewValue, provider_obligation(NewProfile, Obligation, AssessmentDate)) :-
    profile_with_override(Profile, OverriddenKey, NewValue, NewProfile).
request_with_override(documentation(Document), _, _, documentation(Document)).

profile_with_override(Profile, OverriddenKey, NewValue, NewProfile) :-
    attributes_without_key(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], NewProfile).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, KeptAttributes) :-
    ElementKey == OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|KeptAttributes]) :-
    ElementKey \== OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).
