% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3, dora_rts_simplified_testing_continuity_and_report_status/2, dora_rts_simplified_testing_continuity_and_report_status_values/1]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(todo_baseline_subject, Profile),
    dora_rts_simplified_testing_continuity_and_report_status(Profile, complete).
test(complete_holds_with_result_and_citations_bound) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_complete(Profile, complete, [_|_]).
test(outstanding_holds_with_result_bound) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(one_testing_duty_not_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, outstanding([ict_security_testing_plan]), [cite(eu_reg_2024_1774_art_36_1)]).
test(required_holds_with_the_gate_answer_bound) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true)|_], [wrong_type(profile)]).
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true), stray], [wrong_type(profile)]).
test(a_number_value_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, 1)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(an_unsure_trigger_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(authority_requested_framework_review_report, unsure)], [wrong_type(authority_requested_framework_review_report)]).
test(an_unsure_judgement_is_well_formed) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(review_report_states_overall_conclusions, unsure)], []).
test(an_unbound_value_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(ict_change_management_procedure_in_place, _)], [wrong_type(ict_change_management_procedure_in_place)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(stray_key, 1), attribute(ict_security_testing_plan_established_and_implemented, maybe), attribute(financial_entity_is_article_16_1_entity, 7)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(ict_security_testing_plan_established_and_implemented), unknown_key(stray_key)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(authority_requested_framework_review_report, odd), attribute(authority_requested_framework_review_report, true)], [duplicate_key(authority_requested_framework_review_report)]).
test(an_unknown_key_repeated_is_named_once) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(dora_entity_type, a), attribute(dora_entity_type, b)], [unknown_key(dora_entity_type)]).
test(an_unbound_key_is_named_as_given) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(FreeKey, true)], Problems),
    Problems = [unknown_key(Named)],
    Named == FreeKey.
test(two_distinct_unbound_keys_are_two_keys) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(_FirstKey, true), attribute(_SecondKey, true)], Problems),
    length(Problems, 2).
test(the_same_unbound_key_twice_is_one_key) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(FreeKey, true), attribute(FreeKey, false)], Problems),
    length(Problems, 1).
test(an_integer_and_a_float_key_are_two_keys) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(7, true), attribute(7.0, true)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(every_query_refuses_a_malformed_profile) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_microenterprise, true)], input_problems([unknown_key(financial_entity_is_microenterprise)]), []),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_microenterprise, true)], input_problems([unknown_key(financial_entity_is_microenterprise)]), []),
    simplified_testing_continuity_and_report_duties_outstanding([attribute(financial_entity_is_microenterprise, true)], input_problems([unknown_key(financial_entity_is_microenterprise)]), []).
test(a_false_gate_does_not_hide_a_bad_duty_value) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(backup_key_typo_free, true), attribute(continuity_plans_consider_alternative_options, yes)], input_problems([wrong_type(continuity_plans_consider_alternative_options), unknown_key(backup_key_typo_free)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(todo_baseline_subject, Profile),
    dora_rts_simplified_testing_continuity_and_report_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, complete),
    dora_rts_simplified_testing_continuity_and_report_status(Profile, Other).
test(a_malformed_profile_gets_no_final_answer, fail) :-
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, maybe)], not_article_16_1_entity, _).

cp_test_names([status_holds_with_the_verdict_bound, complete_holds_with_result_and_citations_bound, outstanding_holds_with_result_bound, required_holds_with_the_gate_answer_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, a_number_value_is_wrong_type, an_unsure_trigger_is_wrong_type, an_unsure_judgement_is_well_formed, an_unbound_value_is_wrong_type, problems_come_in_contract_order_then_unknown_keys, a_duplicate_key_is_never_also_wrong_type, an_unknown_key_repeated_is_named_once, an_unbound_key_is_named_as_given, two_distinct_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, an_integer_and_a_float_key_are_two_keys, every_query_refuses_a_malformed_profile, a_false_gate_does_not_hide_a_bad_duty_value]).
cp_test_fail_names([every_other_bound_status_is_rejected, a_malformed_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
