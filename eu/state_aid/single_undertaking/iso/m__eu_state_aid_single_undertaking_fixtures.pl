% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_subject/1, single_undertaking_profile_for/2, single_undertaking_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [decide_single_undertaking/2]).

single_undertaking_subject(majority_fifty_one_of_one_hundred).
single_undertaking_subject(just_over_half_fifty_of_ninety_nine).
single_undertaking_subject(exactly_half_fifty_of_one_hundred).
single_undertaking_subject(one_of_one_voting_right).
single_undertaking_subject(no_voting_rights_held).
single_undertaking_subject(board_right_held).
single_undertaking_subject(board_right_denied).
single_undertaking_subject(holder_not_an_enterprise).
single_undertaking_subject(dominant_influence_affirmed).
single_undertaking_subject(dominant_influence_unsure).
single_undertaking_subject(sole_control_by_agreement).
single_undertaking_subject(shareholder_without_agreement).
single_undertaking_subject(holder_enterprise_status_unsure).
single_undertaking_subject(held_enterprise_judgement_missing).
single_undertaking_subject(sisters_through_common_holder).
single_undertaking_subject(sisters_through_unsure_link).
single_undertaking_subject(sisters_without_link).
single_undertaking_subject(two_holders_of_one_enterprise).
single_undertaking_subject(parent_and_subsidiary_direct).
single_undertaking_subject(same_enterprise_twice).
single_undertaking_subject(relationship_list_incomplete).
single_undertaking_subject(relationship_list_missing).
single_undertaking_subject(members_through_chain).
single_undertaking_subject(members_direct_only).
single_undertaking_subject(members_through_unsure_link).
single_undertaking_subject(members_list_incomplete).
single_undertaking_subject(unknown_key_given).
single_undertaking_subject(duplicate_key_given).
single_undertaking_subject(zero_total_voting_rights).
single_undertaking_subject(held_above_total_voting_rights).
single_undertaking_subject(held_equal_to_total_voting_rights).
single_undertaking_subject(unbound_profile).
single_undertaking_subject(number_as_key).

single_undertaking_profile_for(majority_fifty_one_of_one_hundred, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 51), attribute(voting_rights_total, 100)]).
single_undertaking_profile_for(just_over_half_fifty_of_ninety_nine, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 50), attribute(voting_rights_total, 99)]).
single_undertaking_profile_for(exactly_half_fifty_of_one_hundred, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 50), attribute(voting_rights_total, 100), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)]).
single_undertaking_profile_for(one_of_one_voting_right, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 1), attribute(voting_rights_total, 1)]).
single_undertaking_profile_for(no_voting_rights_held, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)]).
single_undertaking_profile_for(board_right_held, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)]).
single_undertaking_profile_for(board_right_denied, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)]).
single_undertaking_profile_for(holder_not_an_enterprise, [attribute(holder_is_an_enterprise, false), attribute(held_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)]).
single_undertaking_profile_for(dominant_influence_affirmed, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, true), attribute(holder_is_shareholder_or_member, false)]).
single_undertaking_profile_for(dominant_influence_unsure, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(holder_is_shareholder_or_member, false)]).
single_undertaking_profile_for(sole_control_by_agreement, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(holder_is_shareholder_or_member, true), attribute(controls_majority_of_voting_rights_alone_by_agreement, true)]).
single_undertaking_profile_for(shareholder_without_agreement, [attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, true), attribute(controls_majority_of_voting_rights_alone_by_agreement, false)]).
single_undertaking_profile_for(holder_enterprise_status_unsure, [attribute(holder_is_an_enterprise, unsure), attribute(held_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)]).
single_undertaking_profile_for(held_enterprise_judgement_missing, [attribute(holder_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)]).
single_undertaking_profile_for(sisters_through_common_holder, [attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, true)])]).
single_undertaking_profile_for(sisters_through_unsure_link, [attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, unsure)]), attribute(relationships_complete, true)]).
single_undertaking_profile_for(sisters_without_link, [attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, true)]).
single_undertaking_profile_for(two_holders_of_one_enterprise, [attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(gamma, beta, point_d, true)])]).
single_undertaking_profile_for(parent_and_subsidiary_direct, [attribute(first_enterprise, beta), attribute(second_enterprise, alpha), attribute(relationships, [relationship(alpha, beta, point_d, true)])]).
single_undertaking_profile_for(same_enterprise_twice, [attribute(first_enterprise, alpha), attribute(second_enterprise, alpha)]).
single_undertaking_profile_for(relationship_list_incomplete, [attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, false)]).
single_undertaking_profile_for(relationship_list_missing, [attribute(first_enterprise, alpha), attribute(second_enterprise, beta)]).
single_undertaking_profile_for(members_through_chain, [attribute(first_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(beta, gamma, point_d, true), relationship(delta, epsilon, point_c, true)]), attribute(relationships_complete, true)]).
single_undertaking_profile_for(members_direct_only, [attribute(first_enterprise, alpha), attribute(relationships, [relationship(alpha, beta, point_b, true)]), attribute(relationships_complete, true)]).
single_undertaking_profile_for(members_through_unsure_link, [attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, unsure)]), attribute(relationships_complete, true)]).
single_undertaking_profile_for(members_list_incomplete, [attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true)])]).
single_undertaking_profile_for(unknown_key_given, [attribute(colour, red)]).
single_undertaking_profile_for(duplicate_key_given, [attribute(first_enterprise, alpha), attribute(first_enterprise, beta)]).
single_undertaking_profile_for(zero_total_voting_rights, [attribute(voting_rights_held, 0), attribute(voting_rights_total, 0)]).
single_undertaking_profile_for(held_above_total_voting_rights, [attribute(voting_rights_held, 4), attribute(voting_rights_total, 3)]).
single_undertaking_profile_for(held_equal_to_total_voting_rights, [attribute(voting_rights_held, 3), attribute(voting_rights_total, 3)]).
single_undertaking_profile_for(unbound_profile, _UnboundProfile).
single_undertaking_profile_for(number_as_key, [attribute(7, alpha)]).

single_undertaking_assess(Subject, Result) :-
    single_undertaking_profile_for(Subject, Profile),
    decide_single_undertaking(Profile, Result).
