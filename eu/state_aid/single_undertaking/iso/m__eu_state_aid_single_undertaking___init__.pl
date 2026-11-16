% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_citations, [citation/2, implements/1]).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [decide_single_undertaking/2, direct_relationship/3, directly_related/0, duplicate_key/1, indeterminate/1, input_problems/1, members_settled/0, needs_legal_review/2, not_directly_related/0, not_single_undertaking/0, provenance/2, relationship/4, same_single_undertaking/3, single_undertaking/0, single_undertaking_checklist/2, single_undertaking_decision_resolvable/1, single_undertaking_members/4, single_undertaking_status/2, single_undertaking_status_values/1, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_state_aid_single_undertaking_queries, [single_undertaking_profile_keys/1, single_undertaking_what_if/4]).
:- use_module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_assess/2, single_undertaking_profile_for/2, single_undertaking_subject/1]).

root_export(controls_majority_of_voting_rights_alone_by_agreement).
root_export(directly_related).
root_export(dominant_influence_by_contract_or_articles).
root_export(first_enterprise).
root_export(held_is_an_enterprise).
root_export(holder_is_an_enterprise).
root_export(holder_is_shareholder_or_member).
root_export(inputs_relied_on).
root_export(members_settled).
root_export(not_directly_related).
root_export(not_single_undertaking).
root_export(open_textured).
root_export(point_a).
root_export(point_b).
root_export(point_c).
root_export(point_d).
root_export(relationships).
root_export(relationships_complete).
root_export(right_to_appoint_or_remove_majority_of_board).
root_export(second_enterprise).
root_export(single_undertaking).
root_export(unsure).
root_export(voting_rights_held).
root_export(voting_rights_total).
