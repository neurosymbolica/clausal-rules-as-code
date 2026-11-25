% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_policies_and_risk_management_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, size_risk_profile_and_complexity_taken_into_account, ict_security_policies_embedded_in_ict_risk_management_framework, security_policies_ensure_security_of_networks, security_policies_contain_safeguards_against_intrusions_and_data_misuse, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, security_policies_guarantee_accurate_and_prompt_data_transmission, security_policies_aligned_to_information_security_objectives, security_policies_indicate_date_of_management_body_approval, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, security_policies_specify_staff_responsibilities_for_ict_security, security_policies_specify_consequences_of_staff_non_compliance, security_policies_list_documentation_to_be_maintained, security_policies_specify_segregation_of_duties_arrangements, security_policies_consider_leading_practices_and_standards, security_policies_identify_roles_for_development_implementation_and_maintenance, security_policies_reviewed_in_accordance_with_article_6_5, security_policies_take_material_changes_into_account, ict_risk_management_policies_and_procedures_developed_documented_and_implemented, risk_management_policies_indicate_approval_of_risk_tolerance_level, risk_management_policies_contain_risk_assessment_procedure_and_methodology, risk_management_policies_contain_risk_treatment_procedure, risk_management_policies_contain_residual_risk_provisions, risk_management_policies_contain_risk_monitoring_provisions, risk_management_policies_contain_process_for_strategy_changes, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, risk_treatment_procedure_ensures_assessment_of_corrective_actions],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(size_risk_profile_and_complexity_taken_into_account, judgement).
key_type(ict_security_policies_embedded_in_ict_risk_management_framework, judgement).
key_type(security_policies_ensure_security_of_networks, judgement).
key_type(security_policies_contain_safeguards_against_intrusions_and_data_misuse, judgement).
key_type(security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, judgement).
key_type(security_policies_guarantee_accurate_and_prompt_data_transmission, judgement).
key_type(security_policies_aligned_to_information_security_objectives, judgement).
key_type(security_policies_indicate_date_of_management_body_approval, judgement).
key_type(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, judgement).
key_type(security_policies_specify_staff_responsibilities_for_ict_security, judgement).
key_type(security_policies_specify_consequences_of_staff_non_compliance, judgement).
key_type(security_policies_list_documentation_to_be_maintained, judgement).
key_type(security_policies_specify_segregation_of_duties_arrangements, judgement).
key_type(security_policies_consider_leading_practices_and_standards, judgement).
key_type(security_policies_identify_roles_for_development_implementation_and_maintenance, judgement).
key_type(security_policies_reviewed_in_accordance_with_article_6_5, judgement).
key_type(security_policies_take_material_changes_into_account, judgement).
key_type(ict_risk_management_policies_and_procedures_developed_documented_and_implemented, judgement).
key_type(risk_management_policies_indicate_approval_of_risk_tolerance_level, judgement).
key_type(risk_management_policies_contain_risk_assessment_procedure_and_methodology, judgement).
key_type(risk_management_policies_contain_risk_treatment_procedure, judgement).
key_type(risk_management_policies_contain_residual_risk_provisions, judgement).
key_type(risk_management_policies_contain_risk_monitoring_provisions, judgement).
key_type(risk_management_policies_contain_process_for_strategy_changes, judgement).
key_type(risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, judgement).
key_type(risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, judgement).
key_type(risk_treatment_procedure_ensures_assessment_of_corrective_actions, judgement).

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

test(a_well_formed_profile_has_no_problem) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(size_risk_profile_and_complexity_taken_into_account, unsure)], []).
test(unsure_on_the_gate_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(a_repeated_key_is_duplicate_only) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(security_policies_ensure_security_of_networks, true), attribute(security_policies_ensure_security_of_networks, 7)], [duplicate_key(security_policies_ensure_security_of_networks)]).
test(an_unknown_key_comes_after_contract_problems) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(colour, 3), attribute(financial_entity_is_article_16_1_entity, 1)], [wrong_type(financial_entity_is_article_16_1_entity), unknown_key(colour)]).
test(a_non_list_profile_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems(_, [wrong_type(profile)]).

test(unsure_on_the_gate_is_not_accepted, fail) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], []).
