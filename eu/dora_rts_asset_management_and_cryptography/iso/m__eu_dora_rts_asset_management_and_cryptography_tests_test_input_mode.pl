% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [dora_rts_asset_management_and_cryptography_status/2, rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_profile_for/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).

test(gate_true_holds_with_simplified_framework_entity_bound) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, simplified_framework_entity).
test(all_performed_holds_with_complete_bound) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, complete).
test(one_duty_not_performed_holds_with_incomplete_bound) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, incomplete).
test(gate_absent_holds_with_the_gate_named) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_absent_entity, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(required_bound_for_a_microenterprise) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required([ict_asset_management_policy, ict_asset_lifecycle_monitoring_and_management, ict_asset_records, ict_asset_management_procedure|_]), _).
test(outstanding_bound_for_two_duties) :-
    dora_rts_asset_management_and_cryptography_profile_for(two_duties_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding([ict_asset_records, certificate_register]), _).
test(outstanding_bound_none_for_all_performed) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, none_outstanding, _).
test(an_empty_profile_has_no_problem) :-
    dora_rts_asset_management_and_cryptography_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_asset_management_and_cryptography_input_problems(_UnboundProfile, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_RemainingElements], [wrong_type(profile)]).
test(an_unbound_element_is_not_an_attribute_list) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, false), _UnboundElement], [wrong_type(profile)]).
test(a_foreign_element_is_not_an_attribute_list) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(foreign_key_atom, true), foreign_element], [wrong_type(profile)]).
test(an_atom_is_not_an_attribute_list) :-
    dora_rts_asset_management_and_cryptography_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unknown_key_value_is_not_checked) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(foreign_key_atom, _UnboundValue)], [unknown_key(foreign_key_atom)]).
test(an_unbound_key_is_reported_as_given) :-
    Profile = [attribute(KeyVariable, true)],
    dora_rts_asset_management_and_cryptography_input_problems(Profile, [unknown_key(ReportedKey)]),
    ReportedKey == KeyVariable.
test(two_distinct_unbound_keys_are_two_keys) :-
    Profile = [attribute(FirstVariable, true), attribute(SecondVariable, false)],
    dora_rts_asset_management_and_cryptography_input_problems(Profile, [unknown_key(FirstReported), unknown_key(SecondReported)]),
    FirstReported == FirstVariable,
    SecondReported == SecondVariable.
test(one_unbound_key_used_twice_is_one_key) :-
    Profile = [attribute(KeyVariable, true), attribute(KeyVariable, false)],
    dora_rts_asset_management_and_cryptography_input_problems(Profile, [unknown_key(ReportedKey)]),
    ReportedKey == KeyVariable.
test(a_number_key_is_unknown) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(7, true), attribute(7.0, true)], [unknown_key(7), unknown_key(7.0)]).
test(a_repeated_unknown_key_is_named_once) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(foreign_key_atom, true), attribute(foreign_key_atom, false)], [unknown_key(foreign_key_atom)]).
test(unsure_is_wrong_type_for_the_trigger) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_microenterprise, unsure)], [wrong_type(financial_entity_is_microenterprise)]).
test(unsure_is_in_type_for_a_judgement) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(certificate_register_created_maintained_and_kept_up_to_date, unsure)], []).
test(a_float_is_wrong_type_for_a_judgement) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(certificate_register_created_maintained_and_kept_up_to_date, 1.0)], [wrong_type(certificate_register_created_maintained_and_kept_up_to_date)]).
test(an_unbound_value_of_a_contract_key_is_wrong_type) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, _UnboundValue)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(a_string_value_is_wrong_type) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, "true")], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(equal_duplicate_values_are_a_duplicate_key_only) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, false)], [duplicate_key(financial_entity_is_article_16_1_entity)]).
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_microenterprise, maybe), attribute(financial_entity_is_microenterprise, true)], [duplicate_key(financial_entity_is_microenterprise)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(foreign_key_atom, true), attribute(certificates_renewed_promptly_before_expiration, maybe), attribute(financial_entity_is_article_16_1_entity, maybe)], [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(certificates_renewed_promptly_before_expiration), unknown_key(foreign_key_atom)]).
test(a_present_duty_key_is_checked_in_the_required_query) :-
    rts_asset_management_and_cryptography_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(certificate_register_created_maintained_and_kept_up_to_date, maybe)], input_problems([wrong_type(certificate_register_created_maintained_and_kept_up_to_date)]), []).
test(every_query_answers_input_problems_first) :-
    dora_rts_asset_management_and_cryptography_profile_for(duplicate_and_unknown_keys, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)]), []),
    rts_asset_management_and_cryptography_duties_complete(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)]), []),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)]), []).

test(gate_true_rejects_complete_bound, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, complete).
test(all_performed_rejects_incomplete_bound, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, incomplete).
test(gate_absent_rejects_the_trigger_named, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_absent_entity, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, indeterminate([financial_entity_is_microenterprise])).

cp_test_names([gate_true_holds_with_simplified_framework_entity_bound, all_performed_holds_with_complete_bound, one_duty_not_performed_holds_with_incomplete_bound, gate_absent_holds_with_the_gate_named, required_bound_for_a_microenterprise, outstanding_bound_for_two_duties, outstanding_bound_none_for_all_performed, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, an_unknown_key_value_is_not_checked, an_unbound_key_is_reported_as_given, two_distinct_unbound_keys_are_two_keys, one_unbound_key_used_twice_is_one_key, a_number_key_is_unknown, a_repeated_unknown_key_is_named_once, unsure_is_wrong_type_for_the_trigger, unsure_is_in_type_for_a_judgement, a_float_is_wrong_type_for_a_judgement, an_unbound_value_of_a_contract_key_is_wrong_type, a_string_value_is_wrong_type, equal_duplicate_values_are_a_duplicate_key_only, a_duplicate_key_is_never_also_wrong_type, problems_follow_contract_order_then_unknown_keys, a_present_duty_key_is_checked_in_the_required_query, every_query_answers_input_problems_first]).
cp_test_fail_names([gate_true_rejects_complete_bound, all_performed_rejects_incomplete_bound, gate_absent_rejects_the_trigger_named]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
