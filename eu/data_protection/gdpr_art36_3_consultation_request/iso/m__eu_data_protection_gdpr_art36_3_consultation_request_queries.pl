% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_queries, [gdpr_art36_3_consultation_request_profile_keys/1, gdpr_art36_3_consultation_request_what_if/4, consultation_request_complete/0, consultation_request_incomplete/0, not_governed_by_article_36_3/0, respective_responsibilities/0, purposes_and_means/0, measures_and_safeguards/0, data_protection_officer_contact_details/0, data_protection_impact_assessment/0, other_requested_information/0, indeterminate/1, needs_legal_review/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, outside_fact/2, attested/2, attestation/4, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [gdpr_art36_3_consultation_request_status/2]).

gdpr_art36_3_consultation_request_profile_keys([consultation_under_article_36_1, joint_controllers_or_processors_involved, respective_responsibilities_provided, purposes_and_means_provided, measures_and_safeguards_provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, impact_assessment_provided, other_information_requested_by_supervisory_authority, requested_other_information_provided]).

consultation_request_complete.

consultation_request_incomplete.

not_governed_by_article_36_3.

respective_responsibilities.

purposes_and_means.

measures_and_safeguards.

data_protection_officer_contact_details.

data_protection_impact_assessment.

other_requested_information.

input_problems([_|_]).

indeterminate([Key]) :-
    atom(Key).

needs_legal_review(cross_reference_unresolved(cite(_), cite(_)), [_|_]).

cross_reference_unresolved(cite(_), cite(_)).

resolution(cite(_), not_attempted).

inputs_relied_on([_|_]).

outside_fact(joint_controllers_or_processors_involved, attested(_, _)).

attested(true, attestation(_, _, _, _)).
attested(false, attestation(_, _, _, _)).

attestation(_, _, _, none).
attestation(_, _, _, url(_, _)).
attestation(_, _, _, document(_, _)).

url(Location, RetrievedAt) :-
    atomic(Location),
    atomic(RetrievedAt).

document(UploadIdentifier, Digest) :-
    atomic(UploadIdentifier),
    atomic(Digest).

unknown_key(Key) :-
    nonvar(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

gdpr_art36_3_consultation_request_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    without_key(Profile, OverriddenKey, KeptElements),
    gdpr_art36_3_consultation_request_status([attribute(OverriddenKey, NewValue)|KeptElements], NewStatus).

without_key([], _, []).
without_key([Element|Elements], Key, Kept) :-
    key_match_t(Element, Key, Match),
    keep_element(Match, Element, Elements, Key, Kept).

keep_element(true, _, Elements, Key, Kept) :-
    without_key(Elements, Key, Kept).
keep_element(false, Element, Elements, Key, [Element|Kept]) :-
    without_key(Elements, Key, Kept).

key_match_t(Element, _, false) :-
    var(Element).
key_match_t(Element, Key, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
key_match_t(Element, Key, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
key_match_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

test(what_if_supplying_the_assessment_completes_the_request) :-
    findall(Status, gdpr_art36_3_consultation_request_what_if([attribute(consultation_under_article_36_1, true), attribute(respective_responsibilities_provided, true), attribute(purposes_and_means_provided, true), attribute(measures_and_safeguards_provided, true), attribute(data_protection_officer_designated, false), attribute(impact_assessment_provided, false), attribute(other_information_requested_by_supervisory_authority, false)], impact_assessment_provided, true, Status), Statuses),
    Statuses == [consultation_request_complete].
test(what_if_another_footing_is_not_governed) :-
    gdpr_art36_3_consultation_request_what_if([attribute(consultation_under_article_36_1, true)], consultation_under_article_36_1, false, Status),
    Status == not_governed_by_article_36_3.
test(what_if_adds_an_absent_key) :-
    gdpr_art36_3_consultation_request_what_if([], consultation_under_article_36_1, false, Status),
    Status == not_governed_by_article_36_3.
test(the_key_schema_has_ten_keys) :-
    gdpr_art36_3_consultation_request_profile_keys(ProfileKeys),
    length(ProfileKeys, 10).
test(the_result_atoms_resolve) :-
    consultation_request_complete,
    consultation_request_incomplete,
    not_governed_by_article_36_3.
test(the_item_atoms_resolve) :-
    respective_responsibilities,
    purposes_and_means,
    measures_and_safeguards,
    data_protection_officer_contact_details,
    data_protection_impact_assessment,
    other_requested_information.
test(the_input_problems_constructor_holds_for_a_problem_list) :-
    input_problems([wrong_type(profile)]).
test(the_wrong_type_constructor_holds_for_a_key) :-
    wrong_type(impact_assessment_provided).
test(the_attested_constructor_holds_for_a_pinned_term) :-
    attested(true, attestation(privacy_counsel, attestation_moment, role_review, none)).

test(what_if_does_not_leave_a_duplicate, fail) :-
    gdpr_art36_3_consultation_request_what_if([attribute(consultation_under_article_36_1, true)], consultation_under_article_36_1, false, input_problems(_)).
test(the_input_problems_constructor_refuses_an_empty_list, fail) :-
    input_problems([]).
test(the_wrong_type_constructor_refuses_a_compound, fail) :-
    wrong_type(attribute(impact_assessment_provided, true)).
test(the_attested_constructor_refuses_unsure, fail) :-
    attested(unsure, attestation(privacy_counsel, attestation_moment, role_review, none)).
