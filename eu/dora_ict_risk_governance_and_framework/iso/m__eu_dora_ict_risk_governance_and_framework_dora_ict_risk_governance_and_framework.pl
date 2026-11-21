% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_governance_and_framework_dora_ict_risk_governance_and_framework, [ict_risk_governance_duties_required/3, ict_risk_governance_duties_complete/3, ict_risk_governance_duties_outstanding/3, decide_dora_ict_risk_governance_and_framework/2, dora_ict_risk_governance_and_framework_status/2, dora_ict_risk_governance_and_framework_checklist/2, dora_ict_risk_governance_and_framework_decision_resolvable/1, dora_ict_risk_governance_and_framework_status_values/1, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, financial_entity_is_article_16_1_entity/0, financial_entity_is_microenterprise/0, authority_requested_ict_risk_information/0, authority_requested_framework_review_report/0, major_change_occurred/0, entity_operates_legacy_ict_systems/0, has_internal_governance_and_control_framework/0, management_body_defines_approves_and_oversees_framework/0, management_body_bears_ultimate_ict_risk_responsibility/0, management_body_put_in_place_data_security_policies/0, ict_roles_and_governance_arrangements_set/0, management_body_approved_strategy_and_risk_tolerance/0, management_body_oversees_continuity_policy_and_plans/0, management_body_approves_ict_audit_plans/0, management_body_allocates_resilience_budget/0, management_body_approves_third_party_policy/0, reporting_channels_to_management_body_in_place/0, third_party_monitoring_role_established/0, management_body_keeps_ict_knowledge_up_to_date/0, has_sound_documented_ict_risk_management_framework/0, framework_protects_information_and_ict_assets/0, minimises_ict_risk_impact/0, provided_ict_risk_information_on_request/0, independent_ict_risk_control_function_assigned/0, risk_control_and_audit_functions_segregated/0, framework_reviewed_at_least_yearly/0, framework_reviewed_periodically/0, framework_reviewed_upon_events_and_improved/0, review_report_submitted_on_request/0, framework_internally_audited/0, formal_audit_follow_up_process_established/0, resilience_strategy_in_framework/0, uses_updated_appropriate_ict_systems/0, functions_and_assets_identified_and_classified/0, ict_risk_sources_identified_and_assessed/0, risk_assessed_upon_major_change/0, assets_identified_and_mapped/0, third_party_dependencies_identified/0, inventories_maintained_and_updated/0, legacy_systems_risk_assessed/0, internal_governance_and_control_framework/0, management_body_framework_responsibility/0, management_body_ultimate_ict_risk_responsibility/0, data_security_policies/0, ict_roles_and_governance_arrangements/0, resilience_strategy_and_risk_tolerance_approval/0, business_continuity_policy_oversight/0, ict_audit_plan_approval/0, resilience_budget_allocation/0, third_party_policy_approval/0, management_body_reporting_channels/0, third_party_monitoring_role/0, management_body_ict_knowledge_and_training/0, ict_risk_management_framework/0, protection_of_information_and_ict_assets/0, ict_risk_impact_minimisation/0, ict_risk_information_to_authority/0, ict_risk_control_function/0, segregation_of_risk_control_and_audit_functions/0, annual_framework_review/0, periodic_framework_review/0, event_driven_framework_review_and_improvement/0, framework_review_report_to_authority/0, internal_audit_of_framework/0, audit_follow_up_process/0, digital_operational_resilience_strategy/0, ict_systems_protocols_and_tools/0, identification_and_classification/0, identification_of_ict_risk_sources/0, risk_assessment_upon_major_change/0, asset_identification_and_mapping/0, third_party_dependency_identification/0, inventories_maintained/0, legacy_systems_risk_assessment/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_kernel, [dora_ict_risk_governance_and_framework_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_citations, [implements/1]).

duty(1, internal_governance_and_control_framework, has_internal_governance_and_control_framework, [], [cite(eu_reg_2022_2554_art_5_1)]).
duty(2, management_body_framework_responsibility, management_body_defines_approves_and_oversees_framework, [], [cite(eu_reg_2022_2554_art_5_2)]).
duty(3, management_body_ultimate_ict_risk_responsibility, management_body_bears_ultimate_ict_risk_responsibility, [], [cite(eu_reg_2022_2554_art_5_2_a)]).
duty(4, data_security_policies, management_body_put_in_place_data_security_policies, [], [cite(eu_reg_2022_2554_art_5_2_b)]).
duty(5, ict_roles_and_governance_arrangements, ict_roles_and_governance_arrangements_set, [], [cite(eu_reg_2022_2554_art_5_2_c)]).
duty(6, resilience_strategy_and_risk_tolerance_approval, management_body_approved_strategy_and_risk_tolerance, [], [cite(eu_reg_2022_2554_art_5_2_d)]).
duty(7, business_continuity_policy_oversight, management_body_oversees_continuity_policy_and_plans, [], [cite(eu_reg_2022_2554_art_5_2_e)]).
duty(8, ict_audit_plan_approval, management_body_approves_ict_audit_plans, [], [cite(eu_reg_2022_2554_art_5_2_f)]).
duty(9, resilience_budget_allocation, management_body_allocates_resilience_budget, [], [cite(eu_reg_2022_2554_art_5_2_g)]).
duty(10, third_party_policy_approval, management_body_approves_third_party_policy, [], [cite(eu_reg_2022_2554_art_5_2_h)]).
duty(11, management_body_reporting_channels, reporting_channels_to_management_body_in_place, [], [cite(eu_reg_2022_2554_art_5_2_i), cite(eu_reg_2022_2554_art_5_2_i_i), cite(eu_reg_2022_2554_art_5_2_i_ii), cite(eu_reg_2022_2554_art_5_2_i_iii)]).
duty(12, third_party_monitoring_role, third_party_monitoring_role_established, [financial_entity_is_microenterprise - false], [cite(eu_reg_2022_2554_art_5_3)]).
duty(13, management_body_ict_knowledge_and_training, management_body_keeps_ict_knowledge_up_to_date, [], [cite(eu_reg_2022_2554_art_5_4)]).
duty(14, ict_risk_management_framework, has_sound_documented_ict_risk_management_framework, [], [cite(eu_reg_2022_2554_art_6_1)]).
duty(15, protection_of_information_and_ict_assets, framework_protects_information_and_ict_assets, [], [cite(eu_reg_2022_2554_art_6_2)]).
duty(16, ict_risk_impact_minimisation, minimises_ict_risk_impact, [], [cite(eu_reg_2022_2554_art_6_3)]).
duty(17, ict_risk_information_to_authority, provided_ict_risk_information_on_request, [authority_requested_ict_risk_information - true], [cite(eu_reg_2022_2554_art_6_3)]).
duty(18, ict_risk_control_function, independent_ict_risk_control_function_assigned, [financial_entity_is_microenterprise - false], [cite(eu_reg_2022_2554_art_6_4)]).
duty(19, segregation_of_risk_control_and_audit_functions, risk_control_and_audit_functions_segregated, [], [cite(eu_reg_2022_2554_art_6_4)]).
duty(20, annual_framework_review, framework_reviewed_at_least_yearly, [financial_entity_is_microenterprise - false], [cite(eu_reg_2022_2554_art_6_5)]).
duty(21, periodic_framework_review, framework_reviewed_periodically, [financial_entity_is_microenterprise - true], [cite(eu_reg_2022_2554_art_6_5)]).
duty(22, event_driven_framework_review_and_improvement, framework_reviewed_upon_events_and_improved, [], [cite(eu_reg_2022_2554_art_6_5)]).
duty(23, framework_review_report_to_authority, review_report_submitted_on_request, [authority_requested_framework_review_report - true], [cite(eu_reg_2022_2554_art_6_5)]).
duty(24, internal_audit_of_framework, framework_internally_audited, [financial_entity_is_microenterprise - false], [cite(eu_reg_2022_2554_art_6_6)]).
duty(25, audit_follow_up_process, formal_audit_follow_up_process_established, [financial_entity_is_microenterprise - false], [cite(eu_reg_2022_2554_art_6_7)]).
duty(26, digital_operational_resilience_strategy, resilience_strategy_in_framework, [], [cite(eu_reg_2022_2554_art_6_8), cite(eu_reg_2022_2554_art_6_8_a), cite(eu_reg_2022_2554_art_6_8_b), cite(eu_reg_2022_2554_art_6_8_c), cite(eu_reg_2022_2554_art_6_8_d), cite(eu_reg_2022_2554_art_6_8_e), cite(eu_reg_2022_2554_art_6_8_f), cite(eu_reg_2022_2554_art_6_8_g), cite(eu_reg_2022_2554_art_6_8_h)]).
duty(27, ict_systems_protocols_and_tools, uses_updated_appropriate_ict_systems, [], [cite(eu_reg_2022_2554_art_7), cite(eu_reg_2022_2554_art_7_a), cite(eu_reg_2022_2554_art_7_b), cite(eu_reg_2022_2554_art_7_c), cite(eu_reg_2022_2554_art_7_d)]).
duty(28, identification_and_classification, functions_and_assets_identified_and_classified, [], [cite(eu_reg_2022_2554_art_8_1)]).
duty(29, identification_of_ict_risk_sources, ict_risk_sources_identified_and_assessed, [], [cite(eu_reg_2022_2554_art_8_2)]).
duty(30, risk_assessment_upon_major_change, risk_assessed_upon_major_change, [financial_entity_is_microenterprise - false, major_change_occurred - true], [cite(eu_reg_2022_2554_art_8_3)]).
duty(31, asset_identification_and_mapping, assets_identified_and_mapped, [], [cite(eu_reg_2022_2554_art_8_4)]).
duty(32, third_party_dependency_identification, third_party_dependencies_identified, [], [cite(eu_reg_2022_2554_art_8_5)]).
duty(33, inventories_maintained, inventories_maintained_and_updated, [], [cite(eu_reg_2022_2554_art_8_6)]).
duty(34, legacy_systems_risk_assessment, legacy_systems_risk_assessed, [financial_entity_is_microenterprise - false, entity_operates_legacy_ict_systems - true], [cite(eu_reg_2022_2554_art_8_7)]).

fixed_citations([cite(eu_reg_2022_2554_art_5_1), cite(eu_reg_2022_2554_art_5_2), cite(eu_reg_2022_2554_art_5_3), cite(eu_reg_2022_2554_art_5_4), cite(eu_reg_2022_2554_art_6_1), cite(eu_reg_2022_2554_art_6_2), cite(eu_reg_2022_2554_art_6_3), cite(eu_reg_2022_2554_art_6_4), cite(eu_reg_2022_2554_art_6_5), cite(eu_reg_2022_2554_art_6_6), cite(eu_reg_2022_2554_art_6_7), cite(eu_reg_2022_2554_art_6_8), cite(eu_reg_2022_2554_art_7), cite(eu_reg_2022_2554_art_8_1), cite(eu_reg_2022_2554_art_8_2), cite(eu_reg_2022_2554_art_8_3), cite(eu_reg_2022_2554_art_8_4), cite(eu_reg_2022_2554_art_8_5), cite(eu_reg_2022_2554_art_8_6), cite(eu_reg_2022_2554_art_8_7)]).

entity_fact_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, authority_requested_ict_risk_information, authority_requested_framework_review_report, major_change_occurred, entity_operates_legacy_ict_systems]).

condition_key(financial_entity_is_microenterprise).
condition_key(authority_requested_ict_risk_information).
condition_key(authority_requested_framework_review_report).
condition_key(major_change_occurred).
condition_key(entity_operates_legacy_ict_systems).

boolean_value(true).
boolean_value(false).

trigger_keys(true, [authority_requested_ict_risk_information, authority_requested_framework_review_report]).
trigger_keys(false, [authority_requested_ict_risk_information, authority_requested_framework_review_report, major_change_occurred, entity_operates_legacy_ict_systems]).

dora_ict_risk_governance_and_framework_status_values([complete, incomplete, simplified_framework_entity]).

root_keys(Keys) :-
    entity_fact_keys(FactKeys),
    findall(DutyKey, duty(_, _, DutyKey, _, _), DutyKeys),
    append(FactKeys, DutyKeys, Keys).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, given(Value)) :-
    profile_get(Profile, Key, Value).

absent_keys(_, [], []).
absent_keys(Profile, [Key|Keys], AbsentKeys) :-
    key_state(Profile, Key, State),
    absent_keys(Profile, Keys, LaterAbsentKeys),
    add_if_absent(State, Key, LaterAbsentKeys, AbsentKeys).

add_if_absent(absent, Key, Keys, [Key|Keys]).
add_if_absent(given(_), _, Keys, Keys).

relied_on_pairs(Profile, Pairs) :-
    root_keys(RootKeys),
    present_pairs(Profile, RootKeys, Pairs).

present_pairs(_, [], []).
present_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    present_pairs(Profile, Keys, LaterPairs),
    add_pair(State, Key, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(given(Value), Key, Pairs, [Key - Value|Pairs]).

in_root_order([], _, []).
in_root_order([Key|Keys], Found, Ordered) :-
    memberd_t(Key, Found, IsFound),
    in_root_order(Keys, Found, LaterOrdered),
    keep_if(IsFound, Key, LaterOrdered, Ordered).

keep_if(true, Element, Elements, [Element|Elements]).
keep_if(false, _, Elements, Elements).

nonempty_t([], false).
nonempty_t([_|_], true).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

condition_state(Profile, ConditionKey - Wanted, State) :-
    key_state(Profile, ConditionKey, KeyState),
    condition_state_of(KeyState, Wanted, State).

condition_state_of(absent, _, open).
condition_state_of(given(Value), Wanted, holds) :-
    Value == Wanted.
condition_state_of(given(Value), Wanted, fails) :-
    Value \== Wanted.

conditions_state(_, [], applies).
conditions_state(Profile, [Condition|Conditions], Applicability) :-
    implements(eu_reg_2022_2554_art_3_60),
    condition_state(Profile, Condition, State),
    conditions_state(Profile, Conditions, LaterApplicability),
    combine_condition(State, LaterApplicability, Applicability).

combine_condition(fails, _, excluded).
combine_condition(holds, Applicability, Applicability).
combine_condition(open, applies, pending).
combine_condition(open, pending, pending).
combine_condition(open, excluded, excluded).

open_applicability(applies).
open_applicability(pending).

not_true(absent).
not_true(given(false)).
not_true(given(unsure)).

evaluated_duties(Profile, Evaluated) :-
    findall(duty_row(Duty, Key, Conditions, Citations), duty(_, Duty, Key, Conditions, Citations), Rows),
    maplist(evaluated_duty(Profile), Rows, Evaluated).

evaluated_duty(Profile, duty_row(Duty, Key, Conditions, Citations), evaluated(Duty, Key, Conditions, Citations, Applicability, KeyState)) :-
    implements(eu_reg_2022_2554_art_6_1),
    conditions_state(Profile, Conditions, Applicability),
    key_state(Profile, Key, KeyState).

duty_failure_t(applies, given(false), true).
duty_failure_t(applies, given(true), false).
duty_failure_t(applies, given(unsure), false).
duty_failure_t(applies, absent, false).
duty_failure_t(pending, _, false).
duty_failure_t(excluded, _, false).

failing_duties([], [], []).
failing_duties([evaluated(Duty, _, _, Citations, Applicability, KeyState)|Evaluated], Duties, CitationLists) :-
    implements(eu_reg_2022_2554_art_5_1),
    failing_duties(Evaluated, LaterDuties, LaterCitationLists),
    duty_failure_t(Applicability, KeyState, Fails),
    collect_duty(Fails, Duty, Citations, LaterDuties, LaterCitationLists, Duties, CitationLists).

applying_t(applies, true).
applying_t(pending, false).
applying_t(excluded, false).

applying_duties([], [], []).
applying_duties([evaluated(Duty, _, _, Citations, Applicability, _)|Evaluated], Duties, CitationLists) :-
    implements(eu_reg_2022_2554_art_5_1),
    applying_duties(Evaluated, LaterDuties, LaterCitationLists),
    applying_t(Applicability, Applies),
    collect_duty(Applies, Duty, Citations, LaterDuties, LaterCitationLists, Duties, CitationLists).

collect_duty(true, Duty, Citations, Duties, CitationLists, [Duty|Duties], [Citations|CitationLists]).
collect_duty(false, _, _, Duties, CitationLists, Duties, CitationLists).

others_hold(_, _, []).
others_hold(Profile, ConditionKey, [Key - _|Conditions]) :-
    Key == ConditionKey,
    others_hold(Profile, ConditionKey, Conditions).
others_hold(Profile, ConditionKey, [Key - Value|Conditions]) :-
    Key \== ConditionKey,
    condition_state(Profile, Key - Value, holds),
    others_hold(Profile, ConditionKey, Conditions).

condition_covered_t(Profile, Condition, DutyConditions, Truth) :-
    condition_state(Profile, Condition, State),
    covered_by_state(State, Condition, DutyConditions, Truth).

covered_by_state(holds, _, _, true).
covered_by_state(open, Condition, DutyConditions, Truth) :-
    memberd_t(Condition, DutyConditions, Truth).
covered_by_state(fails, Condition, DutyConditions, Truth) :-
    memberd_t(Condition, DutyConditions, Truth).

covered(_, [], _).
covered(Profile, [Condition|Conditions], DutyConditions) :-
    condition_covered_t(Profile, Condition, DutyConditions, true),
    covered(Profile, Conditions, DutyConditions).

covered_except(_, _, [], _).
covered_except(Profile, ConditionKey, [Key - _|Conditions], DutyConditions) :-
    Key == ConditionKey,
    covered_except(Profile, ConditionKey, Conditions, DutyConditions).
covered_except(Profile, ConditionKey, [Key - Value|Conditions], DutyConditions) :-
    Key \== ConditionKey,
    condition_covered_t(Profile, Key - Value, DutyConditions, true),
    covered_except(Profile, ConditionKey, Conditions, DutyConditions).

blocking_duty(Profile, Evaluated, Duty, DutyConditions, Other) :-
    member(evaluated(Other, _, OtherConditions, _, _, given(false)), Evaluated),
    Other \== Duty,
    covered(Profile, OtherConditions, DutyConditions).

unblocked_t(Profile, Evaluated, Duty, DutyConditions, Truth) :-
    findall(Other, blocking_duty(Profile, Evaluated, Duty, DutyConditions, Other), Blockers),
    nonempty_t(Blockers, Blocked),
    truth_not(Blocked, Truth).

truth_not(true, false).
truth_not(false, true).

condition_blocking_duty(Profile, Evaluated, Duty, ConditionKey - Value, DutyConditions, Other) :-
    member(evaluated(Other, _, OtherConditions, _, _, given(false)), Evaluated),
    Other \== Duty,
    memberd_t(ConditionKey - Value, OtherConditions, false),
    covered_except(Profile, ConditionKey, OtherConditions, DutyConditions).

value_failure_witness(Profile, Evaluated, ConditionKey, Value, Duty) :-
    member(evaluated(Duty, _, Conditions, _, _, given(false)), Evaluated),
    member(ConditionKey - Value, Conditions),
    others_hold(Profile, ConditionKey, Conditions).

value_makes_duty_fail_t(Profile, Evaluated, ConditionKey, Value, Truth) :-
    findall(Duty, value_failure_witness(Profile, Evaluated, ConditionKey, Value, Duty), Witnesses),
    nonempty_t(Witnesses, Truth).

ict_risk_governance_duties_required(Profile, Result, Citations) :-
    answer(required, Profile, Result, Citations).

ict_risk_governance_duties_complete(Profile, Result, Citations) :-
    answer(complete, Profile, Result, Citations).

ict_risk_governance_duties_outstanding(Profile, Result, Citations) :-
    answer(outstanding, Profile, Result, Citations).

answer(Query, Profile, Result, Citations) :-
    dora_ict_risk_governance_and_framework_input_problems(Profile, Problems),
    answer_after_input_check(Problems, Query, Profile, Result, Citations).

answer_after_input_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
answer_after_input_check([], Query, Profile, Result, Citations) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, State),
    answer_by_article_16(State, Query, Profile, Result, Citations).

answer_by_article_16(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []).
answer_by_article_16(given(true), _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
answer_by_article_16(given(false), Query, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    answer_for_entity(Query, Profile, Result, Citations).

answer_for_entity(required, Profile, Result, Citations) :-
    key_state(Profile, financial_entity_is_microenterprise, MicroenterpriseState),
    required_by_size(MicroenterpriseState, Profile, Result, Citations).
answer_for_entity(complete, Profile, Result, Citations) :-
    evaluated_duties(Profile, Evaluated),
    failing_duties(Evaluated, FailingDuties, _),
    complete_by_failure(FailingDuties, Profile, Evaluated, Result, Citations).
answer_for_entity(outstanding, Profile, Result, Citations) :-
    evaluated_duties(Profile, Evaluated),
    root_keys(RootKeys),
    findall(Key, outstanding_candidate(Profile, Evaluated, Key), Found),
    in_root_order(RootKeys, Found, Candidates),
    outstanding_by_candidates(Candidates, Profile, Evaluated, Result, Citations).

required_by_size(absent, _, indeterminate([financial_entity_is_microenterprise]), []).
required_by_size(given(Microenterprise), Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_3_60),
    trigger_keys(Microenterprise, TriggerKeys),
    absent_keys(Profile, TriggerKeys, AbsentKeys),
    required_by_triggers(AbsentKeys, Profile, Result, Citations).

required_by_triggers([Key|_], _, indeterminate([Key]), []).
required_by_triggers([], Profile, required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_5_1),
    evaluated_duties(Profile, Evaluated),
    applying_duties(Evaluated, Duties, CitationLists),
    append(CitationLists, AllCitations),
    sort(AllCitations, Citations).

complete_by_failure([_|_], _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_6_1),
    fixed_citations(Citations).
complete_by_failure([], Profile, Evaluated, Result, Citations) :-
    key_state(Profile, financial_entity_is_microenterprise, MicroenterpriseState),
    size_decides_t(MicroenterpriseState, Profile, Evaluated, Decides),
    complete_by_size(Decides, Profile, Evaluated, Result, Citations).

size_decides_t(given(_), _, _, false).
size_decides_t(absent, Profile, Evaluated, Decides) :-
    implements(eu_reg_2022_2554_art_3_60),
    value_makes_duty_fail_t(Profile, Evaluated, financial_entity_is_microenterprise, true, ForTrue),
    value_makes_duty_fail_t(Profile, Evaluated, financial_entity_is_microenterprise, false, ForFalse),
    truth_and(ForTrue, ForFalse, Decides).

complete_by_size(true, _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_6_1),
    fixed_citations(Citations).
complete_by_size(false, Profile, Evaluated, Result, Citations) :-
    findall(Duty, unfinished_duty(Evaluated, Duty), Unfinished),
    complete_by_unfinished(Unfinished, Profile, Evaluated, Result, Citations).

unfinished_duty(Evaluated, Duty) :-
    member(evaluated(Duty, _, _, _, Applicability, KeyState), Evaluated),
    open_applicability(Applicability),
    not_true(KeyState).

complete_by_unfinished([], _, _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_6_1),
    fixed_citations(Citations).
complete_by_unfinished([_|_], Profile, Evaluated, Result, Citations) :-
    root_keys(RootKeys),
    findall(Key, complete_candidate(Profile, Evaluated, Key), Found),
    in_root_order(RootKeys, Found, Candidates),
    complete_by_candidates(Candidates, Profile, Evaluated, Result, Citations).

complete_candidate(Profile, Evaluated, Key) :-
    member(evaluated(Duty, Key, Conditions, _, Applicability, absent), Evaluated),
    open_applicability(Applicability),
    unblocked_t(Profile, Evaluated, Duty, Conditions, true).
complete_candidate(Profile, Evaluated, Key) :-
    condition_key(Key),
    key_state(Profile, Key, absent),
    boolean_value(Value),
    member(evaluated(Duty, _, Conditions, _, Applicability, KeyState), Evaluated),
    open_applicability(Applicability),
    member(Key - Value, Conditions),
    not_true(KeyState),
    findall(Other, condition_blocking_duty(Profile, Evaluated, Duty, Key - Value, Conditions, Other), Blockers),
    nonempty_t(Blockers, false).

complete_by_candidates([Candidate|Candidates], Profile, Evaluated, indeterminate([Key]), []) :-
    alone_candidates([Candidate|Candidates], Profile, Evaluated, AloneCandidates),
    named_key(AloneCandidates, [Candidate|Candidates], Key).
complete_by_candidates([], Profile, Evaluated, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    findall(referral(UnsureKey, UnsureCitation), unsure_complete_candidate(Profile, Evaluated, UnsureKey, UnsureCitation), Referrals),
    first_referral(Referrals, Key, Citation),
    relied_on_pairs(Profile, Pairs).

unsure_complete_candidate(Profile, Evaluated, Key, Citation) :-
    member(evaluated(Duty, Key, Conditions, [Citation|_], Applicability, given(unsure)), Evaluated),
    open_applicability(Applicability),
    unblocked_t(Profile, Evaluated, Duty, Conditions, true).

first_referral([referral(Key, Citation)|_], Key, Citation).

alone_candidates([], _, _, []).
alone_candidates([Key|Keys], Profile, Evaluated, AloneCandidates) :-
    decides_alone_t(Profile, Evaluated, Key, Alone),
    alone_candidates(Keys, Profile, Evaluated, LaterAloneCandidates),
    keep_if(Alone, Key, LaterAloneCandidates, AloneCandidates).

decides_alone_t(Profile, Evaluated, Key, Truth) :-
    findall(Key, decides_alone_witness(Profile, Evaluated, Key), Witnesses),
    nonempty_t(Witnesses, Truth).

decides_alone_witness(_, Evaluated, Key) :-
    member(evaluated(_, Key, _, _, applies, _), Evaluated).
decides_alone_witness(Profile, Evaluated, Key) :-
    boolean_value(Value),
    value_failure_witness(Profile, Evaluated, Key, Value, _).

named_key([Key|_], _, Key).
named_key([], [Key|_], Key).

outstanding_candidate(_, Evaluated, Key) :-
    member(evaluated(_, Key, _, _, Applicability, absent), Evaluated),
    open_applicability(Applicability).
outstanding_candidate(Profile, Evaluated, Key) :-
    member(evaluated(_, _, Conditions, _, Applicability, KeyState), Evaluated),
    open_applicability(Applicability),
    not_true(KeyState),
    member(Key - _, Conditions),
    key_state(Profile, Key, absent).

outstanding_by_candidates([Key|_], _, _, indeterminate([Key]), []).
outstanding_by_candidates([], Profile, Evaluated, Result, Citations) :-
    findall(referral(UnsureKey, UnsureCitation), unsure_open_duty(Evaluated, UnsureKey, UnsureCitation), Referrals),
    outstanding_by_referrals(Referrals, Profile, Evaluated, Result, Citations).

unsure_open_duty(Evaluated, Key, Citation) :-
    member(evaluated(_, Key, _, [Citation|_], Applicability, given(unsure)), Evaluated),
    open_applicability(Applicability).

outstanding_by_referrals([referral(Key, Citation)|_], Profile, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    relied_on_pairs(Profile, Pairs).
outstanding_by_referrals([], _, Evaluated, Result, Citations) :-
    failing_duties(Evaluated, Duties, CitationLists),
    outstanding_list(Duties, CitationLists, Result, Citations).

outstanding_list([], _, none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_6_1),
    fixed_citations(Citations).
outstanding_list([Duty|Duties], CitationLists, outstanding([Duty|Duties]), Citations) :-
    implements(eu_reg_2022_2554_art_5_1),
    append(CitationLists, AllCitations),
    sort(AllCitations, Citations).

decide_dora_ict_risk_governance_and_framework(Profile, dora_ict_risk_governance_and_framework_verdict(Status, Citations)) :-
    ict_risk_governance_duties_complete(Profile, Status, Citations).

dora_ict_risk_governance_and_framework_status(Profile, Status) :-
    decide_dora_ict_risk_governance_and_framework(Profile, dora_ict_risk_governance_and_framework_verdict(Status, _Citations)).

dora_ict_risk_governance_and_framework_checklist(Profile, Items) :-
    dora_ict_risk_governance_and_framework_input_problems(Profile, []),
    key_state(Profile, financial_entity_is_article_16_1_entity, State),
    checklist_by_article_16(State, Profile, Items).

checklist_by_article_16(absent, _, Items) :-
    duty_items(unknown([financial_entity_is_article_16_1_entity]), Items).
checklist_by_article_16(given(true), _, Items) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_items(inapplicable, Items).
checklist_by_article_16(given(false), Profile, Items) :-
    evaluated_duties(Profile, Evaluated),
    maplist(evaluated_item(Profile), Evaluated, Items).

duty_items(Status, Items) :-
    findall(item(Duty, Status, Citation), duty(_, Duty, _, _, [Citation|_]), Items).

evaluated_item(Profile, evaluated(Duty, Key, Conditions, [Citation|_], Applicability, KeyState), item(Duty, Status, Citation)) :-
    item_status(Applicability, KeyState, Key, Conditions, Profile, Status).

item_status(excluded, _, _, _, _, inapplicable).
item_status(pending, _, _, Conditions, Profile, unknown(AbsentKeys)) :-
    pairs_keys(Conditions, ConditionKeys),
    absent_keys(Profile, ConditionKeys, AbsentKeys).
item_status(applies, given(true), _, _, _, met).
item_status(applies, given(false), _, _, _, unmet(not_performed)).
item_status(applies, given(unsure), Key, _, _, unknown([Key])).
item_status(applies, absent, Key, _, _, unknown([Key])).

dora_ict_risk_governance_and_framework_decision_resolvable(Profile) :-
    decide_dora_ict_risk_governance_and_framework(Profile, _Verdict).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

unsure.

financial_entity_is_article_16_1_entity.

financial_entity_is_microenterprise.

authority_requested_ict_risk_information.

authority_requested_framework_review_report.

major_change_occurred.

entity_operates_legacy_ict_systems.

has_internal_governance_and_control_framework.

management_body_defines_approves_and_oversees_framework.

management_body_bears_ultimate_ict_risk_responsibility.

management_body_put_in_place_data_security_policies.

ict_roles_and_governance_arrangements_set.

management_body_approved_strategy_and_risk_tolerance.

management_body_oversees_continuity_policy_and_plans.

management_body_approves_ict_audit_plans.

management_body_allocates_resilience_budget.

management_body_approves_third_party_policy.

reporting_channels_to_management_body_in_place.

third_party_monitoring_role_established.

management_body_keeps_ict_knowledge_up_to_date.

has_sound_documented_ict_risk_management_framework.

framework_protects_information_and_ict_assets.

minimises_ict_risk_impact.

provided_ict_risk_information_on_request.

independent_ict_risk_control_function_assigned.

risk_control_and_audit_functions_segregated.

framework_reviewed_at_least_yearly.

framework_reviewed_periodically.

framework_reviewed_upon_events_and_improved.

review_report_submitted_on_request.

framework_internally_audited.

formal_audit_follow_up_process_established.

resilience_strategy_in_framework.

uses_updated_appropriate_ict_systems.

functions_and_assets_identified_and_classified.

ict_risk_sources_identified_and_assessed.

risk_assessed_upon_major_change.

assets_identified_and_mapped.

third_party_dependencies_identified.

inventories_maintained_and_updated.

legacy_systems_risk_assessed.

internal_governance_and_control_framework.

management_body_framework_responsibility.

management_body_ultimate_ict_risk_responsibility.

data_security_policies.

ict_roles_and_governance_arrangements.

resilience_strategy_and_risk_tolerance_approval.

business_continuity_policy_oversight.

ict_audit_plan_approval.

resilience_budget_allocation.

third_party_policy_approval.

management_body_reporting_channels.

third_party_monitoring_role.

management_body_ict_knowledge_and_training.

ict_risk_management_framework.

protection_of_information_and_ict_assets.

ict_risk_impact_minimisation.

ict_risk_information_to_authority.

ict_risk_control_function.

segregation_of_risk_control_and_audit_functions.

annual_framework_review.

periodic_framework_review.

event_driven_framework_review_and_improvement.

framework_review_report_to_authority.

internal_audit_of_framework.

audit_follow_up_process.

digital_operational_resilience_strategy.

ict_systems_protocols_and_tools.

identification_and_classification.

identification_of_ict_risk_sources.

risk_assessment_upon_major_change.

asset_identification_and_mapping.

third_party_dependency_identification.

inventories_maintained.

legacy_systems_risk_assessment.

full_profile(Microenterprise, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, Microenterprise), attribute(authority_requested_ict_risk_information, false), attribute(authority_requested_framework_review_report, false), attribute(major_change_occurred, false), attribute(entity_operates_legacy_ict_systems, false)|DutyAttributes]) :-
    findall(attribute(DutyKey, true), duty(_, _, DutyKey, _, _), DutyAttributes).

with_value(Profile, Key, Value, NewProfile) :-
    maplist(set_attribute(Key, Value), Profile, NewProfile).

set_attribute(Key, Value, attribute(ElementKey, _), attribute(Key, Value)) :-
    ElementKey == Key.
set_attribute(Key, _, attribute(ElementKey, ElementValue), attribute(ElementKey, ElementValue)) :-
    ElementKey \== Key.

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], Key, Remaining) :-
    ElementKey == Key,
    without_key(Elements, Key, Remaining).
without_key([attribute(ElementKey, Value)|Elements], Key, [attribute(ElementKey, Value)|Remaining]) :-
    ElementKey \== Key,
    without_key(Elements, Key, Remaining).

test(required_for_an_entity_that_is_not_a_microenterprise) :-
    full_profile(false, Profile),
    findall(Result, ict_risk_governance_duties_required(Profile, Result, _), [required(Duties)]),
    length(Duties, 29).
test(required_for_a_microenterprise_has_the_periodic_review) :-
    full_profile(true, Profile),
    findall(Result, ict_risk_governance_duties_required(Profile, Result, _), [required(Duties)]),
    length(Duties, 25),
    member(periodic_framework_review, Duties).
test(a_microenterprise_is_not_asked_the_major_change_trigger) :-
    full_profile(true, FullProfile),
    without_key(FullProfile, major_change_occurred, Profile),
    ict_risk_governance_duties_required(Profile, required(_), _).
test(an_absent_trigger_is_named_for_a_larger_entity) :-
    full_profile(false, FullProfile),
    without_key(FullProfile, major_change_occurred, Profile),
    ict_risk_governance_duties_required(Profile, indeterminate([major_change_occurred]), []).
test(every_duty_performed_is_complete) :-
    full_profile(false, Profile),
    findall(Result, ict_risk_governance_duties_complete(Profile, Result, _), Results),
    Results == [complete].
test(one_unperformed_duty_is_incomplete) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, management_body_put_in_place_data_security_policies, false, Profile),
    ict_risk_governance_duties_complete(Profile, incomplete, Citations),
    member(cite(eu_reg_2022_2554_art_8_7), Citations).
test(the_unperformed_duty_is_outstanding) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, management_body_put_in_place_data_security_policies, false, Profile),
    ict_risk_governance_duties_outstanding(Profile, outstanding([data_security_policies]), [cite(eu_reg_2022_2554_art_5_2_b)]).
test(nothing_outstanding_when_all_performed) :-
    full_profile(false, Profile),
    ict_risk_governance_duties_outstanding(Profile, none_outstanding, _).
test(an_article_16_entity_is_a_simplified_framework_entity) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, financial_entity_is_article_16_1_entity, true, Profile),
    ict_risk_governance_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_governance_duties_complete(Profile, simplified_framework_entity, _),
    ict_risk_governance_duties_outstanding(Profile, simplified_framework_entity, _).
test(an_absent_article_16_key_is_named_first) :-
    ict_risk_governance_duties_complete([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, management_body_approves_ict_audit_plans, unsure, Profile),
    ict_risk_governance_duties_complete(Profile, needs_legal_review(open_textured(management_body_approves_ict_audit_plans, cite(eu_reg_2022_2554_art_5_2_f)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 40).
test(an_unknown_key_is_an_input_problem) :-
    ict_risk_governance_duties_required([attribute(bogus_key, true)], input_problems([unknown_key(bogus_key)]), []).
test(an_unanswered_size_that_matters_is_named) :-
    full_profile(false, FullProfile),
    without_key(FullProfile, financial_entity_is_microenterprise, SizelessProfile),
    with_value(SizelessProfile, framework_reviewed_at_least_yearly, false, Profile),
    ict_risk_governance_duties_complete(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(an_unanswered_size_failing_either_way_is_incomplete) :-
    full_profile(false, FullProfile),
    without_key(FullProfile, financial_entity_is_microenterprise, SizelessProfile),
    with_value(SizelessProfile, framework_reviewed_at_least_yearly, false, YearlyProfile),
    with_value(YearlyProfile, framework_reviewed_periodically, false, Profile),
    ict_risk_governance_duties_complete(Profile, incomplete, _).
test(outstanding_names_the_trigger_of_an_unperformed_duty) :-
    full_profile(false, FullProfile),
    without_key(FullProfile, major_change_occurred, TriggerlessProfile),
    with_value(TriggerlessProfile, risk_assessed_upon_major_change, false, Profile),
    ict_risk_governance_duties_outstanding(Profile, indeterminate([major_change_occurred]), []).
test(each_query_answers_once) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, legacy_systems_risk_assessed, unsure, Profile),
    findall(Result, ict_risk_governance_duties_required(Profile, Result, _), RequiredResults),
    findall(Result, ict_risk_governance_duties_complete(Profile, Result, _), CompleteResults),
    findall(Result, ict_risk_governance_duties_outstanding(Profile, Result, _), OutstandingResults),
    length(RequiredResults, 1),
    length(CompleteResults, 1),
    length(OutstandingResults, 1).
test(the_checklist_has_one_item_per_duty) :-
    full_profile(false, Profile),
    dora_ict_risk_governance_and_framework_checklist(Profile, Items),
    length(Items, 34),
    member(item(internal_governance_and_control_framework, met, cite(eu_reg_2022_2554_art_5_1)), Items).
test(the_facade_verdict_is_the_complete_answer) :-
    full_profile(true, Profile),
    dora_ict_risk_governance_and_framework_status(Profile, complete).

test(a_microenterprise_is_never_asked_the_annual_review, fail) :-
    full_profile(true, Profile),
    ict_risk_governance_duties_required(Profile, required(Duties), _),
    member(annual_framework_review, Duties).
test(one_unperformed_duty_is_not_complete, fail) :-
    full_profile(false, FullProfile),
    with_value(FullProfile, management_body_put_in_place_data_security_policies, false, Profile),
    ict_risk_governance_duties_complete(Profile, complete, _).
test(a_performed_duty_is_not_outstanding, fail) :-
    full_profile(false, Profile),
    ict_risk_governance_duties_outstanding(Profile, outstanding(_), _).
