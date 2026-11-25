% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_fixtures, [dora_rts_ict_operations_and_capacity_subject/1, dora_rts_ict_operations_and_capacity_profile_for/2, dora_rts_ict_operations_and_capacity_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_dora_rts_ict_operations_and_capacity, [decide_dora_rts_ict_operations_and_capacity/2]).

dora_rts_ict_operations_and_capacity_subject(article_16_1_entity).
dora_rts_ict_operations_and_capacity_subject(every_duty_performed_without_production).
dora_rts_ict_operations_and_capacity_subject(gate_not_stated).
dora_rts_ict_operations_and_capacity_subject(one_duty_not_performed).
dora_rts_ict_operations_and_capacity_subject(every_duty_performed_with_production).
dora_rts_ict_operations_and_capacity_subject(production_security_not_ensured).
dora_rts_ict_operations_and_capacity_subject(no_production_security_not_ensured).
dora_rts_ict_operations_and_capacity_subject(production_unstated_security_not_ensured).
dora_rts_ict_operations_and_capacity_subject(production_unstated_security_ensured).
dora_rts_ict_operations_and_capacity_subject(one_duty_unstated).
dora_rts_ict_operations_and_capacity_subject(one_duty_unsure).
dora_rts_ict_operations_and_capacity_subject(failing_duty_with_others_unstated).
dora_rts_ict_operations_and_capacity_subject(repeated_gate).
dora_rts_ict_operations_and_capacity_subject(gate_given_unsure).
dora_rts_ict_operations_and_capacity_subject(unknown_key_given).

dora_rts_ict_operations_and_capacity_profile_for(todo_baseline_subject, Profile) :-
    fixture_baseline(false, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(article_16_1_entity, Profile) :-
    fixture_baseline(true, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile) :-
    fixture_baseline(false, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(gate_not_stated, Profile) :-
    fixture_baseline(false, false, Start),
    fixture_remove_key(Start, financial_entity_is_article_16_1_entity, Profile).
dora_rts_ict_operations_and_capacity_profile_for(one_duty_not_performed, Profile) :-
    fixture_baseline(false, false, Start),
    fixture_set_key(Start, ict_operations_policies_cover_backup_and_restore_requirements, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_with_production, Profile) :-
    fixture_baseline(false, true, Profile).
dora_rts_ict_operations_and_capacity_profile_for(production_security_not_ensured, Profile) :-
    fixture_baseline(false, true, Start),
    fixture_set_key(Start, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(no_production_security_not_ensured, Profile) :-
    fixture_baseline(false, false, Start),
    fixture_set_key(Start, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(production_unstated_security_not_ensured, Profile) :-
    fixture_baseline(false, true, Start),
    fixture_remove_key(Start, development_or_testing_performed_in_production_environment, WithoutTrigger),
    fixture_set_key(WithoutTrigger, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(production_unstated_security_ensured, Profile) :-
    fixture_baseline(false, true, Start),
    fixture_remove_key(Start, development_or_testing_performed_in_production_environment, Profile).
dora_rts_ict_operations_and_capacity_profile_for(one_duty_unstated, Profile) :-
    fixture_baseline(false, false, Start),
    fixture_remove_key(Start, capacity_procedures_apply_resource_optimisation, Profile).
dora_rts_ict_operations_and_capacity_profile_for(one_duty_unsure, Profile) :-
    fixture_baseline(false, false, Start),
    fixture_set_key(Start, capacity_procedures_apply_resource_optimisation, unsure, Profile).
dora_rts_ict_operations_and_capacity_profile_for(failing_duty_with_others_unstated, Profile) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(capacity_procedures_apply_resource_optimisation, false)].
dora_rts_ict_operations_and_capacity_profile_for(repeated_gate, [attribute(financial_entity_is_article_16_1_entity, false)|Rest]) :-
    fixture_baseline(false, false, Rest).
dora_rts_ict_operations_and_capacity_profile_for(gate_given_unsure, Profile) :-
    fixture_baseline(unsure, false, Profile).
dora_rts_ict_operations_and_capacity_profile_for(unknown_key_given, Profile) :-
    fixture_baseline(false, false, Start),
    append(Start, [attribute(office_colour, blue)], Profile).

dora_rts_ict_operations_and_capacity_assess(Subject, Result) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    decide_dora_rts_ict_operations_and_capacity(Profile, Result).

fixture_duty_keys([ict_operations_policies_and_procedures_developed_documented_and_implemented, ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets, ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems, ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets, ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems, ict_operations_policies_cover_backup_and_restore_requirements, ict_operations_policies_cover_scheduling_requirements_considering_interdependencies, ict_operations_policies_cover_audit_trail_and_system_log_protocols, ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption, ict_operations_policies_cover_separation_of_production_from_non_production_environments, ict_operations_policies_cover_development_and_testing_in_separated_environments, ict_operations_policies_cover_development_and_testing_in_production_environments, ict_operations_policies_cover_error_handling_procedures_and_protocols, ict_operations_policies_cover_support_and_escalation_contacts, ict_operations_policies_cover_restart_rollback_and_recovery_procedures, environment_separation_considers_all_components_of_the_environment, production_testing_instances_identified_reasoned_time_limited_and_approved, security_of_ict_systems_and_production_data_ensured_during_production_testing, capacity_and_performance_management_procedures_developed_documented_and_implemented, capacity_procedures_identify_capacity_requirements_of_ict_systems, capacity_procedures_apply_resource_optimisation, capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems, capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems, capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages, capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems]).

fixture_baseline(GateValue, TriggerValue, Profile) :-
    fixture_duty_keys(DutyKeys),
    findall(attribute(Key, true), member(Key, DutyKeys), DutyAttributes),
    Profile = [attribute(financial_entity_is_article_16_1_entity, GateValue), attribute(development_or_testing_performed_in_production_environment, TriggerValue)|DutyAttributes].

fixture_remove_key([], _, []).
fixture_remove_key([attribute(Key, _)|Rest], Key, Remaining) :-
    fixture_remove_key(Rest, Key, Remaining).
fixture_remove_key([attribute(Other, Value)|Rest], Key, [attribute(Other, Value)|Remaining]) :-
    dif(Other, Key),
    fixture_remove_key(Rest, Key, Remaining).

fixture_set_key([], _, _, []).
fixture_set_key([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Changed]) :-
    fixture_set_key(Rest, Key, Value, Changed).
fixture_set_key([attribute(Other, OldValue)|Rest], Key, Value, [attribute(Other, OldValue)|Changed]) :-
    dif(Other, Key),
    fixture_set_key(Rest, Key, Value, Changed).
