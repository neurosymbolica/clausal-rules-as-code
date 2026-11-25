% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, framework_review_initiated_following_supervisory_instructions, framework_review_initiated_following_ict_related_incidents, ict_security_testing_plan_established_and_implemented, ict_security_measures_reviewed_assessed_and_tested, security_test_results_evaluated_and_measures_updated, ict_systems_acquisition_and_development_procedure_in_place, requirements_specified_and_approved_before_acquisition, ict_systems_tested_and_approved_before_use_and_changes, alteration_and_manipulation_risk_measures_identified, ict_project_management_procedure_in_place, ict_change_management_procedure_in_place, continuity_plans_developed_on_disruption_and_scenario_analysis, continuity_plans_approved_by_management_body, continuity_plans_documented_and_readily_accessible, continuity_plans_allocate_sufficient_resources, continuity_plans_establish_recovery_levels_and_timeframes, continuity_plans_identify_activation_conditions_and_actions, continuity_plans_identify_restoration_and_recovery_measures, continuity_plans_identify_backup_procedures_scope_and_frequency, continuity_plans_consider_alternative_options, continuity_plans_specify_communication_and_escalation, continuity_plans_updated_with_lessons_learned, continuity_plans_tested_yearly_and_on_major_change, continuity_plan_testing_demonstrates_viability_and_finds_deficiencies, continuity_test_results_documented_and_deficiencies_reported, review_report_submitted_in_searchable_electronic_format, review_report_describes_context, review_report_has_executive_summary, review_report_informs_on_reported_area, review_report_summarises_major_framework_changes, review_report_describes_impact_of_major_changes, review_report_states_approval_date_where_applicable, review_report_describes_reasons_for_review, review_report_gives_evidence_of_supervisory_instructions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period, review_report_names_person_responsible, review_report_summarises_findings_and_self_assessment, review_report_states_remedying_measures, review_report_states_overall_conclusions],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(authority_requested_framework_review_report, fact).
key_type(framework_review_initiated_following_supervisory_instructions, fact).
key_type(framework_review_initiated_following_ict_related_incidents, fact).
key_type(ict_security_testing_plan_established_and_implemented, judgement).
key_type(ict_security_measures_reviewed_assessed_and_tested, judgement).
key_type(security_test_results_evaluated_and_measures_updated, judgement).
key_type(ict_systems_acquisition_and_development_procedure_in_place, judgement).
key_type(requirements_specified_and_approved_before_acquisition, judgement).
key_type(ict_systems_tested_and_approved_before_use_and_changes, judgement).
key_type(alteration_and_manipulation_risk_measures_identified, judgement).
key_type(ict_project_management_procedure_in_place, judgement).
key_type(ict_change_management_procedure_in_place, judgement).
key_type(continuity_plans_developed_on_disruption_and_scenario_analysis, judgement).
key_type(continuity_plans_approved_by_management_body, judgement).
key_type(continuity_plans_documented_and_readily_accessible, judgement).
key_type(continuity_plans_allocate_sufficient_resources, judgement).
key_type(continuity_plans_establish_recovery_levels_and_timeframes, judgement).
key_type(continuity_plans_identify_activation_conditions_and_actions, judgement).
key_type(continuity_plans_identify_restoration_and_recovery_measures, judgement).
key_type(continuity_plans_identify_backup_procedures_scope_and_frequency, judgement).
key_type(continuity_plans_consider_alternative_options, judgement).
key_type(continuity_plans_specify_communication_and_escalation, judgement).
key_type(continuity_plans_updated_with_lessons_learned, judgement).
key_type(continuity_plans_tested_yearly_and_on_major_change, judgement).
key_type(continuity_plan_testing_demonstrates_viability_and_finds_deficiencies, judgement).
key_type(continuity_test_results_documented_and_deficiencies_reported, judgement).
key_type(review_report_submitted_in_searchable_electronic_format, judgement).
key_type(review_report_describes_context, judgement).
key_type(review_report_has_executive_summary, judgement).
key_type(review_report_informs_on_reported_area, judgement).
key_type(review_report_summarises_major_framework_changes, judgement).
key_type(review_report_describes_impact_of_major_changes, judgement).
key_type(review_report_states_approval_date_where_applicable, judgement).
key_type(review_report_describes_reasons_for_review, judgement).
key_type(review_report_gives_evidence_of_supervisory_instructions, judgement).
key_type(review_report_lists_incidents_with_root_cause_analysis, judgement).
key_type(review_report_states_review_period, judgement).
key_type(review_report_names_person_responsible, judgement).
key_type(review_report_summarises_findings_and_self_assessment, judgement).
key_type(review_report_states_remedying_measures, judgement).
key_type(review_report_states_overall_conclusions, judgement).

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
    dora_rts_simplified_testing_continuity_and_report_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(ict_security_testing_plan_established_and_implemented, unsure)], []).
test(an_unsure_gate_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(a_duplicate_gate_is_named_once) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, unsure)], [duplicate_key(financial_entity_is_article_16_1_entity)]).
test(the_microenterprise_key_is_unknown) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_microenterprise, true)], [unknown_key(financial_entity_is_microenterprise)]).
test(a_non_list_is_not_a_profile) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(profile, [wrong_type(profile)]).

test(a_well_formed_profile_is_not_refused, fail) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true)], [_|_]).
