% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_scope_and_roles_scope_and_roles, [regulation_scope_status/4, defined_role_status/5, value_chain_provider_status/4, initial_provider_status/4, supplier_agreement_status/4, scope_and_roles_status/2]).
:- use_module(m__eu_ai_act_scope_and_roles_kernel, [scope_and_roles_input_problems/2]).
:- use_module(m__eu_ai_act_scope_and_roles_fixtures, [scope_and_roles_profile_for/2]).

test(regulation_applies_with_result_and_citations_bound) :-
    scope_and_roles_profile_for(eu_provider_placing_on_market, Profile),
    regulation_scope_status(Profile, date(2026, 8, 1), regulation_applies, [cite(eu_reg_2024_1689_art_2_1_a), cite(eu_reg_2024_1689_art_2_1_c)]).
test(out_of_scope_with_the_result_bound) :-
    scope_and_roles_profile_for(personal_use_deployer, Profile),
    regulation_scope_status(Profile, date(2026, 8, 1), out_of_scope, _).
test(the_facade_status_with_the_status_bound) :-
    scope_and_roles_profile_for(eu_provider_placing_on_market, Profile),
    scope_and_roles_status(case(Profile, date(2026, 8, 1)), regulation_applies).
test(role_holds_with_result_and_citations_bound) :-
    scope_and_roles_profile_for(provider_role_holds, Profile),
    defined_role_status(Profile, provider, date(2026, 8, 1), role_holds, [cite(eu_reg_2024_1689_art_3_1), cite(eu_reg_2024_1689_art_3_3)]).
test(considered_provider_with_the_result_bound) :-
    scope_and_roles_profile_for(rebranding_distributor_considered_provider, Profile),
    value_chain_provider_status(Profile, date(2028, 9, 1), considered_provider, _).
test(paragraph_2_not_applied_with_the_result_bound) :-
    scope_and_roles_profile_for(initial_provider_clearly_specified, Profile),
    initial_provider_status(Profile, date(2028, 9, 1), paragraph_2_not_applied, [cite(eu_reg_2024_1689_art_25_2)]).
test(written_agreement_required_with_the_result_bound) :-
    scope_and_roles_profile_for(general_purpose_model_supplier_agreement_required, Profile),
    supplier_agreement_status(Profile, date(2028, 9, 1), written_agreement_required, [cite(eu_reg_2024_1689_art_25_4)]).
test(a_bound_indeterminate_names_the_first_key) :-
    regulation_scope_status([], date(2026, 8, 1), indeterminate([ai_system]), []).
test(a_well_formed_profile_has_no_problem) :-
    scope_and_roles_input_problems([attribute(ai_system, unsure), attribute(actor_role, provider)], Problems),
    Problems == [].
test(the_empty_profile_has_no_problem) :-
    scope_and_roles_input_problems([], Problems),
    Problems == [].
test(a_non_list_is_not_a_profile) :-
    scope_and_roles_input_problems(foo, Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_makes_a_non_profile) :-
    scope_and_roles_input_problems([attribute(ai_system, true), ai_system], Problems),
    Problems == [wrong_type(profile)].
test(a_repeated_key_is_a_duplicate_and_not_a_wrong_type) :-
    scope_and_roles_input_problems([attribute(ai_system, maybe), attribute(ai_system, true)], Problems),
    Problems == [duplicate_key(ai_system)].
test(an_unknown_key_is_named_once) :-
    scope_and_roles_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(contract_problems_come_before_unknown_keys) :-
    scope_and_roles_input_problems([attribute(colour, red), attribute(ai_system, maybe)], Problems),
    Problems == [wrong_type(ai_system), unknown_key(colour)].
test(contract_problems_follow_the_contract_order) :-
    scope_and_roles_input_problems([attribute(high_risk_route, annex_ii), attribute(actor_role, manufacturer)], Problems),
    Problems == [wrong_type(actor_role), wrong_type(high_risk_route)].
test(a_crisp_key_does_not_take_unsure) :-
    scope_and_roles_input_problems([attribute(testing_in_real_world_conditions, unsure)], Problems),
    Problems == [wrong_type(testing_in_real_world_conditions)].
test(a_string_boolean_is_a_wrong_type) :-
    scope_and_roles_input_problems([attribute(in_the_supply_chain, "true")], Problems),
    Problems == [wrong_type(in_the_supply_chain)].
test(a_compound_key_is_named_as_given) :-
    scope_and_roles_input_problems([attribute(colour(red), true)], Problems),
    Problems == [unknown_key(colour(red))].
test(a_number_key_is_an_unknown_key) :-
    scope_and_roles_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(the_input_check_yields_one_solution) :-
    findall(Problems, scope_and_roles_input_problems([attribute(ai_system, true), attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_profile_problem_answers_first) :-
    findall(Result - Citations, regulation_scope_status([attribute(colour, red)], date(2026, 8, 1), Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(the_argument_problems_follow_the_profile_problems) :-
    findall(Result - Citations, defined_role_status([attribute(ai_system, maybe)], manufacturer, foo, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(ai_system), wrong_type(defined_role), wrong_type(assessment_date)]) - []].
test(an_unbound_assessment_date_is_a_wrong_type) :-
    findall(Result - Citations, value_chain_provider_status([], _, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(assessment_date)]) - []].
test(an_unbound_defined_role_is_a_wrong_type) :-
    findall(Result - Citations, defined_role_status([], _, date(2026, 8, 1), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(defined_role)]) - []].
test(a_non_leap_february_29_is_not_a_date) :-
    findall(Result, supplier_agreement_status([], date(2027, 2, 29), Result, _), Answers),
    Answers == [input_problems([wrong_type(assessment_date)])].
test(a_leap_february_29_is_a_date) :-
    findall(Result, initial_provider_status([], date(2028, 2, 29), Result, _), Answers),
    Answers == [indeterminate([high_risk_route])].
test(a_month_thirteen_is_not_a_date) :-
    findall(Result, initial_provider_status([], date(2028, 13, 1), Result, _), Answers),
    Answers == [input_problems([wrong_type(assessment_date)])].

test(a_bound_out_of_scope_is_rejected_for_a_covered_provider, fail) :-
    scope_and_roles_profile_for(eu_provider_placing_on_market, Profile),
    regulation_scope_status(Profile, date(2026, 8, 1), out_of_scope, _).
test(a_bound_role_holds_is_rejected_for_a_mere_developer, fail) :-
    scope_and_roles_profile_for(developer_without_placing_not_provider, Profile),
    defined_role_status(Profile, provider, date(2026, 8, 1), role_holds, _).

cp_test_names([regulation_applies_with_result_and_citations_bound, out_of_scope_with_the_result_bound, the_facade_status_with_the_status_bound, role_holds_with_result_and_citations_bound, considered_provider_with_the_result_bound, paragraph_2_not_applied_with_the_result_bound, written_agreement_required_with_the_result_bound, a_bound_indeterminate_names_the_first_key, a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, a_non_list_is_not_a_profile, a_foreign_element_makes_a_non_profile, a_repeated_key_is_a_duplicate_and_not_a_wrong_type, an_unknown_key_is_named_once, contract_problems_come_before_unknown_keys, contract_problems_follow_the_contract_order, a_crisp_key_does_not_take_unsure, a_string_boolean_is_a_wrong_type, a_compound_key_is_named_as_given, a_number_key_is_an_unknown_key, the_input_check_yields_one_solution, a_profile_problem_answers_first, the_argument_problems_follow_the_profile_problems, an_unbound_assessment_date_is_a_wrong_type, an_unbound_defined_role_is_a_wrong_type, a_non_leap_february_29_is_not_a_date, a_leap_february_29_is_a_date, a_month_thirteen_is_not_a_date]).
cp_test_fail_names([a_bound_out_of_scope_is_rejected_for_a_covered_provider, a_bound_role_holds_is_rejected_for_a_mere_developer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
