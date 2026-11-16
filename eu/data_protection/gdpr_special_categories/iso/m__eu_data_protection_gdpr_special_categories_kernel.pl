% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_kernel, [gdpr_special_categories_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_special_categories_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [accordance_with_article_89_1, appropriate_safeguards, authorising_law_proportionate_and_respects_essence, biometric_data_present, biometric_used_for_unique_identification, comprehensive_register_of_criminal_convictions, concerns_health, concerns_sex_life_or_sexual_orientation, consent_purposes_specified, consent_satisfies_definition, criminal_data_authorising_law_exists, criminal_data_law_safeguards_appropriate, criminal_offence_data_present, data_not_disclosed_outside_body_without_consent, data_subject_incapable_of_giving_consent, employment_law_or_collective_agreement_authorises, employment_social_security_or_social_protection_field, exception_claimed, explicit_consent_given, genetic_data_present, health_care_law_basis_exists, manifestly_made_public_by_data_subject, member_state_further_conditions_exist, not_for_profit_body_with_specified_aim, processed_under_professional_secrecy, processing_in_course_of_legitimate_activities, processing_necessary, processing_relates_solely_to_members_or_regular_contacts, processing_under_official_authority_control, prohibition_lifting_barred_by_law, public_health_law_basis_exists, public_health_public_interest, purpose_is_archiving_research_or_statistics, purpose_is_health_or_social_care, purpose_is_legal_claims_or_judicial_capacity, pursuant_to_contract_with_health_professional, research_archiving_statistics_law_basis_exists, reveals_political_opinions, reveals_racial_or_ethnic_origin, reveals_religious_or_philosophical_beliefs, reveals_trade_union_membership, substantial_public_interest, substantial_public_interest_law_exists, suitable_and_specific_measures, vital_interest_at_stake],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(accordance_with_article_89_1, judgement).
key_type(appropriate_safeguards, judgement).
key_type(authorising_law_proportionate_and_respects_essence, judgement).
key_type(biometric_data_present, boolean).
key_type(biometric_used_for_unique_identification, boolean).
key_type(comprehensive_register_of_criminal_convictions, boolean).
key_type(concerns_health, judgement).
key_type(concerns_sex_life_or_sexual_orientation, judgement).
key_type(consent_purposes_specified, boolean).
key_type(consent_satisfies_definition, judgement).
key_type(criminal_data_authorising_law_exists, outside_fact).
key_type(criminal_data_law_safeguards_appropriate, judgement).
key_type(criminal_offence_data_present, boolean).
key_type(data_not_disclosed_outside_body_without_consent, boolean).
key_type(data_subject_incapable_of_giving_consent, boolean).
key_type(employment_law_or_collective_agreement_authorises, outside_fact).
key_type(employment_social_security_or_social_protection_field, boolean).
key_type(exception_claimed, enum([art9_2_a, art9_2_b, art9_2_c, art9_2_d, art9_2_e, art9_2_f, art9_2_g, art9_2_h, art9_2_i, art9_2_j])).
key_type(explicit_consent_given, boolean).
key_type(genetic_data_present, boolean).
key_type(health_care_law_basis_exists, outside_fact).
key_type(manifestly_made_public_by_data_subject, judgement).
key_type(member_state_further_conditions_exist, outside_fact).
key_type(not_for_profit_body_with_specified_aim, boolean).
key_type(processed_under_professional_secrecy, boolean).
key_type(processing_in_course_of_legitimate_activities, boolean).
key_type(processing_necessary, judgement).
key_type(processing_relates_solely_to_members_or_regular_contacts, boolean).
key_type(processing_under_official_authority_control, boolean).
key_type(prohibition_lifting_barred_by_law, outside_fact).
key_type(public_health_law_basis_exists, outside_fact).
key_type(public_health_public_interest, judgement).
key_type(purpose_is_archiving_research_or_statistics, boolean).
key_type(purpose_is_health_or_social_care, boolean).
key_type(purpose_is_legal_claims_or_judicial_capacity, boolean).
key_type(pursuant_to_contract_with_health_professional, boolean).
key_type(research_archiving_statistics_law_basis_exists, outside_fact).
key_type(reveals_political_opinions, judgement).
key_type(reveals_racial_or_ethnic_origin, judgement).
key_type(reveals_religious_or_philosophical_beliefs, judgement).
key_type(reveals_trade_union_membership, judgement).
key_type(substantial_public_interest, judgement).
key_type(substantial_public_interest_law_exists, outside_fact).
key_type(suitable_and_specific_measures, judgement).
key_type(vital_interest_at_stake, boolean).

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
