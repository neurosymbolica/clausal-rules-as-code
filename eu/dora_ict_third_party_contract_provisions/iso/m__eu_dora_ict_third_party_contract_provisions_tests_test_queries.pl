% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_queries, [dora_ict_third_party_contract_provisions_profile_keys/1, dora_ict_third_party_contract_provisions_what_if/4]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_kernel, [dora_ict_third_party_contract_provisions_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [contract_provisions_sufficient/3, dora_ict_third_party_contract_provisions_status/2, dora_ict_third_party_contract_provisions_checklist/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_ict_third_party_contract_provisions_profile_keys(ProfileKeys),
    ProfileKeys == [contract_provides_termination_for_significant_breach, contract_provides_termination_for_circumstances_altering_performance, contract_provides_termination_for_risk_management_weaknesses, contract_provides_termination_where_supervision_impeded, contract_is_single_written_document, contract_provides_description_of_functions_services_and_subcontracting, contract_provides_service_and_data_locations, contract_provides_data_protection_provisions, contract_provides_data_access_recovery_and_return, contract_provides_service_level_descriptions, contract_provides_incident_assistance, contract_provides_cooperation_with_authorities, contract_provides_termination_rights_and_notice_periods, contract_provides_security_awareness_and_training_participation, supports_critical_or_important_function, contract_provides_full_service_levels_with_performance_targets, contract_provides_notice_periods_and_reporting_obligations, contract_provides_contingency_plans_and_security_measures, contract_provides_threat_led_penetration_testing_participation, contract_provides_monitoring_rights_of_the_authorities, contract_provides_exit_strategy_and_transition_period, contract_provides_monitoring_rights_of_the_financial_entity, financial_entity_is_microenterprise, contract_provides_delegated_access_inspection_and_audit].
test(the_profile_keys_number_twenty_four) :-
    dora_ict_third_party_contract_provisions_profile_keys(ProfileKeys),
    length(ProfileKeys, 24).
test(the_reexported_input_check_accepts_a_fixture) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_input_problems(Profile, Problems),
    Problems == [].
test(the_reexported_input_check_names_an_unknown_key) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(what_if_a_base_element_were_missing) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_what_if(Profile, contract_provides_incident_assistance, false, NewStatus),
    NewStatus == insufficient.
test(what_if_the_missing_element_were_added) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_incident_assistance_false, Profile),
    dora_ict_third_party_contract_provisions_what_if(Profile, contract_provides_incident_assistance, true, NewStatus),
    NewStatus == sufficient.
test(what_if_the_arrangement_did_not_support_a_critical_function) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    dora_ict_third_party_contract_provisions_what_if(Profile, supports_critical_or_important_function, false, NewStatus),
    NewStatus == sufficient.
test(the_compliance_check_answers_once) :-
    dora_ict_third_party_contract_provisions_profile_for(microenterprise_delegation, Profile),
    findall(Result, contract_provisions_sufficient(Profile, Result, _), Results),
    Results == [sufficient].
test(the_status_is_a_table_atom_or_a_status_compound) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    dora_ict_third_party_contract_provisions_status(Profile, Status),
    Status == insufficient.
test(the_checklist_cites_the_unmet_element) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    dora_ict_third_party_contract_provisions_checklist(Profile, Items),
    member(item(exit_strategy_and_transition_period, Status, Citation), Items),
    Status == unmet(not_provided),
    Citation == cite(eu_reg_2022_2554_art_30_3_f).

cp_test_names([profile_keys_are_the_contract_keys, the_profile_keys_number_twenty_four, the_reexported_input_check_accepts_a_fixture, the_reexported_input_check_names_an_unknown_key, what_if_a_base_element_were_missing, what_if_the_missing_element_were_added, what_if_the_arrangement_did_not_support_a_critical_function, the_compliance_check_answers_once, the_status_is_a_table_atom_or_a_status_compound, the_checklist_cites_the_unmet_element]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
