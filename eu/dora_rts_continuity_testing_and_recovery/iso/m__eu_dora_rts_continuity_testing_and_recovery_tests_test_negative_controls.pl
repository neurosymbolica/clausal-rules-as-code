% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_dora_rts_continuity_testing_and_recovery, [rts_continuity_testing_and_recovery_duties_required/3, rts_continuity_testing_and_recovery_duties_complete/3, rts_continuity_testing_and_recovery_duties_outstanding/3, dora_rts_continuity_testing_and_recovery_status_values/1]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_profile_for/2]).

complete_result(Subject, Result) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, Result, _Citations).

outstanding_result(Subject, Result) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, Result, _Citations).

required_duties(Subject, Duties) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required(Duties), _Citations).

test(the_status_table_holds_the_three_final_atoms) :-
    dora_rts_continuity_testing_and_recovery_status_values(StatusValues),
    StatusValues == [complete, incomplete, simplified_framework_entity].
test(gate_true_is_simplified_framework_entity) :-
    complete_result(article_16_entity_all_performed, simplified_framework_entity).
test(gate_false_near_miss_is_complete) :-
    complete_result(credit_institution_all_performed, complete).
test(gate_absent_asks_the_gate) :-
    complete_result(gate_absent, indeterminate([financial_entity_is_article_16_1_entity])).
test(gate_unsure_is_an_input_problem) :-
    complete_result(gate_unsure_is_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(gate_false_near_miss_asks_the_first_duty) :-
    complete_result(gate_false_alone, indeterminate([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment])).
test(a_false_duty_that_always_applies_is_incomplete) :-
    complete_result(credit_institution_first_duty_false, incomplete).
test(a_non_microenterprise_without_switchover_is_incomplete) :-
    complete_result(non_microenterprise_switchover_false, incomplete).
test(a_microenterprise_without_switchover_is_complete) :-
    complete_result(microenterprise_switchover_false, complete).
test(a_central_counterparty_without_involvement_is_incomplete) :-
    complete_result(central_counterparty_involvement_false, incomplete).
test(a_central_counterparty_with_involvement_is_complete) :-
    complete_result(central_counterparty_all_performed, complete).
test(a_depository_without_involvement_is_incomplete) :-
    complete_result(central_securities_depository_involvement_false, incomplete).
test(a_credit_institution_without_depository_involvement_is_complete) :-
    complete_result(credit_institution_depository_involvement_false, complete).
test(a_provider_user_without_continuity_measures_is_incomplete) :-
    complete_result(provider_user_continuity_measures_false, incomplete).
test(an_entity_without_providers_is_complete) :-
    complete_result(no_provider_continuity_measures_false, complete).
test(an_absent_trigger_under_a_false_provider_duty_is_asked) :-
    complete_result(trigger_absent_provider_testing_false, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers])).
test(a_true_trigger_under_a_false_provider_duty_is_incomplete) :-
    complete_result(trigger_true_provider_testing_false, incomplete).
test(the_key_of_a_duty_that_applies_is_named_first) :-
    complete_result(first_duty_absent_and_trigger_absent, indeterminate([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment])).
test(an_unsure_duty_that_decides_is_referred) :-
    complete_result(unsure_alternative_options, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), _)).
test(an_unsure_duty_beside_a_false_duty_is_incomplete) :-
    complete_result(unsure_alternative_options_with_false_duty, incomplete).
test(the_outstanding_query_still_refers_beside_a_false_duty) :-
    outstanding_result(unsure_alternative_options_with_false_duty, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), _)).
test(a_non_microenterprise_is_required_to_test_switchover) :-
    required_duties(credit_institution_all_performed, Duties),
    member(testing_of_switchover_scenarios, Duties).
test(a_microenterprise_is_still_required_to_document_results) :-
    required_duties(microenterprise_without_providers_all_performed, Duties),
    member(documentation_of_test_results, Duties).
test(a_false_duty_is_outstanding) :-
    outstanding_result(credit_institution_first_duty_false, outstanding([testing_informed_by_business_impact_analysis_and_ict_risk_assessment])).
test(none_outstanding_when_all_are_performed) :-
    outstanding_result(credit_institution_all_performed, none_outstanding).

test(gate_false_is_not_simplified_framework_entity, fail) :-
    complete_result(credit_institution_all_performed, simplified_framework_entity).
test(gate_present_does_not_ask_anything, fail) :-
    complete_result(credit_institution_all_performed, indeterminate(_)).
test(gate_false_is_not_an_input_problem, fail) :-
    complete_result(gate_false_alone, input_problems(_)).
test(the_performed_near_miss_is_not_incomplete, fail) :-
    complete_result(credit_institution_all_performed, incomplete).
test(a_microenterprise_without_switchover_is_not_incomplete, fail) :-
    complete_result(microenterprise_switchover_false, incomplete).
test(a_central_counterparty_with_involvement_is_not_incomplete, fail) :-
    complete_result(central_counterparty_all_performed, incomplete).
test(a_credit_institution_without_depository_involvement_is_not_incomplete, fail) :-
    complete_result(credit_institution_depository_involvement_false, incomplete).
test(an_entity_without_providers_is_not_incomplete, fail) :-
    complete_result(no_provider_continuity_measures_false, incomplete).
test(a_true_trigger_is_not_asked, fail) :-
    complete_result(trigger_true_provider_testing_false, indeterminate(_)).
test(the_trigger_behind_it_is_not_named, fail) :-
    complete_result(first_duty_absent_and_trigger_absent, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers])).
test(an_unsure_duty_beside_a_false_duty_is_not_referred, fail) :-
    complete_result(unsure_alternative_options_with_false_duty, needs_legal_review(_, _)).
test(a_microenterprise_is_not_required_to_test_switchover, fail) :-
    required_duties(microenterprise_without_providers_all_performed, Duties),
    member(testing_of_switchover_scenarios, Duties).
test(no_duty_is_outstanding_when_all_are_performed, fail) :-
    outstanding_result(credit_institution_all_performed, outstanding(_)).

cp_test_names([the_status_table_holds_the_three_final_atoms, gate_true_is_simplified_framework_entity, gate_false_near_miss_is_complete, gate_absent_asks_the_gate, gate_unsure_is_an_input_problem, gate_false_near_miss_asks_the_first_duty, a_false_duty_that_always_applies_is_incomplete, a_non_microenterprise_without_switchover_is_incomplete, a_microenterprise_without_switchover_is_complete, a_central_counterparty_without_involvement_is_incomplete, a_central_counterparty_with_involvement_is_complete, a_depository_without_involvement_is_incomplete, a_credit_institution_without_depository_involvement_is_complete, a_provider_user_without_continuity_measures_is_incomplete, an_entity_without_providers_is_complete, an_absent_trigger_under_a_false_provider_duty_is_asked, a_true_trigger_under_a_false_provider_duty_is_incomplete, the_key_of_a_duty_that_applies_is_named_first, an_unsure_duty_that_decides_is_referred, an_unsure_duty_beside_a_false_duty_is_incomplete, the_outstanding_query_still_refers_beside_a_false_duty, a_non_microenterprise_is_required_to_test_switchover, a_microenterprise_is_still_required_to_document_results, a_false_duty_is_outstanding, none_outstanding_when_all_are_performed]).
cp_test_fail_names([gate_false_is_not_simplified_framework_entity, gate_present_does_not_ask_anything, gate_false_is_not_an_input_problem, the_performed_near_miss_is_not_incomplete, a_microenterprise_without_switchover_is_not_incomplete, a_central_counterparty_with_involvement_is_not_incomplete, a_credit_institution_without_depository_involvement_is_not_incomplete, an_entity_without_providers_is_not_incomplete, a_true_trigger_is_not_asked, the_trigger_behind_it_is_not_named, an_unsure_duty_beside_a_false_duty_is_not_referred, a_microenterprise_is_not_required_to_test_switchover, no_duty_is_outstanding_when_all_are_performed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
