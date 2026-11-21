% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3, dora_ict_third_party_entity_duties_status/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_profile_for/2]).

subject_profile(Subject, Profile) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile).

checked_citations([cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6), cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]).

test(complete_holds_with_result_and_citations_bound) :-
    subject_profile(plain_arrangement_complete, Profile),
    checked_citations(Citations),
    entity_duties_complete(Profile, complete, Citations).
test(incomplete_holds_bound_for_the_near_miss) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    checked_citations(Citations),
    entity_duties_complete(Profile, incomplete, Citations).
test(indeterminate_holds_bound_with_its_key) :-
    subject_profile(critical_arrangement_exit_strategy_unanswered, Profile),
    entity_duties_complete(Profile, indeterminate([exit_strategy_in_place]), []).
test(required_holds_bound_for_the_plain_arrangement) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_required(Profile, required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards]), [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5)]).
test(outstanding_holds_bound_for_the_near_miss) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    entity_duties_outstanding(Profile, outstanding([assessment_of_supervisory_conditions]), [cite(eu_reg_2022_2554_art_28_4_b)]).
test(strategy_required_holds_bound) :-
    subject_profile(plain_arrangement_complete, Profile),
    ict_third_party_strategy_required(Profile, strategy_required, [cite(eu_reg_2022_2554_art_28_2)]).
test(status_holds_with_the_verdict_bound) :-
    subject_profile(critical_arrangement_complete, Profile),
    dora_ict_third_party_entity_duties_status(Profile, complete).
test(an_unbound_profile_is_refused) :-
    findall(Result - Citations, entity_duties_complete(_Unbound, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_partial_list_is_refused) :-
    findall(Result - Citations, entity_duties_required([attribute(exit_strategy_in_place, true)|_Tail], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(an_atom_profile_is_refused) :-
    findall(Result, ict_third_party_strategy_required(not_a_list, Result, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(an_unbound_value_is_wrong_type) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(exit_strategy_in_place, _Value)], Problems),
    Problems == [wrong_type(exit_strategy_in_place)].
test(a_compound_key_is_named_as_given) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(unexpected(key), true)], Problems),
    Problems == [unknown_key(unexpected(key))].
test(the_empty_profile_has_no_problem) :-
    dora_ict_third_party_entity_duties_input_problems([], []).

test(incomplete_bound_is_rejected_for_a_complete_profile, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(complete_bound_is_rejected_for_the_near_miss, fail) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    entity_duties_complete(Profile, complete, _).
test(indeterminate_bound_with_a_behind_key_is_rejected, fail) :-
    subject_profile(critical_arrangement_exit_strategy_unanswered, Profile),
    entity_duties_complete(Profile, indeterminate([arrangement_entails_high_technical_complexity]), _).
test(required_bound_with_a_shorter_list_is_rejected, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_required(Profile, required([assessment_of_critical_or_important_function]), _).
test(none_outstanding_bound_is_rejected_for_the_near_miss, fail) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    entity_duties_outstanding(Profile, none_outstanding, _).
test(strategy_not_required_bound_is_rejected, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    ict_third_party_strategy_required(Profile, strategy_not_required, _).
test(another_bound_status_is_rejected, fail) :-
    subject_profile(critical_arrangement_complete, Profile),
    dora_ict_third_party_entity_duties_status(Profile, incomplete).
test(the_empty_profile_has_no_problem_bound_as_a_list, fail) :-
    dora_ict_third_party_entity_duties_input_problems([], [_|_]).

cp_test_names([complete_holds_with_result_and_citations_bound, incomplete_holds_bound_for_the_near_miss, indeterminate_holds_bound_with_its_key, required_holds_bound_for_the_plain_arrangement, outstanding_holds_bound_for_the_near_miss, strategy_required_holds_bound, status_holds_with_the_verdict_bound, an_unbound_profile_is_refused, a_partial_list_is_refused, an_atom_profile_is_refused, an_unbound_value_is_wrong_type, a_compound_key_is_named_as_given, the_empty_profile_has_no_problem]).
cp_test_fail_names([incomplete_bound_is_rejected_for_a_complete_profile, complete_bound_is_rejected_for_the_near_miss, indeterminate_bound_with_a_behind_key_is_rejected, required_bound_with_a_shorter_list_is_rejected, none_outstanding_bound_is_rejected_for_the_near_miss, strategy_not_required_bound_is_rejected, another_bound_status_is_rejected, the_empty_profile_has_no_problem_bound_as_a_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
