% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_third_party_entity_duties_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [assessed_whether_arrangement_supports_critical_or_important_function, assessed_supervisory_conditions_for_contracting, identified_and_assessed_relevant_risks, undertook_due_diligence_on_provider, identified_and_assessed_conflicts_of_interest, provider_complies_with_appropriate_information_security_standards, entity_exercises_access_inspection_and_audit_rights, audit_frequency_and_areas_predetermined, arrangement_entails_high_technical_complexity, auditor_skills_and_knowledge_verified, supports_critical_or_important_function, considered_most_up_to_date_information_security_standards, exit_strategy_in_place, able_to_exit_without_business_disruption, able_to_exit_without_limiting_regulatory_compliance, able_to_exit_without_detriment_to_client_services, exit_plans_comprehensive_documented_tested_and_reviewed, alternative_solutions_and_transition_plans_in_place, contingency_measures_in_place, considered_concentration_risk, weighed_alternative_solutions, considered_insolvency_law_and_data_recovery_constraints, arrangement_allows_further_subcontracting, weighed_subcontracting_benefits_and_risks, assessed_impact_of_subcontracting_chains, provider_established_in_third_country, considered_third_country_data_protection_and_enforcement, financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(assessed_whether_arrangement_supports_critical_or_important_function, judgement).
key_type(assessed_supervisory_conditions_for_contracting, judgement).
key_type(identified_and_assessed_relevant_risks, judgement).
key_type(undertook_due_diligence_on_provider, judgement).
key_type(identified_and_assessed_conflicts_of_interest, judgement).
key_type(provider_complies_with_appropriate_information_security_standards, judgement).
key_type(entity_exercises_access_inspection_and_audit_rights, fact).
key_type(audit_frequency_and_areas_predetermined, judgement).
key_type(arrangement_entails_high_technical_complexity, judgement).
key_type(auditor_skills_and_knowledge_verified, judgement).
key_type(supports_critical_or_important_function, judgement).
key_type(considered_most_up_to_date_information_security_standards, judgement).
key_type(exit_strategy_in_place, judgement).
key_type(able_to_exit_without_business_disruption, judgement).
key_type(able_to_exit_without_limiting_regulatory_compliance, judgement).
key_type(able_to_exit_without_detriment_to_client_services, judgement).
key_type(exit_plans_comprehensive_documented_tested_and_reviewed, judgement).
key_type(alternative_solutions_and_transition_plans_in_place, judgement).
key_type(contingency_measures_in_place, judgement).
key_type(considered_concentration_risk, judgement).
key_type(weighed_alternative_solutions, judgement).
key_type(considered_insolvency_law_and_data_recovery_constraints, judgement).
key_type(arrangement_allows_further_subcontracting, fact).
key_type(weighed_subcontracting_benefits_and_risks, judgement).
key_type(assessed_impact_of_subcontracting_chains, judgement).
key_type(provider_established_in_third_country, fact).
key_type(considered_third_country_data_protection_and_enforcement, judgement).
key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).

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

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
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
