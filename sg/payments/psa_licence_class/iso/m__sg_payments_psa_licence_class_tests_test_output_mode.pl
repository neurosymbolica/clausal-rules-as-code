% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [decide_psa_licence_class/2, psa_licence_class_status/2]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_profile_for/2]).

test(no_services_yields_no_licence_required) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, no_licence_required).
test(exempt_yields_exempt) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_status(Profile, exempt_payment_service_provider).
test(money_changing_yields_licence) :-
    psa_licence_class_profile_for(money_changing_only, Profile),
    psa_licence_class_status(Profile, money_changing_licence).
test(spi_yields_standard) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(mpi_yields_major) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(indeterminate_yields_indeterminate) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_status(Profile, indeterminate).
test(spi_result_carries_citation) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    decide_psa_licence_class(Profile, psa_licence(standard_payment_institution_licence, [], _Volume, [sg_psa_2019_s6_4])).
test(mpi_result_carries_citations_and_triggers) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    decide_psa_licence_class(Profile, psa_licence(major_payment_institution_licence, [single_service_volume], _Volume, [sg_psa_2019_s6_4, sg_psa_2019_s6_5_a_ii_a])).
test(money_changing_result_carries_citation) :-
    psa_licence_class_profile_for(money_changing_only, Profile),
    decide_psa_licence_class(Profile, psa_licence(money_changing_licence, [], 0, [sg_psa_2019_s6_3])).
test(exempt_result_carries_citation) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    decide_psa_licence_class(Profile, psa_licence(exempt_payment_service_provider, [], _Volume, [sg_psa_2019_s5_1_b])).

cp_test_names([no_services_yields_no_licence_required, exempt_yields_exempt, money_changing_yields_licence, spi_yields_standard, mpi_yields_major, indeterminate_yields_indeterminate, spi_result_carries_citation, mpi_result_carries_citations_and_triggers, money_changing_result_carries_citation, exempt_result_carries_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
