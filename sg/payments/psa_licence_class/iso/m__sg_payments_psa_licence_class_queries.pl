% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_queries, [psa_licence_class_profile_keys/1, psa_licence_class_what_if/4, psa_licence_class_threshold/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [psa_licence_class_status/2]).

psa_licence_class_profile_keys(Keys) :-
    Keys = [services, exempt_payment_service_provider, monthly_average_volumes, resident_e_money_float_cents, singapore_issued_other_e_money_float_cents, specified_e_money_issued_cents].

psa_licence_class_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    psa_licence_class_status(Hypothesis, NewStatus).

psa_licence_class_threshold(single_service_volume, 300000001, sg_psa_2019_s6_5_a_ii_a).
psa_licence_class_threshold(multi_service_volume, 600000001, sg_psa_2019_s6_5_a_ii_b).
psa_licence_class_threshold(e_money_account_float, 500000001, sg_psa_2019_s6_5_b).
psa_licence_class_threshold(e_money_issued, 500000001, sg_psa_2019_s6_5_c).
