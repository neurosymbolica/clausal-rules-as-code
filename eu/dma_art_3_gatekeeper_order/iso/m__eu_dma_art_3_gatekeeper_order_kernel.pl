% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2, dma_art_3_gatekeeper_order_contract_key/2, dma_art_3_gatekeeper_order_outside_fact/3, dma_art_3_gatekeeper_order_merge_citations/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

dma_art_3_gatekeeper_order_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [market_capitalisation_eur_most_recent_financial_year, member_states_where_core_platform_service_provided, union_turnover_eur_most_recent_financial_year, union_turnover_eur_second_most_recent_financial_year, union_turnover_eur_third_most_recent_financial_year, monthly_active_end_users_most_recent_financial_year, monthly_active_end_users_second_most_recent_financial_year, monthly_active_end_users_third_most_recent_financial_year, yearly_active_business_users_most_recent_financial_year, yearly_active_business_users_second_most_recent_financial_year, yearly_active_business_users_third_most_recent_financial_year, rebuttal_arguments_presented, rebuttal_accepted_by_commission, significant_impact_on_internal_market, core_platform_service_is_important_gateway, entrenched_and_durable_position, designated_as_gatekeeper_for_core_platform_service],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(market_capitalisation_eur_most_recent_financial_year, non_negative_integer).
key_type(member_states_where_core_platform_service_provided, non_negative_integer).
key_type(union_turnover_eur_most_recent_financial_year, non_negative_integer).
key_type(union_turnover_eur_second_most_recent_financial_year, non_negative_integer).
key_type(union_turnover_eur_third_most_recent_financial_year, non_negative_integer).
key_type(monthly_active_end_users_most_recent_financial_year, non_negative_integer).
key_type(monthly_active_end_users_second_most_recent_financial_year, non_negative_integer).
key_type(monthly_active_end_users_third_most_recent_financial_year, non_negative_integer).
key_type(yearly_active_business_users_most_recent_financial_year, non_negative_integer).
key_type(yearly_active_business_users_second_most_recent_financial_year, non_negative_integer).
key_type(yearly_active_business_users_third_most_recent_financial_year, non_negative_integer).
key_type(rebuttal_arguments_presented, boolean).
key_type(rebuttal_accepted_by_commission, outside_fact).
key_type(significant_impact_on_internal_market, judgement).
key_type(core_platform_service_is_important_gateway, judgement).
key_type(entrenched_and_durable_position, judgement).
key_type(designated_as_gatekeeper_for_core_platform_service, outside_fact).

dma_art_3_gatekeeper_order_contract_key(Key, Type) :-
    key_type(Key, Type).

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

in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
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
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

attested_t(attested(AttestedValue, Attestation), Type, T) :-
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, Type, AttestedValue, T).
attested_t(Value, _, false) :-
    Value \= attested(_, _).

attestation_t(attestation(_, _, _, _), true).
attestation_t(Value, false) :-
    Value \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, Type, AttestedValue, T) :-
    in_type_t(Type, AttestedValue, T).

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

dma_art_3_gatekeeper_order_outside_fact(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
dma_art_3_gatekeeper_order_outside_fact(Profile, Key, attested_true(attested(true, Attestation))) :-
    profile_get(Profile, Key, attested(true, Attestation)).
dma_art_3_gatekeeper_order_outside_fact(Profile, Key, attested_false(attested(false, Attestation))) :-
    profile_get(Profile, Key, attested(false, Attestation)).

dma_art_3_gatekeeper_order_merge_citations(First, Second, Merged) :-
    append(First, Second, Combined),
    sort(Combined, Merged).

test(a_well_formed_profile_has_no_problem) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(member_states_where_core_platform_service_provided, 3), attribute(significant_impact_on_internal_market, unsure)], []).
test(a_fractional_figure_is_wrong_type) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(union_turnover_eur_most_recent_financial_year, 15/2)], [wrong_type(union_turnover_eur_most_recent_financial_year)]).
test(a_duplicate_key_is_named_once_and_never_wrong_type) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(rebuttal_arguments_presented, maybe), attribute(rebuttal_arguments_presented, true)], [duplicate_key(rebuttal_arguments_presented)]).
test(an_unknown_key_is_named_once) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_non_list_is_not_a_profile) :-
    dma_art_3_gatekeeper_order_input_problems(nothing, [wrong_type(profile)]).
test(a_three_argument_attestation_is_wrong_type) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host, today, reason)))], [wrong_type(designated_as_gatekeeper_for_core_platform_service)]).
test(an_absent_outside_fact_reads_absent) :-
    findall(State, dma_art_3_gatekeeper_order_outside_fact([], designated_as_gatekeeper_for_core_platform_service, State), States),
    States == [absent].
test(a_present_outside_fact_is_copied_exactly) :-
    findall(State, dma_art_3_gatekeeper_order_outside_fact([attribute(rebuttal_accepted_by_commission, attested(false, attestation(host, today, reason, none)))], rebuttal_accepted_by_commission, State), States),
    States == [attested_false(attested(false, attestation(host, today, reason, none)))].
test(citations_merge_each_once) :-
    dma_art_3_gatekeeper_order_merge_citations([cite(eu_reg_2022_1925_art_3_2_c), cite(eu_reg_2022_1925_art_3_2_b)], [cite(eu_reg_2022_1925_art_3_2_b)], Merged),
    length(Merged, 2).

test(an_attested_false_fact_is_not_attested_true, fail) :-
    dma_art_3_gatekeeper_order_outside_fact([attribute(rebuttal_accepted_by_commission, attested(false, attestation(host, today, reason, none)))], rebuttal_accepted_by_commission, attested_true(_)).
