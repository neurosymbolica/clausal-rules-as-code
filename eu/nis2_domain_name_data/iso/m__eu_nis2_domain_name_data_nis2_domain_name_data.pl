% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_status/2, nis2_domain_name_data_checklist/2, nis2_domain_name_data_decision_resolvable/1, nis2_domain_name_data_status_values/1, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_citations, [implements/1]).

nis2_domain_name_data_status_values([addressed_provider, not_addressed_provider]).

addressed_provider_type(tld_name_registry).
addressed_provider_type(domain_name_registration_service_entity).

duty_row(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1)).
duty_row(hold_the_information_identifying_and_contacting_the_holders_and_points_of_contact, cite(eu_dir_2022_2555_art_28_2)).
duty_row(have_policies_and_verification_procedures_for_accurate_and_complete_data, cite(eu_dir_2022_2555_art_28_3)).
duty_row(make_the_accuracy_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_3)).
duty_row(make_non_personal_registration_data_publicly_available, cite(eu_dir_2022_2555_art_28_4)).
duty_row(provide_access_to_specific_registration_data_on_lawful_and_substantiated_requests, cite(eu_dir_2022_2555_art_28_5)).
duty_row(reply_to_access_requests_within_72_hours, cite(eu_dir_2022_2555_art_28_5)).
duty_row(make_the_disclosure_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_5)).
duty_row(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6)).

registrant_field_row(domain_name, cite(eu_dir_2022_2555_art_28_2_a)).
registrant_field_row(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)).
registrant_field_row(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)).
registrant_field_row(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)).
registrant_field_row(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c)).

point_of_contact_field_row(email_address, point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d)).
point_of_contact_field_row(telephone_number, point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d)).

key_state(Profile, AttributeKey, absent) :-
    profile_lacks(Profile, AttributeKey).
key_state(Profile, AttributeKey, present(AttributeValue)) :-
    profile_get(Profile, AttributeKey, AttributeValue).

relied_pairs(_, [], []).
relied_pairs(Profile, [AttributeKey|AttributeKeys], Pairs) :-
    key_state(Profile, AttributeKey, State),
    relied_pairs(Profile, AttributeKeys, LaterPairs),
    add_pair(State, AttributeKey, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(present(AttributeValue), AttributeKey, Pairs, [AttributeKey - AttributeValue|Pairs]).

provider_duties(Profile, input_problems([Problem|Problems])) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
provider_duties(Profile, Duties) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, provider_type, State),
    duties_for(State, Duties).

duties_for(absent, indeterminate([provider_type])).
duties_for(present(other), []) :-
    implements(eu_dir_2022_2555_art_28_1).
duties_for(present(ProviderType), Duties) :-
    implements(eu_dir_2022_2555_art_28_1),
    addressed_provider_type(ProviderType),
    addressed_provider_duties(Duties).

addressed_provider_duties(Duties) :-
    implements(eu_dir_2022_2555_art_28_1),
    findall(duty(DutyName, Citation), duty_row(DutyName, Citation), Duties).

required_registration_data(Profile, input_problems([Problem|Problems])) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
required_registration_data(Profile, Fields) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, point_of_contact_email_address_differs_from_registrant, EmailState),
    key_state(Profile, point_of_contact_telephone_number_differs_from_registrant, TelephoneState),
    fields_for(EmailState, TelephoneState, Fields).

fields_for(absent, _, indeterminate([point_of_contact_email_address_differs_from_registrant])).
fields_for(present(_), absent, indeterminate([point_of_contact_telephone_number_differs_from_registrant])).
fields_for(present(EmailDiffers), present(TelephoneDiffers), Fields) :-
    implements(eu_dir_2022_2555_art_28_2),
    findall(field(FieldName, Citation), registrant_field_row(FieldName, Citation), RegistrantFields),
    differing_field(email_address, EmailDiffers, EmailFields),
    differing_field(telephone_number, TelephoneDiffers, TelephoneFields),
    append(EmailFields, TelephoneFields, ContactFields),
    append(RegistrantFields, ContactFields, Fields).

differing_field(Element, true, [field(FieldName, Citation)]) :-
    implements(eu_dir_2022_2555_art_28_2_d),
    point_of_contact_field_row(Element, FieldName, Citation).
differing_field(_, false, []) :-
    implements(eu_dir_2022_2555_art_28_2_d).

publication_duty(Profile, input_problems([Problem|Problems]), []) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
publication_duty(Profile, Result, Citations) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, registration_data_is_personal_data, State),
    publication_for(State, Profile, Result, Citations).

publication_for(absent, _, indeterminate([registration_data_is_personal_data]), []).
publication_for(present(unsure), Profile, needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_4),
    relied_pairs(Profile, [registration_data_is_personal_data], Pairs).
publication_for(present(false), _, must_publish_without_undue_delay, [cite(eu_dir_2022_2555_art_28_4)]) :-
    implements(eu_dir_2022_2555_art_28_4).
publication_for(present(true), _, no_publication_duty, [cite(eu_dir_2022_2555_art_28_4)]) :-
    implements(eu_dir_2022_2555_art_28_4).

access_duty(Profile, input_problems([Problem|Problems]), []) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
access_duty(Profile, Result, Citations) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, requester_is_legitimate_access_seeker, SeekerState),
    key_state(Profile, request_is_lawful_and_duly_substantiated, RequestState),
    condition_class(SeekerState, SeekerClass),
    condition_class(RequestState, RequestClass),
    access_for(SeekerClass, RequestClass, Profile, Result, Citations).

condition_class(absent, absent).
condition_class(present(true), true).
condition_class(present(false), false).
condition_class(present(unsure), unsure).

non_false_class(absent).
non_false_class(true).
non_false_class(unsure).

answered_non_false_class(true).
answered_non_false_class(unsure).

access_keys([requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated]).

access_for(false, _, _, no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5).
access_for(SeekerClass, false, _, no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5),
    non_false_class(SeekerClass).
access_for(absent, RequestClass, _, indeterminate([requester_is_legitimate_access_seeker]), []) :-
    non_false_class(RequestClass).
access_for(SeekerClass, absent, _, indeterminate([request_is_lawful_and_duly_substantiated]), []) :-
    answered_non_false_class(SeekerClass).
access_for(unsure, RequestClass, Profile, needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_5),
    answered_non_false_class(RequestClass),
    access_keys(AttributeKeys),
    relied_pairs(Profile, AttributeKeys, Pairs).
access_for(true, unsure, Profile, needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_28_5),
    access_keys(AttributeKeys),
    relied_pairs(Profile, AttributeKeys, Pairs).
access_for(true, true, _, must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]) :-
    implements(eu_dir_2022_2555_art_28_5).

access_reply_timeliness(Profile, HoursElapsed, input_problems([Problem|Problems])) :-
    reply_problems(Profile, HoursElapsed, [Problem|Problems]).
access_reply_timeliness(Profile, HoursElapsed, Result) :-
    reply_problems(Profile, HoursElapsed, []),
    reply_for_hours(Profile, HoursElapsed, Result).

reply_problems(Profile, HoursElapsed, Problems) :-
    nis2_domain_name_data_input_problems(Profile, ProfileProblems),
    hours_problems(HoursElapsed, HoursProblems),
    append(ProfileProblems, HoursProblems, Problems).

hours_problems(HoursElapsed, Problems) :-
    hours_integer_t(HoursElapsed, IsInteger),
    integer_hours_problems(IsInteger, HoursElapsed, Problems).

hours_integer_t(HoursElapsed, Truth) :-
    catch(hours_must_be_integer(HoursElapsed, Truth), error(_, _), Truth = false).

hours_must_be_integer(HoursElapsed, true) :-
    must_be(integer, HoursElapsed).

integer_hours_problems(false, _, [wrong_type(hours_elapsed)]).
integer_hours_problems(true, HoursElapsed, []) :-
    HoursElapsed >= 0.
integer_hours_problems(true, HoursElapsed, [wrong_type(hours_elapsed)]) :-
    HoursElapsed < 0.

reply_for_hours(_, HoursElapsed, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_28_5),
    HoursElapsed #> 72.
reply_for_hours(Profile, HoursElapsed, Result) :-
    implements(eu_dir_2022_2555_art_28_5),
    HoursElapsed #< 73,
    key_state(Profile, reply_without_undue_delay, State),
    reply_within_limit(State, Profile, Result).

reply_within_limit(absent, _, indeterminate([reply_without_undue_delay])).
reply_within_limit(present(true), _, on_time) :-
    implements(eu_dir_2022_2555_art_28_5).
reply_within_limit(present(false), _, late(without_undue_delay)) :-
    implements(eu_dir_2022_2555_art_28_5).
reply_within_limit(present(unsure), Profile, needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2022_2555_art_28_5),
    relied_pairs(Profile, [reply_without_undue_delay], Pairs).

decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(input_problems([Problem|Problems]), [])) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(Status, Citations)) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, provider_type, State),
    provider_status(State, Status, Citations).

provider_status(absent, indeterminate([provider_type]), []).
provider_status(present(other), not_addressed_provider, [cite(eu_dir_2022_2555_art_28_1)]) :-
    implements(eu_dir_2022_2555_art_28_1).
provider_status(present(ProviderType), addressed_provider, Citations) :-
    implements(eu_dir_2022_2555_art_28_1),
    addressed_provider_type(ProviderType),
    findall(Citation, duty_row(_, Citation), DutyCitations),
    sort(DutyCitations, Citations).

nis2_domain_name_data_status(Profile, Status) :-
    decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(Status, _Citations)).

nis2_domain_name_data_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dir_2022_2555_art_28_1))]) :-
    nis2_domain_name_data_input_problems(Profile, [Problem|Problems]).
nis2_domain_name_data_checklist(Profile, [item(provider_addressed, AddresseeStatus, cite(eu_dir_2022_2555_art_28_1))|DutyItems]) :-
    nis2_domain_name_data_input_problems(Profile, []),
    key_state(Profile, provider_type, State),
    addressee_item_status(State, AddresseeStatus, DutyStatus),
    findall(item(DutyName, DutyStatus, Citation), duty_row(DutyName, Citation), DutyItems).

addressee_item_status(absent, unknown([provider_type]), unknown([provider_type])).
addressee_item_status(present(other), unmet(not_addressed_provider), inapplicable) :-
    implements(eu_dir_2022_2555_art_28_1).
addressee_item_status(present(ProviderType), met, applicable) :-
    implements(eu_dir_2022_2555_art_28_1),
    addressed_provider_type(ProviderType).

nis2_domain_name_data_decision_resolvable(Profile) :-
    decide_nis2_domain_name_data(Profile, _Verdict).

test(a_registry_has_nine_duties_in_article_order) :-
    findall(Duties, provider_duties([attribute(provider_type, tld_name_registry)], Duties), [Duties]),
    length(Duties, 9),
    Duties = [duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1))|_],
    last(Duties, duty(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6))).
test(a_registration_service_entity_has_nine_duties) :-
    findall(Duties, provider_duties([attribute(provider_type, domain_name_registration_service_entity)], Duties), [Duties]),
    length(Duties, 9).
test(another_entity_has_no_duty) :-
    findall(Duties, provider_duties([attribute(provider_type, other)], Duties), Answers),
    Answers == [[]].
test(an_absent_provider_type_is_asked_for) :-
    findall(Duties, provider_duties([], Duties), Answers),
    Answers == [indeterminate([provider_type])].
test(a_duplicate_key_is_an_input_problem) :-
    findall(Duties, provider_duties([attribute(provider_type, other), attribute(provider_type, other)], Duties), Answers),
    Answers == [input_problems([duplicate_key(provider_type)])].
test(a_key_not_read_is_still_checked) :-
    provider_duties([attribute(provider_type, other), attribute(reply_without_undue_delay, maybe)], input_problems([wrong_type(reply_without_undue_delay)])).
test(a_differing_email_alone_adds_only_the_email) :-
    findall(Fields, required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields), [Fields]),
    Fields == [field(domain_name, cite(eu_dir_2022_2555_art_28_2_a)), field(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)), field(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c)), field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d))].
test(both_differing_add_seven_fields) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, true)], Fields),
    length(Fields, 7).
test(neither_differing_gives_five_fields) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, false), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields),
    length(Fields, 5).
test(the_email_key_is_named_first) :-
    findall(Fields, required_registration_data([], Fields), Answers),
    Answers == [indeterminate([point_of_contact_email_address_differs_from_registrant])].
test(then_the_telephone_key) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, false)], indeterminate([point_of_contact_telephone_number_differs_from_registrant])).
test(non_personal_data_must_be_published) :-
    findall(Result - Citations, publication_duty([attribute(registration_data_is_personal_data, false)], Result, Citations), Answers),
    Answers == [must_publish_without_undue_delay - [cite(eu_dir_2022_2555_art_28_4)]].
test(personal_data_carry_no_publication_duty) :-
    publication_duty([attribute(registration_data_is_personal_data, true)], no_publication_duty, [cite(eu_dir_2022_2555_art_28_4)]).
test(an_unsure_personal_data_judgement_is_referred) :-
    publication_duty([attribute(registration_data_is_personal_data, unsure)], needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on([registration_data_is_personal_data - unsure])]), []).
test(an_absent_personal_data_judgement_is_asked_for) :-
    publication_duty([], indeterminate([registration_data_is_personal_data]), []).
test(a_false_condition_settles_access_beside_an_absent_one) :-
    findall(Result - Citations, access_duty([attribute(request_is_lawful_and_duly_substantiated, false)], Result, Citations), Answers),
    Answers == [no_duty_to_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(an_absent_key_beside_an_unsure_one_is_named) :-
    findall(Result, access_duty([attribute(requester_is_legitimate_access_seeker, unsure)], Result, _), Answers),
    Answers == [indeterminate([request_is_lawful_and_duly_substantiated])].
test(the_seeker_key_is_named_first) :-
    access_duty([attribute(request_is_lawful_and_duly_substantiated, unsure)], indeterminate([requester_is_legitimate_access_seeker]), []).
test(the_first_unsure_condition_is_referred_with_both_pairs) :-
    findall(Result, access_duty([attribute(requester_is_legitimate_access_seeker, unsure), attribute(request_is_lawful_and_duly_substantiated, true)], Result, []), Answers),
    Answers == [needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - unsure, request_is_lawful_and_duly_substantiated - true])])].
test(an_unsure_request_is_referred) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, unsure)], needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), _), []).
test(both_conditions_met_give_access) :-
    findall(Result, access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], Result, _), Answers),
    Answers == [must_provide_access].
test(seventy_two_hours_without_undue_delay_is_on_time) :-
    findall(Result, access_reply_timeliness([attribute(reply_without_undue_delay, true)], 72, Result), Answers),
    Answers == [on_time].
test(seventy_three_hours_is_late_whatever_the_judgement) :-
    findall(Result, access_reply_timeliness([], 73, Result), Answers),
    Answers == [late(hour_limit)].
test(undue_delay_within_the_limit_is_late) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, false)], 10, late(without_undue_delay)).
test(an_absent_delay_judgement_is_asked_for) :-
    access_reply_timeliness([], 10, indeterminate([reply_without_undue_delay])).
test(an_unsure_delay_judgement_is_referred) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, unsure)], 10, needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([reply_without_undue_delay - unsure])])).
test(a_negative_hour_count_is_an_input_problem) :-
    findall(Result, access_reply_timeliness([], -1, Result), Answers),
    Answers == [input_problems([wrong_type(hours_elapsed)])].
test(a_fraction_hour_count_is_an_input_problem) :-
    access_reply_timeliness([], 145/2, input_problems([wrong_type(hours_elapsed)])).
test(a_bad_profile_and_a_bad_hour_count) :-
    access_reply_timeliness(not_a_profile, many, input_problems([wrong_type(profile), wrong_type(hours_elapsed)])).
test(the_facade_marks_an_addressed_provider) :-
    findall(Status, nis2_domain_name_data_status([attribute(provider_type, tld_name_registry)], Status), Answers),
    Answers == [addressed_provider].
test(the_facade_marks_another_entity) :-
    nis2_domain_name_data_status([attribute(provider_type, other)], not_addressed_provider).
test(the_checklist_cites_every_row) :-
    nis2_domain_name_data_checklist([attribute(provider_type, tld_name_registry)], Items),
    length(Items, 10),
    Items = [item(provider_addressed, met, cite(eu_dir_2022_2555_art_28_1))|_].
test(the_checklist_is_unknown_without_a_provider_type) :-
    nis2_domain_name_data_checklist([], [item(provider_addressed, unknown([provider_type]), cite(eu_dir_2022_2555_art_28_1))|_]).

test(another_entity_is_not_given_the_duties, fail) :-
    provider_duties([attribute(provider_type, other)], [_|_]).
test(personal_data_are_not_must_publish, fail) :-
    publication_duty([attribute(registration_data_is_personal_data, true)], must_publish_without_undue_delay, _).
test(both_conditions_met_is_not_refused, fail) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], no_duty_to_provide_access, _).
test(seventy_three_hours_is_not_on_time, fail) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 73, on_time).
