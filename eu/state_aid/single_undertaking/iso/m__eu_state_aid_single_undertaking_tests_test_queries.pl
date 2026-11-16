% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_state_aid_single_undertaking_queries, [single_undertaking_profile_keys/1, single_undertaking_what_if/4]).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [single_undertaking_status/2, single_undertaking_checklist/2, single_undertaking_status_values/1]).
:- use_module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    single_undertaking_profile_keys(ProfileKeys),
    ProfileKeys == [holder_is_an_enterprise, held_is_an_enterprise, voting_rights_held, voting_rights_total, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, holder_is_shareholder_or_member, controls_majority_of_voting_rights_alone_by_agreement, first_enterprise, second_enterprise, relationships, relationships_complete].
test(the_re_exported_input_check_reports_a_duplicate) :-
    single_undertaking_profile_for(duplicate_key_given, Profile),
    single_undertaking_input_problems(Profile, Problems),
    Problems == [duplicate_key(first_enterprise)].
test(the_re_exported_input_check_accepts_a_good_profile) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    single_undertaking_input_problems(Profile, Problems),
    Problems == [].
test(status_of_sisters_through_a_common_holder) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    findall(Status, single_undertaking_status(Profile, Status), Statuses),
    Statuses == [single_undertaking].
test(status_of_an_unbound_profile_is_input_problems) :-
    single_undertaking_profile_for(unbound_profile, Profile),
    single_undertaking_status(Profile, Status),
    Status == input_problems([wrong_type(profile)]).
test(status_of_a_missing_list_is_indeterminate) :-
    single_undertaking_profile_for(relationship_list_missing, Profile),
    single_undertaking_status(Profile, Status),
    Status == indeterminate([relationships]).
test(the_status_values_are_the_two_final_answers) :-
    single_undertaking_status_values(StatusValues),
    StatusValues == [single_undertaking, not_single_undertaking].
test(every_checklist_item_carries_a_citation) :-
    single_undertaking_profile_for(board_right_held, Profile),
    single_undertaking_checklist(Profile, Items),
    findall(Identifier, member(item(Identifier, _, cite(_)), Items), Identifiers),
    Identifiers == [point_a, point_b, point_c, point_d, single_undertaking].
test(the_checklist_marks_point_b_met_with_its_citation) :-
    single_undertaking_profile_for(board_right_held, Profile),
    single_undertaking_checklist(Profile, Items),
    member(item(point_b, met, cite(eu_reg_2023_2831_art_2_2_b)), Items).
test(the_checklist_marks_a_ruled_out_point) :-
    single_undertaking_profile_for(exactly_half_fifty_of_one_hundred, Profile),
    single_undertaking_checklist(Profile, Items),
    member(item(point_a, unmet(point_ruled_out), cite(eu_reg_2023_2831_art_2_2_a)), Items).
test(the_checklist_ends_with_the_verdict_row) :-
    single_undertaking_profile_for(board_right_held, Profile),
    single_undertaking_checklist(Profile, Items),
    last(Items, LastItem),
    LastItem == item(single_undertaking, indeterminate([first_enterprise]), cite(eu_reg_2023_2831_art_2_2)).
test(the_checklist_of_a_problem_profile_is_one_item) :-
    single_undertaking_profile_for(unknown_key_given, Profile),
    single_undertaking_checklist(Profile, Items),
    Items == [item(input_check, input_problems([unknown_key(colour)]), cite(eu_reg_2023_2831_art_2_2))].
test(what_if_the_list_is_complete) :-
    single_undertaking_profile_for(relationship_list_incomplete, Profile),
    single_undertaking_what_if(Profile, relationships_complete, true, NewStatus),
    NewStatus == not_single_undertaking.
test(what_if_the_unsure_link_is_certain) :-
    single_undertaking_profile_for(sisters_through_unsure_link, Profile),
    single_undertaking_what_if(Profile, relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, true)], NewStatus),
    NewStatus == single_undertaking.
test(what_if_a_second_name_is_given) :-
    single_undertaking_profile_for(members_through_chain, Profile),
    single_undertaking_what_if(Profile, second_enterprise, alpha, NewStatus),
    NewStatus == single_undertaking.
test(what_if_never_creates_a_duplicate_key) :-
    single_undertaking_profile_for(same_enterprise_twice, Profile),
    single_undertaking_what_if(Profile, second_enterprise, beta, NewStatus),
    NewStatus == indeterminate([relationships]).
test(what_if_on_an_unbound_profile_reports_the_profile) :-
    single_undertaking_profile_for(unbound_profile, Profile),
    single_undertaking_what_if(Profile, first_enterprise, alpha, NewStatus),
    NewStatus == input_problems([wrong_type(profile)]).
test(what_if_with_a_wrong_value_reports_it) :-
    single_undertaking_profile_for(relationship_list_incomplete, Profile),
    single_undertaking_what_if(Profile, relationships_complete, maybe, NewStatus),
    NewStatus == input_problems([wrong_type(relationships_complete)]).
test(what_if_has_one_answer) :-
    single_undertaking_profile_for(relationship_list_incomplete, Profile),
    findall(NewStatus, single_undertaking_what_if(Profile, relationships_complete, true, NewStatus), Answers),
    Answers == [not_single_undertaking].

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_reports_a_duplicate, the_re_exported_input_check_accepts_a_good_profile, status_of_sisters_through_a_common_holder, status_of_an_unbound_profile_is_input_problems, status_of_a_missing_list_is_indeterminate, the_status_values_are_the_two_final_answers, every_checklist_item_carries_a_citation, the_checklist_marks_point_b_met_with_its_citation, the_checklist_marks_a_ruled_out_point, the_checklist_ends_with_the_verdict_row, the_checklist_of_a_problem_profile_is_one_item, what_if_the_list_is_complete, what_if_the_unsure_link_is_certain, what_if_a_second_name_is_given, what_if_never_creates_a_duplicate_key, what_if_on_an_unbound_profile_reports_the_profile, what_if_with_a_wrong_value_reports_it, what_if_has_one_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
