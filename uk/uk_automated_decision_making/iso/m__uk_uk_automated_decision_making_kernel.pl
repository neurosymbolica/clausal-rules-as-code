% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

uk_automated_decision_making_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [decision_based_entirely_or_partly_on_personal_data, meaningful_human_involvement_in_the_decision, decision_produces_a_legal_effect_for_the_data_subject, decision_has_a_similarly_significant_effect_for_the_data_subject, processing_for_the_decision_relies_on_article_6_1_ea, decision_based_entirely_or_partly_on_special_category_data, decision_based_entirely_on_processing_with_explicit_consent, uk_article_9_2_g_applies, decision_necessary_for_a_contract_with_the_data_subject, decision_required_or_authorised_by_law, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures, decision_based_on_explicit_consent, article_9_2_a_applies, eu_article_9_2_g_applies, suitable_measures_for_special_category_data_in_place, safeguards_provide_information_about_decisions, safeguards_enable_representations, safeguards_enable_human_intervention, safeguards_enable_contesting],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(decision_based_entirely_or_partly_on_personal_data, boolean).
key_type(meaningful_human_involvement_in_the_decision, judgement).
key_type(decision_produces_a_legal_effect_for_the_data_subject, judgement).
key_type(decision_has_a_similarly_significant_effect_for_the_data_subject, judgement).
key_type(processing_for_the_decision_relies_on_article_6_1_ea, boolean).
key_type(decision_based_entirely_or_partly_on_special_category_data, boolean).
key_type(decision_based_entirely_on_processing_with_explicit_consent, judgement).
key_type(uk_article_9_2_g_applies, judgement).
key_type(decision_necessary_for_a_contract_with_the_data_subject, judgement).
key_type(decision_required_or_authorised_by_law, judgement).
key_type(decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures, judgement).
key_type(decision_based_on_explicit_consent, judgement).
key_type(article_9_2_a_applies, judgement).
key_type(eu_article_9_2_g_applies, judgement).
key_type(suitable_measures_for_special_category_data_in_place, judgement).
key_type(safeguards_provide_information_about_decisions, judgement).
key_type(safeguards_enable_representations, judgement).
key_type(safeguards_enable_human_intervention, judgement).
key_type(safeguards_enable_contesting, judgement).

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
