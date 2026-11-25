% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_queries, [dora_rts_ict_operations_and_capacity_profile_keys/1, dora_rts_ict_operations_and_capacity_what_if/4, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, unsure/0]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_kernel, [dora_rts_ict_operations_and_capacity_input_problems/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_dora_rts_ict_operations_and_capacity, [rts_ict_operations_and_capacity_duties_complete/3, dora_rts_ict_operations_and_capacity_status/2, dora_rts_ict_operations_and_capacity_checklist/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_fixtures, [dora_rts_ict_operations_and_capacity_profile_for/2]).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_ict_operations_and_capacity_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, development_or_testing_performed_in_production_environment, ict_operations_policies_and_procedures_developed_documented_and_implemented, ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets, ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems, ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets, ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems, ict_operations_policies_cover_backup_and_restore_requirements, ict_operations_policies_cover_scheduling_requirements_considering_interdependencies, ict_operations_policies_cover_audit_trail_and_system_log_protocols, ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption, ict_operations_policies_cover_separation_of_production_from_non_production_environments, ict_operations_policies_cover_development_and_testing_in_separated_environments, ict_operations_policies_cover_development_and_testing_in_production_environments, ict_operations_policies_cover_error_handling_procedures_and_protocols, ict_operations_policies_cover_support_and_escalation_contacts, ict_operations_policies_cover_restart_rollback_and_recovery_procedures, environment_separation_considers_all_components_of_the_environment, production_testing_instances_identified_reasoned_time_limited_and_approved, security_of_ict_systems_and_production_data_ensured_during_production_testing, capacity_and_performance_management_procedures_developed_documented_and_implemented, capacity_procedures_identify_capacity_requirements_of_ict_systems, capacity_procedures_apply_resource_optimisation, capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems, capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems, capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages, capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems].
test(the_profile_keys_hold_twenty_seven_distinct_keys) :-
    dora_rts_ict_operations_and_capacity_profile_keys(ProfileKeys),
    length(ProfileKeys, 27),
    sort(ProfileKeys, Unique),
    length(Unique, 27).
test(the_compliance_check_answers_complete_for_the_baseline) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, complete, _).
test(the_compliance_check_answers_incomplete_for_a_failing_duty) :-
    dora_rts_ict_operations_and_capacity_profile_for(one_duty_not_performed, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, incomplete, _).
test(the_status_projection_answers_the_simplified_framework) :-
    dora_rts_ict_operations_and_capacity_profile_for(article_16_1_entity, Profile),
    dora_rts_ict_operations_and_capacity_status(Profile, simplified_framework_entity).
test(the_justification_checklist_cites_each_item) :-
    dora_rts_ict_operations_and_capacity_profile_for(production_security_not_ensured, Profile),
    dora_rts_ict_operations_and_capacity_checklist(Profile, Items),
    maplist(cited_item, Items),
    member(item(security_during_production_testing, unmet(not_performed), cite(eu_reg_2024_1774_art_8_2)), Items).
test(what_if_a_duty_not_performed_makes_the_baseline_incomplete) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, ict_operations_policies_cover_backup_and_restore_requirements, false, incomplete).
test(what_if_the_unstated_duty_is_performed) :-
    dora_rts_ict_operations_and_capacity_profile_for(one_duty_unstated, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, capacity_procedures_apply_resource_optimisation, true, complete).
test(what_if_the_unstated_gate_is_true) :-
    dora_rts_ict_operations_and_capacity_profile_for(gate_not_stated, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_production_brings_in_the_security_duty) :-
    dora_rts_ict_operations_and_capacity_profile_for(no_production_security_not_ensured, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, development_or_testing_performed_in_production_environment, true, incomplete).
test(what_if_an_unknown_key_is_added) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, office_colour, blue, input_problems([unknown_key(office_colour)])).
test(what_if_is_deterministic) :-
    dora_rts_ict_operations_and_capacity_profile_for(one_duty_unsure, Profile),
    findall(Status, dora_rts_ict_operations_and_capacity_what_if(Profile, capacity_procedures_apply_resource_optimisation, true, Status), [complete]).
test(what_if_leaves_the_original_profile_alone) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, ict_operations_policies_cover_backup_and_restore_requirements, false, incomplete),
    dora_rts_ict_operations_and_capacity_status(Profile, complete).
test(the_input_check_is_reexported) :-
    dora_rts_ict_operations_and_capacity_input_problems([], []).
test(the_result_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    simplified_framework_entity,
    unsure.

test(what_if_a_performed_duty_does_not_flip_the_baseline, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    dora_rts_ict_operations_and_capacity_what_if(Profile, ict_operations_policies_cover_backup_and_restore_requirements, true, incomplete).

cp_test_names([profile_keys_are_the_contract_keys, the_profile_keys_hold_twenty_seven_distinct_keys, the_compliance_check_answers_complete_for_the_baseline, the_compliance_check_answers_incomplete_for_a_failing_duty, the_status_projection_answers_the_simplified_framework, the_justification_checklist_cites_each_item, what_if_a_duty_not_performed_makes_the_baseline_incomplete, what_if_the_unstated_duty_is_performed, what_if_the_unstated_gate_is_true, what_if_production_brings_in_the_security_duty, what_if_an_unknown_key_is_added, what_if_is_deterministic, what_if_leaves_the_original_profile_alone, the_input_check_is_reexported, the_result_atoms_are_defined]).
cp_test_fail_names([what_if_a_performed_duty_does_not_flip_the_baseline]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
