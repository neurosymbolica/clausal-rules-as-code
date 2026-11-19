% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

swiss_fadp_s3_right_of_access_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [request_form, controller_agreed_to_oral_request, controller_category, formal_law_provides_for_restriction, restriction_required_by_overriding_third_party_interests, request_manifestly_unfounded_or_querulous, restriction_required_by_overriding_controller_interests, controller_discloses_the_personal_data_to_third_parties, restriction_required_by_overriding_public_interests, information_could_endanger_investigation_or_proceedings, processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, data_reveal_information_sources, access_would_give_insight_into_drafts_for_publications, publication_would_endanger_free_formation_of_public_opinion, data_serve_media_professional_exclusively_as_personal_working_instrument, access_involves_disproportionate_effort],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(request_form, request_form_type).
key_type(controller_agreed_to_oral_request, boolean).
key_type(controller_category, controller_category_type).
key_type(formal_law_provides_for_restriction, judgement).
key_type(restriction_required_by_overriding_third_party_interests, judgement).
key_type(request_manifestly_unfounded_or_querulous, judgement).
key_type(restriction_required_by_overriding_controller_interests, judgement).
key_type(controller_discloses_the_personal_data_to_third_parties, boolean).
key_type(restriction_required_by_overriding_public_interests, judgement).
key_type(information_could_endanger_investigation_or_proceedings, judgement).
key_type(processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, judgement).
key_type(data_reveal_information_sources, judgement).
key_type(access_would_give_insight_into_drafts_for_publications, judgement).
key_type(publication_would_endanger_free_formation_of_public_opinion, judgement).
key_type(data_serve_media_professional_exclusively_as_personal_working_instrument, judgement).
key_type(access_involves_disproportionate_effort, judgement).

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

in_type_t(request_form_type, Value, T) :-
    in_type_t(enum([written, electronic, oral]), Value, T).
in_type_t(controller_category_type, Value, T) :-
    in_type_t(enum([private_person, federal_body]), Value, T).
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
