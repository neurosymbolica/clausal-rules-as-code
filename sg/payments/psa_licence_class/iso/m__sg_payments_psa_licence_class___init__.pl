% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_citations, [citation/2, implements/1]).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [decide_psa_licence_class/2, psa_licence/4, psa_licence_class/2, psa_licence_class_checklist/2, psa_licence_class_decision_resolvable/1, psa_licence_class_status/2, psa_licence_class_status_values/1, volume/2]).
:- use_module(m__sg_payments_psa_licence_class_queries, [psa_licence_class_profile_keys/1, psa_licence_class_threshold/3, psa_licence_class_what_if/4]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_assess/2, psa_licence_class_profile_for/2, psa_licence_class_subject/1]).
