% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_kernel, [scope_and_roles_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

scope_and_roles_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [ai_system, exclusively_for_military_defence_or_national_security_purposes, third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation, adequate_safeguards_for_fundamental_rights_and_freedoms, specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development, research_testing_or_development_before_placing_on_the_market_or_putting_into_service, testing_in_real_world_conditions, released_under_free_and_open_source_licence, placed_on_the_market_or_put_into_service_as_high_risk_or_under_article_5_or_50, actor_role, use_in_a_personal_non_professional_activity, develops_or_has_developed_the_system, places_or_puts_into_service_the_system_together_with_its_product, under_its_own_name_or_trademark, uses_the_system_under_its_authority, written_mandate_from_a_provider_received_and_accepted, in_the_supply_chain, makes_the_system_available_on_the_union_market, is_a_product_manufacturer, places_the_system_on_the_union_market, puts_the_system_into_service_in_the_union, established_or_located_in_the_union, located_in_the_union, output_used_in_the_union, represented_provider_established_in_the_union, high_risk_under_article_6_1_related_to_a_product_under_section_b_of_annex_i, system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country, high_risk_route, product_manufacturer_of_a_product_under_section_a_of_annex_i_with_the_system_as_safety_component, system_is_high_risk_after_the_change, puts_its_name_or_trademark_on_a_high_risk_system_already_placed_or_in_service, makes_a_substantial_modification_to_a_high_risk_system_already_placed_or_in_service, modifies_the_intended_purpose_of_a_system_not_classified_as_high_risk_already_placed_or_in_service, system_placed_on_the_market_together_with_the_product_under_the_manufacturer_name, system_put_into_service_under_the_manufacturer_name_after_the_product_was_placed, another_person_became_the_provider_under_paragraph_1, initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk, supplies_items_used_or_integrated_in_a_high_risk_system, makes_the_items_accessible_to_the_public_under_a_free_and_open_source_licence, supplied_items_include_a_general_purpose_ai_model],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(ai_system, judgement).
key_type(exclusively_for_military_defence_or_national_security_purposes, judgement).
key_type(third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation, boolean).
key_type(adequate_safeguards_for_fundamental_rights_and_freedoms, judgement).
key_type(specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development, judgement).
key_type(research_testing_or_development_before_placing_on_the_market_or_putting_into_service, boolean).
key_type(testing_in_real_world_conditions, boolean).
key_type(released_under_free_and_open_source_licence, boolean).
key_type(placed_on_the_market_or_put_into_service_as_high_risk_or_under_article_5_or_50, boolean).
key_type(actor_role, enum([provider, deployer, importer, distributor, product_manufacturer, authorised_representative, affected_person])).
key_type(use_in_a_personal_non_professional_activity, judgement).
key_type(develops_or_has_developed_the_system, boolean).
key_type(places_or_puts_into_service_the_system_together_with_its_product, boolean).
key_type(under_its_own_name_or_trademark, boolean).
key_type(uses_the_system_under_its_authority, boolean).
key_type(written_mandate_from_a_provider_received_and_accepted, boolean).
key_type(in_the_supply_chain, boolean).
key_type(makes_the_system_available_on_the_union_market, judgement).
key_type(is_a_product_manufacturer, boolean).
key_type(places_the_system_on_the_union_market, judgement).
key_type(puts_the_system_into_service_in_the_union, judgement).
key_type(established_or_located_in_the_union, boolean).
key_type(located_in_the_union, boolean).
key_type(output_used_in_the_union, judgement).
key_type(represented_provider_established_in_the_union, boolean).
key_type(high_risk_under_article_6_1_related_to_a_product_under_section_b_of_annex_i, boolean).
key_type(system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country, boolean).
key_type(high_risk_route, enum([annex_iii, annex_i])).
key_type(product_manufacturer_of_a_product_under_section_a_of_annex_i_with_the_system_as_safety_component, boolean).
key_type(system_is_high_risk_after_the_change, boolean).
key_type(puts_its_name_or_trademark_on_a_high_risk_system_already_placed_or_in_service, boolean).
key_type(makes_a_substantial_modification_to_a_high_risk_system_already_placed_or_in_service, judgement).
key_type(modifies_the_intended_purpose_of_a_system_not_classified_as_high_risk_already_placed_or_in_service, judgement).
key_type(system_placed_on_the_market_together_with_the_product_under_the_manufacturer_name, boolean).
key_type(system_put_into_service_under_the_manufacturer_name_after_the_product_was_placed, boolean).
key_type(another_person_became_the_provider_under_paragraph_1, boolean).
key_type(initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk, judgement).
key_type(supplies_items_used_or_integrated_in_a_high_risk_system, boolean).
key_type(makes_the_items_accessible_to_the_public_under_a_free_and_open_source_licence, boolean).
key_type(supplied_items_include_a_general_purpose_ai_model, boolean).

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
