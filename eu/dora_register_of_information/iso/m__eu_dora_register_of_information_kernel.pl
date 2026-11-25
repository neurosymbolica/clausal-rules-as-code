% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_kernel, [dora_register_of_information_input_problems/2, contract_keys/1, present_pairs/2, first_in_key_order/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3]).

dora_register_of_information_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_responsible_for_sub_consolidated_register, financial_entity_responsible_for_consolidated_register, competent_authority_requested_register, entity_plans_arrangement_supporting_critical_or_important_function, function_has_become_critical_or_important, entity_uses_ict_services_supporting_critical_or_important_functions, entity_has_branches_outside_home_country, ict_service_supply_chain_partly_intra_group, register_maintained_and_updated_at_entity_level, register_maintained_and_updated_at_sub_consolidated_level, register_maintained_and_updated_at_consolidated_level, arrangements_documented_distinguishing_critical_or_important_functions, reported_to_competent_authorities_at_least_yearly, register_made_available_to_competent_authority_on_request, competent_authority_informed_of_planned_arrangement, competent_authority_informed_that_function_has_become_critical_or_important, rank_assigned_to_each_ict_third_party_service_provider, templates_include_information_on_all_ict_services_of_direct_providers, templates_include_information_on_subcontractors_underpinning_critical_or_important_functions, template_information_meets_data_quality_principles, template_information_reviewed_regularly_and_errors_corrected, entity_level_information_consistent_with_sub_consolidated_level, entity_level_information_consistent_with_consolidated_level, providers_identified_by_legal_entity_identifier_or_european_unique_identifier, subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier, data_elements_completed_with_single_values, all_data_elements_completed_at_each_applicable_level, register_includes_general_information_on_maintaining_entity, register_includes_general_information_on_entities_in_consolidation, register_includes_identification_of_branches_outside_home_country, register_includes_general_information_on_contractual_arrangements, register_includes_specific_information_on_contractual_arrangements, register_includes_links_between_intra_group_and_other_arrangements, register_includes_entities_signing_arrangements_for_receiving_ict_services, register_includes_providers_signing_arrangements_for_providing_ict_services, register_includes_entities_providing_ict_services_within_consolidation, register_includes_entities_making_use_of_ict_services, register_includes_information_on_direct_providers_and_subcontractors, register_includes_information_on_ict_service_supply_chain, register_includes_identification_of_functions, register_includes_assessment_of_ict_services_supporting_critical_or_important_functions, register_includes_terminology_and_closed_lists],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_responsible_for_sub_consolidated_register, fact).
key_type(financial_entity_responsible_for_consolidated_register, fact).
key_type(competent_authority_requested_register, fact).
key_type(entity_plans_arrangement_supporting_critical_or_important_function, fact).
key_type(function_has_become_critical_or_important, fact).
key_type(entity_uses_ict_services_supporting_critical_or_important_functions, fact).
key_type(entity_has_branches_outside_home_country, fact).
key_type(ict_service_supply_chain_partly_intra_group, fact).
key_type(register_maintained_and_updated_at_entity_level, judgement).
key_type(register_maintained_and_updated_at_sub_consolidated_level, judgement).
key_type(register_maintained_and_updated_at_consolidated_level, judgement).
key_type(arrangements_documented_distinguishing_critical_or_important_functions, judgement).
key_type(reported_to_competent_authorities_at_least_yearly, judgement).
key_type(register_made_available_to_competent_authority_on_request, judgement).
key_type(competent_authority_informed_of_planned_arrangement, judgement).
key_type(competent_authority_informed_that_function_has_become_critical_or_important, judgement).
key_type(rank_assigned_to_each_ict_third_party_service_provider, judgement).
key_type(templates_include_information_on_all_ict_services_of_direct_providers, judgement).
key_type(templates_include_information_on_subcontractors_underpinning_critical_or_important_functions, judgement).
key_type(template_information_meets_data_quality_principles, judgement).
key_type(template_information_reviewed_regularly_and_errors_corrected, judgement).
key_type(entity_level_information_consistent_with_sub_consolidated_level, judgement).
key_type(entity_level_information_consistent_with_consolidated_level, judgement).
key_type(providers_identified_by_legal_entity_identifier_or_european_unique_identifier, judgement).
key_type(subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier, judgement).
key_type(data_elements_completed_with_single_values, judgement).
key_type(all_data_elements_completed_at_each_applicable_level, judgement).
key_type(register_includes_general_information_on_maintaining_entity, judgement).
key_type(register_includes_general_information_on_entities_in_consolidation, judgement).
key_type(register_includes_identification_of_branches_outside_home_country, judgement).
key_type(register_includes_general_information_on_contractual_arrangements, judgement).
key_type(register_includes_specific_information_on_contractual_arrangements, judgement).
key_type(register_includes_links_between_intra_group_and_other_arrangements, judgement).
key_type(register_includes_entities_signing_arrangements_for_receiving_ict_services, judgement).
key_type(register_includes_providers_signing_arrangements_for_providing_ict_services, judgement).
key_type(register_includes_entities_providing_ict_services_within_consolidation, judgement).
key_type(register_includes_entities_making_use_of_ict_services, judgement).
key_type(register_includes_information_on_direct_providers_and_subcontractors, judgement).
key_type(register_includes_information_on_ict_service_supply_chain, judgement).
key_type(register_includes_identification_of_functions, judgement).
key_type(register_includes_assessment_of_ict_services_supporting_critical_or_important_functions, judgement).
key_type(register_includes_terminology_and_closed_lists, judgement).

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

contract_keys([financial_entity_responsible_for_sub_consolidated_register, financial_entity_responsible_for_consolidated_register, competent_authority_requested_register, entity_plans_arrangement_supporting_critical_or_important_function, function_has_become_critical_or_important, entity_uses_ict_services_supporting_critical_or_important_functions, entity_has_branches_outside_home_country, ict_service_supply_chain_partly_intra_group, register_maintained_and_updated_at_entity_level, register_maintained_and_updated_at_sub_consolidated_level, register_maintained_and_updated_at_consolidated_level, arrangements_documented_distinguishing_critical_or_important_functions, reported_to_competent_authorities_at_least_yearly, register_made_available_to_competent_authority_on_request, competent_authority_informed_of_planned_arrangement, competent_authority_informed_that_function_has_become_critical_or_important, rank_assigned_to_each_ict_third_party_service_provider, templates_include_information_on_all_ict_services_of_direct_providers, templates_include_information_on_subcontractors_underpinning_critical_or_important_functions, template_information_meets_data_quality_principles, template_information_reviewed_regularly_and_errors_corrected, entity_level_information_consistent_with_sub_consolidated_level, entity_level_information_consistent_with_consolidated_level, providers_identified_by_legal_entity_identifier_or_european_unique_identifier, subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier, data_elements_completed_with_single_values, all_data_elements_completed_at_each_applicable_level, register_includes_general_information_on_maintaining_entity, register_includes_general_information_on_entities_in_consolidation, register_includes_identification_of_branches_outside_home_country, register_includes_general_information_on_contractual_arrangements, register_includes_specific_information_on_contractual_arrangements, register_includes_links_between_intra_group_and_other_arrangements, register_includes_entities_signing_arrangements_for_receiving_ict_services, register_includes_providers_signing_arrangements_for_providing_ict_services, register_includes_entities_providing_ict_services_within_consolidation, register_includes_entities_making_use_of_ict_services, register_includes_information_on_direct_providers_and_subcontractors, register_includes_information_on_ict_service_supply_chain, register_includes_identification_of_functions, register_includes_assessment_of_ict_services_supporting_critical_or_important_functions, register_includes_terminology_and_closed_lists]).

present_pairs(Profile, Pairs) :-
    contract_keys(Keys),
    findall(Key - Value, (member(Key, Keys), profile_get(Profile, Key, Value)), Pairs).

first_in_key_order(Keys, Key) :-
    contract_keys(OrderedKeys),
    first_listed(OrderedKeys, Keys, Key).

first_listed([Candidate|Candidates], Keys, Key) :-
    memberd_t(Candidate, Keys, IsListed),
    first_listed_pick(IsListed, Candidate, Candidates, Keys, Key).

first_listed_pick(true, Candidate, _, _, Candidate).
first_listed_pick(false, _, Candidates, Keys, Key) :-
    first_listed(Candidates, Keys, Key).

test(contract_keys_match_the_typed_contract) :-
    contract_keys(Keys),
    length(Keys, 42),
    findall(Typed, key_type(Typed, _), TypedKeys),
    TypedKeys == Keys.
test(empty_profile_has_no_problem) :-
    dora_register_of_information_input_problems([], Problems),
    Problems == [].
test(well_formed_profile_has_no_problem) :-
    dora_register_of_information_input_problems([attribute(competent_authority_requested_register, false), attribute(template_information_meets_data_quality_principles, unsure)], Problems),
    Problems == [].
test(a_profile_that_is_not_a_list) :-
    dora_register_of_information_input_problems(profile_atom, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile) :-
    dora_register_of_information_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(unsure_on_a_trigger_is_wrong_type) :-
    dora_register_of_information_input_problems([attribute(competent_authority_requested_register, unsure)], Problems),
    Problems == [wrong_type(competent_authority_requested_register)].
test(a_number_value_is_wrong_type) :-
    dora_register_of_information_input_problems([attribute(template_information_meets_data_quality_principles, 1)], Problems),
    Problems == [wrong_type(template_information_meets_data_quality_principles)].
test(a_repeated_key_is_duplicate_only) :-
    dora_register_of_information_input_problems([attribute(template_information_meets_data_quality_principles, true), attribute(template_information_meets_data_quality_principles, 7)], Problems),
    Problems == [duplicate_key(template_information_meets_data_quality_principles)].
test(a_key_of_another_order_is_unknown) :-
    dora_register_of_information_input_problems([attribute(financial_entity_is_microenterprise, true)], Problems),
    Problems == [unknown_key(financial_entity_is_microenterprise)].
test(an_unbound_key_is_unknown_as_given) :-
    dora_register_of_information_input_problems([attribute(Variable, true)], Problems),
    Problems == [unknown_key(Variable)].
test(contract_problems_come_before_unknown_keys) :-
    dora_register_of_information_input_problems([attribute(dora_entity_type, credit_institution), attribute(competent_authority_requested_register, unsure)], Problems),
    Problems == [wrong_type(competent_authority_requested_register), unknown_key(dora_entity_type)].
test(present_pairs_follow_contract_order) :-
    present_pairs([attribute(competent_authority_requested_register, true), attribute(financial_entity_responsible_for_sub_consolidated_register, false)], Pairs),
    Pairs == [financial_entity_responsible_for_sub_consolidated_register - false, competent_authority_requested_register - true].
test(first_in_key_order_picks_the_earliest_key) :-
    findall(Key, first_in_key_order([register_includes_terminology_and_closed_lists, competent_authority_requested_register], Key), Firsts),
    Firsts == [competent_authority_requested_register].

test(first_in_key_order_has_no_answer_for_no_contract_key, fail) :-
    first_in_key_order([dora_entity_type], _).
