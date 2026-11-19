% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_queries, [gdpr_transfer_dpf_profile_keys/1, gdpr_transfer_dpf_what_if/4, gdpr_transfer_dpf_compliance_check/2, covered_by_data_privacy_framework_adequacy/0, not_covered_by_data_privacy_framework_adequacy/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [gdpr_transfer_dpf_status/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_citations, [implements/1]).

gdpr_transfer_dpf_profile_keys([transfer_from_union, recipient_is_organisation_in_united_states, data_privacy_framework_decision_in_force, recipient_on_data_privacy_framework_list, certification_covers_transferred_data]).

covered_by_data_privacy_framework_adequacy.

not_covered_by_data_privacy_framework_adequacy.

gdpr_transfer_dpf_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_transfer_dpf_input_problems(Profile, []),
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_transfer_dpf_status(Hypothesis, NewStatus).
gdpr_transfer_dpf_what_if(Profile, _OverriddenKey, _NewValue, input_problems([Problem|Problems])) :-
    gdpr_transfer_dpf_input_problems(Profile, [Problem|Problems]).

attribute_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_override([attribute(ElementKey, _ElementValue)|Remaining], OverriddenKey, NewValue, NewProfile) :-
    ElementKey == OverriddenKey,
    attribute_override(Remaining, OverriddenKey, NewValue, NewProfile).
attribute_override([attribute(ElementKey, ElementValue)|Remaining], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|NewProfile]) :-
    ElementKey \== OverriddenKey,
    attribute_override(Remaining, OverriddenKey, NewValue, NewProfile).

gdpr_transfer_dpf_compliance_check(Profile, Answer) :-
    gdpr_transfer_dpf_status(Profile, Status),
    compliance_answer(Status, Answer).

compliance_answer(covered_by_data_privacy_framework_adequacy, no_specific_authorisation_required) :-
    implements(eu_reg_2016_679_art_45_1).
compliance_answer(not_covered_by_data_privacy_framework_adequacy, not_established_by_this_decision) :-
    implements(eu_dec_2023_1795_art_1).
compliance_answer(input_problems(Problems), input_problems(Problems)).
compliance_answer(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
compliance_answer(indeterminate(MissingKeys), indeterminate(MissingKeys)).

test(the_profile_keys_are_the_five_contract_keys) :-
    gdpr_transfer_dpf_profile_keys(ProfileKeys),
    length(ProfileKeys, 5).
test(what_if_stating_the_missing_crisp_key_true_covers) :-
    Affirmed = attested(true, attestation(by, at, reason, none)),
    findall(Status, gdpr_transfer_dpf_what_if([attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)], transfer_from_union, true, Status), Statuses),
    Statuses == [covered_by_data_privacy_framework_adequacy].
test(what_if_replaces_an_existing_value) :-
    gdpr_transfer_dpf_what_if([attribute(transfer_from_union, true)], transfer_from_union, false, not_covered_by_data_privacy_framework_adequacy).
test(what_if_on_a_malformed_profile_gives_its_problems) :-
    gdpr_transfer_dpf_what_if([attribute(colour, red)], transfer_from_union, true, input_problems([unknown_key(colour)])).
test(a_covered_transfer_needs_no_specific_authorisation) :-
    Affirmed = attested(true, attestation(by, at, reason, none)),
    gdpr_transfer_dpf_compliance_check([attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)], no_specific_authorisation_required).
test(a_not_covered_transfer_is_not_established_by_this_decision) :-
    findall(Answer, gdpr_transfer_dpf_compliance_check([attribute(transfer_from_union, false)], Answer), Answers),
    Answers == [not_established_by_this_decision].
test(a_referral_passes_through_the_compliance_check) :-
    gdpr_transfer_dpf_compliance_check([], needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_decision_in_force_statement)), [resolution(cite(data_privacy_framework_decision_in_force_statement), not_attempted), inputs_relied_on([data_privacy_framework_decision_in_force - absent])])).

test(a_not_covered_transfer_is_not_reported_as_needing_no_authorisation, fail) :-
    gdpr_transfer_dpf_compliance_check([attribute(transfer_from_union, false)], no_specific_authorisation_required).
