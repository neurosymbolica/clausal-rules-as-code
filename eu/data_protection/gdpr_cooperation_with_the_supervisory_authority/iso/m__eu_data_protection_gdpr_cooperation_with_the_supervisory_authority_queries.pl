% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_queries, [gdpr_cooperation_with_the_supervisory_authority_profile_keys/1, gdpr_cooperation_with_the_supervisory_authority_what_if/4, acts_as_controller/0, acts_as_processor/0, acts_as_representative_of_controller_or_processor/0, authority_request_made/0, request_is_in_performance_of_authority_tasks/0, cooperation_given/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [gdpr_cooperation_with_the_supervisory_authority_status/2]).

acts_as_controller.

acts_as_processor.

acts_as_representative_of_controller_or_processor.

authority_request_made.

request_is_in_performance_of_authority_tasks.

cooperation_given.

unsure.

gdpr_cooperation_with_the_supervisory_authority_profile_keys([acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks, cooperation_given]).

gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_cooperation_with_the_supervisory_authority_status(Hypothesis, NewStatus).

replace_attribute(Profile, Key, Value, Hypothesis) :-
    other_attributes(Profile, Key, Others),
    append(Others, [attribute(Key, Value)], Hypothesis).

other_attributes([], _, []).
other_attributes([attribute(ElementKey, _)|Elements], Key, Others) :-
    ElementKey == Key,
    other_attributes(Elements, Key, Others).
other_attributes([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Others]) :-
    ElementKey \== Key,
    other_attributes(Elements, Key, Others).

test(what_if_a_request_is_made_asks_for_the_judgement) :-
    gdpr_cooperation_with_the_supervisory_authority_what_if([attribute(acts_as_controller, true), attribute(authority_request_made, false)], authority_request_made, true, Status),
    Status == indeterminate([request_is_in_performance_of_authority_tasks]).
test(what_if_the_statement_is_false_is_not_met) :-
    gdpr_cooperation_with_the_supervisory_authority_what_if([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(by, at, reason, none)))], cooperation_given, attested(false, attestation(by, at, reason, none)), Status),
    Status == cooperation_not_met.
test(what_if_removes_a_duplicated_key) :-
    gdpr_cooperation_with_the_supervisory_authority_what_if([attribute(acts_as_controller, true), attribute(acts_as_controller, false), attribute(authority_request_made, false)], acts_as_controller, true, Status),
    Status == cooperation_not_required.
test(the_key_schema_has_six_keys) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_keys(Keys),
    length(Keys, 6).
test(the_root_atoms_hold) :-
    acts_as_controller,
    acts_as_processor,
    acts_as_representative_of_controller_or_processor,
    authority_request_made,
    request_is_in_performance_of_authority_tasks,
    cooperation_given,
    unsure.

test(what_if_the_statement_is_false_is_not_met_not_met, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_what_if([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(by, at, reason, none)))], cooperation_given, attested(false, attestation(by, at, reason, none)), cooperation_met).
