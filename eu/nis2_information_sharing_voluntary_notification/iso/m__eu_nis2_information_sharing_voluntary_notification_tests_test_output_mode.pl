% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [voluntary_notification_possible/3, information_exchange_permitted/3, arrangement_notification_duty/3, decide_nis2_information_sharing_voluntary_notification/2, nis2_information_sharing_voluntary_notification_status/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_profile_for/2]).

voluntary_answers(Subject, Answers) :-
    nis2_information_sharing_voluntary_notification_profile_for(Subject, Profile),
    findall(Result - Citations, voluntary_notification_possible(Profile, Result, Citations), Answers).

exchange_answers(Subject, Answers) :-
    nis2_information_sharing_voluntary_notification_profile_for(Subject, Profile),
    findall(Result - Citations, information_exchange_permitted(Profile, Result, Citations), Answers).

arrangement_answers(Subject, Answers) :-
    nis2_information_sharing_voluntary_notification_profile_for(Subject, Profile),
    findall(Result - Citations, arrangement_notification_duty(Profile, Result, Citations), Answers).

test(voluntary_essential_entity_incident) :-
    voluntary_answers(essential_entity_notifying_an_incident, Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_a)]].
test(voluntary_other_entity_incident) :-
    voluntary_answers(other_entity_notifying_an_incident, Answers),
    Answers == [voluntary_notification_not_possible - [cite(eu_dir_2022_2555_art_30_1_b)]].
test(voluntary_other_entity_significant_incident) :-
    voluntary_answers(other_entity_notifying_a_significant_incident, Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_b)]].
test(voluntary_unclassified_cyber_threat) :-
    voluntary_answers(unclassified_entity_notifying_a_cyber_threat, Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)]].
test(voluntary_unclassified_incident) :-
    voluntary_answers(unclassified_entity_notifying_an_incident, Answers),
    Answers == [indeterminate([entity_class]) - []].
test(voluntary_empty_profile) :-
    voluntary_answers(empty_profile, Answers),
    Answers == [indeterminate([entity_class, event_kind]) - []].
test(voluntary_other_entity_without_an_event) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(entity_class, out_of_scope)], Result, Citations), Answers),
    Answers == [indeterminate([event_kind]) - []].
test(voluntary_untyped_key) :-
    voluntary_answers(profile_with_an_untyped_key, Answers),
    Answers == [input_problems([unknown_key(entity_in_scope)]) - []].
test(voluntary_enumerated_over_the_event_kinds_for_an_other_entity) :-
    findall(EventKind - Result, (member(EventKind, [incident, significant_incident, cyber_threat, near_miss]), voluntary_notification_possible([attribute(entity_class, out_of_scope), attribute(event_kind, EventKind)], Result, _)), Answers),
    Answers == [incident - voluntary_notification_not_possible, significant_incident - voluntary_notification_possible, cyber_threat - voluntary_notification_possible, near_miss - voluntary_notification_possible].
test(exchange_aiming_at_response) :-
    exchange_answers(exchange_aiming_at_response, Answers),
    Answers == [information_exchange_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(exchange_meeting_neither_point) :-
    exchange_answers(exchange_meeting_neither_point, Answers),
    Answers == [information_exchange_not_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(exchange_enhancing_cybersecurity_only) :-
    exchange_answers(exchange_enhancing_cybersecurity_only, Answers),
    Answers == [information_exchange_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(exchange_of_irrelevant_information) :-
    exchange_answers(exchange_of_irrelevant_information, Answers),
    Answers == [information_exchange_not_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(exchange_with_unsure_relevance) :-
    exchange_answers(exchange_with_unsure_relevance, Answers),
    Answers == [needs_legal_review(open_textured(information_is_relevant_cybersecurity_information, cite(eu_dir_2022_2555_art_29_1)), [inputs_relied_on([information_is_relevant_cybersecurity_information - unsure, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact - true])]) - []].
test(exchange_with_unsure_relevance_and_no_points) :-
    exchange_answers(exchange_with_unsure_relevance_and_no_points, Answers),
    Answers == [indeterminate([sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity]) - []].
test(exchange_empty_profile) :-
    exchange_answers(empty_profile, Answers),
    Answers == [indeterminate([information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity]) - []].
test(exchange_with_unsure_point_a) :-
    findall(Result - Citations, information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, true), attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, unsure), attribute(sharing_enhances_the_level_of_cybersecurity, false)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, cite(eu_dir_2022_2555_art_29_1_a)), [inputs_relied_on([information_is_relevant_cybersecurity_information - true, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact - unsure, sharing_enhances_the_level_of_cybersecurity - false])]) - []].
test(exchange_with_both_points_unsure_refers_point_a_first) :-
    findall(Result, information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, true), attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, unsure), attribute(sharing_enhances_the_level_of_cybersecurity, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, cite(eu_dir_2022_2555_art_29_1_a)), [inputs_relied_on([information_is_relevant_cybersecurity_information - true, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact - unsure, sharing_enhances_the_level_of_cybersecurity - unsure])])].
test(exchange_false_relevance_decides_before_missing_points) :-
    findall(Result - Citations, information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, false)], Result, Citations), Answers),
    Answers == [information_exchange_not_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(arrangement_essential_entity_entering) :-
    arrangement_answers(essential_entity_entering_an_arrangement, Answers),
    Answers == [must_notify_on_entering - [cite(eu_dir_2022_2555_art_29_4)]].
test(arrangement_other_entity_entering) :-
    arrangement_answers(other_entity_entering_an_arrangement, Answers),
    Answers == [no_notification_duty - [cite(eu_dir_2022_2555_art_29_4)]].
test(arrangement_important_entity_withdrawing) :-
    arrangement_answers(important_entity_withdrawing_from_an_arrangement, Answers),
    Answers == [must_notify_on_withdrawal_taking_effect - [cite(eu_dir_2022_2555_art_29_4)]].
test(arrangement_informal_contact) :-
    arrangement_answers(important_entity_withdrawing_from_an_informal_contact, Answers),
    Answers == [no_notification_duty - [cite(eu_dir_2022_2555_art_29_4)]].
test(arrangement_unsure_arrangement) :-
    arrangement_answers(essential_entity_entering_an_unsure_arrangement, Answers),
    Answers == [needs_legal_review(open_textured(arrangement_is_a_cybersecurity_information_sharing_arrangement, cite(eu_dir_2022_2555_art_29_2)), [inputs_relied_on([arrangement_is_a_cybersecurity_information_sharing_arrangement - unsure])]) - []].
test(arrangement_unsure_arrangement_and_no_event) :-
    arrangement_answers(essential_entity_with_an_unsure_arrangement_and_no_event, Answers),
    Answers == [indeterminate([arrangement_event]) - []].
test(arrangement_empty_profile) :-
    arrangement_answers(empty_profile, Answers),
    Answers == [indeterminate([entity_class, arrangement_event, arrangement_is_a_cybersecurity_information_sharing_arrangement]) - []].
test(arrangement_no_event_decides_whatever_is_missing) :-
    findall(Result - Citations, arrangement_notification_duty([attribute(arrangement_event, no_arrangement_event)], Result, Citations), Answers),
    Answers == [no_notification_duty - [cite(eu_dir_2022_2555_art_29_4)]].
test(input_check_untyped_key) :-
    nis2_information_sharing_voluntary_notification_profile_for(profile_with_an_untyped_key, Profile),
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(entity_in_scope)]].
test(the_baseline_profile_yields_exactly_one_status) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    findall(Status, nis2_information_sharing_voluntary_notification_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_citation) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    findall(Verdict, decide_nis2_information_sharing_voluntary_notification(Profile, Verdict), Verdicts),
    Verdicts == [nis2_information_sharing_voluntary_notification_verdict(eligible, [cite(eu_dir_2022_2555_art_30_1_a)])].
test(the_ineligible_verdict_cites_both_points) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_an_incident, Profile),
    findall(Verdict, decide_nis2_information_sharing_voluntary_notification(Profile, Verdict), Verdicts),
    Verdicts == [nis2_information_sharing_voluntary_notification_verdict(ineligible, [cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)])].
test(the_undetermined_verdict_has_no_citation) :-
    nis2_information_sharing_voluntary_notification_profile_for(unclassified_entity_notifying_an_incident, Profile),
    findall(Verdict, decide_nis2_information_sharing_voluntary_notification(Profile, Verdict), Verdicts),
    Verdicts == [nis2_information_sharing_voluntary_notification_verdict(eligibility_undetermined, [])].

cp_test_names([voluntary_essential_entity_incident, voluntary_other_entity_incident, voluntary_other_entity_significant_incident, voluntary_unclassified_cyber_threat, voluntary_unclassified_incident, voluntary_empty_profile, voluntary_other_entity_without_an_event, voluntary_untyped_key, voluntary_enumerated_over_the_event_kinds_for_an_other_entity, exchange_aiming_at_response, exchange_meeting_neither_point, exchange_enhancing_cybersecurity_only, exchange_of_irrelevant_information, exchange_with_unsure_relevance, exchange_with_unsure_relevance_and_no_points, exchange_empty_profile, exchange_with_unsure_point_a, exchange_with_both_points_unsure_refers_point_a_first, exchange_false_relevance_decides_before_missing_points, arrangement_essential_entity_entering, arrangement_other_entity_entering, arrangement_important_entity_withdrawing, arrangement_informal_contact, arrangement_unsure_arrangement, arrangement_unsure_arrangement_and_no_event, arrangement_empty_profile, arrangement_no_event_decides_whatever_is_missing, input_check_untyped_key, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, the_ineligible_verdict_cites_both_points, the_undetermined_verdict_has_no_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
