% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_queries, [gdpr_art36_3_consultation_request_profile_keys/1, gdpr_art36_3_consultation_request_what_if/4, consultation_request_complete/0, consultation_request_incomplete/0, not_governed_by_article_36_3/0, respective_responsibilities/0, purposes_and_means/0, measures_and_safeguards/0, data_protection_officer_contact_details/0, data_protection_impact_assessment/0, other_requested_information/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [gdpr_art36_3_consultation_request_status/2]).

gdpr_art36_3_consultation_request_profile_keys([consultation_under_article_36_1, joint_controllers_or_processors_involved, respective_responsibilities_provided, purposes_and_means_provided, measures_and_safeguards_provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, impact_assessment_provided, other_information_requested_by_supervisory_authority, requested_other_information_provided]).

gdpr_art36_3_consultation_request_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_art36_3_consultation_request_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, Hypothesis).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, Hypothesis) :-
    ElementKey == Key,
    override_attribute(Elements, Key, Value, Hypothesis).

consultation_request_complete.

consultation_request_incomplete.

not_governed_by_article_36_3.

respective_responsibilities.

purposes_and_means.

measures_and_safeguards.

data_protection_officer_contact_details.

data_protection_impact_assessment.

other_requested_information.
