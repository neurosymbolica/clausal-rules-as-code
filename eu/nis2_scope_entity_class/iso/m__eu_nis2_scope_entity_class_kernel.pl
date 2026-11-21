% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2, nis2_scope_entity_class_profile_key_order/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

nis2_scope_entity_class_profile_key_order([annex_i_type, annex_ii_type, services_or_activities_in_union, staff_headcount, annual_turnover_eur, annual_balance_sheet_total_eur, public_electronic_communications_provider, trust_service_provider_status, tld_name_registry, dns_service_provider, sole_provider_of_an_essential_service_in_a_member_state, disruption_could_significantly_impact_public_safety_security_or_health, disruption_could_induce_a_significant_systemic_risk, critical_by_specific_national_or_regional_importance, public_administration_kind, public_administration_in_national_security_defence_or_law_enforcement, critical_entity_under_directive_2022_2557, domain_name_registration_service_entity, exempted_from_dora_scope_by_member_state, identified_by_member_state_as_essential_entity, former_operator_of_essential_services_kept_essential_by_member_state]).

nis2_scope_entity_class_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    nis2_scope_entity_class_profile_key_order(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(annex_i_type, judgement).
key_type(annex_ii_type, judgement).
key_type(services_or_activities_in_union, boolean).
key_type(staff_headcount, non_negative_integer).
key_type(annual_turnover_eur, non_negative_integer).
key_type(annual_balance_sheet_total_eur, non_negative_integer).
key_type(public_electronic_communications_provider, boolean).
key_type(trust_service_provider_status, enum([not_a_trust_service_provider, non_qualified_trust_service_provider, qualified_trust_service_provider])).
key_type(tld_name_registry, boolean).
key_type(dns_service_provider, boolean).
key_type(sole_provider_of_an_essential_service_in_a_member_state, judgement).
key_type(disruption_could_significantly_impact_public_safety_security_or_health, judgement).
key_type(disruption_could_induce_a_significant_systemic_risk, judgement).
key_type(critical_by_specific_national_or_regional_importance, judgement).
key_type(public_administration_kind, enum([not_public_administration, central_government, regional_with_risk_assessed_services, other_public_administration])).
key_type(public_administration_in_national_security_defence_or_law_enforcement, boolean).
key_type(critical_entity_under_directive_2022_2557, boolean).
key_type(domain_name_registration_service_entity, boolean).
key_type(exempted_from_dora_scope_by_member_state, boolean).
key_type(identified_by_member_state_as_essential_entity, boolean).
key_type(former_operator_of_essential_services_kept_essential_by_member_state, boolean).

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
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

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
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.

test(the_key_order_holds_twenty_one_keys) :-
    nis2_scope_entity_class_profile_key_order(Keys),
    length(Keys, 21).
test(a_well_formed_profile_has_no_problem) :-
    nis2_scope_entity_class_input_problems([attribute(annex_i_type, unsure), attribute(staff_headcount, 12), attribute(public_administration_kind, central_government)], []).
test(an_empty_profile_has_no_problem) :-
    nis2_scope_entity_class_input_problems([], []).
test(a_repeated_key_is_a_duplicate_only) :-
    nis2_scope_entity_class_input_problems([attribute(tld_name_registry, true), attribute(tld_name_registry, maybe)], [duplicate_key(tld_name_registry)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    nis2_scope_entity_class_input_problems([attribute(colour, red), attribute(staff_headcount, -1), attribute(annex_i_type, yes), attribute(colour, blue)], [wrong_type(annex_i_type), wrong_type(staff_headcount), unknown_key(colour)]).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    nis2_scope_entity_class_input_problems([attribute(dns_service_provider, unsure)], [wrong_type(dns_service_provider)]).
test(a_list_with_a_foreign_element_is_not_a_profile) :-
    nis2_scope_entity_class_input_problems([attribute(annex_i_type, true), foo], [wrong_type(profile)]).

test(a_well_formed_profile_is_not_refused, fail) :-
    nis2_scope_entity_class_input_problems([attribute(annex_i_type, true)], [wrong_type(profile)]).
