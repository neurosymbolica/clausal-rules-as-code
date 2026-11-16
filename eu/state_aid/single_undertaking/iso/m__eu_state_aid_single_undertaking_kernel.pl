% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

single_undertaking_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [holder_is_an_enterprise, held_is_an_enterprise, voting_rights_held, voting_rights_total, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, holder_is_shareholder_or_member, controls_majority_of_voting_rights_alone_by_agreement, first_enterprise, second_enterprise, relationships, relationships_complete],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(holder_is_an_enterprise, judgement).
key_type(held_is_an_enterprise, judgement).
key_type(voting_rights_held, non_negative_integer).
key_type(voting_rights_total, non_negative_integer).
key_type(right_to_appoint_or_remove_majority_of_board, boolean).
key_type(dominant_influence_by_contract_or_articles, judgement).
key_type(holder_is_shareholder_or_member, boolean).
key_type(controls_majority_of_voting_rights_alone_by_agreement, boolean).
key_type(first_enterprise, atom).
key_type(second_enterprise, atom).
key_type(relationships, relationship_list).
key_type(relationships_complete, boolean).

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
    key_known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

key_known_t(_, [], false).
key_known_t(Key, [KnownKey|_], true) :-
    KnownKey == Key.
key_known_t(Key, [KnownKey|KnownKeys], T) :-
    KnownKey \== Key,
    key_known_t(Key, KnownKeys, T).

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
    added_check_t(InType, Key, Profile, PassesChecks),
    name_wrong_type(PassesChecks, Key, KeyProblems, Problems).

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

added_check_t(false, _, _, false).
added_check_t(true, Key, Profile, T) :-
    added_key_check_t(Key, Profile, T).

added_key_check_t(voting_rights_total, Profile, T) :-
    key_value(Profile, voting_rights_total, TotalVotingRights),
    at_least_one_t(TotalVotingRights, T).
added_key_check_t(voting_rights_held, Profile, T) :-
    key_value(Profile, voting_rights_held, HeldVotingRights),
    total_voting_rights_standing(Profile, TotalStanding),
    held_within_total_t(TotalStanding, HeldVotingRights, T).
added_key_check_t(Key, _, true) :-
    dif(Key, voting_rights_total),
    dif(Key, voting_rights_held).

key_value([attribute(ElementKey, Value)|_], Key, Value) :-
    ElementKey == Key.
key_value([attribute(ElementKey, _)|Elements], Key, Value) :-
    ElementKey \== Key,
    key_value(Elements, Key, Value).

at_least_one_t(Count, true) :-
    Count >= 1.
at_least_one_t(Count, false) :-
    Count < 1.

total_voting_rights_standing(Profile, Standing) :-
    key_occurrences(Profile, voting_rights_total, Occurrences),
    total_standing_from_occurrences(Occurrences, Profile, Standing).

total_standing_from_occurrences(none, _, not_usable).
total_standing_from_occurrences(many, _, not_usable).
total_standing_from_occurrences(one, Profile, Standing) :-
    key_value(Profile, voting_rights_total, TotalVotingRights),
    value_in_type_t(non_negative_integer, TotalVotingRights, InType),
    total_standing_from_value(InType, TotalVotingRights, Standing).

total_standing_from_value(false, _, not_usable).
total_standing_from_value(true, TotalVotingRights, usable(TotalVotingRights)) :-
    TotalVotingRights >= 1.
total_standing_from_value(true, TotalVotingRights, not_usable) :-
    TotalVotingRights < 1.

held_within_total_t(not_usable, _, true).
held_within_total_t(usable(TotalVotingRights), HeldVotingRights, true) :-
    HeldVotingRights =< TotalVotingRights.
held_within_total_t(usable(TotalVotingRights), HeldVotingRights, false) :-
    HeldVotingRights > TotalVotingRights.

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(relationship_list, Value, T) :-
    in_type_t(list(relationship), Value, T).
in_type_t(relationship, Value, T) :-
    relationship_t(Value, T).
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
in_type_t(atom, Value, T) :-
    atom_t(Value, T).

relationship_t(Value, T) :-
    Value = relationship(Holder, Held, Limb, Certainty),
    atom_t(Holder, HolderIsAtom),
    atom_t(Held, HeldIsAtom),
    memberd_t(Limb, [point_a, point_b, point_c, point_d], LimbIsKnown),
    memberd_t(Certainty, [true, unsure], CertaintyIsKnown),
    truth_and(HolderIsAtom, HeldIsAtom, EnterprisesAreAtoms),
    truth_and(LimbIsKnown, CertaintyIsKnown, LabelsAreKnown),
    truth_and(EnterprisesAreAtoms, LabelsAreKnown, T).
relationship_t(Value, false) :-
    Value \= relationship(_, _, _, _).

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

atom_t(Value, true) :-
    atom(Value),
    Value \== [].
atom_t(Value, false) :-
    Value == [].
atom_t(Value, false) :-
    integer(Value).
atom_t(Value, false) :-
    float(Value).
atom_t(Value, false) :-
    compound(Value).

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
    single_undertaking_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    single_undertaking_input_problems([attribute(holder_is_an_enterprise, unsure), attribute(voting_rights_held, 51), attribute(voting_rights_total, 100), attribute(first_enterprise, alpha), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(beta, gamma, point_c, unsure)]), attribute(relationships_complete, false)], Problems),
    Problems == [].
test(an_unbound_profile_is_not_an_attribute_list) :-
    single_undertaking_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    single_undertaking_input_problems([attribute(first_enterprise, alpha)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_makes_the_profile_wrong_alone) :-
    single_undertaking_input_problems([attribute(first_enterprise, 7), stray], Problems),
    Problems == [wrong_type(profile)].
test(a_total_of_zero_is_wrong_type) :-
    single_undertaking_input_problems([attribute(voting_rights_held, 0), attribute(voting_rights_total, 0)], Problems),
    Problems == [wrong_type(voting_rights_total)].
test(held_above_total_is_wrong_type) :-
    single_undertaking_input_problems([attribute(voting_rights_held, 5), attribute(voting_rights_total, 3)], Problems),
    Problems == [wrong_type(voting_rights_held)].
test(held_equal_to_total_is_well_formed) :-
    single_undertaking_input_problems([attribute(voting_rights_held, 3), attribute(voting_rights_total, 3)], Problems),
    Problems == [].
test(a_relationship_with_an_unknown_limb_is_wrong_type) :-
    single_undertaking_input_problems([attribute(relationships, [relationship(alpha, beta, point_e, true)])], Problems),
    Problems == [wrong_type(relationships)].
test(a_relationship_list_with_an_unbound_tail_is_wrong_type) :-
    single_undertaking_input_problems([attribute(relationships, [relationship(alpha, beta, point_a, true)|_])], Problems),
    Problems == [wrong_type(relationships)].
test(a_repeated_key_is_a_duplicate_only) :-
    single_undertaking_input_problems([attribute(first_enterprise, alpha), attribute(first_enterprise, 9)], Problems),
    Problems == [duplicate_key(first_enterprise)].
test(an_unbound_key_is_unknown_as_given) :-
    single_undertaking_input_problems([attribute(Key, alpha)], Problems),
    Problems == [unknown_key(Key)].
test(contract_problems_come_before_unknown_keys) :-
    single_undertaking_input_problems([attribute(colour, red), attribute(colour, blue), attribute(held_is_an_enterprise, maybe)], Problems),
    Problems == [wrong_type(held_is_an_enterprise), unknown_key(colour)].
test(an_unbound_value_is_wrong_type) :-
    single_undertaking_input_problems([attribute(relationships_complete, _)], Problems),
    Problems == [wrong_type(relationships_complete)].
test(the_check_has_one_answer) :-
    findall(Problems, single_undertaking_input_problems([attribute(voting_rights_held, 2)], Problems), Answers),
    Answers == [[]].
