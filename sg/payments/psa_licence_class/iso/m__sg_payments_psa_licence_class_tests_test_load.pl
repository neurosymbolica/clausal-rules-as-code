% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_citations, [citation/2, implements/1]).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [volume/2]).

test(the_result_term_builds_and_destructures) :-
    Result = psa_licence(no_licence_required, [], 0, []),
    Result = psa_licence(Licence, Triggers, VolumeTotal, Citations),
    Licence == no_licence_required,
    Triggers == [],
    VolumeTotal == 0,
    Citations == [].
test(the_licence_atoms_are_distinct) :-
    dif(no_licence_required, exempt_payment_service_provider),
    dif(no_licence_required, money_changing_licence),
    dif(no_licence_required, standard_payment_institution_licence),
    dif(no_licence_required, major_payment_institution_licence),
    dif(no_licence_required, indeterminate),
    dif(exempt_payment_service_provider, money_changing_licence),
    dif(exempt_payment_service_provider, standard_payment_institution_licence),
    dif(exempt_payment_service_provider, major_payment_institution_licence),
    dif(exempt_payment_service_provider, indeterminate),
    dif(money_changing_licence, standard_payment_institution_licence),
    dif(money_changing_licence, major_payment_institution_licence),
    dif(money_changing_licence, indeterminate),
    dif(standard_payment_institution_licence, major_payment_institution_licence),
    dif(standard_payment_institution_licence, indeterminate),
    dif(major_payment_institution_licence, indeterminate).
test(the_mpi_trigger_atoms_are_distinct) :-
    dif(single_service_volume, multi_service_volume),
    dif(single_service_volume, e_money_account_float),
    dif(single_service_volume, e_money_issued),
    dif(multi_service_volume, e_money_account_float),
    dif(multi_service_volume, e_money_issued),
    dif(e_money_account_float, e_money_issued).
test(a_real_citation_resolves) :-
    citation(sg_psa_2019_s6_4, _Record).
test(implements_succeeds_for_recorded_key) :-
    implements(sg_psa_2019_s6_4).
test(volume_accepts_a_known_service_with_zero_cents) :-
    volume(domestic_money_transfer, 0).
test(volume_accepts_a_known_service_with_positive_cents) :-
    volume(merchant_acquisition, 123).

test(volume_rejects_an_unknown_service, fail) :-
    volume(unknown_service, 0).
test(volume_rejects_negative_cents, fail) :-
    volume(domestic_money_transfer, -1).

cp_test_names([the_result_term_builds_and_destructures, the_licence_atoms_are_distinct, the_mpi_trigger_atoms_are_distinct, a_real_citation_resolves, implements_succeeds_for_recorded_key, volume_accepts_a_known_service_with_zero_cents, volume_accepts_a_known_service_with_positive_cents]).
cp_test_fail_names([volume_rejects_an_unknown_service, volume_rejects_negative_cents]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
