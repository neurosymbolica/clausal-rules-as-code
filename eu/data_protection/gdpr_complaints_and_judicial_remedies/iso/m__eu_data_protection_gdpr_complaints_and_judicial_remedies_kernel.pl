% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [is_data_subject, data_subject_considers_processing_infringes_regulation, decision_is_legally_binding, decision_concerns_the_caller, complaint_lodged_under_article_77, authority_competent_under_articles_55_and_56, authority_handled_the_complaint, three_months_from_the_complaint_have_passed, authority_informed_on_progress_or_outcome, data_subject_considers_rights_infringed_by_processing, defendant_is_member_state_public_authority_acting_in_public_powers],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(is_data_subject, boolean).
key_type(data_subject_considers_processing_infringes_regulation, boolean).
key_type(decision_is_legally_binding, judgement).
key_type(decision_concerns_the_caller, judgement).
key_type(complaint_lodged_under_article_77, boolean).
key_type(authority_competent_under_articles_55_and_56, outside_fact).
key_type(authority_handled_the_complaint, boolean).
key_type(three_months_from_the_complaint_have_passed, boolean).
key_type(authority_informed_on_progress_or_outcome, boolean).
key_type(data_subject_considers_rights_infringed_by_processing, boolean).
key_type(defendant_is_member_state_public_authority_acting_in_public_powers, boolean).

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
    gdpr_complaints_and_judicial_remedies_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true), attribute(decision_is_legally_binding, unsure), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none)))], Problems),
    Problems == [].
test(duplicate_wrong_type_and_unknown_in_order) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true), attribute(colour, red), attribute(is_data_subject, false), attribute(decision_concerns_the_caller, maybe), attribute(colour, blue)], Problems),
    Problems == [duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, unsure)], Problems),
    Problems == [wrong_type(is_data_subject)].
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(_, at, reason, none)))], Problems),
    Problems == [wrong_type(authority_competent_under_articles_55_and_56)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    gdpr_complaints_and_judicial_remedies_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_non_attribute_element_is_not_an_attribute_list) :-
    gdpr_complaints_and_judicial_remedies_input_problems([is_data_subject - true], Problems),
    Problems == [wrong_type(profile)].

test(a_well_formed_profile_is_not_refused, fail) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true)], [_|_]).
