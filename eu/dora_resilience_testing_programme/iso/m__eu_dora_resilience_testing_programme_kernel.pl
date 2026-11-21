% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2, contract_key/2, present_pairs/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

contract_key(1, financial_entity_is_microenterprise).
contract_key(2, dora_entity_type).
contract_key(3, tests_undertaken_by_internal_tester).
contract_key(4, resilience_testing_programme_established_maintained_and_reviewed).
contract_key(5, programme_includes_range_of_assessments_and_tests).
contract_key(6, programme_conducted_on_risk_based_approach).
contract_key(7, tests_undertaken_by_independent_parties).
contract_key(8, internal_tester_resourced_and_conflicts_of_interest_avoided).
contract_key(9, procedures_to_prioritise_classify_and_remedy_issues_established).
contract_key(10, internal_validation_methodologies_established).
contract_key(11, critical_ict_systems_tested_at_least_yearly).
contract_key(12, programme_provides_for_appropriate_tests).
contract_key(13, vulnerability_assessments_performed_before_deployment).
contract_key(14, microenterprise_tests_risk_based_and_planned).

present_pairs(Profile, Pairs) :-
    findall(Key, contract_key(_, Key), Keys),
    keys_present_pairs(Keys, Profile, Pairs).

keys_present_pairs([], _, []).
keys_present_pairs([Key|Keys], Profile, [Key - Value|Pairs]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    keys_present_pairs(Keys, Profile, Pairs).
keys_present_pairs([Key|Keys], Profile, Pairs) :-
    profile_lacks(Profile, Key),
    keys_present_pairs(Keys, Profile, Pairs).

dora_resilience_testing_programme_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_microenterprise, dora_entity_type, tests_undertaken_by_internal_tester, resilience_testing_programme_established_maintained_and_reviewed, programme_includes_range_of_assessments_and_tests, programme_conducted_on_risk_based_approach, tests_undertaken_by_independent_parties, internal_tester_resourced_and_conflicts_of_interest_avoided, procedures_to_prioritise_classify_and_remedy_issues_established, internal_validation_methodologies_established, critical_ict_systems_tested_at_least_yearly, programme_provides_for_appropriate_tests, vulnerability_assessments_performed_before_deployment, microenterprise_tests_risk_based_and_planned],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_microenterprise, fact).
key_type(dora_entity_type, entity_type).
key_type(tests_undertaken_by_internal_tester, fact).
key_type(resilience_testing_programme_established_maintained_and_reviewed, judgement).
key_type(programme_includes_range_of_assessments_and_tests, judgement).
key_type(programme_conducted_on_risk_based_approach, judgement).
key_type(tests_undertaken_by_independent_parties, judgement).
key_type(internal_tester_resourced_and_conflicts_of_interest_avoided, judgement).
key_type(procedures_to_prioritise_classify_and_remedy_issues_established, judgement).
key_type(internal_validation_methodologies_established, judgement).
key_type(critical_ict_systems_tested_at_least_yearly, judgement).
key_type(programme_provides_for_appropriate_tests, judgement).
key_type(vulnerability_assessments_performed_before_deployment, judgement).
key_type(microenterprise_tests_risk_based_and_planned, judgement).

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
in_type_t(entity_type, Value, T) :-
    in_type_t(enum([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]), Value, T).
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
    dora_resilience_testing_programme_input_problems([attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty), attribute(programme_conducted_on_risk_based_approach, unsure)], Problems),
    Problems == [].
test(the_empty_profile_has_no_problem) :-
    dora_resilience_testing_programme_input_problems([], []).
test(a_repeated_key_is_a_duplicate_only) :-
    dora_resilience_testing_programme_input_problems([attribute(financial_entity_is_microenterprise, true), attribute(financial_entity_is_microenterprise, unsure)], Problems),
    Problems == [duplicate_key(financial_entity_is_microenterprise)].
test(unsure_is_the_wrong_type_for_a_fact) :-
    dora_resilience_testing_programme_input_problems([attribute(tests_undertaken_by_internal_tester, unsure)], Problems),
    Problems == [wrong_type(tests_undertaken_by_internal_tester)].
test(unsure_is_a_judgement_value) :-
    dora_resilience_testing_programme_input_problems([attribute(microenterprise_tests_risk_based_and_planned, unsure)], []).
test(an_unknown_key_comes_after_the_contract_keys) :-
    dora_resilience_testing_programme_input_problems([attribute(colour, red), attribute(dora_entity_type, bank)], Problems),
    Problems == [wrong_type(dora_entity_type), unknown_key(colour)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_resilience_testing_programme_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(present_pairs_follow_the_contract_order) :-
    present_pairs([attribute(tests_undertaken_by_internal_tester, false), attribute(financial_entity_is_microenterprise, false)], Pairs),
    Pairs == [financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false].
test(the_first_contract_key) :-
    contract_key(1, financial_entity_is_microenterprise).

test(the_first_contract_key_is_not_the_type, fail) :-
    contract_key(1, dora_entity_type).
