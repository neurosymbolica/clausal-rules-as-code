% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_dora_rts_physical_hr_identity_and_access, [physical_hr_identity_and_access_duties_complete/3, physical_hr_identity_and_access_duties_outstanding/3, dora_rts_physical_hr_identity_and_access_status/2, dora_rts_physical_hr_identity_and_access_status_values/1]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_queries, [dora_rts_physical_hr_identity_and_access_what_if/4]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_fixtures, [dora_rts_physical_hr_identity_and_access_profile_for/2]).

test(the_status_table_holds_the_final_atoms) :-
    dora_rts_physical_hr_identity_and_access_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues).
test(gate_true_is_simplified_framework_entity) :-
    dora_rts_physical_hr_identity_and_access_profile_for(article_16_1_entity, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, simplified_framework_entity).
test(gate_false_near_miss_is_complete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, complete).
test(gate_absent_is_asked) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_absent, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(a_failing_duty_is_incomplete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, incomplete).
test(the_duty_performed_near_miss_is_complete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, access_control_policy_contains_segregation_of_duties, true, complete).
test(an_absent_duty_is_asked) :-
    dora_rts_physical_hr_identity_and_access_profile_for(first_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible])).
test(the_duty_given_near_miss_is_complete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(first_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, dedicated_accounts_used_for_administrative_tasks_where_possible, true, complete).
test(a_failing_duty_beats_an_absent_one) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, incomplete).
test(without_the_failing_duty_the_absent_one_is_asked) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, physical_security_policy_contains_clear_desk_policy_for_papers, true, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible])).
test(an_unsure_duty_is_referred) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), _)).
test(the_judged_near_miss_is_complete) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, access_control_policy_contains_segregation_of_duties, true, complete).
test(the_closing_duties_are_outstanding) :-
    dora_rts_physical_hr_identity_and_access_profile_for(closing_subparagraph_duties_outstanding, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding([retention_period_for_point_e_i, dedicated_administrative_accounts, automated_privileged_access_management]), [cite(eu_reg_2024_1774_art_21)]).
test(all_performed_near_miss_is_none_outstanding) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, none_outstanding, _).
test(the_outstanding_query_waits_for_the_absent_key) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible]), []).
test(a_duplicate_and_a_wrong_type_are_input_problems) :-
    dora_rts_physical_hr_identity_and_access_profile_for(duplicate_and_wrong_type, Profile),
    physical_hr_identity_and_access_duties_complete(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), wrong_type(access_control_policy_contains_segregation_of_duties)]), []).
test(an_unknown_key_is_an_input_problem) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unknown_key, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, input_problems([unknown_key(colour)])).
test(without_the_unknown_key_the_first_duty_is_asked) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_only_false, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate([physical_and_environmental_security_policy_specified_documented_and_implemented])).

test(gate_false_near_miss_is_not_simplified_framework_entity, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, simplified_framework_entity).
test(gate_given_near_miss_is_not_asked, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, indeterminate(_)).
test(the_duty_performed_near_miss_is_not_incomplete, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, access_control_policy_contains_segregation_of_duties, true, incomplete).
test(the_duty_given_near_miss_is_not_asked, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(first_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, dedicated_accounts_used_for_administrative_tasks_where_possible, true, indeterminate(_)).
test(without_the_failing_duty_it_is_not_incomplete, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, physical_security_policy_contains_clear_desk_policy_for_papers, true, incomplete).
test(the_judged_near_miss_is_not_referred, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    dora_rts_physical_hr_identity_and_access_what_if(Profile, access_control_policy_contains_segregation_of_duties, true, needs_legal_review(_, _)).
test(all_performed_near_miss_has_no_outstanding_list, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding(_), _).
test(the_closing_duties_profile_is_not_asked, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(closing_subparagraph_duties_outstanding, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, indeterminate(_), _).
test(the_outstanding_query_does_not_list_early, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding(_), _).
test(a_well_formed_near_miss_has_no_input_problems, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, input_problems(_)).
test(without_the_unknown_key_there_is_no_input_problem, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_only_false, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, input_problems(_)).

cp_test_names([the_status_table_holds_the_final_atoms, gate_true_is_simplified_framework_entity, gate_false_near_miss_is_complete, gate_absent_is_asked, a_failing_duty_is_incomplete, the_duty_performed_near_miss_is_complete, an_absent_duty_is_asked, the_duty_given_near_miss_is_complete, a_failing_duty_beats_an_absent_one, without_the_failing_duty_the_absent_one_is_asked, an_unsure_duty_is_referred, the_judged_near_miss_is_complete, the_closing_duties_are_outstanding, all_performed_near_miss_is_none_outstanding, the_outstanding_query_waits_for_the_absent_key, a_duplicate_and_a_wrong_type_are_input_problems, an_unknown_key_is_an_input_problem, without_the_unknown_key_the_first_duty_is_asked]).
cp_test_fail_names([gate_false_near_miss_is_not_simplified_framework_entity, gate_given_near_miss_is_not_asked, the_duty_performed_near_miss_is_not_incomplete, the_duty_given_near_miss_is_not_asked, without_the_failing_duty_it_is_not_incomplete, the_judged_near_miss_is_not_referred, all_performed_near_miss_has_no_outstanding_list, the_closing_duties_profile_is_not_asked, the_outstanding_query_does_not_list_early, a_well_formed_near_miss_has_no_input_problems, without_the_unknown_key_there_is_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
