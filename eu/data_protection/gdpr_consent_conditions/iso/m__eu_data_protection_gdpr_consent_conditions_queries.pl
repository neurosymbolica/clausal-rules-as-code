% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_queries, [gdpr_consent_conditions_profile_keys/1, gdpr_consent_conditions_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [gdpr_consent_conditions_status/2]).

gdpr_consent_conditions_profile_keys([processing_based_on_consent, consent_demonstrable, consent_in_declaration_with_other_matters, request_clearly_distinguishable_and_intelligible, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, withdrawal_as_easy_as_giving_consent, contract_conditional_on_unneeded_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible, additional_identifying_information_provided]).

gdpr_consent_conditions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_consent_conditions_input_problems(Profile, []),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_consent_conditions_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Rest]).
override_attribute([attribute(ElementKey, Other)|Rest], Key, Value, [attribute(ElementKey, Other)|NewRest]) :-
    dif(ElementKey, Key),
    override_attribute(Rest, Key, Value, NewRest).
