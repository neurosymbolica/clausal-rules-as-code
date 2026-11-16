% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_status/2, nis2_domain_name_data_checklist/2, nis2_domain_name_data_decision_resolvable/1, nis2_domain_name_data_status_values/1, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3, tld_name_registry/0, domain_name_registration_service_entity/0, other/0, must_publish_without_undue_delay/0, no_publication_duty/0, must_provide_access/0, no_duty_to_provide_access/0, on_time/0, unsure/0, provider_type/0, point_of_contact_email_address_differs_from_registrant/0, point_of_contact_telephone_number_differs_from_registrant/0, registration_data_is_personal_data/0, requester_is_legitimate_access_seeker/0, request_is_lawful_and_duly_substantiated/0, reply_without_undue_delay/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_has/2, profile_lacks/2, profile_get/3]).
:- use_module(m__eu_nis2_domain_name_data_citations, [implements/1]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).

tld_name_registry.

domain_name_registration_service_entity.

other.

must_publish_without_undue_delay.

no_publication_duty.

must_provide_access.

no_duty_to_provide_access.

on_time.

unsure.

provider_type.

point_of_contact_email_address_differs_from_registrant.

point_of_contact_telephone_number_differs_from_registrant.

registration_data_is_personal_data.

requester_is_legitimate_access_seeker.

request_is_lawful_and_duly_substantiated.

reply_without_undue_delay.

nis2_domain_name_data_status_values([eligible, ineligible]).

reply_limit_hours(72, cite(eu_dir_2022_2555_art_28_5)).

nine_duties([duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1)), duty(hold_the_information_identifying_and_contacting_the_holders_and_points_of_contact, cite(eu_dir_2022_2555_art_28_2)), duty(have_policies_and_verification_procedures_for_accurate_and_complete_data, cite(eu_dir_2022_2555_art_28_3)), duty(make_the_accuracy_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_3)), duty(make_non_personal_registration_data_publicly_available, cite(eu_dir_2022_2555_art_28_4)), duty(provide_access_to_specific_registration_data_on_lawful_and_substantiated_requests, cite(eu_dir_2022_2555_art_28_5)), duty(reply_to_access_requests_within_72_hours, cite(eu_dir_2022_2555_art_28_5)), duty(make_the_disclosure_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_5)), duty(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6))]).

base_fields([field(domain_name, cite(eu_dir_2022_2555_art_28_2_a)), field(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)), field(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c))]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

judgement_pairs(_, [], []).
judgement_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    judgement_pairs(Profile, Keys, LaterPairs),
    add_pair(State, Key, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(true, Key, Pairs, [Key - true|Pairs]).
add_pair(false, Key, Pairs, [Key - false|Pairs]).
add_pair(unsure, Key, Pairs, [Key - unsure|Pairs]).

open_state(true).
open_state(unsure).

not_false_state(true).
not_false_state(unsure).
not_false_state(absent).

boolean_state(true).
boolean_state(false).

provider_duties(Profile, Duties) :-
    nis2_domain_name_data_input_problems(Profile, Problems),
    provider_duties_for(Problems, Profile, Duties).

provider_duties_for([Problem|Problems], _, input_problems([Problem|Problems])).
provider_duties_for([], Profile, Duties) :-
    key_state(Profile, provider_type, Type),
    duties_for_type(Type, Duties).

duties_for_type(absent, indeterminate([provider_type])).
duties_for_type(other, []) :-
    implements(eu_dir_2022_2555_art_28_1).
duties_for_type(tld_name_registry, Duties) :-
    implements(eu_dir_2022_2555_art_28_1),
    nine_duties(Duties).
duties_for_type(domain_name_registration_service_entity, Duties) :-
    implements(eu_dir_2022_2555_art_28_1),
    nine_duties(Duties).

required_registration_data(Profile, Fields) :-
    nis2_domain_name_data_input_problems(Profile, Problems),
    required_fields_for(Problems, Profile, Fields).

required_fields_for([Problem|Problems], _, input_problems([Problem|Problems])).
required_fields_for([], Profile, Fields) :-
    key_state(Profile, point_of_contact_email_address_differs_from_registrant, EmailState),
    key_state(Profile, point_of_contact_telephone_number_differs_from_registrant, TelephoneState),
    fields_result(EmailState, TelephoneState, Fields).

fields_result(absent, absent, indeterminate([point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant])).
fields_result(absent, TelephoneState, indeterminate([point_of_contact_email_address_differs_from_registrant])) :-
    boolean_state(TelephoneState).
fields_result(EmailState, absent, indeterminate([point_of_contact_telephone_number_differs_from_registrant])) :-
    boolean_state(EmailState).
fields_result(EmailState, TelephoneState, Fields) :-
    implements(eu_dir_2022_2555_art_28_2),
    boolean_state(EmailState),
    boolean_state(TelephoneState),
    base_fields(BaseFields),
    point_field(EmailState, field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d)), EmailFields),
    point_field(TelephoneState, field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d)), TelephoneFields),
    append(BaseFields, EmailFields, WithEmail),
    append(WithEmail, TelephoneFields, Fields).

point_field(true, Field, [Field]) :-
    implements(eu_dir_2022_2555_art_28_2_d).
point_field(false, _, []) :-
    implements(eu_dir_2022_2555_art_28_2_d).

publication_duty(Profile, Result, Citations) :-
    nis2_domain_name_data_input_problems(Profile, Problems),
    publication_for(Problems, Profile, Result, Citations).

publication_for([Problem|Problems], _, input_problems([Problem|Problems]), []).
publication_for([], Profile, Result, Citations) :-
    key_state(Profile, registration_data_is_personal_data, State),
    publication_state(State, Profile, Result, Citations).

publication_state(absent, _, indeterminate([registration_data_is_personal_data]), []).
publication_state(unsure, Profile, needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_4),
    judgement_pairs(Profile, [registration_data_is_personal_data], Pairs).
publication_state(false, _, must_publish_without_undue_delay, [cite(eu_dir_2022_2555_art_28_4)]) :-
    implements(eu_dir_2022_2555_art_28_4).
publication_state(true, _, no_publication_duty, [cite(eu_dir_2022_2555_art_28_4)]) :-
    implements(eu_dir_2022_2555_art_28_4).

access_duty(Profile, Result, Citations) :-
    nis2_domain_name_data_input_problems(Profile, Problems),
    access_for(Problems, Profile, Result, Citations).

access_for([Problem|Problems], _, input_problems([Problem|Problems]), []).
access_for([], Profile, Result, Citations) :-
    key_state(Profile, requester_is_legitimate_access_seeker, SeekerState),
    key_state(Profile, request_is_lawful_and_duly_substantiated, LawfulState),
    access_state(SeekerState, LawfulState, Profile, Result, Citations).

access_state(false, _, _, no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5).
access_state(SeekerState, false, _, no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5),
    not_false_state(SeekerState).
access_state(absent, absent, _, indeterminate([requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated]), []).
access_state(absent, LawfulState, _, indeterminate([requester_is_legitimate_access_seeker]), []) :-
    open_state(LawfulState).
access_state(SeekerState, absent, _, indeterminate([request_is_lawful_and_duly_substantiated]), []) :-
    open_state(SeekerState).
access_state(unsure, LawfulState, Profile, needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_5),
    open_state(LawfulState),
    judgement_pairs(Profile, [requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated], Pairs).
access_state(true, unsure, Profile, needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_5),
    judgement_pairs(Profile, [requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated], Pairs).
access_state(true, true, _, must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5).

access_reply_timeliness(Profile, HoursElapsed, Result) :-
    nis2_domain_name_data_input_problems(Profile, ProfileProblems),
    hours_valid_t(HoursElapsed, HoursAreValid),
    hours_problems(HoursAreValid, HoursProblems),
    append(ProfileProblems, HoursProblems, Problems),
    timeliness_for(Problems, Profile, HoursElapsed, Result).

hours_valid_t(Hours, false) :-
    var(Hours).
hours_valid_t(Hours, true) :-
    integer(Hours),
    Hours >= 0.
hours_valid_t(Hours, false) :-
    integer(Hours),
    Hours < 0.
hours_valid_t(Hours, false) :-
    float(Hours).
hours_valid_t(Hours, false) :-
    atom(Hours).
hours_valid_t(Hours, false) :-
    compound(Hours).

hours_problems(true, []).
hours_problems(false, [wrong_type(hours_elapsed)]).

timeliness_for([Problem|Problems], _, _, input_problems([Problem|Problems])).
timeliness_for([], Profile, HoursElapsed, Result) :-
    reply_limit_hours(LimitHours, _),
    timeliness_at(HoursElapsed, LimitHours, Profile, Result).

timeliness_at(HoursElapsed, LimitHours, _, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_28_5),
    HoursElapsed #> LimitHours.
timeliness_at(HoursElapsed, LimitHours, Profile, Result) :-
    HoursElapsed #=< LimitHours,
    key_state(Profile, reply_without_undue_delay, State),
    reply_state(State, Profile, Result).

reply_state(absent, _, indeterminate([reply_without_undue_delay])).
reply_state(true, _, on_time) :-
    implements(eu_dir_2022_2555_art_28_5).
reply_state(false, _, late(without_undue_delay)) :-
    implements(eu_dir_2022_2555_art_28_5).
reply_state(unsure, Profile, needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2022_2555_art_28_5),
    judgement_pairs(Profile, [reply_without_undue_delay], Pairs).

decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(Status, Citations)) :-
    provider_duties(Profile, Duties),
    verdict_from_duties(Duties, Status, Citations).

verdict_from_duties([], ineligible, [cite(eu_dir_2022_2555_art_28_1)]).
verdict_from_duties([Duty|Duties], eligible, [cite(eu_dir_2022_2555_art_28_1)]) :-
    implements(eu_dir_2022_2555_art_28_1),
    length([Duty|Duties], _).
verdict_from_duties(indeterminate(Keys), indeterminate(Keys), []).
verdict_from_duties(input_problems(Problems), input_problems(Problems), []).

nis2_domain_name_data_status(Profile, Status) :-
    decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(Status, _Citations)).

nis2_domain_name_data_checklist(Profile, [item(provider_addressed, ItemStatus, cite(eu_dir_2022_2555_art_28_1))]) :-
    decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(Status, _Citations)),
    item_status(Status, ItemStatus).

item_status(eligible, met).
item_status(ineligible, unmet(not_an_addressed_provider)).
item_status(indeterminate(Keys), unknown(Keys)).
item_status(input_problems(Problems), unmet(input_problems(Problems))).

nis2_domain_name_data_decision_resolvable(Profile) :-
    decide_nis2_domain_name_data(Profile, _Verdict).

test(duties_for_other_is_empty) :-
    provider_duties([attribute(provider_type, other)], []).
test(duties_for_registry_are_nine) :-
    provider_duties([attribute(provider_type, tld_name_registry)], Duties),
    length(Duties, 9).
test(duties_absent_type_is_indeterminate) :-
    provider_duties([], indeterminate([provider_type])).
test(duties_bad_type_is_input_problem) :-
    provider_duties([attribute(provider_type, bogus)], input_problems([wrong_type(provider_type)])).
test(fields_without_difference_are_five) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, false), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields),
    length(Fields, 5).
test(fields_with_email_difference_are_six) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields),
    length(Fields, 6).
test(fields_missing_key_is_named) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true)], indeterminate([point_of_contact_telephone_number_differs_from_registrant])).
test(publication_for_non_personal_data) :-
    publication_duty([attribute(registration_data_is_personal_data, false)], must_publish_without_undue_delay, [cite(eu_dir_2022_2555_art_28_4)]).
test(publication_for_personal_data) :-
    publication_duty([attribute(registration_data_is_personal_data, true)], no_publication_duty, [cite(eu_dir_2022_2555_art_28_4)]).
test(publication_unsure_refers) :-
    publication_duty([attribute(registration_data_is_personal_data, unsure)], needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on([registration_data_is_personal_data - unsure])]), []).
test(access_false_decides_before_unsure) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, false), attribute(request_is_lawful_and_duly_substantiated, unsure)], no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).
test(access_unsure_with_absent_is_indeterminate) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, unsure)], indeterminate([request_is_lawful_and_duly_substantiated]), []).
test(access_both_true) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).
test(reply_at_72_hours_is_on_time) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 72, on_time).
test(reply_at_73_hours_is_late) :-
    access_reply_timeliness([], 73, late(hour_limit)).
test(reply_with_undue_delay_is_late) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, false)], 10, late(without_undue_delay)).
test(reply_negative_hours_is_input_problem) :-
    access_reply_timeliness([], -1, input_problems([wrong_type(hours_elapsed)])).
test(verdict_for_registry_is_eligible) :-
    nis2_domain_name_data_status([attribute(provider_type, tld_name_registry)], eligible).
test(verdict_for_other_is_ineligible) :-
    nis2_domain_name_data_status([attribute(provider_type, other)], ineligible).

test(verdict_for_other_is_not_eligible, fail) :-
    nis2_domain_name_data_status([attribute(provider_type, other)], eligible).
