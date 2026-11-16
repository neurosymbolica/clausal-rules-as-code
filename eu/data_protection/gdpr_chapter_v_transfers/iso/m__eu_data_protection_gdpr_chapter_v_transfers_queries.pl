% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_queries, [gdpr_chapter_v_transfers_profile_keys/1, gdpr_chapter_v_transfers_what_if/4, input_problems/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [transfer_status/2]).

gdpr_chapter_v_transfers_profile_keys([adequacy_decision_in_force, safeguard_in_place, derogation_claimed, public_authority_public_powers, explicit_consent_obtained, contract_necessity, data_subject_interest_contract_necessity, important_public_interest, legal_claims_necessity, vital_interests_necessity, register_public_by_law, register_consultation_conditions_fulfilled, register_not_entire, register_requester_condition_met, legitimate_interests_derogation, transfer_is_onward_transfer, binding_corporate_rules_approved, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision]).

gdpr_chapter_v_transfers_what_if(Profile, _, _, input_problems([Problem|Problems])) :-
    gdpr_chapter_v_transfers_input_problems(Profile, [Problem|Problems]).
gdpr_chapter_v_transfers_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_chapter_v_transfers_input_problems(Profile, []),
    attributes_without(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    transfer_status(Hypothesis, NewStatus).

attributes_without([], _, []).
attributes_without([attribute(Key, _)|Attributes], RemovedKey, Kept) :-
    Key == RemovedKey,
    attributes_without(Attributes, RemovedKey, Kept).
attributes_without([attribute(Key, Value)|Attributes], RemovedKey, [attribute(Key, Value)|Kept]) :-
    Key \== RemovedKey,
    attributes_without(Attributes, RemovedKey, Kept).

input_problems(Problems) :-
    is_list(Problems).

wrong_type(ContractKey) :-
    atom(ContractKey).

duplicate_key(ContractKey) :-
    atom(ContractKey).

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(_Reason, Context) :-
    is_list(Context).

open_textured(InputKey, cite(_CitationKey)) :-
    atom(InputKey).

cross_reference_unresolved(cite(_CitationKey), cite(_TargetKey)).

resolution(cite(_TargetKey), not_attempted).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(_DecidingClause, Citations) :-
    is_list(Citations).

outside_fact(OutsideKey, _Arrival) :-
    atom(OutsideKey).

attested(true, attestation(_AttestingHost, _AttestedTime, _AttestationReason, _EvidenceTerm)).
attested(false, attestation(_AttestingHost, _AttestedTime, _AttestationReason, _EvidenceTerm)).

test(what_if_supplies_the_missing_safeguard) :-
    findall(Status, gdpr_chapter_v_transfers_what_if([], safeguard_in_place, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_replaces_an_existing_entry_once) :-
    findall(Status, gdpr_chapter_v_transfers_what_if([attribute(safeguard_in_place, false)], safeguard_in_place, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_on_a_malformed_profile_reports_its_problems) :-
    findall(Status, gdpr_chapter_v_transfers_what_if(not_a_list, safeguard_in_place, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(what_if_with_a_wrong_value_reports_the_wrong_type) :-
    findall(Status, gdpr_chapter_v_transfers_what_if([], safeguard_in_place, yes, Status), Statuses),
    Statuses == [input_problems([wrong_type(safeguard_in_place)])].
test(the_profile_keys_are_nineteen) :-
    gdpr_chapter_v_transfers_profile_keys(Keys),
    length(Keys, 19).
test(an_attested_value_is_true_or_false) :-
    attested(true, attestation(query_host, query_time, query_reason, none)),
    attested(false, attestation(query_host, query_time, query_reason, none)).

test(what_if_supplied_safeguard_is_not_ineligible, fail) :-
    gdpr_chapter_v_transfers_what_if([], safeguard_in_place, true, ineligible).
test(an_unsure_attested_value_is_not_a_shape, fail) :-
    attested(unsure, attestation(query_host, query_time, query_reason, none)).
