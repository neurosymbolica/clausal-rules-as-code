% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_single_undertaking, [direct_relationship/3, same_single_undertaking/3, single_undertaking_members/4, directly_related/0, not_directly_related/0, single_undertaking/0, not_single_undertaking/0, members_settled/0, indeterminate/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, relationship/4, decide_single_undertaking/2, single_undertaking_status/2, single_undertaking_checklist/2, single_undertaking_decision_resolvable/1, single_undertaking_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3, is_list/1]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_citations, [implements/1]).

directly_related.

not_directly_related.

single_undertaking.

not_single_undertaking.

members_settled.

provenance(_Clause, Citations) :-
    nonvar(Citations).
provenance(_Clause, Citations) :-
    var(Citations),
    Citations = [cite(eu_reg_2023_2831_art_2_2)].

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(Input, cite(CitationKey)), Context) :-
    atom(Input),
    atom(CitationKey),
    is_list(Context),
    Context = [inputs_relied_on(Pairs)|_],
    is_list(Pairs).

input_problems(Problems) :-
    is_list(Problems),
    Problems = [_|_].

unknown_key(GivenKey) :-
    nonvar(GivenKey).

wrong_type(ContractKey) :-
    atom(ContractKey).

duplicate_key(ContractKey) :-
    atom(ContractKey).

relationship(HolderEnterprise, HeldEnterprise, LimbAtom, Certainty) :-
    atom(HolderEnterprise),
    atom(HeldEnterprise),
    atom(LimbAtom),
    member(LimbAtom, [point_a, point_b, point_c, point_d]),
    atom(Certainty),
    member(Certainty, [true, unsure]).

limb_citation(point_a, cite(eu_reg_2023_2831_art_2_2_a)).
limb_citation(point_b, cite(eu_reg_2023_2831_art_2_2_b)).
limb_citation(point_c, cite(eu_reg_2023_2831_art_2_2_c)).
limb_citation(point_d, cite(eu_reg_2023_2831_art_2_2_d)).

referral_row(holder_enterprise_status_unsure, holder_is_an_enterprise, cite(eu_reg_2023_2831_art_2_2), [holder_is_an_enterprise, held_is_an_enterprise, dominant_influence_by_contract_or_articles]).
referral_row(held_enterprise_status_unsure, held_is_an_enterprise, cite(eu_reg_2023_2831_art_2_2), [holder_is_an_enterprise, held_is_an_enterprise, dominant_influence_by_contract_or_articles]).
referral_row(dominant_influence_unsure, dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c), [holder_is_an_enterprise, held_is_an_enterprise, dominant_influence_by_contract_or_articles]).
referral_row(joined_only_through_unsure_relationship, relationships, cite(eu_reg_2023_2831_art_2_2), [relationships]).
referral_row(member_only_through_unsure_relationship, relationships, cite(eu_reg_2023_2831_art_2_2), [relationships]).

single_undertaking_status_values([single_undertaking, not_single_undertaking]).

key_reading(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_reading(Profile, ProfileKey, present(Value)) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

present_pairs([], _, []).
present_pairs([ProfileKey|ProfileKeys], Profile, Pairs) :-
    key_reading(Profile, ProfileKey, Reading),
    present_pairs(ProfileKeys, Profile, LaterPairs),
    add_pair(Reading, ProfileKey, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(present(Value), ProfileKey, Pairs, [ProfileKey - Value|Pairs]).

referral_result(Situation, Profile, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    referral_row(Situation, Input, Citation, Inputs),
    present_pairs(Inputs, Profile, Pairs).

either_true(true, _, true).
either_true(false, Truth, Truth).

both_true(true, Truth, Truth).
both_true(false, _, false).

truth_negated(true, false).
truth_negated(false, true).

same_atom_t(Enterprise, Enterprise, true).
same_atom_t(Enterprise, Other, false) :-
    dif(Enterprise, Other).

judgement_false_t(absent, false).
judgement_false_t(present(true), false).
judgement_false_t(present(false), true).
judgement_false_t(present(unsure), false).

judgement_true_t(absent, false).
judgement_true_t(present(true), true).
judgement_true_t(present(false), false).
judgement_true_t(present(unsure), false).

point_states(Profile, [point_a - StateA, point_b - StateB, point_c - StateC, point_d - StateD]) :-
    key_reading(Profile, voting_rights_held, HeldReading),
    key_reading(Profile, voting_rights_total, TotalReading),
    key_reading(Profile, right_to_appoint_or_remove_majority_of_board, BoardReading),
    key_reading(Profile, dominant_influence_by_contract_or_articles, DominantReading),
    key_reading(Profile, holder_is_shareholder_or_member, ShareholderReading),
    key_reading(Profile, controls_majority_of_voting_rights_alone_by_agreement, AgreementReading),
    point_a_state(HeldReading, TotalReading, StateA),
    point_b_state(BoardReading, StateB),
    point_c_state(DominantReading, StateC),
    point_d_state(ShareholderReading, AgreementReading, StateD).

point_a_state(present(0), _, fails) :-
    implements(eu_reg_2023_2831_art_2_2_a).
point_a_state(present(HeldVotingRights), present(TotalVotingRights), holds) :-
    implements(eu_reg_2023_2831_art_2_2_a),
    HeldVotingRights #> 0,
    2 * HeldVotingRights #> TotalVotingRights.
point_a_state(present(HeldVotingRights), present(TotalVotingRights), fails) :-
    implements(eu_reg_2023_2831_art_2_2_a),
    HeldVotingRights #> 0,
    2 * HeldVotingRights #=< TotalVotingRights.
point_a_state(present(HeldVotingRights), absent, open([voting_rights_total])) :-
    implements(eu_reg_2023_2831_art_2_2_a),
    HeldVotingRights #> 0.
point_a_state(absent, present(_), open([voting_rights_held])) :-
    implements(eu_reg_2023_2831_art_2_2_a).
point_a_state(absent, absent, open([voting_rights_held, voting_rights_total])) :-
    implements(eu_reg_2023_2831_art_2_2_a).

point_b_state(present(true), holds) :-
    implements(eu_reg_2023_2831_art_2_2_b).
point_b_state(present(false), fails) :-
    implements(eu_reg_2023_2831_art_2_2_b).
point_b_state(absent, open([right_to_appoint_or_remove_majority_of_board])) :-
    implements(eu_reg_2023_2831_art_2_2_b).

point_c_state(present(true), holds) :-
    implements(eu_reg_2023_2831_art_2_2_c).
point_c_state(present(false), fails) :-
    implements(eu_reg_2023_2831_art_2_2_c).
point_c_state(present(unsure), open([])) :-
    implements(eu_reg_2023_2831_art_2_2_c).
point_c_state(absent, open([dominant_influence_by_contract_or_articles])) :-
    implements(eu_reg_2023_2831_art_2_2_c).

point_d_state(present(true), present(true), holds) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(present(false), _, fails) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(present(true), present(false), fails) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(absent, present(false), fails) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(present(true), absent, open([controls_majority_of_voting_rights_alone_by_agreement])) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(absent, present(true), open([holder_is_shareholder_or_member])) :-
    implements(eu_reg_2023_2831_art_2_2_d).
point_d_state(absent, absent, open([holder_is_shareholder_or_member, controls_majority_of_voting_rights_alone_by_agreement])) :-
    implements(eu_reg_2023_2831_art_2_2_d).

any_point_holds_t([], false).
any_point_holds_t([_ - State|PointStates], Truth) :-
    state_holds_t(State, HereTruth),
    any_point_holds_t(PointStates, LaterTruth),
    either_true(HereTruth, LaterTruth, Truth).

state_holds_t(holds, true).
state_holds_t(fails, false).
state_holds_t(open(_), false).

every_point_fails_t([], true).
every_point_fails_t([_ - State|PointStates], Truth) :-
    state_fails_t(State, HereTruth),
    every_point_fails_t(PointStates, LaterTruth),
    both_true(HereTruth, LaterTruth, Truth).

state_fails_t(holds, false).
state_fails_t(fails, true).
state_fails_t(open(_), false).

holding_point_citations([], []).
holding_point_citations([Point - holds|PointStates], [Citation|Citations]) :-
    implements(eu_reg_2023_2831_art_2_2),
    limb_citation(Point, Citation),
    holding_point_citations(PointStates, Citations).
holding_point_citations([_ - fails|PointStates], Citations) :-
    holding_point_citations(PointStates, Citations).
holding_point_citations([_ - open(_)|PointStates], Citations) :-
    holding_point_citations(PointStates, Citations).

direct_relationship(Profile, Result, Citations) :-
    single_undertaking_input_problems(Profile, Problems),
    direct_relationship_checked(Problems, Profile, Result, Citations).

direct_relationship_checked([Problem|OtherProblems], _, input_problems([Problem|OtherProblems]), []).
direct_relationship_checked([], Profile, Result, Citations) :-
    key_reading(Profile, holder_is_an_enterprise, HolderStatus),
    key_reading(Profile, held_is_an_enterprise, HeldStatus),
    point_states(Profile, PointStates),
    judgement_false_t(HolderStatus, HolderFalse),
    judgement_false_t(HeldStatus, HeldFalse),
    either_true(HolderFalse, HeldFalse, EnterpriseFalse),
    direct_step_one(EnterpriseFalse, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations).

direct_step_one(true, _, _, _, _, not_directly_related, [cite(eu_reg_2023_2831_art_2_2)]) :-
    implements(eu_reg_2023_2831_art_2_2).
direct_step_one(false, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations) :-
    any_point_holds_t(PointStates, AnyHolds),
    judgement_true_t(HolderStatus, HolderTrue),
    judgement_true_t(HeldStatus, HeldTrue),
    both_true(HolderTrue, HeldTrue, BothEnterprises),
    both_true(AnyHolds, BothEnterprises, RelationshipShown),
    direct_step_two(RelationshipShown, AnyHolds, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations).

direct_step_two(true, _, _, _, PointStates, _, directly_related, [cite(eu_reg_2023_2831_art_2_2)|PointCitations]) :-
    implements(eu_reg_2023_2831_art_2_2),
    holding_point_citations(PointStates, PointCitations).
direct_step_two(false, AnyHolds, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations) :-
    every_point_fails_t(PointStates, AllFail),
    direct_step_three(AllFail, AnyHolds, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations).

direct_step_three(true, _, _, _, _, _, not_directly_related, [cite(eu_reg_2023_2831_art_2_2)]) :-
    implements(eu_reg_2023_2831_art_2_2).
direct_step_three(false, AnyHolds, HolderStatus, HeldStatus, PointStates, Profile, Result, Citations) :-
    direct_missing_key(HolderStatus, HeldStatus, AnyHolds, PointStates, Missing),
    direct_step_four(Missing, HolderStatus, HeldStatus, Profile, Result, Citations).

direct_step_four(key(MissingKey), _, _, _, indeterminate([MissingKey]), []).
direct_step_four(none, HolderStatus, HeldStatus, Profile, Result, []) :-
    key_reading(Profile, dominant_influence_by_contract_or_articles, DominantStatus),
    direct_referral_situation(HolderStatus, HeldStatus, DominantStatus, Situation),
    referral_result(Situation, Profile, Result).

direct_missing_key(absent, _, _, _, key(holder_is_an_enterprise)).
direct_missing_key(present(_), absent, _, _, key(held_is_an_enterprise)).
direct_missing_key(present(_), present(_), true, _, none).
direct_missing_key(present(_), present(_), false, PointStates, Missing) :-
    fewest_absent_keys(PointStates, none, Leader),
    leader_missing_key(Leader, Missing).

leader_missing_key(none, none).
leader_missing_key(leader(_, MissingKey), key(MissingKey)).

fewest_absent_keys([], Leader, Leader).
fewest_absent_keys([_ - State|PointStates], Leader, Final) :-
    fewer_absent(State, Leader, Improved),
    fewest_absent_keys(PointStates, Improved, Final).

fewer_absent(holds, Leader, Leader).
fewer_absent(fails, Leader, Leader).
fewer_absent(open([]), Leader, Leader).
fewer_absent(open([FirstKey|OtherKeys]), none, leader(Count, FirstKey)) :-
    length([FirstKey|OtherKeys], Count).
fewer_absent(open([FirstKey|OtherKeys]), leader(LeaderCount, LeaderKey), leader(LeaderCount, LeaderKey)) :-
    length([FirstKey|OtherKeys], Count),
    Count #>= LeaderCount.
fewer_absent(open([FirstKey|OtherKeys]), leader(LeaderCount, _), leader(Count, FirstKey)) :-
    length([FirstKey|OtherKeys], Count),
    Count #< LeaderCount.

direct_referral_situation(present(unsure), _, _, holder_enterprise_status_unsure) :-
    implements(eu_reg_2023_2831_art_2_2).
direct_referral_situation(present(true), present(unsure), _, held_enterprise_status_unsure) :-
    implements(eu_reg_2023_2831_art_2_2).
direct_referral_situation(present(true), present(true), present(unsure), dominant_influence_unsure) :-
    implements(eu_reg_2023_2831_art_2_2_c).

joined_neighbour(Enterprise, Certainties, Relationships, Neighbour) :-
    implements(eu_reg_2023_2831_art_2_2),
    member(relationship(HolderEnterprise, HeldEnterprise, _, Certainty), Relationships),
    member(Certainty, Certainties),
    other_end(Enterprise, HolderEnterprise, HeldEnterprise, Neighbour).

other_end(Enterprise, Enterprise, HeldEnterprise, HeldEnterprise).
other_end(Enterprise, HolderEnterprise, Enterprise, HolderEnterprise).

group_closure([], Visited, _, _, Group) :-
    sort(Visited, Group).
group_closure([Enterprise|Frontier], Visited, Certainties, Relationships, Group) :-
    implements(eu_reg_2023_2831_art_2_t1),
    findall(Neighbour, joined_neighbour(Enterprise, Certainties, Relationships, Neighbour), Found),
    sort(Found, Neighbours),
    subtract(Neighbours, Visited, Fresh),
    append(Visited, Fresh, Widened),
    append(Frontier, Fresh, Extended),
    group_closure(Extended, Widened, Certainties, Relationships, Group).

enterprise_group(First, Relationships, Group) :-
    group_closure([First], [First], [true], Relationships, Group).

reachable_group(First, Relationships, Reachable) :-
    group_closure([First], [First], [true, unsure], Relationships, Reachable).

group_limb_citations(Group, Relationships, LimbCitations) :-
    findall(Citation, group_relationship_citation(Group, Relationships, Citation), Found),
    sort(Found, LimbCitations).

group_relationship_citation(Group, Relationships, Citation) :-
    implements(eu_reg_2023_2831_art_2_2),
    member(relationship(HolderEnterprise, HeldEnterprise, LimbAtom, true), Relationships),
    memberd_t(HolderEnterprise, Group, true),
    memberd_t(HeldEnterprise, Group, true),
    limb_citation(LimbAtom, Citation).

true_join_t([], _, _, false).
true_join_t([relationship(HolderEnterprise, HeldEnterprise, _, Certainty)|Relationships], First, Other, Truth) :-
    same_atom_t(HolderEnterprise, First, HolderIsFirst),
    same_atom_t(HeldEnterprise, Other, HeldIsOther),
    both_true(HolderIsFirst, HeldIsOther, Forward),
    same_atom_t(HolderEnterprise, Other, HolderIsOther),
    same_atom_t(HeldEnterprise, First, HeldIsFirst),
    both_true(HolderIsOther, HeldIsFirst, Backward),
    either_true(Forward, Backward, Joins),
    same_atom_t(Certainty, true, Certain),
    both_true(Joins, Certain, HereTruth),
    true_join_t(Relationships, First, Other, LaterTruth),
    either_true(HereTruth, LaterTruth, Truth).

indirect_member_t([], _, _, false).
indirect_member_t([Member|Members], First, Relationships, Truth) :-
    same_atom_t(Member, First, IsFirst),
    member_indirect_t(IsFirst, Member, First, Relationships, HereTruth),
    indirect_member_t(Members, First, Relationships, LaterTruth),
    either_true(HereTruth, LaterTruth, Truth).

member_indirect_t(true, _, _, _, false).
member_indirect_t(false, Member, First, Relationships, Indirect) :-
    true_join_t(Relationships, First, Member, Joined),
    truth_negated(Joined, Indirect).

closing_sentence_citations(true, [cite(eu_reg_2023_2831_art_2_t1)]) :-
    implements(eu_reg_2023_2831_art_2_t1).
closing_sentence_citations(false, []).

completeness(absent, incomplete).
completeness(present(false), incomplete).
completeness(present(true), complete).

same_single_undertaking(Profile, Result, Citations) :-
    single_undertaking_input_problems(Profile, Problems),
    same_checked(Problems, Profile, Result, Citations).

same_checked([Problem|OtherProblems], _, input_problems([Problem|OtherProblems]), []).
same_checked([], Profile, Result, Citations) :-
    key_reading(Profile, first_enterprise, FirstStatus),
    key_reading(Profile, second_enterprise, SecondStatus),
    same_named(FirstStatus, SecondStatus, Profile, Result, Citations).

same_named(absent, _, _, indeterminate([first_enterprise]), []).
same_named(present(_), absent, _, indeterminate([second_enterprise]), []).
same_named(present(First), present(Second), Profile, Result, Citations) :-
    same_atom_t(First, Second, SameEnterprise),
    same_identity(SameEnterprise, First, Second, Profile, Result, Citations).

same_identity(true, _, _, _, single_undertaking, [cite(eu_reg_2023_2831_art_2_2)]) :-
    implements(eu_reg_2023_2831_art_2_2).
same_identity(false, First, Second, Profile, Result, Citations) :-
    key_reading(Profile, relationships, RelationshipsStatus),
    same_listed(RelationshipsStatus, First, Second, Profile, Result, Citations).

same_listed(absent, _, _, _, indeterminate([relationships]), []).
same_listed(present(Relationships), First, Second, Profile, Result, Citations) :-
    enterprise_group(First, Relationships, Group),
    memberd_t(Second, Group, InGroup),
    same_grouped(InGroup, First, Second, Group, Relationships, Profile, Result, Citations).

same_grouped(true, First, Second, Group, Relationships, _, single_undertaking, [cite(eu_reg_2023_2831_art_2_2)|Citations]) :-
    implements(eu_reg_2023_2831_art_2_2),
    group_limb_citations(Group, Relationships, LimbCitations),
    true_join_t(Relationships, First, Second, DirectlyJoined),
    truth_negated(DirectlyJoined, ThroughOthers),
    closing_sentence_citations(ThroughOthers, ClosingCitations),
    append(LimbCitations, ClosingCitations, Citations).
same_grouped(false, First, Second, _, Relationships, Profile, Result, Citations) :-
    key_reading(Profile, relationships_complete, CompleteStatus),
    completeness(CompleteStatus, Completeness),
    same_completed(Completeness, First, Second, Relationships, Profile, Result, Citations).

same_completed(incomplete, _, _, _, _, indeterminate([relationships_complete]), []).
same_completed(complete, First, Second, Relationships, Profile, Result, Citations) :-
    reachable_group(First, Relationships, Reachable),
    memberd_t(Second, Reachable, Reached),
    same_reached(Reached, Profile, Result, Citations).

same_reached(true, Profile, Result, []) :-
    implements(eu_reg_2023_2831_art_2_2),
    referral_result(joined_only_through_unsure_relationship, Profile, Result).
same_reached(false, _, not_single_undertaking, [cite(eu_reg_2023_2831_art_2_2)]) :-
    implements(eu_reg_2023_2831_art_2_2).

single_undertaking_members(Profile, Result, Members, Citations) :-
    single_undertaking_input_problems(Profile, Problems),
    members_checked(Problems, Profile, Result, Members, Citations).

members_checked([Problem|OtherProblems], _, input_problems([Problem|OtherProblems]), [], []).
members_checked([], Profile, Result, Members, Citations) :-
    key_reading(Profile, first_enterprise, FirstStatus),
    members_named(FirstStatus, Profile, Result, Members, Citations).

members_named(absent, _, indeterminate([first_enterprise]), [], []).
members_named(present(First), Profile, Result, Members, Citations) :-
    key_reading(Profile, relationships, RelationshipsStatus),
    members_listed(RelationshipsStatus, First, Profile, Result, Members, Citations).

members_listed(absent, _, _, indeterminate([relationships]), [], []).
members_listed(present(Relationships), First, Profile, Result, Members, Citations) :-
    key_reading(Profile, relationships_complete, CompleteStatus),
    completeness(CompleteStatus, Completeness),
    members_completed(Completeness, First, Relationships, Profile, Result, Members, Citations).

members_completed(incomplete, _, _, _, indeterminate([relationships_complete]), [], []).
members_completed(complete, First, Relationships, Profile, Result, Members, Citations) :-
    enterprise_group(First, Relationships, Group),
    reachable_group(First, Relationships, Reachable),
    subtract(Reachable, Group, Outside),
    members_bounded(Outside, First, Group, Relationships, Profile, Result, Members, Citations).

members_bounded([_|_], _, _, _, Profile, Result, [], []) :-
    implements(eu_reg_2023_2831_art_2_2),
    referral_result(member_only_through_unsure_relationship, Profile, Result).
members_bounded([], First, Group, Relationships, _, members_settled, Group, [cite(eu_reg_2023_2831_art_2_2)|Citations]) :-
    implements(eu_reg_2023_2831_art_2_2),
    group_limb_citations(Group, Relationships, LimbCitations),
    indirect_member_t(Group, First, Relationships, ThroughOthers),
    closing_sentence_citations(ThroughOthers, ClosingCitations),
    append(LimbCitations, ClosingCitations, Citations).

decide_single_undertaking(Profile, single_undertaking_verdict(Status, Citations)) :-
    same_single_undertaking(Profile, Status, Citations).

single_undertaking_status(Profile, Status) :-
    decide_single_undertaking(Profile, single_undertaking_verdict(Status, _Citations)).

single_undertaking_checklist(Profile, Items) :-
    single_undertaking_input_problems(Profile, Problems),
    checklist_checked(Problems, Profile, Items).

checklist_checked([Problem|OtherProblems], _, [item(input_check, input_problems([Problem|OtherProblems]), cite(eu_reg_2023_2831_art_2_2))]).
checklist_checked([], Profile, Items) :-
    point_states(Profile, PointStates),
    point_items(PointStates, PointItems),
    same_single_undertaking(Profile, Status, _Citations),
    append(PointItems, [item(single_undertaking, Status, cite(eu_reg_2023_2831_art_2_2))], Items).

point_items([], []).
point_items([Point - State|PointStates], [item(Point, ItemStatus, Citation)|Items]) :-
    limb_citation(Point, Citation),
    state_item_status(State, ItemStatus),
    point_items(PointStates, Items).

state_item_status(holds, met).
state_item_status(fails, unmet(point_ruled_out)).
state_item_status(open(AbsentKeys), unknown(AbsentKeys)).

single_undertaking_decision_resolvable(Profile) :-
    decide_single_undertaking(Profile, _Verdict).

test(a_majority_of_votes_is_a_direct_relationship) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 51), attribute(voting_rights_total, 100)], Result, Citations),
    Result == directly_related,
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)].
test(every_holding_point_is_cited) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true), attribute(dominant_influence_by_contract_or_articles, true)], Result, Citations),
    Result == directly_related,
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_b), cite(eu_reg_2023_2831_art_2_2_c)].
test(exactly_half_with_every_point_ruled_out_is_not_related) :-
    direct_relationship([attribute(voting_rights_held, 50), attribute(voting_rights_total, 100), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(a_holder_that_is_not_an_enterprise_decides_first) :-
    direct_relationship([attribute(holder_is_an_enterprise, false), attribute(right_to_appoint_or_remove_majority_of_board, true)], Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(an_empty_profile_asks_for_the_holder) :-
    direct_relationship([], Result, Citations),
    Result == indeterminate([holder_is_an_enterprise]),
    Citations == [].
test(a_missing_held_judgement_is_named) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)], Result, _),
    Result == indeterminate([held_is_an_enterprise]).
test(the_point_with_fewest_absent_keys_is_asked) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true)], Result, _),
    Result == indeterminate([right_to_appoint_or_remove_majority_of_board]).
test(an_unsure_dominant_influence_goes_to_a_lawyer) :-
    direct_relationship([attribute(holder_is_an_enterprise, true), attribute(held_is_an_enterprise, true), attribute(voting_rights_held, 0), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(holder_is_shareholder_or_member, false)], Result, Citations),
    Result == needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([holder_is_an_enterprise - true, held_is_an_enterprise - true, dominant_influence_by_contract_or_articles - unsure])]),
    Citations == [].
test(an_unsure_holder_with_a_holding_point_goes_to_a_lawyer) :-
    direct_relationship([attribute(holder_is_an_enterprise, unsure), attribute(held_is_an_enterprise, true), attribute(right_to_appoint_or_remove_majority_of_board, true)], Result, _),
    Result == needs_legal_review(open_textured(holder_is_an_enterprise, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([holder_is_an_enterprise - unsure, held_is_an_enterprise - true])]).
test(an_unknown_key_is_an_input_problem) :-
    direct_relationship([attribute(colour, red)], Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(direct_relationship_has_one_answer) :-
    findall(Result - Citations, direct_relationship([attribute(holder_is_an_enterprise, false), attribute(voting_rights_held, 0)], Result, Citations), Answers),
    length(Answers, 1).
test(sister_enterprises_are_one_single_undertaking) :-
    same_single_undertaking([attribute(first_enterprise, beta), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, true)])], Result, Citations),
    Result == single_undertaking,
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a), cite(eu_reg_2023_2831_art_2_2_b), cite(eu_reg_2023_2831_art_2_t1)].
test(a_direct_join_does_not_cite_the_closing_sentence) :-
    same_single_undertaking([attribute(first_enterprise, beta), attribute(second_enterprise, alpha), attribute(relationships, [relationship(alpha, beta, point_d, true)])], Result, Citations),
    Result == single_undertaking,
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_d)].
test(the_same_enterprise_is_its_own_single_undertaking) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, alpha)], Result, Citations),
    Result == single_undertaking,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(a_missing_second_name_is_asked) :-
    same_single_undertaking([attribute(first_enterprise, alpha)], Result, _),
    Result == indeterminate([second_enterprise]).
test(an_incomplete_list_asks_for_completeness) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, false)], Result, Citations),
    Result == indeterminate([relationships_complete]),
    Citations == [].
test(a_join_only_through_an_unsure_relationship_goes_to_a_lawyer) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(gamma, beta, point_c, unsure)]), attribute(relationships_complete, true)], Result, _),
    Result == needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([relationships - [relationship(alpha, beta, point_a, true), relationship(gamma, beta, point_c, unsure)]])]).
test(unjoined_enterprises_on_a_complete_list_are_separate) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, true)], Result, Citations),
    Result == not_single_undertaking,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(the_members_are_the_group) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true), relationship(beta, gamma, point_d, true), relationship(delta, epsilon, point_c, true)]), attribute(relationships_complete, true)], Result, Members, Citations),
    Result == members_settled,
    Members == [alpha, beta, gamma],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a), cite(eu_reg_2023_2831_art_2_2_d), cite(eu_reg_2023_2831_art_2_t1)].
test(an_unsure_relationship_that_could_add_a_member_goes_to_a_lawyer) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, unsure)]), attribute(relationships_complete, true)], Result, Members, Citations),
    Result == needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([relationships - [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, unsure)]])]),
    Members == [],
    Citations == [].
test(members_need_a_complete_list) :-
    single_undertaking_members([attribute(first_enterprise, gamma), attribute(relationships, [])], Result, Members, _),
    Result == indeterminate([relationships_complete]),
    Members == [].
test(members_has_one_answer) :-
    findall(Result - Members, single_undertaking_members([attribute(first_enterprise, alpha), attribute(relationships, [relationship(alpha, alpha, point_a, true)]), attribute(relationships_complete, true)], Result, Members, _), Answers),
    Answers == [members_settled - [alpha]].
test(the_checklist_carries_a_citation_per_point) :-
    single_undertaking_checklist([attribute(right_to_appoint_or_remove_majority_of_board, true)], Items),
    member(item(point_b, met, cite(eu_reg_2023_2831_art_2_2_b)), Items).
test(the_status_projects_the_verdict) :-
    single_undertaking_status([attribute(first_enterprise, alpha), attribute(second_enterprise, alpha)], Status),
    Status == single_undertaking.
test(the_provenance_constructor_gives_one_ground_answer) :-
    findall(Citations, provenance(direct_relationship, Citations), Answers),
    Answers == [[cite(eu_reg_2023_2831_art_2_2)]].
test(the_provenance_constructor_accepts_a_given_list) :-
    findall(found, provenance(same_single_undertaking, [cite(eu_reg_2023_2831_art_2_t1)]), Answers),
    Answers == [found].
test(the_indeterminate_constructor_accepts_one_key) :-
    findall(found, indeterminate([relationships_complete]), Answers),
    Answers == [found].
test(the_referral_constructor_accepts_a_referral) :-
    findall(found, needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])]), Answers),
    Answers == [found].
test(the_input_problems_constructor_accepts_a_problem_list) :-
    findall(found, input_problems([unknown_key(colour)]), Answers),
    Answers == [found].
test(the_unknown_key_constructor_accepts_a_key_as_given) :-
    findall(found, unknown_key(7), Answers),
    Answers == [found].
test(the_wrong_type_constructor_accepts_a_key) :-
    findall(found, wrong_type(voting_rights_total), Answers),
    Answers == [found].
test(the_duplicate_key_constructor_accepts_a_key) :-
    findall(found, duplicate_key(first_enterprise), Answers),
    Answers == [found].
test(the_relationship_constructor_accepts_a_relationship) :-
    findall(found, relationship(alpha, beta, point_a, true), Answers),
    Answers == [found].

test(exactly_half_is_not_directly_related, fail) :-
    direct_relationship([attribute(voting_rights_held, 50), attribute(voting_rights_total, 100), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holder_is_shareholder_or_member, false)], directly_related, _).
test(unjoined_enterprises_are_not_one_single_undertaking, fail) :-
    same_single_undertaking([attribute(first_enterprise, alpha), attribute(second_enterprise, gamma), attribute(relationships, [relationship(alpha, beta, point_a, true)]), attribute(relationships_complete, true)], single_undertaking, _).
test(the_indeterminate_constructor_rejects_two_keys, fail) :-
    indeterminate([first_enterprise, second_enterprise]).
test(the_referral_constructor_rejects_a_missing_context, fail) :-
    needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), []).
test(the_input_problems_constructor_rejects_an_empty_list, fail) :-
    input_problems([]).
test(the_relationship_constructor_rejects_an_unknown_limb, fail) :-
    relationship(alpha, beta, point_e, true).
