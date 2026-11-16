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
    consultation_request_status(Profile, Result, _, _).

items_of(Subject, Items) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    missing_consultation_request_items(Profile, Items, _, _).

basis_of(Subject, Basis) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    consultation_request_status(Profile, _, Basis, _).

roles_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])])).

test(the_status_table_holds_the_three_final_atoms) :-
    gdpr_art36_3_consultation_request_status_values(StatusValues),
    StatusValues == [consultation_request_complete, consultation_request_incomplete, not_governed_by_article_36_3].
test(complete_route_positive) :-
    status_of(controller_alone_complete, consultation_request_complete).
test(complete_route_near_miss_is_incomplete) :-
    status_of(impact_assessment_not_provided, consultation_request_incomplete).
test(not_governed_route_positive) :-
    status_of(consultation_under_member_state_law, not_governed_by_article_36_3).
test(footing_unstated_route_positive) :-
    status_of(consultation_footing_not_stated, indeterminate([consultation_under_article_36_1])).
test(referral_route_positive) :-
    roles_referral(Referral),
    status_of(roles_not_attested_responsibilities_not_given, Referral),
    items_of(roles_not_attested_responsibilities_not_given, Referral).
test(referral_route_near_miss_is_complete) :-
    status_of(roles_attested_controller_alone, consultation_request_complete).
test(point_a_missing_positive) :-
    status_of(processor_involved_responsibilities_missing, consultation_request_incomplete),
    items_of(processor_involved_responsibilities_missing, [respective_responsibilities]).
test(point_a_given_near_miss_is_complete) :-
    status_of(processor_involved_responsibilities_given, consultation_request_complete),
    items_of(processor_involved_responsibilities_given, []).
test(basis_copied_when_responsibilities_not_given) :-
    basis_of(processor_involved_responsibilities_missing, [outside_fact(joint_controllers_or_processors_involved, attested(true, attestation(host_user, host_time, stated_by_caller, none)))]).
test(basis_empty_when_responsibilities_given) :-
    basis_of(processor_involved_responsibilities_given, []).
test(point_d_missing_positive) :-
    items_of(officer_designated_contact_missing, [data_protection_officer_contact_details]).
test(point_d_given_near_miss) :-
    status_of(officer_designated_contact_given, consultation_request_complete).
test(point_d_contact_settles_without_designation) :-
    status_of(contact_given_designation_unstated, consultation_request_complete).
test(point_f_unstated_positive) :-
    status_of(authority_request_answer_unstated, indeterminate([requested_other_information_provided])).
test(point_f_answered_near_miss) :-
    status_of(authority_request_answered, consultation_request_complete).
test(point_f_not_answered_near_miss) :-
    items_of(authority_request_not_answered, [other_requested_information]).
test(missing_item_decides_status_positive) :-
    status_of(missing_item_and_officer_unknown, consultation_request_incomplete),
    items_of(missing_item_and_officer_unknown, indeterminate([data_protection_officer_designated])).
test(missing_item_near_miss_lists_the_items) :-
    items_of(missing_item_and_officer_not_designated, [purposes_and_means]).
test(deciding_key_positive) :-
    status_of(deciding_key_before_responsibilities, indeterminate([measures_and_safeguards_provided])).
test(deciding_key_near_miss_names_the_waiting_key) :-
    status_of(responsibilities_unstated_roles_unstated, indeterminate([respective_responsibilities_provided])).
test(input_problem_route_positive) :-
    status_of(attested_value_on_crisp_key, input_problems([wrong_type(purposes_and_means_provided)])).
test(input_problem_route_near_miss_is_complete) :-
    status_of(controller_alone_complete, consultation_request_complete).
test(bare_roles_value_is_an_input_problem) :-
    status_of(bare_roles_value, input_problems([wrong_type(joint_controllers_or_processors_involved)])).
test(duplicate_keys_are_an_input_problem) :-
    items_of(duplicate_and_unknown_keys, input_problems([duplicate_key(impact_assessment_provided), unknown_key(controller_name)])).

test(complete_route_near_miss_is_not_complete, fail) :-
    status_of(impact_assessment_not_provided, consultation_request_complete).
test(complete_route_positive_is_not_incomplete, fail) :-
    status_of(controller_alone_complete, consultation_request_incomplete).
test(not_governed_route_near_miss_is_not_not_governed, fail) :-
    status_of(controller_alone_complete, not_governed_by_article_36_3).
test(not_governed_route_positive_is_not_complete, fail) :-
    status_of(consultation_under_member_state_law, consultation_request_complete).
test(footing_unstated_route_near_miss, fail) :-
    status_of(controller_alone_complete, indeterminate([consultation_under_article_36_1])).
test(referral_route_near_miss_is_not_referred, fail) :-
    roles_referral(Referral),
    status_of(roles_attested_controller_alone, Referral).
test(point_a_given_near_miss_is_not_incomplete, fail) :-
    status_of(processor_involved_responsibilities_given, consultation_request_incomplete).
test(basis_not_copied_when_responsibilities_given, fail) :-
    basis_of(processor_involved_responsibilities_given, [_OutsideFact]).
test(point_d_given_near_miss_is_not_incomplete, fail) :-
    status_of(officer_designated_contact_given, consultation_request_incomplete).
test(point_d_contact_settles_names_no_key, fail) :-
    status_of(contact_given_designation_unstated, indeterminate([data_protection_officer_designated])).
test(point_f_answered_is_not_incomplete, fail) :-
    status_of(authority_request_answered, consultation_request_incomplete).
test(missing_item_near_miss_names_no_key, fail) :-
    items_of(missing_item_and_officer_not_designated, indeterminate(_)).
test(deciding_key_positive_is_not_the_waiting_key, fail) :-
    status_of(deciding_key_before_responsibilities, indeterminate([respective_responsibilities_provided])).
test(input_problem_route_gives_no_verdict, fail) :-
    status_of(attested_value_on_crisp_key, consultation_request_complete).
test(duplicate_keys_give_no_item_list, fail) :-
    items_of(duplicate_and_unknown_keys, []).

cp_test_names([the_status_table_holds_the_three_final_atoms, complete_route_positive, complete_route_near_miss_is_incomplete, not_governed_route_positive, footing_unstated_route_positive, referral_route_positive, referral_route_near_miss_is_complete, point_a_missing_positive, point_a_given_near_miss_is_complete, basis_copied_when_responsibilities_not_given, basis_empty_when_responsibilities_given, point_d_missing_positive, point_d_given_near_miss, point_d_contact_settles_without_designation, point_f_unstated_positive, point_f_answered_near_miss, point_f_not_answered_near_miss, missing_item_decides_status_positive, missing_item_near_miss_lists_the_items, deciding_key_positive, deciding_key_near_miss_names_the_waiting_key, input_problem_route_positive, input_problem_route_near_miss_is_complete, bare_roles_value_is_an_input_problem, duplicate_keys_are_an_input_problem]).
cp_test_fail_names([complete_route_near_miss_is_not_complete, complete_route_positive_is_not_incomplete, not_governed_route_near_miss_is_not_not_governed, not_governed_route_positive_is_not_complete, footing_unstated_route_near_miss, referral_route_near_miss_is_not_referred, point_a_given_near_miss_is_not_incomplete, basis_not_copied_when_responsibilities_given, point_d_given_near_miss_is_not_incomplete, point_d_contact_settles_names_no_key, point_f_answered_is_not_incomplete, missing_item_near_miss_names_no_key, deciding_key_positive_is_not_the_waiting_key, input_problem_route_gives_no_verdict, duplicate_keys_give_no_item_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
