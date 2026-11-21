% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_governance_and_framework_queries, [dora_ict_risk_governance_and_framework_profile_keys/1, dora_ict_risk_governance_and_framework_what_if/4, dora_ict_risk_governance_and_framework_compliance_check/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_kernel, [dora_ict_risk_governance_and_framework_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_citations, [implements/1]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_dora_ict_risk_governance_and_framework, [dora_ict_risk_governance_and_framework_status/2, ict_risk_governance_duties_required/3]).

dora_ict_risk_governance_and_framework_profile_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, authority_requested_ict_risk_information, authority_requested_framework_review_report, major_change_occurred, entity_operates_legacy_ict_systems, has_internal_governance_and_control_framework, management_body_defines_approves_and_oversees_framework, management_body_bears_ultimate_ict_risk_responsibility, management_body_put_in_place_data_security_policies, ict_roles_and_governance_arrangements_set, management_body_approved_strategy_and_risk_tolerance, management_body_oversees_continuity_policy_and_plans, management_body_approves_ict_audit_plans, management_body_allocates_resilience_budget, management_body_approves_third_party_policy, reporting_channels_to_management_body_in_place, third_party_monitoring_role_established, management_body_keeps_ict_knowledge_up_to_date, has_sound_documented_ict_risk_management_framework, framework_protects_information_and_ict_assets, minimises_ict_risk_impact, provided_ict_risk_information_on_request, independent_ict_risk_control_function_assigned, risk_control_and_audit_functions_segregated, framework_reviewed_at_least_yearly, framework_reviewed_periodically, framework_reviewed_upon_events_and_improved, review_report_submitted_on_request, framework_internally_audited, formal_audit_follow_up_process_established, resilience_strategy_in_framework, uses_updated_appropriate_ict_systems, functions_and_assets_identified_and_classified, ict_risk_sources_identified_and_assessed, risk_assessed_upon_major_change, assets_identified_and_mapped, third_party_dependencies_identified, inventories_maintained_and_updated, legacy_systems_risk_assessed]).

dora_ict_risk_governance_and_framework_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ict_risk_governance_and_framework_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    clausal_is_list(Profile),
    replace_attribute(Profile, Key, Value, Replaced, Found),
    finish_override(Found, Replaced, Key, Value, Hypothesis).

replace_attribute([], _, _, [], false).
replace_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Replaced], true) :-
    ElementKey == Key,
    replace_attribute(Elements, Key, Value, Replaced, _).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Replaced], Found) :-
    ElementKey \== Key,
    replace_attribute(Elements, Key, Value, Replaced, Found).

finish_override(true, Replaced, _, _, Replaced).
finish_override(false, Replaced, Key, Value, Hypothesis) :-
    append(Replaced, [attribute(Key, Value)], Hypothesis).

dora_ict_risk_governance_and_framework_compliance_check(Profile, Action, Verdict) :-
    ict_risk_governance_duties_required(Profile, Result, Citations),
    action_verdict(Result, Citations, Action, Verdict).

action_verdict(required(Duties), Citations, omit_duty(Duty), Verdict) :-
    implements(eu_reg_2022_2554_art_5_1),
    memberd_t(Duty, Duties, IsRequired),
    omission_verdict(IsRequired, Citations, Verdict).
action_verdict(required(_), Citations, perform_duty(_), verdict(permitted, Citations)) :-
    implements(eu_reg_2022_2554_art_5_1).
action_verdict(simplified_framework_entity, Citations, omit_duty(_), verdict(permitted, Citations)) :-
    implements(eu_reg_2022_2554_art_16_1).
action_verdict(simplified_framework_entity, Citations, perform_duty(_), verdict(permitted, Citations)) :-
    implements(eu_reg_2022_2554_art_16_1).
action_verdict(indeterminate(MissingKeys), _, _, verdict(indeterminate(MissingKeys), [])).
action_verdict(input_problems(Problems), _, _, verdict(input_problems(Problems), [])).
action_verdict(needs_legal_review(Reason, Context), _, _, verdict(needs_legal_review(Reason, ContextWithProvenance), [])) :-
    referral_with_provenance(Context, ContextWithProvenance).

context_item_constructor(inputs_relied_on, 'inputs_relied_on').
context_item_constructor(provenance, 'provenance (optional, unscored)').

referral_with_provenance([inputs_relied_on(Pairs)], [inputs_relied_on(Pairs), Provenance]) :-
    context_item_constructor(inputs_relied_on, _),
    referral_provenance(Provenance).
referral_with_provenance([inputs_relied_on(Pairs), Provenance], [inputs_relied_on(Pairs), Provenance]) :-
    context_item_constructor(inputs_relied_on, _),
    provenance_element(Provenance).

referral_provenance(provenance(action_verdict, [])) :-
    context_item_constructor(provenance, 'provenance (optional, unscored)').

provenance_element(provenance(_Clause, _Citations)) :-
    context_item_constructor(provenance, 'provenance (optional, unscored)').

omission_verdict(true, Citations, verdict(forbidden, Citations)).
omission_verdict(false, _, verdict(permitted, [])).
