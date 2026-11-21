% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [dora_proportionality_and_simplified_framework_status/2, dora_proportionality_and_simplified_framework_status_values/1, simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_profile_for/2]).

expected_status(exempted_payment_institution_all_duties_performed, complete).
expected_status(exempted_payment_institution_framework_not_performed, incomplete).
expected_status(exempted_payment_institution_framework_unsure, needs_legal_review(open_textured(simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)), [inputs_relied_on(_RelyingPairs)])).
expected_status(exempted_electronic_money_institution_all_duties_performed, complete).
expected_status(small_investment_firm_all_duties_performed, complete).
expected_status(investment_firm_not_small, not_article_16_1_entity).
expected_status(occupational_retirement_fifteen_members, out_of_scope).
expected_status(occupational_retirement_sixteen_members, complete).
expected_status(occupational_retirement_ninety_nine_members, complete).
expected_status(occupational_retirement_one_hundred_members, not_article_16_1_entity).
expected_status(directive_institution_not_excluded_by_member_state, complete).
expected_status(directive_institution_excluded_by_member_state, out_of_scope).
expected_status(third_party_service_provider, not_a_financial_entity).
expected_status(unlisted_entity_type, out_of_scope).
expected_status(credit_institution_subject, not_article_16_1_entity).
expected_status(requested_report_submitted, complete).
expected_status(requested_report_not_submitted, incomplete).
expected_status(entity_type_not_given, indeterminate([dora_entity_type])).
expected_status(entity_type_misspelt, input_problems([wrong_type(dora_entity_type)])).
expected_status(entity_type_given_twice, input_problems([duplicate_key(dora_entity_type)])).

all_duties([simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems, ict_risk_impact_minimisation, detection_and_handling, key_third_party_dependencies, continuity_of_critical_or_important_functions, regular_testing, operational_conclusions_implemented, awareness_and_training_programmes, framework_documentation_and_review, continuous_improvement, review_report_to_authority]).

standing_duties([simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems, ict_risk_impact_minimisation, detection_and_handling, key_third_party_dependencies, continuity_of_critical_or_important_functions, regular_testing, operational_conclusions_implemented, awareness_and_training_programmes, framework_documentation_and_review, continuous_improvement]).

bound_status_holds(Subject) :-
    expected_status(Subject, Status),
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    dora_proportionality_and_simplified_framework_status(Profile, Status).

test(every_expected_status_holds_with_the_verdict_bound) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    length(Subjects, 20),
    maplist(bound_status_holds, Subjects).
test(qualification_holds_with_the_result_bound) :-
    simplified_framework_qualification([attribute(dora_entity_type, exempted_electronic_money_institution)], article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_39)]).
test(required_holds_with_the_full_list_bound) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile),
    all_duties(Duties),
    simplified_framework_duties_required(Profile, required(Duties), _).
test(required_holds_with_the_standing_list_bound) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    standing_duties(Duties),
    simplified_framework_duties_required(Profile, required(Duties), _).
test(complete_holds_with_the_result_bound) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(outstanding_holds_with_the_list_bound) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding([review_report_to_authority]), Citations),
    clausal_msort(Citations, SortedCitations),
    clausal_msort([cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_2)], SortedCitations).
test(an_unbound_key_is_named_as_that_variable) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(StrayKey, true)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == StrayKey.
test(an_unbound_value_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, _)], [wrong_type(dora_entity_type)]).
test(a_negative_member_count_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(iorp_pension_scheme_members_total, -1)], [wrong_type(iorp_pension_scheme_members_total)]).
test(zero_members_is_well_formed) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(iorp_pension_scheme_members_total, 0)], []).
test(a_partial_list_is_not_an_attribute_list) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, credit_institution)|_], [wrong_type(profile)]).
test(a_list_with_a_stray_element_is_not_an_attribute_list) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, credit_institution), stray], [wrong_type(profile)]).
test(an_integer_and_a_float_key_are_two_keys) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(7, first), attribute(7.0, second)], [unknown_key(7), unknown_key(7.0)]).
test(a_judgement_given_a_number_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(plans_and_controls_tested_regularly, 1)], [wrong_type(plans_and_controls_tested_regularly)]).
test(problems_follow_the_contract_order) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(simplified_framework_review_report_submitted, unsure), attribute(dora_entity_type, bogus)], [wrong_type(dora_entity_type), wrong_type(simplified_framework_review_report_submitted)]).
test(every_query_refuses_an_ill_formed_profile_first) :-
    simplified_framework_qualification(not_a_list, input_problems([wrong_type(profile)]), []),
    simplified_framework_duties_required(not_a_list, input_problems([wrong_type(profile)]), []),
    simplified_framework_duties_complete(not_a_list, input_problems([wrong_type(profile)]), []),
    simplified_framework_duties_outstanding(not_a_list, input_problems([wrong_type(profile)]), []).
test(a_present_duty_key_is_checked_even_by_the_qualification) :-
    simplified_framework_qualification([attribute(dora_entity_type, credit_institution), attribute(ict_systems_continuously_monitored, maybe)], input_problems([wrong_type(ict_systems_continuously_monitored)]), []).
test(an_unread_key_for_another_type_is_not_a_problem) :-
    simplified_framework_qualification([attribute(dora_entity_type, credit_institution), attribute(iorp_pension_scheme_members_total, 50)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).

test(every_other_bound_status_is_rejected, fail) :-
    expected_status(Subject, Status),
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    dora_proportionality_and_simplified_framework_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, Status),
    dora_proportionality_and_simplified_framework_status(Profile, Other).
test(a_wrong_bound_qualification_is_rejected, fail) :-
    simplified_framework_qualification([attribute(dora_entity_type, exempted_electronic_money_institution)], not_article_16_1_entity, _).
test(a_shorter_bound_list_is_rejected_when_the_report_is_requested, fail) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile),
    standing_duties(Duties),
    simplified_framework_duties_required(Profile, required(Duties), _).
test(none_outstanding_is_rejected_for_an_unsent_report, fail) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile),
    simplified_framework_duties_outstanding(Profile, none_outstanding, _).

cp_test_names([every_expected_status_holds_with_the_verdict_bound, qualification_holds_with_the_result_bound, required_holds_with_the_full_list_bound, required_holds_with_the_standing_list_bound, complete_holds_with_the_result_bound, outstanding_holds_with_the_list_bound, an_unbound_key_is_named_as_that_variable, an_unbound_value_is_wrong_type, a_negative_member_count_is_wrong_type, zero_members_is_well_formed, a_partial_list_is_not_an_attribute_list, a_list_with_a_stray_element_is_not_an_attribute_list, an_integer_and_a_float_key_are_two_keys, a_judgement_given_a_number_is_wrong_type, problems_follow_the_contract_order, every_query_refuses_an_ill_formed_profile_first, a_present_duty_key_is_checked_even_by_the_qualification, an_unread_key_for_another_type_is_not_a_problem]).
cp_test_fail_names([every_other_bound_status_is_rejected, a_wrong_bound_qualification_is_rejected, a_shorter_bound_list_is_rejected_when_the_report_is_requested, none_outstanding_is_rejected_for_an_unsent_report]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
