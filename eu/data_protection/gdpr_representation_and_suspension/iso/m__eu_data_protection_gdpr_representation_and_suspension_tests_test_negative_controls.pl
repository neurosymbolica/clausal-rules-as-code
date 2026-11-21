% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [gdpr_representation_and_suspension_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_assess/2]).

result_of(Subject, Result) :-
    gdpr_representation_and_suspension_assess(Subject, gdpr_representation_and_suspension_verdict(Result, _Basis, _Citations)).

table_atom(Atom) :-
    gdpr_representation_and_suspension_status_values(StatusValues),
    member(Atom, StatusValues).

test(every_atom_used_below_is_a_table_atom) :-
    maplist(table_atom, [may_act_on_mandate, may_not_act_on_mandate, may_act_without_mandate, may_not_act_without_mandate, contact_duty_applies, contact_duty_does_not_apply, may_suspend_proceedings, suspension_not_available, may_decline_jurisdiction, declining_jurisdiction_not_available]).
test(mandated_positive) :-
    result_of(mandated_complaint_qualified, may_act_on_mandate).
test(mandated_near_miss_gets_the_refusal) :-
    result_of(mandated_complaint_not_mandated, may_not_act_on_mandate).
test(mandated_public_interest_false_refuses) :-
    result_of(mandated_complaint_public_interest_false, may_not_act_on_mandate).
test(mandated_public_interest_unsure_goes_to_a_lawyer) :-
    result_of(mandated_complaint_public_interest_unsure, needs_legal_review(open_textured(body_statutory_objectives_in_public_interest, _), _)).
test(compensation_positive) :-
    result_of(mandated_compensation_law_attested, may_act_on_mandate).
test(compensation_near_miss_refuses) :-
    result_of(mandated_compensation_law_refused, may_not_act_on_mandate).
test(d204_compensation_refers_first) :-
    result_of(mandated_compensation_law_and_mandate_absent, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(d296_complaint_names_the_mandate) :-
    result_of(mandated_complaint_mandate_missing, indeterminate([data_subject_mandated_the_body])).
test(without_mandate_positive) :-
    result_of(without_mandate_complaint_provided, may_act_without_mandate).
test(without_mandate_near_miss_refuses) :-
    result_of(without_mandate_complaint_not_considered, may_not_act_without_mandate).
test(without_mandate_law_refused_refuses) :-
    result_of(without_mandate_complaint_law_refused, may_not_act_without_mandate).
test(without_mandate_law_absent_refers) :-
    result_of(without_mandate_complaint_law_absent, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(without_mandate_compensation_refuses) :-
    result_of(without_mandate_compensation_refused, may_not_act_without_mandate).
test(contact_positive) :-
    result_of(court_contact_related, contact_duty_applies).
test(contact_near_miss_does_not_apply) :-
    result_of(court_contact_without_information, contact_duty_does_not_apply).
test(suspension_positive) :-
    result_of(court_suspension_second_court, may_suspend_proceedings).
test(suspension_near_miss_not_available) :-
    result_of(court_suspension_court_first_seized, suspension_not_available).
test(declining_positive) :-
    result_of(court_declining_consolidation_permitted, may_decline_jurisdiction).
test(declining_near_miss_not_available) :-
    result_of(court_declining_consolidation_refused, declining_jurisdiction_not_available).
test(declining_first_instance_near_miss_not_available) :-
    result_of(court_declining_not_first_instance, declining_jurisdiction_not_available).
test(declining_does_not_read_competence) :-
    result_of(court_declining_incompetent_court, may_decline_jurisdiction).
test(input_problem_positive) :-
    result_of(input_unsure_crisp_key, input_problems([wrong_type(court_is_competent_court)])).
test(unknown_action_positive) :-
    result_of(input_unknown_action, input_problems([wrong_type(action)])).

test(mandated_near_miss_may_not_act, fail) :-
    result_of(mandated_complaint_not_mandated, may_act_on_mandate).
test(mandated_public_interest_false_may_not_act, fail) :-
    result_of(mandated_complaint_public_interest_false, may_act_on_mandate).
test(mandated_public_interest_unsure_is_not_settled, fail) :-
    result_of(mandated_complaint_public_interest_unsure, may_act_on_mandate).
test(compensation_near_miss_may_not_act, fail) :-
    result_of(mandated_compensation_law_refused, may_act_on_mandate).
test(d204_compensation_does_not_name_the_mandate, fail) :-
    result_of(mandated_compensation_law_and_mandate_absent, indeterminate(_)).
test(d296_complaint_does_not_refer, fail) :-
    result_of(mandated_complaint_mandate_missing, needs_legal_review(_, _)).
test(without_mandate_near_miss_may_not_act, fail) :-
    result_of(without_mandate_complaint_not_considered, may_act_without_mandate).
test(without_mandate_law_absent_is_not_settled, fail) :-
    result_of(without_mandate_complaint_law_absent, may_act_without_mandate).
test(without_mandate_compensation_may_not_act, fail) :-
    result_of(without_mandate_compensation_refused, may_act_without_mandate).
test(contact_near_miss_has_no_duty, fail) :-
    result_of(court_contact_without_information, contact_duty_applies).
test(suspension_near_miss_may_not_suspend, fail) :-
    result_of(court_suspension_court_first_seized, may_suspend_proceedings).
test(declining_near_miss_may_not_decline, fail) :-
    result_of(court_declining_consolidation_refused, may_decline_jurisdiction).
test(declining_first_instance_near_miss_may_not_decline, fail) :-
    result_of(court_declining_not_first_instance, may_decline_jurisdiction).
test(input_problem_gets_no_verdict, fail) :-
    result_of(input_unsure_crisp_key, contact_duty_does_not_apply).
test(unknown_action_gets_no_verdict, fail) :-
    result_of(input_unknown_action, may_act_on_mandate).

cp_test_names([every_atom_used_below_is_a_table_atom, mandated_positive, mandated_near_miss_gets_the_refusal, mandated_public_interest_false_refuses, mandated_public_interest_unsure_goes_to_a_lawyer, compensation_positive, compensation_near_miss_refuses, d204_compensation_refers_first, d296_complaint_names_the_mandate, without_mandate_positive, without_mandate_near_miss_refuses, without_mandate_law_refused_refuses, without_mandate_law_absent_refers, without_mandate_compensation_refuses, contact_positive, contact_near_miss_does_not_apply, suspension_positive, suspension_near_miss_not_available, declining_positive, declining_near_miss_not_available, declining_first_instance_near_miss_not_available, declining_does_not_read_competence, input_problem_positive, unknown_action_positive]).
cp_test_fail_names([mandated_near_miss_may_not_act, mandated_public_interest_false_may_not_act, mandated_public_interest_unsure_is_not_settled, compensation_near_miss_may_not_act, d204_compensation_does_not_name_the_mandate, d296_complaint_does_not_refer, without_mandate_near_miss_may_not_act, without_mandate_law_absent_is_not_settled, without_mandate_compensation_may_not_act, contact_near_miss_has_no_duty, suspension_near_miss_may_not_suspend, declining_near_miss_may_not_decline, declining_first_instance_near_miss_may_not_decline, input_problem_gets_no_verdict, unknown_action_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
