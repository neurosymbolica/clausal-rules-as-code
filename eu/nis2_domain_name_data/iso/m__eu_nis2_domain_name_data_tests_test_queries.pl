% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_datetime, [datetime/7]).
:- use_module(m__eu_nis2_domain_name_data_queries, [nis2_domain_name_data_profile_keys/1, nis2_domain_name_data_what_if/4, access_reply_deadline/2, access_reply_hours_elapsed/3, access_reply_outcome/4]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, nis2_domain_name_data_checklist/2]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_domain_name_data_profile_keys(ProfileKeys),
    ProfileKeys == [provider_type, point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant, registration_data_is_personal_data, requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated, reply_without_undue_delay].
test(eligibility_status_for_registry) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_status(Profile, eligible).
test(justification_checklist_carries_cite) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_checklist(Profile, [item(_, _, cite(_))]).
test(what_if_provider_type_other_makes_it_ineligible) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_what_if(Profile, provider_type, other, ineligible).
test(what_if_yields_exactly_one_solution) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Status, nis2_domain_name_data_what_if(Profile, provider_type, other, Status), Statuses),
    Statuses == [ineligible].
test(what_if_restores_eligibility_from_other) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    nis2_domain_name_data_what_if(Profile, provider_type, domain_name_registration_service_entity, eligible).
test(what_if_adds_an_absent_key) :-
    nis2_domain_name_data_what_if([], provider_type, tld_name_registry, eligible).
test(what_if_invalid_value_is_an_input_problem) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_what_if(Profile, provider_type, bogus, input_problems([wrong_type(provider_type)])).
test(deadline_is_seventy_two_hours_after_receipt) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 0, 0, Expected),
    access_reply_deadline(Receipt, Deadline),
    Deadline == Expected.
test(hours_elapsed_exact_is_seventy_two) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 0, 0, Reply),
    access_reply_hours_elapsed(Receipt, Reply, 72).
test(hours_elapsed_rounds_a_partial_hour_up) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 30, 0, Reply),
    access_reply_hours_elapsed(Receipt, Reply, 73).
test(outcome_on_time_at_the_limit) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 0, 0, Reply),
    access_reply_outcome([attribute(reply_without_undue_delay, true)], Receipt, Reply, on_time).
test(outcome_late_one_partial_hour_after_the_limit) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 30, 0, Reply),
    access_reply_outcome([attribute(reply_without_undue_delay, true)], Receipt, Reply, late(hour_limit)).
test(outcome_yields_one_solution) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 2, 10, 0, 0, Reply),
    findall(Result, access_reply_outcome([attribute(reply_without_undue_delay, true)], Receipt, Reply, Result), Results),
    Results == [on_time].

test(what_if_provider_type_other_is_not_eligible, fail) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    nis2_domain_name_data_what_if(Profile, provider_type, other, eligible).
test(deadline_is_not_forty_eight_hours_after_receipt, fail) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 3, 10, 0, 0, Wrong),
    access_reply_deadline(Receipt, Wrong).
test(hours_elapsed_partial_hour_is_not_seventy_two, fail) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 30, 0, Reply),
    access_reply_hours_elapsed(Receipt, Reply, 72).
test(outcome_late_is_not_on_time, fail) :-
    datetime(2026, 1, 1, 10, 0, 0, Receipt),
    datetime(2026, 1, 4, 10, 30, 0, Reply),
    access_reply_outcome([attribute(reply_without_undue_delay, true)], Receipt, Reply, on_time).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_status_for_registry, justification_checklist_carries_cite, what_if_provider_type_other_makes_it_ineligible, what_if_yields_exactly_one_solution, what_if_restores_eligibility_from_other, what_if_adds_an_absent_key, what_if_invalid_value_is_an_input_problem, deadline_is_seventy_two_hours_after_receipt, hours_elapsed_exact_is_seventy_two, hours_elapsed_rounds_a_partial_hour_up, outcome_on_time_at_the_limit, outcome_late_one_partial_hour_after_the_limit, outcome_yields_one_solution]).
cp_test_fail_names([what_if_provider_type_other_is_not_eligible, deadline_is_not_forty_eight_hours_after_receipt, hours_elapsed_partial_hour_is_not_seventy_two, outcome_late_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
