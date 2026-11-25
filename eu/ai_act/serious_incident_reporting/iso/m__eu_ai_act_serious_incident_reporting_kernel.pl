% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

serious_incident_reporting_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately, system_under_the_exclusive_competence_of_the_ai_office],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(high_risk_classification, enum([annex_iii_high_risk, annex_i_high_risk, not_high_risk])).
key_type(placed_before_chapter_iii_application_date, boolean).
key_type(significant_change_in_design_since_that_date, judgement).
key_type(intended_to_be_used_by_public_authorities, judgement).
key_type(medical_device_or_safety_component_of_one, boolean).
key_type(provider_subject_to_equivalent_union_reporting_obligations, judgement).
key_type(harm_to_health, enum([death_of_a_person, serious_harm_to_health_without_death, no_death_or_serious_harm_to_health])).
key_type(critical_infrastructure_disruption, boolean).
key_type(fundamental_rights_obligations_infringed, boolean).
key_type(serious_harm_to_property_or_environment, boolean).
key_type(widespread_infringement, judgement).
key_type(report_made_immediately, judgement).
key_type(system_under_the_exclusive_competence_of_the_ai_office, outside_fact).

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
    serious_incident_reporting_input_problems([], []).
test(a_well_typed_profile_has_no_problem) :-
    serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii_high_risk), attribute(widespread_infringement, unsure), attribute(system_under_the_exclusive_competence_of_the_ai_office, attested(true, attestation(host, stamp, reason, none)))], []).
test(an_atom_is_not_a_profile) :-
    serious_incident_reporting_input_problems(foo, [wrong_type(profile)]).
test(a_repeated_key_is_a_duplicate) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person), attribute(harm_to_health, bad_value)], [duplicate_key(harm_to_health)]).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(system_under_the_exclusive_competence_of_the_ai_office, true)], [wrong_type(system_under_the_exclusive_competence_of_the_ai_office)]).
test(unsure_is_not_a_crisp_value) :-
    serious_incident_reporting_input_problems([attribute(critical_infrastructure_disruption, unsure)], [wrong_type(critical_infrastructure_disruption)]).
test(a_key_outside_the_contract_is_unknown) :-
    serious_incident_reporting_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
