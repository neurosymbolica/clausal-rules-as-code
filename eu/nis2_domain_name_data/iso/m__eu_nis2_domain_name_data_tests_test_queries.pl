% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_datetime, [datetime/7]).
:- use_module(m__eu_nis2_domain_name_data_queries, [nis2_domain_name_data_profile_keys/1, nis2_domain_name_data_what_if/4, nis2_domain_name_data_reply_deadline/2, nis2_domain_name_data_hours_elapsed/3]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_checklist/2, access_reply_timeliness/3]).

test(profile_keys_are_the_contract_keys) :-
    nis2_domain_name_data_profile_keys(ProfileKeys),
    ProfileKeys == [provider_type, point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant, registration_data_is_personal_data, requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated, reply_without_undue_delay].
test(the_reexported_input_check_answers_once) :-
    findall(Problems, nis2_domain_name_data_input_problems([attribute(provider_type, other)], Problems), Answers),
    Answers == [[]].
test(the_reexported_input_check_names_an_unknown_key) :-
    nis2_domain_name_data_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
test(what_if_another_entity_were_a_registry) :-
    findall(NewStatus, nis2_domain_name_data_what_if([attribute(provider_type, other)], provider_type, tld_name_registry, NewStatus), Answers),
    Answers == [addressed_provider].
test(what_if_a_registry_were_another_entity) :-
    nis2_domain_name_data_what_if([attribute(provider_type, tld_name_registry)], provider_type, other, not_addressed_provider).
test(the_eligibility_verdict_is_cited) :-
    decide_nis2_domain_name_data([attribute(provider_type, domain_name_registration_service_entity)], nis2_domain_name_data_verdict(addressed_provider, [cite(eu_dir_2022_2555_art_28_1)|_])).
test(every_checklist_row_is_cited) :-
    nis2_domain_name_data_checklist([attribute(provider_type, tld_name_registry)], Items),
    length(Items, ItemCount),
    findall(Key, member(item(_, _, cite(Key)), Items), CitedKeys),
    length(CitedKeys, ItemCount).
test(the_reply_deadline_is_seventy_two_hours_after_receipt) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    findall(DeadlineDatetime, nis2_domain_name_data_reply_deadline(ReceiptDatetime, DeadlineDatetime), [DeadlineDatetime]),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, DeadlineDatetime, 72).
test(a_reply_at_the_deadline_is_on_time) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    nis2_domain_name_data_reply_deadline(ReceiptDatetime, DeadlineDatetime),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, DeadlineDatetime, HoursElapsed),
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], HoursElapsed, on_time).
test(a_part_of_an_hour_counts_as_a_whole_hour) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    datetime(2026, 3, 5, 9, 30, 0, ReplyDatetime),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, 73).
test(seventy_two_hours_thirty_minutes_is_late) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    datetime(2026, 3, 5, 9, 30, 0, ReplyDatetime),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed),
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], HoursElapsed, late(hour_limit)).
test(a_reply_one_second_after_receipt_counts_one_hour) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    datetime(2026, 3, 2, 9, 0, 1, ReplyDatetime),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, 1).

test(a_reply_before_receipt_counts_no_hours, fail) :-
    datetime(2026, 3, 2, 9, 0, 0, ReceiptDatetime),
    datetime(2026, 3, 1, 9, 0, 0, ReplyDatetime),
    nis2_domain_name_data_hours_elapsed(ReceiptDatetime, ReplyDatetime, _).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_answers_once, the_reexported_input_check_names_an_unknown_key, what_if_another_entity_were_a_registry, what_if_a_registry_were_another_entity, the_eligibility_verdict_is_cited, every_checklist_row_is_cited, the_reply_deadline_is_seventy_two_hours_after_receipt, a_reply_at_the_deadline_is_on_time, a_part_of_an_hour_counts_as_a_whole_hour, seventy_two_hours_thirty_minutes_is_late, a_reply_one_second_after_receipt_counts_one_hour]).
cp_test_fail_names([a_reply_before_receipt_counts_no_hours]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
