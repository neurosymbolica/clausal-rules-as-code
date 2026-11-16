% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_profile_keys/1, gdpr_administrative_fine_maximum_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3]).

gdpr_administrative_fine_maximum_profile_keys([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros, infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent]).

gdpr_administrative_fine_maximum_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    administrative_fine_maximum(Hypothesis, NewVerdict, _).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Attributes], Key, Value, [attribute(Key, Value)|Attributes]).
override_attribute([attribute(Other, Existing)|Attributes], Key, Value, [attribute(Other, Existing)|Overridden]) :-
    dif(Other, Key),
    override_attribute(Attributes, Key, Value, Overridden).
