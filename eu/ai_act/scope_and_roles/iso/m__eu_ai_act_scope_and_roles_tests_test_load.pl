% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_scope_and_roles_scope_and_roles, [decide_scope_and_roles/2, scope_and_roles_status/2, scope_and_roles_status_values/1, date/3, indeterminate/1, needs_legal_review/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_ai_act_scope_and_roles_kernel, [scope_and_roles_input_problems/2]).
:- use_module(m__eu_ai_act_scope_and_roles_citations, [citation/2, implements/1]).
:- use_module(m__eu_ai_act_scope_and_roles_fixtures, [scope_and_roles_profile_for/2]).

baseline_case(case(Profile, date(2026, 8, 1))) :-
    scope_and_roles_profile_for(eu_provider_placing_on_market, Profile).

other_status(Case, Status) :-
    scope_and_roles_status_values(Values),
    member(Status, Values),
    dif(Status, regulation_applies),
    scope_and_roles_status(Case, Status).

test(the_baseline_case_is_covered) :-
    baseline_case(Case),
    scope_and_roles_status(Case, regulation_applies).
test(the_baseline_profile_yields_exactly_one_status) :-
    baseline_case(Case),
    findall(Status, scope_and_roles_status(Case, Status), Statuses),
    Statuses == [regulation_applies].
test(the_verdict_term_carries_status_and_citations) :-
    baseline_case(Case),
    decide_scope_and_roles(Case, scope_and_roles_verdict(Status, Citations)),
    Status == regulation_applies,
    Citations = [_|_].
test(an_empty_profile_has_no_problem) :-
    scope_and_roles_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_is_not_refused) :-
    baseline_case(case(Profile, _)),
    scope_and_roles_input_problems(Profile, Problems),
    Problems == [].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    scope_and_roles_input_problems(foo, Problems),
    Problems == [wrong_type(profile)].
test(an_element_that_is_not_an_attribute_spoils_the_list) :-
    scope_and_roles_input_problems([attribute(ai_system, true), foo], Problems),
    Problems == [wrong_type(profile)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    scope_and_roles_input_problems([attribute(testing_in_real_world_conditions, unsure)], Problems),
    Problems == [wrong_type(testing_in_real_world_conditions)].
test(a_judgement_key_given_unsure_is_well_typed) :-
    scope_and_roles_input_problems([attribute(ai_system, unsure)], Problems),
    Problems == [].
test(an_enumeration_key_outside_its_atoms_is_wrong_type) :-
    scope_and_roles_input_problems([attribute(high_risk_route, annex_ii)], Problems),
    Problems == [wrong_type(high_risk_route)].
test(a_repeated_key_is_a_duplicate_and_not_wrong_type) :-
    scope_and_roles_input_problems([attribute(actor_role, manufacturer), attribute(actor_role, provider)], Problems),
    Problems == [duplicate_key(actor_role)].
test(the_scope_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_2_1, _).
test(the_value_chain_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_25_1, _).
test(a_recorded_key_marks_provenance) :-
    implements(eu_reg_2024_1689_art_3_1).
test(the_verdict_atoms_are_distinct) :-
    scope_and_roles_status_values(Values),
    sort(Values, Sorted),
    length(Values, Count),
    length(Sorted, Count).
test(the_not_final_statuses_build_and_destructure) :-
    Missing = indeterminate([ai_system]),
    Missing = indeterminate([MissingKey]),
    MissingKey == ai_system,
    Referral = needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]),
    Referral = needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)]),
    Judgement == ai_system,
    Citation == cite(eu_reg_2024_1689_art_3_1),
    Pairs == [ai_system - unsure],
    Refusal = input_problems([wrong_type(ai_system)]),
    Refusal = input_problems(Problems),
    Problems == [wrong_type(ai_system)].
test(the_date_constructor_holds_for_a_ground_date) :-
    date(2026, 8, 1).
test(the_indeterminate_constructor_holds_for_one_key) :-
    indeterminate([actor_role]).
test(the_needs_legal_review_constructor_holds_for_its_shape) :-
    needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]).
test(the_input_problems_constructor_holds_for_a_problem_list) :-
    input_problems([wrong_type(ai_system), unknown_key(colour)]).
test(the_unknown_key_constructor_holds_for_a_ground_key) :-
    unknown_key(colour).
test(the_wrong_type_constructor_holds_for_a_key) :-
    wrong_type(ai_system).
test(the_duplicate_key_constructor_holds_for_a_key) :-
    duplicate_key(actor_role).

test(every_other_bound_status_is_rejected, fail) :-
    baseline_case(Case),
    other_status(Case, _).
test(the_placeholder_citation_is_gone, fail) :-
    citation(todo, _).
test(an_unrecorded_key_marks_nothing, fail) :-
    implements(not_a_recorded_citation_key).
test(two_distinct_verdict_atoms_do_not_unify, fail) :-
    regulation_applies = out_of_scope.
test(the_date_constructor_does_not_hold_for_a_non_integer, fail) :-
    date(2026, august, 1).
test(the_indeterminate_constructor_does_not_hold_for_no_key, fail) :-
    indeterminate([]).
test(the_needs_legal_review_constructor_does_not_hold_for_another_shape, fail) :-
    needs_legal_review(ai_system, []).
test(the_input_problems_constructor_does_not_hold_for_no_problem, fail) :-
    input_problems([]).
test(the_wrong_type_constructor_does_not_hold_for_a_number, fail) :-
    wrong_type(7).
test(the_duplicate_key_constructor_does_not_hold_for_a_number, fail) :-
    duplicate_key(7).

cp_test_names([the_baseline_case_is_covered, the_baseline_profile_yields_exactly_one_status, the_verdict_term_carries_status_and_citations, an_empty_profile_has_no_problem, a_well_formed_profile_is_not_refused, a_term_that_is_not_a_list_is_not_a_profile, an_element_that_is_not_an_attribute_spoils_the_list, a_crisp_key_given_unsure_is_wrong_type, a_judgement_key_given_unsure_is_well_typed, an_enumeration_key_outside_its_atoms_is_wrong_type, a_repeated_key_is_a_duplicate_and_not_wrong_type, the_scope_citation_is_recorded, the_value_chain_citation_is_recorded, a_recorded_key_marks_provenance, the_verdict_atoms_are_distinct, the_not_final_statuses_build_and_destructure, the_date_constructor_holds_for_a_ground_date, the_indeterminate_constructor_holds_for_one_key, the_needs_legal_review_constructor_holds_for_its_shape, the_input_problems_constructor_holds_for_a_problem_list, the_unknown_key_constructor_holds_for_a_ground_key, the_wrong_type_constructor_holds_for_a_key, the_duplicate_key_constructor_holds_for_a_key]).
cp_test_fail_names([every_other_bound_status_is_rejected, the_placeholder_citation_is_gone, an_unrecorded_key_marks_nothing, two_distinct_verdict_atoms_do_not_unify, the_date_constructor_does_not_hold_for_a_non_integer, the_indeterminate_constructor_does_not_hold_for_no_key, the_needs_legal_review_constructor_does_not_hold_for_another_shape, the_input_problems_constructor_does_not_hold_for_no_problem, the_wrong_type_constructor_does_not_hold_for_a_number, the_duplicate_key_constructor_does_not_hold_for_a_number]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
