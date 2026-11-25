% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_queries, [dora_rts_logging_and_network_security_profile_keys/1, dora_rts_logging_and_network_security_what_if/4]).
:- use_module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [dora_rts_logging_and_network_security_status/2, dora_rts_logging_and_network_security_checklist/2, rts_logging_and_network_security_duties_complete/3]).
:- use_module(m__eu_dora_rts_logging_and_network_security_fixtures, [dora_rts_logging_and_network_security_profile_for/2]).

true_attribute(ProfileKey, attribute(ProfileKey, true)).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_logging_and_network_security_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, financial_entity_has_ict_systems_supporting_critical_or_important_functions, logging_procedures_protocols_and_tools_developed_documented_and_implemented, logging_procedures_identify_logged_events_retention_and_log_data_security, logging_detail_aligned_with_purpose_and_usage, logging_covers_access_control_and_identity_management_events, logging_covers_capacity_management_events, logging_covers_change_management_events, logging_covers_ict_operations_events, logging_covers_network_traffic_events, logging_systems_and_log_information_protected, logging_system_failure_detection_measures_in_place, ict_system_clocks_synchronised_to_reliable_reference_time_source, log_retention_period_established_taking_into_account_required_considerations, network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, network_connections_and_data_flows_documented, separate_dedicated_administration_network_used, network_access_controls_identified_and_implemented, network_connections_encrypted, networks_designed_in_line_with_ict_security_requirements, traffic_to_internet_and_external_connections_secured, firewall_rules_roles_responsibilities_and_steps_identified, network_architecture_and_security_design_reviewed_once_a_year, network_architecture_and_security_design_reviewed_periodically, subnetworks_and_network_components_isolation_measures_in_place, secure_network_configuration_baseline_and_hardening_implemented, inactive_system_and_remote_sessions_limited_locked_and_terminated, network_services_security_measures_and_service_levels_specified, network_services_provider_type_identified, firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, data_protected_during_network_transmission_with_compliance_assessment, data_leakage_prevented_and_detected_and_external_transfer_secured, confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, information_in_transit_policies_designed_on_classification_and_risk_assessment].
test(every_schema_key_is_accepted_by_the_input_check) :-
    dora_rts_logging_and_network_security_profile_keys(ProfileKeys),
    maplist(true_attribute, ProfileKeys, Profile),
    dora_rts_logging_and_network_security_input_problems(Profile, Problems),
    Problems == [].
test(the_re_exported_input_check_refuses_a_non_list) :-
    dora_rts_logging_and_network_security_input_problems(profile, [wrong_type(profile)]).
test(compliance_check_a_performing_entity_complies) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    rts_logging_and_network_security_duties_complete(Profile, complete, _),
    dora_rts_logging_and_network_security_status(Profile, complete).
test(justification_every_checklist_item_carries_a_citation) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    dora_rts_logging_and_network_security_checklist(Profile, Items),
    findall(DutyAtom, member(item(DutyAtom, _, [cite(_)|_]), Items), CitedDuties),
    length(CitedDuties, 35).
test(what_if_a_duty_turns_false_the_duties_are_incomplete) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    dora_rts_logging_and_network_security_what_if(Profile, network_connections_encrypted, false, incomplete).
test(what_if_the_entity_were_a_microenterprise_the_yearly_review_is_not_owed) :-
    dora_rts_logging_and_network_security_profile_for(yearly_review_not_performed_larger_entity, Profile),
    dora_rts_logging_and_network_security_status(Profile, incomplete),
    dora_rts_logging_and_network_security_what_if(Profile, financial_entity_is_microenterprise, true, complete).
test(what_if_an_absent_gate_is_given) :-
    dora_rts_logging_and_network_security_profile_for(gate_not_stated, Profile),
    dora_rts_logging_and_network_security_what_if(Profile, financial_entity_is_article_16_1_entity, false, complete),
    dora_rts_logging_and_network_security_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_a_badly_typed_value_is_an_input_problem) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    dora_rts_logging_and_network_security_what_if(Profile, financial_entity_is_article_16_1_entity, unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(what_if_answers_exactly_once) :-
    dora_rts_logging_and_network_security_profile_for(encryption_unsure, Profile),
    findall(NewStatus, dora_rts_logging_and_network_security_what_if(Profile, network_connections_encrypted, true, NewStatus), NewStatuses),
    NewStatuses == [complete].
test(what_if_leaves_the_original_profile_unchanged) :-
    dora_rts_logging_and_network_security_profile_for(encryption_unsure, Profile),
    dora_rts_logging_and_network_security_what_if(Profile, network_connections_encrypted, false, incomplete),
    dora_rts_logging_and_network_security_status(Profile, needs_legal_review(_, _)).

test(compliance_check_a_failed_duty_does_not_comply, fail) :-
    dora_rts_logging_and_network_security_profile_for(encryption_not_performed_larger_entity, Profile),
    rts_logging_and_network_security_duties_complete(Profile, complete, _).

cp_test_names([profile_keys_are_the_contract_keys, every_schema_key_is_accepted_by_the_input_check, the_re_exported_input_check_refuses_a_non_list, compliance_check_a_performing_entity_complies, justification_every_checklist_item_carries_a_citation, what_if_a_duty_turns_false_the_duties_are_incomplete, what_if_the_entity_were_a_microenterprise_the_yearly_review_is_not_owed, what_if_an_absent_gate_is_given, what_if_a_badly_typed_value_is_an_input_problem, what_if_answers_exactly_once, what_if_leaves_the_original_profile_unchanged]).
cp_test_fail_names([compliance_check_a_failed_duty_does_not_comply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
