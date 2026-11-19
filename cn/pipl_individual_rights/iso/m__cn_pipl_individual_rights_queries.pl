% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_queries, [pipl_individual_rights_profile_keys/1, pipl_individual_rights_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2]).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [pipl_individual_rights_status/2]).

pipl_individual_rights_profile_keys([pinned_text_in_force_on_reference_day, laws_or_regulations_provide_otherwise, article_18_1_case, article_35_case, cyberspace_department_transfer_conditions_met, verification_confirms_inaccurate_or_incomplete, purpose_achieved_impossible_or_unnecessary, service_stopped_or_retention_period_expired, consent_withdrawn, processing_violates_law_or_agreement, other_deletion_case_prescribed_by_law, legal_retention_period_unexpired, deletion_technically_difficult, person_deceased, requester_is_near_relative, for_requester_own_lawful_and_legitimate_interests, deceased_arranged_otherwise, convenient_mechanism_established, request_refused, refusal_reasons_given]).

pipl_individual_rights_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    list_shape(Profile, Shape),
    hypothesis(Shape, Profile, OverriddenKey, NewValue, Hypothesis),
    pipl_individual_rights_status(Hypothesis, NewStatus).

hypothesis(proper_list, Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, Kept),
    append(Kept, [attribute(OverriddenKey, NewValue)], Hypothesis).
hypothesis(not_a_list, Profile, _, _, Profile).

list_shape(Term, not_a_list) :-
    var(Term).
list_shape(Term, proper_list) :-
    Term == [].
list_shape(Term, Shape) :-
    nonvar(Term),
    Term = [_|Rest],
    list_shape(Rest, Shape).
list_shape(Term, not_a_list) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

without_key([], _, []).
without_key([Element|Elements], Key, Kept) :-
    element_key_t(Element, Key, Matches),
    keep_element(Matches, Element, LaterKept, Kept),
    without_key(Elements, Key, LaterKept).

element_key_t(Element, _, false) :-
    var(Element).
element_key_t(Element, Key, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
element_key_t(Element, Key, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
element_key_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

keep_element(true, _, Kept, Kept).
keep_element(false, Element, Kept, [Element|Kept]).

query_test_profile([attribute(pinned_text_in_force_on_reference_day, true), attribute(laws_or_regulations_provide_otherwise, false), attribute(article_18_1_case, false), attribute(article_35_case, false), attribute(cyberspace_department_transfer_conditions_met, true), attribute(verification_confirms_inaccurate_or_incomplete, true), attribute(purpose_achieved_impossible_or_unnecessary, false), attribute(service_stopped_or_retention_period_expired, false), attribute(consent_withdrawn, true), attribute(processing_violates_law_or_agreement, false), attribute(other_deletion_case_prescribed_by_law, false), attribute(legal_retention_period_unexpired, false), attribute(deletion_technically_difficult, false), attribute(person_deceased, true), attribute(requester_is_near_relative, true), attribute(for_requester_own_lawful_and_legitimate_interests, true), attribute(deceased_arranged_otherwise, false), attribute(convenient_mechanism_established, true), attribute(request_refused, true), attribute(refusal_reasons_given, true)]).

test(the_schema_has_twenty_keys) :-
    pipl_individual_rights_profile_keys(ProfileKeys),
    length(ProfileKeys, 20).
test(what_if_unchanged_value_keeps_eligible) :-
    query_test_profile(Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, refusal_reasons_given, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_refusal_without_reasons_is_ineligible) :-
    query_test_profile(Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, refusal_reasons_given, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_unsure_mechanism_is_referred) :-
    query_test_profile(Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, convenient_mechanism_established, unsure, Status), Statuses),
    Statuses == [referred_for_legal_review].
test(what_if_text_not_in_force) :-
    query_test_profile(Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, pinned_text_in_force_on_reference_day, false, Status), Statuses),
    Statuses == [text_not_in_force].
test(what_if_wrong_type_value_is_rejected) :-
    query_test_profile(Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, consent_withdrawn, maybe, Status), Statuses),
    Statuses == [input_rejected].
test(what_if_on_a_non_list_is_rejected) :-
    findall(Status, pipl_individual_rights_what_if(not_a_profile, consent_withdrawn, true, Status), Statuses),
    Statuses == [input_rejected].
test(what_if_on_the_empty_profile_is_undetermined) :-
    findall(Status, pipl_individual_rights_what_if([], pinned_text_in_force_on_reference_day, true, Status), Statuses),
    Statuses == [undetermined].
test(the_override_replaces_a_duplicated_key) :-
    without_key([attribute(consent_withdrawn, true), attribute(person_deceased, true), attribute(consent_withdrawn, false)], consent_withdrawn, Kept),
    Kept == [attribute(person_deceased, true)].

test(what_if_refusal_without_reasons_is_not_eligible, fail) :-
    query_test_profile(Profile),
    pipl_individual_rights_what_if(Profile, refusal_reasons_given, false, eligible).
