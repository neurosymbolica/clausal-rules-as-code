% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_procedural_regulation_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [complaint_lodged_by, lodging_person_name_and_contact_details_included, proof_of_proper_constitution_included, proof_of_data_subject_mandate_included, controller_or_processor_identification_information_included, alleged_infringement_description_included, complaint_concerns_right_exercised_by_request, request_made_to_controller_before_complaint, complaint_concerns_chapter_iii_rights, end_of_infringement_established_on_supporting_evidence, complainant_objected_to_early_resolution_in_time, early_resolution_procedure_before, case_handled_under_article_56_2, lead_authority_considers_no_reasonable_doubt_as_to_scope, issues_addressable_without_additional_cooperation, concerned_authority_objected_to_simple_procedure_in_time, simple_cooperation_procedure_applied, draft_decision_time_limit_extended, board_request_under_article_11_6_made, extension_justified_by_exceptional_complexity, national_law_requires_domestic_proceedings_after_time_limit, time_limit_set_by_this_regulation_or_article_65_6],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(complaint_lodged_by, complaint_lodged_by_atom).
key_type(lodging_person_name_and_contact_details_included, boolean).
key_type(proof_of_proper_constitution_included, boolean).
key_type(proof_of_data_subject_mandate_included, boolean).
key_type(controller_or_processor_identification_information_included, boolean).
key_type(alleged_infringement_description_included, boolean).
key_type(complaint_concerns_right_exercised_by_request, judgement).
key_type(request_made_to_controller_before_complaint, boolean).
key_type(complaint_concerns_chapter_iii_rights, boolean).
key_type(end_of_infringement_established_on_supporting_evidence, boolean).
key_type(complainant_objected_to_early_resolution_in_time, boolean).
key_type(early_resolution_procedure_before, early_resolution_procedure_before_atom).
key_type(case_handled_under_article_56_2, outside_fact).
key_type(lead_authority_considers_no_reasonable_doubt_as_to_scope, boolean).
key_type(issues_addressable_without_additional_cooperation, judgement).
key_type(concerned_authority_objected_to_simple_procedure_in_time, boolean).
key_type(simple_cooperation_procedure_applied, boolean).
key_type(draft_decision_time_limit_extended, boolean).
key_type(board_request_under_article_11_6_made, boolean).
key_type(extension_justified_by_exceptional_complexity, judgement).
key_type(national_law_requires_domestic_proceedings_after_time_limit, outside_fact).
key_type(time_limit_set_by_this_regulation_or_article_65_6, outside_fact).

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

in_type_t(complaint_lodged_by_atom, Value, T) :-
    in_type_t(enum([data_subject, article_80_1_body, article_80_2_body]), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(early_resolution_procedure_before_atom, Value, T) :-
    in_type_t(enum([receiving_authority, lead_authority]), Value, T).
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
