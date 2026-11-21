% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_queries, [nis2_domain_name_data_profile_keys/1, nis2_domain_name_data_what_if/4, nis2_domain_name_data_reply_deadline/2, nis2_domain_name_data_hours_elapsed/3, provider_type/0, point_of_contact_email_address_differs_from_registrant/0, point_of_contact_telephone_number_differs_from_registrant/0, registration_data_is_personal_data/0, requester_is_legitimate_access_seeker/0, request_is_lawful_and_duly_substantiated/0, reply_without_undue_delay/0, unsure/0, tld_name_registry/0, domain_name_registration_service_entity/0, other/0, must_publish_without_undue_delay/0, no_publication_duty/0, must_provide_access/0, no_duty_to_provide_access/0, on_time/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, duty/2, field/2, late/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3, date_diff/3]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_citations, [implements/1]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, access_reply_timeliness/3]).

nis2_domain_name_data_profile_keys([provider_type, point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant, registration_data_is_personal_data, requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated, reply_without_undue_delay]).

nis2_domain_name_data_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_domain_name_data_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([Element|Elements], OverriddenKey, NewValue, Hypothesis) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).
override_attribute([Element|Elements], OverriddenKey, NewValue, [Element|Hypothesis]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).
override_attribute([Element|Elements], OverriddenKey, NewValue, [Element|Hypothesis]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).

reply_hour_limit(LimitHours) :-
    implements(eu_dir_2022_2555_art_28_5),
    Ceiling #= 1000,
    between(0, Ceiling, LimitHours),
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], LimitHours, on_time),
    NextHours #= LimitHours + 1,
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], NextHours, late(hour_limit)).

nis2_domain_name_data_reply_deadline(ReceiptDatetime, DeadlineDatetime) :-
    implements(eu_dir_2022_2555_art_28_5),
    reply_hour_limit(LimitHours),
    LimitSeconds #= LimitHours * 3600,
    timedelta(0, LimitSeconds, ReplyPeriod),
    date_add(ReceiptDatetime, ReplyPeriod, DeadlineDatetime).

nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed) :-
    implements(eu_dir_2022_2555_art_28_5),
    date_diff(ReplyDatetime, ReceiptDatetime, Difference),
    timedelta(ElapsedDays, ElapsedDaySeconds, Difference),
    TotalSeconds #= ElapsedDays * 86400 + ElapsedDaySeconds,
    TotalSeconds #>= 0,
    HoursElapsed #= (TotalSeconds + 3599) // 3600.

provider_type.

point_of_contact_email_address_differs_from_registrant.

point_of_contact_telephone_number_differs_from_registrant.

registration_data_is_personal_data.

requester_is_legitimate_access_seeker.

request_is_lawful_and_duly_substantiated.

reply_without_undue_delay.

unsure.

tld_name_registry.

domain_name_registration_service_entity.

other.

must_publish_without_undue_delay.

no_publication_duty.

must_provide_access.

no_duty_to_provide_access.

on_time.

late(hour_limit).
late(without_undue_delay).

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(ReviewKey, cite(ReviewCitation)), [inputs_relied_on(Pairs)|_]) :-
    atom(ReviewKey),
    atom(ReviewCitation),
    clausal_is_list(Pairs).

open_textured(TexturedKey, cite(TexturedCitation)) :-
    atom(TexturedKey),
    atom(TexturedCitation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(DecidingClause, Citations) :-
    atom(DecidingClause),
    clausal_is_list(Citations).

input_problems([_|_]).

unknown_key(ProblemKey) :-
    atom(ProblemKey).

wrong_type(ProblemKey) :-
    atom(ProblemKey).

duplicate_key(ProblemKey) :-
    atom(ProblemKey).

duty(DutyName, cite(DutyCitation)) :-
    atom(DutyName),
    atom(DutyCitation).

field(FieldName, cite(FieldCitation)) :-
    atom(FieldName),
    atom(FieldCitation).
