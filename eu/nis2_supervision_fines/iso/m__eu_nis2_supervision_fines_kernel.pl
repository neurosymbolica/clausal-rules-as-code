% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_relied_pairs/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

nis2_supervision_fines_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [entity_class, infringed_provision, worldwide_annual_turnover_eur, entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline, infringement_may_entail_notifiable_personal_data_breach, authority_became_aware_in_supervision_or_enforcement, data_protection_authority_in_other_member_state, gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(entity_class, enum([essential, important])).
key_type(infringed_provision, enum([art_21, art_23, other])).
key_type(worldwide_annual_turnover_eur, non_negative_integer).
key_type(entity_is_public_administration, boolean).
key_type(earlier_measures_ineffective, judgement).
key_type(deadline_set_for_necessary_action, boolean).
key_type(required_action_taken_within_deadline, boolean).
key_type(infringement_may_entail_notifiable_personal_data_breach, judgement).
key_type(authority_became_aware_in_supervision_or_enforcement, boolean).
key_type(data_protection_authority_in_other_member_state, boolean).
key_type(gdpr_fine_imposed_under_art_58_2_i, boolean).
key_type(gdpr_fine_for_same_conduct, judgement).

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

nis2_supervision_fines_relied_pairs(_, [], []).
nis2_supervision_fines_relied_pairs(Profile, [Key|Keys], [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    nis2_supervision_fines_relied_pairs(Profile, Keys, Pairs).
nis2_supervision_fines_relied_pairs(Profile, [Key|Keys], Pairs) :-
    profile_lacks(Profile, Key),
    nis2_supervision_fines_relied_pairs(Profile, Keys, Pairs).

test(a_well_formed_profile_has_no_problem) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, essential), attribute(earlier_measures_ineffective, unsure)], []).
test(the_empty_profile_has_no_problem) :-
    nis2_supervision_fines_input_problems([], []).
test(a_repeated_key_is_a_duplicate_only) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, essential), attribute(entity_class, wrong)], [duplicate_key(entity_class)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(entity_is_public_administration, unsure)], [wrong_type(entity_is_public_administration)]).
test(a_negative_turnover_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(worldwide_annual_turnover_eur, -1)], [wrong_type(worldwide_annual_turnover_eur)]).
test(an_unknown_key_is_named_once) :-
    nis2_supervision_fines_input_problems([attribute(foo, 1), attribute(foo, 2)], [unknown_key(foo)]).
test(contract_problems_come_before_unknown_keys) :-
    nis2_supervision_fines_input_problems([attribute(foo, 1), attribute(gdpr_fine_for_same_conduct, maybe), attribute(entity_class, big)], [wrong_type(entity_class), wrong_type(gdpr_fine_for_same_conduct), unknown_key(foo)]).
test(a_non_list_is_not_a_profile) :-
    nis2_supervision_fines_input_problems(not_a_list, [wrong_type(profile)]).
test(a_list_with_a_bare_atom_is_not_a_profile) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, essential), stray], [wrong_type(profile)]).
test(pairs_follow_the_given_key_order) :-
    nis2_supervision_fines_relied_pairs([attribute(gdpr_fine_for_same_conduct, unsure), attribute(infringement_may_entail_notifiable_personal_data_breach, true)], [infringement_may_entail_notifiable_personal_data_breach, gdpr_fine_for_same_conduct], [infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure]).
test(pairs_skip_an_absent_key) :-
    nis2_supervision_fines_relied_pairs([attribute(earlier_measures_ineffective, unsure)], [infringement_may_entail_notifiable_personal_data_breach, earlier_measures_ineffective], [earlier_measures_ineffective - unsure]).
