% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, ict_asset_management_policy_developed_documented_and_implemented, asset_policy_prescribes_monitoring_and_management_of_asset_lifecycle, asset_policy_prescribes_records_of_ict_assets, asset_policy_prescribes_records_for_legacy_system_risk_assessment, ict_asset_management_procedure_developed_documented_and_implemented, asset_procedure_specifies_criticality_assessment_criteria, encryption_policy_developed_documented_and_implemented, encryption_policy_designed_on_data_classification_and_ict_risk_assessment, encryption_policy_has_rules_for_data_at_rest_and_in_transit, encryption_policy_has_rules_for_data_in_use_where_necessary, encryption_policy_has_rules_for_network_connections_and_external_traffic, encryption_policy_has_rules_for_cryptographic_key_management, data_in_use_protected_where_its_encryption_is_not_possible, encryption_policy_has_criteria_for_selecting_cryptographic_techniques, mitigation_and_monitoring_where_leading_practices_or_standards_not_followed, encryption_policy_has_provisions_for_updating_cryptographic_technology, mitigation_and_monitoring_where_cryptographic_technology_not_updated, encryption_policy_requires_recording_of_mitigation_measures_with_reasons, key_management_policy_has_requirements_for_whole_key_lifecycle, key_protection_controls_identified_and_implemented, key_protection_controls_designed_on_data_classification_and_ict_risk_assessment, key_replacement_methods_developed_and_implemented, certificate_register_created_maintained_and_kept_up_to_date, certificates_renewed_promptly_before_expiration],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(ict_asset_management_policy_developed_documented_and_implemented, judgement).
key_type(asset_policy_prescribes_monitoring_and_management_of_asset_lifecycle, judgement).
key_type(asset_policy_prescribes_records_of_ict_assets, judgement).
key_type(asset_policy_prescribes_records_for_legacy_system_risk_assessment, judgement).
key_type(ict_asset_management_procedure_developed_documented_and_implemented, judgement).
key_type(asset_procedure_specifies_criticality_assessment_criteria, judgement).
key_type(encryption_policy_developed_documented_and_implemented, judgement).
key_type(encryption_policy_designed_on_data_classification_and_ict_risk_assessment, judgement).
key_type(encryption_policy_has_rules_for_data_at_rest_and_in_transit, judgement).
key_type(encryption_policy_has_rules_for_data_in_use_where_necessary, judgement).
key_type(encryption_policy_has_rules_for_network_connections_and_external_traffic, judgement).
key_type(encryption_policy_has_rules_for_cryptographic_key_management, judgement).
key_type(data_in_use_protected_where_its_encryption_is_not_possible, judgement).
key_type(encryption_policy_has_criteria_for_selecting_cryptographic_techniques, judgement).
key_type(mitigation_and_monitoring_where_leading_practices_or_standards_not_followed, judgement).
key_type(encryption_policy_has_provisions_for_updating_cryptographic_technology, judgement).
key_type(mitigation_and_monitoring_where_cryptographic_technology_not_updated, judgement).
key_type(encryption_policy_requires_recording_of_mitigation_measures_with_reasons, judgement).
key_type(key_management_policy_has_requirements_for_whole_key_lifecycle, judgement).
key_type(key_protection_controls_identified_and_implemented, judgement).
key_type(key_protection_controls_designed_on_data_classification_and_ict_risk_assessment, judgement).
key_type(key_replacement_methods_developed_and_implemented, judgement).
key_type(certificate_register_created_maintained_and_kept_up_to_date, judgement).
key_type(certificates_renewed_promptly_before_expiration, judgement).

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
