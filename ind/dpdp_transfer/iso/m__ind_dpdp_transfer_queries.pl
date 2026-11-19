% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_queries, [restriction_status/4, dpdp_transfer_profile_keys/1, dpdp_transfer_what_if/4, restricted_see_notification/0, requirements_apply_see_order/0, not_restricted/0, not_in_force/0, notified_destination/0, foreign_state_requirements/0, section_16_in_force_on_reference_date/0, destination_restricted_by_notification/0, reference_date/0, recipient_is_foreign_state_or_its_entity/0, foreign_state_requirements_specified/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [decide_dpdp_transfer/2, dpdp_transfer_status/2]).

restriction_status(Restriction, Profile, Result, Citations) :-
    decide_dpdp_transfer(restriction_request(Restriction, Profile), dpdp_transfer_verdict(Result, Citations)).

dpdp_transfer_profile_keys([section_16_in_force_on_reference_date, destination_restricted_by_notification, reference_date, recipient_is_foreign_state_or_its_entity, foreign_state_requirements_specified]).

dpdp_transfer_what_if(restriction_request(Restriction, Profile), OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dpdp_transfer_status(restriction_request(Restriction, Hypothesis), NewStatus).

attribute_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_override([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Hypothesis).
attribute_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Hypothesis).

restricted_see_notification.

requirements_apply_see_order.

not_restricted.

not_in_force.

notified_destination.

foreign_state_requirements.

section_16_in_force_on_reference_date.

destination_restricted_by_notification.

reference_date.

recipient_is_foreign_state_or_its_entity.

foreign_state_requirements_specified.

unsure.

test(restriction_status_gives_one_answer) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)], Result, Citations), Answers),
    Answers == [restricted_see_notification - [cite(in_dpdp_act_2023_s_16_1)]].
test(restriction_status_input_problems_first) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, not_a_list, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(what_if_flips_the_notification) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)]), destination_restricted_by_notification, true, Status), Statuses),
    Statuses == [restricted_see_notification].
test(what_if_supplies_an_absent_key) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)]), reference_date, date(2027, 5, 12), Status), Statuses),
    Statuses == [not_in_force].
test(input_check_called_directly_on_a_well_formed_profile) :-
    dpdp_transfer_input_problems([attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13))], Problems),
    Problems == [].
