% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile).

subject_count(Count) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    length(Subjects, Count).

lawful_count(Count) :-
    subject_profile(_, Profile),
    findall(Result, lawful_basis_status(Profile, Result, _, _), Results),
    length(Results, Count).

compatibility_count(Count) :-
    subject_profile(_, Profile),
    findall(Result, purpose_compatibility(Profile, Result, _, _), Results),
    length(Results, Count).

input_check_count(Count) :-
    subject_profile(_, Profile),
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), Answers),
    length(Answers, Count).

verdict_count(Count) :-
    subject_profile(_, Profile),
    findall(Verdict, decide_gdpr_art6_lawful_basis(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

not_final_result(indeterminate(_)).
not_final_result(needs_legal_review(_, _)).
not_final_result(input_problems(_)).

final_result(eligible).
final_result(ineligible).

test(lawful_basis_status_answers_once_for_every_subject) :-
    subject_count(SubjectCount),
    findall(Count, lawful_count(Count), Counts),
    length(Counts, SubjectCount),
    sort(Counts, [1]).
test(purpose_compatibility_answers_once_for_every_subject) :-
    subject_count(SubjectCount),
    findall(Count, compatibility_count(Count), Counts),
    length(Counts, SubjectCount),
    sort(Counts, [1]).
test(input_check_answers_once_for_every_subject) :-
    subject_count(SubjectCount),
    findall(Count, input_check_count(Count), Counts),
    length(Counts, SubjectCount),
    sort(Counts, [1]).
test(decide_answers_once_for_every_subject) :-
    subject_count(SubjectCount),
    findall(Count, verdict_count(Count), Counts),
    length(Counts, SubjectCount),
    sort(Counts, [1]).
test(not_final_answers_have_empty_basis_and_citations) :-
    findall(Basis - Citations, (subject_profile(_, Profile), lawful_basis_status(Profile, Result, Basis, Citations), not_final_result(Result)), Pairs),
    sort(Pairs, [[] - []]).
test(not_final_compatibility_answers_have_empty_citations) :-
    findall(Basis - Citations, (subject_profile(_, Profile), purpose_compatibility(Profile, Result, Basis, Citations), not_final_result(Result)), Pairs),
    sort(Pairs, [[] - []]).
test(final_answers_cite_article_6_1) :-
    findall(Flag, (subject_profile(_, Profile), lawful_basis_status(Profile, Result, _, Citations), final_result(Result), memberd_t(cite(eu_reg_2016_679_art_6_1), Citations, Flag)), Flags),
    sort(Flags, [true]).
test(purpose_compatibility_basis_is_always_empty) :-
    findall(Basis, (subject_profile(_, Profile), purpose_compatibility(Profile, _, Basis, _)), Bases),
    sort(Bases, [[]]).
test(an_outside_fact_is_never_a_missing_key) :-
    findall(Flag, (subject_profile(_, Profile), lawful_basis_status(Profile, indeterminate([NamedKey]), _, _), memberd_t(NamedKey, [consent_given_and_conditions_met, legal_obligation_laid_down_by_law, public_interest_task_laid_down_by_law, child_data_subject, special_category], Flag)), Flags),
    sort(Flags, [false]).
test(the_status_projection_agrees_with_the_query) :-
    findall(Result - Status, (subject_profile(_, Profile), lawful_basis_status(Profile, Result, _, _), gdpr_art6_lawful_basis_status(Profile, Status)), Pairs),
    findall(Same, (member(Result - Status, Pairs), same_t(Result, Status, Same)), Flags),
    sort(Flags, [true]).
test(the_child_and_the_special_category_never_change_the_result) :-
    Statement = attested(true, attestation(host_system, recorded_moment, stated_by_host, none)),
    lawful_basis_status([attribute(basis_claimed, legitimate_interests)], WithoutFlags, _, _),
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(child_data_subject, Statement), attribute(special_category, Statement)], WithFlags, _, _),
    WithoutFlags == WithFlags.
test(an_absent_child_is_never_referred) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false)], eligible, [], _).

same_t(Left, Right, true) :-
    Left == Right.
same_t(Left, Right, false) :-
    Left \== Right.

cp_test_names([lawful_basis_status_answers_once_for_every_subject, purpose_compatibility_answers_once_for_every_subject, input_check_answers_once_for_every_subject, decide_answers_once_for_every_subject, not_final_answers_have_empty_basis_and_citations, not_final_compatibility_answers_have_empty_citations, final_answers_cite_article_6_1, purpose_compatibility_basis_is_always_empty, an_outside_fact_is_never_a_missing_key, the_status_projection_agrees_with_the_query, the_child_and_the_special_category_never_change_the_result, an_absent_child_is_never_referred]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
