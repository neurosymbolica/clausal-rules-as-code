% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_queries, [gdpr_child_consent_age_fields_profile_keys/1, gdpr_child_consent_age_fields_what_if/4, gdpr_child_consent_age_fields_compliance_check/3, gdpr_child_consent_age_fields_justification/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_status_checklist/2]).

gdpr_child_consent_age_fields_profile_keys([processing_rests_on_consent, information_society_service, offered_directly_to_child, child_age_years, parental_consent_given, member_state, member_state_selection_test, consent_date, member_state_digital_consent_age, verification_efforts_reasonable]).

gdpr_child_consent_age_fields_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    child_consent_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Rest]).
override_attribute([attribute(OtherKey, OtherValue)|Rest], Key, Value, [attribute(OtherKey, OtherValue)|NewRest]) :-
    dif(OtherKey, Key),
    override_attribute(Rest, Key, Value, NewRest).

gdpr_child_consent_age_fields_compliance_check(Profile, process_on_consent, Verdict) :-
    child_consent_status(Profile, Status),
    compliance_verdict(Status, Verdict).

compliance_verdict(eligible, permitted(cite(eu_reg_2016_679_art_8_1))).
compliance_verdict(ineligible, forbidden(cite(eu_reg_2016_679_art_8_1))).
compliance_verdict(indeterminate(MissingKeys), undetermined(indeterminate(MissingKeys))).
compliance_verdict(needs_legal_review(Reason, Context), undetermined(needs_legal_review(Reason, Context))).
compliance_verdict(input_problems(Problems), undetermined(input_problems(Problems))).

gdpr_child_consent_age_fields_justification(Profile, Checklist) :-
    child_consent_status_checklist(Profile, Checklist).
