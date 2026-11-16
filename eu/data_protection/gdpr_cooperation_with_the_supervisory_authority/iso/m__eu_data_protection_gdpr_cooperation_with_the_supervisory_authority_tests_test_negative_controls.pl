% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    member(cooperation_not_required, StatusValues),
    member(cooperation_met, StatusValues),
    member(cooperation_not_met, StatusValues).
test(wrong_type_positive) :-
    status_of(wrong_type_role_key, input_problems([wrong_type(acts_as_controller)])).
test(wrong_type_control_is_decided) :-
    status_of(wrong_type_control, cooperation_not_required).
test(duplicate_positive) :-
    status_of(duplicate_role_key, input_problems([duplicate_key(acts_as_controller)])).
test(duplicate_control_is_decided) :-
    status_of(duplicate_control, cooperation_not_required).
test(unknown_key_positive) :-
    status_of(unknown_key_given, input_problems([unknown_key(as_of_date)])).
test(unknown_key_control_is_decided) :-
    status_of(unknown_key_control, cooperation_not_required).
test(no_request_positive) :-
    status_of(no_request_made, cooperation_not_required).
test(request_made_control) :-
    status_of(request_made_and_cooperated, cooperation_met).
test(outside_tasks_positive) :-
    status_of(request_outside_authority_tasks, cooperation_not_required).
test(within_tasks_control) :-
    status_of(request_within_authority_tasks, cooperation_met).
test(not_bound_positive) :-
    status_of(caller_not_bound, cooperation_not_required).
test(representative_control) :-
    status_of(representative_alone_bound, cooperation_met).
test(processor_missing_positive) :-
    status_of(processor_key_missing, indeterminate([acts_as_processor])).
test(processor_given_control) :-
    status_of(processor_key_given, cooperation_met).
test(request_missing_positive) :-
    status_of(request_key_missing, indeterminate([authority_request_made])).
test(request_given_control) :-
    status_of(request_key_given, cooperation_not_required).
test(statement_absent_positive) :-
    status_of(cooperation_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), _)).
test(statement_false_control) :-
    status_of(cooperation_statement_attested_false, cooperation_not_met).
test(unsure_and_absent_refers_on_the_statement) :-
    status_of(unsure_and_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), _)).
test(unsure_and_given_refers_on_the_judgement) :-
    status_of(unsure_and_statement_given, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), _)).
test(unsure_positive) :-
    status_of(tasks_judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
test(judgement_true_control) :-
    status_of(tasks_judgement_true, cooperation_met).
test(attested_true_positive) :-
    status_of(request_made_and_cooperated, cooperation_met).
test(attested_false_positive) :-
    status_of(cooperation_statement_attested_false, cooperation_not_met).

test(wrong_type_control_has_no_problem, fail) :-
    status_of(wrong_type_control, input_problems(_)).
test(wrong_type_is_not_decided, fail) :-
    status_of(wrong_type_role_key, cooperation_not_required).
test(duplicate_is_not_decided, fail) :-
    status_of(duplicate_role_key, cooperation_not_required).
test(unknown_key_is_not_decided, fail) :-
    status_of(unknown_key_given, cooperation_not_required).
test(no_request_is_not_met, fail) :-
    status_of(no_request_made, cooperation_met).
test(request_made_is_not_not_required, fail) :-
    status_of(request_made_and_cooperated, cooperation_not_required).
test(outside_tasks_is_not_met, fail) :-
    status_of(request_outside_authority_tasks, cooperation_met).
test(not_bound_is_not_met, fail) :-
    status_of(caller_not_bound, cooperation_met).
test(representative_is_bound, fail) :-
    status_of(representative_alone_bound, cooperation_not_required).
test(processor_missing_is_not_met, fail) :-
    status_of(processor_key_missing, cooperation_met).
test(request_missing_is_not_not_required, fail) :-
    status_of(request_key_missing, cooperation_not_required).
test(statement_absent_is_not_not_met, fail) :-
    status_of(cooperation_statement_absent, cooperation_not_met).
test(statement_absent_is_never_indeterminate, fail) :-
    status_of(cooperation_statement_absent, indeterminate(_)).
test(unsure_and_absent_is_not_open_textured, fail) :-
    status_of(unsure_and_statement_absent, needs_legal_review(open_textured(_, _), _)).
test(unsure_is_not_met, fail) :-
    status_of(tasks_judgement_unsure, cooperation_met).
test(attested_false_is_not_met, fail) :-
    status_of(cooperation_statement_attested_false, cooperation_met).
test(attested_true_is_not_not_met, fail) :-
    status_of(request_made_and_cooperated, cooperation_not_met).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, wrong_type_positive, wrong_type_control_is_decided, duplicate_positive, duplicate_control_is_decided, unknown_key_positive, unknown_key_control_is_decided, no_request_positive, request_made_control, outside_tasks_positive, within_tasks_control, not_bound_positive, representative_control, processor_missing_positive, processor_given_control, request_missing_positive, request_given_control, statement_absent_positive, statement_false_control, unsure_and_absent_refers_on_the_statement, unsure_and_given_refers_on_the_judgement, unsure_positive, judgement_true_control, attested_true_positive, attested_false_positive]).
cp_test_fail_names([wrong_type_control_has_no_problem, wrong_type_is_not_decided, duplicate_is_not_decided, unknown_key_is_not_decided, no_request_is_not_met, request_made_is_not_not_required, outside_tasks_is_not_met, not_bound_is_not_met, representative_is_bound, processor_missing_is_not_met, request_missing_is_not_not_required, statement_absent_is_not_not_met, statement_absent_is_never_indeterminate, unsure_and_absent_is_not_open_textured, unsure_is_not_met, attested_false_is_not_met, attested_true_is_not_not_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
