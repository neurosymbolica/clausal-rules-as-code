% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2, duty_argument_problems/2, outside_fact_reference/3, absent_referral/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_chapter_v_extras_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [transfer_relies_on_article_49_1_second_subparagraph, party_role, supervisory_authority_informed_of_transfer, data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests, assessment_documented_in_records, suitable_safeguards_documented_in_records, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(transfer_relies_on_article_49_1_second_subparagraph, outside_fact).
key_type(party_role, party_role_atom).
key_type(supervisory_authority_informed_of_transfer, boolean).
key_type(data_subject_informed_of_transfer, boolean).
key_type(data_subject_informed_of_compelling_legitimate_interests, boolean).
key_type(assessment_documented_in_records, boolean).
key_type(suitable_safeguards_documented_in_records, boolean).
key_type(third_country_judgment_or_decision_requires_transfer, outside_fact).
key_type(international_agreement_basis_for_judgment_or_decision, outside_fact).
key_type(transfer_is_onward_transfer, outside_fact).
key_type(onward_transfer_has_chapter_v_basis, outside_fact).

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

in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(party_role_atom, Value, T) :-
    in_type_t(enum([controller, processor]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

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

duty_argument_problems(Duty, [wrong_type(duty)]) :-
    var(Duty).
duty_argument_problems(Duty, Problems) :-
    nonvar(Duty),
    memberd_t(Duty, [inform_supervisory_authority, inform_data_subject, document_assessment_and_safeguards], IsDuty),
    duty_problems(IsDuty, Problems).

duty_problems(true, []).
duty_problems(false, [wrong_type(duty)]).

outside_fact_reference(transfer_relies_on_article_49_1_second_subparagraph, cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)).
outside_fact_reference(third_country_judgment_or_decision_requires_transfer, cite(eu_reg_2016_679_art_48), cite(foreign_judgment_requires_transfer_statement)).
outside_fact_reference(international_agreement_basis_for_judgment_or_decision, cite(eu_reg_2016_679_art_48), cite(international_agreement_basis_statement)).
outside_fact_reference(transfer_is_onward_transfer, cite(eu_reg_2016_679_art_44), cite(onward_transfer_statement)).
outside_fact_reference(onward_transfer_has_chapter_v_basis, cite(eu_reg_2016_679_art_44), cite(onward_transfer_chapter_v_basis_statement)).

absent_referral(Key, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])])) :-
    outside_fact_reference(Key, Citation, Target).

test(an_empty_profile_has_no_problem) :-
    gdpr_chapter_v_extras_input_problems([], []).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_chapter_v_extras_input_problems([attribute(transfer_is_onward_transfer, true)], [wrong_type(transfer_is_onward_transfer)]).
test(a_known_duty_has_no_problem) :-
    duty_argument_problems(inform_data_subject, []).
test(an_unbound_duty_is_wrong_type) :-
    findall(Problems, duty_argument_problems(_, Problems), All),
    All == [[wrong_type(duty)]].
test(an_unknown_duty_is_wrong_type) :-
    duty_argument_problems(inform_everyone, [wrong_type(duty)]).
test(the_referral_on_the_onward_transfer_statement) :-
    findall(Result, absent_referral(transfer_is_onward_transfer, Result), All),
    All == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_44), cite(onward_transfer_statement)), [resolution(cite(onward_transfer_statement), not_attempted), inputs_relied_on([transfer_is_onward_transfer - absent])])].

test(an_unknown_duty_has_problems, fail) :-
    duty_argument_problems(inform_everyone, []).
test(a_crisp_key_has_no_referral, fail) :-
    absent_referral(party_role, _).
