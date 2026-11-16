% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_queries, [nis2_information_sharing_voluntary_notification_profile_keys/1, nis2_information_sharing_voluntary_notification_what_if/4]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [nis2_information_sharing_voluntary_notification_status/2, nis2_information_sharing_voluntary_notification_checklist/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_information_sharing_voluntary_notification_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, event_kind, arrangement_event, information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity, arrangement_is_a_cybersecurity_information_sharing_arrangement].
test(the_reexported_input_check_names_an_untyped_key) :-
    nis2_information_sharing_voluntary_notification_profile_for(profile_with_an_untyped_key, Profile),
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(entity_in_scope)]].
test(the_reexported_input_check_accepts_the_empty_profile) :-
    nis2_information_sharing_voluntary_notification_input_problems([], []).
test(status_of_an_other_entity_significant_incident) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_a_significant_incident, Profile),
    findall(Status, nis2_information_sharing_voluntary_notification_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(status_of_an_unclassified_incident) :-
    nis2_information_sharing_voluntary_notification_profile_for(unclassified_entity_notifying_an_incident, Profile),
    findall(Status, nis2_information_sharing_voluntary_notification_status(Profile, Status), Statuses),
    Statuses == [eligibility_undetermined].
test(checklist_of_an_essential_entity_incident) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    findall(Items, nis2_information_sharing_voluntary_notification_checklist(Profile, Items), Answers),
    Answers == [[item(essential_or_important_entity, met, cite(eu_dir_2022_2555_art_30_1_a)), item(event_open_to_every_entity, unmet(incident_not_significant), cite(eu_dir_2022_2555_art_30_1_b))]].
test(checklist_of_the_empty_profile) :-
    nis2_information_sharing_voluntary_notification_checklist([], Items),
    Items == [item(essential_or_important_entity, unknown([entity_class]), cite(eu_dir_2022_2555_art_30_1_a)), item(event_open_to_every_entity, unknown([event_kind]), cite(eu_dir_2022_2555_art_30_1_b))].
test(checklist_of_a_bad_profile) :-
    nis2_information_sharing_voluntary_notification_profile_for(profile_with_an_untyped_key, Profile),
    nis2_information_sharing_voluntary_notification_checklist(Profile, Items),
    Items == [item(input_check, unknown([unknown_key(entity_in_scope)]), cite(eu_dir_2022_2555_art_30_1))].
test(what_if_an_other_entity_were_essential_gives_one_status) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_an_incident, Profile),
    findall(Status, nis2_information_sharing_voluntary_notification_what_if(Profile, entity_class, essential_entity, Status), Statuses),
    Statuses == [eligible].
test(what_if_the_incident_were_a_near_miss) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_what_if(Profile, event_kind, near_miss, eligible).
test(what_if_the_significant_incident_were_not_significant) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_a_significant_incident, Profile),
    nis2_information_sharing_voluntary_notification_what_if(Profile, event_kind, incident, ineligible).
test(what_if_adds_an_absent_key) :-
    nis2_information_sharing_voluntary_notification_what_if([], entity_class, important_entity, eligible).
test(what_if_clears_a_duplicate_key) :-
    findall(Status, nis2_information_sharing_voluntary_notification_what_if([attribute(entity_class, out_of_scope), attribute(entity_class, out_of_scope), attribute(event_kind, incident)], entity_class, essential_entity, Status), Statuses),
    Statuses == [eligible].
test(what_if_a_wrong_value_leaves_the_status_undetermined) :-
    nis2_information_sharing_voluntary_notification_profile_for(essential_entity_notifying_an_incident, Profile),
    nis2_information_sharing_voluntary_notification_what_if(Profile, entity_class, operator_of_essential_services, eligibility_undetermined).

test(what_if_the_significant_incident_were_not_significant_is_not_eligible, fail) :-
    nis2_information_sharing_voluntary_notification_profile_for(other_entity_notifying_a_significant_incident, Profile),
    nis2_information_sharing_voluntary_notification_what_if(Profile, event_kind, incident, eligible).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_names_an_untyped_key, the_reexported_input_check_accepts_the_empty_profile, status_of_an_other_entity_significant_incident, status_of_an_unclassified_incident, checklist_of_an_essential_entity_incident, checklist_of_the_empty_profile, checklist_of_a_bad_profile, what_if_an_other_entity_were_essential_gives_one_status, what_if_the_incident_were_a_near_miss, what_if_the_significant_incident_were_not_significant, what_if_adds_an_absent_key, what_if_clears_a_duplicate_key, what_if_a_wrong_value_leaves_the_status_undetermined]).
cp_test_fail_names([what_if_the_significant_incident_were_not_significant_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
