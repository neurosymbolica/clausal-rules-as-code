% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [request_basis_status/2, request_basis_status_values/1, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_fixtures, [gdpr_data_subject_rights_access_rectification_restriction_profile_for/2, gdpr_data_subject_rights_access_rectification_restriction_assess/2]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(Subject, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

basis_of(Subject, Basis) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(Subject, gdpr_data_subject_request_verdict(_, Basis, _, _, _)).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    request_basis_status_values(StatusValues),
    member(art16_inaccurate_data, StatusValues).
test(the_access_profile_is_art15_1) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    request_basis_status(Profile, art15_1).
test(unfounded_true_relieves_the_controller) :-
    comply_of(access_unfounded, need_not_comply).
test(unfounded_false_must_comply) :-
    comply_of(access_not_unfounded, must_comply).
test(unable_to_identify_relieves_the_controller) :-
    comply_of(access_unable_to_identify, need_not_comply).
test(without_the_demonstration_the_controller_must_comply) :-
    comply_of(access_plain, must_comply).
test(attested_restriction_relieves_the_controller) :-
    comply_of(access_restricted_by_law, need_not_comply).
test(attested_false_restriction_does_not_relieve) :-
    decide_data_subject_request([attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(host, at_time, legal_register, none)))], gdpr_data_subject_request_verdict(must_comply, art15_1, none, [], _)).
test(doubts_without_confirmation_suspend) :-
    comply_of(access_identity_suspended, suspended(art12_6_identity_not_confirmed)).
test(doubts_with_confirmation_do_not_suspend) :-
    comply_of(access_identity_confirmed, must_comply).
test(inaccurate_data_engages_rectification) :-
    basis_of(rectification_inaccurate, art16_inaccurate_data).
test(nothing_wrong_does_not_engage_rectification) :-
    comply_of(rectification_not_engaged, need_not_comply).
test(incomplete_data_engages_rectification) :-
    basis_of(rectification_incomplete, art16_incomplete_data).
test(point_a_accuracy_contested) :-
    basis_of(restriction_accuracy_contested, art18_1_a).
test(point_b_unlawful_and_opposed) :-
    basis_of(restriction_unlawful_opposed, art18_1_b).
test(point_d_objection_pending) :-
    basis_of(restriction_objection_pending, art18_1_d).
test(no_point_met_is_not_engaged) :-
    comply_of(restriction_not_engaged, need_not_comply).
test(objection_without_pending_verification_is_open) :-
    comply_of(restriction_verification_unknown, indeterminate([verification_of_overriding_grounds_pending])).
test(objection_with_pending_verification_is_engaged) :-
    comply_of(restriction_objection_pending, must_comply).
test(an_unsure_judgement_is_referred) :-
    comply_of(access_unfounded_unsure, needs_legal_review(_, _)).
test(an_unknown_key_is_an_input_problem) :-
    comply_of(profile_with_unknown_key, input_problems([unknown_key(not_a_contract_key)])).

test(the_access_profile_is_not_art16_inaccurate_data, fail) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    request_basis_status(Profile, art16_inaccurate_data).
test(unfounded_false_does_not_relieve, fail) :-
    comply_of(access_not_unfounded, need_not_comply).
test(without_the_demonstration_no_relief, fail) :-
    comply_of(access_plain, need_not_comply).
test(attested_false_restriction_is_not_relief, fail) :-
    decide_data_subject_request([attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(host, at_time, legal_register, none)))], gdpr_data_subject_request_verdict(need_not_comply, _, _, _, _)).
test(doubts_with_confirmation_are_not_suspended, fail) :-
    comply_of(access_identity_confirmed, suspended(_)).
test(nothing_wrong_is_not_must_comply, fail) :-
    comply_of(rectification_not_engaged, must_comply).
test(no_point_met_is_not_must_comply, fail) :-
    comply_of(restriction_not_engaged, must_comply).
test(a_false_judgement_is_not_referred, fail) :-
    comply_of(access_not_unfounded, needs_legal_review(_, _)).
test(a_known_key_is_not_an_input_problem, fail) :-
    comply_of(access_plain, input_problems(_)).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, the_access_profile_is_art15_1, unfounded_true_relieves_the_controller, unfounded_false_must_comply, unable_to_identify_relieves_the_controller, without_the_demonstration_the_controller_must_comply, attested_restriction_relieves_the_controller, attested_false_restriction_does_not_relieve, doubts_without_confirmation_suspend, doubts_with_confirmation_do_not_suspend, inaccurate_data_engages_rectification, nothing_wrong_does_not_engage_rectification, incomplete_data_engages_rectification, point_a_accuracy_contested, point_b_unlawful_and_opposed, point_d_objection_pending, no_point_met_is_not_engaged, objection_without_pending_verification_is_open, objection_with_pending_verification_is_engaged, an_unsure_judgement_is_referred, an_unknown_key_is_an_input_problem]).
cp_test_fail_names([the_access_profile_is_not_art16_inaccurate_data, unfounded_false_does_not_relieve, without_the_demonstration_no_relief, attested_false_restriction_is_not_relief, doubts_with_confirmation_are_not_suspended, nothing_wrong_is_not_must_comply, no_point_met_is_not_must_comply, a_false_judgement_is_not_referred, a_known_key_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
