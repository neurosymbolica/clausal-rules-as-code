% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_small_items, [small_items_status/2, bias_data_processing_status/4, sandbox_personal_data_processing_status/4, real_world_testing_status/4, informed_consent_status/4, sme_simplified_compliance_status/4, explanation_right_status/4]).
:- use_module(m__eu_ai_act_small_items_fixtures, [small_items_profile_for/2]).
:- use_module(m__eu_ai_act_small_items_kernel, [small_items_input_problems/2]).

subject_status(Subject, Status) :-
    small_items_profile_for(Subject, Request),
    small_items_status(Request, Status).

subject_profile(Subject, Profile, AssessmentDate) :-
    small_items_profile_for(Subject, small_items_request(_Query, Profile, AssessmentDate)).

test(bias_permitted_with_the_answer_bound) :-
    subject_profile(bias_provider_all_conditions_met, Profile, AssessmentDate),
    bias_data_processing_status(Profile, AssessmentDate, bias_processing_permitted, [cite(eu_reg_2024_1689_art_4a_1), cite(eu_reg_2024_1689_art_4a_1_a), cite(eu_reg_2024_1689_art_4a_1_b), cite(eu_reg_2024_1689_art_4a_1_c), cite(eu_reg_2024_1689_art_4a_1_d), cite(eu_reg_2024_1689_art_4a_1_e), cite(eu_reg_2024_1689_art_4a_1_f)]).
test(bias_not_applicable_with_the_answer_bound) :-
    subject_profile(bias_provider_on_twenty_sixth_july, Profile, AssessmentDate),
    bias_data_processing_status(Profile, AssessmentDate, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
test(sandbox_permitted_with_the_answer_bound) :-
    subject_profile(sandbox_outside_law_enforcement, Profile, AssessmentDate),
    sandbox_personal_data_processing_status(Profile, AssessmentDate, sandbox_processing_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(sandbox_not_permitted_with_the_answer_bound) :-
    subject_profile(sandbox_law_enforcement_without_specific_law, Profile, AssessmentDate),
    sandbox_personal_data_processing_status(Profile, AssessmentDate, sandbox_processing_not_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(testing_permitted_with_the_answer_bound) :-
    subject_profile(testing_annex_iii_all_conditions_met, Profile, AssessmentDate),
    real_world_testing_status(Profile, AssessmentDate, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(testing_framework_with_the_answer_bound) :-
    subject_profile(testing_section_b_with_framework, Profile, AssessmentDate),
    real_world_testing_status(Profile, AssessmentDate, subject_to_the_member_state_framework, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_5)]).
test(testing_not_provided_for_with_the_answer_bound) :-
    subject_profile(testing_section_b_without_framework, Profile, AssessmentDate),
    real_world_testing_status(Profile, AssessmentDate, testing_not_provided_for_by_the_member_state, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_2)]).
test(consent_meets_with_the_answer_bound) :-
    subject_profile(consent_meets_all_conditions, Profile, AssessmentDate),
    informed_consent_status(Profile, AssessmentDate, consent_meets_article_61, [cite(eu_reg_2024_1689_art_61_1), cite(eu_reg_2024_1689_art_61_1_a), cite(eu_reg_2024_1689_art_61_1_b), cite(eu_reg_2024_1689_art_61_1_c), cite(eu_reg_2024_1689_art_61_1_d), cite(eu_reg_2024_1689_art_61_1_e), cite(eu_reg_2024_1689_art_61_2)]).
test(sme_may_simplify_with_the_answer_bound) :-
    subject_profile(sme_independent, Profile, AssessmentDate),
    sme_simplified_compliance_status(Profile, AssessmentDate, may_comply_in_a_simplified_manner, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]).
test(explanation_right_with_the_answer_bound) :-
    subject_profile(explanation_all_conditions_met, Profile, AssessmentDate),
    explanation_right_status(Profile, AssessmentDate, right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]).
test(missing_key_with_the_answer_bound) :-
    subject_status(bias_capacity_absent, indeterminate([bias_processing_capacity])).
test(input_problems_with_the_answer_bound) :-
    subject_status(input_unsure_for_a_crisp_key, input_problems([wrong_type(has_partner_or_linked_enterprises)])).
test(a_non_attribute_element_is_wrong_type_alone) :-
    small_items_input_problems([attribute(unlisted_key, true), not_an_attribute], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    small_items_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(a_number_key_is_unknown_as_given) :-
    small_items_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_compound_key_is_unknown_as_given) :-
    small_items_input_problems([attribute(key(consent_freely_given), true)], Problems),
    Problems == [unknown_key(key(consent_freely_given))].
test(a_repeated_unknown_key_is_named_once) :-
    small_items_input_problems([attribute(unlisted_key, true), attribute(unlisted_key, false)], Problems),
    Problems == [unknown_key(unlisted_key)].
test(problems_follow_contract_order_then_unknown_keys) :-
    small_items_input_problems([attribute(unlisted_key, true), attribute(has_partner_or_linked_enterprises, maybe), attribute(bias_processing_capacity, other), attribute(second_unlisted_key, true)], Problems),
    Problems == [wrong_type(bias_processing_capacity), wrong_type(has_partner_or_linked_enterprises), unknown_key(unlisted_key), unknown_key(second_unlisted_key)].
test(a_duplicate_with_equal_values_is_a_duplicate) :-
    small_items_input_problems([attribute(testing_route, annex_iii), attribute(testing_route, annex_iii)], Problems),
    Problems == [duplicate_key(testing_route)].
test(a_judgement_accepts_unsure) :-
    small_items_input_problems([attribute(consent_freely_given, unsure)], Problems),
    Problems == [].
test(an_enumeration_rejects_an_unlisted_atom) :-
    small_items_input_problems([attribute(testing_route, annex_ii)], Problems),
    Problems == [wrong_type(testing_route)].
test(an_enumeration_rejects_unsure) :-
    small_items_input_problems([attribute(approval_status, unsure)], Problems),
    Problems == [wrong_type(approval_status)].
test(a_crisp_key_rejects_an_enumeration_atom) :-
    small_items_input_problems([attribute(is_an_sme_including_a_start_up, approved)], Problems),
    Problems == [wrong_type(is_an_sme_including_a_start_up)].
test(the_input_check_yields_exactly_one_solution) :-
    findall(Problems, small_items_input_problems([attribute(42, true), attribute(consent_freely_given, maybe)], Problems), Solutions),
    Solutions == [[wrong_type(consent_freely_given), unknown_key(42)]].
test(a_non_integer_month_is_an_input_problem) :-
    explanation_right_status([], date(2026, august, 2), Result, Citations),
    Result == input_problems([wrong_type(assessment_date)]),
    Citations == [].
test(a_non_date_term_is_an_input_problem) :-
    real_world_testing_status([], day(2026, 8, 2), Result, Citations),
    Result == input_problems([wrong_type(assessment_date)]),
    Citations == [].
test(profile_problems_come_before_the_date_problem) :-
    sme_simplified_compliance_status([attribute(unlisted_key, true)], date(2026, 13, 1), Result, Citations),
    Result == input_problems([unknown_key(unlisted_key), wrong_type(assessment_date)]),
    Citations == [].
test(input_problems_come_before_the_application_date) :-
    bias_data_processing_status([attribute(bias_processing_capacity, unsure)], date(2025, 1, 1), Result, Citations),
    Result == input_problems([wrong_type(bias_processing_capacity)]),
    Citations == [].
test(an_unread_key_is_still_checked) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, true), attribute(has_partner_or_linked_enterprises, false), attribute(testing_duration, forever)], date(2026, 8, 2), Result, Citations),
    Result == input_problems([wrong_type(testing_duration)]),
    Citations == [].
test(an_unread_unsure_judgement_never_refers) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, true), attribute(has_partner_or_linked_enterprises, false), attribute(consent_freely_given, unsure)], date(2026, 8, 2), Result, _),
    Result == may_comply_in_a_simplified_manner.

test(bias_permitted_is_not_also_not_permitted, fail) :-
    subject_profile(bias_provider_all_conditions_met, Profile, AssessmentDate),
    bias_data_processing_status(Profile, AssessmentDate, bias_processing_not_permitted, _).
test(explanation_right_is_not_also_refused, fail) :-
    subject_profile(explanation_all_conditions_met, Profile, AssessmentDate),
    explanation_right_status(Profile, AssessmentDate, no_right_to_explanation_under_article_86, _).

cp_test_names([bias_permitted_with_the_answer_bound, bias_not_applicable_with_the_answer_bound, sandbox_permitted_with_the_answer_bound, sandbox_not_permitted_with_the_answer_bound, testing_permitted_with_the_answer_bound, testing_framework_with_the_answer_bound, testing_not_provided_for_with_the_answer_bound, consent_meets_with_the_answer_bound, sme_may_simplify_with_the_answer_bound, explanation_right_with_the_answer_bound, missing_key_with_the_answer_bound, input_problems_with_the_answer_bound, a_non_attribute_element_is_wrong_type_alone, an_atom_is_not_a_profile, a_number_key_is_unknown_as_given, a_compound_key_is_unknown_as_given, a_repeated_unknown_key_is_named_once, problems_follow_contract_order_then_unknown_keys, a_duplicate_with_equal_values_is_a_duplicate, a_judgement_accepts_unsure, an_enumeration_rejects_an_unlisted_atom, an_enumeration_rejects_unsure, a_crisp_key_rejects_an_enumeration_atom, the_input_check_yields_exactly_one_solution, a_non_integer_month_is_an_input_problem, a_non_date_term_is_an_input_problem, profile_problems_come_before_the_date_problem, input_problems_come_before_the_application_date, an_unread_key_is_still_checked, an_unread_unsure_judgement_never_refers]).
cp_test_fail_names([bias_permitted_is_not_also_not_permitted, explanation_right_is_not_also_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
