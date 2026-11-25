% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [dora_information_sharing_arrangements_status_values/1, information_sharing_within_article_45/3, membership_notification_duty/3]).
:- use_module(m__eu_dora_information_sharing_arrangements_fixtures, [dora_information_sharing_arrangements_profile_for/2]).

sharing(Subject, Result) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    information_sharing_within_article_45(Profile, Result, _Citations).

duty(Subject, Result) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    membership_notification_duty(Profile, Result, _Citations).

test(the_status_table_holds_both_final_atoms) :-
    dora_information_sharing_arrangements_status_values(StatusValues),
    clausal_msort(StatusValues, [sharing_outside_article_45, sharing_within_article_45]).
test(a4_positive_all_conditions_met_is_within) :-
    sharing(all_conditions_met, sharing_within_article_45).
test(a1_positive_paragraph_2_false_is_outside) :-
    sharing(paragraph_2_false, sharing_outside_article_45).
test(a1_positive_community_false_decides_alone) :-
    sharing(community_false_with_absent_others, sharing_outside_article_45).
test(a2_positive_community_absent_is_indeterminate) :-
    sharing(community_absent, indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities])).
test(a2_positive_absent_before_unsure_is_not_referred) :-
    sharing(first_absent_before_unsure, indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities])).
test(a3_positive_point_c_unsure_is_referred) :-
    sharing(point_c_unsure_referral, needs_legal_review(open_textured(arrangement_protects_sensitive_information_and_has_rules_of_conduct, cite(eu_reg_2022_2554_art_45_1_c)), _Context)).
test(a0_positive_wrong_type_is_an_input_problem) :-
    sharing(wrong_type_value, input_problems([wrong_type(membership_event)])).
test(a0_near_miss_well_formed_value_is_answered) :-
    information_sharing_within_article_45([attribute(membership_event, membership_validated)], indeterminate([information_is_cyber_threat_information_and_intelligence]), []).
test(b0_positive_duplicate_is_an_input_problem) :-
    duty(duplicate_and_unknown_keys, input_problems([duplicate_key(membership_event), unknown_key(entity_size)])).
test(b4_positive_validation_notifies_participation) :-
    duty(all_conditions_met, notify_participation_upon_validation).
test(b4_positive_cessation_notifies_cessation) :-
    duty(cessation_effective_true, notify_cessation_once_effective).
test(b1_positive_arrangement_false_gives_no_duty) :-
    duty(cessation_arrangement_false, no_notification_duty).
test(b1_positive_no_event_gives_no_duty) :-
    duty(no_event_with_unsure_arrangement, no_notification_duty).
test(b2_positive_event_absent_is_named) :-
    duty(event_absent_arrangement_unsure, indeterminate([membership_event])).
test(b2_positive_arrangement_absent_is_named) :-
    duty(arrangement_absent, indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1])).
test(b3_positive_unsure_arrangement_is_referred) :-
    duty(arrangement_unsure_referral, needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3)), _Context)).

test(a4_near_miss_paragraph_2_false_is_not_within, fail) :-
    sharing(paragraph_2_false, sharing_within_article_45).
test(a1_near_miss_all_conditions_met_is_not_outside, fail) :-
    sharing(all_conditions_met, sharing_outside_article_45).
test(a1_near_miss_community_absent_is_not_outside, fail) :-
    sharing(community_absent, sharing_outside_article_45).
test(a2_near_miss_community_false_is_not_indeterminate, fail) :-
    sharing(community_false_with_absent_others, indeterminate(_MissingKeys)).
test(a2_near_miss_absent_before_unsure_is_not_referred, fail) :-
    sharing(first_absent_before_unsure, needs_legal_review(_Reason, _Context)).
test(a3_near_miss_point_c_true_is_not_referred, fail) :-
    sharing(all_conditions_met, needs_legal_review(_Reason, _Context)).
test(a0_near_miss_well_formed_value_is_no_input_problem, fail) :-
    information_sharing_within_article_45([attribute(membership_event, membership_validated)], input_problems(_Problems), _Citations).
test(b0_near_miss_single_key_is_no_input_problem, fail) :-
    duty(arrangement_absent, input_problems(_Problems)).
test(b4_near_miss_cessation_does_not_notify_participation, fail) :-
    duty(cessation_effective_true, notify_participation_upon_validation).
test(b4_near_miss_arrangement_false_does_not_notify_cessation, fail) :-
    duty(cessation_arrangement_false, notify_cessation_once_effective).
test(b1_near_miss_arrangement_true_is_not_no_duty, fail) :-
    duty(cessation_effective_true, no_notification_duty).
test(b1_near_miss_validated_event_is_not_no_duty, fail) :-
    duty(arrangement_unsure_referral, no_notification_duty).
test(b2_near_miss_event_given_is_not_indeterminate, fail) :-
    duty(arrangement_unsure_referral, indeterminate(_MissingKeys)).
test(b2_near_miss_arrangement_given_is_not_indeterminate, fail) :-
    duty(all_conditions_met, indeterminate(_MissingKeys)).
test(b3_near_miss_no_event_is_not_referred, fail) :-
    duty(no_event_with_unsure_arrangement, needs_legal_review(_Reason, _Context)).

cp_test_names([the_status_table_holds_both_final_atoms, a4_positive_all_conditions_met_is_within, a1_positive_paragraph_2_false_is_outside, a1_positive_community_false_decides_alone, a2_positive_community_absent_is_indeterminate, a2_positive_absent_before_unsure_is_not_referred, a3_positive_point_c_unsure_is_referred, a0_positive_wrong_type_is_an_input_problem, a0_near_miss_well_formed_value_is_answered, b0_positive_duplicate_is_an_input_problem, b4_positive_validation_notifies_participation, b4_positive_cessation_notifies_cessation, b1_positive_arrangement_false_gives_no_duty, b1_positive_no_event_gives_no_duty, b2_positive_event_absent_is_named, b2_positive_arrangement_absent_is_named, b3_positive_unsure_arrangement_is_referred]).
cp_test_fail_names([a4_near_miss_paragraph_2_false_is_not_within, a1_near_miss_all_conditions_met_is_not_outside, a1_near_miss_community_absent_is_not_outside, a2_near_miss_community_false_is_not_indeterminate, a2_near_miss_absent_before_unsure_is_not_referred, a3_near_miss_point_c_true_is_not_referred, a0_near_miss_well_formed_value_is_no_input_problem, b0_near_miss_single_key_is_no_input_problem, b4_near_miss_cessation_does_not_notify_participation, b4_near_miss_arrangement_false_does_not_notify_cessation, b1_near_miss_arrangement_true_is_not_no_duty, b1_near_miss_validated_event_is_not_no_duty, b2_near_miss_event_given_is_not_indeterminate, b2_near_miss_arrangement_given_is_not_indeterminate, b3_near_miss_no_event_is_not_referred]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
