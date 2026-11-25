% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [dora_rts_asset_management_and_cryptography_status_values/1, rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_profile_for/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).

test(the_status_table_names_the_final_atoms) :-
    dora_rts_asset_management_and_cryptography_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues).
test(gate_true_is_a_simplified_framework_entity) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_absent_names_the_gate) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_absent_entity, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(all_performed_is_complete) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(one_duty_not_performed_is_incomplete) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
test(microenterprise_without_legacy_records_is_complete) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(non_microenterprise_without_legacy_records_is_incomplete) :-
    dora_rts_asset_management_and_cryptography_profile_for(non_microenterprise_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
test(non_microenterprise_requires_legacy_records) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    member(legacy_ict_system_risk_assessment_records, Duties).
test(absent_trigger_with_legacy_false_names_the_trigger) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(absent_trigger_with_legacy_true_is_complete) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(an_absent_duty_key_is_named) :-
    dora_rts_asset_management_and_cryptography_profile_for(always_duty_key_absent, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate([ict_asset_management_policy_developed_documented_and_implemented]), []).
test(a_false_duty_decides_before_an_absent_key) :-
    dora_rts_asset_management_and_cryptography_profile_for(false_duty_before_absent_key, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
test(an_unsure_judgement_is_referred) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, needs_legal_review(open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)), _), []).
test(an_absent_key_comes_before_the_unsure_judgement) :-
    dora_rts_asset_management_and_cryptography_profile_for(absent_key_before_unsure_judgement, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate([certificates_renewed_promptly_before_expiration]), []).
test(two_duties_are_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(two_duties_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding([ict_asset_records, certificate_register]), _).
test(all_performed_has_none_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, none_outstanding, _).
test(duplicate_and_unknown_keys_are_input_problems) :-
    dora_rts_asset_management_and_cryptography_profile_for(duplicate_and_unknown_keys, Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)]).
test(a_well_formed_profile_has_no_input_problem) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, []).
test(the_gate_given_unsure_is_wrong_type) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_given_unsure, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(not_an_attribute_list_is_wrong_type_profile) :-
    dora_rts_asset_management_and_cryptography_profile_for(not_an_attribute_list, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, input_problems([wrong_type(profile)]), []).

test(gate_false_is_not_a_simplified_framework_entity, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, simplified_framework_entity, _).
test(gate_given_does_not_name_the_gate, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), _).
test(one_duty_not_performed_is_not_complete, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(non_microenterprise_without_legacy_records_is_not_complete, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(non_microenterprise_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(microenterprise_does_not_require_legacy_records, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    member(legacy_ict_system_risk_assessment_records, Duties).
test(absent_trigger_with_legacy_true_does_not_name_the_trigger, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate(_), _).
test(a_present_duty_key_is_not_named, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate(_), _).
test(a_false_duty_does_not_leave_the_absent_key_named_in_complete, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(false_duty_before_absent_key, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate(_), _).
test(an_absent_key_stops_the_referral, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(absent_key_before_unsure_judgement, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, needs_legal_review(_, _), _).
test(all_performed_has_no_outstanding_list, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding(_), _).
test(a_well_formed_profile_is_not_refused, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, input_problems(_), _).

cp_test_names([the_status_table_names_the_final_atoms, gate_true_is_a_simplified_framework_entity, gate_absent_names_the_gate, all_performed_is_complete, one_duty_not_performed_is_incomplete, microenterprise_without_legacy_records_is_complete, non_microenterprise_without_legacy_records_is_incomplete, non_microenterprise_requires_legacy_records, absent_trigger_with_legacy_false_names_the_trigger, absent_trigger_with_legacy_true_is_complete, an_absent_duty_key_is_named, a_false_duty_decides_before_an_absent_key, an_unsure_judgement_is_referred, an_absent_key_comes_before_the_unsure_judgement, two_duties_are_outstanding, all_performed_has_none_outstanding, duplicate_and_unknown_keys_are_input_problems, a_well_formed_profile_has_no_input_problem, the_gate_given_unsure_is_wrong_type, not_an_attribute_list_is_wrong_type_profile]).
cp_test_fail_names([gate_false_is_not_a_simplified_framework_entity, gate_given_does_not_name_the_gate, one_duty_not_performed_is_not_complete, non_microenterprise_without_legacy_records_is_not_complete, microenterprise_does_not_require_legacy_records, absent_trigger_with_legacy_true_does_not_name_the_trigger, a_present_duty_key_is_not_named, a_false_duty_does_not_leave_the_absent_key_named_in_complete, an_absent_key_stops_the_referral, all_performed_has_no_outstanding_list, a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
