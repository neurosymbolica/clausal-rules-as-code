% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [rts_incident_policy_and_detection_duties_required/3, rts_incident_policy_and_detection_duties_complete/3, rts_incident_policy_and_detection_duties_outstanding/3, dora_rts_incident_policy_and_detection_status/2, dora_rts_incident_policy_and_detection_status_values/1]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_profile_for/2]).

test(the_status_table_names_every_route) :-
    dora_rts_incident_policy_and_detection_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(input_problems, StatusValues).
test(complete_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, complete, _).
test(simplified_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(simplified_beats_failing_duties) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity_with_failures, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, simplified_framework_entity, _).
test(gate_absent_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(gate_not_stated_with_failures, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(incomplete_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(secure_retention_not_performed, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(false_beats_absent_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(failure_beside_unanswered, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(absent_duty_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(retention_not_answered, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]), []).
test(absent_beats_unsure_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(unsure_beside_unanswered, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, indeterminate([criticality_of_affected_services_considered]), []).
test(referral_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_unsure, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(_)]), []).
test(referral_in_outstanding_beside_a_failure) :-
    dora_rts_incident_policy_and_detection_profile_for(unsure_beside_failure, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(_)]) - []].
test(input_problems_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(unknown_key_present, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, input_problems([unknown_key(financial_entity_is_microenterprise)]), []).
test(gate_unsure_is_refused) :-
    dora_rts_incident_policy_and_detection_profile_for(gate_unsure, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(outstanding_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, outstanding([prioritisation_of_alerts]), [cite(eu_reg_2024_1774_art_23_2_c)]).
test(none_outstanding_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(required_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, required([ict_related_incident_policy|_]), _).
test(status_positive) :-
    dora_rts_incident_policy_and_detection_profile_for(two_duties_unsure, Profile),
    dora_rts_incident_policy_and_detection_status(Profile, needs_legal_review).

test(complete_near_miss_one_duty_false, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, complete, _).
test(simplified_near_miss_gate_false, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, simplified_framework_entity, _).
test(simplified_with_failures_is_not_outstanding, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity_with_failures, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, outstanding(_), _).
test(gate_absent_near_miss_gate_stated, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, indeterminate(_), _).
test(gate_absent_is_not_incomplete, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(gate_not_stated_with_failures, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(incomplete_near_miss_every_duty_true, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(false_beats_absent_near_miss_no_failure, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(retention_not_answered, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(absent_duty_near_miss_key_given, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, indeterminate(_), _).
test(absent_beats_unsure_is_not_referred, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(unsure_beside_unanswered, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, needs_legal_review(_, _), _).
test(referral_near_miss_judgement_true, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, needs_legal_review(_, _), _).
test(referral_beside_a_failure_is_not_a_list, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(unsure_beside_failure, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, outstanding(_), _).
test(input_problems_near_miss_clean_profile, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, input_problems(_), _).
test(gate_unsure_is_not_simplified, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(gate_unsure, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, simplified_framework_entity, _).
test(outstanding_near_miss_every_duty_true, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, outstanding(_), _).
test(none_outstanding_near_miss_one_duty_false, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(required_near_miss_gate_true, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, required(_), _).
test(status_near_miss_is_not_complete, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(two_duties_unsure, Profile),
    dora_rts_incident_policy_and_detection_status(Profile, complete).

cp_test_names([the_status_table_names_every_route, complete_positive, simplified_positive, simplified_beats_failing_duties, gate_absent_positive, incomplete_positive, false_beats_absent_positive, absent_duty_positive, absent_beats_unsure_positive, referral_positive, referral_in_outstanding_beside_a_failure, input_problems_positive, gate_unsure_is_refused, outstanding_positive, none_outstanding_positive, required_positive, status_positive]).
cp_test_fail_names([complete_near_miss_one_duty_false, simplified_near_miss_gate_false, simplified_with_failures_is_not_outstanding, gate_absent_near_miss_gate_stated, gate_absent_is_not_incomplete, incomplete_near_miss_every_duty_true, false_beats_absent_near_miss_no_failure, absent_duty_near_miss_key_given, absent_beats_unsure_is_not_referred, referral_near_miss_judgement_true, referral_beside_a_failure_is_not_a_list, input_problems_near_miss_clean_profile, gate_unsure_is_not_simplified, outstanding_near_miss_every_duty_true, none_outstanding_near_miss_one_duty_false, required_near_miss_gate_true, status_near_miss_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
