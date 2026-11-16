% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_kernel, [gdpr_records_and_officer_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_records_and_officer_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [acts_as_controller, acts_as_processor, controller_erasure_time_limits_possible, controller_record_has_article_49_safeguards_documentation, controller_record_has_categories_of_data_subjects_and_personal_data, controller_record_has_categories_of_recipients, controller_record_has_contact_details, controller_record_has_erasure_time_limits, controller_record_has_purposes, controller_record_has_security_measures_description, controller_record_has_transfer_details, controller_security_measures_description_possible, controller_transfers_rely_on_article_49_1_second_subparagraph, controller_transfers_to_third_countries, is_public_authority_or_body, monitoring_is_core_activity, monitoring_is_large_scale, officer_free_of_instructions_and_penalty, officer_involved_properly_and_in_time, officer_other_tasks_result_in_conflict_of_interests, officer_reports_to_highest_management_level, officer_supported_with_resources_and_access, officer_tasks_include_acting_as_contact_point, officer_tasks_include_advising_on_impact_assessment, officer_tasks_include_cooperating_with_supervisory_authority, officer_tasks_include_informing_and_advising, officer_tasks_include_monitoring_compliance, persons_employed, processing_includes_criminal_offence_data, processing_includes_special_categories, processing_is_by_court_in_judicial_capacity, processing_is_occasional, processing_likely_to_result_in_risk, processing_requires_regular_and_systematic_monitoring, processor_record_has_article_49_safeguards_documentation, processor_record_has_categories_of_processing, processor_record_has_contact_details, processor_record_has_security_measures_description, processor_record_has_transfer_details, processor_security_measures_description_possible, processor_transfers_rely_on_article_49_1_second_subparagraph, processor_transfers_to_third_countries, special_category_processing_is_core_activity, special_category_processing_is_large_scale, union_or_member_state_law_requires_data_protection_officer],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(acts_as_controller, boolean).
key_type(acts_as_processor, boolean).
key_type(controller_erasure_time_limits_possible, judgement).
key_type(controller_record_has_article_49_safeguards_documentation, boolean).
key_type(controller_record_has_categories_of_data_subjects_and_personal_data, boolean).
key_type(controller_record_has_categories_of_recipients, boolean).
key_type(controller_record_has_contact_details, boolean).
key_type(controller_record_has_erasure_time_limits, boolean).
key_type(controller_record_has_purposes, boolean).
key_type(controller_record_has_security_measures_description, boolean).
key_type(controller_record_has_transfer_details, boolean).
key_type(controller_security_measures_description_possible, judgement).
key_type(controller_transfers_rely_on_article_49_1_second_subparagraph, boolean).
key_type(controller_transfers_to_third_countries, boolean).
key_type(is_public_authority_or_body, outside_fact).
key_type(monitoring_is_core_activity, judgement).
key_type(monitoring_is_large_scale, judgement).
key_type(officer_free_of_instructions_and_penalty, outside_fact).
key_type(officer_involved_properly_and_in_time, outside_fact).
key_type(officer_other_tasks_result_in_conflict_of_interests, judgement).
key_type(officer_reports_to_highest_management_level, outside_fact).
key_type(officer_supported_with_resources_and_access, outside_fact).
key_type(officer_tasks_include_acting_as_contact_point, boolean).
key_type(officer_tasks_include_advising_on_impact_assessment, boolean).
key_type(officer_tasks_include_cooperating_with_supervisory_authority, boolean).
key_type(officer_tasks_include_informing_and_advising, boolean).
key_type(officer_tasks_include_monitoring_compliance, boolean).
key_type(persons_employed, non_negative_integer).
key_type(processing_includes_criminal_offence_data, boolean).
key_type(processing_includes_special_categories, boolean).
key_type(processing_is_by_court_in_judicial_capacity, boolean).
key_type(processing_is_occasional, judgement).
key_type(processing_likely_to_result_in_risk, judgement).
key_type(processing_requires_regular_and_systematic_monitoring, judgement).
key_type(processor_record_has_article_49_safeguards_documentation, boolean).
key_type(processor_record_has_categories_of_processing, boolean).
key_type(processor_record_has_contact_details, boolean).
key_type(processor_record_has_security_measures_description, boolean).
key_type(processor_record_has_transfer_details, boolean).
key_type(processor_security_measures_description_possible, judgement).
key_type(processor_transfers_rely_on_article_49_1_second_subparagraph, boolean).
key_type(processor_transfers_to_third_countries, boolean).
key_type(special_category_processing_is_core_activity, judgement).
key_type(special_category_processing_is_large_scale, judgement).
key_type(union_or_member_state_law_requires_data_protection_officer, outside_fact).

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
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).
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

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.
