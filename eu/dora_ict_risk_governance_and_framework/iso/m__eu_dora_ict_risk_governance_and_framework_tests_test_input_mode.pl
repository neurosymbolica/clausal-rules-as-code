% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_governance_and_framework_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_kernel, [dora_ict_risk_governance_and_framework_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_dora_ict_risk_governance_and_framework, [dora_ict_risk_governance_and_framework_status/2, dora_ict_risk_governance_and_framework_status_values/1, ict_risk_governance_duties_required/3, ict_risk_governance_duties_complete/3, ict_risk_governance_duties_outstanding/3]).
:- use_module(m__eu_dora_ict_risk_governance_and_framework_fixtures, [dora_ict_risk_governance_and_framework_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_all_performed, Profile),
    findall(Status, dora_ict_risk_governance_and_framework_status(Profile, Status), [BaselineStatus]),
    dora_ict_risk_governance_and_framework_status(Profile, BaselineStatus).
test(complete_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_all_performed, Profile),
    ict_risk_governance_duties_complete(Profile, complete, _).
test(incomplete_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_data_security_unperformed, Profile),
    ict_risk_governance_duties_complete(Profile, incomplete, _).
test(simplified_framework_entity_bound_in_every_query) :-
    dora_ict_risk_governance_and_framework_profile_for(article_16_1_entity, Profile),
    ict_risk_governance_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_governance_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_governance_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(missing_article_16_answer_bound_in_every_query) :-
    dora_ict_risk_governance_and_framework_profile_for(article_16_1_answer_absent, Profile),
    ict_risk_governance_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    ict_risk_governance_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    ict_risk_governance_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(missing_trigger_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_major_change_unanswered, Profile),
    ict_risk_governance_duties_required(Profile, indeterminate([major_change_occurred]), []).
test(missing_size_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(size_unanswered_all_performed, Profile),
    ict_risk_governance_duties_required(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(outstanding_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_information_request_unanswered, Profile),
    ict_risk_governance_duties_outstanding(Profile, outstanding([ict_risk_information_to_authority]), [cite(eu_reg_2022_2554_art_6_3)]).
test(none_outstanding_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(microenterprise_all_performed, Profile),
    ict_risk_governance_duties_outstanding(Profile, none_outstanding, _).
test(legal_review_bound) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_control_function_unsure, Profile),
    ict_risk_governance_duties_complete(Profile, needs_legal_review(open_textured(independent_ict_risk_control_function_assigned, cite(eu_reg_2022_2554_art_6_4)), [inputs_relied_on(_)]), []),
    ict_risk_governance_duties_outstanding(Profile, needs_legal_review(open_textured(independent_ict_risk_control_function_assigned, cite(eu_reg_2022_2554_art_6_4)), [inputs_relied_on(_)]), []).
test(input_problems_bound_in_every_query) :-
    ict_risk_governance_duties_required(not_a_profile, input_problems([wrong_type(profile)]), []),
    ict_risk_governance_duties_complete(not_a_profile, input_problems([wrong_type(profile)]), []),
    ict_risk_governance_duties_outstanding(not_a_profile, input_problems([wrong_type(profile)]), []).
test(an_empty_profile_has_no_problem) :-
    dora_ict_risk_governance_and_framework_input_problems([], []).
test(a_fixture_profile_has_no_problem) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_every_trigger, Profile),
    dora_ict_risk_governance_and_framework_input_problems(Profile, []).
test(an_atom_is_not_a_profile) :-
    dora_ict_risk_governance_and_framework_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    dora_ict_risk_governance_and_framework_input_problems(_Profile, [wrong_type(profile)]).
test(a_partial_list_is_not_a_profile) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, true)|_Rest], [wrong_type(profile)]).
test(a_list_with_a_bare_element_is_not_a_profile) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, true), major_change_occurred], [wrong_type(profile)]).
test(a_list_with_an_unbound_element_is_not_a_profile) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, true), _Element], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, _Value)], [wrong_type(major_change_occurred)]).
test(unsure_is_wrong_type_for_a_crisp_key) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(framework_reviewed_at_least_yearly, unsure)], [wrong_type(framework_reviewed_at_least_yearly)]).
test(unsure_is_allowed_for_a_judgement_key) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(framework_reviewed_periodically, unsure)], []).
test(a_number_value_is_wrong_type) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(minimises_ict_risk_impact, 7)], [wrong_type(minimises_ict_risk_impact)]).
test(a_float_value_is_wrong_type) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, 7.0)], [wrong_type(major_change_occurred)]).
test(a_number_key_is_unknown) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_key_is_named_as_given) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(Key, true)], [unknown_key(Named)]),
    Named == Key.
test(a_duplicate_with_equal_values_is_a_duplicate) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, true), attribute(major_change_occurred, true)], [duplicate_key(major_change_occurred)]).
test(a_duplicate_reads_none_of_its_values) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(major_change_occurred, unsure), attribute(major_change_occurred, 7)], [duplicate_key(major_change_occurred)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    dora_ict_risk_governance_and_framework_input_problems([attribute(legacy_systems_risk_assessed, maybe), attribute(zebra_key, true), attribute(financial_entity_is_microenterprise, unsure), attribute(zebra_key, false)], [wrong_type(financial_entity_is_microenterprise), wrong_type(legacy_systems_risk_assessed), unknown_key(zebra_key)]).
test(the_input_check_answers_once) :-
    findall(Problems, dora_ict_risk_governance_and_framework_input_problems([attribute(zebra_key, true), attribute(major_change_occurred, unsure)], Problems), Answers),
    Answers == [[wrong_type(major_change_occurred), unknown_key(zebra_key)]].

test(every_other_bound_status_is_rejected, fail) :-
    dora_ict_risk_governance_and_framework_profile_for(large_entity_all_performed, Profile),
    findall(Status, dora_ict_risk_governance_and_framework_status(Profile, Status), [BaselineStatus]),
    dora_ict_risk_governance_and_framework_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ict_risk_governance_and_framework_status(Profile, Other).

cp_test_names([status_holds_with_the_verdict_bound, complete_bound, incomplete_bound, simplified_framework_entity_bound_in_every_query, missing_article_16_answer_bound_in_every_query, missing_trigger_bound, missing_size_bound, outstanding_bound, none_outstanding_bound, legal_review_bound, input_problems_bound_in_every_query, an_empty_profile_has_no_problem, a_fixture_profile_has_no_problem, an_atom_is_not_a_profile, an_unbound_profile_is_not_a_profile, a_partial_list_is_not_a_profile, a_list_with_a_bare_element_is_not_a_profile, a_list_with_an_unbound_element_is_not_a_profile, an_unbound_value_is_wrong_type, unsure_is_wrong_type_for_a_crisp_key, unsure_is_allowed_for_a_judgement_key, a_number_value_is_wrong_type, a_float_value_is_wrong_type, a_number_key_is_unknown, an_unbound_key_is_named_as_given, a_duplicate_with_equal_values_is_a_duplicate, a_duplicate_reads_none_of_its_values, problems_follow_contract_order_then_unknown_keys, the_input_check_answers_once]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
