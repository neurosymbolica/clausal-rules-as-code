% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_queries, [dora_rts_asset_management_and_cryptography_profile_keys/1, dora_rts_asset_management_and_cryptography_what_if/4, complete/0, unsure/0]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_asset_management_and_cryptography_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, ict_asset_management_policy_developed_documented_and_implemented, asset_policy_prescribes_monitoring_and_management_of_asset_lifecycle, asset_policy_prescribes_records_of_ict_assets, asset_policy_prescribes_records_for_legacy_system_risk_assessment, ict_asset_management_procedure_developed_documented_and_implemented, asset_procedure_specifies_criticality_assessment_criteria, encryption_policy_developed_documented_and_implemented, encryption_policy_designed_on_data_classification_and_ict_risk_assessment, encryption_policy_has_rules_for_data_at_rest_and_in_transit, encryption_policy_has_rules_for_data_in_use_where_necessary, encryption_policy_has_rules_for_network_connections_and_external_traffic, encryption_policy_has_rules_for_cryptographic_key_management, data_in_use_protected_where_its_encryption_is_not_possible, encryption_policy_has_criteria_for_selecting_cryptographic_techniques, mitigation_and_monitoring_where_leading_practices_or_standards_not_followed, encryption_policy_has_provisions_for_updating_cryptographic_technology, mitigation_and_monitoring_where_cryptographic_technology_not_updated, encryption_policy_requires_recording_of_mitigation_measures_with_reasons, key_management_policy_has_requirements_for_whole_key_lifecycle, key_protection_controls_identified_and_implemented, key_protection_controls_designed_on_data_classification_and_ict_risk_assessment, key_replacement_methods_developed_and_implemented, certificate_register_created_maintained_and_kept_up_to_date, certificates_renewed_promptly_before_expiration].
test(profile_keys_are_twenty_six) :-
    dora_rts_asset_management_and_cryptography_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
test(the_re_exported_input_check_accepts_a_fixture) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, []).
test(the_re_exported_input_check_refuses_an_atom) :-
    dora_rts_asset_management_and_cryptography_input_problems(not_a_profile, [wrong_type(profile)]).
test(what_if_the_failing_duty_is_performed) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    findall(Status, dora_rts_asset_management_and_cryptography_what_if(Profile, certificates_renewed_promptly_before_expiration, true, Status), Statuses),
    Statuses == [complete].
test(what_if_a_performed_duty_is_not_gives_incomplete) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, certificates_renewed_promptly_before_expiration, false, incomplete).
test(what_if_the_gate_is_true) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_the_trigger_is_given) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_not_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_microenterprise, true, complete),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_microenterprise, false, incomplete).
test(what_if_a_value_out_of_type) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_article_16_1_entity, unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(what_if_replaces_every_duplicate) :-
    dora_rts_asset_management_and_cryptography_profile_for(duplicate_and_unknown_keys, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_article_16_1_entity, false, input_problems([unknown_key(foreign_contract_key)])).
test(what_if_an_unsure_judgement) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, key_replacement_methods_developed_and_implemented, unsure, needs_legal_review(open_textured(key_replacement_methods_developed_and_implemented, cite(eu_reg_2024_1774_art_7_3)), _)).
test(root_export_atoms_and_constructors_are_served) :-
    complete,
    unsure,
    Result = required([ict_asset_management_policy]),
    functor(Result, required, 1).

test(what_if_a_performed_duty_is_not, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, certificates_renewed_promptly_before_expiration, false, complete).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_are_twenty_six, the_re_exported_input_check_accepts_a_fixture, the_re_exported_input_check_refuses_an_atom, what_if_the_failing_duty_is_performed, what_if_a_performed_duty_is_not_gives_incomplete, what_if_the_gate_is_true, what_if_the_trigger_is_given, what_if_a_value_out_of_type, what_if_replaces_every_duplicate, what_if_an_unsure_judgement, root_export_atoms_and_constructors_are_served]).
cp_test_fail_names([what_if_a_performed_duty_is_not]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
