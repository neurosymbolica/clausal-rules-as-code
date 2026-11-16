% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis, [request_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_profile_for/2]).

test(must_comply_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)])).
test(exception_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(objection_art21_2_excessive, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, art21_2, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3)])).
test(suspension_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_suspended, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(input_problem_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(unknown_key_problem, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(input_problems([unknown_key(no_such_key)]), none, none, [], [])).
test(basis_holds_with_the_basis_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(objection_art21_2_positive, Profile),
    request_basis(Profile, art21_2).
test(input_problems_give_input_problems_answer) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(unknown_key_problem, Profile),
    request_basis(Profile, input_problems([unknown_key(no_such_key)])).
test(a_non_list_profile_gives_wrong_type_profile) :-
    request_basis(not_a_profile, input_problems([wrong_type(profile)])).
test(status_holds_with_the_status_bound) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    request_basis_status(Profile, art20_1).

test(the_wrong_bound_comply_is_rejected, fail) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, _, _, _, _)).
test(the_wrong_bound_basis_is_rejected, fail) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(objection_art21_2_positive, Profile),
    request_basis(Profile, art21_1).
test(input_problems_are_not_basis_none, fail) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(unknown_key_problem, Profile),
    request_basis(Profile, none).
test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    request_basis_status(Profile, art21_1).

cp_test_names([must_comply_holds_with_the_verdict_bound, exception_holds_with_the_verdict_bound, suspension_holds_with_the_verdict_bound, input_problem_holds_with_the_verdict_bound, basis_holds_with_the_basis_bound, input_problems_give_input_problems_answer, a_non_list_profile_gives_wrong_type_profile, status_holds_with_the_status_bound]).
cp_test_fail_names([the_wrong_bound_comply_is_rejected, the_wrong_bound_basis_is_rejected, input_problems_are_not_basis_none, the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
