% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_queries, [nis2_domain_name_data_profile_keys/1, nis2_domain_name_data_what_if/4, access_reply_deadline/2, access_reply_hours_elapsed/3, access_reply_outcome/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [date_add/3, date_diff/3, timedelta/3]).
:- use_module(m__eu_nis2_domain_name_data_citations, [implements/1]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, access_reply_timeliness/3]).

nis2_domain_name_data_profile_keys([provider_type, point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant, registration_data_is_personal_data, requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated, reply_without_undue_delay]).

nis2_domain_name_data_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_domain_name_data_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, NewProfile) :-
    override_attribute(Rest, Key, Value, NewProfile).
override_attribute([attribute(OtherKey, OtherValue)|Rest], Key, Value, [attribute(OtherKey, OtherValue)|NewRest]) :-
    dif(OtherKey, Key),
    override_attribute(Rest, Key, Value, NewRest).

access_reply_deadline(ReceiptDatetime, DeadlineDatetime) :-
    implements(eu_dir_2022_2555_art_28_5),
    PeriodSeconds #= 72 * 3600,
    timedelta(0, PeriodSeconds, ReplyPeriod),
    date_add(ReceiptDatetime, ReplyPeriod, DeadlineDatetime).

access_reply_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed) :-
    implements(eu_dir_2022_2555_art_28_5),
    date_diff(ReplyDatetime, ReceiptDatetime, Difference),
    timedelta(Days, DaySeconds, Difference),
    TotalSeconds #= Days * 86400 + DaySeconds,
    TotalSeconds #>= 0,
    HoursElapsed #= (TotalSeconds + 3600 - 1) // 3600.

access_reply_outcome(Profile, ReceiptDatetime, ReplyDatetime, Result) :-
    access_reply_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed),
    access_reply_timeliness(Profile, HoursElapsed, Result).
