% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis/2, request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_queries, [gdpr_data_subject_rights_erasure_basis_compliance_check/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_profile_for/2]).

basis_of(Subject, Basis) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile),
    request_basis(Profile, Basis).

retention_of(Subject, Result) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, Result).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    request_basis_status_values(StatusValues),
    member(art17_1_b, StatusValues).
test(the_necessity_profile_is_art17_1_a) :-
    basis_of(necessity_no_longer, art17_1_a).
test(ground_a_positive_is_prohibited_retention) :-
    retention_of(necessity_no_longer, prohibited).
test(ground_a_near_miss_no_ground_is_permitted) :-
    basis_of(no_ground_engaged, none),
    retention_of(no_ground_engaged, permitted).
test(ground_b_positive) :-
    basis_of(consent_withdrawn_no_other_ground, art17_1_b).
test(ground_b_near_miss_other_ground_exists) :-
    basis_of(consent_withdrawn_other_ground_exists, none),
    retention_of(consent_withdrawn_other_ground_exists, permitted).
test(ground_c_positive) :-
    basis_of(objection_21_1_without_overriding, art17_1_c).
test(ground_c_near_miss_overriding_grounds) :-
    basis_of(objection_21_1_with_overriding, none).
test(ground_c_art21_2_positive) :-
    basis_of(objection_21_2, art17_1_c).
test(ground_d_positive) :-
    basis_of(unlawfully_processed, art17_1_d).
test(ground_d_near_miss_base_profile) :-
    basis_of(no_ground_engaged, none).
test(ground_e_positive_attested) :-
    basis_of(law_requires_erasure, art17_1_e),
    retention_of(law_requires_erasure, prohibited).
test(ground_e_near_miss_unattested_refers) :-
    basis_of(law_requires_erasure_unattested, none),
    retention_of(law_requires_erasure_unattested, undetermined).
test(ground_f_positive) :-
    basis_of(information_society_offer, art17_1_f).
test(ground_f_near_miss_base_profile) :-
    retention_of(no_ground_engaged, permitted).
test(unsure_necessity_is_undetermined) :-
    basis_of(necessity_unsure, none),
    retention_of(necessity_unsure, undetermined).
test(exception_17_3_a_positive_relieves) :-
    retention_of(freedom_of_expression_exception, permitted).
test(exception_17_3_a_near_miss_not_necessary) :-
    retention_of(freedom_of_expression_not_necessary, prohibited).
test(exception_12_5_positive_relieves) :-
    retention_of(manifestly_excessive_request, permitted).
test(exception_12_5_near_miss_not_excessive) :-
    retention_of(request_not_excessive, prohibited).
test(suspension_positive_unconfirmed) :-
    basis_of(identity_doubts_unconfirmed, none),
    retention_of(identity_doubts_unconfirmed, undetermined).
test(suspension_near_miss_confirmed) :-
    basis_of(identity_doubts_confirmed, art17_1_a),
    retention_of(identity_doubts_confirmed, prohibited).
test(exception_12_2_positive_relieves) :-
    retention_of(unable_to_identify, permitted).
test(exception_12_2_near_miss_identifiable) :-
    retention_of(necessity_no_longer, prohibited).
test(exception_23_positive_relieves) :-
    retention_of(legislative_restriction, permitted).
test(exception_23_near_miss_no_restriction) :-
    retention_of(necessity_no_longer, prohibited).
test(input_problem_positive_has_no_basis) :-
    basis_of(unknown_key_present, none),
    retention_of(unknown_key_present, undetermined).
test(input_problem_near_miss_without_the_unknown_key) :-
    basis_of(necessity_no_longer, art17_1_a).
test(missing_required_keys_give_no_basis) :-
    basis_of(request_type_only, none),
    retention_of(request_type_only, undetermined).

test(the_necessity_profile_is_not_art17_1_b, fail) :-
    basis_of(necessity_no_longer, art17_1_b).
test(ground_a_near_miss_is_not_art17_1_a, fail) :-
    basis_of(no_ground_engaged, art17_1_a).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, the_necessity_profile_is_art17_1_a, ground_a_positive_is_prohibited_retention, ground_a_near_miss_no_ground_is_permitted, ground_b_positive, ground_b_near_miss_other_ground_exists, ground_c_positive, ground_c_near_miss_overriding_grounds, ground_c_art21_2_positive, ground_d_positive, ground_d_near_miss_base_profile, ground_e_positive_attested, ground_e_near_miss_unattested_refers, ground_f_positive, ground_f_near_miss_base_profile, unsure_necessity_is_undetermined, exception_17_3_a_positive_relieves, exception_17_3_a_near_miss_not_necessary, exception_12_5_positive_relieves, exception_12_5_near_miss_not_excessive, suspension_positive_unconfirmed, suspension_near_miss_confirmed, exception_12_2_positive_relieves, exception_12_2_near_miss_identifiable, exception_23_positive_relieves, exception_23_near_miss_no_restriction, input_problem_positive_has_no_basis, input_problem_near_miss_without_the_unknown_key, missing_required_keys_give_no_basis]).
cp_test_fail_names([the_necessity_profile_is_not_art17_1_b, ground_a_near_miss_is_not_art17_1_a]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
