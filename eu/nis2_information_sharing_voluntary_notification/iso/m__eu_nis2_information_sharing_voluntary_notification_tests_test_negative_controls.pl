% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [voluntary_notification_possible/3, information_exchange_permitted/3, arrangement_notification_duty/3, nis2_information_sharing_voluntary_notification_status/2, nis2_information_sharing_voluntary_notification_status_values/1]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_profile_for/2]).

profile(Subject, Profile) :-
    nis2_information_sharing_voluntary_notification_profile_for(Subject, Profile).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    nis2_information_sharing_voluntary_notification_status_values(StatusValues),
    member(ineligible, StatusValues),
    member(eligible, StatusValues).
test(point_a_positive) :-
    profile(essential_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a)]).
test(point_a_near_miss_answer) :-
    profile(other_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_not_possible, [cite(eu_dir_2022_2555_art_30_1_b)]).
test(point_b_positive) :-
    profile(other_entity_notifying_a_significant_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_b)]).
test(absent_class_positive) :-
    profile(unclassified_entity_notifying_a_cyber_threat, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)]).
test(absent_class_near_miss_answer) :-
    profile(unclassified_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, indeterminate([entity_class]), []).
test(exchange_point_a_positive) :-
    profile(exchange_aiming_at_response, Profile),
    information_exchange_permitted(Profile, information_exchange_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(exchange_point_a_near_miss_answer) :-
    profile(exchange_meeting_neither_point, Profile),
    information_exchange_permitted(Profile, information_exchange_not_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(exchange_point_b_positive) :-
    profile(exchange_enhancing_cybersecurity_only, Profile),
    information_exchange_permitted(Profile, information_exchange_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(exchange_point_b_near_miss_answer) :-
    profile(exchange_of_irrelevant_information, Profile),
    information_exchange_permitted(Profile, information_exchange_not_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(relevance_referral_positive) :-
    profile(exchange_with_unsure_relevance, Profile),
    information_exchange_permitted(Profile, needs_legal_review(open_textured(information_is_relevant_cybersecurity_information, cite(eu_dir_2022_2555_art_29_1)), [inputs_relied_on(_)]), []).
test(relevance_referral_near_miss_answer) :-
    profile(exchange_with_unsure_relevance_and_no_points, Profile),
    information_exchange_permitted(Profile, indeterminate([sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity]), []).
test(entering_positive) :-
    profile(essential_entity_entering_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_entering, [cite(eu_dir_2022_2555_art_29_4)]).
test(entering_near_miss_answer) :-
    profile(other_entity_entering_an_arrangement, Profile),
    arrangement_notification_duty(Profile, no_notification_duty, [cite(eu_dir_2022_2555_art_29_4)]).
test(withdrawal_positive) :-
    profile(important_entity_withdrawing_from_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_withdrawal_taking_effect, [cite(eu_dir_2022_2555_art_29_4)]).
test(withdrawal_near_miss_answer) :-
    profile(important_entity_withdrawing_from_an_informal_contact, Profile),
    arrangement_notification_duty(Profile, no_notification_duty, [cite(eu_dir_2022_2555_art_29_4)]).
test(arrangement_referral_positive) :-
    profile(essential_entity_entering_an_unsure_arrangement, Profile),
    arrangement_notification_duty(Profile, needs_legal_review(open_textured(arrangement_is_a_cybersecurity_information_sharing_arrangement, cite(eu_dir_2022_2555_art_29_2)), [inputs_relied_on([arrangement_is_a_cybersecurity_information_sharing_arrangement - unsure])]), []).
test(arrangement_referral_near_miss_answer) :-
    profile(essential_entity_with_an_unsure_arrangement_and_no_event, Profile),
    arrangement_notification_duty(Profile, indeterminate([arrangement_event]), []).
test(input_check_positive) :-
    profile(profile_with_an_untyped_key, Profile),
    voluntary_notification_possible(Profile, input_problems([unknown_key(entity_in_scope)]), []).
test(input_check_near_miss_answer) :-
    profile(empty_profile, Profile),
    voluntary_notification_possible(Profile, indeterminate([entity_class, event_kind]), []).
test(facade_positive) :-
    profile(essential_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_status(Profile, eligible).
test(facade_near_miss_answer) :-
    profile(other_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_status(Profile, ineligible).

test(point_a_near_miss_is_not_possible, fail) :-
    profile(other_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, _).
test(point_b_positive_is_not_refused, fail) :-
    profile(other_entity_notifying_a_significant_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_not_possible, _).
test(absent_class_near_miss_is_not_possible, fail) :-
    profile(unclassified_entity_notifying_an_incident, Profile),
    voluntary_notification_possible(Profile, voluntary_notification_possible, _).
test(exchange_point_a_near_miss_is_not_permitted, fail) :-
    profile(exchange_meeting_neither_point, Profile),
    information_exchange_permitted(Profile, information_exchange_permitted, _).
test(exchange_point_b_near_miss_is_not_permitted, fail) :-
    profile(exchange_of_irrelevant_information, Profile),
    information_exchange_permitted(Profile, information_exchange_permitted, _).
test(relevance_referral_near_miss_is_not_referred, fail) :-
    profile(exchange_with_unsure_relevance_and_no_points, Profile),
    information_exchange_permitted(Profile, needs_legal_review(_, _), _).
test(entering_near_miss_has_no_duty, fail) :-
    profile(other_entity_entering_an_arrangement, Profile),
    arrangement_notification_duty(Profile, must_notify_on_entering, _).
test(withdrawal_near_miss_has_no_duty, fail) :-
    profile(important_entity_withdrawing_from_an_informal_contact, Profile),
    arrangement_notification_duty(Profile, must_notify_on_withdrawal_taking_effect, _).
test(arrangement_referral_near_miss_is_not_referred, fail) :-
    profile(essential_entity_with_an_unsure_arrangement_and_no_event, Profile),
    arrangement_notification_duty(Profile, needs_legal_review(_, _), _).
test(input_check_near_miss_has_no_problem, fail) :-
    profile(empty_profile, Profile),
    voluntary_notification_possible(Profile, input_problems(_), _).
test(facade_near_miss_is_not_eligible, fail) :-
    profile(other_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_status(Profile, eligible).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, point_a_positive, point_a_near_miss_answer, point_b_positive, absent_class_positive, absent_class_near_miss_answer, exchange_point_a_positive, exchange_point_a_near_miss_answer, exchange_point_b_positive, exchange_point_b_near_miss_answer, relevance_referral_positive, relevance_referral_near_miss_answer, entering_positive, entering_near_miss_answer, withdrawal_positive, withdrawal_near_miss_answer, arrangement_referral_positive, arrangement_referral_near_miss_answer, input_check_positive, input_check_near_miss_answer, facade_positive, facade_near_miss_answer]).
cp_test_fail_names([point_a_near_miss_is_not_possible, point_b_positive_is_not_refused, absent_class_near_miss_is_not_possible, exchange_point_a_near_miss_is_not_permitted, exchange_point_b_near_miss_is_not_permitted, relevance_referral_near_miss_is_not_referred, entering_near_miss_has_no_duty, withdrawal_near_miss_has_no_duty, arrangement_referral_near_miss_is_not_referred, input_check_near_miss_has_no_problem, facade_near_miss_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
