% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [objection_right_notice/4, erasure_follow_up_duty/4, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixtures, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for/2]).

notice_of(Subject, Result) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    objection_right_notice(Profile, Result, _Basis, _Citations).

follow_up_of(Subject, Result) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    erasure_follow_up_duty(Profile, Result, _Basis, _Citations).

test(the_near_miss_atoms_are_the_status_values) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values(Values),
    clausal_msort(Values, Sorted),
    Sorted == [follow_up_duty_does_not_apply, follow_up_duty_met, follow_up_duty_not_met, notice_complies, notice_does_not_comply, notice_not_owed, notice_not_yet_due].
test(complies_positive) :-
    notice_of(duties_fulfilled, notice_complies).
test(does_not_comply_positive_clarity) :-
    notice_of(clarity_failed_near_miss, notice_does_not_comply).
test(does_not_comply_positive_separation) :-
    notice_of(separation_failed_near_miss, notice_does_not_comply).
test(does_not_comply_positive_explicit) :-
    notice_of(explicit_failed_near_miss, notice_does_not_comply).
test(not_owed_positive) :-
    notice_of(no_right_to_object, notice_not_owed).
test(not_yet_due_positive) :-
    notice_of(first_communication_pending, notice_not_yet_due).
test(first_communication_missing_positive) :-
    notice_of(first_communication_not_stated, indeterminate([first_communication_with_data_subject_has_taken_place])).
test(explicit_missing_positive) :-
    notice_of(explicit_not_stated, indeterminate([right_explicitly_brought_to_attention_by_first_communication])).
test(right_not_attested_positive) :-
    notice_of(right_not_attested, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])])).
test(clarity_unsure_positive) :-
    notice_of(clarity_unsure, needs_legal_review(open_textured(right_presented_clearly, cite(eu_reg_2016_679_art_21_4)), [inputs_relied_on([right_presented_clearly - unsure])])).
test(met_positive) :-
    follow_up_of(duties_fulfilled, follow_up_duty_met).
test(not_met_positive) :-
    follow_up_of(steps_failed_near_miss, follow_up_duty_not_met).
test(does_not_apply_positive_not_public) :-
    follow_up_of(data_not_public, follow_up_duty_does_not_apply).
test(does_not_apply_positive_no_obligation) :-
    follow_up_of(no_obligation_to_erase, follow_up_duty_does_not_apply).
test(publication_missing_positive) :-
    follow_up_of(publication_not_stated, indeterminate([controller_made_personal_data_public])).
test(steps_missing_positive) :-
    follow_up_of(steps_not_stated, indeterminate([reasonable_steps_taken_to_inform_other_controllers])).
test(obligation_not_attested_positive) :-
    follow_up_of(obligation_not_attested, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1 - absent])])).
test(steps_unsure_positive) :-
    follow_up_of(steps_unsure, needs_legal_review(open_textured(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)), [inputs_relied_on([reasonable_steps_taken_to_inform_other_controllers - unsure])])).
test(input_problem_positive) :-
    notice_of(bare_outside_fact_value, input_problems([wrong_type(right_to_object_applies)])).
test(input_problem_near_miss_gets_its_answer) :-
    objection_right_notice([attribute(right_to_object_applies, attested(true, attestation(host_user, host_time, stated_reason, none)))], indeterminate([first_communication_with_data_subject_has_taken_place]), [], []).
test(duplicate_key_positive) :-
    follow_up_of(duplicate_key_present, input_problems([duplicate_key(first_communication_with_data_subject_has_taken_place)])).

test(complies_near_miss_clarity_false, fail) :-
    notice_of(clarity_failed_near_miss, notice_complies).
test(complies_near_miss_separation_false, fail) :-
    notice_of(separation_failed_near_miss, notice_complies).
test(complies_near_miss_explicit_false, fail) :-
    notice_of(explicit_failed_near_miss, notice_complies).
test(does_not_comply_near_miss_all_met, fail) :-
    notice_of(duties_fulfilled, notice_does_not_comply).
test(not_owed_near_miss_right_attested_true, fail) :-
    notice_of(duties_fulfilled, notice_not_owed).
test(not_yet_due_near_miss_communication_made, fail) :-
    notice_of(duties_fulfilled, notice_not_yet_due).
test(first_communication_missing_near_miss_supplied, fail) :-
    notice_of(duties_fulfilled, indeterminate(_)).
test(explicit_missing_near_miss_explicit_false, fail) :-
    notice_of(explicit_failed_near_miss, indeterminate(_)).
test(right_not_attested_near_miss_attested, fail) :-
    notice_of(duties_fulfilled, needs_legal_review(_, _)).
test(clarity_unsure_near_miss_clarity_false, fail) :-
    notice_of(clarity_failed_near_miss, needs_legal_review(_, _)).
test(met_near_miss_steps_false, fail) :-
    follow_up_of(steps_failed_near_miss, follow_up_duty_met).
test(not_met_near_miss_steps_true, fail) :-
    follow_up_of(duties_fulfilled, follow_up_duty_not_met).
test(does_not_apply_near_miss_public_and_obliged, fail) :-
    follow_up_of(duties_fulfilled, follow_up_duty_does_not_apply).
test(publication_missing_near_miss_supplied, fail) :-
    follow_up_of(duties_fulfilled, indeterminate(_)).
test(steps_missing_near_miss_steps_false, fail) :-
    follow_up_of(steps_failed_near_miss, indeterminate(_)).
test(obligation_not_attested_near_miss_attested, fail) :-
    follow_up_of(duties_fulfilled, needs_legal_review(_, _)).
test(steps_unsure_near_miss_steps_false, fail) :-
    follow_up_of(steps_failed_near_miss, needs_legal_review(_, _)).
test(input_problem_near_miss_attested_value, fail) :-
    objection_right_notice([attribute(right_to_object_applies, attested(true, attestation(host_user, host_time, stated_reason, none)))], input_problems(_), _, _).
test(duplicate_key_near_miss_single_key, fail) :-
    erasure_follow_up_duty([attribute(first_communication_with_data_subject_has_taken_place, true)], input_problems(_), _, _).

cp_test_names([the_near_miss_atoms_are_the_status_values, complies_positive, does_not_comply_positive_clarity, does_not_comply_positive_separation, does_not_comply_positive_explicit, not_owed_positive, not_yet_due_positive, first_communication_missing_positive, explicit_missing_positive, right_not_attested_positive, clarity_unsure_positive, met_positive, not_met_positive, does_not_apply_positive_not_public, does_not_apply_positive_no_obligation, publication_missing_positive, steps_missing_positive, obligation_not_attested_positive, steps_unsure_positive, input_problem_positive, input_problem_near_miss_gets_its_answer, duplicate_key_positive]).
cp_test_fail_names([complies_near_miss_clarity_false, complies_near_miss_separation_false, complies_near_miss_explicit_false, does_not_comply_near_miss_all_met, not_owed_near_miss_right_attested_true, not_yet_due_near_miss_communication_made, first_communication_missing_near_miss_supplied, explicit_missing_near_miss_explicit_false, right_not_attested_near_miss_attested, clarity_unsure_near_miss_clarity_false, met_near_miss_steps_false, not_met_near_miss_steps_true, does_not_apply_near_miss_public_and_obliged, publication_missing_near_miss_supplied, steps_missing_near_miss_steps_false, obligation_not_attested_near_miss_attested, steps_unsure_near_miss_steps_false, input_problem_near_miss_attested_value, duplicate_key_near_miss_single_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
