% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(information_relates_to_natural_person, judgement).
key_type(natural_person_identified, boolean).
key_type(natural_person_identifiable, judgement).
key_type(operation_performed_on_the_data, boolean).
key_type(stored_data_marked_to_limit_future_processing, boolean).
key_type(processing_automated, boolean).
key_type(evaluates_personal_aspects_of_natural_person, judgement).
key_type(attribution_needs_additional_information, judgement).
key_type(additional_information_kept_separately, boolean).
key_type(measures_prevent_attribution, judgement).
key_type(structured_set_accessible_by_specific_criteria, judgement).
key_type(data_disclosed_to_receiving_body, boolean).
key_type(receiving_body_public_authority_in_particular_inquiry, boolean).
key_type(receiving_body_is_data_subject, boolean).
key_type(receiving_body_is_controller_or_processor, boolean).
key_type(receiving_body_authorised_under_direct_authority, boolean).
key_type(indication_freely_given, judgement).
key_type(indication_specific, judgement).
key_type(indication_informed, judgement).
key_type(indication_unambiguous, judgement).
key_type(agreement_by_statement_or_clear_affirmative_action, judgement).
key_type(breach_of_security, judgement).
key_type(breach_led_to_listed_outcome, boolean).
key_type(service_is_information_society_service, outside_fact).
key_type(organisation_governed_by_public_international_law, outside_fact).
key_type(body_set_up_by_agreement_between_countries, boolean).

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
    Element = attribute(Key, _),
    var(Key).
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    nonvar(Key),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

identical_member_t(_, [], false).
identical_member_t(Key, [Candidate|_], true) :-
    Key == Candidate.
identical_member_t(Key, [Candidate|Remaining], T) :-
    Key \== Candidate,
    identical_member_t(Key, Remaining, T).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identical_member_t(Key, Known, IsKnown),
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
    gdpr_common_definitions_data_and_processing_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(information_relates_to_natural_person, unsure), attribute(natural_person_identified, false), attribute(service_is_information_society_service, attested(true, attestation(host, moment, reason, none)))], Problems),
    Problems == [].
test(an_atom_is_not_a_profile) :-
    gdpr_common_definitions_data_and_processing_input_problems(nothing, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_a_profile) :-
    gdpr_common_definitions_data_and_processing_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_a_profile) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(processing_automated, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_non_ground_compound_key_is_not_a_profile) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(wrapper(_), true)], Problems),
    Problems == [wrong_type(profile)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(natural_person_identified, unsure)], Problems),
    Problems == [wrong_type(natural_person_identified)].
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(organisation_governed_by_public_international_law, true)], Problems),
    Problems == [wrong_type(organisation_governed_by_public_international_law)].
test(a_repeated_key_is_duplicate_and_its_values_unread) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(processing_automated, true), attribute(processing_automated, nonsense)], Problems),
    Problems == [duplicate_key(processing_automated)].
test(unknown_and_unbound_keys_in_first_occurrence_order) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(extra_key, true), attribute(Variable, one), attribute(Variable, two), attribute(extra_key, false)], Problems),
    Problems == [unknown_key(extra_key), unknown_key(Variable)].
test(an_unbound_key_does_not_bind_to_a_contract_key) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(Variable, true), attribute(processing_automated, true)], Problems),
    Problems == [unknown_key(Variable)],
    var(Variable).
test(exactly_one_answer) :-
    findall(Problems, gdpr_common_definitions_data_and_processing_input_problems([attribute(processing_automated, true)], Problems), Answers),
    length(Answers, 1).

test(a_well_formed_profile_is_not_a_profile_problem, fail) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(processing_automated, true)], [wrong_type(profile)]).
