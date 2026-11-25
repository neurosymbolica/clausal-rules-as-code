% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, major_ict_related_incident_disrupted_core_activities, competent_authority_requested_post_incident_review_changes, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, post_ict_related_incident_reviews_put_in_place, post_incident_review_changes_communicated_to_competent_authorities, post_incident_reviews_determine_procedures_followed_and_actions_effective, post_incident_reviews_cover_promptness_of_response_and_impact_determination, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, post_incident_reviews_cover_effectiveness_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment_process, findings_form_basis_for_reviews_of_ict_risk_management_framework, effectiveness_of_resilience_strategy_implementation_monitored, evolution_of_ict_risk_mapped_over_time, frequency_types_magnitude_and_evolution_of_incidents_analysed, cyber_maturity_and_preparedness_enhanced, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, awareness_programmes_and_resilience_training_compulsory_in_staff_training, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, ict_third_party_service_providers_included_in_training_where_appropriate, relevant_technological_developments_monitored_continuously, kept_up_to_date_with_latest_ict_risk_management_processes],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(major_ict_related_incident_disrupted_core_activities, fact).
key_type(competent_authority_requested_post_incident_review_changes, fact).
key_type(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, judgement).
key_type(post_ict_related_incident_reviews_put_in_place, judgement).
key_type(post_incident_review_changes_communicated_to_competent_authorities, judgement).
key_type(post_incident_reviews_determine_procedures_followed_and_actions_effective, judgement).
key_type(post_incident_reviews_cover_promptness_of_response_and_impact_determination, judgement).
key_type(post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, judgement).
key_type(post_incident_reviews_cover_effectiveness_of_incident_escalation, judgement).
key_type(post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, judgement).
key_type(lessons_incorporated_into_ict_risk_assessment_process, judgement).
key_type(findings_form_basis_for_reviews_of_ict_risk_management_framework, judgement).
key_type(effectiveness_of_resilience_strategy_implementation_monitored, judgement).
key_type(evolution_of_ict_risk_mapped_over_time, judgement).
key_type(frequency_types_magnitude_and_evolution_of_incidents_analysed, judgement).
key_type(cyber_maturity_and_preparedness_enhanced, judgement).
key_type(senior_ict_staff_report_findings_and_recommendations_at_least_yearly, judgement).
key_type(awareness_programmes_and_resilience_training_compulsory_in_staff_training, judgement).
key_type(programmes_and_training_apply_to_all_staff_at_commensurate_complexity, judgement).
key_type(ict_third_party_service_providers_included_in_training_where_appropriate, judgement).
key_type(relevant_technological_developments_monitored_continuously, judgement).
key_type(kept_up_to_date_with_latest_ict_risk_management_processes, judgement).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).
