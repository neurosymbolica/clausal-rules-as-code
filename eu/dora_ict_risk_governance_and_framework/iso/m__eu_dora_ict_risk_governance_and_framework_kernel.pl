% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_governance_and_framework_kernel, [dora_ict_risk_governance_and_framework_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_risk_governance_and_framework_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, authority_requested_ict_risk_information, authority_requested_framework_review_report, major_change_occurred, entity_operates_legacy_ict_systems, has_internal_governance_and_control_framework, management_body_defines_approves_and_oversees_framework, management_body_bears_ultimate_ict_risk_responsibility, management_body_put_in_place_data_security_policies, ict_roles_and_governance_arrangements_set, management_body_approved_strategy_and_risk_tolerance, management_body_oversees_continuity_policy_and_plans, management_body_approves_ict_audit_plans, management_body_allocates_resilience_budget, management_body_approves_third_party_policy, reporting_channels_to_management_body_in_place, third_party_monitoring_role_established, management_body_keeps_ict_knowledge_up_to_date, has_sound_documented_ict_risk_management_framework, framework_protects_information_and_ict_assets, minimises_ict_risk_impact, provided_ict_risk_information_on_request, independent_ict_risk_control_function_assigned, risk_control_and_audit_functions_segregated, framework_reviewed_at_least_yearly, framework_reviewed_periodically, framework_reviewed_upon_events_and_improved, review_report_submitted_on_request, framework_internally_audited, formal_audit_follow_up_process_established, resilience_strategy_in_framework, uses_updated_appropriate_ict_systems, functions_and_assets_identified_and_classified, ict_risk_sources_identified_and_assessed, risk_assessed_upon_major_change, assets_identified_and_mapped, third_party_dependencies_identified, inventories_maintained_and_updated, legacy_systems_risk_assessed],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(authority_requested_ict_risk_information, fact).
key_type(authority_requested_framework_review_report, fact).
key_type(major_change_occurred, fact).
key_type(entity_operates_legacy_ict_systems, fact).
key_type(has_internal_governance_and_control_framework, judgement).
key_type(management_body_defines_approves_and_oversees_framework, judgement).
key_type(management_body_bears_ultimate_ict_risk_responsibility, judgement).
key_type(management_body_put_in_place_data_security_policies, judgement).
key_type(ict_roles_and_governance_arrangements_set, judgement).
key_type(management_body_approved_strategy_and_risk_tolerance, judgement).
key_type(management_body_oversees_continuity_policy_and_plans, judgement).
key_type(management_body_approves_ict_audit_plans, judgement).
key_type(management_body_allocates_resilience_budget, judgement).
key_type(management_body_approves_third_party_policy, judgement).
key_type(reporting_channels_to_management_body_in_place, judgement).
key_type(third_party_monitoring_role_established, judgement).
key_type(management_body_keeps_ict_knowledge_up_to_date, judgement).
key_type(has_sound_documented_ict_risk_management_framework, judgement).
key_type(framework_protects_information_and_ict_assets, judgement).
key_type(minimises_ict_risk_impact, judgement).
key_type(provided_ict_risk_information_on_request, judgement).
key_type(independent_ict_risk_control_function_assigned, judgement).
key_type(risk_control_and_audit_functions_segregated, judgement).
key_type(framework_reviewed_at_least_yearly, fact).
key_type(framework_reviewed_periodically, judgement).
key_type(framework_reviewed_upon_events_and_improved, judgement).
key_type(review_report_submitted_on_request, judgement).
key_type(framework_internally_audited, judgement).
key_type(formal_audit_follow_up_process_established, judgement).
key_type(resilience_strategy_in_framework, judgement).
key_type(uses_updated_appropriate_ict_systems, judgement).
key_type(functions_and_assets_identified_and_classified, judgement).
key_type(ict_risk_sources_identified_and_assessed, judgement).
key_type(risk_assessed_upon_major_change, judgement).
key_type(assets_identified_and_mapped, judgement).
key_type(third_party_dependencies_identified, judgement).
key_type(inventories_maintained_and_updated, judgement).
key_type(legacy_systems_risk_assessed, judgement).

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
