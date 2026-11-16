% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

sme_definition_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [is_enterprise, public_bodies_control_25_percent_or_more, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held, majority_of_voting_rights, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, majority_of_voting_rights_by_shareholder_agreement, relationship_only_through_natural_persons, same_or_adjacent_market, holding_basis_points, investor_category, investor_involved_in_management, business_angels_total_investment_cents, local_authority_annual_budget_cents, local_authority_inhabitants],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(is_enterprise, judgement).
key_type(public_bodies_control_25_percent_or_more, boolean).
key_type(accounting_basis, accounting_basis).
key_type(own_staff_annual_work_units_hundredths, non_negative_integer).
key_type(own_annual_turnover_cents, non_negative_integer).
key_type(own_annual_balance_sheet_total_cents, non_negative_integer).
key_type(partner_enterprises, partner_enterprise_list).
key_type(linked_enterprises, linked_enterprise_list).
key_type(previous_period_size_class, previous_period_size_class).
key_type(size_class_held, size_class).
key_type(majority_of_voting_rights, boolean).
key_type(right_to_appoint_or_remove_majority_of_board, boolean).
key_type(dominant_influence_by_contract_or_articles, judgement).
key_type(majority_of_voting_rights_by_shareholder_agreement, boolean).
key_type(relationship_only_through_natural_persons, boolean).
key_type(same_or_adjacent_market, judgement).
key_type(holding_basis_points, non_negative_integer).
key_type(investor_category, investor_category).
key_type(investor_involved_in_management, boolean).
key_type(business_angels_total_investment_cents, non_negative_integer).
key_type(local_authority_annual_budget_cents, non_negative_integer).
key_type(local_authority_inhabitants, non_negative_integer).

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
in_type_t(accounting_basis, Value, T) :-
    in_type_t(enum([approved_accounts, bona_fide_estimate]), Value, T).
in_type_t(partner_enterprise_list, Value, T) :-
    in_type_t(list(partner_enterprise_item), Value, T).
in_type_t(linked_enterprise_list, Value, T) :-
    in_type_t(list(linked_enterprise_item), Value, T).
in_type_t(previous_period_size_class, Value, T) :-
    in_type_t(enum([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, no_previous_period]), Value, T).
in_type_t(size_class, Value, T) :-
    in_type_t(enum([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise]), Value, T).
in_type_t(investor_category, Value, T) :-
    in_type_t(enum([not_a_listed_investor, public_investment_corporation_or_venture_capital_company, business_angel, university_or_non_profit_research_centre, institutional_investor, autonomous_local_authority]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(list(Type), Value, T) :-
    list_in_type_t(Value, Type, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).
in_type_t(partner_enterprise_item, Value, T) :-
    partner_enterprise_item_t(Value, T).
in_type_t(linked_enterprise_item, Value, T) :-
    linked_enterprise_item_t(Value, T).

partner_enterprise_item_t(Value, T) :-
    Value = partner_enterprise_data(Share, Staff, Turnover, Balance),
    all_item_arguments_t([Share, Staff, Turnover, Balance], T).
partner_enterprise_item_t(Value, false) :-
    Value \= partner_enterprise_data(_, _, _, _).

linked_enterprise_item_t(Value, T) :-
    Value = linked_enterprise_data(Staff, Turnover, Balance),
    all_item_arguments_t([Staff, Turnover, Balance], T).
linked_enterprise_item_t(Value, false) :-
    Value \= linked_enterprise_data(_, _, _).

all_item_arguments_t([], true).
all_item_arguments_t([Value|Values], T) :-
    item_argument_t(Value, ValueInType),
    all_item_arguments_t(Values, ValuesInType),
    truth_and(ValueInType, ValuesInType, T).

item_argument_t(Value, true) :-
    atom(Value).
item_argument_t(Value, T) :-
    number(Value),
    non_negative_integer_t(Value, T).
item_argument_t(Value, false) :-
    compound(Value).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

list_in_type_t(Value, _, true) :-
    Value == [].
list_in_type_t([Element|Elements], Type, T) :-
    in_type_t(Type, Element, ElementInType),
    list_in_type_t(Elements, Type, ElementsInType),
    truth_and(ElementInType, ElementsInType, T).
list_in_type_t(Value, _, false) :-
    Value \== [],
    Value \= [_|_].

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

test(an_empty_profile_has_no_problem) :-
    sme_definition_input_problems([], []).
test(a_well_formed_partner_list_has_no_problem) :-
    sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(2500, 100, 1000, 1000)])], []).
test(a_partner_item_of_two_arguments_is_wrong_type) :-
    sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(2500, 100)])], [wrong_type(partner_enterprises)]).
test(a_well_formed_linked_list_has_no_problem) :-
    sme_definition_input_problems([attribute(linked_enterprises, [linked_enterprise_data(0, 0, 0)])], []).
test(a_linked_item_with_named_arguments_has_no_problem) :-
    sme_definition_input_problems([attribute(linked_enterprises, [linked_enterprise_data(staff, turnover, balance)])], []).
test(a_partner_item_with_named_arguments_has_no_problem) :-
    sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(share, staff, turnover, balance)])], []).
test(a_negative_linked_figure_is_wrong_type) :-
    sme_definition_input_problems([attribute(linked_enterprises, [linked_enterprise_data(0, -1, 0)])], [wrong_type(linked_enterprises)]).
test(a_duplicate_key_is_named_once) :-
    sme_definition_input_problems([attribute(is_enterprise, true), attribute(is_enterprise, maybe)], [duplicate_key(is_enterprise)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    sme_definition_input_problems(_, [wrong_type(profile)]).
test(an_unknown_key_is_named) :-
    sme_definition_input_problems([attribute(colour, red)], [unknown_key(colour)]).

test(a_partner_item_of_two_arguments_is_not_accepted, fail) :-
    sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(2500, 100)])], []).
