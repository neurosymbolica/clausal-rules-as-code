% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_queries, [gdpr_corrective_powers_named_profile_keys/1, gdpr_corrective_powers_named_what_if/4, not_named/0, authority_discretion/0, warning/0, reprimand/0, order_to_comply_with_data_subject_requests/0, order_to_bring_processing_into_compliance/0, order_to_communicate_personal_data_breach/0, limitation_or_ban_on_processing/0, order_of_rectification_erasure_or_restriction/0, withdrawal_or_refusal_of_certification/0, administrative_fine/0, suspension_of_data_flows/0, controller/0, processor/0, certification_body/0, powers_named/2, named/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [gdpr_corrective_powers_named_status/2]).

gdpr_corrective_powers_named_profile_keys([intended_processing_likely_to_infringe, processing_has_infringed, data_subject_request_to_exercise_rights_made, processing_not_in_compliance, personal_data_breach_occurred, rectification_erasure_or_restriction_ground_met, certification_issued_or_applied_for, certification_requirements_not_met, data_flows_to_third_country_or_international_organisation]).

gdpr_corrective_powers_named_what_if(Profile, _OverriddenKey, _NewValue, input_problems([Problem|Problems])) :-
    gdpr_corrective_powers_named_input_problems(Profile, [Problem|Problems]).
gdpr_corrective_powers_named_what_if(Profile, OverriddenKey, NewValue, NewResult) :-
    gdpr_corrective_powers_named_input_problems(Profile, []),
    attribute_overridden(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_corrective_powers_named_status(Hypothesis, NewResult).

attribute_overridden([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_overridden([attribute(AttributeKey, AttributeValue)|Attributes], OverriddenKey, NewValue, [attribute(AttributeKey, AttributeValue)|Hypothesis]) :-
    AttributeKey \== OverriddenKey,
    attribute_overridden(Attributes, OverriddenKey, NewValue, Hypothesis).
attribute_overridden([attribute(AttributeKey, _)|Attributes], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|Attributes]) :-
    AttributeKey == OverriddenKey.

not_named.

authority_discretion.

warning.

reprimand.

order_to_comply_with_data_subject_requests.

order_to_bring_processing_into_compliance.

order_to_communicate_personal_data_breach.

limitation_or_ban_on_processing.

order_of_rectification_erasure_or_restriction.

withdrawal_or_refusal_of_certification.

administrative_fine.

suspension_of_data_flows.

controller.

processor.

certification_body.

powers_named(_Powers, authority_discretion).

named(_Addressees, authority_discretion).

test(override_replaces_a_present_value) :-
    attribute_overridden([attribute(processing_has_infringed, false)], processing_has_infringed, true, Hypothesis),
    Hypothesis == [attribute(processing_has_infringed, true)].
test(override_adds_an_absent_key) :-
    attribute_overridden([attribute(processing_has_infringed, false)], personal_data_breach_occurred, true, Hypothesis),
    Hypothesis == [attribute(processing_has_infringed, false), attribute(personal_data_breach_occurred, true)].
test(what_if_adds_the_missing_key) :-
    findall(Result, gdpr_corrective_powers_named_what_if([], intended_processing_likely_to_infringe, true, Result), Results),
    Results == [indeterminate([processing_has_infringed])].
test(what_if_on_a_malformed_profile_reports_its_problems) :-
    findall(Result, gdpr_corrective_powers_named_what_if([foo], processing_has_infringed, true, Result), Results),
    Results == [input_problems([wrong_type(profile)])].
test(what_if_with_a_bad_value_reports_it) :-
    findall(Result, gdpr_corrective_powers_named_what_if([], personal_data_breach_occurred, unsure, Result), Results),
    Results == [input_problems([wrong_type(personal_data_breach_occurred)])].
test(what_if_with_an_unknown_key_reports_it) :-
    findall(Result, gdpr_corrective_powers_named_what_if([], fine_amount, true, Result), Results),
    Results == [input_problems([unknown_key(fine_amount)])].
test(profile_keys_are_the_nine_contract_keys) :-
    gdpr_corrective_powers_named_profile_keys(ProfileKeys),
    length(ProfileKeys, 9).
test(vocabulary_atoms_are_defined) :-
    not_named,
    authority_discretion,
    warning,
    suspension_of_data_flows,
    certification_body.
test(named_constructor_carries_authority_discretion) :-
    named([controller], authority_discretion).

test(named_constructor_refuses_another_second_argument, fail) :-
    named([controller], must_use).
