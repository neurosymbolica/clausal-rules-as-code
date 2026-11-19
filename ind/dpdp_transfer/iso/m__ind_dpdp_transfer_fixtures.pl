% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_subject/1, dpdp_transfer_profile_for/2, dpdp_transfer_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4]).

dpdp_transfer_subject(notified_destination_restricted).
dpdp_transfer_subject(notified_destination_no_notification).
dpdp_transfer_subject(notified_destination_section_16_not_in_force).
dpdp_transfer_subject(notified_destination_section_16_unstated).
dpdp_transfer_subject(notified_destination_notification_unstated).
dpdp_transfer_subject(notified_destination_notification_unclear).
dpdp_transfer_subject(foreign_state_requirements_apply_on_commencement_day).
dpdp_transfer_subject(foreign_state_day_before_commencement).
dpdp_transfer_subject(foreign_state_section_16_not_in_force).
dpdp_transfer_subject(foreign_state_section_16_unstated).
dpdp_transfer_subject(foreign_state_section_16_unstated_day_before_commencement).
dpdp_transfer_subject(foreign_state_reference_date_unstated).
dpdp_transfer_subject(foreign_state_recipient_not_foreign_state).
dpdp_transfer_subject(foreign_state_no_order_specified).
dpdp_transfer_subject(foreign_state_recipient_unstated).
dpdp_transfer_subject(foreign_state_order_unstated).
dpdp_transfer_subject(foreign_state_order_unstated_recipient_unsure).
dpdp_transfer_subject(foreign_state_recipient_unclear).
dpdp_transfer_subject(input_crisp_key_given_unsure).
dpdp_transfer_subject(input_duplicate_key).
dpdp_transfer_subject(input_unknown_key).
dpdp_transfer_subject(input_not_a_real_day).
dpdp_transfer_subject(input_real_leap_day).
dpdp_transfer_subject(input_not_an_attribute_list).

dpdp_transfer_profile_for(notified_destination_restricted, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)])).
dpdp_transfer_profile_for(notified_destination_no_notification, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)])).
dpdp_transfer_profile_for(notified_destination_section_16_not_in_force, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, false), attribute(destination_restricted_by_notification, true)])).
dpdp_transfer_profile_for(notified_destination_section_16_unstated, restriction_request(notified_destination, [attribute(destination_restricted_by_notification, true)])).
dpdp_transfer_profile_for(notified_destination_notification_unstated, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true)])).
dpdp_transfer_profile_for(notified_destination_notification_unclear, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, unsure)])).
dpdp_transfer_profile_for(foreign_state_requirements_apply_on_commencement_day, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_day_before_commencement, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 12)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_section_16_not_in_force, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, false), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_section_16_unstated, restriction_request(foreign_state_requirements, [attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_section_16_unstated_day_before_commencement, restriction_request(foreign_state_requirements, [attribute(reference_date, date(2027, 5, 12)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_reference_date_unstated, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_recipient_not_foreign_state, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, false), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_no_order_specified, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, false)])).
dpdp_transfer_profile_for(foreign_state_recipient_unstated, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(foreign_state_order_unstated, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true)])).
dpdp_transfer_profile_for(foreign_state_order_unstated_recipient_unsure, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, unsure)])).
dpdp_transfer_profile_for(foreign_state_recipient_unclear, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, unsure), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(input_crisp_key_given_unsure, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, unsure), attribute(destination_restricted_by_notification, true)])).
dpdp_transfer_profile_for(input_duplicate_key, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)])).
dpdp_transfer_profile_for(input_unknown_key, restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true), attribute(colour, blue)])).
dpdp_transfer_profile_for(input_not_a_real_day, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 2, 29)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(input_real_leap_day, restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 2, 29)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)])).
dpdp_transfer_profile_for(input_not_an_attribute_list, restriction_request(foreign_state_requirements, not_a_list)).

dpdp_transfer_assess(Subject, dpdp_transfer_verdict(Result, Citations)) :-
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, Result, Citations).
