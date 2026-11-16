% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [request_basis_status/2, request_basis/2, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    request_basis_status(Profile, art22_1).
test(basis_none_when_not_engaged) :-
    gdpr_data_subject_rights_automated_decision_profile_for(not_solely_automated, Profile),
    request_basis(Profile, none).
test(basis_is_input_problems_for_unknown_key) :-
    gdpr_data_subject_rights_automated_decision_profile_for(unknown_key_input_problem, Profile),
    request_basis(Profile, input_problems([unknown_key(bogus_key)])).
test(bound_must_comply_verdict) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, art22_1, none, [], [cite(eu_reg_2016_679_art_22_1)])).
test(bound_suspended_verdict) :-
    gdpr_data_subject_rights_automated_decision_profile_for(identity_suspended, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(bound_indeterminate_verdict) :-
    gdpr_data_subject_rights_automated_decision_profile_for(request_type_missing, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    request_basis_status(Profile, none).
test(bound_wrong_comply_is_rejected, fail) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, _, _, _, _)).

cp_test_names([status_holds_with_the_verdict_bound, basis_none_when_not_engaged, basis_is_input_problems_for_unknown_key, bound_must_comply_verdict, bound_suspended_verdict, bound_indeterminate_verdict]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, bound_wrong_comply_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
