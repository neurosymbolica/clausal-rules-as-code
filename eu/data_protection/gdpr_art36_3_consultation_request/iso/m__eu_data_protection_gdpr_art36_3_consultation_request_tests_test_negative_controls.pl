% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, gdpr_art36_3_consultation_request_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

status_of(Subject, Result) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    consultation_request_status(Profile, Result, _Basis, _Citations).

items_of(Subject, Items) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    missing_consultation_request_items(Profile, Items, _Basis, _Citations).

test(the_status_table_holds_each_final_atom) :-
    gdpr_art36_3_consultation_request_status_values(StatusValues),
    StatusValues == [consultation_request_complete, consultation_request_incomplete, not_governed_by_article_36_3].
test(point_e_positive_is_complete) :-
    status_of(complete_sole_controller, consultation_request_complete).
test(point_e_near_miss_is_incomplete) :-
    status_of(incomplete_missing_assessment, consultation_request_incomplete).
test(point_a_positive_is_complete) :-
    status_of(complete_joint_controllers, consultation_request_complete).
test(point_a_near_miss_lists_the_responsibilities) :-
    items_of(joint_controllers_responsibilities_missing, [respective_responsibilities]).
test(point_d_near_miss_lists_the_contact_details) :-
    items_of(officer_contact_details_missing, [data_protection_officer_contact_details]).
test(point_d_without_designation_is_complete) :-
    status_of(officer_not_designated, consultation_request_complete).
test(point_d_unknown_designation_is_asked) :-
    status_of(officer_designation_unknown, indeterminate([data_protection_officer_designated])).
test(point_f_near_miss_lists_the_other_information) :-
    items_of(other_information_missing, [other_requested_information]).
test(another_footing_is_not_governed) :-
    status_of(member_state_law_consultation, not_governed_by_article_36_3).
test(an_unstated_footing_is_asked) :-
    status_of(consultation_footing_unstated, indeterminate([consultation_under_article_36_1])).
test(attested_sole_controller_is_complete) :-
    status_of(roles_attested_sole_controller, consultation_request_complete).
test(unattested_roles_are_referred) :-
    status_of(roles_unattested_referral, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])])).
test(settled_responsibilities_give_a_whole_list) :-
    items_of(missing_item_with_settled_responsibilities, [purposes_and_means]).
test(open_responsibilities_are_asked) :-
    items_of(missing_item_with_open_responsibilities, indeterminate([respective_responsibilities_provided])).
test(open_responsibilities_still_make_the_status_incomplete) :-
    status_of(missing_item_with_open_responsibilities, consultation_request_incomplete).
test(an_attested_crisp_key_is_an_input_problem) :-
    status_of(malformed_attested_crisp_key, input_problems([wrong_type(purposes_and_means_provided)])).

test(point_e_positive_is_not_incomplete, fail) :-
    status_of(complete_sole_controller, consultation_request_incomplete).
test(point_e_near_miss_is_not_complete, fail) :-
    status_of(incomplete_missing_assessment, consultation_request_complete).
test(point_a_near_miss_is_not_complete, fail) :-
    status_of(joint_controllers_responsibilities_missing, consultation_request_complete).
test(point_d_near_miss_is_not_complete, fail) :-
    status_of(officer_contact_details_missing, consultation_request_complete).
test(point_d_unknown_designation_is_not_complete, fail) :-
    status_of(officer_designation_unknown, consultation_request_complete).
test(point_f_near_miss_is_not_complete, fail) :-
    status_of(other_information_missing, consultation_request_complete).
test(another_footing_is_not_complete, fail) :-
    status_of(member_state_law_consultation, consultation_request_complete).
test(the_article_36_1_footing_is_not_ungoverned, fail) :-
    status_of(complete_sole_controller, not_governed_by_article_36_3).
test(an_unstated_footing_is_not_complete, fail) :-
    status_of(consultation_footing_unstated, consultation_request_complete).
test(unattested_roles_are_not_complete, fail) :-
    status_of(roles_unattested_referral, consultation_request_complete).
test(attested_sole_controller_is_not_referred, fail) :-
    status_of(roles_attested_sole_controller, needs_legal_review(_, _)).
test(open_responsibilities_give_no_list, fail) :-
    items_of(missing_item_with_open_responsibilities, [purposes_and_means]).
test(an_attested_crisp_key_gets_no_verdict, fail) :-
    status_of(malformed_attested_crisp_key, consultation_request_complete).
test(a_well_formed_profile_is_not_an_input_problem, fail) :-
    status_of(complete_sole_controller, input_problems(_)).

cp_test_names([the_status_table_holds_each_final_atom, point_e_positive_is_complete, point_e_near_miss_is_incomplete, point_a_positive_is_complete, point_a_near_miss_lists_the_responsibilities, point_d_near_miss_lists_the_contact_details, point_d_without_designation_is_complete, point_d_unknown_designation_is_asked, point_f_near_miss_lists_the_other_information, another_footing_is_not_governed, an_unstated_footing_is_asked, attested_sole_controller_is_complete, unattested_roles_are_referred, settled_responsibilities_give_a_whole_list, open_responsibilities_are_asked, open_responsibilities_still_make_the_status_incomplete, an_attested_crisp_key_is_an_input_problem]).
cp_test_fail_names([point_e_positive_is_not_incomplete, point_e_near_miss_is_not_complete, point_a_near_miss_is_not_complete, point_d_near_miss_is_not_complete, point_d_unknown_designation_is_not_complete, point_f_near_miss_is_not_complete, another_footing_is_not_complete, the_article_36_1_footing_is_not_ungoverned, an_unstated_footing_is_not_complete, unattested_roles_are_not_complete, attested_sole_controller_is_not_referred, open_responsibilities_give_no_list, an_attested_crisp_key_gets_no_verdict, a_well_formed_profile_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
