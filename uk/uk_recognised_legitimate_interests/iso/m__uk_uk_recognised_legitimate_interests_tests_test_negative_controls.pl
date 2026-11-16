% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_uk_recognised_legitimate_interests, [uk_recognised_legitimate_interests_status/2, uk_recognised_legitimate_interests_status_values/1, uk_legitimate_interests/3, uk_legitimate_interest_basis/3, eu_legitimate_interests/3, compare_uk_eu_legitimate_interest_basis/5, uk_right_to_object/3]).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_fixtures, [uk_recognised_legitimate_interests_profile_for/2]).

status_of(Subject, Status) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    uk_recognised_legitimate_interests_status(Profile, Status).

objection_of(Subject, Result) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    uk_right_to_object(Profile, Result, _Citations).

test(applies_is_a_real_verdict_atom) :-
    uk_recognised_legitimate_interests_status_values(StatusValues),
    member(recognised_legitimate_interest_applies, StatusValues).
test(does_not_apply_is_a_real_verdict_atom) :-
    uk_recognised_legitimate_interests_status_values(StatusValues),
    member(recognised_legitimate_interest_does_not_apply, StatusValues).
test(bar_positive) :-
    status_of(public_authority_bar, recognised_legitimate_interest_does_not_apply).
test(bar_near_miss_applies) :-
    status_of(security_condition_met, recognised_legitimate_interest_applies).
test(bar_unsure_positive_is_a_referral) :-
    status_of(authority_unsure_condition_met, needs_legal_review(_Reason, _Context)).
test(bar_absent_positive_is_indeterminate) :-
    status_of(authority_absent_condition_met, indeterminate([processing_by_a_public_authority_in_the_performance_of_its_tasks])).
test(disclosure_positive) :-
    status_of(disclosure_condition_met, recognised_legitimate_interest_applies).
test(disclosure_near_miss_does_not_apply) :-
    status_of(disclosure_request_silent, recognised_legitimate_interest_does_not_apply).
test(emergency_positive) :-
    status_of(emergency_condition_met, recognised_legitimate_interest_applies).
test(emergency_near_miss_names_the_response_key) :-
    status_of(emergency_response_missing, indeterminate([processing_necessary_for_responding_to_the_emergency])).
test(crime_positive) :-
    status_of(crime_condition_met, recognised_legitimate_interest_applies).
test(all_fail_does_not_apply_without_the_bar_key) :-
    status_of(all_conditions_fail, recognised_legitimate_interest_does_not_apply).
test(safeguarding_adult_at_risk_positive) :-
    status_of(safeguarding_adult_at_risk, recognised_legitimate_interest_applies).
test(safeguarding_adult_not_at_risk_does_not_apply) :-
    status_of(safeguarding_adult_not_at_risk, recognised_legitimate_interest_does_not_apply).
test(safeguarding_adult_unsure_risk_is_a_referral) :-
    status_of(safeguarding_adult_unsure_risk, needs_legal_review(open_textured(controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk, cite(uk_gdpr_annex_1_para_8)), _Context)).
test(safeguarding_child_positive) :-
    status_of(safeguarding_child, recognised_legitimate_interest_applies).
test(uk_interests_positive) :-
    uk_recognised_legitimate_interests_profile_for(interests_apply, Profile),
    uk_legitimate_interests(Profile, legitimate_interests_applies, _Citations).
test(uk_interests_near_miss_does_not_apply) :-
    uk_recognised_legitimate_interests_profile_for(interests_overridden, Profile),
    uk_legitimate_interests(Profile, legitimate_interests_does_not_apply, _Citations).
test(eu_interests_positive) :-
    uk_recognised_legitimate_interests_profile_for(interests_apply, Profile),
    eu_legitimate_interests(Profile, legitimate_interests_applies, _Citations).
test(basis_positive) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    uk_legitimate_interest_basis(Profile, legitimate_interest_basis_available, _Citations).
test(basis_near_miss_not_available) :-
    uk_recognised_legitimate_interests_profile_for(uk_same_as_eu, Profile),
    uk_legitimate_interest_basis(Profile, legitimate_interest_basis_not_available, _Citations).
test(comparison_positive_differs) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, differs, [_|_]).
test(comparison_near_miss_same) :-
    uk_recognised_legitimate_interests_profile_for(uk_same_as_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, same, []).
test(objection_must_stop_positive) :-
    objection_of(objection_must_stop, controller_must_no_longer_process).
test(objection_legal_claims_near_miss) :-
    objection_of(objection_legal_claims, controller_may_continue_processing).
test(objection_not_engaged_positive) :-
    objection_of(objection_not_engaged, objection_right_not_engaged).
test(objection_engaging_basis_without_objection_names_it) :-
    uk_right_to_object([attribute(basis_relied_on, legitimate_interests)], indeterminate([objection_on_grounds_relating_to_particular_situation]), []).
test(objection_missing_positive) :-
    objection_of(objection_exceptions_missing, indeterminate([controller_demonstrates_compelling_legitimate_grounds_that_override])).
test(objection_unsure_near_miss_is_a_referral) :-
    objection_of(objection_unsure, needs_legal_review(_Reason, _Context)).
test(input_problem_positive) :-
    uk_recognised_legitimate_interests_profile_for(crisp_key_wrong_type, Profile),
    uk_recognised_legitimate_interests_input_problems(Profile, [wrong_type(individual_aged_under_18)]).
test(input_control_has_no_problem) :-
    uk_recognised_legitimate_interests_profile_for(crisp_key_control, Profile),
    uk_recognised_legitimate_interests_input_problems(Profile, []).

test(bar_positive_is_not_applies, fail) :-
    status_of(public_authority_bar, recognised_legitimate_interest_applies).
test(bar_near_miss_is_not_does_not_apply, fail) :-
    status_of(security_condition_met, recognised_legitimate_interest_does_not_apply).
test(bar_unsure_is_not_applies, fail) :-
    status_of(authority_unsure_condition_met, recognised_legitimate_interest_applies).
test(bar_absent_is_not_applies, fail) :-
    status_of(authority_absent_condition_met, recognised_legitimate_interest_applies).
test(disclosure_near_miss_is_not_applies, fail) :-
    status_of(disclosure_request_silent, recognised_legitimate_interest_applies).
test(emergency_near_miss_is_not_applies, fail) :-
    status_of(emergency_response_missing, recognised_legitimate_interest_applies).
test(all_fail_is_not_applies, fail) :-
    status_of(all_conditions_fail, recognised_legitimate_interest_applies).
test(safeguarding_adult_not_at_risk_is_not_applies, fail) :-
    status_of(safeguarding_adult_not_at_risk, recognised_legitimate_interest_applies).
test(safeguarding_adult_unsure_risk_is_not_applies, fail) :-
    status_of(safeguarding_adult_unsure_risk, recognised_legitimate_interest_applies).
test(safeguarding_adult_without_risk_key_is_not_applies, fail) :-
    uk_recognised_legitimate_interests_status([attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, false), attribute(processing_necessary_for_safeguarding_an_individual, true), attribute(individual_aged_under_18, false)], recognised_legitimate_interest_applies).
test(uk_interests_near_miss_is_not_applies, fail) :-
    uk_recognised_legitimate_interests_profile_for(interests_overridden, Profile),
    uk_legitimate_interests(Profile, legitimate_interests_applies, _Citations).
test(eu_interests_near_miss_is_not_applies, fail) :-
    uk_recognised_legitimate_interests_profile_for(interests_overridden, Profile),
    eu_legitimate_interests(Profile, legitimate_interests_applies, _Citations).
test(basis_near_miss_is_not_available, fail) :-
    uk_recognised_legitimate_interests_profile_for(uk_same_as_eu, Profile),
    uk_legitimate_interest_basis(Profile, legitimate_interest_basis_available, _Citations).
test(comparison_near_miss_is_not_differs, fail) :-
    uk_recognised_legitimate_interests_profile_for(uk_same_as_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, differs, _ChangedBy).
test(objection_legal_claims_is_not_must_stop, fail) :-
    objection_of(objection_legal_claims, controller_must_no_longer_process).
test(objection_engaging_basis_without_objection_is_not_not_engaged, fail) :-
    uk_right_to_object([attribute(basis_relied_on, legitimate_interests)], objection_right_not_engaged, _Citations).
test(objection_unsure_is_not_must_stop, fail) :-
    objection_of(objection_unsure, controller_must_no_longer_process).
test(input_control_is_not_input_problems, fail) :-
    status_of(crisp_key_control, input_problems(_Problems)).

cp_test_names([applies_is_a_real_verdict_atom, does_not_apply_is_a_real_verdict_atom, bar_positive, bar_near_miss_applies, bar_unsure_positive_is_a_referral, bar_absent_positive_is_indeterminate, disclosure_positive, disclosure_near_miss_does_not_apply, emergency_positive, emergency_near_miss_names_the_response_key, crime_positive, all_fail_does_not_apply_without_the_bar_key, safeguarding_adult_at_risk_positive, safeguarding_adult_not_at_risk_does_not_apply, safeguarding_adult_unsure_risk_is_a_referral, safeguarding_child_positive, uk_interests_positive, uk_interests_near_miss_does_not_apply, eu_interests_positive, basis_positive, basis_near_miss_not_available, comparison_positive_differs, comparison_near_miss_same, objection_must_stop_positive, objection_legal_claims_near_miss, objection_not_engaged_positive, objection_engaging_basis_without_objection_names_it, objection_missing_positive, objection_unsure_near_miss_is_a_referral, input_problem_positive, input_control_has_no_problem]).
cp_test_fail_names([bar_positive_is_not_applies, bar_near_miss_is_not_does_not_apply, bar_unsure_is_not_applies, bar_absent_is_not_applies, disclosure_near_miss_is_not_applies, emergency_near_miss_is_not_applies, all_fail_is_not_applies, safeguarding_adult_not_at_risk_is_not_applies, safeguarding_adult_unsure_risk_is_not_applies, safeguarding_adult_without_risk_key_is_not_applies, uk_interests_near_miss_is_not_applies, eu_interests_near_miss_is_not_applies, basis_near_miss_is_not_available, comparison_near_miss_is_not_differs, objection_legal_claims_is_not_must_stop, objection_engaging_basis_without_objection_is_not_not_engaged, objection_unsure_is_not_must_stop, input_control_is_not_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
