% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, suspended/1, input_problems/1, attested/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2, contract_keys/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).

gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys(Keys) :-
    contract_keys(Keys).

gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, OverriddenKey, NewValue, NewComply) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    request_decision(Hypothesis, NewComply).

override_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_with_key(OverriddenKey), Profile, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_with_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

indeterminate([_|_]).

needs_legal_review(open_textured(_, _), [_|_]).

open_textured(_, cite(_)).

inputs_relied_on([]).
inputs_relied_on([_|_]).

suspended(art12_6_identity_not_confirmed).

input_problems([_|_]).

attested(_, attestation(_, _, _, _)).
