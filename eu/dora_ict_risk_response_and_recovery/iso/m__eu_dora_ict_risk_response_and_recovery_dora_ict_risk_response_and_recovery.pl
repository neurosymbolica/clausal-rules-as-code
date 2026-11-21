% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, decide_dora_ict_risk_response_and_recovery/2, dora_ict_risk_response_and_recovery_status/2, dora_ict_risk_response_and_recovery_checklist/2, dora_ict_risk_response_and_recovery_decision_resolvable/1, dora_ict_risk_response_and_recovery_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_citations, [implements/1]).

dora_ict_risk_response_and_recovery_status_values([complete, incomplete, simplified_framework_entity]).

profile_key_order([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, business_continuity_or_response_and_recovery_plans_activated, authority_requested_estimate_of_annual_ict_incident_costs_and_losses, backup_data_restored_using_own_systems, recovered_from_ict_related_incident, data_reconstructed_from_external_stakeholders, has_ict_business_continuity_policy, continuity_policy_implemented_through_documented_arrangements, arrangements_ensure_continuity_of_critical_or_important_functions, arrangements_respond_to_and_resolve_ict_related_incidents, arrangements_activate_containment_plans_without_delay, arrangements_estimate_preliminary_impacts_damages_and_losses, arrangements_set_out_communication_and_crisis_management_actions, ict_response_and_recovery_plans_implemented, response_and_recovery_plans_subject_to_independent_internal_audit_reviews, ict_business_continuity_plans_in_place_maintained_and_periodically_tested, business_impact_analysis_conducted, ict_assets_and_services_aligned_with_business_impact_analysis, plans_tested_at_least_yearly_and_on_substantive_changes, crisis_communication_plans_tested, testing_plans_include_cyber_attack_and_switchover_scenarios, continuity_policy_and_plans_regularly_reviewed, has_crisis_management_function, records_of_activities_during_disruption_events_kept, continuity_test_results_provided_to_competent_authorities, estimate_of_aggregated_annual_costs_and_losses_reported, backup_policies_and_procedures_developed_and_documented, restoration_and_recovery_procedures_and_methods_developed_and_documented, backup_systems_that_can_be_activated_set_up, backup_activation_does_not_jeopardise_security, backup_and_restoration_procedures_periodically_tested, restoration_uses_segregated_and_protected_ict_systems, recovery_plans_enable_recovery_of_all_transactions, adequate_resources_and_backup_and_restoration_facilities_maintained, redundant_ict_capacities_maintained, need_for_redundant_ict_capacities_assessed, secondary_processing_site_maintained, secondary_site_located_at_geographical_distance, secondary_site_can_ensure_continuity_of_critical_or_important_functions, secondary_site_immediately_accessible_to_staff, recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, data_integrity_checks_performed_when_recovering, data_consistency_checks_performed_when_reconstructing_data]).

condition_keys([financial_entity_is_microenterprise, dora_entity_type, business_continuity_or_response_and_recovery_plans_activated, authority_requested_estimate_of_annual_ict_incident_costs_and_losses, backup_data_restored_using_own_systems, recovered_from_ict_related_incident, data_reconstructed_from_external_stakeholders]).

condition_values(financial_entity_is_microenterprise, [true, false]).
condition_values(dora_entity_type, [credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]).
condition_values(business_continuity_or_response_and_recovery_plans_activated, [true, false]).
condition_values(authority_requested_estimate_of_annual_ict_incident_costs_and_losses, [true, false]).
condition_values(backup_data_restored_using_own_systems, [true, false]).
condition_values(recovered_from_ict_related_incident, [true, false]).
condition_values(data_reconstructed_from_external_stakeholders, [true, false]).

fixed_citations([cite(eu_reg_2022_2554_art_11_1), cite(eu_reg_2022_2554_art_11_2), cite(eu_reg_2022_2554_art_11_3), cite(eu_reg_2022_2554_art_11_4), cite(eu_reg_2022_2554_art_11_5), cite(eu_reg_2022_2554_art_11_6), cite(eu_reg_2022_2554_art_11_7), cite(eu_reg_2022_2554_art_11_8), cite(eu_reg_2022_2554_art_11_9), cite(eu_reg_2022_2554_art_11_10), cite(eu_reg_2022_2554_art_12_1), cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_3), cite(eu_reg_2022_2554_art_12_4), cite(eu_reg_2022_2554_art_12_5), cite(eu_reg_2022_2554_art_12_6), cite(eu_reg_2022_2554_art_12_7)]).

duty(ict_business_continuity_policy, has_ict_business_continuity_policy, cite(eu_reg_2022_2554_art_11_1), cite(eu_reg_2022_2554_art_11_1), []).
duty(continuity_policy_implementation_arrangements, continuity_policy_implemented_through_documented_arrangements, cite(eu_reg_2022_2554_art_11_2), cite(eu_reg_2022_2554_art_11_2), []).
duty(continuity_of_critical_or_important_functions, arrangements_ensure_continuity_of_critical_or_important_functions, cite(eu_reg_2022_2554_art_11_2_a), cite(eu_reg_2022_2554_art_11_2), []).
duty(incident_response_and_resolution, arrangements_respond_to_and_resolve_ict_related_incidents, cite(eu_reg_2022_2554_art_11_2_b), cite(eu_reg_2022_2554_art_11_2), []).
duty(activation_of_containment_plans, arrangements_activate_containment_plans_without_delay, cite(eu_reg_2022_2554_art_11_2_c), cite(eu_reg_2022_2554_art_11_2), []).
duty(estimation_of_impacts_damages_and_losses, arrangements_estimate_preliminary_impacts_damages_and_losses, cite(eu_reg_2022_2554_art_11_2_d), cite(eu_reg_2022_2554_art_11_2), []).
duty(communication_and_crisis_management_actions, arrangements_set_out_communication_and_crisis_management_actions, cite(eu_reg_2022_2554_art_11_2_e), cite(eu_reg_2022_2554_art_11_2), []).
duty(ict_response_and_recovery_plans, ict_response_and_recovery_plans_implemented, cite(eu_reg_2022_2554_art_11_3), cite(eu_reg_2022_2554_art_11_3), []).
duty(independent_internal_audit_review_of_response_and_recovery_plans, response_and_recovery_plans_subject_to_independent_internal_audit_reviews, cite(eu_reg_2022_2554_art_11_3), cite(eu_reg_2022_2554_art_11_3), [condition(financial_entity_is_microenterprise, false)]).
duty(ict_business_continuity_plans, ict_business_continuity_plans_in_place_maintained_and_periodically_tested, cite(eu_reg_2022_2554_art_11_4), cite(eu_reg_2022_2554_art_11_4), []).
duty(business_impact_analysis, business_impact_analysis_conducted, cite(eu_reg_2022_2554_art_11_5), cite(eu_reg_2022_2554_art_11_5), []).
duty(alignment_with_business_impact_analysis, ict_assets_and_services_aligned_with_business_impact_analysis, cite(eu_reg_2022_2554_art_11_5), cite(eu_reg_2022_2554_art_11_5), []).
duty(yearly_testing_of_continuity_and_response_and_recovery_plans, plans_tested_at_least_yearly_and_on_substantive_changes, cite(eu_reg_2022_2554_art_11_6_a), cite(eu_reg_2022_2554_art_11_6), []).
duty(testing_of_crisis_communication_plans, crisis_communication_plans_tested, cite(eu_reg_2022_2554_art_11_6_b), cite(eu_reg_2022_2554_art_11_6), []).
duty(cyber_attack_and_switchover_scenarios_in_testing_plans, testing_plans_include_cyber_attack_and_switchover_scenarios, cite(eu_reg_2022_2554_art_11_6), cite(eu_reg_2022_2554_art_11_6), [condition(financial_entity_is_microenterprise, false)]).
duty(regular_review_of_continuity_policy_and_plans, continuity_policy_and_plans_regularly_reviewed, cite(eu_reg_2022_2554_art_11_6), cite(eu_reg_2022_2554_art_11_6), []).
duty(crisis_management_function, has_crisis_management_function, cite(eu_reg_2022_2554_art_11_7), cite(eu_reg_2022_2554_art_11_7), [condition(financial_entity_is_microenterprise, false)]).
duty(records_of_activities_during_disruption_events, records_of_activities_during_disruption_events_kept, cite(eu_reg_2022_2554_art_11_8), cite(eu_reg_2022_2554_art_11_8), [condition(business_continuity_or_response_and_recovery_plans_activated, true)]).
duty(continuity_test_results_to_competent_authorities, continuity_test_results_provided_to_competent_authorities, cite(eu_reg_2022_2554_art_11_9), cite(eu_reg_2022_2554_art_11_9), [condition(dora_entity_type, central_securities_depository)]).
duty(estimate_of_aggregated_annual_costs_and_losses, estimate_of_aggregated_annual_costs_and_losses_reported, cite(eu_reg_2022_2554_art_11_10), cite(eu_reg_2022_2554_art_11_10), [condition(financial_entity_is_microenterprise, false), condition(authority_requested_estimate_of_annual_ict_incident_costs_and_losses, true)]).
duty(backup_policies_and_procedures, backup_policies_and_procedures_developed_and_documented, cite(eu_reg_2022_2554_art_12_1_a), cite(eu_reg_2022_2554_art_12_1), []).
duty(restoration_and_recovery_procedures_and_methods, restoration_and_recovery_procedures_and_methods_developed_and_documented, cite(eu_reg_2022_2554_art_12_1_b), cite(eu_reg_2022_2554_art_12_1), []).
duty(backup_systems, backup_systems_that_can_be_activated_set_up, cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_2), []).
duty(secure_activation_of_backup_systems, backup_activation_does_not_jeopardise_security, cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_2), []).
duty(periodic_testing_of_backup_and_restoration_procedures, backup_and_restoration_procedures_periodically_tested, cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_2), []).
duty(segregated_and_protected_restoration_systems, restoration_uses_segregated_and_protected_ict_systems, cite(eu_reg_2022_2554_art_12_3), cite(eu_reg_2022_2554_art_12_3), [condition(backup_data_restored_using_own_systems, true)]).
duty(recovery_of_all_transactions, recovery_plans_enable_recovery_of_all_transactions, cite(eu_reg_2022_2554_art_12_3), cite(eu_reg_2022_2554_art_12_3), [condition(dora_entity_type, central_counterparty)]).
duty(data_reporting_resources_and_facilities, adequate_resources_and_backup_and_restoration_facilities_maintained, cite(eu_reg_2022_2554_art_12_3), cite(eu_reg_2022_2554_art_12_3), [condition(dora_entity_type, data_reporting_service_provider)]).
duty(redundant_ict_capacities, redundant_ict_capacities_maintained, cite(eu_reg_2022_2554_art_12_4), cite(eu_reg_2022_2554_art_12_4), [condition(financial_entity_is_microenterprise, false)]).
duty(assessment_of_need_for_redundant_ict_capacities, need_for_redundant_ict_capacities_assessed, cite(eu_reg_2022_2554_art_12_4), cite(eu_reg_2022_2554_art_12_4), [condition(financial_entity_is_microenterprise, true)]).
duty(secondary_processing_site, secondary_processing_site_maintained, cite(eu_reg_2022_2554_art_12_5), cite(eu_reg_2022_2554_art_12_5), [condition(dora_entity_type, central_securities_depository)]).
duty(secondary_site_at_geographical_distance, secondary_site_located_at_geographical_distance, cite(eu_reg_2022_2554_art_12_5_a), cite(eu_reg_2022_2554_art_12_5), [condition(dora_entity_type, central_securities_depository)]).
duty(secondary_site_capable_of_ensuring_continuity, secondary_site_can_ensure_continuity_of_critical_or_important_functions, cite(eu_reg_2022_2554_art_12_5_b), cite(eu_reg_2022_2554_art_12_5), [condition(dora_entity_type, central_securities_depository)]).
duty(secondary_site_immediately_accessible, secondary_site_immediately_accessible_to_staff, cite(eu_reg_2022_2554_art_12_5_c), cite(eu_reg_2022_2554_art_12_5), [condition(dora_entity_type, central_securities_depository)]).
duty(recovery_time_and_recovery_point_objectives, recovery_time_and_point_objectives_take_criticality_and_market_impact_into_account, cite(eu_reg_2022_2554_art_12_6), cite(eu_reg_2022_2554_art_12_6), []).
duty(data_integrity_checks_when_recovering, data_integrity_checks_performed_when_recovering, cite(eu_reg_2022_2554_art_12_7), cite(eu_reg_2022_2554_art_12_7), [condition(recovered_from_ict_related_incident, true)]).
duty(data_consistency_checks_when_reconstructing_data, data_consistency_checks_performed_when_reconstructing_data, cite(eu_reg_2022_2554_art_12_7), cite(eu_reg_2022_2554_art_12_7), [condition(data_reconstructed_from_external_stakeholders, true)]).

ict_risk_response_and_recovery_duties_required(Profile, Result, Citations) :-
    order_answer(required, Profile, Result, Citations).

ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations) :-
    order_answer(complete, Profile, Result, Citations).

ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations) :-
    order_answer(outstanding, Profile, Result, Citations).

order_answer(Query, Profile, Result, Citations) :-
    dora_ict_risk_response_and_recovery_input_problems(Profile, Problems),
    answer_after_check(Problems, Query, Profile, Result, Citations).

answer_after_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
answer_after_check([], Query, Profile, Result, Citations) :-
    profile_states(Profile, States),
    gate_state(States, Gate),
    answer_after_gate(Gate, Query, States, Result, Citations).

answer_after_gate(present(true), _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
answer_after_gate(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
answer_after_gate(present(false), Query, States, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    evaluate_duties(States, Evaluations),
    query_answer(Query, States, Evaluations, Result, Citations).

query_answer(required, States, Evaluations, Result, Citations) :-
    required_answer(States, Evaluations, Result, Citations).
query_answer(complete, States, Evaluations, Result, Citations) :-
    complete_answer(States, Evaluations, Result, Citations).
query_answer(outstanding, States, Evaluations, Result, Citations) :-
    outstanding_answer(States, Evaluations, Result, Citations).

profile_states(Profile, States) :-
    profile_key_order(Keys),
    maplist(key_state_pair(Profile), Keys, States).

key_state_pair(Profile, Key, Key - State) :-
    key_state(Profile, Key, State).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

state_of(States, Key, State) :-
    member(Key - State, States).

gate_state(States, State) :-
    implements(eu_reg_2022_2554_art_16_1),
    state_of(States, financial_entity_is_article_16_1_entity, State).

present_pairs([], []).
present_pairs([_ - absent|States], Pairs) :-
    present_pairs(States, Pairs).
present_pairs([Key - present(Value)|States], [Key - Value|Pairs]) :-
    present_pairs(States, Pairs).

evaluate_duties(States, Evaluations) :-
    findall(duty(Atom, Key, Cite, Paragraph, Conditions), duty(Atom, Key, Cite, Paragraph, Conditions), Rows),
    maplist(evaluate_duty(States), Rows, Evaluations).

evaluate_duty(States, duty(Atom, Key, cite(CitationKey), Paragraph, Conditions), evaluated(Atom, Key, cite(CitationKey), Paragraph, Conditions, Statuses, Applicability, KeyState)) :-
    maplist(condition_status(States), Conditions, Statuses),
    applicability(Statuses, applies, Applicability),
    state_of(States, Key, KeyState).

condition_status(States, condition(Key, Value), condition(Key, Value) - Status) :-
    implements(eu_reg_2022_2554_art_3_60),
    Key == financial_entity_is_microenterprise,
    state_of(States, Key, State),
    condition_status_for(State, Value, Status).
condition_status(States, condition(Key, Value), condition(Key, Value) - Status) :-
    Key \== financial_entity_is_microenterprise,
    state_of(States, Key, State),
    condition_status_for(State, Value, Status).

condition_status_for(absent, _, open).
condition_status_for(present(Given), Value, holds) :-
    Given == Value.
condition_status_for(present(Given), Value, fails) :-
    Given \== Value.

applicability([], Applicability, Applicability).
applicability([_ - Status|Statuses], Current, Final) :-
    combine_applicability(Current, Status, Next),
    applicability(Statuses, Next, Final).

combine_applicability(applies, holds, applies).
combine_applicability(applies, open, pending).
combine_applicability(applies, fails, excluded).
combine_applicability(pending, holds, pending).
combine_applicability(pending, open, pending).
combine_applicability(pending, fails, excluded).
combine_applicability(excluded, _, excluded).

evaluated_atom(evaluated(Atom, _, _, _, _, _, _, _), Atom).

evaluated_key(evaluated(_, Key, _, _, _, _, _, _), Key).

evaluated_cite(evaluated(_, _, Cite, _, _, _, _, _), Cite).

evaluated_paragraph(evaluated(_, _, _, Paragraph, _, _, _, _), Paragraph).

evaluated_conditions(evaluated(_, _, _, _, Conditions, _, _, _), Conditions).

evaluated_statuses(evaluated(_, _, _, _, _, Statuses, _, _), Statuses).

evaluated_applicability(evaluated(_, _, _, _, _, _, Applicability, _), Applicability).

evaluated_key_state(evaluated(_, _, _, _, _, _, _, KeyState), KeyState).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

some_t(_, [], false).
some_t(Goal, [Element|Elements], Truth) :-
    call(Goal, Element, ElementTruth),
    some_t(Goal, Elements, RestTruth),
    truth_or(ElementTruth, RestTruth, Truth).

every_t(_, [], true).
every_t(Goal, [Element|Elements], Truth) :-
    call(Goal, Element, ElementTruth),
    every_t(Goal, Elements, RestTruth),
    truth_and(ElementTruth, RestTruth, Truth).

open_truth(applies, true).
open_truth(pending, true).
open_truth(excluded, false).

applies_truth(applies, true).
applies_truth(pending, false).
applies_truth(excluded, false).

not_true_truth(absent, true).
not_true_truth(present(true), false).
not_true_truth(present(false), true).
not_true_truth(present(unsure), true).

false_truth(absent, false).
false_truth(present(true), false).
false_truth(present(false), true).
false_truth(present(unsure), false).

absent_truth(absent, true).
absent_truth(present(_), false).

status_holds_truth(holds, true).
status_holds_truth(open, false).
status_holds_truth(fails, false).

open_status_t(_ - Status, Truth) :-
    open_status_truth(Status, Truth).

open_status_truth(open, true).
open_status_truth(holds, false).
open_status_truth(fails, false).

state_is_t(Wanted, State, true) :-
    State == Wanted.
state_is_t(Wanted, State, false) :-
    State \== Wanted.

same_condition_t(Condition, Other, true) :-
    Condition == Other.
same_condition_t(Condition, Other, false) :-
    Condition \== Other.

condition_on_t(Key, condition(ConditionKey, _), true) :-
    ConditionKey == Key.
condition_on_t(Key, condition(ConditionKey, _), false) :-
    ConditionKey \== Key.

condition_value_on([], _, none).
condition_value_on([condition(Key, Value)|_], Wanted, value(Value)) :-
    Key == Wanted.
condition_value_on([condition(Key, _)|Conditions], Wanted, Result) :-
    Key \== Wanted,
    condition_value_on(Conditions, Wanted, Result).

open_t(Evaluation, Truth) :-
    evaluated_applicability(Evaluation, Applicability),
    open_truth(Applicability, Truth).

applies_t(Evaluation, Truth) :-
    evaluated_applicability(Evaluation, Applicability),
    applies_truth(Applicability, Truth).

key_not_true_t(Evaluation, Truth) :-
    evaluated_key_state(Evaluation, State),
    not_true_truth(State, Truth).

key_false_t(Evaluation, Truth) :-
    evaluated_key_state(Evaluation, State),
    false_truth(State, Truth).

failing_t(Evaluation, Truth) :-
    applies_t(Evaluation, Applies),
    key_false_t(Evaluation, IsFalse),
    truth_and(Applies, IsFalse, Truth).

open_not_true_t(Evaluation, Truth) :-
    open_t(Evaluation, Open),
    key_not_true_t(Evaluation, NotTrue),
    truth_and(Open, NotTrue, Truth).

open_duty_conditioned_on_t(Key, Evaluation, Truth) :-
    open_t(Evaluation, Open),
    evaluated_conditions(Evaluation, Conditions),
    some_t(condition_on_t(Key), Conditions, ConditionedOn),
    truth_and(Open, ConditionedOn, Truth).

open_not_true_conditioned_on_t(Key, Evaluation, Truth) :-
    open_duty_conditioned_on_t(Key, Evaluation, ConditionedOn),
    key_not_true_t(Evaluation, NotTrue),
    truth_and(ConditionedOn, NotTrue, Truth).

open_key_in_state_t(Wanted, Evaluation, Truth) :-
    open_t(Evaluation, Open),
    evaluated_key_state(Evaluation, State),
    state_is_t(Wanted, State, InState),
    truth_and(Open, InState, Truth).

distinct_duty_t(Duty, Other, false) :-
    evaluated_atom(Duty, Atom),
    evaluated_atom(Other, OtherAtom),
    Atom == OtherAtom.
distinct_duty_t(Duty, Other, true) :-
    evaluated_atom(Duty, Atom),
    evaluated_atom(Other, OtherAtom),
    Atom \== OtherAtom.

other_condition_holds_t(Excluded, condition(Key, _) - _, true) :-
    Key == Excluded.
other_condition_holds_t(Excluded, condition(Key, _) - Status, Truth) :-
    Key \== Excluded,
    status_holds_truth(Status, Truth).

condition_covered_t(DutyConditions, Condition - Status, Truth) :-
    status_holds_truth(Status, Holds),
    some_t(same_condition_t(Condition), DutyConditions, Shared),
    truth_or(Holds, Shared, Truth).

other_condition_covered_t(Excluded, _, condition(Key, _) - _, true) :-
    Key == Excluded.
other_condition_covered_t(Excluded, DutyConditions, condition(Key, Value) - Status, Truth) :-
    Key \== Excluded,
    condition_covered_t(DutyConditions, condition(Key, Value) - Status, Truth).

required_answer(States, Evaluations, Result, Citations) :-
    condition_keys(Keys),
    tfilter(required_missing_key_t(States, Evaluations), Keys, Missing),
    required_route(Missing, Evaluations, Result, Citations).

required_missing_key_t(States, Evaluations, Key, Truth) :-
    state_of(States, Key, State),
    absent_truth(State, IsAbsent),
    some_t(open_duty_conditioned_on_t(Key), Evaluations, Carries),
    truth_and(IsAbsent, Carries, Truth).

required_route([Key|_], _, indeterminate([Key]), []).
required_route([], Evaluations, required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    tfilter(applies_t, Evaluations, Applying),
    maplist(evaluated_atom, Applying, Duties),
    maplist(evaluated_paragraph, Applying, Paragraphs),
    sort(Paragraphs, Citations).

complete_answer(States, Evaluations, Result, Citations) :-
    tfilter(failing_t, Evaluations, Failing),
    complete_after_failing(Failing, States, Evaluations, Result, Citations).

complete_after_failing([_|_], _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    fixed_citations(Citations).
complete_after_failing([], States, Evaluations, Result, Citations) :-
    size_split_t(States, Evaluations, Split),
    complete_after_split(Split, States, Evaluations, Result, Citations).

size_split_t(States, Evaluations, Truth) :-
    implements(eu_reg_2022_2554_art_3_60),
    state_of(States, financial_entity_is_microenterprise, State),
    absent_truth(State, IsAbsent),
    some_t(failing_for_size_t(true), Evaluations, ForMicroenterprise),
    some_t(failing_for_size_t(false), Evaluations, ForOther),
    truth_and(IsAbsent, ForMicroenterprise, First),
    truth_and(First, ForOther, Truth).

failing_for_size_t(Value, Evaluation, Truth) :-
    key_false_t(Evaluation, IsFalse),
    evaluated_conditions(Evaluation, Conditions),
    some_t(same_condition_t(condition(financial_entity_is_microenterprise, Value)), Conditions, HasCondition),
    evaluated_statuses(Evaluation, Statuses),
    every_t(other_condition_holds_t(financial_entity_is_microenterprise), Statuses, OthersHold),
    truth_and(IsFalse, HasCondition, First),
    truth_and(First, OthersHold, Truth).

complete_after_split(true, _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    fixed_citations(Citations).
complete_after_split(false, States, Evaluations, Result, Citations) :-
    tfilter(open_not_true_t, Evaluations, Unsettled),
    complete_after_unsettled(Unsettled, States, Evaluations, Result, Citations).

complete_after_unsettled([], _, _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    fixed_citations(Citations).
complete_after_unsettled([_|_], States, Evaluations, Result, Citations) :-
    change_candidates(States, Evaluations, Candidates),
    complete_after_candidates(Candidates, States, Evaluations, Result, Citations).

change_candidates(States, Evaluations, Candidates) :-
    condition_keys(Keys),
    tfilter(condition_key_can_change_t(States, Evaluations), Keys, ConditionKeys),
    maplist(condition_candidate(Evaluations), ConditionKeys, ConditionCandidates),
    tfilter(duty_key_can_change_t(Evaluations, absent), Evaluations, DutyEvaluations),
    maplist(duty_candidate, DutyEvaluations, DutyCandidates),
    append(ConditionCandidates, DutyCandidates, Candidates).

condition_candidate(Evaluations, Key, Key - DecidesAlone) :-
    some_t(condition_decides_alone_t(Key), Evaluations, DecidesAlone).

duty_candidate(Evaluation, Key - DecidesAlone) :-
    evaluated_key(Evaluation, Key),
    applies_t(Evaluation, DecidesAlone).

condition_decides_alone_t(Key, Evaluation, Truth) :-
    key_false_t(Evaluation, IsFalse),
    evaluated_conditions(Evaluation, Conditions),
    some_t(condition_on_t(Key), Conditions, ConditionedOn),
    evaluated_statuses(Evaluation, Statuses),
    every_t(other_condition_holds_t(Key), Statuses, OthersHold),
    truth_and(IsFalse, ConditionedOn, First),
    truth_and(First, OthersHold, Truth).

duty_key_can_change_t(Evaluations, Wanted, Duty, Truth) :-
    evaluated_key_state(Duty, State),
    state_is_t(Wanted, State, InState),
    open_t(Duty, Open),
    some_t(covering_blocker_t(Duty), Evaluations, Blocked),
    truth_not(Blocked, Unblocked),
    truth_and(InState, Open, First),
    truth_and(First, Unblocked, Truth).

covering_blocker_t(Duty, Other, Truth) :-
    distinct_duty_t(Duty, Other, Distinct),
    key_false_t(Other, IsFalse),
    evaluated_conditions(Duty, DutyConditions),
    evaluated_statuses(Other, OtherStatuses),
    every_t(condition_covered_t(DutyConditions), OtherStatuses, Covered),
    truth_and(Distinct, IsFalse, First),
    truth_and(First, Covered, Truth).

condition_key_can_change_t(States, Evaluations, Key, Truth) :-
    state_of(States, Key, State),
    absent_truth(State, IsAbsent),
    some_t(value_witness_t(Evaluations, Key), Evaluations, Witnessed),
    truth_and(IsAbsent, Witnessed, Truth).

value_witness_t(Evaluations, Key, Duty, Truth) :-
    open_t(Duty, Open),
    key_not_true_t(Duty, NotTrue),
    evaluated_conditions(Duty, Conditions),
    condition_value_on(Conditions, Key, ValueOnKey),
    alternative_exists_t(ValueOnKey, Evaluations, Key, Duty, Alternative),
    truth_and(Open, NotTrue, First),
    truth_and(First, Alternative, Truth).

alternative_exists_t(none, _, _, _, false).
alternative_exists_t(value(Value), Evaluations, Key, Duty, Truth) :-
    condition_values(Key, Values),
    some_t(unblocked_alternative_t(Evaluations, Key, Value, Duty), Values, Truth).

unblocked_alternative_t(_, _, Value, _, Alternative, false) :-
    Alternative == Value.
unblocked_alternative_t(Evaluations, Key, Value, Duty, Alternative, Truth) :-
    Alternative \== Value,
    some_t(alternative_blocker_t(Key, Alternative, Duty), Evaluations, Blocked),
    truth_not(Blocked, Truth).

alternative_blocker_t(Key, Alternative, Duty, Other, Truth) :-
    distinct_duty_t(Duty, Other, Distinct),
    key_false_t(Other, IsFalse),
    evaluated_conditions(Other, OtherConditions),
    condition_value_on(OtherConditions, Key, OtherOnKey),
    holds_for_alternative(OtherOnKey, Alternative, HoldsForAlternative),
    evaluated_conditions(Duty, DutyConditions),
    evaluated_statuses(Other, OtherStatuses),
    every_t(other_condition_covered_t(Key, DutyConditions), OtherStatuses, Covered),
    truth_and(Distinct, IsFalse, First),
    truth_and(First, HoldsForAlternative, Second),
    truth_and(Second, Covered, Truth).

holds_for_alternative(none, _, true).
holds_for_alternative(value(Value), Alternative, true) :-
    Value == Alternative.
holds_for_alternative(value(Value), Alternative, false) :-
    Value \== Alternative.

complete_after_candidates([Candidate|Candidates], _, _, indeterminate([Key]), []) :-
    tfilter(candidate_decides_alone_t, [Candidate|Candidates], Alone),
    named_candidate(Alone, [Candidate|Candidates], Key).
complete_after_candidates([], States, Evaluations, Result, Citations) :-
    tfilter(duty_key_can_change_t(Evaluations, present(unsure)), Evaluations, Referable),
    referral(Referable, States, Result, Citations).

candidate_decides_alone_t(_ - DecidesAlone, DecidesAlone).

named_candidate([Key - _|_], _, Key).
named_candidate([], [Key - _|_], Key).

referral([Evaluation|_], States, needs_legal_review(open_textured(Key, Cite), [inputs_relied_on(Pairs)]), []) :-
    evaluated_key(Evaluation, Key),
    evaluated_cite(Evaluation, Cite),
    present_pairs(States, Pairs).

outstanding_answer(States, Evaluations, Result, Citations) :-
    condition_keys(Keys),
    tfilter(list_condition_key_t(States, Evaluations), Keys, ConditionMissing),
    tfilter(open_key_in_state_t(absent), Evaluations, DutyMissing),
    maplist(evaluated_key, DutyMissing, DutyMissingKeys),
    append(ConditionMissing, DutyMissingKeys, Missing),
    outstanding_after_missing(Missing, States, Evaluations, Result, Citations).

list_condition_key_t(States, Evaluations, Key, Truth) :-
    state_of(States, Key, State),
    absent_truth(State, IsAbsent),
    some_t(open_not_true_conditioned_on_t(Key), Evaluations, Matters),
    truth_and(IsAbsent, Matters, Truth).

outstanding_after_missing([Key|_], _, _, indeterminate([Key]), []).
outstanding_after_missing([], States, Evaluations, Result, Citations) :-
    tfilter(open_key_in_state_t(present(unsure)), Evaluations, Unsure),
    outstanding_after_unsure(Unsure, States, Evaluations, Result, Citations).

outstanding_after_unsure([Evaluation|Evaluations], States, _, Result, Citations) :-
    referral([Evaluation|Evaluations], States, Result, Citations).
outstanding_after_unsure([], _, Evaluations, Result, Citations) :-
    tfilter(failing_t, Evaluations, Failing),
    outstanding_final(Failing, Result, Citations).

outstanding_final([], none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    fixed_citations(Citations).
outstanding_final([Evaluation|Evaluations], outstanding(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_11_1),
    maplist(evaluated_atom, [Evaluation|Evaluations], Duties),
    maplist(evaluated_cite, [Evaluation|Evaluations], Cites),
    sort(Cites, Citations).

decide_dora_ict_risk_response_and_recovery(Profile, dora_ict_risk_response_and_recovery_verdict(Status, Citations)) :-
    ict_risk_response_and_recovery_duties_complete(Profile, Status, Citations).

dora_ict_risk_response_and_recovery_status(Profile, Status) :-
    decide_dora_ict_risk_response_and_recovery(Profile, dora_ict_risk_response_and_recovery_verdict(Status, _Citations)).

dora_ict_risk_response_and_recovery_checklist(Profile, Items) :-
    dora_ict_risk_response_and_recovery_input_problems(Profile, []),
    profile_states(Profile, States),
    gate_state(States, Gate),
    checklist_after_gate(Gate, States, Items).

checklist_after_gate(present(true), _, Items) :-
    implements(eu_reg_2022_2554_art_16_1),
    findall(item(Atom, inapplicable, cite(eu_reg_2022_2554_art_16_1)), duty(Atom, _, _, _, _), Items).
checklist_after_gate(absent, _, Items) :-
    findall(item(Atom, unknown([financial_entity_is_article_16_1_entity]), Cite), duty(Atom, _, Cite, _, _), Items).
checklist_after_gate(present(false), States, Items) :-
    evaluate_duties(States, Evaluations),
    maplist(checklist_item, Evaluations, Items).

checklist_item(Evaluation, item(Atom, Status, Cite)) :-
    evaluated_atom(Evaluation, Atom),
    evaluated_cite(Evaluation, Cite),
    evaluated_applicability(Evaluation, Applicability),
    evaluated_key_state(Evaluation, KeyState),
    evaluated_key(Evaluation, Key),
    evaluated_statuses(Evaluation, Statuses),
    checklist_status(Applicability, KeyState, Key, Statuses, Status).

checklist_status(excluded, _, _, _, inapplicable).
checklist_status(applies, present(true), _, _, met).
checklist_status(applies, present(false), _, _, unmet(duty_not_performed)).
checklist_status(applies, present(unsure), Key, _, unknown([Key])).
checklist_status(applies, absent, Key, _, unknown([Key])).
checklist_status(pending, _, _, Statuses, unknown(Keys)) :-
    tfilter(open_status_t, Statuses, OpenStatuses),
    maplist(status_condition_key, OpenStatuses, Keys).

status_condition_key(condition(Key, _) - _, Key).

dora_ict_risk_response_and_recovery_decision_resolvable(Profile) :-
    decide_dora_ict_risk_response_and_recovery(Profile, _Verdict).

test_duty_keys(Keys) :-
    findall(Key, duty(_, Key, _, _, _), Keys).

test_attribute(Value, Key, attribute(Key, Value)).

test_base_profile(Profile) :-
    test_duty_keys(Keys),
    maplist(test_attribute(true), Keys, Duties),
    append([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(business_continuity_or_response_and_recovery_plans_activated, false), attribute(authority_requested_estimate_of_annual_ict_incident_costs_and_losses, false), attribute(backup_data_restored_using_own_systems, false), attribute(recovered_from_ict_related_incident, false), attribute(data_reconstructed_from_external_stakeholders, false)], Duties, Profile).

test_set([], _, _, []).
test_set([attribute(Key, _)|Attributes], Wanted, New, [attribute(Key, New)|Rest]) :-
    Key == Wanted,
    test_set(Attributes, Wanted, New, Rest).
test_set([attribute(Key, Value)|Attributes], Wanted, New, [attribute(Key, Value)|Rest]) :-
    Key \== Wanted,
    test_set(Attributes, Wanted, New, Rest).

test(gate_true_is_simplified_framework_entity) :-
    ict_risk_response_and_recovery_duties_required([attribute(financial_entity_is_article_16_1_entity, true)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_response_and_recovery_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_response_and_recovery_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_absent_is_named_first) :-
    ict_risk_response_and_recovery_duties_complete([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(every_duty_performed_is_complete) :-
    test_base_profile(Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, Citations),
    length(Citations, 17).
test(every_duty_performed_is_none_outstanding) :-
    test_base_profile(Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 17).
test(a_false_policy_is_incomplete) :-
    test_base_profile(Base),
    test_set(Base, has_ict_business_continuity_policy, false, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, incomplete, _).
test(a_false_policy_is_outstanding) :-
    test_base_profile(Base),
    test_set(Base, has_ict_business_continuity_policy, false, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([ict_business_continuity_policy]), [cite(eu_reg_2022_2554_art_11_1)]).
test(a_large_credit_institution_has_twenty_four_duties) :-
    test_base_profile(Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 24).
test(a_microenterprise_is_not_asked_the_cost_request) :-
    ict_risk_response_and_recovery_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, true), attribute(dora_entity_type, credit_institution), attribute(business_continuity_or_response_and_recovery_plans_activated, false), attribute(backup_data_restored_using_own_systems, false), attribute(recovered_from_ict_related_incident, false), attribute(data_reconstructed_from_external_stakeholders, false)], required(Duties), _),
    length(Duties, 21).
test(required_asks_the_size_first) :-
    ict_risk_response_and_recovery_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([financial_entity_is_microenterprise]), []).
test(complete_asks_the_first_applying_duty_first) :-
    ict_risk_response_and_recovery_duties_complete([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([has_ict_business_continuity_policy]), []).
test(outstanding_asks_the_size_first) :-
    ict_risk_response_and_recovery_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([financial_entity_is_microenterprise]), []).
test(each_size_failing_is_incomplete) :-
    ict_risk_response_and_recovery_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(redundant_ict_capacities_maintained, false), attribute(need_for_redundant_ict_capacities_assessed, false)], incomplete, _).
test(an_unsure_judgement_is_referred) :-
    test_base_profile(Base),
    test_set(Base, has_ict_business_continuity_policy, unsure, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, needs_legal_review(open_textured(has_ict_business_continuity_policy, cite(eu_reg_2022_2554_art_11_1)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 45).
test(an_unknown_key_is_an_input_problem) :-
    ict_risk_response_and_recovery_duties_complete([attribute(no_such_key, true)], input_problems([unknown_key(no_such_key)]), []).
test(each_query_answers_once) :-
    test_base_profile(Profile),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1).
test(the_checklist_has_a_row_per_duty) :-
    test_base_profile(Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, Items),
    length(Items, 37).

test(gate_absent_is_not_complete, fail) :-
    ict_risk_response_and_recovery_duties_complete([], complete, _).
test(a_false_policy_is_not_complete, fail) :-
    test_base_profile(Base),
    test_set(Base, has_ict_business_continuity_policy, false, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, _).
