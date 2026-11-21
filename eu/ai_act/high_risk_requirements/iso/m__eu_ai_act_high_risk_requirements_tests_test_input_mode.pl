% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_high_risk_requirements_high_risk_requirements, [high_risk_requirement_status/5, documentation_element_status/4, high_risk_requirements_status/2]).
:- use_module(m__eu_ai_act_high_risk_requirements_kernel, [high_risk_requirements_input_problems/2]).
:- use_module(m__eu_ai_act_high_risk_requirements_fixtures, [high_risk_requirements_profile_for/2]).

test(a_bound_requirement_applies_holds) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirement_status(Profile, risk_management_system, date(2027, 12, 2), requirement_applies, _).
test(a_bound_citation_set_holds) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    sort([cite(eu_reg_2024_1689_art_9_1), cite(eu_reg_2024_1689_art_8_1)], Citations),
    high_risk_requirement_status(Profile, risk_management_system, date(2027, 12, 2), requirement_applies, Citations).
test(the_status_projection_holds_with_the_status_bound) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_status(requirement_case(Profile, risk_management_system, date(2027, 12, 2)), requirement_applies).
test(a_bound_element_answer_holds) :-
    high_risk_requirements_profile_for(component_photographs_not_a_component, Profile),
    documentation_element_status(Profile, annex_iv_point_1_f, element_not_required, _).
test(a_bound_missing_key_answer_holds) :-
    high_risk_requirements_profile_for(missing_annex_iii_classification, Profile),
    high_risk_requirement_status(Profile, risk_management_system, date(2028, 1, 1), indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii]), []).
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, high_risk_requirements_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type_profile) :-
    findall(Problems, high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_item_is_wrong_type_profile_alone) :-
    high_risk_requirements_input_problems([attribute(colour, red), colour], Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_an_unbound_item_is_wrong_type_profile) :-
    findall(Problems, high_risk_requirements_input_problems([_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    high_risk_requirements_input_problems(not_a_list, [wrong_type(profile)]).
test(an_empty_profile_has_no_problem) :-
    high_risk_requirements_input_problems([], []).
test(a_number_key_is_an_unknown_key) :-
    high_risk_requirements_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unbound_value_is_a_wrong_type) :-
    findall(Problems, high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, _)], Problems), Answers),
    Answers == [[wrong_type(system_is_a_component_of_products)]].
test(a_judgement_may_be_unsure) :-
    high_risk_requirements_input_problems([attribute(significant_changes_in_design_as_from_the_chapter_iii_date, unsure)], []).
test(a_judgement_outside_its_type_is_a_wrong_type) :-
    high_risk_requirements_input_problems([attribute(intended_to_be_used_by_public_authorities, maybe)], Problems),
    Problems == [wrong_type(intended_to_be_used_by_public_authorities)].
test(a_crisp_key_given_a_string_is_a_wrong_type) :-
    high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, "true")], Problems),
    Problems == [wrong_type(system_is_a_component_of_products)].
test(a_duplicate_key_with_different_values_is_only_a_duplicate) :-
    high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, true), attribute(system_is_a_component_of_products, maybe)], Problems),
    Problems == [duplicate_key(system_is_a_component_of_products)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    high_risk_requirements_input_problems([attribute(colour, red), attribute(related_to_a_product_covered_by_annex_i_section_a, maybe), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, 1)], Problems),
    Problems == [wrong_type(system_is_a_high_risk_ai_system_listed_in_annex_iii), wrong_type(related_to_a_product_covered_by_annex_i_section_a), unknown_key(colour)].
test(a_repeated_unknown_key_is_named_once) :-
    high_risk_requirements_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(a_profile_problem_is_answered_first) :-
    high_risk_requirement_status([attribute(colour, red)], risk_management_system, date(2028, 1, 1), Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(all_argument_problems_follow_the_profile_problems) :-
    high_risk_requirement_status(not_a_list, colour_coding, today, Result, Citations),
    Result == input_problems([wrong_type(profile), wrong_type(requirement), wrong_type(assessment_date)]),
    Citations == [].
test(an_unbound_requirement_is_not_enumerated) :-
    findall(Result, high_risk_requirement_status([], _, date(2028, 1, 1), Result, _), Results),
    Results == [input_problems([wrong_type(requirement)])].
test(an_unbound_date_is_a_wrong_type) :-
    findall(Result - Citations, high_risk_requirement_status([], human_oversight, _, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(assessment_date)]) - []].
test(an_impossible_day_is_a_wrong_type) :-
    high_risk_requirement_status([], human_oversight, date(2027, 2, 29), Result, []),
    Result == input_problems([wrong_type(assessment_date)]).
test(a_word_day_is_a_wrong_type) :-
    high_risk_requirement_status([], human_oversight, date(2028, 1, first), Result, []),
    Result == input_problems([wrong_type(assessment_date)]).
test(a_year_past_9999_is_a_wrong_type) :-
    high_risk_requirement_status([], human_oversight, date(10000, 1, 1), Result, []),
    Result == input_problems([wrong_type(assessment_date)]).
test(an_unbound_element_is_not_enumerated) :-
    findall(Result, documentation_element_status([], _, Result, _), Results),
    Results == [input_problems([wrong_type(element)])].
test(an_unknown_element_follows_the_profile_problems) :-
    documentation_element_status([attribute(system_is_a_component_of_products, unsure)], annex_iv_point_10, Result, []),
    Result == input_problems([wrong_type(system_is_a_component_of_products), wrong_type(element)]).

test(a_bound_wrong_verdict_is_rejected, fail) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirement_status(Profile, risk_management_system, date(2027, 12, 2), not_applicable_on_date, _).
test(a_bound_wrong_citation_set_is_rejected, fail) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirement_status(Profile, risk_management_system, date(2027, 12, 2), requirement_applies, [cite(eu_reg_2024_1689_art_8_1)]).
test(a_bound_wrong_element_answer_is_rejected, fail) :-
    high_risk_requirements_profile_for(component_photographs_not_a_component, Profile),
    documentation_element_status(Profile, annex_iv_point_1_f, element_required, _).

cp_test_names([a_bound_requirement_applies_holds, a_bound_citation_set_holds, the_status_projection_holds_with_the_status_bound, a_bound_element_answer_holds, a_bound_missing_key_answer_holds, an_unbound_profile_is_wrong_type_profile, a_partial_list_is_wrong_type_profile, a_list_with_a_foreign_item_is_wrong_type_profile_alone, a_list_with_an_unbound_item_is_wrong_type_profile, an_atom_is_not_an_attribute_list, an_empty_profile_has_no_problem, a_number_key_is_an_unknown_key, an_unbound_value_is_a_wrong_type, a_judgement_may_be_unsure, a_judgement_outside_its_type_is_a_wrong_type, a_crisp_key_given_a_string_is_a_wrong_type, a_duplicate_key_with_different_values_is_only_a_duplicate, problems_come_in_contract_order_then_unknown_keys, a_repeated_unknown_key_is_named_once, a_profile_problem_is_answered_first, all_argument_problems_follow_the_profile_problems, an_unbound_requirement_is_not_enumerated, an_unbound_date_is_a_wrong_type, an_impossible_day_is_a_wrong_type, a_word_day_is_a_wrong_type, a_year_past_9999_is_a_wrong_type, an_unbound_element_is_not_enumerated, an_unknown_element_follows_the_profile_problems]).
cp_test_fail_names([a_bound_wrong_verdict_is_rejected, a_bound_wrong_citation_set_is_rejected, a_bound_wrong_element_answer_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
