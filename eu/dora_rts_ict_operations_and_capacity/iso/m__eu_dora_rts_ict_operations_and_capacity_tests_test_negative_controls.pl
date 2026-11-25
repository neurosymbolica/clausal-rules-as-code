% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_dora_rts_ict_operations_and_capacity, [rts_ict_operations_and_capacity_duties_required/3, rts_ict_operations_and_capacity_duties_complete/3, rts_ict_operations_and_capacity_duties_outstanding/3, dora_rts_ict_operations_and_capacity_status/2, dora_rts_ict_operations_and_capacity_status_values/1]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_fixtures, [dora_rts_ict_operations_and_capacity_profile_for/2]).

subject_status(Subject, Status) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    dora_rts_ict_operations_and_capacity_status(Profile, Status).

test(the_status_table_has_a_near_miss_atom) :-
    dora_rts_ict_operations_and_capacity_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_status_table_names_every_final_answer) :-
    dora_rts_ict_operations_and_capacity_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues).
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_rts_ict_operations_and_capacity_profile_for(todo_baseline_subject, Profile),
    findall(Status, dora_rts_ict_operations_and_capacity_status(Profile, Status), [_]).
test(the_near_miss_baseline_is_complete) :-
    subject_status(every_duty_performed_without_production, complete).
test(an_article_16_1_entity_is_the_simplified_framework) :-
    subject_status(article_16_1_entity, simplified_framework_entity).
test(an_unstated_gate_is_asked) :-
    subject_status(gate_not_stated, indeterminate([financial_entity_is_article_16_1_entity])).
test(a_duty_not_performed_is_incomplete) :-
    subject_status(one_duty_not_performed, incomplete).
test(security_not_ensured_in_production_is_incomplete) :-
    subject_status(production_security_not_ensured, incomplete).
test(security_not_ensured_without_production_is_complete) :-
    subject_status(no_production_security_not_ensured, complete).
test(security_ensured_in_production_is_complete) :-
    subject_status(every_duty_performed_with_production, complete).
test(an_unstated_trigger_over_a_false_duty_is_asked) :-
    subject_status(production_unstated_security_not_ensured, indeterminate([development_or_testing_performed_in_production_environment])).
test(an_unstated_trigger_over_a_true_duty_is_complete) :-
    subject_status(production_unstated_security_ensured, complete).
test(an_unstated_duty_is_asked) :-
    subject_status(one_duty_unstated, indeterminate([capacity_procedures_apply_resource_optimisation])).
test(a_false_key_decides_before_absent_keys) :-
    subject_status(failing_duty_with_others_unstated, incomplete).
test(an_unsure_duty_is_referred) :-
    subject_status(one_duty_unsure, needs_legal_review(open_textured(capacity_procedures_apply_resource_optimisation, cite(eu_reg_2024_1774_art_9_1_b)), _)).
test(an_unknown_key_is_an_input_problem) :-
    subject_status(unknown_key_given, input_problems([unknown_key(office_colour)])).
test(a_repeated_gate_is_an_input_problem) :-
    subject_status(repeated_gate, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(an_unsure_gate_is_an_input_problem) :-
    subject_status(gate_given_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(production_requires_the_security_duty) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_with_production, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), _),
    member(security_during_production_testing, Duties).
test(no_production_requires_the_policies_on_production_testing) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), _),
    member(development_and_testing_in_production_environments, Duties),
    member(production_testing_instances_identified_and_approved, Duties).
test(a_duty_not_performed_is_outstanding) :-
    dora_rts_ict_operations_and_capacity_profile_for(one_duty_not_performed, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding([backup_and_restore_requirements]), _).
test(every_duty_performed_is_none_outstanding) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, none_outstanding, _).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(todo_baseline_subject, Profile),
    findall(Status, dora_rts_ict_operations_and_capacity_status(Profile, Status), [BaselineStatus]),
    dora_rts_ict_operations_and_capacity_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_ict_operations_and_capacity_status(Profile, Other).
test(an_entity_not_of_article_16_1_is_not_the_simplified_framework, fail) :-
    subject_status(every_duty_performed_without_production, simplified_framework_entity).
test(a_stated_gate_is_not_asked, fail) :-
    subject_status(every_duty_performed_without_production, indeterminate(_)).
test(every_duty_performed_is_not_incomplete, fail) :-
    subject_status(every_duty_performed_without_production, incomplete).
test(security_not_ensured_without_production_is_not_incomplete, fail) :-
    subject_status(no_production_security_not_ensured, incomplete).
test(an_unstated_trigger_over_a_true_duty_is_not_asked, fail) :-
    subject_status(production_unstated_security_ensured, indeterminate(_)).
test(a_stated_duty_is_not_asked, fail) :-
    subject_status(every_duty_performed_without_production, indeterminate([capacity_procedures_apply_resource_optimisation])).
test(a_false_key_does_not_leave_the_answer_open, fail) :-
    subject_status(failing_duty_with_others_unstated, indeterminate(_)).
test(a_judged_duty_is_not_referred, fail) :-
    subject_status(every_duty_performed_without_production, needs_legal_review(_, _)).
test(a_well_formed_profile_is_not_an_input_problem, fail) :-
    subject_status(every_duty_performed_without_production, input_problems(_)).
test(no_production_does_not_require_the_security_duty, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), _),
    member(security_during_production_testing, Duties).
test(every_duty_performed_has_nothing_outstanding, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(every_duty_performed_without_production, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding(_), _).
test(a_duty_that_does_not_apply_is_not_outstanding, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(no_production_security_not_ensured, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding(_), _).
test(the_gate_true_is_never_incomplete, fail) :-
    dora_rts_ict_operations_and_capacity_profile_for(article_16_1_entity, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, incomplete, _).

cp_test_names([the_status_table_has_a_near_miss_atom, the_status_table_names_every_final_answer, the_baseline_profile_yields_exactly_one_status, the_near_miss_baseline_is_complete, an_article_16_1_entity_is_the_simplified_framework, an_unstated_gate_is_asked, a_duty_not_performed_is_incomplete, security_not_ensured_in_production_is_incomplete, security_not_ensured_without_production_is_complete, security_ensured_in_production_is_complete, an_unstated_trigger_over_a_false_duty_is_asked, an_unstated_trigger_over_a_true_duty_is_complete, an_unstated_duty_is_asked, a_false_key_decides_before_absent_keys, an_unsure_duty_is_referred, an_unknown_key_is_an_input_problem, a_repeated_gate_is_an_input_problem, an_unsure_gate_is_an_input_problem, production_requires_the_security_duty, no_production_requires_the_policies_on_production_testing, a_duty_not_performed_is_outstanding, every_duty_performed_is_none_outstanding]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, an_entity_not_of_article_16_1_is_not_the_simplified_framework, a_stated_gate_is_not_asked, every_duty_performed_is_not_incomplete, security_not_ensured_without_production_is_not_incomplete, an_unstated_trigger_over_a_true_duty_is_not_asked, a_stated_duty_is_not_asked, a_false_key_does_not_leave_the_answer_open, a_judged_duty_is_not_referred, a_well_formed_profile_is_not_an_input_problem, no_production_does_not_require_the_security_duty, every_duty_performed_has_nothing_outstanding, a_duty_that_does_not_apply_is_not_outstanding, the_gate_true_is_never_incomplete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
