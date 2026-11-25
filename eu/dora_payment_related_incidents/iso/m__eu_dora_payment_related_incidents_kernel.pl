% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2, dora_payment_related_incidents_contract_keys/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_payment_related_incidents_contract_keys([dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major, credit_institution_classified_as_significant, member_state_requires_reports_to_directive_2022_2555_authorities]).

dora_payment_related_incidents_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    dora_payment_related_incidents_contract_keys(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(dora_entity_type, entity_type).
key_type(incident_is_operational_or_security_payment_related, judgement).
key_type(payment_related_incident_is_major, judgement).
key_type(credit_institution_classified_as_significant, fact).
key_type(member_state_requires_reports_to_directive_2022_2555_authorities, fact).

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

test(a_well_formed_profile_has_no_problem) :-
    dora_payment_related_incidents_input_problems([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, unsure), attribute(credit_institution_classified_as_significant, true)], Problems),
    Problems == [].
test(an_empty_profile_has_no_problem) :-
    dora_payment_related_incidents_input_problems([], Problems),
    Problems == [].
test(a_repeated_key_is_one_duplicate_and_never_wrong_type) :-
    dora_payment_related_incidents_input_problems([attribute(dora_entity_type, seven), attribute(dora_entity_type, seven)], Problems),
    Problems == [duplicate_key(dora_entity_type)].
test(unsure_is_wrong_type_for_a_fact_key) :-
    dora_payment_related_incidents_input_problems([attribute(credit_institution_classified_as_significant, unsure)], Problems),
    Problems == [wrong_type(credit_institution_classified_as_significant)].
test(contract_key_problems_come_before_unknown_keys) :-
    dora_payment_related_incidents_input_problems([attribute(colour, 1), attribute(dora_entity_type, 3)], Problems),
    Problems == [wrong_type(dora_entity_type), unknown_key(colour)].
test(an_unbound_profile_is_wrong_type_profile) :-
    dora_payment_related_incidents_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_value_is_wrong_type) :-
    dora_payment_related_incidents_input_problems([attribute(payment_related_incident_is_major, _)], Problems),
    Problems == [wrong_type(payment_related_incident_is_major)].
test(the_input_check_has_one_answer) :-
    findall(Problems, dora_payment_related_incidents_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(the_contract_has_five_keys) :-
    dora_payment_related_incidents_contract_keys(Keys),
    length(Keys, 5).
