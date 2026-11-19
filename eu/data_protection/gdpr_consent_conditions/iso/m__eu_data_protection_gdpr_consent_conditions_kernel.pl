% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2, gdpr_consent_conditions_key_order/1, outside_fact_limb/4, crisp_limb/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

gdpr_consent_conditions_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [processing_based_on_consent, consent_demonstrable, consent_in_declaration_with_other_matters, request_clearly_distinguishable_and_intelligible, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, withdrawal_as_easy_as_giving_consent, contract_conditional_on_unneeded_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible, additional_identifying_information_provided],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(processing_based_on_consent, boolean).
key_type(consent_demonstrable, outside_fact).
key_type(consent_in_declaration_with_other_matters, boolean).
key_type(request_clearly_distinguishable_and_intelligible, outside_fact).
key_type(declaration_part_infringes_regulation, boolean).
key_type(informed_of_withdrawal_right_before_consent, boolean).
key_type(withdrawal_as_easy_as_giving_consent, outside_fact).
key_type(contract_conditional_on_unneeded_consent, boolean).
key_type(consent_freely_given, outside_fact).
key_type(purposes_do_not_require_identification, outside_fact).
key_type(able_to_demonstrate_not_in_position_to_identify, outside_fact).
key_type(informing_data_subject_possible, outside_fact).
key_type(additional_identifying_information_provided, boolean).

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

in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
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

gdpr_consent_conditions_key_order([processing_based_on_consent, consent_demonstrable, consent_in_declaration_with_other_matters, request_clearly_distinguishable_and_intelligible, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, withdrawal_as_easy_as_giving_consent, contract_conditional_on_unneeded_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible, additional_identifying_information_provided]).

outside_fact_limb(Profile, Key, absent, absent) :-
    profile_lacks(Profile, Key).
outside_fact_limb(Profile, Key, met, attested(true, Attestation)) :-
    profile_get(Profile, Key, attested(true, Attestation)).
outside_fact_limb(Profile, Key, unmet, attested(false, Attestation)) :-
    profile_get(Profile, Key, attested(false, Attestation)).

crisp_limb(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
crisp_limb(Profile, Key, met) :-
    profile_get(Profile, Key, true).
crisp_limb(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).

test(an_empty_profile_has_no_problem) :-
    gdpr_consent_conditions_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, true), attribute(consent_demonstrable, attested(true, attestation(by, at, reason, none)))], []).
test(a_bare_true_on_an_outside_fact_is_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(consent_demonstrable, true)], [wrong_type(consent_demonstrable)]).
test(unsure_on_a_crisp_key_is_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, unsure)], [wrong_type(processing_based_on_consent)]).
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(consent_freely_given, attested(true, attestation(_, at, reason, none)))], [wrong_type(consent_freely_given)]).
test(a_duplicate_key_is_never_also_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, true), attribute(processing_based_on_consent, maybe)], [duplicate_key(processing_based_on_consent)]).
test(a_number_key_is_an_unknown_key_as_given) :-
    gdpr_consent_conditions_input_problems([attribute(1, true)], [unknown_key(1)]).
test(contract_problems_come_before_unknown_keys) :-
    gdpr_consent_conditions_input_problems([attribute(colour, red), attribute(colour, blue), attribute(consent_demonstrable, false)], [wrong_type(consent_demonstrable), unknown_key(colour)]).
test(an_unbound_profile_is_wrong_type_profile) :-
    gdpr_consent_conditions_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_wrong_type_profile) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, true)|_], [wrong_type(profile)]).
test(a_non_attribute_element_is_wrong_type_profile) :-
    gdpr_consent_conditions_input_problems([foo], [wrong_type(profile)]).
test(the_input_check_yields_one_solution) :-
    findall(Problems, gdpr_consent_conditions_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(the_key_order_holds_thirteen_keys) :-
    gdpr_consent_conditions_key_order(Keys),
    length(Keys, 13).
test(an_attested_true_outside_fact_is_met) :-
    outside_fact_limb([attribute(consent_demonstrable, attested(true, attestation(by, at, reason, none)))], consent_demonstrable, met, attested(true, attestation(by, at, reason, none))).
test(an_attested_false_outside_fact_is_unmet) :-
    outside_fact_limb([attribute(consent_demonstrable, attested(false, attestation(by, at, reason, none)))], consent_demonstrable, unmet, _).
test(an_absent_outside_fact_is_absent) :-
    outside_fact_limb([], consent_demonstrable, absent, absent).
test(the_outside_fact_reader_yields_one_solution) :-
    findall(Limb, outside_fact_limb([], consent_demonstrable, Limb, _), Limbs),
    Limbs == [absent].
test(a_true_crisp_key_is_met) :-
    crisp_limb([attribute(processing_based_on_consent, true)], processing_based_on_consent, met).
test(a_false_crisp_key_is_unmet) :-
    crisp_limb([attribute(processing_based_on_consent, false)], processing_based_on_consent, unmet).
test(an_absent_crisp_key_is_absent) :-
    crisp_limb([], processing_based_on_consent, absent).

test(an_attested_false_outside_fact_is_not_met, fail) :-
    outside_fact_limb([attribute(consent_demonstrable, attested(false, attestation(by, at, reason, none)))], consent_demonstrable, met, _).
test(a_false_crisp_key_is_not_met, fail) :-
    crisp_limb([attribute(processing_based_on_consent, false)], processing_based_on_consent, met).
