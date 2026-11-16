% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_queries, [gdpr_child_consent_age_verdict_profile_keys/1, gdpr_child_consent_age_verdict_what_if/4, gdpr_child_consent_age_verdict_compliance_check/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_kernel, [gdpr_child_consent_age_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [child_consent_ground_status/2]).

gdpr_child_consent_age_verdict_profile_keys([processing_rests_on_consent, information_society_service, offered_directly_to_child, child_age_years, parental_consent_given, member_state, member_state_selection_test, consent_date, member_state_digital_consent_age, verification_efforts_reasonable]).

gdpr_child_consent_age_verdict_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    child_consent_ground_status(Hypothesis, NewStatus).

gdpr_child_consent_age_verdict_compliance_check(Profile, Result) :-
    child_consent_ground_status(Profile, Status),
    compliance_of(Status, Result).

compliance_of(eligible, not_barred).
compliance_of(ineligible, barred).
compliance_of(indeterminate(_), undetermined).
compliance_of(needs_legal_review(_, _), refer_to_lawyer).
compliance_of(input_problems(_), input_rejected).

override_attribute(Profile, Key, Value, NewProfile) :-
    without_attribute(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], NewProfile).

without_attribute([], _, []).
without_attribute([attribute(Other, OtherValue)|Elements], Key, [attribute(Other, OtherValue)|Kept]) :-
    dif(Other, Key),
    without_attribute(Elements, Key, Kept).
without_attribute([attribute(Key, _)|Elements], Key, Kept) :-
    without_attribute(Elements, Key, Kept).
