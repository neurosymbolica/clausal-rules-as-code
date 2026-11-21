% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, dora_ict_risk_response_and_recovery_status/2, dora_ict_risk_response_and_recovery_status_values/1]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_status(Profile, complete).
test(complete_bound_with_a_fixed_citation) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, Citations),
    member(cite(eu_reg_2022_2554_art_12_7), Citations).
test(incomplete_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_policy_not_performed, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, incomplete, _).
test(simplified_framework_entity_bound_with_its_citation) :-
    dora_ict_risk_response_and_recovery_profile_for(article_16_1_entity, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_response_and_recovery_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_response_and_recovery_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_absent_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(article_16_1_status_not_stated, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(required_bound_for_a_microenterprise) :-
    dora_ict_risk_response_and_recovery_profile_for(microenterprise_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 21).
test(required_bound_asks_the_cost_request) :-
    dora_ict_risk_response_and_recovery_profile_for(large_entity_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, indeterminate([authority_requested_estimate_of_annual_ict_incident_costs_and_losses]), []).
test(outstanding_bound_with_its_citation) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_without_audit_review, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([independent_internal_audit_review_of_response_and_recovery_plans]), [cite(eu_reg_2022_2554_art_11_3)]).
test(a_clean_profile_has_no_problem_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, []).
test(an_unsure_gate_is_a_wrong_type_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(unsure_gate_profile, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, [wrong_type(financial_entity_is_article_16_1_entity)]),
    ict_risk_response_and_recovery_duties_complete(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(an_unknown_key_bound) :-
    dora_ict_risk_response_and_recovery_profile_for(unknown_key_profile, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, input_problems([unknown_key(no_such_key)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, complete),
    dora_ict_risk_response_and_recovery_status(Profile, Other).
test(incomplete_bound_as_complete_fails, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_policy_not_performed, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, _).
test(outstanding_bound_as_none_outstanding_fails, fail) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_without_audit_review, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, none_outstanding, _).

cp_test_names([status_holds_with_the_verdict_bound, complete_bound_with_a_fixed_citation, incomplete_bound, simplified_framework_entity_bound_with_its_citation, gate_absent_bound, required_bound_for_a_microenterprise, required_bound_asks_the_cost_request, outstanding_bound_with_its_citation, a_clean_profile_has_no_problem_bound, an_unsure_gate_is_a_wrong_type_bound, an_unknown_key_bound]).
cp_test_fail_names([every_other_bound_status_is_rejected, incomplete_bound_as_complete_fails, outstanding_bound_as_none_outstanding_fails]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
