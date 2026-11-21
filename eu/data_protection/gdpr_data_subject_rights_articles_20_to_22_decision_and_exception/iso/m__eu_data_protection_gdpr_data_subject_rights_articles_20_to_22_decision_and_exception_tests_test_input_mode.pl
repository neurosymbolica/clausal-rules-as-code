% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile).

decision_of(Subject, Comply) :-
    subject_profile(Subject, Profile),
    request_decision(Profile, Comply).

exception_of(Subject, Exception) :-
    subject_profile(Subject, Profile),
    request_exception(Profile, Exception).

test(must_comply_holds_bound) :-
    decision_of(portability_engaged_must_comply, must_comply).
test(need_not_comply_holds_bound) :-
    decision_of(portability_not_automated_not_engaged, need_not_comply).
test(relief_exception_holds_bound) :-
    exception_of(portability_public_task_relieves, art20_3_public_task).
test(indeterminate_holds_with_a_partial_pattern) :-
    decision_of(portability_missing_keys, indeterminate(_)).
test(indeterminate_holds_with_the_full_list) :-
    decision_of(portability_missing_keys, indeterminate([personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means])).
test(referral_holds_bound) :-
    decision_of(manifestly_excessive_unsure_refers, needs_legal_review(open_textured(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)), [inputs_relied_on([request_type - portability, request_manifestly_unfounded_or_excessive - unsure])])).
test(suspended_holds_bound) :-
    decision_of(identity_doubts_suspend, suspended(art12_6_identity_not_confirmed)).
test(suspended_exception_is_none_bound) :-
    exception_of(identity_doubts_suspend, none).
test(status_projection_holds_bound) :-
    subject_profile(portability_rights_of_others_relieves, Profile),
    request_exception_status(Profile, art20_4_rights_of_others).
test(input_problems_hold_bound) :-
    decision_of(duplicate_and_unknown_keys, input_problems([duplicate_key(request_type), unknown_key(colour)])).
test(input_problems_exception_is_none_bound) :-
    exception_of(duplicate_and_unknown_keys, none).
test(a_non_list_profile_is_wrong_type_profile) :-
    request_decision(portability, input_problems([wrong_type(profile)])).
test(a_bare_outside_fact_is_wrong_type) :-
    request_decision([attribute(request_type, portability), attribute(legislative_restriction_applies_to_the_right, true)], input_problems([wrong_type(legislative_restriction_applies_to_the_right)])).
test(a_crisp_flag_given_unsure_is_wrong_type) :-
    decision_of(crisp_flag_given_unsure_wrong_type, input_problems([wrong_type(processing_carried_out_by_automated_means)])).
test(a_judgement_outside_its_type_is_wrong_type) :-
    request_decision([attribute(request_manifestly_unfounded_or_excessive, maybe)], input_problems([wrong_type(request_manifestly_unfounded_or_excessive)])).
test(a_request_type_outside_the_enum_is_wrong_type) :-
    request_decision([attribute(request_type, complaint)], input_problems([wrong_type(request_type)])).
test(an_objection_ground_outside_the_enum_is_wrong_type) :-
    request_decision([attribute(request_type, objection), attribute(objection_ground_claimed, art21_4)], input_problems([wrong_type(objection_ground_claimed)])).
test(a_receipt_that_is_not_a_date_is_wrong_type) :-
    request_decision([attribute(request_received_on, yesterday)], input_problems([wrong_type(request_received_on)])).
test(an_unknown_key_gives_exception_none) :-
    request_exception([attribute(colour, red)], none).
test(an_unread_key_does_not_change_the_answer) :-
    subject_profile(portability_engaged_must_comply, Profile),
    append(Profile, [attribute(consent_withdrawn, true)], Extended),
    request_decision(Extended, must_comply).
test(a_sibling_order_type_is_well_formed_and_not_engaged) :-
    request_decision([attribute(request_type, rectification)], need_not_comply).
test(a_well_formed_profile_has_no_problem) :-
    subject_profile(portability_engaged_must_comply, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, []).

test(must_comply_profile_rejects_bound_need_not_comply, fail) :-
    decision_of(portability_engaged_must_comply, need_not_comply).
test(not_engaged_profile_rejects_bound_must_comply, fail) :-
    decision_of(portability_not_automated_not_engaged, must_comply).
test(relief_exception_rejects_bound_none, fail) :-
    exception_of(portability_public_task_relieves, none).
test(the_bare_indeterminate_atom_never_answers, fail) :-
    decision_of(portability_missing_keys, indeterminate).

cp_test_names([must_comply_holds_bound, need_not_comply_holds_bound, relief_exception_holds_bound, indeterminate_holds_with_a_partial_pattern, indeterminate_holds_with_the_full_list, referral_holds_bound, suspended_holds_bound, suspended_exception_is_none_bound, status_projection_holds_bound, input_problems_hold_bound, input_problems_exception_is_none_bound, a_non_list_profile_is_wrong_type_profile, a_bare_outside_fact_is_wrong_type, a_crisp_flag_given_unsure_is_wrong_type, a_judgement_outside_its_type_is_wrong_type, a_request_type_outside_the_enum_is_wrong_type, an_objection_ground_outside_the_enum_is_wrong_type, a_receipt_that_is_not_a_date_is_wrong_type, an_unknown_key_gives_exception_none, an_unread_key_does_not_change_the_answer, a_sibling_order_type_is_well_formed_and_not_engaged, a_well_formed_profile_has_no_problem]).
cp_test_fail_names([must_comply_profile_rejects_bound_need_not_comply, not_engaged_profile_rejects_bound_must_comply, relief_exception_rejects_bound_none, the_bare_indeterminate_atom_never_answers]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
