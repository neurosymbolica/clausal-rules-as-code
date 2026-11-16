% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [prior_consultation_duty_status/2, prior_consultation_duty_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_fixtures, [gdpr_impact_assessment_prior_consultation_profile_for/2]).

fixture_status(Subject, Status) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    prior_consultation_duty_status(Profile, Status).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    prior_consultation_duty_status_values(StatusValues),
    member(required, StatusValues),
    member(not_required, StatusValues).
test(route_no_measures_positive) :-
    fixture_status(residual_high_risk_no_measures, required).
test(route_no_measures_near_miss) :-
    fixture_status(measures_bring_risk_below_high, not_required).
test(route_measures_insufficient_positive) :-
    fixture_status(residual_high_risk_measures_insufficient, required).
test(route_measures_insufficient_near_miss) :-
    fixture_status(no_high_risk_indicated, not_required).
test(route_member_state_positive) :-
    fixture_status(member_state_prior_authorisation, required).
test(route_member_state_near_miss) :-
    fixture_status(member_state_law_does_not_require_authorisation, not_required).
test(route_not_governed_here_positive) :-
    fixture_status(no_assessment_public_interest_unmet, needs_legal_review(not_governed_here(_), _)).
test(route_not_governed_here_near_miss) :-
    fixture_status(no_assessment_member_state_authorisation, required).
test(route_cross_reference_positive) :-
    fixture_status(no_assessment_member_state_fact_absent, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(route_reading_13_positive) :-
    fixture_status(assessment_status_absent_no_way_open, not_required).
test(route_reading_13_near_miss) :-
    fixture_status(assessment_status_absent_way_open, indeterminate([impact_assessment_carried_out])).
test(route_open_textured_positive) :-
    fixture_status(residual_risk_unsure, needs_legal_review(open_textured(measures_reduce_residual_risk_below_high, _), _)).
test(route_open_textured_near_miss) :-
    fixture_status(residual_high_risk_measures_insufficient, required).
test(route_input_problems_positive) :-
    fixture_status(duplicate_and_unknown_keys, input_problems([_|_])).
test(route_input_problems_near_miss) :-
    prior_consultation_duty_status([attribute(impact_assessment_carried_out, true), attribute(mitigating_measures_taken, true)], indeterminate(_)).

test(route_no_measures_positive_is_not_not_required, fail) :-
    fixture_status(residual_high_risk_no_measures, not_required).
test(route_no_measures_near_miss_is_not_required, fail) :-
    fixture_status(measures_bring_risk_below_high, required).
test(route_measures_insufficient_near_miss_is_not_required, fail) :-
    fixture_status(no_high_risk_indicated, required).
test(route_member_state_near_miss_is_not_required, fail) :-
    fixture_status(member_state_law_does_not_require_authorisation, required).
test(route_not_governed_here_is_not_not_required, fail) :-
    fixture_status(no_assessment_public_interest_unmet, not_required).
test(route_not_governed_here_near_miss_does_not_refer, fail) :-
    fixture_status(no_assessment_member_state_authorisation, needs_legal_review(_, _)).
test(route_cross_reference_is_not_indeterminate, fail) :-
    fixture_status(no_assessment_member_state_fact_absent, indeterminate(_)).
test(route_reading_13_near_miss_is_not_not_required, fail) :-
    fixture_status(assessment_status_absent_way_open, not_required).
test(route_open_textured_is_not_required, fail) :-
    fixture_status(residual_risk_unsure, required).
test(route_input_problems_near_miss_has_no_problems, fail) :-
    prior_consultation_duty_status([attribute(impact_assessment_carried_out, true), attribute(mitigating_measures_taken, true)], input_problems(_)).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, route_no_measures_positive, route_no_measures_near_miss, route_measures_insufficient_positive, route_measures_insufficient_near_miss, route_member_state_positive, route_member_state_near_miss, route_not_governed_here_positive, route_not_governed_here_near_miss, route_cross_reference_positive, route_reading_13_positive, route_reading_13_near_miss, route_open_textured_positive, route_open_textured_near_miss, route_input_problems_positive, route_input_problems_near_miss]).
cp_test_fail_names([route_no_measures_positive_is_not_not_required, route_no_measures_near_miss_is_not_required, route_measures_insufficient_near_miss_is_not_required, route_member_state_near_miss_is_not_required, route_not_governed_here_is_not_not_required, route_not_governed_here_near_miss_does_not_refer, route_cross_reference_is_not_indeterminate, route_reading_13_near_miss_is_not_not_required, route_open_textured_is_not_required, route_input_problems_near_miss_has_no_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
