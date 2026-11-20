% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_queries, [psa_licence_class_profile_keys/1, psa_licence_class_what_if/4, psa_licence_class_threshold/3]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_profile_for/2]).

test(profile_keys_include_services) :-
    psa_licence_class_profile_keys(Keys),
    member(services, Keys).
test(profile_keys_include_exempt) :-
    psa_licence_class_profile_keys(Keys),
    member(exempt_payment_service_provider, Keys).
test(profile_keys_include_volumes) :-
    psa_licence_class_profile_keys(Keys),
    member(monthly_average_volumes, Keys).
test(what_if_overriding_exempt_to_true_gives_exempt) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_what_if(Profile, exempt_payment_service_provider, true, exempt_payment_service_provider).
test(what_if_overriding_exempt_to_false_gives_spi) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_what_if(Profile, exempt_payment_service_provider, false, standard_payment_institution_licence).
test(threshold_single_service_volume) :-
    psa_licence_class_threshold(single_service_volume, 300000001, sg_psa_2019_s6_5_a_ii_a).
test(threshold_multi_service_volume) :-
    psa_licence_class_threshold(multi_service_volume, 600000001, sg_psa_2019_s6_5_a_ii_b).
test(threshold_e_money_account_float) :-
    psa_licence_class_threshold(e_money_account_float, 500000001, sg_psa_2019_s6_5_b).
test(threshold_e_money_issued) :-
    psa_licence_class_threshold(e_money_issued, 500000001, sg_psa_2019_s6_5_c).

cp_test_names([profile_keys_include_services, profile_keys_include_exempt, profile_keys_include_volumes, what_if_overriding_exempt_to_true_gives_exempt, what_if_overriding_exempt_to_false_gives_spi, threshold_single_service_volume, threshold_multi_service_volume, threshold_e_money_account_float, threshold_e_money_issued]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
