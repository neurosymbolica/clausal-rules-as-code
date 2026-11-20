% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_queries, [csp_registration_profile_keys/1, csp_registration_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_registration_status/2]).

csp_registration_profile_keys([activities, carries_on_business_in_singapore, registered_service_types, is_accounting_entity, accounting_service_is_own, deemed_registration_suspended_or_cancelled, arranges_nominee_director, satisfied_nominee_fit_and_proper, took_reasonable_steps_on_disqualification, considered_prescribed_factors]).

csp_registration_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    csp_registration_status(Hypothesis, NewStatus).
