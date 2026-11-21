% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [terms_and_conditions_include_information_on_restrictions_on_recipient_information, terms_and_conditions_include_information_on_content_moderation, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, provider_has_internal_complaint_handling_system, terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, terms_and_conditions_changed, change_to_terms_and_conditions_is_significant, recipients_informed_of_change_to_terms_and_conditions, service_primarily_directed_at_minors, service_predominantly_used_by_minors, conditions_and_restrictions_explained_in_way_minors_can_understand, provider_applies_or_enforces_restriction, restriction_applied_in_diligent_objective_and_proportionate_manner, restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, concise_clear_machine_readable_summary_of_terms_and_conditions_provided, terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, designated_as_very_large_online_platform_or_search_engine],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(terms_and_conditions_include_information_on_restrictions_on_recipient_information, judgement).
key_type(terms_and_conditions_include_information_on_content_moderation, judgement).
key_type(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, judgement).
key_type(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, judgement).
key_type(provider_has_internal_complaint_handling_system, boolean).
key_type(terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, judgement).
key_type(terms_and_conditions_changed, boolean).
key_type(change_to_terms_and_conditions_is_significant, judgement).
key_type(recipients_informed_of_change_to_terms_and_conditions, boolean).
key_type(service_primarily_directed_at_minors, judgement).
key_type(service_predominantly_used_by_minors, judgement).
key_type(conditions_and_restrictions_explained_in_way_minors_can_understand, judgement).
key_type(provider_applies_or_enforces_restriction, boolean).
key_type(restriction_applied_in_diligent_objective_and_proportionate_manner, judgement).
key_type(restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, judgement).
key_type(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, judgement).
key_type(terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, boolean).
key_type(designated_as_very_large_online_platform_or_search_engine, outside_fact).

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
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
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

test(an_empty_profile_has_no_problem) :-
    dsa_art_14_terms_and_conditions_order_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, true), attribute(change_to_terms_and_conditions_is_significant, unsure), attribute(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host, at_time, commission_decision, none)))], Problems),
    Problems == [].
test(an_unbound_profile_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_non_attribute_element_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, true), other], Problems),
    Problems == [wrong_type(profile)].
test(a_duplicate_comes_before_an_unknown_key) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, true), attribute(stray_key, value), attribute(terms_and_conditions_changed, unsure)], Problems),
    Problems == [duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(provider_applies_or_enforces_restriction, unsure)], Problems),
    Problems == [wrong_type(provider_applies_or_enforces_restriction)].
test(an_attestation_with_an_unbound_argument_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host, at_time, _, none)))], Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform_or_search_engine)].
test(a_plain_boolean_designation_is_wrong_type) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(designated_as_very_large_online_platform_or_search_engine, true)], Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform_or_search_engine)].
test(an_unbound_key_is_named_as_given) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Named)],
    Named == Key.
test(the_check_has_exactly_one_answer) :-
    findall(Problems, dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, true), attribute(terms_and_conditions_changed, false)], Problems), Answers),
    length(Answers, 1).
