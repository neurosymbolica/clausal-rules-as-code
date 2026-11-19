% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4, dpdp_transfer_profile_keys/1, dpdp_transfer_what_if/4]).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [dpdp_transfer_checklist/2]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_subject/1, dpdp_transfer_profile_for/2]).

all_items_cited([]).
all_items_cited([item(_, _, cite(Key))|Items]) :-
    member(Key, [in_dpdp_act_2023_s_16_1, in_dpdp_act_2023_s_16_2, in_dpdp_rules_2025_r_15, in_dpdp_rules_2025_r_1_4]),
    all_items_cited(Items).

subject_checklist_cited(Subject) :-
    dpdp_transfer_profile_for(Subject, Request),
    dpdp_transfer_checklist(Request, Items),
    all_items_cited(Items).

test(profile_keys_are_the_contract_keys) :-
    dpdp_transfer_profile_keys(ProfileKeys),
    ProfileKeys == [section_16_in_force_on_reference_date, destination_restricted_by_notification, reference_date, recipient_is_foreign_state_or_its_entity, foreign_state_requirements_specified].
test(eligibility_one_answer_per_restriction) :-
    findall(Restriction - Result, (member(Restriction, [notified_destination, foreign_state_requirements]), restriction_status(Restriction, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true), attribute(reference_date, date(2028, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)], Result, _)), Answers),
    Answers == [notified_destination - restricted_see_notification, foreign_state_requirements - requirements_apply_see_order].
test(eligibility_both_restrictions_can_reach_one_transfer) :-
    restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)], restricted_see_notification, _),
    restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)], requirements_apply_see_order, _).
test(justification_every_checklist_item_cited) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    findall(Subject, (member(Subject, Subjects), subject_checklist_cited(Subject)), CitedSubjects),
    CitedSubjects == Subjects.
test(justification_unmet_item_for_no_notification) :-
    dpdp_transfer_profile_for(notified_destination_no_notification, Request),
    findall(Items, dpdp_transfer_checklist(Request, Items), Checklists),
    Checklists == [[item(section_16_in_force, met, cite(in_dpdp_act_2023_s_16_1)), item(destination_restricted_by_notification, unmet(destination_restricted_by_notification), cite(in_dpdp_act_2023_s_16_1))]].
test(what_if_flips_notification_to_restricted) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)]), destination_restricted_by_notification, true, Status), Statuses),
    Statuses == [restricted_see_notification].
test(what_if_moves_reference_date_before_commencement) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)]), reference_date, date(2027, 5, 12), Status), Statuses),
    Statuses == [not_in_force].
test(what_if_unread_key_changes_nothing) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)]), reference_date, date(2020, 1, 1), Status), Statuses),
    Statuses == [restricted_see_notification].
test(what_if_replaces_every_occurrence) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(section_16_in_force_on_reference_date, false), attribute(destination_restricted_by_notification, true)]), section_16_in_force_on_reference_date, true, Status), Statuses),
    Statuses == [restricted_see_notification].
test(what_if_wrong_type_is_an_input_problem) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)]), section_16_in_force_on_reference_date, unsure, Status), Statuses),
    Statuses == [input_problems([wrong_type(section_16_in_force_on_reference_date)])].
test(what_if_recipient_unsure_is_referred) :-
    findall(Status, dpdp_transfer_what_if(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)]), recipient_is_foreign_state_or_its_entity, unsure, Status), Statuses),
    Statuses == [needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])])].
test(input_check_reexported) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].

cp_test_names([profile_keys_are_the_contract_keys, eligibility_one_answer_per_restriction, eligibility_both_restrictions_can_reach_one_transfer, justification_every_checklist_item_cited, justification_unmet_item_for_no_notification, what_if_flips_notification_to_restricted, what_if_moves_reference_date_before_commencement, what_if_unread_key_changes_nothing, what_if_replaces_every_occurrence, what_if_wrong_type_is_an_input_problem, what_if_recipient_unsure_is_referred, input_check_reexported]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
