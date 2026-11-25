% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_kernel, [dora_rts_ict_operations_and_capacity_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_ict_operations_and_capacity_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, development_or_testing_performed_in_production_environment, ict_operations_policies_and_procedures_developed_documented_and_implemented, ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets, ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems, ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets, ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems, ict_operations_policies_cover_backup_and_restore_requirements, ict_operations_policies_cover_scheduling_requirements_considering_interdependencies, ict_operations_policies_cover_audit_trail_and_system_log_protocols, ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption, ict_operations_policies_cover_separation_of_production_from_non_production_environments, ict_operations_policies_cover_development_and_testing_in_separated_environments, ict_operations_policies_cover_development_and_testing_in_production_environments, ict_operations_policies_cover_error_handling_procedures_and_protocols, ict_operations_policies_cover_support_and_escalation_contacts, ict_operations_policies_cover_restart_rollback_and_recovery_procedures, environment_separation_considers_all_components_of_the_environment, production_testing_instances_identified_reasoned_time_limited_and_approved, security_of_ict_systems_and_production_data_ensured_during_production_testing, capacity_and_performance_management_procedures_developed_documented_and_implemented, capacity_procedures_identify_capacity_requirements_of_ict_systems, capacity_procedures_apply_resource_optimisation, capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems, capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems, capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages, capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(development_or_testing_performed_in_production_environment, fact).
key_type(ict_operations_policies_and_procedures_developed_documented_and_implemented, judgement).
key_type(ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets, judgement).
key_type(ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems, judgement).
key_type(ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets, judgement).
key_type(ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems, judgement).
key_type(ict_operations_policies_cover_backup_and_restore_requirements, judgement).
key_type(ict_operations_policies_cover_scheduling_requirements_considering_interdependencies, judgement).
key_type(ict_operations_policies_cover_audit_trail_and_system_log_protocols, judgement).
key_type(ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption, judgement).
key_type(ict_operations_policies_cover_separation_of_production_from_non_production_environments, judgement).
key_type(ict_operations_policies_cover_development_and_testing_in_separated_environments, judgement).
key_type(ict_operations_policies_cover_development_and_testing_in_production_environments, judgement).
key_type(ict_operations_policies_cover_error_handling_procedures_and_protocols, judgement).
key_type(ict_operations_policies_cover_support_and_escalation_contacts, judgement).
key_type(ict_operations_policies_cover_restart_rollback_and_recovery_procedures, judgement).
key_type(environment_separation_considers_all_components_of_the_environment, judgement).
key_type(production_testing_instances_identified_reasoned_time_limited_and_approved, judgement).
key_type(security_of_ict_systems_and_production_data_ensured_during_production_testing, judgement).
key_type(capacity_and_performance_management_procedures_developed_documented_and_implemented, judgement).
key_type(capacity_procedures_identify_capacity_requirements_of_ict_systems, judgement).
key_type(capacity_procedures_apply_resource_optimisation, judgement).
key_type(capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems, judgement).
key_type(capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems, judgement).
key_type(capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages, judgement).
key_type(capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems, judgement).

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
