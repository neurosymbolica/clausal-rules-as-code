% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [direct_relationship/3, same_single_undertaking/3, single_undertaking_members/4, single_undertaking_status/2, single_undertaking_status_values/1]).
:- use_module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_profile_for/2]).

direct_result(Subject, Result) :-
    single_undertaking_profile_for(Subject, Profile),
    direct_relationship(Profile, Result, _Citations).

same_result(Subject, Result) :-
    single_undertaking_profile_for(Subject, Profile),
    same_single_undertaking(Profile, Result, _Citations).

test(single_undertaking_is_a_verdict_atom) :-
    single_undertaking_status_values(StatusValues),
    member(single_undertaking, StatusValues).
test(not_single_undertaking_is_a_verdict_atom) :-
    single_undertaking_status_values(StatusValues),
    member(not_single_undertaking, StatusValues).
test(enterprise_false_positive) :-
    direct_result(holder_not_an_enterprise, Result),
    Result == not_directly_related.
test(enterprise_true_near_miss_flips) :-
    direct_result(board_right_held, Result),
    Result == directly_related.
test(point_a_exactly_half_positive) :-
    direct_result(exactly_half_fifty_of_one_hundred, Result),
    Result == not_directly_related.
test(point_a_one_more_vote_flips) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 51), attribute(voting_rights_total, 100), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], Result, Citations),
    Result == directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)].
test(point_b_denied_positive) :-
    direct_result(board_right_denied, Result),
    Result == not_directly_related.
test(point_b_held_flips) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, true), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], Result, Citations),
    Result == directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_b)].
test(point_c_affirmed_positive) :-
    direct_result(dominant_influence_affirmed, Result),
    Result == directly_related.
test(point_c_unsure_flips_to_a_lawyer) :-
    direct_result(dominant_influence_unsure, Result),
    Result = needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), _).
test(point_d_without_agreement_positive) :-
    direct_result(shareholder_without_agreement, Result),
    Result == not_directly_related.
test(point_d_with_agreement_flips) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, true), attribute(controls_majority_of_voting_rights_alone_by_agreement, true)], Result, Citations),
    Result == directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_d)].
test(missing_held_judgement_positive) :-
    direct_result(held_enterprise_judgement_missing, Result),
    Result == indeterminate([held_is_an_enterprise]).
test(given_held_judgement_flips) :-
    direct_result(board_right_held, Result),
    Result == directly_related.
test(unsure_holder_positive) :-
    direct_result(holder_enterprise_status_unsure, Result),
    Result = needs_legal_review(open_textured(holder_is_an_enterprise, cite(eu_reg_2023_2831_art_2_2)), _).
test(certain_holder_flips) :-
    direct_result(board_right_held, Result),
    Result == directly_related.
test(missing_second_name_positive) :-
    same_single_undertaking([attribute(first_enterprise, alpha)], Result, _),
    Result == indeterminate([second_enterprise]).
test(given_second_name_flips) :-
    same_result(same_enterprise_twice, Result),
    Result == single_undertaking.
test(same_enterprise_positive) :-
    same_result(same_enterprise_twice, Result),
    Result == single_undertaking.
test(different_enterprises_flip_to_asking_for_the_list) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, beta)], Result, _),
    Result == indeterminate([relationships]).
test(chain_positive) :-
    same_result(sisters_through_common_holder, Result),
    Result == single_undertaking.
test(no_chain_flips) :-
    same_result(sisters_without_link, Result),
    Result == not_single_undertaking.
test(indirect_join_cites_the_closing_sentence) :-
    single_undertaking_profile_for(sisters_through_common_holder, Profile),
    same_single_undertaking(Profile, single_undertaking, Citations),
    member(cite(eu_reg_2023_2831_art_2_t1), Citations).
test(direct_join_is_one_single_undertaking) :-
    same_result(parent_and_subsidiary_direct, Result),
    Result == single_undertaking.
test(incomplete_list_positive) :-
    same_result(relationship_list_incomplete, Result),
    Result == indeterminate([relationships_complete]).
test(complete_list_flips) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, true)], Result, _),
    Result == not_single_undertaking.
test(unsure_link_positive) :-
    same_result(sisters_through_unsure_link, Result),
    Result = needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), _).
test(certain_link_flips) :-
    same_single_undertaking([attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, true)]), attribute(relationships_complete, true)], Result, _),
    Result == single_undertaking.
test(members_incomplete_positive) :-
    single_undertaking_profile_for(members_list_incomplete, Profile),
    single_undertaking_members(Profile, Result, Members, _),
    Result == indeterminate([relationships_complete]),
    Members == [].
test(members_complete_flips) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true)]), attribute(relationships_complete, true)], Result, Members, _),
    Result == members_settled,
    Members == [beta, gamma].
test(members_unsure_link_positive) :-
    single_undertaking_profile_for(members_through_unsure_link, Profile),
    single_undertaking_members(Profile, Result, Members, _),
    Result = needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), _),
    Members == [].
test(members_certain_link_flips) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, true)]), attribute(relationships_complete, true)], Result, Members, _),
    Result == members_settled,
    Members == [beta, gamma, zeta].
test(duplicate_key_positive) :-
    same_result(duplicate_key_given, Result),
    Result == input_problems([duplicate_key(first_enterprise)]).
test(single_key_flips) :-
    same_single_undertaking([attribute(first_enterprise, alpha)], Result, _),
    Result == indeterminate([second_enterprise]).
test(status_near_miss_positive) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    single_undertaking_status(Profile, not_single_undertaking).

test(enterprise_true_near_miss_is_not_unrelated, fail) :-
    direct_result(board_right_held, not_directly_related).
test(point_a_one_more_vote_is_not_unrelated, fail) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 51), attribute(voting_rights_total, 100), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], not_directly_related, _).
test(point_b_held_is_not_unrelated, fail) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, true), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], not_directly_related, _).
test(point_c_unsure_is_not_directly_related, fail) :-
    direct_result(dominant_influence_unsure, directly_related).
test(point_d_with_agreement_is_not_unrelated, fail) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, true), attribute(controls_majority_of_voting_rights_alone_by_agreement, true)], not_directly_related, _).
test(given_held_judgement_is_not_indeterminate, fail) :-
    direct_result(board_right_held, indeterminate(_)).
test(certain_holder_is_not_referred, fail) :-
    direct_result(board_right_held, needs_legal_review(_, _)).
test(given_second_name_is_not_indeterminate, fail) :-
    same_result(same_enterprise_twice, indeterminate(_)).
test(different_enterprises_without_a_list_are_not_one, fail) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, beta)], single_undertaking, _).
test(no_chain_is_not_one_single_undertaking, fail) :-
    same_result(sisters_without_link, single_undertaking).
test(direct_join_cites_no_closing_sentence, fail) :-
    single_undertaking_profile_for(parent_and_subsidiary_direct, Profile),
    same_single_undertaking(Profile, _, Citations),
    member(cite(eu_reg_2023_2831_art_2_t1), Citations).
test(complete_list_is_not_indeterminate, fail) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, true)], indeterminate(_), _).
test(certain_link_is_not_referred, fail) :-
    same_single_undertaking([attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, true)]), attribute(relationships_complete, true)], needs_legal_review(_, _), _).
test(members_complete_is_not_indeterminate, fail) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true)]), attribute(relationships_complete, true)], indeterminate(_), _, _).
test(members_certain_link_is_not_referred, fail) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, true)]), attribute(relationships_complete, true)], needs_legal_review(_, _), _, _).
test(single_key_has_no_input_problem, fail) :-
    same_single_undertaking([attribute(first_enterprise, alpha)], input_problems(_), _).
test(status_near_miss_is_not_single_undertaking, fail) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    single_undertaking_status(Profile, single_undertaking).

cp_test_names([single_undertaking_is_a_verdict_atom, not_single_undertaking_is_a_verdict_atom, enterprise_false_positive, enterprise_true_near_miss_flips, point_a_exactly_half_positive, point_a_one_more_vote_flips, point_b_denied_positive, point_b_held_flips, point_c_affirmed_positive, point_c_unsure_flips_to_a_lawyer, point_d_without_agreement_positive, point_d_with_agreement_flips, missing_held_judgement_positive, given_held_judgement_flips, unsure_holder_positive, certain_holder_flips, missing_second_name_positive, given_second_name_flips, same_enterprise_positive, different_enterprises_flip_to_asking_for_the_list, chain_positive, no_chain_flips, indirect_join_cites_the_closing_sentence, direct_join_is_one_single_undertaking, incomplete_list_positive, complete_list_flips, unsure_link_positive, certain_link_flips, members_incomplete_positive, members_complete_flips, members_unsure_link_positive, members_certain_link_flips, duplicate_key_positive, single_key_flips, status_near_miss_positive]).
cp_test_fail_names([enterprise_true_near_miss_is_not_unrelated, point_a_one_more_vote_is_not_unrelated, point_b_held_is_not_unrelated, point_c_unsure_is_not_directly_related, point_d_with_agreement_is_not_unrelated, given_held_judgement_is_not_indeterminate, certain_holder_is_not_referred, given_second_name_is_not_indeterminate, different_enterprises_without_a_list_are_not_one, no_chain_is_not_one_single_undertaking, direct_join_cites_no_closing_sentence, complete_list_is_not_indeterminate, certain_link_is_not_referred, members_complete_is_not_indeterminate, members_certain_link_is_not_referred, single_key_has_no_input_problem, status_near_miss_is_not_single_undertaking]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
