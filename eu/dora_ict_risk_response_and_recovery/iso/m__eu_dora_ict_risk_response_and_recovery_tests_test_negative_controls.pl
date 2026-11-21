% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, dora_ict_risk_response_and_recovery_status/2, dora_ict_risk_response_and_recovery_status_values/1]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_profile_for/2]).

complete_answer(Subject, Result) :-
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, Result, _).

test(the_status_table_names_each_final_atom) :-
    dora_ict_risk_response_and_recovery_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues).
test(gate_true_is_simplified_framework_entity) :-
    complete_answer(article_16_1_entity, simplified_framework_entity).
test(gate_absent_is_asked_first) :-
    complete_answer(article_16_1_status_not_stated, indeterminate([financial_entity_is_article_16_1_entity])).
test(a_failing_policy_is_incomplete) :-
    complete_answer(large_credit_institution_policy_not_performed, incomplete).
test(a_performed_policy_is_complete) :-
    complete_answer(large_credit_institution_all_performed, complete).
test(a_microenterprise_needs_no_audit_review) :-
    complete_answer(microenterprise_without_audit_review, complete).
test(a_large_entity_without_audit_review_is_incomplete) :-
    complete_answer(large_credit_institution_without_audit_review, incomplete).
test(a_microenterprise_must_assess_the_need_for_redundancy) :-
    complete_answer(microenterprise_need_for_redundancy_not_assessed, incomplete).
test(a_central_securities_depository_needs_a_secondary_site) :-
    complete_answer(central_securities_depository_without_secondary_site, incomplete).
test(a_credit_institution_without_secondary_site_is_complete) :-
    complete_answer(credit_institution_without_secondary_site, complete).
test(activated_plans_need_records) :-
    complete_answer(plans_activated_records_not_kept, incomplete).
test(plans_not_activated_without_records_is_complete) :-
    complete_answer(plans_not_activated_records_not_kept, complete).
test(each_size_failing_is_incomplete) :-
    complete_answer(size_not_stated_both_redundancy_duties_failing, incomplete).
test(one_size_failing_asks_the_size) :-
    complete_answer(size_not_stated_one_redundancy_duty_failing, indeterminate([financial_entity_is_microenterprise])).
test(an_unsure_recovery_is_referred) :-
    complete_answer(central_counterparty_recovery_unsure, needs_legal_review(open_textured(recovery_plans_enable_recovery_of_all_transactions, cite(eu_reg_2022_2554_art_12_3)), _)).
test(a_performed_recovery_is_complete) :-
    complete_answer(central_counterparty_recovery_performed, complete).
test(a_microenterprise_is_not_asked_the_cost_request) :-
    dora_ict_risk_response_and_recovery_profile_for(microenterprise_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(_), _).
test(a_failing_policy_is_outstanding) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_policy_not_performed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([ict_business_continuity_policy]), [cite(eu_reg_2022_2554_art_11_1)]).
test(a_performed_policy_is_none_outstanding) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, none_outstanding, _).
test(an_unknown_key_is_a_problem) :-
    dora_ict_risk_response_and_recovery_profile_for(unknown_key_profile, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, [unknown_key(no_such_key)]).

test(gate_false_is_not_simplified_framework_entity, fail) :-
    complete_answer(large_credit_institution_all_performed, simplified_framework_entity).
test(gate_stated_is_not_asked, fail) :-
    complete_answer(large_credit_institution_all_performed, indeterminate([financial_entity_is_article_16_1_entity])).
test(a_performed_policy_is_not_incomplete, fail) :-
    complete_answer(large_credit_institution_all_performed, incomplete).
test(a_large_entity_without_audit_review_is_not_complete, fail) :-
    complete_answer(large_credit_institution_without_audit_review, complete).
test(a_microenterprise_that_assessed_is_not_incomplete, fail) :-
    complete_answer(microenterprise_all_performed, incomplete).
test(a_credit_institution_needs_no_secondary_site, fail) :-
    complete_answer(credit_institution_without_secondary_site, incomplete).
test(plans_not_activated_need_no_records, fail) :-
    complete_answer(plans_not_activated_records_not_kept, incomplete).
test(one_size_failing_is_not_incomplete, fail) :-
    complete_answer(size_not_stated_one_redundancy_duty_failing, incomplete).
test(a_performed_recovery_is_not_referred, fail) :-
    complete_answer(central_counterparty_recovery_performed, needs_legal_review(_, _)).
test(a_large_entity_is_asked_the_cost_request, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_entity_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(_), _).
test(a_performed_policy_is_not_outstanding, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding(_), _).
test(a_clean_profile_has_no_problem, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, [_|_]).
test(a_profile_with_a_problem_gets_no_status_atom, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(unknown_key_profile, Profile),
    dora_ict_risk_response_and_recovery_status_values(StatusValues),
    member(Status, StatusValues),
    dora_ict_risk_response_and_recovery_status(Profile, Status).

cp_test_names([the_status_table_names_each_final_atom, gate_true_is_simplified_framework_entity, gate_absent_is_asked_first, a_failing_policy_is_incomplete, a_performed_policy_is_complete, a_microenterprise_needs_no_audit_review, a_large_entity_without_audit_review_is_incomplete, a_microenterprise_must_assess_the_need_for_redundancy, a_central_securities_depository_needs_a_secondary_site, a_credit_institution_without_secondary_site_is_complete, activated_plans_need_records, plans_not_activated_without_records_is_complete, each_size_failing_is_incomplete, one_size_failing_asks_the_size, an_unsure_recovery_is_referred, a_performed_recovery_is_complete, a_microenterprise_is_not_asked_the_cost_request, a_failing_policy_is_outstanding, a_performed_policy_is_none_outstanding, an_unknown_key_is_a_problem]).
cp_test_fail_names([gate_false_is_not_simplified_framework_entity, gate_stated_is_not_asked, a_performed_policy_is_not_incomplete, a_large_entity_without_audit_review_is_not_complete, a_microenterprise_that_assessed_is_not_incomplete, a_credit_institution_needs_no_secondary_site, plans_not_activated_need_no_records, one_size_failing_is_not_incomplete, a_performed_recovery_is_not_referred, a_large_entity_is_asked_the_cost_request, a_performed_policy_is_not_outstanding, a_clean_profile_has_no_problem, a_profile_with_a_problem_gets_no_status_atom]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
