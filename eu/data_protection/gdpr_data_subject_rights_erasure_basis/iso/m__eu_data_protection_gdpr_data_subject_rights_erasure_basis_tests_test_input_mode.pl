% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_kernel, [gdpr_data_subject_rights_erasure_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    request_basis_status(Profile, art17_1_a).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    gdpr_data_subject_rights_erasure_basis_input_problems(Profile, []).
test(an_absent_key_is_not_a_problem) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_type, erasure)], []).
test(the_empty_profile_has_no_problem) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([], []).
test(an_unknown_key_is_named) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(no_such_key, true)], [unknown_key(no_such_key)]).
test(an_enum_outside_its_values_is_wrong_type) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_type, shopping)], [wrong_type(request_type)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(consent_withdrawn, unsure)], [wrong_type(consent_withdrawn)]).
test(a_judgement_may_be_unsure) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(data_no_longer_necessary_for_purposes, unsure)], []).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(legislative_restriction_applies_to_the_right, true)], [wrong_type(legislative_restriction_applies_to_the_right)]).
test(an_impossible_date_is_wrong_type) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_received_on, date(2026, 2, 30))], [wrong_type(request_received_on)]).
test(a_duplicate_key_is_named_once) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_type, erasure), attribute(request_type, erasure)], [duplicate_key(request_type)]).
test(a_non_list_is_not_a_profile) :-
    gdpr_data_subject_rights_erasure_basis_input_problems(not_a_list, [wrong_type(profile)]).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    request_basis_status(Profile, art17_1_b).
test(a_profile_with_a_problem_has_no_basis, fail) :-
    gdpr_data_subject_rights_erasure_basis_input_problems([attribute(request_type, shopping)], []).

cp_test_names([status_holds_with_the_verdict_bound, a_well_formed_profile_has_no_problem, an_absent_key_is_not_a_problem, the_empty_profile_has_no_problem, an_unknown_key_is_named, an_enum_outside_its_values_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_judgement_may_be_unsure, a_bare_outside_fact_is_wrong_type, an_impossible_date_is_wrong_type, a_duplicate_key_is_named_once, a_non_list_is_not_a_profile]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, a_profile_with_a_problem_has_no_basis]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
