% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [decide_single_undertaking/2, single_undertaking_status/2, single_undertaking_checklist/2, single_undertaking_decision_resolvable/1, single_undertaking_status_values/1, provenance/2, indeterminate/1, needs_legal_review/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, relationship/4]).
:- use_module(m__eu_state_aid_single_undertaking_fixtures, [single_undertaking_subject/1, single_undertaking_profile_for/2, single_undertaking_assess/2]).
:- use_module(m__eu_state_aid_single_undertaking_single_undertaking, [direct_relationship/3, same_single_undertaking/3, single_undertaking_members/4]).
:- use_module(m__eu_state_aid_single_undertaking_queries, [single_undertaking_what_if/4, single_undertaking_profile_keys/1]).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).

direct_answer(Subject, Result, Citations) :-
    single_undertaking_profile_for(Subject, Profile),
    direct_relationship(Profile, Result, Citations).

same_answer(Subject, Result, Citations) :-
    single_undertaking_profile_for(Subject, Profile),
    same_single_undertaking(Profile, Result, Citations).

members_answer(Subject, Result, Members, Citations) :-
    single_undertaking_profile_for(Subject, Profile),
    single_undertaking_members(Profile, Result, Members, Citations).

problems_of(Subject, Problems) :-
    single_undertaking_profile_for(Subject, Profile),
    single_undertaking_input_problems(Profile, Problems).

same_citations(Citations, Expected) :-
    sort(Citations, Sorted),
    sort(Expected, SortedExpected),
    Sorted == SortedExpected.

all_subjects(Subjects) :-
    findall(Subject, single_undertaking_subject(Subject), Subjects).

one_direct_answer(Subject) :-
    findall(Result - Citations, direct_answer(Subject, Result, Citations), Answers),
    length(Answers, 1).

one_same_answer(Subject) :-
    findall(Result - Citations, same_answer(Subject, Result, Citations), Answers),
    length(Answers, 1).

one_members_answer(Subject) :-
    findall(Result - Members - Citations, members_answer(Subject, Result, Members, Citations), Answers),
    length(Answers, 1).

one_verdict(Subject) :-
    findall(Verdict, single_undertaking_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

has_checklist(Subject) :-
    single_undertaking_profile_for(Subject, Profile),
    single_undertaking_checklist(Profile, [_FirstItem|_OtherItems]).

resolvable(Subject) :-
    single_undertaking_profile_for(Subject, Profile),
    single_undertaking_decision_resolvable(Profile).

cited_item(item(_Identifier, _Status, cite(_CitationKey))).

test(fifty_one_of_one_hundred_is_directly_related) :-
    direct_answer(majority_fifty_one_of_one_hundred, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)]).
test(fifty_of_ninety_nine_is_directly_related) :-
    direct_answer(just_over_half_fifty_of_ninety_nine, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)]).
test(exactly_half_is_not_directly_related) :-
    direct_answer(exactly_half_fifty_of_one_hundred, Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(one_of_one_is_directly_related) :-
    direct_answer(one_of_one_voting_right, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a)]).
test(no_voting_rights_held_is_not_directly_related) :-
    direct_answer(no_voting_rights_held, Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(a_board_right_is_directly_related) :-
    direct_answer(board_right_held, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_b)]).
test(a_denied_board_right_is_not_directly_related) :-
    direct_answer(board_right_denied, Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(a_holder_that_is_not_an_enterprise_is_not_directly_related) :-
    direct_answer(holder_not_an_enterprise, Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(an_unsure_holder_goes_to_a_lawyer) :-
    direct_answer(holder_enterprise_status_unsure, Result, Citations),
    Result == needs_legal_review(open_textured(holder_is_an_enterprise, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([holder_is_an_enterprise - unsure, held_is_an_enterprise - true])]),
    Citations == [].
test(a_missing_held_judgement_is_asked) :-
    direct_answer(held_enterprise_judgement_missing, Result, Citations),
    Result == indeterminate([held_is_an_enterprise]),
    Citations == [].
test(an_affirmed_dominant_influence_is_directly_related) :-
    direct_answer(dominant_influence_affirmed, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_c)]).
test(an_unsure_dominant_influence_goes_to_a_lawyer) :-
    direct_answer(dominant_influence_unsure, Result, Citations),
    Result == needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([holder_is_an_enterprise - true, held_is_an_enterprise - true, dominant_influence_by_contract_or_articles - unsure])]),
    Citations == [].
test(sole_control_by_agreement_is_directly_related) :-
    direct_answer(sole_control_by_agreement, Result, Citations),
    Result == directly_related,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_d)]).
test(a_shareholder_without_agreement_is_not_directly_related) :-
    direct_answer(shareholder_without_agreement, Result, Citations),
    Result == not_directly_related,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(sisters_through_a_common_holder_are_one_single_undertaking) :-
    single_undertaking_assess(sisters_through_common_holder, single_undertaking_verdict(Status, Citations)),
    Status == single_undertaking,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a), cite(eu_reg_2023_2831_art_2_2_b), cite(eu_reg_2023_2831_art_2_t1)]).
test(sisters_through_an_unsure_link_go_to_a_lawyer) :-
    single_undertaking_assess(sisters_through_unsure_link, single_undertaking_verdict(Status, Citations)),
    Status == needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([relationships - [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_b, unsure)]])]),
    Citations == [].
test(sisters_without_a_link_are_not_one_single_undertaking) :-
    single_undertaking_assess(sisters_without_link, single_undertaking_verdict(Status, Citations)),
    Status == not_single_undertaking,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(two_holders_of_one_enterprise_are_one_single_undertaking) :-
    single_undertaking_assess(two_holders_of_one_enterprise, single_undertaking_verdict(Status, Citations)),
    Status == single_undertaking,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a), cite(eu_reg_2023_2831_art_2_2_d), cite(eu_reg_2023_2831_art_2_t1)]).
test(a_direct_join_does_not_cite_the_closing_sentence) :-
    single_undertaking_assess(parent_and_subsidiary_direct, single_undertaking_verdict(Status, Citations)),
    Status == single_undertaking,
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_d)]).
test(the_same_enterprise_is_its_own_single_undertaking) :-
    single_undertaking_assess(same_enterprise_twice, single_undertaking_verdict(Status, Citations)),
    Status == single_undertaking,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(an_incomplete_list_asks_for_completeness) :-
    single_undertaking_assess(relationship_list_incomplete, single_undertaking_verdict(Status, Citations)),
    Status == indeterminate([relationships_complete]),
    Citations == [].
test(a_missing_list_is_asked) :-
    single_undertaking_assess(relationship_list_missing, single_undertaking_verdict(Status, Citations)),
    Status == indeterminate([relationships]),
    Citations == [].
test(the_status_projects_the_facade_verdict) :-
    single_undertaking_profile_for(two_holders_of_one_enterprise, Profile),
    single_undertaking_status(Profile, Status),
    Status == single_undertaking.
test(the_facade_agrees_with_the_query) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    decide_single_undertaking(Profile, single_undertaking_verdict(Status, Citations)),
    same_answer(sisters_without_link, Result, QueryCitations),
    Status == Result,
    Citations == QueryCitations.
test(settled_statuses_are_in_the_status_vocabulary) :-
    single_undertaking_status_values(StatusValues),
    single_undertaking_assess(sisters_through_common_holder, single_undertaking_verdict(Joined, _)),
    single_undertaking_assess(sisters_without_link, single_undertaking_verdict(Separate, _)),
    member(Joined, StatusValues),
    member(Separate, StatusValues).
test(completing_the_list_settles_the_incomplete_subject) :-
    single_undertaking_profile_for(relationship_list_incomplete, Profile),
    single_undertaking_what_if(Profile, relationships_complete, true, NewStatus),
    NewStatus == not_single_undertaking.
test(adding_a_link_joins_the_sisters) :-
    single_undertaking_profile_for(sisters_without_link, Profile),
    single_undertaking_what_if(Profile, relationships, [relationship(alpha, beta, point_a, true), relationship(alpha, gamma, point_c, true)], NewStatus),
    NewStatus == single_undertaking.
test(the_schema_names_the_twelve_keys) :-
    single_undertaking_profile_keys(ProfileKeys),
    length(ProfileKeys, 12).
test(the_members_through_a_chain_are_the_group) :-
    members_answer(members_through_chain, Result, Members, Citations),
    Result == members_settled,
    Members == [alpha, beta, gamma],
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_a), cite(eu_reg_2023_2831_art_2_2_d), cite(eu_reg_2023_2831_art_2_t1)]).
test(direct_members_do_not_cite_the_closing_sentence) :-
    members_answer(members_direct_only, Result, Members, Citations),
    Result == members_settled,
    Members == [alpha, beta],
    same_citations(Citations, [cite(eu_reg_2023_2831_art_2_2), cite(eu_reg_2023_2831_art_2_2_b)]).
test(an_unsure_link_that_could_add_a_member_goes_to_a_lawyer) :-
    members_answer(members_through_unsure_link, Result, Members, Citations),
    Result == needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), [inputs_relied_on([relationships - [relationship(beta, gamma, point_d, true), relationship(gamma, zeta, point_c, unsure)]])]),
    Members == [],
    Citations == [].
test(members_need_a_complete_list) :-
    members_answer(members_list_incomplete, Result, Members, Citations),
    Result == indeterminate([relationships_complete]),
    Members == [],
    Citations == [].
test(an_unknown_key_is_an_input_problem) :-
    problems_of(unknown_key_given, Problems),
    Problems == [unknown_key(colour)],
    same_answer(unknown_key_given, Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(a_duplicate_key_is_an_input_problem) :-
    problems_of(duplicate_key_given, Problems),
    Problems == [duplicate_key(first_enterprise)],
    members_answer(duplicate_key_given, Result, Members, Citations),
    Result == input_problems([duplicate_key(first_enterprise)]),
    Members == [],
    Citations == [].
test(a_total_of_zero_is_an_input_problem) :-
    problems_of(zero_total_voting_rights, Problems),
    Problems == [wrong_type(voting_rights_total)],
    direct_answer(zero_total_voting_rights, Result, Citations),
    Result == input_problems([wrong_type(voting_rights_total)]),
    Citations == [].
test(held_above_total_is_an_input_problem) :-
    problems_of(held_above_total_voting_rights, Problems),
    Problems == [wrong_type(voting_rights_held)].
test(held_equal_to_total_is_well_formed) :-
    problems_of(held_equal_to_total_voting_rights, Problems),
    Problems == [].
test(held_equal_to_total_asks_for_the_first_enterprise) :-
    single_undertaking_assess(held_equal_to_total_voting_rights, single_undertaking_verdict(Status, Citations)),
    Status == indeterminate([first_enterprise]),
    Citations == [].
test(an_unbound_profile_is_not_an_attribute_list) :-
    problems_of(unbound_profile, Problems),
    Problems == [wrong_type(profile)],
    single_undertaking_assess(unbound_profile, single_undertaking_verdict(Status, Citations)),
    Status == input_problems([wrong_type(profile)]),
    Citations == [].
test(a_number_as_a_key_is_an_unknown_key) :-
    problems_of(number_as_key, Problems),
    Problems == [unknown_key(7)].
test(the_provenance_constructor_is_callable) :-
    provenance(direct_relationship, [cite(eu_reg_2023_2831_art_2_2_c)]).
test(a_provenance_item_may_follow_the_pairs_of_a_referral) :-
    direct_answer(dominant_influence_unsure, needs_legal_review(Reason, [inputs_relied_on(Pairs)]), _),
    Extended = needs_legal_review(Reason, [inputs_relied_on(Pairs), provenance(direct_relationship, [cite(eu_reg_2023_2831_art_2_2_c)])]),
    Extended = needs_legal_review(_, [_, provenance(Clause, ProvenanceCitations)]),
    provenance(Clause, ProvenanceCitations),
    Clause == direct_relationship,
    ProvenanceCitations == [cite(eu_reg_2023_2831_art_2_2_c)].
test(the_indeterminate_constructor_holds_for_one_key) :-
    indeterminate([relationships_complete]).
test(the_referral_constructor_holds_for_a_referral) :-
    needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])]).
test(the_input_problems_constructor_holds_for_a_problem_list) :-
    input_problems([unknown_key(colour)]).
test(the_unknown_key_constructor_holds_for_a_key_as_given) :-
    unknown_key(colour).
test(the_wrong_type_constructor_holds_for_a_contract_key) :-
    wrong_type(voting_rights_total).
test(the_duplicate_key_constructor_holds_for_a_contract_key) :-
    duplicate_key(first_enterprise).
test(the_relationship_constructor_holds_for_a_relationship) :-
    relationship(alpha, beta, point_a, true).
test(the_checklist_cites_every_item) :-
    single_undertaking_profile_for(majority_fifty_one_of_one_hundred, Profile),
    single_undertaking_checklist(Profile, Items),
    maplist(cited_item, Items),
    member(item(point_a, met, cite(eu_reg_2023_2831_art_2_2_a)), Items).
test(the_checklist_marks_a_ruled_out_point_unmet) :-
    single_undertaking_profile_for(exactly_half_fifty_of_one_hundred, Profile),
    single_undertaking_checklist(Profile, Items),
    member(item(point_a, unmet(point_ruled_out), cite(eu_reg_2023_2831_art_2_2_a)), Items).
test(the_checklist_is_never_empty) :-
    all_subjects(Subjects),
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(resolvable, Subjects).
test(every_subject_has_one_verdict) :-
    all_subjects(Subjects),
    maplist(one_verdict, Subjects).
test(every_subject_has_one_direct_answer) :-
    all_subjects(Subjects),
    maplist(one_direct_answer, Subjects).
test(every_subject_has_one_same_answer) :-
    all_subjects(Subjects),
    maplist(one_same_answer, Subjects).
test(every_subject_has_one_members_answer) :-
    all_subjects(Subjects),
    maplist(one_members_answer, Subjects).

test(exactly_half_is_never_directly_related, fail) :-
    direct_answer(exactly_half_fifty_of_one_hundred, directly_related, _).
test(no_voting_rights_held_is_never_directly_related, fail) :-
    direct_answer(no_voting_rights_held, directly_related, _).
test(a_denied_board_right_is_never_directly_related, fail) :-
    direct_answer(board_right_denied, directly_related, _).
test(a_holder_that_is_not_an_enterprise_is_never_directly_related, fail) :-
    direct_answer(holder_not_an_enterprise, directly_related, _).
test(an_unsure_dominant_influence_is_never_directly_related, fail) :-
    direct_answer(dominant_influence_unsure, directly_related, _).
test(a_shareholder_without_agreement_is_never_directly_related, fail) :-
    direct_answer(shareholder_without_agreement, directly_related, _).
test(sisters_through_an_unsure_link_are_never_settled_as_one, fail) :-
    single_undertaking_assess(sisters_through_unsure_link, single_undertaking_verdict(single_undertaking, _)).
test(sisters_without_a_link_are_never_one_single_undertaking, fail) :-
    single_undertaking_assess(sisters_without_link, single_undertaking_verdict(single_undertaking, _)).
test(an_incomplete_list_is_never_settled_as_separate, fail) :-
    single_undertaking_assess(relationship_list_incomplete, single_undertaking_verdict(not_single_undertaking, _)).
test(an_unsure_link_never_settles_the_members, fail) :-
    members_answer(members_through_unsure_link, members_settled, _, _).
test(members_without_a_complete_list_are_never_settled, fail) :-
    members_answer(members_list_incomplete, members_settled, _, _).
test(held_equal_to_total_is_not_an_input_problem, fail) :-
    single_undertaking_assess(held_equal_to_total_voting_rights, single_undertaking_verdict(input_problems(_), _)).
test(the_indeterminate_constructor_rejects_two_keys, fail) :-
    indeterminate([first_enterprise, second_enterprise]).
test(the_referral_constructor_rejects_an_empty_context, fail) :-
    needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), []).
test(the_input_problems_constructor_rejects_an_empty_list, fail) :-
    input_problems([]).
test(the_relationship_constructor_rejects_an_unknown_limb, fail) :-
    relationship(alpha, beta, point_e, true).

cp_test_names([fifty_one_of_one_hundred_is_directly_related, fifty_of_ninety_nine_is_directly_related, exactly_half_is_not_directly_related, one_of_one_is_directly_related, no_voting_rights_held_is_not_directly_related, a_board_right_is_directly_related, a_denied_board_right_is_not_directly_related, a_holder_that_is_not_an_enterprise_is_not_directly_related, an_unsure_holder_goes_to_a_lawyer, a_missing_held_judgement_is_asked, an_affirmed_dominant_influence_is_directly_related, an_unsure_dominant_influence_goes_to_a_lawyer, sole_control_by_agreement_is_directly_related, a_shareholder_without_agreement_is_not_directly_related, sisters_through_a_common_holder_are_one_single_undertaking, sisters_through_an_unsure_link_go_to_a_lawyer, sisters_without_a_link_are_not_one_single_undertaking, two_holders_of_one_enterprise_are_one_single_undertaking, a_direct_join_does_not_cite_the_closing_sentence, the_same_enterprise_is_its_own_single_undertaking, an_incomplete_list_asks_for_completeness, a_missing_list_is_asked, the_status_projects_the_facade_verdict, the_facade_agrees_with_the_query, settled_statuses_are_in_the_status_vocabulary, completing_the_list_settles_the_incomplete_subject, adding_a_link_joins_the_sisters, the_schema_names_the_twelve_keys, the_members_through_a_chain_are_the_group, direct_members_do_not_cite_the_closing_sentence, an_unsure_link_that_could_add_a_member_goes_to_a_lawyer, members_need_a_complete_list, an_unknown_key_is_an_input_problem, a_duplicate_key_is_an_input_problem, a_total_of_zero_is_an_input_problem, held_above_total_is_an_input_problem, held_equal_to_total_is_well_formed, held_equal_to_total_asks_for_the_first_enterprise, an_unbound_profile_is_not_an_attribute_list, a_number_as_a_key_is_an_unknown_key, the_provenance_constructor_is_callable, a_provenance_item_may_follow_the_pairs_of_a_referral, the_indeterminate_constructor_holds_for_one_key, the_referral_constructor_holds_for_a_referral, the_input_problems_constructor_holds_for_a_problem_list, the_unknown_key_constructor_holds_for_a_key_as_given, the_wrong_type_constructor_holds_for_a_contract_key, the_duplicate_key_constructor_holds_for_a_contract_key, the_relationship_constructor_holds_for_a_relationship, the_checklist_cites_every_item, the_checklist_marks_a_ruled_out_point_unmet, the_checklist_is_never_empty, every_subject_is_resolvable, every_subject_has_one_verdict, every_subject_has_one_direct_answer, every_subject_has_one_same_answer, every_subject_has_one_members_answer]).
cp_test_fail_names([exactly_half_is_never_directly_related, no_voting_rights_held_is_never_directly_related, a_denied_board_right_is_never_directly_related, a_holder_that_is_not_an_enterprise_is_never_directly_related, an_unsure_dominant_influence_is_never_directly_related, a_shareholder_without_agreement_is_never_directly_related, sisters_through_an_unsure_link_are_never_settled_as_one, sisters_without_a_link_are_never_one_single_undertaking, an_incomplete_list_is_never_settled_as_separate, an_unsure_link_never_settles_the_members, members_without_a_complete_list_are_never_settled, held_equal_to_total_is_not_an_input_problem, the_indeterminate_constructor_rejects_two_keys, the_referral_constructor_rejects_an_empty_context, the_input_problems_constructor_rejects_an_empty_list, the_relationship_constructor_rejects_an_unknown_limb]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
