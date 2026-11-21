% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_queries, [dma_art_6_9_10_portability_and_business_data_order_profile_keys/1, dma_art_6_9_10_portability_and_business_data_order_what_if/4, designated_as_gatekeeper_for_core_platform_service/0, portability_requested_by_end_user_or_authorised_third_party/0, data_provided_by_or_generated_through_activity_of_end_user/0, end_user_data_portability_free_of_charge/0, end_user_data_portability_effective/0, end_user_data_portability_tools_provided/0, end_user_data_continuous_real_time_access_provided/0, data_access_requested_by_business_user_or_authorised_third_party/0, data_provided_or_generated_in_use_by_business_user_and_its_end_users/0, requested_business_user_data_are_personal_data/0, personal_data_directly_connected_with_end_user_use_of_business_user_offer/0, end_users_opted_in_to_sharing_by_consent/0, business_user_data_access_free_of_charge/0, business_user_data_access_and_use_effective_and_high_quality/0, business_user_data_access_continuous_and_real_time/0, unsure/0, absent/0, not_attempted/0, article_6_obligations_apply/0, article_6_obligations_do_not_apply/0, portability_not_requested/0, data_outside_article_6_9/0, portability_duty_met/0, portability_duty_not_met/0, data_access_not_requested/0, data_outside_article_6_10/0, personal_data_access_not_required/0, personal_data_access_duty_met/0, personal_data_access_duty_not_met/0, data_access_duty_met/0, data_access_duty_not_met/0, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2, input_problems/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_kernel, [dma_art_6_9_10_portability_and_business_data_order_input_problems/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [dma_art_6_9_10_portability_and_business_data_order_status/2]).

dma_art_6_9_10_portability_and_business_data_order_profile_keys([designated_as_gatekeeper_for_core_platform_service, portability_requested_by_end_user_or_authorised_third_party, data_provided_by_or_generated_through_activity_of_end_user, end_user_data_portability_free_of_charge, end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided, data_access_requested_by_business_user_or_authorised_third_party, data_provided_or_generated_in_use_by_business_user_and_its_end_users, requested_business_user_data_are_personal_data, personal_data_directly_connected_with_end_user_use_of_business_user_offer, end_users_opted_in_to_sharing_by_consent, business_user_data_access_free_of_charge, business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time]).

dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dma_art_6_9_10_portability_and_business_data_order_status(Hypothesis, NewStatus).

attribute_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis).

without_key([], _, []).
without_key([Element|Elements], OverriddenKey, Remaining) :-
    element_has_key_t(Element, OverriddenKey, Truth),
    kept_element(Truth, Element, Elements, OverriddenKey, Remaining).

element_has_key_t(Element, _, false) :-
    var(Element).
element_has_key_t(Element, OverriddenKey, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_has_key_t(Element, OverriddenKey, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_has_key_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

kept_element(true, _, Elements, OverriddenKey, Remaining) :-
    without_key(Elements, OverriddenKey, Remaining).
kept_element(false, Element, Elements, OverriddenKey, [Element|Remaining]) :-
    without_key(Elements, OverriddenKey, Remaining).

designated_as_gatekeeper_for_core_platform_service.

portability_requested_by_end_user_or_authorised_third_party.

data_provided_by_or_generated_through_activity_of_end_user.

end_user_data_portability_free_of_charge.

end_user_data_portability_effective.

end_user_data_portability_tools_provided.

end_user_data_continuous_real_time_access_provided.

data_access_requested_by_business_user_or_authorised_third_party.

data_provided_or_generated_in_use_by_business_user_and_its_end_users.

requested_business_user_data_are_personal_data.

personal_data_directly_connected_with_end_user_use_of_business_user_offer.

end_users_opted_in_to_sharing_by_consent.

business_user_data_access_free_of_charge.

business_user_data_access_and_use_effective_and_high_quality.

business_user_data_access_continuous_and_real_time.

unsure.

absent.

not_attempted.

article_6_obligations_apply.

article_6_obligations_do_not_apply.

portability_not_requested.

data_outside_article_6_9.

portability_duty_met.

portability_duty_not_met.

data_access_not_requested.

data_outside_article_6_10.

personal_data_access_not_required.

personal_data_access_duty_met.

personal_data_access_duty_not_met.

data_access_duty_met.

data_access_duty_not_met.

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(InputKey, Citation) :-
    atom(InputKey),
    compound(Citation).

cross_reference_unresolved(Citation, Target) :-
    compound(Citation),
    compound(Target).

resolution(Target, ResolutionStatus) :-
    compound(Target),
    atom(ResolutionStatus).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Source, Detail) :-
    ground(Source),
    ground(Detail).

outside_fact(FactKey, Attested) :-
    atom(FactKey),
    compound(Attested).

attested(AttestedValue, Attestation) :-
    atom(AttestedValue),
    compound(Attestation).

attestation(AttestedBy, AttestedAt, StatedReason, Evidence) :-
    ground(AttestedBy),
    ground(AttestedAt),
    ground(StatedReason),
    ground(Evidence).

url(Address, RetrievedAt) :-
    ground(Address),
    ground(RetrievedAt).

document(UploadIdentifier, DocumentHash) :-
    ground(UploadIdentifier),
    ground(DocumentHash).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(ProblemKey) :-
    atom(ProblemKey).

duplicate_key(ProblemKey) :-
    atom(ProblemKey).

test(profile_keys_are_the_fifteen_contract_keys) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_keys(Keys),
    length(Keys, 15),
    sort(Keys, SortedKeys),
    length(SortedKeys, 15).
test(input_problems_reexported_empty_for_empty_profile) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([], []).
test(input_problems_reexported_names_unknown_key) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
test(root_values_are_defined) :-
    unsure,
    absent,
    not_attempted.
test(what_if_listing_the_service_makes_article_6_apply) :-
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if([], designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', listed_in_designation_decision, none)), Status), Statuses),
    Statuses = [answers(article_6_obligations_apply, _, _)].
test(what_if_replaces_an_existing_value) :-
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', listed_in_designation_decision, none)))], designated_as_gatekeeper_for_core_platform_service, attested(false, attestation(host_operator, '2026-11-19T10:00:00Z', not_listed_in_designation_decision, none)), Status), Statuses),
    Statuses == [answers(article_6_obligations_do_not_apply, article_6_obligations_do_not_apply, article_6_obligations_do_not_apply)].

test(what_if_replacing_does_not_leave_a_duplicate, fail) :-
    dma_art_6_9_10_portability_and_business_data_order_what_if([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', listed_in_designation_decision, none)))], designated_as_gatekeeper_for_core_platform_service, attested(false, attestation(host_operator, '2026-11-19T10:00:00Z', not_listed_in_designation_decision, none)), answers(input_problems(_), _, _)).
