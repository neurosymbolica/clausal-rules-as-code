% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2, pipl_individual_rights_key_state/3, pipl_individual_rights_relied_pairs/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

pipl_individual_rights_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [pinned_text_in_force_on_reference_day, laws_or_regulations_provide_otherwise, article_18_1_case, article_35_case, cyberspace_department_transfer_conditions_met, verification_confirms_inaccurate_or_incomplete, purpose_achieved_impossible_or_unnecessary, service_stopped_or_retention_period_expired, consent_withdrawn, processing_violates_law_or_agreement, other_deletion_case_prescribed_by_law, legal_retention_period_unexpired, deletion_technically_difficult, person_deceased, requester_is_near_relative, for_requester_own_lawful_and_legitimate_interests, deceased_arranged_otherwise, convenient_mechanism_established, request_refused, refusal_reasons_given],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(pinned_text_in_force_on_reference_day, boolean).
key_type(laws_or_regulations_provide_otherwise, boolean).
key_type(article_18_1_case, boolean).
key_type(article_35_case, boolean).
key_type(cyberspace_department_transfer_conditions_met, boolean).
key_type(verification_confirms_inaccurate_or_incomplete, judgement).
key_type(purpose_achieved_impossible_or_unnecessary, judgement).
key_type(service_stopped_or_retention_period_expired, boolean).
key_type(consent_withdrawn, boolean).
key_type(processing_violates_law_or_agreement, judgement).
key_type(other_deletion_case_prescribed_by_law, boolean).
key_type(legal_retention_period_unexpired, boolean).
key_type(deletion_technically_difficult, judgement).
key_type(person_deceased, boolean).
key_type(requester_is_near_relative, boolean).
key_type(for_requester_own_lawful_and_legitimate_interests, judgement).
key_type(deceased_arranged_otherwise, boolean).
key_type(convenient_mechanism_established, judgement).
key_type(request_refused, boolean).
key_type(refusal_reasons_given, boolean).

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

pipl_individual_rights_key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
pipl_individual_rights_key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

pipl_individual_rights_relied_pairs(Profile, PairsKeys, Pairs) :-
    findall(Key - Value, (member(Key, PairsKeys), profile_get(Profile, Key, Value)), Pairs).

test(an_empty_profile_has_no_problem) :-
    pipl_individual_rights_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    pipl_individual_rights_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    pipl_individual_rights_input_problems([attribute(consent_withdrawn, true)|_], [wrong_type(profile)]).
test(a_duplicate_key_is_named_once_and_never_wrong_type) :-
    pipl_individual_rights_input_problems([attribute(consent_withdrawn, true), attribute(consent_withdrawn, maybe)], [duplicate_key(consent_withdrawn)]).
test(a_crisp_key_given_unsure_is_wrong_type_and_an_unknown_key_follows) :-
    pipl_individual_rights_input_problems([attribute(colour, red), attribute(article_35_case, unsure)], [wrong_type(article_35_case), unknown_key(colour)]).
test(a_judgement_key_given_unsure_is_well_formed) :-
    pipl_individual_rights_input_problems([attribute(convenient_mechanism_established, unsure)], []).
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(person_deceased, true)], Problems), Answers),
    Answers == [[]].
test(an_absent_key_has_state_absent) :-
    findall(State, pipl_individual_rights_key_state([attribute(person_deceased, true)], request_refused, State), States),
    States == [absent].
test(a_present_key_has_its_value_as_state) :-
    findall(State, pipl_individual_rights_key_state([attribute(person_deceased, true)], person_deceased, State), States),
    States == [true].
test(relied_pairs_keep_the_present_keys_in_list_order) :-
    pipl_individual_rights_relied_pairs([attribute(deletion_technically_difficult, false), attribute(purpose_achieved_impossible_or_unnecessary, unsure)], [purpose_achieved_impossible_or_unnecessary, processing_violates_law_or_agreement, deletion_technically_difficult], Pairs),
    Pairs == [purpose_achieved_impossible_or_unnecessary - unsure, deletion_technically_difficult - false].

test(a_present_key_is_not_absent, fail) :-
    pipl_individual_rights_key_state([attribute(person_deceased, true)], person_deceased, absent).
