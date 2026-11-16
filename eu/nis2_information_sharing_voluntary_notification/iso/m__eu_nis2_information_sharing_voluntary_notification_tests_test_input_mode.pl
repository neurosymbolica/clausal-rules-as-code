% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [voluntary_notification_possible/3, information_exchange_permitted/3, arrangement_notification_duty/3, nis2_information_sharing_voluntary_notification_status/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_status(Profile, eligible).
test(voluntary_point_a_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a)]).
test(voluntary_point_b_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_a_significant_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_b)]).
test(voluntary_not_possible_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_not_possible, [cite(eu_dir_2022_2555_art_30_1_b)]).
test(exchange_permitted_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(exchange_aiming_at_response, Profile),
    information_exchange_permitted(Profile, information_exchange_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(exchange_not_permitted_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(exchange_meeting_neither_point, Profile),
    information_exchange_permitted(Profile, information_exchange_not_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(arrangement_entering_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_entering_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_entering, [cite(eu_dir_2022_2555_art_29_4)]).
test(arrangement_withdrawal_bound) :-
    nis2_information_sharing_voluntary_notification_profile_for(important_entity_withdrawing_from_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_withdrawal_taking_effect, [cite(eu_dir_2022_2555_art_29_4)]).
test(the_order_of_the_attributes_does_not_matter) :-
    findall(Result - Citations, arrangement_notification_duty([attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, true), attribute(arrangement_event, entered), attribute(entity_class, important_entity)], Result, Citations), Answers),
    Answers == [must_notify_on_entering - [cite(eu_dir_2022_2555_art_29_4)]].
test(a_key_no_query_reads_is_still_accepted) :-
    voluntary_notification_possible([attribute(arrangement_event, withdrew), attribute(entity_class, important_entity)], voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a)]).
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, out_of_scope), attribute(sharing_enhances_the_level_of_cybersecurity, unsure)], Problems), Answers),
    Answers == [[]].
test(the_empty_profile_has_no_problem) :-
    nis2_information_sharing_voluntary_notification_input_problems([], []).
test(a_non_list_is_not_a_profile) :-
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_foreign_element_spoils_the_list) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, essential_entity), entity_class], [wrong_type(profile)]).
test(an_enumeration_outside_its_atoms_is_wrong_type) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(event_kind, data_breach)], [wrong_type(event_kind)]).
test(a_quoted_python_boolean_is_wrong_type) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(information_is_relevant_cybersecurity_information, 'True')], [wrong_type(information_is_relevant_cybersecurity_information)]).
test(a_number_is_wrong_type_for_a_judgement) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, 1)], [wrong_type(arrangement_is_a_cybersecurity_information_sharing_arrangement)]).
test(a_repeated_key_is_a_duplicate_whatever_its_values) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, essential_entity), attribute(entity_class, bogus)], [duplicate_key(entity_class)]).
test(a_repeated_unknown_key_is_named_once) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_in_scope, true), attribute(entity_in_scope, false)], [unknown_key(entity_in_scope)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(mandatory_under_art_23, true), attribute(event_kind, bogus), attribute(entity_class, essential_entity), attribute(entity_class, essential_entity), attribute(notified_authority_of_arrangement_event, false)], [duplicate_key(entity_class), wrong_type(event_kind), unknown_key(mandatory_under_art_23), unknown_key(notified_authority_of_arrangement_event)]).
test(every_query_answers_input_problems_first) :-
    Profile = [attribute(entity_class, essential_entity), attribute(sharing_enhances_the_level_of_cybersecurity, maybe)],
    voluntary_notification_possible(Profile, input_problems([wrong_type(sharing_enhances_the_level_of_cybersecurity)]), []),
    information_exchange_permitted(Profile, input_problems([wrong_type(sharing_enhances_the_level_of_cybersecurity)]), []),
    arrangement_notification_duty(Profile, input_problems([wrong_type(sharing_enhances_the_level_of_cybersecurity)]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_status(Profile, ineligible).
test(voluntary_not_possible_rejects_possible, fail) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, _).
test(arrangement_withdrawal_rejects_entering, fail) :-
    nis2_information_sharing_voluntary_notification_profile_for(important_entity_withdrawing_from_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_entering, _).
test(a_bad_profile_gets_no_final_answer, fail) :-
    voluntary_notification_possible([attribute(entity_class, essential_entity), attribute(entity_in_scope, true)], voluntary_notification_possible, _).

cp_test_names([status_holds_with_the_verdict_bound, voluntary_point_a_bound, voluntary_point_b_bound, voluntary_not_possible_bound, exchange_permitted_bound, exchange_not_permitted_bound, arrangement_entering_bound, arrangement_withdrawal_bound, the_order_of_the_attributes_does_not_matter, a_key_no_query_reads_is_still_accepted, a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, a_non_list_is_not_a_profile, a_foreign_element_spoils_the_list, an_enumeration_outside_its_atoms_is_wrong_type, a_quoted_python_boolean_is_wrong_type, a_number_is_wrong_type_for_a_judgement, a_repeated_key_is_a_duplicate_whatever_its_values, a_repeated_unknown_key_is_named_once, problems_come_in_contract_order_then_unknown_keys, every_query_answers_input_problems_first]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, voluntary_not_possible_rejects_possible, arrangement_withdrawal_rejects_entering, a_bad_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
