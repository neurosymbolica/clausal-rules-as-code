% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [post_market_monitoring_status/2, post_market_monitoring_status_values/1]).
:- use_module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_profile_for/2]).

subject_status(Subject, Status) :-
    post_market_monitoring_profile_for(Subject, Request),
    post_market_monitoring_status(Request, Status).

test(the_near_miss_atoms_are_verdict_atoms) :-
    post_market_monitoring_status_values(StatusValues),
    member(not_applicable_on_date, StatusValues),
    member(not_a_provider, StatusValues),
    member(not_a_high_risk_ai_system, StatusValues),
    member(compliance_required_by_31_december_2030, StatusValues),
    member(existing_system_without_significant_changes_not_covered, StatusValues),
    member(compliance_required_by_2_august_2030, StatusValues),
    member(duty_applies, StatusValues),
    member(integration_not_available, StatusValues),
    member(integration_available, StatusValues).
test(gate_positive_the_day_before) :-
    subject_status(before_the_annex_iii_date, not_applicable_on_date).
test(gate_near_miss_the_day_itself) :-
    subject_status(annex_iii_system_on_its_first_day, duty_applies).
test(provider_positive) :-
    subject_status(actor_not_a_provider, not_a_provider).
test(provider_near_miss) :-
    subject_status(provider_of_an_annex_iii_system, duty_applies).
test(high_risk_positive) :-
    subject_status(system_not_high_risk, not_a_high_risk_ai_system).
test(annex_i_positive_the_day_before) :-
    subject_status(annex_i_only_system_the_day_before, not_applicable_on_date).
test(annex_i_near_miss_the_day_itself) :-
    subject_status(annex_i_only_system_on_its_first_day, duty_applies).
test(annex_x_positive_the_day_before) :-
    subject_status(annex_x_component_the_day_before_the_deadline, compliance_required_by_31_december_2030).
test(annex_x_near_miss_the_day_itself) :-
    subject_status(annex_x_component_on_the_deadline, duty_applies).
test(not_covered_positive) :-
    subject_status(existing_system_without_changes, existing_system_without_significant_changes_not_covered).
test(not_covered_near_miss_changed) :-
    subject_status(existing_system_with_significant_changes, duty_applies).
test(public_authorities_positive_the_day_before) :-
    subject_status(existing_public_authority_system_the_day_before_the_deadline, compliance_required_by_2_august_2030).
test(public_authorities_near_miss_the_day_itself) :-
    subject_status(existing_public_authority_system_on_the_deadline, duty_applies).
test(a_changed_public_authority_system_has_the_duty) :-
    subject_status(existing_changed_public_authority_system, duty_applies).
test(integration_positive) :-
    subject_status(integration_through_annex_i_legislation, integration_available).
test(integration_near_miss_equivalence) :-
    subject_status(integration_without_equivalent_protection, integration_not_available).
test(financial_institution_positive) :-
    subject_status(integration_for_financial_institution, integration_available).
test(financial_institution_near_miss_without_plan) :-
    subject_status(integration_for_financial_institution_without_plan, integration_not_available).
test(covered_annex_iii_positive) :-
    subject_status(integration_for_covered_annex_iii_system, integration_available).
test(legislation_route_near_miss) :-
    subject_status(integration_without_legislation_route, integration_not_available).
test(integration_provider_positive) :-
    subject_status(integration_actor_not_a_provider, not_a_provider).
test(integration_high_risk_positive) :-
    subject_status(integration_system_not_high_risk, not_a_high_risk_ai_system).
test(missing_key_positive) :-
    subject_status(missing_provider, indeterminate([provider_of_the_system])).
test(referral_positive) :-
    subject_status(integration_referral_on_equivalence, needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection - unsure])])).
test(impossible_date_positive) :-
    subject_status(input_impossible_date, input_problems([wrong_type(assessment_date)])).
test(real_date_near_miss) :-
    subject_status(input_last_day_of_february, not_applicable_on_date).

test(gate_near_miss_is_not_inapplicable, fail) :-
    subject_status(annex_iii_system_on_its_first_day, not_applicable_on_date).
test(provider_near_miss_is_not_not_a_provider, fail) :-
    subject_status(provider_of_an_annex_iii_system, not_a_provider).
test(high_risk_near_miss_is_not_not_high_risk, fail) :-
    subject_status(provider_of_an_annex_iii_system, not_a_high_risk_ai_system).
test(annex_i_near_miss_is_not_inapplicable, fail) :-
    subject_status(annex_i_only_system_on_its_first_day, not_applicable_on_date).
test(annex_x_near_miss_is_not_transitional, fail) :-
    subject_status(annex_x_component_on_the_deadline, compliance_required_by_31_december_2030).
test(annex_x_component_is_not_reached_by_in_any_case, fail) :-
    subject_status(annex_x_component_for_public_authorities, compliance_required_by_2_august_2030).
test(not_covered_near_miss_is_not_not_covered, fail) :-
    subject_status(existing_system_with_significant_changes, existing_system_without_significant_changes_not_covered).
test(public_authorities_near_miss_is_not_transitional, fail) :-
    subject_status(existing_public_authority_system_on_the_deadline, compliance_required_by_2_august_2030).
test(a_changed_public_authority_system_is_not_transitional, fail) :-
    subject_status(existing_changed_public_authority_system, compliance_required_by_2_august_2030).
test(integration_near_miss_equivalence_is_not_available, fail) :-
    subject_status(integration_without_equivalent_protection, integration_available).
test(financial_institution_near_miss_is_not_available, fail) :-
    subject_status(integration_for_financial_institution_without_plan, integration_available).
test(legislation_route_near_miss_is_not_available, fail) :-
    subject_status(integration_without_legislation_route, integration_available).
test(integration_provider_is_not_available, fail) :-
    subject_status(integration_actor_not_a_provider, integration_available).
test(integration_high_risk_is_not_available, fail) :-
    subject_status(integration_system_not_high_risk, integration_available).
test(missing_key_near_miss_is_not_final, fail) :-
    subject_status(missing_provider, duty_applies).
test(referral_is_not_a_final_answer, fail) :-
    subject_status(integration_referral_on_equivalence, integration_available).
test(real_date_near_miss_is_not_an_input_problem, fail) :-
    subject_status(input_last_day_of_february, input_problems(_)).

cp_test_names([the_near_miss_atoms_are_verdict_atoms, gate_positive_the_day_before, gate_near_miss_the_day_itself, provider_positive, provider_near_miss, high_risk_positive, annex_i_positive_the_day_before, annex_i_near_miss_the_day_itself, annex_x_positive_the_day_before, annex_x_near_miss_the_day_itself, not_covered_positive, not_covered_near_miss_changed, public_authorities_positive_the_day_before, public_authorities_near_miss_the_day_itself, a_changed_public_authority_system_has_the_duty, integration_positive, integration_near_miss_equivalence, financial_institution_positive, financial_institution_near_miss_without_plan, covered_annex_iii_positive, legislation_route_near_miss, integration_provider_positive, integration_high_risk_positive, missing_key_positive, referral_positive, impossible_date_positive, real_date_near_miss]).
cp_test_fail_names([gate_near_miss_is_not_inapplicable, provider_near_miss_is_not_not_a_provider, high_risk_near_miss_is_not_not_high_risk, annex_i_near_miss_is_not_inapplicable, annex_x_near_miss_is_not_transitional, annex_x_component_is_not_reached_by_in_any_case, not_covered_near_miss_is_not_not_covered, public_authorities_near_miss_is_not_transitional, a_changed_public_authority_system_is_not_transitional, integration_near_miss_equivalence_is_not_available, financial_institution_near_miss_is_not_available, legislation_route_near_miss_is_not_available, integration_provider_is_not_available, integration_high_risk_is_not_available, missing_key_near_miss_is_not_final, referral_is_not_a_final_answer, real_date_near_miss_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
