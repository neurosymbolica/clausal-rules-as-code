% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [psa_licence_class_status/2]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_profile_for/2]).

test(no_services_status_bound) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, no_licence_required).
test(exempt_status_bound) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_status(Profile, exempt_payment_service_provider).
test(money_changing_status_bound) :-
    psa_licence_class_profile_for(money_changing_only, Profile),
    psa_licence_class_status(Profile, money_changing_licence).
test(spi_status_bound) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(mpi_status_bound) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(indeterminate_status_bound) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_status(Profile, indeterminate).

test(no_services_not_spi, fail) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(exempt_not_spi, fail) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(money_changing_not_mpi, fail) :-
    psa_licence_class_profile_for(money_changing_only, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(spi_not_mpi, fail) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(mpi_not_spi, fail) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(indeterminate_not_spi, fail) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).

cp_test_names([no_services_status_bound, exempt_status_bound, money_changing_status_bound, spi_status_bound, mpi_status_bound, indeterminate_status_bound]).
cp_test_fail_names([no_services_not_spi, exempt_not_spi, money_changing_not_mpi, spi_not_mpi, mpi_not_spi, indeterminate_not_spi]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
