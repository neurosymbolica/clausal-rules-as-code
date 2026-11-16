% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, nis2_domain_name_data_status_values/1, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2]).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    nis2_domain_name_data_status_values(StatusValues),
    member(ineligible, StatusValues),
    member(eligible, StatusValues).
test(registry_is_eligible) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_status(Profile, eligible).
test(other_provider_is_ineligible) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    nis2_domain_name_data_status(Profile, ineligible).
test(registrar_is_eligible) :-
    nis2_domain_name_data_profile_for(registrar_addressed, Profile),
    nis2_domain_name_data_status(Profile, eligible).
test(registry_has_a_duty) :-
    provider_duties([attribute(provider_type, tld_name_registry)], [_|_]).
test(telephone_difference_adds_the_telephone_field) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, false), attribute(point_of_contact_telephone_number_differs_from_registrant, true)], Fields),
    last(Fields, field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d))),
    length(Fields, 6).
test(non_personal_data_must_be_published) :-
    publication_duty([attribute(registration_data_is_personal_data, false)], must_publish_without_undue_delay, _).
test(personal_data_has_no_publication_duty) :-
    publication_duty([attribute(registration_data_is_personal_data, true)], no_publication_duty, _).
test(legitimate_and_lawful_must_give_access) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], must_provide_access, _).
test(not_legitimate_is_no_duty) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, false), attribute(request_is_lawful_and_duly_substantiated, true)], no_duty_to_provide_access, _).
test(not_lawful_is_no_duty) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, false)], no_duty_to_provide_access, _).
test(unsure_second_key_refers) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, unsure)], needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), _), []).
test(seventy_two_hours_is_within_the_limit) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 72, on_time).
test(seventy_three_hours_is_late) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 73, late(hour_limit)).
test(undue_delay_inside_the_limit_is_late) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, false)], 72, late(without_undue_delay)).

test(registry_is_not_ineligible, fail) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_status(Profile, ineligible).
test(other_provider_is_not_eligible, fail) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    nis2_domain_name_data_status(Profile, eligible).
test(other_has_no_duty, fail) :-
    provider_duties([attribute(provider_type, other)], [_|_]).
test(no_difference_has_no_point_of_contact_field, fail) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, false), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields),
    member(field(point_of_contact_telephone_number, _), Fields).
test(email_difference_adds_no_telephone_field, fail) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, false)], Fields),
    member(field(point_of_contact_telephone_number, _), Fields).
test(personal_data_is_not_to_be_published, fail) :-
    publication_duty([attribute(registration_data_is_personal_data, true)], must_publish_without_undue_delay, _).
test(non_personal_data_has_a_publication_duty, fail) :-
    publication_duty([attribute(registration_data_is_personal_data, false)], no_publication_duty, _).
test(not_legitimate_is_not_must_provide, fail) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, false), attribute(request_is_lawful_and_duly_substantiated, true)], must_provide_access, _).
test(not_lawful_is_not_must_provide, fail) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, false)], must_provide_access, _).
test(both_true_is_not_no_duty, fail) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, true)], no_duty_to_provide_access, _).
test(unsure_second_key_refers_not_decides, fail) :-
    access_duty([attribute(requester_is_legitimate_access_seeker, true), attribute(request_is_lawful_and_duly_substantiated, unsure)], must_provide_access, _).
test(seventy_three_hours_is_not_on_time, fail) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 73, on_time).
test(seventy_two_hours_is_not_late, fail) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 72, late(hour_limit)).
test(undue_delay_inside_the_limit_is_not_on_time, fail) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, false)], 72, on_time).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, registry_is_eligible, other_provider_is_ineligible, registrar_is_eligible, registry_has_a_duty, telephone_difference_adds_the_telephone_field, non_personal_data_must_be_published, personal_data_has_no_publication_duty, legitimate_and_lawful_must_give_access, not_legitimate_is_no_duty, not_lawful_is_no_duty, unsure_second_key_refers, seventy_two_hours_is_within_the_limit, seventy_three_hours_is_late, undue_delay_inside_the_limit_is_late]).
cp_test_fail_names([registry_is_not_ineligible, other_provider_is_not_eligible, other_has_no_duty, no_difference_has_no_point_of_contact_field, email_difference_adds_no_telephone_field, personal_data_is_not_to_be_published, non_personal_data_has_a_publication_duty, not_legitimate_is_not_must_provide, not_lawful_is_not_must_provide, both_true_is_not_no_duty, unsure_second_key_refers_not_decides, seventy_three_hours_is_not_on_time, seventy_two_hours_is_not_late, undue_delay_inside_the_limit_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
