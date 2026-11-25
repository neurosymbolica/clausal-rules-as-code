% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_subject/1, dora_rts_continuity_testing_and_recovery_profile_for/2, dora_rts_continuity_testing_and_recovery_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_dora_rts_continuity_testing_and_recovery, [decide_dora_rts_continuity_testing_and_recovery/2]).

dora_rts_continuity_testing_and_recovery_subject(article_16_entity_all_performed).
dora_rts_continuity_testing_and_recovery_subject(credit_institution_all_performed).
dora_rts_continuity_testing_and_recovery_subject(gate_absent).
dora_rts_continuity_testing_and_recovery_subject(gate_unsure_is_wrong_type).
dora_rts_continuity_testing_and_recovery_subject(gate_false_alone).
dora_rts_continuity_testing_and_recovery_subject(credit_institution_first_duty_false).
dora_rts_continuity_testing_and_recovery_subject(microenterprise_without_providers_all_performed).
dora_rts_continuity_testing_and_recovery_subject(microenterprise_switchover_false).
dora_rts_continuity_testing_and_recovery_subject(non_microenterprise_switchover_false).
dora_rts_continuity_testing_and_recovery_subject(central_counterparty_all_performed).
dora_rts_continuity_testing_and_recovery_subject(central_counterparty_involvement_false).
dora_rts_continuity_testing_and_recovery_subject(central_securities_depository_involvement_false).
dora_rts_continuity_testing_and_recovery_subject(credit_institution_depository_involvement_false).
dora_rts_continuity_testing_and_recovery_subject(provider_user_continuity_measures_false).
dora_rts_continuity_testing_and_recovery_subject(no_provider_continuity_measures_false).
dora_rts_continuity_testing_and_recovery_subject(trigger_absent_provider_testing_false).
dora_rts_continuity_testing_and_recovery_subject(trigger_true_provider_testing_false).
dora_rts_continuity_testing_and_recovery_subject(first_duty_absent_and_trigger_absent).
dora_rts_continuity_testing_and_recovery_subject(unsure_alternative_options).
dora_rts_continuity_testing_and_recovery_subject(unsure_alternative_options_with_false_duty).
dora_rts_continuity_testing_and_recovery_subject(duplicate_and_unknown_key).
dora_rts_continuity_testing_and_recovery_subject(profile_not_a_list).

dora_rts_continuity_testing_and_recovery_profile_for(article_16_entity_all_performed, Profile) :-
    performed_profile(true, false, credit_institution, true, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile) :-
    performed_profile(false, false, credit_institution, true, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(gate_absent, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    without_key(BaseProfile, financial_entity_is_article_16_1_entity, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(gate_unsure_is_wrong_type, [attribute(financial_entity_is_article_16_1_entity, unsure)]).
dora_rts_continuity_testing_and_recovery_profile_for(gate_false_alone, [attribute(financial_entity_is_article_16_1_entity, false)]).
dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(microenterprise_without_providers_all_performed, Profile) :-
    performed_profile(false, true, credit_institution, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(microenterprise_switchover_false, Profile) :-
    performed_profile(false, true, credit_institution, false, BaseProfile),
    with_value(BaseProfile, continuity_testing_contains_switchover_scenarios, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(non_microenterprise_switchover_false, Profile) :-
    performed_profile(false, false, credit_institution, false, BaseProfile),
    with_value(BaseProfile, continuity_testing_contains_switchover_scenarios, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(central_counterparty_all_performed, Profile) :-
    performed_profile(false, false, central_counterparty, true, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(central_counterparty_involvement_false, Profile) :-
    performed_profile(false, false, central_counterparty, true, BaseProfile),
    with_value(BaseProfile, continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(central_securities_depository_involvement_false, Profile) :-
    performed_profile(false, false, central_securities_depository, true, BaseProfile),
    with_value(BaseProfile, continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_depository_involvement_false, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(provider_user_continuity_measures_false, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(no_provider_continuity_measures_false, Profile) :-
    performed_profile(false, false, credit_institution, false, BaseProfile),
    with_value(BaseProfile, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(trigger_absent_provider_testing_false, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    without_key(BaseProfile, financial_entity_uses_ict_services_of_ict_third_party_service_providers, WithoutTrigger),
    with_value(WithoutTrigger, continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(trigger_true_provider_testing_false, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(first_duty_absent_and_trigger_absent, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    without_key(BaseProfile, financial_entity_uses_ict_services_of_ict_third_party_service_providers, WithoutTrigger),
    without_key(WithoutTrigger, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, WithoutFirstDuty),
    with_value(WithoutFirstDuty, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented, unsure, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(unsure_alternative_options, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, unsure, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(unsure_alternative_options_with_false_duty, Profile) :-
    performed_profile(false, false, credit_institution, true, BaseProfile),
    with_value(BaseProfile, response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, unsure, UnsureProfile),
    with_value(UnsureProfile, continuity_test_results_documented, false, Profile).
dora_rts_continuity_testing_and_recovery_profile_for(duplicate_and_unknown_key, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, true), attribute(unlisted_key, 1)]).
dora_rts_continuity_testing_and_recovery_profile_for(profile_not_a_list, not_an_attribute_list).

duty_keys([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, continuity_testing_assesses_continuity_of_critical_or_important_functions, continuity_testing_based_on_scenarios_including_severe_but_plausible_scenarios, continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, continuity_testing_contains_switchover_scenarios, continuity_testing_challenges_assumptions_of_business_continuity_plans, continuity_testing_contains_procedures_to_verify_ability_to_respond, continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions, continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, continuity_test_results_documented, continuity_test_deficiencies_analysed_addressed_and_reported_to_management_body, response_and_recovery_plans_take_into_account_business_impact_analysis, response_and_recovery_plans_specify_activation_and_deactivation_conditions_and_exceptions, response_and_recovery_plans_describe_actions_for_ict_systems_and_services_supporting_critical_or_important_functions, response_and_recovery_plans_designed_to_meet_recovery_objectives, response_and_recovery_plans_documented_available_and_accessible_with_roles_and_responsibilities, response_and_recovery_plans_provide_short_term_and_long_term_recovery_options, response_and_recovery_plans_lay_down_objectives_and_conditions_of_successful_execution, response_and_recovery_plans_identify_relevant_scenarios, response_and_recovery_plans_develop_scenarios_on_current_threat_information_and_lessons_learned, listed_disruption_scenarios_duly_taken_into_account, response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented]).

performed_profile(GateValue, MicroenterpriseValue, EntityType, TriggerValue, Profile) :-
    duty_keys(DutyKeys),
    maplist(performed_attribute, DutyKeys, DutyAttributes),
    append([attribute(financial_entity_is_article_16_1_entity, GateValue), attribute(financial_entity_is_microenterprise, MicroenterpriseValue), attribute(dora_entity_type, EntityType), attribute(financial_entity_uses_ict_services_of_ict_third_party_service_providers, TriggerValue)], DutyAttributes, Profile).

performed_attribute(DutyKey, attribute(DutyKey, true)).

with_value([], _, _, []).
with_value([attribute(AttributeKey, _)|LaterAttributes], WantedKey, NewValue, [attribute(AttributeKey, NewValue)|Changed]) :-
    AttributeKey == WantedKey,
    with_value(LaterAttributes, WantedKey, NewValue, Changed).
with_value([attribute(AttributeKey, OldValue)|LaterAttributes], WantedKey, NewValue, [attribute(AttributeKey, OldValue)|Changed]) :-
    AttributeKey \== WantedKey,
    with_value(LaterAttributes, WantedKey, NewValue, Changed).

without_key([], _, []).
without_key([attribute(AttributeKey, _)|LaterAttributes], WantedKey, Changed) :-
    AttributeKey == WantedKey,
    without_key(LaterAttributes, WantedKey, Changed).
without_key([attribute(AttributeKey, AttributeValue)|LaterAttributes], WantedKey, [attribute(AttributeKey, AttributeValue)|Changed]) :-
    AttributeKey \== WantedKey,
    without_key(LaterAttributes, WantedKey, Changed).

dora_rts_continuity_testing_and_recovery_assess(Subject, Result) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    decide_dora_rts_continuity_testing_and_recovery(Profile, Result).
