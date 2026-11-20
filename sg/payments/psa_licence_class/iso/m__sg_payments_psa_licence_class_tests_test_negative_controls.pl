% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [psa_licence_class_status/2, psa_licence_class_status_values/1]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_profile_for/2]).

test(no_services_is_no_licence_required) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, no_licence_required).
test(exempt_is_exempt) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_status(Profile, exempt_payment_service_provider).
test(money_changing_only_is_money_changing_licence) :-
    psa_licence_class_profile_for(money_changing_only, Profile),
    psa_licence_class_status(Profile, money_changing_licence).
test(single_volume_mpi_is_major) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(multi_volume_mpi_is_major) :-
    psa_licence_class_profile_for(multi_volume_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(e_money_float_mpi_is_major) :-
    psa_licence_class_profile_for(e_money_float_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(e_money_issued_mpi_is_major) :-
    psa_licence_class_profile_for(e_money_issued_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(missing_services_is_indeterminate) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_status(Profile, indeterminate).
test(near_miss_verdicts_are_real_atoms) :-
    psa_licence_class_status_values(StatusValues),
    member(standard_payment_institution_licence, StatusValues),
    member(major_payment_institution_licence, StatusValues),
    member(no_licence_required, StatusValues),
    member(exempt_payment_service_provider, StatusValues),
    member(money_changing_licence, StatusValues),
    member(indeterminate, StatusValues).

test(no_services_near_miss_is_not_no_licence_required, fail) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_status(Profile, no_licence_required).
test(exempt_near_miss_is_not_exempt, fail) :-
    psa_licence_class_profile_for(exempt_near_miss, Profile),
    psa_licence_class_status(Profile, exempt_payment_service_provider).
test(money_changing_near_miss_is_not_money_changing_licence, fail) :-
    psa_licence_class_profile_for(money_changing_near_miss, Profile),
    psa_licence_class_status(Profile, money_changing_licence).
test(single_volume_at_threshold_is_not_major, fail) :-
    psa_licence_class_profile_for(single_volume_at_threshold, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(multi_volume_at_threshold_is_not_major, fail) :-
    psa_licence_class_profile_for(multi_volume_at_threshold, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(e_money_float_at_threshold_is_not_major, fail) :-
    psa_licence_class_profile_for(e_money_float_at_threshold, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(e_money_issued_at_threshold_is_not_major, fail) :-
    psa_licence_class_profile_for(e_money_issued_at_threshold, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(no_services_is_not_indeterminate, fail) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, indeterminate).

cp_test_names([no_services_is_no_licence_required, exempt_is_exempt, money_changing_only_is_money_changing_licence, single_volume_mpi_is_major, multi_volume_mpi_is_major, e_money_float_mpi_is_major, e_money_issued_mpi_is_major, missing_services_is_indeterminate, near_miss_verdicts_are_real_atoms]).
cp_test_fail_names([no_services_near_miss_is_not_no_licence_required, exempt_near_miss_is_not_exempt, money_changing_near_miss_is_not_money_changing_licence, single_volume_at_threshold_is_not_major, multi_volume_at_threshold_is_not_major, e_money_float_at_threshold_is_not_major, e_money_issued_at_threshold_is_not_major, no_services_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
