% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2, contract_key_order/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

contract_key_order([dora_entity_type, investment_firm_is_small_and_non_interconnected, iorp_pension_scheme_members_total, exempted_from_dora_scope_by_member_state, authority_requested_framework_review_report, simplified_framework_in_place_and_maintained, ict_systems_continuously_monitored, ict_risk_impact_minimised_with_sound_systems, risk_sources_detected_and_incidents_handled, key_ict_third_party_dependencies_identified, continuity_of_critical_functions_ensured, plans_and_controls_tested_regularly, test_and_incident_conclusions_implemented, awareness_and_training_programmes_developed, simplified_framework_documented_and_reviewed, simplified_framework_continuously_improved, simplified_framework_review_report_submitted]).

dora_proportionality_and_simplified_framework_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    contract_key_order(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(dora_entity_type, entity_type).
key_type(investment_firm_is_small_and_non_interconnected, fact).
key_type(iorp_pension_scheme_members_total, non_negative_integer).
key_type(exempted_from_dora_scope_by_member_state, fact).
key_type(authority_requested_framework_review_report, fact).
key_type(simplified_framework_in_place_and_maintained, judgement).
key_type(ict_systems_continuously_monitored, judgement).
key_type(ict_risk_impact_minimised_with_sound_systems, judgement).
key_type(risk_sources_detected_and_incidents_handled, judgement).
key_type(key_ict_third_party_dependencies_identified, judgement).
key_type(continuity_of_critical_functions_ensured, judgement).
key_type(plans_and_controls_tested_regularly, judgement).
key_type(test_and_incident_conclusions_implemented, judgement).
key_type(awareness_and_training_programmes_developed, judgement).
key_type(simplified_framework_documented_and_reviewed, judgement).
key_type(simplified_framework_continuously_improved, judgement).
key_type(simplified_framework_review_report_submitted, fact).

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

in_type_t(entity_type, Value, T) :-
    in_type_t(enum([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]), Value, T).
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

test(contract_key_order_has_seventeen_keys) :-
    contract_key_order(Keys),
    length(Keys, 17).
test(an_empty_profile_has_no_problem) :-
    dora_proportionality_and_simplified_framework_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, investment_firm), attribute(iorp_pension_scheme_members_total, 15)], []).
test(a_float_member_count_is_wrong_type) :-
    FloatMembers is float(15),
    dora_proportionality_and_simplified_framework_input_problems([attribute(iorp_pension_scheme_members_total, FloatMembers)], [wrong_type(iorp_pension_scheme_members_total)]).
test(unsure_is_wrong_type_for_a_crisp_key) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(authority_requested_framework_review_report, unsure)], [wrong_type(authority_requested_framework_review_report)]).
test(unsure_is_in_type_for_a_judgement_key) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(ict_systems_continuously_monitored, unsure)], []).
test(a_repeated_key_is_a_duplicate_only) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, bogus), attribute(dora_entity_type, investment_firm)], [duplicate_key(dora_entity_type)]).
test(an_unknown_key_comes_after_contract_problems) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(stray, 1), attribute(dora_entity_type, bogus), attribute(stray, 2)], [wrong_type(dora_entity_type), unknown_key(stray)]).
test(a_non_list_profile_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems(not_a_list, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems(_, [wrong_type(profile)]).
test(the_input_check_has_one_answer) :-
    findall(Problems, dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, investment_firm)], Problems), Answers),
    Answers == [[]].
