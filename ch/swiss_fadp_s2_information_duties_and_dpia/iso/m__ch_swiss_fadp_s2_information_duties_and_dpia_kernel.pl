% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_kernel, [swiss_fadp_s2_information_duties_and_dpia_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [controller_is_federal_body, personal_data_collected_from_data_subject, data_subject_already_has_information, processing_provided_for_by_law, controller_bound_by_statutory_secrecy, article_27_conditions_met, information_impossible_or_requires_disproportionate_effort, overriding_third_party_interests_require_restriction, information_defeats_purpose_of_processing, overriding_controller_interests_require_restriction, controller_discloses_personal_data_to_third_parties, overriding_public_interests_require_restriction, information_may_endanger_investigation_or_proceedings, personal_data_disclosed_to_recipients, personal_data_disclosed_abroad, disclosure_abroad_relies_on_safeguards_or_exception, decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject, decision_directly_related_to_contract_with_data_subject, data_subject_request_granted, data_subject_explicitly_consented_to_automated_decision, data_subject_need_not_be_heard_before_decision, processing_may_entail_high_risk_to_personality_or_fundamental_rights, large_scale_processing_of_sensitive_personal_data, systematic_large_scale_monitoring_of_public_areas, controller_legally_obliged_to_process_data, system_product_or_service_certified_for_intended_use, controller_complies_with_code_of_conduct, code_of_conduct_based_on_impact_assessment, code_of_conduct_provides_protective_measures, code_of_conduct_submitted_to_commissioner, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy, eu_decision_based_solely_on_automated_processing, eu_decision_has_legal_or_similarly_significant_effects, eu_processing_likely_to_result_in_high_risk, eu_systematic_extensive_evaluation_with_significant_automated_decisions, eu_large_scale_processing_of_special_categories_or_criminal_data, eu_systematic_large_scale_monitoring_of_publicly_accessible_area, eu_article_35_10_exemption_applies],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(controller_is_federal_body, boolean).
key_type(personal_data_collected_from_data_subject, boolean).
key_type(data_subject_already_has_information, judgement).
key_type(processing_provided_for_by_law, judgement).
key_type(controller_bound_by_statutory_secrecy, judgement).
key_type(article_27_conditions_met, judgement).
key_type(information_impossible_or_requires_disproportionate_effort, judgement).
key_type(overriding_third_party_interests_require_restriction, judgement).
key_type(information_defeats_purpose_of_processing, judgement).
key_type(overriding_controller_interests_require_restriction, judgement).
key_type(controller_discloses_personal_data_to_third_parties, boolean).
key_type(overriding_public_interests_require_restriction, judgement).
key_type(information_may_endanger_investigation_or_proceedings, judgement).
key_type(personal_data_disclosed_to_recipients, boolean).
key_type(personal_data_disclosed_abroad, boolean).
key_type(disclosure_abroad_relies_on_safeguards_or_exception, boolean).
key_type(decision_based_solely_on_automated_processing, judgement).
key_type(decision_has_legal_consequence_or_significantly_impairs_data_subject, judgement).
key_type(decision_directly_related_to_contract_with_data_subject, judgement).
key_type(data_subject_request_granted, boolean).
key_type(data_subject_explicitly_consented_to_automated_decision, judgement).
key_type(data_subject_need_not_be_heard_before_decision, judgement).
key_type(processing_may_entail_high_risk_to_personality_or_fundamental_rights, judgement).
key_type(large_scale_processing_of_sensitive_personal_data, judgement).
key_type(systematic_large_scale_monitoring_of_public_areas, judgement).
key_type(controller_legally_obliged_to_process_data, judgement).
key_type(system_product_or_service_certified_for_intended_use, judgement).
key_type(controller_complies_with_code_of_conduct, judgement).
key_type(code_of_conduct_based_on_impact_assessment, judgement).
key_type(code_of_conduct_provides_protective_measures, judgement).
key_type(code_of_conduct_submitted_to_commissioner, boolean).
key_type(eu_data_subject_already_has_information, judgement).
key_type(eu_information_impossible_disproportionate_or_seriously_impairing, judgement).
key_type(eu_obtaining_or_disclosure_expressly_laid_down_by_law, judgement).
key_type(eu_personal_data_confidential_under_professional_secrecy, judgement).
key_type(eu_decision_based_solely_on_automated_processing, judgement).
key_type(eu_decision_has_legal_or_similarly_significant_effects, judgement).
key_type(eu_processing_likely_to_result_in_high_risk, judgement).
key_type(eu_systematic_extensive_evaluation_with_significant_automated_decisions, judgement).
key_type(eu_large_scale_processing_of_special_categories_or_criminal_data, judgement).
key_type(eu_systematic_large_scale_monitoring_of_publicly_accessible_area, judgement).
key_type(eu_article_35_10_exemption_applies, judgement).

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
