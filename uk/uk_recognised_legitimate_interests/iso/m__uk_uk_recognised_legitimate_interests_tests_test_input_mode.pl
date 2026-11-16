% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_uk_recognised_legitimate_interests, [uk_recognised_legitimate_interests_status/2, recognised_legitimate_interest/3, uk_legitimate_interests/3, uk_legitimate_interest_basis/3, eu_legitimate_interests/3, compare_uk_eu_legitimate_interest_basis/5, uk_right_to_object/3]).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_fixtures, [uk_recognised_legitimate_interests_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    uk_recognised_legitimate_interests_status(Profile, recognised_legitimate_interest_applies).
test(public_authority_bar_bound_with_its_citation) :-
    uk_recognised_legitimate_interests_profile_for(public_authority_bar, Profile),
    recognised_legitimate_interest(Profile, recognised_legitimate_interest_does_not_apply, [cite(uk_gdpr_art_6_1)]).
test(uk_legitimate_interests_bound) :-
    uk_recognised_legitimate_interests_profile_for(interests_apply, Profile),
    uk_legitimate_interests(Profile, legitimate_interests_applies, [cite(uk_gdpr_art_6_1_f)]).
test(eu_legitimate_interests_bound) :-
    uk_recognised_legitimate_interests_profile_for(interests_apply, Profile),
    eu_legitimate_interests(Profile, legitimate_interests_applies, [cite(eu_reg_2016_679_art_6_1_f)]).
test(eu_bar_bound_cites_the_eu_paragraph) :-
    uk_recognised_legitimate_interests_profile_for(public_authority_bar, Profile),
    eu_legitimate_interests(Profile, legitimate_interests_does_not_apply, [cite(eu_reg_2016_679_art_6_1)]).
test(basis_bound_available) :-
    uk_recognised_legitimate_interests_profile_for(interests_apply, Profile),
    uk_legitimate_interest_basis(Profile, legitimate_interest_basis_available, [cite(uk_gdpr_art_6_1_f)]).
test(comparison_bound_differs) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, legitimate_interest_basis_available, legitimate_interest_basis_not_available, differs, _ChangedBy).
test(objection_bound_must_stop) :-
    uk_recognised_legitimate_interests_profile_for(objection_must_stop, Profile),
    uk_right_to_object(Profile, controller_must_no_longer_process, [cite(uk_gdpr_art_21_1)]).
test(reordered_profile_gives_the_same_answer) :-
    findall(Result, recognised_legitimate_interest([attribute(processing_necessary_for_national_security_public_security_or_defence, true), attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, false)], Result, _Citations), Results),
    Results == [recognised_legitimate_interest_applies].
test(non_attribute_element_is_wrong_type_alone) :-
    uk_recognised_legitimate_interests_input_problems([attribute(foo, 1), individual_aged_under_18], Problems),
    Problems == [wrong_type(profile)].
test(non_list_profile_is_wrong_type) :-
    uk_recognised_legitimate_interests_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(number_key_is_unknown_key) :-
    uk_recognised_legitimate_interests_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(repeated_unknown_key_is_named_once) :-
    uk_recognised_legitimate_interests_input_problems([attribute(foo, 1), attribute(foo, 2)], Problems),
    Problems == [unknown_key(foo)].
test(enumeration_key_outside_its_atoms_is_wrong_type) :-
    uk_recognised_legitimate_interests_input_problems([attribute(basis_relied_on, consent)], Problems),
    Problems == [wrong_type(basis_relied_on)].
test(judgement_key_accepts_unsure) :-
    uk_recognised_legitimate_interests_input_problems([attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, unsure)], Problems),
    Problems == [].
test(problems_follow_contract_order_then_unknown_keys) :-
    uk_recognised_legitimate_interests_input_problems([attribute(zzz, 1), attribute(basis_relied_on, bad), attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, true), attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, false)], Problems),
    Problems == [duplicate_key(processing_by_a_public_authority_in_the_performance_of_its_tasks), wrong_type(basis_relied_on), unknown_key(zzz)].
test(duplicate_key_is_never_also_wrong_type) :-
    uk_recognised_legitimate_interests_input_problems([attribute(individual_aged_under_18, bad), attribute(individual_aged_under_18, worse)], Problems),
    Problems == [duplicate_key(individual_aged_under_18)].
test(empty_profile_has_no_problem) :-
    uk_recognised_legitimate_interests_input_problems([], Problems),
    Problems == [].
test(unbound_profile_query_gives_one_input_problems_answer) :-
    findall(Result - Citations, recognised_legitimate_interest(_Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(all_queries_bound_to_input_problems) :-
    uk_recognised_legitimate_interests_profile_for(crisp_key_wrong_type, Profile),
    recognised_legitimate_interest(Profile, input_problems([wrong_type(individual_aged_under_18)]), []),
    uk_legitimate_interests(Profile, input_problems([wrong_type(individual_aged_under_18)]), []),
    uk_legitimate_interest_basis(Profile, input_problems([wrong_type(individual_aged_under_18)]), []),
    eu_legitimate_interests(Profile, input_problems([wrong_type(individual_aged_under_18)]), []),
    compare_uk_eu_legitimate_interest_basis(Profile, input_problems([wrong_type(individual_aged_under_18)]), input_problems([wrong_type(individual_aged_under_18)]), not_comparable, []),
    uk_right_to_object(Profile, input_problems([wrong_type(individual_aged_under_18)]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    uk_recognised_legitimate_interests_status(Profile, recognised_legitimate_interest_does_not_apply).
test(comparison_bound_same_is_rejected_when_it_differs, fail) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, same, _ChangedBy).
test(objection_bound_continue_is_rejected_when_it_must_stop, fail) :-
    uk_recognised_legitimate_interests_profile_for(objection_must_stop, Profile),
    uk_right_to_object(Profile, controller_may_continue_processing, _Citations).
test(input_problem_profile_gets_no_final_answer, fail) :-
    uk_recognised_legitimate_interests_profile_for(crisp_key_wrong_type, Profile),
    recognised_legitimate_interest(Profile, recognised_legitimate_interest_does_not_apply, _Citations).

cp_test_names([status_holds_with_the_verdict_bound, public_authority_bar_bound_with_its_citation, uk_legitimate_interests_bound, eu_legitimate_interests_bound, eu_bar_bound_cites_the_eu_paragraph, basis_bound_available, comparison_bound_differs, objection_bound_must_stop, reordered_profile_gives_the_same_answer, non_attribute_element_is_wrong_type_alone, non_list_profile_is_wrong_type, number_key_is_unknown_key, repeated_unknown_key_is_named_once, enumeration_key_outside_its_atoms_is_wrong_type, judgement_key_accepts_unsure, problems_follow_contract_order_then_unknown_keys, duplicate_key_is_never_also_wrong_type, empty_profile_has_no_problem, unbound_profile_query_gives_one_input_problems_answer, all_queries_bound_to_input_problems]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, comparison_bound_same_is_rejected_when_it_differs, objection_bound_continue_is_rejected_when_it_must_stop, input_problem_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
