% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [direct_relationship/3, same_single_undertaking/3, single_undertaking_members/4, single_undertaking_status/2]).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_profile_for/2]).

test(a_majority_holds_with_the_result_and_citations_bound) :-
    single_undertaking_profile_for(majority_fifty_one_of_one_hundred, Profile),
    direct_relationship(Profile, directly_related, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)]).
test(exactly_half_holds_with_not_directly_related_bound) :-
    single_undertaking_profile_for(exactly_half_fifty_of_one_hundred, Profile),
    direct_relationship(Profile, not_directly_related, [cite(eu_reg_2023_2831_art_2_2)]).
test(a_bound_missing_key_is_accepted) :-
    single_undertaking_profile_for(held_enterprise_judgement_missing, Profile),
    direct_relationship(Profile, indeterminate([held_is_an_enterprise]), []).
test(a_bound_referral_is_accepted) :-
    single_undertaking_profile_for(dominant_influence_unsure, Profile),
    direct_relationship(Profile, needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([holder_is_an_enterprise - true, held_is_an_enterprise - true, dominant_influence_by_contract_or_articles - unsure])]), []).
test(sisters_hold_with_single_undertaking_bound) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    same_single_undertaking(Profile, single_undertaking, _).
test(unlinked_sisters_hold_with_not_single_undertaking_bound) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    same_single_undertaking(Profile, not_single_undertaking, [cite(eu_reg_2023_2831_art_2_2)]).
test(the_members_hold_with_the_group_bound) :-
    single_undertaking_profile_for(members_through_chain, Profile),
    single_undertaking_members(Profile, members_settled, [alpha, beta, gamma], _).
test(an_incomplete_list_holds_with_empty_members_bound) :-
    single_undertaking_profile_for(members_list_incomplete, Profile),
    single_undertaking_members(Profile, indeterminate([relationships_complete]), [], []).
test(the_status_holds_with_the_verdict_bound) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    single_undertaking_status(Profile, single_undertaking).
test(the_input_check_holds_with_the_problems_bound) :-
    single_undertaking_profile_for(unknown_key_given, Profile),
    single_undertaking_input_problems(Profile, [unknown_key(colour)]).
test(a_profile_that_is_not_an_attribute_list_answers_input_problems) :-
    direct_relationship(not_a_profile, input_problems([wrong_type(profile)]), []).

test(a_majority_rejects_not_directly_related_bound, fail) :-
    single_undertaking_profile_for(majority_fifty_one_of_one_hundred, Profile),
    direct_relationship(Profile, not_directly_related, _).
test(exactly_half_rejects_directly_related_bound, fail) :-
    single_undertaking_profile_for(exactly_half_fifty_of_one_hundred, Profile),
    direct_relationship(Profile, directly_related, _).
test(a_bound_wrong_missing_key_is_rejected, fail) :-
    single_undertaking_profile_for(held_enterprise_judgement_missing, Profile),
    direct_relationship(Profile, indeterminate([holder_is_an_enterprise]), _).
test(a_bound_referral_with_the_wrong_citation_is_rejected, fail) :-
    single_undertaking_profile_for(dominant_influence_unsure, Profile),
    direct_relationship(Profile, needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2)), _), _).
test(sisters_reject_not_single_undertaking_bound, fail) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    same_single_undertaking(Profile, not_single_undertaking, _).
test(unlinked_sisters_reject_single_undertaking_bound, fail) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    same_single_undertaking(Profile, single_undertaking, _).
test(a_short_member_list_is_rejected, fail) :-
    single_undertaking_profile_for(members_through_chain, Profile),
    single_undertaking_members(Profile, members_settled, [beta, gamma], _).
test(an_incomplete_list_rejects_settled_members, fail) :-
    single_undertaking_profile_for(members_list_incomplete, Profile),
    single_undertaking_members(Profile, members_settled, _, _).
test(the_wrong_bound_status_is_rejected, fail) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    single_undertaking_status(Profile, not_single_undertaking).
test(the_input_check_rejects_no_problem_bound, fail) :-
    single_undertaking_profile_for(unknown_key_given, Profile),
    single_undertaking_input_problems(Profile, []).
test(a_profile_that_is_not_an_attribute_list_gets_no_settled_answer, fail) :-
    same_single_undertaking(not_a_profile, not_single_undertaking, _).

cp_test_names([a_majority_holds_with_the_result_and_citations_bound, exactly_half_holds_with_not_directly_related_bound, a_bound_missing_key_is_accepted, a_bound_referral_is_accepted, sisters_hold_with_single_undertaking_bound, unlinked_sisters_hold_with_not_single_undertaking_bound, the_members_hold_with_the_group_bound, an_incomplete_list_holds_with_empty_members_bound, the_status_holds_with_the_verdict_bound, the_input_check_holds_with_the_problems_bound, a_profile_that_is_not_an_attribute_list_answers_input_problems]).
cp_test_fail_names([a_majority_rejects_not_directly_related_bound, exactly_half_rejects_directly_related_bound, a_bound_wrong_missing_key_is_rejected, a_bound_referral_with_the_wrong_citation_is_rejected, sisters_reject_not_single_undertaking_bound, unlinked_sisters_reject_single_undertaking_bound, a_short_member_list_is_rejected, an_incomplete_list_rejects_settled_members, the_wrong_bound_status_is_rejected, the_input_check_rejects_no_problem_bound, a_profile_that_is_not_an_attribute_list_gets_no_settled_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
