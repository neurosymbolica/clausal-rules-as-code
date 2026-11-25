% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_review_report_format_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, financial_entity_is_microenterprise, review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions, review_initiated_following_ict_related_incidents, identified_weaknesses_not_subject_to_corrective_measures, past_corrective_measures_proved_ineffective_or_created_unexpected_challenges, review_report_in_searchable_electronic_format, review_report_identifies_entity_and_group_structure, review_report_describes_context, review_report_summarises_changes_since_previous_report, review_report_gives_executive_summary, review_report_states_approval_date, review_report_describes_reason_for_review, review_report_references_initiating_instructions_or_conclusions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period_dates, review_report_indicates_responsible_function, review_report_describes_major_changes_and_improvements, review_report_analyses_impact_of_changes, review_report_summarises_findings_and_severity, review_report_summarises_remediation_measures, review_report_gives_measure_dates_and_progress, review_report_gives_measure_tools_and_functions, review_report_describes_resource_impact, review_report_informs_on_authority_information_process, review_report_explains_residual_risk_acceptance, review_report_informs_on_planned_developments, review_report_states_conclusions, review_report_lists_past_reviews, review_report_states_corrective_measure_implementation, review_report_describes_corrective_measure_improvements, review_report_uses_internal_audit_results, review_report_uses_compliance_assessments, review_report_uses_resilience_testing_results, review_report_uses_external_sources],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(authority_requested_framework_review_report, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions, fact).
key_type(review_initiated_following_ict_related_incidents, fact).
key_type(identified_weaknesses_not_subject_to_corrective_measures, fact).
key_type(past_corrective_measures_proved_ineffective_or_created_unexpected_challenges, fact).
key_type(review_report_in_searchable_electronic_format, judgement).
key_type(review_report_identifies_entity_and_group_structure, judgement).
key_type(review_report_describes_context, judgement).
key_type(review_report_summarises_changes_since_previous_report, judgement).
key_type(review_report_gives_executive_summary, judgement).
key_type(review_report_states_approval_date, judgement).
key_type(review_report_describes_reason_for_review, judgement).
key_type(review_report_references_initiating_instructions_or_conclusions, judgement).
key_type(review_report_lists_incidents_with_root_cause_analysis, judgement).
key_type(review_report_states_review_period_dates, judgement).
key_type(review_report_indicates_responsible_function, judgement).
key_type(review_report_describes_major_changes_and_improvements, judgement).
key_type(review_report_analyses_impact_of_changes, judgement).
key_type(review_report_summarises_findings_and_severity, judgement).
key_type(review_report_summarises_remediation_measures, judgement).
key_type(review_report_gives_measure_dates_and_progress, judgement).
key_type(review_report_gives_measure_tools_and_functions, judgement).
key_type(review_report_describes_resource_impact, judgement).
key_type(review_report_informs_on_authority_information_process, judgement).
key_type(review_report_explains_residual_risk_acceptance, judgement).
key_type(review_report_informs_on_planned_developments, judgement).
key_type(review_report_states_conclusions, judgement).
key_type(review_report_lists_past_reviews, judgement).
key_type(review_report_states_corrective_measure_implementation, judgement).
key_type(review_report_describes_corrective_measure_improvements, judgement).
key_type(review_report_uses_internal_audit_results, judgement).
key_type(review_report_uses_compliance_assessments, judgement).
key_type(review_report_uses_resilience_testing_results, judgement).
key_type(review_report_uses_external_sources, judgement).

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

in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
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

test(an_empty_profile_has_no_problem) :-
    dora_rts_review_report_format_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_review_report_format_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(authority_requested_framework_review_report, true), attribute(review_report_in_searchable_electronic_format, unsure)], Problems),
    Problems == [].
test(an_atom_is_not_an_attribute_list) :-
    dora_rts_review_report_format_input_problems(profile_atom, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_review_report_format_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(unsure_is_wrong_type_for_a_fact_key) :-
    dora_rts_review_report_format_input_problems([attribute(financial_entity_is_microenterprise, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_microenterprise)].
test(a_duplicate_comes_before_an_unknown_key) :-
    dora_rts_review_report_format_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(colour, red), attribute(financial_entity_is_article_16_1_entity, false)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)].

test(a_well_formed_profile_is_not_refused, fail) :-
    dora_rts_review_report_format_input_problems([attribute(financial_entity_is_article_16_1_entity, false)], [_|_]).
