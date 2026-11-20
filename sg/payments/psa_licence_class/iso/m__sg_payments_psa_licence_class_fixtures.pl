% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_subject/1, psa_licence_class_profile_for/2, psa_licence_class_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [decide_psa_licence_class/2]).

psa_licence_class_subject(no_services).
psa_licence_class_subject(no_services_near_miss).
psa_licence_class_subject(exempt_basic).
psa_licence_class_subject(exempt_near_miss).
psa_licence_class_subject(money_changing_only).
psa_licence_class_subject(money_changing_near_miss).
psa_licence_class_subject(single_volume_mpi).
psa_licence_class_subject(single_volume_at_threshold).
psa_licence_class_subject(multi_volume_mpi).
psa_licence_class_subject(multi_volume_at_threshold).
psa_licence_class_subject(e_money_float_mpi).
psa_licence_class_subject(e_money_float_at_threshold).
psa_licence_class_subject(e_money_issued_mpi).
psa_licence_class_subject(e_money_issued_at_threshold).
psa_licence_class_subject(indeterminate_missing_services).
psa_licence_class_subject(indeterminate_missing_exempt).

psa_licence_class_profile_for(no_services, Profile) :-
    dict_pairs(Profile, [services - [], exempt_payment_service_provider - false]).
psa_licence_class_profile_for(no_services_near_miss, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer], exempt_payment_service_provider - false]).
psa_licence_class_profile_for(exempt_basic, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer], exempt_payment_service_provider - true]).
psa_licence_class_profile_for(exempt_near_miss, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer], exempt_payment_service_provider - false]).
psa_licence_class_profile_for(money_changing_only, Profile) :-
    dict_pairs(Profile, [services - [money_changing], exempt_payment_service_provider - false]).
psa_licence_class_profile_for(money_changing_near_miss, Profile) :-
    dict_pairs(Profile, [services - [money_changing, domestic_money_transfer], exempt_payment_service_provider - false]).
psa_licence_class_profile_for(single_volume_mpi, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer], exempt_payment_service_provider - false, monthly_average_volumes - [volume(domestic_money_transfer, 300000001)]]).
psa_licence_class_profile_for(single_volume_at_threshold, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer], exempt_payment_service_provider - false, monthly_average_volumes - [volume(domestic_money_transfer, 300000000)]]).
psa_licence_class_profile_for(multi_volume_mpi, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer, cross_border_money_transfer, merchant_acquisition], exempt_payment_service_provider - false, monthly_average_volumes - [volume(domestic_money_transfer, 200000000), volume(cross_border_money_transfer, 200000000), volume(merchant_acquisition, 210000000)]]).
psa_licence_class_profile_for(multi_volume_at_threshold, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer, cross_border_money_transfer, merchant_acquisition], exempt_payment_service_provider - false, monthly_average_volumes - [volume(domestic_money_transfer, 200000000), volume(cross_border_money_transfer, 200000000), volume(merchant_acquisition, 200000000)]]).
psa_licence_class_profile_for(e_money_float_mpi, Profile) :-
    dict_pairs(Profile, [services - [e_money_account_issuance], exempt_payment_service_provider - false, resident_e_money_float_cents - 500000001]).
psa_licence_class_profile_for(e_money_float_at_threshold, Profile) :-
    dict_pairs(Profile, [services - [e_money_account_issuance], exempt_payment_service_provider - false, resident_e_money_float_cents - 500000000]).
psa_licence_class_profile_for(e_money_issued_mpi, Profile) :-
    dict_pairs(Profile, [services - [e_money_issuance], exempt_payment_service_provider - false, specified_e_money_issued_cents - 500000001]).
psa_licence_class_profile_for(e_money_issued_at_threshold, Profile) :-
    dict_pairs(Profile, [services - [e_money_issuance], exempt_payment_service_provider - false, specified_e_money_issued_cents - 500000000]).
psa_licence_class_profile_for(indeterminate_missing_services, Profile) :-
    dict_pairs(Profile, [exempt_payment_service_provider - false]).
psa_licence_class_profile_for(indeterminate_missing_exempt, Profile) :-
    dict_pairs(Profile, [services - [domestic_money_transfer]]).

psa_licence_class_assess(Subject, Result) :-
    psa_licence_class_profile_for(Subject, Profile),
    decide_psa_licence_class(Profile, Result).
