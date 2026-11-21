% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [post_market_monitoring_duty_status/4, post_market_monitoring_integration_status/3, post_market_monitoring_status/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_kernel, [post_market_monitoring_input_problems/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_profile_for/2]).

subject_status(Subject, Status) :-
    post_market_monitoring_profile_for(Subject, Request),
    post_market_monitoring_status(Request, Status).

test(not_applicable_on_date_bound) :-
    subject_status(before_the_annex_iii_date, not_applicable_on_date).
test(not_a_provider_bound) :-
    subject_status(actor_not_a_provider, not_a_provider).
test(not_a_high_risk_ai_system_bound) :-
    subject_status(system_not_high_risk, not_a_high_risk_ai_system).
test(annex_i_only_day_before_bound) :-
    subject_status(annex_i_only_system_the_day_before, not_applicable_on_date).
test(annex_x_component_bound) :-
    subject_status(annex_x_component_the_day_before_the_deadline, compliance_required_by_31_december_2030).
test(existing_system_not_covered_bound) :-
    subject_status(existing_system_without_changes, existing_system_without_significant_changes_not_covered).
test(public_authority_system_bound) :-
    subject_status(existing_public_authority_system_the_day_before_the_deadline, compliance_required_by_2_august_2030).
test(duty_applies_bound) :-
    subject_status(provider_of_an_annex_iii_system, duty_applies).
test(integration_available_bound) :-
    subject_status(integration_through_annex_i_legislation, integration_available).
test(integration_not_available_bound) :-
    subject_status(integration_without_equivalent_protection, integration_not_available).
test(missing_key_bound) :-
    subject_status(missing_provider, indeterminate([provider_of_the_system])).
test(referral_bound) :-
    subject_status(referral_on_significant_changes, needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date - unsure, intended_to_be_used_by_public_authorities - false])])).
test(duty_status_with_every_argument_bound) :-
    post_market_monitoring_profile_for(annex_x_component_the_day_before_the_deadline, duty(Profile, AssessmentDate)),
    post_market_monitoring_duty_status(Profile, AssessmentDate, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1), cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
test(integration_status_with_every_argument_bound) :-
    post_market_monitoring_profile_for(integration_for_financial_institution, integration(Profile)),
    post_market_monitoring_integration_status(Profile, integration_available, [cite(eu_reg_2024_1689_art_72_4)]).
test(an_unbound_profile_is_one_problem) :-
    findall(Problems, post_market_monitoring_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_key_is_an_unknown_key_as_given) :-
    post_market_monitoring_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_compound_key_is_an_unknown_key_as_given) :-
    post_market_monitoring_input_problems([attribute(key(provider), true)], Problems),
    Problems == [unknown_key(key(provider))].
test(a_judgement_accepts_unsure) :-
    post_market_monitoring_input_problems([attribute(intended_to_be_used_by_public_authorities, unsure)], []).
test(contract_problems_come_before_unknown_keys) :-
    post_market_monitoring_input_problems([attribute(colour, red), attribute(provider_of_the_system, maybe)], [wrong_type(provider_of_the_system), unknown_key(colour)]).
test(a_string_value_is_a_wrong_type) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, "true")], [wrong_type(provider_of_the_system)]).
test(a_bad_profile_and_a_bad_date_are_both_named) :-
    post_market_monitoring_duty_status(profile, nineteen, input_problems([wrong_type(profile), wrong_type(assessment_date)]), []).
test(a_thirteenth_month_is_not_a_date) :-
    post_market_monitoring_duty_status([], date(2028, 13, 1), input_problems([wrong_type(assessment_date)]), []).
test(year_ten_thousand_is_not_a_date) :-
    post_market_monitoring_duty_status([], date(10000, 1, 1), input_problems([wrong_type(assessment_date)]), []).
test(a_non_leap_february_29_is_not_a_date) :-
    post_market_monitoring_duty_status([], date(2029, 2, 29), input_problems([wrong_type(assessment_date)]), []).
test(input_problems_come_first_for_integration) :-
    findall(Result - Citations, post_market_monitoring_integration_status([attribute(provider_of_the_system, false), attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].

test(not_applicable_on_date_rejects_duty_applies, fail) :-
    subject_status(before_the_annex_iii_date, duty_applies).
test(not_a_provider_rejects_duty_applies, fail) :-
    subject_status(actor_not_a_provider, duty_applies).
test(not_a_high_risk_ai_system_rejects_not_a_provider, fail) :-
    subject_status(system_not_high_risk, not_a_provider).
test(annex_x_component_rejects_duty_applies, fail) :-
    subject_status(annex_x_component_the_day_before_the_deadline, duty_applies).
test(existing_system_not_covered_rejects_duty_applies, fail) :-
    subject_status(existing_system_without_changes, duty_applies).
test(public_authority_system_rejects_not_covered, fail) :-
    subject_status(existing_public_authority_system_the_day_before_the_deadline, existing_system_without_significant_changes_not_covered).
test(duty_applies_rejects_not_applicable_on_date, fail) :-
    subject_status(provider_of_an_annex_iii_system, not_applicable_on_date).
test(integration_available_rejects_not_available, fail) :-
    subject_status(integration_through_annex_i_legislation, integration_not_available).
test(integration_status_rejects_a_wrong_citation, fail) :-
    post_market_monitoring_profile_for(integration_for_financial_institution, integration(Profile)),
    post_market_monitoring_integration_status(Profile, integration_available, [cite(eu_reg_2024_1689_art_72_1)]).

cp_test_names([not_applicable_on_date_bound, not_a_provider_bound, not_a_high_risk_ai_system_bound, annex_i_only_day_before_bound, annex_x_component_bound, existing_system_not_covered_bound, public_authority_system_bound, duty_applies_bound, integration_available_bound, integration_not_available_bound, missing_key_bound, referral_bound, duty_status_with_every_argument_bound, integration_status_with_every_argument_bound, an_unbound_profile_is_one_problem, a_number_key_is_an_unknown_key_as_given, a_compound_key_is_an_unknown_key_as_given, a_judgement_accepts_unsure, contract_problems_come_before_unknown_keys, a_string_value_is_a_wrong_type, a_bad_profile_and_a_bad_date_are_both_named, a_thirteenth_month_is_not_a_date, year_ten_thousand_is_not_a_date, a_non_leap_february_29_is_not_a_date, input_problems_come_first_for_integration]).
cp_test_fail_names([not_applicable_on_date_rejects_duty_applies, not_a_provider_rejects_duty_applies, not_a_high_risk_ai_system_rejects_not_a_provider, annex_x_component_rejects_duty_applies, existing_system_not_covered_rejects_duty_applies, public_authority_system_rejects_not_covered, duty_applies_rejects_not_applicable_on_date, integration_available_rejects_not_available, integration_status_rejects_a_wrong_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
