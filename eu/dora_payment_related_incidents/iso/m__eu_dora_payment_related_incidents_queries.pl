% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_queries, [dora_payment_related_incidents_profile_keys/1, dora_payment_related_incidents_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2]).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [dora_payment_related_incidents_status/2]).

dora_payment_related_incidents_profile_keys([dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major, credit_institution_classified_as_significant, member_state_requires_reports_to_directive_2022_2555_authorities]).

dora_payment_related_incidents_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_payment_related_incidents_input_problems(Profile, Problems),
    what_if_after_check(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_after_check([Problem|Problems], _Profile, _OverriddenKey, _NewValue, input_problems([Problem|Problems])).
what_if_after_check([], Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_without_key(Profile, OverriddenKey, RemainingAttributes),
    append(RemainingAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    dora_payment_related_incidents_status(Hypothesis, NewStatus).

profile_without_key([], _OverriddenKey, []).
profile_without_key([attribute(ElementKey, _ElementValue)|Attributes], OverriddenKey, Remaining) :-
    ElementKey == OverriddenKey,
    profile_without_key(Attributes, OverriddenKey, Remaining).
profile_without_key([attribute(ElementKey, ElementValue)|Attributes], OverriddenKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== OverriddenKey,
    profile_without_key(Attributes, OverriddenKey, Remaining).

test(the_profile_keys_are_the_five_contract_keys) :-
    dora_payment_related_incidents_profile_keys(Keys),
    length(Keys, 5).
test(what_if_major_turns_the_chapter_into_reporting) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], payment_related_incident_is_major, true, Status), Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(what_if_not_major_gives_only_the_chapter) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], payment_related_incident_is_major, false, Status), Statuses),
    Statuses == [chapter_requirements_apply].
test(what_if_adds_an_absent_key) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], dora_entity_type, investment_firm, Status), Statuses),
    Statuses == [not_an_article_23_entity].
test(what_if_on_a_bad_profile_gives_its_problems) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(dora_entity_type, bank)], payment_related_incident_is_major, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(dora_entity_type)])].
test(what_if_with_a_bad_value_gives_its_problem) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(dora_entity_type, credit_institution)], payment_related_incident_is_major, maybe, Status), Statuses),
    Statuses == [input_problems([wrong_type(payment_related_incident_is_major)])].
