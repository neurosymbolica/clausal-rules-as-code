% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_profile_for/2]).

complete_result(Subject, Result) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    simplified_testing_continuity_and_report_duties_complete(Profile, Result, _).

outstanding_result(Subject, Result) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, Result, _).

required_result(Subject, Result) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, Result, _).

test(all_performed_without_request_is_complete) :-
    complete_result(all_performed_without_request, complete).
test(one_testing_duty_not_performed_is_incomplete) :-
    complete_result(one_testing_duty_not_performed_without_request, incomplete).
test(conclusions_missing_without_request_is_complete) :-
    complete_result(conclusions_missing_without_request, complete).
test(conclusions_missing_with_request_is_incomplete) :-
    complete_result(conclusions_missing_with_request, incomplete).
test(conclusions_missing_request_unanswered_names_the_request) :-
    complete_result(conclusions_missing_request_unanswered, indeterminate([authority_requested_framework_review_report])).
test(evidence_missing_without_supervisory_instructions_is_complete) :-
    complete_result(evidence_missing_without_supervisory_instructions, complete).
test(evidence_missing_with_supervisory_instructions_is_incomplete) :-
    complete_result(evidence_missing_with_supervisory_instructions, incomplete).
test(all_performed_with_both_reasons_is_complete) :-
    complete_result(all_performed_with_request_for_both_reasons, complete).
test(incident_list_missing_is_incomplete) :-
    complete_result(incident_list_missing_with_request_for_both_reasons, incomplete).
test(an_unsure_backup_duty_is_referred) :-
    complete_result(backup_procedures_unsure_without_request, needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), _)).
test(a_false_duty_decides_before_the_unsure_one) :-
    complete_result(backup_procedures_unsure_with_testing_plan_not_performed, incomplete).
test(a_false_gate_is_not_an_article_16_1_entity) :-
    complete_result(not_an_article_16_1_entity, not_article_16_1_entity).
test(an_unanswered_gate_is_named) :-
    complete_result(gate_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
test(a_microenterprise_key_is_unknown) :-
    complete_result(microenterprise_key_given, input_problems([unknown_key(financial_entity_is_microenterprise)])).
test(an_unsure_request_is_wrong_type) :-
    complete_result(request_given_as_unsure, input_problems([wrong_type(authority_requested_framework_review_report)])).
test(a_gate_given_twice_is_a_duplicate) :-
    complete_result(gate_given_twice, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(outstanding_none_when_all_performed) :-
    outstanding_result(all_performed_without_request, none_outstanding).
test(outstanding_lists_the_testing_plan) :-
    outstanding_result(one_testing_duty_not_performed_without_request, outstanding([ict_security_testing_plan])).
test(outstanding_conclusions_with_request) :-
    outstanding_result(conclusions_missing_with_request, outstanding([report_overall_conclusions])).
test(outstanding_conclusions_without_request_is_none) :-
    outstanding_result(conclusions_missing_without_request, none_outstanding).
test(required_without_request_has_twenty_three) :-
    required_result(all_performed_without_request, required(Duties)),
    length(Duties, 23).
test(required_with_both_reasons_has_thirty_eight) :-
    required_result(all_performed_with_request_for_both_reasons, required(Duties)),
    length(Duties, 38).
test(required_for_a_false_gate_is_not_a_list) :-
    required_result(not_an_article_16_1_entity, not_article_16_1_entity).

test(one_testing_duty_not_performed_is_not_complete, fail) :-
    complete_result(one_testing_duty_not_performed_without_request, complete).
test(conclusions_missing_with_request_is_not_complete, fail) :-
    complete_result(conclusions_missing_with_request, complete).
test(conclusions_missing_request_unanswered_is_not_complete, fail) :-
    complete_result(conclusions_missing_request_unanswered, complete).
test(evidence_missing_with_supervisory_instructions_is_not_complete, fail) :-
    complete_result(evidence_missing_with_supervisory_instructions, complete).
test(incident_list_missing_is_not_complete, fail) :-
    complete_result(incident_list_missing_with_request_for_both_reasons, complete).
test(a_false_duty_beside_an_unsure_one_is_not_referred, fail) :-
    complete_result(backup_procedures_unsure_with_testing_plan_not_performed, needs_legal_review(_, _)).
test(a_false_gate_is_not_complete, fail) :-
    complete_result(not_an_article_16_1_entity, complete).
test(an_unanswered_gate_is_not_complete, fail) :-
    complete_result(gate_unanswered, complete).
test(a_microenterprise_key_is_not_complete, fail) :-
    complete_result(microenterprise_key_given, complete).
test(a_gate_given_twice_is_not_wrong_type, fail) :-
    complete_result(gate_given_twice, input_problems([wrong_type(_)|_])).
test(outstanding_with_a_failure_is_not_none, fail) :-
    outstanding_result(one_testing_duty_not_performed_without_request, none_outstanding).
test(required_without_request_has_no_report_duty, fail) :-
    required_result(all_performed_without_request, required(Duties)),
    member(review_report_in_searchable_electronic_format, Duties).
test(required_for_a_false_gate_lists_nothing, fail) :-
    required_result(not_an_article_16_1_entity, required(_)).

cp_test_names([all_performed_without_request_is_complete, one_testing_duty_not_performed_is_incomplete, conclusions_missing_without_request_is_complete, conclusions_missing_with_request_is_incomplete, conclusions_missing_request_unanswered_names_the_request, evidence_missing_without_supervisory_instructions_is_complete, evidence_missing_with_supervisory_instructions_is_incomplete, all_performed_with_both_reasons_is_complete, incident_list_missing_is_incomplete, an_unsure_backup_duty_is_referred, a_false_duty_decides_before_the_unsure_one, a_false_gate_is_not_an_article_16_1_entity, an_unanswered_gate_is_named, a_microenterprise_key_is_unknown, an_unsure_request_is_wrong_type, a_gate_given_twice_is_a_duplicate, outstanding_none_when_all_performed, outstanding_lists_the_testing_plan, outstanding_conclusions_with_request, outstanding_conclusions_without_request_is_none, required_without_request_has_twenty_three, required_with_both_reasons_has_thirty_eight, required_for_a_false_gate_is_not_a_list]).
cp_test_fail_names([one_testing_duty_not_performed_is_not_complete, conclusions_missing_with_request_is_not_complete, conclusions_missing_request_unanswered_is_not_complete, evidence_missing_with_supervisory_instructions_is_not_complete, incident_list_missing_is_not_complete, a_false_duty_beside_an_unsure_one_is_not_referred, a_false_gate_is_not_complete, an_unanswered_gate_is_not_complete, a_microenterprise_key_is_not_complete, a_gate_given_twice_is_not_wrong_type, outstanding_with_a_failure_is_not_none, required_without_request_has_no_report_duty, required_for_a_false_gate_lists_nothing]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
