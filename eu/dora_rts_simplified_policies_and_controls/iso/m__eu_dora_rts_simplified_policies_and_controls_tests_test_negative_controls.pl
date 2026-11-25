% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [simplified_policies_and_controls_duties_required/3, simplified_policies_and_controls_duties_complete/3, simplified_policies_and_controls_duties_outstanding/3, dora_rts_simplified_policies_and_controls_status/2, dora_rts_simplified_policies_and_controls_status_values/1]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_profile_for/2]).

profile(Subject, Profile) :-
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile).

test(the_status_table_has_a_near_miss_atom) :-
    dora_rts_simplified_policies_and_controls_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_near_miss_atoms_are_table_statuses) :-
    dora_rts_simplified_policies_and_controls_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(not_article_16_1_entity, StatusValues).
test(all_duties_performed_is_complete) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, complete, _).
test(one_duty_not_performed_is_incomplete) :-
    profile(one_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(gate_false_is_not_article_16_1_entity) :-
    profile(gate_false_entity, Profile),
    simplified_policies_and_controls_duties_required(Profile, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_true_gets_the_duty_list) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_required(Profile, required(_), _).
test(gate_false_decides_before_a_false_duty) :-
    profile(gate_false_with_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, not_article_16_1_entity, _),
    simplified_policies_and_controls_duties_outstanding(Profile, not_article_16_1_entity, _).
test(gate_absent_is_indeterminate_on_the_gate) :-
    profile(gate_absent_entity, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_absent_duty_is_indeterminate) :-
    profile(one_duty_absent, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate([access_operations_and_change_events_logged]), []).
test(an_unsure_duty_is_referred) :-
    profile(one_duty_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on(_)]), []).
test(an_absent_key_is_named_before_an_unsure_one) :-
    profile(absent_before_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate([teleworking_and_private_device_measures_implemented]), []).
test(a_false_duty_decides_complete_before_an_absent_key) :-
    profile(false_and_absent, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(a_false_duty_does_not_end_outstanding) :-
    profile(false_and_absent, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, indeterminate([access_operations_and_change_events_logged]), []).
test(a_false_duty_decides_complete_before_an_unsure_key) :-
    profile(false_and_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(several_false_duties_are_outstanding_in_duty_order) :-
    profile(several_duties_not_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, outstanding([internal_governance_and_control_framework, protection_of_premises_and_data_centres, user_accountability]), _).
test(all_true_is_none_outstanding) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, none_outstanding, _).
test(a_wrong_type_gate_is_an_input_problem) :-
    profile(gate_unsure_wrong_type, Profile),
    simplified_policies_and_controls_duties_complete(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(a_well_formed_profile_has_no_input_problem) :-
    profile(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_input_problems(Profile, []).
test(an_unknown_key_is_refused) :-
    profile(microenterprise_key_unknown, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, input_problems([unknown_key(financial_entity_is_microenterprise)]), []).
test(a_duplicate_key_is_refused) :-
    profile(duplicate_contract_key, Profile),
    simplified_policies_and_controls_duties_required(Profile, input_problems([duplicate_key(user_accountability_ensured)]), []).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    profile(all_duties_performed, Profile),
    findall(Status, dora_rts_simplified_policies_and_controls_status(Profile, Status), [BaselineStatus]),
    dora_rts_simplified_policies_and_controls_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_simplified_policies_and_controls_status(Profile, Other).
test(one_duty_not_performed_is_not_complete, fail) :-
    profile(one_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, complete, _).
test(all_duties_performed_is_not_incomplete, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(gate_true_is_not_not_article_16_1_entity, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_required(Profile, not_article_16_1_entity, _).
test(gate_false_gets_no_duty_list, fail) :-
    profile(gate_false_entity, Profile),
    simplified_policies_and_controls_duties_required(Profile, required(_), _).
test(gate_false_with_a_false_duty_is_not_incomplete, fail) :-
    profile(gate_false_with_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(gate_absent_is_not_incomplete_despite_a_false_duty, fail) :-
    profile(gate_absent_entity, Profile),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, _).
test(gate_true_with_a_false_duty_is_not_indeterminate, fail) :-
    profile(one_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate(_), _).
test(a_present_duty_is_not_indeterminate, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate(_), _).
test(an_unsure_duty_is_not_indeterminate, fail) :-
    profile(one_duty_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate(_), _).
test(a_true_duty_is_not_referred, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(_, _), _).
test(an_absent_key_before_an_unsure_one_is_not_referred, fail) :-
    profile(absent_before_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(_, _), _).
test(false_and_absent_is_not_outstanding_yet, fail) :-
    profile(false_and_absent, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, outstanding(_), _).
test(false_and_unsure_is_not_referred_by_complete, fail) :-
    profile(false_and_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(_, _), _).
test(all_true_has_nothing_outstanding, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, outstanding(_), _).
test(one_false_is_not_none_outstanding, fail) :-
    profile(one_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, none_outstanding, _).
test(a_well_formed_profile_is_not_refused, fail) :-
    profile(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_complete(Profile, input_problems(_), _).
test(a_refused_profile_gets_no_duty_list, fail) :-
    profile(duplicate_contract_key, Profile),
    simplified_policies_and_controls_duties_required(Profile, required(_), _).

cp_test_names([the_status_table_has_a_near_miss_atom, the_near_miss_atoms_are_table_statuses, all_duties_performed_is_complete, one_duty_not_performed_is_incomplete, gate_false_is_not_article_16_1_entity, gate_true_gets_the_duty_list, gate_false_decides_before_a_false_duty, gate_absent_is_indeterminate_on_the_gate, an_absent_duty_is_indeterminate, an_unsure_duty_is_referred, an_absent_key_is_named_before_an_unsure_one, a_false_duty_decides_complete_before_an_absent_key, a_false_duty_does_not_end_outstanding, a_false_duty_decides_complete_before_an_unsure_key, several_false_duties_are_outstanding_in_duty_order, all_true_is_none_outstanding, a_wrong_type_gate_is_an_input_problem, a_well_formed_profile_has_no_input_problem, an_unknown_key_is_refused, a_duplicate_key_is_refused]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, one_duty_not_performed_is_not_complete, all_duties_performed_is_not_incomplete, gate_true_is_not_not_article_16_1_entity, gate_false_gets_no_duty_list, gate_false_with_a_false_duty_is_not_incomplete, gate_absent_is_not_incomplete_despite_a_false_duty, gate_true_with_a_false_duty_is_not_indeterminate, a_present_duty_is_not_indeterminate, an_unsure_duty_is_not_indeterminate, a_true_duty_is_not_referred, an_absent_key_before_an_unsure_one_is_not_referred, false_and_absent_is_not_outstanding_yet, false_and_unsure_is_not_referred_by_complete, all_true_has_nothing_outstanding, one_false_is_not_none_outstanding, a_well_formed_profile_is_not_refused, a_refused_profile_gets_no_duty_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
