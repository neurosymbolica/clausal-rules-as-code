% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [article_6_application_status/4, end_user_data_portability_status/4, business_user_data_access_status/4, dma_art_6_9_10_portability_and_business_data_order_status_values/1]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_fixtures, [dma_art_6_9_10_portability_and_business_data_order_profile_for/2]).

application_result(Subject, Result) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    article_6_application_status(Profile, Result, _, _).

portability_result(Subject, Result) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    end_user_data_portability_status(Profile, Result, _, _).

business_result(Subject, Result) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    business_user_data_access_status(Profile, Result, _, _).

test(the_status_table_is_the_thirteen_result_atoms) :-
    dma_art_6_9_10_portability_and_business_data_order_status_values(StatusValues),
    clausal_msort(StatusValues, SortedValues),
    clausal_msort([article_6_obligations_apply, article_6_obligations_do_not_apply, portability_duty_met, portability_duty_not_met, portability_not_requested, data_outside_article_6_9, data_access_duty_met, data_access_duty_not_met, personal_data_access_duty_met, personal_data_access_duty_not_met, personal_data_access_not_required, data_access_not_requested, data_outside_article_6_10], SortedValues).
test(application_listed_applies) :-
    application_result(application_listed, article_6_obligations_apply).
test(application_not_listed_does_not_apply) :-
    application_result(application_not_listed, article_6_obligations_do_not_apply).
test(portability_met_positive) :-
    portability_result(portability_duty_met_subject, portability_duty_met).
test(portability_not_met_positive) :-
    portability_result(portability_tools_lacking, portability_duty_not_met).
test(portability_not_requested_positive) :-
    portability_result(portability_not_requested_subject, portability_not_requested).
test(portability_data_outside_positive) :-
    portability_result(portability_data_outside, data_outside_article_6_9).
test(portability_not_listed_positive) :-
    portability_result(portability_not_listed, article_6_obligations_do_not_apply).
test(portability_absent_element_positive) :-
    portability_result(portability_effective_absent, indeterminate([end_user_data_portability_effective])).
test(portability_designation_referral_positive) :-
    portability_result(portability_designation_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), _)).
test(portability_scope_unsure_positive) :-
    portability_result(portability_scope_unsure, needs_legal_review(open_textured(data_provided_by_or_generated_through_activity_of_end_user, cite(eu_reg_2022_1925_art_6_9)), _)).
test(portability_tools_unsure_positive) :-
    portability_result(portability_tools_unsure, needs_legal_review(open_textured(end_user_data_portability_tools_provided, cite(eu_reg_2022_1925_art_6_9)), _)).
test(business_non_personal_met_positive) :-
    business_result(business_non_personal_met, data_access_duty_met).
test(business_non_personal_not_met_positive) :-
    business_result(business_non_personal_charged, data_access_duty_not_met).
test(business_personal_met_positive) :-
    business_result(business_personal_met, personal_data_access_duty_met).
test(business_personal_not_met_positive) :-
    business_result(business_personal_real_time_lacking, personal_data_access_duty_not_met).
test(business_not_required_consent_positive) :-
    business_result(business_consent_refused, personal_data_access_not_required).
test(business_not_required_connection_positive) :-
    business_result(business_not_directly_connected, personal_data_access_not_required).
test(business_not_requested_positive) :-
    business_result(business_not_requested, data_access_not_requested).
test(business_data_outside_positive) :-
    business_result(business_data_outside, data_outside_article_6_10).
test(business_not_listed_positive) :-
    business_result(business_not_listed, article_6_obligations_do_not_apply).
test(business_personal_absent_positive) :-
    business_result(business_personal_absent, indeterminate([requested_business_user_data_are_personal_data])).
test(business_connection_absent_positive) :-
    business_result(business_connection_absent, indeterminate([personal_data_directly_connected_with_end_user_use_of_business_user_offer])).
test(business_element_absent_positive) :-
    business_result(business_element_absent, indeterminate([business_user_data_access_and_use_effective_and_high_quality])).
test(business_designation_referral_positive) :-
    business_result(business_designation_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), _)).
test(business_consent_referral_positive) :-
    business_result(business_consent_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_10), cite(digital_markets_business_user_data_sharing_consent_statement)), _)).
test(business_personal_unsure_positive) :-
    business_result(business_personal_unsure, needs_legal_review(open_textured(requested_business_user_data_are_personal_data, cite(eu_reg_2022_1925_art_6_10)), _)).
test(business_effective_unsure_positive) :-
    business_result(business_effective_unsure, needs_legal_review(open_textured(business_user_data_access_and_use_effective_and_high_quality, cite(eu_reg_2022_1925_art_6_10)), _)).
test(input_problems_positive) :-
    application_result(input_unknown_key, input_problems([unknown_key(colour)])).

test(application_not_listed_does_not_apply_route, fail) :-
    application_result(application_not_listed, article_6_obligations_apply).
test(application_absent_is_not_final, fail) :-
    application_result(application_designation_absent, article_6_obligations_do_not_apply).
test(portability_met_near_miss_tools_lacking, fail) :-
    portability_result(portability_tools_lacking, portability_duty_met).
test(portability_not_met_near_miss_all_hold, fail) :-
    portability_result(portability_duty_met_subject, portability_duty_not_met).
test(portability_not_requested_near_miss_request_absent, fail) :-
    portability_result(portability_request_absent, portability_not_requested).
test(portability_data_outside_near_miss_scope_absent, fail) :-
    portability_result(portability_scope_absent, data_outside_article_6_9).
test(portability_not_listed_near_miss_designation_absent, fail) :-
    portability_result(portability_designation_absent, article_6_obligations_do_not_apply).
test(portability_absent_element_near_miss_all_present, fail) :-
    portability_result(portability_duty_met_subject, indeterminate(_)).
test(portability_designation_referral_near_miss_listed, fail) :-
    portability_result(portability_duty_met_subject, needs_legal_review(_, _)).
test(portability_scope_unsure_near_miss_scope_false, fail) :-
    portability_result(portability_data_outside, needs_legal_review(_, _)).
test(portability_tools_unsure_near_miss_tools_false, fail) :-
    portability_result(portability_tools_lacking, needs_legal_review(_, _)).
test(business_non_personal_met_near_miss_charged, fail) :-
    business_result(business_non_personal_charged, data_access_duty_met).
test(business_non_personal_not_met_near_miss_free, fail) :-
    business_result(business_non_personal_met, data_access_duty_not_met).
test(business_personal_met_near_miss_consent_refused, fail) :-
    business_result(business_consent_refused, personal_data_access_duty_met).
test(business_personal_not_met_near_miss_real_time, fail) :-
    business_result(business_personal_met, personal_data_access_duty_not_met).
test(business_not_required_near_miss_conditions_hold, fail) :-
    business_result(business_personal_met, personal_data_access_not_required).
test(business_not_requested_near_miss_request_absent, fail) :-
    business_result(business_request_absent, data_access_not_requested).
test(business_data_outside_near_miss_in_scope, fail) :-
    business_result(business_personal_absent, data_outside_article_6_10).
test(business_not_listed_near_miss_listed, fail) :-
    business_result(business_request_absent, article_6_obligations_do_not_apply).
test(business_personal_absent_near_miss_unsure, fail) :-
    business_result(business_personal_unsure, indeterminate(_)).
test(business_connection_absent_near_miss_connected, fail) :-
    business_result(business_personal_met, indeterminate(_)).
test(business_element_absent_near_miss_present, fail) :-
    business_result(business_non_personal_met, indeterminate(_)).
test(business_designation_referral_near_miss_listed, fail) :-
    business_result(business_non_personal_met, needs_legal_review(_, _)).
test(business_consent_referral_near_miss_consent_given, fail) :-
    business_result(business_personal_met, needs_legal_review(_, _)).
test(business_personal_unsure_near_miss_personal_true, fail) :-
    business_result(business_personal_met, needs_legal_review(open_textured(requested_business_user_data_are_personal_data, _), _)).
test(business_effective_unsure_near_miss_effective_true, fail) :-
    business_result(business_non_personal_met, needs_legal_review(open_textured(_, _), _)).
test(input_problems_near_miss_clean_profile, fail) :-
    application_result(application_designation_absent, input_problems(_)).

cp_test_names([the_status_table_is_the_thirteen_result_atoms, application_listed_applies, application_not_listed_does_not_apply, portability_met_positive, portability_not_met_positive, portability_not_requested_positive, portability_data_outside_positive, portability_not_listed_positive, portability_absent_element_positive, portability_designation_referral_positive, portability_scope_unsure_positive, portability_tools_unsure_positive, business_non_personal_met_positive, business_non_personal_not_met_positive, business_personal_met_positive, business_personal_not_met_positive, business_not_required_consent_positive, business_not_required_connection_positive, business_not_requested_positive, business_data_outside_positive, business_not_listed_positive, business_personal_absent_positive, business_connection_absent_positive, business_element_absent_positive, business_designation_referral_positive, business_consent_referral_positive, business_personal_unsure_positive, business_effective_unsure_positive, input_problems_positive]).
cp_test_fail_names([application_not_listed_does_not_apply_route, application_absent_is_not_final, portability_met_near_miss_tools_lacking, portability_not_met_near_miss_all_hold, portability_not_requested_near_miss_request_absent, portability_data_outside_near_miss_scope_absent, portability_not_listed_near_miss_designation_absent, portability_absent_element_near_miss_all_present, portability_designation_referral_near_miss_listed, portability_scope_unsure_near_miss_scope_false, portability_tools_unsure_near_miss_tools_false, business_non_personal_met_near_miss_charged, business_non_personal_not_met_near_miss_free, business_personal_met_near_miss_consent_refused, business_personal_not_met_near_miss_real_time, business_not_required_near_miss_conditions_hold, business_not_requested_near_miss_request_absent, business_data_outside_near_miss_in_scope, business_not_listed_near_miss_listed, business_personal_absent_near_miss_unsure, business_connection_absent_near_miss_connected, business_element_absent_near_miss_present, business_designation_referral_near_miss_listed, business_consent_referral_near_miss_consent_given, business_personal_unsure_near_miss_personal_true, business_effective_unsure_near_miss_effective_true, input_problems_near_miss_clean_profile]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
